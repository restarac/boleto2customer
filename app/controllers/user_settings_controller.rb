class UserSettingsController < ApplicationController
  before_action :require_login
  
  def senders
    @users = User.where.not(id: current_user.id)
  end

  def update_senders
    begin
      current_user.update_sender(current_user, params[:sender_origin_id])
    rescue 
      flash[:notice]= I18n.t('flashes.user.empty').html_safe
    end

    redirect_to action: "senders"
  end
end
