#
# Author:: Christian Graf (<christian.graf@realzeitmedia.com>)
# Cookbook Name:: golang
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

define :write_deploy_key, deploy_key: nil, ssh_wrapper_path: nil do
  directory "/etc/deployment" do
    user 'root'
    mode 00700
    action :create
  end

  file "/etc/deployment/deploy_key" do
    content params[:deploy_key]
    mode 00600
  end

  file params[:ssh_wrapper_path] do
    content <<-EOH
    /usr/bin/env ssh -i /etc/deployment/deploy_key -o StrictHostKeyChecking=no $1 $2
    EOH
    mode 00700
  end
end
