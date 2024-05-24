class MovieSessionsController < ApplicationController
  def index
    @movies = Movie.joins(:sessions).merge(Session.available).distinct
  end

  def show
    @movie = Movie.find(params[:id])
    @sessions_by_date = @movie.sessions.available.order(:start_datetime).group_by { |session| session.start_datetime.to_date }
    @session = @sessions_by_date.values.first.first
  end

  def swap
    @session = Session.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('seats-chart', partial: '/movie_sessions/seats_chart', locals: { admin: false })
      end
    end
  end

  def payment
    unless current_user
      flash[:danger] = 'You must log in before purchasing tickets'
      render json: { redirect_to: new_user_session_path }
      return
    end

    @session = Session.find(params[:id])

    unless @session.tickets_available?(params[:scheme])
      flash[:danger] = 'Tickets not available'
      render json: { redirect_to: movie_session_url(@session.movie) }
      return
    end

    checkout = Stripe::Checkout::Session.create(
      customer: current_user.stripe_customer,
      line_items: stripe_products,
      metadata: stripe_metadata,
      payment_intent_data: { metadata: stripe_metadata },
      mode: 'payment',
      success_url:  my_tickets_url,
      cancel_url: movie_session_url(@session.movie)
    )
    render json: { redirect_to: checkout.url }
  end

  private

  def stripe_products
    params['tickets'].to_unsafe_h.map do |row, seats|
      seats.map do |seat|
        { price_data: { currency: 'usd', unit_amount: (@session.price * 100).to_i, product_data: { name: "Ticket to: #{@session.movie.title}", description: "#{@session.hall.name} | Row: #{row}, Seat: #{seat} | #{@session.start_datetime.strftime("%d.%m.%Y %H:%M")}" } }, quantity: 1 }
      end
    end.flatten
  end

  def stripe_metadata
    params.slice(:scheme, :tickets, :id).to_unsafe_h.transform_values{|v| v.is_a?(Hash) ? v.to_json : v}.merge(user_id: current_user.id)
  end
end
