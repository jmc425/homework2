class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sorted_by_title, @sorted_by_release_date = false
    @all_ratings = Movie.get_distinct_ratings.sort!
    
    
    if params[:ratings] == nil
      ratings = @all_ratings
    else
      ratings = params[:ratings].keys
    end    
    
    if params[:sort_by] == nil
      @movies = Movie.find :all, :conditions => { :rating => ratings }
    else
      @movies = Movie.order(params[:sort_by] + " ASC").
        find :all, :conditions => { :rating => ratings }
      instance_variable_set "@sorted_by_#{params[:sort_by]}", true
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
