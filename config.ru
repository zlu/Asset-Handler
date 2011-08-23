$:.push File.expand_path("../lib", __FILE__)
require 'asset_handler'

prism = "/var/folders"
run AssetHandler.new(prism, Dir.pwd + "/assets/greetings")