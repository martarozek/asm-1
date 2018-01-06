#!/bin/bash

TESTS=(1 2 3 4 5 6 7)

TESTS_PATH=/home/mrozek/asm/game_of_life/tests
EXEC=/home/mrozek/asm/game_of_life/game_of_life

pushd $TESTS_PATH 1>/dev/null

for test in ${TESTS[@]}; do
	DF=$($EXEC < "$test.in" | diff -w "$test.out" -)

	if [ "$DF" ]; then
		echo -e "Test: "$test" - \033[0;31mFAIL\033[0m"
		echo $DF
	else
		echo -e "Test: "$test" - \033[0;32mOK\033[0m"
	fi
done

popd 1>/dev/null
