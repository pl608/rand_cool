rand_cool = {}
rand_cool.ore = {}
function get_len()-- cause idk the standard way :P
	local  i = 0
	for _,item in  pairs(rand_cool.ore) do i=i+1 end
	return i
end

local function add_ores()
	local iter = 1
	for _,item in  pairs(minetest.registered_ores) do
		if minetest.registered_nodes[item.ore] then
			local drop = minetest.registered_nodes[item.ore].drop
			if type(drop) == "string"
			and item.ore_type == "scatter"
			and item.wherein == "default:stone"
			and item.clust_scarcity ~= nil and item.clust_scarcity > 0
			and item.clust_num_ores ~= nil and item.clust_num_ores > 0
			and item.y_max ~= nil and item.y_min ~= nil then
				rand_cool.ore[iter] =  tostring(item.ore)
				rand_cool.ore[iter+1] = 'default:stone'-- to offset tons of diamonds+mese
				minetest.log('[Rand_Cool] loaded >> '..tostring(item.ore))
				iter = iter + 2
			end
		end
	end
	
end

math.randomseed(100)
local function get_ore()
	local rand = math.ceil(math.random()*get_len())
	if rand_cool.ore[rand] == nil then return get_ore() end
	return rand_cool.ore[rand]
end

default.cool_lava = function(pos, node)
	if node.name == "default:lava_source" then
		minetest.set_node(pos, {name = "default:obsidian"})
    else -- Lava flowing
		minetest.set_node(pos, {name = get_ore()})
	end
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.2}, true)
end
minetest.register_on_mods_loaded(function()
	add_ores()
end)
