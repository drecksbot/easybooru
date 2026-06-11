# frozen_string_literal: true

class PostDanbooruTagImportsController < ApplicationController
  respond_to :html, :js

  class Error < StandardError; end

  def new
    @post = authorize Post.find(params[:post_id]), :update?
    respond_with(@post)
  end

  def create
    @post = authorize Post.find(params[:post_id]), :update?
    danbooru_post_id = parse_danbooru_post_id(params.dig(:danbooru_tag_import, :danbooru_post_id))
    @post.update(
      old_tag_string: @post.tag_string,
      tag_string: fetch_danbooru_tag_string(danbooru_post_id),
    )

    if @post.errors.any?
      flash[:notice] = @post.errors.full_messages.join("; ")
    else
      flash[:notice] = "Tags loaded from Danbooru post ##{danbooru_post_id}"
    end
    redirect_to @post
  rescue Error => e
    flash[:notice] = e.message
    redirect_to @post
  end

  private

  def parse_danbooru_post_id(input)
    input = input.to_s.strip
    post_id = input[/\A\d+\z/] || input[%r{\Ahttps?://(?:[^/]+\.)?donmai\.(?:us|moe)/posts/(\d+)(?:[/?#.]|\z)}, 1]

    raise Error, "Enter a Danbooru post ID or post URL." if post_id.blank?

    post_id
  end

  def fetch_danbooru_tag_string(post_id)
    credentials = {
      login: Danbooru.config.original_username,
      api_key: Danbooru.config.original_api_key,
    }

    raise Error, "Danbooru credentials are not configured." if credentials.values.any?(&:blank?)

    response = Danbooru::Http.external
      .headers("User-Agent": "#{Danbooru.config.canonical_app_name}/#{Rails.application.config.x.git_hash}")
      .parsed_get("https://danbooru.donmai.us/posts/#{post_id}.json", params: credentials)

    response = response.to_h.with_indifferent_access
    tag_string = response[:tag_string].presence ||
                 response[:"tag-string"].presence ||
                 response.dig(:post, :tag_string).presence ||
                 response.dig(:post, :"tag-string").presence

    raise Error, "Could not load tags for Danbooru post ##{post_id}." if tag_string.blank?

    tag_string
  end
end
