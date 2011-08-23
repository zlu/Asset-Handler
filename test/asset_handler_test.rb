require "test/unit"
require "rack/test"

$:.push File.expand_path("../../lib", __FILE__)
require 'asset_handler'

class AssetHandlerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    FileUtils.mkdir(fixture_path)
    FileUtils.mkdir(original_media_dir)
    FileUtils.mkdir(assets_dir)
  end

  def teardown
    FileUtils.rm_rf(fixture_path)
  end

  def fixture_path
    File.expand_path("../fixtures", __FILE__)
  end

  def original_media_dir
    fixture_path + "/original_media"
  end

  def assets_dir
    fixture_path + "/assets"
  end

  def app
    AssetHandler.new(original_media_dir, assets_dir)
  end

  def create_asset(contents, filename="existing_file.txt", destination_folder=assets_dir)
    File.open(File.join(destination_folder, filename), "w") do |f|
      f << contents
    end
    filename
  end

  def test_requesting_asset_that_exists_in_the_assets_directory_returns_the_file
    asset_file = create_asset("returning a file")
    get "/assets/#{asset_file}"

    assert_equal last_response.body, "returning a file"
  end

  def test_requesting_asset_that_does_not_exist_in_the_assets_directory_returns_a_404
    get "/assets/non-existent-file"

    assert last_response.not_found?
  end

  def test_requesting_asset_in_the_original_media_folder_moves_the_file_and_returns_new_location
    filename = create_asset("original content", "original-content-file.txt", original_media_dir)
    original_file_path = "#{original_media_dir}/#{filename}"
    get original_file_path

    assert !File.exists?(original_file_path)
    assert File.exists?(File.join(assets_dir, filename))

    assert_equal last_response.body, "/assets/#{filename}"
  end

end