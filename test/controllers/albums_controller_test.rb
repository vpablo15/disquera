require "test_helper"

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = albums(:one)
  end

  test "should get index" do
    get albums_url
    assert_response :success
  end

  test "should get new" do
    get new_album_url
    assert_response :success
  end

  test "should create album" do
    assert_difference("Album.count") do
      post albums_url, params: { album: { author_id: @album.author_id, category: @album.category, condition_is_new: @album.condition_is_new, deleted_at: @album.deleted_at, description: @album.description, media_type: @album.media_type, name: @album.name, stock_available: @album.stock_available, unit_price: @album.unit_price } }
    end

    assert_redirected_to album_url(Album.last)
  end

  test "should show album" do
    get album_url(@album)
    assert_response :success
  end

  test "should get edit" do
    get edit_album_url(@album)
    assert_response :success
  end

  test "should update album" do
    patch album_url(@album), params: { album: { author_id: @album.author_id, category: @album.category, condition_is_new: @album.condition_is_new, deleted_at: @album.deleted_at, description: @album.description, media_type: @album.media_type, name: @album.name, stock_available: @album.stock_available, unit_price: @album.unit_price } }
    assert_redirected_to album_url(@album)
  end

  test "should destroy album" do
    assert_difference("Album.count", -1) do
      delete album_url(@album)
    end

    assert_redirected_to albums_url
  end
end
