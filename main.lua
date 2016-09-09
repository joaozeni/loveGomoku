function love.load()
    --require modules
    --require "board"
    
    --Geting Imgs
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    Board = love.graphics.newImage('assets/board.png')
    
    --Creating Quads
    Piece = love.graphics.newQuad(0, 0, 24, 24, 24,24)

    --Data Structs that will be used
    --PlayerPieces = {}
    --ComputerPieces = {}
    Pieces = Board:start()
--    for i=0,14 do
--      Pieces[i] = {}
--      for j=0,14 do
--	Pieces[i][j] = {}
--      end
--    end
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
	  neigrD = (rightDiagonalNeighbours(currentPiece) == 4)
	  neiglD = (leftDiagonalNeighbours(currentPiece) == 4)
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

function leftDiagonalNeighbours(piece)
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

function rightDiagonalNeighbours(piece)
    countUp = 0
    countDown = 0
    for i=1,4 do
      if piece[2]+i < 16 and piece[3]-i < 16 then
	if Pieces[piece[2]+i][piece[3]-i][1] == piece[1] then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if piece[2]+i > 0 and piece[3]-i > 0 then
	if Pieces[piece[2]+i][piece[3]-i][1] == piece[1] then
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
function mmab(depth, min, max, maximize)
    if(won(WhitePiece) or won(BlackPiece) or depth > 5) then --Leaf
        --if(won(gameState[1]) or won(gameState[2])) then
        --    print("here ")
        --end
        return {evaluate(maximize), _, depth}
    end
    moves = getEmpties()
    if(maximize) then
        local val = min
        for _, move in pairs(moves) do
	    Pieces[move[1]][move[2]] = {WhitePiece,move[1],move[2]}
            --table.insert(childGameState[2],{WhitePiece,move[2],move[3]})
            local eval = mmab(depth+1,val,max,false)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val < eval[1]) then
                val = eval[1]
                bestMove = move
            end
	    Pieces[move[1]][move[2]] = {}
            --table.remove(childGameState[2])
            if val > max then 
                print("max cut")
                return {max, bestMove,depth} 
            end
        end
        return {val,bestMove,depth}
    else
        local val = max
        for _, move in pairs(moves) do
	    Pieces[move[1]][move[2]] = {BlackPiece,move[1],move[2]}
            --local childGameState = {gameState[1],gameState[2]}
            --table.insert(childGameState[1],{BlackPiece,move[2],move[3]})
            local eval = mmab(depth+1,min,val,true)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val > eval[1]) then
                val = eval[1]
                bestMove = move
            end
	    Pieces[move[1]][move[2]] = {}
	    --table.remove(childGameState[1])
            if val < min then 
                print("mix cut")
                return {min, bestMove,depth}
            end
        end
        return {val,bestMove,depth}
    end
end

function getEmpties()
  empties = {}
  for i=0,14 do
    for j=0,14 do
      if Pieces[i][j][1] ~= nil then
	blanks = getAroundBlanks(Pieces[i][j])
	for k,v in pairs(blanks) do table.insert(empties,v) end
      end
    end
  end
  return empties
end

function getAroundBlanks(piece)
  blanks = {}
  if Pieces[piece[1]-1][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]-1]}) end
  if Pieces[piece[1]][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]],[piece[2]-1]}) end
  if Pieces[piece[1]+1][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]-1]}) end
  if Pieces[piece[1]-1][piece[2]][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]]}) end
  if Pieces[piece[1]+1][piece[2]][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]]}) end
  if Pieces[piece[1]-1][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]+1]}) end
  if Pieces[piece[1]][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]],[piece[2]+1]}) end
  if Pieces[piece[1]+1][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]+1]}) end
  return blanks
end

function evaluate(move)
    evaluation = 0
    --print(evaluation)
    --print(rnd)
    return evaluation
end
