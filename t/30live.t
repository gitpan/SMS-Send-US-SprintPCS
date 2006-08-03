use strict;
use Test::More tests => 1;
use SMS::Send;

my $to   = $ENV{SMS_TO};
my $text = $ENV{SMS_TEXT} || 'Testing SMS::Send::US::SprintPCS';

SKIP: {
    if ( not( $to and $text ) ) {
        skip 'Live testing requires SMS_TO', 1;
    }

    my $sender = SMS::Send->new('US::SprintPCS');
    ok( $sender->send_sms(
            to   => $to,
            text => $text
        ),
        '->send_sms sends a live message ok'
    );
}
