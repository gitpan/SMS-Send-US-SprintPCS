## no critic (PodSections,PodAtEnd,UseWarnings,BoundaryMatching,ExtendedFormatting)
package SMS::Send::US::SprintPCS;

# $Revision$
# $Source$
# $Date$

=head1 NAME

SMS::Send::US::SprintPCS - An SMS::Send driver for the messaging.sprintpcs.com website

=head1 SYNOPSIS

  # Get the sender, there is no login
  my $sender = SMS::Send->new('US::SprintPCS');
  
  # Send a message to ourself
  my $sent = $sender->send_sms(
      text => 'Messages have a limit of 160 chars',
      to   => '555-555-5555',
  );

  # Did it send?
  if ( $sent ) {
      print "Sent text message\n";
  }
  else {
      print "Text message failed\n";
  }

=head1 DESCRIPTION

L<SMS::Send::US::SprintPCS> is an regional L<SMS::Send> driver for the
US that delivers messages via the L<http://messaging.sprintpcs.com>
web site.

This allows you to send SMS messages to anyone with a SprintPCS
phone. The recipient will pay for the message as usual.

=head2 Preparing to Use This Driver

This driver requires acceptance of a disclaimer and conditions of use
form.

You C<must> manually accept this disclaimer and conditions before you
will be able to use this driver.

While we certainly could make the driver do it for you, acceptance of
the terms of use implies you understand the cost structure and rules
surrounding the use of SprintPCS text messaging.

=head2 Disclaimer

Other than dieing on encountering the terms of use form, no other
protection is provided, and the authors of this driver take no
responsibility for any costs accrued on your phone bill by using this
module.

Using this driver will cost you money. B<YOU HAVE BEEN WARNED>

=head1 METHODS

=over

=cut

use strict;
use vars qw( @ISA $VERSION );

BEGIN {
    @ISA     = 'SMS::Send::Driver';
    $VERSION = '0.03';
}
use SMS::Send;
use WWW::Mechanize;
use Carp qw( croak );

# Starting URI
my $FORM = 'http://messaging.sprintpcs.com/textmessaging/compose';

# Detection regexs
my $RE_INVALID
    = qr/(?:Please check information|Invalid fields|is required|is invalid)/i;

#####################################################################
# Constructor

=item C<SMS::Send::US::SprintPCS->new()>

  # Create a new sender using this driver
  my $sender = SMS::Send->new( 'US::SprintPCS' );

=cut

sub new {
    my $class   = shift @_;
    my %private = @_;

    # Create our mechanise object
    my $mech = WWW::Mechanize->new;

    # Create the object
    my $self = bless {
        mech    => $mech,
        private => \%private,
    }, $class;

    return $self;
}

=item C<< $sender->send_sms( ... ) >>

The C<< $sender->send_sms( ... ) >> method accepts two named
parameters, C<text> and C<to>.

ANY use may result in charges on the recipients phone bill, and you
should use this software with care. The author takes no responsibility
for any such charges accrued.

=cut

sub send_sms {
    my $self   = shift;
    my %params = @_;

    # Get the message and destination
    my $message   = $self->_MESSAGE( delete $params{text} );
    my $recipient = $self->_TO( delete $params{to} );

    # Fill out the message form
    my $form = $self->_get_form;
    $form->value( phoneNumber => $recipient );
    $form->value( message     => $message );

    # Send the form
    $self->{mech}->submit();
    if ( not $self->{mech}->success ) {
        croak 'HTTP request returned failure when sending SMS request';
    }

    # Fire-and-forget, we don't know for sure.
    return 1;
}

#####################################################################
# Support Functions

sub _get_form {
    my $self = shift @_;

    # Get to the Web2TXT form
    $self->{mech}->get($FORM);
    if ( not $self->{mech}->content =~ /Compose a Text Message/ ) {
        croak 'Could not locate the SMS send form';
    }
    $self->{mech}->form_name('composeForm');
    return $self->{mech}->current_form;
}

sub _MESSAGE {
    my ( $self, $message ) = @_;

    if ( not length $message <= 160 ) {
        croak 'Message length limit is 160 characters';
    }
    return $message;
}

sub _TO {
    my ( $self, $to ) = @_;

    # 123-123-1234 -> 1231231234
    $to =~ s/[[:punct:]]+//g;

    if ( not $to =~ /\A\d{10}\z/ ) {
        croak "$to is not a ten digit US phone number";
    }

    return $to;
}

=back

=head1 AUTHOR

Joshua ben Jore, C<< <jjore at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-sms-send-us-sprintpcs at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=SMS-Send-US-SprintPCS>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc SMS::Send::US::SprintPCS

You can also look for information at:

=over

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SMS-Send-US-SprintPCS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SMS-Send-US-SprintPCS>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SMS-Send-US-SprintPCS>

=item * Search CPAN

L<http://search.cpan.org/dist/SMS-Send-US-SprintPCS>

=back

=head1 ACKNOWLEDGEMENTS

L<ADAMK>'s L<SMS::Send::AU::MyVodafone> for the inspiration and source
for liberal copying.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Joshua ben Jore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of SMS::Send::US::SprintPCS
