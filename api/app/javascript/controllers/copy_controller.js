import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "defaultIcon", "successIcon"]
  static values = {
    text: String
  }

  connect() {
    if (this.hasTextValue) {
      this.inputTarget.value = this.textValue
    }
  }

  copy() {
    this.inputTarget.select()
    document.execCommand("copy")
    
    // Show success state
    this.buttonTarget.dataset.state = "success"
    this.buttonTarget.classList.add('bg-green-500')
    this.defaultIconTarget.classList.add('hidden')
    this.successIconTarget.classList.remove('hidden')
    
    // Reset after 3 seconds
    setTimeout(() => {
      this.buttonTarget.dataset.state = "default"
      this.buttonTarget.classList.remove('bg-green-500')
      this.defaultIconTarget.classList.remove('hidden')
      this.successIconTarget.classList.add('hidden')
    }, 3000)
  }
} 
