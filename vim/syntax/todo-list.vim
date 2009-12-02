if exists("b:current_syntax")
    finish
endif

syntax match todoItemID /^\d\+/ contained
syntax match todoItemProject /+[^ ]\+/ contained
syntax match todoItemContext /@[^ ]\+/ contained
syntax match todoItemText /^\d\+ .*$/ contains=todoItemID,todoItemProject,todoItemContext
syntax match todoItemSeparator +--+
syntax match todoItemSummary /^TODO:.*/

hi link todoItemID Statement
hi link todoItemProject SpecialKey
hi link todoItemContext Title
hi link todoItemText Comment
hi link todoItemSeparator Ignore
hi link todoItemSummary Ignore

let b:current_syntax = "todo-list"
