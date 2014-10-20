node[:deploy].each do |application, deploy|
  Chef::Log.info("Deploy for application #{application} as #{deploy[:application_type]} app")

  node.each do | key, value |
    Chef::Log.info( "#{key} = #{value}" )
  end

  environment_variables = deploy[:environment_variables]
  Chef::Log.info("deploy: #{deploy}")
  Chef::Log.info("Environment: #{environment_variables}")

end


