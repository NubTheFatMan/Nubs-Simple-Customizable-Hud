function Circle( x, y, radius, seg, arc, angOffset)
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360)*(arc/360) - math.rad(angOffset)
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end
    table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

hook.Add( "HUDPaint", "nubs_hud_draw", function()
	if GetConVar("nubshud_use_circular_hud"):GetInt() == 1 then
		surface.SetDrawColor(75, 75, 75, 255)
		surface.DrawRect(7, ScrH()-63, 396, 26)

		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(10, ScrH()-60, 390, 20)

		surface.SetDrawColor(255, 62, 62, 255)
		surface.DrawRect(10, ScrH()-60, math.Clamp(LocalPlayer():Health(), 0, 100)*3.9, 20)

		surface.SetFont("Android")
		surface.SetTextColor(50, 50, 50, 255)
		surface.SetTextPos(12, ScrH()-61)
		surface.DrawText(LocalPlayer():Health())

		surface.SetDrawColor(255, 255, 255, 25)

		if GetConVar("nubshud_clamp_to_amount"):GetBool() then
			surface.DrawRect(10, ScrH()-60, math.Clamp(LocalPlayer():Health(), 0, 100)*3.9, math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
		else
			surface.DrawRect(10, ScrH()-60, 390, math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
		end

		surface.SetDrawColor( 75, 75, 75, 255 )
		surface.DrawRect(7, ScrH()-33, 396, 26)

		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(10, ScrH()-30, 390, 20)

		surface.SetDrawColor(98, 176, 255, 255)
		surface.DrawRect(10, ScrH()-30, math.Clamp(LocalPlayer():Armor(), 0, 100)*3.9, 20)

		surface.SetFont("Android")
		surface.SetTextColor(50, 50, 50, 255)
		surface.SetTextPos(12, ScrH()-31)
		surface.DrawText(LocalPlayer():Armor())

		surface.SetDrawColor(255, 255, 255, 25)
		if GetConVar("nubshud_clamp_to_amount"):GetBool() then
			surface.DrawRect(10, ScrH()-30, math.Clamp(LocalPlayer():Armor(), 0, 100)*3.9, math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
		else
			surface.DrawRect(10, ScrH()-30, 390, math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
		end

		if LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 then
				surface.SetDrawColor(75, 75, 75, 255)
				surface.DrawRect(ScrW()-443, ScrH()-33, 436, 26)

				surface.SetDrawColor(50, 50, 50, 255)
				surface.DrawRect(ScrW()-440, ScrH()-30, 390, 20)

				surface.DrawRect(ScrW()-45, ScrH()-30, 35, 20)

				surface.SetDrawColor(255, 255, 62, 255)
				surface.DrawRect(ScrW()-440, ScrH()-30, math.Round(390 * (LocalPlayer():GetActiveWeapon():Clip1()/LocalPlayer():GetActiveWeapon():GetMaxClip1())), 20)
			
				surface.SetTextColor(50, 50, 50, 255)
				surface.SetTextPos(ScrW()-438, ScrH()-30)
				surface.SetFont("Android")
				surface.DrawText(tostring(LocalPlayer():GetActiveWeapon():Clip1()) .. ":" .. tostring(LocalPlayer():GetActiveWeapon():GetMaxClip1()))

				surface.SetDrawColor(255, 255, 255, 125)
				if GetConVar("nubshud_clamp_to_amount"):GetBool() then
					surface.DrawRect(ScrW()-440, ScrH()-30, math.Round(390 * (LocalPlayer():GetActiveWeapon():Clip1()/LocalPlayer():GetActiveWeapon():GetMaxClip1())), math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
				else
					surface.DrawRect(ScrW()-440, ScrH()-30, 390, math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))
				end

				surface.SetTextColor(100, 100, 100, 255)
				surface.SetTextPos(ScrW()-43, ScrH()-30)
				surface.DrawText(tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())))
			end
		end
	else
		if GetConVar("nubshud_use_circular_hud"):GetInt() == 2 then
			surface.SetDrawColor(75, 75, 75, 255)
			draw.NoTexture()
			Circle(105, ScrH()-105, 100, 360, 360, 0)
			surface.DrawRect(5, ScrH()-205, 100, 100)
			surface.DrawRect(105, ScrH()-105, 100, 100)

			if GetConVar("nubshud_clamp_to_amount"):GetBool() then
				surface.SetDrawColor(50, 50, 50, 255)
				Circle(105, ScrH()-105, 100, 360, 270, 90)
			end

			surface.SetDrawColor(255, 62, 62, 255)
			Circle(105, ScrH()-105, 100, 360, math.Clamp(LocalPlayer():Health(), 0, 100)*2.7, 90)

			surface.SetDrawColor(75, 75, 75, 255)
			if GetConVar("nubshud_clamp_to_amount"):GetBool() then
				surface.SetDrawColor(50, 50, 50, 255)
			end
			Circle(105, ScrH()-105, 75, 360, 270, 90)
			
			surface.SetDrawColor(98, 176, 255, 255)
			Circle(105, ScrH()-105, 75, 360, math.Clamp(LocalPlayer():Armor(), 0, 100)*2.7, 90)

			surface.SetDrawColor(75, 75, 75, 255)
			Circle(105, ScrH()-105, 50, 360, 360, 0)

			surface.SetTextColor(255, 62, 62, 255)
			surface.SetTextPos(70, ScrH()-125)
			surface.SetFont("Android")
			surface.DrawText("HP: " .. tostring(math.Clamp(LocalPlayer():Health(), 0, 100)))

			surface.SetTextColor(98, 176, 255, 255)
			surface.SetTextPos(70, ScrH()-110)
			surface.SetFont("Android")
			surface.DrawText("SUIT: " .. tostring(math.Clamp(LocalPlayer():Armor(), 0, 100)))

			if LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) then
				if LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 then
					surface.SetDrawColor(75, 75, 75, 255)
					Circle(ScrW()-80, ScrH()-80, 75, 360, 360, 0)
					surface.DrawRect(ScrW()-155, ScrH()-80, 75, 75)
					surface.DrawRect(ScrW()-80, ScrH()-155, 75, 75)

					if GetConVar("nubshud_clamp_to_amount"):GetBool() then
						surface.SetDrawColor(50, 50, 50, 255)
						Circle(ScrW()-80, ScrH()-80, 75, 360, 270, 90)
					end

					surface.SetDrawColor(255, 255, 62, 255)
					Circle(ScrW()-80, ScrH()-80, 75, 360, math.rad((360*42.95) * (LocalPlayer():GetActiveWeapon():Clip1()/LocalPlayer():GetActiveWeapon():GetMaxClip1())), 90)
					
					surface.SetDrawColor(75, 75, 75, 255)
					Circle(ScrW()-80, ScrH()-80, 60, 360, 360, 0)

					surface.SetTextColor(255, 255, 62, 255)
					surface.SetFont("Android")
					surface.SetTextPos(ScrW()-120, ScrH()-120)
					surface.DrawText(LocalPlayer():GetActiveWeapon():Clip1() .. ":" .. LocalPlayer():GetActiveWeapon():GetMaxClip1())

					surface.SetTextPos(ScrW()-120, ScrH()-100)
					surface.DrawText(tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())))
				end
			end
		else
			if GetConVar("nubshud_use_circular_hud"):GetInt() == 3 then
				surface.SetDrawColor(75, 75, 75, 255)
				draw.NoTexture()
				Circle(105, ScrH()-105, 100, 360, 360, 0)

				surface.SetDrawColor(50, 50, 50, 255)
				Circle(105, ScrH()-105, 90, 360, 360, 0)

				surface.SetDrawColor(255, 62, 62, 255)
				Circle(105, ScrH()-105, 90, 360, math.Clamp(LocalPlayer():Health(), 0, 100)*1.8, 90)

				surface.SetDrawColor(98, 176, 255, 255)
				Circle(105, ScrH()-105, 90, 360, math.Clamp(LocalPlayer():Armor(), 0, 100)*1.8, -90)

				surface.SetDrawColor(75, 75, 75, 255)
				Circle(105, ScrH()-105, 80, 360, 360, 0)

				surface.SetTextColor(255, 62, 62)
				surface.SetTextPos(70, ScrH()-125)
				surface.SetFont("Android")
				surface.DrawText("HP: " .. tostring(math.Clamp(LocalPlayer():Health(), 0, 100)))

				surface.SetTextColor(98, 176, 255, 255)
				surface.SetTextPos(70, ScrH()-110)
				surface.SetFont("Android")
				surface.DrawText("SUIT: " .. tostring(math.Clamp(LocalPlayer():Armor(), 0, 100)))

				if LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) then
					if LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 then
						surface.SetDrawColor(75, 75, 75, 255)
						Circle(ScrW()-80, ScrH()-80, 75, 360, 360, 0)

						surface.SetDrawColor(50, 50, 50, 255)
						Circle(ScrW()-80, ScrH()-80, 65, 360, 360, 0)

						surface.SetDrawColor(255, 255, 62, 255)
						Circle(ScrW()-80, ScrH()-80, 65, 360, math.rad((360*57.29) * (LocalPlayer():GetActiveWeapon():Clip1()/LocalPlayer():GetActiveWeapon():GetMaxClip1())), 90)

						surface.SetDrawColor(75, 75, 75, 255)
						Circle(ScrW()-80, ScrH()-80, 55, 360, 360, 0)

						surface.SetTextColor(255, 255, 62, 255)
						surface.SetFont("Android")
						surface.SetTextPos(ScrW()-120, ScrH()-100)
						surface.DrawText(LocalPlayer():GetActiveWeapon():Clip1() .. ":" .. LocalPlayer():GetActiveWeapon():GetMaxClip1())

						surface.SetTextPos(ScrW()-120, ScrH()-80)
						surface.DrawText(tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())))
					end
				end
			else
				if GetConVar("nubshud_use_circular_hud"):GetInt() == 4 then
					surface.SetDrawColor(255, 62, 62, 255)
					draw.NoTexture()
					Circle(75, ScrH()-75, 70, 360, math.Clamp(LocalPlayer():Health(), 0, 100)*3.6, 180)

					surface.SetDrawColor(127, 31, 31, 255)
					Circle(75, ScrH()-75, 65, 360, 360, 0)

					surface.SetTextColor(255, 62, 62, 255)
					surface.SetFont("AndroidL")
					surface.SetTextPos(20, ScrH()-100)
					surface.DrawText(math.Clamp(LocalPlayer():Health(), 0, 100) .. "%")

					surface.SetDrawColor(98, 176, 255, 255)
					Circle(220, ScrH()-75, 70, 360, math.Clamp(LocalPlayer():Armor(), 0, 100)*3.6, 180)

					surface.SetDrawColor(49, 176/2, 127, 255)
					Circle(220, ScrH()-75, 65, 360, 360, 180)

					surface.SetTextColor(98, 176, 255, 255)
					surface.SetFont("AndroidL")
					surface.SetTextPos(170, ScrH()-100)
					surface.DrawText(math.Clamp(LocalPlayer():Armor(), 0, 100) .. "%")

					if LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) then
						if LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 then
							surface.SetDrawColor(255, 255, 62, 255)
							Circle(ScrW()-75, ScrH()-75, 70, 360, math.rad((360*57.29) * (LocalPlayer():GetActiveWeapon():Clip1()/LocalPlayer():GetActiveWeapon():GetMaxClip1())), 180)

							surface.SetDrawColor(127, 127, 31, 255)
							Circle(ScrW()-75, ScrH()-75, 65, 360, 360, 0)

							surface.SetTextColor(255, 255, 62, 255)
							surface.SetFont("Android")
							surface.SetTextPos(ScrW()-130, ScrH()-100)
							surface.DrawText(LocalPlayer():GetActiveWeapon():Clip1() .. ":" .. LocalPlayer():GetActiveWeapon():GetMaxClip1())

							surface.SetTextPos(ScrW()-130, ScrH()-80)
							surface.DrawText(tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())))
						end
					end
				else
					if GetConVar("nubshud_use_circular_hud"):GetInt() == 5 then
						surface.SetDrawColor(75, 75, 75, 255)
						draw.NoTexture()

						local t1 = {
							{x = ScrW()/2, y = ScrH()-205},
							{x = (ScrW()/2)+100, y = ScrH()-5},
							{x = (ScrW()/2)-100, y = ScrH()-5}
						}
						surface.DrawPoly(t1)

						surface.SetDrawColor(255, 62, 62, 255)
						local t2 = {
							{x = ScrW()/2, y = ScrH()-205},
							{x = (ScrW()/2)+50, y = ScrH()-105},
							{x = (ScrW()/2)-50, y = ScrH()-105}
						}
						surface.DrawPoly(t2)

						surface.SetDrawColor(255, 255, 62, 255)
						local t3 = {
							{x = (ScrW()/2)+50, y = ScrH()-105},
							{x = (ScrW()/2)+100, y = ScrH()-5},
							{x = ScrW()/2, y = ScrH()-5}
						}
						surface.DrawPoly(t3)

						surface.SetDrawColor(98, 176, 255, 255)
						local t4 = {
							{x = (ScrW()/2)-50, y = ScrH()-105},
							{x = ScrW()/2, y = ScrH()-5},
							{x = (ScrW()/2)-100, y = ScrH()-5}
						}
						surface.DrawPoly(t4)
					else
						local Val = math.Clamp(GetConVar("nubshud_use_circular_hud"):GetInt(), 1, 5)
						GetConVar("nubshud_use_circular_hud"):SetInt(Val)
					end
				end
			end
		end
	end
end )

//This hides the default HUD
local elements = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

hook.Add("HUDShouldDraw", "nubs_hide_hud", function(name)
	if elements[name] then return false end
end)