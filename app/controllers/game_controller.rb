class GameController < ApplicationController
    def index
    end
    
    def play
      @id = params[:id]
    end
end
