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

    should "show quick category links" do
      tags = [
        create(:tag, name: "blue_hair", category: Tag.categories.general),
        create(:tag, name: "sadamoto_yoshiyuki", category: Tag.categories.artist),
        create(:tag, name: "evangelion", category: Tag.categories.copyright),
        create(:tag, name: "ayanami_rei", category: Tag.categories.character),
        create(:tag, name: "commentary", category: Tag.categories.meta),
      ]

      render_search_tag_list(tags)

      assert_no_css("a.wiki-link", text: "?")
      assert_no_css("a.edit-tag-link", text: "e")
      assert_css("li[data-tag-name='blue_hair'] form.tag-category-shortcut-form[action='#{tag_path(tags[0])}'][method='post'] button.tag-category-shortcut-link", text: "a")
      assert_css("li[data-tag-name='blue_hair'] form.tag-category-shortcut-form[action='#{tag_path(tags[0])}'][method='post'] button.tag-category-shortcut-link", text: "r")
      assert_css("li[data-tag-name='blue_hair'] form.tag-category-shortcut-form[action='#{tag_path(tags[0])}'][method='post'] button.tag-category-shortcut-link", text: "c")
      assert_css("li[data-tag-name='blue_hair'] form.tag-category-shortcut-form[action='#{tag_path(tags[0])}'][method='post'] button.tag-category-shortcut-link", text: "m")
      assert_no_css("li[data-tag-name='blue_hair'] button.tag-category-shortcut-link", text: "g")

      assert_css("li[data-tag-name='sadamoto_yoshiyuki'] button.tag-category-shortcut-link", text: "g")
      assert_css("li[data-tag-name='sadamoto_yoshiyuki'] button.tag-category-shortcut-link", text: "r")
      assert_css("li[data-tag-name='sadamoto_yoshiyuki'] button.tag-category-shortcut-link", text: "c")
      assert_css("li[data-tag-name='sadamoto_yoshiyuki'] button.tag-category-shortcut-link", text: "m")
      assert_no_css("li[data-tag-name='sadamoto_yoshiyuki'] button.tag-category-shortcut-link", text: "a")

      assert_css("li[data-tag-name='evangelion'] button.tag-category-shortcut-link", text: "g")
      assert_css("li[data-tag-name='evangelion'] button.tag-category-shortcut-link", text: "a")
      assert_css("li[data-tag-name='evangelion'] button.tag-category-shortcut-link", text: "c")
      assert_css("li[data-tag-name='evangelion'] button.tag-category-shortcut-link", text: "m")
      assert_no_css("li[data-tag-name='evangelion'] button.tag-category-shortcut-link", text: "r")

      assert_css("li[data-tag-name='ayanami_rei'] button.tag-category-shortcut-link", text: "g")
      assert_css("li[data-tag-name='ayanami_rei'] button.tag-category-shortcut-link", text: "a")
      assert_css("li[data-tag-name='ayanami_rei'] button.tag-category-shortcut-link", text: "r")
      assert_css("li[data-tag-name='ayanami_rei'] button.tag-category-shortcut-link", text: "m")
      assert_no_css("li[data-tag-name='ayanami_rei'] button.tag-category-shortcut-link", text: "c")

      assert_css("li[data-tag-name='commentary'] button.tag-category-shortcut-link", text: "g")
      assert_css("li[data-tag-name='commentary'] button.tag-category-shortcut-link", text: "a")
      assert_css("li[data-tag-name='commentary'] button.tag-category-shortcut-link", text: "r")
      assert_css("li[data-tag-name='commentary'] button.tag-category-shortcut-link", text: "c")
      assert_no_css("li[data-tag-name='commentary'] button.tag-category-shortcut-link", text: "m")
    end
  end
end
