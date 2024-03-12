import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="game"
export default class extends Controller {
  static values = {gameId: Number}
  static targets = ["container"]
  connect() {
    this.channel = createConsumer().subscriptions.create(
      {channel: 'GameChannel', id: this.gameIdValue },
      { received: data => document.getElementById("pre-lobby-grid").insertAdjacentHTML("beforeend", data.html) }
    )
  }
}
