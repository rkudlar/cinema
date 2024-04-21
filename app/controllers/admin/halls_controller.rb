module Admin
  class HallsController < Admin::BaseController
    before_action -> { authorize(:hall) }
    before_action :load_halls, except: :build_chart
    before_action :load_hall, only: %i[update destroy]

    def index
      @hall = Hall.new
    end

    def create
      @hall = Hall.new(hall_params)
      if @hall.save
        flash[:success] = 'The hall has been created.'
        @hall = Hall.new
        render :index, status: :created
      else
        flash[:danger] = 'Something went wrong.'
        render :index, status: :unprocessable_entity
      end
    end

    def update
      if @hall.update(hall_params)
        flash[:success] = "The #{@hall.name} hall has been updated."
        @hall = Hall.new
        render :index, status: :see_other
      else
        flash[:danger] = 'Something went wrong.'
        @hall = Hall.new
        render :index, status: :unprocessable_entity
      end
    end

    def build_chart
      @hall = params[:hall]
    end

    def destroy
      if @hall.destroy
        flash[:success] = 'Hall successfully deleted.'
      else
        flash[:danger] = 'The hall cannot be deleted. It probably has active sessions.'
      end
      @hall = Hall.new
      render :index, status: :see_other
    end

    private

    def hall_params
      seats_scheme = params.dig(:hall, :scheme, :seats)
      params[:hall][:scheme][:seats] = JSON.parse(seats_scheme) if seats_scheme
      params.require(:hall).permit(:name, scheme: {})
    end

    def load_halls
      @halls = Hall.all
    end

    def load_hall
      @hall = Hall.find(params[:id])
    end
  end
end
