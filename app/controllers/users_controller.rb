class UsersController < Clearance::UsersController

  def index
    @users = User.all
  end

  def update
    user = User.find(params[:user_id])
    user.sender_origin = User.find(params[:sender_origin_id])
    user.save
    redirect_to :root
  end
end