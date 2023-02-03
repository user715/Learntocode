class SubmissionsController < ApplicationController

  before_action :require_user, only: [:submit, :last_submission]


  def last_submission
    @submission = current_user.submissions.where(problem_id: params[:prob_id]).last if current_user.submissions
    
  end

  def submit
    # get ide-form data
    compiler = params[:compiler]
    record = Language.find{ |l| l.name == compiler }
    language = record.language
    versionIndex = record.versionIndex
    script = params[:script]
    testcases = ""
    if params[:custom_cases] == "1"
      testcases = params[:testcases]
    else
      testcases = Problem.find(params[:problem_id]).test_cases
    end

    temp = String.new(testcases)

    testcases.chomp!
    testcases.gsub! "\t",' '
    testcases.gsub! "\n",' '
    testcases.gsub! "\r",' '
    testcases = testcases.squeeze(" ")
    testcases = testcases.strip

 

    # API - testcases response
    @response = Problem.execute(script, language, versionIndex,testcases)

    script.chomp!
    script.gsub! "\t",' '
    script.gsub! "\r",' '
    script = script.squeeze(" ")

    temp.gsub! "\r",' '
    @response[:testcases] = temp
    if params[:custom_cases] == "1"
      @response[:solved] = nil
    else
      # create new submission record in db
      submission = Submission.new
      submission.compiler = compiler
      submission.script = script
      submission.language = language
      submission.versionIndex = versionIndex
      submission.user_id = current_user.id
      submission.problem_id = params[:problem_id]

      solution = Problem.find(params[:problem_id]).test_case_solutions
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
        @response[:solved] = true
        @response[:status] = "All Testcases Passes"
        submission.status = "All Testcases Passes"
        problem = Problem.find(params[:problem_id])
        if !(current_user.problems_solved.include? problem)
          problem.solved_users << current_user
          if problem.tag.tagname == "Easy"
            current_user.easysolved += 1
          elsif problem.tag.tagname == "Medium"
            current_user.mediumSolved += 1
          else
            current_user.difficultSolved += 1
          end
          current_user.save
        end
      else
        @response[:solved] = false
        @response[:status] = "Wrong Answer"
        submission.status = "Wrong Answer"
      end
      submission.save
    end

    if @response
      respond_to do |f|
        f.js {render partial: 'problems/response'}
      end
    end

  end
end