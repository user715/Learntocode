class ProblemsController < ApplicationController

  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:new, :create,:edit, :update, :destroy, :last_submission]
  before_action :require_admin, only: [ :create, :edit, :update, :destroy]

  def index
    @problems = Problem.all

    if params.has_key?(:difficulty)
      @problems = Tag.find(params[:difficulty]).problems
    end

    if params.has_key?(:status)
      if !logged_in?
        flash[:alert] = "You must logged in to perform that action"  
        redirect_to login_path
      else
        if params[:status] == "solved"
          @problems = @problems.select { |problem| current_user.problems_solved.include?(problem) }
        else
          @problems = @problems.select { |problem| !current_user.problems_solved.include?(problem) }
        end
      end
    end

    if params.has_key?(:categories)
      params[:categories].each do |category|
        @problems = @problems.select { |problem| problem.categories.collect(&:id).include?(category.to_i) }
      end
    end

  end

  def show
    if params[:submission_id]
      @submission = Submission.find(params[:submission_id]) 
      if !current_user || !(current_user.submissions.pluck(:problem_id).include? @submission.problem_id)
        flash[:alert] = "You must solve a question to view others submissions"
        redirect_to problems_path
      end
    end
  end

  def new
    if !current_user.admin?
      flash[:alert] = "only admin can create problems"
      redirect_to problems_path
    end
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(problem_params)
    @problem.categories.each do |category|
      category.problem_count += 1;
    end
    Tag.find(@problem.tag_id).problem_count += 1
    if @problem.save
      flash[:notice] = "Problem was created successfully."
      redirect_to @problem
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @problem.categories.each do |category|
      category.problem_count -= 1;
      category.save
    end

    @problem.solved_users.each do |user|
      if @problem.tag.tagname == "Easy"
        user.easysolved -= 1
      elsif @problem.tag.tagname == "Medium"
        user.mediumSolved -= 1
      else
        user.difficultSolved -= 1
      end
      user.save
    end
    
    @problem.solved_users.delete_all

    if @problem.update(problem_params)
      @problem.categories.each do |category|
        category.problem_count += 1;
        category.save
      end
      @problem.save
      flash[:notice] = "Problem was upadted successfully."
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destroy
    @problem.categories.each do |category|
      category.problem_count -= 1;
      category.save
    end
    @problem.solved_users.each do |user|
      if @problem.tag.tagname == "Easy"
        user.easysolved -= 1
      elsif @problem.tag.tagname == "Medium"
        user.mediumSolved -= 1
      else
        user.difficultSolved -= 1
      end
      user.save
    end

    @problem.destroy
    flash[:notice] = "problem was successfully deleted"
    redirect_to problems_path
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:title, :description, :sample_cases, :sample_case_solutions, :test_cases, :test_case_solutions, :tag_id, category_ids: [])
  end

  def require_admin
    if !current_user.admin?
      flash[:alert] = "only admin can perform that action"
      redirect_to @problem
    end
  end


end