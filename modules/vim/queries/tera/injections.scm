; extends

; catppuccin/whiskers-specific
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.toml")
  (content) @injection.content
  (#set! injection.language "toml")
  (#set! injection.combined)
)
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.yaml")
  (content) @injection.content
  (#set! injection.language "yaml")
  (#set! injection.combined)
)
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.json")
  (content) @injection.content
  (#set! injection.language "json")
  (#set! injection.combined)
)
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.html")
  (content) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
)
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.css")
  (content) @injection.content
  (#set! injection.language "css")
  (#set! injection.combined)
)
(
  (frontmatter) @fm
    (#match? @fm "filename:\\s*.+\\.qss")
  (content) @injection.content
  (#set! injection.language "css")
  (#set! injection.combined)
)
