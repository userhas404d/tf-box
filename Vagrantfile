$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF

# AWS environment variables.
export AWS_DEFAULT_REGION=#{ENV['GOV_AWS_DEFAULT_REGION']}
export AWS_ACCESS_KEY_ID=#{ENV['GOV_AWS_ACCESS_KEY_ID']}
export AWS_SECRET_ACCESS_KEY=#{ENV['GOV_AWS_SECRET_ACCESS_KEY']}
EOF
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "tf-box"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.provision "shell", path: "bootstrap.sh", run: "always"
  config.vm.provision "shell", inline: $set_environment_variables, run: "always"
end