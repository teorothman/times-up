import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

// Connects to data-controller="game"
export default class extends Controller {
  static values = { gameId: Number, userId: Number };
  static targets = ["container"];

  connect() {
    this.gameChannel = createConsumer().subscriptions.create(
      { channel: 'GameChannel', id: this.gameIdValue },
      {
        received: data => {
          if (data.partial === "avatar") {
            document.getElementById("pre-lobby-grid").insertAdjacentHTML("beforeend", data.html);
          } else if (data.partial === "lobby") {
            this.containerTarget.innerHTML = data.html;
            window.location.reload(true);
          } else if (data.partial === "player_selected") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "player_plays") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "player_score") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "round1_results") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "round2_results") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "round3_results") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "results") {
            this.containerTarget.innerHTML = data.html;
          }
        }
      }
    );

    this.playerChannel = createConsumer().subscriptions.create(
      { channel: 'PlayerChannel', id: this.userIdValue },
      {
        received: data => {
          if (data.partial === "player_selected_playing") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "player_plays_playing") {
            this.containerTarget.innerHTML = data.html;
            console.log("this is player broadcast");
          } else if (data.partial === "player_score_playing") {
            this.containerTarget.innerHTML = data.html;
          }
        }
      }
    );
  }
}
