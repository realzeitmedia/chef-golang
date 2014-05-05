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

def package_file(uri)
  require 'pathname'
  require 'uri'
  Pathname.new(URI.parse(uri).path).basename.to_s
end

def make_url(version, platform_family, kernel_machine)
  base_url = "https://storage.googleapis.com/golang"

  case kernel_machine
  when "x86_64"
    arch = "amd64"
  else
    arch = "386"
  end

  case platform_family
  when "windows"
    family = "windows"
  when "mac_os_x"
    family = "darwin"
  else
    family = "linux"
  end

  "#{base_url}/go#{version}.#{family}-#{arch}.tar.gz"
end
