
obj/user/faultnostack.debug:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 39 00 00 00       	callq  80007a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 35 06 80 00 00 	movabs $0x800635,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	c9                   	leaveq 
  800079:	c3                   	retq   

000000000080007a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007a:	55                   	push   %rbp
  80007b:	48 89 e5             	mov    %rsp,%rbp
  80007e:	48 83 ec 10          	sub    $0x10,%rsp
  800082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800089:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  800090:	00 00 00 
  800093:	ff d0                	callq  *%rax
  800095:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009a:	48 63 d0             	movslq %eax,%rdx
  80009d:	48 89 d0             	mov    %rdx,%rax
  8000a0:	48 c1 e0 03          	shl    $0x3,%rax
  8000a4:	48 01 d0             	add    %rdx,%rax
  8000a7:	48 c1 e0 05          	shl    $0x5,%rax
  8000ab:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b2:	00 00 00 
  8000b5:	48 01 c2             	add    %rax,%rdx
  8000b8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000bf:	00 00 00 
  8000c2:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c9:	7e 14                	jle    8000df <libmain+0x65>
		binaryname = argv[0];
  8000cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cf:	48 8b 10             	mov    (%rax),%rdx
  8000d2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d9:	00 00 00 
  8000dc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e6:	48 89 d6             	mov    %rdx,%rsi
  8000e9:	89 c7                	mov    %eax,%edi
  8000eb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8000f7:	48 b8 05 01 80 00 00 	movabs $0x800105,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	callq  *%rax
}
  800103:	c9                   	leaveq 
  800104:	c3                   	retq   

0000000000800105 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800105:	55                   	push   %rbp
  800106:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800109:	48 b8 fd 09 80 00 00 	movabs $0x8009fd,%rax
  800110:	00 00 00 
  800113:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800115:	bf 00 00 00 00       	mov    $0x0,%edi
  80011a:	48 b8 3e 02 80 00 00 	movabs $0x80023e,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax

}
  800126:	5d                   	pop    %rbp
  800127:	c3                   	retq   

0000000000800128 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800128:	55                   	push   %rbp
  800129:	48 89 e5             	mov    %rsp,%rbp
  80012c:	53                   	push   %rbx
  80012d:	48 83 ec 48          	sub    $0x48,%rsp
  800131:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800134:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800137:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800143:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800147:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800152:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800156:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015e:	4c 89 c3             	mov    %r8,%rbx
  800161:	cd 30                	int    $0x30
  800163:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800167:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016b:	74 3e                	je     8001ab <syscall+0x83>
  80016d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800172:	7e 37                	jle    8001ab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800174:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800178:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017b:	49 89 d0             	mov    %rdx,%r8
  80017e:	89 c1                	mov    %eax,%ecx
  800180:	48 ba ca 3f 80 00 00 	movabs $0x803fca,%rdx
  800187:	00 00 00 
  80018a:	be 23 00 00 00       	mov    $0x23,%esi
  80018f:	48 bf e7 3f 80 00 00 	movabs $0x803fe7,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	49 b9 48 27 80 00 00 	movabs $0x802748,%r9
  8001a5:	00 00 00 
  8001a8:	41 ff d1             	callq  *%r9

	return ret;
  8001ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001af:	48 83 c4 48          	add    $0x48,%rsp
  8001b3:	5b                   	pop    %rbx
  8001b4:	5d                   	pop    %rbp
  8001b5:	c3                   	retq   

00000000008001b6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b6:	55                   	push   %rbp
  8001b7:	48 89 e5             	mov    %rsp,%rbp
  8001ba:	48 83 ec 20          	sub    $0x20,%rsp
  8001be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d5:	00 
  8001d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e2:	48 89 d1             	mov    %rdx,%rcx
  8001e5:	48 89 c2             	mov    %rax,%rdx
  8001e8:	be 00 00 00 00       	mov    $0x0,%esi
  8001ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f2:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
}
  8001fe:	c9                   	leaveq 
  8001ff:	c3                   	retq   

0000000000800200 <sys_cgetc>:

int
sys_cgetc(void)
{
  800200:	55                   	push   %rbp
  800201:	48 89 e5             	mov    %rsp,%rbp
  800204:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800208:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020f:	00 
  800210:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800216:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800221:	ba 00 00 00 00       	mov    $0x0,%edx
  800226:	be 00 00 00 00       	mov    $0x0,%esi
  80022b:	bf 01 00 00 00       	mov    $0x1,%edi
  800230:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
}
  80023c:	c9                   	leaveq 
  80023d:	c3                   	retq   

000000000080023e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023e:	55                   	push   %rbp
  80023f:	48 89 e5             	mov    %rsp,%rbp
  800242:	48 83 ec 10          	sub    $0x10,%rsp
  800246:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800249:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024c:	48 98                	cltq   
  80024e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800255:	00 
  800256:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800262:	b9 00 00 00 00       	mov    $0x0,%ecx
  800267:	48 89 c2             	mov    %rax,%rdx
  80026a:	be 01 00 00 00       	mov    $0x1,%esi
  80026f:	bf 03 00 00 00       	mov    $0x3,%edi
  800274:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	c9                   	leaveq 
  800281:	c3                   	retq   

0000000000800282 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
  800286:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800291:	00 
  800292:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800298:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b2:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8002b9:	00 00 00 
  8002bc:	ff d0                	callq  *%rax
}
  8002be:	c9                   	leaveq 
  8002bf:	c3                   	retq   

00000000008002c0 <sys_yield>:

void
sys_yield(void)
{
  8002c0:	55                   	push   %rbp
  8002c1:	48 89 e5             	mov    %rsp,%rbp
  8002c4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002cf:	00 
  8002d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e6:	be 00 00 00 00       	mov    $0x0,%esi
  8002eb:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f0:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8002f7:	00 00 00 
  8002fa:	ff d0                	callq  *%rax
}
  8002fc:	c9                   	leaveq 
  8002fd:	c3                   	retq   

00000000008002fe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002fe:	55                   	push   %rbp
  8002ff:	48 89 e5             	mov    %rsp,%rbp
  800302:	48 83 ec 20          	sub    $0x20,%rsp
  800306:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800309:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800310:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800313:	48 63 c8             	movslq %eax,%rcx
  800316:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031d:	48 98                	cltq   
  80031f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800326:	00 
  800327:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032d:	49 89 c8             	mov    %rcx,%r8
  800330:	48 89 d1             	mov    %rdx,%rcx
  800333:	48 89 c2             	mov    %rax,%rdx
  800336:	be 01 00 00 00       	mov    $0x1,%esi
  80033b:	bf 04 00 00 00       	mov    $0x4,%edi
  800340:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax
}
  80034c:	c9                   	leaveq 
  80034d:	c3                   	retq   

000000000080034e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034e:	55                   	push   %rbp
  80034f:	48 89 e5             	mov    %rsp,%rbp
  800352:	48 83 ec 30          	sub    $0x30,%rsp
  800356:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800359:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800360:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800364:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036b:	48 63 c8             	movslq %eax,%rcx
  80036e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800372:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800375:	48 63 f0             	movslq %eax,%rsi
  800378:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037f:	48 98                	cltq   
  800381:	48 89 0c 24          	mov    %rcx,(%rsp)
  800385:	49 89 f9             	mov    %rdi,%r9
  800388:	49 89 f0             	mov    %rsi,%r8
  80038b:	48 89 d1             	mov    %rdx,%rcx
  80038e:	48 89 c2             	mov    %rax,%rdx
  800391:	be 01 00 00 00       	mov    $0x1,%esi
  800396:	bf 05 00 00 00       	mov    $0x5,%edi
  80039b:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	callq  *%rax
}
  8003a7:	c9                   	leaveq 
  8003a8:	c3                   	retq   

00000000008003a9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a9:	55                   	push   %rbp
  8003aa:	48 89 e5             	mov    %rsp,%rbp
  8003ad:	48 83 ec 20          	sub    $0x20,%rsp
  8003b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bf:	48 98                	cltq   
  8003c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c8:	00 
  8003c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d5:	48 89 d1             	mov    %rdx,%rcx
  8003d8:	48 89 c2             	mov    %rax,%rdx
  8003db:	be 01 00 00 00       	mov    $0x1,%esi
  8003e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e5:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8003ec:	00 00 00 
  8003ef:	ff d0                	callq  *%rax
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	48 83 ec 10          	sub    $0x10,%rsp
  8003fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800401:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800404:	48 63 d0             	movslq %eax,%rdx
  800407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040a:	48 98                	cltq   
  80040c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800413:	00 
  800414:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800420:	48 89 d1             	mov    %rdx,%rcx
  800423:	48 89 c2             	mov    %rax,%rdx
  800426:	be 01 00 00 00       	mov    $0x1,%esi
  80042b:	bf 08 00 00 00       	mov    $0x8,%edi
  800430:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800437:	00 00 00 
  80043a:	ff d0                	callq  *%rax
}
  80043c:	c9                   	leaveq 
  80043d:	c3                   	retq   

000000000080043e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80043e:	55                   	push   %rbp
  80043f:	48 89 e5             	mov    %rsp,%rbp
  800442:	48 83 ec 20          	sub    $0x20,%rsp
  800446:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800449:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	48 98                	cltq   
  800456:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045d:	00 
  80045e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046a:	48 89 d1             	mov    %rdx,%rcx
  80046d:	48 89 c2             	mov    %rax,%rdx
  800470:	be 01 00 00 00       	mov    $0x1,%esi
  800475:	bf 09 00 00 00       	mov    $0x9,%edi
  80047a:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
}
  800486:	c9                   	leaveq 
  800487:	c3                   	retq   

0000000000800488 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 20          	sub    $0x20,%rsp
  800490:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800493:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049e:	48 98                	cltq   
  8004a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a7:	00 
  8004a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b4:	48 89 d1             	mov    %rdx,%rcx
  8004b7:	48 89 c2             	mov    %rax,%rdx
  8004ba:	be 01 00 00 00       	mov    $0x1,%esi
  8004bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c4:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8004cb:	00 00 00 
  8004ce:	ff d0                	callq  *%rax
}
  8004d0:	c9                   	leaveq 
  8004d1:	c3                   	retq   

00000000008004d2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d2:	55                   	push   %rbp
  8004d3:	48 89 e5             	mov    %rsp,%rbp
  8004d6:	48 83 ec 20          	sub    $0x20,%rsp
  8004da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004eb:	48 63 f0             	movslq %eax,%rsi
  8004ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f5:	48 98                	cltq   
  8004f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800502:	00 
  800503:	49 89 f1             	mov    %rsi,%r9
  800506:	49 89 c8             	mov    %rcx,%r8
  800509:	48 89 d1             	mov    %rdx,%rcx
  80050c:	48 89 c2             	mov    %rax,%rdx
  80050f:	be 00 00 00 00       	mov    $0x0,%esi
  800514:	bf 0c 00 00 00       	mov    $0xc,%edi
  800519:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800520:	00 00 00 
  800523:	ff d0                	callq  *%rax
}
  800525:	c9                   	leaveq 
  800526:	c3                   	retq   

0000000000800527 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800527:	55                   	push   %rbp
  800528:	48 89 e5             	mov    %rsp,%rbp
  80052b:	48 83 ec 10          	sub    $0x10,%rsp
  80052f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800537:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80053e:	00 
  80053f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800545:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800550:	48 89 c2             	mov    %rax,%rdx
  800553:	be 01 00 00 00       	mov    $0x1,%esi
  800558:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055d:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  800564:	00 00 00 
  800567:	ff d0                	callq  *%rax
}
  800569:	c9                   	leaveq 
  80056a:	c3                   	retq   

000000000080056b <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80056b:	55                   	push   %rbp
  80056c:	48 89 e5             	mov    %rsp,%rbp
  80056f:	48 83 ec 20          	sub    $0x20,%rsp
  800573:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800577:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  80057b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800583:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80058a:	00 
  80058b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800591:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800597:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059c:	89 c6                	mov    %eax,%esi
  80059e:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005a3:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
}
  8005af:	c9                   	leaveq 
  8005b0:	c3                   	retq   

00000000008005b1 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8005b1:	55                   	push   %rbp
  8005b2:	48 89 e5             	mov    %rsp,%rbp
  8005b5:	48 83 ec 20          	sub    $0x20,%rsp
  8005b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8005c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005d0:	00 
  8005d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e2:	89 c6                	mov    %eax,%esi
  8005e4:	bf 10 00 00 00       	mov    $0x10,%edi
  8005e9:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8005ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800606:	00 
  800607:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80060d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
  800618:	ba 00 00 00 00       	mov    $0x0,%edx
  80061d:	be 00 00 00 00       	mov    $0x0,%esi
  800622:	bf 0e 00 00 00       	mov    $0xe,%edi
  800627:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  80062e:	00 00 00 
  800631:	ff d0                	callq  *%rax
}
  800633:	c9                   	leaveq 
  800634:	c3                   	retq   

0000000000800635 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  800635:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  800638:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80063f:	00 00 00 
call *%rax
  800642:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  800644:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80064b:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80064c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  800653:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  800654:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  800658:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80065b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  800662:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  800663:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  800667:	4c 8b 3c 24          	mov    (%rsp),%r15
  80066b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  800670:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  800675:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80067a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80067f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  800684:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  800689:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80068e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  800693:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  800698:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80069d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8006a2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8006a7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8006ac:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8006b1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8006b5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8006b9:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8006ba:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8006bb:	c3                   	retq   

00000000008006bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8006bc:	55                   	push   %rbp
  8006bd:	48 89 e5             	mov    %rsp,%rbp
  8006c0:	48 83 ec 08          	sub    $0x8,%rsp
  8006c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8006c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006cc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8006d3:	ff ff ff 
  8006d6:	48 01 d0             	add    %rdx,%rax
  8006d9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8006dd:	c9                   	leaveq 
  8006de:	c3                   	retq   

00000000008006df <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8006df:	55                   	push   %rbp
  8006e0:	48 89 e5             	mov    %rsp,%rbp
  8006e3:	48 83 ec 08          	sub    $0x8,%rsp
  8006e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8006eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ef:	48 89 c7             	mov    %rax,%rdi
  8006f2:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  8006f9:	00 00 00 
  8006fc:	ff d0                	callq  *%rax
  8006fe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800704:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800708:	c9                   	leaveq 
  800709:	c3                   	retq   

000000000080070a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80070a:	55                   	push   %rbp
  80070b:	48 89 e5             	mov    %rsp,%rbp
  80070e:	48 83 ec 18          	sub    $0x18,%rsp
  800712:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800716:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80071d:	eb 6b                	jmp    80078a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80071f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800722:	48 98                	cltq   
  800724:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80072a:	48 c1 e0 0c          	shl    $0xc,%rax
  80072e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800736:	48 c1 e8 15          	shr    $0x15,%rax
  80073a:	48 89 c2             	mov    %rax,%rdx
  80073d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800744:	01 00 00 
  800747:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80074b:	83 e0 01             	and    $0x1,%eax
  80074e:	48 85 c0             	test   %rax,%rax
  800751:	74 21                	je     800774 <fd_alloc+0x6a>
  800753:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800757:	48 c1 e8 0c          	shr    $0xc,%rax
  80075b:	48 89 c2             	mov    %rax,%rdx
  80075e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800765:	01 00 00 
  800768:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80076c:	83 e0 01             	and    $0x1,%eax
  80076f:	48 85 c0             	test   %rax,%rax
  800772:	75 12                	jne    800786 <fd_alloc+0x7c>
			*fd_store = fd;
  800774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800778:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80077c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80077f:	b8 00 00 00 00       	mov    $0x0,%eax
  800784:	eb 1a                	jmp    8007a0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800786:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80078a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80078e:	7e 8f                	jle    80071f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80079b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8007a0:	c9                   	leaveq 
  8007a1:	c3                   	retq   

00000000008007a2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007a2:	55                   	push   %rbp
  8007a3:	48 89 e5             	mov    %rsp,%rbp
  8007a6:	48 83 ec 20          	sub    $0x20,%rsp
  8007aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8007b5:	78 06                	js     8007bd <fd_lookup+0x1b>
  8007b7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8007bb:	7e 07                	jle    8007c4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c2:	eb 6c                	jmp    800830 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8007c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007c7:	48 98                	cltq   
  8007c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8007cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8007d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8007d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007db:	48 c1 e8 15          	shr    $0x15,%rax
  8007df:	48 89 c2             	mov    %rax,%rdx
  8007e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007e9:	01 00 00 
  8007ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f0:	83 e0 01             	and    $0x1,%eax
  8007f3:	48 85 c0             	test   %rax,%rax
  8007f6:	74 21                	je     800819 <fd_lookup+0x77>
  8007f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007fc:	48 c1 e8 0c          	shr    $0xc,%rax
  800800:	48 89 c2             	mov    %rax,%rdx
  800803:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80080a:	01 00 00 
  80080d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800811:	83 e0 01             	and    $0x1,%eax
  800814:	48 85 c0             	test   %rax,%rax
  800817:	75 07                	jne    800820 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800819:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081e:	eb 10                	jmp    800830 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800820:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800824:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800828:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800830:	c9                   	leaveq 
  800831:	c3                   	retq   

0000000000800832 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800832:	55                   	push   %rbp
  800833:	48 89 e5             	mov    %rsp,%rbp
  800836:	48 83 ec 30          	sub    $0x30,%rsp
  80083a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80083e:	89 f0                	mov    %esi,%eax
  800840:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800847:	48 89 c7             	mov    %rax,%rdi
  80084a:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  800851:	00 00 00 
  800854:	ff d0                	callq  *%rax
  800856:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80085a:	48 89 d6             	mov    %rdx,%rsi
  80085d:	89 c7                	mov    %eax,%edi
  80085f:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800866:	00 00 00 
  800869:	ff d0                	callq  *%rax
  80086b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80086e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800872:	78 0a                	js     80087e <fd_close+0x4c>
	    || fd != fd2)
  800874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800878:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80087c:	74 12                	je     800890 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80087e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800882:	74 05                	je     800889 <fd_close+0x57>
  800884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800887:	eb 05                	jmp    80088e <fd_close+0x5c>
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	eb 69                	jmp    8008f9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80089a:	48 89 d6             	mov    %rdx,%rsi
  80089d:	89 c7                	mov    %eax,%edi
  80089f:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax
  8008ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008b2:	78 2a                	js     8008de <fd_close+0xac>
		if (dev->dev_close)
  8008b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008bc:	48 85 c0             	test   %rax,%rax
  8008bf:	74 16                	je     8008d7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8008c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8008cd:	48 89 d7             	mov    %rdx,%rdi
  8008d0:	ff d0                	callq  *%rax
  8008d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008d5:	eb 07                	jmp    8008de <fd_close+0xac>
		else
			r = 0;
  8008d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8008de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008e2:	48 89 c6             	mov    %rax,%rsi
  8008e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ea:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8008f1:	00 00 00 
  8008f4:	ff d0                	callq  *%rax
	return r;
  8008f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8008f9:	c9                   	leaveq 
  8008fa:	c3                   	retq   

