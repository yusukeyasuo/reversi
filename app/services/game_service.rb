class GameService

  def initialize(game)
    @game = game
    @opponent = @game.senko ? 2 : 1
    @game_detail = game.latest_game_detail
    @formation_array = JSON.parse(@game_detail.formation)
  end
  
  # そのマスに置いた際のアクション
  def move(x, y)
    pp "===> GameService.move: #{x}, #{y}"
    # 置けるかの確認
    movable = movable?(x, y) 

    # TODO 置いた後のGameDetailを算出
    
    movable
  end

  # そのマスに置けるかどうかを判定する
  def movable?(x, y)
    # 隣のマスの一覧を取得
    next_masses = next_masses(x, y)
    
    # x, yに置いた際にひっくり返せるか各方向にて確認
    next_masses.each_with_index do |mass, i|
      # 一方向でもひっくり返せることがわかればtrueを返す
      return true if sandwitch?(mass, i)
    end
    false
  end
  
  def next_masses(x, y)
    masses = Array.new(8, nil)
    masses.each_with_index do |mass, i|
      masses[i] = next_mass(x, y, i)
    end
  end
  
  def next_mass(x, y, i)
    mass = nil
    case i
    when 0 then
      mass = { x: x, y: y - 1 } if in_field?(x, y - 1)
    when 1 then
      mass = { x: x + 1, y: y - 1 } if in_field?(x + 1, y - 1)
    when 2 then
      mass = { x: x + 1, y: y } if in_field?(x + 1, y)
    when 3 then
      mass = { x: x + 1, y: y + 1 } if in_field?(x + 1, y + 1)
    when 4 then
      mass = { x: x, y: y + 1 } if in_field?(x, y + 1)
    when 5 then
      mass = { x: x - 1, y: y + 1 } if in_field?(x - 1, y + 1)
    when 6 then
      mass = { x: x - 1, y: y } if in_field?(x - 1, y)
    when 7 then
      mass = { x: x - 1, y: y - 1 } if in_field?(x - 1, y - 1)
    end
    mass
  end
  
  def sandwitch?(mass, i)
    # マスがnil（枠外）ならfalseを返す
    return false if mass.nil?
    # マスが自分と同じ石、または何も置かれていなければfalseを返す
    is_opponent = @formation_array[mass[:x]][mass[:y]].to_i == @opponent
    return false unless is_opponent
    
    # 連続する石を確認
    while is_opponent do
      mass = next_mass(mass[:x], mass[:y], i)
      # マスがnil（枠外）ならfalseを返す
      return false if mass.nil?
      # マスに何も置かれていなければfalseを返す
      return false if @formation_array[mass[:x]][mass[:y]].nil?
      is_opponent = @formation_array[mass[:x]][mass[:y]].to_i == @opponent
    end
    true
  end
  
  def in_field?(x, y)
    return true if x >= 0 && x <= 7 && y >= 0 && y <= 7
    false
  end
end
