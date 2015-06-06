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
 
 # print out the layout of contacts
 # on the roll of film as a series
 # of 1s and 0s:
 print $film->contacts_row_1, "\n";
 print $film->contacts_row_2, "\n";

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 speed

The film speed.  Must be a legal ISO arithmetic value between 25 and 5000.  Defaults to ISO 100.

Special values 1-8 denote "custom" values.

=cut

my %log;
my %speed;

has speed => (
  is      => 'ro',
  lazy    => 1,
  default => sub { 100 },
  isa     => sub {
    die "speed must be a legal ISO arithmetic film speed value between 25 and 5000 or 1-8 (indicating custom film speed values)"
      unless defined $_[0] && (defined $log{$_[0]} || $_[0] =~ /^[1-8]$/);
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
    die "tolerance must be one of 0.5, 1, 2, 3"
      unless (defined $_[0]) && ($_[0] =~ /^(0.5|1|2|3)$/);
  },
);

=head1 METHODS

=head2 contacts_row_1

Returns the contact layout as a string of 1s and 0s for the first row
of electrical contacts.  1 represents a metal contact, 0 represents the
lack of metal.

=cut

sub contacts_row_1 ($self)
{
  return $speed{$self->speed};
}

=head2 contacts_row_2

Returns the contact layout as a string of 1s and 0s for the second row
of electrical contacts.  1 represents a metal contact, 0 represents the
lack of metal.

=cut

my %length = (
  undef => '000',
  12    => '100',
  20    => '010',
  24    => '110',
  36    => '001',
  48    => '101',
  60    => '011',
  72    => '111',
);

my %tolerance = qw(
  0.5  00
  1    10
  2    01
  3    11
);

sub contacts_row_2 ($self)
{
  return '1' . $length{$self->length} . $tolerance{$self->tolerance};
}

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
  ||     $self->speed == 6
  ||     $self->speed == 7
  ||     $self->speed == 8;
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

=head1 SEE ALSO

=over 4

=item L<Photography::EV>

=item L<http://en.wikipedia.org/wiki/DX_encoding>

=back

=cut

while(<DATA>)
{
  if(/^\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+$/)
  {
    $log{$1} = $2;
    $speed{$1} = $3;
  }
  elsif(/^\s+([0-9]+)\s+-\s+([0-9]+)\s+$/)
  {
    $speed{$1} = $2;
  }
}

1;

__DATA__
# ISO  DIN  code
  25   15   100010
  32   16   100001
  40   17   100011
  50   18   110010
  64   19   110001
  80   20   110011
  100  21   101010
  125  22   101001
  160  23   101011
  200  24   111010
  250  25   111001
  320  26   111011
  400  27   100110
  500  28   100101
  640  29   100111
  800  30   110110
  1000 31   110101
  1250 32   110111
  1600 33   101110
  2000 34   101101
  2500 35   101111
  3200 36   111110
  4000 37   111101
  5000 38   111111
  1    -    100000
  2    -    110000
  3    -    101000
  4    -    111000
  5    -    100100
  6    -    110100
  7    -    101100
  8    -    111100

400 Tmax                  010804 100110:100111
Provia 100F               005574 101010:100100
Fujicolor Press 800       105614 110110:100111
Kodak Professional 100UC  015264 101010:100110
