#include <stdio.h>
#include <chibi/eval.h>

int main(int argc, char **argv)
{
	printf("hello world from c\n");
	
	sexp ctx;
	ctx = sexp_make_eval_context(NULL, NULL, NULL, 0, 0);
	sexp_load_standard_env(ctx, NULL, SEXP_SEVEN);
	sexp_load_standard_ports(ctx, NULL, stdin, stdout, stderr, 0);

	sexp_gc_var1(file_path);
	sexp_gc_preserve1(ctx, file_path);

	file_path = sexp_c_string(ctx, "test.scm", -1);
	sexp_load(ctx, file_path, NULL);
	
	sexp_gc_release1(ctx);
	sexp_destroy_context(ctx);

	return 0;
}
