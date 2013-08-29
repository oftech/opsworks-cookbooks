Chef::Log.info("Running evrionment variables")

node[:deploy].each do |application, deploy|

  if node[:env]

    env_file_path = "#{deploy[:deploy_to]}/shared/config/environment_variables.rb"
    Chef::Log.info("Env variables set, writing to #{env_file_path}")
    template env_file_path do
      cookbook "environment_variables"
      source "environment_variables.rb.erb"
      mode "0660"
      owner node[:deploy][application][:user]
      group node[:deploy][application][:group]
      variables(
        :env => node[:env]
      )
    end.run_action(:create)
    Chef::Log.info("Env variables written")
  else
    Chef::Log.info("Env variables not set")
  end

end
