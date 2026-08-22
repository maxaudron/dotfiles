-- https://www.julienturbide.com/blog/hyprland-acceleration-curve-setup

-- Windows 10 registry curve points
local x = {
	"\x00\x00\x00\x00",
	"\x15\x6e\x00\x00",
	"\x00\x40\x01\x00",
	"\x29\xdc\x03\x00",
	"\x00\x00\x28\x00",
}

local y = {
	"\x00\x00\x00\x00",
	"\xfd\x11\x01\x00",
	"\x00\x24\x04\x00",
	"\x00\xfc\x12\x00",
	"\x00\xc0\xbb\x01",
}

local function float16x16(num)
	return string.unpack("<i", num) / 0xffff
end

local pointer = {}

function pointer.accel(device_dpi, screen_dpi, screen_scaling_factor, sample_points_count, sensitivity_factor)
	local scale_x = device_dpi / 1e3
	local scale_y = screen_dpi / 1e3 / screen_scaling_factor * sensitivity_factor

	local windows_points = {}
	local points = {}

	for i = 1, 5 do
		table.insert(windows_points, { float16x16(x[i]), float16x16(y[i]) })
	end

	for _, point in ipairs(windows_points) do
		local px, py = point[1], point[2]
		table.insert(points, { px * scale_x, py * scale_y })
	end

	local function find2points(ix)
		local i = 1
		while i < #points - 1 and ix >= points[i + 1][1] do
			i = i + 1
		end
		return points[i], points[i + 1]
	end

	local function interpolate(ix)
		local p0, p1 = find2points(ix)
		local t = (ix - p0[1]) / (p1[1] - p0[1])
		local a, b = p0[2], p1[2]

		return a + (b - a) * t
	end

	local last_point = #points - 1
	local max_x = points[last_point][1]
	local step = max_x / (sample_points_count + last_point)

	local sample_points_x, sample_points_y = {}, {}
	for si = 1, sample_points_count - 1 do
		local sx = si * step
		table.insert(sample_points_x, sx)
		table.insert(sample_points_y, interpolate(sx))
	end

	local parts = {}
	for i = 1, #sample_points_y do
		parts[i] = string.format("%.3f", sample_points_y[i])
	end

	return string.format("custom %.10f " .. table.concat(parts, " "), step)
end

return pointer
