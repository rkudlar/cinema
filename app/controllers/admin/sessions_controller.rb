class Admin::SessionsController < Admin::BaseController
  include BookingMethods

  before_action -> { authorize(:session) }
  before_action :prepare_values, except: %i[tickets book]
  before_action :load_session, only: %i[destroy update tickets]

  def index;end

  def create
    session = Session.new(session_params)
    if params[:repeat]
      create_repeated_sessions(session)
    else
      if session.save
        flash.now[:success] = 'Session successfully created'
      else
        flash.now[:danger] = session.errors.full_messages.join('. ')
      end
    end
    render :index, status: :see_other
  end

  def update
    if @session.update(session_params)
      flash.now[:success] = 'Session successfully updated.'
    else
      flash.now[:danger] = @session.errors.full_messages.join('. ')
    end
    @session = Session.new
    render :index, status: :see_other
  end

  def destroy
    if @session.destroy
      flash.now[:success] = 'Session successfully deleted.'
    else
      flash.now[:danger] = @session.errors.full_messages.join('. ')
    end
    @session = Session.new
    render :index, status: :see_other
  end

  def tickets
    @session = Session.find(params[:id])
  end

  def book
    @session = Session.find(params[:id])
    if params[:scheme].present? && params[:tickets].present?
      unless @session.tickets_available?(params[:scheme])
        flash.now[:danger] = 'Tickets not available'
        render :tickets
        return
      end

      ActiveRecord::Base.transaction do
        expire_payment_session(params[:scheme], params[:id])

        update_session(@session, params[:scheme])
        book_tickets(params[:tickets], params[:id])

        flash.now[:success] = 'Tickets successfully booked'
      rescue => e
        flash.now[:danger] = e.message
      end
    else
      flash.now[:danger] = 'Select at least one seat first'
    end

    render :tickets
  end

  private

  def session_params
    params.require(:session).permit(:movie_id, :hall_id, :price, :start_datetime)
  end

  def prepare_values
    @sessions = Session.available.includes(:movie, :hall).order(:start_datetime, :hall_id)
    @session = Session.new
    @halls = Hall.all
    @movies = Movie.all
  end

  def load_session
    @session = Session.find(params[:id])
  end

  def create_repeated_sessions(session)
    repeat_to = Date.new(*params.fetch(:session).slice(:'repeat_to(1i)', :'repeat_to(2i)', :'repeat_to(3i)').values.map(&:to_i))
    if repeat_to > session.start_datetime.to_date
      begin
        Session.transaction do
          (session.start_datetime.to_date..repeat_to).each do |date|
            Session.create!(session_params.merge('start_datetime(1i)': date.year.to_s, 'start_datetime(2i)': date.month.to_s, 'start_datetime(3i)': date.day.to_s))
          end
        end
        flash.now[:success] = 'Sessions successfully created'
      rescue => e
        flash.now[:danger] = e.message
      end
    else
      flash.now[:danger] = 'Please select a valid date range'
    end
  end
end
