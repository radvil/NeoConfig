vim.print(vim.fn.getcwd():gsub(os.getenv("HOME"), "~"))
