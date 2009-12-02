if exists("b:current_syntax")
    finish
endif

syntax match todoItemID /^\d\+/ contained
syntax match todoItemPriorityA /(A)/ contained
syntax match todoItemPriorityB /(B)/ contained
syntax match todoItemPriorityC /(C)/ contained
syntax match todoItemPriority /([D-Z])/ contained
syntax match todoItemProject /+[^ ]\+/ contained
syntax match todoItemContext /@[^ ]\+/ contained
syntax match todoItemText /^\d\+ .*$/ contains=todoItemID,todoItemProject,todoItemContext,todoItemPriority,todoItemPriorityA,todoItemPriorityB,todoItemPriorityC
syntax match todoItemSeparator +--+
syntax match todoItemSummary /^TODO:.*/

hi link todoItemID Statement
hi link todoItemProject Identifier
hi link todoItemContext Type
hi link todoItemText Comment

hi link todoItemPriority Constant
hi link todoItemPriorityA Todo
hi link todoItemPriorityB Visual
hi link todoItemPriorityC DiffAdd

hi link todoItemSeparator Ignore
hi link todoItemSummary Ignore

let b:current_syntax = "todo-list"
