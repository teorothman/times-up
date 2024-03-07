import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="about-us"
export default class extends Controller {
  static targets = ["user", "all"]

  connect() {
  }

  showAsFirstPicture(event) {
    this.allTarget.style.opacity = "0";
    this.allTarget.style.visibility = "hidden";

    this.userTargets.forEach((user) => {
      user.style.opacity = "0";
      user.style.visibility = "hidden";
    });


    this.userTargets.forEach((user) => {
      if (event.currentTarget.dataset.name === user.dataset.name) {
        setTimeout(() => {
          user.style.opacity = "1";
          user.style.visibility = "visible";
        }, 10);
      }
    })
  }
}
