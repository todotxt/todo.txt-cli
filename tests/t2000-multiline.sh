#!/bin/sh

test_description='Multi-line functionality'

. ./test-lib.sh

## Replace test
# Create the expected file
echo "1: smell the cheese
replaced with
1: eat apples eat oranges drink milk">$HOME/expect.multi

test_expect_success 'multiline squash item replace' '
(
# Prepare single line todo file
cat /dev/null > $HOME/todo.txt
"$HOME/bin/todo.sh" add smell the cheese

# Run replace
"$HOME/bin/todo.sh" replace 1 "eat apples
eat oranges
drink milk" > $HOME/output.multi

# Test output against expected
diff "$HOME/output.multi" "$HOME/expect.multi"
if [ $? -ne 0 ]; then
  exit 1
else
  exit 0
fi
)
'

## Add test
# Create the expected file
echo "TODO: 'eat apples eat oranges drink milk' added on line 2.">$HOME/expect.multi

test_expect_success 'multiline squash item add' '
(
# Prepare single line todo file
cat /dev/null > $HOME/todo.txt
"$HOME/bin/todo.sh" add smell the cheese

# Run add
"$HOME/bin/todo.sh" add "eat apples
eat oranges
drink milk" > $HOME/output.multi

# Test output against expected
diff "$HOME/output.multi" "$HOME/expect.multi"
if [ $? -ne 0 ]; then
  exit 1
else
  exit 0
fi
)
'

## Append test
# Create the expected file
echo "1: smell the cheese eat apples eat oranges drink milk">$HOME/expect.multi

test_expect_success 'multiline squash item append' '
(
# Prepare single line todo file
cat /dev/null > $HOME/todo.txt
"$HOME/bin/todo.sh" add smell the cheese

# Run append
"$HOME/bin/todo.sh" append 1 "eat apples
eat oranges
drink milk" > $HOME/output.multi

# Test output against expected
diff "$HOME/output.multi" "$HOME/expect.multi"
if [ $? -ne 0 ]; then
  exit 1
else
  exit 0
fi
)
'

## Prepend test
# Create the expected file
echo "1: eat apples eat oranges drink milk smell the cheese">$HOME/expect.multi

test_expect_success 'multiline squash item prepend' '
(
# Prepare single line todo file
cat /dev/null > $HOME/todo.txt
"$HOME/bin/todo.sh" add smell the cheese

# Run prepend
"$HOME/bin/todo.sh" prepend 1 "eat apples
eat oranges
drink milk" > $HOME/output.multi

# Test output against expected
diff "$HOME/output.multi" "$HOME/expect.multi"
if [ $? -ne 0 ]; then
  exit 1
else
  exit 0
fi
)
'

## Multiple line addition
# Create the expected file
echo "TODO: 'eat apples' added on line 2." > $HOME/expect.multi
echo "TODO: 'eat oranges' added on line 3." >>$HOME/expect.multi
echo "TODO: 'drink milk' added on line 4." >> $HOME/expect.multi

test_expect_success 'actual multiline add' '
(
# Run addm
"$HOME/bin/todo.sh" addm "eat apples
eat oranges
drink milk" > $HOME/output.multi

# Test output against expected
diff "$HOME/output.multi" "$HOME/expect.multi"
if [ $? -ne 0 ]; then
  exit 1
else
  exit 0
fi
)
'

test_done
