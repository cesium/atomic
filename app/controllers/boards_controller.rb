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
    @board = Board.new(params.require(:board).permit(:year))

    @board.save
    redirect_to @board
  end
end
