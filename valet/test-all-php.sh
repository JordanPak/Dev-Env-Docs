#==============================#
#  RUN ALL PHPUNIT TESTS       #
#  Usage: zsh test-all-php.sh  #
#==============================#

# Get phpunit9 function
source ~/.zshrc

echo ""
echo "Running all PHPUnit tests in $PWD"
echo ""

for dir in ./*; do
	# Make sure it's a directory, not a README or something.
	if [ -d "$dir" ]; then

		# Enter the directory.
		cd "$dir"

		# Check for phpunit.xml
		if [ -f ./phpunit.xml ]; then

			# Run PHPUnit
			phpunit9
		fi

		cd - > /dev/null
	fi
done
