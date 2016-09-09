Board = {}

function Board:verticalNeighbours(piece)
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

function Board:horizontalNeighbours(piece)
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

function Board:diagonalNeighbours(piece)
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
