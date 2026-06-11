# frozen_string_literal: true

module TagsHelper
  QUICK_TAG_CATEGORY_LINKS = {
    "g" => TagCategory::GENERAL,
    "r" => TagCategory::COPYRIGHT,
    "c" => TagCategory::CHARACTER,
    "m" => TagCategory::META,
  }.freeze

  def tag_class(tag)
    return nil if tag.blank?
    "tag-type-#{tag.category}"
  end

  def quick_tag_category_links(tag)
    return "".html_safe if tag.artist?

    current_letter = QUICK_TAG_CATEGORY_LINKS.key(tag.category)
    links = QUICK_TAG_CATEGORY_LINKS.except(current_letter).map do |letter, category|
      link_to letter, tag_path(tag), method: :put, class: "wiki-link tag-category-shortcut-link",
        title: "Set category to #{TagCategory.reverse_mapping[category].capitalize}", "data-params": {
        tag: { category: category },
        url: request.fullpath,
      }.to_param
    end

    safe_join(links)
  end
end
