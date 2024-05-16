module BookingMethods
  extend ActiveSupport::Concern

  def update_session(session, scheme)
    scheme.each do |row, columns|
      columns.each do |column|
        session.seats_data[row][column]['booked'] = true
      end
    end
    session.save
  end

  def book_tickets(tickets, session_id, user_id = nil)
    tickets.each do |row, seats|
      seats.each do |seat|
        Ticket.create!(row: row, seat: seat, session_id: session_id , user_id: user_id)
      end
    end
  end

  def expire_payment_session(scheme, session_id)
    Stripe::Checkout::Session.list({status: 'open', limit: 100}).each do |checkout|
      Stripe::Checkout::Session.expire(checkout.id) if tickets_conflict?(checkout, scheme, session_id)
    end
  end

  private

  def tickets_conflict?(checkout, scheme, session_id)
    return false if session_id != checkout.metadata.id
    JSON.parse(checkout.metadata.scheme).each do |row, columns|
      columns.each do |column|
        return true if scheme[row]&.include?(column)
      end
    end

    false
  end
end
