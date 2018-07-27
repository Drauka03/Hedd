	-- get the addon namespace
local addon, ns = ...

-- get the config values
local cfg = ns.cfg

-- get the library
local lib = ns.lib
local t,s
if cfg.Game.release>6 then
lib.classes["HUNTER"] = {}
lib.classpreload["HUNTER"] = function()
	lib.SetPower("Focus")
	lib.AddResourceBar(cfg.Power.max)
	lib.ChangeResourceBarType(cfg.Power.type)
end

-- BEAST MASTERY SPEC
lib.classes["HUNTER"][1] = function () -- BM
	cfg.talents={
		["Killer Instinct"]=IsPlayerSpell(273887),
		["Animal Companion"]=IsPlayerSpell(267116),
		["Dire Beast"]=IsPlayerSpell(120679),
		["Scent of Blood"]=IsPlayerSpell(193532),
		["One with the Pack"]=IsPlayerSpell(199528),
		["Chimaera Shot"]=IsPlayerSpell(53209),
		["Trailblazer"]=IsPlayerSpell(199921),
		["Natural Mending"]=IsPlayerSpell(270581),
		["Camouflage"]=IsPlayerSpell(199483),
		["Venomous Bite"]=IsPlayerSpell(257891),
		["Thrill of the Hunt"]=IsPlayerSpell(257944),
		["A Murder of Crows"]=IsPlayerSpell(131894),
		["Born To Be Wild"]=IsPlayerSpell(266921),
		["Posthaste"]=IsPlayerSpell(109215),
		["Binding Shot"]=IsPlayerSpell(109248),
		["Stomp"]=IsPlayerSpell(199530),
		["Barrage"]=IsPlayerSpell(120360),
		["Stampede"]=IsPlayerSpell(201430),
		["Aspect of the Beast"]=IsPlayerSpell(191384),
		["Killer Cobra"]=IsPlayerSpell(199532),
		["Spitting Cobra"]=IsPlayerSpell(194407),
	}
	lib.SetSpellIcon("aa",(select(3,GetSpellInfo(75))),true)
	lib.AddSpell("Aspect of the Wild",{193530},true)
	lib.AddSpell("Stampede",{201430})
	lib.AddSpell("Kill Command",{34026})
	lib.AddSpell("Dire Beast",{120679})
	lib.AddAura("Dire Beast",120694,"buff","player")
	lib.AddSpell("Cobra Shot",{193455})
	lib.AddSpell("Multi-Shot",{2643})
	lib.AddSpell("Chimaera Shot",{53209})
	lib.AddSpell("Bestial Wrath",{19574},true)
	lib.AddSpell("A Murder of Crows",{131894},"target")
	lib.AddSpell("Barrage",{120360},nil,nil,true)
	lib.AddAura("Beast Cleave",118455,"buff","pet")
	lib.SetTrackAura("Beast Cleave")
	lib.AddSpell("Misdirection",{34477})
	lib.AddAura("Misdirection",35079,"buff","player")
	lib.AddSpell("Barbed Shot",{217200})
	lib.AddAura("Frenzy",272790,"buff","pet")

	lib.AddTracking("Bestial Wrath",{255,0,0})
	lib.AddTracking("Aspect of the Wild",{0,255,0})
	--lib.AddTracking("Dire Beast",{255,255,0})
	--lib.AddTracking("Dire Frenzy",{255,255,0})

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Kick")
	table.insert(cfg.plistdps,"Mend_pet")
	table.insert(cfg.plistdps,"Misdirection")
	table.insert(cfg.plistdps,"Multi-Shot_5")
	table.insert(cfg.plistdps,"Barbed Shot_noFrenzy")
	table.insert(cfg.plistdps,"Chimaera Shot")
	table.insert(cfg.plistdps,"Kill Command")
	table.insert(cfg.plistdps,"A Murder of Crows")
	table.insert(cfg.plistdps,"Bestial Wrath")
	table.insert(cfg.plistdps,"Aspect of the Wild")
	table.insert(cfg.plistdps,"Multi-Shot_2-4")
	table.insert(cfg.plistdps,"Barrage_aoe")
	table.insert(cfg.plistdps,"Dire Beast")
	table.insert(cfg.plistdps,"Barbed Shot_7s")
	table.insert(cfg.plistdps,"Cobra Shot")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe = nil

	cfg.plist = cfg.plistdps

	cfg.case = {}
	cfg.case = {
		["Misdirection"] = function()
			return lib.SimpleCDCheck("Misdirection",lib.GetAura({"Misdirection"}))
		end,
		["Multi-Shot_5"] = function()
			if cfg.cleave_targets < 5 then return nil end
			return lib.SimpleCDCheck("Multi-Shot", lib.GetAura({"Beast Cleave"}))
		end,
		["Barbed Shot_noFrenzy"] = function()
			if lib.GetSpellCharges("Barbed Shot") > 1 or lib.GetAura({"Frenzy"}) < 2 then
				return lib.SimpleCDCheck("Barbed Shot")
			end
			return nil
		end,
		["Chimaera Shot"] = function()
			if lib.PowerInTime(lib.GetSpellCD("Chimaera Shot"))<=90 then
				return lib.SimpleCDCheck("Chimaera Shot")
			end
			return nil
		end,
		["Multi-Shot_2-4"] = function()
			if cfg.cleave_targets < 2 or cfg.cleave_targets > 4 then return nil end
			return lib.SimpleCDCheck("Multi-Shot", lib.GetAura({"Beast Cleave"}))
		end,
		["Barrage_aoe"] = function()
			if cfg.cleave_targets>1 and lib.GetAura({"Frenzy"}) > 3 then
				return lib.SimpleCDCheck("Barrage")
			end
			return nil
		end,
		["Barbed Shot_7s"] = function()
			if lib.GetSpellCharges("Barbed Shot") == 1 and lib.GetSpellCD("Barbed Shot") < 7 then
				return lib.SimpleCDCheck("Barbed Shot", lib.GetAura({"Frenzy"}))
			end
			return nil
		end,
		["Cobra Shot"] = function()
			if lib.GetSpellCD("Kill Command") < 2.5 then return nil end
			return lib.SimpleCDCheck("Cobra Shot", lib.Time2Power(90))
		end,
	}

	lib.AddRangeCheck({
	{"Cobra Shot",nil}
	})

	return true
