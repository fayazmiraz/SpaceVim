"=============================================================================
" markdown.vim --- lang#markdown layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

let s:md_listItemIndent = 1
let s:md_enableWcwidth = 0
function! SpaceVim#layers#lang#markdown#set_variable(var) abort
   let s:md_listItemIndent = get(a:var, 'listItemIndent', s:md_listItemIndent)
   let s:md_enableWcwidth = get(a:var, 'enableWcwidth', s:md_enableWcwidth)
endfunction

function! SpaceVim#layers#lang#markdown#plugins() abort
    let plugins = []
    call add(plugins, ['SpaceVim/vim-markdown',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['joker1007/vim-markdown-quote-syntax',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['mzlogin/vim-markdown-toc',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/mathjax-support-for-mkdp',{ 'on_ft' : 'markdown'}])
    call add(plugins, ['iamcco/markdown-preview.vim',{ 'on_ft' : 'markdown'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#markdown#config() abort
    let g:markdown_minlines = 100
    let g:markdown_syntax_conceal = 0
    let g:markdown_enable_mappings = 0
    let g:markdown_enable_insert_mode_leader_mappings = 0
    let g:markdown_enable_spell_checking = 0
    let g:markdown_quote_syntax_filetypes = {
                \ "vim" : {
                \   "start" : "\\%(vim\\|viml\\)",
                \},
                \}
    augroup SpaceVim_lang_markdown
        au!
        autocmd BufEnter *.md call s:mappings()
    augroup END
    if executable('firefox')
        let g:mkdp_path_to_chrome= get(g:, 'mkdp_path_to_chrome', 'firefox')
    endif
    let remarkrc = s:generate_remarkrc()
    let g:neoformat_enabled_markdown = ['remark']
    let g:neoformat_markdown_remark = {
                \ 'exe': 'remark',
                \ 'args': ['--no-color', '--silent'] + (empty(remarkrc) ?  [] : ['-r', remarkrc]),
                \ 'stdin': 1,
                \ }
endfunction

function! s:mappings() abort
    if !exists('g:_spacevim_mappings_space')
        let g:_spacevim_mappings_space = {}
    endif
    let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','ft'], "Tabularize /|", 'Format table under cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','p'], "MarkdownPreview", 'Real-time markdown preview', 1)
endfunction

function! s:generate_remarkrc() abort
    let conf = [
                \ 'module.exports = {',
                \ '  settings: {',
                \ ]
    " TODO add settings
    call add(conf, "    listItemIndent: '" . s:md_listItemIndent . "',")
    if s:md_enableWcwidth
        call add(conf, "    stringLength: require('wcwidth'),")
    endif
    call add(conf, '  },')
    call add(conf, '  plugins: [')
    " TODO add plugins
    call add(conf, "    require('remark-frontmatter'),")
    call add(conf, '  ]')
    call add(conf, '};')
    let f  = tempname() . '.js'
    call writefile(conf, f)
    return f
endfunction


