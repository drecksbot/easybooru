# frozen_string_literal: true

class TagsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    if request.format.html?
      @tags = authorize Tag.paginated_search(params, defaults: { hide_empty: true })
    else
      @tags = authorize Tag.paginated_search(params)
    end

    @tags = @tags.includes(:consequent_aliases) if request.format.html?
    respond_with(@tags)
  end

  def show
    @tag = authorize Tag.find(params[:id])
    respond_with(@tag)
  end

  def edit
    @tag = authorize Tag.find(params[:id])
    respond_with(@tag)
  end

  def update
    @tag = authorize Tag.find(params[:id])
    if params[:quick_category].present?
      @tag.skip_artist_category_validation = true
      @tag.update(updater: CurrentUser.user, category: params.dig(:tag, :category))
    else
      @tag.update(updater: CurrentUser.user, **permitted_attributes(@tag))
    end
    respond_with(@tag, location: params[:url].presence || @tag)
  end
end
