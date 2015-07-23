--[[

Skyblock for MineTest

Copyright (c) 2015 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-skyblock
License: GPLv3

LEVEL 2 FUNCTIONS

]]--


--
-- PUBLIC FUNCTIONS
--

local level = 2
levels[level] = {}


-- get pos
levels[level].get_pos = function(player_name)
	skyblock.log('level['..level..'].get_pos() for '..player_name)
	local pos = skyblock.get_spawn(player_name)
	if pos==nil then return pos end
	return {x=pos.x,y=pos.y+15,z=pos.z}
end


-- make start blocks
levels[level].make_start_blocks = function(player_name)
	skyblock.log('level['..level..'].make_start_blocks() for '..player_name)
	local pos = levels[level].get_pos(player_name)
	if pos==nil then return end
	
	-- sphere
	local radius = 3
	local hollow = 1
	skyblock.make_sphere({x=pos.x,y=pos.y-radius,z=pos.z},radius,'default:dirt',hollow)
	minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name='default:water_source'})

	-- level 2
	minetest.env:add_node(pos, {name='skyblock:level_2'})
	achievements.update(level,player_name)

end


-- update achievements
levels[level].update = function(player_name,pos)
	local formspec = ''
	local total = 10
	local count = 0

	formspec = formspec
		..'size[15,10;]'
		..'label[0,0;LEVEL '..level..' FOR: '.. player_name ..']'
		..'label[13.4,0; rewards]'
		..'list[current_name;rewards;13,0.5;2,2;]'
		..'list[current_player;main;0,6;8,4;]'

		..'label[0,1; --== A View From Above ==--]'
		..'label[0,1.5; Wow, look at that view... of... nothing.]'
		..'label[0,2.0; You should get to work extending this]'
		..'label[0,2.5; island.  Perhaps you could build some]'
		..'label[0,3.0; structures too?]'
		
		..'label[0,4; --== About The Level '..level..' Block ==--]'
		..'label[0,4.5; * SHORT LEFT CLICK]'
		..'label[0.4,5; = PUNCH to refresh achievements]'

	-- place water infinite
	formspec = formspec..'label[8,0; 1) create an Infinite Water Source]'
	if achievements.get(level,player_name,'place_water_infinite') >= 1 then
		formspec = formspec .. 'label[8.3,0.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,0.4; not done]'
	end

	-- place 200 dirt
	formspec = formspec..'label[8,1; 2) extend your Island with 200 Dirt]'
	if achievements.get(level,player_name,'place_dirt') >= 200 then
		formspec = formspec .. 'label[8.3,1.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,1.4; not done]'
	end

	-- place 50 wood
	formspec = formspec..'label[8,2; 3) build a structure using 50 Wood]'
	if achievements.get(level,player_name,'place_wood') >= 50 then
		formspec = formspec .. 'label[8.3,2.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,2.4; not done]'
	end

	-- place 50 brick
	formspec = formspec..'label[8,3; 4) build a structure using 50 Brick]'
	if achievements.get(level,player_name,'place_brick') >= 50 then
		formspec = formspec .. 'label[8.3,3.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,3.4; not done]'
	end

	-- place trapdoor
	formspec = formspec..'label[8,4; 5) place a Trapdoor]'
	if achievements.get(level,player_name,'place_trapdoor') >= 1 then
		formspec = formspec .. 'label[8.3,4.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,4.4; not done]'
	end
	
	-- place 10 ladders
	formspec = formspec..'label[8,5; 6) place 10 Ladders]'
	if achievements.get(level,player_name,'place_ladder') >= 10 then
		formspec = formspec .. 'label[8.3,5.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,5.4; not done]'
	end

	-- place 20 wood fences
	formspec = formspec..'label[8,6; 7) place 20 Wood Fences]'
	if achievements.get(level,player_name,'place_fence_wood') >= 20 then
		formspec = formspec .. 'label[8.3,6.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,6.4; not done]'
	end
	
	-- dig 4 iron lumps
	formspec = formspec..'label[8,7; 8) dig 4 Iron Lumps]'
	if achievements.get(level,player_name,'dig_stone_with_iron') >= 2 then
		formspec = formspec .. 'label[8.3,7.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,7.4; not done]'
	end
	
	-- place locked chest
	formspec = formspec..'label[8,8; 9) craft and place a Locked Chest]'
	if achievements.get(level,player_name,'place_chest_locked') >= 1 then
		formspec = formspec .. 'label[8.3,8.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,8.4; not done]'
	end

	-- dig 4 copper lumps
	formspec = formspec..'label[8,9; 10) dig 4 Copper Lumps]'
	if achievements.get(level,player_name,'dig_stone_with_copper') >= 2 then
		formspec = formspec .. 'label[8.3,9.4; COMPLETE!]'
		count = count + 1
	else
		formspec = formspec .. 'label[8.3,9.4; not done]'
	end

	-- next level
	if count==total and achievements.get(0,player_name,'level')==level then
		levels[level+1].make_start_blocks(player_name)
		achievements.add(0,player_name,'level')
	end
	if  achievements.get(0,player_name,'level') > level then
		local pos = levels[level+1].get_pos(player_name)
		if pos and minetest.env:get_node(pos).name ~= 'skyblock:level_3' then
			levels[level+1].make_start_blocks(player_name)
		end
	end

	local infotext = 'LEVEL '..level..' for '.. player_name ..': '.. count ..' of '..total
	return formspec, infotext
