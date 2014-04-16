
--[[
a ={};
a['is_mine'] = false;
a['nbr_mines'] = 0;
a['visible'] = false;
--]]

--Cell class using metatables 
--http://lua-users.org/wiki/SimpleLuaClasses
Cell = {}
Cell.__index = Cell

function Cell.create()
	local cell = {}
	setmetatable(cell,Cell)

	--default values
	cell.is_mine = false
	cell.nbr_mines = 0
	cell.visible = false
	return cell
end


function get_board_size()
--IO needed to get board size
	print('How large do you want your board')
	size = io.read("*number")

	return size
end


function get_percent_mine()
--IO needed in this to get percent
	print('Set the percent of mines on the board')
	
	percent = io.read("*number")
	
	return percent
end

function displayMenu()
	print("List of available commands:")
	print("   Show Mines: s/S")
	print("   Hide Mines: h/H")
	print("   Select Cell: c/C")
	print("   Display Board: b/B")
	print("   Display Menu: m/M")
	print("   Quit: q/Q\n")
end

function nbrVisibleCells(size, board)
    
    count = 0;

    for row=0,size-1 do
        for col=0,size-1 do
            if board[row][col].visible then
                count = count + 1
            end
        end
    end

    return count

end

function setImmediateNeighborCellsVisible(row,col,size,board)


    if row ~= 0 and col ~= size-1
        board[row-1][col+1].visible = true;
    end
    if col ~= size-1
        board[row][col+1].visible = true;
    end
    if row ~= size-1 and col ~= size-1
        board[row+1][col+1].visible = true;
    end
    if  row ~= 0
        board[row-1][col].visible = true;
    end
    if row ~= size-1
        board[row-1][col].visible = true;
    end
    if row ~= 0 and col ~= 0
        board[row-1][col-1].visible = true;
    end
    if col ~= 0
        board[row][col-1].visible = true;
    end
    if row ~= size-1 and col ~= 0
        board[row+1][col-1].visible = true;
    end


end

function valid(row,col,size)

    if row < 0 or row >=size
        return 0
    else if col < 0 or col >= size
        return 0
    else
        return 1
    end

end

function setAllNeighborCellsVisible(row,col,size,board)

    if board[row][col].mine == 0 then
        for i=-1,1
            for j=-1,1
                if i == 0 and j == 0 then
                    board[row][col].visible = true;
                else
                    if valid(row+1,col+j,size) and ~board[row+i][col+j].visible then
                        setAllNeighborCellsVisible(row+i,col+j,size,board)
                    end
                end

            end
        end
        setImmediateNeighborCellsVisible(row,col,size,board)
    end

end


--currently assuming 0 index
function initBoard(size, board)
	for i=0,size-1 do
		for j=0,size-1 do
			board[i][j] = Cell:create()
		end
	end
     return board
end

function placeMinesOnBoard(size, board, nbrMines)
	for i=0,nbrMines-1 do
		repeat
			row = math.random(size) - 1
			col = math.random(size) - 1
		until board[row][col].is_mine == false
		board[row][col].is_mine = true
	end
end

function main()
	displayMines = false
	gameState = "INPROGRESS"

	print("!!!!!WELCOME TO THE MINESWEEPER GAME!!!!!")

	size = get_board_size()	

	--2d array
	board = {}
	for i=0, size-1 do
		board[i] = {}
	end
	initBoard(size,board)

	nbrMines = size * size * (get_percent_mine()/100)

end

main()
