--[[
This file is part of updater-ng. Don't edit it.
]]

local uci_cursor = nil
if uci then
	uci_cursor = uci.cursor()
else
	ERROR("UCI library is not available. Configuration not used.")
end
local function uci_cnf(name, default)
	if uci_cursor then
		return uci_cursor:get("updater", "turris", name) or default
	else
		return default
	end
end

-- Configuration variables
local mode = uci_cnf("mode", "branch") -- should we follow branch or version?
local branch = uci_cnf("branch", "hbs") -- which branch to follow
local version = uci_cnf("version", nil) -- which version to follow
local lists = uci_cnf("lists", {}) -- what additional lists should we use

-- Verify that we have sensible configuration
if type(lists) == "string" then -- if there is single list then uci returns just a string
	lists = {lists}
end
if mode == "version" and not version then
	WARN("Mode configured to be 'version' but no version provided. Changing mode to 'branch' instead.")
	mode = "branch"
end

-- Common URL base to Turris OS updater-ng scripts
local base_url
if mode == "branch" then
	base_url = "https://repo.turris.cz/" .. branch .. "/lists/"
elseif mode == "version" then
	base_url = "https://repo.turris.cz/archive/" .. version .. "/lists/"
end
-- Common connection settings for Turris OS scripts
local script_options = {
	security = "Remote",
	ca = system_cas,
	crl = no_crl,
	pubkey = {
		"file:///etc/updater/keys/release.pub",
		"file:///etc/updater/keys/standby.pub",
		"file:///etc/updater/keys/test.pub" -- It is normal for this one to not be present in production systems
	}
}

-- The distribution base script. It contains the repository and bunch of basic packages
Script("base",  base_url .. "base.lua", script_options)

-- Additional enabled distribution lists
local exec_list = {} -- We want to run userlist only once even if it's defined multiple times
for _, l in ipairs(lists) do
	if exec_list[l] then
		WARN("Turris package list '" .. l .. "' specified multiple times")
	else
		Script("pkglist-" .. l, base_url .. l .. ".lua", script_options)
		exec_list[l] = true
	end
end
