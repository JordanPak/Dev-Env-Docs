# Usage: Put in .zshrc or something

# Local PHPUnit 9 (for Laravel Valet sites)
function phpunit9 {
	export PHPUNIT_BIN=$(which phpunit)
	export CURRENT_PROJECT_NAME=$(cut -d/ -f6 <<<"$(pwd)")
	export PMC_PHPUNIT_BOOTSTRAP=${HOME}/pmc/sites/${CURRENT_PROJECT_NAME}/wp-content/plugins/pmc-plugins/pmc-unit-test/bootstrap.php;
	export WP_TESTS_DIR=${HOME}/pmc/sites/${CURRENT_PROJECT_NAME}/tests/phpunit

	if [[ -f ${PHPUNIT_BIN} ]]; then
		echo "PHPUnit 9 libraries are set bro";
		echo ${PMC_PHPUNIT_BOOTSTRAP};
		echo ${WP_TESTS_DIR};
		${PHPUNIT_BIN} $@
	else
		echo "Could not locate PHPUnit 9 binary"
	fi
}

# Run phpunit9 in all subdirectories
alias phpunit9_all="zsh ~/test-all-php.sh"
