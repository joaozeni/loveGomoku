function love.load()
    --Geting Imgs
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    Board = love.graphics.newImage('assets/board.png')
    
    --Creating Quads
    Piece = love.graphics.newQuad(0, 0, 24, 24, 24,24)

    --Data Structs that will be used
    --PlayerPieces = {}
    --ComputerPieces = {}
    Pieces = {}
    for i=0,14 do
      Pieces[i] = {}
      for j=0,14 do
	Pieces[i][j] = {}
      end
    end
    TestMessage = "Nothing till now"
    TileOffset = 32
    BoardOffset = 16
    PlayerTurn = true
    ComputerTurn = false
end

function won(playerColorPiece)
    for i=0,14 do
      for j=0,14 do
	if Pieces[i][j][1] == playerColorPiece then
	  x = (Pieces[i][j][2] - BoardOffset + 12)/32
	  y = (Pieces[i][j][3] - BoardOffset + 12)/32
	  currentPiece = {Pieces[i][j][1], x, y}
	  neigV = (verticalNeighbours(currentPiece) == 4)
	  neigH = (horizontalNeighbours(currentPiece) == 4)
	  neigD = (diagonalNeighbours(currentPiece) == 4)
	  if(neigV or neigH or neigD) then
	    return true
	  end
	end
      end
    end
    return false
end

function verticalNeighbours(piece)
    countUp = 0
    countDown = 0
    print("x"..piece[2])
    for i=1,4 do
      if piece[3]+i < 16 then
	if Pieces[piece[2]][piece[3]+i][1] == piece[1] then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if piece[3]+i > 0 then
	if Pieces[piece[2]][piece[3]+i][1] == piece[1] then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function horizontalNeighbours(piece)
    countUp = 0
    countDown = 0
    for i=1,4 do
      if piece[2]+i < 16 then
	if Pieces[piece[2]+i][piece[3]][1] == piece[1] then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if piece[2]+i > 0 then
	if Pieces[piece[2]+i][piece[3]][1] == piece[1] then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function diagonalNeighbours(piece)
    countUp = 0
    countDown = 0
    for i=1,4 do
      if piece[2]+i < 16 and piece[3]+i < 16 then
	if Pieces[piece[2]+i][piece[3]+i][1] == piece[1] then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if piece[2]+i > 0 and piece[3]+i > 0 then
	if Pieces[piece[2]+i][piece[3]+i][1] == piece[1] then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function love.update(dt)
    if(ComputerTurn) then
        ComputerTurn = not ComputerTurn
        local mmabResult = mmab({PlayerPieces,ComputerPieces}, 0, -10000, 10000, true)
	x = (mmabResult[2][2] - BoardOffset + 12)/32
	y = (mmabResult[2][3] - BoardOffset + 12)/32
	Pieces[x][y] = {WhitePiece, mmabResult[2][2], mmabResult[2][3]}
        --table.insert(ComputerPieces, {WhitePiece, mmabResult[2][2], mmabResult[2][3]})
        print(mmabResult[3])
        PlayerTurn = true
        --ai()
    end
end

function roundUp(numToRound, multiple)
    mod = ((numToRound % multiple) + multiple) % multiple
    return numToRound - mod
end

function positionTaken(piece)
  x = (piece[2] - BoardOffset + 12)/32
  y = (piece[3] - BoardOffset + 12)/32
  return Pieces[x][y][1] ~= nil
end

function love.mousepressed(x,y,btn)
    --TestMessage = "Pressed X:" .. x .. " Y: " .. y
    xRelativePos = math.abs(math.floor((x-BoardOffset)/TileOffset) - (x-BoardOffset)/TileOffset)
    yRelativePos = math.abs(math.floor((y-BoardOffset)/TileOffset) - (y-BoardOffset)/TileOffset)
    if((xRelativePos < 0.5) and (yRelativePos < 0.5)) then
        newX = roundUp(x,32) + BoardOffset
        newY = roundUp(y,32) + BoardOffset
        if(PlayerTurn) then
            localPiece = {BlackPiece, newX-12, newY-12}
            if(not positionTaken(localPiece)) then
                --PlayerTurn = not PlayerTurn
	        x = (localPiece[2] - BoardOffset + 12)/32
	        y = (localPiece[3] - BoardOffset + 12)/32
		Pieces[x][y] = localPiece
                --table.insert(PlayerPieces, localPiece)
                if(won(BlackPiece)) then
                    print("player won")
                --else
                    ComputerTurn = false
                end
            end
        end
    end
end

function love.draw(dt)
  love.graphics.draw(Board,0,0,0,0.25)
  for i=0,14 do
    for j=0,14 do
      if Pieces[i][j][1] ~= nil then
        love.graphics.draw(Pieces[i][j][1],Piece,Pieces[i][j][2],Pieces[i][j][3])
      end
    end
  end
  love.graphics.print(TestMessage, 514,1)
end

-- Game AI
function mmab(gameState, depth, min, max, maximize)
    if(won(gameState[1]) or won(gameState[2]) or depth > 20) then --Leaf
        if(won(gameState[1]) or won(gameState[2])) then
            print("here ")
        end
        return {evaluate(gameState,maximize), _, depth}
    end
    moves = getEmpties(gameState)
    if(maximize) then
        local val = min
        for _, move in pairs(moves) do
            local childGameState = {gameState[1],gameState[2]}
            table.insert(childGameState[2],{WhitePiece,move[2],move[3]})
            local eval = mmab(gameState,depth+1,val,max,false)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val < eval[1]) then
                val = eval[1]
                bestMove = move
            end
            table.remove(childGameState[2])
            if val > max then 
                print("max cut")
                return {max, bestMove,depth} 
            end
        end
        return {val,bestMove,depth}
    else
        local val = max
        for _, move in pairs(moves) do
            local childGameState = {gameState[1],gameState[2]}
            table.insert(childGameState[1],{BlackPiece,move[2],move[3]})
            local eval = mmab(gameState,depth+1,min,val,true)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val > eval[1]) then
                val = eval[1]
                bestMove = move
            end
            table.remove(childGameState[1])
            if val < min then 
                print("mix cut")
                return {min, bestMove,depth}
            end
        end
        return {val,bestMove,depth}
    end
end

function evaluate(gameState, maximize)
    oneWay = 0
    twoWay = 0
    threeWay = 0
    if maximize then
        gamePieces = gameState[1]
    else
        gamePieces = gameState[2]
    end
    for _, piece in pairs(gamePieces) do
        neigV = verticalNeighbours(piece,gamePieces,0)
        neigH = horizontalNeighbours(piece,gamePieces,0)
        neigD = diagonalNeighbours(piece,gamePieces,0)
        if neigV == 4 then
            oneWay = oneWay + 1
        elseif neigV == 3 then
            twoWay = twoWay + 1
        elseif neigV == 2 then
            threeWay = threeWay + 1
        end

        if neigH == 4 then
            oneWay = oneWay + 1
        elseif neigH == 3 then
            twoWay = twoWay + 1
        elseif neigH == 2 then
            threeWay = threeWay + 1
        end

        if neigD == 4 then
            oneWay = oneWay + 1
        elseif neigD == 3 then
            twoWay = twoWay + 1
        elseif neigD == 2 then
            threeWay = threeWay + 1
        end
    end
    evaluation = oneWay * 100.0 + twoWay * 5.0 + threeWay * 1.0
    --print(evaluation)
    --print(rnd)
    return evaluation
end
