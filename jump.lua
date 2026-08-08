local Players = game:GetService("Players")
local player = Players.LocalPlayer

local MAX_JUMP = 1000000
local NORMAL_JUMP = 50

local jumpPower = NORMAL_JUMP
local enabled = false

local gui = Instance.new("ScreenGui")
gui.Name = "HighJumpGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "HIGH JUMP"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.fromOffset(180,40)
input.Position = UDim2.fromOffset(15,50)
input.PlaceholderText = "Jump Power (max 1,000,000)"
input.Text = ""
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(45,45,45)
input.TextSize = 15
input.Parent = frame

Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)

local ok = Instance.new("TextButton")
ok.Size = UDim2.fromOffset(80,40)
ok.Position = UDim2.fromOffset(205,50)
ok.Text = "OK"
ok.TextColor3 = Color3.new(1,1,1)
ok.TextSize = 16
ok.BackgroundColor3 = Color3.fromRGB(55,55,55)
ok.Parent = frame

Instance.new("UICorner", ok).CornerRadius = UDim.new(0,8)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-30,0,42)
toggle.Position = UDim2.fromOffset(15,100)
toggle.Text = "HIGH JUMP: OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 17
toggle.Font = Enum.Font.GothamBold
toggle.BackgroundColor3 = Color3.fromRGB(55,55,55)
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

local function applyJump()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = enabled and jumpPower or NORMAL_JUMP
	end
end

ok.MouseButton1Click:Connect(function()
	local value = tonumber(input.Text)

	if value then
		jumpPower = math.clamp(value, 1, MAX_JUMP)
		input.Text = tostring(jumpPower)

		if enabled then
			applyJump()
		end
	end
end)

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled

	toggle.Text = enabled
		and "HIGH JUMP: ON"
		or "HIGH JUMP: OFF"

	applyJump()
end)

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyJump()
end)