function love.load()
    --Geting Imgs
    BlankTileImg = love.graphics.newImage('assets/blanckTile.png')
    DotTiles = love.graphics.newImage('assets/dotTiles.png')
    BlackPiece = love.graphics.newImage('assets/blackPiece.png')
    WhitePiece = love.graphics.newImage('assets/whitePiece.png')
    
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
    Turn = true
end

function won(gamePieces)
    for _, piece in pairs(gamePieces) do
        neigV = (verticalNeighbours(piece,gamePieces,0) == 4)
        neigH = (horizontalNeighbours(piece,gamePieces,0) == 4)
        neigD = (diagonalNeighbours(piece,gamePieces,0) == 4)
        --print("v "..neigV.." h "..neigH.." d "..neigD)
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
end

function roundUp(numToRound, multiple)
    mod = ((numToRound % multiple) + multiple) % multiple
    return numToRound - mod
end

function positionTaken(piece)
    for _, gamePiece in pairs(PlayerPieces) do
        if((piece[2] == gamePiece[2]) and (piece[3] == gamePiece[3])) then
            return true
        end
    end
    for _, gamePiece in pairs(ComputerPieces) do
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
        if(Turn) then
            localPiece = {BlackPiece, newX-12, newY-12}
            if(not positionTaken(localPiece)) then
                table.insert(PlayerPieces, localPiece)
                if(won(PlayerPieces)) then
                    print("player won")
                end
                Turn = not Turn
            end
        else
            localPiece = {WhitePiece, newX-12, newY-12}
            if(not positionTaken(localPiece)) then
                table.insert(ComputerPieces, localPiece)
                if(won(ComputerPieces)) then
                    print("Computer Won")
                end
                Turn = not Turn
            end
        end
    end
end

function love.draw(dt)
    for i=0,14 do
        for j=0,14 do
            if((i==2 and j==2)or(i==2 and j==11)or(i==11 and j==2)or(i==11 and j==11)or( i==7 and j==7)) then
                love.graphics.draw(DotTiles,UpLeftTile, i*TileOffset, j*TileOffset)
            elseif((i==3 and j==2)or(i==3 and j==11)or(i==12 and j==2)or(i==12 and j==11)or( i==8 and j==7)) then
                love.graphics.draw(DotTiles,UpRightTile, i*TileOffset, j*TileOffset)
            elseif((i==2 and j==3)or(i==2 and j==12)or(i==11 and j==3)or(i==11 and j==12)or( i==7 and j==8)) then
                love.graphics.draw(DotTiles,DownLeftTile, i*TileOffset, j*TileOffset)
            elseif((i==3 and j==3)or(i==3 and j==12)or(i==12 and j==3)or(i==12 and j==12)or( i==8 and j==8)) then
                love.graphics.draw(DotTiles,DownRightTile, i*TileOffset, j*TileOffset)
            else
                love.graphics.draw(BlankTileImg,BlankTile, i*TileOffset, j*TileOffset)
            end
        end
    end
    for _,piece in pairs(PlayerPieces) do
        love.graphics.draw(piece[1],Piece,piece[2],piece[3])
    end
    for _,piece in pairs(ComputerPieces) do
        love.graphics.draw(piece[1],Piece,piece[2],piece[3])
    end
    love.graphics.print(TestMessage, 485,1)
end
