window.Game = 
  init: ->
    console.log 'Initialized'
    Game.canvas = document.getElementById 'snake-pit'

    if navigator.userAgent.match('WebKit')
      Game.canvas.width = document.width - 10
      Game.canvas.height = document.height - 10
    else
      Game.canvas.width = 500
      Game.canvas.height = 500

    Game.ctx = Game.canvas.getContext '2d'
    Game.bounds = [0, 0, Game.canvas.width + 8, Game.canvas.height + 8]
    Game.speed = 100
    Game.score = 0

    Game.snake = new Snake
    Game.mouse = new Mouse
    Game.paused = true
    alert 'Welcome to the game of Snake!\n\nIf you have a keyboard, control the snake with the up, down, left, and right arrow keys. If you\'re on a touch enabled device, tap and drag the direction you want to turn.\n\nThe goal is to eat the mouse!'

    Game.events()
    Game.pause()

  events: ->
    Game.touchStartX = 0
    Game.touchStartY = 0

    Game.canvas.addEventListener('touchend', (event)->
      event.preventDefault()
      if event.changedTouches.length > 0
        touch = event.changedTouches[0]
        xResult = (touch.pageX - Game.touchStartX)
        yResult = (touch.pageY - Game.touchStartY)
        if Math.abs(xResult) > Math.abs(yResult)
          # Main movement was on the xaxis
          if xResult > 0 then Game.snake.changeDirection('right'); else Game.snake.changeDirection('left')
        else
          # Main movement was on the yaxis
          if yResult > 0 then Game.snake.changeDirection('down') else Game.snake.changeDirection('up')

        Game.touchStartX = 0
        Game.touchStartY = 0
    , false)

    window.addEventListener('touchstart', (event)->
      event.preventDefault()
      if event.targetTouches.length > 0
        touch = event.targetTouches[0]
        Game.touchStartX = touch.pageX
        Game.touchStartY = touch.pageY
    , false)

    window.addEventListener('keydown', (event)->
      switch event.keyCode
        when 37 then Game.snake.changeDirection('left'); event.preventDefault() unless Game.paused #left
        when 38 then Game.snake.changeDirection('up'); event.preventDefault() unless Game.paused #up
        when 39 then Game.snake.changeDirection('right'); event.preventDefault() unless Game.paused #right
        when 40 then Game.snake.changeDirection('down'); event.preventDefault() unless Game.paused #down
        when 80 then Game.pause() #pause the game

    , false)

  pause: ->
    if Game.paused
      Game.paused = false
      Game.interval = setInterval(=>
        if Game.snake.move() && Game.snake.avoidingSelf()
          @drawFrame()
        else
          @gameOver()
      Game.speed)
    else
      clearTimeout Game.interval
      Game.paused = true


  gameOver: ->
    clearTimeout Game.interval
    if confirm 'Game Over! \nScore: ' + Game.score + "\n\nWant to play again?" 
      Game.score = 0
      Game.snake = new Snake
      Game.mouse = new Mouse
      Game.paused = true

      Game.pause()

  drawFrame: ->
    Game.ctx.clearRect 0, 0, Game.canvas.width, Game.canvas.height

    Game.snake.draw()
    Game.mouse.draw()
