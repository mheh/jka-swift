#include "jka_host.h"

#include <dlfcn.h>
#include <stdarg.h>
#include <stddef.h>

jka_systemcall_fn jka_systemCall = NULL;

// Source: oracle/codemp/qcommon/vm.cpp:363
intptr_t VM_DllSyscall( intptr_t arg, ... ) {
	// Port-note: Raven's x86 arm read the words from the stack after &arg, which is undefined on a 64-bit host.
	// This is the form of Raven's linux powerpc arm at oracle/codemp/qcommon/vm.cpp:364-377, which copies the words from the va_list.
	intptr_t	args[15];
	int		i;
	va_list	ap;

	args[0] = arg;

	va_start(ap, arg);
	for (i = 1; i < (int)(sizeof (args) / sizeof (args[i])); i++)
		args[i] = va_arg(ap, intptr_t);
	va_end(ap);

	return jka_systemCall( args, (int)(sizeof (args) / sizeof (args[0])) );
}

// Source: oracle/codemp/null/win_main.cpp:784
void *jka_load_dll( const char *path, jka_vmmain_fn *entryPoint ) {
	void	*libHandle;
	void	(*dllEntry)( jka_syscall_fn syscallptr );

	libHandle = dlopen( path, RTLD_NOW | RTLD_LOCAL );
	if ( !libHandle ) {
		return NULL;
	}

	// Source: oracle/codemp/null/win_main.cpp:827-828
	dllEntry = ( void (*)( jka_syscall_fn ) )dlsym( libHandle, "dllEntry" );
	*entryPoint = ( jka_vmmain_fn )dlsym( libHandle, "vmMain" );
	if ( !*entryPoint || !dllEntry ) {
		dlclose( libHandle );
		return NULL;
	}
	dllEntry( VM_DllSyscall );

	return libHandle;
}
