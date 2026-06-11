require "test_helper"

class PostDanbooruTagImportsControllerTest < ActionDispatch::IntegrationTest
  context "The post Danbooru tag imports controller" do
    setup do
      @user = create(:user)
      @post = as(@user) { create(:post, tag_string: "old_tag") }
    end

    should "render the new dialog" do
      get_auth new_post_danbooru_tag_import_path(@post, format: :js), @user

      assert_response :success
      assert_includes(response.body, "Load tags from Danbooru")
      assert_includes(response.body, post_danbooru_tag_import_path(@post))
    end

    should "replace tags with tags from a Danbooru post URL" do
      Danbooru.config.stubs(:original_username).returns("danbooru_user")
      Danbooru.config.stubs(:original_api_key).returns("danbooru_api_key")

      http = mock("http")
      Danbooru::Http.stubs(:external).returns(http)
      http.stubs(:headers).returns(http)
      http.expects(:parsed_get).with(
        "https://danbooru.donmai.us/posts/7719391.json",
        params: { login: "danbooru_user", api_key: "danbooru_api_key" },
      ).returns({ tag_string: "1girl solo" })

      post_auth post_danbooru_tag_import_path(@post), @user, params: {
        danbooru_tag_import: { danbooru_post_id: "https://danbooru.donmai.us/posts/7719391" },
      }

      assert_redirected_to @post
      assert_equal("1girl solo", @post.reload.tag_string)
      assert_not_includes(@post.tag_array, "old_tag")
      assert_equal("Tags loaded from Danbooru post #7719391", flash[:notice])
    end

    should "load tags from a bare Danbooru post ID" do
      Danbooru.config.stubs(:original_username).returns("danbooru_user")
      Danbooru.config.stubs(:original_api_key).returns("danbooru_api_key")

      http = mock("http")
      Danbooru::Http.stubs(:external).returns(http)
      http.stubs(:headers).returns(http)
      http.expects(:parsed_get).returns({ "tag-string" => "solo" })

      post_auth post_danbooru_tag_import_path(@post), @user, params: {
        danbooru_tag_import: { danbooru_post_id: "7719391" },
      }

      assert_redirected_to @post
      assert_equal("solo", @post.reload.tag_string)
    end

    should "not update the post without credentials" do
      Danbooru.config.stubs(:original_username).returns(nil)
      Danbooru.config.stubs(:original_api_key).returns(nil)

      post_auth post_danbooru_tag_import_path(@post), @user, params: {
        danbooru_tag_import: { danbooru_post_id: "7719391" },
      }

      assert_redirected_to @post
      assert_equal("old_tag", @post.reload.tag_string)
      assert_equal("Danbooru credentials are not configured.", flash[:notice])
    end
  end
end
