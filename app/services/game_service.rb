class GameService

  def initialize(game)
    @game = game
    @opponent = @game.senko ? 2 : 1
    @me = @opponent == 1 ? 2 : 1
    @game_detail = game.latest_game_detail
    @formation_array = JSON.parse(@game_detail.formation)
  end
  
  # そのマスに置いた際のアクション
  def move(x, y)
    unless @game.senko
      x, y = choice_cpu_move_mass
    end

    return false if @formation_array[x][y].present?
    
    # 隣のマスの一覧を取得
    next_masses = next_masses(x, y)
    
    # 各方向にてひっくり返す
    next_masses.each_with_index do |mass, i|
      sandwitch(mass, i)
    end
    @formation_array[x][y] = @me
    
    # GameDetialを追加
    game_detail = GameDetail.new(game_id: @game.id, formation: @formation_array.to_json)
    game_detail.save
    
    # Gameを保存
    @game.senko = !@game.senko
    @game.save
  end
  
  def choice_cpu_move_mass
    movable_masses = []
    8.times do |x|
      8.times do |y|
        movable_masses << { x: x, y: y } if movable?(x, y)
      end
    end
    move_mass = movable_masses.sample
    
    return move_mass[:x], move_mass[:y]
  end
  
  def judge_movable
    # 置く場所があるかチェックする
    unless has_movable_masses?(@game.senko)
      unless has_movable_masses?(!@game.senko)
        # 両者置く場所がない場合はゲーム終了とする
        @game.status = 'finished'
        @game.save
        return @game.reload
      end
      # Gameを保存
      @game.save
    end
    @game.reload
  end
  
  def has_movable_masses?(senko)
    game = @game
    game.senko = senko
    service = GameService.new(game)
    8.times do |x|
      8.times do |y|
        if service.movable?(x, y)
          return true
        end
      end
    end
    false
  end

  # そのマスに置けるかどうかを判定する
  def movable?(x, y)
    # もともと置いてある場所には置けない
    return false if @formation_array[x][y].present?
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
  
  def sandwitch(mass, i)
    get_masses = []
    # マスがnil（枠外）ならfalseを返す
    return if mass.nil?
    # マスが自分と同じ石、または何も置かれていなければfalseを返す
    is_opponent = @formation_array[mass[:x]][mass[:y]].to_i == @opponent
    return unless is_opponent
    get_masses << mass
    
    # 連続する石を確認
    while is_opponent do
      mass = next_mass(mass[:x], mass[:y], i)
      # マスがnil（枠外）ならfalseを返す
      return false if mass.nil?
      # マスに何も置かれていなければfalseを返す
      return false if @formation_array[mass[:x]][mass[:y]].nil?
      is_opponent = @formation_array[mass[:x]][mass[:y]].to_i == @opponent
      get_masses << mass
    end
    get_masses.each do |m|
      @formation_array[m[:x]][m[:y]] = @me
    end
  end
  
  def in_field?(x, y)
    return true if x >= 0 && x <= 7 && y >= 0 && y <= 7
    false
  end
end
