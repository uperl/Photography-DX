package Photography::DX;

use 5.022;
use Carp qw( croak );
use Moo 2.0;

use feature 'signatures';
no warnings 'experimental::signatures';
use feature 'refaliasing';
no warnings 'experimental::refaliasing';

use namespace::clean;

# ABSTRACT: Encode/decode DX film codes
# VERSION

=encoding utf-8

=head1 SYNOPSIS

 use Photography::DX;
 
 my $film = Photography::DX->new(
   speed     => 100,
   length    => 36,
   tolerance => 2,
 );

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 speed

The film speed.  Must be a legal ISO arithmetic value.  Defaults to ISO 100.

Special values 1-6 denote "custom" values.

=cut

my %log = qw(
  25   15
  32   16
  40   17
  50   18
  64   19
  80   20
  100  21
  125  22
  160  23
  200  24
  250  25
  320  26
  400  27
  500  28
  640  29
  800  30
  1000 31
  1250 32
  1600 33
  2000 34
  2500 35
  3200 36
  4000 37
  5000 38
);

has speed => (
  is      => 'ro',
  lazy    => 1,
  default => sub { 100 },
  isa     => sub {
    die "speed must be a legal ISO arithmetic film speed value between 25 and 5000 or 1-6 (indicating custom film speed values)"
      unless defined $_[0] && (defined $log{$_[0]} || $_[0] =~ /^[1-6]$/);
  },
);

=head2 length

The length of the film in 32x24mm exposures.  Must be one of undef (denotes "other"),
12, 20, 24, 36, 48, 60, 72.

=cut

has length => (
  is      => 'ro',
  lazy    => 1,
  default => sub { undef },
  isa     => sub {
    die "length must be one of undef, 12, 20, 24, 36, 48, 60 or 72"
      unless (!defined $_[0]) || ($_[0] =~ /^(12|20|24|36|48|60|72)$/);
  },
);

=head2 tolerance

The exposure latitude of the film.  Must be one of:

=over 4

=item 0.5 for ±0.5 stop

=item 1 for ±1 stop

=item 2 for +2 to -1 stops

=item 2 for +3 to -1 stops

=back

=cut

has tolerance => (
  is      => 'ro',
  lazy    => 1,
  default => sub { 2 },
  isa     => sub {
    die "tolerance must be one of .5, 1, 2, 3"
      unless (defined $_[0]) && ($_[0] =~ /^(0.5|1|2|3)$/);
  },
);

=head1 METHODS

=head2 is_custom_speed

Returns true if the film speed is a custom film speed.

=cut

sub is_custom_speed ($self)
{
  return $self->speed == 1
  ||     $self->speed == 2
  ||     $self->speed == 3
  ||     $self->speed == 4
  ||     $self->speed == 5
  ||     $self->speed == 6;
}

=head2 logarithmic_speed

Returns the ISO logarithmic scale speed of the film (also known as DIN).

=cut

sub logarithmic_speed ($self)
{
  my $din = $log{$self->speed};
  croak "Unable to determine ISO logarithmic scale speed for custom " . $self->speed
    unless defined $din;
  return $din; # no loger a performance penalty in 5.20!
}

=head1 CAVEATS

In digital photography, DX also refers to Nikon's crop sensor format DSLRs.

=cut

1;
