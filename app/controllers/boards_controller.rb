class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board  = Board.find(params[:id])
  end

  def new
  end

  def create
    @board = Board.new(params.require(:board).permit(:start_date, :end_date))

    @board.save
    redirect_to boards_path
  end

  def destroy
    board = Board.find(params[:id])
    terms = board.terms

    # Destroy board terms.
    terms.each do |term|
      term.destroy
    end

    # Destroy board.
    board.destroy

    redirect_to boards_path
  end
end
