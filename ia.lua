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
            --print("here ")
        end
        return {IA:evaluate(board, maximize), _, depth}
    end
    moves = board:getEmpties()
    if(maximize) then
        local val = min
        for _, move in pairs(moves) do
            --local eval = mmab(board, depth+1, move, val, max, false)
	    board:insert(move[1],move[2], "w")
            local eval = IA:mmab(board, depth+1, val, max, false)
            print("max x "..move[1].." y "..move[2].." eval "..eval[1])
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
            print("min x "..move[1].." y "..move[2].." eval "..eval[1])
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

function IA:evaluate(board, maximize)
    evaluation = 0
    moves = board:getEmpties()
    if maximize then
      color = "b"
      openenteColor = "w"
    else
      color = "w"
      openenteColor = "b"
    end
    for _, move in pairs(moves) do
      val = IA:evaluatePosition(move[1], move[2], color, board)
      print("  x "..move[1].." y "..move[2].." eval "..val)
      openentVal = IA:evaluatePosition(move[1], move[2], openenteColor, board)
      evaluation = evaluation + val - openentVal
    end
    --print(evaluation)
    --print(rnd)
    return evaluation
end

function IA:evaluatePosition(x, y, color, board)
  evaluation = 0
  if color == "w" then
    oponentColor = "b"
  else
    oponentColor = "w"
  end
  vertical = board:verticalOpenPaths(x, y, color)
  horizontal = board:horizontalOpenPaths(x, y, color)
  rightDiagonal = board:rightDiagonalOpenPaths(x, y, color)
  leftDiagonal = board:leftDiagonalOpenPaths(x, y, color)
  
  --verticalOpenent = board:verticalOpenPaths(x, y, oponentColor)
  --horizontalOpenent = board:horizontalOpenPaths(x, y, oponentColor)
  --rightDiagonalOpenent = board:rightDiagonalOpenPaths(x, y, oponentColor)
  --leftDiagonalOpenent = board:leftDiagonalOpenPaths(x, y, oponentColor)
  --print("x "..x.." y "..y.." opens "..horizontal[3].." n "..horizontal[1])
  --print(vertical[1] + vertical[3] > 3)
  if vertical[1] + vertical[3] > 3 then
    evaluation = evaluation + (vertical[3]*(10^(vertical[1]+vertical[3])))
  end
  if horizontal[1] + horizontal[3] > 3 then
    evaluation = evaluation + (horizontal[3]*(10^(horizontal[1]+horizontal[3])))
  end
  if rightDiagonal[1] + rightDiagonal[3] > 3 then
    evaluation = evaluation + (rightDiagonal[3]*(10^(rightDiagonal[1]+rightDiagonal[3])))
  end
  if leftDiagonal[1] + leftDiagonal[3] > 3 then
    evaluation = evaluation + (leftDiagonal[3]*(10^(leftDiagonal[1]+leftDiagonal[3])))
  end
  if vertical[2] + vertical[4] > 3 then
    evaluation = evaluation + (vertical[4]*(10^(vertical[2]+vertical[4])))
  end
  if horizontal[2] + horizontal[4] > 3 then
    evaluation = evaluation + (horizontal[4]*(10^(horizontal[2]+horizontal[4])))
  end
  if rightDiagonal[2] + rightDiagonal[4] > 3 then
    evaluation = evaluation + (rightDiagonal[4]*((10^rightDiagonal[2]+rightDiagonal[4])))
  end
  if leftDiagonal[2] + leftDiagonal[4] > 3 then
    evaluation = evaluation + (leftDiagonal[4]*(10^(leftDiagonal[2]+leftDiagonal[4])))
  end
  return evaluation
end
