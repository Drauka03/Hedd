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
	lib.InitCleave()

	cfg.talents = lib.ScanTalents()
	lib.ScanSpells()

	lib.AddAura("Shadow Word: Pain", 589, "debuff", "target")
	lib.AddAura("Shadowform", 232698, "buff", "player")
	lib.AddAura("Vampiric Touch", 34914, "debuff", "target")
	lib.AddAura("Voidform", 194249, "buff", "player")

	lib.RemoveSpell("Smite")
	lib.RemoveSpell("Void Bolt")
	lib.RemoveSpell("Void Eruption")
	lib.RemoveSpell("Shadowfiend")
	lib.AddSpell("Mind Flay", {15407})
	lib.AddSpell("Shadow Word: Void", {205351})
	lib.AddSpell("Void Bolt", {228266})
	lib.AddSpell("Void Eruption", {228260})
	lib.AddSpell("Shadowfiend", {34433})
	lib.AddSpell("Mindbender", {200174})

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
	if cfg.talents["Dark Void"] then
		table.insert(cfg.plistdps, "Dark Void_aoe")
	elseif cfg.talents["Misery"] then
		table.insert(cfg.plistdps, "Vampiric Touch_aoe")
	end
	table.insert(cfg.plistdps, "Vampiric Touch")
	if cfg.talents["Misery"] then
		table.insert(cfg.plistdps, "Shadow Word: Pain_misery")
	else
		table.insert(cfg.plistdps, "Shadow Word: Pain")
	end
	if cfg.talents["Shadow Crash"] then
		table.insert(cfg.plistdps, "Shadow Crash_aoe")
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
	table.insert(cfg.plistdps, "Mind Sear")
	table.insert(cfg.plistdps, "Mind Flay")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe = nil
	cfg.plist=cfg.plistdps

	cfg.case = {
		["Shadowform"] = function()
			if lib.UnitHasAura("player", "Shadowform") or lib.UnitHasAura("player", "Voidform") then return nil end
			return lib.SimpleCDCheck("Shadowform")
		end,
		["Dark Void_aoe"] = function()
			if cfg.cleave_targets < cfg.cleave_threshold then return nil end
			return lib.SimpleCDCheck("Dark Void")
		end,
		["Vampiric Touch_aoe"] = function()
			if cfg.cleave_targets < cfg.cleave_threshold then return nil end
			return lib.SimpleCDCheck("Vampiric Touch", lib.GetAura({"Vampiric Touch"}))
		end,
		["Vampiric Touch"] = function()
			if cfg.cleave_targets >= cfg.cleave_threshold then return nil end
			return lib.SimpleCDCheck("Vampiric Touch", lib.GetAura({"Vampiric Touch"}))
		end,
		["Shadow Word: Pain"] = function()
			return lib.SimpleCDCheck("Shadow Word: Pain", lib.GetAura({"Shadow Word: Pain"}))
		end,
		["Shadow Word: Pain_misery"] = function()
			return lib.SimpleCDCheck("Vampiric Touch", lib.GetAura({"Shadow Word: Pain"}))
		end,
		["Shadow Crash_aoe"] = function()
			if cfg.cleave_targets < cfg.cleave_threshold then return nil end
			return lib.SimpleCDCheck("Shadow Crash")
		end,
		["Void Eruption"] = function()
			if cfg.Power.now < cfg.voidform_cost or lib.UnitHasAura("player", "Voidform") then return nil end
			return lib.SimpleCDCheck("Void Eruption")
		end,
		["Void Bolt"] = function()
			if not lib.UnitHasAura("player", "Voidform") then return nil end
			return lib.SimpleCDCheck("Void Eruption")
		end,
		["Shadow Word: Void"] = function()
			if cfg.cleave_targets > 5 then return nil end
			return lib.SimpleCDCheck("Shadow Word: Void")
		end,
		["Mind Blast"] = function()
			if cfg.cleave_targets > 5 then return nil end
			return lib.SimpleCDCheck("Mind Blast")
		end,
		["Mindbender"] = function()
			-- if lib.GetAuraStacks("Voidform") < 5 or lib.GetAuraStacks("Voidform") > 10 then return nil end
			return lib.SimpleCDCheck("Mindbender")
		end,
		["Mind Sear"] = function()
			if cfg.cleave_targets <= 2 then return nil end
			return lib.SimpleCDCheck("Mind Sear")
		end,
		["Mind Flay"] = function()
			return lib.SimpleCDCheck("Mind Flay")
		end,
	}
	lib.AddRangeCheck({
		{"Vampiric Touch", nil}
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
		lib.CDadd("Shadowfiend")
		-- lib.CDadd("Mindbender")
		lib.CDadd("Dark Ascension")
		lib.CDadd("Surrender to Madness")
	end
end
