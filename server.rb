require 'sinatra'
require 'sinatra/namespace'
require './game'


get '/' do
    "this is an API only server for SudokuDoer"
end


namespace '/api/v1' do 
    before do
        content_type 'application/json'
    end

    post '/complete' do 
        game = Game.new(:grid)
        solved = game.solve
    end

end

