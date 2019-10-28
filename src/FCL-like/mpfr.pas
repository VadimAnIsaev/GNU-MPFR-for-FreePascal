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

  // Structure long number MPFR
  // Структура длинного числа MPFR
  mpfr_t = record
    _mpfr_prec : mpfr_prec_t; // Mantissa. Мантисса
    _mpfr_sign : mpfr_sign_t; // Sign of number. Знак числа
    _mpfr_exp  : mpfr_exp_t;  // Экспонента
    _mpfr_d    : ^mp_limb_t;  // Array of storage. Указатель на хранилище
  end;
  mpfr_ptr    = ^mpfr_t;
  mpfr_srcptr = ^mpfr_t;


// Functions
// Функции

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
function mpfr_check_range(var rop: mpfr_t; p1: integer; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_check_range';

procedure mpfr_init(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_init';
procedure mpfr_clear(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_clear';
procedure mpfr_inits(var rop: mpfr_t{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_inits';
procedure mpfr_init2(var rop: mpfr_t; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_init2';
procedure mpfr_inits2(rop: mpfr_prec_t; var op1: mpfr_t{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_inits2';
procedure mpfr_clears(var rop: mpfr_t{; ...}); cdecl; varargs; external LIBMPFR name 'mpfr_clears';

procedure mpfr_init_set_si(var x: mpfr_t; y: valsint; rnd: mpfr_rnd_t);
procedure mpfr_init_set_ui(var x: mpfr_t; y: valuint; rnd: mpfr_rnd_t);
procedure mpfr_init_set_d(var x: mpfr_t; y: double; rnd: mpfr_rnd_t);
procedure mpfr_init_set_ld(var x: mpfr_t; y: extended; rnd: mpfr_rnd_t);
procedure mpfr_init_set_z(var x: mpfr_t; var y: mpz_t; rnd: mpfr_rnd_t);
procedure mpfr_init_set_q(var x: mpfr_t; var y: mpq_t; rnd: mpfr_rnd_t);
procedure mpfr_init_set_f(var x: mpfr_t; var y: mpf_t; rnd: mpfr_rnd_t);

function mpfr_prec_round(var rop: mpfr_t; p1: mpfr_prec_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_prec_round';
function mpfr_can_round(var rop: mpfr_t; p1: mpfr_exp_t; p2: mpfr_rnd_t; p3: mpfr_rnd_t; p4: mpfr_prec_t): integer; cdecl; external LIBMPFR name 'mpfr_can_round';
function mpfr_min_prec(var rop: mpfr_t): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_min_prec';
function mpfr_get_exp(var rop: mpfr_t): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_exp';
function mpfr_set_exp(var rop: mpfr_t; p1: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_set_exp';
function mpfr_get_prec(var rop: mpfr_t): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_get_prec';
procedure mpfr_set_prec(var rop: mpfr_t; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_prec';
procedure mpfr_set_prec_raw(var rop: mpfr_t; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_prec_raw';
procedure mpfr_set_default_prec(rop: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_set_default_prec';
function mpfr_get_default_prec(): mpfr_prec_t; cdecl; external LIBMPFR name 'mpfr_get_default_prec';

function mpfr_set_d(var rop: mpfr_t; p1: double; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_d';
function mpfr_set_flt(var rop: mpfr_t; p1: single; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_flt';
function mpfr_set_ld(var rop: mpfr_t; p1: extended; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ld';
function mpfr_set_z(var rop: mpfr_t; var p1: mpz_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_z';
function mpfr_set_z_2exp(var rop: mpfr_t; var p1: mpz_t; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_z_2exp';
procedure mpfr_set_nan(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_set_nan';
procedure mpfr_set_inf(var rop: mpfr_t; p1: integer); cdecl; external LIBMPFR name 'mpfr_set_inf';
procedure mpfr_set_zero(var rop: mpfr_t; p1: integer); cdecl; external LIBMPFR name 'mpfr_set_zero';
function mpfr_set_f(var rop: mpfr_t; var p1: mpf_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_f';
function mpfr_cmp_f(var rop: mpfr_t; var p1: mpf_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_f';
function mpfr_get_f(var rop: mpf_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_get_f';
function mpfr_set_si(var rop: mpfr_t; p1: int64; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_si';
function mpfr_set_ui(var rop: mpfr_t; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ui';
function mpfr_set_si_2exp(var rop: mpfr_t; p1: int64; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_si_2exp';
function mpfr_set_ui_2exp(var rop: mpfr_t; p1: valsint; p2: mpfr_exp_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_ui_2exp';
function mpfr_set_q(var rop: mpfr_t; var p1: mpq_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_q';
function mpfr_mul_q(var rop: mpfr_t; var op1: mpfr_t; var p2: mpq_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_q';
function mpfr_div_q(var rop: mpfr_t; var op1: mpfr_t; var p2: mpq_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_q';
function mpfr_add_q(var rop: mpfr_t; var op1: mpfr_t; var p2: mpq_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_q';
function mpfr_sub_q(var rop: mpfr_t; var op1: mpfr_t; var p2: mpq_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_q';
function mpfr_cmp_q(var rop: mpfr_t; var p1: mpq_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_q';
procedure mpfr_get_q(var rop: mpq_t; var op1: mpfr_t); cdecl; external LIBMPFR name 'mpfr_get_q';
function mpfr_set_str(var rop: mpfr_t; p1: PChar; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set_str';
function mpfr_init_set_str(var rop: mpfr_t; p1: PChar; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_init_set_str';
function mpfr_set4(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t; p3: integer): integer; cdecl; external LIBMPFR name 'mpfr_set4';
function mpfr_abs(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_abs';
function mpfr_set(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_set';
function mpfr_neg(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_neg';
function mpfr_signbit(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_signbit';
function mpfr_setsign(var rop: mpfr_t; var op1: mpfr_t; p2: integer; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_setsign';
function mpfr_copysign(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_copysign';
function mpfr_get_flt(var rop: mpfr_t; p1: mpfr_rnd_t): single; cdecl; external LIBMPFR name 'mpfr_get_flt';
function mpfr_get_d(var rop: mpfr_t; p1: mpfr_rnd_t): double; cdecl; external LIBMPFR name 'mpfr_get_d';
function mpfr_get_ld(var rop: mpfr_t; p1: mpfr_rnd_t): extended; cdecl; external LIBMPFR name 'mpfr_get_ld';
function mpfr_get_d1(var rop: mpfr_t): double; cdecl; external LIBMPFR name 'mpfr_get_d1';
function mpfr_get_d_2exp(rop: Pint64; var op1: mpfr_t; p2: mpfr_rnd_t): double; cdecl; external LIBMPFR name 'mpfr_get_d_2exp';
function mpfr_get_ld_2exp(rop: Pint64; var op1: mpfr_t; p2: mpfr_rnd_t): extended; cdecl; external LIBMPFR name 'mpfr_get_ld_2exp';
function mpfr_frexp(rop: mpfr_exp_ptr; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_frexp';
function mpfr_get_si(var rop: mpfr_t; p1: mpfr_rnd_t): int64; cdecl; external LIBMPFR name 'mpfr_get_si';
function mpfr_get_ui(var rop: mpfr_t; p1: mpfr_rnd_t): valsint; cdecl; external LIBMPFR name 'mpfr_get_ui';
function mpfr_get_str(rop: PChar; p1: mpfr_exp_ptr; p2: integer; p3: valuint; var p4: mpfr_t; p5: mpfr_rnd_t): PChar; cdecl; external LIBMPFR name 'mpfr_get_str';
function mpfr_get_z(var rop: mpz_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_get_z';
function mpfr_get_z_2exp(var rop: mpz_t; var op1: mpfr_t): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_get_z_2exp';

procedure mpfr_free_str(rop: PChar); cdecl; external LIBMPFR name 'mpfr_free_str';

function mpfr_urandom(var rop: mpfr_t; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_urandom';
function mpfr_grandom(var rop: mpfr_t; var op1: mpfr_t; p2: gmp_randstate_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_grandom';
function mpfr_nrandom(var rop: mpfr_t; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_nrandom';
function mpfr_erandom(var rop: mpfr_t; p1: gmp_randstate_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erandom';
function mpfr_urandomb(var rop: mpfr_t; p1: gmp_randstate_t): integer; cdecl; external LIBMPFR name 'mpfr_urandomb';

procedure mpfr_nextabove(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_nextabove';
procedure mpfr_nextbelow(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_nextbelow';
procedure mpfr_nexttoward(var rop: mpfr_t; var op1: mpfr_t); cdecl; external LIBMPFR name 'mpfr_nexttoward';

function mpfr_printf(rop: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_printf';
function mpfr_asprintf(rop: PChar; p1: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_asprintf';
function mpfr_sprintf(rop: PChar; p1: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_sprintf';
function mpfr_snprintf(rop: PChar; p1: valuint; p2: PChar{; ...}): integer; cdecl; varargs; external LIBMPFR name 'mpfr_snprintf';

function mpfr_pow(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow';
function mpfr_pow_si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_si';
function mpfr_pow_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_ui';
function mpfr_ui_pow_ui(var rop: mpfr_t; p1: valsint; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_pow_ui';
function mpfr_ui_pow(var rop: mpfr_t; p1: valsint; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_pow';
function mpfr_pow_z(var rop: mpfr_t; var op1: mpfr_t; var p2: mpz_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_pow_z';
function mpfr_sqrt(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqrt';
function mpfr_sqrt_ui(var rop: mpfr_t; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqrt_ui';
function mpfr_rec_sqrt(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rec_sqrt';
function mpfr_add(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add';
function mpfr_sub(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub';
function mpfr_mul(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul';
function mpfr_div(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div';
function mpfr_add_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_ui';
function mpfr_sub_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_ui';
function mpfr_ui_sub(var rop: mpfr_t; p1: valsint; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_sub';
function mpfr_mul_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_ui';
function mpfr_div_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_ui';
function mpfr_ui_div(var rop: mpfr_t; p1: valsint; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ui_div';
function mpfr_add_si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_si';
function mpfr_sub_si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_si';
function mpfr_si_sub(var rop: mpfr_t; p1: int64; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_si_sub';
function mpfr_mul_si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_si';
function mpfr_div_si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_si';
function mpfr_si_div(var rop: mpfr_t; p1: int64; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_si_div';
function mpfr_add_d(var rop: mpfr_t; var op1: mpfr_t; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_d';
function mpfr_sub_d(var rop: mpfr_t; var op1: mpfr_t; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_d';
function mpfr_d_sub(var rop: mpfr_t; p1: double; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_d_sub';
function mpfr_mul_d(var rop: mpfr_t; var op1: mpfr_t; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_d';
function mpfr_div_d(var rop: mpfr_t; var op1: mpfr_t; p2: double; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_d';
function mpfr_d_div(var rop: mpfr_t; p1: double; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_d_div';
function mpfr_sqr(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sqr';

function mpfr_const_pi(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_pi';
function mpfr_const_log2(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_log2';
function mpfr_const_euler(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_euler';
function mpfr_const_catalan(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_const_catalan';

function mpfr_agm(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_agm';
function mpfr_log(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log';
function mpfr_log2(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log2';
function mpfr_log10(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log10';
function mpfr_log1p(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log1p';
function mpfr_log_ui(var rop: mpfr_t; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_log_ui';
function mpfr_exp(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp';
function mpfr_exp2(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp2';
function mpfr_exp10(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_exp10';
function mpfr_expm1(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_expm1';
function mpfr_eint(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_eint';
function mpfr_li2(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_li2';

function mpfr_cmp(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp';
function mpfr_cmp3(var rop: mpfr_t; var op1: mpfr_t; p2: integer): integer; cdecl; external LIBMPFR name 'mpfr_cmp3';
function mpfr_cmp_d(var rop: mpfr_t; p1: double): integer; cdecl; external LIBMPFR name 'mpfr_cmp_d';
function mpfr_cmp_ld(var rop: mpfr_t; p1: extended): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ld';
function mpfr_cmpabs(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_cmpabs';
function mpfr_cmp_abs(ovar op1: mpfr_t; var op2: mpfr_t): integer;
function mpfr_cmp_ui(var rop: mpfr_t; p1: valsint): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ui';
function mpfr_cmp_si(var rop: mpfr_t; p1: int64): integer; cdecl; external LIBMPFR name 'mpfr_cmp_si';
function mpfr_cmp_ui_2exp(var rop: mpfr_t; p1: valsint; p2: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_ui_2exp';
function mpfr_cmp_si_2exp(var rop: mpfr_t; p1: int64; p2: mpfr_exp_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_si_2exp';
procedure mpfr_reldiff(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t); cdecl; external LIBMPFR name 'mpfr_reldiff';
function mpfr_eq(var rop: mpfr_t; var op1: mpfr_t; p2: valsint): integer; cdecl; external LIBMPFR name 'mpfr_eq';

function mpfr_sgn(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_sgn';
function mpfr_mul_2exp(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2exp';
function mpfr_div_2exp(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2exp';
function mpfr_mul_2ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2ui';
function mpfr_div_2ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2ui';
function mpfr_mul_2si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_2si';
function mpfr_div_2si(var rop: mpfr_t; var op1: mpfr_t; p2: int64; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_2si';
function mpfr_rint(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint';
function mpfr_roundeven(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_roundeven';
function mpfr_round(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_round';
function mpfr_trunc(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_trunc';
function mpfr_ceil(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_ceil';
function mpfr_floor(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_floor';
function mpfr_rint_roundeven(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_roundeven';
function mpfr_rint_round(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_round';
function mpfr_rint_trunc(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_trunc';
function mpfr_rint_ceil(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_ceil';
function mpfr_rint_floor(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rint_floor';
function mpfr_frac(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_frac';
function mpfr_modf(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_modf';
function mpfr_remquo(var rop: mpfr_t; p1: Pint64; var op2: mpfr_t; var p3: mpfr_t; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_remquo';
function mpfr_remainder(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_remainder';
function mpfr_fmod(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmod';
function mpfr_fmodquo(var rop: mpfr_t; p1: Pint64; var op2: mpfr_t; var p3: mpfr_t; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmodquo';
function mpfr_fits_ulong_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_ulong_p';
function mpfr_fits_slong_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_slong_p';
function mpfr_fits_uint_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_uint_p';
function mpfr_fits_sint_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_sint_p';
function mpfr_fits_ushort_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_ushort_p';
function mpfr_fits_sshort_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_sshort_p';
function mpfr_fits_uintmax_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_uintmax_p';
function mpfr_fits_intmax_p(var rop: mpfr_t; p1: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fits_intmax_p';
procedure mpfr_extract(var rop: mpz_t; var op1: mpfr_t; p2: integer); cdecl; external LIBMPFR name 'mpfr_extract';
procedure mpfr_swap(var rop: mpfr_t; var op1: mpfr_t); cdecl; external LIBMPFR name 'mpfr_swap';
procedure mpfr_dump(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_dump';
function mpfr_nan_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_nan_p';
function mpfr_inf_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_inf_p';
function mpfr_number_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_number_p';
function mpfr_integer_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_integer_p';
function mpfr_zero_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_zero_p';
function mpfr_regular_p(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_regular_p';
function mpfr_greater_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_greater_p';
function mpfr_greaterequal_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_greaterequal_p';
function mpfr_less_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_less_p';
function mpfr_lessequal_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_lessequal_p';
function mpfr_lessgreater_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_lessgreater_p';
function mpfr_equal_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_equal_p';
function mpfr_unordered_p(var rop: mpfr_t; var op1: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_unordered_p';
function mpfr_atanh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atanh';
function mpfr_acosh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_acosh';
function mpfr_asinh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_asinh';
function mpfr_cosh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cosh';
function mpfr_sinh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sinh';
function mpfr_tanh(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_tanh';
function mpfr_sinh_cosh(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sinh_cosh';
function mpfr_sech(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sech';
function mpfr_csch(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_csch';
function mpfr_coth(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_coth';
function mpfr_acos(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_acos';
function mpfr_asin(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_asin';
function mpfr_atan(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atan';
function mpfr_sin(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sin';
function mpfr_sin_cos(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sin_cos';
function mpfr_cos(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cos';
function mpfr_tan(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_tan';
function mpfr_atan2(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_atan2';
function mpfr_sec(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sec';
function mpfr_csc(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_csc';
function mpfr_cot(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cot';
function mpfr_hypot(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_hypot';
function mpfr_erf(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erf';
function mpfr_erfc(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_erfc';
function mpfr_cbrt(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_cbrt';
function mpfr_root(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_root';
function mpfr_rootn_ui(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_rootn_ui';
function mpfr_gamma(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_gamma';
function mpfr_gamma_inc(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_gamma_inc';
function mpfr_beta(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_beta';
function mpfr_lngamma(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_lngamma';
function mpfr_lgamma(var rop: mpfr_t; p1: Pinteger; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_lgamma';
function mpfr_digamma(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_digamma';
function mpfr_zeta(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_zeta';
function mpfr_zeta_ui(var rop: mpfr_t; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_zeta_ui';
function mpfr_fac_ui(var rop: mpfr_t; p1: valsint; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fac_ui';
function mpfr_j0(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_j0';
function mpfr_j1(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_j1';
function mpfr_jn(var rop: mpfr_t; p1: int64; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_jn';
function mpfr_y0(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_y0';
function mpfr_y1(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_y1';
function mpfr_yn(var rop: mpfr_t; p1: int64; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_yn';
function mpfr_ai(var rop: mpfr_t; var op1: mpfr_t; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_ai';
function mpfr_min(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_min';
function mpfr_max(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_max';
function mpfr_dim(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_dim';
function mpfr_mul_z(var rop: mpfr_t; var op1: mpfr_t; var p2: mpz_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_mul_z';
function mpfr_div_z(var rop: mpfr_t; var op1: mpfr_t; var p2: mpz_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_div_z';
function mpfr_add_z(var rop: mpfr_t; var op1: mpfr_t; var p2: mpz_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_add_z';
function mpfr_sub_z(var rop: mpfr_t; var op1: mpfr_t; var p2: mpz_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sub_z';
function mpfr_z_sub(var rop: mpfr_t; var p1: mpz_t; var op2: mpfr_t; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_z_sub';
function mpfr_cmp_z(var rop: mpfr_t; var p1: mpz_t): integer; cdecl; external LIBMPFR name 'mpfr_cmp_z';
function mpfr_fma(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; var p3: mpfr_t; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fma';
function mpfr_fms(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; var p3: mpfr_t; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fms';
function mpfr_fmma(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; var p3: mpfr_t; var p4: mpfr_t; p5: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmma';
function mpfr_fmms(var rop: mpfr_t; var op1: mpfr_t; var op2: mpfr_t; var p3: mpfr_t; var p4: mpfr_t; p5: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_fmms';
function mpfr_sum(var rop: mpfr_t; var op1: mpfr_t; p2: valsint; p3: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_sum';
procedure mpfr_free_cache(); cdecl; external LIBMPFR name 'mpfr_free_cache';
procedure mpfr_free_cache2(rop: mpfr_free_cache_t); cdecl; external LIBMPFR name 'mpfr_free_cache2';
procedure mpfr_free_pool(); cdecl; external LIBMPFR name 'mpfr_free_pool';
function mpfr_mp_memory_cleanup(): integer; cdecl; external LIBMPFR name 'mpfr_mp_memory_cleanup';
function mpfr_subnormalize(var rop: mpfr_t; p1: integer; p2: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_subnormalize';
function mpfr_strtofr(var rop: mpfr_t; p1: PChar; p2: PChar; p3: integer; p4: mpfr_rnd_t): integer; cdecl; external LIBMPFR name 'mpfr_strtofr';
procedure mpfr_round_nearest_away_begin(var rop: mpfr_t); cdecl; external LIBMPFR name 'mpfr_round_nearest_away_begin';
function mpfr_round_nearest_away_end(var rop: mpfr_t; p1: integer): integer; cdecl; external LIBMPFR name 'mpfr_round_nearest_away_end';
function mpfr_custom_get_size(rop: mpfr_prec_t): valuint; cdecl; external LIBMPFR name 'mpfr_custom_get_size';
procedure mpfr_custom_init(rop: pointer; p1: mpfr_prec_t); cdecl; external LIBMPFR name 'mpfr_custom_init';
function mpfr_custom_get_significand(var rop: mpfr_t): pointer; cdecl; external LIBMPFR name 'mpfr_custom_get_significand';
function mpfr_custom_get_exp(var rop: mpfr_t): mpfr_exp_t; cdecl; external LIBMPFR name 'mpfr_custom_get_exp';
procedure mpfr_custom_move(var rop: mpfr_t; p1: pointer); cdecl; external LIBMPFR name 'mpfr_custom_move';
procedure mpfr_custom_init_set(var rop: mpfr_t; p1: integer; p2: mpfr_exp_t; p3: mpfr_prec_t; p4: pointer); cdecl; external LIBMPFR name 'mpfr_custom_init_set';
function mpfr_custom_get_kind(var rop: mpfr_t): integer; cdecl; external LIBMPFR name 'mpfr_custom_get_kind';

function mpfr_sign(op: mpfr_t): mpfr_sign_t;

implementation

procedure mpfr_init_set_si(var x: mpfr_t; y: valsint; rnd: mpfr_rnd_t);
begin 
  mpfr_init(x); 
  mpfr_set_si(x, y, rnd);
end;

procedure mpfr_init_set_ui(var x: mpfr_t; y: valuint; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_ui(x, y, rnd)
end;

procedure mpfr_init_set_d(var x: mpfr_t; y: double; rnd: mpfr_rnd_t);
begin 
  mpfr_init(x); 
  mpfr_set_d(x, y, rnd);
end;

procedure mpfr_init_set_ld(var x: mpfr_t; y: extended; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_ld(x, y, rnd);
end;

procedure mpfr_init_set_z(var x: mpfr_t; y: mpz_t; rnd: mpfr_rnd_t);
begin
  mpfr_init(x);
  mpfr_set_z(x, y, rnd);
end;

procedure mpfr_init_set_q(var x: mpfr_t; y: mpq_t; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_q(x, y, rnd);
end;

procedure mpfr_init_set_f(var x: mpfr_t; y: mpf_t; rnd: mpfr_rnd_t);
begin
  mpfr_init(x); 
  mpfr_set_f(x, y, rnd);
end;

function mpfr_cmp_abs(op1: mpfr_t; op2: mpfr_t): integer;
begin
  result:=mpfr_cmpabs(op1, op2);
end;

function mpfr_sign(op: mpfr_t): mpfr_sign_t;
begin
  result:=op._mpfr_sign;
end;

end.
