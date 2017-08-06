#!/bin/lua
local candran = require("candran")
local cmdline = require("cmdline")

if #arg < 1 then
	print("Candran compiler version "..candran.VERSION.." by Reuh")
	print("Usage: "..arg[0].." [target=<target>] [dest=<destination directory>] [-print] [preprocessor arguments] filename...")
	return
end

local args = cmdline(arg)

for _, file in ipairs(args) do
	local dest = file:gsub("%.can$", "")..".lua"
	if args.dest then
		dest = args.dest .. "/" .. dest
	end

	if not args.print then
		print("Compiling "..file.." in "..dest)
	end

	local inputFile, err = io.open(file, "r")
	if not inputFile then error("Error while opening input file: "..err) end
	local input = inputFile:read("*a")
	inputFile:close()

	local out = candran.make(input, args)

	if args.print then
		print(out)
	else
		local outFile = io.open(dest, "w")
		if not outFile then
			os.execute("mkdir -p "..dest:gsub("[^/]+%.lua$", ""))
			outFile, err = io.open(dest, "w")
			if not outFile then
				error("Error while writing output file: "..err)
			end
		end
		outFile:write(out)
		outFile:close()
	end
end
