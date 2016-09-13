IA = {}

function IA:new()
  require 'board'
  local object = {}
  setmetatable(object, {__index = IA})
  return object
end

function IA:mmab(board, depth, evalMove, min, max, maximize)
    if(Board:won("w") or Board:won("b") or depth > 5) then --Leaf
        if(won("b") or won("w")) then
            print("here ")
        end
        return {IA:evaluate(evalMove[1],evalMove[2]), _, depth}
    end
    moves = board:getEmpties()
    if(maximize) then
        local val = min
        for _, move in pairs(moves) do
            local eval = mmab(board, depth+1, move, val, max, false)
	    board:insert(move[1],move[2], "w")
            --local eval = mmab(board, depth+1, move,val,max,false)
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
            local eval = mmab(board, depth+1, move, min, val, true)
	    board:insert(move[1],move[2], "b")
            --local eval = mmab(board, depth+1, move, min, val, true)
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

function IA:evaluate(x,y, color)
    evaluation = 0
    --print(evaluation)
    --print(rnd)
    return evaluation
end
