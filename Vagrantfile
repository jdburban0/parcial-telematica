Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64" 
  config.vm.boot_timeout = 600

  config.vm.define "vm1" do |vm1|
    vm1.vm.hostname = "maestro"
    vm1.vm.network "private_network", ip: "192.168.50.2"
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.hostname = "esclavo"
    vm2.vm.network "private_network", ip: "192.168.50.3"
  end
end