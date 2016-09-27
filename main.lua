function love.load()
    --require modules
    require 'board'
    require 'ia'
    
    --Geting Imgs
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    BoardImg = love.graphics.newImage('assets/board.png')
    
    --Creating Quads
    Piece = love.graphics.newQuad(0, 0, 24, 24, 24,24)

    --Starting IA
    IA = IA:new()

    --Data Structs that will be used
    Board = Board:new()
    DrawPieces = {}

    --For menu
    PlayerPiece = "b"
    ComputerPiece = "w"
    
    TestMessage = "Nothing till now"
    TileOffset = 32
    BoardOffset = 16
    PlayerTurn = true
    ComputerTurn = false
end

function love.update(dt)
    if(ComputerTurn) then
        ComputerTurn = not ComputerTurn
        local mmabResult = IA:mmab(Board, 0, -100000000000, 1000000000000, true)
	print "------------------------------------------------------------"
        --local mmabResult = mmab({PlayerPieces,ComputerPieces}, 0, -10000, 10000, true)
	vx = (32*mmabResult[2][1] + BoardOffset - 12)
	vy = (32*mmabResult[2][2] + BoardOffset - 12)
	Board:insert(mmabResult[2][1],mmabResult[2][2], ComputerPiece)
	table.insert(DrawPieces, {WhitePiece, vx, vy})
	--Pieces[x][y] = {WhitePiece, mmabResult[2][2], mmabResult[2][3]}
        --table.insert(ComputerPieces, {WhitePiece, mmabResult[2][2], mmabResult[2][3]})
        --print(mmabResult[3])
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
	        Board:insert(x,y,PlayerPiece)
		table.insert(DrawPieces, localPiece)
                --PlayerTurn = not PlayerTurn
	        --x = (localPiece[2] - BoardOffset + 12)/32
	        --y = (localPiece[3] - BoardOffset + 12)/32
		--Pieces[x][y] = localPiece
                --table.insert(PlayerPieces, localPiece)
                if(Board:won(PlayerPiece)) then
                    print("player won")
		elseif(Board:won(ComputerPiece)) then
                    print("Computer won")
                else
                    ComputerTurn = true
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
