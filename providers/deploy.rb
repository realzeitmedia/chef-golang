#
# Author:: Christian Graf (<christian.graf@realzeitmedia.com>)
# Cookbook Name:: golang
# Provider:: golang_install
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
#
action :deploy do
  pkg              = new_resource.package_name || new_resource.name
  workpath         = ::File.join(Chef::Config[:file_cache_path], "src", pkg)
  repo_url         = new_resource.repo_url || "https://github.com/#{pkg}"
  ssh_wrapper_path = new_resource.ssh_wrapper_path || "/etc/deployment/ssh_wrapper"
  install_commands = new_resource.install_commands || "make && make test && make install"
  deploy_key       = new_resource.deploy_key

  ENV["PATH"] = "#{ENV["PATH"]}:#{node[:golang][:install_dir]}/go/bin"
  package "git"

  directory workpath do
    owner "root"
    group "root"
    mode 00700
    recursive true
    action :create
  end

  set_paths workpath

  unless deploy_key.nil?
    write_deploy_key "for_deployment" do
      deploy_key       deploy_key
      ssh_wrapper_path ssh_wrapper_path
    end
  end

  git workpath do
    repository repo_url
    reference  new_resource.revision
    action :sync
    ssh_wrapper ssh_wrapper_path
    notifies :run, "bash[install_gopackage]", :immediately
  end

  bash "install_gopackage" do
    user "root"
    cwd  workpath
    code <<-EOH
    #{install_commands}
    EOH
  end
end

private

def set_paths(workpath)
  gopath, path = "", ""
  if new_resource.godep
    gopath = "#{workpath}/Godeps/_workspace:"
    path =   "#{workpath}/Godeps/_workspace/bin:"
  end
  gopath += "#{Chef::Config[:file_cache_path]}"
  path   += "#{Chef::Config[:file_cache_path]}/bin"

  ENV['GOPATH'] = gopath
  ENV['PATH']   = "#{path}:#{ENV['PATH']}"
end
