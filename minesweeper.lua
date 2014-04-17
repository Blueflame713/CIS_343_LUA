
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
	validSize = false
	while not validSize do
		print("Enter the board size (5 .. 15): ")
		size = io.read("*number")
		if size >= 5 and size <= 15 then
			validSize = true
		else
			print("Invalid board size.")
		end
	end
	return size
end


function get_percent_mine()
--IO needed in this to get percent
	validPercent = false
	while not validPercent do
		print("Enter the percentage of mines on the board (10 .. 70): ")
		percent = io.read("*number")
		if percent >= 10 and percent <= 70 then
			validPercent = true
		else
			print("Invalid percentage.")
		end
	end
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

function nbrVisibleCells(size)
    
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

function valid(row,col,size)

    if row < 0 or row >=size then
        return false
    elseif col < 0 or col >= size then
        return false
    else
        return true
    end

end

function setImmediateNeighborCellsVisible(row,col,size)


    if valid(row-1,col+1,size) then
        board[row-1][col+1].visible = true;
    end
    if valid(row,col+1,size) then
        board[row][col+1].visible = true;
    end
    if valid(row+1,col+1,size) then
        board[row+1][col+1].visible = true;
    end
    if valid(row-1,col,size) then
        board[row-1][col].visible = true;
    end
    if valid(row+1,col,size) then
        board[row+1][col].visible = true;
    end
    if valid(row-1,col-1,size) then
        board[row-1][col-1].visible = true;
    end
    if valid(row,col-1,size) then
        board[row][col-1].visible = true;
    end
    if valid(row+1,col-1,size) then
        board[row+1][col-1].visible = true;
    end

end


function setAllNeighborCellsVisible(row,col,size)
    if board[row][col].nbr_mines == 0 then
       print(board[row][col])
				 for i=-1,1 do
           for j=-1,1 do
                if i == 0 and j == 0 then
                    board[row][col].visible = true;
                else
                    if valid(row+i,col+j,size) and board[row+i][col+j].visible== false  then
                        setAllNeighborCellsVisible(row+i,col+j,size)
                    end
                end

            end
        end
        setImmediateNeighborCellsVisible(row,col,size)
    end
	
end


--currently assuming 0 index
function initBoard(size)
	for i=0,size-1 do
		for j=0,size-1 do
			board[i][j] = Cell:create()
		end
	end
     return board
end

function placeMinesOnBoard(size, nbrMines)
	math.randomseed( os.time() )
	for i=0,nbrMines-1 do
		repeat
			row = math.random(size) - 1
			col = math.random(size) - 1
		until board[row][col].is_mine == false
		board[row][col].is_mine = true
	end
end

function fillInMineCountForNonMineCells(size)
	for row=0,size-1 do
		for col=0,size-1 do
			if board[row][col].is_mine == false then
				board[row][col].nbr_mines = getNbrNeighborMines(row, col, size)
			end
		end 
	end
end

function nbrOfMines(size)
	count = 0
	for row=0,size-1 do
		for col=0, size-1 do
			if board[row][col].is_mine then
				count = count + 1
			end
		end
	end
	return count
end

function getNbrNeighborMines(row, col, size)
	count=0; rStart=-1; rFinish=1 ; cStart=-1; cFinish=1
	if row == 0 then rStart = 0 end
	if col == 0 then cStart = 0 end
	if row == size-1 then rFinish = 0 end
	if col == size-1 then cFinish = 0 end

	for vert = rStart, rFinish do
		for horiz = cStart, cFinish do
			if board[row+vert][col+horiz].is_mine then
				count = count + 1
			end
		end
	end
	return count
end

function displayBoard(size, displayMines)
	str = "\n"
	--prints top row
	for a=0,size do
		if not a == 0 then
			if a > 9 then
				str = str .. "\b"
			end
			str = str .. " " .. a .. " "
		else
			str = str .. "   "
		end
	end
	str = str .. "\n"

	--other rows
	for row=0,size-1 do
		if row+1 < 10 then
			str= str .. " "
		end
		str = str .. row + 1 .. " "
		for col=0,size-1 do
			if not board[row][col].visible then
				if not displayMines then
					str = str .. " ? "
				else
					if board[row][col].is_mine then
						str = str .. " * "
					else
						str = str .. " ? "
					end
				end
			else
				if board[row][col].is_mine then
					str = str .. " * "
				else
					str = str .. " " .. board[row][col].nbr_mines .. " "
				end
			end
		end
		str = str .. "\n"
	end
	str = str .. "\n"
	print(str)
end

function selectCell (row, col, size)
	board[row][col].visible = true
	if board[row][col].is_mine then
		return "LOST"
	elseif board[row][col].nbr_mines == 0 then
		setAllNeighborCellsVisible(row, col, size)
	end

	if nbrVisibleCells(size)+nbrOfMines(size) == size*size then
		return "WON"
	end

	return "INPROGRESS"
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
	initBoard(size)

	nbrMines = size * size * (get_percent_mine()/100)

	placeMinesOnBoard(size, nbrMines)

	fillInMineCountForNonMineCells(size)

	displayBoard(size, displayMines)


	while true do
		print("Enter command (m/M for command menu): ")
		command = io.read("*line")
		
		if command == "m" or command == "M" then
			displayMenu()

		elseif command == "c" or command == "C" then
			repeat
				print("Enter row and column of cell: ")
				row, col = io.read("*number","*number")
				if row < 1 or row > size or col < 1 or col > size then
					print("Invalid row or column values. Try again.")
				end
			until not(row < 1 or row > size or col < 1 or col > size)
			row = row - 1
			col = col - 1
			gameState = selectCell(row, col, size)
			displayBoard(size, displayMines)

		elseif command == "s" or command == "S" then
			displayMines = true
			displayBoard(size, displayMines)

		elseif command == "h" or command == "H" then
			displayMines = false
			displayBoard(size, displayMines)

		elseif command == "b" or command == "B" then
			displayBoard(size, displayMines)

		elseif command == "q" or command == "Q" then
			print("Bye.")
			return

		else
			print("Invalid command. Try again.")
		end
	
		if (gameState == "WON") then
			print("You found all the mines. Congratulations. Bye.")
			return
		elseif (gameState == "LOST") then
			print("Oops. Sorry, you landed on a mine. Bye.")
			return
		end

	end
end

main()
