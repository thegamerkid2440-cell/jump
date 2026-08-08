local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local infiniteJump = false

local gui = Instance.new("ScreenGui")
gui.Name = "InfiniteJumpGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main box
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300,130)
main.Position = UDim2.new(1,-320,0,50)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

-- Title / drag area
local title = Instance.new("TextButton")
title.Size = UDim2.new(1,-45,0,40)
title.BackgroundTransparency = 1
title.Text = "♾️ INFINITE JUMP"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-40,0,3)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(55,55,55)
close.Parent = main

Instance.new("UICorner",close).CornerRadius = UDim.new(0,7)

-- Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-30,0,50)
toggle.Position = UDim2.fromOffset(15,55)
toggle.Text = "INFINITE JUMP: OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 16
toggle.Font = Enum.Font.GothamBold
toggle.BackgroundColor3 = Color3.fromRGB(55,55,55)
toggle.Parent = main

Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,8)

-- Restore circle
local restore = Instance.new("TextButton")
restore.Size = UDim2.fromOffset(60,60)
restore.Position = UDim2.new(1,-80,0,50)
restore.Text = "♾️"
restore.TextSize = 24
restore.TextColor3 = Color3.new(1,1,1)
restore.BackgroundColor3 = Color3.fromRGB(30,30,30)
restore.Visible = false
restore.Parent = gui

Instance.new("UICorner",restore).CornerRadius = UDim.new(1,0)

-- Dragging
local function makeDraggable(handle,object)

	local dragging = false
	local startInput
	local startPosition

	handle.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			startInput = input.Position
			startPosition = object.Position

			input.Changed:Connect(function()

				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if not dragging then return end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - startInput

			object.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)
end

makeDraggable(title,main)
makeDraggable(restore,restore)

-- Toggle infinite jump
toggle.Activated:Connect(function()

	infiniteJump = not infiniteJump

	if infiniteJump then
		toggle.Text = "INFINITE JUMP: ON"
	else
		toggle.Text = "INFINITE JUMP: OFF"
	end
end)

-- Jump
UserInputService.JumpRequest:Connect(function()

	if not infiniteJump then
		return
	end

	local character = player.Character
	local humanoid = character
		and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Close / restore
close.Activated:Connect(function()

	main.Visible = false
	restore.Visible = true
end)

restore.Activated:Connect(function()

	main.Visible = true
	restore.Visible = false
end)