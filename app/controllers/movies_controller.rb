class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_distinct_ratings.sort!
    
    if params[:ratings] != nil
      @selected_ratings = params[:ratings].keys
    elsif params[:selected_ratings] != nil
      @selected_ratings = params[:selected_ratings]
    else
      @selected_ratings = @all_ratings
    end
    
    if params[:sort_by_title] == "true"
      @movies = Movie.order("title ASC").
        find :all, :conditions => { :rating => @selected_ratings }
      @sorted_by_title = true
    elsif params[:sort_by_release_date] == "true"
      @movies = Movie.order("release_date ASC").
        find :all, :conditions => { :rating => @selected_ratings }
      @sorted_by_release_date = true
    else
      @movies = Movie.find :all, :conditions => { :rating => @selected_ratings }
    end
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
