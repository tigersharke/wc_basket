-- LUALOCALS < ---------------------------------------------------------
local ItemStack, minetest, nodecore, pairs
    = ItemStack, minetest, nodecore, pairs
-- LUALOCALS > ---------------------------------------------------------

nodecore.register_aism({
		label = "Packed Wicker Basket AISMs",
		interval = 1,
		chance = 1,
		itemnames = {"group:basket"},
		action = function(stack, data)
			local stackmeta = stack:get_meta()
			local raw = stackmeta:get_string("carrying")
			local inv = raw and (raw ~= "") and minetest.deserialize(raw)
			if not inv then return end

			local dirty
			for _, slot in pairs(inv) do
				-- Modern format
				local ncitem = slot and slot.m and slot.m.fields
				and slot.m.fields.ncitem
				if ncitem then
					local istack = ItemStack(ncitem)
					if not istack:is_empty() then
						local sdata = {
							pos = data.pos,
							basketslot = slot,
							set = function(s)
								local ss = s:to_string()
								if ss ~= ncitem then
									slot.m.fields.ncitem = ss
									dirty = true
								end
							end
						}
						nodecore.aism_check_stack(istack, sdata)
					end
				end
				-- Legacy format
				for lname, list in pairs(slot and slot.m and slot.m.inventory or {}) do
					for sub, item in pairs(list) do
						local istack = ItemStack(item)
						if not istack:is_empty() then
							local sdata = {
								pos = data.pos,
								basketslot = slot,
								basketlistname = lname,
								basketlist = list,
								basketsubslot = sub,
								set = function(s)
									list[sub] = s:to_string()
									dirty = true
								end
							}
							nodecore.aism_check_stack(istack, sdata)
						end
					end
				end
			end
			if not dirty then return end

			stackmeta:set_string("carrying", minetest.serialize(inv))
			return stack
		end
	})
