--[[
* --------------------------------------------------------------------
* @file    kick.lua
* @brief   Several chat commands to be used by staff.
* @author  smk (smk@it.ca)
* @version 20230417
* @license BSD3
* @bugs    No know bugs
* --------------------------------------------------------------------
]]

--[[
* kick : Kicks a player from the server.
* kick2 : Kicks a player for 60 seconds.
* kick3 : Kicks a player for 10 minutes.
* kick4 : Kicks a player for 1 hour.
* kick5 : Kicks a player for 1 day.
* kick6 : Kicks a player for 1 week.
]]

-- check if xban2 is installed
if minetest.get_modpath("xban2") then
    minetest.log("action", "[kick] xban2 is installed.")
else
    minetest.log("action", "[kick] xban2 is not installed.")
end

-- load xban api
local xban = { MP = minetest.get_modpath("xban2") }

-- list of time values from 60 seconds to 1 week in seconds
local time = { 60, 600, 6000, 86400, 604800 }
local time_str = { "60 seconds", "10 minutes", "1 hour", "1 day", "1 week" }

-- register chat commands from kick2 to kick7 for different time values
for i = 2, 6 do
    minetest.register_chatcommand("kick" .. i, {
        params = "<name> <reason>",
        description = "Kick a player for " .. time_str[i - 1],
        privs = { kick = true },
        func = function(name, param)
            local player, reason = param:match("^(%S+)%s(.+)$")
            if not player then
                return false, "Invalid usage, see /help kick" .. i
            end
            if xban.MP then
                xban.ban_player(name, player, reason, time[i - 1])
            else
                minetest.kick_player(player, reason)
            end
            minetest.log("action", name .. " kicked " .. player .. " for " .. time_str[i - 1])
            return true, "Kicked " .. player .. " for " .. time_str[i - 1]
        end
    })
end