import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  addField(event) {
    event.preventDefault();
    let input = this.contentTarget.querySelector("input").cloneNode()
    input.value = ""
    this.contentTarget.append(input)
  }
}
