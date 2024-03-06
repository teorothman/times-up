import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="about-us"
export default class extends Controller {
  static targets = ["user", "all"]

  connect() {
  }

  showAsFirstPicture(event) {
    this.allTarget.classList.add("d-none")
    this.userTargets.forEach((user) => {
      if (event.currentTarget.dataset.name === user.dataset.name) {
        user.classList.remove("d-none")
      } else {
        user.classList.add("d-none")
      }
    })
  }
}
