# Dotfiles

My personal configuration files for development environment setup.

## Contents

This repository contains configuration files for various development tools and applications:

### Terminal & Shell

#### `zshrc_content.sh` - Zsh Configuration Content
Shell function definitions and configuration snippets for zsh shell.

**Features:**
- `fv()` function - File viewer with fuzzy finder integration
- Combines `fd`, `fzf`, and `bat` for enhanced file selection
- Preview window with syntax highlighting
- Tmux integration for seamless workflow
- Opens files directly in Neovim

#### `.tmux.conf` - Tmux Configuration
Terminal multiplexer configuration with custom keybindings and enhanced functionality.

**Features:**
- Mouse support enabled
- Prefix changed from `Ctrl-b` to `Ctrl-a`
- Intuitive pane splitting with `|` (horizontal) and `-` (vertical)
- Enhanced split commands preserve current directory and improved positioning
- Quick config reload with `Prefix + r`
- Alt + Arrow keys for pane navigation without prefix
- Vi mode for copy operations
- macOS clipboard integration (pbcopy)
- Windows and panes start at index 1
- Auto-renumber windows on close
- 256-color terminal support
- Custom status bar with system load and time
- Vim-style pane resizing with `Prefix + hjkl`
- Alternative pane resizing with `Prefix + Shift + arrows`
- Enhanced scrollback buffer (10,000 lines)
- Faster key response with zero escape time
- Focus events enabled for better editor integration

### Neovim Plugins

#### `claudecode.lua` - Claude Code Integration
Neovim plugin configuration for Claude Code AI assistant integration.

**Features:**
- AI-powered code assistance with Claude
- Key mappings under `<leader>a` namespace
- Toggle, focus, and resume Claude sessions
- Model selection support
- Buffer and visual selection sending
- Diff management with auto-reopen functionality
- File tree integration (NvimTree, neo-tree, oil, minifiles)
- Floating terminal window configuration
- Port range configuration (10000-65535)
- Visual selection tracking

**Key Bindings:**
- `<leader>ac` - Toggle Claude
- `<leader>af` - Focus Claude window
- `<leader>ar` - Resume Claude session
- `<leader>aC` - Continue Claude
- `<leader>am` - Select Claude model
- `<leader>ab` - Add current buffer
- `<leader>as` - Send selection to Claude
- `<leader>aa` - Accept diff and reopen
- `<leader>ad` - Deny diff and reopen

#### `llm-nvim.lua` - LLM Integration
General LLM integration for Neovim with support for various AI models.

**Features:**
- OpenAI-compatible API support
- Environment variable configuration (uses `COSMOS_API` environment variable)
- AI-powered commit message generation for lazygit
- Smart diff handling (adapts to diff size)
- Branch-aware commit messages with conventional commit format
- Support for large diffs with intelligent summarization
- Automatic diff size detection (full diff for <10KB, summary for larger)
- Claude Sonnet 4 model integration for commit messages
- Flexible window interface for commit message editing

**Key Bindings:**
- `<leader>gc` - Generate commit message

#### `package-info.lua` - NPM Package Management
Visual package version management for `package.json` files in Neovim.

**Features:**
- Auto-start on JSON files
- Visual display of package versions
- Update notifications
- Interactive package management
- NPM as default package manager
- Hide unstable versions option

**Key Bindings:**
- `<leader>cps` - Show package versions
- `<leader>cph` - Hide package versions
- `<leader>cpt` - Toggle version display
- `<leader>cpu` - Update package
- `<leader>cpd` - Delete package
- `<leader>cpi` - Install package
- `<leader>cpc` - Change package version

#### `kulala.lua` - REST Client
HTTP client for testing REST APIs directly from Neovim.

**Features:**
- Support for HTTP and REST file types
- Request execution with visual feedback
- Environment and authentication management
- Built-in UI for request/response viewing
- Global keymaps with `<leader>R` prefix
- LSP support for syntax highlighting
- 30-second request timeout
- Scratchpad for quick testing

**Key Bindings:**
- `<leader>Rs` - Send request
- `<leader>Ra` - Send all requests
- `<leader>Rr` - Replay last request
- `<C-c>` - Cancel request (in HTTP/REST files)
- `<leader>Ro` - Open Kulala UI
- `<leader>Rb` - Open scratchpad
- `<leader>Rf` - Find request
- `<leader>Re` - Choose environment
- `<leader>Ru` - Manage authentication

