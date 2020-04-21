class Api::V1::MoviesController < ApplicationController

  def index
    @movies = Movie.all
    render json: @movies
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie
    else
      render error: {error: "Unable to create movie."}, status: 400
    end
  end

  def show
    @movie = Movie.find_by(id: params[:id])
    render json: @movie
  end

  def update
    @movie = Movie.find_by(id: params[:id])
    if @movie
      @movie.update(movie_params)
      render json: {message: "Movie updated successfully."}, status: 200
    else
      render json: {error: "Unable to update the movie."}, status: 400
    end
  end

  def destroy
    @movie = Movie.find_by(id: params[:id])
    if @movie
      @movie.destroy
      render json: {message: "Movie deleted successfully."}, status: 200
    else
      render json: {error: "Unable to delete the movie."}, status: 400
    end
  end

  def best_seat_available
    available_seat = {}
    total_rows = params["venue"]["layout"]["rows"]
    total_column = params["venue"]["layout"]["columns"]
    position_alpha = get_position(total_rows)
    seat_requested = params["seat_requested"]
    middle = (total_column.to_f/2).round
    ('a'..position_alpha).each_with_index do |row, index|
      row_index = index+1
      (1..total_column).each_with_index do |column, col_index|
        key = row + column.to_s
        seat =  params["seats"][key]
        position = get_available_seat(column, total_column, row_index, middle)
        # position = (center1+row_index) - column if center1 >= column
        # position = (column+row_index) - center2 if column >= center2
        available_seat["#{key}"] = position if seat["status"] == "AVAILABLE"
      end
      @data = available_seat.sort_by {|_key, value| value}
    end
    data_val = Hash[@data.to_a[0,seat_requested]].map {|key, value| key}
    render json: {seat_available: data_val, status: "successful"}
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :summary, :year, :genre, :imdb_link)
  end

  def get_position(position)
    alfa = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    alfa.each_with_index do |alphabate, index|
      return alphabate if index+1 == position
    end
  end

  def get_available_seat(column, total_column, row_index, middle)
    if total_column.even?
      center1 = middle
      center2 = middle+1
      position = (center1+row_index) - column if center1 >= column
      position = (column+row_index) - center2 if column >= center2
      return position
    else
      center = middle
      position = (center+row_index) - column if center >= column
      position = (column+row_index) - center if column >= center
      return position
    end
  end
end
