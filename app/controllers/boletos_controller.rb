class BoletosController < ApplicationController
  before_action :require_login

  def index
    @boletos = current_user.boletos
  end

  def new
  end

  def create
    current_user.boletos.create(boleto_params)
    redirect_to action: "index"
  end

  def show
  end

  def destroy
    Boleto.destroy(params[:id])
    redirect_to action: "index"
  end


  private

  def boleto_params
    params.permit(:due_date)
  end
end
