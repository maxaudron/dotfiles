return {
	"olimorris/codecompanion.nvim",
	version = false, -- Never set this value to "*"! Never!
	dependencies = {
		"nvim-lua/plenary.nvim",
		"franco-ruggeri/codecompanion-spinner.nvim",
		"ravitemer/codecompanion-history.nvim",
	},
	opts = {
		extensions = {
			spinner = {},
			history = {
				enabled = true,
				opts = {
					auto_save = true,
					expiration_days = 30,
					picker = "snacks",
					delete_on_clearing_chat = true,

					auto_generate_title = false,
					title_generation_opts = {
						adapter = "gemini",
						model = "gemini-2.5-flash",
					},
				},
			},
		},

		strategies = {
			chat = {
				adapter = "claude_code",
				tools = {
					["mcp"] = {
						callback = require("mcphub.extensions.codecompanion"),
						description = "Call tools and resources from the MCP Servers",
						opts = {
							user_approval = true,
						},
					},
					["cmd_runner"] = {
						callback = "strategies.chat.tools.catalog.cmd_runner",
						description = "Run shell commands initiated by the LLM",
						opts = {
							requires_approval = true,
						},
					},
				},
			},
			inline = {
				adapter = "anthropic",
				model = "claude-haiku-4.5",
			},
			cmd = {
				adapter = "anthropic",
				model = "claude-haiku-4.5",
			},
		},

		adapters = {
			acp = {
				opts = { show_defaults = false },
				-- gemini_cli = function()
				-- 	return require("codecompanion.adapters").extend("gemini_cli", {
				-- 		defaults = {
				-- 			auth_method = "vertex-ai",
				-- 		},
				-- 		env = {
				-- 			GOOGLE_CLOUD_PROJECT = "claranet-playground",
				-- 			GOOGLE_CLOUD_LOCATION = "europe-west1",
				-- 			GEMINI_API_KEY = "cmd:gcloud auth print-access-token",
				-- 		},
				-- 	})
				-- end,
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							ANTHROPIC_BASE_URL = "https://public.llm.de.clara.net/",
							ANTHROPIC_AUTH_TOKEN = "cmd:pass show work/litellm_claude",
							ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4.5",
							ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4.5",
							ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4.5",
							CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS = "1",
						},
					})
				end,
			},
			http = {
				opts = {
					show_defaults = false,
					show_model_choices = true,
				},
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						url = "https://llm.de.clara.net/v1/messages",
						env = {
							api_key = "cmd:pass show work/litellm_claude",
						},
						headers = {
							["anthropic-beta"] = "",
						},
						schema = {
							---@type CodeCompanion.Schema
							model = {
								default = "claude-haiku-4.5",
								choices = {
									["claude-haiku-4.5"] = {
										formatted_name = "Claude Haiku 4.5",
										opts = { can_reason = true, has_vision = true },
									},
									["claude-opus-4.5"] = {
										formatted_name = "Claude Opus 4.5",
										opts = { can_reason = true, has_vision = true },
									},
									["claude-sonnet-4.5"] = {
										formatted_name = "Claude Sonnet 4.5",
										opts = { can_reason = true, has_vision = true },
									},
								},
							},
						},
					})
				end,
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						name = "vertex_gemini",
						url = "https://llm.de.clara.net/v1/chat/completions",
						env = {
							api_key = "cmd:pass show work/litellm_gemini",
						},
						schema = {
							---@type CodeCompanion.Schema
							model = {
								default = "gemini-2.5-flash",
								choices = {
									["gemini-2.5-pro"] = {
										nice_name = "Gemini 2.5 Pro",
										opts = { can_reason = true, has_vision = true },
									},
									["gemini-2.5-flash"] = {
										nice_name = "Gemini 2.5 Flash",
										opts = { can_reason = true, has_vision = true },
									},
								},
							},
						},
					})
				end,
			},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat toggle<cr>", desc = "Toggle AI Chat" },
		{ "<leader>ae", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Assistant" },
		{ "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action Palette" },
		{ "<leader>ac", "<cmd>CodeCompanionChat Add<cr>", mode = { "n", "v" }, desc = "Add selected code to chat" },
	},
}
