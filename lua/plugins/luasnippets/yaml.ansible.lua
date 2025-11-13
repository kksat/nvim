local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  -- Playbook
  s("playbook", fmt([[
---
- name: {}
  hosts: {}
  become: {}
  vars:
    {}
  tasks:
    {}
]], {
    i(1, "Playbook name"),
    i(2, "all"),
    c(3, { t("true"), t("false") }),
    i(4, "var: value"),
    i(0, "- name: Task name"),
  })),

  -- Task
  s("task", fmt([[
- name: {}
  {}:
    {}
]], {
    i(1, "Task name"),
    i(2, "module"),
    i(0, "param: value"),
  })),

  -- Block
  s("block", fmt([[
- name: {}
  block:
    {}
  rescue:
    {}
  always:
    {}
]], {
    i(1, "Block name"),
    i(2, "- name: Task in block"),
    i(3, "- name: Task in rescue"),
    i(0, "- name: Task in always"),
  })),

  -- Handler
  s("handler", fmt([[
---
- name: {}
  {}:
    {}
  listen: "{}"
]], {
    i(1, "Handler name"),
    i(2, "module"),
    i(3, "param: value"),
    i(0, "handler topic"),
  })),

  -- Role
  s("role", fmt([[
---
- name: {}
  hosts: {}
  roles:
    - role: {}
      vars:
        {}
]], {
    i(1, "Role playbook"),
    i(2, "all"),
    i(3, "role_name"),
    i(0, "var: value"),
  })),

  -- When condition
  s("when", {
    t("when: "),
    i(0, "condition"),
  }),

  -- Loop
  s("loop", {
    t({ "loop:", "  - " }),
    i(0, "item"),
  }),

  -- Register
  s("register", {
    t("register: "),
    i(0, "result"),
  }),

  -- Debug task
  s("debug", fmt([[
- name: {}
  debug:
    {}
]], {
    i(1, "Debug output"),
    c(2, {
      fmt('msg: "{}"', { i(1, "message") }),
      fmt("var: {}", { i(1, "variable") }),
    }),
  })),

  -- Copy module
  s("copy", fmt([[
- name: {}
  ansible.builtin.copy:
    src: {}
    dest: {}
    owner: {}
    group: {}
    mode: '{}'
]], {
    i(1, "Copy file"),
    i(2, "source/path"),
    i(3, "dest/path"),
    i(4, "root"),
    i(5, "root"),
    i(0, "0644"),
  })),

  -- Template module
  s("template", fmt([[
- name: {}
  ansible.builtin.template:
    src: {}
    dest: {}
    owner: {}
    group: {}
    mode: '{}'
]], {
    i(1, "Template file"),
    i(2, "template.j2"),
    i(3, "dest/path"),
    i(4, "root"),
    i(5, "root"),
    i(0, "0644"),
  })),

  -- File module
  s("file", fmt([[
- name: {}
  ansible.builtin.file:
    path: {}
    state: {}
    owner: {}
    group: {}
    mode: '{}'
]], {
    i(1, "Manage file/directory"),
    i(2, "/path/to/file"),
    c(3, { t("file"), t("directory"), t("absent"), t("link") }),
    i(4, "root"),
    i(5, "root"),
    i(0, "0755"),
  })),

  -- Package module
  s("package", fmt([[
- name: {}
  ansible.builtin.package:
    name: {}
    state: {}
]], {
    i(1, "Install package"),
    i(2, "package_name"),
    c(0, { t("present"), t("latest"), t("absent") }),
  })),

  -- Service module
  s("service", fmt([[
- name: {}
  ansible.builtin.service:
    name: {}
    state: {}
    enabled: {}
]], {
    i(1, "Manage service"),
    i(2, "service_name"),
    c(3, { t("started"), t("stopped"), t("restarted"), t("reloaded") }),
    c(0, { t("true"), t("false") }),
  })),

  -- Systemd module
  s("systemd", fmt([[
- name: {}
  ansible.builtin.systemd:
    name: {}
    state: {}
    enabled: {}
    daemon_reload: {}
]], {
    i(1, "Manage systemd service"),
    i(2, "service_name"),
    c(3, { t("started"), t("stopped"), t("restarted"), t("reloaded") }),
    c(4, { t("true"), t("false") }),
    c(0, { t("true"), t("false") }),
  })),

  -- Command module
  s("command", fmt([[
- name: {}
  ansible.builtin.command: {}
  args:
    chdir: {}
]], {
    i(1, "Run command"),
    i(2, "command to run"),
    i(0, "/path"),
  })),

  -- Shell module
  s("shell", fmt([[
- name: {}
  ansible.builtin.shell: |
    {}
  args:
    chdir: {}
]], {
    i(1, "Run shell command"),
    i(2, "shell commands"),
    i(0, "/path"),
  })),

  -- Lineinfile module
  s("lineinfile", fmt([[
- name: {}
  ansible.builtin.lineinfile:
    path: {}
    line: '{}'
    state: {}
]], {
    i(1, "Manage line in file"),
    i(2, "/path/to/file"),
    i(3, "line content"),
    c(0, { t("present"), t("absent") }),
  })),

  -- Blockinfile module
  s("blockinfile", fmt([[
- name: {}
  ansible.builtin.blockinfile:
    path: {}
    block: |
      {}
    marker: "# {{{{ mark }}}} ANSIBLE MANAGED BLOCK"
]], {
    i(1, "Manage block in file"),
    i(2, "/path/to/file"),
    i(0, "block content"),
  })),

  -- Stat module
  s("stat", fmt([[
- name: {}
  ansible.builtin.stat:
    path: {}
  register: {}
]], {
    i(1, "Check file stats"),
    i(2, "/path/to/file"),
    i(0, "stat_result"),
  })),

  -- Assert module
  s("assert", fmt([[
- name: {}
  ansible.builtin.assert:
    that:
      - {}
    fail_msg: "{}"
    success_msg: "{}"
]], {
    i(1, "Assert condition"),
    i(2, "condition"),
    i(3, "Failure message"),
    i(0, "Success message"),
  })),

  -- Wait_for module
  s("wait_for", fmt([[
- name: {}
  ansible.builtin.wait_for:
    {}
    timeout: {}
]], {
    i(1, "Wait for condition"),
    c(2, {
      fmt('port: {}', { i(1, "80") }),
      fmt('path: {}', { i(1, "/path/to/file") }),
    }),
    i(0, "300"),
  })),

  -- Set_fact module
  s("set_fact", fmt([[
- name: {}
  ansible.builtin.set_fact:
    {}: {}
]], {
    i(1, "Set fact"),
    i(2, "fact_name"),
    i(0, "value"),
  })),

  -- Include_tasks
  s("include_tasks", fmt([[
- name: {}
  include_tasks: {}
  vars:
    {}
]], {
    i(1, "Include tasks"),
    i(2, "tasks.yml"),
    i(0, "var: value"),
  })),

  -- Include_role
  s("include_role", fmt([[
- name: {}
  ansible.builtin.include_role:
    name: {}
  vars:
    {}
]], {
    i(1, "Include role"),
    i(2, "role_name"),
    i(0, "var: value"),
  })),

}
