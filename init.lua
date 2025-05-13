-- LUALOCALS < ---------------------------------------------------------
local include, core, nodecore, nc
    = include, core, nodecore, nc
-- LUALOCALS > ---------------------------------------------------------
include("creel")
include("basket")
include("aism")
include("craft")
--include("sift")
include("hints")
------------------------------------------------------------------------
core.override_item("nc_woodwork:form",
	{groups = {
		choppy = 1,
		flammable = 2,
		fire_fuel = 1,
		totable = 1,
		storebox = -1,
		visinv = 1,
		basketable = 1,
		container = 2
	}}
)

-- Permit both styles of form to be attached to creel handle.
core.override_item("nc_woodwork:form_braced",
	{groups = {
		choppy = 1,
		flammable = 2,
		fire_fuel = 1,
		totable = 1,
		storebox = -1,
		visinv = 1,
		basketable = 1,
		container = 2
	}}
)

