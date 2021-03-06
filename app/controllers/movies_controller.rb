class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index   
    if params[:ratings] == nil and params[:sort_by] == nil
      redirect_to_movies_path if session[:ratings] != nil and session[:sort_by] != nil
      redirect_to_movies_path(session[:ratings], nil) if session[:ratings] != nil and 
        session[:sort_by] == nil
      redirect_to_movies_path(@all_ratings) if session[:ratings] == nil and session[:sort_by] != nil
      redirect_to_movies_path(@all_ratings, nil) if session[:ratings] == nil and 
        session[:sort_by] == nil
    elsif params[:ratings] == nil
      redirect_to_movies_path(session[:ratings], params[:sort_by]) if session[:ratings] != nil
      redirect_to_movies_path(@all_ratings, params[:sort_by])
    elsif params[:sort_by] == nil
      redirect_to_movies_path(params[:ratings]) if session[:sort_by] != nil
    end
    
    @all_ratings = Movie.get_distinct_ratings.sort!
    @ratings = params[:ratings] if params[:ratings].is_a? Array
    @ratings = params[:ratings].keys if params[:ratings].is_a? Hash
    @ratings = @all_ratings if @ratings == nil or @ratings.empty?
    
    if params[:sort_by] == nil
      @movies = Movie.find :all, 
        :conditions => { :rating => @ratings }
    elsif Movie.column_names.include? params[:sort_by]
      @movies = Movie.order(params[:sort_by] + " ASC").
        find :all, :conditions => { :rating => @ratings }
      instance_variable_set "@sorted_by_#{params[:sort_by]}", true
    end
    
    session[:ratings] = @ratings
    session[:sort_by] = params[:sort_by]
  end
  
  def redirect_to_movies_path(ratings=session[:ratings], sort_by=session[:sort_by])
    flash.keep
    redirect_to movies_path(Hash[:ratings => ratings, :sort_by => sort_by])
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
