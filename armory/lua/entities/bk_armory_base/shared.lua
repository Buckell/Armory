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

ENT.Type = "anim"
ENT.Spawnable = false
ENT.Category = "Buckell's"
ENT.WorldModel = "models/props_wasteland/controlroom_storagecloset001a.mdl"

function ENT:Initialize()
	self:SetModel(self.WorldModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 	
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(50)
	end
end