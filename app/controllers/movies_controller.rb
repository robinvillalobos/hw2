class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def getRatings
	@all_ratings = Array.new

	ratings = Movie.find(:all, :select => "DISTINCT rating")

	ratings.each do |mov| 
		@all_ratings << mov.rating
	end 
  end

  def index
	
	getRatings
 	myWhere = Array.new
	if params[:ratings].respond_to?(:each) 
		
		
		params[:ratings].each_key do |key|
			myWhere << key.to_s
		end
	
	end

	if params[:type]=='Title'
		if myWhere.length > 0 
			@movies = Movie.where(:rating => myWhere).find(:all, :order => 'title')		
		else
				
			@movies = Movie.find(:all, :order => 'title')
		end
		@title_header = 'hilite'
		@release_date_header = ''

	elsif params[:type]=='Date'
		if myWhere.length > 0
			@movies = Movie.where(:rating => myWhere).find(:all, :order => 'release_date')
		else
			@movies = Movie.find(:all, :order => 'release_date')
		end		
		@release_date_header = 'hilite'
		@title_header = ''	    
	else
		if myWhere.length > 0
			@movies = Movie.where(:rating => myWhere)
		else
			@movies = Movie.all
		end
		
		@title_header = ''
		@release_date_header = ''
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
