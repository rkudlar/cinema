module Admin
  class MoviesController < Admin::BaseController
    before_action -> { authorize(:movie) }
    before_action :load_movies, only: %i[index new search create_with_tmdb]
    before_action :load_tmdb_movies, only: %i[new create_with_tmdb]
    before_action :load_movie, only: %i[edit update destroy]

    def new
      @movie = Movie.new
    end

    def create
      movie = Movie.new(movie_params)
      if movie.save
        flash[:success] = 'The movie has been added to our collection.'
        redirect_to admin_movies_path
      else
        flash.now[:danger] = 'Something went wrong.'
        render :new
      end
    end

    def create_with_tmdb
      @movie = TmdbConstructionService.call(external_id: params[:external_id])
      if @movie.save
        @movie = Movie.new
        flash.now[:success] = 'The movie has been copied to our collection.'
        render :new, status: :created
      else
        cookies[:active_movie_tab] = 'Add Manually'
        flash.now[:danger] = 'All required fields must be filled'
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @movie.update(movie_params)
        flash[:success] = 'The movie has been updated.'
        redirect_to admin_movies_path
      else
        flash.now[:danger] = 'Something went wrong.'
        render :new
      end
    end

    def search
      @search_list = TmdbApiService.call(action: :search, opts: { query: params[:query] }).dig('results')
    end

    def destroy
      if @movie.destroy
        flash[:success] = 'Movie successfully deleted'
      else
        flash[:danger] = @movie.errors.full_messages.join('. ')
      end
      redirect_to request.referer || admin_movies_path
    end

    private

    def movie_params
      params.require(:movie).permit(:title, :description, :duration, :release_date, countries: [], directors: [], actors: [], genre: [])
    end

    def load_movies
      @movies ||= Movie.all
    end

    def load_tmdb_movies
      @now_playing_list = TmdbApiService.call(action: :now_playing).dig('results')
      @upcoming_list = TmdbApiService.call(action: :upcoming).dig('results')
    end

    def load_movie
      @movie = Movie.find(params[:id])
    end
  end
end
