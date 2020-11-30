-- msr.Io
-- Routines that I commonly use that may be slightly different than what the system provides.
-- By: M. Scott Reynolds
-- Date: 2020.11.07

local date = os.date
local io_orig = io

local Io = {}

-- print and write are almost identical except print will include top values of nested tables.
local function print(...)
	for _, v in ipairs{...} do
		-- if a table was passed, print out the top level values.
		if type(v) == "table" then
			io_orig.write("{")
			for i, j in pairs(v) do
				if type(i) == "string" then
					io_orig.write("\"", i, "\"=")
				else
					io_orig.write(tostring(i), "=")
				end
				if type(j) == "string" then
					io_orig.write("\"", j, "\", ")
				else
					io_orig.write(tostring(j), ", ")
				end
			end
			io_orig.write("}")
		else
			io_orig.write(tostring(v))
		end
	end
end

-- print followed by a new line.
local function println(...)
	print(...)
	print("\n")
end

-- debug: print date followed by parameters.
local function debug(...)
	print(date(), ": ", ...)
	print("\n")
end

-- write: print out parameters, but do not print a tab between 
-- like print does.
local function write(...)
	for _, v in ipairs{...} do
		io_orig.write(tostring(v))
	end
end

-- writeln: write paramters followed by newline.
local function writeln(...)
	write(...)
	write("\n")
end

-- dumppad: write out level number of pad characters.
Io.pad_character = "    "
local function dumppad(level)
	write(string.rep(Io.pad_character, level))
end

-- dumpv: dump the specified v at level.
local function dumpv(v, level)
	level = level or 0
	dumppad(level)
	if type(v) == "string" then
		writeln("\"", v, "\"")
	else
		writeln(v)
	end
end

-- dumpkv: dump the specified k, v pairs at level.
local function dumpkv(k, v, level)
	level = level or 0
	dumppad(level)
	if type(v) == "string" then
		writeln(k, " = \"", v, "\"", ",")
	else
		writeln(k, " = ", v, ",")
	end
end

--dumptable: dump table with key k up to maxlevels deep.  prevtables = tables already encountered,
-- to prevent endless recursion.
Io.max_levels = 10
local function dumptable(maxlevel, k, v, prevtables, level)
	level = level or 0
	dumppad(level)
	writeln(k, " = {")
	--writeln("{")
	for i, j in pairs(v) do
		-- recursive table?
		if prevtables[j] ~= true then
			if type(j) == "table" then
				if level < maxlevel then
					prevtables[j] = true
					dumptable(maxlevel, i, j, prevtables, level+1)
				else
					dumpkv(i, j, level+1)
				end
			else
				dumpkv(i, j, level+1)
			end
		else
			dumpkv(i, j, level+1)
		end
	end
	dumppad(level)
	writeln("},")
end

-- dump out parameters with specified maximum nested level. 0 will print out
-- the top level only.
local function dump(maxlevel, ...)
	local level = 0
	for k, v in pairs{...} do
		if  maxlevel > 0 and type(v) == "table" then
			dumptable(maxlevel, k, v, {v}, level)
		else
			dumpv(v, level)
		end
	end
end

-- exported functions.
Io.print = print
Io.println = println
Io.debug = debug
Io.write = write
Io.writeln = writeln
Io.dump = dump

--print("msr.Io:\n")
--dump(1, ...)

--package.loaded["msrlib"] = msrlib
return Io
