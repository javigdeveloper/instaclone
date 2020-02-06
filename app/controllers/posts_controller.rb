class PostsController < ApplicationController
  def index
      @posts = Post.all
  end
  def show
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new
  end
  def edit
    @post = Post.find(params[:id])
    if current_user != @post.user
      sign_out current_user
      redirect_to "/users/sign_in"
      flash[:alert] = "Unauthorized request"
    end
  end
  def update
    post = Post.find(params[:id])
    if current_user == post.user
      post.update(update_params)
      redirect_to post
      flash[:notice] = "Update successful!"
    end
  end
  
  def create
    @post = Post.new(posts_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post
      flash[:notice] = "Post created!"
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = "Post creation failed"
    end
  end
  def destroy
    Post.find(params[:id])
    if current_user == post.user
      post.destroy
      redirect_to "/posts"
      flash[:notice] = "Post destroyed"
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = "Not authorized to delete post"
    end
    redirect_to "/posts"
  end

  private
  def posts_params
    params.require(:post).permit(:caption, :pic)
  end
  def update_params
    params.require(:post).permit(:caption)
  end
end