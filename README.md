![Stable](https://img.shields.io/badge/status-stable-brightgreen) ![License](https://img.shields.io/badge/license-MIT-blue)

# vim-easyline

A fast, lightweight, and highly customizable statusline plugin for Vim (compatible with Vim 8+ and Vim 9). vim-easyline enhances your Vim experience by providing dynamic, informative, and visually appealing statusline sections, git integration, extensive theming, and automatic colorscheme matching.

---

## Key Features

- ✅ **Automatic setup**: Initializes automatically on startup with zero configuration required
- ✅ **Advanced git integration**: Real-time branch display and diff statistics with intelligent caching
- ✅ **Extensive theme library**: 10+ built-in themes with automatic colorscheme detection
- ✅ **Highly customizable**: Configure separate layouts for active/inactive windows and per-filetype
- ✅ **Performance optimized**: Asynchronous job support, update throttling, and smart caching
- ✅ **Cross-platform**: Works with Vim 8+, Vim 9, and Neovim
- ✅ **No dependencies**: Pure Vimscript implementation

---

## Performance Features

### Asynchronous Operations
- **Job Support**: Automatic detection and use of Vim 8+/Neovim job APIs
- **Fallback Mode**: Timer-based execution for older Vim versions
- **Non-blocking**: Git operations never block the editor

### Intelligent Caching
- **Git Repository Cache**: Efficient repository root detection
- **Git Command Cache**: Cached git branch and diff results
- **Timeout Management**: Configurable cache expiration
- **Memory Efficient**: Automatic cleanup of stale cache entries

### Update Optimization
- **Throttled Updates**: Configurable minimum update intervals
- **Debounced Git Diff**: Intelligent batching of diff stat updates
- **Event-driven**: Updates only when necessary (file changes, window focus, etc.)

---

## Installation

### Using vim-plug (Recommended)

```vim
call plug#begin('~/.vim/plugged')
Plug 'josstei/vim-easyline'
call plug#end()
```

Then reload Vim and run `:PlugInstall`.

### Using Pathogen

```bash
cd ~/.vim/bundle
git clone https://github.com/josstei/vim-easyline.git
```

### Using Vim 8+ packages

```bash
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/josstei/vim-easyline.git
```

---

## Setup Requirements

Ensure true color support is enabled for best theme experience:

```vim
if has('termguicolors')
  set termguicolors
endif
```

---

## Configuration

### Basic Configuration

```vim
" Left Section (Active windows)
let g:easyline_left_active_items = ['windownumber', 'filename', 'modified', 'readonly']

" Left Section (Inactive windows)
let g:easyline_left_inactive_items = ['windownumber', 'filename']

" Right Section (Active windows)
let g:easyline_right_active_items = ['git', 'position', 'filetype', 'encoding']

" Right Section (Inactive windows)
let g:easyline_right_inactive_items = ['position', 'filetype']

" Visual separators
let g:easyline_left_separator = '█'
let g:easyline_right_separator = '█'
```

### Git Integration

```vim
" Enable git features
let g:easyline_git_enabled = 1

" Git cache timeout (milliseconds)
let g:easyline_git_cache_timeout = 5000

" Git diff update debounce timeout (milliseconds)
let g:easyline_git_diff_debounce = 200
```

### Performance Tuning

```vim
" Update throttling (milliseconds)
let g:easyline_update_throttle = 20

" Buffer types to exclude from easyline
let g:easyline_buffer_exclude = ['help', 'quickfix', 'terminal']
```
---

## Advanced Configuration

### Per-Filetype Customization

Override statusline items for specific file types:

```vim
" Python-specific layout
let g:easyline_left_active_items_python = ['filename', 'git', 'modified']
let g:easyline_right_active_items_python = ['position', 'encoding']

" Markdown-specific layout
let g:easyline_left_active_items_markdown = ['filename', 'modified', 'readonly']
let g:easyline_right_active_items_markdown = ['position', 'filetype']

" JavaScript-specific layout
let g:easyline_left_active_items_javascript = ['cwd', 'filename', 'gitdiff']
```

---

## Complete Item Reference

| **Item**         | **Description**                                  | **Example Output**        |
|------------------|--------------------------------------------------|---------------------------|
| `windownumber`   | Window number in current tab                     | `1`, `2`, `3`            |
| `filename`       | Current file name                                | `README.md`, `[No Name]` |
| `modified`       | File modification indicator                      | `[Modified]`, ``         |
| `readonly`       | Read-only file indicator                         | `[Readonly]`, ``         |
| `position`       | Cursor position (line:column)                    | `42:15`, `1:1`           |
| `filetype`       | File type from `&filetype`                       | `vim`, `python`, `[no ft]` |
| `encoding`       | File encoding                                    | `utf-8`, `latin1`        |
| `cwd`            | Current working directory name                   | `vim-easyline`, `project` |
| **Git Items**    |                                                  |                           |
| `git`            | Combined git branch and diff statistics          | `main ~2 +15 -3`         |
| `gitbranch`      | Current git branch name                          | `main`, `feature/new`    |
| `gitdiff`        | Git diff statistics for current repository       | `~2 +15 -3`, ``          |

---

## Theme Library

vim-easyline includes 10+ commonly used themes that automatically integrate with your Vim colorscheme:

### Available Themes

| **Theme**     | **Description**                                  |
|---------------|--------------------------------------------------|
| `default`     | Neutral grayscale theme (fallback)              |
| `material`    | Google Material Design colors                    |
| `onedark`     | Atom One Dark inspired theme                    |
| `gruvbox`     | Retro groove colors                              |
| `nord`        | Arctic, north-bluish clean palette               |
| `dracula`     | Dark theme with vibrant colors                  |
| `nightfox`    | Dark blue theme with warm accents               |
| `edge`        | Clean, elegant dark theme                        |
| `molokai`     | Vim molokai colorscheme integration              |
| `sonokai`     | High contrast dark theme                         |



---

## 📝 License

MIT – see [LICENSE.md](LICENSE.md) for details.
