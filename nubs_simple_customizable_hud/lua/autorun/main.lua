if SERVER then
	util.AddNetworkString("nubshud_help")
	util.AddNetworkString("nubshud_regen")

	CreateConVar("nubshud_regen_amount", 3, {FCVAR_ARCHIVE}, "How much the health regenerates per set seconds.")
	CreateConVar("nubshud_regen_time", 1, {FCVAR_ARCHIVE}, "How often the health regenerates.")

	GetConVar("nubshud_regen_amount"):SetInt(math.Clamp(GetConVar("nubshud_regen_amount"):GetInt(), 0, 100))
	GetConVar("nubshud_regen_time"):SetInt(math.Clamp(GetConVar("nubshud_regen_time"):GetInt(), 1, 10))

	resource.AddFile("resource/fonts/android_7.ttf")

	hook.Add("PlayerInitialSpawn", "nubshud_showhelp", function(player)
		net.Start("nubshud_help")
		net.Send(player)
	end)

	hook.Add("PlayerSay", "nubshud_commands", function(player, msg, isTeam)
		local args = string.Explode(" ", string.lower(msg))
		if args[1] == "!shud" then
			player:ConCommand("nubshud xgui")
			return ""
		end
		if args[1] == "!shud_admin" then
			player:ConCommand("nubshud xgui_admin")
			return ""
		end
	end)

	hook.Add("EntityTakeDamage", "nubshud_healthregen", function(ply, dmg)
		if ply:IsPlayer() then
			local armor = ply:Armor() or 0
			net.Start("nubshud_regen")
				net.WriteString(ply:Health()-(math.Round(dmg:GetDamage()-ply:Armor())))
			net.Send(ply)
		end
	end)

	net.Receive("nubshud_regen", function()
		local can = net.ReadBool()
		local ply = net.ReadEntity()
		if can then
			local newHP = ply:Health()+math.Clamp(GetConVar("nubshud_regen_amount"):GetInt(), 0, 100)
			ply:SetHealth(math.Clamp(newHP, 0, 100))
			if ply:Health() < 100 then
				local armor = ply:Armor() or 0
				net.Start("nubshud_regen")
					net.WriteString(ply:Health()+armor)
				net.Send(ply)
			end
		end
	end)
