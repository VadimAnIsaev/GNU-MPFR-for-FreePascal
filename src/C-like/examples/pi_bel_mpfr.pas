{************************************************************
 Вычисление числа PI по формуле Фабриса Беллара
 
*************************************************************}
{$mode objfpc}{$H+}
program pi_bel_gmp1;
Uses SysUtils, DateUtils, mpfr;

Var
  pi_bellard: mpfr_t;
  m1, m2, m3, m4, m5, m6, m7, m8: mpfr_t;
  tmp_1, tmp1,tmp2,tmp3,tmp5,tmp7,tmp9: mpfr_t;
  t1, t2: mpfr_t;
  startt, endt: TDateTime;
  k: longword;

Begin
  startt:=Now;
  mpfr_set_default_prec(128);
  
  mpfr_init_set_str(@pi_bellard, '0.0', 10, MPFR_RNDD);
  
  mpfr_init_set_str(@tmp_1, '-1.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp1, '1.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp2, '2.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp3, '3.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp5, '5.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp7, '7.0', 10, MPFR_RNDD);
  mpfr_init_set_str(@tmp9, '9.0', 10, MPFR_RNDD);
  
  mpfr_inits(@m1, @m2, @m3, @m4, @m5, @m6, @m7, @m8, mpfr_ptr(0));
  mpfr_inits(@t1, @t2, mpfr_ptr(0));
  
  For k:=0 To 20000000 Do
  Begin
    mpfr_pow_ui(@t1, @tmp_1, k, MPFR_RNDD);
    mpfr_pow_ui(@t2, @tmp2, (10*k), MPFR_RNDD);
    mpfr_div(@m1, @t1, @t2, MPFR_RNDD);
    
    mpfr_pow_ui(@t1, @tmp2, 5, MPFR_RNDD);
    mpfr_neg(@t1, @t1, MPFR_RNDD);
    mpfr_add_ui(@t2, @tmp1, 4*k, MPFR_RNDD);
    mpfr_div(@m2, @t1, @t2, MPFR_RNDD);
    
    mpfr_add_ui(@t2, @tmp3, 4*k, MPFR_RNDD);
    mpfr_div(@m3, @tmp1, @t2, MPFR_RNDD);
    
    mpfr_pow_ui(@t1, @tmp2, 8, MPFR_RNDD);
    mpfr_add_ui(@t2, @tmp1, 10*k, MPFR_RNDD);
    mpfr_div(@m4, @t1, @t2, MPFR_RNDD);
    
    mpfr_pow_ui(@t1, @tmp2, 6, MPFR_RNDD);
    mpfr_add_ui(@t2, @tmp3, 10*k, MPFR_RNDD);
    mpfr_div(@m5, @t1, @t2, MPFR_RNDD);
    
    mpfr_pow_ui(@t1, @tmp2, 2, MPFR_RNDD);
    mpfr_add_ui(@t2, @tmp5, 10*k, MPFR_RNDD);
    mpfr_div(@m6, @t1, @t2, MPFR_RNDD);
    
    mpfr_pow_ui(@t1, @tmp2, 2, MPFR_RNDD);
    mpfr_add_ui(@t2, @tmp7, (10*k), MPFR_RNDD);
    mpfr_div(@m7, @t1, @t2, MPFR_RNDD);
    
    mpfr_add_ui(@t2, @tmp9, 10*k, MPFR_RNDD);
    mpfr_div(@m8, @tmp1, @t2, MPFR_RNDD);
    
    mpfr_sub(@t1, @m2, @m3, MPFR_RNDD);
    mpfr_add(@t1, @t1, @m4, MPFR_RNDD);
    mpfr_sub(@t1, @t1, @m5, MPFR_RNDD);
    mpfr_sub(@t1, @t1, @m6, MPFR_RNDD);
    mpfr_sub(@t1, @t1, @m7, MPFR_RNDD);
    mpfr_add(@t1, @t1, @m8, MPFR_RNDD);
    mpfr_mul(@t2, @m1, @t1, MPFR_RNDD);
    mpfr_add(@pi_bellard, @pi_bellard, @t2, MPFR_RNDD);
  end;
  mpfr_mul(@t1, @pi_bellard, @tmp1, MPFR_RNDU);
  mpfr_pow_ui(@t2, @tmp2, 6, MPFR_RNDD);
  mpfr_div(@pi_bellard, @t1, @t2, MPFR_RNDD);

  endt := Now;

  mpfr_printf('%40.38Rf'#10, @pi_bellard);
  WriteLn('Время: ', SecondsBetween(endt, startt), ' секунд');
  WriteLn('3,14159265358979323846264338327950288');

  mpfr_clear(@pi_bellard);
  
  mpfr_clears(@tmp_1, @tmp1, @tmp2, @tmp3, @tmp5, @tmp7, @tmp9, mpfr_ptr(0));
  mpfr_clears(@m1, @m2, @m3, @m4, @m5, @m6, @m7, @m8, mpfr_ptr(0));
  mpfr_clears(@t1, @t2, mpfr_ptr(0));
end.
