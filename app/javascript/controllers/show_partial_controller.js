import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-partial"
export default class extends Controller {
  static targets = ["container", 'grid']

  connect() {
  }

  showPartial(event) {
    fetch('/show_qr')
      .then(response => response.text())
      .then(html => {
        this.containerTarget.innerHTML = html
      })
    this.gridTarget.classList.add("hidden")
    event.target.classList.add("hidden")
  }

  hidePartial() {
    this.element.innerHTML = ""
    const grid = document.getElementById("pre-lobby-grid")
    const button = document.getElementById("show-qr-btn")
    grid.classList.remove("hidden")
    button.classList.remove("hidden")
  }
}
