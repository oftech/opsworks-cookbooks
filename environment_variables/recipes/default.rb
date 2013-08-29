Chef::Log.info("Running evrionment variables")

node[:deploy].each do |application, deploy|

  if node[:env]
    Chef::Log.info("Env variables set, generating environment_variables.rb")

    template "#{deploy[:deploy_to]}/current/config/environment_variables.rb" do
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
