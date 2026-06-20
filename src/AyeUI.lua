local AyeUI = {}

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--// Helpers
local function Corner(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = obj
	return c
end

local function Stroke(obj)
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(80,80,80)
	s.Thickness = 1
	s.Parent = obj
	return s
end

--// Window
function AyeUI:CreateWindow(config)
	config = config or {}

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "AyeUI"
	Gui.ResetOnSpawn = false
	Gui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 460, 0, 320)
	Main.Position = UDim2.new(0.5, -230, 0.5, -160)
	Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Main.BorderSizePixel = 0
	Main.Parent = Gui
	Corner(Main, 10)
	Stroke(Main)

	local Top = Instance.new("Frame")
	Top.Size = UDim2.new(1,0,0,35)
	Top.BackgroundColor3 = Color3.fromRGB(18,18,18)
	Top.Parent = Main
	Corner(Top, 10)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,0,1,0)
	Title.BackgroundTransparency = 1
	Title.Text = config.Title or "AyeUI"
	Title.TextColor3 = Color3.new(1,1,1)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.Parent = Top

	--// Tabs UI
	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(0,120,1,-35)
	TabHolder.Position = UDim2.new(0,0,0,35)
	TabHolder.BackgroundColor3 = Color3.fromRGB(20,20,20)
	TabHolder.Parent = Main

	local Pages = Instance.new("Frame")
	Pages.Size = UDim2.new(1,-120,1,-35)
	Pages.Position = UDim2.new(0,120,0,35)
	Pages.BackgroundTransparency = 1
	Pages.Parent = Main

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = TabHolder

	--// Minimize system
	local minimized = false
	local savedSize = Main.Size
	local FloatingBtn

	local MinBtn = Instance.new("TextButton")
	MinBtn.Size = UDim2.new(0,30,0,30)
	MinBtn.Position = UDim2.new(1,-70,0,2)
	MinBtn.Text = "-"
	MinBtn.Parent = Top
	Corner(MinBtn, 6)

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0,30,0,30)
	CloseBtn.Position = UDim2.new(1,-35,0,2)
	CloseBtn.Text = "X"
	CloseBtn.Parent = Top
	Corner(CloseBtn, 6)

	CloseBtn.MouseButton1Click:Connect(function()
		if FloatingBtn then FloatingBtn:Destroy() end
		Gui:Destroy()
	end)

	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized

		if minimized then
			savedSize = Main.Size
			Main.Size = UDim2.new(0,460,0,35)
			TabHolder.Visible = false
			Pages.Visible = false

			-- 💀 floating icon
			FloatingBtn = Instance.new("TextButton")
			FloatingBtn.Size = UDim2.new(0,45,0,45)
			FloatingBtn.Position = UDim2.new(0.9,0,0.5,0)
			FloatingBtn.Text = "💀"
			FloatingBtn.TextSize = 20
			FloatingBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
			FloatingBtn.TextColor3 = Color3.new(1,1,1)
			FloatingBtn.Parent = Gui
			Corner(FloatingBtn, 10)
			Stroke(FloatingBtn)

			FloatingBtn.MouseButton1Click:Connect(function()
				minimized = false
				Main.Size = savedSize
				TabHolder.Visible = true
				Pages.Visible = true

				FloatingBtn:Destroy()
				FloatingBtn = nil
			end)

		else
			Main.Size = savedSize
			TabHolder.Visible = true
			Pages.Visible = true

			if FloatingBtn then
				FloatingBtn:Destroy()
				FloatingBtn = nil
			end
		end
	end)

	--// Drag system
	local dragging, dragStart, startPos

	Top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	--// Tabs
	function AyeUI:CreateTab(name)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1,0,0,35)
		TabBtn.Text = name
		TabBtn.Parent = TabHolder
		Corner(TabBtn, 6)

		local Page = Instance.new("Frame")
		Page.Size = UDim2.new(1,0,1,0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.Parent = Pages

		TabBtn.MouseButton1Click:Connect(function()
			for _,v in pairs(Pages:GetChildren()) do
				if v:IsA("Frame") then
					v.Visible = false
				end
			end
			Page.Visible = true
		end)

		local tab = {}

		function tab:Button(text, cb)
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,-20,0,35)
			b.Position = UDim2.new(0,10,0,10)
			b.Text = text
			b.Parent = Page
			Corner(b, 6)

			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
		end

		function tab:Toggle(text, cb)
			local state = false

			local t = Instance.new("TextButton")
			t.Size = UDim2.new(1,-20,0,35)
			t.Position = UDim2.new(0,10,0,10)
			t.Text = text .. " [OFF]"
			t.Parent = Page
			Corner(t, 6)

			t.MouseButton1Click:Connect(function()
				state = not state
				t.Text = text .. (state and " [ON]" or " [OFF]")
				if cb then cb(state) end
			end)
		end

		function tab:Slider(text, min, max, cb)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-20,0,40)
			frame.Position = UDim2.new(0,10,0,10)
			frame.Parent = Page
			Corner(frame, 6)

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1,0,1,0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1,1,1)
			label.Text = text
			label.Parent = frame

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(0,0,1,0)
			bar.BackgroundColor3 = Color3.fromRGB(80,120,255)
			bar.Parent = frame

			local dragging = false

			frame.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UIS.InputChanged:Connect(function(i)
				if dragging then
					local x = math.clamp((i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
					bar.Size = UDim2.new(x,0,1,0)

					local value = math.floor(min + (max - min) * x)
					label.Text = text .. ": " .. value

					if cb then cb(value) end
				end
			end)
		end

		return tab
	end

	return AyeUI
end

return AyeUI
