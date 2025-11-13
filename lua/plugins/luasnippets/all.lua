local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Helper function to get comment string for current filetype
local function get_comment()
  return vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
end

-- Helper function to prefix lines with comment string
local function comment_lines(lines)
  return function()
    local comment = get_comment()
    local result = {}
    for _, line in ipairs(lines) do
      if line == "" then
        table.insert(result, comment)
      else
        table.insert(result, comment .. " " .. line)
      end
    end
    return result
  end
end

return {
  -- MIT License snippet - Permissive open source license allowing commercial use
  s(":MIT", {
    f(comment_lines({
      "MIT License",
      "",
      "Copyright (c) " .. os.date("%Y") .. " ",
    })),
    i(1, "Your Name"),
    f(comment_lines({
      "",
      "",
      "Permission is hereby granted, free of charge, to any person obtaining a copy",
      "of this software and associated documentation files (the \"Software\"), to deal",
      "in the Software without restriction, including without limitation the rights",
      "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell",
      "copies of the Software, and to permit persons to whom the Software is",
      "furnished to do so, subject to the following conditions:",
      "",
      "The above copyright notice and this permission notice shall be included in all",
      "copies or substantial portions of the Software.",
      "",
      "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR",
      "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,",
      "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE",
      "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER",
      "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,",
      "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE",
      "SOFTWARE.",
    })),
  }),

  -- Apache License 2.0 snippet - Permissive license with patent grant protection
  s(":APACHE2", {
    f(comment_lines({
      "Apache License",
      "Version 2.0, January 2004",
      "http://www.apache.org/licenses/",
      "",
      "Copyright " .. os.date("%Y") .. " ",
    })),
    i(1, "Your Name"),
    f(comment_lines({
      "",
      "",
      "Licensed under the Apache License, Version 2.0 (the \"License\");",
      "you may not use this file except in compliance with the License.",
      "You may obtain a copy of the License at",
      "",
      "    http://www.apache.org/licenses/LICENSE-2.0",
      "",
      "Unless required by applicable law or agreed to in writing, software",
      "distributed under the License is distributed on an \"AS IS\" BASIS,",
      "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.",
      "See the License for the specific language governing permissions and",
      "limitations under the License.",
    })),
  }),

  -- GPL v3 License snippet - Copyleft license requiring derivative works to use same license
  s(":GPL3", {
    f(function(args)
      local comment = get_comment()
      return comment .. " " .. args[1][1] .. " - " .. args[2][1]
    end, { 1, 2 }),
    i(1, "Program Name"),
    i(2, "Program Description"),
    f(function(args)
      local comment = get_comment()
      return {
        comment,
        comment .. " Copyright (C) " .. os.date("%Y") .. " " .. args[1][1],
      }
    end, { 3 }),
    i(3, "Your Name"),
    f(comment_lines({
      "",
      "",
      "This program is free software: you can redistribute it and/or modify",
      "it under the terms of the GNU General Public License as published by",
      "the Free Software Foundation, either version 3 of the License, or",
      "(at your option) any later version.",
      "",
      "This program is distributed in the hope that it will be useful,",
      "but WITHOUT ANY WARRANTY; without even the implied warranty of",
      "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the",
      "GNU General Public License for more details.",
      "",
      "You should have received a copy of the GNU General Public License",
      "along with this program. If not, see <https://www.gnu.org/licenses/>.",
    })),
  }),

  -- Unlicense snippet - Public domain dedication, no copyright restrictions
  s("unlicense", {
    f(comment_lines({
      "This is free and unencumbered software released into the public domain.",
      "",
      "Anyone is free to copy, modify, publish, use, compile, sell, or",
      "distribute this software, either in source code form or as a compiled",
      "binary, for any purpose, commercial or non-commercial, and by any",
      "means.",
      "",
      "In jurisdictions that recognize copyright laws, the author or authors",
      "of this software dedicate any and all copyright interest in the",
      "software to the public domain. We make this dedication for the benefit",
      "of the public at large and to the detriment of our heirs and",
      "successors. We intend this dedication to be an overt act of",
      "relinquishment in perpetuity of all present and future rights to this",
      "software under copyright law.",
      "",
      "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,",
      "EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF",
      "MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.",
      "IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR",
      "OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,",
      "ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR",
      "OTHER DEALINGS IN THE SOFTWARE.",
      "",
      "For more information, please refer to <https://unlicense.org>",
    })),
  }),
}
