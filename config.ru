$:.push File.expand_path("../lib", __FILE__)
require 'asset_handler'

original_media_location = "/var/folders"
run AssetHandler.new(original_media_location, Dir.pwd)