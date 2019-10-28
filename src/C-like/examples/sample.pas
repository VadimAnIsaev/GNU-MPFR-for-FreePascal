{ This is the example given and commented on the MPFR web site:
    http://www.mpfr.org/sample.html
 

Copyright 1999-2004, 2006-2018 Free Software Foundation, Inc.
Contributed by the AriC and Caramba projects, INRIA.

This file is part of the GNU MPFR Library.

The GNU MPFR Library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

The GNU MPFR Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with the GNU MPFR Library; see the file COPYING.LESSER.  If not, see
http://www.gnu.org/licenses/ or write to the Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
}

Uses mpfr;

Var
  i: LongWord;
  s, t, u: mpfr_t;

Begin
  mpfr_init2 (@t, 200);
  mpfr_set_d (@t, 1.0, MPFR_RNDD);
  mpfr_init2 (@s, 200);
  mpfr_set_d (@s, 1.0, MPFR_RNDD);
  mpfr_init2 (@u, 200);
  For i := 1 To 100 Do
  Begin
    mpfr_mul_ui (@t, @t, i, MPFR_RNDU);
    mpfr_set_d (@u, 1.0, MPFR_RNDD);
    mpfr_div (@u, @u, @t, MPFR_RNDD);
    mpfr_add (@s, @s, @u, MPFR_RNDD);
  End;
  WriteLn('Sum is ');
  mpfr_printf ('%.40Rf'#10, @s);

  mpfr_clear (@s);
  mpfr_clear (@t);
  mpfr_clear (@u);

End.
