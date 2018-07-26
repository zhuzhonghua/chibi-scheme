#include <stdio.h>
#include <chibi/eval.h>

int main(int argc, char **argv)
{
	printf("hello world from c\n");
	
	sexp ctx;
	ctx = sexp_make_eval_context(NULL, NULL, NULL, 0, 0);
	
	sexp_gc_var3(file_path, err, tmp);
	sexp_gc_preserve3(ctx, file_path, err, tmp);
	
	sexp_add_module_directory(ctx, tmp=sexp_c_string(ctx,"../../lib",-1), SEXP_FALSE);
	
	sexp_load_standard_env(ctx, NULL, SEXP_SEVEN);
	sexp_load_standard_ports(ctx, NULL, stdin, stdout, stderr, 0);

	file_path = sexp_c_string(ctx, "test.scm", -1);
	file_path = sexp_load(ctx, file_path, NULL);
	if(sexp_exceptionp(file_path)){
		err = sexp_current_error_port(ctx);
		sexp_print_exception(ctx, file_path, err);
		sexp_stack_trace(ctx, err);
	}
	
	sexp_gc_release1(ctx);
	sexp_destroy_context(ctx);

	return 0;
}