end


-- reward_achievement
levels[level].reward_achievement = function(player_name,achievement)
	local achievement_count = achievements.get(level,player_name,achievement)
	
	-- place_water_infinite
	if achievement == 'place_water_infinite' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'stairs:stair_wood 5')
		return true
	end

	-- place_dirt
	if achievement == 'place_dirt' and achievement_count == 200 then
		achievements.give_reward(level,player_name,'stairs:stair_brick 5')
		return true
	end
	
	-- place_wood
	if achievement == 'place_wood' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:brick 40')
		return true
	end

	-- place_brick
	if achievement == 'place_brick' and achievement_count == 50 then
		achievements.give_reward(level,player_name,'default:sandstonebrick 50')
		return true
	end
	
	-- place_trapdoor
	if achievement == 'place_trapdoor' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:desert_stonebrick 50')
		return true
	end

	-- place_ladder
	if achievement == 'place_ladder' and achievement_count == 10 then
		achievements.give_reward(level,player_name,'wool:white 50')
		return true
	end

	-- place_fence
	if achievement == 'place_fence' and achievement_count == 20 then
		achievements.give_reward(level,player_name,'default:iron_lump')
		return true
	end
	
	-- dig_stone_with_iron x2
	if achievement == 'dig_stone_with_iron' and achievement_count == 2 then
		achievements.give_reward(level,player_name,'default:desert_cobble 50')
		return true
	end

	-- place_chest_locked
	if achievement == 'place_chest_locked' and achievement_count == 1 then
		achievements.give_reward(level,player_name,'default:copper_lump')
		return true
	end

	-- dig_stone_with_copper x2
	if achievement == 'dig_stone_with_copper' and achievement_count == 2 then
		achievements.give_reward(level,player_name,'default:gold_lump')
		return true
	end
	
end


-- track digging achievements
levels[level].on_dignode = function(pos, oldnode, digger)
	local player_name = digger:get_player_name()

	-- dig_stone_with_iron
	if oldnode.name == 'default:stone_with_iron' then
		achievements.add(level,player_name,'dig_stone_with_iron')
		return
	end
	
	-- dig_stone_with_copper
	if oldnode.name == 'default:stone_with_copper' then
		achievements.add(level,player_name,'dig_stone_with_copper')
		return
	end

end


-- track placing achievements
levels[level].on_placenode = function(pos, newnode, placer, oldnode)
	local player_name = placer:get_player_name()

	-- place_dirt
	if newnode.name == 'default:dirt' then
		achievements.add(level,player_name,'place_dirt')
		return
	end

	-- place_brick
	if newnode.name == 'default:brick' then
		achievements.add(level,player_name,'place_brick')
		return
	end

	-- place_wood
	if newnode.name == 'default:wood' then
		achievements.add(level,player_name,'place_wood')
		return
	end

	-- place_trapdoor
	if newnode.name == 'doors:trapdoor' then
		achievements.add(level,player_name,'place_trapdoor')
		return
	end

	-- place_ladder
	if newnode.name == 'default:ladder' then
		achievements.add(level,player_name,'place_ladder')
		return
	end

	-- place_fence_wood
	if newnode.name == 'default:fence_wood' then
		achievements.add(level,player_name,'place_fence_wood')
		return
	end

	-- place_chest_locked
	if newnode.name == 'default:chest_locked' then
		achievements.add(level,player_name,'place_chest_locked')
		return
	end

end


-- track bucket achievements
levels[level].bucket_on_use = function(player_name, pointed_thing) end


-- track bucket water achievements
levels[level].bucket_water_on_use = function(player_name, pointed_thing) 

	-- place_water_infinite
	local pos = pointed_thing.under
	if minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z-1}).name=='default:water_source' 
	or minetest.env:get_node({x=pos.x-1,y=pos.y,z=pos.z+1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z-1}).name=='default:water_source'
	or minetest.env:get_node({x=pos.x+1,y=pos.y,z=pos.z+1}).name=='default:water_source' then
		achievements.add(level,player_name,'place_water_infinite')
		return
	end

end


-- track bucket lava achievements
levels[level].bucket_lava_on_use = function(player_name, pointed_thing) end