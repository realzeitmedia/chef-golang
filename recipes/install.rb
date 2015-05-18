#
# Author:: Christian Graf (<christian.graf@realzeitmedia.com>)
# Cookbook Name:: golang
# Recipe:: install
#
# Copyright:: 2014, realzeit GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'pathname'
require 'uri'

include_recipe "build-essential"
include_recipe "golang::install"

if not node[:golang][:url]
  node.default[:golang][:url] = make_url(
    node[:golang][:version],
    node[:platform_family],
    node[:kernel][:machine]
  )
end

cache_dir = Chef::Config[:file_cache_path]
pkg_file = package_file(node[:golang][:url])
cached_package = ::File.join(cache_dir, pkg_file)

remote_file cached_package do
  source node[:golang][:url]
  action :create_if_missing
end

directory node[:golang][:install_dir] do
  owner "root"
  group node[:golang][:owner]
  group node[:golang][:group]
  mode 0755
  recursive true
  action :create
end

bash "install_golang" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf "#{node[:golang][:install_dir]}/go"
    tar -C #{node[:golang][:install_dir]} -xzf #{pkg_file}
  EOH
  not_if "#{node[:golang][:install_dir]}/go/bin/go version | grep -q 'go#{node[:golang][:version]}'"
  action :run
end

template "/etc/profile.d/golang.sh" do
  source "golang.sh.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    goroot: "#{node[:golang][:install_dir]}/go"
  })
  notifies :run, "bash[source_profile]", :immediately
end

bash "source_profile" do
  code <<-EOH
  source /etc/profile.d/golang.sh
  EOH
  action :nothing
end
