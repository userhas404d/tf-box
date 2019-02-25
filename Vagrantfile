$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF
# AWS environment variables.
export AWS_DEFAULT_REGION=#{ENV['AWS_DEFAULT_REGION']}
export AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']}
export AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}

# confirm env vars exist
echo "-------------------------"
echo "validating env"
echo "-------------------------"
[[ -z "$AWS_DEFAULT_REGION" ]] && echo "ERROR: AWS_DEFAULT_REGION not set" || echo "AWS_DEFAULT_REGION is set"
[[ -z "$AWS_ACCESS_KEY_ID" ]] && echo "ERROR: AWS_ACCESS_KEY_ID not set" || echo "AWS_ACCESS_KEY_ID is set"
[[ -z "$AWS_SECRET_ACCESS_KEY" ]] && echo "ERROR: AWS_SECRET_ACCESS_KEY not set" || echo "AWS_SECRET_ACCESS_KEY is set"

EOF
SCRIPT


Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "tf-box"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.provision "shell", path: "bootstrap.sh", run: "once"
  config.vm.provision "file", source: "~/Documents/EAADS/terrabroker", destination: "$HOME/terrabroker"
  config.vm.provision "shell", path: "env_bootstrap.sh", run: "once", privileged: false
  config.vm.provision "shell", inline: $set_environment_variables, run: "always"
end