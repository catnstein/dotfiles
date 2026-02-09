return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    local git_worktree = require('git-worktree')
    git_worktree.setup()

    local function get_worktrees()
      local output = vim.fn.systemlist('git worktree list --porcelain')
      local worktrees = {}
      local current = {}
      local cwd = vim.fn.getcwd()

      for _, line in ipairs(output) do
        if line:match('^worktree ') then
          current.path = line:sub(10)
        elseif line:match('^branch ') then
          current.branch = line:sub(8):gsub('refs/heads/', '')
        elseif line:match('^bare') then
          current.bare = true
        elseif line:match('^HEAD ') then
          current.head = line:sub(6)
        elseif line == '' and current.path then
          current.is_current = current.path == cwd
          table.insert(worktrees, {
            text = current.branch or current.head or '(bare)',
            path = current.path,
            branch = current.branch,
            bare = current.bare,
            is_current = current.is_current,
          })
          current = {}
        end
      end

      if current.path then
        current.is_current = current.path == cwd
        table.insert(worktrees, {
          text = current.branch or current.head or '(bare)',
          path = current.path,
          branch = current.branch,
          bare = current.bare,
          is_current = current.is_current,
        })
      end

      return worktrees
    end

    local function worktree_picker()
      local items = get_worktrees()

      Snacks.picker.pick({
        source = 'git_worktrees',
        title = 'Git Worktrees',
        items = items,
        pattern = '',
        preview = 'none',
        layout = { preset = 'select' },
        format = function(item)
          local icon = item.is_current and '● ' or '  '
          local icon_hl = item.is_current and 'DiagnosticOk' or 'Comment'
          local name = item.branch or item.text
          local name_hl = item.is_current and 'Bold' or 'SnacksPickerFile'
          return {
            { icon, icon_hl },
            { name, name_hl },
            { '  ' },
            { item.path, 'Comment' },
          }
        end,
        confirm = function(picker, item)
          picker:close()
          if item then
            if item.is_current then
              vim.notify('Already in this worktree', vim.log.levels.INFO)
              return
            end
            git_worktree.switch_worktree(item.path)
          end
        end,
        actions = {
          delete = function(picker, item)
            if not item then
              return
            end
            if item.is_current then
              vim.notify('Cannot delete current worktree', vim.log.levels.ERROR)
              return
            end
            if item.bare then
              vim.notify('Cannot delete bare repository', vim.log.levels.ERROR)
              return
            end
            local name = item.branch or item.path
            vim.ui.input({ prompt = 'Delete worktree "' .. name .. '"? (y/N): ' }, function(input)
              if input and input:lower() == 'y' then
                picker:close()
                git_worktree.delete_worktree(item.path)
              end
            end)
          end,
        },
        win = {
          input = {
            keys = {
              ['<C-d>'] = { 'delete', mode = { 'n', 'i' } },
            },
          },
          list = {
            keys = {
              ['dd'] = 'delete',
            },
          },
        },
      })
    end

    local function get_branch_basename(branch)
      return branch:match('[^/]+$') or branch
    end

    local function create_worktree_picker()
      Snacks.picker.git_branches({
        title = 'Select Branch for New Worktree',
        confirm = function(picker, item)
          picker:close()
          if not item then
            return
          end
          local branch = item.name or item.branch or item.text
          local default_path = get_branch_basename(branch)

          vim.ui.input({ prompt = 'Worktree path: ', default = default_path }, function(path)
            if path and path ~= '' then
              git_worktree.create_worktree(path, branch, 'origin')
            end
          end)
        end,
      })
    end

    local function create_new_branch_worktree()
      vim.ui.input({ prompt = 'New branch name: ' }, function(branch)
        if not branch or branch == '' then
          return
        end
        local default_path = get_branch_basename(branch)
        vim.ui.input({ prompt = 'Worktree path: ', default = default_path }, function(path)
          if not path or path == '' then
            return
          end
          git_worktree.create_worktree(path, branch)
        end)
      end)
    end

    vim.keymap.set('n', '<leader>lw', worktree_picker, { desc = 'Git Worktrees' })
    vim.keymap.set('n', '<leader>lc', create_worktree_picker, { desc = 'Create Worktree from Branch' })
    vim.keymap.set('n', '<leader>ln', create_new_branch_worktree, { desc = 'New Branch + Worktree' })
  end,
}
