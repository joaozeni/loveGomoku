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
    if(board:won("w") or board:won("b") or depth > 6) then --Leaf
        if board:won("b") then
	    return {-IA:evaluateVictory(board, maximize), _, depth}
	elseif board:won("w") then
	    return {IA:evaluateVictory(board, maximize), _, depth}
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
      print("--eval "..evaluation)
      val = IA:evaluatePosition(move[1], move[2], color, board)
      oponentVal = IA:evaluatePosition(move[1], move[2], openenteColor, board)
      tt = val - oponentVal
      evaluation = evaluation + tt
      print("  x "..move[1].." y "..move[2].." val "..val.." oval "..oponentVal.." eval "..evaluation.." tt "..tt)
    end
    --print(evaluation)
    --print(rnd)
    return evaluation
end

function IA:evaluatePosition(x, y, color, board)
  evaluationP = 0
  vertical = board:verticalPath(x, y, color)
  horizontal = board:horizontalPath(x, y, color)
  rightDiagonal = board:rightDiagonalPath(x, y, color)
  leftDiagonal = board:leftDiagonalPath(x, y, color)

  verticalVal = vertical[1] + vertical[2]
  horizontalVal = horizontal[1] + horizontal[2]
  rightDiagonalVal = rightDiagonal[1] + rightDiagonal[2]
  leftDiagonalVal = leftDiagonal[1] + leftDiagonal[2]
  
  evaluationP = 2^(verticalVal + horizontalVal + rightDiagonalVal + leftDiagonalVal)
  
  --print("x "..x.." y "..y.." opens "..horizontal[3].." n "..horizontal[1])
  --print(vertical[3])
  return evaluationP
end

function IA:evaluateVictory(board)
  evaluation = 0

  pieces = board:getPieces()
  evaluation = 10^(pieces[1]+pieces[2])

  return evaluation
end
