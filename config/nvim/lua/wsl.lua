-- wsl on windows auto detection for clipboard
local function get_distro_name()
	local handle = io.popen("echo $WSL_DISTRO_NAME")
	if handle == nil then
		return
	end
	local hostname = handle:read("*a")
	handle:close()
	return hostname:match("^%s*(.-)%s*$")
end

if get_distro_name() ~= "" then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end
