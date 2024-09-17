module ExamResultsHelper
  def exam_average_score(exam)
    exam.user_exams.completed.average(:total_score)
  end
end
