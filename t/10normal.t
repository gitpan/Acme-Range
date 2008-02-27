#!/usr/bin/env perl
use warnings;
use strict;

# Test that using the module doesn't break normal use of glob

use Test::More tests => 1;

use Acme::Range;

use File::Glob;

is(<.>, '.', 'regular globbing works' );
