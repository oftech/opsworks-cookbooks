service "tomcat6"

cookbook_file "/usr/share/solr/conf/schema.xml" do
  source 'schema.xml'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  notifies :restart, 'service[tomcat6]', :delayed
end
