# --------------------------------------------------------
# Start SSH agent in Cloudways server
#
# Add this .bash_aliases file to master user directory.
# --------------------------------------------------------

# Get existing SSH agent
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
	echo "Initializing new SSH agent..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	/usr/bin/ssh-add;
}

# Source SSH settings, if applicable
function get_agent {
	if [ -f "${SSH_ENV}" ]; then
		. "${SSH_ENV}" > /dev/null
		#ps ${SSH_AGENT_PID} doesn't work under cywgin
		ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
			start_agent;
		}
	else
		start_agent;
	fi
}
get_agent;
