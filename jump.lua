local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local NORMAL_JUMP = 50
local MAX_JUMP = 1000000

local jumpPower = NORMAL_JUMP
local enabled = false

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "HighJumpGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Main box
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(300, 155)
main.Position = UDim2.new(0.5, -150, 0.5, -77)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

--==================================================
-- TITLE / DRAG BAR
--==================================================

local dragBar = Instance.new("TextButton")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.new(1, -45, 0, 40)
dragBar.Position = UDim2.fromOffset(0, 0)
dragBar.BackgroundTransparency = 1
dragBar.Text = "HIGH JUMP"
dragBar.TextColor3 = Color3.new(1, 1, 1)
dragBar.TextSize = 20
dragBar.Font = Enum.Font.GothamBold
dragBar.Parent = main

--==================================================
-- CLOSE BUTTON
--==================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -40, 0, 3)
close.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = close

--==================================================
-- NUMBER BOX
--==================================================

local input = Instance.new("TextBox")
input.Size = UDim2.fromOffset(185, 42)
input.Position = UDim2.fromOffset(12, 50)
input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
input.PlaceholderText = "Jump Power"
input.Text = ""
input.TextSize = 16
input.ClearTextOnFocus = false
input.Parent = main

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = input

--==================================================
-- OK BUTTON
--==================================================

local ok = Instance.new("TextButton")
ok.Size = UDim2.fromOffset(85, 42)
ok.Position = UDim2.fromOffset(205, 50)
ok.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
ok.Text = "OK"
ok.TextColor3 = Color3.new(1, 1, 1)
ok.TextSize = 16
ok.Font = Enum.Font.GothamBold
ok.Parent = main

local okCorner = Instance.new("UICorner")
okCorner.CornerRadius = UDim.new(0, 8)
okCorner.Parent = ok

--==================================================
-- ON/OFF BUTTON
--==================================================

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -24, 0, 45)
toggle.Position = UDim2.fromOffset(12, 102)
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
toggle.Text = "HIGH JUMP: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 17
toggle.Font = Enum.Font.GothamBold
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

--==================================================
-- ROUND RESTORE BUTTON
--==================================================

local restore = Instance.new("TextButton")
restore.Name = "RestoreButton"
restore.Size = UDim2.fromOffset(60, 60)
restore.Position = UDim2.new(0.5, -30, 0.5, -30)
restore.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
restore.Text = "HJ"
restore.TextColor3 = Color3.new(1, 1, 1)
restore.TextSize = 17
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.Parent = gui

local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(1, 0)
restoreCorner.Parent = restore

--==================================================
-- DRAG FUNCTION
--==================================================

local function makeDraggable(handle, object)

	local dragging = false
	local dragStart
	local startPosition

	handle.InputBegan:Connect(function(inputObject)

		if inputObject.UserInputType == Enum.UserInputType.MouseButton1
			or inputObject.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = inputObject.Position
			startPosition = object.Position

			inputObject.Changed:Connect(function()

				if inputObject.UserInputState == Enum.UserInputState.End then
					dragging = false
				end

			end)
		end

	end)

	UserInputService.InputChanged:Connect(function(inputObject)

		if not dragging then
			return
		end

		if inputObject.UserInputType == Enum.UserInputType.MouseMovement
			or inputObject.UserInputType == Enum.UserInputType.Touch then

			local delta = inputObject.Position - dragStart

			object.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,

				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end

	end)
end

-- Main window moves from title
makeDraggable(dragBar, main)

-- Restore circle moves by itself
makeDraggable(restore, restore)

--==================================================
-- APPLY JUMP POWER
--==================================================

local function applyJumpPower()

	local character = player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return
	end

	humanoid.UseJumpPower = true

	if enabled then
		humanoid.JumpPower = jumpPower
	else
		humanoid.JumpPower = NORMAL_JUMP
	end

end

--==================================================
-- OK
--==================================================

ok.Activated:Connect(function()

	local number = tonumber(input.Text)

	if not number then
		input.Text = tostring(jumpPower)
		return
	end

	number = math.floor(number)

	jumpPower = math.clamp(number, 1, MAX_JUMP)

	input.Text = tostring(jumpPower)

	if enabled then
		applyJumpPower()
	end

end)

--==================================================
-- TOGGLE
--==================================================

toggle.Activated:Connect(function()

	enabled = not enabled

	if enabled then
		toggle.Text = "HIGH JUMP: ON"
	else
		toggle.Text = "HIGH JUMP: OFF"
	end

	applyJumpPower()

end)

--==================================================
-- CLOSE / RESTORE
--==================================================

close.Activated:Connect(function()

	main.Visible = false
	restore.Visible = true

end)

restore.Activated:Connect(function()

	main.Visible = true
	restore.Visible = false

end)

--==================================================
-- CHARACTER RESPAWN
--==================================================

player.CharacterAdded:Connect(function(character)

	local humanoid = character:WaitForChild("Humanoid")

	task.wait(0.2)

	humanoid.UseJumpPower = true

	if enabled then
		humanoid.JumpPower = jumpPower
	else
		humanoid.JumpPower = NORMAL_JUMP
	end

end)