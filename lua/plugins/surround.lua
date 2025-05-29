
local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
  vim.notify("nvim-surround not found", vim.log.levels.WARN)
  return
end

surround.setup({
 
  keymaps = {
    
    insert = "<C-g>s",
    insert_line = "<C-g>S",

    normal = "ys",      
    normal_cur = "yss",     
    normal_line = "yS",      
    normal_cur_line = "ySS", 

    visual = "S",          
    visual_line = "gS",     

    delete = "ds",           
    change = "cs",           
    change_line = "cS",     
  },

  surrounds = {

    ["("] = {
      add = { "( ", " )" },
      find = function()
        return M.get_selection({ open = "%(", close = "%)" })
      end,
      delete = "^(. ?)().-( ?.)()$",
    },
    [")"] = {
      add = { "(", ")" },
      find = function()
        return M.get_selection({ open = "%(", close = "%)" })
      end,
      delete = "^(.)().-(.)()$",
    },

    ["{"] = {
      add = { "{ ", " }" },
      find = function()
        return M.get_selection({ open = "%{", close = "%}" })
      end,
      delete = "^(. ?)().-( ?.)()$",
    },
    ["}"] = {
      add = { "{", "}" },
      find = function()
        return M.get_selection({ open = "%{", close = "%}" })
      end,
      delete = "^(.)().-(.)()$",
    },

    ["["] = {
      add = { "[ ", " ]" },
      find = function()
        return M.get_selection({ open = "%[", close = "%]" })
      end,
      delete = "^(. ?)().-( ?.)()$",
    },
    ["]"] = {
      add = { "[", "]" },
      find = function()
        return M.get_selection({ open = "%[", close = "%]" })
      end,
      delete = "^(.)().-(.)()$",
    },

    ["<"] = {
      add = { "< ", " >" },
      find = function()
        return M.get_selection({ open = "%<", close = "%>" })
      end,
      delete = "^(. ?)().-( ?.)()$",
    },
    [">"] = {
      add = { "<", ">" },
      find = function()
        return M.get_selection({ open = "%<", close = "%>" })
      end,
      delete = "^(.)().-(.)()$",
    },

    ['"'] = {
      add = { '"', '"' },
      find = '".-"',
      delete = "^(.)().-(.)()$",
    },
    ["'"] = {
      add = { "'", "'" },
      find = "'.-'",
      delete = "^(.)().-(.)()$",
    },
    ["`"] = {
      add = { "`", "`" },
      find = "`.-`",
      delete = "^(.)().-(.)()$",
    },

    ["t"] = {
      add = function()
        local tag = require("nvim-surround.config").get_input("Enter tag name: ")
        if tag then
          return { { "<" .. tag .. ">" }, { "</" .. tag .. ">" } }
        end
      end,
      find = function()
        return require("nvim-surround.config").get_selection({
          motion = "at",
        })
      end,
      delete = "^(%b<>)().-(%b<>)()$",
      change = {
        target = "^<([^%s>]+)().-([^%s>]+)()>$",
        replacement = function()
          local tag = require("nvim-surround.config").get_input("Enter new tag name: ")
          if tag then
            return { { "<" .. tag .. ">" }, { "</" .. tag .. ">" } }
          end
        end,
      },
    },

    ["f"] = {
      add = function()
        local func_name = require("nvim-surround.config").get_input("Enter function name: ")
        if func_name then
          return { { func_name .. "(" }, { ")" } }
        end
      end,
      find = function()
        return require("nvim-surround.config").get_selection({
          pattern = "[%w_]+%b()",
        })
      end,
      delete = "^([%w_]+%()().-(%))()$",
    },

    ["c"] = {
      add = { "```", "```" },
      find = "```.-```",
      delete = "^(```)().-(```)()$",
    },
 
    ["C"] = {
      add = function()
        local lang = require("nvim-surround.config").get_input("Enter language: ")
        return { { "```" .. (lang or "") }, { "```" } }
      end,
      find = "```%w*.-```",
      delete = "^(```%w*)().-(```)()$",
    },

    ["m"] = {
      add = { "$", "$" },
      find = "%$[^%$]*%$",
      delete = "^(%$)().-(%)$)()$",
    },
    
    ["M"] = {
      add = { "$$", "$$" },
      find = "%$%$[^%$]*%$%$",
      delete = "^(%$%$)().-(%$%$)()$",
    },

    ["/"] = {
      add = { "/* ", " */" },
      find = "/%*.*%*/",
      delete = "^(/%* ?)().-( ?%*/)()$",
    },

    ["#"] = {
      add = { "# ", "" },
      find = "#[^\r\n]*",
      delete = "^(# ?)().-()()$",
    },

    ["-"] = {
      add = { "-- ", "" },
      find = "%-%-[^\r\n]*",
      delete = "^(%-%- ?)().-()()$",
    },
    

    ["j"] = {
      add = { "{", "}" },
      find = "%b{}",
      delete = "^(.)().-(.)()$",
    },

    ["v"] = {
      add = { "{{ ", " }}" },
      find = "{{.-}}",
      delete = "^({{ ?)().-( ?}})()$",
    },

    ["A"] = {
      add = { "{{ ", " }}" },
      find = "{{.-}}",
      delete = "^({{ ?)().-( ?}})()$",
    },

    ["h"] = {
      add = { "{{", "}}" },
      find = "{{.-}}",
      delete = "^({{}?)().-(?}})()$",
    },
  },

  aliases = {
    
    ["a"] = ">",  
    ["b"] = ")",  
    ["B"] = "}",  
    ["r"] = "]",  
    ["q"] = '"',  
    ["s"] = "'",  
    ["z"] = "`",  

    ["T"] = "t", 
    ["F"] = "f",  

    ["md"] = "c", 
    ["ML"] = "C", 

    ["$"] = "m",  
    ["$$"] = "M", 
    
    ["/*"] = "/", 
    ["//"] = "#", 
    

    ["jsx"] = "j", 
    ["vue"] = "v", 
    ["ng"] = "A",  
    ["hbs"] = "h", 
  },

  highlight = {
    duration = 500,
  },

  move_cursor = "begin",

  indent_lines = function(start, stop)
    local b = vim.bo
    if b.filetype == "python" or b.filetype == "yaml" or b.filetype == "nim" then
      return false
    end
    return true
  end,
})

