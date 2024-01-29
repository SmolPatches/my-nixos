return {
    "mfussenegger/nvim-dap",
    dependencies = {
	"leoluz/nvim-dap-go",
    },
    config = function()
	local dap = require("dap")
	-- setup delve debugger for go
	dap.adapters.delve = {}
	dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages 
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  } 
}
    end
}
