#!/usr/bin/wpexec

local config = ...

-- local config = {
--     {
--         ["input"] = "virtual.system-output",
--         ["output"] = "effect_input.speaker-eq",
--         ["port_map"] = {
--             ["monitor_FL"] = "playback_FL",
--             ["monitor_FR"] = "playback_FR",
--         },
--     },
--     {
--         ["input"] = "effect_output.speaker-eq",
--         ["output"] = "alsa_output.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-output-0",
--         ["port_map"] = {
--             ["output_FL"] = "playback_AUX0",
--             ["output_FR"] = "playback_AUX1",
--         },
--     },
--     {
--         ["input"] = "virtual.system-output",
--         ["output"] = "alsa_output.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-output-0",
--         ["port_map"] = {
--             ["monitor_FL"] = "playback_AUX2",
--             ["monitor_FR"] = "playback_AUX3",
--         },
--     },
--     {
--         ["input"] = "virtual.voip-output",
--         ["output"] = "virtual.system-output",
--         ["port_map"] = {
--             ["monitor_FL"] = "playback_FL",
--             ["monitor_FR"] = "playback_FR",
--         },
--     },
--     {
--         ["input"] = "alsa_input.usb-BEHRINGER_UMC1820_BAB9273B-00.pro-input-0",
--         ["output"] = "virtual.voip-microphone",
--         ["port_map"] = {
--             ["capture_AUX0"] = "input_FL",
--             ["capture_AUX0"] = "input_FR",
--         },
--     },
-- }

link_om = ObjectManager {
    Interest {
        type = "link"
    }
}

links = {}
active_links = {}

function try_activate_link(link)
    if link["link.input.node"] == nil or link["link.input.port"] == nil or link["link.output.node"] == nil or link["link.output.port"] == nil then
        print("Link not complete")
        return
    end

    local link_index = link["link.input.node"] .. " " .. link["link.input.port"] .. " " .. link["link.output.node"] .. " " .. link["link.output.port"]

    if active_links[link_index] ~= nil then
        print("Link is active")
        return
    end

    local count = 0
    for k,v in pairs(link) do
        count = count + 1
    end
    if count ~= 4 then
        print("Not all properties are set")
        return
    end

    active_links[link_index] = Link("link-factory", link)
    active_links[link_index]:activate(1)
end

function add_ports(index, node, direction, port_map)
    local object_id = node.properties["object.id"]
    for k,v in pairs(port_map) do
        local port_name = nil
        if direction == "input" then
            port_name = v
        else
            port_name = k
        end

        local port_om = ObjectManager {
            Interest {
                type = "port",
                Constraint {"port.name", "=", port_name},
                Constraint {"node.id", "=", object_id},
            }
        }

        if links[index][k] == nil then
            links[index][k] = {
                ["link.output.port"] = nil,
                ["link.input.port"] = nil,
                ["link.output.node"] = nil,
                ["link.input.node"] = nil
            }
        end

        port_om:connect("object-added", function(om, port)
            links[index][k]["link." .. direction .. ".port"] = port.properties["port.id"]
            try_activate_link(links[index][k])
        end)
        port_om:activate()

        links[index][k]["link." .. direction .. ".node"] = object_id
    end
end

function deactivate_link(id, link)
        if link == nil then
            return
        end
        link:request_destroy()

        active_links[id] = nil
end

function get_links_by_node_id(id)
    local result = {}
    for k,v in pairs(active_links) do
        if v["link.output.node"] == id or v["link.input.node"] == id then
            result[k] = v
        end
    end

    return result
end

for index,conn in pairs(config) do
    links[index] = {}

    local input_om = ObjectManager {
        Interest {
            type = "node",
            Constraint {
                "node.name", "=", conn["input"]
            }
        }
    }

    local output_om = ObjectManager {
        Interest {
            type = "node",
            Constraint {
                "node.name", "=", conn["output"]
            }
        }
    }

    output_om:connect("object-added", function(om, node)
        add_ports(index, node, "input", conn["port_map"])
        for k,link in pairs(links[index]) do
            try_activate_link(link)
        end
    end)

    input_om:connect("object-added", function(om, node)
        add_ports(index, node, "output", conn["port_map"])
        for k,link in pairs(links[index]) do
            try_activate_link(link)
        end
    end)

    input_om:connect("object-removed", function (om, node)
        for k,v in pairs(get_links_by_node_id(node["object.id"])) do
            deactivate_link(k, v)
        end
    end)

    output_om:connect("object-removed", function (om, node)
        for k,v in pairs(get_links_by_node_id(node["object.id"])) do
            deactivate_link(k, v)
        end
    end)

    input_om:activate()
    output_om:activate()
end

local function find_link_index (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

link_om:connect("object-removed", function (om, l)
    for i, link in ipairs(active_links) do
        if link == l then
            active_links[i] = nil
            try_activate_link(l)
            return true
        end
    end
end)

link_om:activate()
