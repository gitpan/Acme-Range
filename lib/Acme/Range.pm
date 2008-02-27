package Acme::Range;
use warnings;
use strict;

use Regexp::Common;

use File::Glob qw( csh_glob );
my $csh_glob = \&csh_glob;

my $num = $RE{num}{int};

sub _range($$$) {
  my($first, $last, $step) = @_;
  my @range;
  if($step > 0) {
    while($first <= $last) {
      push @range, $first;
      $first += $step;
    }
  } elsif($step < 0) {
    while($first >= $last) {
      push @range, $first;
      $first += $step;
    }
  } else {
    return [ $first ];
  }
  return \@range;
}

sub _try_range {
  for(shift) {
    if(/^($num)\.\.($num)$/) {
      if($1 < $2) {
        return _range $1, $2, 1;
      } elsif ($1 > $2) {
        return _range $1, $2, -1;
      } else {
        return [ $1 ];
      }
    } elsif(/^($num),($num)\.\.($num)$/) {
      return _range $1, $3, $2-$1;
    } elsif(/^($num)\.\.($num),($num)$/) {
      return _range $1, $3, $3-$2;
    } else {
      return;
    }
  }
};

sub _new_csh_glob {
  my($glob_pattern) = @_;
  my $range = _try_range($glob_pattern);
  return @$range if $range;
  goto &$csh_glob;
};

no warnings;

*File::Glob::csh_glob = \&_new_csh_glob;
*CORE::GLOBAL::glob = \&File::Glob::csh_glob;

=head1 NAME

Acme::Range - Alternative to the range operator

=head1 SYNOPSIS

 use Acme::Range;

 foreach (<10..1>) {
   print "$_... ";
 }
 print "Lift-off!";

 sub my_keys(\%) {
   my @hash = %{ $_[0] };
  return @hash[ glob("0,2..$#hash") ];
 }

 sub my_values(\%) {
   my @hash = %{ $_[0] };
  return @hash[ glob("1,3..$#hash") ];
 }

=head1 DESCRIPTION

Have you ever wanted to abuse glob to do ranges that are not incrementing
integers? Well, put down that crack pipe and run away from this module.

This module overloads the glob() function and thus the C<E<lt>E<gt>>
operator to provide a range-like operator. This new glob operator takes the
following formats:

=over 4

=item C<A..Z>

Returns the integers between A and Z. If Z is lower than A, this will return
a reversed range. Thus C<E<lt>1..9E<gt>> is C<(1..9)> and C<E<lt>9..1E<gt>>
is C<(reverse 1..9)>.

=item C<A,B..Z>

Returns the integers between A and Z with a step such that the second value
is B. Thus C<E<lt>1,3..9E<gt>> is C<(1, 3, 5, 7, 9)>.

=item C<A..Y,Z>

Returns the integers between A and Z with a step such that the next to last
value is Y. Thus C<E<lt>1..7,9E<gt>> is C<(1, 3, 5, 7, 9)>.

=item Anything else

This will be globbed as before, e.g. <~> will return your home directory on
Unux.

=back

=head1 BUGS

Any code that uses this module is guaranteed to have a bug. Remove the line
beginning C<use Acme::Range> to fix it.

=head1 SEE ALSO

List::Maker, which turns out to have already existed before I wrote this.
You should probably use that if you don't find the whole concept highly
icky.

=head1 AUTHOR

All code and documentation by Peter Corlett <abuse@cabal.org.uk>.

=head1 COPYRIGHT

Copyright (C) 2008 Peter Corlett <abuse@cabal.org.uk>. All rights
reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SUPPORT / WARRANTY

This is free software. IT COMES WITHOUT WARRANTY OF ANY KIND.

=cut

1;
