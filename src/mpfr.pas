{
    An header for the MPFR library
    Copyright (c) 2018 by Vadim Isaev

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

{$mode objfpc}{$h+}
{$packrecords c}
Unit mpfr;

interface

Uses gmp;

Const
  LIBMPFR = 'mpfr';
  
  MPFR_PREC_MIN   = 1;
  MPFR_PREC_MAX   = High(valsint);

  __MPFR_EXP_MAX  = valsint(valuint(-1) shr 1);
  __MPFR_EXP_NAN  = 1 - __MPFR_EXP_MAX;
  __MPFR_EXP_ZERO = 0 - __MPFR_EXP_MAX;
  __MPFR_EXP_INF  = 2 - __MPFR_EXP_MAX;

  MPFR_FLAGS_UNDERFLOW = 1;
  MPFR_FLAGS_OVERFLOW  = 2;
  MPFR_FLAGS_NAN       = 4;
  MPFR_FLAGS_INEXACT   = 8;
  MPFR_FLAGS_ERANGE    = 16;
  MPFR_FLAGS_DIVBY0    = 32;
  MPFR_FLAGS_ALL       = MPFR_FLAGS_UNDERFLOW or MPFR_FLAGS_OVERFLOW or MPFR_FLAGS_NAN or MPFR_FLAGS_INEXACT or MPFR_FLAGS_ERANGE or MPFR_FLAGS_DIVBY0;

  MPFR_EMAX_DEFAULT = valsint((longword(1) shl 30) - 1);
  MPFR_EMIN_DEFAULT = -MPFR_EMAX_DEFAULT;


Type
// Stack interface
  mpfr_kind_t = (
    MPFR_NAN_KIND     = 0,
    MPFR_INF_KIND     = 1,
    MPFR_ZERO_KIND    = 2,
    MPFR_REGULAR_KIND = 3
  ) ;

// Варманты округления значений
  mpfr_rnd_t = (
//    MPFR_RNDNA=-1,// round to nearest, with ties away from zero (mpfr_round) (к ближайшему целому, от нуля)(не рекомендуется)
    MPFR_RNDN=0,  // round to nearest, with ties to even (к ближайшему целому, с привязкой к чётному)
    MPFR_RNDZ,    // round toward zero (округление к нулю)
    MPFR_RNDU,    // round toward +Inf (к + бесконечности, округление вверх)
    MPFR_RNDD,    // round toward -Inf (к - бесконечности, округление вниз)
    MPFR_RNDA,    // round away from zero  (от нуля)
    MPFR_RNDF     // faithful rounding     (точное округление (экспериментально))
  );

// Free cache policy 
  mpfr_free_cache_t = (
    MPFR_FREE_LOCAL_CACHE  = 1,  // 1 << 0
    MPFR_FREE_GLOBAL_CACHE = 2   // 1 << 1
  );

  mpfr_exp_t      = valsint;
  mpfr_uexp_t     = valuint;
  mpfr_prec_t     = valsint;
  mpfr_uprec_t    = valuint;
  mpfr_sign_t     = integer;
  mpfr_flags_t    = longword;
  mpfr_exp_ptr    = ^mpfr_exp_t;
  Pint64	  = ^int64;

  // Структура длинного числа MPFR
  mpfr_t = record
    _mpfr_prec : mpfr_prec_t; // Мантисса
    _mpfr_sign : mpfr_sign_t; // Знак числа
    _mpfr_exp  : mpfr_exp_t;  // Экспонента
    _mpfr_d    : ^mp_limb_t;  // Указатель на хранилище
  end;
  mpfr_ptr    = ^mpfr_t;
  mpfr_srcptr = ^mpfr_t;



function mpfr_get_version(): PChar; cdecl; external LIBMPFR name 'mpfr_get_version';
function mpfr_get_patches(): PChar; cdecl; external LIBMPFR name 'mpfr_get_patches';
function mpfr_buildopt_tls_p(): integer; cdecl; external LIBMPFR name 'mpfr_buildopt_tls_p';
function mpfr_buildopt_float128_p(): integer; cdecl; external LIBMPFR name 'mpfr_buildopt_float128_p';
function mpfr_buildopt_decimal_p(): integer; cdecl; external LIBMPFR name 'mpfr_buildopt_decimal_p';
function mpfr_buildopt_gmpinternals_p(): integer; cdecl; external LIBMPFR name 'mpfr_buildopt_gmpinternals_p';
function mpfr_buildopt_sharedcache_p(): integer; cdecl; external LIBMPFR name 'mpfr_buildopt_sharedcache_p';
function mpfr_buildopt_tune_case(): PChar; cdecl; external LIBMPFR name 'mpfr_buildopt_tune_case';
function mpfr_get_emin(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emin';
function mpfr_set_emin(rop: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_set_emin';
function mpfr_get_emin_min(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emin_min';
function mpfr_get_emin_max(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emin_max';
function mpfr_get_emax(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emax';
function mpfr_set_emax(rop: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_set_emax';
function mpfr_get_emax_min(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emax_min';
function mpfr_get_emax_max(): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_emax_max';
procedure mpfr_set_default_rounding_mode(rop: mpfr_rnd_t); cdecl; external LIBMPFR name 'mpfr_set_default_rounding_mode';
function mpfr_get_default_rounding_mode(): mpfr_rnd_t; cdecl; external LIBMPFR name 'mpfr_get_default_rounding_mode';
function mpfr_print_rnd_mode(rop: mpfr_rnd_t): PChar; cdecl; external LIBMPFR name 'mpfr_print_rnd_mode';
procedure mpfr_clear_flags(); cdecl; external LIBMPFR name 'mpfr_clear_flags';
procedure mpfr_clear_underflow(); cdecl; external LIBMPFR name 'mpfr_clear_underflow';
procedure mpfr_clear_overflow(); cdecl; external LIBMPFR name 'mpfr_clear_overflow';
procedure mpfr_clear_divby0(); cdecl; external LIBMPFR name 'mpfr_clear_divby0';
procedure mpfr_clear_nanflag(); cdecl; external LIBMPFR name 'mpfr_clear_nanflag';
procedure mpfr_clear_inexflag(); cdecl; external LIBMPFR name 'mpfr_clear_inexflag';
procedure mpfr_clear_erangeflag(); cdecl; external LIBMPFR name 'mpfr_clear_erangeflag';
procedure mpfr_set_underflow(); cdecl; external LIBMPFR name 'mpfr_set_underflow';
procedure mpfr_set_overflow(); cdecl; external LIBMPFR name 'mpfr_set_overflow';
procedure mpfr_set_divby0(); cdecl; external LIBMPFR name 'mpfr_set_divby0';
procedure mpfr_set_nanflag(); cdecl; external LIBMPFR name 'mpfr_set_nanflag';
procedure mpfr_set_inexflag(); cdecl; external LIBMPFR name 'mpfr_set_inexflag';
procedure mpfr_set_erangeflag(); cdecl; external LIBMPFR name 'mpfr_set_erangeflag';
function mpfr_underflow_p(): integer; cdecl; external LIBMPFR name 'mpfr_underflow_p';
function mpfr_overflow_p(): integer; cdecl; external LIBMPFR name 'mpfr_overflow_p';
function mpfr_divby0_p(): integer; cdecl; external LIBMPFR name 'mpfr_divby0_p';
function mpfr_nanflag_p(): integer; cdecl; external LIBMPFR name 'mpfr_nanflag_p';
function mpfr_inexflag_p(): integer; cdecl; external LIBMPFR name 'mpfr_inexflag_p';
function mpfr_erangeflag_p(): integer; cdecl; external LIBMPFR name 'mpfr_erangeflag_p';
procedure mpfr_flags_clear(rop: mpfr_flags_t); cdecl; external LIBMPFR name 'mpfr_flags_clear';
procedure mpfr_flags_set(rop: mpfr_flags_t); cdecl; external LIBMPFR name 'mpfr_flags_set';
function mpfr_flags_test(rop: mpfr_flags_t): mpfr_flags_t; cdecl; external LIBMPFR name 'mpfr_flags_test';
function mpfr_flags_save(): mpfr_flags_t; cdecl; external LIBMPFR name 'mpfr_flags_save';
procedure mpfr_flags_restore(rop: mpfr_flags_t; p1: mpfr_flags_t); cdecl; external LIBMPFR name 'mpfr_flags_restore';
function mpfr_check_range(rop: mpfr_ptr; p1: integer; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_check_range';
procedure mpfr_init2(rop: mpfr_ptr; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_init2';
procedure mpfr_init(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_init';
procedure mpfr_clear(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_clear';
procedure mpfr_inits2(rop: mpfr_prec_t; p1: mpfr_ptr{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_inits2';
procedure mpfr_inits(rop: mpfr_ptr{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_inits';
procedure mpfr_clears(rop: mpfr_ptr{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_clears';
procedure mpfr_init_set_si(x: mpfr_ptr; y: valsint; rnd: mpfr_rnd_t);
procedure mpfr_init_set_ui(x: mpfr_ptr; y: valuint; rnd: mpfr_rnd_t);
procedure mpfr_init_set_d(x: mpfr_ptr; y: double; rnd: mpfr_rnd_t);
procedure mpfr_init_set_ld(x: mpfr_ptr; y: extended; rnd: mpfr_rnd_t);
procedure mpfr_init_set_z(x: mpfr_ptr; y: mpz_ptr; rnd: mpfr_rnd_t);
procedure mpfr_init_set_q(x: mpfr_ptr; y: mpq_ptr; rnd: mpfr_rnd_t);
procedure mpfr_init_set_f(x: mpfr_ptr; y: mpf_ptr; rnd: mpfr_rnd_t);

function mpfr_prec_round(rop: mpfr_ptr; p1: mpfr_prec_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_prec_round';
function mpfr_can_round(const rop: mpfr_ptr; p1: mpfr_exp_t; p2: mpfr_rnd_t; p3: mpfr_rnd_t; p4: mpfr_prec_t): integer; cdecl; external LIBMPFR name 'mpfr_can_round';
function mpfr_min_prec(const rop: mpfr_ptr): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_min_prec';
function mpfr_get_exp(const rop: mpfr_ptr): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_exp';
function mpfr_set_exp(rop: mpfr_ptr; p1: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_set_exp';
function mpfr_get_prec(const rop: mpfr_ptr): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_get_prec';
procedure mpfr_set_prec(rop: mpfr_ptr; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_prec';
procedure mpfr_set_prec_raw(rop: mpfr_ptr; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_prec_raw';
procedure mpfr_set_default_prec(rop: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_default_prec';
function mpfr_get_default_prec(): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_get_default_prec';
function mpfr_set_d(rop: mpfr_ptr; p1: double; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_d';
function mpfr_set_flt(rop: mpfr_ptr; p1: single; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_flt';
function mpfr_set_ld(rop: mpfr_ptr; p1: extended; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ld';
function mpfr_set_z(rop: mpfr_ptr; const p1: mpz_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_z';
function mpfr_set_z_2exp(rop: mpfr_ptr; const p1: mpz_ptr; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_z_2exp';
procedure mpfr_set_nan(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_set_nan';
procedure mpfr_set_inf(rop: mpfr_ptr; p1: integer); cdecl; external LIBMPFR name 'mpfr_set_inf';
procedure mpfr_set_zero(rop: mpfr_ptr; p1: integer); cdecl; external LIBMPFR name 'mpfr_set_zero';
function mpfr_set_f(rop: mpfr_ptr; const p1: mpf_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_f';
function mpfr_cmp_f(const rop: mpfr_ptr; const p1: mpf_ptr): integer; cdecl; external LIBMPFR name 'mpfr_cmp_f';
function mpfr_get_f(rop: mpf_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_get_f';
function mpfr_set_si(rop: mpfr_ptr; p1: int64; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_si';
function mpfr_set_ui(rop: mpfr_ptr; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ui';
function mpfr_set_si_2exp(rop: mpfr_ptr; p1: int64; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_si_2exp';
function mpfr_set_ui_2exp(rop: mpfr_ptr; p1: valsint; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ui_2exp';
function mpfr_set_q(rop: mpfr_ptr; const p1: mpq_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_q';
function mpfr_mul_q(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpq_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_q';
function mpfr_div_q(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpq_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_q';
function mpfr_add_q(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpq_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_q';
function mpfr_sub_q(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpq_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_q';
function mpfr_cmp_q(const rop: mpfr_ptr; const p1: mpq_ptr): integer; cdecl; external LIBMPFR name 'mpfr_cmp_q';
procedure mpfr_get_q(rop: mpq_ptr; const p1: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_get_q';
function mpfr_set_str(rop: mpfr_ptr; p1: PChar; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_str';
function mpfr_init_set_str(rop: mpfr_ptr; p1: PChar; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_init_set_str';
function mpfr_set4(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t; p3: integer): integer; cdecl; external LIBMPFR name 'mpfr_set4';
function mpfr_abs(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_abs';
function mpfr_set(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set';
function mpfr_neg(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_neg';
function mpfr_signbit(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_signbit';
function mpfr_setsign(rop: mpfr_ptr; const p1: mpfr_ptr; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_setsign';
function mpfr_copysign(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_copysign';
function mpfr_get_z_2exp(rop: mpz_ptr; const p1: mpfr_ptr): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_z_2exp';
function mpfr_get_flt(const rop: mpfr_ptr; p1: mpfr_rnd_t): single; cdecl; external LIBMPFR name 'mpfr_get_flt';
function mpfr_get_d(const rop: mpfr_ptr; p1: mpfr_rnd_t): double; cdecl; external LIBMPFR name 'mpfr_get_d';
function mpfr_get_ld(const rop: mpfr_ptr; p1: mpfr_rnd_t): extended; cdecl; external LIBMPFR name 'mpfr_get_ld';
function mpfr_get_d1(const rop: mpfr_ptr): double; cdecl; external LIBMPFR name 'mpfr_get_d1';
function mpfr_get_d_2exp(rop: Pint64; const p1: mpfr_ptr; p2: mpfr_rnd_t): double; cdecl; external LIBMPFR name 'mpfr_get_d_2exp';
function mpfr_get_ld_2exp(rop: Pint64; const p1: mpfr_ptr; p2: mpfr_rnd_t): extended; cdecl; external LIBMPFR name 'mpfr_get_ld_2exp';
function mpfr_frexp(rop: mpfr_exp_ptr; p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_frexp';
function mpfr_get_si(const rop: mpfr_ptr; p1: mpfr_rnd_t): int64; cdecl; external LIBMPFR name 'mpfr_get_si';
function mpfr_get_ui(const rop: mpfr_ptr; p1: mpfr_rnd_t): valsint; cdecl; external LIBMPFR name 'mpfr_get_ui';
function mpfr_get_str(rop: PChar; p1: mpfr_exp_ptr; p2: integer; p3: valuint; const p4: mpfr_ptr; p5: mpfr_rnd_t): PChar; cdecl; external LIBMPFR name 'mpfr_get_str';
function mpfr_get_z(rop: mpz_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_get_z';
procedure mpfr_free_str(rop: PChar); cdecl; external LIBMPFR name 'mpfr_free_str';
function mpfr_urandom(rop: mpfr_ptr; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_urandom';
function mpfr_grandom(rop: mpfr_ptr; p1: mpfr_ptr; p2: gmp_randstate_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_grandom';
function mpfr_nrandom(rop: mpfr_ptr; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_nrandom';
function mpfr_erandom(rop: mpfr_ptr; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erandom';
function mpfr_urandomb(rop: mpfr_ptr; p1: gmp_randstate_t): integer; cdecl; external LIBMPFR name 'mpfr_urandomb';
procedure mpfr_nextabove(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_nextabove';
procedure mpfr_nextbelow(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_nextbelow';
procedure mpfr_nexttoward(rop: mpfr_ptr; const p1: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_nexttoward';
function mpfr_printf(rop: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_printf';
function mpfr_asprintf(rop: PChar; p1: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_asprintf';
function mpfr_sprintf(rop: PChar; p1: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_sprintf';
function mpfr_snprintf(rop: PChar; p1: valuint; p2: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_snprintf';
function mpfr_pow(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow';
function mpfr_pow_si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_si';
function mpfr_pow_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_ui';
function mpfr_ui_pow_ui(rop: mpfr_ptr; p1: valsint; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_pow_ui';
function mpfr_ui_pow(rop: mpfr_ptr; p1: valsint; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_pow';
function mpfr_pow_z(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpz_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_z';
function mpfr_sqrt(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqrt';
function mpfr_sqrt_ui(rop: mpfr_ptr; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqrt_ui';
function mpfr_rec_sqrt(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rec_sqrt';
function mpfr_add(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add';
function mpfr_sub(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub';
function mpfr_mul(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul';
function mpfr_div(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div';
function mpfr_add_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_ui';
function mpfr_sub_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_ui';
function mpfr_ui_sub(rop: mpfr_ptr; p1: valsint; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_sub';
function mpfr_mul_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_ui';
function mpfr_div_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_ui';
function mpfr_ui_div(rop: mpfr_ptr; p1: valsint; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_div';
function mpfr_add_si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_si';
function mpfr_sub_si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_si';
function mpfr_si_sub(rop: mpfr_ptr; p1: int64; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_si_sub';
function mpfr_mul_si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_si';
function mpfr_div_si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_si';
function mpfr_si_div(rop: mpfr_ptr; p1: int64; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_si_div';
function mpfr_add_d(rop: mpfr_ptr; const p1: mpfr_ptr; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_d';
function mpfr_sub_d(rop: mpfr_ptr; const p1: mpfr_ptr; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_d';
function mpfr_d_sub(rop: mpfr_ptr; p1: double; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_d_sub';
function mpfr_mul_d(rop: mpfr_ptr; const p1: mpfr_ptr; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_d';
function mpfr_div_d(rop: mpfr_ptr; const p1: mpfr_ptr; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_d';
function mpfr_d_div(rop: mpfr_ptr; p1: double; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_d_div';
function mpfr_sqr(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqr';
function mpfr_const_pi(rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_pi';
function mpfr_const_log2(rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_log2';
function mpfr_const_euler(rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_euler';
function mpfr_const_catalan(rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_catalan';
function mpfr_agm(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_agm';
function mpfr_log(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log';
function mpfr_log2(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log2';
function mpfr_log10(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log10';
function mpfr_log1p(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log1p';
function mpfr_log_ui(rop: mpfr_ptr; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log_ui';
function mpfr_exp(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp';
function mpfr_exp2(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp2';
function mpfr_exp10(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp10';
function mpfr_expm1(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_expm1';
function mpfr_eint(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_eint';
function mpfr_li2(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_li2';
function mpfr_cmp(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_cmp';
function mpfr_cmp3(const rop: mpfr_ptr; const p1: mpfr_ptr; p2: integer): integer; cdecl; external LIBMPFR name 'mpfr_cmp3';
function mpfr_cmp_d(const rop: mpfr_ptr; p1: double): integer; cdecl; external LIBMPFR name 'mpfr_cmp_d';
function mpfr_cmp_ld(const rop: mpfr_ptr; p1: extended): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ld';
function mpfr_cmpabs(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_cmpabs';
function mpfr_cmp_abs(op1: mpfr_ptr; op2: mpfr_ptr): integer;
function mpfr_cmp_ui(const rop: mpfr_ptr; p1: valsint): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ui';
function mpfr_cmp_si(const rop: mpfr_ptr; p1: int64): integer; cdecl; external LIBMPFR name 'mpfr_cmp_si';
function mpfr_cmp_ui_2exp(const rop: mpfr_ptr; p1: valsint; p2: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ui_2exp';
function mpfr_cmp_si_2exp(const rop: mpfr_ptr; p1: int64; p2: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_si_2exp';
procedure mpfr_reldiff(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t); cdecl; external LIBMPFR name 'mpfr_reldiff';
function mpfr_eq(const rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint): integer; cdecl; external LIBMPFR name 'mpfr_eq';
function mpfr_sgn(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_sgn';
function mpfr_mul_2exp(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2exp';
function mpfr_div_2exp(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2exp';
function mpfr_mul_2ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2ui';
function mpfr_div_2ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2ui';
function mpfr_mul_2si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2si';
function mpfr_div_2si(rop: mpfr_ptr; const p1: mpfr_ptr; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2si';
function mpfr_rint(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint';
function mpfr_roundeven(rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_roundeven';
function mpfr_round(rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_round';
function mpfr_trunc(rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_trunc';
function mpfr_ceil(rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_ceil';
function mpfr_floor(rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_floor';
function mpfr_rint_roundeven(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_roundeven';
function mpfr_rint_round(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_round';
function mpfr_rint_trunc(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_trunc';
function mpfr_rint_ceil(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_ceil';
function mpfr_rint_floor(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_floor';
function mpfr_frac(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_frac';
function mpfr_modf(rop: mpfr_ptr; p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_modf';
function mpfr_remquo(rop: mpfr_ptr; p1: Pint64; const p2: mpfr_ptr; const p3: mpfr_ptr; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_remquo';
function mpfr_remainder(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_remainder';
function mpfr_fmod(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmod';
function mpfr_fmodquo(rop: mpfr_ptr; p1: Pint64; const p2: mpfr_ptr; const p3: mpfr_ptr; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmodquo';
function mpfr_fits_ulong_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_ulong_p';
function mpfr_fits_slong_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_slong_p';
function mpfr_fits_uint_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_uint_p';
function mpfr_fits_sint_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_sint_p';
function mpfr_fits_ushort_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_ushort_p';
function mpfr_fits_sshort_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_sshort_p';
function mpfr_fits_uintmax_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_uintmax_p';
function mpfr_fits_intmax_p(const rop: mpfr_ptr; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_intmax_p';
procedure mpfr_extract(rop: mpz_ptr; const p1: mpfr_ptr; p2: integer); cdecl; external LIBMPFR name 'mpfr_extract';
procedure mpfr_swap(rop: mpfr_ptr; p1: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_swap';
procedure mpfr_dump(const rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_dump';
function mpfr_nan_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_nan_p';
function mpfr_inf_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_inf_p';
function mpfr_number_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_number_p';
function mpfr_integer_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_integer_p';
function mpfr_zero_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_zero_p';
function mpfr_regular_p(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_regular_p';
function mpfr_greater_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_greater_p';
function mpfr_greaterequal_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_greaterequal_p';
function mpfr_less_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_less_p';
function mpfr_lessequal_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_lessequal_p';
function mpfr_lessgreater_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_lessgreater_p';
function mpfr_equal_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_equal_p';
function mpfr_unordered_p(const rop: mpfr_ptr; const p1: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_unordered_p';
function mpfr_atanh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atanh';
function mpfr_acosh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_acosh';
function mpfr_asinh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_asinh';
function mpfr_cosh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cosh';
function mpfr_sinh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sinh';
function mpfr_tanh(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_tanh';
function mpfr_sinh_cosh(rop: mpfr_ptr; p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sinh_cosh';
function mpfr_sech(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sech';
function mpfr_csch(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_csch';
function mpfr_coth(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_coth';
function mpfr_acos(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_acos';
function mpfr_asin(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_asin';
function mpfr_atan(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atan';
function mpfr_sin(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sin';
function mpfr_sin_cos(rop: mpfr_ptr; p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sin_cos';
function mpfr_cos(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cos';
function mpfr_tan(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_tan';
function mpfr_atan2(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atan2';
function mpfr_sec(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sec';
function mpfr_csc(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_csc';
function mpfr_cot(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cot';
function mpfr_hypot(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_hypot';
function mpfr_erf(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erf';
function mpfr_erfc(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erfc';
function mpfr_cbrt(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cbrt';
function mpfr_root(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_root';
function mpfr_rootn_ui(rop: mpfr_ptr; const p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rootn_ui';
function mpfr_gamma(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_gamma';
function mpfr_gamma_inc(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_gamma_inc';
function mpfr_beta(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_beta';
function mpfr_lngamma(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_lngamma';
function mpfr_lgamma(rop: mpfr_ptr; p1: Pinteger; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_lgamma';
function mpfr_digamma(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_digamma';
function mpfr_zeta(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_zeta';
function mpfr_zeta_ui(rop: mpfr_ptr; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_zeta_ui';
function mpfr_fac_ui(rop: mpfr_ptr; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fac_ui';
function mpfr_j0(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_j0';
function mpfr_j1(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_j1';
function mpfr_jn(rop: mpfr_ptr; p1: int64; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_jn';
function mpfr_y0(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_y0';
function mpfr_y1(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_y1';
function mpfr_yn(rop: mpfr_ptr; p1: int64; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_yn';
function mpfr_ai(rop: mpfr_ptr; const p1: mpfr_ptr; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ai';
function mpfr_min(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_min';
function mpfr_max(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_max';
function mpfr_dim(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_dim';
function mpfr_mul_z(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpz_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_z';
function mpfr_div_z(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpz_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_z';
function mpfr_add_z(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpz_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_z';
function mpfr_sub_z(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpz_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_z';
function mpfr_z_sub(rop: mpfr_ptr; const p1: mpz_ptr; const p2: mpfr_ptr; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_z_sub';
function mpfr_cmp_z(const rop: mpfr_ptr; const p1: mpz_ptr): integer; cdecl; external LIBMPFR name 'mpfr_cmp_z';
function mpfr_fma(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; const p3: mpfr_ptr; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fma';
function mpfr_fms(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; const p3: mpfr_ptr; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fms';
function mpfr_fmma(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; const p3: mpfr_ptr; const p4: mpfr_ptr; p5: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmma';
function mpfr_fmms(rop: mpfr_ptr; const p1: mpfr_ptr; const p2: mpfr_ptr; const p3: mpfr_ptr; const p4: mpfr_ptr; p5: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmms';
function mpfr_sum(rop: mpfr_ptr; p1: mpfr_ptr; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sum';
procedure mpfr_free_cache(); cdecl; external LIBMPFR name 'mpfr_free_cache';
procedure mpfr_free_cache2(rop: mpfr_free_cache_t); cdecl; external LIBMPFR name 'mpfr_free_cache2';
procedure mpfr_free_pool(); cdecl; external LIBMPFR name 'mpfr_free_pool';
function mpfr_mp_memory_cleanup(): integer; cdecl; external LIBMPFR name 'mpfr_mp_memory_cleanup';
function mpfr_subnormalize(rop: mpfr_ptr; p1: integer; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_subnormalize';
function mpfr_strtofr(rop: mpfr_ptr; p1: PChar; p2: PChar; p3: integer; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_strtofr';
procedure mpfr_round_nearest_away_begin(rop: mpfr_ptr); cdecl; external LIBMPFR name 'mpfr_round_nearest_away_begin';
function mpfr_round_nearest_away_end(rop: mpfr_ptr; p1: integer): integer; cdecl; external LIBMPFR name 'mpfr_round_nearest_away_end';
function mpfr_custom_get_size(rop: mpfr_prec_t): valuint; cdecl; external LIBMPFR name 'mpfr_custom_get_size';
procedure mpfr_custom_init(rop: pointer; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_custom_init';
function mpfr_custom_get_significand(const rop: mpfr_ptr): pointer; cdecl; external LIBMPFR name 'mpfr_custom_get_significand';
function mpfr_custom_get_exp(const rop: mpfr_ptr): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_custom_get_exp';
procedure mpfr_custom_move(rop: mpfr_ptr; p1: pointer); cdecl; external LIBMPFR name 'mpfr_custom_move';
procedure mpfr_custom_init_set(rop: mpfr_ptr; p1: integer; p2: mpfr_exp_t; p3: mpfr_prec_t; p4: pointer); cdecl; external LIBMPFR name 'mpfr_custom_init_set';
function mpfr_custom_get_kind(const rop: mpfr_ptr): integer; cdecl; external LIBMPFR name 'mpfr_custom_get_kind';

implementation

procedure mpfr_init_set_si(x: mpfr_ptr; y: valsint; rnd: mpfr_rnd_t);
begin 
  mpfr_init(x); 
  mpfr_set_si(x, y, rnd);
end;

procedure mpfr_init_set_ui(x: mpfr_ptr; y: valuint; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_ui(x, y, rnd)
end;

procedure mpfr_init_set_d(x: mpfr_ptr; y: double; rnd: mpfr_rnd_t);
begin 
  mpfr_init(x); 
  mpfr_set_d(x, y, rnd);
end;

procedure mpfr_init_set_ld(x: mpfr_ptr; y: extended; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_ld(x, y, rnd);
end;

procedure mpfr_init_set_z(x: mpfr_ptr; y: mpz_ptr; rnd: mpfr_rnd_t);
begin
  mpfr_init(x);
  mpfr_set_z(x, y, rnd);
end;

procedure mpfr_init_set_q(x: mpfr_ptr; y: mpq_ptr; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_q(x, y, rnd);
end;

procedure mpfr_init_set_f(x: mpfr_ptr; y: mpf_ptr; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_f(x, y, rnd);
end;

function mpfr_cmp_abs(op1: mpfr_ptr; op2: mpfr_ptr): integer;
begin
  result:=mpfr_cmpabs(op1, op2);
end;

end.