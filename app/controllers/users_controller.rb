class UsersController < ApplicationController
  before_action :authenticate_user! #ログイン中か確認
  before_action :ensure_correct_user, only: [:edit, :update] #機能制限
  #before_action :ensure_guest_user, only: [:edit] #ゲストユーザーに機能制限
  
  def show
    @user = User.find(params[:id])
    if !current_user.admin && @user.admin # ログインユーザが管理者ではない 且 管理者のページである => 両方の条件を満たす時リダイレクトしたいため。
      redirect_to user_path(current_user)
    end
    posts = @user.posts
    @posts = posts.page(params[:page]).per(6)
  end
  
  # User一覧(管理者専用)
  def index
    if current_user.name == "管理者"
      @users = User.all
      # .where.not(admin)
    else
      redirect_to user_path(current_user)
    end
  end
  
  #管理者はeditに遷移できない
  def edit
    @user = User.find(params[:id])
    if current_user.admin?
      redirect_to user_path(current_user)
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user = current_user
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end
  
  # User削除(管理者専用)
  def destroy
    if current_user.name == "管理者"
       @user = User.find(params[:id])
       @user.destroy
       redirect_to users_path
    else
       redirect_to request.referer
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :round_area, :average_score, :experience)
  end
  
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  # ポートフォリオ提出時はOFFにしておく
  # def ensure_guest_user
  #   @user = User.find(params[:id])
  #   if @user.name == "ゲストユーザー"
  #     redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
  #   end
  # end
  
end