else
	CreateClientConVar("nubshud_use_circular_hud", 1, true, false, "Enables/Disables circular HUD.")
	CreateClientConVar("nubshud_clamp_to_amount", 0, true, false, "Clamps white bar over health, or fills the entire bar.")
	CreateClientConVar("nubshud_whitebar_height", 0, true, false, "Height of the white tinted bar.")

	GetConVar("nubshud_use_circular_hud"):SetInt(math.Clamp(GetConVar("nubshud_use_circular_hud"):GetInt(), 1, 5))
	GetConVar("nubshud_clamp_to_amount"):SetInt(math.Clamp(GetConVar("nubshud_clamp_to_amount"):GetInt(), 0, 1))
	GetConVar("nubshud_whitebar_height"):SetInt(math.Clamp(GetConVar("nubshud_whitebar_height"):GetInt(), 3, 17))

	surface.CreateFont("Android", {
		font = "Android 7",
		extended = false,
		size = 20,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	})
	surface.CreateFont("AndroidL", {
		font = "Android 7",
		extended = false,
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	})

	net.Receive("nubshud_regen", function()
		local am = net.ReadString()
		if LocalPlayer():Alive() then
			local t = math.Clamp(GetConVar("nubshud_regen_time"):GetInt(), 1, 10)
			timer.Simple(t, function()
				local armor = LocalPlayer():Armor() or 0
				if tonumber(am) == math.floor((tonumber(am) + LocalPlayer():Health() + armor)/2) then
					net.Start("nubshud_regen")
						net.WriteBool(true)
						net.WriteEntity(LocalPlayer())
					net.SendToServer()
				end
			end)
		end
	end)

	concommand.Add("nubshud", function(ply, cmd, args, argStr)
		if args[1] == "xgui" then
			local M = vgui.Create("DFrame")
			M:SetSize(280, 170)
			M:Center()
			M:SetTitle("Nub's Simplistic Customizable HUD Settings")
			M:SetSizable(false)
			M:SetDraggable(false)
			M:ShowCloseButton(false)
			M.Paint = function(self, w, h)
				draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100))
			end

			local CB = vgui.Create("DButton", M)
			CB:SetSize(30, 20)
			CB:SetPos(M:GetWide()-30, 0)
			CB:SetTextColor(Color(255, 255, 255))
			CB:SetText("X")
			CB:SetFont("Android")
			CB.Paint = function(self, w, h)
				draw.RoundedBox(8, 0, 0, w, h, Color(0, 150, 255))
			end
			CB.DoClick = function()
				M:Close()
			end

			local tl = vgui.Create("DShape", M)
			tl:SetType("Rect")
			tl:SetPos(0, 20)
			tl:SetColor(Color(50, 50, 50))
			tl:SetSize(M:GetWide(), 2)

			local csb = vgui.Create("DShape", M)
			csb:SetType("Rect")
			csb:SetPos(5, 25)
			csb:SetSize(270, M:GetTall()-30)
			csb:SetColor(Color(0, 150, 255))

			local csf = vgui.Create("DShape", M)
			csf:SetType("Rect")
			csf:SetPos(10, 30)
			csf:SetSize(260, csb:GetTall()-10)
			csf:SetColor(Color(100, 100, 100))

			local csd = vgui.Create("DShape", M)
			csd:SetType("Rect")
			csd:SetPos(10, 55)
			csd:SetSize(260, 2)
			csd:SetColor(Color(50, 50, 50))

			local cst = vgui.Create("DLabel", M)
			cst:SetPos(5+(250/3.75), 30)
			cst:SetSize(250, 25)
			cst:SetText("Client Settings")
			cst:SetFont("Android")

			local tc = vgui.Create("DCheckBoxLabel", M)
			tc:SetPos(15, 60)
			tc:SetText("Snap white bar to health & armor")
			tc:SizeToContents()
			tc:SetConVar("nubshud_clamp_to_amount")

			local bh = vgui.Create("DNumSlider", M)
			bh:SetPos(15, 75)
			bh:SetSize(275, 20)
			bh:SetText("White Bar Height")
			bh:SetMin(3)
			bh:SetMax(17)
			bh:SetDecimals(0)
			bh:SetConVar("nubshud_whitebar_height")

			local ud = vgui.Create("DButton", M)
			ud:SetPos(15, M:GetTall()-55)
			ud:SetSize(250, 40)
			ud:SetTextColor(Color(255, 255, 255))
			ud:SetText("Use Defaults")
			ud:SetFont("Android")
			ud.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 150, 255))
			end
			ud.DoClick = function()
				GetConVar("nubshud_whitebar_height"):SetInt(7)
				GetConVar("nubshud_clamp_to_amount"):SetBool(false)
				GetConVar("nubshud_use_circular_hud"):SetInt(1)
				M:Close()
			end

			local uc = vgui.Create("DNumSlider", M)
			uc:SetPos(15, 90)
			uc:SetSize(275, 20)
			uc:SetText("Hud Design")
			uc:SetMin(1)
			uc:SetMax(4)
			uc:SetDecimals(0)
			uc:SetConVar("nubshud_use_circular_hud")
			function uc:OnValueChanged(n)
				if n == 1 then
					tc:SetText("Snap white bar to health & armor")
				else
					if n == 2 then
						tc:SetText("Show dark layer (under hp & armor)")
					else
						if n == 3 then
							tc:SetText("(Pick a different design for option)")
						else
							if n == 4 then
								tc:SetText("(Pick a different design for option)")
							else
								//tc:SetText("Snap white bar to health & armor")
							end
						end
					end
				end
			end

			M:MakePopup()
		end
		if args[1] == "xgui_admin" then
			if LocalPlayer():IsAdmin() then
				local M = vgui.Create("DFrame")
				M:SetSize(280, 100)
				M:Center()
				M:SetTitle("Nub's Admin Settings")
				M:SetSizable(false)
				M:SetDraggable(false)
				M:ShowCloseButton(false)
				M.Paint = function(self, w, h)
					draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100))
				end

				local CB = vgui.Create("DButton", M)
				CB:SetSize(30, 20)
				CB:SetPos(M:GetWide()-30, 0)
				CB:SetTextColor(Color(255, 255, 255))
				CB:SetText("X")
				CB:SetFont("Android")
				CB.Paint = function(self, w, h)
					draw.RoundedBox(8, 0, 0, w, h, Color(0, 150, 255))
				end
				CB.DoClick = function()
					M:Close()
				end

				local tl = vgui.Create("DShape", M)
				tl:SetType("Rect")
				tl:SetPos(0, 20)
				tl:SetColor(Color(50, 50, 50))
				tl:SetSize(M:GetWide(), 2)

				local ssb = vgui.Create("DShape", M)
				ssb:SetType("Rect")
				ssb:SetPos(5, 25)
				ssb:SetSize(270, M:GetTall()-30)
				ssb:SetColor(Color(0, 150, 255))

				local ssf = vgui.Create("DShape", M)
				ssf:SetType("Rect")
				ssf:SetPos(10, 30)
				ssf:SetSize(260, ssb:GetTall()-10)
				ssf:SetColor(Color(100, 100, 100))

				local ssd = vgui.Create("DShape", M)
				ssd:SetType("Rect")
				ssd:SetPos(10, 55)
				ssd:SetSize(260, 2)
				ssd:SetColor(Color(50, 50, 50))

				local sst = vgui.Create("DLabel", M)
				sst:SetPos(250/3.75, 30)
				sst:SetSize(250, 25)
				sst:SetText("Server Settings")
				sst:SetFont("Android")

				local hra = vgui.Create("DNumSlider", M)
				hra:SetPos(15, 55)
				hra:SetSize(275, 20)
				hra:SetText("Health Regen amount")
				hra:SetMin(0)
				hra:SetMax(100)
				hra:SetDecimals(0)
				hra:SetConVar("nubshud_regen_amount")

				local rt = vgui.Create("DNumSlider", M)
				rt:SetPos(15, 70)
				rt:SetSize(275, 20)
				rt:SetText("Health Regen delay")
				rt:SetMin(1)
				rt:SetMax(10)
				rt:SetDecimals(0)
				rt:SetConVar("nubshud_regen_time")

				M:MakePopup()
			else
				chat.AddText(Color(255, 62, 62), "Error: You must be admin to open this menu")
			end
		end
	end)

	net.Receive("nubshud_help", function()
		timer.Simple(5, function()
			chat.AddText(Color(255, 62, 62), " --Want to change the hud's look? Say ", Color(98, 176, 255), "!shud", Color(255, 62, 62), " for customization options!")
			if LocalPlayer():IsAdmin() then
				chat.AddText(Color(255, 62, 62), " --Being admin, you may use ", Color(98, 176, 255), "!shud_admin", Color(255, 62, 62), ".")
			end
		end)
	end)
end