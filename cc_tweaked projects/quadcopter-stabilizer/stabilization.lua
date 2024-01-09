
-- Connect to a quad-copter system's individual thrusters' throttling to stabilize it regardless (kinda) of weight


-- INPUT

-- set the connections here
-- schema: [thruster_position] = "[computer_side]"
-- the signal for thruster_position will be outputted on computer_side
-- can be any of the following: "top", "bottom", "front", "back", "left", "right"
local thruster_connections = {
    front_left = "fl",
    front_right = "fr",
    back_left = "bl",
    back_right = "br"
}

local shipReader = peripheral.find("ship_reader")

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

local signal_range_max = 30 --output signal range (0 to X)

local axes = {
    roll = "AXES_ROLL",
    pitch = "AXES_PITCH",
    yaw = "AXES_YAW",
}

--which thrusters affect which axes
local axes_thruster_mapping = {
    [axes.pitch] = {
        positive = { thruster_connections.front_left, thruster_connections.front_right },
        negative = { thruster_connections.back_left, thruster_connections.back_right }
    },
    [axes.roll] = {
        positive = { thruster_connections.front_right, thruster_connections.back_right },
        negative = { thruster_connections.front_left, thruster_connections.back_left }
    }
}


-- UTILITY

-- scale a value between 0 and 1
local function normalize(value, min, max) return (value - min) / (max - min) end


-- SCRIPT

-- get the current ship rotation data
local function get_deg_rotation()
    local rotation = shipReader.getRotation() 
    local pitch = math.floor(math.deg(rotation.pitch)) % 360
    local roll = math.floor(math.deg(rotation.yaw)) % 360 -- YAW AND ROLL ARE INVERTED!!!!
    local yaw = math.floor(math.deg(rotation.roll)) % 360 -- because of a bug i think??
end

-- for any given axis, figure out which thrusters affect it
local function get_affecting_thrusters(axis)
    return axes_thruster_mapping[axis]
end

-- find how much signal you need to correct the tilt
local function get_correction_signal(error)
	if error == 0 then return {}, 0 end -- skip useless computing
	local correction = 0 - error -- invert the error to find the correction
	correction = normalize(correction, 0, 180) -- normalize to force between target_position and target_position + max_correction_threshold
	correction = correction * signal_range_max -- range the correction
	return correction
end

-- in: axis, error; out: output_signals
--	axis: the axis to map the correction on
--	error: how much the tilt to correct is
--	output_signals: data on how to throttle the thrusters to stabilize
--	delta: the correction signal to output (in redtone intensity)
-- e.g.
--		in: roll, -35
--		out: {
--			{thruster_connections.front_left, -3},
--			{thruster_connections.front_right, +3},
--			{thruster_connections.back_left, -3},
--			{thruster_connections.back_right, +3}   --correction total: 6, tilting left
--		}
local function get_mapped_correction(axis, error)
    local out = {}
	local correction = get_correction_signal(error)

	-- Convert to output shown in comment --
    --get the affecting thrusters
    local thrusters = get_affecting_thrusters(axis)
    --for each of them:
    for i=1, #thrusters.positive do
        table.insert(out, {thrusters.positive[i], correction}) end --apply correction
    for i=1, #thrusters.negative do
        table.insert(out, {thrusters.negative[i], 0 - correction}) end --apply negative correction

    return out
end



local function main()

    print(textutils.serialize(
        get_mapped_correction(axes.roll, -67)
    ))

end main()
