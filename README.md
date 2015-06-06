# Photography::DX

Encode/decode DX film codes

# SYNOPSIS

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

# DESCRIPTION

This class represents a roll of 35mm film, and allows you to compute the
DX encoding contacts used by film cameras that automatically detect film
speed, the number of exposures and the exposure tolerance of the film
(most cameras actually use only the film speed for the DX encoding).

# CONSTRUCTOR

    my $film = Photography::DX->new;

In addition the attributes documented below you may pass into
the constructor:

- contacts\_row\_1

    The first row of contacts on the roll of film.  The speed
    will be computed from this value.

- contacts\_row\_2

    The second row of contacts on the roll of film.  The length
    and tolerance will be computed from this value.

# ATTRIBUTES

## speed

The film speed.  Must be a legal ISO arithmetic value between 25 and 5000.  Defaults to ISO 100.

Special values 1-8 denote "custom" values.

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

## contacts\_row\_1

Returns the contact layout as a string of 1s and 0s for the first row
of electrical contacts.  1 represents a metal contact, 0 represents the
lack of metal.

## contacts\_row\_2

Returns the contact layout as a string of 1s and 0s for the second row
of electrical contacts.  1 represents a metal contact, 0 represents the
lack of metal.

## is\_custom\_speed

Returns true if the film speed is a custom film speed.

## logarithmic\_speed

Returns the ISO logarithmic scale speed of the film (also known as DIN).

# CAVEATS

In digital photography, DX also refers to Nikon's crop sensor format DSLRs.

# SEE ALSO

- [Photography::EV](https://metacpan.org/pod/Photography::EV)
- [http://en.wikipedia.org/wiki/DX\_encoding](http://en.wikipedia.org/wiki/DX_encoding)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
