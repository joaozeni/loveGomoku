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
    Pieces = {}
    TestMessage = "Nothing till now"
    TileOffset = 32
end

function love.update(dt)
end

function love.mousepressed(x,y,btn)
    TestMessage = "Pressed X:" .. x .. " Y: " .. y
    xRelativePos = math.abs(math.floor(x/TileOffset) - x/TileOffset)
    yRelativePos = math.abs(math.floor(y/TileOffset) - y/TileOffset)
    if((xRelativePos < 0.15) and (yRelativePos < 0.15)) then
        local localPiece = {BlackPiece, x - 12, y - 12}
        table.insert(Pieces, localPiece)
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
    for key,piece in pairs(Pieces) do
        love.graphics.draw(piece[1],Piece,piece[2],piece[3])
    end
    --love.graphics.draw(BlackPiece,Piece,20,20)
    love.graphics.draw(WhitePiece,Piece,52,52)
    love.graphics.print(TestMessage, 485,1)
end
