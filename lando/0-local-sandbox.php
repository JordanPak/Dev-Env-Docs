<?php
/**
 * Local dependencies/sandbox
 *
 * @author  Jordan Pakrosnis <jpakrosnis@pmc.com>
 */

$autoload_file = getenv( 'HOME' ) . '/site-host-dependencies/index.php';

if ( file_exists( $autoload_file ) ) {
	require_once $autoload_file;
}
