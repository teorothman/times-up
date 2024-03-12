import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["gamecode", "div", "copied"]
  connect() {
    console.log("Hello, clipboard!")
  }

  copy(event) {
    const text = this.gamecodeTarget.innerText
    const temp = document.body.appendChild(document.createElement('textarea'));
    temp.value = text;
    temp.select();
    document.execCommand('copy');
    document.body.removeChild(temp);
    console.log(this.copiedTarget)
    this.copiedTarget.classList.remove('hidden')
    setTimeout(() => {
      this.copiedTarget.classList.add('hidden')
    }, 1000)
  }



}