end

-- MARKSMAN SPEC
lib.classes["HUNTER"][2] = function () --MM
	cfg.cleave_threshold=3
	cfg.talents={
		["Master Marksman"]=IsPlayerSpell(260309),
		["Serpent Sting"]=IsPlayerSpell(271788),
		["A Murder of Crows"]=IsPlayerSpell(131894),
		["Careful Aim"]=IsPlayerSpell(260228),
		["Volley"]=IsPlayerSpell(260243),
		["Explosive Shot"]=IsPlayerSpell(212431),
		["Trailblazer"]=IsPlayerSpell(199921),
		["Natural Mending"]=IsPlayerSpell(270581),
		["Camouflage"]=IsPlayerSpell(199483),
		["Steady Focus"]=IsPlayerSpell(193533),
		["Stramline"]=IsPlayerSpell(260367),
		["Hunter's Mark"]=IsPlayerSpell(257284),
		["Born To Be Wild"]=IsPlayerSpell(266921),
		["Posthaste"]=IsPlayerSpell(109215),
		["Binding Shot"]=IsPlayerSpell(109248),
		["Lethal Shots"]=IsPlayerSpell(260393),
		["Barrage"]=IsPlayerSpell(120360),
		["Double Tap"]=IsPlayerSpell(260402),
		["Calling the Shots"]=IsPlayerSpell(260404),
		["Lock and Load"]=IsPlayerSpell(194595),
		["Piercing Shot"]=IsPlayerSpell(198670),
	}
	lib.SetSpellIcon("aa",(select(3,GetSpellInfo(75))),true)

	lib.AddSpell("A Murder of Crows",{131894},"target")
	lib.AddSpell("Aimed Shot",{19434})
	lib.AddSpell("Arcane Shot",{185358})
	lib.AddSpell("Barrage",{120360},nil,nil,true)
	lib.AddSpell("Black Arrow",{194599},"target")
	lib.AddSpell("Double Tap",{260402})
	lib.AddSpell("Explosive Shot",{212431})
	lib.AddSpell("Hunter's Mark",{257284})
	lib.AddSpell("Marked Shot",{185901})
	lib.AddSpell("Multi-Shot",{2643})
	lib.AddSpell("Piercing Shot",{198670})
	lib.AddSpell("Rapid Fire",{257044})
	lib.AddSpell("Serpent Sting",{271788})
	lib.AddSpell("Steady Shot",{56641})
	lib.AddSpell("Trueshot",{193526},true)

	lib.AddAura("Hunter's Mark",257284,"debuff","target")
	lib.AddAura("Lock and Load",194594,"buff","player")
	lib.AddAura("Marking Targets",223138,"buff","player")
	lib.AddAura("Precise Shots",260242,"buff","player")
	lib.AddAura("Serpent Sting",271788,"debuff","target")
	lib.AddAura("Steady Focus",193534,"buff","player")
	lib.AddAura("Trick Shots",257622,"buff","player")
	lib.AddAura("True Aim",199803,"debuff","target")

	lib.SetAuraFunction("Lock and Load","OnApply",function() lib.ReloadSpell("Aimed Shot") end)
	lib.SetAuraFunction("Lock and Load","OnFade",function() lib.ReloadSpell("Aimed Shot") end)

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Kick")
	-- TODO: Figure out what to do about Hunter's Mark because it's only worth applying if the enemy will die in 20+ seconds
	if cfg.talents["Hunter's Mark"] then
		table.insert(cfg.plistdps,"Hunter's Mark")
	end
	table.insert(cfg.plistdps,"Trueshot")
	table.insert(cfg.plistdps,"Aimed Shot_almostcapped")
	if cfg.talents["A Murder of Crows"] then
		table.insert(cfg.plistdps,"A Murder of Crows")
	end
	table.insert(cfg.plistdps,"Barrage")
	table.insert(cfg.plistdps,"Double Tap")
	table.insert(cfg.plistdps,"Rapid Fire")
	if cfg.talents["Serpent Sting"] then
		table.insert(cfg.plistdps,"Serpent Sting")
	end
	table.insert(cfg.plistdps,"Arcane Shot_precise")
	table.insert(cfg.plistdps,"Multi-Shot_precise")
	table.insert(cfg.plistdps,"Aimed Shot")
	if cfg.talents["Explosive Shot"] then
		table.insert(cfg.plistdps,"Explosive Shot")
	end
	table.insert(cfg.plistdps,"Arcane Shot")
	table.insert(cfg.plistdps,"Multi-Shot")
	if cfg.talents["Piercing Shot"] then
		table.insert(cfg.plistdps,"Piercing Shot")
	end
	table.insert(cfg.plistdps,"Steady Shot")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe = nil
	cfg.plist = cfg.plistdps
	cfg.case = {}
	cfg.case = {
		["Hunter's Mark"] = function()
			return lib.SimpleCDCheck("Hunter's Mark", lib.GetAura({"Hunter's Mark"}))
		end,
		["Trueshot"] = function()
			if lib.GetSpellCharges("Aimed Shot") > 0 then return nil end
			return lib.SimpleCDCheck("Trueshot")
		end,
		["Aimed Shot_almostcapped"] = function()
			if lib.GetSpellCharges("Aimed Shot") > 1 or
			(lib.GetSpellCharges("Aimed Shot") == 1 and lib.GetSpellCT("Aimed Shot") + 2 > lib.GetSpellCD("Aimed Shot", false, 2)) then
				return lib.SimpleCDCheck("Aimed Shot")
			end
			return nil
		end,
		["Barrage"] = function()
			if cfg.cleave_targets < 2 then return nil end
			return lib.SimpleCDCheck("Barrage")
		end,
		["Rapid Fire"] = function()
			if (not cfg.talents["Streamline"] and cfg.Power.now >= 75) or
			(cfg.talents["Streamline"] and cfg.Power.now >= 69) then return nil end
			if cfg.cleave_targets >= cfg.cleave_threshold and lib.GetAura("Trick Shots") == 0 then return nil end
			return lib.SimpleCDCheck("Rapid Fire")
		end,
		["Serpent Sting"] = function()
			return lib.SimpleCDCheck("Serpent Sting", lib.GetAura({"Serpent Sting"}) - 3)
		end,
		["Arcane Shot_precise"] = function()
			if cfg.cleave_targets >= cfg.cleave_threshold then return nil end
			if lib.GetAura({"Precise Shots"}) == 0 then return nil end
			return lib.SimpleCDCheck("Arcane Shot")
		end,
		["Multi-Shot_precise"] = function()
			if cfg.cleave_targets < cfg.cleave_threshold then return nil end
			if lib.GetAura({"Precise Shots"}) == 0 then return nil end
			return lib.SimpleCDCheck("Multi-Shot")
		end,
		["Aimed Shot"] = function()
			if cfg.Power.now > 90 then return nil end
			if cfg.cleave_targets >= cfg.cleave_threshold and lib.GetAura("Trick Shots") == 0 then return nil end
			return lib.SimpleCDCheck("Aimed Shot")
		end,
		["Arcane Shot"] = function()
			if cfg.cleave_targets >= cfg.cleave_threshold then return nil end
			if (lib.GetSpellCD("Rapid Fire") < 3 and lib.Time2Power(90) < 3) or
			cfg.Power.now > 90 then
				return lib.SimpleCDCheck("Arcane Shot")
			end
			return nil
		end,
		["Multi-Shot"] = function()
			if cfg.cleave_targets < cfg.cleave_threshold then return nil end
			return lib.SimpleCDCheck("Multi-Shot")
		end,
		["Steady Shot"] = function()
			-- TODO: Take Steady Focus into account
			return lib.SimpleCDCheck("Steady Shot")
		end,
	}

	--cfg.mode = "dps"
	lib.AddRangeCheck({
	{"Aimed Shot",nil}
	})
	--cfg.spells_aoe={"ET","MS"}
	--cfg.spells_single={"AI"}
	return true
