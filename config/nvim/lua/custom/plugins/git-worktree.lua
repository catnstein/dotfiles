return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    local git_worktree = require('git-worktree')
    git_worktree.setup()

    git_worktree.on_tree_change(function(op, metadata)
      -- Refresh Oil on switch
      if op == git_worktree.Operations.Switch then
        local oil_ok, oil = pcall(require, 'oil')
        if oil_ok then
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match('^oil://') then
            vim.schedule(function()
              oil.open(vim.fn.getcwd())
            end)
          end
        end
        return
      end

      if op ~= git_worktree.Operations.Create then
        return
      end

      -- Get absolute path using git worktree list
      local worktrees = vim.fn.systemlist('git worktree list --porcelain')
      local new_path = nil
      local parent = nil

      for _, line in ipairs(worktrees) do
        if line:match('^worktree ') then
          local path = line:sub(10)
          -- Use plain string comparison (metadata.path may contain pattern special chars like -)
          if #path >= #metadata.path and path:sub(-#metadata.path) == metadata.path then
            new_path = path
            parent = vim.fn.fnamemodify(path, ':h')
            break
          end
        end
      end

      if not new_path then
        vim.notify('Could not find worktree path', vim.log.levels.ERROR)
        return
      end

      -- Copy .env from ../master or ../main
      local env_source = nil
      local master_env = parent .. '/master/.env'
      local main_env = parent .. '/main/.env'

      if vim.fn.filereadable(master_env) == 1 then
        env_source = master_env
      elseif vim.fn.filereadable(main_env) == 1 then
        env_source = main_env
      end

      if env_source then
        vim.fn.system({ 'cp', env_source, new_path .. '/.env' })
        local source_name = vim.fn.fnamemodify(env_source, ':h:t')
        vim.notify('.env copied from ' .. source_name, vim.log.levels.INFO)
      else
        vim.notify('.env not found in ../master or ../main', vim.log.levels.WARN)
      end

      -- Run npm ci async
      vim.notify('Running npm ci in: ' .. new_path, vim.log.levels.INFO)

      if vim.fn.isdirectory(new_path) ~= 1 then
        vim.notify('Directory does not exist: ' .. new_path, vim.log.levels.ERROR)
        return
      end

      vim.fn.jobstart({ 'npm', 'ci' }, {
        cwd = new_path,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.notify('npm ci completed', vim.log.levels.INFO)
            else
              vim.notify('npm ci failed (exit ' .. code .. ')', vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end)

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
