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
            model = "gemini-2.5-flash",
          },
        },
      },
		},

		strategies = {
			chat = {
				adapter = "gemini",
				model = "gemini-2.5-flash",
			},
			inline = {
				adapter = "gemini",
				model = "gemini-2.5-flash",
			},
			cmd = {
				adapter = "gemini",
				model = "gemini-2.5-flash",
			},
		},

		adapters = {
			acp = {
				opts = { show_defaults = false },
			},
			http = {
				opts = {
          show_defaults = false,
          show_model_choices = true,
        },
        gemini = "gemini",
				vertex = function()
					return require("codecompanion.adapters").extend("gemini", {
						name = "vertex",
						url = "https://${region}-aiplatform.googleapis.com/v1/projects/${project_id}/locations/${region}/endpoints/openapi/chat/completions",
						env = {
							region = "GCLOUD_REGION",
							project_id = "GCLOUD_PROJECT_ID",
							api_key = "VERTEX_API_KEY",
						},
						headers = {
							Authorization = "Bearer ${api_key}",
							["Content-Type"] = "application/json",
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
									["google/gemini-2.5-pro"] = {
										nice_name = "Gemini 2.5 Pro",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.5-flash"] = {
										nice_name = "Gemini 2.5 Flash",
										opts = { can_reason = true, has_vision = true },
									},
									["google/gemini-2.5-flash-preview-05-20"] = {
										nice_name = "Gemini 2.5 Flash Preview",
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
									["anthropic/claude-sonnet-4-5"] = {
										nice_name = "Claude Sonnet 4.5",
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
		{ "<leader>ae", "<cmd>CodeCompanion<cr>", mode={"n", "v"}, desc = "Inline Assistant" },
		{ "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode={"n", "v"}, desc = "Action Palette" },
	},
}
