return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		local key = require("utils").new("MultiCursor")
		mc.setup()

		-- Add or skip cursor above/below the main cursor.
		key.NXVset("<C-up>", function()
			mc.lineAddCursor(-1)
		end)
		key.NXVset("<c-down>", function()
			mc.lineAddCursor(1)
		end, "Add cursor below")
		key.NXVset("<leader><up>", function()
			mc.lineSkipCursor(-1)
		end, "Skip cursor above")
		key.NXVset("<leader><down>", function()
			mc.lineSkipCursor(1)
		end, "Skip cursor below")

		-- Add or skip adding a new cursor by matching word/selection
		key.NXVset("<leader>n", function()
			mc.matchAddCursor(1)
		end, "Add cursor to next match")
		key.NXVset("<leader>s", function()
			mc.matchSkipCursor(1)
		end, "Skip next match")
		key.NXVset("<leader>N", function()
			mc.matchAddCursor(-1)
		end, "Add cursor to previous match")
		key.NXVset("<leader>S", function()
			mc.matchSkipCursor(-1)
		end, "Skip previous match")

		-- Add and remove cursors with control + left click.
		key.NXVset("<c-leftmouse>", mc.handleMouse)
		key.NXVset("<c-leftdrag>", mc.handleMouseDrag)
		key.NXVset("<c-leftrelease>", mc.handleMouseRelease)
		key.NXset("<leader>A", mc.matchAllAddCursors)
		key.NXVset("<c-q>", mc.toggleCursor)
		-- Disable and enable cursors.

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor)
			layerSet({
				"n",
				"x",
			}, "<right>", mc.nextCursor)

			-- Delete the main cursor.
			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
