require "test_helper"

class SearchTagListComponentTest < ViewComponent::TestCase
  def render_search_tag_list(tags, current_user: User.anonymous)
    render_inline(SearchTagListComponent.new(tags: tags, current_user: current_user))
  end

  context "The SearchTagListComponent" do
    should "render search tags with counts" do
      tag = create(:tag, name: "blue_hair", category: Tag.categories.general, post_count: 42)

      render_search_tag_list([tag])

      assert_css(".search-tag-list")
      assert_css("li[data-tag-name='blue_hair']")
      assert_css(".post-count", text: "42")
    end

    should "show edit links for members" do
      tag = create(:tag, name: "blue_hair", category: Tag.categories.general)

      render_search_tag_list([tag], current_user: create(:user))

      assert_css("a.edit-tag-link[href='#{edit_tag_path(tag)}']", text: "e")
    end

    should "not show edit links for anonymous users" do
      tag = create(:tag, name: "blue_hair", category: Tag.categories.general)

      render_search_tag_list([tag], current_user: User.anonymous)

      assert_no_css("a.edit-tag-link[href='#{edit_tag_path(tag)}']")
    end
  end
end
