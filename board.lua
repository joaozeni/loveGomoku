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
	  neigV = (Board:verticalOpenPaths(i,j)[1] == 4)
	  neigH = (Board:horizontalOpenPaths(i,j)[1] == 4)
	  neigrD = (Board:rightDiagonalOpenPaths(i,j)[1] == 4)
	  neiglD = (Board:leftDiagonalOpenPaths(i,j)[1] == 4)
	  if (neigV or neigH or neigrD or neiglD) then
	    return true
	  end
	end
      end
    end
    return false
end

function Board:verticalOpenPaths(x,y)
    countUp = 0
    countDown = 0
    countOpenUp = 0
    countOpenDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if y+i < 16 then
	if self.pieces[x][y+i] == color then
	  countUp = countUp + 1
	elseif self.pieces[x][y+i] == 0 then
	  countOpenUp = countOpenUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if y+i > 0 then
	if self.pieces[x][y+i] == color then
	  countDown = countDown + 1
	elseif self.pieces[x][y+i] == 0 then
	  countOpenDown = countOpenDown + 1
	else
	  break
	end
      end
    end
    return {countUp + countDown}
end

function Board:horizontalOpenPaths(x,y)
    countUp = 0
    countDown = 0
    countOpenUp = 0
    countOpenDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 then
	if self.pieces[x+i][y] == color then
	  countUp = countUp + 1
	elseif self.pieces[x+i][y] == 0 then
	  countOpenUp = countOpenUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 then
	if self.pieces[x+i][y] == color then
	  countDown = countDown + 1
	elseif self.pieces[x+i][y] == 0 then
	  countOpenDown = countOpenDown + 1
	else
	  break
	end
      end
    end
    return {countUp + countDown}
end

function Board:leftDiagonalOpenPaths(x,y)
    countUp = 0
    countDown = 0
    countOpenUp = 0
    countOpenDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 and y+i < 16 then
	if self.pieces[x+i][y+i] == color then
	  countUp = countUp + 1
	elseif self.pieces[x+i][y+i] == 0 then
	  countOpenUp = countOpenUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 and y+i > 0 then
	if self.pieces[x+i][y+i] == color then
	  countDown = countDown + 1
	elseif self.pieces[x+i][y+i] == 0 then
	  countOpenDown = countOpenDown + 1
	else
	  break
	end
      end
    end
    return {countUp + countDown}
end

function Board:rightDiagonalOpenPaths(x,y)
    countUp = 0
    countDown = 0
    countOpenUp = 0
    countOpenDown = 0
    color = self.pieces[x][y]
    for i=1,4 do
      if x+i < 16 and y-i < 16 then
	if self.pieces[x+i][y-i] == color then
	  countUp = countUp + 1
	elseif self.pieces[x+i][y-i] == 0 then
	  countOpenUp = countOpenUp + 1
	else
	  break
	end
      end
    end
    for i=-1,-4,-1 do
      if x+i > 0 and y-i > 0 then
	if self.pieces[x+i][y-i] == color then
	  countDown = countDown + 1
	elseif self.pieces[x+i][y-i] == 0 then
	  countOpenDown = countOpenDown + 1
	else
	  break
	end
      end
    end
    return {countUp + countDown}
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

function Board:getAroundBlanks(x,y)
  blanks = {}
  if self.pieces[x-1][y-1] == 0 then table.insert(blanks, {x-1,x-1}) end
  if self.pieces[x][y-1] == 0 then table.insert(blanks, {x,y-1}) end
  if self.pieces[x+1][y-1] == 0 then table.insert(blanks, {x+1,y-1}) end
  if self.pieces[x-1][y] == 0 then table.insert(blanks, {x-1,y}) end
  if self.pieces[x+1][y] == 0 then table.insert(blanks, {x+1,y}) end
  if self.pieces[x-1][y+1] == 0 then table.insert(blanks, {x-1,y+1}) end
  if self.pieces[x][y+1] == 0 then table.insert(blanks, {x,y+1}) end
  if self.pieces[x+1][y+1] == 0 then table.insert(blanks, {x+1,y+1}) end
  return blanks
end
