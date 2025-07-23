-- LocalScript in StarterPlayerScripts

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- Default force value
local forceMagnitude = 100

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JumpForceUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 200, 0, 50)
sliderFrame.Position = UDim2.new(0, 20, 0, 20)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = screenGui

local fill = Instance.new("Frame")
fill.Size = UDim2.new(forceMagnitude / 200, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
fill.BorderSizePixel = 0
fill.Parent = sliderFrame

local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0, 10, 1, 0)
knob.Position = UDim2.new(forceMagnitude / 200, -5, 0, 0)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.Text = ""
knob.BorderSizePixel = 0
knob.AutoButtonColor = false
knob.Parent = sliderFrame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 200, 0, 30)
label.Position = UDim2.new(0, 20, 0, 75)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Text = "Force: " .. forceMagnitude
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Parent = screenGui

-- UI visibility toggle
local uiVisible = true

local function updateSlider(x)
	local relative = math.clamp((x - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
	forceMagnitude = math.floor(relative * 200)
	fill.Size = UDim2.new(relative, 0, 1, 0)
	knob.Position = UDim2.new(relative, -5, 0, 0)
	label.Text = "Force: " .. forceMagnitude
end

-- Dragging support for both mouse and touch
local dragging = false

knob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			updateSlider(input.Position.X)
		end
	end
end)

-- Input handler for launching and toggling UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

	-- Launch upward
	if input.KeyCode == Enum.KeyCode.F or
	   (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonR1) then
		if hrp then
			hrp.Velocity = Vector3.new(0, forceMagnitude, 0)
		end
	end

	-- Toggle UI: PC "0" or Gamepad D-Pad Right
	if input.KeyCode == Enum.KeyCode.Zero or
	   (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.DPadRight) then
		uiVisible = not uiVisible
		screenGui.Enabled = uiVisible
	end
end)