00000000008008fb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008fb:	55                   	push   %rbp
  8008fc:	48 89 e5             	mov    %rsp,%rbp
  8008ff:	48 83 ec 20          	sub    $0x20,%rsp
  800903:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800906:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80090a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800911:	eb 41                	jmp    800954 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800913:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80091a:	00 00 00 
  80091d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800920:	48 63 d2             	movslq %edx,%rdx
  800923:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800927:	8b 00                	mov    (%rax),%eax
  800929:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80092c:	75 22                	jne    800950 <dev_lookup+0x55>
			*dev = devtab[i];
  80092e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800935:	00 00 00 
  800938:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80093b:	48 63 d2             	movslq %edx,%rdx
  80093e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800942:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800946:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	eb 60                	jmp    8009b0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800950:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800954:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80095b:	00 00 00 
  80095e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800961:	48 63 d2             	movslq %edx,%rdx
  800964:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800968:	48 85 c0             	test   %rax,%rax
  80096b:	75 a6                	jne    800913 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80096d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800974:	00 00 00 
  800977:	48 8b 00             	mov    (%rax),%rax
  80097a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800980:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800983:	89 c6                	mov    %eax,%esi
  800985:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  80098c:	00 00 00 
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	48 b9 81 29 80 00 00 	movabs $0x802981,%rcx
  80099b:	00 00 00 
  80099e:	ff d1                	callq  *%rcx
	*dev = 0;
  8009a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8009ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8009b0:	c9                   	leaveq 
  8009b1:	c3                   	retq   

00000000008009b2 <close>:

int
close(int fdnum)
{
  8009b2:	55                   	push   %rbp
  8009b3:	48 89 e5             	mov    %rsp,%rbp
  8009b6:	48 83 ec 20          	sub    $0x20,%rsp
  8009ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8009c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8009c4:	48 89 d6             	mov    %rdx,%rsi
  8009c7:	89 c7                	mov    %eax,%edi
  8009c9:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  8009d0:	00 00 00 
  8009d3:	ff d0                	callq  *%rax
  8009d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009dc:	79 05                	jns    8009e3 <close+0x31>
		return r;
  8009de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009e1:	eb 18                	jmp    8009fb <close+0x49>
	else
		return fd_close(fd, 1);
  8009e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009e7:	be 01 00 00 00       	mov    $0x1,%esi
  8009ec:	48 89 c7             	mov    %rax,%rdi
  8009ef:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  8009f6:	00 00 00 
  8009f9:	ff d0                	callq  *%rax
}
  8009fb:	c9                   	leaveq 
  8009fc:	c3                   	retq   

00000000008009fd <close_all>:

void
close_all(void)
{
  8009fd:	55                   	push   %rbp
  8009fe:	48 89 e5             	mov    %rsp,%rbp
  800a01:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800a0c:	eb 15                	jmp    800a23 <close_all+0x26>
		close(i);
  800a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  800a1a:	00 00 00 
  800a1d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800a1f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800a23:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800a27:	7e e5                	jle    800a0e <close_all+0x11>
		close(i);
}
  800a29:	c9                   	leaveq 
  800a2a:	c3                   	retq   

0000000000800a2b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800a2b:	55                   	push   %rbp
  800a2c:	48 89 e5             	mov    %rsp,%rbp
  800a2f:	48 83 ec 40          	sub    $0x40,%rsp
  800a33:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800a36:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a39:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800a3d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800a40:	48 89 d6             	mov    %rdx,%rsi
  800a43:	89 c7                	mov    %eax,%edi
  800a45:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a58:	79 08                	jns    800a62 <dup+0x37>
		return r;
  800a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a5d:	e9 70 01 00 00       	jmpq   800bd2 <dup+0x1a7>
	close(newfdnum);
  800a62:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a65:	89 c7                	mov    %eax,%edi
  800a67:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  800a6e:	00 00 00 
  800a71:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a73:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a76:	48 98                	cltq   
  800a78:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a7e:	48 c1 e0 0c          	shl    $0xc,%rax
  800a82:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800aa1:	48 89 c7             	mov    %rax,%rdi
  800aa4:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	callq  *%rax
  800ab0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 c1 e8 15          	shr    $0x15,%rax
  800abc:	48 89 c2             	mov    %rax,%rdx
  800abf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800ac6:	01 00 00 
  800ac9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800acd:	83 e0 01             	and    $0x1,%eax
  800ad0:	48 85 c0             	test   %rax,%rax
  800ad3:	74 73                	je     800b48 <dup+0x11d>
  800ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad9:	48 c1 e8 0c          	shr    $0xc,%rax
  800add:	48 89 c2             	mov    %rax,%rdx
  800ae0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ae7:	01 00 00 
  800aea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800aee:	83 e0 01             	and    $0x1,%eax
  800af1:	48 85 c0             	test   %rax,%rax
  800af4:	74 52                	je     800b48 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afa:	48 c1 e8 0c          	shr    $0xc,%rax
  800afe:	48 89 c2             	mov    %rax,%rdx
  800b01:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b08:	01 00 00 
  800b0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b0f:	25 07 0e 00 00       	and    $0xe07,%eax
  800b14:	89 c1                	mov    %eax,%ecx
  800b16:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1e:	41 89 c8             	mov    %ecx,%r8d
  800b21:	48 89 d1             	mov    %rdx,%rcx
  800b24:	ba 00 00 00 00       	mov    $0x0,%edx
  800b29:	48 89 c6             	mov    %rax,%rsi
  800b2c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b31:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800b38:	00 00 00 
  800b3b:	ff d0                	callq  *%rax
  800b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b44:	79 02                	jns    800b48 <dup+0x11d>
			goto err;
  800b46:	eb 57                	jmp    800b9f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b4c:	48 c1 e8 0c          	shr    $0xc,%rax
  800b50:	48 89 c2             	mov    %rax,%rdx
  800b53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800b5a:	01 00 00 
  800b5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800b61:	25 07 0e 00 00       	and    $0xe07,%eax
  800b66:	89 c1                	mov    %eax,%ecx
  800b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b70:	41 89 c8             	mov    %ecx,%r8d
  800b73:	48 89 d1             	mov    %rdx,%rcx
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	48 89 c6             	mov    %rax,%rsi
  800b7e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b83:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800b8a:	00 00 00 
  800b8d:	ff d0                	callq  *%rax
  800b8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b96:	79 02                	jns    800b9a <dup+0x16f>
		goto err;
  800b98:	eb 05                	jmp    800b9f <dup+0x174>

	return newfdnum;
  800b9a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b9d:	eb 33                	jmp    800bd2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ba3:	48 89 c6             	mov    %rax,%rsi
  800ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bab:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800bb2:	00 00 00 
  800bb5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800bbb:	48 89 c6             	mov    %rax,%rsi
  800bbe:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc3:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800bca:	00 00 00 
  800bcd:	ff d0                	callq  *%rax
	return r;
  800bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bd2:	c9                   	leaveq 
  800bd3:	c3                   	retq   

0000000000800bd4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800bd4:	55                   	push   %rbp
  800bd5:	48 89 e5             	mov    %rsp,%rbp
  800bd8:	48 83 ec 40          	sub    $0x40,%rsp
  800bdc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bdf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800be3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800beb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bee:	48 89 d6             	mov    %rdx,%rsi
  800bf1:	89 c7                	mov    %eax,%edi
  800bf3:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c06:	78 24                	js     800c2c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0c:	8b 00                	mov    (%rax),%eax
  800c0e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c12:	48 89 d6             	mov    %rdx,%rsi
  800c15:	89 c7                	mov    %eax,%edi
  800c17:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  800c1e:	00 00 00 
  800c21:	ff d0                	callq  *%rax
  800c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c2a:	79 05                	jns    800c31 <read+0x5d>
		return r;
  800c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c2f:	eb 76                	jmp    800ca7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c35:	8b 40 08             	mov    0x8(%rax),%eax
  800c38:	83 e0 03             	and    $0x3,%eax
  800c3b:	83 f8 01             	cmp    $0x1,%eax
  800c3e:	75 3a                	jne    800c7a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c40:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800c47:	00 00 00 
  800c4a:	48 8b 00             	mov    (%rax),%rax
  800c4d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c53:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c56:	89 c6                	mov    %eax,%esi
  800c58:	48 bf 17 40 80 00 00 	movabs $0x804017,%rdi
  800c5f:	00 00 00 
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	48 b9 81 29 80 00 00 	movabs $0x802981,%rcx
  800c6e:	00 00 00 
  800c71:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c78:	eb 2d                	jmp    800ca7 <read+0xd3>
	}
	if (!dev->dev_read)
  800c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c82:	48 85 c0             	test   %rax,%rax
  800c85:	75 07                	jne    800c8e <read+0xba>
		return -E_NOT_SUPP;
  800c87:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c8c:	eb 19                	jmp    800ca7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c92:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c96:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c9a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800ca2:	48 89 cf             	mov    %rcx,%rdi
  800ca5:	ff d0                	callq  *%rax
}
  800ca7:	c9                   	leaveq 
  800ca8:	c3                   	retq   

0000000000800ca9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ca9:	55                   	push   %rbp
  800caa:	48 89 e5             	mov    %rsp,%rbp
  800cad:	48 83 ec 30          	sub    $0x30,%rsp
  800cb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800cb8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800cc3:	eb 49                	jmp    800d0e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cc8:	48 98                	cltq   
  800cca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800cce:	48 29 c2             	sub    %rax,%rdx
  800cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd4:	48 63 c8             	movslq %eax,%rcx
  800cd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cdb:	48 01 c1             	add    %rax,%rcx
  800cde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ce1:	48 89 ce             	mov    %rcx,%rsi
  800ce4:	89 c7                	mov    %eax,%edi
  800ce6:	48 b8 d4 0b 80 00 00 	movabs $0x800bd4,%rax
  800ced:	00 00 00 
  800cf0:	ff d0                	callq  *%rax
  800cf2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800cf5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800cf9:	79 05                	jns    800d00 <readn+0x57>
			return m;
  800cfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cfe:	eb 1c                	jmp    800d1c <readn+0x73>
		if (m == 0)
  800d00:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800d04:	75 02                	jne    800d08 <readn+0x5f>
			break;
  800d06:	eb 11                	jmp    800d19 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d0b:	01 45 fc             	add    %eax,-0x4(%rbp)
  800d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d11:	48 98                	cltq   
  800d13:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800d17:	72 ac                	jb     800cc5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d1c:	c9                   	leaveq 
  800d1d:	c3                   	retq   

0000000000800d1e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d1e:	55                   	push   %rbp
  800d1f:	48 89 e5             	mov    %rsp,%rbp
  800d22:	48 83 ec 40          	sub    $0x40,%rsp
  800d26:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d29:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800d2d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d31:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d35:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d38:	48 89 d6             	mov    %rdx,%rsi
  800d3b:	89 c7                	mov    %eax,%edi
  800d3d:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
  800d49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d50:	78 24                	js     800d76 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d56:	8b 00                	mov    (%rax),%eax
  800d58:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d5c:	48 89 d6             	mov    %rdx,%rsi
  800d5f:	89 c7                	mov    %eax,%edi
  800d61:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  800d68:	00 00 00 
  800d6b:	ff d0                	callq  *%rax
  800d6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d74:	79 05                	jns    800d7b <write+0x5d>
		return r;
  800d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d79:	eb 75                	jmp    800df0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7f:	8b 40 08             	mov    0x8(%rax),%eax
  800d82:	83 e0 03             	and    $0x3,%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	75 3a                	jne    800dc3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d89:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d90:	00 00 00 
  800d93:	48 8b 00             	mov    (%rax),%rax
  800d96:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d9c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d9f:	89 c6                	mov    %eax,%esi
  800da1:	48 bf 33 40 80 00 00 	movabs $0x804033,%rdi
  800da8:	00 00 00 
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
  800db0:	48 b9 81 29 80 00 00 	movabs $0x802981,%rcx
  800db7:	00 00 00 
  800dba:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800dbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dc1:	eb 2d                	jmp    800df0 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc7:	48 8b 40 18          	mov    0x18(%rax),%rax
  800dcb:	48 85 c0             	test   %rax,%rax
  800dce:	75 07                	jne    800dd7 <write+0xb9>
		return -E_NOT_SUPP;
  800dd0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dd5:	eb 19                	jmp    800df0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddb:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ddf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800de3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800de7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800deb:	48 89 cf             	mov    %rcx,%rdi
  800dee:	ff d0                	callq  *%rax
}
  800df0:	c9                   	leaveq 
  800df1:	c3                   	retq   

0000000000800df2 <seek>:

int
seek(int fdnum, off_t offset)
{
  800df2:	55                   	push   %rbp
  800df3:	48 89 e5             	mov    %rsp,%rbp
  800df6:	48 83 ec 18          	sub    $0x18,%rsp
  800dfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800dfd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e00:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800e07:	48 89 d6             	mov    %rdx,%rsi
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e1f:	79 05                	jns    800e26 <seek+0x34>
		return r;
  800e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e24:	eb 0f                	jmp    800e35 <seek+0x43>
	fd->fd_offset = offset;
  800e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800e2d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 83 ec 30          	sub    $0x30,%rsp
  800e3f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e42:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e4c:	48 89 d6             	mov    %rdx,%rsi
  800e4f:	89 c7                	mov    %eax,%edi
  800e51:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800e58:	00 00 00 
  800e5b:	ff d0                	callq  *%rax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e64:	78 24                	js     800e8a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6a:	8b 00                	mov    (%rax),%eax
  800e6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e70:	48 89 d6             	mov    %rdx,%rsi
  800e73:	89 c7                	mov    %eax,%edi
  800e75:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  800e7c:	00 00 00 
  800e7f:	ff d0                	callq  *%rax
  800e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e88:	79 05                	jns    800e8f <ftruncate+0x58>
		return r;
  800e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8d:	eb 72                	jmp    800f01 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	8b 40 08             	mov    0x8(%rax),%eax
  800e96:	83 e0 03             	and    $0x3,%eax
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 3a                	jne    800ed7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e9d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800ea4:	00 00 00 
  800ea7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800eaa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800eb0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800eb3:	89 c6                	mov    %eax,%esi
  800eb5:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  800ebc:	00 00 00 
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	48 b9 81 29 80 00 00 	movabs $0x802981,%rcx
  800ecb:	00 00 00 
  800ece:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800ed0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed5:	eb 2a                	jmp    800f01 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edb:	48 8b 40 30          	mov    0x30(%rax),%rax
  800edf:	48 85 c0             	test   %rax,%rax
  800ee2:	75 07                	jne    800eeb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800ee4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ee9:	eb 16                	jmp    800f01 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eef:	48 8b 40 30          	mov    0x30(%rax),%rax
  800ef3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800efa:	89 ce                	mov    %ecx,%esi
  800efc:	48 89 d7             	mov    %rdx,%rdi
  800eff:	ff d0                	callq  *%rax
}
  800f01:	c9                   	leaveq 
  800f02:	c3                   	retq   

0000000000800f03 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800f03:	55                   	push   %rbp
  800f04:	48 89 e5             	mov    %rsp,%rbp
  800f07:	48 83 ec 30          	sub    $0x30,%rsp
  800f0b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800f0e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f12:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800f16:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800f19:	48 89 d6             	mov    %rdx,%rsi
  800f1c:	89 c7                	mov    %eax,%edi
  800f1e:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  800f25:	00 00 00 
  800f28:	ff d0                	callq  *%rax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f31:	78 24                	js     800f57 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f37:	8b 00                	mov    (%rax),%eax
  800f39:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f3d:	48 89 d6             	mov    %rdx,%rsi
  800f40:	89 c7                	mov    %eax,%edi
  800f42:	48 b8 fb 08 80 00 00 	movabs $0x8008fb,%rax
  800f49:	00 00 00 
  800f4c:	ff d0                	callq  *%rax
  800f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f55:	79 05                	jns    800f5c <fstat+0x59>
		return r;
  800f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f5a:	eb 5e                	jmp    800fba <fstat+0xb7>
	if (!dev->dev_stat)
  800f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f60:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f64:	48 85 c0             	test   %rax,%rax
  800f67:	75 07                	jne    800f70 <fstat+0x6d>
		return -E_NOT_SUPP;
  800f69:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f6e:	eb 4a                	jmp    800fba <fstat+0xb7>
	stat->st_name[0] = 0;
  800f70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f74:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f82:	00 00 00 
	stat->st_isdir = 0;
  800f85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f89:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f90:	00 00 00 
	stat->st_dev = dev;
  800f93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f9b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800fa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa6:	48 8b 40 28          	mov    0x28(%rax),%rax
  800faa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fae:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800fb2:	48 89 ce             	mov    %rcx,%rsi
  800fb5:	48 89 d7             	mov    %rdx,%rdi
  800fb8:	ff d0                	callq  *%rax
}
  800fba:	c9                   	leaveq 
  800fbb:	c3                   	retq   

0000000000800fbc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800fbc:	55                   	push   %rbp
  800fbd:	48 89 e5             	mov    %rsp,%rbp
  800fc0:	48 83 ec 20          	sub    $0x20,%rsp
  800fc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd0:	be 00 00 00 00       	mov    $0x0,%esi
  800fd5:	48 89 c7             	mov    %rax,%rdi
  800fd8:	48 b8 aa 10 80 00 00 	movabs $0x8010aa,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fe7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800feb:	79 05                	jns    800ff2 <stat+0x36>
		return fd;
  800fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff0:	eb 2f                	jmp    801021 <stat+0x65>
	r = fstat(fd, stat);
  800ff2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff9:	48 89 d6             	mov    %rdx,%rsi
  800ffc:	89 c7                	mov    %eax,%edi
  800ffe:	48 b8 03 0f 80 00 00 	movabs $0x800f03,%rax
  801005:	00 00 00 
  801008:	ff d0                	callq  *%rax
  80100a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80100d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801010:	89 c7                	mov    %eax,%edi
  801012:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  801019:	00 00 00 
  80101c:	ff d0                	callq  *%rax
	return r;
  80101e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 10          	sub    $0x10,%rsp
  80102b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80102e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801032:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801039:	00 00 00 
  80103c:	8b 00                	mov    (%rax),%eax
  80103e:	85 c0                	test   %eax,%eax
  801040:	75 1d                	jne    80105f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801042:	bf 01 00 00 00       	mov    $0x1,%edi
  801047:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  80104e:	00 00 00 
  801051:	ff d0                	callq  *%rax
  801053:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80105a:	00 00 00 
  80105d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80105f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801066:	00 00 00 
  801069:	8b 00                	mov    (%rax),%eax
  80106b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80106e:	b9 07 00 00 00       	mov    $0x7,%ecx
  801073:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80107a:	00 00 00 
  80107d:	89 c7                	mov    %eax,%edi
  80107f:	48 b8 4e 3e 80 00 00 	movabs $0x803e4e,%rax
  801086:	00 00 00 
  801089:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80108b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	48 89 c6             	mov    %rax,%rsi
  801097:	bf 00 00 00 00       	mov    $0x0,%edi
  80109c:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax
}
  8010a8:	c9                   	leaveq 
  8010a9:	c3                   	retq   

