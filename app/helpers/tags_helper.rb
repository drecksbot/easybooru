# frozen_string_literal: true

module TagsHelper
  QUICK_TAG_CATEGORY_BUTTON_STYLE = "display: inline; border: 0; padding: 0; background: transparent; color: var(--link-color); font: inherit; line-height: inherit; cursor: pointer; box-shadow: none;".freeze
  QUICK_TAG_CATEGORY_FORM_STYLE = "display: inline; margin: 0; padding: 0;".freeze

  QUICK_TAG_CATEGORY_LINKS = {
    "g" => TagCategory::GENERAL,
    "a" => TagCategory::ARTIST,
    "r" => TagCategory::COPYRIGHT,
    "c" => TagCategory::CHARACTER,
    "m" => TagCategory::META,
  }.freeze

  def tag_class(tag)
    return nil if tag.blank?
    "tag-type-#{tag.category}"
  end

  def quick_tag_category_links(tag)
    current_letter = QUICK_TAG_CATEGORY_LINKS.key(tag.category)
    links = QUICK_TAG_CATEGORY_LINKS.except(current_letter).map do |letter, category|
      button_to letter, tag_path(tag), method: :put, class: "wiki-link tag-category-shortcut-link",
        form: { class: "tag-category-shortcut-form", style: QUICK_TAG_CATEGORY_FORM_STYLE },
        style: QUICK_TAG_CATEGORY_BUTTON_STYLE,
        title: "Set category to #{TagCategory.reverse_mapping[category].capitalize}", params: {
        tag: { category: category },
        quick_category: true,
        url: request.fullpath,
      }
    end

    safe_join(links)
  end
end
