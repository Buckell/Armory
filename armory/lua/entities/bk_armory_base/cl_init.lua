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

include("shared.lua")

surface.CreateFont("Armory.Large", {
	font = "Roboto",
	size = 128,
	weight = 800,
	antialias = true
})

surface.CreateFont("Armory.Small", {
	font = "Roboto",
	size = 72,
	weight = 800,
	antialias = true
})

function ENT:Draw()
	self:DrawModel()

    local sqr_dist = ply:GetPos():DistToSqr(self:GetPos())
    local alpha = 255
    if sqr_dist > 90000 then alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) end 
    if alpha == 0 then return end

	local oang = self:GetAngles()
	local opos = self:GetPos()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), -90 )
	ang:RotateAroundAxis( oang:Up(), -4)

	pos = pos + oang:Forward()*14 + oang:Up() * 20 + oang:Right() * 20

    cam.Start3D2D( pos, ang, 0.025 )
        draw.SimpleText(self.PrintName, "Armory.Large", 0, 0, Color(255,255,255, alpha) )
        draw.DrawText("Press your 'use' key to access the armory.", "Armory.Small", 0, 128, Color(255,255,255, alpha) )
    cam.End3D2D()
end

function ENT:OpenArmoryPanel()
    local ply = LocalPlayer()
    local loadouts_num = 0

    for _,_ in pairs(Armory.RussianArmoryLoadouts) do
        loadouts_num = loadouts_num + 1
    end

    local ArmoryFrame = vgui.Create("MRPFrame")
    ArmoryFrame:SetTitle("Russian Armory")
    ArmoryFrame:SetSize(1380, 130 + (math.ceil(loadouts_num / 5) * 140))
    ArmoryFrame:Center()
    ArmoryFrame:MakePopup()

    local JobLabel = vgui.Create("DLabel", ArmoryFrame)
    JobLabel:SetText(team.GetName(ply:Team()))
    JobLabel:SetFont("DermaLarge")
    JobLabel:SetPos(30, 30)
    JobLabel:SetSize(1320, 70)
    JobLabel:SetContentAlignment(5)

    local x_offset = 30
    local y_offset = 110

    for name, loadout in pairs(Armory.RussianArmoryLoadouts) do
        local LoadoutPanel = vgui.Create("DPanel", ArmoryFrame)
        LoadoutPanel:SetPos(x_offset, y_offset)
        LoadoutPanel:SetSize(240, 130)
        LoadoutPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
        end

        local LoadoutName = vgui.Create("DLabel", LoadoutPanel)
        LoadoutName:SetText(name)
        LoadoutName:SetPos(10, 5)
        LoadoutName:SetSize(220, 30)
        LoadoutName:SetFont("DermaDefaultBold")
        LoadoutName:SetContentAlignment(5)
        
        x_offset = x_offset + 270
        if (x_offset == 1380) then
            x_offset = 30
            y_offset = y_offset + 140
        end

        local weapon_list = ""

        for i, weapon in ipairs(loadout.weapons) do
            local cat = ""
            if i ~= 1 then cat = ", " else cat = "" end
            weapon_list = weapon_list .. cat .. weapon
        end

        local LoadoutWeapons = vgui.Create("DLabel", LoadoutPanel)
        LoadoutWeapons:SetText(weapon_list)
        LoadoutWeapons:SetPos(10, 30)
        LoadoutWeapons:SetSize(220, 53)
        LoadoutWeapons:SetFont("DermaDefault")
        LoadoutWeapons:SetContentAlignment(7)
        LoadoutWeapons:SetWrap(true)

        local SwitchLoadout = vgui.Create("DButton", LoadoutPanel)
        if table.HasValue(loadout.access_teams, ply:getJobTable().command) then
            SwitchLoadout:SetText("Choose")
            SwitchLoadout.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
            end
            SwitchLoadout.DoClick = function()
                net.Start("Armory.Russian.Choose")
                net.WriteString(name)
                net.SendToServer()
                ArmoryFrame:Close()
            end
        else
            SwitchLoadout:SetText("Locked")
            SwitchLoadout.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 188))
            end
        end
        SwitchLoadout:SetTextColor(Color(255,255,255))
        SwitchLoadout:SetPos(50, 90)
        SwitchLoadout:SetSize(140, 30)
    end
end

net.Receive("Armory.Russian.Open", function()
    RussianArmoryPanel(net.ReadString(), net.ReadTable())
end)