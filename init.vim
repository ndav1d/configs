"------------------------------------------------------------------------"
"|  ___  ________   ___  _________    ___      ___  ___   ______ _____  |"
"| |\  \|\   ___  \|\  \|\___   ___\ |\  \    /  /|/  /|/   _  / _   /| |"
"| \ \  \ \  \\ \  \ \  \|___ \  \_| \ \  \  /  / /  / /  / /__///  / / |"
"|  \ \  \ \  \\ \  \ \  \   \ \  \   \ \  \/  / /  / /  / |__|//  / /  |"
"|   \ \  \ \  \\ \  \ \  \   \ \  \ __\ \    / /  / /  / /    /  / /   |"
"|    \ \__\ \__\\ \__\ \__\   \ \__\\__\ \__/ /__/ /__/ /    /__/ /    |"
"|     \|__|\|__| \|__|\|__|    \|__\|__|\|__|/|__|/|__|/     |__|/     |"
"|       init.vim file (nvim 0.5.0) ------------------ by: ndavid       |"
"|----------------------------------------------------------------------|"
"|    FIRST TIME TODOS                                                  |"
"|    - install Packer.nvim                                             |"
"|    - place pt.utf-8.spl into /spell                                  |"
"|    - install sumatraPDF, sqlite, etc.                                |"
"------------------------------------------------------------------------"

" --- Load plugins ------------------------------------------------------"
lua require'plugins'

" -----------------------------------------------------------------------"
" ---------------- NVIM SETTINGS ----------------------------------------"
" -----------------------------------------------------------------------"
" --- Define mapleader for keymaps --------------------------------------"
let mapleader = ' '

" --- Enable 256 color support ------------------------------------------"
set termguicolors

" --- Disable recommended styles ----------------------------------------"
" Be a round peg in a squared hole
let g:python_recommended_style = 0
let g:rust_recommended_style = 0

" --- Set g:python3_host_prog -------------------------------------------"
let g:python3_host_prog=
      \'~/AppData/Local/Programs/Python/Python38/python.exe'

" --- Time format language ----------------------------------------------"
language time en_us

" --- Global settings ---------------------------------------------------"
set nowrap
set clipboard=unnamed
set noshowmode
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu rnu
set nohls
set list
set ignorecase
set smartcase
set noswapfile
set nobackup
set undofile
set pumblend=15
set textwidth=80
set colorcolumn=+1
set updatetime=100
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set inccommand=split

" --- Listchars ---------------------------------------------------------"
if &list
  let g:listchar_index = 0
  let g:listchar_options = [
        \ 'tab:\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·'.
        \ ',eol:﬋',
        \ 'tab:\ ,conceal:┊,nbsp:⍽,extends:>,precedes:<,trail:·',
        \ ]
  " Nice chars ﲒ ﮊ ⌴ ⍽   ▷▻⊳►▶▚‽⊛ψψδ…﬋↲↵┊
  " ﴣ           
  function CycleListchars() abort
    execute 'set listchars='.g:listchar_options[
          \ float2nr(
          \ fmod(g:listchar_index, len(g:listchar_options))
          \ )]
    let g:listchar_index += 1
  endfunction
  " Cycle listchars
  nnoremap <silent><leader><leader>cl :call CycleListchars()<CR>
  call CycleListchars()
endif

" --- Have cursorline active only on the active window ------------------"
"hi CursorLine guibg=NONE guibg=#101010
"hi CursorLineNr guifg=white guibg=#101010
"au WinEnter,BufEnter * if &ft!='startify' | setl cursorline
      "\ | hi CursorLine guibg=#101010 | endif
"au WinLeave,BufLeave * setl nocursorline | hi CursorLine guibg=NONE

" --- Change guicursor --------------------------------------------------"
set guicursor=a:block-Cursor,i-r:hor20-Cursor

" --- Mouse options -----------------------------------------------------"
set mouse=a
behave xterm

" --- Fix Highlight Errors ----------------------------------------------"
let g:vimsyn_noerror = 1

" --- Highlight when yanking --------------------------------------------"
augroup LuaHighlight
  au!
  au TextYankPost *
        \ silent! lua require'vim.highlight'.on_yank({on_visual=false})
augroup END

" -----------------------------------------------------------------------"
" ---------------- PLUGIN SETTINGS --------------------------------------"
" -----------------------------------------------------------------------"
" --- For base16 colorscheme --------------------------------------------"
let base16colorspace=256  " Access colors present in 256 colorspace

" --- For WebDevicons ---------------------------------------------------"
" Load webdevicons config
lua require('webdevicons_config').my_setup()
" Update filetype icon highlight
lua require('webdevicons_config').make_hl()

