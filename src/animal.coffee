class Animal
  constructor: ->
    @size = 10
    @segments = []
    @color = "#999"
    console.log window.Game.bounds

    @place() #draw the new segment


  getRandomCord: (limit) ->
    Math.round(Math.floor(Math.random() * limit + 1) / @size) * @size

  withinBounds: (x, y)->
    true if (x >= Game.bounds[0] && x + @size <= Game.bounds[2]) && (y >= Game.bounds[1] && y + @size <= Game.bounds[3])

  place: ->
    cords = [-1,-1]
    cords = [@getRandomCord(Game.bounds[2]), @getRandomCord(Game.bounds[3]), @size, @size] until @withinBounds(cords[0], cords[1])
    @segments.push(cords)

  draw: ->
    Game.ctx.fillStyle = @color
    for segment in @segments
      Game.ctx.fillRect(segment[0], segment[1], @size, @size)

  head: ->
    @segments[@segments.length - 1]

  withinSegment: (segment, penetrator) ->
    if (penetrator[0] >= segment[0] && penetrator[0] < segment[0] + @size) && (penetrator[1] >= segment[1] && penetrator[1] < segment[1] + @size)
      true
    else
      false
