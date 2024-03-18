import { Controller } from "@hotwired/stimulus";
import { createConsumer } from "@rails/actioncable";

// Connects to data-controller="game"
export default class extends Controller {
  static values = { gameId: Number, userId: Number };
  static targets = ["container", "user"];

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
          } else if (data.action === 'user_ready') {
            console.log('User ready action received:', data);
            this.updateUserReadyState(data.user_id, data.is_ready);
          } else if (data.partial === 'cards') {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "player_selected") {
            this.containerTarget.innerHTML = data.html;
          }  else if (data.partial === "player_plays") {
            this.containerTarget.innerHTML = data.html;
            this.initializeTimer();
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
            this.initializeTimer();
          } else if (data.partial === "player_score_playing") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "card_playing") {
            document.querySelector(".word-wrapper").innerHTML = data.html;
            // this.wordwrapperTarget.innerHTML = data.html;
            console.log(data);
          } else if (data.partial === "player_score_playing") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "round1_results") {
            this.containerTarget.innerHTML = data.html;
          }else if (data.partial === "round2_results") {
            this.containerTarget.innerHTML = data.html;
          }else if (data.partial === "round3_results") {
            this.containerTarget.innerHTML = data.html;
          } else if (data.partial === "player_plays_playing_skipped") {
            // this.wordwrapperTarget.innerHTML = data.html;
            document.querySelector(".word-wrapper").innerHTML = data.html;
          }
        }
      }
    );
  }
  showNextButton() {
    if (document.getElementById('next-button') != null) {
    document.getElementById('next-button').classList.remove('hidden');
    }
  }

  hideButtons() {
    if (document.querySelectorAll('.play-button') != null) {
      document.querySelectorAll('.play-button').forEach(button => {
      button.classList.add('hidden');
    })}
  }

  hideTimer() {
  if (document.getElementById('timer-container') != null) {
  document.getElementById('timer-container').style.display = 'none';
  }}

  initializeTimer() {
    let timeLeft = 10;
    const timerElement = document.getElementById('timer');

    timerElement.innerText = timeLeft;

    const updateTimer = () => {
      if (timeLeft <= 0) {
        clearInterval(countdown);
        this.showNextButton();
        this.hideButtons();
        this.hideTimer();
      } else {
        timerElement.innerText = timeLeft;
        timeLeft -= 1;
      }
    };

    updateTimer();

    const countdown = setInterval(updateTimer, 1000);
  }


  updateUserReadyState(userId, isReady) {
    console.log(`Attempting to update user ${userId} ready state to ${isReady}`);
    const userElement = document.querySelector(`[data-user-id='${userId}']`);
    console.log('User Element:', userElement);

    if (!userElement) {
      console.log(`User element not found for ID: ${userId}`);
      return;
    }
    if (!userElement) return;

    let tickElement = userElement.querySelector('.black');

    if (isReady) {
        tickElement = document.createElement('div');
        tickElement.classList.add('black');
        tickElement.innerHTML = '<p><i class="fa-solid fa-check"></i></p>';
        userElement.appendChild(tickElement);
        console.log('Tick added for user:', userId);
      } else if (!isReady && tickElement) {
        tickElement.remove();
        console.log('Tick removed for user:', userId)
      }
    }
}
