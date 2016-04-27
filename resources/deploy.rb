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

actions :deploy
default_action :deploy

attribute :package_name, kind_of: String
attribute :repo_url, kind_of: String
attribute :revision, kind_of: String
attribute :deploy_key, kind_of: String
attribute :ssh_wrapper_path, kind_of: String
attribute :godep, kind_of: [TrueClass, FalseClass]
attribute :install_commands, kind_of: String
attribute :force_install, kind_of: [TrueClass, FalseClass], default: false
