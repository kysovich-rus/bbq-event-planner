class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show]
  before_action :set_current_user, except: [:show]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t('activerecord.controllers.users.updated')
    else
      flash.now[:alert] = t('activerecord.controllers.users.error')
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @user = current_user
  end

  # Пропишем, что разрешено передавать в params
  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end