00000000008010aa <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8010aa:	55                   	push   %rbp
  8010ab:	48 89 e5             	mov    %rsp,%rbp
  8010ae:	48 83 ec 30          	sub    $0x30,%rsp
  8010b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8010b6:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8010b9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8010c0:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8010c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8010ce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010d3:	75 08                	jne    8010dd <open+0x33>
	{
		return r;
  8010d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d8:	e9 f2 00 00 00       	jmpq   8011cf <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8010dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010e1:	48 89 c7             	mov    %rax,%rdi
  8010e4:	48 b8 ca 34 80 00 00 	movabs $0x8034ca,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	callq  *%rax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8010f3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8010fa:	7e 0a                	jle    801106 <open+0x5c>
	{
		return -E_BAD_PATH;
  8010fc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801101:	e9 c9 00 00 00       	jmpq   8011cf <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801106:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80110d:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80110e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801112:	48 89 c7             	mov    %rax,%rdi
  801115:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  80111c:	00 00 00 
  80111f:	ff d0                	callq  *%rax
  801121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801128:	78 09                	js     801133 <open+0x89>
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112e:	48 85 c0             	test   %rax,%rax
  801131:	75 08                	jne    80113b <open+0x91>
		{
			return r;
  801133:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801136:	e9 94 00 00 00       	jmpq   8011cf <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80113b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80113f:	ba 00 04 00 00       	mov    $0x400,%edx
  801144:	48 89 c6             	mov    %rax,%rsi
  801147:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80114e:	00 00 00 
  801151:	48 b8 c8 35 80 00 00 	movabs $0x8035c8,%rax
  801158:	00 00 00 
  80115b:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80115d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801164:	00 00 00 
  801167:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80116a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	48 89 c6             	mov    %rax,%rsi
  801177:	bf 01 00 00 00       	mov    $0x1,%edi
  80117c:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  801183:	00 00 00 
  801186:	ff d0                	callq  *%rax
  801188:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80118b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80118f:	79 2b                	jns    8011bc <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801195:	be 00 00 00 00       	mov    $0x0,%esi
  80119a:	48 89 c7             	mov    %rax,%rdi
  80119d:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  8011a4:	00 00 00 
  8011a7:	ff d0                	callq  *%rax
  8011a9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8011ac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8011b0:	79 05                	jns    8011b7 <open+0x10d>
			{
				return d;
  8011b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011b5:	eb 18                	jmp    8011cf <open+0x125>
			}
			return r;
  8011b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ba:	eb 13                	jmp    8011cf <open+0x125>
		}	
		return fd2num(fd_store);
  8011bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c0:	48 89 c7             	mov    %rax,%rdi
  8011c3:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  8011ca:	00 00 00 
  8011cd:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8011cf:	c9                   	leaveq 
  8011d0:	c3                   	retq   

00000000008011d1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8011d1:	55                   	push   %rbp
  8011d2:	48 89 e5             	mov    %rsp,%rbp
  8011d5:	48 83 ec 10          	sub    $0x10,%rsp
  8011d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8011dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e1:	8b 50 0c             	mov    0xc(%rax),%edx
  8011e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011eb:	00 00 00 
  8011ee:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8011f0:	be 00 00 00 00       	mov    $0x0,%esi
  8011f5:	bf 06 00 00 00       	mov    $0x6,%edi
  8011fa:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  801201:	00 00 00 
  801204:	ff d0                	callq  *%rax
}
  801206:	c9                   	leaveq 
  801207:	c3                   	retq   

0000000000801208 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801208:	55                   	push   %rbp
  801209:	48 89 e5             	mov    %rsp,%rbp
  80120c:	48 83 ec 30          	sub    $0x30,%rsp
  801210:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801218:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801223:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801228:	74 07                	je     801231 <devfile_read+0x29>
  80122a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80122f:	75 07                	jne    801238 <devfile_read+0x30>
		return -E_INVAL;
  801231:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801236:	eb 77                	jmp    8012af <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123c:	8b 50 0c             	mov    0xc(%rax),%edx
  80123f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801246:	00 00 00 
  801249:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80124b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801252:	00 00 00 
  801255:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801259:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80125d:	be 00 00 00 00       	mov    $0x0,%esi
  801262:	bf 03 00 00 00       	mov    $0x3,%edi
  801267:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  80126e:	00 00 00 
  801271:	ff d0                	callq  *%rax
  801273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80127a:	7f 05                	jg     801281 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80127c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127f:	eb 2e                	jmp    8012af <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801284:	48 63 d0             	movslq %eax,%rdx
  801287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801292:	00 00 00 
  801295:	48 89 c7             	mov    %rax,%rdi
  801298:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  80129f:	00 00 00 
  8012a2:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8012a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8012ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8012af:	c9                   	leaveq 
  8012b0:	c3                   	retq   

00000000008012b1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012b1:	55                   	push   %rbp
  8012b2:	48 89 e5             	mov    %rsp,%rbp
  8012b5:	48 83 ec 30          	sub    $0x30,%rsp
  8012b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8012c5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8012cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d1:	74 07                	je     8012da <devfile_write+0x29>
  8012d3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012d8:	75 08                	jne    8012e2 <devfile_write+0x31>
		return r;
  8012da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012dd:	e9 9a 00 00 00       	jmpq   80137c <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e6:	8b 50 0c             	mov    0xc(%rax),%edx
  8012e9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012f0:	00 00 00 
  8012f3:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8012f5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8012fc:	00 
  8012fd:	76 08                	jbe    801307 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8012ff:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801306:	00 
	}
	fsipcbuf.write.req_n = n;
  801307:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80130e:	00 00 00 
  801311:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801315:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801319:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80131d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801321:	48 89 c6             	mov    %rax,%rsi
  801324:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80132b:	00 00 00 
  80132e:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801335:	00 00 00 
  801338:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80133a:	be 00 00 00 00       	mov    $0x0,%esi
  80133f:	bf 04 00 00 00       	mov    $0x4,%edi
  801344:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  80134b:	00 00 00 
  80134e:	ff d0                	callq  *%rax
  801350:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801353:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801357:	7f 20                	jg     801379 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801359:	48 bf 76 40 80 00 00 	movabs $0x804076,%rdi
  801360:	00 00 00 
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  80136f:	00 00 00 
  801372:	ff d2                	callq  *%rdx
		return r;
  801374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801377:	eb 03                	jmp    80137c <devfile_write+0xcb>
	}
	return r;
  801379:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 20          	sub    $0x20,%rsp
  801386:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801392:	8b 50 0c             	mov    0xc(%rax),%edx
  801395:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80139c:	00 00 00 
  80139f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013a1:	be 00 00 00 00       	mov    $0x0,%esi
  8013a6:	bf 05 00 00 00       	mov    $0x5,%edi
  8013ab:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  8013b2:	00 00 00 
  8013b5:	ff d0                	callq  *%rax
  8013b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013be:	79 05                	jns    8013c5 <devfile_stat+0x47>
		return r;
  8013c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c3:	eb 56                	jmp    80141b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8013d0:	00 00 00 
  8013d3:	48 89 c7             	mov    %rax,%rdi
  8013d6:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  8013dd:	00 00 00 
  8013e0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8013e2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013e9:	00 00 00 
  8013ec:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8013f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801403:	00 00 00 
  801406:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80140c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801410:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141b:	c9                   	leaveq 
  80141c:	c3                   	retq   

000000000080141d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80141d:	55                   	push   %rbp
  80141e:	48 89 e5             	mov    %rsp,%rbp
  801421:	48 83 ec 10          	sub    $0x10,%rsp
  801425:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801429:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80142c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801430:	8b 50 0c             	mov    0xc(%rax),%edx
  801433:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80143a:	00 00 00 
  80143d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80143f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801446:	00 00 00 
  801449:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80144c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80144f:	be 00 00 00 00       	mov    $0x0,%esi
  801454:	bf 02 00 00 00       	mov    $0x2,%edi
  801459:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  801460:	00 00 00 
  801463:	ff d0                	callq  *%rax
}
  801465:	c9                   	leaveq 
  801466:	c3                   	retq   

0000000000801467 <remove>:

// Delete a file
int
remove(const char *path)
{
  801467:	55                   	push   %rbp
  801468:	48 89 e5             	mov    %rsp,%rbp
  80146b:	48 83 ec 10          	sub    $0x10,%rsp
  80146f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	48 89 c7             	mov    %rax,%rdi
  80147a:	48 b8 ca 34 80 00 00 	movabs $0x8034ca,%rax
  801481:	00 00 00 
  801484:	ff d0                	callq  *%rax
  801486:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80148b:	7e 07                	jle    801494 <remove+0x2d>
		return -E_BAD_PATH;
  80148d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801492:	eb 33                	jmp    8014c7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	48 89 c6             	mov    %rax,%rsi
  80149b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8014a2:	00 00 00 
  8014a5:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  8014ac:	00 00 00 
  8014af:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8014b1:	be 00 00 00 00       	mov    $0x0,%esi
  8014b6:	bf 07 00 00 00       	mov    $0x7,%edi
  8014bb:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	callq  *%rax
}
  8014c7:	c9                   	leaveq 
  8014c8:	c3                   	retq   

00000000008014c9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8014c9:	55                   	push   %rbp
  8014ca:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8014cd:	be 00 00 00 00       	mov    $0x0,%esi
  8014d2:	bf 08 00 00 00       	mov    $0x8,%edi
  8014d7:	48 b8 23 10 80 00 00 	movabs $0x801023,%rax
  8014de:	00 00 00 
  8014e1:	ff d0                	callq  *%rax
}
  8014e3:	5d                   	pop    %rbp
  8014e4:	c3                   	retq   

00000000008014e5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8014e5:	55                   	push   %rbp
  8014e6:	48 89 e5             	mov    %rsp,%rbp
  8014e9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8014f0:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8014f7:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8014fe:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801505:	be 00 00 00 00       	mov    $0x0,%esi
  80150a:	48 89 c7             	mov    %rax,%rdi
  80150d:	48 b8 aa 10 80 00 00 	movabs $0x8010aa,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
  801519:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80151c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801520:	79 28                	jns    80154a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801525:	89 c6                	mov    %eax,%esi
  801527:	48 bf 92 40 80 00 00 	movabs $0x804092,%rdi
  80152e:	00 00 00 
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
  801536:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  80153d:	00 00 00 
  801540:	ff d2                	callq  *%rdx
		return fd_src;
  801542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801545:	e9 74 01 00 00       	jmpq   8016be <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80154a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801551:	be 01 01 00 00       	mov    $0x101,%esi
  801556:	48 89 c7             	mov    %rax,%rdi
  801559:	48 b8 aa 10 80 00 00 	movabs $0x8010aa,%rax
  801560:	00 00 00 
  801563:	ff d0                	callq  *%rax
  801565:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801568:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80156c:	79 39                	jns    8015a7 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80156e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801571:	89 c6                	mov    %eax,%esi
  801573:	48 bf a8 40 80 00 00 	movabs $0x8040a8,%rdi
  80157a:	00 00 00 
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  801589:	00 00 00 
  80158c:	ff d2                	callq  *%rdx
		close(fd_src);
  80158e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801591:	89 c7                	mov    %eax,%edi
  801593:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  80159a:	00 00 00 
  80159d:	ff d0                	callq  *%rax
		return fd_dest;
  80159f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015a2:	e9 17 01 00 00       	jmpq   8016be <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8015a7:	eb 74                	jmp    80161d <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8015a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ac:	48 63 d0             	movslq %eax,%rdx
  8015af:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8015b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015b9:	48 89 ce             	mov    %rcx,%rsi
  8015bc:	89 c7                	mov    %eax,%edi
  8015be:	48 b8 1e 0d 80 00 00 	movabs $0x800d1e,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	callq  *%rax
  8015ca:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8015cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8015d1:	79 4a                	jns    80161d <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8015d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015d6:	89 c6                	mov    %eax,%esi
  8015d8:	48 bf c2 40 80 00 00 	movabs $0x8040c2,%rdi
  8015df:	00 00 00 
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  8015ee:	00 00 00 
  8015f1:	ff d2                	callq  *%rdx
			close(fd_src);
  8015f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015f6:	89 c7                	mov    %eax,%edi
  8015f8:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  8015ff:	00 00 00 
  801602:	ff d0                	callq  *%rax
			close(fd_dest);
  801604:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801607:	89 c7                	mov    %eax,%edi
  801609:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  801610:	00 00 00 
  801613:	ff d0                	callq  *%rax
			return write_size;
  801615:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801618:	e9 a1 00 00 00       	jmpq   8016be <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80161d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801627:	ba 00 02 00 00       	mov    $0x200,%edx
  80162c:	48 89 ce             	mov    %rcx,%rsi
  80162f:	89 c7                	mov    %eax,%edi
  801631:	48 b8 d4 0b 80 00 00 	movabs $0x800bd4,%rax
  801638:	00 00 00 
  80163b:	ff d0                	callq  *%rax
  80163d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801640:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801644:	0f 8f 5f ff ff ff    	jg     8015a9 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80164a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80164e:	79 47                	jns    801697 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801650:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801653:	89 c6                	mov    %eax,%esi
  801655:	48 bf d5 40 80 00 00 	movabs $0x8040d5,%rdi
  80165c:	00 00 00 
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
  801664:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  80166b:	00 00 00 
  80166e:	ff d2                	callq  *%rdx
		close(fd_src);
  801670:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801673:	89 c7                	mov    %eax,%edi
  801675:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  80167c:	00 00 00 
  80167f:	ff d0                	callq  *%rax
		close(fd_dest);
  801681:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801684:	89 c7                	mov    %eax,%edi
  801686:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  80168d:	00 00 00 
  801690:	ff d0                	callq  *%rax
		return read_size;
  801692:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801695:	eb 27                	jmp    8016be <copy+0x1d9>
	}
	close(fd_src);
  801697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80169a:	89 c7                	mov    %eax,%edi
  80169c:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  8016a3:	00 00 00 
  8016a6:	ff d0                	callq  *%rax
	close(fd_dest);
  8016a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016ab:	89 c7                	mov    %eax,%edi
  8016ad:	48 b8 b2 09 80 00 00 	movabs $0x8009b2,%rax
  8016b4:	00 00 00 
  8016b7:	ff d0                	callq  *%rax
	return 0;
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8016be:	c9                   	leaveq 
  8016bf:	c3                   	retq   

00000000008016c0 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8016c0:	55                   	push   %rbp
  8016c1:	48 89 e5             	mov    %rsp,%rbp
  8016c4:	48 83 ec 20          	sub    $0x20,%rsp
  8016c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8016cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d2:	48 89 d6             	mov    %rdx,%rsi
  8016d5:	89 c7                	mov    %eax,%edi
  8016d7:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  8016de:	00 00 00 
  8016e1:	ff d0                	callq  *%rax
  8016e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ea:	79 05                	jns    8016f1 <fd2sockid+0x31>
		return r;
  8016ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ef:	eb 24                	jmp    801715 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f5:	8b 10                	mov    (%rax),%edx
  8016f7:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8016fe:	00 00 00 
  801701:	8b 00                	mov    (%rax),%eax
  801703:	39 c2                	cmp    %eax,%edx
  801705:	74 07                	je     80170e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801707:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80170c:	eb 07                	jmp    801715 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80170e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801712:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801715:	c9                   	leaveq 
  801716:	c3                   	retq   

0000000000801717 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801717:	55                   	push   %rbp
  801718:	48 89 e5             	mov    %rsp,%rbp
  80171b:	48 83 ec 20          	sub    $0x20,%rsp
  80171f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801722:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  801730:	00 00 00 
  801733:	ff d0                	callq  *%rax
  801735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80173c:	78 26                	js     801764 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80173e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801742:	ba 07 04 00 00       	mov    $0x407,%edx
  801747:	48 89 c6             	mov    %rax,%rsi
  80174a:	bf 00 00 00 00       	mov    $0x0,%edi
  80174f:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80175e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801762:	79 16                	jns    80177a <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801764:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801767:	89 c7                	mov    %eax,%edi
  801769:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  801770:	00 00 00 
  801773:	ff d0                	callq  *%rax
		return r;
  801775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801778:	eb 3a                	jmp    8017b4 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80177a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177e:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801785:	00 00 00 
  801788:	8b 12                	mov    (%rdx),%edx
  80178a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80179e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8017a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a5:	48 89 c7             	mov    %rax,%rdi
  8017a8:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  8017af:	00 00 00 
  8017b2:	ff d0                	callq  *%rax
}
  8017b4:	c9                   	leaveq 
  8017b5:	c3                   	retq   

00000000008017b6 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017b6:	55                   	push   %rbp
  8017b7:	48 89 e5             	mov    %rsp,%rbp
  8017ba:	48 83 ec 30          	sub    $0x30,%rsp
  8017be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017cc:	89 c7                	mov    %eax,%edi
  8017ce:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  8017d5:	00 00 00 
  8017d8:	ff d0                	callq  *%rax
  8017da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017e1:	79 05                	jns    8017e8 <accept+0x32>
		return r;
  8017e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e6:	eb 3b                	jmp    801823 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ec:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f3:	48 89 ce             	mov    %rcx,%rsi
  8017f6:	89 c7                	mov    %eax,%edi
  8017f8:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	callq  *%rax
  801804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80180b:	79 05                	jns    801812 <accept+0x5c>
		return r;
  80180d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801810:	eb 11                	jmp    801823 <accept+0x6d>
	return alloc_sockfd(r);
  801812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801815:	89 c7                	mov    %eax,%edi
  801817:	48 b8 17 17 80 00 00 	movabs $0x801717,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
}
  801823:	c9                   	leaveq 
  801824:	c3                   	retq   

0000000000801825 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	48 83 ec 20          	sub    $0x20,%rsp
  80182d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801830:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801834:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801837:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183a:	89 c7                	mov    %eax,%edi
  80183c:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801843:	00 00 00 
  801846:	ff d0                	callq  *%rax
  801848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80184b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80184f:	79 05                	jns    801856 <bind+0x31>
		return r;
  801851:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801854:	eb 1b                	jmp    801871 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  801856:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801859:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80185d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801860:	48 89 ce             	mov    %rcx,%rsi
  801863:	89 c7                	mov    %eax,%edi
  801865:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  80186c:	00 00 00 
  80186f:	ff d0                	callq  *%rax
}
  801871:	c9                   	leaveq 
  801872:	c3                   	retq   

0000000000801873 <shutdown>:

int
shutdown(int s, int how)
{
  801873:	55                   	push   %rbp
  801874:	48 89 e5             	mov    %rsp,%rbp
  801877:	48 83 ec 20          	sub    $0x20,%rsp
  80187b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80187e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801881:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801884:	89 c7                	mov    %eax,%edi
  801886:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  80188d:	00 00 00 
  801890:	ff d0                	callq  *%rax
  801892:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801899:	79 05                	jns    8018a0 <shutdown+0x2d>
		return r;
  80189b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189e:	eb 16                	jmp    8018b6 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8018a0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a6:	89 d6                	mov    %edx,%esi
  8018a8:	89 c7                	mov    %eax,%edi
  8018aa:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
}
  8018b6:	c9                   	leaveq 
  8018b7:	c3                   	retq   

