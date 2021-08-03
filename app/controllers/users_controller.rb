class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :update_interests, :update_profile]
  before_action :store_url, only: [:edit_profile]

  def show
    @tie = user_tie(current_user, @user)
    last_message = Message.where(tie_id: @tie).last
    if last_message
      @last_message_id = last_message.id
    else
      @last_message_id = 0
    end
  end

  def edit_profile
    # binding.pry
    if user_signed_in?
      @user = User.find(current_user.id)
    else
      redirect_to root_path, notice: "Sorry, you must login first."
    end
  end

  def update_profile
    if user_signed_in?
      if @user.update!(user_params)
        redirect_to after_update_path_for(@user), notice: "Your interest is updated sucessfully !"
        # redirect_back(fallback_location: root_path)
      else
        flash.now[:alert] = @user.errors.full_messages.first
        # render :edit_interests
      end

    else
      redirect_to root_path, notice: "Sorry, you must login first."
    end
  end

  def update_interests
    if user_signed_in?
      if @user.update!(user_params)
        # redirect_to edit_user_registration_path, notice: "Your interest is updated sucessfully !"
        # flash.now[:alert] = "Interests updated"
      else
        flash.now[:alert] = @user.errors.full_messages.first
        # render :edit_interests
      end

    else
      redirect_to root_path, notice: "Sorry, you must login first."
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :bio, :summary, photos: [], interest_ids: [])
  end

  def find_user
    @user = User.find(params[:id])
  end

  # Return a tie object that contains the two users
  def user_tie(user_A, user_B)
    Tie.where('(user1_id = :user1 and user2_id = :user2) OR (user1_id= :user2 and user2_id= :user1)', { user1: user_A, user2: user_B }).first
  end
end
