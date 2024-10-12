-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
nodecore.register_craft({
	label = "craft creel handle",
	action = "stackapply",
	indexkeys = {"nc_woodwork:form"},
	wield = {name = "nc_woodwork:frame"},
	consumewield = 1,
	nodes = {
		{
			match = {name = "nc_woodwork:form", empty = true},
			replace = modname .. ":handle"
		},
	}
})
nodecore.register_craft({
	label = "break apart creel",
	action = "pummel",
	toolgroups = {choppy = 3},
	check = function(pos, data)
		if data.node.name == modname .. ":handle" then return true end
		local stack = nodecore.stack_get(pos)
		if stack:get_name() ~= modname .. ":handle" then return end
		return (stack:get_meta():get_string("carrying") or "") == ""
	end,
	indexkeys = {modname .. ":handle"},
	nodes = {
		{
			match = modname .. ":handle",
			replace = "air"
		}
	},
	items = {
		{name = "nc_woodwork:staff 2", count = 4, scatter = 5}
	}
})
------------------------------------------------------------------------
nodecore.register_craft({
	label = "assemble wicker basket",
	action = "stackapply",
	indexkeys = {"nc_woodwork:form"},
	wield = {name = "nc_flora:wicker"},
	consumewield = 1,
	nodes = {
		{
			match = {name = "nc_woodwork:form", empty = true},
			replace = modname .. ":shelf_wicker"
		},
	}
})
nodecore.register_craft({
	label = "assemble rattan basket",
	action = "stackapply",
	indexkeys = {"nc_woodwork:form"},
	wield = {name = "nc_flora:thatch"},
	consumewield = 1,
	nodes = {
		{
			match = {name = "nc_woodwork:form", empty = true},
			replace = modname .. ":shelf_thatch"
		},
	}
})
------------------------------------------------------------------------