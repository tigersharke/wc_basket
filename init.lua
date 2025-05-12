-- LUALOCALS < ---------------------------------------------------------
local include, nodecore
    = include, nodecore
-- LUALOCALS > ---------------------------------------------------------
include("creel")
include("basket")
include("aism")
include("craft")
--include("sift")
include("hints")
------------------------------------------------------------------------
minetest.override_item("nc_woodwork:form",
	{groups = {
		basketable = 1,
		choppy = 1,
		flammable = 2,
		fire_fuel = 1,
		totable = 1,
		storebox = 1,
		visinv = 1
	}}
)

-- Permit both styles of form to be attached to creel handle.
minetest.override_item("nc_woodwork:form_braced",
	{groups = {
		basketable = 1,
		choppy = 1,
		flammable = 2,
		fire_fuel = 1,
		totable = 1,
		storebox = 1,
		visinv = 1
	}}
)

