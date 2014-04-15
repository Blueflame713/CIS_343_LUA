
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
	
	return percent;
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
