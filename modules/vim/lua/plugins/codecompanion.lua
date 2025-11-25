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

					auto_generate_title = true,
					title_generation_opts = {
						adapter = "gemini",
						model = "google/gemini-2.5-flash-lite",
					},
				},
			},
		},

		strategies = {
			chat = {
				adapter = "gemini",
        model = "google/gemini-2.5-pro",
				tools = {
					["mcp"] = {
						callback = require("mcphub.extensions.codecompanion"),
						description = "Call tools and resources from the MCP Servers",
						opts = {
							user_approval = true,
						},
					},
				},
			},
			inline = {
				adapter = "claude_code",
			},
			cmd = {
				adapter = "claude_code",
			},
		},

		adapters = {
			acp = {
				opts = { show_defaults = false },
				gemini_cli = function()
					return require("codecompanion.adapters").extend("gemini_cli", {
						defaults = {
							auth_method = "vertex-ai",
						},
						env = {
							GOOGLE_CLOUD_PROJECT = "claranet-playground",
							GOOGLE_CLOUD_LOCATION = "europe-west1",
							GEMINI_API_KEY = "cmd:gcloud auth print-access-token",
						},
					})
				end,
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							ANTHROPIC_VERTEX_PROJECT_ID = "claranet-playground",
							ANTHROPIC_MODEL = "claude-sonnet-4-5@20250929",
							ANTHROPIC_SMALL_FAST_MODEL = "claude-haiku-4-5@20251001",
							CLOUD_ML_REGION = "europe-west1",
							CLAUDE_CODE_USE_VERTEX = "1",
						},
					})
				end,
			},
			http = {
				opts = {
					show_defaults = false,
					show_model_choices = true,
				},
				-- ["anthropic/claude-sonnet-4-5"] = {
				-- 	nice_name = "Claude Sonnet 4.5",
				-- 	opts = { can_reason = true, has_vision = true },
				-- },
				-- vertex_anthropic = function()
				-- 	return require("codecompanion.adapters").extend("gemini", {
				-- 		name = "vertex_gemini",
				-- 		url = "https://${region}-aiplatform.googleapis.com/v1/projects/${project_id}/locations/${region}/publishers/anthropic/models",
				-- 		env = {
				-- 			region = "europe-west1",
				-- 			project_id = "claranet-playground",
				-- 			api_key = "cmd:gcloud auth print-access-token",
				-- 		},
				--       })
				--     end,
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						name = "vertex_gemini",
						url = "https://${region}-aiplatform.googleapis.com/v1/projects/${project_id}/locations/${region}/endpoints/openapi/chat/completions",
						env = {
							region = "europe-west1",
							project_id = "claranet-playground",
							api_key = "cmd:gcloud auth print-access-token",
						},
						schema = {
							---@type CodeCompanion.Schema
							model = {
								order = 1,
								mapping = "parameters",
								type = "enum",
								desc = "The model that will complete your prompt. See https://ai.google.dev/gemini-api/docs/models/gemini#model-variations for additional details and options.",
								default = "google/gemini-2.5-flash",
								choices = {
									["google/gemini-3-pro-preview"] = {
										nice_name = "Gemini 3 Pro Preview",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.5-pro"] = {
										nice_name = "Gemini 2.5 Pro",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.5-flash"] = {
										nice_name = "Gemini 2.5 Flash",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.5-flash-lite"] = {
										nice_name = "Gemini 2.5 Flash Lite",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.0-flash"] = {
										nice_name = "Gemini 2.0 Flash",
										opts = { has_vision = true },
									},
									["googl/gemini-2.0-flash-lite"] = {
										nice_name = "Gemini 2.0 Flash Lite",
										opts = { has_vision = true },
									},
									["google/gemini-1.5-pro"] = {
										nice_name = "Gemini 1.5 Pro",
										opts = { has_vision = true },
									},
									["google/gemini-1.5-flash"] = {
										nice_name = "Gemini 1.5 Flash",
										opts = { has_vision = true },
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
