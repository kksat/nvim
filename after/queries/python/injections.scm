; extends
(
((string_content) @injection.content)
(#match? @injection.content "---")
(#set! injection.language "yaml")
)