#### `render-markdown.lua` - Enhanced Markdown Rendering
Real-time markdown rendering with rich visual enhancements in Neovim.

**Features:**
- Live markdown rendering in normal, command, and terminal modes
- Anti-conceal functionality for editing
- Custom heading icons with different levels
- Enhanced code block rendering with sign column
- Styled bullet points and checkboxes
- Blockquote rendering with visual indicators
- Full-width table rendering
- GitHub-style callouts (Note, Tip, Important, Warning, Caution)
- Link visualization with custom icons
- Sign column integration

**Key Bindings:**
- `<leader>rm` - Toggle markdown rendering

#### `colorscheme.lua` - TokyoNight Theme Configuration
Colorscheme configuration for consistent visual theme across Neovim.

**Features:**
- TokyoNight theme with "storm" variant
- LazyVim integration
- Consistent color scheme application
- Dark theme optimized for extended coding sessions

## Installation

1. Clone this repository:
```bash
git clone https://github.com/[your-username]/.dotfiles.git ~/.dotfiles
```

2. Create symbolic links to the configuration files:

### Zsh Configuration
```bash
# Add the function to your .zshrc
cat ~/.dotfiles/zshrc_content.sh >> ~/.zshrc
# Or source it directly
echo "source ~/.dotfiles/zshrc_content.sh" >> ~/.zshrc
```

### Tmux
```bash
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
```

### Neovim plugins
For Neovim, copy the Lua plugin configurations to your Neovim config directory:

```bash
# Assuming you use lazy.nvim as your plugin manager
cp ~/.dotfiles/*.lua ~/.config/nvim/lua/plugins/
```

Or if you prefer symbolic links:
```bash
ln -sf ~/.dotfiles/claudecode.lua ~/.config/nvim/lua/plugins/claudecode.lua
ln -sf ~/.dotfiles/llm-nvim.lua ~/.config/nvim/lua/plugins/llm-nvim.lua
ln -sf ~/.dotfiles/package-info.lua ~/.config/nvim/lua/plugins/package-info.lua
ln -sf ~/.dotfiles/kulala.lua ~/.config/nvim/lua/plugins/kulala.lua
ln -sf ~/.dotfiles/render-markdown.lua ~/.config/nvim/lua/plugins/render-markdown.lua
ln -sf ~/.dotfiles/colorscheme.lua ~/.config/nvim/lua/plugins/colorscheme.lua
```

## Requirements

### Zsh Configuration
- Zsh shell
- `fd` - Fast find alternative
- `fzf` - Fuzzy finder
- `bat` - Cat alternative with syntax highlighting
- `tmux` (optional, for tmux integration)
- Neovim

### Tmux
- Tmux 2.9+ recommended
- macOS with pbcopy for clipboard integration

### Neovim Plugins
- Neovim 0.8.0+
- Plugin manager (e.g., lazy.nvim)
- Dependencies will be automatically installed by the plugin manager

#### Plugin-specific requirements:
- **claudecode.lua**: 
  - `folke/snacks.nvim` dependency
  - Claude Code server setup
  
- **llm-nvim.lua**: 
  - `nvim-lua/plenary.nvim`
  - `MunifTanjim/nui.nvim`
  - Git for commit message generation
  - `COSMOS_API` environment variable set to your LLM endpoint
  - Compatible LLM endpoint (OpenAI-compatible API)
  
- **package-info.lua**:
  - `MunifTanjim/nui.nvim`
  - Node.js and npm

- **kulala.lua**:
  - HTTP and REST file type support
  - No additional dependencies (self-contained)

- **render-markdown.lua**:
  - `nvim-treesitter/nvim-treesitter`
  - `echasnovski/mini.nvim` (for mini.icons)
  - Treesitter parsers for markdown

- **colorscheme.lua**:
  - `folke/tokyonight.nvim`
  - LazyVim (if using LazyVim distribution)

## Customization

Feel free to modify any configuration to suit your preferences. Each file is well-commented to help you understand and customize the settings.

### Tmux
Edit `~/.tmux.conf` and reload with `Prefix + r`

### Neovim
Edit the respective Lua files and restart Neovim or reload the configuration.

## License

These configuration files are provided as-is for personal use.

## Contributing

If you have suggestions or improvements, feel free to open an issue or submit a pull request.