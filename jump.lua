local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local MAX_JUMP = 1000000
local NORMAL_JUMP = 50

local jumpPower = NORMAL_JUMP
local enabled = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HighJumpGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main window
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(310, 155)
main.Position = UDim2.new(1, -330, 0, 40)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 40)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "HIGH JUMP"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Active = true
title.Parent = main

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -38, 0, 4)
close.Text = "X"
close.TextSize = 15
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

-- Input
local input = Instance.new("TextBox")
input.Size = UDim2.fromOffset(190, 40)
input.Position = UDim2.fromOffset(15, 50)
input.PlaceholderText = "Jump Power (max 1,000,000)"
input.Text = ""
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
input.TextSize = 15
input.ClearTextOnFocus = false
input.Parent = main

Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

-- OK
local ok = Instance.new("TextButton")
ok.Size = UDim2.fromOffset(75, 40)
ok.Position = UDim2.fromOffset(220, 50)
ok.Text = "OK"
ok.TextColor3 = Color3.new(1, 1, 1)
ok.TextSize = 16
ok.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ok.Parent = main

Instance.new("UICorner", ok).CornerRadius = UDim.new(0, 8)

-- Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -30, 0, 45)
toggle.Position = UDim2.fromOffset(15, 100)
toggle.Text = "HIGH JUMP: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 17
toggle.Font = Enum.Font.GothamBold
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
toggle.Parent = main

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- Round restore button
local restore = Instance.new("TextButton")
restore.Size = UDim2.fromOffset(58, 58)
restore.Position = UDim2.new(1, -75, 0, 40)
restore.Text = "HJ"
restore.TextColor3 = Color3.new(1, 1, 1)
restore.TextSize = 16
restore.Font = Enum.Font.GothamBold
restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
restore.Visible = false
restore.Active = true
restore.Parent = gui

Instance.new("UICorner", restore).CornerRadius = UDim.new(1, 0)

-- Apply jump
local function applyJump()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.UseJumpPower = true

		if enabled then
			humanoid.JumpPower = jumpPower
		else
			humanoid.JumpPower = NORMAL_JUMP
		end
	end
end

-- OK button
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

-- Toggle
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled

	if enabled then
		toggle.Text = "HIGH JUMP: ON"
	else
		toggle.Text = "HIGH JUMP: OFF"
	end

	applyJump()
end)

-- Close
close.MouseButton1Click:Connect(function()
	main.Visible = false
	restore.Visible = true
end)

-- Restore
restore.MouseButton1Click:Connect(function()
	main.Visible = true
	restore.Visible = false
end)

-- Make something draggable
local function makeDraggable(object, moveObject)
	local dragging = false
	local dragStart
	local startPosition

	object.InputBegan:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1
			or inputObject.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = inputObject.Position
			startPosition = moveObject.Position

			inputObject.Changed:Connect(function()
				if inputObject.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(inputObject)
		if dragging and (
			inputObject.UserInputType == Enum.UserInputType.MouseMovement
			or inputObject.UserInputType == Enum.UserInputType.Touch
		) then

			local delta = inputObject.Position - dragStart

			moveObject.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)
end

-- Main window can be moved using the title
makeDraggable(title, main)

-- Round HJ button can also be moved
makeDraggable(restore, restore)

-- Respawn support
player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyJump()
end)