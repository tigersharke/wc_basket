-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

nodecore.register_hint("assemble a creel handle",
	"craft tote handle",
	{"nc_woodwork:form", "nc_woodwork:frame", "group:basketable"}
)

nodecore.register_hint("pack up a complete creel",
	"inv:" .. modname .. ":handle_full",
	"craft creel handle"
)
