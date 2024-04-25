import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  switchDisplayNone() {
    this.inputTargets.forEach((e) => e.classList.toggle('d-none'));
  }
}
