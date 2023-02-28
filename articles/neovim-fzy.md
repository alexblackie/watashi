title: Finding files in Neovim with fzy
slug: neovim-fzy
publish_date: "2022-01-27"

coverUrl: /images/articles/neovim-fzy/nvim-fzy.png
coverAlt: "Neovim with a floating window showing fzy searching for the string 'win'."
coverWidth: 1920
coverHeight: 571

openGraphTitle: Finding files in Neovim with fzy
openGraphDescription: "Integrating the fuzzy file finder 'fzy' into Neovim with a little bit of Lua."
openGraphImageUrl: /images/articles/neovim-fzy/nvim-fzy.png
---
<p>
	<big>
		I'm a big fan of <a href="https://github.com/jhawthorn/fzy">fzy</a> for
		quickly finding things in a list. I used to use it as my fuzzy file
		finder in vim, but lost that functionality when I moved to neovim a
		while back. It's time to finally fix that.
	</big>
</p>

In vim, we're able to use the `system` function to run a command synchronously
and capture its output. Since neovim focuses on asynchronicity, this behaviour
is no longer supported. While this seemed like a blocker at the time, it turns
out to not be a significant problem.

With neovim, we can create a buffer, start an embedded terminal in it, and then
read the contents of that buffer when the terminal exits. Since fzy prints the
file you selected as its only output, we can easily use the neovim buffer API's
`nvim_buf_get_lines` to read the lines in the buffer.

The neovim support for Lua configuration has really provided a comfortable
platform for me to build upon. Part of the reason for my sharing this
integration was because of how pleased I was with the brevity and clarity of
the final solution.

Here is the entirety of what it takes:

```lua
function _G.FzyFiles(vim_command)
	local terminal_command = 'fd -t f -H | fzy'

	CreateFloatingWindow({ height = 10 })

	local opts = {
		on_exit = function()
			local filename = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), " ")
			vim.cmd('bdelete!')
			vim.fn.execute(vim_command .. ' ' .. filename)
		end
	}
	vim.fn.termopen(terminal_command, opts)
	vim.cmd('startinsert')
end
```

There's not much to it! The magic is really in the `on_exit` callback function,
where we use the neovim API `nvim_buf_get_lines` function to return the lines
of output from the terminal buffer, which will be the file path printed by
`fzy` when it terminates.

Then we delete the terminal buffer, and execute a `vim_command` (`:e`, `:vs`,
etc.) with the file path we got.

`CreateFloatingWindow` is a little helper function I have to make popping up a
floating window easier. It's a little dense but pretty simple (most of the
complexity is just calculating how to centre it):

```lua
function CreateFloatingWindow(overrides)
	-- Window maths lovingly stolen from:
	--   https://www.2n.pl/blog/how-to-make-ui-for-neovim-plugins-in-lua
	local width = vim.api.nvim_get_option('columns')
	local height = vim.api.nvim_get_option('lines')
	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)
	local col = math.ceil((width - win_width) / 2)
	local buf = vim.api.nvim_create_buf(false, true)

	local opts = {
		relative = 'editor',
		width = win_width,
		height = win_height,
		col = col,
		row = 2,
		border = 'rounded',
	}
	for k,v in pairs(overrides) do opts[k] = v end

	return vim.api.nvim_open_win(buf, true, opts)
end
```

Then, all we need to do is bind `v:lua.FzyFiles(':e')` to a key,
and we're done! We now have `fzy` integrated into neovim.