end

lib.classes["HUNTER"][3] = function () -- Surv
	cfg.talents={
		--["Steady_Focus"]=IsPlayerSpell(177667),
		["Way of the Mok'Nathal"]=IsPlayerSpell(201082),
		["Serpent Sting"]=IsPlayerSpell(87935),
		["Butchery"]=IsPlayerSpell(212436),
	}

	lib.AddSpell("Explosive Trap",{191433})
	lib.AddAura("Explosive Trap",13812,"debuff","target")
	lib.AddCleaveSpell("Explosive Trap",nil,{13812})
	lib.AddSpell("Dragonsfire Grenade",{194855})
	lib.AddAura("Dragonsfire Grenade",194858,"debuff","target")
	lib.AddCleaveSpell("Dragonsfire Grenade",nil,{194858,194859})
	lib.AddSpell("Mongoose Bite",{190928})
	lib.AddAura("Mongoose Fury",190931,"buff","player")
	lib.SetTrackAura("Mongoose Fury")
	--[[lib.SetAuraFunction("Mongoose Fury","OnStacks",function()
		lib.UpdateTrackAura(cfg.GUID["player"],lib.GetAuraStacks("Mongoose Fury")>0 and lib.GetAuraStacks("Mongoose Fury") or nil)
	end)]]
	lib.AddSpell("Flanking Strike",{202800})
	lib.AddSpell("Raptor Strike",{186270})
	lib.AddAura("Serpent Sting",118253,"debuff","target")
	lib.AddAura("Mok'Nathal Tactics",201081,"buff","player")
	lib.AddAura("Raptor Strike",201081,"buff","player")
	lib.AddSpell("Fury of the Eagle",{203415},nil,nil,true)
	lib.AddSpell("Steel Trap",{162488})
	lib.AddAura("Steel Trap",162487,"debuff","target")
	lib.AddSpell("Throwing Axes",{200163})
	lib.AddSpell("Snake Hunter",{201078})
	lib.AddSpell("Hatchet Toss",{193265})
	lib.AddSpell("Harpoon",{190925})
	lib.AddSpell("Caltrops",{194277})
	lib.AddAura("Caltrops",194279,"debuff","target")
	lib.AddSpell("Lacerate",{185855},"target")
	lib.AddSpell("A Murder of Crows",{206505},"target")
	lib.AddSpell("Spitting Cobra",{194407},true)
	lib.AddSpell("Aspect of the Eagle",{186289},true)
	if cfg.talents["Butchery"] then
		lib.AddSpell("Butchery",{212436})
		lib.AddCleaveSpell("Butchery",nil,{212436})
	else
		lib.AddSpell("Carve",{187708})
		lib.AddCleaveSpell("Carve",nil,{187708})
	end

	cfg.plistdps = {}
	table.insert(cfg.plistdps,"Kick")
	table.insert(cfg.plistdps,"Mend_pet")
	table.insert(cfg.plistdps,"Harpoon")
	table.insert(cfg.plistdps,"Hatchet Toss")
	table.insert(cfg.plistdps,"Fury of the Eagle_Mongoose Fury")
	if cfg.talents["Way of the Mok'Nathal"] then
		table.insert(cfg.plistdps,"Raptor Strike_buff")
	end
	table.insert(cfg.plistdps,"A Murder of Crows")
	table.insert(cfg.plistdps,"Steel Trap")
	table.insert(cfg.plistdps,"Explosive Trap")
	table.insert(cfg.plistdps,"Caltrops")
	table.insert(cfg.plistdps,"Dragonsfire Grenade")
	if cfg.talents["Serpent Sting"] then
		table.insert(cfg.plistdps,"Raptor Strike_debuff")
	end
	table.insert(cfg.plistdps,"Aspect of the Eagle")
	table.insert(cfg.plistdps,"Snake Hunter")
	table.insert(cfg.plistdps,"Mongoose Bite_Mongoose Fury")
	table.insert(cfg.plistdps,"Mongoose Bite_max")
	table.insert(cfg.plistdps,"Lacerate")
	table.insert(cfg.plistdps,"Flanking Strike")
	table.insert(cfg.plistdps,"Butchery_aoe")
	table.insert(cfg.plistdps,"Carve_aoe")
	table.insert(cfg.plistdps,"Spitting Cobra")
	table.insert(cfg.plistdps,"Throwing Axes")
	table.insert(cfg.plistdps,"Raptor Strike_nomax")
	table.insert(cfg.plistdps,"end")

	cfg.plistaoe = {}
	table.insert(cfg.plistaoe,"end")
	cfg.plistaoe = nil

	cfg.plist = cfg.plistdps

	cfg.case = {
		["Hatchet Toss"] = function()
			if lib.inrange("Mongoose Bite") then return nil end
			if lib.inrange("Hatchet Toss") then
				return lib.SimpleCDCheck("Hatchet Toss")
			end
			return nil
		end,
		["Harpoon"] = function()
			if lib.inrange("Mongoose Bite") then return nil end
			if lib.inrange("Harpoon") then
				return lib.SimpleCDCheck("Harpoon")
			end
			return nil
		end,
		--[[["Flanking Strike"] = function()
			return lib.SimpleCDCheck("Flanking Strike",lib.Time2Power(cfg.Power.max-10))
		end,]]
		["Flanking Strike"] = function()
			return lib.SimpleCDCheck("Flanking Strike",lib.Time2Power(85))
		end,
		["Lacerate"] = function()
			return lib.SimpleCDCheck("Lacerate",lib.GetAura({"Lacerate"})-3.6)
		end,
		["Caltrops"] = function()
			return lib.SimpleCDCheck("Caltrops",lib.GetAura({"Caltrops"})-1.8)
		end,
		["Raptor Strike_nomax"] = function()
			return lib.SimpleCDCheck("Raptor Strike",lib.Time2Power(cfg.Power.max))
		end,
		["Raptor Strike_buff"] = function()
			if lib.GetAuraStacks("Mok'Nathal Tactics")<4 then
				return lib.SimpleCDCheck("Raptor Strike",lib.GetAura({"Mongoose Fury"}))
			else
				return lib.SimpleCDCheck("Raptor Strike",lib.GetAura({"Mok'Nathal Tactics"})-2.4)
			end
		end,
		["Raptor Strike_debuff"] = function()
			if cfg.cleave_targets>=2 and not cfg.noaoe then
				return lib.SimpleCDCheck("Carve",lib.GetAura({"Serpent Sting"})-4.5)
			end
			return lib.SimpleCDCheck("Raptor Strike",lib.GetAura({"Serpent Sting"})-4.5)
		end,
		["Mongoose Bite_max"] = function()
			if lib.IsChanneling("Fury of the Eagle") then return nil end
			return lib.SimpleCDCheck("Mongoose Bite",lib.GetSpellCD("Mongoose Bite",nil,lib.GetSpellMaxCharges("Mongoose Bite"))-(lib.GetSpellMaxCharges("Mongoose Bite")-1)*cfg.gcd)
		end,
		["Snake Hunter"] = function()
			if lib.GetSpellCharges("Mongoose Bite")==0 and lib.GetAura({"Mongoose Fury"})>lib.GetSpellCD("Snake Hunter")+4*cfg.gcd then
				return lib.SimpleCDCheck("Snake Hunter") --,lib.GetAura({"Aspect of the Eagle"})
			end
			return nil
		end,
		["Aspect of the Eagle"] = function()
			if lib.GetSpellCharges("Mongoose Bite")<lib.GetSpellMaxCharges("Mongoose Bite") and lib.GetAura({"Mongoose Fury"})>lib.GetSpellCD("Aspect of the Eagle")+3*cfg.gcd then
				return lib.SimpleCDCheck("Aspect of the Eagle",lib.GetAura({"Aspect of the Eagle"}))
			end
			return nil
		end,
		["Mongoose Bite_Mongoose Fury"] = function()
			if lib.IsChanneling("Fury of the Eagle") then return nil end
			if lib.GetAura({"Mongoose Fury"})>lib.GetSpellCD("Mongoose Bite") then
				return lib.SimpleCDCheck("Mongoose Bite")
			end
			return nil
		end,
		["Fury of the Eagle_Mongoose Fury"] = function()
			if lib.GetAura({"Mongoose Fury"})>lib.GetSpellCD("Fury of the Eagle") then --lib.GetAuraStacks("Mongoose Fury")>=6
				return lib.SimpleCDCheck("Fury of the Eagle",lib.GetAura({"Mongoose Fury"})-cfg.gcd)
			end
			return nil
		end,
		["Carve_aoe"] = function()
			if cfg.cleave_targets>=4 then
				return lib.SimpleCDCheck("Carve") --,lib.Time2Power(75)
			end
			return nil
		end,
		["Butchery_aoe"] = function()
			if cfg.cleave_targets>=2 then
				return lib.SimpleCDCheck("Butchery") --,lib.Time2Power(85)
			end
			return nil
		end,
	}

	lib.AddRangeCheck({
	{"Mongoose Bite",nil},
	{"Hatchet Toss",{0,0,1,1}},
	{"Harpoon",{1,1,0,1}},
	})
	--cfg.mode = "dps"

	--cfg.spells_aoe={"MS"}
	--cfg.spells_single={"AS"}

	return true
