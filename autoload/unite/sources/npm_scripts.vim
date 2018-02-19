let s:save_cpo = &cpo
set cpo&vim

let s:source = {
  \ 'name': 'npm-scripts',
  \ 'description': 'candidates from package.json scripts'
  \ }

function! s:source.gather_candidates(args, context) abort
  if !filereadable('package.json')
    return []
  endif

  let package = join(readfile('package.json'), '')
  let package_as_json = json_decode(package)
  let scripts = get(package_as_json, 'scripts', {})
  let candidates = []

  for key in keys(scripts)
    let command = 'VimProcBang npm run ' . key . (empty(a:args) ? '' : ' ' . join(a:args, ' '))

    call add(candidates, {
      \ 'word': key,
      \ 'kind': 'command',
      \ 'action__command': command
      \ })
  endfor

  return candidates
endfunction

function! unite#sources#npm_scripts#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