00000000008018b8 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 10          	sub    $0x10,%rsp
  8018c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8018c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c8:	48 89 c7             	mov    %rax,%rdi
  8018cb:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	callq  *%rax
  8018d7:	83 f8 01             	cmp    $0x1,%eax
  8018da:	75 17                	jne    8018f3 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8018dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e0:	8b 40 0c             	mov    0xc(%rax),%eax
  8018e3:	89 c7                	mov    %eax,%edi
  8018e5:	48 b8 24 1c 80 00 00 	movabs $0x801c24,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	callq  *%rax
  8018f1:	eb 05                	jmp    8018f8 <devsock_close+0x40>
	else
		return 0;
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f8:	c9                   	leaveq 
  8018f9:	c3                   	retq   

00000000008018fa <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8018fa:	55                   	push   %rbp
  8018fb:	48 89 e5             	mov    %rsp,%rbp
  8018fe:	48 83 ec 20          	sub    $0x20,%rsp
  801902:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801905:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801909:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80190c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80190f:	89 c7                	mov    %eax,%edi
  801911:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801918:	00 00 00 
  80191b:	ff d0                	callq  *%rax
  80191d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801924:	79 05                	jns    80192b <connect+0x31>
		return r;
  801926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801929:	eb 1b                	jmp    801946 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80192b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80192e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801935:	48 89 ce             	mov    %rcx,%rsi
  801938:	89 c7                	mov    %eax,%edi
  80193a:	48 b8 51 1c 80 00 00 	movabs $0x801c51,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
}
  801946:	c9                   	leaveq 
  801947:	c3                   	retq   

0000000000801948 <listen>:

int
listen(int s, int backlog)
{
  801948:	55                   	push   %rbp
  801949:	48 89 e5             	mov    %rsp,%rbp
  80194c:	48 83 ec 20          	sub    $0x20,%rsp
  801950:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801953:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801956:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801959:	89 c7                	mov    %eax,%edi
  80195b:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
  801967:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80196a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80196e:	79 05                	jns    801975 <listen+0x2d>
		return r;
  801970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801973:	eb 16                	jmp    80198b <listen+0x43>
	return nsipc_listen(r, backlog);
  801975:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	89 d6                	mov    %edx,%esi
  80197d:	89 c7                	mov    %eax,%edi
  80197f:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 20          	sub    $0x20,%rsp
  801995:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801999:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ab:	8b 40 0c             	mov    0xc(%rax),%eax
  8019ae:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8019b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b7:	89 c7                	mov    %eax,%edi
  8019b9:	48 b8 f5 1c 80 00 00 	movabs $0x801cf5,%rax
  8019c0:	00 00 00 
  8019c3:	ff d0                	callq  *%rax
}
  8019c5:	c9                   	leaveq 
  8019c6:	c3                   	retq   

00000000008019c7 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c7:	55                   	push   %rbp
  8019c8:	48 89 e5             	mov    %rsp,%rbp
  8019cb:	48 83 ec 20          	sub    $0x20,%rsp
  8019cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019df:	89 c2                	mov    %eax,%edx
  8019e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e5:	8b 40 0c             	mov    0xc(%rax),%eax
  8019e8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8019ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f1:	89 c7                	mov    %eax,%edi
  8019f3:	48 b8 c1 1d 80 00 00 	movabs $0x801dc1,%rax
  8019fa:	00 00 00 
  8019fd:	ff d0                	callq  *%rax
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 10          	sub    $0x10,%rsp
  801a09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a15:	48 be f0 40 80 00 00 	movabs $0x8040f0,%rsi
  801a1c:	00 00 00 
  801a1f:	48 89 c7             	mov    %rax,%rdi
  801a22:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  801a29:	00 00 00 
  801a2c:	ff d0                	callq  *%rax
	return 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a33:	c9                   	leaveq 
  801a34:	c3                   	retq   

0000000000801a35 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	48 83 ec 20          	sub    $0x20,%rsp
  801a3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a40:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801a43:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a46:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801a49:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801a4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a4f:	89 ce                	mov    %ecx,%esi
  801a51:	89 c7                	mov    %eax,%edi
  801a53:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a66:	79 05                	jns    801a6d <socket+0x38>
		return r;
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	eb 11                	jmp    801a7e <socket+0x49>
	return alloc_sockfd(r);
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	89 c7                	mov    %eax,%edi
  801a72:	48 b8 17 17 80 00 00 	movabs $0x801717,%rax
  801a79:	00 00 00 
  801a7c:	ff d0                	callq  *%rax
}
  801a7e:	c9                   	leaveq 
  801a7f:	c3                   	retq   

0000000000801a80 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a80:	55                   	push   %rbp
  801a81:	48 89 e5             	mov    %rsp,%rbp
  801a84:	48 83 ec 10          	sub    $0x10,%rsp
  801a88:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a8b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a92:	00 00 00 
  801a95:	8b 00                	mov    (%rax),%eax
  801a97:	85 c0                	test   %eax,%eax
  801a99:	75 1d                	jne    801ab8 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a9b:	bf 02 00 00 00       	mov    $0x2,%edi
  801aa0:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  801aa7:	00 00 00 
  801aaa:	ff d0                	callq  *%rax
  801aac:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801ab3:	00 00 00 
  801ab6:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ab8:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801abf:	00 00 00 
  801ac2:	8b 00                	mov    (%rax),%eax
  801ac4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ac7:	b9 07 00 00 00       	mov    $0x7,%ecx
  801acc:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801ad3:	00 00 00 
  801ad6:	89 c7                	mov    %eax,%edi
  801ad8:	48 b8 4e 3e 80 00 00 	movabs $0x803e4e,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae9:	be 00 00 00 00       	mov    $0x0,%esi
  801aee:	bf 00 00 00 00       	mov    $0x0,%edi
  801af3:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 30          	sub    $0x30,%rsp
  801b09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801b14:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b1b:	00 00 00 
  801b1e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801b21:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b23:	bf 01 00 00 00       	mov    $0x1,%edi
  801b28:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801b2f:	00 00 00 
  801b32:	ff d0                	callq  *%rax
  801b34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b3b:	78 3e                	js     801b7b <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801b3d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b44:	00 00 00 
  801b47:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4f:	8b 40 10             	mov    0x10(%rax),%eax
  801b52:	89 c2                	mov    %eax,%edx
  801b54:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b5c:	48 89 ce             	mov    %rcx,%rsi
  801b5f:	48 89 c7             	mov    %rax,%rdi
  801b62:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801b69:	00 00 00 
  801b6c:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801b6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b72:	8b 50 10             	mov    0x10(%rax),%edx
  801b75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b79:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 10          	sub    $0x10,%rsp
  801b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b8f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b99:	00 00 00 
  801b9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b9f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ba1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba8:	48 89 c6             	mov    %rax,%rsi
  801bab:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801bb2:	00 00 00 
  801bb5:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801bbc:	00 00 00 
  801bbf:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801bc1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bc8:	00 00 00 
  801bcb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801bce:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801bd1:	bf 02 00 00 00       	mov    $0x2,%edi
  801bd6:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
}
  801be2:	c9                   	leaveq 
  801be3:	c3                   	retq   

0000000000801be4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	48 83 ec 10          	sub    $0x10,%rsp
  801bec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bef:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801bf2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bf9:	00 00 00 
  801bfc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801c01:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c08:	00 00 00 
  801c0b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c0e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801c11:	bf 03 00 00 00       	mov    $0x3,%edi
  801c16:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	callq  *%rax
}
  801c22:	c9                   	leaveq 
  801c23:	c3                   	retq   

0000000000801c24 <nsipc_close>:

int
nsipc_close(int s)
{
  801c24:	55                   	push   %rbp
  801c25:	48 89 e5             	mov    %rsp,%rbp
  801c28:	48 83 ec 10          	sub    $0x10,%rsp
  801c2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801c2f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c36:	00 00 00 
  801c39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c3c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801c3e:	bf 04 00 00 00       	mov    $0x4,%edi
  801c43:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801c4a:	00 00 00 
  801c4d:	ff d0                	callq  *%rax
}
  801c4f:	c9                   	leaveq 
  801c50:	c3                   	retq   

0000000000801c51 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c51:	55                   	push   %rbp
  801c52:	48 89 e5             	mov    %rsp,%rbp
  801c55:	48 83 ec 10          	sub    $0x10,%rsp
  801c59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c60:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801c63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c6a:	00 00 00 
  801c6d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c70:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c72:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c79:	48 89 c6             	mov    %rax,%rsi
  801c7c:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801c83:	00 00 00 
  801c86:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801c8d:	00 00 00 
  801c90:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c92:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c99:	00 00 00 
  801c9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c9f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801ca2:	bf 05 00 00 00       	mov    $0x5,%edi
  801ca7:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
}
  801cb3:	c9                   	leaveq 
  801cb4:	c3                   	retq   

0000000000801cb5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb5:	55                   	push   %rbp
  801cb6:	48 89 e5             	mov    %rsp,%rbp
  801cb9:	48 83 ec 10          	sub    $0x10,%rsp
  801cbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801cc3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cca:	00 00 00 
  801ccd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cd0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801cd2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cd9:	00 00 00 
  801cdc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801cdf:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801ce2:	bf 06 00 00 00       	mov    $0x6,%edi
  801ce7:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801cee:	00 00 00 
  801cf1:	ff d0                	callq  *%rax
}
  801cf3:	c9                   	leaveq 
  801cf4:	c3                   	retq   

0000000000801cf5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cf5:	55                   	push   %rbp
  801cf6:	48 89 e5             	mov    %rsp,%rbp
  801cf9:	48 83 ec 30          	sub    $0x30,%rsp
  801cfd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d04:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801d07:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801d0a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d11:	00 00 00 
  801d14:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d17:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801d19:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d20:	00 00 00 
  801d23:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d26:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801d29:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d30:	00 00 00 
  801d33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d36:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d39:	bf 07 00 00 00       	mov    $0x7,%edi
  801d3e:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
  801d4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d51:	78 69                	js     801dbc <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801d53:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801d5a:	7f 08                	jg     801d64 <nsipc_recv+0x6f>
  801d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5f:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801d62:	7e 35                	jle    801d99 <nsipc_recv+0xa4>
  801d64:	48 b9 f7 40 80 00 00 	movabs $0x8040f7,%rcx
  801d6b:	00 00 00 
  801d6e:	48 ba 0c 41 80 00 00 	movabs $0x80410c,%rdx
  801d75:	00 00 00 
  801d78:	be 61 00 00 00       	mov    $0x61,%esi
  801d7d:	48 bf 21 41 80 00 00 	movabs $0x804121,%rdi
  801d84:	00 00 00 
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8c:	49 b8 48 27 80 00 00 	movabs $0x802748,%r8
  801d93:	00 00 00 
  801d96:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9c:	48 63 d0             	movslq %eax,%rdx
  801d9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801da3:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801daa:	00 00 00 
  801dad:	48 89 c7             	mov    %rax,%rdi
  801db0:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
	}

	return r;
  801dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801dbf:	c9                   	leaveq 
  801dc0:	c3                   	retq   

0000000000801dc1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dc1:	55                   	push   %rbp
  801dc2:	48 89 e5             	mov    %rsp,%rbp
  801dc5:	48 83 ec 20          	sub    $0x20,%rsp
  801dc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dd3:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801dd6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ddd:	00 00 00 
  801de0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801de3:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801de5:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801dec:	7e 35                	jle    801e23 <nsipc_send+0x62>
  801dee:	48 b9 2d 41 80 00 00 	movabs $0x80412d,%rcx
  801df5:	00 00 00 
  801df8:	48 ba 0c 41 80 00 00 	movabs $0x80410c,%rdx
  801dff:	00 00 00 
  801e02:	be 6c 00 00 00       	mov    $0x6c,%esi
  801e07:	48 bf 21 41 80 00 00 	movabs $0x804121,%rdi
  801e0e:	00 00 00 
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
  801e16:	49 b8 48 27 80 00 00 	movabs $0x802748,%r8
  801e1d:	00 00 00 
  801e20:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e26:	48 63 d0             	movslq %eax,%rdx
  801e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e2d:	48 89 c6             	mov    %rax,%rsi
  801e30:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801e37:	00 00 00 
  801e3a:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  801e41:	00 00 00 
  801e44:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801e46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e4d:	00 00 00 
  801e50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e53:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801e56:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e5d:	00 00 00 
  801e60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e63:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801e66:	bf 08 00 00 00       	mov    $0x8,%edi
  801e6b:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
}
  801e77:	c9                   	leaveq 
  801e78:	c3                   	retq   

0000000000801e79 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e79:	55                   	push   %rbp
  801e7a:	48 89 e5             	mov    %rsp,%rbp
  801e7d:	48 83 ec 10          	sub    $0x10,%rsp
  801e81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e84:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801e87:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e8a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e91:	00 00 00 
  801e94:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e97:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e99:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ea0:	00 00 00 
  801ea3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801ea6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801ea9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801eb0:	00 00 00 
  801eb3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801eb6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801eb9:	bf 09 00 00 00       	mov    $0x9,%edi
  801ebe:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
}
  801eca:	c9                   	leaveq 
  801ecb:	c3                   	retq   

0000000000801ecc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ecc:	55                   	push   %rbp
  801ecd:	48 89 e5             	mov    %rsp,%rbp
  801ed0:	53                   	push   %rbx
  801ed1:	48 83 ec 38          	sub    $0x38,%rsp
  801ed5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ed9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801edd:	48 89 c7             	mov    %rax,%rdi
  801ee0:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	callq  *%rax
  801eec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef3:	0f 88 bf 01 00 00    	js     8020b8 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efd:	ba 07 04 00 00       	mov    $0x407,%edx
  801f02:	48 89 c6             	mov    %rax,%rsi
  801f05:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0a:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
  801f16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f1d:	0f 88 95 01 00 00    	js     8020b8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f23:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f27:	48 89 c7             	mov    %rax,%rdi
  801f2a:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  801f31:	00 00 00 
  801f34:	ff d0                	callq  *%rax
  801f36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f3d:	0f 88 5d 01 00 00    	js     8020a0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f47:	ba 07 04 00 00       	mov    $0x407,%edx
  801f4c:	48 89 c6             	mov    %rax,%rsi
  801f4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f54:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax
  801f60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f67:	0f 88 33 01 00 00    	js     8020a0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f71:	48 89 c7             	mov    %rax,%rdi
  801f74:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  801f7b:	00 00 00 
  801f7e:	ff d0                	callq  *%rax
  801f80:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f88:	ba 07 04 00 00       	mov    $0x407,%edx
  801f8d:	48 89 c6             	mov    %rax,%rsi
  801f90:	bf 00 00 00 00       	mov    $0x0,%edi
  801f95:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	callq  *%rax
  801fa1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fa8:	79 05                	jns    801faf <pipe+0xe3>
		goto err2;
  801faa:	e9 d9 00 00 00       	jmpq   802088 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801faf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb3:	48 89 c7             	mov    %rax,%rdi
  801fb6:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
  801fc2:	48 89 c2             	mov    %rax,%rdx
  801fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801fcf:	48 89 d1             	mov    %rdx,%rcx
  801fd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd7:	48 89 c6             	mov    %rax,%rsi
  801fda:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdf:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	callq  *%rax
  801feb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ff2:	79 1b                	jns    80200f <pipe+0x143>
		goto err3;
  801ff4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff9:	48 89 c6             	mov    %rax,%rsi
  801ffc:	bf 00 00 00 00       	mov    $0x0,%edi
  802001:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
  80200d:	eb 79                	jmp    802088 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80200f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802013:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80201a:	00 00 00 
  80201d:	8b 12                	mov    (%rdx),%edx
  80201f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802021:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80202c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802030:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802037:	00 00 00 
  80203a:	8b 12                	mov    (%rdx),%edx
  80203c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80203e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802042:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204d:	48 89 c7             	mov    %rax,%rdi
  802050:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  802057:	00 00 00 
  80205a:	ff d0                	callq  *%rax
  80205c:	89 c2                	mov    %eax,%edx
  80205e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802062:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802064:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802068:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80206c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802070:	48 89 c7             	mov    %rax,%rdi
  802073:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax
  80207f:	89 03                	mov    %eax,(%rbx)
	return 0;
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	eb 33                	jmp    8020bb <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802088:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80208c:	48 89 c6             	mov    %rax,%rsi
  80208f:	bf 00 00 00 00       	mov    $0x0,%edi
  802094:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8020a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a4:	48 89 c6             	mov    %rax,%rsi
  8020a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ac:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	callq  *%rax
err:
	return r;
  8020b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8020bb:	48 83 c4 38          	add    $0x38,%rsp
  8020bf:	5b                   	pop    %rbx
  8020c0:	5d                   	pop    %rbp
  8020c1:	c3                   	retq   

00000000008020c2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020c2:	55                   	push   %rbp
  8020c3:	48 89 e5             	mov    %rsp,%rbp
  8020c6:	53                   	push   %rbx
  8020c7:	48 83 ec 28          	sub    $0x28,%rsp
  8020cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8020cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020d3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020da:	00 00 00 
  8020dd:	48 8b 00             	mov    (%rax),%rax
  8020e0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8020e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ed:	48 89 c7             	mov    %rax,%rdi
  8020f0:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  8020f7:	00 00 00 
  8020fa:	ff d0                	callq  *%rax
  8020fc:	89 c3                	mov    %eax,%ebx
  8020fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802102:	48 89 c7             	mov    %rax,%rdi
  802105:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax
  802111:	39 c3                	cmp    %eax,%ebx
  802113:	0f 94 c0             	sete   %al
  802116:	0f b6 c0             	movzbl %al,%eax
  802119:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80211c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802123:	00 00 00 
  802126:	48 8b 00             	mov    (%rax),%rax
  802129:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80212f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802132:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802135:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802138:	75 05                	jne    80213f <_pipeisclosed+0x7d>
			return ret;
  80213a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80213d:	eb 4f                	jmp    80218e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80213f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802142:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802145:	74 42                	je     802189 <_pipeisclosed+0xc7>
  802147:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80214b:	75 3c                	jne    802189 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80214d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802154:	00 00 00 
  802157:	48 8b 00             	mov    (%rax),%rax
  80215a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802160:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802166:	89 c6                	mov    %eax,%esi
  802168:	48 bf 3e 41 80 00 00 	movabs $0x80413e,%rdi
  80216f:	00 00 00 
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
  802177:	49 b8 81 29 80 00 00 	movabs $0x802981,%r8
  80217e:	00 00 00 
  802181:	41 ff d0             	callq  *%r8
	}
  802184:	e9 4a ff ff ff       	jmpq   8020d3 <_pipeisclosed+0x11>
  802189:	e9 45 ff ff ff       	jmpq   8020d3 <_pipeisclosed+0x11>
}
  80218e:	48 83 c4 28          	add    $0x28,%rsp
  802192:	5b                   	pop    %rbx
  802193:	5d                   	pop    %rbp
  802194:	c3                   	retq   

