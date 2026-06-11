require "test_helper"

class SearchTagListComponentTest < ViewComponent::TestCase
  def render_search_tag_list(tags, current_user: User.anonymous)
    as(current_user) do
      render_inline(SearchTagListComponent.new(tags: tags))
    end
  end

  context "The SearchTagListComponent" do
    should "render search tags with counts" do
      tag = create(:tag, name: "blue_hair", category: Tag.categories.general, post_count: 42)

      render_search_tag_list([tag])

      assert_css(".search-tag-list")
      assert_css("li[data-tag-name='blue_hair']")
      assert_css(".post-count", text: "42")
    end

    should "show edit links" do
      tag = create(:tag, name: "blue_hair", category: Tag.categories.general)

      render_search_tag_list([tag])

      assert_css("a.edit-tag-link[href='#{edit_tag_path(tag)}']", text: "e")
    end
  end
end
