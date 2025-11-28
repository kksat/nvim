local function run_job_async(buf, command)
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
  })
end

local function create_scratch_buffer()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_set_current_buf(buf)
  return buf
end


vim.keymap.set("n", "<localleader>r", function()
  vim.cmd("w")
  local buf = create_scratch_buffer()
  local command = { "go", "run", vim.fn.expand("%") }
  run_job_async(buf, command)
end, { buffer = true, desc = "go run %" })

vim.keymap.set("n", "<localleader>t", function()
  vim.cmd("w")
  local buf = create_scratch_buffer()
  local command = { "go", "test", vim.fn.expand("%") }
  run_job_async(buf, command)
end, { buffer = true, desc = "go test %" })

vim.keymap.set("n", "<localleader>f", function()
  vim.cmd("w")
  local buf = create_scratch_buffer()
  local command = { "go", "fmt", vim.fn.expand("%") }
  run_job_async(buf, command)
end, { buffer = true, desc = "go fmt %" })