0000000000802195 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802195:	55                   	push   %rbp
  802196:	48 89 e5             	mov    %rsp,%rbp
  802199:	48 83 ec 30          	sub    $0x30,%rsp
  80219d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a7:	48 89 d6             	mov    %rdx,%rsi
  8021aa:	89 c7                	mov    %eax,%edi
  8021ac:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
  8021b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bf:	79 05                	jns    8021c6 <pipeisclosed+0x31>
		return r;
  8021c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c4:	eb 31                	jmp    8021f7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	48 89 c7             	mov    %rax,%rdi
  8021cd:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	callq  *%rax
  8021d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8021dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e5:	48 89 d6             	mov    %rdx,%rsi
  8021e8:	48 89 c7             	mov    %rax,%rdi
  8021eb:	48 b8 c2 20 80 00 00 	movabs $0x8020c2,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
}
  8021f7:	c9                   	leaveq 
  8021f8:	c3                   	retq   

00000000008021f9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021f9:	55                   	push   %rbp
  8021fa:	48 89 e5             	mov    %rsp,%rbp
  8021fd:	48 83 ec 40          	sub    $0x40,%rsp
  802201:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802205:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802209:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80220d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802211:	48 89 c7             	mov    %rax,%rdi
  802214:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
  802220:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802228:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80222c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802233:	00 
  802234:	e9 92 00 00 00       	jmpq   8022cb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802239:	eb 41                	jmp    80227c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80223b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802240:	74 09                	je     80224b <devpipe_read+0x52>
				return i;
  802242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802246:	e9 92 00 00 00       	jmpq   8022dd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80224b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802253:	48 89 d6             	mov    %rdx,%rsi
  802256:	48 89 c7             	mov    %rax,%rdi
  802259:	48 b8 c2 20 80 00 00 	movabs $0x8020c2,%rax
  802260:	00 00 00 
  802263:	ff d0                	callq  *%rax
  802265:	85 c0                	test   %eax,%eax
  802267:	74 07                	je     802270 <devpipe_read+0x77>
				return 0;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	eb 6d                	jmp    8022dd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802270:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80227c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802280:	8b 10                	mov    (%rax),%edx
  802282:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802286:	8b 40 04             	mov    0x4(%rax),%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	74 ae                	je     80223b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80228d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802291:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802295:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229d:	8b 00                	mov    (%rax),%eax
  80229f:	99                   	cltd   
  8022a0:	c1 ea 1b             	shr    $0x1b,%edx
  8022a3:	01 d0                	add    %edx,%eax
  8022a5:	83 e0 1f             	and    $0x1f,%eax
  8022a8:	29 d0                	sub    %edx,%eax
  8022aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ae:	48 98                	cltq   
  8022b0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8022b5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8022b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022bb:	8b 00                	mov    (%rax),%eax
  8022bd:	8d 50 01             	lea    0x1(%rax),%edx
  8022c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022cf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8022d3:	0f 82 60 ff ff ff    	jb     802239 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 40          	sub    $0x40,%rsp
  8022e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f7:	48 89 c7             	mov    %rax,%rdi
  8022fa:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80230a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80230e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802312:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802319:	00 
  80231a:	e9 8e 00 00 00       	jmpq   8023ad <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80231f:	eb 31                	jmp    802352 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802321:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802329:	48 89 d6             	mov    %rdx,%rsi
  80232c:	48 89 c7             	mov    %rax,%rdi
  80232f:	48 b8 c2 20 80 00 00 	movabs $0x8020c2,%rax
  802336:	00 00 00 
  802339:	ff d0                	callq  *%rax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	74 07                	je     802346 <devpipe_write+0x67>
				return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	eb 79                	jmp    8023bf <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802346:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  80234d:	00 00 00 
  802350:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802356:	8b 40 04             	mov    0x4(%rax),%eax
  802359:	48 63 d0             	movslq %eax,%rdx
  80235c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802360:	8b 00                	mov    (%rax),%eax
  802362:	48 98                	cltq   
  802364:	48 83 c0 20          	add    $0x20,%rax
  802368:	48 39 c2             	cmp    %rax,%rdx
  80236b:	73 b4                	jae    802321 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80236d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802371:	8b 40 04             	mov    0x4(%rax),%eax
  802374:	99                   	cltd   
  802375:	c1 ea 1b             	shr    $0x1b,%edx
  802378:	01 d0                	add    %edx,%eax
  80237a:	83 e0 1f             	and    $0x1f,%eax
  80237d:	29 d0                	sub    %edx,%eax
  80237f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802383:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802387:	48 01 ca             	add    %rcx,%rdx
  80238a:	0f b6 0a             	movzbl (%rdx),%ecx
  80238d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802391:	48 98                	cltq   
  802393:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239b:	8b 40 04             	mov    0x4(%rax),%eax
  80239e:	8d 50 01             	lea    0x1(%rax),%edx
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8023b5:	0f 82 64 ff ff ff    	jb     80231f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023bf:	c9                   	leaveq 
  8023c0:	c3                   	retq   

00000000008023c1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023c1:	55                   	push   %rbp
  8023c2:	48 89 e5             	mov    %rsp,%rbp
  8023c5:	48 83 ec 20          	sub    $0x20,%rsp
  8023c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d5:	48 89 c7             	mov    %rax,%rdi
  8023d8:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  8023df:	00 00 00 
  8023e2:	ff d0                	callq  *%rax
  8023e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8023e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ec:	48 be 51 41 80 00 00 	movabs $0x804151,%rsi
  8023f3:	00 00 00 
  8023f6:	48 89 c7             	mov    %rax,%rdi
  8023f9:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  802400:	00 00 00 
  802403:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802409:	8b 50 04             	mov    0x4(%rax),%edx
  80240c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802410:	8b 00                	mov    (%rax),%eax
  802412:	29 c2                	sub    %eax,%edx
  802414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802418:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80241e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802422:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802429:	00 00 00 
	stat->st_dev = &devpipe;
  80242c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802430:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802437:	00 00 00 
  80243a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802446:	c9                   	leaveq 
  802447:	c3                   	retq   

0000000000802448 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802448:	55                   	push   %rbp
  802449:	48 89 e5             	mov    %rsp,%rbp
  80244c:	48 83 ec 10          	sub    $0x10,%rsp
  802450:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802458:	48 89 c6             	mov    %rax,%rsi
  80245b:	bf 00 00 00 00       	mov    $0x0,%edi
  802460:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80246c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802470:	48 89 c7             	mov    %rax,%rdi
  802473:	48 b8 df 06 80 00 00 	movabs $0x8006df,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
  80247f:	48 89 c6             	mov    %rax,%rsi
  802482:	bf 00 00 00 00       	mov    $0x0,%edi
  802487:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  80248e:	00 00 00 
  802491:	ff d0                	callq  *%rax
}
  802493:	c9                   	leaveq 
  802494:	c3                   	retq   

0000000000802495 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
  802499:	48 83 ec 20          	sub    $0x20,%rsp
  80249d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8024a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024a6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8024aa:	be 01 00 00 00       	mov    $0x1,%esi
  8024af:	48 89 c7             	mov    %rax,%rdi
  8024b2:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	callq  *%rax
}
  8024be:	c9                   	leaveq 
  8024bf:	c3                   	retq   

00000000008024c0 <getchar>:

int
getchar(void)
{
  8024c0:	55                   	push   %rbp
  8024c1:	48 89 e5             	mov    %rsp,%rbp
  8024c4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024c8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8024cc:	ba 01 00 00 00       	mov    $0x1,%edx
  8024d1:	48 89 c6             	mov    %rax,%rsi
  8024d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d9:	48 b8 d4 0b 80 00 00 	movabs $0x800bd4,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	callq  *%rax
  8024e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8024e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ec:	79 05                	jns    8024f3 <getchar+0x33>
		return r;
  8024ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f1:	eb 14                	jmp    802507 <getchar+0x47>
	if (r < 1)
  8024f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f7:	7f 07                	jg     802500 <getchar+0x40>
		return -E_EOF;
  8024f9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8024fe:	eb 07                	jmp    802507 <getchar+0x47>
	return c;
  802500:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802504:	0f b6 c0             	movzbl %al,%eax
}
  802507:	c9                   	leaveq 
  802508:	c3                   	retq   

0000000000802509 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802509:	55                   	push   %rbp
  80250a:	48 89 e5             	mov    %rsp,%rbp
  80250d:	48 83 ec 20          	sub    $0x20,%rsp
  802511:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802514:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802518:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 a2 07 80 00 00 	movabs $0x8007a2,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <iscons+0x31>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 1a                	jmp    802554 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80253a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253e:	8b 10                	mov    (%rax),%edx
  802540:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802547:	00 00 00 
  80254a:	8b 00                	mov    (%rax),%eax
  80254c:	39 c2                	cmp    %eax,%edx
  80254e:	0f 94 c0             	sete   %al
  802551:	0f b6 c0             	movzbl %al,%eax
}
  802554:	c9                   	leaveq 
  802555:	c3                   	retq   

0000000000802556 <opencons>:

int
opencons(void)
{
  802556:	55                   	push   %rbp
  802557:	48 89 e5             	mov    %rsp,%rbp
  80255a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80255e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802562:	48 89 c7             	mov    %rax,%rdi
  802565:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
  802571:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802578:	79 05                	jns    80257f <opencons+0x29>
		return r;
  80257a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257d:	eb 5b                	jmp    8025da <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80257f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802583:	ba 07 04 00 00       	mov    $0x407,%edx
  802588:	48 89 c6             	mov    %rax,%rsi
  80258b:	bf 00 00 00 00       	mov    $0x0,%edi
  802590:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a3:	79 05                	jns    8025aa <opencons+0x54>
		return r;
  8025a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a8:	eb 30                	jmp    8025da <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8025aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ae:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8025b5:	00 00 00 
  8025b8:	8b 12                	mov    (%rdx),%edx
  8025ba:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8025bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	48 89 c7             	mov    %rax,%rdi
  8025ce:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	callq  *%rax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 30          	sub    $0x30,%rsp
  8025e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8025f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8025f5:	75 07                	jne    8025fe <devcons_read+0x22>
		return 0;
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	eb 4b                	jmp    802649 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8025fe:	eb 0c                	jmp    80260c <devcons_read+0x30>
		sys_yield();
  802600:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  802607:	00 00 00 
  80260a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80260c:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261f:	74 df                	je     802600 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802625:	79 05                	jns    80262c <devcons_read+0x50>
		return c;
  802627:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262a:	eb 1d                	jmp    802649 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80262c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802630:	75 07                	jne    802639 <devcons_read+0x5d>
		return 0;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
  802637:	eb 10                	jmp    802649 <devcons_read+0x6d>
	*(char*)vbuf = c;
  802639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263c:	89 c2                	mov    %eax,%edx
  80263e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802642:	88 10                	mov    %dl,(%rax)
	return 1;
  802644:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802649:	c9                   	leaveq 
  80264a:	c3                   	retq   

000000000080264b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264b:	55                   	push   %rbp
  80264c:	48 89 e5             	mov    %rsp,%rbp
  80264f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802656:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80265d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802664:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80266b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802672:	eb 76                	jmp    8026ea <devcons_write+0x9f>
		m = n - tot;
  802674:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80267b:	89 c2                	mov    %eax,%edx
  80267d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802680:	29 c2                	sub    %eax,%edx
  802682:	89 d0                	mov    %edx,%eax
  802684:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802687:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80268a:	83 f8 7f             	cmp    $0x7f,%eax
  80268d:	76 07                	jbe    802696 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80268f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802696:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802699:	48 63 d0             	movslq %eax,%rdx
  80269c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269f:	48 63 c8             	movslq %eax,%rcx
  8026a2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8026a9:	48 01 c1             	add    %rax,%rcx
  8026ac:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8026b3:	48 89 ce             	mov    %rcx,%rsi
  8026b6:	48 89 c7             	mov    %rax,%rdi
  8026b9:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8026c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026c8:	48 63 d0             	movslq %eax,%rdx
  8026cb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	48 89 c7             	mov    %rax,%rdi
  8026d8:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026e7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8026ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ed:	48 98                	cltq   
  8026ef:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8026f6:	0f 82 78 ff ff ff    	jb     802674 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8026fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ff:	c9                   	leaveq 
  802700:	c3                   	retq   

0000000000802701 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802701:	55                   	push   %rbp
  802702:	48 89 e5             	mov    %rsp,%rbp
  802705:	48 83 ec 08          	sub    $0x8,%rsp
  802709:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802712:	c9                   	leaveq 
  802713:	c3                   	retq   

0000000000802714 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 10          	sub    $0x10,%rsp
  80271c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802720:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802728:	48 be 5d 41 80 00 00 	movabs $0x80415d,%rsi
  80272f:	00 00 00 
  802732:	48 89 c7             	mov    %rax,%rdi
  802735:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
	return 0;
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802746:	c9                   	leaveq 
  802747:	c3                   	retq   

0000000000802748 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802748:	55                   	push   %rbp
  802749:	48 89 e5             	mov    %rsp,%rbp
  80274c:	53                   	push   %rbx
  80274d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802754:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80275b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802761:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802768:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80276f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802776:	84 c0                	test   %al,%al
  802778:	74 23                	je     80279d <_panic+0x55>
  80277a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802781:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802785:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802789:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80278d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802791:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802795:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802799:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80279d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8027a4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8027ab:	00 00 00 
  8027ae:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8027b5:	00 00 00 
  8027b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8027bc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8027c3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8027ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027d1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8027d8:	00 00 00 
  8027db:	48 8b 18             	mov    (%rax),%rbx
  8027de:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
  8027ea:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8027f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027f7:	41 89 c8             	mov    %ecx,%r8d
  8027fa:	48 89 d1             	mov    %rdx,%rcx
  8027fd:	48 89 da             	mov    %rbx,%rdx
  802800:	89 c6                	mov    %eax,%esi
  802802:	48 bf 68 41 80 00 00 	movabs $0x804168,%rdi
  802809:	00 00 00 
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	49 b9 81 29 80 00 00 	movabs $0x802981,%r9
  802818:	00 00 00 
  80281b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80281e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802825:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80282c:	48 89 d6             	mov    %rdx,%rsi
  80282f:	48 89 c7             	mov    %rax,%rdi
  802832:	48 b8 d5 28 80 00 00 	movabs $0x8028d5,%rax
  802839:	00 00 00 
  80283c:	ff d0                	callq  *%rax
	cprintf("\n");
  80283e:	48 bf 8b 41 80 00 00 	movabs $0x80418b,%rdi
  802845:	00 00 00 
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
  80284d:	48 ba 81 29 80 00 00 	movabs $0x802981,%rdx
  802854:	00 00 00 
  802857:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802859:	cc                   	int3   
  80285a:	eb fd                	jmp    802859 <_panic+0x111>

000000000080285c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80285c:	55                   	push   %rbp
  80285d:	48 89 e5             	mov    %rsp,%rbp
  802860:	48 83 ec 10          	sub    $0x10,%rsp
  802864:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802867:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80286b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286f:	8b 00                	mov    (%rax),%eax
  802871:	8d 48 01             	lea    0x1(%rax),%ecx
  802874:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802878:	89 0a                	mov    %ecx,(%rdx)
  80287a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287d:	89 d1                	mov    %edx,%ecx
  80287f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802883:	48 98                	cltq   
  802885:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802889:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288d:	8b 00                	mov    (%rax),%eax
  80288f:	3d ff 00 00 00       	cmp    $0xff,%eax
  802894:	75 2c                	jne    8028c2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289a:	8b 00                	mov    (%rax),%eax
  80289c:	48 98                	cltq   
  80289e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028a2:	48 83 c2 08          	add    $0x8,%rdx
  8028a6:	48 89 c6             	mov    %rax,%rsi
  8028a9:	48 89 d7             	mov    %rdx,%rdi
  8028ac:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  8028b3:	00 00 00 
  8028b6:	ff d0                	callq  *%rax
        b->idx = 0;
  8028b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8028c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c6:	8b 40 04             	mov    0x4(%rax),%eax
  8028c9:	8d 50 01             	lea    0x1(%rax),%edx
  8028cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8028d3:	c9                   	leaveq 
  8028d4:	c3                   	retq   

00000000008028d5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8028d5:	55                   	push   %rbp
  8028d6:	48 89 e5             	mov    %rsp,%rbp
  8028d9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8028e0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8028e7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8028ee:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8028f5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8028fc:	48 8b 0a             	mov    (%rdx),%rcx
  8028ff:	48 89 08             	mov    %rcx,(%rax)
  802902:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802906:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80290a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80290e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802912:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802919:	00 00 00 
    b.cnt = 0;
  80291c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802923:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802926:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80292d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802934:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80293b:	48 89 c6             	mov    %rax,%rsi
  80293e:	48 bf 5c 28 80 00 00 	movabs $0x80285c,%rdi
  802945:	00 00 00 
  802948:	48 b8 34 2d 80 00 00 	movabs $0x802d34,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802954:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80295a:	48 98                	cltq   
  80295c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802963:	48 83 c2 08          	add    $0x8,%rdx
  802967:	48 89 c6             	mov    %rax,%rsi
  80296a:	48 89 d7             	mov    %rdx,%rdi
  80296d:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802979:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80297f:	c9                   	leaveq 
  802980:	c3                   	retq   

0000000000802981 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802981:	55                   	push   %rbp
  802982:	48 89 e5             	mov    %rsp,%rbp
  802985:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80298c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802993:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80299a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029a1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8029a8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8029af:	84 c0                	test   %al,%al
  8029b1:	74 20                	je     8029d3 <cprintf+0x52>
  8029b3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8029b7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8029bb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8029bf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8029c3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8029c7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8029cb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8029cf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8029d3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8029da:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8029e1:	00 00 00 
  8029e4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8029eb:	00 00 00 
  8029ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8029f9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802a07:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802a0e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802a15:	48 8b 0a             	mov    (%rdx),%rcx
  802a18:	48 89 08             	mov    %rcx,(%rax)
  802a1b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a1f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a23:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a27:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802a2b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802a32:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802a39:	48 89 d6             	mov    %rdx,%rsi
  802a3c:	48 89 c7             	mov    %rax,%rdi
  802a3f:	48 b8 d5 28 80 00 00 	movabs $0x8028d5,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802a51:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802a57:	c9                   	leaveq 
  802a58:	c3                   	retq   

0000000000802a59 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802a59:	55                   	push   %rbp
  802a5a:	48 89 e5             	mov    %rsp,%rbp
  802a5d:	53                   	push   %rbx
  802a5e:	48 83 ec 38          	sub    $0x38,%rsp
  802a62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802a6e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a71:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a75:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a79:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a7c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a80:	77 3b                	ja     802abd <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a82:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a85:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a89:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a90:	ba 00 00 00 00       	mov    $0x0,%edx
  802a95:	48 f7 f3             	div    %rbx
  802a98:	48 89 c2             	mov    %rax,%rdx
  802a9b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a9e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802aa1:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa9:	41 89 f9             	mov    %edi,%r9d
  802aac:	48 89 c7             	mov    %rax,%rdi
  802aaf:	48 b8 59 2a 80 00 00 	movabs $0x802a59,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
  802abb:	eb 1e                	jmp    802adb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802abd:	eb 12                	jmp    802ad1 <printnum+0x78>
			putch(padc, putdat);
  802abf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ac3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aca:	48 89 ce             	mov    %rcx,%rsi
  802acd:	89 d7                	mov    %edx,%edi
  802acf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802ad1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802ad5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802ad9:	7f e4                	jg     802abf <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802adb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae7:	48 f7 f1             	div    %rcx
  802aea:	48 89 d0             	mov    %rdx,%rax
  802aed:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
  802af4:	00 00 00 
  802af7:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802afb:	0f be d0             	movsbl %al,%edx
  802afe:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b06:	48 89 ce             	mov    %rcx,%rsi
  802b09:	89 d7                	mov    %edx,%edi
  802b0b:	ff d0                	callq  *%rax
}
  802b0d:	48 83 c4 38          	add    $0x38,%rsp
  802b11:	5b                   	pop    %rbx
  802b12:	5d                   	pop    %rbp
  802b13:	c3                   	retq   

