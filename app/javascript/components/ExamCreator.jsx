import React, { useState } from 'react'
import Button from "./ui/Button"
import Input from "./ui/Input"
import Label from "./ui/Label"
import Textarea from "./ui/Textarea"
import Card, { CardHeader, CardTitle, CardContent } from "./ui/Card"
import Checkbox from "./ui/Checkbox"
import Select, { SelectItem } from "./ui/Select"
import { PlusCircle, Trash2 } from 'lucide-react'

export default function ExamCreator() {
  const [exam, setExam] = useState({
    title: '',
    start_date: '',
    end_date: '',
    questions_attributes: []
  })

  const addQuestion = () => {
    setExam(prev => ({
      ...prev,
      questions_attributes: [
        ...prev.questions_attributes,
        {
          content: '',
          question_type: 'free_text',
          points: 0,
          answers_attributes: [],
          evaluable: true
        }
      ]
    }))
  }

  const removeQuestion = (index) => {
    setExam(prev => ({
      ...prev,
      questions_attributes: prev.questions_attributes.filter((_, i) => i !== index)
    }))
  }

  const updateQuestion = (index, updates) => {
    setExam(prev => ({
      ...prev,
      questions_attributes: prev.questions_attributes.map((q, i) => 
        i === index ? { ...q, ...updates } : q
      )
    }))
  }

  const addAnswer = (questionIndex) => {
    setExam(prev => ({
      ...prev,
      questions_attributes: prev.questions_attributes.map((q, i) => 
        i === questionIndex ? {
          ...q,
          answers_attributes: [
            ...q.answers_attributes,
            { content: '', correct: false }
          ]
        } : q
      )
    }))
  }

  const removeAnswer = (questionIndex, answerIndex) => {
    setExam(prev => ({
      ...prev,
      questions_attributes: prev.questions_attributes.map((q, i) => 
        i === questionIndex ? {
          ...q,
          answers_attributes: q.answers_attributes.filter((_, j) => j !== answerIndex)
        } : q
      )
    }))
  }

  const updateAnswer = (questionIndex, answerIndex, updates) => {
    setExam(prev => ({
      ...prev,
      questions_attributes: prev.questions_attributes.map((q, i) => 
        i === questionIndex ? {
          ...q,
          answers_attributes: q.answers_attributes.map((a, j) => {
            if (j === answerIndex) {
              return { ...a, ...updates }
            }
            if (q.question_type === 'single_choice' && updates.correct) {
              return { ...a, correct: false }
            }
            return a
          })
        } : q
      )
    }))
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    const formData = new FormData()
    formData.append('exam[title]', exam.title)
    formData.append('exam[start_date]', exam.start_date)
    formData.append('exam[end_date]', exam.end_date)
    exam.questions_attributes.forEach((question, index) => {
      formData.append(`exam[questions_attributes][${index}][content]`, question.content)
      formData.append(`exam[questions_attributes][${index}][question_type]`, question.question_type)
      formData.append(`exam[questions_attributes][${index}][points]`, question.points)
      formData.append(`exam[questions_attributes][${index}][evaluable]`, question.evaluable)
      question.answers_attributes.forEach((answer, answerIndex) => {
        formData.append(`exam[questions_attributes][${index}][answers_attributes][${answerIndex}][content]`, answer.content)
        formData.append(`exam[questions_attributes][${index}][answers_attributes][${answerIndex}][correct]`, answer.correct)
      })
    })

    fetch('/exams', {
      method: 'POST',
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      if (data.id) {
        window.location.href = `/exams/${data.id}`
      } else {
        console.error('Error creating exam:', data.errors)
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }

  return (
    <form onSubmit={handleSubmit} className="container mt-4">
      <Card className="mb-4">
        <CardHeader>
          <CardTitle>Crear Examen</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="mb-3">
            <Label htmlFor="title">Título</Label>
            <Input
              id="title"
              value={exam.title}
              onChange={e => setExam(prev => ({ ...prev, title: e.target.value }))}
              required
            />
          </div>
          <div className="row">
            <div className="col-md-6 mb-3">
              <Label htmlFor="start_date">Fecha de inicio</Label>
              <Input
                id="start_date"
                type="datetime-local"
                value={exam.start_date}
                onChange={e => setExam(prev => ({ ...prev, start_date: e.target.value }))}
                required
              />
            </div>
            <div className="col-md-6 mb-3">
              <Label htmlFor="end_date">Fecha de fin</Label>
              <Input
                id="end_date"
                type="datetime-local"
                value={exam.end_date}
                onChange={e => setExam(prev => ({ ...prev, end_date: e.target.value }))}
                required
              />
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="mb-4">
        {exam.questions_attributes.map((question, index) => (
          <Card key={index} className="mb-3">
            <CardHeader>
              <CardTitle>Pregunta {index + 1}</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="mb-3">
                <Textarea
                  value={question.content}
                  onChange={e => updateQuestion(index, { content: e.target.value })}
                  placeholder="Contenido de la pregunta"
                  required
                />
              </div>
              <div className="row mb-3">
                <div className="col-md-6">
                  <Label htmlFor={`questionType-${index}`}>Tipo de pregunta</Label>
                  <Select
                    value={question.question_type}
                    onChange={(e) => updateQuestion(index, { question_type: e.target.value })}
                  >
                    <SelectItem value="free_text">Texto libre</SelectItem>
                    <SelectItem value="multiple_choice">Opción múltiple</SelectItem>
                    <SelectItem value="single_choice">Opción única</SelectItem>
                  </Select>
                </div>
                <div className="col-md-6">
                  <Label htmlFor={`points-${index}`}>Puntos</Label>
                  <Input
                    id={`points-${index}`}
                    type="number"
                    value={question.points}
                    onChange={e => updateQuestion(index, { points: Number(e.target.value) })}
                    min="0"
                  />
                </div>
              </div>
              
              <div className="mb-3">
                <Checkbox
                  id={`evaluable-${index}`}
                  checked={question.evaluable}
                  onChange={(e) => updateQuestion(index, { evaluable: e.target.checked })}
                >
                  Pregunta evaluable
                </Checkbox>
              </div>
              
              {question.question_type !== 'free_text' && (
                <div className="mb-3">
                  <Label>Respuestas</Label>
                  {question.answers_attributes.map((answer, answerIndex) => (
                    <div key={answerIndex} className="d-flex align-items-center mb-2">
                      <Input
                        value={answer.content}
                        onChange={e => updateAnswer(index, answerIndex, { content: e.target.value })}
                        placeholder={`Respuesta ${answerIndex + 1}`}
                        required
                        className="me-2"
                      />
                      <Checkbox
                        checked={answer.correct}
                        onChange={(e) => updateAnswer(index, answerIndex, { correct: e.target.checked })}
                        className="me-2"
                      >
                        Correcta
                      </Checkbox>
                      <Button
                        type="button"
                        variant="destructive"
                        size="sm"
                        onClick={() => removeAnswer(index, answerIndex)}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  ))}
                  <Button type="button" variant="outline" onClick={() => addAnswer(index)}>
                    <PlusCircle className="h-4 w-4 me-2" />
                    Agregar Respuesta
                  </Button>
                </div>
              )}
              
              <Button type="button" variant="destructive" onClick={() => removeQuestion(index)}>
                Eliminar Pregunta
              </Button>
            </CardContent>
          </Card>
        ))}
        <Button type="button" onClick={addQuestion} variant="outline" className="w-100">
          <PlusCircle className="h-4 w-4 me-2" />
          Agregar Pregunta
        </Button>
      </div>

      <Button type="submit" className="w-100">Crear Examen</Button>
    </form>
  )
}