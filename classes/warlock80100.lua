-- get the addon namespace
local addon, ns = ...

-- get the config values
local cfg = ns.cfg

-- get the library
local lib = ns.lib

lib.classes["WARLOCK"] = {}
local t,s,n

lib.classes["WARLOCK"][1] = function() -- Affliction
	lib.InitCleave()
	lib.SetPower("Mana")
	lib.SetAltPower("SoulShards")

	cfg.talents={
		["Nightfall"]=IsPlayerSpell(108558),
		["Drain Soul"]=IsPlayerSpell(198590),
		["Deathbolt"]=IsPlayerSpell(264106),
		["Writhe in Agony"]=IsPLayerSpell(196102),
		["Absolute Corruption"]=IsPlayerSpell(196103),
		["Siphon Life"]=IsPlayerSpell(63106),
		["Demon Skin"]=IsPlayerSpell(219272),
		["Burning Rush"]=IsPlayerSpell(111400),
		["Dark Pact"]=IsPlayerSpell(108416),
		["Sow the Seeds"]=IsPlayerSpell(196226),
		["Phantom Singularity"]=IsPlayerSpell(205179),
		["Vile Taint"]=IsPlayerSpell(278350),
		["Darkfury"]=IsPlayerSpell(264874),
		["Mortal Coil"]=IsPlayerSpell(6789),
		["Demonic Circle"]=IsPlayerSpell(268358),
		["Shadow Embrace"]=IsPlayerSpell(32388),
		["Haunt"]=IsPlayerSpell(48181),
		["Grimoire of Sacrifice"]=IsPlayerSpell(108503),
		["Soul Conduit"]=IsPlayerSpell(215941),
		["Creeping Death"]=IsPlayerSpell(264000),
		["Dark Soul: Misery"]=IsPlayerSpell(113860),
	}

	lib.AddSpell("Agony",{980})
	lib.AddSpell("Corruption",{172})
	lib.AddSpell("Dark Soul: Misery",{113860})
	lib.AddSpell("Deathbolt",{264106})
	lib.AddSpell("Drain Life",{234153})
	lib.AddSpell("Drain Soul",{198590})
	lib.AddSpell("Grimoire of Sacrifice",{108503})
	lib.AddSpell("Haunt",{48181})
	lib.AddSpell("Health Funnel",{755})
	lib.AddSpell("Phantom Singularity",{205179})
	lib.AddSpell("Seed of Corruption",{27243})
	lib.AddSpell("Shadow Bolt",{686,232670})
	lib.AddSpell("Siphon Life",{63106})
	lib.AddSpell("Summon Darkglare",{205180})
	lib.AddSpell("Unstable Affliction",{30108})
	lib.AddSpell("Vile Taint",{278350})

	lib.AddAura("Grimoire of Sacrifice",196099,"buff","player")
	lib.AddAura("Agony",980,"debuff","target")
	cfg.warlock_agony=18*0.3
	lib.AddAura("Corruption",146739,"debuff","target")
	cfg.warlock_corruption=14*0.3
	lib.AddAura("Siphon Life",63106,"debuff","target")
	cfg.warlock_siphon=15*0.3
	lib.AddAura("Unstable Affliction",233490,"debuff","target")
	cfg.warlock_ua=(8*0.3)+1.5  -- +1.5 to account for cast time
	lib.AddAura("Drain Soul",198590,"debuff","target")

	if cfg.talents["Creeping Death"] then	cfg.warlock_agony=15.3*0.3 end
	if cfg.talents["Creeping Death"] then	cfg.warlock_corruption=11.9*0.3	end
	if cfg.talents["Creeping Death"] then	cfg.warlock_siphon=12.8*0.3 end
	if cfg.talents["Creeping Death"] then	cfg.warlock_ua=6.8*0.3 end


	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Sacrifice")
	table.insert(cfg.plistdps,"Agony")
	table.insert(cfg.plistdps,"Seed_aoe")
	table.insert(cfg.plistdps,"Corruption")
	table.insert(cfg.plistdps,"Siphon Life")
	table.insert(cfg.plistdps,"Unstable Affliction_4ss")
	table.insert(cfg.plistdps,"Haunt")
	table.insert(cfg.plistdps,"UA_Darkglare")
	table.insert(cfg.plistdps,"Summon Darkglare")
	table.insert(cfg.plistdps,"UA_Deathbolt")
	table.insert(cfg.plistdps,"Deathbolt")
	table.insert(cfg.plistdps,"Phantom Singularity")
	table.insert(cfg.plistdps,"Unstable Affliction_re")
	table.insert(cfg.plistdps,"Shadow Bolt")
	table.insert(cfg.plistdps,"end")


	cfg.plist=cfg.plistdps

	cfg.case = {
		["Agony"] = function ()
			return lib.SimpleCDCheck("Agony",lib.GetAura({"Agony"})-cfg.warlock_agony)
		end,
		["Corruption"] = function ()
			if lib.SpellCasting("Seed of Corruption") then return nil end
			return lib.SimpleCDCheck("Corruption",lib.GetAura({"Corruption"})-cfg.warlock_corruption)
		end,
		-- ["Drain Soul"] = function ()
		-- 	return lib.SimpleCDCheck("Drain Soul",lib.SpellChannelingLeft("Drain Soul"))
		-- end,
		["Sacrifice"] = function ()
			if not cfg.talents["Grimoire of Sacrifice"] then return nil end
			if lib.GetAura({"Grimoire of Sacrifice"})<=0 then
				return lib.SimpleCDCheck("Grimoire of Sacrifice")
			end
			return nil
		end,
		["Seed_aoe"] = function ()
			if lib.SpellCasting("Seed of Corruption") then return nil end
			if cfg.cleave_targets>=2 then
				return lib.SimpleCDCheck("Seed of Corruption",lib.GetAura({"Corruption"})-cfg.warlock_corruption)
			end
			return nil
		end,
		["Shadow Bolt"] = function ()
			if cfg.talents["Drain Soul"] then
				return lib.SimpleCDCheck("Drain Soul")
			else
				return lib.SimpleCDCheck("Shadow Bolt")
			end
			return nil
		end,
		["Siphon Life"] = function ()
			return lib.SimpleCDCheck("Siphon Life",lib.GetAura({"Siphon Life"})-cfg.warlock_siphon)
		end,
		-- ["Unstable Affliction5"] = function ()
		-- 	--if lib.SpellCasting("Unstable Affliction") then return nil end
		-- 	if cfg.AltPower.now==cfg.AltPower.max then
		-- 		return lib.SimpleCDCheck("Unstable Affliction")
		-- 	end
		-- 	return nil
		-- end,
		["Unstable Affliction_4ss"] = function ()
			--if lib.SpellCasting("Unstable Affliction") then return nil end
			if cfg.AltPower.now>=cfg.AltPower.max-1 then
				return lib.SimpleCDCheck("Unstable Affliction")
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
			if lib.SpellCasting("Unstable Affliction") and cfg.AltPower.now==1 then return nil end
			if cfg.AltPower.now>0 then
				return lib.SimpleCDCheck("Unstable Affliction",lib.GetAura({"Unstable Affliction"})-cfg.warlock_ua-lib.GetSpellCT("Unstable Affliction"))
			end
			return nil
		end,
		["UA_Darkglare"] = function () -- stacking UA before Darkglare to gain more benefit from the timer extension
			if lib.GetSpellCD("Darkglare")<=3 and cfg.AltPower.now>=3 then
				return lib.SimpleCDCheck("Unstable Affliction")
			end
			return nil
		end,
		["UA_Deathbolt"] = function () -- stacking UA before Deathbolt to gain more benefit from the % damage
			if not cfg.talents["Deathbolt"] then return nil end
			if lib.GetSpellCD("Deathbolt")<=3 and cfg.AltPower.now>=3 then
				return lib.SimpleCDCheck("Unstable Affliction")
			end
			return nil
		end,
	}
	lib.AddRangeCheck({
	{"Agony",nil}
	})
	return true
