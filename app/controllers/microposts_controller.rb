# SOURCE: app/controllers/microposts_controller.rb
# 

class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # 
    def correct_user
      # find microposts through the association
      @micropost = current_user.microposts.find_by(id: params[:id]) # using 'find_by' instead of 'find' because the latter raises an exception when the micropost doesn’t exist instead of returning nil
      redirect_to root_url if @micropost.nil?
    end
end