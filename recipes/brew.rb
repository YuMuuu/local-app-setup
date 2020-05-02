BREW_INSTALL_URL = "https://raw.githubusercontent.com/Homebrew/install/master/install"

# Update brew
enable_update = node["brew"]["enable_update"] ? node["brew"]["enable_update"] : false
if enable_update
  execute "Update brew" do
    command "brew update"
  end
else
  # Logger.info('Execution skipped Update brew because of not true enable_update')
end

# Upgrade brew
enable_upgrade = node["brew"]["enable_upgrade"] ? node["brew"]["enable_upgrade"] : false
if enable_upgrade
  execute "Upgrade brew" do
    command "brew upgrade"
  end
else
  # Logger.info('Execution skipped Upgrade brew because of not true enable_upgrade')
end

# Install brew
execute "Install brew" do
  command "ruby -e \"$(curl -fsSL #{BREW_INSTALL_URL})\""
  not_if "test $(which brew)"
end

# Add Repository
node["brew"]["add_repositories"].each do |repo|
  execute "Add Repository: #{repo}" do
    command "brew tap #{repo}"
    not_if "brew tap | grep -q '#{repo}'"
  end
end

# Install bin packages
node["brew"]["install_packages"].each do |package|
  package "#{package}" do
    not_if "brew list | grep -q #{package}"
  end
end

# Install apps
node["brew"]["install_apps"].each do |app|
  execute "Install apps: #{app}" do
    command "brew cask install #{app} --appdir=\"/Applications\""
    not_if "brew cask list | grep -q #{app}"
  end
end

# Install app store apps
node["brew"]["install_apps_from_store"].each do |app|
  execute "Install app_store apps: #{app}" do
    command "mas install #{app}"
    not_if "mas list | grep -q #{app}"
  end
end

# # Setup alfred
# execute "Setup alfred" do
#   command "brew cask alfred link"
# end

# Install sdkman
execute "Install sdkman" do
  command "curl -s get.sdkman.io | bash"
  not_if "test $(which sdk)"
end

# Update sdkman
execute "Update sdkman" do
  #todo: source $HOME/.sdkman/bin/sdkman-init.shを予め設定できるようにする
  command "source $HOME/.sdkman/bin/sdkman-init.sh && sdk update"
  not_if "test $(which sdk)"
end


# Install sdkman tools
node['sdkman'].each do |tool|
  execute "Install sdk tools: #{tool}" do
  #todo: source $HOME/.sdkman/bin/sdkman-init.shを予め設定できるようにする
    command "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install #{tool}"
    not_if "sdk list | grep -q #{tool}"
  end
end

# Create default directory
directory "$HOME/src" do
end
directory "$HOME/src/public" do
end
directory "$HOME/src/private" do
end

# Setting fish shell
# cant success travis ci this code.
# execute "Setting default fish shell" do
#   command "echo /usr/local/bin/fish | sudo tee -a /etc/shells && chsh -s /usr/local/bin/fish"
# end
