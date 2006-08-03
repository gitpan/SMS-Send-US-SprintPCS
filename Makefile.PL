use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'SMS::Send::US::SprintPCS',
    AUTHOR        => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/SMS/Send/US/SprintPCS.pm',
    ABSTRACT_FROM => 'lib/SMS/Send/US/SprintPCS.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More'     => 0,
        'SMS::Send'      => 0,
        'WWW::Mechanize' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'SMS-Send-US-SprintPCS-*' },
);
