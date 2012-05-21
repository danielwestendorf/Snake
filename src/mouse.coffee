class Mouse extends Animal

  place: ->
    cords = [-1,-1]
    cords = [@getRandomCord(Game.bounds[2]), @getRandomCord(Game.bounds[3]), @size, @size] until @withinBounds(cords[0], cords[1]) && @notOnSnake(cords[0], cords[1])
    @segments.push(cords)

  notOnSnake: (x, y)->
    response = true
    for segment in Game.snake.segments
      if segment[0] == x && segment[1] == y
        response = false
        break
    response