" --- For Colorizer -----------------------------------------------------"
nnoremap <silent><leader>co :ColorizerToggle<CR>

" --- For Dirvish -------------------------------------------------------"
nnoremap <silent><leader>d :Dirvish<CR>

" --- For Hop.nvim ------------------------------------------------------"
noremap <silent>,w <cmd>HopWord<CR>
noremap <silent>,c <cmd>HopChar2<CR>

" --- For ScrollView ----------------------------------------------------"
let g:scrollview_on_startup = 0
let g:scrollview_column = 1
let g:scrollview_excluded_filetypes =
      \ ['startify', 'nerdtree', 'vista_kind', 'packer']
let g:scrollview_mode = 'flexible'
let g:active_scrollview = 0
function ToggleSrollView()
  if g:active_scrollview == 0
    let g:active_scrollview = 1
    execute 'ScrollViewEnable'
  elseif g:active_scrollview == 1
    let g:active_scrollview = 0
    execute 'ScrollViewDisable'
  endif
endfunction
nnoremap <silent><leader>sb :call ToggleSrollView()<CR>

" --- For vim-smoothie --------------------------------------------------"
let g:smoothie_no_default_mappings = 1
" Keymaps
nnoremap <silent><A-j> :call smoothie#downwards()<CR>
nnoremap <silent><A-k> :call smoothie#upwards()<CR>

" --- For vim-startify --------------------------------------------------"
function! StartifyEntryFormat()
  return "luaeval(\"require'webdevicons_config'.get_icon{"
        \."filepath=_A}\", absolute_path)"
        \." .\" \". entry_path"
endfunction
function GetNvimVersion()
  redir => s
  silent! version
  redir END
  return 'NVIM v'.matchstr(s, 'NVIM v\zs[^\n]*')
endfunction
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_bookmarks = [
      \ ]
let g:startify_commands = [
      \ {'f': ['Frecency', 'Telescope frecency']},
      \ {'p': 'PackerSync'},
      \ ]
let g:startify_files_number = 5
let g:startify_fortune_use_unicode = 1
let g:startify_custom_header_quotes =
      \ startify#fortune#predefined_quotes() +
      \ [[
      \ 'The career of a young theoretical physicist consists'.
      \ ' of treating the harmonic oscillator in ever-increasing'.
      \ ' levels of abstraction.','','- Sidney Coleman'
      \ ]]
let s:ascii_darth_vader = [
      \ '  o       ⌌━━━ ⌍      ',
      \ '   o     | //   ░▏    ',
      \ '    o  _/,-||-_╲_\    ',
      \ '       / (■)(■)\\░\   ',
      \ '      / \_/_\__/\  ╲  ',
      \ '     (   ╱╱ii\\/ )  \_',
      \ '      ╲▁  ▔▔▔▔─⌍▁▁▁▁▁/',
      \ '       ▁▁▐ ▐  ▐ \     ',
      \ ]
function StartifyUpdateQuote()
  let s:get_quote = startify#fortune#boxed()
endfunction
function StartifyUpdateCentering()
  let g:startify_custom_header =
        \ startify#center([GetNvimVersion()]) +
        \ startify#center(['',
        \ '  Welcome to the Dark Side of text editing',
        \ 'Nvim is open source and freely distributable',
        \ '']) + startify#center(s:get_quote) +
        \ startify#center(s:ascii_darth_vader)
endfunction
autocmd VimEnter * call StartifyUpdateQuote()
      \| call StartifyUpdateCentering()
autocmd VimResized * if &ft=='startify' && winwidth(0)>=64
      \| call StartifyUpdateCentering()
      \| call startify#insane_in_the_membrane(0)
      \| endif
function StartifyReLaunch()
  call StartifyUpdateQuote()
  call StartifyUpdateCentering()
  Startify
endfunction
nnoremap <silent><leader><leader>s :call StartifyReLaunch()<CR>

" --- For Vista.vim -----------------------------------------------------"
let g:vista_default_executive = 'nvim_lsp'
let g:vista_icon_indent = ["└─ ", "├─ "]
autocmd VimResized * let g:vista_sidebar_width =
      \ string(nvim_win_get_width(0)*0.3)
let g:vista_update_on_text_changed = 1
let g:vista_cursor_delay = 10
if exists('g:scrollview_on_startup')
  nnoremap <silent><leader>v :Vista!!<CR>:ScrollViewRefresh<CR>
else
  nnoremap <silent><leader>v :Vista!!<CR>
endif

