# Micro `fzf`

## Requirements

1. You should have `fzf` installed and added to your `PATH` variable.
2. If you want to use `ff` you need `grep`. If you are on a Unix machine you will probably have this by default. 
	If you are on a Windows machine you can iunstall it using `scoop install grep`.

## Usage

### `> f`  

Runs `fzf` and then opens the selected file in the current tab, i.e. it closes the last current.

### `> fv` 

Runs `fzf` and then opens the selected file in a `v`ertical split in the current tab.

### `> fh` 

Runs `fzf` and then opens the selected file in a `h`orizontal split in the current tab.

### `> ff {pattern}`  

Runs

```bash
grep --line-buffered -rnwi {pattern} * | fzf
``` 

and then opens the selected file in a new vertical split in the selected line.


## Keybindings

> None by default.

I personally changed the open (`CtrlO`) to `f`, and mapped `CtrlShift-v` and `CtrlShift-h` to `fv` and `fh`, respect.
