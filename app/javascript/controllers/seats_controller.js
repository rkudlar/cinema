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

  selectSeat(e) {
    const selectedTickets = document.getElementById('selected-tickets')
    const row = e.target.dataset.row
    const column = e.target.dataset.column
    const cardId = `${row}_${column}`

    e.target.classList.toggle('selected');
    if (e.target.classList.contains('selected')) {
      const card = document.createElement('div');
      card.className = 'card mb-2';
      card.id = cardId
      card.dataset.row = row
      card.dataset.column = column
      card.dataset.rowNumber = e.target.dataset.rowNumber
      card.dataset.seatNumber = e.target.dataset.seatNumber

      const cardBody = document.createElement('div');
      cardBody.className = 'card-body row';

      const placeCol = document.createElement('div');
      placeCol.className = 'col';
      placeCol.textContent = `Row: ${e.target.dataset.rowNumber}, Seat: ${e.target.dataset.seatNumber}`

      const priceCol = document.createElement('div');
      priceCol.className = 'col-4 border-start';
      priceCol.textContent = `Price: ${e.target.dataset.price}`

      cardBody.appendChild(placeCol)
      cardBody.appendChild(priceCol)
      card.appendChild(cardBody)
      selectedTickets.appendChild(card)
    } else {
      selectedTickets.removeChild(document.getElementById(cardId));
    }
  }

  bookSeat(e) {
    const tickets = document.getElementById('selected-tickets').childNodes
    const data = { scheme:{}, tickets:{} }

    tickets.forEach(e => {
      const row = e.dataset.row
      const column = e.dataset.column
      const rowNumber = e.dataset.rowNumber
      const seatNumber = e.dataset.seatNumber

      if (!data["scheme"][row]) {
        data["scheme"][row] = [];
        data["tickets"][rowNumber] = [];
      }

      data["scheme"][row].push(column)
      data["tickets"][rowNumber].push(seatNumber)
    })

    fetch(`/admin/sessions/${e.target.dataset.sessionId}/book`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute("content")
      },
      body: JSON.stringify(data)
    }).then((response) => response.text()).then((html) => {
      document.documentElement.innerHTML = html;
    })
  }
}
