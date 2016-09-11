Board = {}

function Board:new()
  var = {}
  for i=0,14 do
    var[i] = {}
    for j=0,14 do
      var[i][j] = 0
    end
  end
  local object = {
    pieces = var
  }
  setmetatable(object,{__index = Board})
  return object
end

function Board:start()
  for i=0,14 do
    self.pieces[i] = {}
    for j=0,14 do
      self.pieces[i][j] = 0
    end
  end
end

function Board:insert(x,y,color)
  self.pieces[x][y] = color
end

function Board:positionTaken(x,y)
  return self.pieces[x][y] ~= 0
end

function Board:won(color)
    for i=0,14 do
      for j=0,14 do
	if self.pieces[i][j] == color then
	  neigV = (Board:verticalNeighbours(i,j) == 4)
	  neigH = (Board:horizontalNeighbours(i,j) == 4)
	  neigrD = (Board:rightDiagonalNeighbours(i,j) == 4)
	  neiglD = (Board:leftDiagonalNeighbours(i,j) == 4)
	  if (neigV or neigH or neigrD or neiglD) then
	    return true
	  end
	end
      end
    end
    return false
end

function Board:verticalNeighbours(x,y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if y+i < 16 then
	if self.pieces[x][y+i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if y+i > 0 then
	if self.pieces[x][y+i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function Board:horizontalNeighbours(x,y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 then
	if self.pieces[x+i][y] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 then
	if self.pieces[x+i][y] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function Board:leftDiagonalNeighbours(x,y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 and y+i < 16 then
	if self.pieces[x+i][y+i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 and y+i > 0 then
	if self.pieces[x+i][y+i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end

function Board:rightDiagonalNeighbours(x,y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 and y-i < 16 then
	if self.pieces[x+i][y-i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 and y-i > 0 then
	if self.pieces[x+i][y-i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return countUp + countDown
end
