Chef::Log.info("Running evrionment variables recipes")

deploy = params[:deploy_data]
application = params[:app]
environment = params[:env]

Chef::Log.info("deploy: #{deploy}")
Chef::Log.info("Applicaiton: #{application}")
Chef::Log.info("Environment: #{environment}")
