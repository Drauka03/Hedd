-- get the addon namespace
local addon, ns = ...

-- get the config values
local cfg = ns.cfg

-- get the library
local lib = ns.lib

lib.classes["MAGE"] = {}
local t,s,n

lib.classes["MAGE"][10] = function() -- Arcane
	lib.InitCleave()
	lib.SetPower("Mana")
	lib.SetAltPower("ArcaneCharges")

	cfg.talents={
		["Amplification"]=IsPlayerSpell(236628),
		["Rule of Threes"]=IsPlayerSpell(264354),
		["Arcane Familiar"]=IsPlayerSpell(205022),
		["Mana Shield"]=IsPlayerSpell(235463),
		["Shimmer"]=IsPlayerSpell(212653),
		["Slipstream"]=IsPlayerSpell(236457),
		["Incanter's Flow"]=IsPlayerSpell(1463),
		["Mirror Image"]=IsPlayerSpell(55342),
		["Rune of Power"]=IsPlayerSpell(116011),
		["Resonance"]=IsPlayerSpell(205028),
		["Charged Up"]=IsPlayerSpell(205032),
		["Supernova"]=IsPlayerSpell(157980),
		["Chrono Shift"]=IsPlayerSpell(235711),
		["Ice Ward"]=IsPlayerSpell(205036),
		["Ring of Frost"]=IsPlayerSpell(113724),
		["Reverberate"]=IsPlayerSpell(281482),
		["Touch of the Magi"]=IsPlayerSpell(210725),
		["Nether Tempest"]=IsPlayerSpell(114923),
		["Overpowered"]=IsPlayerSpell(155147),
		["Time Anomaly"]=IsPlayerSpell(210805),
		["Arcane Orb"]=IsPlayerSpell(153626),
	}


	lib.AddSpell("Arcane Barrage",{44425})
	lib.AddSpell("Arcane Blast",{30451})
	lib.AddSpell("Arcane Explosion",{1449})
	lib.AddSpell("Arcane Familiar",{205022})
	lib.AddSpell("Arcane Missiles",{5143})
	lib.AddSpell("Arcane Orb",{153626})
	lib.AddSpell("Arcane Power",{12042})
	lib.AddSpell("Blink",{1953,212653}) -- blink,shimmer
	lib.AddSpell("Charged Up",{205032})
	lib.AddSpell("Evocation",{12051})
	lib.AddSpell("Mirror Image",{55342})
	lib.AddSpell("Nether Tempest",{114923})
	lib.AddSpell("Presence of Mind",{502025})
	lib.AddSpell("Ring of Frost",{113724})
	lib.AddSpell("Rune of Power",{116011})
	lib.AddSpell("Supernova",{157980})
	-- lib.AddSpell("",{})

	lib.AddAura("Arcane Intellect",1459,"buff","player")
	lib.AddAura("Arcane Power",12042,"buff","player")
	lib.AddAura("Clearcasting",263725,"buff","player")
	lib.AddAura("Nether Tempest",114923,"debuff","target")
	lib.AddAura("Presence of Mind",205025,"buff","player")
	lib.AddAura("Rule of Threes",264774,"buff","player")
	lib.AddAura("Rune of Power",116014,"buff","player")

	-- cfg.burn_phase initiate when
		-- if lib.GetSpellCD("Arcane Power")<1
		-- if cfg.AltPower.now>4 or (cfg.talents["Charged Up"] and cfg.AltPower.now<=2)
		-- if lib.GetSpellCharges("Rune of Power")>1
		-- if not cfg.talents("Overpowered") and cfg.Power.now>=50
		-- if cfg.talents("Overpowered") and cfg.Power.now>=30
	-- until mana < 3% then Evocate then initiate conserve phase.

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Charged Up_burn")
	table.insert(cfg.plistdps,"Arcane Orb_burn")
	table.insert(cfg.plistdps,"Nether Tempest_burn")
	table.insert(cfg.plistdps,"Mirror Image_burn")
	table.insert(cfg.plistdps,"Rune of Power_burn")
	table.insert(cfg.plistdps,"Arcane Power_burn")
	table.insert(cfg.plistdps,"Presence of Mind_burn")
	table.insert(cfg.plistdps,"Arcane Barrage_burn")
	table.insert(cfg.plistdps,"Arcane Explosion_burn")
	table.insert(cfg.plistdps,"Arcane Missiles_burn")
	table.insert(cfg.plistdps,"Arcane Blast_burn")
	table.insert(cfg.plistdps,"Evocation_burn")
	table.insert(cfg.plistdps,"Arcane Barrage_burnfiller")
	table.insert(cfg.plistdps,"end")

	cfg.plist=cfg.plistdps

	cfg.case = {
	["Arcane Barrage_burn"] = function()
		if cfg.cleave_targets>=3 and cfg.AltPower.now>=4 then
			return lib.SimpleCDCheck("Arcane Barrage")
		end
		return nil
	end,
	["Arcane Barrage_burnfiller"] = function()
		if lib.GetSpellCD("Evocate")>1 and cfg.Power.now<3 then
			return lib.SimpleCDCheck("Arcane Barrage")
		end
		return nil
	end,
	["Arcane Blast_burn"] = function()
		return lib.SimpleCDCheck("Arcane Blast")
	end,
	["Arcane Explosion_burn"] = function()
		if cfg.cleave_targets>=3 and cfg.AltPower.now<cfg.AltPower.max then
			return lib.SimpleCDCheck("Arcane Explosion")
		end
		return nil
	end,
	["Arcane Missiles_burn"] = function()
		if lib.GetAura("Clearcasting") and cfg.Power.now<=95 then
			return lib.SimpleCDCheck("Arcane Missiles")
		end
		return nil
	end,
	["Arcane Orb_burn"] = function()
		if cfg.AltPower.now<4 then
			return lib.SimpleCDCheck("Arcane Orb")
		end
	return nil
	end,
	["Arcane Power_burn"] = function()
		return lib.SimpleCDCheck("Arcane Power")
	end,
	["Charged Up_burn"] = function()
		if cfg.AltPower.now<=2 then
			return lib.SimpleCDCheck("Charged Up")
		end
	return nil
	end,
	["Evocation_burn"] = function()
		if cfg.Power.now<3 then
			return lib.SimpleCDCheck("Evocation")
		end
		return nil
	end,
	["Mirror Image_burn"] = function()
			return SimpleCDCheck("Mirror Image")
	end,
	["Nether Tempest_burn"] = function()
		if cfg.AltPower.now==4 and
		lib.GetAura("Nether Tempest")<=3 and
		not lib.GetAura("Arcane Power") and
		not lib.GetAura("Rune of Power") then
			return lib.SimpleCDCheck("Nether Tempest")
		end
		return nil
	end,
	["Presence of Mind_burn"] = function()
		return lib.SimpleCDCheck("Presence of Mind")
	end,
	["Rune of Power_burn"] = function()
			return SimpleCDCheck("Rune of Power")
	end,
	}
		return true
	end


