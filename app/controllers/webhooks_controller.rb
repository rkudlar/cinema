class WebhooksController < ApplicationController
  include BookingMethods

  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Settings.stripe.signing_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: { message: e.message }}, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: { message: e.message, extra: "Sig verification failed" }}, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when 'checkout.session.completed'
      metadata = event.data.object.metadata
      scheme = JSON.parse(metadata.scheme)
      tickets = JSON.parse(metadata.tickets)
      session = Session.find(metadata.id)

      update_session(session, scheme)
      book_tickets(tickets, metadata.id, metadata.user_id)

      expire_payment_session(scheme, metadata.id)
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end
end
