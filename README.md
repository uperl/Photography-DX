# Photography::DX

Encode/decode DX film codes

# SYNOPSIS

    use Photography::DX;
    
    my $film = Photography::DX->new(
      speed     => 100,
      length    => 36,
      tolerance => 2,
    );

# DESCRIPTION

# ATTRIBUTES

## speed

The film speed.  Must be a legal ISO arithmetic value.  Defaults to ISO 100.

Special values 1-6 denote "custom" values.

## length

The length of the film in 32x24mm exposures.  Must be one of undef (denotes "other"),
12, 20, 24, 36, 48, 60, 72.

## tolerance

The exposure latitude of the film.  Must be one of:

- 0.5 for ±0.5 stop
- 1 for ±1 stop
- 2 for +2 to -1 stops
- 2 for +3 to -1 stops

# METHODS

## is\_custom\_speed

Returns true if the film speed is a custom film speed.

## logarithmic\_speed

Returns the ISO logarithmic scale speed of the film (also known as DIN).

# CAVEATS

In digital photography, DX also refers to Nikon's crop sensor format DSLRs.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
