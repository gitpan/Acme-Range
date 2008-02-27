#!/usr/bin/env perl
use warnings;
use strict;

use vars qw( $VERSION );

# $Id: Makefile.PL 32 2007-12-14 22:43:23Z abuse $
$VERSION = do {
  my @r=(q$Revision: 32 $=~/\d+/g); sprintf "%d."."%03d"x$#r,@r
};

use ExtUtils::MakeMaker;
eval "use ExtUtils::MakeMaker::Coverage";
warn "Note: ExtUtils::MakeMaker::Coverage not available, can't 'make testcover'\n"
  if $@;

WriteMakefile(
              ABSTRACT => 'Turns a long list into an easy-to-navigate tree',
	      NAME     => 'Acme::Range',
	      VERSION  => '0.004',
              PREREQ_PM => {
                            'Regexp::Common' => undef,
                           },
	     );
