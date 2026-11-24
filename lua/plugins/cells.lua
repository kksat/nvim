local zals_cel_dir = "/home/ksatarin/dev/zals-neon/docs/cel"

local function find_zals_cel_assets(root_dir)
  if root_dir then
    local local_binpb = root_dir .. "/docs/cel/zals.binpb"
    local local_cfg = root_dir .. "/docs/cel/cel.yaml"
    if vim.uv.fs_stat(local_binpb) then
      return local_binpb, vim.uv.fs_stat(local_cfg) and local_cfg or (zals_cel_dir .. "/cel.yaml")
    end
  end
  local fallback_binpb = zals_cel_dir .. "/zals.binpb"
  local fallback_cfg = zals_cel_dir .. "/cel.yaml"
  return vim.uv.fs_stat(fallback_binpb) and fallback_binpb or nil,
    vim.uv.fs_stat(fallback_cfg) and fallback_cfg or nil
end

local function load_cells_proto_buffer(buf, uri)
  local clients = vim.lsp.get_clients({ name = "cells" })
  local client = clients[1]
  if not client then
    return
  end
  local resp = client:request_sync("workspace/textDocumentContent", { uri = uri }, 2000)
  if not resp or resp.err or not resp.result or type(resp.result.text) ~= "string" then
    return
  end
  local lines = vim.split(resp.result.text, "\n", { plain = true })
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].filetype = "proto"
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local caps = vim.lsp.protocol.make_client_capabilities()
      caps.workspace = caps.workspace or {}
      caps.workspace.textDocumentContent = { dynamicRegistration = true }

      vim.lsp.config("cells", {
        cmd = { "cells", "serve" },
        filetypes = { "cel" },
        root_markers = { "cel.yaml", ".git" },
        capabilities = caps,
        before_init = function(params, config)
          local root_dir = config.root_dir
          local binpb, default_cfg = find_zals_cel_assets(root_dir)
          params.initializationOptions = params.initializationOptions or {}
          if binpb then
            params.initializationOptions.descriptorSets = { binpb }
          end
          local has_local_cfg = root_dir and vim.fs.find("cel.yaml", {
            path = root_dir,
            upward = true,
            type = "file",
          })[1] ~= nil
          if not has_local_cfg and default_cfg then
            params.initializationOptions.config = default_cfg
          end
        end,
        handlers = {
          ["workspace/textDocumentContent/refresh"] = function(_, result)
            if not result or not result.uri then
              return vim.NIL
            end
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == result.uri then
                load_cells_proto_buffer(buf, result.uri)
              end
            end
            return vim.NIL
          end,
        },
      })
      vim.lsp.enable("cells")

      local group = vim.api.nvim_create_augroup("CellsProtoView", { clear = true })
      vim.api.nvim_create_autocmd("BufReadCmd", {
        group = group,
        pattern = { "cells-proto:*", "cells-proto:/*" },
        callback = function(ev)
          load_cells_proto_buffer(ev.buf, ev.match)
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "cel",
        callback = function(ev)
          vim.bo[ev.buf].commentstring = "// %s"
        end,
      })
    end,
  },
}