0000000000802b14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802b14:	55                   	push   %rbp
  802b15:	48 89 e5             	mov    %rsp,%rbp
  802b18:	48 83 ec 1c          	sub    $0x1c,%rsp
  802b1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b20:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802b23:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802b27:	7e 52                	jle    802b7b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2d:	8b 00                	mov    (%rax),%eax
  802b2f:	83 f8 30             	cmp    $0x30,%eax
  802b32:	73 24                	jae    802b58 <getuint+0x44>
  802b34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b38:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b40:	8b 00                	mov    (%rax),%eax
  802b42:	89 c0                	mov    %eax,%eax
  802b44:	48 01 d0             	add    %rdx,%rax
  802b47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b4b:	8b 12                	mov    (%rdx),%edx
  802b4d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b54:	89 0a                	mov    %ecx,(%rdx)
  802b56:	eb 17                	jmp    802b6f <getuint+0x5b>
  802b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b60:	48 89 d0             	mov    %rdx,%rax
  802b63:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b6f:	48 8b 00             	mov    (%rax),%rax
  802b72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b76:	e9 a3 00 00 00       	jmpq   802c1e <getuint+0x10a>
	else if (lflag)
  802b7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b7f:	74 4f                	je     802bd0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b85:	8b 00                	mov    (%rax),%eax
  802b87:	83 f8 30             	cmp    $0x30,%eax
  802b8a:	73 24                	jae    802bb0 <getuint+0x9c>
  802b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b98:	8b 00                	mov    (%rax),%eax
  802b9a:	89 c0                	mov    %eax,%eax
  802b9c:	48 01 d0             	add    %rdx,%rax
  802b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ba3:	8b 12                	mov    (%rdx),%edx
  802ba5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ba8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bac:	89 0a                	mov    %ecx,(%rdx)
  802bae:	eb 17                	jmp    802bc7 <getuint+0xb3>
  802bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bb8:	48 89 d0             	mov    %rdx,%rax
  802bbb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bc3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bc7:	48 8b 00             	mov    (%rax),%rax
  802bca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802bce:	eb 4e                	jmp    802c1e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	8b 00                	mov    (%rax),%eax
  802bd6:	83 f8 30             	cmp    $0x30,%eax
  802bd9:	73 24                	jae    802bff <getuint+0xeb>
  802bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be7:	8b 00                	mov    (%rax),%eax
  802be9:	89 c0                	mov    %eax,%eax
  802beb:	48 01 d0             	add    %rdx,%rax
  802bee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf2:	8b 12                	mov    (%rdx),%edx
  802bf4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bf7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bfb:	89 0a                	mov    %ecx,(%rdx)
  802bfd:	eb 17                	jmp    802c16 <getuint+0x102>
  802bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c03:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c07:	48 89 d0             	mov    %rdx,%rax
  802c0a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c12:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c16:	8b 00                	mov    (%rax),%eax
  802c18:	89 c0                	mov    %eax,%eax
  802c1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c22:	c9                   	leaveq 
  802c23:	c3                   	retq   

0000000000802c24 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802c24:	55                   	push   %rbp
  802c25:	48 89 e5             	mov    %rsp,%rbp
  802c28:	48 83 ec 1c          	sub    $0x1c,%rsp
  802c2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c30:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802c33:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802c37:	7e 52                	jle    802c8b <getint+0x67>
		x=va_arg(*ap, long long);
  802c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3d:	8b 00                	mov    (%rax),%eax
  802c3f:	83 f8 30             	cmp    $0x30,%eax
  802c42:	73 24                	jae    802c68 <getint+0x44>
  802c44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c50:	8b 00                	mov    (%rax),%eax
  802c52:	89 c0                	mov    %eax,%eax
  802c54:	48 01 d0             	add    %rdx,%rax
  802c57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c5b:	8b 12                	mov    (%rdx),%edx
  802c5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c64:	89 0a                	mov    %ecx,(%rdx)
  802c66:	eb 17                	jmp    802c7f <getint+0x5b>
  802c68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c70:	48 89 d0             	mov    %rdx,%rax
  802c73:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c7b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c7f:	48 8b 00             	mov    (%rax),%rax
  802c82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c86:	e9 a3 00 00 00       	jmpq   802d2e <getint+0x10a>
	else if (lflag)
  802c8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c8f:	74 4f                	je     802ce0 <getint+0xbc>
		x=va_arg(*ap, long);
  802c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c95:	8b 00                	mov    (%rax),%eax
  802c97:	83 f8 30             	cmp    $0x30,%eax
  802c9a:	73 24                	jae    802cc0 <getint+0x9c>
  802c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca8:	8b 00                	mov    (%rax),%eax
  802caa:	89 c0                	mov    %eax,%eax
  802cac:	48 01 d0             	add    %rdx,%rax
  802caf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb3:	8b 12                	mov    (%rdx),%edx
  802cb5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802cb8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cbc:	89 0a                	mov    %ecx,(%rdx)
  802cbe:	eb 17                	jmp    802cd7 <getint+0xb3>
  802cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802cc8:	48 89 d0             	mov    %rdx,%rax
  802ccb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802ccf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cd3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cd7:	48 8b 00             	mov    (%rax),%rax
  802cda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802cde:	eb 4e                	jmp    802d2e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce4:	8b 00                	mov    (%rax),%eax
  802ce6:	83 f8 30             	cmp    $0x30,%eax
  802ce9:	73 24                	jae    802d0f <getint+0xeb>
  802ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802cf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf7:	8b 00                	mov    (%rax),%eax
  802cf9:	89 c0                	mov    %eax,%eax
  802cfb:	48 01 d0             	add    %rdx,%rax
  802cfe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d02:	8b 12                	mov    (%rdx),%edx
  802d04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0b:	89 0a                	mov    %ecx,(%rdx)
  802d0d:	eb 17                	jmp    802d26 <getint+0x102>
  802d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d13:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802d17:	48 89 d0             	mov    %rdx,%rax
  802d1a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802d1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d22:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d26:	8b 00                	mov    (%rax),%eax
  802d28:	48 98                	cltq   
  802d2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802d2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d32:	c9                   	leaveq 
  802d33:	c3                   	retq   

0000000000802d34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802d34:	55                   	push   %rbp
  802d35:	48 89 e5             	mov    %rsp,%rbp
  802d38:	41 54                	push   %r12
  802d3a:	53                   	push   %rbx
  802d3b:	48 83 ec 60          	sub    $0x60,%rsp
  802d3f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802d43:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802d47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d4b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802d4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802d53:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802d57:	48 8b 0a             	mov    (%rdx),%rcx
  802d5a:	48 89 08             	mov    %rcx,(%rax)
  802d5d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802d61:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802d65:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802d69:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d6d:	eb 17                	jmp    802d86 <vprintfmt+0x52>
			if (ch == '\0')
  802d6f:	85 db                	test   %ebx,%ebx
  802d71:	0f 84 cc 04 00 00    	je     803243 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802d77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d7f:	48 89 d6             	mov    %rdx,%rsi
  802d82:	89 df                	mov    %ebx,%edi
  802d84:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d8e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d92:	0f b6 00             	movzbl (%rax),%eax
  802d95:	0f b6 d8             	movzbl %al,%ebx
  802d98:	83 fb 25             	cmp    $0x25,%ebx
  802d9b:	75 d2                	jne    802d6f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d9d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802da1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802da8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802daf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802db6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802dbd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802dc1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802dc5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802dc9:	0f b6 00             	movzbl (%rax),%eax
  802dcc:	0f b6 d8             	movzbl %al,%ebx
  802dcf:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802dd2:	83 f8 55             	cmp    $0x55,%eax
  802dd5:	0f 87 34 04 00 00    	ja     80320f <vprintfmt+0x4db>
  802ddb:	89 c0                	mov    %eax,%eax
  802ddd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802de4:	00 
  802de5:	48 b8 b8 43 80 00 00 	movabs $0x8043b8,%rax
  802dec:	00 00 00 
  802def:	48 01 d0             	add    %rdx,%rax
  802df2:	48 8b 00             	mov    (%rax),%rax
  802df5:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802df7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802dfb:	eb c0                	jmp    802dbd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802dfd:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802e01:	eb ba                	jmp    802dbd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e03:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802e0a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e0d:	89 d0                	mov    %edx,%eax
  802e0f:	c1 e0 02             	shl    $0x2,%eax
  802e12:	01 d0                	add    %edx,%eax
  802e14:	01 c0                	add    %eax,%eax
  802e16:	01 d8                	add    %ebx,%eax
  802e18:	83 e8 30             	sub    $0x30,%eax
  802e1b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802e1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802e22:	0f b6 00             	movzbl (%rax),%eax
  802e25:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802e28:	83 fb 2f             	cmp    $0x2f,%ebx
  802e2b:	7e 0c                	jle    802e39 <vprintfmt+0x105>
  802e2d:	83 fb 39             	cmp    $0x39,%ebx
  802e30:	7f 07                	jg     802e39 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802e32:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802e37:	eb d1                	jmp    802e0a <vprintfmt+0xd6>
			goto process_precision;
  802e39:	eb 58                	jmp    802e93 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802e3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e3e:	83 f8 30             	cmp    $0x30,%eax
  802e41:	73 17                	jae    802e5a <vprintfmt+0x126>
  802e43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e4a:	89 c0                	mov    %eax,%eax
  802e4c:	48 01 d0             	add    %rdx,%rax
  802e4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e52:	83 c2 08             	add    $0x8,%edx
  802e55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e58:	eb 0f                	jmp    802e69 <vprintfmt+0x135>
  802e5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e5e:	48 89 d0             	mov    %rdx,%rax
  802e61:	48 83 c2 08          	add    $0x8,%rdx
  802e65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e69:	8b 00                	mov    (%rax),%eax
  802e6b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802e6e:	eb 23                	jmp    802e93 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802e70:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e74:	79 0c                	jns    802e82 <vprintfmt+0x14e>
				width = 0;
  802e76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e7d:	e9 3b ff ff ff       	jmpq   802dbd <vprintfmt+0x89>
  802e82:	e9 36 ff ff ff       	jmpq   802dbd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e87:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e8e:	e9 2a ff ff ff       	jmpq   802dbd <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e93:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e97:	79 12                	jns    802eab <vprintfmt+0x177>
				width = precision, precision = -1;
  802e99:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e9c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e9f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802ea6:	e9 12 ff ff ff       	jmpq   802dbd <vprintfmt+0x89>
  802eab:	e9 0d ff ff ff       	jmpq   802dbd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802eb0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802eb4:	e9 04 ff ff ff       	jmpq   802dbd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802eb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ebc:	83 f8 30             	cmp    $0x30,%eax
  802ebf:	73 17                	jae    802ed8 <vprintfmt+0x1a4>
  802ec1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ec5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ec8:	89 c0                	mov    %eax,%eax
  802eca:	48 01 d0             	add    %rdx,%rax
  802ecd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ed0:	83 c2 08             	add    $0x8,%edx
  802ed3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ed6:	eb 0f                	jmp    802ee7 <vprintfmt+0x1b3>
  802ed8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802edc:	48 89 d0             	mov    %rdx,%rax
  802edf:	48 83 c2 08          	add    $0x8,%rdx
  802ee3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ee7:	8b 10                	mov    (%rax),%edx
  802ee9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802eed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ef1:	48 89 ce             	mov    %rcx,%rsi
  802ef4:	89 d7                	mov    %edx,%edi
  802ef6:	ff d0                	callq  *%rax
			break;
  802ef8:	e9 40 03 00 00       	jmpq   80323d <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802efd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f00:	83 f8 30             	cmp    $0x30,%eax
  802f03:	73 17                	jae    802f1c <vprintfmt+0x1e8>
  802f05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f0c:	89 c0                	mov    %eax,%eax
  802f0e:	48 01 d0             	add    %rdx,%rax
  802f11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f14:	83 c2 08             	add    $0x8,%edx
  802f17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f1a:	eb 0f                	jmp    802f2b <vprintfmt+0x1f7>
  802f1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f20:	48 89 d0             	mov    %rdx,%rax
  802f23:	48 83 c2 08          	add    $0x8,%rdx
  802f27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f2b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802f2d:	85 db                	test   %ebx,%ebx
  802f2f:	79 02                	jns    802f33 <vprintfmt+0x1ff>
				err = -err;
  802f31:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802f33:	83 fb 15             	cmp    $0x15,%ebx
  802f36:	7f 16                	jg     802f4e <vprintfmt+0x21a>
  802f38:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  802f3f:	00 00 00 
  802f42:	48 63 d3             	movslq %ebx,%rdx
  802f45:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802f49:	4d 85 e4             	test   %r12,%r12
  802f4c:	75 2e                	jne    802f7c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802f4e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f56:	89 d9                	mov    %ebx,%ecx
  802f58:	48 ba a1 43 80 00 00 	movabs $0x8043a1,%rdx
  802f5f:	00 00 00 
  802f62:	48 89 c7             	mov    %rax,%rdi
  802f65:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6a:	49 b8 4c 32 80 00 00 	movabs $0x80324c,%r8
  802f71:	00 00 00 
  802f74:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f77:	e9 c1 02 00 00       	jmpq   80323d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f7c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f84:	4c 89 e1             	mov    %r12,%rcx
  802f87:	48 ba aa 43 80 00 00 	movabs $0x8043aa,%rdx
  802f8e:	00 00 00 
  802f91:	48 89 c7             	mov    %rax,%rdi
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	49 b8 4c 32 80 00 00 	movabs $0x80324c,%r8
  802fa0:	00 00 00 
  802fa3:	41 ff d0             	callq  *%r8
			break;
  802fa6:	e9 92 02 00 00       	jmpq   80323d <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802fab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fae:	83 f8 30             	cmp    $0x30,%eax
  802fb1:	73 17                	jae    802fca <vprintfmt+0x296>
  802fb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802fb7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802fba:	89 c0                	mov    %eax,%eax
  802fbc:	48 01 d0             	add    %rdx,%rax
  802fbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802fc2:	83 c2 08             	add    $0x8,%edx
  802fc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802fc8:	eb 0f                	jmp    802fd9 <vprintfmt+0x2a5>
  802fca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802fce:	48 89 d0             	mov    %rdx,%rax
  802fd1:	48 83 c2 08          	add    $0x8,%rdx
  802fd5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fd9:	4c 8b 20             	mov    (%rax),%r12
  802fdc:	4d 85 e4             	test   %r12,%r12
  802fdf:	75 0a                	jne    802feb <vprintfmt+0x2b7>
				p = "(null)";
  802fe1:	49 bc ad 43 80 00 00 	movabs $0x8043ad,%r12
  802fe8:	00 00 00 
			if (width > 0 && padc != '-')
  802feb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fef:	7e 3f                	jle    803030 <vprintfmt+0x2fc>
  802ff1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802ff5:	74 39                	je     803030 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802ff7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ffa:	48 98                	cltq   
  802ffc:	48 89 c6             	mov    %rax,%rsi
  802fff:	4c 89 e7             	mov    %r12,%rdi
  803002:	48 b8 f8 34 80 00 00 	movabs $0x8034f8,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
  80300e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803011:	eb 17                	jmp    80302a <vprintfmt+0x2f6>
					putch(padc, putdat);
  803013:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803017:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80301b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80301f:	48 89 ce             	mov    %rcx,%rsi
  803022:	89 d7                	mov    %edx,%edi
  803024:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803026:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80302a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80302e:	7f e3                	jg     803013 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803030:	eb 37                	jmp    803069 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  803032:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803036:	74 1e                	je     803056 <vprintfmt+0x322>
  803038:	83 fb 1f             	cmp    $0x1f,%ebx
  80303b:	7e 05                	jle    803042 <vprintfmt+0x30e>
  80303d:	83 fb 7e             	cmp    $0x7e,%ebx
  803040:	7e 14                	jle    803056 <vprintfmt+0x322>
					putch('?', putdat);
  803042:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803046:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80304a:	48 89 d6             	mov    %rdx,%rsi
  80304d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803052:	ff d0                	callq  *%rax
  803054:	eb 0f                	jmp    803065 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  803056:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80305a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80305e:	48 89 d6             	mov    %rdx,%rsi
  803061:	89 df                	mov    %ebx,%edi
  803063:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803065:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803069:	4c 89 e0             	mov    %r12,%rax
  80306c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803070:	0f b6 00             	movzbl (%rax),%eax
  803073:	0f be d8             	movsbl %al,%ebx
  803076:	85 db                	test   %ebx,%ebx
  803078:	74 10                	je     80308a <vprintfmt+0x356>
  80307a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80307e:	78 b2                	js     803032 <vprintfmt+0x2fe>
  803080:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803084:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803088:	79 a8                	jns    803032 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80308a:	eb 16                	jmp    8030a2 <vprintfmt+0x36e>
				putch(' ', putdat);
  80308c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803090:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803094:	48 89 d6             	mov    %rdx,%rsi
  803097:	bf 20 00 00 00       	mov    $0x20,%edi
  80309c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80309e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8030a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8030a6:	7f e4                	jg     80308c <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8030a8:	e9 90 01 00 00       	jmpq   80323d <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8030ad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030b1:	be 03 00 00 00       	mov    $0x3,%esi
  8030b6:	48 89 c7             	mov    %rax,%rdi
  8030b9:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
  8030c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8030c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030cd:	48 85 c0             	test   %rax,%rax
  8030d0:	79 1d                	jns    8030ef <vprintfmt+0x3bb>
				putch('-', putdat);
  8030d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030da:	48 89 d6             	mov    %rdx,%rsi
  8030dd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8030e2:	ff d0                	callq  *%rax
				num = -(long long) num;
  8030e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e8:	48 f7 d8             	neg    %rax
  8030eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8030ef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030f6:	e9 d5 00 00 00       	jmpq   8031d0 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8030fb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030ff:	be 03 00 00 00       	mov    $0x3,%esi
  803104:	48 89 c7             	mov    %rax,%rdi
  803107:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803117:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80311e:	e9 ad 00 00 00       	jmpq   8031d0 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803123:	8b 55 e0             	mov    -0x20(%rbp),%edx
  803126:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80312a:	89 d6                	mov    %edx,%esi
  80312c:	48 89 c7             	mov    %rax,%rdi
  80312f:	48 b8 24 2c 80 00 00 	movabs $0x802c24,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80313f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803146:	e9 85 00 00 00       	jmpq   8031d0 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  80314b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80314f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803153:	48 89 d6             	mov    %rdx,%rsi
  803156:	bf 30 00 00 00       	mov    $0x30,%edi
  80315b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80315d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803161:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803165:	48 89 d6             	mov    %rdx,%rsi
  803168:	bf 78 00 00 00       	mov    $0x78,%edi
  80316d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80316f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803172:	83 f8 30             	cmp    $0x30,%eax
  803175:	73 17                	jae    80318e <vprintfmt+0x45a>
  803177:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80317b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80317e:	89 c0                	mov    %eax,%eax
  803180:	48 01 d0             	add    %rdx,%rax
  803183:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803186:	83 c2 08             	add    $0x8,%edx
  803189:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80318c:	eb 0f                	jmp    80319d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80318e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803192:	48 89 d0             	mov    %rdx,%rax
  803195:	48 83 c2 08          	add    $0x8,%rdx
  803199:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80319d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8031a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8031a4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8031ab:	eb 23                	jmp    8031d0 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8031ad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031b1:	be 03 00 00 00       	mov    $0x3,%esi
  8031b6:	48 89 c7             	mov    %rax,%rdi
  8031b9:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
  8031c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8031c9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8031d0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8031d5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8031d8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8031db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031df:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8031e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031e7:	45 89 c1             	mov    %r8d,%r9d
  8031ea:	41 89 f8             	mov    %edi,%r8d
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 59 2a 80 00 00 	movabs $0x802a59,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
			break;
  8031fc:	eb 3f                	jmp    80323d <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8031fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803202:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803206:	48 89 d6             	mov    %rdx,%rsi
  803209:	89 df                	mov    %ebx,%edi
  80320b:	ff d0                	callq  *%rax
			break;
  80320d:	eb 2e                	jmp    80323d <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80320f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803213:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803217:	48 89 d6             	mov    %rdx,%rsi
  80321a:	bf 25 00 00 00       	mov    $0x25,%edi
  80321f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803221:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803226:	eb 05                	jmp    80322d <vprintfmt+0x4f9>
  803228:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80322d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803231:	48 83 e8 01          	sub    $0x1,%rax
  803235:	0f b6 00             	movzbl (%rax),%eax
  803238:	3c 25                	cmp    $0x25,%al
  80323a:	75 ec                	jne    803228 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80323c:	90                   	nop
		}
	}
  80323d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80323e:	e9 43 fb ff ff       	jmpq   802d86 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803243:	48 83 c4 60          	add    $0x60,%rsp
  803247:	5b                   	pop    %rbx
  803248:	41 5c                	pop    %r12
  80324a:	5d                   	pop    %rbp
  80324b:	c3                   	retq   

