class UsersController < Clearance::UsersController

  def new
    @user = user_from_params
    render template: "users/new"
  end

  def create
    begin
      validate_params
      super
    rescue
      flash[:notice]= I18n.t('flashes.user.failure_after_create').html_safe
      redirect_to action: 'new'
    end
  end

  def index
    @users = User.all
  end

  def update
    user = User.find(params[:user_id])
    user.sender_origin = User.find(params[:sender_origin_id])
    user.save
    redirect_to :root
  end


  private
  def validate_params
    required = params.require(:user)
    required.require(:password)
    required.require(:email)
  end
end