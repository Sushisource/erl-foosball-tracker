# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.define "app" do |v|
        v.vm.provider "docker" do |d|
            d.build_dir = "./docker"
            d.cmd = ["ls", "/app"]
            d.remains_running = false
        end
    end

    config.vm.define "db" do |v|
        v.vm.provider "docker" do |d|
            d.image = "postgres:9.4.0"
            d.ports = ["5432:5432"]
        end
    end
end