local M = {}

M.get_selection = function(opts)
  return require("nvim-surround.config").get_selection(opts)
end

local function setup_additional_keymaps()
  local opts = { noremap = true, silent = true }

  vim.keymap.set("n", "<leader>sw", "ysiw", vim.tbl_extend("force", opts, { 
    remap = true, 
    desc = "Surround word" 
  }))
  
  vim.keymap.set("n", "<leader>sW", "ysiW", vim.tbl_extend("force", opts, { 
    remap = true, 
    desc = "Surround WORD" 
  }))
  
  vim.keymap.set("n", "<leader>sl", "yss", vim.tbl_extend("force", opts, { 
    remap = true, 
    desc = "Surround line" 
  }))

  vim.keymap.set("v", "<leader>s(", "S)", opts)
  vim.keymap.set("v", "<leader>s[", "S]", opts)
  vim.keymap.set("v", "<leader>s{", "S}", opts)
  vim.keymap.set("v", '<leader>s"', 'S"', opts)
  vim.keymap.set("v", "<leader>s'", "S'", opts)
  vim.keymap.set("v", "<leader>s`", "S`", opts)
end


setup_additional_keymaps()


vim.api.nvim_create_user_command("SurroundHelp", function()
  print([[
nvim-surround shortcuts:
  ys{motion}{char} - Add surround
  yss{char} - Surround line
  S{char} - Surround selection (visual)
  ds{char} - Delete surround
  cs{old}{new} - Change surround
  
Aliases:
  a=>, b=), B=}, r=], q=", s=', z=`
  T=tag, F=function, md=code, $=math
  
Leader shortcuts:
  <leader>sw - Surround word
  <leader>sW - Surround WORD  
  <leader>sl - Surround line
  ]])
end, { desc = "Show nvim-surround help" })

return M