end

lib.classpostload["HUNTER"] = function()
	--lib.SetPower(cfg.Power.type)
	lib.AddSpell("Mend",{136}) -- Mend Pet
	lib.AddAura("Mend",136,"buff","pet") -- Mend Pet
	cfg.case["Mend_pet"] = function()
		if cfg.GUID["pet"]~=0 and lib.GetUnitHealth("pet")<90 then
			return lib.SimpleCDCheck("Mend",lib.GetAura({"Mend"})-3)
		end
		return nil
	end

	lib.SetInterrupt("Kick",{147362,187707})

	cfg.onpower=true
	lib.CD = function()
		-- GENERAL
		lib.CDadd("Kick")
		lib.CDadd("A Murder of Crows")

		lib.CDadd("Hatchet Toss")
		lib.CDadd("Mend")
		lib.CDadd("Misdirection")
		lib.CDtoggleOff("Misdirection")
		lib.CDadd("Harpoon")
		lib.CDadd("Aspect of the Wild")
		lib.CDadd("Aspect of the Eagle")
		lib.CDadd("Bestial Wrath")
		lib.CDadd("Fury of the Eagle")
		lib.CDadd("Stampede")
		lib.CDAddCleave("Barrage")
		lib.CDadd("Snake Hunter")
		lib.CDadd("Spitting Cobra")
		lib.CDadd("Steel Trap")
		lib.CDadd("Caltrops")
		lib.CDadd("Powershot")
		-- MARKSMAN
		lib.CDadd("Double Tap")
		lib.CDadd("Explosive Shot")
		lib.CDadd("Trueshot")

		lib.CDAddCleave("Marked Shot",nil,212621)
		lib.CDAddCleave("Multi-Shot")
	end
end
end
