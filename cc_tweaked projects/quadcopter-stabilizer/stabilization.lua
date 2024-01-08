
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


-- CONSTANTS

local axes = {
    roll = "AXES_ROLL",
    pitch = "AXES_PITCH",
    yaw = "AXES_YAW",
}


-- SCRIPT

--in: axis, error; out: output signal position
--e.g. in: roll, -35; out: thruster_connections.back_right
local function map_correction(axis, error)

end



