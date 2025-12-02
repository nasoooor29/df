return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		local u = require("utils")
		mc.setup()

		-- Add or skip cursor above/below the main cursor.
		u.NXVset("<C-up>", function()
			mc.lineAddCursor(-1)
		end, "Add cursor above")
		u.NXVset("<c-down>", function()
			mc.lineAddCursor(1)
		end, "Add cursor below")
		u.NXVset("<leader><up>", function()
			mc.lineSkipCursor(-1)
		end, "Skip cursor above")
		u.NXVset("<leader><down>", function()
			mc.lineSkipCursor(1)
		end, "Skip cursor below")

		-- Add or skip adding a new cursor by matching word/selection
		u.NXVset("<leader>n", function()
			mc.matchAddCursor(1)
		end, "Add cursor to next match")
		u.NXVset("<leader>s", function()
			mc.matchSkipCursor(1)
		end, "Skip next match")
		u.NXVset("<leader>N", function()
			mc.matchAddCursor(-1)
		end, "Add cursor to previous match")
		u.NXVset("<leader>S", function()
			mc.matchSkipCursor(-1)
		end, "Skip previous match")

		-- Add and remove cursors with control + left click.
		u.NXVset("<c-leftmouse>", mc.handleMouse, "Add cursor with mouse")
		u.NXVset("<c-leftdrag>", mc.handleMouseDrag, "Add cursors with mouse drag")
		u.NXVset("<c-leftrelease>", mc.handleMouseRelease, "Finish adding cursors with mouse")

		-- Disable and enable cursors.
		u.NXVset("<c-q>", mc.toggleCursor, "Toggle multi-cursor")

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
