function love.load()
    --Geting Imgs
    BlankTileImg = love.graphics.newImage('assets/blanckTile.png')
    DotTiles = love.graphics.newImage('assets/dotTiles.png')
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    Board = love.graphics.newImage('assets/board.png')
    
    --Creating Quads
    local tileW, tileH = 32,32
    local dotTilesW, dotTilesH = DotTiles:getWidth(), DotTiles:getHeight()

    BlankTile = love.graphics.newQuad(0,  0, tileW, tileH, 32, 32)
    UpLeftTile = love.graphics.newQuad(0,  0, tileW, tileH, dotTilesW, dotTilesH)
    UpRightTile = love.graphics.newQuad(32,  0, tileW, tileH, dotTilesW, dotTilesH)
    DownLeftTile = love.graphics.newQuad(0,  32, tileW, tileH, dotTilesW, dotTilesH)
    DownRightTile = love.graphics.newQuad(32,  32, tileW, tileH, dotTilesW, dotTilesH)
    Piece = love.graphics.newQuad(0, 0, 24, 24, 24,24)

    --Data Structs that will be used
    PlayerPieces = {}
    ComputerPieces = {}
    TestMessage = "Nothing till now"
    TileOffset = 32
    PlayerTurn = true
    ComputerTurn = false
end

function won(gamePieces)
    for _, piece in pairs(gamePieces) do
        neigV = (verticalNeighbours(piece,gamePieces,0) == 4)
        neigH = (horizontalNeighbours(piece,gamePieces,0) == 4)
        neigD = (diagonalNeighbours(piece,gamePieces,0) == 4)
        if(neigV or neigH or neigD) then
            return true
        end
    end
    return false
end

function verticalNeighbours(piece, gamePieces, count)
    for _, nPiece in pairs(gamePieces) do
        if((nPiece[2] == piece[2]) and (nPiece[3] == piece[3]+32)) then
            return verticalNeighbours(nPiece, gamePieces, count+1)
        end
    end
    return count
end

function horizontalNeighbours(piece, gamePieces, count)
    for _, nPiece in pairs(gamePieces) do
        if((nPiece[2] == piece[2]+32) and (nPiece[3] == piece[3])) then
            return verticalNeighbours(nPiece, gamePieces, count+1)
        end
    end
    return count
end

function diagonalNeighbours(piece, gamePieces, count)
    for _, nPiece in pairs(gamePieces) do
        if((nPiece[2] == piece[2]+32) and (nPiece[3] == piece[3]+32)) then
            return verticalNeighbours(nPiece, gamePieces, count+1)
        end
    end
    return count
end

function love.update(dt)
    if(ComputerTurn) then
        ComputerTurn = not ComputerTurn
        local mmabResult = mmab({PlayerPieces,ComputerPieces}, 0, -10000, 10000, true)
        table.insert(ComputerPieces, {WhitePiece, mmabResult[2][2], mmabResult[2][3]})
        print(mmabResult[3])
        PlayerTurn = true
        --ai()
    end
end

function roundUp(numToRound, multiple)
    mod = ((numToRound % multiple) + multiple) % multiple
    return numToRound - mod
end

function positionTaken(piece, gameState)
    for _, gamePiece in pairs(gameState[1]) do
        if((piece[2] == gamePiece[2]) and (piece[3] == gamePiece[3])) then
            return true
        end
    end
    for _, gamePiece in pairs(gameState[2]) do
        if((piece[2] == gamePiece[2]) and (piece[3] == gamePiece[3])) then
            return true
        end
    end
    return false
end

function love.mousepressed(x,y,btn)
    TestMessage = "Pressed X:" .. x .. " Y: " .. y
    xRelativePos = math.abs(math.floor(x/TileOffset) - x/TileOffset)
    yRelativePos = math.abs(math.floor(y/TileOffset) - y/TileOffset)
    if((xRelativePos < 0.15) and (yRelativePos < 0.15)) then
        newX = roundUp(x,32)
        newY = roundUp(y,32)
        if(PlayerTurn) then
            localPiece = {BlackPiece, newX-12, newY-12}
            if(not positionTaken(localPiece,{PlayerPieces,ComputerPieces})) then
                PlayerTurn = not PlayerTurn
                table.insert(PlayerPieces, localPiece)
                if(won(PlayerPieces)) then
                    print("player won")
                else
                    ComputerTurn = true
                end
            end
        end
    end
end

function love.draw(dt)
  love.graphics.draw(Board,0,0,0,0.5)
--    for i=0,14 do
--        for j=0,14 do
--            if((i==2 and j==2)or(i==2 and j==11)or(i==11 and j==2)or(i==11 and j==11)or( i==7 and j==7)) then
--                love.graphics.draw(DotTiles,UpLeftTile, i*TileOffset, j*TileOffset)
--            elseif((i==3 and j==2)or(i==3 and j==11)or(i==12 and j==2)or(i==12 and j==11)or( i==8 and j==7)) then
--                love.graphics.draw(DotTiles,UpRightTile, i*TileOffset, j*TileOffset)
--            elseif((i==2 and j==3)or(i==2 and j==12)or(i==11 and j==3)or(i==11 and j==12)or( i==7 and j==8)) then
--                love.graphics.draw(DotTiles,DownLeftTile, i*TileOffset, j*TileOffset)
--            elseif((i==3 and j==3)or(i==3 and j==12)or(i==12 and j==3)or(i==12 and j==12)or( i==8 and j==8)) then
--                love.graphics.draw(DotTiles,DownRightTile, i*TileOffset, j*TileOffset)
--            else
--                love.graphics.draw(BlankTileImg,BlankTile, i*TileOffset, j*TileOffset)
--            end
--        end
--    end
    for _,piece in pairs(PlayerPieces) do
        love.graphics.draw(piece[1],Piece,piece[2],piece[3])
    end
    for _,piece in pairs(ComputerPieces) do
        love.graphics.draw(piece[1],Piece,piece[2],piece[3])
    end
    love.graphics.print(TestMessage, 485,1)
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

function getEmpties(gameState)
    moves = {}
    for x=0,14 do
        for y=0,14 do
            localPiece = {_, (x*32)-12, (y*32)-12}
            if(not positionTaken(localPiece,gameState)) then
                table.insert(moves,localPiece)
            end
        end
    end
    return moves
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
