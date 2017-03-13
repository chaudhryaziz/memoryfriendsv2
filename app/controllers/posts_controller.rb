#controller to create a post, edit, update and destroy it
class PostsController < ApplicationController

	before_action :set_post, only: [:edit, :update, :destroy]

	#create post, pass acceptable post content and notify on success or fail
	def create 
		@post = current_user.posts.new(post_params)
		if @post.save
			@post.create_activity key: 'post.created', owner: @post.user
			respond_to do |format|
				format.html {redirect_to user_path(@post.user.username), notice: "Memory Has been created"}
			end
		else
			redirect_to user_path(@post.user.username), notice: "Error has occured, Memory not created"
		end
	end

	#edit a post, needs to find post from params
	def edit
	end


	def update
		if @post.update(post_params)
		respond_to do |format|
				format.html {redirect_to user_path(@post.user.username), notice: "Memory Updated"}
		end
		else
		redirect_to post_path(@post), notice: "Some error has occured, taking you back to Memory Post page."
		end
	end


	def destroy
		@post.destroy
		respond_to do |format|
			format.html {redirect_to user_path(@post.user.username), notice: "Memory Deleted"}
		end
	end

	private


	def set_post
		@post = Post.find(params[:id])
	end

	#define what you want to permit in a post. HTML is checked in model so just permit content.
	def post_params
		params.require(:post).permit(:content)
	end

end