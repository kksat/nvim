local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  -- Main function
  s("main", {
    t({ "func main() {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- Error handling
  s("iferr", {
    t({ "if err != nil {", "\t" }),
    i(0, "return err"),
    t({ "", "}" }),
  }),

  -- Error check with return
  s("errn", {
    t({ "if err != nil {", "\t" }),
    t("return "),
    i(1, "nil"),
    t(", err"),
    t({ "", "}" }),
    i(0),
  }),

  -- Error check with log.Fatal
  s("errf", {
    t({ "if err != nil {", "\t" }),
    t("log.Fatal(err)"),
    t({ "", "}" }),
    i(0),
  }),

  -- Function
  s("fn", fmt([[
func {}({}) {} {{
	{}
}}
]], {
    i(1, "funcName"),
    i(2, "params"),
    i(3, "returnType"),
    i(0, "// TODO"),
  })),

  -- Method
  s("meth", fmt([[
func ({} {}) {}({}) {} {{
	{}
}}
]], {
    i(1, "receiver"),
    i(2, "Type"),
    i(3, "methodName"),
    i(4, "params"),
    i(5, "returnType"),
    i(0, "// TODO"),
  })),

  -- For loop
  s("for", {
    t("for "),
    i(1, "i := 0; i < 10; i++"),
    t({ " {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- For range
  s("forr", {
    t("for "),
    i(1, "index, value"),
    t(" := range "),
    i(2, "collection"),
    t({ " {", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- Struct
  s("struct", fmt([[
type {} struct {{
	{}
}}
]], {
    i(1, "StructName"),
    i(0, "Field string"),
  })),

  -- Interface
  s("interface", fmt([[
type {} interface {{
	{}
}}
]], {
    i(1, "InterfaceName"),
    i(0, "Method()"),
  })),

  -- Switch statement
  s("switch", {
    t("switch "),
    i(1, "variable"),
    t({ " {", "case " }),
    i(2, "condition"),
    t({ ":", "\t" }),
    i(0),
    t({ "", "default:", "\t", "}" }),
  }),

  -- Test function
  s("test", fmt([[
func Test{}(t *testing.T) {{
	{}
}}
]], {
    i(1, "FunctionName"),
    i(0, "// TODO"),
  })),

  -- Table driven test
  s("tdt", fmt([[
func Test{}(t *testing.T) {{
	tests := []struct {{
		name string
		{}
		want {}
	}}{{
		{{
			name: "{}",
			{}: {},
			want: {},
		}},
	}}

	for _, tt := range tests {{
		t.Run(tt.name, func(t *testing.T) {{
			{}
		}})
	}}
}}
]], {
    i(1, "FunctionName"),
    i(2, "input string"),
    i(3, "string"),
    i(4, "test case 1"),
    rep(2),
    i(5, "value"),
    i(6, "expected"),
    i(0, "// test logic"),
  })),

  -- Benchmark
  s("bench", fmt([[
func Benchmark{}(b *testing.B) {{
	for i := 0; i < b.N; i++ {{
		{}
	}}
}}
]], {
    i(1, "FunctionName"),
    i(0, "// benchmark code"),
  })),

  -- HTTP handler
  s("handler", fmt([[
func {}(w http.ResponseWriter, r *http.Request) {{
	{}
}}
]], {
    i(1, "handlerName"),
    i(0, "// handler logic"),
  })),

  -- JSON marshal
  s("json", {
    t("data, err := json.Marshal("),
    i(1, "object"),
    t({ ")", "if err != nil {", "\treturn err", "}" }),
    i(0),
  }),

  -- JSON unmarshal
  s("jsonu", {
    t("var "),
    i(1, "result"),
    t(" "),
    i(2, "Type"),
    t({ "", "err := json.Unmarshal(" }),
    i(3, "data"),
    t(", &"),
    rep(1),
    t({ ")", "if err != nil {", "\treturn err", "}" }),
    i(0),
  }),

  -- Goroutine
  s("go", {
    t("go func() {"),
    t({ "", "\t" }),
    i(0),
    t({ "", "}()" }),
  }),

  -- Select
  s("select", {
    t({ "select {", "case " }),
    i(1, "v := <-ch"),
    t({ ":", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- Context with cancel
  s("ctx", {
    t("ctx, cancel := context.WithCancel("),
    i(1, "context.Background()"),
    t({ ")", "defer cancel()" }),
    i(0),
  }),

  -- Context with timeout
  s("ctxt", {
    t("ctx, cancel := context.WithTimeout("),
    i(1, "context.Background()"),
    t(", "),
    i(2, "5*time.Second"),
    t({ ")", "defer cancel()" }),
    i(0),
  }),
}
