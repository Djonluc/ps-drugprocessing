Config = {}

Config.KeyRequired = true -- Whether a key is required to process items

Config.Delays = {
	WeedProcessing = 1000 * 10, -- Delay for weed processing in milliseconds
	MethProcessing = 1000 * 10, -- Delay for meth processing in milliseconds
	CokeProcessing = 1000 * 10, -- Delay for coke processing in milliseconds
	lsdProcessing = 1000 * 10, -- Delay for LSD processing in milliseconds
	HeroinProcessing = 1000 * 10, -- Delay for heroin processing in milliseconds
	thionylchlorideProcessing = 1000 * 10, -- Delay for thionyl chloride processing in milliseconds
}

Config.CircleZones = {
	WeedField = {coords = vector3(2224.64, 5577.03, 53.85), name = ('Weed Farm'), radius = 100.0}, -- Coordinates for the weed field
	WeedProcessing = {coords = vector3(1038.33, -3204.44, -38.17), name = ('Weed Process'), radius = 100.0}, -- Coordinates for weed processing

	MethProcessing = {coords = vector3(978.17, -147.98, -48.53), name = ('Meth Process'), radius = 20.0}, -- Coordinates for meth processing
	MethTemp = {coords = vector3(982.56, -145.59, -49.0), name = ('Meth Temperature'), radius = 20.0}, -- Coordinates for meth temperature
	MethBag = {coords = vector3(987.81, -140.43, -49.0), name = ('Meth Bagging'), radius = 20.0}, -- Coordinates for meth bagging
	HydrochloricAcidFarm = {coords = vector3(293.51, -2430.17, 8.04), name = ('Hydrochloric Acid'), radius = 10.0}, -- Coordinates for hydrochloric acid farm

	SulfuricAcidFarm = {coords = vector3(1388.78, -1002.43, 42.49), name = ('Sulfuric Acid'), radius = 100.0}, -- Coordinates for sulfuric acid farm (meth)
	SodiumHydroxideFarm = {coords = vector3(2006.55, 523.9, 164.97), name = ('Sodium Hydroxide'), radius = 100.0}, -- Coordinates for sodium hydroxide farm (meth)

	ChemicalsField = {coords = vector3(-2438.13, 2654.86, 3.85), name = ('Chemicals'), radius = 100.0}, -- Coordinates for chemicals field
	ChemicalsConvertionMenu = {coords = vector3(3536.71, 3662.63, 28.12), name = ('Chemicals Process'), radius = 100.0}, -- Coordinates for chemicals conversion menu

	CokeField = {coords = vector3(2806.5, 4774.46, 46.98), name = ('Coke'), radius = 100.0}, -- Coordinates for coke field
	CokeProcessing = {coords = vector3(1087.14, -3195.31, -38.99), name = ('Coke Process'), radius = 20.0}, -- Coordinates for coke processing
	CokePowder = {coords = vector3(1092.9, -3196.65, -38.99), name = ('Powder Cutting'), radius = 20.0}, -- Coordinates for powder cutting
	CokeBrick = {coords = vector3(1099.57, -3194.35, -38.99), name = ('Brick Up Packages'), radius = 20.0}, -- Coordinates for brick up packages

	HeroinField = {coords = vector3(-2339.15, -54.32, 95.05), name = ('Heroin'), radius = 100.0}, -- Coordinates for heroin field
	HeroinProcessing = {coords = vector3(1413.37, -2041.74, 52.0), name = ('Heroin Process'), radius = 100.0}, -- Coordinates for heroin processing

	lsdProcessing = {coords = vector3(2503.84, -428.11, 92.99), name = ('LSD process'), radius = 100.0}, -- Coordinates for LSD processing

	thionylchlorideProcessing = {coords = vector3(-679.59, 5800.46, 17.33), name = ('Thi Clo Process'), radius = 100.0}, -- Coordinates for thionyl chloride processing
}

Config.MethLab = {
	["enter"] = {
        coords = vector4(-1187.17, -446.24, 43.91, 306.59), -- Coordinates and heading for meth lab entrance
    },
    ["exit"] = {
        coords = vector4(969.57, -147.07, -46.4, 267.52),  -- Coordinates and heading for meth lab exit
    },
}

Config.CokeLab = {
	["enter"] = {
        coords = vector4(813.21, -2398.69, 23.66, 171.51), -- Coordinates and heading for coke lab entrance
    },
    ["exit"] = {
        coords = vector4(1088.68, -3187.68, -38.99, 176.04), -- Coordinates and heading for coke lab exit
    },
}

Config.WeedLab = {
	["enter"] = {
		coords = vector4(102.07, 175.09, 104.59, 165.63), -- Coordinates and heading for weed lab entrance
    },
    ["exit"] = {
        coords = vector4(1066.01, -3183.38, -39.16, 93.01), -- Coordinates and heading for weed lab exit
    },
}

--------------------------------
-- DRUG CONFIG AMOUNTS --
--------------------------------

--------------------------------
-- COKE PROCESSING AMOUNTS --
--------------------------------

Config.CokeProcessing = {
	CokeLeaf = 1, -- Amount of coke leaf needed to process
	ProcessCokeLeaf = math.random(2,7), -- Amount of coke received from processing coke leaf
	-- Processing Small Bricks --
	Coke = 10, -- Amount of coke needed for small brick
	BakingSoda = 5, -- Amount of baking soda needed for small brick
	SmallCokeBrick = math.random(2,7), -- Amount of small coke bricks received
	-- Process Small Bricks Into Large Brick --
	SmallBrick = 4, -- Amount of small bricks required to make a large brick
	LargeBrick = 1, -- Amount of large bricks received
}

--------------------------------
-- METH PROCESSING AMOUNTS --
--------------------------------

Config.MethProcessing = {
	-- Chemical Processing --
	SulfAcid = 1, -- Amount of sulfuric acid needed for liquid mix
	HydAcid = 1, -- Amount of hydrochloric acid needed for liquid mix
	SodHyd = 1, -- Amount of sodium hydroxide needed for liquid mix
	Meth = math.random(80,100), -- Amount of meth received from 1 tray
}

--------------------------------
-- HEROIN PROCESSING AMOUNTS --
--------------------------------

Config.HeroinProcessing = {
	Poppy = 2 -- Amount of poppy required for 1 heroin
}