end

lib.classes["WARLOCK"][2] = function() -- Demonology
	lib.InitCleave()
	lib.SetPower("Mana")
	lib.SetAltPower("SoulShards")

	cfg.talents={
		["Dreadlash"]=IsPlayerSpell(264078),
		["Demonic Strength"]=IsPlayerSpell(267171),
		["Bilescourge Bombers"]=IsPlayerSpell(267211),
		["Demonic Calling"]=IsPlayerSpell(205145),
		["Power Siphon"]=IsPlayerSpell(264130),
		["Doom"]=IsPlayerSpell(265412),
		["Demon Skin"]=IsPlayerSpell(219272),
		["Burning Rush"]=IsPlayerSpell(111400),
		["Dark Pact"]=IsPlayerSpell(108416),
		["From the Shadows"]=IsPlayerSpell(267170),
		["Soul Strike"]=IsPlayerSpell(264057),
		["Summon Vilefiend"]=IsPlayerSpell(264119),
		["Darkfury"]=IsPlayerSpell(264874),
		["Mortal Coil"]=IsPlayerSpell(6789),
		["Demonic Circle"]=IsPlayerSpell(268358),
		["Soul Conduit"]=IsPlayerSpell(215941),
		["Inner Demons"]=IsPlayerSpell(267216),
		["Grimoire: Felguard"]=IsPlayerSpell(111898),
		["Sacrificed Souls"]=IsPlayerSpell(267214),
		["Demonic Consumption"]=IsPlayerSpell(267215),
		["Nether Portal"]=IsPlayerSpell(267217)
	}

	lib.AddSpell("Bilescourge Bombers",{267211})
	lib.AddSpell("Call Dreadstalkers",{104316})
	lib.AddSpell("Demonbolt",{264178})
	lib.AddSpell("Demonic Core",{267102})
	lib.AddSpell("Demonic Strength",{267171})
	lib.AddSpell("Doom",{265412})
	lib.AddSpell("Drain Life",{234153})
	lib.AddSpell("Soul Strike",{264057})
	lib.AddSpell("Grimoire: Felguard",{111898})
	lib.AddSpell("Hand of Gul'dan",{105174})
	lib.AddSpell("Health Funnel",{755})
	lib.AddSpell("Implosion",{196277})
	lib.AddSpell("Nether Portal",{267217})
	lib.AddSpell("Power Siphon",{264130})
	lib.AddSpell("Shadow Bolt",{686,232670})
	lib.AddSpell("Summon Demonic Tyrant",{265187})
	lib.AddSpell("Summon Vilefiend",{264119})
	lib.AddSpell("Summon Felguard",{30146})

	lib.AddAura("Doom",265412,"debuff","target")
	lib.AddAura("Demonic Core",264173,"buff","player")

	cfg.plistdps = {}
	-- table.insert(cfg.plistdps,"Felguard") - need to fix pet type tracking
	table.insert(cfg.plistdps,"Doom")
	table.insert(cfg.plistdps,"Nether Portal_pull")
	table.insert(cfg.plistdps,"Call Dreadstalkers")
	table.insert(cfg.plistdps,"Grimoire: Felguard")
	table.insert(cfg.plistdps,"Demonic Strength")
	table.insert(cfg.plistdps,"Summon Vilefiend")
	table.insert(cfg.plistdps,"Nether Portal")
	table.insert(cfg.plistdps,"Demonbolt_Tyrant")
	table.insert(cfg.plistdps,"Hand of Gul'dan_Tyrant")
	table.insert(cfg.plistdps,"Summon Demonic Tyrant")
	table.insert(cfg.plistdps,"Hand of Gul'dan_4ss")
	table.insert(cfg.plistdps,"Demonbolt_2dc")
	table.insert(cfg.plistdps,"Bilescourge Bombers")
	table.insert(cfg.plistdps,"Power Siphon")
	table.insert(cfg.plistdps,"Hand of Gul'dan_3ss")
	-- table.insert(cfg.plistdps,"Implosion_aoe2") -- need to fix imp tracking
	table.insert(cfg.plistdps,"Shadow Bolt")
	table.insert(cfg.plistdps,"end")


	cfg.plist=cfg.plistdps

	cfg.case = {
		["Call Dreadstalkers"] = function()
			if lib.SpellCasting("Call Dreadstalkers") then return nil end
			return lib.SimpleCDCheck("Call Dreadstalkers")
		end,
		["Demonbolt_2dc"] = function()
			if cfg.AltPower.now>=cfg.AltPower.max-2 then return nil end
			if lib.GetAuraStacks("Demonic Core")>=2 then
				return lib.SimpleCDCheck("Demonbolt")
			end
			return nil
		end,
		["Demonbolt_Tyrant"] = function()
			if cfg.AltPower.now>=cfg.AltPower.max-2 then return nil end
			if lib.GetSpellCD("Summon Demonic Tyrant")>5 and
			lib.GetSpellCD("Summon Demonic Tyrant")<15 then
				return lib.SimpleCDCheck("Demonbolt")
			end
			return nil
		end,
		-- ["Felguard"] = function() -- Need to use pet type instead of pet name
		-- 	if UnitName("pet") == "Felguard" then return nil end
		-- 	return lib.SimpleCDCheck("Summon Felguard")
		-- end,
		["Hand of Gul'dan_4ss"] = function()
			if cfg.talents["Nether Portal"] and lib.GetSpellCD("Nether Portal")<3 then return nil end
			if cfg.talents["Summon Vilefiend"] and lib.GetSpellCD("Summon Vilefiend")<3 then return nil end
			if cfg.talents["Bilescourge Bombers"] and lib.GetSpellCD("Bilescourge Bombers")<3 then return nil end
			if lib.GetSpellCD("Call Dreadstalkers")<3 then return nil end
			if lib.SpellCasting("Hand of Gul'dan") then return nil end
			if cfg.AltPower.now>=4 then
				return lib.SimpleCDCheck("Hand of Gul'dan")
			end
			return nil
		end,
		["Hand of Gul'dan_3ss"] = function()
			if cfg.talents["Nether Portal"] and lib.GetSpellCD("Nether Portal")<3 then return nil end
			if cfg.talents["Summon Vilefiend"] and lib.GetSpellCD("Summon Vilefiend")<3 then return nil end
			if cfg.talents["Bilescourge Bombers"] and lib.GetSpellCD("Bilescourge Bombers")<3 then return nil end
			if lib.GetSpellCD("Call Dreadstalkers")<3 then return nil end
			if lib.SpellCasting("Hand of Gul'dan") then return nil end
			if cfg.AltPower.now>=3 then
				return lib.SimpleCDCheck("Hand of Gul'dan")
			end
			return nil
		end,
		["Hand of Gul'dan_Tyrant"] = function()
			if lib.GetSpellCD("Summon Demonic Tyrant")>5 and
			lib.GetSpellCD("Summon Demonic Tyrant")<15 then
				return lib.SimpleCDCheck("Hand of Gul'dan")
			end
			return nil
		end,
		["Implosion_aoe2"] = function() -- Need to test how to cast with imps about to die or every 2-3 HoG'D casts
			if cfg.cleave_targets>=2 then
				return lib.SimpleCDCheck("Implosion")
			end
			return nil
		end,
		["Nether Portal"] = function()
			if not cfg.talents["Nether Portal"] then return nil end
			if lib.SpellCasting("Nether Portal") then return nil end
			if lib.GetSpellCD("Summon Demonic Tyrant")<16 then --using ahead of Tyrant to get some demons rolling out
				return lib.SimpleCDCheck("Nether Portal")
			end
			return nil
		end,
		["Nether Portal_pull"] = function()
			if not cfg.talents["Nether Portal"] then return nil end
			if lib.SpellCasting("Nether Portal") then return nil end
			if lib.GetSpellCD("Summon Demonic Tyrant")==0 and
			lib.GetSpellCD("Call Dreadstalkers")==0 and
			lib.GetSpellCD("Summon Vilefiend")==0 then
				return lib.SimpleCDCheck("Nether Portal")
			end
			return nil
		end,
		["Power Siphon"] =  function()
			if not cfg.talents["Power Siphon"] then return nil end
			if lib.GetAuraStacks("Demonic Core")>=2 then return nil end
			if lib.GetSpellCD("Summon Demonic Tyrant")<30 and
			lib.GetSpellCD("Summon Demonic Tyrant")>10 then
				return nil end
			return lib.SimpleCDCheck("Power Siphon")
		end,
		["Shadow Bolt"] = function()
			-- if lib.SpellCasting("Shadow Bolt") then return nil end
			return lib.SimpleCDCheck("Shadow Bolt")
		end,
		["Summon Demonic Tyrant"] = function()
			if lib.SpellCasting("Summon Demonic Tyrant") then return nil end
			if lib.GetSpellCD("Summon Vilefiend")>30 and
			lib.GetSpellCD("Call Dreadstalkers")>8 then
				return lib.SimpleCDCheck("Summon Demonic Tyrant")
			end
			return nil
		end,
		["Summon Vilefiend"] = function()
			if not cfg.talents["Summon Vilefiend"] then return nil end
			if lib.SpellCasting("Summon Vilefiend") then return nil end
			return lib.SimpleCDCheck("Summon Vilefiend")
		end,
	}
		return true
	end

	lib.classes["WARLOCK"][3] = function() -- Destro
		lib.InitCleave()
		cfg.talents = lib.ScanTalents()
		lib.ScanSpells()
		lib.SetPower("Mana")
		lib.SetAltPower("SoulShards")

		cfg.talents={
			["Flahsover"]=IsPlayerSpell(),
			["Eradication"]=IsPlayerSpell(),
			["Soul Fire"]=IsPlayerSpell(),
			["Reverse Entropy"]=IsPlayerSpell(),
			["Internal Combustion"]=IsPlayerSpell(),
			["Shadowburn"]=IsPlayerSpell(),
			["Demon Skin"]=IsPlayerSpell(),
			["Burning Rush"]=IsPlayerSpell(),
			["Dark Pact"]=IsPlayerSpell(),
			["Inferno"]=IsPlayerSpell(),
			["Fire and Brimstone"]=IsPlayerSpell(),
			["Cataclysm"]=IsPlayerSpell(),
			["Darkfury"]=IsPlayerSpell(),
			["Mortal Coil"]=IsPlayerSpell(),
			["Demonic Circle"]=IsPlayerSpell(),
			["Roaring Blaze"]=IsPlayerSpell(),
			["Grimoire of Supremacy"]=IsPlayerSpell(),
			["Grimoire of Sacrifice"]=IsPlayerSpell(),
			["Soul Conduit"]=IsPlayerSpell(),
			["Channel Demonfire"]=IsPlayerSpell(),
			["Dark Soul: Instability"]=IsPlayerSpell(),
		}


		--lib.AddSpell("",{})

		lib.RemoveSpell("Shadow Bolt")
		lib.RemoveSpell(686)
		lib.AddSpell("Incinerate",{29722},false,false,false,false,true)

		lib.AddAura("Immolate",157736,"debuff","target")
		lib.AddAura("Eradication",196414,"debuff","target")

		cfg.plistdps = {}
		table.insert(cfg.plistdps,"Summon Infernal")
		table.insert(cfg.plistdps,"Immolate")
		-- table.insert(cfg.plistdps,"Rain of Fire") -- leaves no aura to track
		table.insert(cfg.plistdps,"Dark Soul: Instability")
		table.insert(cfg.plistdps,"Chaos Bolt_5")
		table.insert(cfg.plistdps,"Conflagrate_2")
		table.insert(cfg.plistdps,"Channel Demonfire")
		table.insert(cfg.plistdps,"Chaos Bolt_eradication")
		table.insert(cfg.plistdps,"Cataclysm")
		table.insert(cfg.plistdps,"Conflagrate")
		table.insert(cfg.plistdps,"Shadowburn")
		table.insert(cfg.plistdps,"Incinerate")
		table.insert(cfg.plistdps,"end")


		cfg.plist=cfg.plistdps

		cfg.case = {
			["Cataclysm"] = function()
				if lib.SpellCasting("Cataclysm") then return nil end
				return lib.SimpleCDCheck("Cataclysm")
			end,
			["Channel Demonfire"] = function()
				if lib.SpellCasting("Channel Demonfire") then return nil end
				return lib.SimpleCDCheck("Channel Demonfire")
			end,
			["Chaos Bolt_5"] = function()
				if lib.SpellCasting("Chaos Bolt") then return nil end
				if cfg.AltPower.now>=5 then
					return lib.SimpleCDCheck("Chaos Bolt")
				end
				return nil
			end,
			["Chaos Bolt_eradication"] = function()
				if lib.SpellCasting("Chaos Bolt") then return nil end
				if lib.GetAura("Eradication")<=4 then
					return lib.SimpleCDCheck("Chaos Bolt")
				end
				return nil
			end,
			["Conflagrate"] = function()
				if cfg.AltPower.now>=5 then return nil end
				return lib.SimpleCDCheck("Conflagrate")
			end,
			["Conflagrate_2"] = function()
				if cfg.AltPower.now>=5 then return nil end
				if lib.GetSpellCharges("Conflagrate")>=2 then
					return lib.SimpleCDCheck("Conflagrate")
				end
				return nil
			end,
			["Dark Soul: Instability"] = function()
				if lib.GetAura("Immolate")<18 then return nil end
				if cfg.AltPower.now<4 then return nil end
				return lib.SimpleCDCheck("Dark Soul: Instability")
			end,
			["Immolate"] = function()
				if lib.SpellCasting("Immolate") then return nil end
				if lib.GetAura("Immolate")<=6.9 then  -- *0.3 + (1.5s cast time)
					return lib.SimpleCDCheck("Immolate")
				end
				return nil
			end,
			["Incinerate"] = function()
				-- if lib.SpellCasting("Incinerate") return nil end
				if cfg.AltPower.now>=5 then return nil end
				return lib.SimpleCDCheck("Incinerate")
			end,
			["Rain of Fire"] = function()
				if cfg.cleave_targets>=6 then
					return lib.SimpleCDCheck("Rain of Fire")
				end
				return nil
			end,
			}
				return true
			end
lib.classpostload["WARLOCK"] = function()

	lib.CD = function()
		lib.CDadd("Dark Soul: Misery")
		lib.CDadd("Unending Resolve")
		lib.CDadd("Summon Darkglare")
		lib.CDadd("Summon Infernal")
		lib.CDadd("Grimoire of Sacrifice")
		lib.CDadd("Grimoire:Felguard")
		lib.CDadd("Summon Demonic Tyrant")
		lib.CDadd("Nether Portal")
		lib.CDadd("Summon Vilefiend")
		lib.CDadd("Call Dreadstalkers")
		lib.CDadd("Create Soulwell")
		lib.CDadd("Soulstone")
	end

end