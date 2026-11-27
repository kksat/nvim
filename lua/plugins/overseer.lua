return {
  "stevearc/overseer.nvim",
  opts = {
    -- The zig template provider runs `zig build --list-steps`, which must
    -- compile the build script first (~45s cold after a zig upgrade or
    -- build.zig change; ~0.1s warm). The default 3s timeout silently drops
    -- the zig templates from :OverseerRun when the cache is cold.
    template_timeout_ms = 0,
  },
}