" --- For signify -------------------------------------------------------"
let s:signify_symbol = '▌' " ▊
let g:signify_sign_add = s:signify_symbol
let g:signify_sign_change = s:signify_symbol
let g:signify_sign_delete = s:signify_symbol

" --- For Luapad --------------------------------------------------------"
lua require('luapad_config')

" --- For NERDCommenter -------------------------------------------------"
let NERDSpaceDelims=0
let g:NERDAltDelims_c     = 1
let g:NERDAltDelims_cpp   = 1
let g:NERDCompactSexyComs = 1

" --- For creating presentations in vim ---------------------------------"
autocmd BufNewFile,BufRead *.vpm call SetVimPresentationMode()
function SetVimPresentationMode()
  set laststatus=0
  hi NonText guifg=bg ctermfg=bg
  set nonu
  nnoremap <buffer> <Right> :n<CR>
  nnoremap <buffer> <Left> :N<CR>
endfunction

" --- For vim-anyfold ---------------------------------------------------"
let g:anyfold_fold_toplevel=0
set foldlevel=99
autocmd BufWritePre *.md let b:noanyfold="true"
if !exists('b:noanyfold')
  if bufname(0) != ''
    AnyFoldActivate
  endif
endif

" --- For vim-sleuth ----------------------------------------------------"
let g:sleuth_automatic = 0

" --- For nvim-treesitter -----------------------------------------------"
lua require('treesitter_config')

" --- For sql.nvim ------------------------------------------------------"
let g:sql_clib_path = "C:/Sqlite3/sqlite3.dll"

" --- For nvim-telescope ------------------------------------------------"
" Load config file
lua require('telescope_config')
" Media command ( nvim media player :D ) SOON
"command Media lua require'telescope.builtin'.find_files{ find_command =
      "\ {'fd', '--type', 'f', '-e', 'mp4' }, previewer = false }
" Keymaps
nnoremap <leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>gl :lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>gs :lua require('telescope.builtin').grep_string()<CR>
nnoremap <leader>ga :lua require('telescope.builtin').lsp_code_actions()<CR>
nnoremap <leader>gt :lua require('telescope.builtin').treesitter()<CR>
nnoremap <leader><leader>h :lua require('telescope.builtin').help_tags()<CR>
nnoremap z= :lua require('telescope.builtin').spell_suggest()<CR>
nnoremap <leader>fc :lua require('telescope_config').search_config()<CR>
nnoremap <leader>gb :lua require('telescope_config').git_branches()<CR>

" --- For lspconfig -----------------------------------------------------"
" Load config file
lua require('lspconfig_config')
" Format command ( for proper formatting )
command! Format execute 'lua vim.lsp.buf.formatting()'
command! LineDiag lua vim.lsp.diagnostic.show_line_diagnostics()
" Keymaps
nnoremap <silent>gD         :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent>gd         :lua vim.lsp.buf.definition()<CR>
nnoremap <silent><leader>gk :lua vim.lsp.buf.hover()<CR>
nnoremap <silent><leader>gr :lua vim.lsp.buf.rename()<CR>
nnoremap <silent><leader>gR :lua vim.lsp.buf.references()<CR>
nnoremap <silent><leader>gp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent><leader>gn :lua vim.lsp.diagnostic.goto_next()<CR>

" --- For nvim-jdtls ----------------------------------------------------"
augroup lsp
  au!
  au FileType java lua require'nvimjdtls_config'
augroup END

" --- For vim-vsnip and Neosnippet --------------------------------------"
function SnippetSettings(whichOne)
  if a:whichOne == 'neo'
    let g:completion_enable_snippet = 'Neosnippet'
    imap <C-k> <Plug>(neosnippet_jump)
    smap <C-k> <Plug>(neosnippet_jump)
  elseif a:whichOne == 'vsnip'
    let g:completion_enable_snippet = 'vim-vsnip'
    imap <expr><C-k> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-k>'
    smap <expr><C-k> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-k>'
    imap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
    smap <expr><C-j> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-j>'
  endif
endfunction

" --- For completion.nvim -----------------------------------------------"
" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
" Enable Neosnippet snippets for html & tex
" Use vim-vsnip for the rest
autocmd BufEnter * if &filetype =~ 'tex\|html' |
      \ call SnippetSettings('neo') | else |
        \ call SnippetSettings('vsnip') | endif
let g:completion_confirm_key = '<CR>'
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)
let g:completion_enable_auto_paren = 0
let g:completion_matching_strategy_list =
      \ ['exact', 'substring', 'fuzzy', 'all']

" -----------------------------------------------------------------------"
finish

Impulse. Response. Fluid. Imperfect. Patterned. Chaotic.
