function love.load()
    --require modules
    require 'board'
    --require 'player'
    
    --Geting Imgs
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    BoardImg = love.graphics.newImage('assets/board.png')
    
    --Creating Quads
    Piece = love.graphics.newQuad(0, 0, 24, 24, 24,24)

    --Data Structs that will be used
    --PlayerPieces = {}
    --ComputerPieces = {}
    Board = Board:new()
    DrawPieces = {}
    
    TestMessage = "Nothing till now"
    TileOffset = 32
    BoardOffset = 16
    PlayerTurn = true
    ComputerTurn = false
end

function love.update(dt)
    if(ComputerTurn) then
        ComputerTurn = not ComputerTurn
        local mmabResult = mmab({PlayerPieces,ComputerPieces}, 0, -10000, 10000, true)
	x = (mmabResult[2][2] - BoardOffset + 12)/32
	y = (mmabResult[2][3] - BoardOffset + 12)/32
	Board:insert(x,y,"w")
	table.insert(DrawPieces, {WhitePiece, mmabResult[2][2], mmabResult[2][3]})
	--Pieces[x][y] = {WhitePiece, mmabResult[2][2], mmabResult[2][3]}
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

function love.mousepressed(x,y,btn)
    --TestMessage = "Pressed X:" .. x .. " Y: " .. y
    xRelativePos = math.abs(math.floor((x-BoardOffset)/TileOffset) - (x-BoardOffset)/TileOffset)
    yRelativePos = math.abs(math.floor((y-BoardOffset)/TileOffset) - (y-BoardOffset)/TileOffset)
    if((xRelativePos < 0.5) and (yRelativePos < 0.5)) then
        newX = roundUp(x,32) + BoardOffset
        newY = roundUp(y,32) + BoardOffset
        if(PlayerTurn) then
            localPiece = {BlackPiece, newX-12, newY-12}
	    x = (localPiece[2] - BoardOffset + 12)/32
	    y = (localPiece[3] - BoardOffset + 12)/32
            if(not Board:positionTaken(x,y)) then
	        Board:insert(x,y,"b")
		table.insert(DrawPieces, localPiece)
                --PlayerTurn = not PlayerTurn
	        --x = (localPiece[2] - BoardOffset + 12)/32
	        --y = (localPiece[3] - BoardOffset + 12)/32
		--Pieces[x][y] = localPiece
                --table.insert(PlayerPieces, localPiece)
                if(Board:won("b")) then
                    print("player won")
                --else
                    ComputerTurn = false
                end
            end
        end
    end
end

function love.draw(dt)
  love.graphics.draw(BoardImg,0,0,0,0.25)
  for _, piece in pairs(DrawPieces) do
    love.graphics.draw(piece[1],Piece,piece[2],piece[3])
  end
  love.graphics.print(TestMessage, 514,1)
end

-- Game AI
function mmab(depth, min, max, maximize)
    if(Board:won("w") or Board:won("b") or depth > 5) then --Leaf
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

--function getAroundBlanks(piece)
--  blanks = {}
--  if Pieces[piece[1]-1][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]-1]}) end
--  if Pieces[piece[1]][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]],[piece[2]-1]}) end
--  if Pieces[piece[1]+1][piece[2]-1][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]-1]}) end
--  if Pieces[piece[1]-1][piece[2]][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]]}) end
--  if Pieces[piece[1]+1][piece[2]][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]]}) end
--  if Pieces[piece[1]-1][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]-1],[piece[2]+1]}) end
--  if Pieces[piece[1]][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]],[piece[2]+1]}) end
--  if Pieces[piece[1]+1][piece[2]+1][1] == nil then table.insert(blanks, {[piece[1]+1],[piece[2]+1]}) end
--  return blanks
--end

function evaluate(move)
    evaluation = 0
    --print(evaluation)
    --print(rnd)
    return evaluation
end
