VERSION = "1.0.0"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")

function fzf(bp, opt)
    if shell.TermEmuSupported then
        local err = shell.RunTermEmulator(bp, "fzf", false, true, fzfOpen, bp, opt)
        if err ~= nil then
            micro.InfoBar():Error(err)
        end
    else
        local output, err = shell.RunInteractiveShell("fzf", false, true)
        if err ~= nil then
            micro.InfoBar():Error(err)
        else
            fzfOpen(output, bp, opt)
        end
    end
end

function fzfOpen(output, bp, opt)
    local strings = import("strings") 
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
    
    config.AddRuntimeFile("fzf", config.RTHelp, "help/fzf.md")
end
