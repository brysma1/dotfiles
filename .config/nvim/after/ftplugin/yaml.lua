local filename = vim.fn.expand("%:t")
if not (string.find(filename, "compose") == nil) then
	vim.bo.filetype = "yaml.docker-compose"
end
