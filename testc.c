/* Automatically generated by chibi-ffi; version: 0.4 */

#include <chibi/eval.h>
/*
types: ()
enums: ()
*/

extern void hello_user(const char*);

sexp sexp_hello_user_stub (sexp ctx, sexp self, sexp_sint_t n, sexp arg0) {
  sexp res;
  if (! sexp_stringp(arg0))
    return sexp_type_exception(ctx, self, SEXP_STRING, arg0);
  res = ((hello_user(sexp_string_data(arg0))), SEXP_VOID);
  return res;
}


sexp sexp_init_library (sexp ctx, sexp self, sexp_sint_t n, sexp env, const char* version, const sexp_abi_identifier_t abi) {
  sexp_gc_var3(name, tmp, op);
  if (!(sexp_version_compatible(ctx, version, sexp_version)
        && sexp_abi_compatible(ctx, abi, SEXP_ABI_IDENTIFIER)))
    return SEXP_ABI_ERROR;
  sexp_gc_preserve3(ctx, name, tmp, op);
  op = sexp_define_foreign(ctx, env, "hello-user", 1, sexp_hello_user_stub);
  if (sexp_opcodep(op)) {
    sexp_opcode_return_type(op) = SEXP_VOID;
    sexp_opcode_arg1_type(op) = sexp_make_fixnum(SEXP_STRING);
  }
  sexp_gc_release3(ctx);
  return SEXP_VOID;
}

