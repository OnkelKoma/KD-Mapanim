Config = {}

-- Animation played while the pause menu / map is open
Config.Anim = {
    dict = 'amb@world_human_tourist_map@male@base',
    name = 'base',
    flag = 49, -- 49 = loop + upper body only + player keeps control
}

-- The map prop held in the right hand
Config.Prop = {
    model  = `prop_tourist_map_01`,
    bone   = 28422, -- PH_R_Hand
    offset = vec3(0.0, 0.0, 0.0),
    rot    = vec3(0.0, 0.0, 0.0),
}

-- Put the weapon away while holding the map and give it back afterwards
Config.HolsterWeapon = true

-- Don't play the animation in these situations
Config.Block = {
    inVehicle = true,
    dead      = true,
    swimming  = true,
    ragdoll   = true, -- also covers falling / climbing / parachuting
}

-- Let players turn it on/off for themselves (saved on their PC). Set to false to disable the command.
Config.Command = 'mapanim'
