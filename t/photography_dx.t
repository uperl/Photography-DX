use strict;
use warnings;
use Test::More;
use Photography::DX;

subtest speed => sub {
  my $film = Photography::DX->new;
  is $film->speed, 100, 'Default film speed is ISO 100';
  ok !$film->is_custom_speed, 'film is not custom';
  is $film->logarithmic_speed, 21, 'log film speed 21';

  $film = Photography::DX->new(speed => 200);
  is $film->speed, 200, 'set non default film speed';
  ok !$film->is_custom_speed, 'film is not custom';
  is $film->logarithmic_speed, 24, 'log film speed 24';

  $film = Photography::DX->new(speed => 3);
  is $film->speed, 3, 'set custom film speed';
  ok $film->is_custom_speed, 'film is custom';
  eval { $film->logarithmic_speed };
  my $error = $@;
  like "$error", qr/Unable to determine ISO logarithmic scale speed for custom/, "log film speed with custom value throws exception";

  eval { Photography::DX->new(speed => 12) };
  $error = $@;
  like "$error", qr/speed must be a legal ISO arithmetic film/, 'bad film speed throws exception';
  note "error=$error";
};

subtest length => sub {
  my $film = Photography::DX->new;
  is $film->length, undef, 'length is undef by default';

  $film = Photography::DX->new(length => undef);
  is $film->length, undef, 'length assign to undef okay';

  $film = Photography::DX->new(length => 24);
  is $film->length, 24, 'length assign to 24 okay';

  $film = Photography::DX->new(length => 36);
  is $film->length, 36, 'length assign to 36 okay';

  eval { Photography::DX->new(length => 900) };
  my $error = $@;
  like "$error", qr/length must be one of/, 'bad film speed throws exception';
  note "error=$error";
};

subtest tolerance => sub {
  my $film = Photography::DX->new;
  is $film->tolerance, 2, 'tolerance is 2 by default';

  $film = Photography::DX->new(tolerance => 0.5);
  is $film->tolerance, 0.5, 'tolerance 0.5 okay';

  $film = Photography::DX->new(tolerance => 3);
  is $film->tolerance, 3, 'tolerance 3 okay';

  eval { Photography::DX->new(tolerance => 900) };
  my $error = $@;
  like "$error", qr/tolerance must be one of/, 'bad film speed throws exception';
  note "error=$error";
};

subtest 'contacts 1' => sub {
  is(Photography::DX->new(speed => 400)->contacts_row_1, '100110', 'okay for speed 400');
  is(Photography::DX->new(speed => 5)->contacts_row_1,   '100100', 'okay for custom 5');

  is(Photography::DX->new(contacts_row_1 => '100110')->speed, 400, 'okay for speed 400 (reverse)');
  is(Photography::DX->new(contacts_row_1 => '100100')->speed, 5,   'okay for custom 5 (reverse)');
};

subtest 'contacts 2' => sub {
  is(Photography::DX->new(length => 24, tolerance => 0.5)->contacts_row_2, '111000', 'okay for length 24 tolerance 0.5');
  is(Photography::DX->new(length => 36, tolerance => 3.0)->contacts_row_2, '100111', 'okay for length 36 tolerance 3  ');

  my $film1 = Photography::DX->new(contacts_row_2 => '111000');
  is $film1->length,     24, 'okay length 24 (reverse)';
  is $film1->tolerance, 0.5, 'okay tolerance 0.5 (reverse)';

  my $film2 = Photography::DX->new(contacts_row_2 => '100111');
  is $film2->length,    36, 'okay length 36 (reverse)';
  is $film2->tolerance, 3,  'okay tolerance 3 (reverse)';
};

done_testing;
