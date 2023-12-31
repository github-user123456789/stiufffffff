-- Now with exciting TeamColors HACK!

function waitForChild(parent, childName)
	while true do
		local child = parent:findFirstChild(childName)
		if child then
			return child
		end
		parent.ChildAdded:wait()
	end
end


----------------------------- TEAM COLORS


function onTeamChanged(player)

	wait(1)

	local char = player.Character
	if char == nil then return end

	if (player.Neutral == true) then 
		-- Replacing the current BodyColor object will force a reset
		local old = char:findFirstChild("Body Colors")
		if (old == nil) then return end
		old:clone().Parent = char
		old.Parent = nil
	else
		local head = char:findFirstChild("Head")
		local torso = char:findFirstChild("Torso") 
		local left_arm = char:findFirstChild("Left Arm") 
		local right_arm = char:findFirstChild("Right Arm") 
		local left_leg = char:findFirstChild("Left Leg") 
		local right_leg = char:findFirstChild("Right Leg") 

		if head ~= nil then head.BrickColor = BrickColor.new(24) end
		if torso ~= nil then torso.BrickColor = player.TeamColor end
		if left_arm ~= nil then left_arm.BrickColor = BrickColor.new(26) end
		if right_arm ~= nil then right_arm.BrickColor = BrickColor.new(26) end
		if left_leg ~= nil then left_leg.BrickColor = BrickColor.new(26) end
		if right_leg ~= nil then right_leg.BrickColor = BrickColor.new(26) end
	end

	

end

function onPlayerPropChanged(property, player)
	if property == "Character" then
		onTeamChanged(player)
	end
	if property== "TeamColor" or property == "Neutral" then
		onTeamChanged(player)
	end
end


local cPlayer = game.Players:GetPlayerFromCharacter(script.Parent)
cPlayer.Changed:connect(function(property) onPlayerPropChanged(property, cPlayer) end )
onTeamChanged(cPlayer)


----------------------------- ANIMATION

-- declarations

local Figure = script.Parent
local Torso = waitForChild(Figure, "Torso")
local RightShoulder = waitForChild(Torso, "Right Shoulder")
local LeftShoulder = waitForChild(Torso, "Left Shoulder")
local RightHip = waitForChild(Torso, "Right Hip")
local LeftHip = waitForChild(Torso, "Left Hip")
local Neck = waitForChild(Torso, "Neck")
local Humanoid = waitForChild(Figure, "Humanoid")
local pose = "Standing"

local toolAnim = "None"
local toolAnimTime = 0

local isSeated = false

-- functions

function onRunning(speed)
	if isSeated then return end

	if speed>0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end

function onDied()
	pose = "Dead"
end

function onJumping()
	isSeated = false
	pose = "Jumping"
end

function onClimbing()
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onSeated()
	isSeated = true
	pose = "Seated"
end



function moveJump()
	RightShoulder.MaxVelocity = 0.5
	LeftShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 3.14
	LeftShoulder.DesiredAngle = -3.14
	RightHip.DesiredAngle = 0
	LeftHip.DesiredAngle = 0
end

function moveFreeFall()
	RightShoulder.MaxVelocity = 0.5
	LeftShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = 1
	LeftShoulder.DesiredAngle = -1
	RightHip.DesiredAngle = 0
	LeftHip.DesiredAngle = 0
end


function moveClimb()
	RightShoulder.MaxVelocity = 0.5
	LeftShoulder.MaxVelocity = 0.5
	RightShoulder.DesiredAngle = -3.14
	LeftShoulder.DesiredAngle = 3.14
	RightHip.DesiredAngle = 0
	LeftHip.DesiredAngle = 0
end

function moveSit()
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	RightShoulder.DesiredAngle = 3.14 /2
	LeftShoulder.DesiredAngle = -3.14 /2
	RightHip.DesiredAngle = 3.14 /2
	LeftHip.DesiredAngle = -3.14 /2
end

function getTool()
	
	kidTable = Figure:children()
	if (kidTable ~= nil) then
		numKids = #kidTable
		for i=1,numKids do
			if (kidTable[i].className == "Tool") then return kidTable[i] end
		end
	end
	
	return nil
end

function getToolAnim(tool)

	c = tool:children()
	for i=1,#c do
		if (c[i].Name == "toolanim" and c[i].className == "StringValue") then
			return c[i]
		end
	end
	return nil
end

function animateTool()
	
	if (toolAnim == "None") then
		RightShoulder.DesiredAngle = 1.57
		return
	end

	if (toolAnim == "Slash") then
		RightShoulder.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = 0
		return
	end

	if (toolAnim == "Lunge") then
		RightShoulder.MaxVelocity = 0.5
		LeftShoulder.MaxVelocity = 0.5
		RightHip.MaxVelocity = 0.5
		LeftHip.MaxVelocity = 0.5
		RightShoulder.DesiredAngle = 1.57
		LeftShoulder.DesiredAngle = 1.0
		RightHip.DesiredAngle = 1.57
		LeftHip.DesiredAngle = 1.0
		return
	end
end

function move(time)
	local amplitude
	local frequency

	if (pose == "Jumping") then
		moveJump()
		return
	end

	if (pose == "FreeFall") then
		moveFreeFall()
		return
	end

	if (pose == "Climbing") then
		moveClimb()
		return
	end

	if (pose == "Seated") then
		moveSit()
		return
	end


	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	if (pose == "Running") then
		amplitude = 1
		frequency = 9
	else
		amplitude = 0.1
		frequency = 1
	end

	desiredAngle = amplitude * math.sin(time*frequency)

	RightShoulder.DesiredAngle = desiredAngle
	LeftShoulder.DesiredAngle = desiredAngle
	RightHip.DesiredAngle = -desiredAngle
	LeftHip.DesiredAngle = -desiredAngle


	local tool = getTool()

	if tool ~= nil then
	
		animStringValueObject = getToolAnim(tool)

		if animStringValueObject ~= nil then
			toolAnim = animStringValueObject.Value
			-- message recieved, delete StringValue
			animStringValueObject.Parent = nil
			toolAnimTime = time + .3
		end

		if time > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()

		
	else
		toolAnim = "None"
		toolAnimTime = 0
	end
end


-- connect events

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)

-- main program

local nextTime = 0
local runService = game:service("RunService");

while Figure.Parent~=nil do
	time = runService.Stepped:wait()
	if time > nextTime then
		move(time)
		nextTime = time + 0.1
	end
end
