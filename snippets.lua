lg = love.graphics;
la = love.audio;
lw = love.window;
lk = love.keyboard;

function lerp(v0, v1, t, dt)
  return v0 + (v1 - v0) * t * dt;
end

function refloat(v, pointPlaces)
  return math.floor(v * math.pow(10, pointPlaces)) / math.pow(10, pointPlaces);
end

function clamp(n, low, high) return math.min(math.max(low, n), high) end

function split(stringArg, delimiter)
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find(stringArg, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub(stringArg, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find(stringArg, delimiter, from  )
	end
	table.insert( result, stringArg.sub(stringArg, from  ) )
	return result
end

function initialize2DArray(x, y)
	local arr = {};
	for a=1, x, 1 do
		arr[a] = {};
	end
	for a=1, x, 1 do
		for b=1, y, 1 do
			arr[a][b] = {};
		end
	end
	return arr;
end

function resizeImageByScale(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end