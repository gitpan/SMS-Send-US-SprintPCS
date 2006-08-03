use strict;
use Test::More tests => 3;
use SMS::Send;

my $sender = SMS::Send->new('US::SprintPCS');

isa_ok( $sender, 'SMS::Send' );
isa_ok( $sender->_OBJECT_, 'SMS::Send::US::SprintPCS' );

ok( $sender->_OBJECT_->_get_form, 'Got to the messaging.sprintpcs.com' );
