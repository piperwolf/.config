-- Create a function to ensure directories exist
local function ensure_dir_exists()
  local file_path = vim.fn.expand('%:p')
  local dir_path = vim.fn.fnamemodify(file_path, ':h')
  if vim.fn.isdirectory(dir_path) == 0 then
    vim.fn.mkdir(dir_path, 'p')
  end
end

-- Hook the function to BufWritePre event
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = ensure_dir_exists
})
