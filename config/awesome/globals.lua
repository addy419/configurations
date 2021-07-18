-- Print global varibles for debugging
local function serialize_table()
    local keys = ""
    for k,v in pairs(_G) do
        keys = keys .. k .. "\n"
    end
    return keys;
end

global_vars = serialize_table()
