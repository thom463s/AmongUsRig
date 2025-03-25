-- @thom463s
wait(3)

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
assert(humanoid.RigType == Enum.HumanoidRigType.R6)

local map = {
	["Left Arm"] = CFrame.new(0, 0, 0.5) * CFrame.Angles(0, 0, 0),
	["Right Arm"] = CFrame.new(0, 0.25, -0.5) * CFrame.Angles(0, 0, math.rad(90)),
	["Head"] = CFrame.new(0, 0.25, 0.125) * CFrame.Angles(0, 0, 0),
	["Left Leg"] = CFrame.new(-1, -0.5, 0) * CFrame.Angles(0, math.rad(-90), 0),
	["Right Leg"] = CFrame.new(1, -0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
}

local sizes = {
	["Left Leg"] = Vector3.one,
	["Right Leg"] = Vector3.one
}

local function create_weld(name, part0, part1, c0, parent)
	local weld = Instance.new("Weld")
	weld.Name = name
	weld.Part0 = part0
	weld.Part1 = part1
	weld.C0 = c0
	weld.Parent = parent
	return weld
end

local function create_sound(id, volume, pitch, parent)
	local sound = Instance.new("Sound")
	sound.SoundId = `rbxassetid://{tostring(id):gsub("%D", "")}`
	sound.Volume = volume
	sound.PlaybackSpeed = pitch
	sound.Parent = parent
	return sound
end

local function smooth(x)
	if x < 0.5 then
		x *= x
		return 8 * x * x
	end

	x -= 1
	return 1 - 8 * x * x * x * x
end

local function destroy(obj, d)
	task.delay(d or 1, function()
		obj:Destroy()
	end)
end

local head = character:WaitForChild("Head")
local torso = character:WaitForChild("Torso")
local left_arm = character:WaitForChild("Left Arm")
local right_arm = character:WaitForChild("Right Arm")
local left_leg = character:WaitForChild("Left Leg")
local right_leg = character:WaitForChild("Right Leg")

local cf_torso = torso.CFrame
local cf_left_arm = cf_torso:ToObjectSpace(left_arm.CFrame)
local cf_right_arm = cf_torso:ToObjectSpace(right_arm.CFrame)
local cf_head = cf_torso:ToObjectSpace(head.CFrame)

local cf_left_leg, cf_right_leg do
	local left_hip = torso:WaitForChild("Left Hip")
	local right_hip = torso:WaitForChild("Right Hip")
	cf_left_leg = left_hip.C0
	cf_right_leg = right_hip.C0
end

local size_left_leg = left_leg.Size
local size_right_leg = right_leg.Size

local LW = create_weld("LW", torso, left_arm, cf_left_arm, torso)
local RW = create_weld("RW", torso, right_arm, cf_right_arm, torso)
local HW = create_weld("HW", torso, head, cf_head, torso)

local function update(alpha)
	local lw_cf = cf_left_arm:Lerp(map["Left Arm"], alpha)
	local rw_cf = cf_right_arm:Lerp(map["Right Arm"], alpha)
	local hw_cf = cf_head:Lerp(map["Head"], alpha)
	
	local left_hip = torso:FindFirstChild("Left Hip")
	local right_hip = torso:FindFirstChild("Right Hip")
	
	local ll_cf = cf_left_leg:Lerp(map["Left Leg"], alpha)
	local rl_cf = cf_right_leg:Lerp(map["Right Leg"], alpha)
	local ll_size = size_left_leg:Lerp(sizes["Left Leg"], alpha)
	local rl_size = size_right_leg:Lerp(sizes["Right Leg"], alpha)
	
	LW.C0 = lw_cf
	RW.C0 = rw_cf
	HW.C0 = hw_cf
	
	left_hip.C0 = ll_cf
	right_hip.C0 = rl_cf
	left_leg.Size = ll_size
	right_leg.Size = rl_size
end

local pitch = math.random(85, 110) / 100
local sound = create_sound(5799014146, 1, pitch, head)
destroy(sound, 10)
sound:Play()

local start = os.clock()
while os.clock() - start < 3 do
	local alpha = smooth(math.min((os.clock() - start) / 3, 1))
	update(alpha)
	wait(0)
end
update(1)
