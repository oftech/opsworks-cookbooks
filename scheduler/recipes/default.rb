node[:deploy].each do |application, deploy|

  Chef::Log.info("Set up corn job for #{application}...")

  execute "rake whenever to write to crontab" do
    cwd "#{File.join(deploy[:deploy_to], 'current')}"
    command "bundle exec whenever"
  end

  Chef::Log.info("Corntable has been updated")
end