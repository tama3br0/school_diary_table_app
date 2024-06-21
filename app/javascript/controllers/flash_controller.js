import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      const flashMessages = document.getElementById('flash_messages')
      if (flashMessages) {
        flashMessages.style.display = 'none'
      }
    }, 5000)
  }
}