000000000080324c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80324c:	55                   	push   %rbp
  80324d:	48 89 e5             	mov    %rsp,%rbp
  803250:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803257:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80325e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803265:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80326c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803273:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80327a:	84 c0                	test   %al,%al
  80327c:	74 20                	je     80329e <printfmt+0x52>
  80327e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803282:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803286:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80328a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80328e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803292:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803296:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80329a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80329e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8032a5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8032ac:	00 00 00 
  8032af:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8032b6:	00 00 00 
  8032b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8032c4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032cb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8032d2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8032d9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032e0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8032e7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8032ee:	48 89 c7             	mov    %rax,%rdi
  8032f1:	48 b8 34 2d 80 00 00 	movabs $0x802d34,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
	va_end(ap);
}
  8032fd:	c9                   	leaveq 
  8032fe:	c3                   	retq   

00000000008032ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8032ff:	55                   	push   %rbp
  803300:	48 89 e5             	mov    %rsp,%rbp
  803303:	48 83 ec 10          	sub    $0x10,%rsp
  803307:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80330a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80330e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803312:	8b 40 10             	mov    0x10(%rax),%eax
  803315:	8d 50 01             	lea    0x1(%rax),%edx
  803318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80331f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803323:	48 8b 10             	mov    (%rax),%rdx
  803326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80332e:	48 39 c2             	cmp    %rax,%rdx
  803331:	73 17                	jae    80334a <sprintputch+0x4b>
		*b->buf++ = ch;
  803333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803337:	48 8b 00             	mov    (%rax),%rax
  80333a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80333e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803342:	48 89 0a             	mov    %rcx,(%rdx)
  803345:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803348:	88 10                	mov    %dl,(%rax)
}
  80334a:	c9                   	leaveq 
  80334b:	c3                   	retq   

000000000080334c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80334c:	55                   	push   %rbp
  80334d:	48 89 e5             	mov    %rsp,%rbp
  803350:	48 83 ec 50          	sub    $0x50,%rsp
  803354:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803358:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80335b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80335f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803363:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803367:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80336b:	48 8b 0a             	mov    (%rdx),%rcx
  80336e:	48 89 08             	mov    %rcx,(%rax)
  803371:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803375:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803379:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80337d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803381:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803385:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803389:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80338c:	48 98                	cltq   
  80338e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803392:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803396:	48 01 d0             	add    %rdx,%rax
  803399:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80339d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8033a4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8033a9:	74 06                	je     8033b1 <vsnprintf+0x65>
  8033ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8033af:	7f 07                	jg     8033b8 <vsnprintf+0x6c>
		return -E_INVAL;
  8033b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033b6:	eb 2f                	jmp    8033e7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8033b8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8033bc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8033c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8033c4:	48 89 c6             	mov    %rax,%rsi
  8033c7:	48 bf ff 32 80 00 00 	movabs $0x8032ff,%rdi
  8033ce:	00 00 00 
  8033d1:	48 b8 34 2d 80 00 00 	movabs $0x802d34,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8033dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8033e4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8033e7:	c9                   	leaveq 
  8033e8:	c3                   	retq   

00000000008033e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8033e9:	55                   	push   %rbp
  8033ea:	48 89 e5             	mov    %rsp,%rbp
  8033ed:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8033f4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8033fb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803401:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803408:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80340f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803416:	84 c0                	test   %al,%al
  803418:	74 20                	je     80343a <snprintf+0x51>
  80341a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80341e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803422:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803426:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80342a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80342e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803432:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803436:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80343a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803441:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803448:	00 00 00 
  80344b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803452:	00 00 00 
  803455:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803459:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803460:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803467:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80346e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803475:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80347c:	48 8b 0a             	mov    (%rdx),%rcx
  80347f:	48 89 08             	mov    %rcx,(%rax)
  803482:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803486:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80348a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80348e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803492:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803499:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8034a0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8034a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 4c 33 80 00 00 	movabs $0x80334c,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
  8034bc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8034c2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8034c8:	c9                   	leaveq 
  8034c9:	c3                   	retq   

00000000008034ca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8034ca:	55                   	push   %rbp
  8034cb:	48 89 e5             	mov    %rsp,%rbp
  8034ce:	48 83 ec 18          	sub    $0x18,%rsp
  8034d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8034d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034dd:	eb 09                	jmp    8034e8 <strlen+0x1e>
		n++;
  8034df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8034e3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ec:	0f b6 00             	movzbl (%rax),%eax
  8034ef:	84 c0                	test   %al,%al
  8034f1:	75 ec                	jne    8034df <strlen+0x15>
		n++;
	return n;
  8034f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034f6:	c9                   	leaveq 
  8034f7:	c3                   	retq   

00000000008034f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8034f8:	55                   	push   %rbp
  8034f9:	48 89 e5             	mov    %rsp,%rbp
  8034fc:	48 83 ec 20          	sub    $0x20,%rsp
  803500:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803504:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80350f:	eb 0e                	jmp    80351f <strnlen+0x27>
		n++;
  803511:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803515:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80351a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80351f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803524:	74 0b                	je     803531 <strnlen+0x39>
  803526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352a:	0f b6 00             	movzbl (%rax),%eax
  80352d:	84 c0                	test   %al,%al
  80352f:	75 e0                	jne    803511 <strnlen+0x19>
		n++;
	return n;
  803531:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803534:	c9                   	leaveq 
  803535:	c3                   	retq   

0000000000803536 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803536:	55                   	push   %rbp
  803537:	48 89 e5             	mov    %rsp,%rbp
  80353a:	48 83 ec 20          	sub    $0x20,%rsp
  80353e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803546:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80354e:	90                   	nop
  80354f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803553:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803557:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80355b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80355f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803563:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803567:	0f b6 12             	movzbl (%rdx),%edx
  80356a:	88 10                	mov    %dl,(%rax)
  80356c:	0f b6 00             	movzbl (%rax),%eax
  80356f:	84 c0                	test   %al,%al
  803571:	75 dc                	jne    80354f <strcpy+0x19>
		/* do nothing */;
	return ret;
  803573:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803577:	c9                   	leaveq 
  803578:	c3                   	retq   

0000000000803579 <strcat>:

char *
strcat(char *dst, const char *src)
{
  803579:	55                   	push   %rbp
  80357a:	48 89 e5             	mov    %rsp,%rbp
  80357d:	48 83 ec 20          	sub    $0x20,%rsp
  803581:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803585:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358d:	48 89 c7             	mov    %rax,%rdi
  803590:	48 b8 ca 34 80 00 00 	movabs $0x8034ca,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
  80359c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a2:	48 63 d0             	movslq %eax,%rdx
  8035a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035a9:	48 01 c2             	add    %rax,%rdx
  8035ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b0:	48 89 c6             	mov    %rax,%rsi
  8035b3:	48 89 d7             	mov    %rdx,%rdi
  8035b6:	48 b8 36 35 80 00 00 	movabs $0x803536,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
	return dst;
  8035c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8035c6:	c9                   	leaveq 
  8035c7:	c3                   	retq   

00000000008035c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8035c8:	55                   	push   %rbp
  8035c9:	48 89 e5             	mov    %rsp,%rbp
  8035cc:	48 83 ec 28          	sub    $0x28,%rsp
  8035d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8035e4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035eb:	00 
  8035ec:	eb 2a                	jmp    803618 <strncpy+0x50>
		*dst++ = *src;
  8035ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035fe:	0f b6 12             	movzbl (%rdx),%edx
  803601:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803603:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803607:	0f b6 00             	movzbl (%rax),%eax
  80360a:	84 c0                	test   %al,%al
  80360c:	74 05                	je     803613 <strncpy+0x4b>
			src++;
  80360e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803613:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803620:	72 cc                	jb     8035ee <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803622:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803626:	c9                   	leaveq 
  803627:	c3                   	retq   

0000000000803628 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803628:	55                   	push   %rbp
  803629:	48 89 e5             	mov    %rsp,%rbp
  80362c:	48 83 ec 28          	sub    $0x28,%rsp
  803630:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803634:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803638:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80363c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803640:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803644:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803649:	74 3d                	je     803688 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80364b:	eb 1d                	jmp    80366a <strlcpy+0x42>
			*dst++ = *src++;
  80364d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803651:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803655:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803659:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80365d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803661:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803665:	0f b6 12             	movzbl (%rdx),%edx
  803668:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80366a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80366f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803674:	74 0b                	je     803681 <strlcpy+0x59>
  803676:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80367a:	0f b6 00             	movzbl (%rax),%eax
  80367d:	84 c0                	test   %al,%al
  80367f:	75 cc                	jne    80364d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803685:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80368c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803690:	48 29 c2             	sub    %rax,%rdx
  803693:	48 89 d0             	mov    %rdx,%rax
}
  803696:	c9                   	leaveq 
  803697:	c3                   	retq   

0000000000803698 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803698:	55                   	push   %rbp
  803699:	48 89 e5             	mov    %rsp,%rbp
  80369c:	48 83 ec 10          	sub    $0x10,%rsp
  8036a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8036a8:	eb 0a                	jmp    8036b4 <strcmp+0x1c>
		p++, q++;
  8036aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036af:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8036b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b8:	0f b6 00             	movzbl (%rax),%eax
  8036bb:	84 c0                	test   %al,%al
  8036bd:	74 12                	je     8036d1 <strcmp+0x39>
  8036bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c3:	0f b6 10             	movzbl (%rax),%edx
  8036c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ca:	0f b6 00             	movzbl (%rax),%eax
  8036cd:	38 c2                	cmp    %al,%dl
  8036cf:	74 d9                	je     8036aa <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8036d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d5:	0f b6 00             	movzbl (%rax),%eax
  8036d8:	0f b6 d0             	movzbl %al,%edx
  8036db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036df:	0f b6 00             	movzbl (%rax),%eax
  8036e2:	0f b6 c0             	movzbl %al,%eax
  8036e5:	29 c2                	sub    %eax,%edx
  8036e7:	89 d0                	mov    %edx,%eax
}
  8036e9:	c9                   	leaveq 
  8036ea:	c3                   	retq   

00000000008036eb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8036eb:	55                   	push   %rbp
  8036ec:	48 89 e5             	mov    %rsp,%rbp
  8036ef:	48 83 ec 18          	sub    $0x18,%rsp
  8036f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8036ff:	eb 0f                	jmp    803710 <strncmp+0x25>
		n--, p++, q++;
  803701:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803706:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80370b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803710:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803715:	74 1d                	je     803734 <strncmp+0x49>
  803717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371b:	0f b6 00             	movzbl (%rax),%eax
  80371e:	84 c0                	test   %al,%al
  803720:	74 12                	je     803734 <strncmp+0x49>
  803722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803726:	0f b6 10             	movzbl (%rax),%edx
  803729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372d:	0f b6 00             	movzbl (%rax),%eax
  803730:	38 c2                	cmp    %al,%dl
  803732:	74 cd                	je     803701 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803734:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803739:	75 07                	jne    803742 <strncmp+0x57>
		return 0;
  80373b:	b8 00 00 00 00       	mov    $0x0,%eax
  803740:	eb 18                	jmp    80375a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  803742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803746:	0f b6 00             	movzbl (%rax),%eax
  803749:	0f b6 d0             	movzbl %al,%edx
  80374c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803750:	0f b6 00             	movzbl (%rax),%eax
  803753:	0f b6 c0             	movzbl %al,%eax
  803756:	29 c2                	sub    %eax,%edx
  803758:	89 d0                	mov    %edx,%eax
}
  80375a:	c9                   	leaveq 
  80375b:	c3                   	retq   

000000000080375c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80375c:	55                   	push   %rbp
  80375d:	48 89 e5             	mov    %rsp,%rbp
  803760:	48 83 ec 0c          	sub    $0xc,%rsp
  803764:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803768:	89 f0                	mov    %esi,%eax
  80376a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80376d:	eb 17                	jmp    803786 <strchr+0x2a>
		if (*s == c)
  80376f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803773:	0f b6 00             	movzbl (%rax),%eax
  803776:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803779:	75 06                	jne    803781 <strchr+0x25>
			return (char *) s;
  80377b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377f:	eb 15                	jmp    803796 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803781:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378a:	0f b6 00             	movzbl (%rax),%eax
  80378d:	84 c0                	test   %al,%al
  80378f:	75 de                	jne    80376f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 0c          	sub    $0xc,%rsp
  8037a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a4:	89 f0                	mov    %esi,%eax
  8037a6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8037a9:	eb 13                	jmp    8037be <strfind+0x26>
		if (*s == c)
  8037ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037af:	0f b6 00             	movzbl (%rax),%eax
  8037b2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8037b5:	75 02                	jne    8037b9 <strfind+0x21>
			break;
  8037b7:	eb 10                	jmp    8037c9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8037b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c2:	0f b6 00             	movzbl (%rax),%eax
  8037c5:	84 c0                	test   %al,%al
  8037c7:	75 e2                	jne    8037ab <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8037c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037cd:	c9                   	leaveq 
  8037ce:	c3                   	retq   

00000000008037cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8037cf:	55                   	push   %rbp
  8037d0:	48 89 e5             	mov    %rsp,%rbp
  8037d3:	48 83 ec 18          	sub    $0x18,%rsp
  8037d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037db:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8037de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8037e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8037e7:	75 06                	jne    8037ef <memset+0x20>
		return v;
  8037e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ed:	eb 69                	jmp    803858 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8037ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f3:	83 e0 03             	and    $0x3,%eax
  8037f6:	48 85 c0             	test   %rax,%rax
  8037f9:	75 48                	jne    803843 <memset+0x74>
  8037fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ff:	83 e0 03             	and    $0x3,%eax
  803802:	48 85 c0             	test   %rax,%rax
  803805:	75 3c                	jne    803843 <memset+0x74>
		c &= 0xFF;
  803807:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80380e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803811:	c1 e0 18             	shl    $0x18,%eax
  803814:	89 c2                	mov    %eax,%edx
  803816:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803819:	c1 e0 10             	shl    $0x10,%eax
  80381c:	09 c2                	or     %eax,%edx
  80381e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803821:	c1 e0 08             	shl    $0x8,%eax
  803824:	09 d0                	or     %edx,%eax
  803826:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  803829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382d:	48 c1 e8 02          	shr    $0x2,%rax
  803831:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803834:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803838:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80383b:	48 89 d7             	mov    %rdx,%rdi
  80383e:	fc                   	cld    
  80383f:	f3 ab                	rep stos %eax,%es:(%rdi)
  803841:	eb 11                	jmp    803854 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803843:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803847:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80384a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80384e:	48 89 d7             	mov    %rdx,%rdi
  803851:	fc                   	cld    
  803852:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  803854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803858:	c9                   	leaveq 
  803859:	c3                   	retq   

000000000080385a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80385a:	55                   	push   %rbp
  80385b:	48 89 e5             	mov    %rsp,%rbp
  80385e:	48 83 ec 28          	sub    $0x28,%rsp
  803862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803866:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80386a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80386e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803872:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80387e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803882:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803886:	0f 83 88 00 00 00    	jae    803914 <memmove+0xba>
  80388c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803890:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803894:	48 01 d0             	add    %rdx,%rax
  803897:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80389b:	76 77                	jbe    803914 <memmove+0xba>
		s += n;
  80389d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8038a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8038ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b1:	83 e0 03             	and    $0x3,%eax
  8038b4:	48 85 c0             	test   %rax,%rax
  8038b7:	75 3b                	jne    8038f4 <memmove+0x9a>
  8038b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bd:	83 e0 03             	and    $0x3,%eax
  8038c0:	48 85 c0             	test   %rax,%rax
  8038c3:	75 2f                	jne    8038f4 <memmove+0x9a>
  8038c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c9:	83 e0 03             	and    $0x3,%eax
  8038cc:	48 85 c0             	test   %rax,%rax
  8038cf:	75 23                	jne    8038f4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8038d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d5:	48 83 e8 04          	sub    $0x4,%rax
  8038d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038dd:	48 83 ea 04          	sub    $0x4,%rdx
  8038e1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038e5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8038e9:	48 89 c7             	mov    %rax,%rdi
  8038ec:	48 89 d6             	mov    %rdx,%rsi
  8038ef:	fd                   	std    
  8038f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038f2:	eb 1d                	jmp    803911 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8038f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8038fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803900:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803908:	48 89 d7             	mov    %rdx,%rdi
  80390b:	48 89 c1             	mov    %rax,%rcx
  80390e:	fd                   	std    
  80390f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803911:	fc                   	cld    
  803912:	eb 57                	jmp    80396b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803918:	83 e0 03             	and    $0x3,%eax
  80391b:	48 85 c0             	test   %rax,%rax
  80391e:	75 36                	jne    803956 <memmove+0xfc>
  803920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803924:	83 e0 03             	and    $0x3,%eax
  803927:	48 85 c0             	test   %rax,%rax
  80392a:	75 2a                	jne    803956 <memmove+0xfc>
  80392c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803930:	83 e0 03             	and    $0x3,%eax
  803933:	48 85 c0             	test   %rax,%rax
  803936:	75 1e                	jne    803956 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393c:	48 c1 e8 02          	shr    $0x2,%rax
  803940:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803947:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80394b:	48 89 c7             	mov    %rax,%rdi
  80394e:	48 89 d6             	mov    %rdx,%rsi
  803951:	fc                   	cld    
  803952:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803954:	eb 15                	jmp    80396b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80395e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803962:	48 89 c7             	mov    %rax,%rdi
  803965:	48 89 d6             	mov    %rdx,%rsi
  803968:	fc                   	cld    
  803969:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80396b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80396f:	c9                   	leaveq 
  803970:	c3                   	retq   

