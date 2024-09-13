// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import React from 'react'
import { createRoot } from 'react-dom/client'
import ExamCreator from './components/ExamCreator'

document.addEventListener('turbo:load', () => {
  const examCreatorContainer = document.getElementById('exam-creator')
  if (examCreatorContainer && !examCreatorContainer.hasAttribute('data-react-mounted')) {
    const examId = examCreatorContainer.getAttribute('data-exam-id')
    const root = createRoot(examCreatorContainer)
    root.render(React.createElement(ExamCreator, { examId: examId }))
    examCreatorContainer.setAttribute('data-react-mounted', 'true')
  }
})