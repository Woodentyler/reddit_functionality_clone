class PostsController < ApplicationController
  before_action :require_user_owns_post, only:[:edit, :update]

  def new
    @subs = Sub.all
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      render post_url(@post)
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to edit_post_url(@post)
    end
  end

  def show
    @post = Post.find(params[:id])
    @all_posts = Comment.all.where("parent_comment_id IS NOT NULL")
  end

  private

  def require_user_owns_post!
    redirect_to subs_url unless current_user.posts.find_by(id: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

end
