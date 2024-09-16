User.create(email: "rails@dev.com", password: "123456").add_role :admin
exam = Exam.find_or_create_by(
  title: "Fundamentos de Rails",
  start_date: "2024-09-14 00:00:00.000000000 +0000",
  end_date: "2050-12-31 00:00:00.000000000 +0000"
)

questions = [
  {
    exam: exam,
    content: "Explica el concepto de 'Convención sobre Configura...",
    question_type: "free_text",
    points: 40,
    evaluable: true
  },
  {
    exam: exam,
    content: "¿Cuál de los siguientes se utiliza para definir el...",
    question_type: "single_choice",
    points: 20,
    evaluable: true
  },
  {
    exam: exam,
    content: "¿Cuáles de los siguientes son comandos válidos de ...",
    question_type: "multiple_choice",
    points: 20,
    evaluable: true
  },
  {
    exam: exam,
    content: "¿Cuáles es tu color favorito?",
    question_type: "free_text",
    points: 1,
    evaluable: false
  }
]


answers = [
  {
    question_id: 2,
    content: "Schema.rb",
    correct: false
  },
  {
    question_id: 2,
    content: "Routes.rb",
    correct: false
  },
  {
    question_id: 2,
    content: "Migraciones",
    correct: true
  },
  {
    question_id: 2,
    content: "Gemfile",
    correct: false

  },
  {
    question_id: 3,
    content: "rails c",
    correct: true
  },
  {
    question_id: 3,
    content: "rails console",
    correct: true
  },
  {
    question_id: 3,
    content: "rails terminal",
    correct: false
  },
  {
    question_id: 3,
    content: "rails repl",
    correct: false
  }
]

questions.each do |question|
  Question.create(question)
end

answers.each do |answer|
  Answer.create(answer)
end
