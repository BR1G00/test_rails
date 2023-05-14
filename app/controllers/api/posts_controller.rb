class Api::PostsController < ApplicationController
  def index
    @posts = Post.all

    render json: serialize_posts(@posts)
  end

  def serialize_posts(posts)
    @posts.map do |post|
      {
        title: post.title,
        id: post.id,
        tags: post.tags.map { |tag| { name: tag.name } }
      }
    end
  end

  def search
    term = params[:term]
    @posts = if term
              Post.joins(:tags).where('title LIKE ? OR LIKE = ?', "%#{term}%", "%#{term}%")
            else
              []
            end

    render json: @posts, include: [:tags] # questo ritorna i post includendo anche i tags collegati
  end
end