lib.classes["MAGE"][2] = function() -- Fire
	lib.InitCleave()
	cfg.talents = lib.ScanTalents()
	lib.ScanSpells()
	lib.SetPower("Mana")

	cfg.talents={
		[""]=IsPlayerSpell(),
		[""]=IsPlayerSpell(),

	}

	-- lib.AddSpell("",{})

	lib.AddAura("Combustion",190319,"buff","player")
	lib.AddAura("Heating Up",48107,"buff","player")
	lib.AddAura("Hot Streak",48108,"buff","player")
	lib.AddAura("Pyroclasm",269651,"buff","player")
	lib.AddAura("Rune of Power",116014,"buff","player")

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Rune of Power_combustion")
	table.insert(cfg.plistdps,"Meteor")
	table.insert(cfg.plistdps,"Combustion")
	table.insert(cfg.plistdps,"Rune of Power_2")
	table.insert(cfg.plistdps,"Pyroblast_pyroclasm")
	table.insert(cfg.plistdps,"Phoenix Flames")
	table.insert(cfg.plistdps,"Flamestrike_aoe8")
	table.insert(cfg.plistdps,"Pyroblast_hotstreak")
	table.insert(cfg.plistdps,"Living Bomb_aoe3")
	table.insert(cfg.plistdps,"Dragon's Breath")
	table.insert(cfg.plistdps,"Fire Blast")
	table.insert(cfg.plistdps,"Scorch")
	table.insert(cfg.plistdps,"Fireball")
	table.insert(cfg.plistdps,"end")

	cfg.plist=cfg.plistdps

	cfg.case = {
		["Combustion"] = function()
			if (cfg.talents["Rune of Power"] and lib.GetAura("Rune of Power")) or
			not cfg.talents["Rune of Power"] then
				return lib.SimpleCDCheck("Combustion")
			end
			return nil
		end,
		["Dragon's Breath"] = function()
			if cfg.cleave_targets>=8 or cfg.talents["Alexstrasza's Fury"] then
				return lib.SimpleCDCheck("Dragon's Breath")
			end
			return nil
		end,
		["Fireball"] = function()
			if lib.GetAura({"Hot Streak"}) then return nil end
			-- if lib.GetAura({"Heating up"}) then return nil end
			-- if lib.SpellCasting("Fireball") then return nil end
			return lib.SimpleCDCheck("Fireball")
		end,
		["Fire Blast"] = function()
			if lib.GetAura({"Heating Up"}) then
				return lib.SimpleCDCheck("Fire Blast")
			end
			return nil
		end,
		["Flamestrike_aoe8"] = function()
			if cfg.cleave_targets>=8 and lib.GetAura({"Hot Streak"}) then
				return lib.SimpleCDCheck("Flamestrike")
			end
			return nil
		end,
		["Living Bomb_aoe3"] = function()
			if cfg.cleave_targets>=3 then
				return lib.SimpleCDCheck("Living Bomb")
			end
			return nil
		end,
		["Meteor"] = function()
			if (cfg.talents["Rune of Power"] and lib.GetAura({"Rune of Power"})) or
			not cfg.talents["Rune of Power"] then
				return lib.SimpleCDCheck("Meteor")
			end
			return nil
		end,
		["Phoenix Flames"] = function()
			if lib.GetSpellStacks("Phoenix Flames")>2 then
				return lib.SimpleCDCheck("Phoenix Flames")
			end
			return nil
		end,
		["Pyroblast_hotstreak"] = function()
			if lib.GetAura({"Hot Streak"}) then
				return lib.SimpleCDCheck("Pyroblast")
			end
			return nil
		end,
		["Pyroblast_pyroclasm"] = function()
			if lib.GetAura({"Combustion"}) and lib.GetAura("Pyroclasm")>4.7 then return nil end
			if lib.GetAura({"Pyroclasm"}) then
				return lib.SimpleCDCheck("Pyroblast")
			end
			return nil
		end,
		["Rune of Power_combustion"] = function()
			if lib.SpellCasting("Rune of Power") then return nil end
			if lib.GetSpellCD("Combustion")<1 then
				return lib.SimpleCDCheck("Rune of Power")
			end
			return nil
		end,
		["Rune of Power_2"] = function()
			if lib.SpellCasting("Rune of Power") then return nil end
			if lib.GetSpellStacks("Rune of Power")==2 or
			((lib.GetAura({"Pyroclasm"}) and
			(lib.GetAura({"Rune of Power"})<4.7 and lib.GetSpellCD("Combustion")>39))) then
				return lib.SimpleCDCheck("Rune of power")
			end
			return nil
		end,
		["Scorch"] = function()
			if lib.GetAura({"Hot Streak"}) then return nil end
			if cfg.talents["Searing Touch"] and lib.GetUnitHealth("target","percent")>30 then
				return lib.SimpleCDCheck("Scorch")
			end
			return nil
		end,
	}
		return true
	end

lib.classes["MAGE"][3] = function() -- Frost
	lib.InitCleave()
	cfg.talents = lib.ScanTalents()
	lib.ScanSpells()
	lib.SetPower("Mana")
	-- lib.SetAltPower("  ")

	lib.AddAura("Clearcasting",000,"buff","player")

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"  ")
	table.insert(cfg.plistdps,"end")

	cfg.plist=cfg.plistdps

	cfg.case = {
	[" "] = function()
	end,
	}
		return true
	end


lib.classpostload["MAGE"] = function()

	lib.CD = function()
		lib.CDadd("Arcane Power")
		lib.CDadd("Evocation")
		lib.CDadd("Arcane Intellect")
		lib.CDadd("Polymorph")
		lib.CDadd("Greater Invisibility")
	end

end
