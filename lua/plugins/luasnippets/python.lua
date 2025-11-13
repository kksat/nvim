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
  -- Main function
  s("main", {
    t({ 'if __name__ == "__main__":', "\t" }),
    i(0, "pass"),
  }),

  -- Function
  s("def", fmt([[
def {}({}):
	"""{}"""
	{}
]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "Function description"),
    i(0, "pass"),
  })),

  -- Class
  s("class", fmt([[
class {}:
	"""{}"""

	def __init__(self{}):
		{}
]], {
    i(1, "ClassName"),
    i(2, "Class description"),
    i(3, ", args"),
    i(0, "pass"),
  })),

  -- Dataclass
  s("dataclass", fmt([[
@dataclass
class {}:
	"""{}"""
	{}: {}
]], {
    i(1, "ClassName"),
    i(2, "Class description"),
    i(3, "field_name"),
    i(0, "str"),
  })),

  -- Try except
  s("try", {
    t({ "try:", "\t" }),
    i(1, "pass"),
    t({ "", "except " }),
    i(2, "Exception"),
    t({ " as e:", "\t" }),
    i(0, "pass"),
  }),

  -- Try except else finally
  s("tryf", {
    t({ "try:", "\t" }),
    i(1, "pass"),
    t({ "", "except " }),
    i(2, "Exception"),
    t({ " as e:", "\t" }),
    i(3, "pass"),
    t({ "", "else:", "\t" }),
    i(4, "pass"),
    t({ "", "finally:", "\t" }),
    i(0, "pass"),
  }),

  -- For loop
  s("for", {
    t("for "),
    i(1, "item"),
    t(" in "),
    i(2, "iterable"),
    t({ ":", "\t" }),
    i(0, "pass"),
  }),

  -- Enumerate
  s("fore", {
    t("for "),
    i(1, "index, item"),
    t(" in enumerate("),
    i(2, "iterable"),
    t({ "):", "\t" }),
    i(0, "pass"),
  }),

  -- List comprehension
  s("lc", {
    t("["),
    i(1, "expr"),
    t(" for "),
    i(2, "item"),
    t(" in "),
    i(3, "iterable"),
    t("]"),
    i(0),
  }),

  -- Dict comprehension
  s("dc", {
    t("{"),
    i(1, "key"),
    t(": "),
    i(2, "value"),
    t(" for "),
    i(3, "item"),
    t(" in "),
    i(4, "iterable"),
    t("}"),
    i(0),
  }),

  -- Lambda
  s("lambda", {
    t("lambda "),
    i(1, "x"),
    t(": "),
    i(0, "x"),
  }),

  -- Property
  s("prop", fmt([[
@property
def {}(self) -> {}:
	"""{}"""
	return self._{}
]], {
    i(1, "property_name"),
    i(2, "type"),
    i(3, "Property description"),
    rep(1),
  })),

  -- Setter
  s("setter", fmt([[
@{}.setter
def {}(self, value: {}):
	"""{}"""
	self._{} = value
]], {
    i(1, "property_name"),
    rep(1),
    i(2, "type"),
    i(3, "Setter description"),
    rep(1),
  })),

  -- Context manager
  s("with", {
    t("with "),
    i(1, "expr"),
    t(" as "),
    i(2, "var"),
    t({ ":", "\t" }),
    i(0, "pass"),
  }),

  -- Pytest test function
  s("test", fmt([[
def test_{}():
	"""{}"""
	{}
]], {
    i(1, "function_name"),
    i(2, "Test description"),
    i(0, "assert True"),
  })),

  -- Pytest fixture
  s("fixture", fmt([[
@pytest.fixture
def {}():
	"""{}"""
	{}
	yield {}
	{}
]], {
    i(1, "fixture_name"),
    i(2, "Fixture description"),
    i(3, "# Setup"),
    i(4, "value"),
    i(0, "# Teardown"),
  })),

  -- Pytest parametrize
  s("parametrize", fmt([[
@pytest.mark.parametrize("{}, {}", [
	({}, {}),
])
def test_{}({}, {}):
	"""{}"""
	{}
]], {
    i(1, "input"),
    i(2, "expected"),
    i(3, "input_value"),
    i(4, "expected_value"),
    i(5, "function_name"),
    rep(1),
    rep(2),
    i(6, "Test description"),
    i(0, "assert input == expected"),
  })),

  -- Type hints function
  s("deft", fmt([[
def {}({}) -> {}:
	"""{}"""
	{}
]], {
    i(1, "function_name"),
    i(2, "arg: str"),
    i(3, "None"),
    i(4, "Function description"),
    i(0, "pass"),
  })),

  -- Async function
  s("async", fmt([[
async def {}({}):
	"""{}"""
	{}
]], {
    i(1, "function_name"),
    i(2, "args"),
    i(3, "Async function description"),
    i(0, "pass"),
  })),

  -- FastAPI route
  s("route", fmt([[
@app.{}("{}")
async def {}({}):
	"""{}"""
	{}
]], {
    c(1, { t("get"), t("post"), t("put"), t("delete"), t("patch") }),
    i(2, "/endpoint"),
    i(3, "endpoint_name"),
    i(4, ""),
    i(5, "Endpoint description"),
    i(0, "return {}"),
  })),

  -- Pydantic model
  s("pydantic", fmt([[
class {}(BaseModel):
	"""{}"""
	{}: {}
]], {
    i(1, "ModelName"),
    i(2, "Model description"),
    i(3, "field_name"),
    i(0, "str"),
  })),

  -- Logger setup
  s("logger", {
    t("import logging"),
    t({ "", "", 'logger = logging.getLogger(__name__)' }),
    i(0),
  }),

  -- Docstring
  s("doc", fmt([[
"""
{}

Args:
	{}: {}

Returns:
	{}: {}

Raises:
	{}: {}
"""
]], {
    i(1, "Function description"),
    i(2, "param"),
    i(3, "Parameter description"),
    i(4, "return_type"),
    i(5, "Return description"),
    i(6, "ExceptionType"),
    i(0, "Exception description"),
  })),

  -- If name main with argparse
  s("argparse", {
    t({ "import argparse", "", "", 'if __name__ == "__main__":', "\tparser = argparse.ArgumentParser(description=" }),
    i(1, '"Description"'),
    t({ ")", "\tparser.add_argument(" }),
    i(2, '"arg"'),
    t({ ", help=" }),
    i(3, '"Help text"'),
    t({ ")", "\targs = parser.parse_args()", "\t" }),
    i(0),
  }),

  -- Enum
  s("enum", fmt([[
class {}(Enum):
	"""{}"""
	{} = {}
]], {
    i(1, "EnumName"),
    i(2, "Enum description"),
    i(3, "VALUE"),
    i(0, '"value"'),
  })),

  -- Type alias
  s("typealias", {
    t("type "),
    i(1, "AliasName"),
    t(" = "),
    i(0, "type"),
  }),
}
