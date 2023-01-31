class SubmissionsController < ApplicationController

  def submit
    compiler = params[:compiler]
    record = Language.find{ |l| l.name == compiler }
    language = record.language
    versionIndex = record.versionIndex
    script = params[:script]
    testcases = params[:testcases]
    @response = Problem.execute(script, language, versionIndex,testcases)
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
    if s1 == s2
      @response[:solved] = true
    else
      @response[:solved] = false
    end
    if @response
      respond_to do |f|
        f.js {render partial: 'problems/response'}
      end
    end
  end
end