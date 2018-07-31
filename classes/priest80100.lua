-- get the addon namespace
local addon, ns = ...

-- get the config values
local cfg = ns.cfg

-- get the library
local lib = ns.lib

lib.classes["PRIEST"] = {}
local t,s,n
lib.classpreload["PRIEST"] = function()
	cfg.cleave_threshold=3
end
-- SHADOW SPEC
lib.classes["PRIEST"][3] = function()
	lib.SetPower("Insanity")
	lib.SetAltPower("Mana")

	cfg.talents = lib.ScanTalents()
	lib.ScanSpells()

	lib.AddAura("Shadow Word: Pain", 589, "debuff", "target")
	lib.AddAura("Shadowform", 232698, "buff", "player")
	lib.AddAura("Vampiric Touch", 34914, "debuff", "target")
	lib.AddAura("Voidform", 194249, "buff", "player")

	lib.RemoveSpell("Smite")
	lib.RemoveSpell("Void Bolt")
	lib.RemoveSpell("Void Eruption")
	lib.AddSpell("Mind Flay", {15407})
	lib.AddSpell("Shadow Word: Void", {205351})
	lib.AddSpell("Void Bolt", {228266})
	lib.AddSpell("Void Eruption", {228260})

	cfg.voidform_cost = 90
	if cfg.talents["Legacy of the Void"] then
		cfg.voidform_cost = 60
	end

	cfg.plistdps = {}
	table.insert(cfg.plistdps, "Shadowform")
	table.insert(cfg.plistdps, "Kick")
	table.insert(cfg.plistdps, "Purify Disease")
	if not cfg.talents["Mindbender"] then
		table.insert(cfg.plistdps, "Shadowfiend")
	end
	table.insert(cfg.plistdps, "Vampiric Touch")
	if cfg.talents["Misery"] then
		table.insert(cfg.plistdps, "Shadow Word: Pain_misery")
	else
		table.insert(cfg.plistdps, "Shadow Word: Pain")
	end
	table.insert(cfg.plistdps, "Void Eruption")
	table.insert(cfg.plistdps, "Void Bolt")
	if cfg.talents["Shadow Word: Void"] then
		table.insert(cfg.plistdps, "Shadow Word: Void")
	else
		table.insert(cfg.plistdps, "Mind Blast")
	end
	if cfg.talents["Shadow Word: Death"] then
		table.insert(cfg.plistdps, "Shadow Word: Death")
	end
	if cfg.talents["Mindbender"] then
		table.insert(cfg.plistdps, "Mindbender")
	end
	if cfg.talents["Dark Void"] then
		table.insert(cfg.plistdps, "Dark Void")
	end
	if cfg.talents["Shadow Crash"] then
		table.insert(cfg.plistdps, "Shadow Crash")
	end
	if cfg.talents["Void Torrent"] then
		table.insert(cfg.plistdps, "Void Torrent")
	end
	table.insert(cfg.plistdps, "Mind Flay")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe = nil
	cfg.plist=cfg.plistdps

	cfg.case = {
		["Shadowform"] = function()
			if lib.UnitHasAura("player", "Shadowform") or lib.UnitHasAura("player", "Voidform") then return nil end
			return lib.SimpleCDCheck("Shadowform")
		end,
		["Vampiric Touch"] = function()
			return lib.SimpleCDCheck("Vampiric Touch", lib.GetAura({"Vampiric Touch"}))
		end,
		["Shadow Word: Pain"] = function()
			return lib.SimpleCDCheck("Shadow Word: Pain", lib.GetAura({"Shadow Word: Pain"}))
		end,
		["Shadow Word: Pain_misery"] = function()
			return lib.SimpleCDCheck("Vampiric Touch", lib.GetAura({"Shadow Word: Pain"}))
		end,
		["Void Eruption"] = function()
			if cfg.Power.now < cfg.voidform_cost or lib.UnitHasAura("player", "Voidform") then return nil end
			local res = lib.SimpleCDCheck("Void Eruption")
			-- if res then
			-- 	lib.SetSpellIcon("Void Eruption", 1386548)
			-- end
			return res
		end,
		["Void Bolt"] = function()
			if not lib.UnitHasAura("player", "Voidform") then return nil end
			local res = lib.SimpleCDCheck("Void Eruption")
			-- if res then
			-- 	lib.SetSpellIcon("Void Eruption", 1035040)
			-- end
			return res
		end,
		["Mindbender"] = function()
			if lib.GetAuraStacks({"Voidform"}) < 5 or lib.GetAuraStacks({"Voidform"}) > 10 then return nil end
			return lib.SimpleCDCheck("Mindbender")
		end,
		["Mind Flay"] = function()
			return lib.SimpleCDCheck("Mind Flay")
		end,
	}
	lib.AddRangeCheck({
	-- {"Tiger Palm",nil},
	-- {"Keg Smash",{0,0,1,1}},
	})

	return true
end

lib.classpostload["PRIEST"] = function()
	cfg.healpercent=80
	lib.AddDispellPlayer("Purify Disease",{213634},{"Disease"})
	lib.SetInterrupt("Kick",{15487}) -- Silence

	lib.CD = function()
		lib.CDadd("Kick")
		lib.CDadd("Purify Disease")
		-- lib.CDadd("Ironskin Brew")
		-- lib.CDadd("Purifying Brew")
		-- lib.CDadd("Black Ox Brew")
		-- lib.CDadd("Exploding Keg")
		--
		-- lib.CDadd("Energizing Elixir")
		-- lib.CDadd("Touch of Death")
		-- lib.CDadd("Serenity")
		-- lib.CDadd("Storm, Earth, and Fire")
		-- lib.CDadd("Zen Meditation")
		-- lib.CDturnoff("Zen Meditation")
		-- lib.CDadd("Fortifying Brew")
		-- lib.CDturnoff("Fortifying Brew")
		-- lib.CDadd("Dampen Harm")
		-- lib.CDturnoff("Dampen Harm")
		-- lib.CDadd("Touch of Karma")
		-- lib.CDturnoff("Touch of Karma")
		-- lib.CDadd("Fortifying")
		-- lib.CDturnoff("Fortifying")
		-- lib.CDadd("Flying Serpent Kick")
		-- lib.CDadd("Chi Wave")
		-- lib.CDadd("Chi Burst")
		-- lib.CDadd("Sphere")
		-- lib.CDadd("Healing Elixir")
		-- lib.CDadd("Vivify")
		-- lib.CDadd("Transcendence: Transfer")
		-- lib.CDadd("Transcendence")
	end
end
