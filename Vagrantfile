Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "tf-box"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"
  config.vm.provision "shell", path: "bootstrap.sh", run: "once"
  config.vm.provision "file", source: "~/.aws/", destination: "$HOME/.aws"
  config.vm.synced_folder "~/Documents/EAADS/terrabroker", "/home/vagrant/terrabroker"
end