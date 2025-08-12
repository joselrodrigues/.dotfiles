# Dotfiles

My personal configuration files for development environment setup.

## Contents

This repository contains configuration files for various development tools and applications:

### Terminal & Shell

#### `.tmux.conf` - Tmux Configuration
Terminal multiplexer configuration with custom keybindings and enhanced functionality.

**Features:**
- Mouse support enabled
- Prefix changed from `Ctrl-b` to `Ctrl-a`
- Intuitive pane splitting with `|` (horizontal) and `-` (vertical)
- Quick config reload with `Prefix + r`
- Alt + Arrow keys for pane navigation without prefix
- Vi mode for copy operations
- macOS clipboard integration (pbcopy)
- Windows and panes start at index 1
- Auto-renumber windows on close
- 256-color terminal support
- Custom status bar with system load and time

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
- Custom endpoint configuration
- AI-powered commit message generation for lazygit
- Smart diff handling (adapts to diff size)
- Branch-aware commit messages
- Support for large diffs with intelligent summarization

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

## Installation

1. Clone this repository:
```bash
git clone https://github.com/[your-username]/.dotfiles.git ~/.dotfiles
```

2. Create symbolic links to the configuration files:

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
```

## Requirements

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
  - Compatible LLM endpoint (OpenAI-compatible API)
  
- **package-info.lua**:
  - `MunifTanjim/nui.nvim`
  - Node.js and npm

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