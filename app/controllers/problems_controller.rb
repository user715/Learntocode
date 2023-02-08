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
      if !current_user || (!current_user.admin? && !(current_user.problems_solved.pluck(:problem_id).include? @submission.problem_id))
        if !current_user || (current_user.id!=@submission.user_id)
          flash[:alert] = "You must solve a question to view others submissions"
          redirect_back fallback_location: root_path
        end
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
    
    s1 = @problem.test_case_solutions
    if @problem.update(problem_params)
      t = Thread.new {
        @problem.categories.each do |category|
          category.problem_count += 1;
          category.save
        end
        s2=@problem.test_case_solutions
        s1.chomp!
        s2.chomp!
        s1.gsub! "\t",' '
        s1.gsub! "\n",' '
        s1.gsub! "\r",' '
        s2.gsub! "\t",' ' 
        s2.gsub! "\n",' '
        s2.gsub! "\r",' '
        s1 = s1.squeeze(" ")
        s2 = s2.squeeze(" ")
        s1 = s1.strip
        s2 = s2.strip
        if s1 != s2
          # byebug
          @problem.solved_users.each do |user|
            @problem.solved_users.delete(user)
            if @problem.tag.tagname == "Easy"
              user.easysolved -= 1
              user.score -= 10
            elsif @problem.tag.tagname == "Medium"
              user.mediumSolved -= 1
              user.score -= 20
            else
              user.difficultSolved -= 1
              user.score -= 30
            end
            user.save
          end
          @problem.submissions.each do |submission|
            @submission = submission
            check_submission
          end
          User.all.each do |user|
            if !user.submissions.select{|s| s.problem_id==@problem.id && s.status=="All Testcases Passes"}.empty?
              # byebug
              @problem.solved_users << user
              if @problem.tag.tagname == "Easy"
                user.easysolved += 1
                user.score += 10
              elsif @problem.tag.tagname == "Medium"
                user.mediumSolved += 1
                user.score += 20
              else
                user.difficultSolved += 1
                user.score += 30
              end
              user.save
            end
          end
          sort_leaderboard
        end
      }
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
        user.score -= 10
      elsif @problem.tag.tagname == "Medium"
        user.mediumSolved -= 1
        user.score -= 20
      else
        user.difficultSolved -= 1
        user.score -= 30
      end
      user.save
    end

    @problem.destroy
    flash[:notice] = "problem was successfully deleted"
    redirect_to problems_path
  end

  private

  def set_problem
    if !Problem.exists?(params[:id])
      flash[:alert] = "Problem not found"
      redirect_to problems_path
    else
      @problem = Problem.find(params[:id])
    end
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

  def check_submission
    problem = Problem.find(@submission.problem_id)
    user = User.find(@submission.user_id)
    language = @submission.language
    versionIndex = @submission.versionIndex
    script = @submission.script
    testcases = problem.test_cases

    testcases.chomp!
    testcases.gsub! "\t",' '
    testcases.gsub! "\n",' '
    testcases.gsub! "\r",' '
    testcases = testcases.squeeze(" ")
    testcases = testcases.strip

    # API - testcases response
    @response = Problem.execute(script, language, versionIndex,testcases)

      solution = problem.test_case_solutions
      s1 = String.new(solution)
      s2 = String.new(@response[:output])
      s1.chomp!
      s2.chomp!
      s1.gsub! "\t",' '
      s1.gsub! "\n",' '
      s1.gsub! "\r",' '
      s2.gsub! "\t",' ' 
      s2.gsub! "\n",' '
      s2.gsub! "\r",' '
      s1 = s1.squeeze(" ")
      s2 = s2.squeeze(" ")
      s1 = s1.strip
      s2 = s2.strip
      if s1 == s2
        @submission.status = "All Testcases Passes"
      else
        @submission.status = "Wrong Answer"
      end
      @submission.save
      problem.save
    end

    if @response
      respond_to do |f|
        f.js {render partial: 'problems/response'}
      end
    end
  end
