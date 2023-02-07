class ApplicationController < ActionController::Base
  
  helper_method :current_user, :logged_in?
  def current_user
    if !User.exists?(session[:user_id])
      @current_user = nil
    else
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end


  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:alert] = "You must logged in to perform that action"  
      redirect_to login_path
    end
  end

  def sort_leaderboard
    admin = User.all.find_by(admin: true)
    admin.score = 0
    admin.save
    users = User.all
    users = users.sort_by { |user| -1*(user.score) }
    rank = 0
    previous_score = -1
    users.each do |user|
      rank += 1 if previous_score != user.score
      user.rank = rank
      previous_score = user.score
      user.save
    end
    admin = User.all.find_by(admin: true)
    rank += 1
    admin.rank = rank
    admin.save
  end
  
end
