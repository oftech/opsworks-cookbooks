node[:deploy].each do |application, deploy|

  Chef::Log.info("Getting commit info for app #{application}")
  stack_name = node[:opsworks][:stack][:name]
  current_dir = "#{deploy[:deploy_to]}/current"
  previous_deploy_dir =  Dir.entries("#{deploy[:deploy_to]}/releases").sort[-2]
  Chef::Log.info("previous_deploy_dir: #{previous_deploy_dir}")

	commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
		:cwd => current_dir
	})
	commit_sha_cmd.run_command
	commit_sha = commit_sha_cmd.stdout.chomp

	previous_commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
		:cwd => previous_deploy_dir
	})
	previous_commit_sha_cmd.run_command
	previous_commit_sha = previous_commit_sha_cmd.stdout.chomp
	Chef::Log.info("previous_commit_sha: #{previous_commit_sha}")

	changes_cmd = Mixlib::ShellOut.new("git log #{commit_sha}...#{previous_commit_sha} --format=\"[%h] %an: %s\"", {
		:cwd => current_dir
	})
	changes_cmd.run_command
	changes = changes_cmd.stdout.chomp

	commit_branch_cmd = Mixlib::ShellOut.new('git rev-parse --abbrev-ref HEAD', {
		:cwd => current_dir
	})
	commit_branch_cmd.run_command
	commit_branch = commit_branch_cmd.stdout.chomp

	Chef::Log.info("Sending commit info to hipchat for app #{application}")
	message = "Commit #{commit_sha} from branch '#{commit_branch}' was deployed to #{stack_name}. Changes:\n#{changes}"

	uri = URI.parse('http://api.hipchat.com/v1/rooms/message')
	response = Net::HTTP.post_form(uri, {
		'auth_token' => 'c9bd281c9f01e292cbbb8fe3199fa6',
		'room_id' => 'Dogs Inc',
		'message' => message,
		'from' => 'Deploy',
		'message_format' => 'text'
	})

	Chef::Log.info("Writing build info file for app #{application}")
  file "#{current_dir}/public/buildinfo.txt" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    content "#{Time.now.to_s}\n#{commit_branch}\n#{commit_sha}\n#{changes}"
    action :create
  end
end
