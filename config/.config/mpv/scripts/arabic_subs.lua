local function set_shit()
    mp.set_property("sub-font", "Noto Sans")
    mp.set_property("sub-font-size", "48")
    mp.set_property("sub-color", "#FFFFFFFF") -- white
    mp.set_property("sub-border-size", "2")
    mp.set_property("sub-shadow-offset", "1")
    mp.osd_message("Setting default subtitle style", 2)
end
local function set_sub_style()
    local sid = mp.get_property_number("sid")
    if not sid then return end

    local tracks = mp.get_property_native("track-list")
    for _, t in ipairs(tracks) do
        if t.id == sid and t.type == "sub" then
            if t.lang == "ar" or t.lang == "ara" then
                set_shit()
            else
                set_shit()
            end
        end
    end
end

mp.observe_property("sid", "number", set_sub_style)
