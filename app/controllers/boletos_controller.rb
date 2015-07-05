class BoletosController < ApplicationController
  before_action :require_login

  def index
    @boletos = current_user.boletos
  end

  def new
  end

  def create
  end

  def show
  end

  def destroy
    Boleto.destroy(params[:id])
    redirect_to action: "index"
  end
end
