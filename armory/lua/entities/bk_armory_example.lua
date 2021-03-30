AddCSLuaFile()

ENT.Base = "bk_armory_base"
ENT.PrintName = "Armory Example" -- Set the name here.
ENT.Spawnable = true

-- List of weapons that won't be removed when loadouts are switched.
-- Can be overrided with the "incompatible" loadout field.
ENT.PersistentWeapons = {
    ["weapon_physgun"] = true,
    ["weapon_physcannon"] = true
}

-- Add loadouts here.
ENT.Loadouts = {
    ["Citizen Loadout"] = {
        teams = {
            TEAM_CITIZEN,
            TEAM_GUNDEALER
        },
        weapons = {
            "weapon_fists",
            "gmod_camera"
        }
    },
    ["Shotgun"] = {
        teams = {
            TEAM_GUNDEALER
        },
        weapons = {
            "weapon_shotgun"
        },
        ammo = {
            ["rocket"] = 5
        },
        addition = true, -- Don't remove old weapons.
        incompatible = { -- These weapons will be removed when switching to this loadout. Mostly used with addition = true.
            "weapon_rpg"
        }
    },
    ["Rocket Launcher"] = {
        teams = {
            TEAM_GUNDEALER
        },
        weapons = {
            "weapon_rpg"
        },
        ammo = {
            ["buckshot"] = 20
        },
        addition = true,
        incompatible = {
            "weapon_shotgun"
        }
    }
}

ENT.CanAccess = function (ply)
    return true
end