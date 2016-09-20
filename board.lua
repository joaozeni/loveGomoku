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
  --print("x "..x.." y "..y)
  self.pieces[x][y] = color
end

function Board:delete(x,y)
  self.pieces[x][y] = 0
end

--Board Analysys of the state
function Board:positionTaken(x,y)
  return self.pieces[x][y] ~= 0
end

function Board:won(color)
    for i=0,14 do
      for j=0,14 do
	if self.pieces[i][j] == color then
	  neigV = Board:verticalNeighbors(i,j)
	  neigH = Board:horizontalNeighbors(i,j)
	  neigrD = Board:rightDiagonalNeighbors(i,j)
	  neiglD = Board:leftDiagonalNeighbors(i,j)
	  neigVSize = (neigV[1] + neigV[2] == 4)
	  neigHSize = (neigH[1] + neigH[2] == 4)
	  neigrDSize = (neigrD[1] + neigrD[2] == 4)
	  neiglDSize = (neiglD[1] + neiglD[2] == 4)
	  if (neigVSize or neigHSize or neigrDSize or neiglDSize) then
	    return true
	  end
	end
      end
    end
    return false
end

function Board:verticalNeighbors(x, y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    for i=1,4 do
      if y+i <= 14 then
	if self.pieces[x][y+i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if y+i >= 0 then
	if self.pieces[x][y+i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end

function Board:horizontalNeighbors(x, y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    for i=1,4 do
      if x+i <= 14 then
	if self.pieces[x+i][y] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i >= 0 then
	if self.pieces[x+i][y] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end

function Board:leftDiagonalNeighbors(x, y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    for i=1,4 do
      if x+i <= 14 and y+i <= 14 then
	if self.pieces[x+i][y+i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i >= 0 and y+i >= 0 then
	if self.pieces[x+i][y+i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end

function Board:rightDiagonalNeighbors(x, y)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    for i=1,4 do
      if x+i <= 14 and y-i <= 14 then
	if self.pieces[x+i][y-i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i >= 0 and y-i >= 0 then
	if self.pieces[x+i][y-i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end

function Board:getEmpties()
  empties = {}
  for i=0,14 do
    for j=0,14 do
      if self.pieces[i][j] ~= 0 then
	blanks = Board:getAroundBlanks(i,j)
	for k,v in pairs(blanks) do table.insert(empties,v) end
      end
    end
  end
  return empties
end

function Board:getPieces()
  countBlack = 0
  countWhite = 0
  for i=0,14 do
    for j=0,14 do
      if self.pieces[i][j] == "w" then
	countBlack = countBlack + 1
      elseif self.pieces[i][j] == "b" then
	countWhite = countWhite + 1
      end
    end
  end
  return {countBlack, countWhite}
end

function Board:getAroundBlanks(x,y)
  blanks = {}
  --print("x "..x.." y "..y)
  if x-1 >= 0 and y-1 >= 0 then
    if self.pieces[x-1][y-1] == 0 then table.insert(blanks, {x-1,y-1}) end
  end
  if y-1 >= 0 then
    if self.pieces[x][y-1] == 0 then table.insert(blanks, {x,y-1}) end
  end
  if x+1 <= 14 and y-1 >= 0 then
    if self.pieces[x+1][y-1] == 0 then table.insert(blanks, {x+1,y-1}) end
  end
  if x-1 >= 0 then
    if self.pieces[x-1][y] == 0 then table.insert(blanks, {x-1,y}) end
  end
  if x+1 <= 14 then
    if self.pieces[x+1][y] == 0 then table.insert(blanks, {x+1,y}) end
  end
  if x-1 >= 0 and y+1 <= 14 then
    if self.pieces[x-1][y+1] == 0 then table.insert(blanks, {x-1,y+1}) end
  end
  if y+1 <= 14 then
    if self.pieces[x][y+1] == 0 then table.insert(blanks, {x,y+1}) end
  end
  if x+1 <= 14 and y+1 <= 14 then
    if self.pieces[x+1][y+1] == 0 then table.insert(blanks, {x+1,y+1}) end
  end
  return blanks
end

function Board:verticalPath(x, y, color)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    i = 1
    flag = true
    while flag  do
      if y + i > 14 then
	break
      end
      if self.pieces[x+i][y] == color then
	countUp = countUp + 1
      else
	flag = false
      end
      i = i + 1
    end

    i = -1
    flag = true
    while flag do
      if y + i < 0 then
	break
      end
      if self.pieces[x][y+i] == color then
	countDown = countDown + 1
      else
	flag = false
      end
      i = i - 1
    end
    
    for i=1,4 do
      if y+i <= 14 then
	if self.pieces[x][y+i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if y+i >= 0 then
	if self.pieces[x][y+i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end

function Board:horizontalPath(x, y, color)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]
    
    i = 1
    flag = true
    while flag  do
      if x + i > 14 then
	break
      end
      if self.pieces[x+i][y] == color then
	countUp = countUp + 1
      else
	flag = false
      end
      i = i + 1
    end

    i = -1
    flag = true
    while flag do
      if x + i < 0 then
	break
      end
      if self.pieces[x+i][y] == color then
	countDown = countDown + 1
      else
	flag = false
      end
      i = i - 1
    end
    
    return {countUp, countDown}
end

function Board:leftDiagonalPath(x, y, color)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    i = 1
    flag = true
    while flag  do
      if x + i > 14 and y+i > 14 then
	break
      end
      if self.pieces[x+i][y+i] == color then
	countUp = countUp + 1
      else
	flag = false
      end
      i = i + 1
    end

    i = -1
    flag = true
    while flag do
      if x+i < 0 and y+i < 0 then
	break
      end
      if self.pieces[x+i][y+i] == color then
	countDown = countDown + 1
      else
	flag = false
      end
      i = i - 1
    end
    
    return {countUp, countDown}
end

function Board:rightDiagonalPath(x, y, color)
    countUp = 0
    countDown = 0
    color = self.pieces[x][y]

    for i=1,4 do
      if x+i <= 14 and y-i <= 14 then
	if self.pieces[x+i][y-i] == color then
	  countUp = countUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i >= 0 and y-i >= 0 then
	if self.pieces[x+i][y-i] == color then
	  countDown = countDown + 1
	else
	  break
	end
      end
    end
    return {countUp, countDown}
end
