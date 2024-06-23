import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeForm()
  }

  initializeForm() {
    const roleButtons = this.element.querySelectorAll("#role-buttons button")
    const gradeButtons = this.element.querySelectorAll("#grade-buttons button")
    const classButtons = this.element.querySelectorAll("#class-buttons button")
    const roleInput = this.element.querySelector("#user_role")
    const gradeInput = this.element.querySelector("#user_grade")
    const classNumInput = this.element.querySelector("#user_class_num")
    const schoolCodeInput = this.element.querySelector("#user_school_code")
    const nameInput = this.element.querySelector("#user_name")
    const studentNumInput = this.element.querySelector("#user_student_num")
    const teacherNameField = this.element.querySelector("#teacher-name")
    const studentNumField = this.element.querySelector("#student-num")

    function toggleFields() {
      const role = roleInput.value
      if (role === "teacher") {
        teacherNameField.style.display = "block"
        studentNumField.style.display = "none"
      } else if (role === "student") {
        teacherNameField.style.display = "none"
        studentNumField.style.display = "block"
      } else {
        teacherNameField.style.display = "none"
        studentNumField.style.display = "none"
      }
    }

    roleButtons.forEach(button => {
      button.addEventListener("click", function() {
        roleButtons.forEach(btn => btn.classList.remove("active"))
        button.classList.add("active")
        roleInput.value = button.dataset.role
        toggleFields()
      })
    })

    gradeButtons.forEach(button => {
      button.addEventListener("click", function() {
        gradeButtons.forEach(btn => btn.classList.remove("active"))
        button.classList.add("active")
        gradeInput.value = button.dataset.grade
      })
    })

    classButtons.forEach(button => {
      button.addEventListener("click", function() {
        classButtons.forEach(btn => btn.classList.remove("active"))
        button.classList.add("active")
        classNumInput.value = button.dataset.classNum
      })
    })

    toggleFields() // 初期表示のために呼び出す

    this.element.querySelector(".additional-info-form").addEventListener("submit", function(event) {
      let valid = true
      let errorMessage = ""

      if (!schoolCodeInput.value.trim()) {
        valid = false
        errorMessage += "がっこうコードを せんせいに きいて にゅうりょくしてください。\n"
      }
      if (!roleInput.value.trim()) {
        valid = false
        errorMessage += "「せんせい」か「こども」かを、えらんでください。\n"
      }
      if (roleInput.value === "teacher" && !nameInput.value.trim()) {
        valid = false
        errorMessage += "先生の場合、名前を入力してください。\n"
      }
      if (roleInput.value === "student") {
        if (!gradeInput.value.trim()) {
          valid = false
          errorMessage += "なんねんせいかを えらんでください。\n"
        }
        if (!classNumInput.value.trim()) {
          valid = false
          errorMessage += "なんくみかを えらんでください。\n"
        }
        if (!studentNumInput.value.trim()) {
          valid = false
          errorMessage += "しゅっせきばんごうを えらんでください。\n"
        }
      }

      if (!valid) {
        event.preventDefault()
        alert(errorMessage)
      }
    })
  }
}
