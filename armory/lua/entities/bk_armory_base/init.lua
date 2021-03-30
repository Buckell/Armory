--[[
Armory
An addon for Garry's Mod that adds in armories for DarkRP that can be customized for multiple factions.
There are a list of loadouts and each loadout has a list of jobs that can use it.

Copyright (C) 2021 Max Goddard

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]--

if not DarkRP then
    print("[Armory] DarkRP is required but not found.")
end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("Armory.Open")
util.AddNetworkString("Armory.Select")
util.AddNetworkString("Armory.NicePrint")

local function NicePrint(ply, string)
    net.Start("Armory.NicePrint")
    net.WriteString(string)
    net.Send(ply)
end

function ENT:Use(ply)
    if ply:IsPlayer() then
        net.Start("Armory.Open")
        net.WriteEntity(self)
        net.Send(ply)
    end
end

net.Receive("Armory.Select", function (len, ply)
    if not ply:IsPlayer() then return end
    
    local armory = net.ReadEntity()
    local loadout = net.ReadString()

    if not armory.Loadouts then return end

    local loadout_tb = armory.Loadouts[loadout]

    if not loadout_tb or not loadout_tb.weapons then return end
    
    if armory:GetPos():DistToSqr(ply:GetPos()) > 9000 then return end
    
    if loadout_tb.teams and not loadout_tb.teams[ply:Team()] then
        
        return
    end

    if not loadout_tb.addition then
        ply:StripAmmo()

        if armory.PersistentWeapons then
            for _,v in ipairs(ply:GetWeapons()) do
                local class = v:GetClass()

                if armory.PersistentWeapons[class] then
                    ply:StripWeapon(class)
                end
            end
        end
    end

    for _,v in ipairs(loadout_tb.incompatible or {}) then
        ply:StripWeapon(v)
    end

    for k,v in pairs(loadout_tb.ammo or {}) do
        ply:GiveAmmo(v, k)
    end

    for _,v in ipairs(loadout_tb.weapons or {}) do
        ply:Give(v)
    end
end)