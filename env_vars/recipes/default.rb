node[:deploy].each do |application, deploy|
  Chef::Log.info("Deploy for application #{application} as #{deploy[:application_type]} app")

  #Get ENV VARS from new opsworks stupid UI
  environment_variables = deploy[:environment_variables]

  Chef::Log.info("Environment: #{environment_variables}")

  execute "SET ENV VARS TO SHELL" do
    environment(environment_variables)
  end

end


