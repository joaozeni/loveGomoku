IA = {}

function IA:new()
  require 'board'
  local object = {}
  setmetatable(object, {__index = IA})
  return object
end

function IA:mmab(board, depth, min, max, maximize)
    --print("min")
    --print(min)
    if(board:won("w") or board:won("b") or depth > 5) then --Leaf
        if(board:won("b") or board:won("w")) then
            print("here ")
        end
        return {IA:evaluate(board), _, depth}
    end
    moves = board:getEmpties()
    if(maximize) then
        local val = min
        for _, move in pairs(moves) do
            --local eval = mmab(board, depth+1, move, val, max, false)
	    board:insert(move[1],move[2], "w")
            local eval = IA:mmab(board, depth+1, val, max, false)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val < eval[1]) then
                val = eval[1]
                bestMove = move
            end
	    board:delete(move[1],move[2])
            if val > max then 
                print("max cut")
                return {max, bestMove,depth} 
            end
        end
        return {val,bestMove,depth}
    else
        local val = max
        for _, move in pairs(moves) do
            --local eval = mmab(board, depth+1, move, min, val, true)
	    board:insert(move[1],move[2], "b")
            local eval = IA:mmab(board, depth+1, min, val, true)
            if(depth < eval[3]) then
                depth = eval[3]
            end
            if(val > eval[1]) then
                val = eval[1]
                bestMove = move
            end
	    board:delete(move[1],move[2])
            if val < min then 
                print("min cut")
                return {min, bestMove,depth}
            end
        end
        return {val,bestMove,depth}
    end
end

function IA:evaluate(board)
    evaluation = 0
    moves = board:getEmpties()
    for _, move in pairs(moves) do
      evaluation = evaluation + IA:evaluatePosition(move[1], move[2], "w", board)
    end
    --print(evaluation)
    --print(rnd)
    return evaluation
end

function IA:evaluatePosition(x, y, color, board)
  evaluation = 0
  vertical = board:verticalOpenPaths(x, y, color)
  horizontal = board:horizontalOpenPaths(x, y, color)
  rightDiagonal = board:rightDiagonalOpenPaths(x, y, color)
  leftDiagonal = board:leftDiagonalOpenPaths(x, y, color)
  if vertical[1] + vertical[3] > 4 then
    evaluation = evaluation + (vertical[3](10^vertical[1]))
  end
  if horizontal[1] + horizontal[3] > 4 then
    evaluation = evaluation + (horizontal[3](10^horizontal[1]))
  end
  if rightDiagonal[1] + rightDiagonal[3] > 4 then
    evaluation = evaluation + (rightDiagonal[3](10^rightDiagonal[1]))
  end
  if leftDiagonal[1] + leftDiagonal[3] > 4 then
    evaluation = evaluation + (leftDiagonal[3](10^leftDiagonal[1]))
  end
  if vertical[2] + vertical[4] > 4 then
    evaluation = evaluation + (vertical[4](10^vertical[2]))
  end
  if horizontal[2] + horizontal[4] > 4 then
    evaluation = evaluation + (horizontal[4](10^horizontal[2]))
  end
  if rightDiagonal[2] + rightDiagonal[4] > 4 then
    evaluation = evaluation + (rightDiagonal[4](10^rightDiagonal[2]))
  end
  if leftDiagonal[2] + leftDiagonal[4] > 4 then
    evaluation = evaluation + (leftDiagonal[4](10^leftDiagonal[2]))
  end
  return evaluation
end
