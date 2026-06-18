-- require("git-link.config").get_rules()
--
local format_url = function(base_url, params)
	if params.permalink then
		return string.format("%s/tree/%s?id=%s#n%d", base_url, params.file_path, params.branch, params.start_line)
	else
		return string.format("%s/tree/%s?h=%s#n%d", base_url, params.file_path, params.branch, params.start_line)
	end
end

return {
	"juacker/git-link.nvim",
	opts = {
		url_rules = {
			{
				pattern = "^audron@audron.dev:(.+)$",
				replace = "https://git.audron.dev/%1.git",
				format_url = format_url,
			},
			{
				pattern = "^git@vapor.systems:(.+)$",
				replace = "https://git.vapor.systems/%1.git",
				format_url = format_url,
			},
		},
	},
	keys = {
		{
			"<leader>gl",
			function()
				require("git-link.main").copy_line_url()
			end,
			desc = "Copy code link to clipboard",
			mode = { "n", "x" },
		},
		{
			"<leader>gL",
			function()
				require("git-link.main").copy_permalink()
			end,
			desc = "Copy code permalink to clipboard",
			mode = { "n", "x" },
		},
	},
}
