
local init = {}

-- update the package path so strict and msr.Io can be loaded.
init.path = ";./lib/?.lua;./lib/?/init.lua;./?.l2;./?/init.l2;./lib/?.l2;./lib/?/init.l2"
package.path = package.path .. init.path
init.strict = require("strict")
init.io = require("msr.Io")

-- global write and writeln
write = init.io.write
writeln = init.io.writeln

return init
