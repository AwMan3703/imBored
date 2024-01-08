
-- Connect to a quad-copter system's individual thrusters' throttling to stabilize it regardless (kinda) of weight


-- INPUT

-- set the connections here
-- schema: [thruster_position] = "[computer_side]"
-- the signal for thruster_position will be outputted on computer_side
-- you may output on any side (top, bottom, front, back, left, right)
local thruster_connections = {
    front_left = "front",
    front_right = "right",
    back_left = "left",
    back_right = "back"
}

-- whatever you need to do to get roll value
local function get_roll()
    local roll = 0
    return roll
end

-- whatever you need to do to get pitch value
local function get_pitch()
    local pitch = 0
    return pitch
end

-- the position you want to correct to
local target_position = {
	roll = 0,
	pitch = 0
}

-- the tilt threshold (in degrees) at which the thrusters are set to maximum power to correct the position
local max_correction_threshold = {
	roll = 45,
	pitch = 45
}


-- CONSTANTS

local axes = {
    roll = "AXES_ROLL",
    pitch = "AXES_PITCH",
    yaw = "AXES_YAW",
}

local signal_range_max = 30 --output signal range (0 to X)


-- UTILITY

-- scale a value between 0 and 1
local function normalize(value, min, max) return (value - min) / (max - min) end


-- SCRIPT

-- find how much signal you need to correct the tilt
local function get_correction_signal(error)
	if error == 0 then return {}, 0 end -- skip useless computing
	local correction = 0 - error -- invert the error to find the correction
	correction = normalize(correction, 0, 180) -- normalize to force between target_position and target_position + max_correction_threshold
	correction = correction * signal_range_max -- range the correction
	return correction
end

--in: axis, error; out: output_signals
--	axis: the axis to map the correction on
--	error: how much the tilt to correct is
--	output_signals: data on how to throttle the thrusters to stabilize
--	delta: the correction signal to output (in redtone intensity)
--e.g.
--		in: roll, -35
--		out: {
--			{thruster_connections.front_left, -3},
--			{thruster_connections.front_right, +9},
--			{thruster_connections.back_left, -3},
--			{thruster_connections.back_right, +9}
--		}
local function get_mapped_correction(axis, error)
	local correction = get_correction_signal(error)
	--convert to output shown in comment
end

print(get_mapped_correction(axes.pitch, -67))


