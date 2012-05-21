class Snake extends Animal
  constructor: ->
    super
    @color = '#333'
    @moving = [1, 0]
    @moveCount = 0
    for time in [1,2,3] #draw 3 more segemnts
      @grow()

  place: ->
    if @segments.length > 0 #draw the other segments
      @grow()
    else #draw first segment
      x = Math.round((Game.bounds[2] / 2) / @size) * @size
      y = Math.round((Game.bounds[3] / 2) / @size) * @size

      @segments.push([x, y, @size, @size])

  grow: ->
    @segments.push([@head()[0] + @size * @moving[0], @head()[1] + @size * @moving[1], @size, @size])

  changeDirection: (direction) ->
    unless @differetDirection
      @moveCount += 1
      switch direction
        when 'left'
          @moving = [-1, 0] if @moving[0] != 1
        when 'up'
          @moving = [0, -1] if @moving[1] != 1
        when 'right'
          @moving = [1, 0] if @moving[0] != -1
        when 'down'
          @moving = [0, 1] if @moving[1] != -1

      @draw()
      @differetDirection = true

  move: ->
    @differetDirection = false
    @segments.shift()
    @grow()
    if @withinSegment(Game.mouse.head(), @head()) #within the bounds of the mouse?
      Game.score += 100 - @moveCount
      @grow()
      @draw()
      Game.mouse = new Mouse;
      Game.mouse.draw()
      @moveCount = 0
    if @withinBounds(@head()[0], @head()[1])
      true
    else
      false

  avoidingSelf: ->
    head = @head()
    for segment, count in @segments
      if @withinSegment(segment, head) && count != @segments.length - 1 then response = false; break else response = true
    #console.log 'Avoiding self? ' + response
    response
