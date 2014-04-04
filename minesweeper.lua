
--[[
a ={};
a['is_mine'] = false;
a['nbr_mines'] = 0;
a['visible'] = false;
--]]




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



function main()
	
	get_board_size()
	get_percent_mine()

end

main()
