import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['rowsCount', 'columnsCount', 'seatsScheme', 'hallId']

  buildSeats() {
    const rows_count = this.rowsCountTarget.value
    const columns_count = this.columnsCountTarget.value

    const seats = {}

    for (let i = 1; i <= rows_count; i++) {
      seats[`row_${i}`] = Array(Number(columns_count)).fill(true);
    }

    const data = {
      hall: {
        id: this.hallIdTarget.value,
        scheme: {
          columns_count: columns_count,
          rows_count: rows_count,
          seats
        }
      }
    }

    fetch('/admin/halls/build_chart', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content")
      },
      body: JSON.stringify(data) })
      .then((response) => response.text()).then((html) => {
        Turbo.renderStreamMessage(html);
      })
  }

  changeSeat(e) {
    const seatsScheme = JSON.parse(this.seatsSchemeTarget.value);
    const row = `row_${e.target.dataset.row}`
    const column = Number(e.target.dataset.column)

    e.target.classList.toggle('space');
    seatsScheme[row][column] = !seatsScheme[row][column]

    this.seatsSchemeTarget.value = JSON.stringify(seatsScheme);
  }
}
