require 'rack/file'

class AssetHandler
  def initialize(original_media_location, assets_location)
    @original_media_dir = original_media_location
    @asset_dir = assets_location
    @files = Rack::File.new(Dir.new(@asset_dir))
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path_info

    if path =~ /assets/
      env["PATH_INFO"] = path.gsub("/assets", "")
      @files.call(env)
    else
      if path =~ /#{@original_media_dir}/ && File.exists?(path)
        FileUtils.mv(path, @asset_dir)
        filename = File.basename(path)
        [200, {"Content-Type" => "text/html"}, "/assets/#{filename}"]
      else
        [404, {"Content-Type" => "text/html"}, "File not found"]
      end
    end
  end
end