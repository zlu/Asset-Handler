require 'rack/file'

class AssetHandler
  def initialize(original_media_location, app_location)
    @original_media_dir = original_media_location
    @asset_dir_name = "assets"
    @asset_dir = File.join(app_location, @asset_dir_name)
    @files = Rack::File.new(Dir.new(app_location))
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info =~ /^\/#{@asset_dir_name}\//
      @files.call(env)
    else
      path = File.expand_path(request.path_info)
      if path =~ /^#{@original_media_dir}/ && File.exists?(path)
        FileUtils.mv(path, @asset_dir)
        new_asset_location = File.join("/", @asset_dir_name, File.basename(path))
        [200, {"Content-Type" => "text/html"}, new_asset_location]
      else
        [404, {"Content-Type" => "text/html"}, "File not found"]
      end
    end
  end
end