use strict;
use Test::More tests => 3;

use_ok('SMS::Send');
use_ok('SMS::Send::US::SprintPCS');

my @drivers = SMS::Send->installed_drivers;
is( scalar( grep { $_ eq 'US::SprintPCS' } @drivers ),
    1, 'Found installed driver US::SprintPCS' );
