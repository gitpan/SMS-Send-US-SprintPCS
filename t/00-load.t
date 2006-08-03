#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'SMS::Send::US::SprintPCS' );
}

diag( "Testing SMS::Send::US::SprintPCS $SMS::Send::US::SprintPCS::VERSION, Perl $], $^X" );
