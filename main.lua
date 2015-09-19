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
end

function love.update(dt)
end

function love.draw(dt)
    local offset = 32
    for i=0,14 do
        for j=0,14 do
            if((i==2 and j==2)or(i==2 and j==11)or(i==11 and j==2)or(i==11 and j==11)or( i==7 and j==7)) then
                love.graphics.draw(DotTiles,UpLeftTile, i*offset, j*offset)
            elseif((i==3 and j==2)or(i==3 and j==11)or(i==12 and j==2)or(i==12 and j==11)or( i==8 and j==7)) then
                love.graphics.draw(DotTiles,UpRightTile, i*offset, j*offset)
            elseif((i==2 and j==3)or(i==2 and j==12)or(i==11 and j==3)or(i==11 and j==12)or( i==7 and j==8)) then
                love.graphics.draw(DotTiles,DownLeftTile, i*offset, j*offset)
            elseif((i==3 and j==3)or(i==3 and j==12)or(i==12 and j==3)or(i==12 and j==12)or( i==8 and j==8)) then
                love.graphics.draw(DotTiles,DownRightTile, i*offset, j*offset)
            else
                love.graphics.draw(BlankTileImg,BlankTile, i*offset, j*offset)
            end
        end
    end
    love.graphics.draw(BlackPiece,Piece,20,20)
    love.graphics.draw(WhitePiece,Piece,52,52)
end
