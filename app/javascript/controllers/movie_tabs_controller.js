import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  setLastActiveTab(event) {
    event.preventDefault();
    document.cookie = "active_movie_tab=" + event.currentTarget.textContent.trim() + ";path=/";
  }
}
