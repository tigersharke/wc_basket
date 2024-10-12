-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
local rfcall = function(pos, data)
	local ref = minetest.get_player_by_name(data.pname)
	local wield = ref:get_wielded_item()
	wield:take_item(1)
	ref:set_wielded_item(wield)
end
------------------------------------------------------------------------
local bark = "nc_tree_tree_side.png^[mask:nc_api_storebox_frame.png"
local wick = "nc_flora_wicker.png^(" .. bark .. ")"
local ratt = "nc_flora_thatch.png^(" .. bark .. ")"
------------------------------------------------------------------------
minetest.register_node(modname .. ":shelf_wicker", {
	description = "Wicker Basket",
	tiles = {wick, wick, bark},
	use_alpha_texture = "clip",
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		choppy = 1,
		visinv = 1,
		flammable = 1,
		fire_fuel = 3,
		storebox = 1,
		totable = 1,
		basketable = 1,
		scaling_time = 50
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_tree_sticky"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end,
	on_ignite = function(pos)
		if minetest.get_node(pos).name == modname .. ":shelf_wicker" then
			return nodecore.stack_get(pos)
		end
	end
})
------------------------------------------------------------------------
minetest.register_node(modname .. ":shelf_thatch", {
	description = "Rattan Basket",
	tiles = {ratt, ratt, bark},
	use_alpha_texture = "clip",
	selection_box = nodecore.fixedbox(),
	collision_box = nodecore.fixedbox(),
	groups = {
		choppy = 1,
		visinv = 1,
		flammable = 1,
		fire_fuel = 3,
		storebox = 1,
		totable = 1,
		basketable = 1,
		scaling_time = 50
	},
	paramtype = "light",
	sounds = nodecore.sounds("nc_terrain_swishy"),
	storebox_access = function(pt) return pt.above.y > pt.under.y end,
	on_ignite = function(pos)
		if minetest.get_node(pos).name == modname .. ":shelf_thatch" then
			return nodecore.stack_get(pos)
		end
	end
})
------------------------------------------------------------------------