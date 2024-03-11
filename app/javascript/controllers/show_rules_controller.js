import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-rules"
export default class extends Controller {
  static targets = ["rules", "wrapper", "rulesbutton"]

  connect() {
  }

  show() {
    //this.wrapperTarget.classList.toggle("hidden")
    //this.rulesTarget.classList.toggle("hidden")
    console.log(this.rulesTarget)
    console.log(this.wrapperTarget)
    this.rulesTarget.classList.remove("hidden")
    this.wrapperTarget.classList.add("hidden")
    this.rulesbuttonTarget.classList.add("hidden")
  }

  next(event) {
    console.log(event)
    //event.currentarget.nextElementSibling.classList.remove("hidden")
    const dataName = event.currentTarget.dataset.name
    const currentDiv = document.querySelector(`[data-name="${dataName}"]`)
    currentDiv.classList.add("hidden")
    currentDiv.nextElementSibling.classList.remove("hidden")
  }

  back(event) {
    console.log(event)
    const dataName = event.currentTarget.dataset.name
    const currentDiv = document.querySelector(`[data-name="${dataName}"]`)
    currentDiv.classList.add("hidden")
    currentDiv.previousElementSibling.classList.remove("hidden")
  }

  hide() {
    this.rulesTarget.classList.add("hidden")
    this.wrapperTarget.classList.remove("hidden")
    this.rulesbuttonTarget.classList.remove("hidden")
  }
}
