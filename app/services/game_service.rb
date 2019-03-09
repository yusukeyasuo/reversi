class GameService

  def initialize(game)
    @game = game
  end
  
  def move(x, y)
    pp "===> GameService.move"
    pp x
    pp y
  end
end
