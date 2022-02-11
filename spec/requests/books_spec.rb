require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title: '1994', author: 'George Orwell')
      FactoryBot.create(:book, title: 'Game of thrones', author: 'George Margin')
    end
    it 'returns all books' do
  
      get '/api/v1/books'
  
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
  describe 'POST /books' do
    it 'create new book' do
      expect {
        post '/api/v1/books', params: { 
          book: {titile: 'The Martian'},
          author: { first_name: 'Andy', last_name: 'Bowel', age: '32'}
         }
      }.to change { Book.count }.from(0).to(1)

      expect(:response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(JSON.parse(response.body)).to eq(
        {
          'id': 1,
          'name': 'The Martian',
          'author_name': 'Andy Bowel',
          'author_age': '32'
        }
    )
      
    end
  end

  describe 'DELETE /books/:id' do
    let!(:book) { FactoryBot.create(:book, title: '1994', author: 'George Orwell') }
    
    it 'deletes a book' do
      expect {
        delete "/api/v1/books/1/#{book.id}"
      }.to change { Book.count }.from(1).to(0)


      expect(response).to have_http_status(:no_content)
    end
  end
end