# GNU-MPFR-for-FreePascal
## The GNU MPFR Library. Header for FreePascal.
<br>Developed based on the current version of the GNU MPFR 4.0.1

In catalog "src" your will see 2 versions:
- "C-like" - "long number" parameters of functions is address of variable, as in language "C". Requires modernized unit GMP for FreePascal 
https://github.com/VadimAnIsaev/GNU-MP-for-FreePascal;
- "FCL-like" - "long number" parameters of functions with a "var" prefix, for compatibility with the FCL-version of unit "gmp".

## Библиотека GNU MPFR. Заголовочный файл для FreePascal.
Разработано на основе текущей версии GNU MPFR 4.0.1.

В каталоге "src" лежат две версии: 
- "C-like" - параметры функций вида "длинное число" передаются с помощью адреса переменной, как в языке "Си". Требуется усовершенствованный модуль gmp.pas для FreePascal из https://github.com/VadimAnIsaev/GNU-MP-for-FreePascal
- "FCL-like" - параметры функций вида "длинное число" передаются с помощью модификатора "var" для совместимости с FCL-версией модуля "gmp".

Модуль mpfr-mini.pas - работает без использования зависимости от gmp.pas. Работает только с типом данных MPFR без типов GMP.

