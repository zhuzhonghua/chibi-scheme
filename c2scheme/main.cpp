#include <stdio.h>
#include <chibi/eval.h>

void hello_user(const char* tmp){
	printf("in hello user %s \n", tmp);
}

int main(int argc, char **argv)
{
	printf("hello world from c\n");

	sexp ctx;
	ctx = sexp_make_eval_context(NULL, NULL, NULL, 0, 0);

	sexp_gc_var5(obj1, arg_val, arg_sym, ret, tmp);
	sexp_gc_preserve5(ctx, obj1, arg_val, arg_sym, ret, tmp);

	sexp_add_module_directory(ctx, tmp=sexp_c_string(ctx,"../lib",-1), SEXP_TRUE);
	
	sexp_load_standard_env(ctx, NULL, SEXP_SEVEN);
	sexp_load_standard_ports(ctx, NULL, stdin, stdout, stderr, 0);

	obj1 = sexp_c_string(ctx, "callme.scm", -1);
	sexp_load(ctx, obj1, NULL);

	sexp_eval_string(ctx, "(say-hello)", -1, NULL);

	const int num = 4;
	arg_val = sexp_make_fixnum(num);
  arg_sym = sexp_intern(ctx, "arg", -1);
	sexp_env_define(ctx, sexp_context_env(ctx), arg_sym, arg_val);

	ret = sexp_eval_string(ctx, "(square arg)", -1, NULL);
	int result = -1;
	if (sexp_integerp(ret)) {
	  result = sexp_unbox_fixnum(ret);
	}

	printf("from square ret %d\n", result);
	
	sexp_gc_release1(ctx);
	sexp_destroy_context(ctx);
	
	return 0;
}
