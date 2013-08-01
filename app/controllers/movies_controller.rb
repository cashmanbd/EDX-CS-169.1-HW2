class MoviesController < ApplicationController

  attr_accessor :all_ratings
  attr_reader :selected_ratings

  def initialize(*args, &block)
    super
    @all_ratings = ['G','PG','PG-13','R']
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   if !session[:stored_selections].present?
     session[:stored_selections] = @all_ratings
   end
   @selected_ratings = (params[:ratings].present? ? params[:ratings].keys : session[:stored_selections])
   session[:stored_selections] = @selected_ratings
    puts "after #{@selected_ratings}"
   all_movies = Movie.all
   if params[:sort]
     @current_item = params[:sort] == "title" ? "title_header" : "release_date_header"
     all_movies = Movie.order(params[:sort])
   end
     temp_movies = Array.new
     all_movies.each do | movie |
        if @selected_ratings.include?(movie.rating)
          temp_movies.push movie
          puts "saving #{movie}"
        end
        @movies = temp_movies
     end

   # @movies = Movie.where(:rating => params[:ratings].keys) if params[:ratings].present?
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
