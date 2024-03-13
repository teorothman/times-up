import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="game"
export default class extends Controller {
  static values = {gameId: Number, userId: Number}
  static targets = ["container"]
  connect() {
    this.gameChannel = createConsumer().subscriptions.create(
      {channel: 'GameChannel', id: this.gameIdValue },
      { received: data => {
        console.log(this.userIdValue)
        if (data.partial === "avatar") {
          document.getElementById("pre-lobby-grid").insertAdjacentHTML("beforeend", data.html);
        } else if (data.partial === "lobby") {
          this.containerTarget.innerHTML = data.html;
          window.location.reload(true);
        } else if (data.partial === "player_selected" && data.user != this.userIdValue) {
          this.containerTarget.innerHTML = data.html
        }
      }
    }
    )
     this.playerChannel = createConsumer().subscriptions.create(
       {channel: 'PlayerChannel', id: this.userIdValue },
       { received: data => {
        console.log("player")
        this.containerTarget.innerHTML = data.html
       }
     }
     )
  }
}




// else if (data.partial === "loading") {
//   this.containerTarget.innerHTML = data.html;
//   setTimeout(() => {
//     window.location.reload(true);
//   }, 3000);
