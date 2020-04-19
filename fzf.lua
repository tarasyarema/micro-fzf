VERSION = "1.0.0"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")

function fzf(bp, opt)
	local output, err = shell.RunInteractiveShell("fzf", false, true)
	if err ~= nil then
	    micro.InfoBar():Error(err)
	else
	    fzfOpen(output, bp, opt)
	end
end

function fzf_find(bp, args, opt)
	local strings = import("strings")
	local cmd = "grep --line-buffered -rnwi "

	local pattern = ""

	for i = 1, #args do
		pattern = args[i] .. " "
	end

	cmd = cmd .. pattern .. " * | fzf"
	
	local output, err = shell.RunInteractiveShell(cmd, false, true)
	-- local run, err = shell.RunBackgroundShell(cmd)
	-- local output = run()
	
	if err ~= nil then
	    micro.InfoBar():Error("could not execute fzf command: ", err)
	    return
   	end

	-- output = strings.Split(output, "\n")
	-- micro:TermMessage("\nOutput\n", output)
	
	local input = strings.Split(output, ":")

	if #input < 2 then
	    micro.InfoBar():Error("bad input format: ", input)
	    return
   	end
   	
	fzfOpenLine(input[1], bp, 2, input[2])
	micro.InfoBar():Message(input[1] .. " @ " .. input[2])
end

function fzfOpen(output, bp, opt)
    local strings = import("strings") 
    local strconv = import("strconv") 
    file = strings.TrimSpace(output)

	if file ~= "" then
		local buf, err = buffer.NewBufferFromFile(file)

		if err ~= nil then
			micro.InfoBar():Error(err)
		end

		if opt == 0 then
			bp:OpenBuffer(buf)
		elseif opt == 1 then
			bp:HSplitBuf(buf)
		elseif opt == 2 then
			bp:VSplitBuf(buf)
		end
	end
end

function fzfOpenLine(output, bp, opt, line)
    local strings = import("strings") 
    local strconv = import("strconv") 
    file = strings.TrimSpace(output)

	if file ~= "" then
		local buf, err = buffer.NewBufferFromFile(file)

		if err ~= nil then
			micro.InfoBar():Error(err)
		end

		local new_bp

		if opt == 0 then
			new_bp = bp:OpenBuffer(buf)
		elseif opt == 1 then
			new_bp = bp:HSplitBuf(buf)
		elseif opt == 2 then
			new_bp =bp:VSplitBuf(buf)
		end

		new_bp.Cursor.Y = tonumber(line)-1
		new_bp.Cursor:Relocate()
	end
end

function init()
    config.MakeCommand("f", function(bp, args)
		fzf(bp, 0)
    end, config.NoComplete)

    config.MakeCommand("fh", function(bp, args)
		fzf(bp, 1)
    end, config.NoComplete)

    config.MakeCommand("fv", function(bp, args)
		fzf(bp, 2)
    end, config.NoComplete)

    config.MakeCommand("ff", function(bp, args)
		fzf_find(bp, args, 2)
    end, config.NoComplete)

    config.AddRuntimeFile("fzf", config.RTHelp, "help/fzf.md")
end
