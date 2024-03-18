; extends
(
((string_content) @injection.content)
(#match? @injection.content "---")
(#set! injection.language "yaml")
)
(
((string_content) @injection.content)
(#match? @injection.content "#!ansible-playbook")
(#set! injection.language "yaml")
)
