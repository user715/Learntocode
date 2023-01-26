class ProblemsController < ApplicationController

  before_action :set_problem, only: [:show, :destroy]
  before_action :require_user, only: [:new, :create, :destroy]
  before_action :require_admin, only: [:new, :create, :destroy]

  def index
    @problems = Problem.all
  end

  def show
  end

  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(problem_params)
    if @problem.save
      flash[:notice] = "Problem was created successfully."
      redirect_to @problem
    else
      render 'new'
    end
  end

  def destroy
    @problem.destroy
    flash[:notice] = "problem was successfully deleted"
    redirect_to problems_path
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:title, :description, :sample_cases, :sample_case_solutions, :test_cases, :test_case_solutions, :tag_id)
  end

  def require_admin
    if !current_user.admin?
      flash[:alert] = "only admin can delete problems"
      redirect_to @problem
    end
  end


end