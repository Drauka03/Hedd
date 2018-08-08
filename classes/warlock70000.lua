-- get the addon namespace
local addon, ns = ...

-- get the config values
local cfg = ns.cfg

-- get the library
local lib = ns.lib
if cfg.Game.release>=7 then
lib.classes["WARLOCK"] = {}
local t,s,n
lib.classpreload["WARLOCK"] = function()
	lib.SetPower("Mana")
end
lib.classes["WARLOCK"][1] = function()
	lib.SetAltPower("SOUL_SHARDS")
	cfg.talents={
		["Absolute Corruption"]=IsPlayerSpell(196103),
		--["SoD"]=IsPlayerSpell(162448),
		--["CoP"]=IsPlayerSpell(155246),
		--["Entropy"]=IsPlayerSpell(155361) --Void Entropy
	}
	lib.AddSpell("Agony",{980},"target")
	lib.SetDOT("Agony")
	lib.AddSpell("Unstable Affliction",{30108})
	--cfg.walock_ua=8*0.3
	lib.AddSpell("Corruption",{172})
	lib.AddSpell("Haunt",{48181},"target")
	lib.AddAura("Corruption",146739,"debuff","target")
	lib.AddAura("Unstable Affliction",233490,"debuff","target")
	lib.AddSpell("Siphon Life",{63106},"target")
	lib.AddSpell("Drain",{198590,689},"target")
	--lib.AddSpell("Soul Effigy",{205178}) --,"target"
	lib.AddSpell("Life Tap",{1454})
	lib.AddSpell("Shadow Bolt",{232670})
	lib.AddSpell("Phantom Singularity",{205179},"target")
	lib.AddSpell("Deathbolt",{264106})
	
	lib.SetAuraRefresh("Agony",18*0.3)
	lib.SetAuraRefresh("Siphon Life",15*0.3)
	--lib.SetAuraRefresh("Unstable Affliction",0)
	lib.AddTracking("Unstable Affliction",{255,0,0})
	lib.AddTracking("Agony",{0,255,0})
	if cfg.talents["Absolute Corruption"] then
		lib.SetAuraRefresh("Corruption",0)
	else
		lib.SetAuraRefresh("Corruption",14*0.3)
		lib.AddTracking("Corruption",{0,0,255})
	end
	lib.AddTracking("Siphon Life",{0,255,0})

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Agony")
	table.insert(cfg.plistdps,"Corruption")
	table.insert(cfg.plistdps,"Soul Effigy")
	table.insert(cfg.plistdps,"Siphon Life")
	table.insert(cfg.plistdps,"Unstable Affliction5")
	table.insert(cfg.plistdps,"Unstable Affliction4")
	table.insert(cfg.plistdps,"Haunt")
	table.insert(cfg.plistdps,"Life Tap")
	table.insert(cfg.plistdps,"Deathbolt")
	table.insert(cfg.plistdps,"Phantom Singularity")
	table.insert(cfg.plistdps,"Unstable Affliction_re")
	table.insert(cfg.plistdps,"Drain")
	table.insert(cfg.plistdps,"Shadow Bolt")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe=nil

	cfg.plist=cfg.plistdps

	cfg.case = {
		["Soul Effigy"] = function ()
			return lib.SimpleCDCheck("Soul Effigy",lib.GetAura({"Soul Effigy"}))
		end,
		["Agony"] = function ()
			return lib.SimpleCDCheck("Agony",lib.GetAura({"Agony"})-lib.GetAuraRefresh("Agony"))
		end,
		["Drain"] = function ()
			return lib.SimpleCDCheck("Drain",lib.SpellChannelingLeft("Drain"))
		end,
		["Corruption"] = function ()
			return lib.SimpleCDCheck("Corruption",lib.GetAura({"Corruption"})-lib.GetAuraRefresh("Corruption"))
		end,
		["Siphon Life"] = function ()
			return lib.SimpleCDCheck("Siphon Life",lib.GetAura({"Siphon Life"})-lib.GetAuraRefresh("Siphon Life"))
		end,
		
		["Unstable Affliction4"] = function ()
			if cfg.AltPower.now==4 then
				if lib.SpellCasting("Unstable Affliction") then return nil end
				return lib.SimpleCDCheck("Unstable Affliction")
			end
			return nil
		end,
		["Unstable Affliction5"] = function ()
			if cfg.AltPower.now==5 then
				--if lib.SpellCasting("Unstable Affliction") then return nil end
				return lib.SimpleCDCheck("Unstable Affliction")
			end
			return nil
		end,
		["Life Tap"] = function ()
			if cfg.Power.now<5*lib.GetSpellCost("Agony") then
				return lib.SimpleCDCheck("Life Tap")
			end
			return nil
		end,
		["Unstable Affliction_dump"] = function ()
			if lib.SpellCasting("Unstable Affliction") and cfg.AltPower.now==1 then return nil end
			if cfg.AltPower.now>0 and lib.GetAura({"Unstable Affliction"})>lib.GetSpellCD("Unstable Affliction")+lib.GetSpellCT("Unstable Affliction") then
				return lib.SimpleCDCheck("Unstable Affliction")
			end
			return nil
		end,
		["Unstable Affliction_re"] = function ()
			if lib.SpellCasting("Unstable Affliction") then return nil end
			if cfg.AltPower.now>0 then
				return lib.SimpleCDCheck("Unstable Affliction",lib.GetAura({"Unstable Affliction"})-lib.GetSpellCT("Unstable Affliction"))
			end
			return nil
		end,
	}
	cfg.warlock_effigy=0
	function Heddclassevents.COMBAT_LOG_EVENT_UNFILTERED()
		local timeStamp, eventtype,_,sourceGUID,sourceName,_,_,destGUID,destName,_,_,SpellID,spellName,_,_,interrupt = CombatLogGetCurrentEventInfo()
		if string.find(eventtype,"SUMMON") and SpellID==lib.GetSpellID("Soul Effigy") and sourceGUID == cfg.GUID["player"] then
			cfg.warlock_effigy=destGUID
			--print(eventtype.." "..sourceGUID.." "..sourceName.." "..SpellID.." "..spellName.." "..destGUID)
		end
	end
	lib.AddRangeCheck({
	{"Agony",nil}
	})
	return true
end

lib.classpostload["WARLOCK"] = function()
--	lib.AddSpell("Halo",{120517})
--	lib.AddDispellPlayer("Cleanse",{4987},{"Disease","Poison"})
--	lib.AddDispellTarget("Dispell_target",{528},{"Magic"})
--	lib.SetInterrupt("Kick",{15487})

	lib.CD = function()
		lib.CDadd("Kick")
		lib.CDadd("Soul Effigy")
		lib.CDaddTimers("Soul Effigy","Soul Effigy",function(self, event, unitID, castid, SpellID)
			if event=="UNIT_SPELLCAST_SUCCEEDED" and unitID=="player" and SpellID==lib.GetSpellID("Soul Effigy") then
				CooldownFrame_SetTimer(self.cooldown,GetTime(),10*60,1)
			end
		end
		,{"UNIT_SPELLCAST_SUCCEEDED"})
		--lib.CDaddBar("Soul Effigy",18*1.3)
	end


end
end
