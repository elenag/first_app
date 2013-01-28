class BooksController < ApplicationController
  
  def index
  	search
  	render('search')
  end

  def search
  	@status = BookStatus.find_by_name("Published")
 
    @books = @status.books

    @br = Book.search(params[:search])
    @articles = @br.all
  end

  def show
    @book = Book.find(params[:id])
    @author = Author.find(@book.author_ids[0]).name
    @publisher = Publisher.find(@book.publisher_id).name

  end

  # def add
  #   @book = Book.find(params[:id])
  # end
end

  