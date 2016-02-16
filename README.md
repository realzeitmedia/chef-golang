# golang cookbook

## Requirements

* `build-essential`

## Attributes

* `install_dir` - the installation directory for Go. Defaults to
  /usr/local
* `url` - the download URL of the golang package. Will be automatically
  generated from the `version` attribute and your platform parameters if
left empty.
* `owner` - for setting the permissions of the install directory
* `group` - for setting the permissions of the install directory
* `version` - the Golang version to install

## Recipes

* `default` - calls the install recipe
* `install` - installs Go

## Resources

### deploy

Deploy a Go binary from a private source repository

#### Action Parameters

* `name attribute`: The name of the golang package
* `repo_url`: The location of the repository
* `revision`: The revision that should be checked out
* `deploy_key`: The access key used for SSH access
* `godep`: Use godep for building the binary (true/false)
* `install_commands`: The commands to run for the installation
* `force_install`: Always run install commands even if git repo is in
  sync (default: false)

#### Example

```ruby
golang_deploy 'github.com/realzeitmedia/myprivaterepo' do
  repo_url 'git@github.com:realzeitmedia/myprivaterepo'
  revision 'master'
  deploy_key keys['my_private_key']
  godep true
  install_commands "make && make install"
end
```

## Author and License

Author:: Christian Graf

```text
Copyright 2014, realzeit GmbH (http://realzeitmedia.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
