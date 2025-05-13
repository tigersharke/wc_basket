-- LUALOCALS < ---------------------------------------------------------
local ItemStack, ipairs, math, minetest, nodecore, pairs, type
    = ItemStack, ipairs, math, minetest, nodecore, pairs, type
local math_random
    = math.random
-- LUALOCALS > ---------------------------------------------------------

local modname = core.get_current_modname()

local metadesc = "Creel (@1 / @2)"
nc.translate_inform(metadesc)

local function protected(pos, whom)
	return whom and whom:is_player()
	and core.is_protected(pos, whom:get_player_name())
end

local function basketfill(stack, meta, data, ser)
	meta = meta or stack:get_meta()
	if data and #data then
		stack:set_name(modname .. ":handle_full")
		meta:set_string("carrying", ser or core.serialize(data))
		local slots = #data
		local full = 0
		for _, s in ipairs(data) do
			local ss = s.m and nc.stack_get_serial(s.m)
			if ss and not ss:is_empty() then
				full = full + 1
			end
		end
		meta:set_string("description", nc.translate(metadesc, full, slots))
	else
		stack:set_name(modname .. ":handle")
		meta:set_string("carrying", "")
		meta:set_string("description", "")
	end
	return stack
end

local function basketdug(pos, _, _, digger)
	local drop = ItemStack(modname .. ":handle")
	if not (digger and digger:get_player_control().sneak) then
		local dump
		for dx = -1, 1 do
			for dz = -1, 1 do
				local p = {x = pos.x + dx, y = pos.y, z = pos.z + dz}
				local n = core.get_node(p)
				local d = core.registered_items[n.name] or {}
				if d and d.groups and d.groups.basketable
				and not protected(p, digger) then
					local m = nc.meta_serializable(core.get_meta(p))
					for _, v1 in pairs(m.inventory or {}) do
						for k2, v2 in pairs(v1) do
							if type(v2) == "userdata" then
								v1[k2] = v2:to_string()
							end
						end
					end
					dump = dump or {}
					dump[#dump + 1] = {
						x = dx,
						z = dz,
						n = n,
						m = m
					}
					core.remove_node(p)
				end
			end
		end
		basketfill(drop, nil, dump)
	end
	core.handle_node_drops(pos, {drop}, digger)
end

local function basketplace(stack, placer, pointed, ...)
	local pos = nc.buildable_to(pointed.under) and pointed.under
	or nc.buildable_to(pointed.above) and pointed.above
	if (not pos) or nc.protection_test(pos, placer) then return end

	stack = ItemStack(stack)
	local inv = stack:get_meta():get_string("carrying")
	inv = inv and (inv ~= "") and core.deserialize(inv)
	if not inv then return core.item_place(stack, placer, pointed, ...) end

	local commit = {{pos, {
				name = modname .. ":handle",
				param2 = placer and core.dir_to_facedir(placer:get_look_dir())
				or math_random(0, 3)
	}, {}}}
	for _, v in ipairs(inv) do
		if commit then
			local p = {x = pos.x + v.x, y = pos.y, z = pos.z + v.z}
			if (not nc.buildable_to(p)) or protected(p, placer) then
				commit = nil
			else
				commit[#commit + 1] = {p, v.n, v.m}
			end
		end
	end
	if commit then
		for _, v in ipairs(commit) do
			nc.set_loud(v[1], v[2])
			core.get_meta(v[1]):from_table(v[3])
			nc.fallcheck(v[1])
		end
		stack:set_count(stack:get_count() - 1)
	end
	return stack
end

local function basket_ignite(pos)
	local stack = nc.stack_get(pos)
	if core.get_item_group(stack:get_name(), "basket") < 1 then return true end

	local stackmeta = stack:get_meta()
	local raw = stackmeta:get_string("carrying")
	local inv = raw and (raw ~= "") and core.deserialize(raw)
	if not inv then return true end

	local newinv = {}
	for _, slot in pairs(inv) do
		local nn = slot and slot.n and slot.n.name
		local flam = core.get_item_group(nn, "flammable")
		if flam > 0 then
			nc.item_eject(pos, nn)
			local ss = slot and slot.m and nc.stack_get_serial(slot.m)
			if ss and not ss:is_empty() then
				nc.item_eject(pos, ss)
			end
		else
			newinv[#newinv + 1] = slot
		end
	end
	local newraw = core.serialize(newinv)
	if newraw == raw then return true end

	basketfill(stack, stackmeta, newinv, newraw)
	nc.stack_set(pos, stack)
	return true
end

local txr_sides = "(nc_tree_tree_side.png^[mask:nc_tote_sides.png)"
local txr_bot = "nc_flora_wicker.png^(" ..txr_sides.. ")"
local txr_handle = "nc_tree_tree_side.png^nc_flora_wicker.png"
local txr_top = txr_handle .. "^[transformFX^[mask:nc_tote_top.png^[transformR90^" .. txr_sides

local function reg(suff, inner, def)
	return core.register_node(modname .. ":handle" .. suff, nc.underride(def, {
				description = "Creel Handle",
				drawtype = "mesh",
				visual_scale = nc.z_fight_ratio,
				mesh = "nc_tote_handle.obj",
				selection_box = nc.fixedbox(),
				paramtype = "light",
				paramtype2 = "facedir",
				tiles = {
					txr_sides,
					txr_bot,
					txr_top,
					txr_handle,
					inner
				},
				backface_culling = true,
				use_texture_alpha = "clip",
				groups = {
					snappy = 1,
					flammable = 1,
					basket = 1,
					scaling_time = 60
				},
				on_ignite = basket_ignite,
				after_dig_node = basketdug,
				on_place = basketplace,
				on_place_node = basketplace,
				drop = "",
				sounds = nc.sounds("nc_tree_sticky")
			}))
end
reg("", "[combine:1x1", {
		stack_max = 8,
-- Allow a creel handle to be contained by either form style, possibly other wood containers. 
-- Lode handles can be placed in a lode crate or lode form, so this makes it consistent.
--		groups = {container = 1}
	})
reg("_full", "nc_flora_wicker.png", {
		stack_max = 1,
		node_placement_prediction = "",
		groups = {container = 100}
	})
