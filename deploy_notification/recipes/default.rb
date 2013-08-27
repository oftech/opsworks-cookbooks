# chef_gem 'hipchat'
# chef_gem 'mixlib-shellout'

# require 'rubygems'
# require 'hipchat'

node[:deploy].each do |application, deploy|

  Chef::Log.info("Getting commit info for app #{application}")
  stack_name = node[:opsworks][:stack][:name]
  current_dir = "#{deploy[:deploy_to]}/current"
  previous_deploy_dir =  Dir.entries("#{deploy[:deploy_to]}/releases").sort[-2]

	commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
		:cwd => current_dir
	})
	commit_sha_cmd.run_command
	commit_sha = commit_sha_cmd.stdout

	previous_commit_sha_cmd = Mixlib::ShellOut.new('git log -1 --format="%h"', {
		:cwd => previous_deploy_dir
	})
	previous_commit_sha_cmd.run_command
	previous_commit_sha = previous_commit_sha_cmd.stdout

	changes_cmd = Mixlib::ShellOut.new("git log #{commit_sha}...#{previous_commit_sha} --format=\"[%h] %an: %s\"", {
		:cwd => current_dir
	})
	changes_cmd.run_command
	changes = changes_cmd.stdout

	commit_branch_cmd = Mixlib::ShellOut.new('git rev-parse --abbrev-ref HEAD', {
		:cwd => current_dir
	})
	commit_branch_cmd.run_command
	commit_branch = commit_branch_cmd.stdout

	# Chef::Log.info("Sending commit info to hipchat for app #{application}")
	# message = "Commit #{commit_sha} from branch '#{commit_branch}' was deployed to #{stack_name}"
	# client = HipChat::Client.new('c9bd281c9f01e292cbbb8fe3199fa6')
	# client['PosBoss'].send('Deploy', message, :color => 'red')
	uri = URI.parse("http://api.random.com")
	http = Net::HTTP.new(uri.host, uri.port)

	Chef::Log.info("Writing build info file for app #{application}")
  file "#{current_dir}/public/buildinfo.txt" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    content "#{Time.now.to_s}\n#{commit_branch}\n#{commit_sha}\n#{changes}"
    action :create
  end
end
