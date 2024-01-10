
-- UTILITY CONSTANTS - ignore this part -------------------------------------------------

local axes = {
    roll = "AXES_ROLL",
    pitch = "AXES_PITCH",
    yaw = "AXES_YAW",
}

-----------------------------------------------------------------------------------------

-- ABOUT

-- Mods needed:
-- CC:Tweaked (code execution), Valkyrien skies (ships), Valkyrien computers (sensors)

-- Connect this computer to a quad-copter-like system's individual thrusters' throttling to stabilize it regardless (kinda) of weight
-- assign a side to each thruster in the thruster_connections table, then connect a valkyrien computers' ship reader and run this program:
-- the algorithm will try to balance it so that even if weight balancement changes the whole thing doesn't tilt over and fly off.


-- INPUT

-- set the connections here
-- schema: [thruster_position] = "[computer_side]"
-- the signal for thruster_position will be outputted on computer_side
-- can be any of the following: "top", "bottom", "front", "back", "left", "right"
local thruster_connections = {
    front_left = "front",
    front_right = "right",
    back_left = "left",
    back_right = "back"
}

-- connect your ship reader
local shipReader = peripheral.find("ship_reader")

-- wether to output details about the process
local verbose_output = true

-- the target range of rotation you want to correct to, 0 being perfectly vertical
local target_rotation = {
	roll = { min = -1, max = 1 },
	pitch = { min = -1, max = 1 }
}

-- the tilt threshold (in degrees) at which the thrusters are set to maximum power to correct the position
local max_correction_threshold = {
	[axes.roll] = 45,
	[axes.pitch] = 45
}


-- CONSTANTS

local signal_range_max = 15 --output signal range (0 to X)

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

-- log levels for stdout()
local log_levels = {
    info = "INFO",
    warn = "WARN",
    error = "ERROR",
    fatal = "FATAL"
}


-- UTILITY FUNCTIONS

-- output process information
local function stdout(text, level) if verbose_output or level == log_levels.fatal then print("[STABILIZER.lua/"..(level or log_levels.info).."] > "..text) end end

-- scale a value between 0 and 1
local function normalize(value, min, max) return (value - min) / (max - min) end


-- SCRIPT

-- get the current ship's rotation data
local function get_rotation_deg()
    stdout("obtaining rotation info from ship reader...")

    -- get the rotation from the ship reader
    local rotation = shipReader.getRotation() 
    local pitch = math.floor(math.deg(rotation.pitch)) % 360
    local roll = math.floor(math.deg(rotation.yaw)) % 360 -- YAW AND ROLL ARE INVERTED!!!!
    local yaw = math.floor(math.deg(rotation.roll)) % 360 -- because of a bug i think??

    -- make it a value between -180 and +180
    local cRoll = roll > 180 and 0 - (360 - roll) or roll
    local cPitch = pitch > 180 and 0 - (360 - pitch) or pitch

    return {
        roll = cRoll,
        pitch = cPitch,
        yaw = yaw
    }
end

-- for any given axis, figure out which thrusters affect it
local function get_affecting_thrusters(axis)
    return axes_thruster_mapping[axis]
end

-- find how much signal you need to correct the tilt
local function get_correction_signal(error, axis)
	if error == 0 then return 0 end -- skip useless computing
	local correction = error -- invert the error to find the correction
	correction = normalize(correction, target_rotation, max_correction_threshold[axis]) -- normalize to force between target_rotation and target_rotation + max_correction_threshold
	correction = correction * signal_range_max -- range the correction
	return 0 - correction
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
    stdout("mapping correction for axis "..axis.."; error: "..error.."deg...")
    local out = {}
	local correction = get_correction_signal(error, axis)
    correction = math.ceil(correction) --uhm sir redstone signals must be integers ☝️🤓

	-- Convert to output shown in comment --
    --get the affecting thrusters
    local thrusters = get_affecting_thrusters(axis)
    stdout("found affecting thrusters")
    --for each of them:
    for i=1, #thrusters.positive do
        table.insert(out, {thrusters.positive[i], correction}) end --apply correction
    for i=1, #thrusters.negative do
        table.insert(out, {thrusters.negative[i], 0 - correction}) end --apply negative correction

    return out
end

-- combine multiple get_mapped_correction() outputs
local function sum_mapped_corrections(...)
    stdout("summing mapped corrections...")
    local out = {
        [thruster_connections.front_left] = 0,
        [thruster_connections.front_right] = 0,
        [thruster_connections.back_left] = 0,
        [thruster_connections.back_right] = 0
    }

    for i=1, #arg do
        local mapped_correction = arg[i]

        for i=1, #mapped_correction do
            local correction = mapped_correction[i]
            local target = correction[1]
            local variation = correction[2]

            out[target] = out[target] + variation
        end
    end

    return out
end

-- basically just set engines to the corrected power level
local function apply_corrections(summed_corrections)
    stdout("applying corrections...")
    for thruster, value in pairs(summed_corrections) do
        stdout("setting thruster "..thruster.." to "..value)
        redstone.setAnalogOutput(thruster, value)
    end
end



-- quick check
if not shipReader then stdout("NO SHIP READER CONNECTED", log_levels.fatal) return end

local function main()

    -- get the current tilt (ignore yaw because i'm cool like that)
    local cRot = get_rotation_deg()

    -- calculate the error
    local errorRoll = cRot.roll
    local errorPitch = cRot.pitch

    -- calculate correction signals
    local correctRoll = get_mapped_correction(axes.roll, -67)
    local correctPitch = get_mapped_correction(axes.pitch, 42)

    local correctSum = sum_mapped_corrections( correctRoll, correctPitch )

    apply_corrections( correctSum )

end main()
