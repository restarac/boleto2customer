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

  private
  def validate_params
    required = params.require(:user)
    required.require(:password)
    required.require(:email)
  end
end