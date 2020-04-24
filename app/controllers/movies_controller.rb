class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    @ratings = Movie.with_ratings
    
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    @movies_all = Movie.where(rating: @selected_ratings.keys)
    
    if params[:ratings] != session[:ratings]
      
      session[:ratings] = @selected_ratings
      redirect_to :ratings => @selected_ratings and return
    end
    
    if params[:sort_name].nil?
      @movies = @movies_all
    else
    @movies = @movies_all.order("#{params[:sort_name]} ASC")
    @highlight = params[:sort_name]
    end 
    
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def moviesort
    @movie = Movie.all
    @movies = @movie.order("title ASC")
    @all_ratings = ['G','PG','PG-13','R']
  end 
  
  def datesort
    @movie = Movie.all
    @movies = @movie.order("release_date ASC")
    @all_ratings = ['G','PG','PG-13','R']
  end 
  
end
