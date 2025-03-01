local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
	return
end

trouble.setup({
	position = "bottom",
	height = 10,
	width = 50,

	icons = true,
	mode = "workspace_diagnostics",
	fold_open = "",
	fold_closed = "",
	group = true,
	padding = true,

	auto_open = false,
	auto_close = true,
	auto_preview = true,
	auto_fold = false,
	signs = {
		error = "",
		warning = "",
		hint = "",
		information = "",
	},

	use_diagnostic_signs = true,
})