0000000000803971 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803971:	55                   	push   %rbp
  803972:	48 89 e5             	mov    %rsp,%rbp
  803975:	48 83 ec 18          	sub    $0x18,%rsp
  803979:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80397d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803981:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803989:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80398d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803991:	48 89 ce             	mov    %rcx,%rsi
  803994:	48 89 c7             	mov    %rax,%rdi
  803997:	48 b8 5a 38 80 00 00 	movabs $0x80385a,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
}
  8039a3:	c9                   	leaveq 
  8039a4:	c3                   	retq   

00000000008039a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8039a5:	55                   	push   %rbp
  8039a6:	48 89 e5             	mov    %rsp,%rbp
  8039a9:	48 83 ec 28          	sub    $0x28,%rsp
  8039ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8039b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8039c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8039c9:	eb 36                	jmp    803a01 <memcmp+0x5c>
		if (*s1 != *s2)
  8039cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039cf:	0f b6 10             	movzbl (%rax),%edx
  8039d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d6:	0f b6 00             	movzbl (%rax),%eax
  8039d9:	38 c2                	cmp    %al,%dl
  8039db:	74 1a                	je     8039f7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8039dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e1:	0f b6 00             	movzbl (%rax),%eax
  8039e4:	0f b6 d0             	movzbl %al,%edx
  8039e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039eb:	0f b6 00             	movzbl (%rax),%eax
  8039ee:	0f b6 c0             	movzbl %al,%eax
  8039f1:	29 c2                	sub    %eax,%edx
  8039f3:	89 d0                	mov    %edx,%eax
  8039f5:	eb 20                	jmp    803a17 <memcmp+0x72>
		s1++, s2++;
  8039f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a05:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803a09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803a0d:	48 85 c0             	test   %rax,%rax
  803a10:	75 b9                	jne    8039cb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a17:	c9                   	leaveq 
  803a18:	c3                   	retq   

0000000000803a19 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803a19:	55                   	push   %rbp
  803a1a:	48 89 e5             	mov    %rsp,%rbp
  803a1d:	48 83 ec 28          	sub    $0x28,%rsp
  803a21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a25:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803a28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a34:	48 01 d0             	add    %rdx,%rax
  803a37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803a3b:	eb 15                	jmp    803a52 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a41:	0f b6 10             	movzbl (%rax),%edx
  803a44:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803a47:	38 c2                	cmp    %al,%dl
  803a49:	75 02                	jne    803a4d <memfind+0x34>
			break;
  803a4b:	eb 0f                	jmp    803a5c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803a4d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a56:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803a5a:	72 e1                	jb     803a3d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803a60:	c9                   	leaveq 
  803a61:	c3                   	retq   

0000000000803a62 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803a62:	55                   	push   %rbp
  803a63:	48 89 e5             	mov    %rsp,%rbp
  803a66:	48 83 ec 34          	sub    $0x34,%rsp
  803a6a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a72:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803a7c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803a83:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a84:	eb 05                	jmp    803a8b <strtol+0x29>
		s++;
  803a86:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a8f:	0f b6 00             	movzbl (%rax),%eax
  803a92:	3c 20                	cmp    $0x20,%al
  803a94:	74 f0                	je     803a86 <strtol+0x24>
  803a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9a:	0f b6 00             	movzbl (%rax),%eax
  803a9d:	3c 09                	cmp    $0x9,%al
  803a9f:	74 e5                	je     803a86 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa5:	0f b6 00             	movzbl (%rax),%eax
  803aa8:	3c 2b                	cmp    $0x2b,%al
  803aaa:	75 07                	jne    803ab3 <strtol+0x51>
		s++;
  803aac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803ab1:	eb 17                	jmp    803aca <strtol+0x68>
	else if (*s == '-')
  803ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab7:	0f b6 00             	movzbl (%rax),%eax
  803aba:	3c 2d                	cmp    $0x2d,%al
  803abc:	75 0c                	jne    803aca <strtol+0x68>
		s++, neg = 1;
  803abe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803ac3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803aca:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803ace:	74 06                	je     803ad6 <strtol+0x74>
  803ad0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803ad4:	75 28                	jne    803afe <strtol+0x9c>
  803ad6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ada:	0f b6 00             	movzbl (%rax),%eax
  803add:	3c 30                	cmp    $0x30,%al
  803adf:	75 1d                	jne    803afe <strtol+0x9c>
  803ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae5:	48 83 c0 01          	add    $0x1,%rax
  803ae9:	0f b6 00             	movzbl (%rax),%eax
  803aec:	3c 78                	cmp    $0x78,%al
  803aee:	75 0e                	jne    803afe <strtol+0x9c>
		s += 2, base = 16;
  803af0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803af5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803afc:	eb 2c                	jmp    803b2a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803afe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803b02:	75 19                	jne    803b1d <strtol+0xbb>
  803b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b08:	0f b6 00             	movzbl (%rax),%eax
  803b0b:	3c 30                	cmp    $0x30,%al
  803b0d:	75 0e                	jne    803b1d <strtol+0xbb>
		s++, base = 8;
  803b0f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b14:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803b1b:	eb 0d                	jmp    803b2a <strtol+0xc8>
	else if (base == 0)
  803b1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803b21:	75 07                	jne    803b2a <strtol+0xc8>
		base = 10;
  803b23:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803b2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2e:	0f b6 00             	movzbl (%rax),%eax
  803b31:	3c 2f                	cmp    $0x2f,%al
  803b33:	7e 1d                	jle    803b52 <strtol+0xf0>
  803b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b39:	0f b6 00             	movzbl (%rax),%eax
  803b3c:	3c 39                	cmp    $0x39,%al
  803b3e:	7f 12                	jg     803b52 <strtol+0xf0>
			dig = *s - '0';
  803b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b44:	0f b6 00             	movzbl (%rax),%eax
  803b47:	0f be c0             	movsbl %al,%eax
  803b4a:	83 e8 30             	sub    $0x30,%eax
  803b4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b50:	eb 4e                	jmp    803ba0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803b52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b56:	0f b6 00             	movzbl (%rax),%eax
  803b59:	3c 60                	cmp    $0x60,%al
  803b5b:	7e 1d                	jle    803b7a <strtol+0x118>
  803b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b61:	0f b6 00             	movzbl (%rax),%eax
  803b64:	3c 7a                	cmp    $0x7a,%al
  803b66:	7f 12                	jg     803b7a <strtol+0x118>
			dig = *s - 'a' + 10;
  803b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6c:	0f b6 00             	movzbl (%rax),%eax
  803b6f:	0f be c0             	movsbl %al,%eax
  803b72:	83 e8 57             	sub    $0x57,%eax
  803b75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b78:	eb 26                	jmp    803ba0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803b7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b7e:	0f b6 00             	movzbl (%rax),%eax
  803b81:	3c 40                	cmp    $0x40,%al
  803b83:	7e 48                	jle    803bcd <strtol+0x16b>
  803b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b89:	0f b6 00             	movzbl (%rax),%eax
  803b8c:	3c 5a                	cmp    $0x5a,%al
  803b8e:	7f 3d                	jg     803bcd <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b94:	0f b6 00             	movzbl (%rax),%eax
  803b97:	0f be c0             	movsbl %al,%eax
  803b9a:	83 e8 37             	sub    $0x37,%eax
  803b9d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803ba0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803ba6:	7c 02                	jl     803baa <strtol+0x148>
			break;
  803ba8:	eb 23                	jmp    803bcd <strtol+0x16b>
		s++, val = (val * base) + dig;
  803baa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803baf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803bb2:	48 98                	cltq   
  803bb4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803bb9:	48 89 c2             	mov    %rax,%rdx
  803bbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bbf:	48 98                	cltq   
  803bc1:	48 01 d0             	add    %rdx,%rax
  803bc4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803bc8:	e9 5d ff ff ff       	jmpq   803b2a <strtol+0xc8>

	if (endptr)
  803bcd:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803bd2:	74 0b                	je     803bdf <strtol+0x17d>
		*endptr = (char *) s;
  803bd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bdc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803bdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be3:	74 09                	je     803bee <strtol+0x18c>
  803be5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be9:	48 f7 d8             	neg    %rax
  803bec:	eb 04                	jmp    803bf2 <strtol+0x190>
  803bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803bf2:	c9                   	leaveq 
  803bf3:	c3                   	retq   

0000000000803bf4 <strstr>:

char * strstr(const char *in, const char *str)
{
  803bf4:	55                   	push   %rbp
  803bf5:	48 89 e5             	mov    %rsp,%rbp
  803bf8:	48 83 ec 30          	sub    $0x30,%rsp
  803bfc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c08:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803c0c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803c10:	0f b6 00             	movzbl (%rax),%eax
  803c13:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803c16:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803c1a:	75 06                	jne    803c22 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803c1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c20:	eb 6b                	jmp    803c8d <strstr+0x99>

	len = strlen(str);
  803c22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c26:	48 89 c7             	mov    %rax,%rdi
  803c29:	48 b8 ca 34 80 00 00 	movabs $0x8034ca,%rax
  803c30:	00 00 00 
  803c33:	ff d0                	callq  *%rax
  803c35:	48 98                	cltq   
  803c37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c3f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803c43:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803c47:	0f b6 00             	movzbl (%rax),%eax
  803c4a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803c4d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803c51:	75 07                	jne    803c5a <strstr+0x66>
				return (char *) 0;
  803c53:	b8 00 00 00 00       	mov    $0x0,%eax
  803c58:	eb 33                	jmp    803c8d <strstr+0x99>
		} while (sc != c);
  803c5a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803c5e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803c61:	75 d8                	jne    803c3b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803c63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c67:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803c6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c6f:	48 89 ce             	mov    %rcx,%rsi
  803c72:	48 89 c7             	mov    %rax,%rdi
  803c75:	48 b8 eb 36 80 00 00 	movabs $0x8036eb,%rax
  803c7c:	00 00 00 
  803c7f:	ff d0                	callq  *%rax
  803c81:	85 c0                	test   %eax,%eax
  803c83:	75 b6                	jne    803c3b <strstr+0x47>

	return (char *) (in - 1);
  803c85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c89:	48 83 e8 01          	sub    $0x1,%rax
}
  803c8d:	c9                   	leaveq 
  803c8e:	c3                   	retq   

0000000000803c8f <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c8f:	55                   	push   %rbp
  803c90:	48 89 e5             	mov    %rsp,%rbp
  803c93:	48 83 ec 10          	sub    $0x10,%rsp
  803c97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803c9b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca2:	00 00 00 
  803ca5:	48 8b 00             	mov    (%rax),%rax
  803ca8:	48 85 c0             	test   %rax,%rax
  803cab:	0f 85 84 00 00 00    	jne    803d35 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803cb1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cb8:	00 00 00 
  803cbb:	48 8b 00             	mov    (%rax),%rax
  803cbe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803cc4:	ba 07 00 00 00       	mov    $0x7,%edx
  803cc9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803cce:	89 c7                	mov    %eax,%edi
  803cd0:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
  803cdc:	85 c0                	test   %eax,%eax
  803cde:	79 2a                	jns    803d0a <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ce0:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  803ce7:	00 00 00 
  803cea:	be 23 00 00 00       	mov    $0x23,%esi
  803cef:	48 bf 8f 46 80 00 00 	movabs $0x80468f,%rdi
  803cf6:	00 00 00 
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfe:	48 b9 48 27 80 00 00 	movabs $0x802748,%rcx
  803d05:	00 00 00 
  803d08:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803d0a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d11:	00 00 00 
  803d14:	48 8b 00             	mov    (%rax),%rax
  803d17:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803d1d:	48 be 35 06 80 00 00 	movabs $0x800635,%rsi
  803d24:	00 00 00 
  803d27:	89 c7                	mov    %eax,%edi
  803d29:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  803d30:	00 00 00 
  803d33:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803d35:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d3c:	00 00 00 
  803d3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d43:	48 89 10             	mov    %rdx,(%rax)
}
  803d46:	c9                   	leaveq 
  803d47:	c3                   	retq   

0000000000803d48 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	48 83 ec 30          	sub    $0x30,%rsp
  803d50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803d5c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d63:	00 00 00 
  803d66:	48 8b 00             	mov    (%rax),%rax
  803d69:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d6f:	85 c0                	test   %eax,%eax
  803d71:	75 3c                	jne    803daf <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d73:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
  803d7f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d84:	48 63 d0             	movslq %eax,%rdx
  803d87:	48 89 d0             	mov    %rdx,%rax
  803d8a:	48 c1 e0 03          	shl    $0x3,%rax
  803d8e:	48 01 d0             	add    %rdx,%rax
  803d91:	48 c1 e0 05          	shl    $0x5,%rax
  803d95:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d9c:	00 00 00 
  803d9f:	48 01 c2             	add    %rax,%rdx
  803da2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803da9:	00 00 00 
  803dac:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803daf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803db4:	75 0e                	jne    803dc4 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803db6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803dbd:	00 00 00 
  803dc0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803dc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc8:	48 89 c7             	mov    %rax,%rdi
  803dcb:	48 b8 27 05 80 00 00 	movabs $0x800527,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
  803dd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803dda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dde:	79 19                	jns    803df9 <ipc_recv+0xb1>
		*from_env_store = 0;
  803de0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803dea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dee:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df7:	eb 53                	jmp    803e4c <ipc_recv+0x104>
	}
	if(from_env_store)
  803df9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803dfe:	74 19                	je     803e19 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803e00:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e07:	00 00 00 
  803e0a:	48 8b 00             	mov    (%rax),%rax
  803e0d:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e17:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e19:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e1e:	74 19                	je     803e39 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803e20:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e27:	00 00 00 
  803e2a:	48 8b 00             	mov    (%rax),%rax
  803e2d:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e37:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e39:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e40:	00 00 00 
  803e43:	48 8b 00             	mov    (%rax),%rax
  803e46:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e4c:	c9                   	leaveq 
  803e4d:	c3                   	retq   

0000000000803e4e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e4e:	55                   	push   %rbp
  803e4f:	48 89 e5             	mov    %rsp,%rbp
  803e52:	48 83 ec 30          	sub    $0x30,%rsp
  803e56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e59:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e5c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e60:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803e63:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e68:	75 0e                	jne    803e78 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e6a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e71:	00 00 00 
  803e74:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e78:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e7b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e85:	89 c7                	mov    %eax,%edi
  803e87:	48 b8 d2 04 80 00 00 	movabs $0x8004d2,%rax
  803e8e:	00 00 00 
  803e91:	ff d0                	callq  *%rax
  803e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e96:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e9a:	75 0c                	jne    803ea8 <ipc_send+0x5a>
			sys_yield();
  803e9c:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  803ea3:	00 00 00 
  803ea6:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803ea8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803eac:	74 ca                	je     803e78 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803eae:	c9                   	leaveq 
  803eaf:	c3                   	retq   

0000000000803eb0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803eb0:	55                   	push   %rbp
  803eb1:	48 89 e5             	mov    %rsp,%rbp
  803eb4:	48 83 ec 14          	sub    $0x14,%rsp
  803eb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ec2:	eb 5e                	jmp    803f22 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ec4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ecb:	00 00 00 
  803ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed1:	48 63 d0             	movslq %eax,%rdx
  803ed4:	48 89 d0             	mov    %rdx,%rax
  803ed7:	48 c1 e0 03          	shl    $0x3,%rax
  803edb:	48 01 d0             	add    %rdx,%rax
  803ede:	48 c1 e0 05          	shl    $0x5,%rax
  803ee2:	48 01 c8             	add    %rcx,%rax
  803ee5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803eeb:	8b 00                	mov    (%rax),%eax
  803eed:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ef0:	75 2c                	jne    803f1e <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ef2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ef9:	00 00 00 
  803efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eff:	48 63 d0             	movslq %eax,%rdx
  803f02:	48 89 d0             	mov    %rdx,%rax
  803f05:	48 c1 e0 03          	shl    $0x3,%rax
  803f09:	48 01 d0             	add    %rdx,%rax
  803f0c:	48 c1 e0 05          	shl    $0x5,%rax
  803f10:	48 01 c8             	add    %rcx,%rax
  803f13:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f19:	8b 40 08             	mov    0x8(%rax),%eax
  803f1c:	eb 12                	jmp    803f30 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f22:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f29:	7e 99                	jle    803ec4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f30:	c9                   	leaveq 
  803f31:	c3                   	retq   

0000000000803f32 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f32:	55                   	push   %rbp
  803f33:	48 89 e5             	mov    %rsp,%rbp
  803f36:	48 83 ec 18          	sub    $0x18,%rsp
  803f3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f42:	48 c1 e8 15          	shr    $0x15,%rax
  803f46:	48 89 c2             	mov    %rax,%rdx
  803f49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f50:	01 00 00 
  803f53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f57:	83 e0 01             	and    $0x1,%eax
  803f5a:	48 85 c0             	test   %rax,%rax
  803f5d:	75 07                	jne    803f66 <pageref+0x34>
		return 0;
  803f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f64:	eb 53                	jmp    803fb9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f6e:	48 89 c2             	mov    %rax,%rdx
  803f71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f78:	01 00 00 
  803f7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f87:	83 e0 01             	and    $0x1,%eax
  803f8a:	48 85 c0             	test   %rax,%rax
  803f8d:	75 07                	jne    803f96 <pageref+0x64>
		return 0;
  803f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f94:	eb 23                	jmp    803fb9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f9a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f9e:	48 89 c2             	mov    %rax,%rdx
  803fa1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fa8:	00 00 00 
  803fab:	48 c1 e2 04          	shl    $0x4,%rdx
  803faf:	48 01 d0             	add    %rdx,%rax
  803fb2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fb6:	0f b7 c0             	movzwl %ax,%eax
}
  803fb9:	c9                   	leaveq 
  803fba:	c3                   	retq   
