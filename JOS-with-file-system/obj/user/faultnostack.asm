
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
  800052:	48 be 6b 05 80 00 00 	movabs $0x80056b,%rsi
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
  8000b8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  8000d2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
  800109:	48 b8 33 09 80 00 00 	movabs $0x800933,%rax
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
  800180:	48 ba 2a 35 80 00 00 	movabs $0x80352a,%rdx
  800187:	00 00 00 
  80018a:	be 23 00 00 00       	mov    $0x23,%esi
  80018f:	48 bf 47 35 80 00 00 	movabs $0x803547,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	49 b9 97 1c 80 00 00 	movabs $0x801c97,%r9
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

000000000080056b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80056b:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80056e:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  800575:	00 00 00 
	call *%rax
  800578:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  80057a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800581:	00 
	movq 152(%rsp), %rcx  //Load RSP
  800582:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  800589:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  80058a:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80058e:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  800591:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  800598:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  800599:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80059d:	4c 8b 3c 24          	mov    (%rsp),%r15
  8005a1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8005a6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8005ab:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8005b0:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8005b5:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8005ba:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8005bf:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8005c4:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8005c9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8005ce:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8005d3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8005d8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8005dd:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8005e2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005e7:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8005eb:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8005ef:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8005f0:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8005f1:	c3                   	retq   

00000000008005f2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8005f2:	55                   	push   %rbp
  8005f3:	48 89 e5             	mov    %rsp,%rbp
  8005f6:	48 83 ec 08          	sub    $0x8,%rsp
  8005fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800602:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800609:	ff ff ff 
  80060c:	48 01 d0             	add    %rdx,%rax
  80060f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800613:	c9                   	leaveq 
  800614:	c3                   	retq   

0000000000800615 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800615:	55                   	push   %rbp
  800616:	48 89 e5             	mov    %rsp,%rbp
  800619:	48 83 ec 08          	sub    $0x8,%rsp
  80061d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800625:	48 89 c7             	mov    %rax,%rdi
  800628:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  80062f:	00 00 00 
  800632:	ff d0                	callq  *%rax
  800634:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80063a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80063e:	c9                   	leaveq 
  80063f:	c3                   	retq   

0000000000800640 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	48 83 ec 18          	sub    $0x18,%rsp
  800648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80064c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800653:	eb 6b                	jmp    8006c0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800658:	48 98                	cltq   
  80065a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800660:	48 c1 e0 0c          	shl    $0xc,%rax
  800664:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066c:	48 c1 e8 15          	shr    $0x15,%rax
  800670:	48 89 c2             	mov    %rax,%rdx
  800673:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80067a:	01 00 00 
  80067d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800681:	83 e0 01             	and    $0x1,%eax
  800684:	48 85 c0             	test   %rax,%rax
  800687:	74 21                	je     8006aa <fd_alloc+0x6a>
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	48 c1 e8 0c          	shr    $0xc,%rax
  800691:	48 89 c2             	mov    %rax,%rdx
  800694:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80069b:	01 00 00 
  80069e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a2:	83 e0 01             	and    $0x1,%eax
  8006a5:	48 85 c0             	test   %rax,%rax
  8006a8:	75 12                	jne    8006bc <fd_alloc+0x7c>
			*fd_store = fd;
  8006aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ba:	eb 1a                	jmp    8006d6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8006c0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8006c4:	7e 8f                	jle    800655 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8006d1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8006d6:	c9                   	leaveq 
  8006d7:	c3                   	retq   

00000000008006d8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8006d8:	55                   	push   %rbp
  8006d9:	48 89 e5             	mov    %rsp,%rbp
  8006dc:	48 83 ec 20          	sub    $0x20,%rsp
  8006e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8006e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006eb:	78 06                	js     8006f3 <fd_lookup+0x1b>
  8006ed:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8006f1:	7e 07                	jle    8006fa <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006f8:	eb 6c                	jmp    800766 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8006fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8006fd:	48 98                	cltq   
  8006ff:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800705:	48 c1 e0 0c          	shl    $0xc,%rax
  800709:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80070d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800711:	48 c1 e8 15          	shr    $0x15,%rax
  800715:	48 89 c2             	mov    %rax,%rdx
  800718:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80071f:	01 00 00 
  800722:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800726:	83 e0 01             	and    $0x1,%eax
  800729:	48 85 c0             	test   %rax,%rax
  80072c:	74 21                	je     80074f <fd_lookup+0x77>
  80072e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800732:	48 c1 e8 0c          	shr    $0xc,%rax
  800736:	48 89 c2             	mov    %rax,%rdx
  800739:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800740:	01 00 00 
  800743:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800747:	83 e0 01             	and    $0x1,%eax
  80074a:	48 85 c0             	test   %rax,%rax
  80074d:	75 07                	jne    800756 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80074f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800754:	eb 10                	jmp    800766 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800756:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80075a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80075e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800761:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800766:	c9                   	leaveq 
  800767:	c3                   	retq   

0000000000800768 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800768:	55                   	push   %rbp
  800769:	48 89 e5             	mov    %rsp,%rbp
  80076c:	48 83 ec 30          	sub    $0x30,%rsp
  800770:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800774:	89 f0                	mov    %esi,%eax
  800776:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80077d:	48 89 c7             	mov    %rax,%rdi
  800780:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  800787:	00 00 00 
  80078a:	ff d0                	callq  *%rax
  80078c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800790:	48 89 d6             	mov    %rdx,%rsi
  800793:	89 c7                	mov    %eax,%edi
  800795:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  80079c:	00 00 00 
  80079f:	ff d0                	callq  *%rax
  8007a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007a8:	78 0a                	js     8007b4 <fd_close+0x4c>
	    || fd != fd2)
  8007aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ae:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007b2:	74 12                	je     8007c6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007b4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007b8:	74 05                	je     8007bf <fd_close+0x57>
  8007ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007bd:	eb 05                	jmp    8007c4 <fd_close+0x5c>
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 69                	jmp    80082f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ca:	8b 00                	mov    (%rax),%eax
  8007cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8007d0:	48 89 d6             	mov    %rdx,%rsi
  8007d3:	89 c7                	mov    %eax,%edi
  8007d5:	48 b8 31 08 80 00 00 	movabs $0x800831,%rax
  8007dc:	00 00 00 
  8007df:	ff d0                	callq  *%rax
  8007e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007e8:	78 2a                	js     800814 <fd_close+0xac>
		if (dev->dev_close)
  8007ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ee:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007f2:	48 85 c0             	test   %rax,%rax
  8007f5:	74 16                	je     80080d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800803:	48 89 d7             	mov    %rdx,%rdi
  800806:	ff d0                	callq  *%rax
  800808:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80080b:	eb 07                	jmp    800814 <fd_close+0xac>
		else
			r = 0;
  80080d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800818:	48 89 c6             	mov    %rax,%rsi
  80081b:	bf 00 00 00 00       	mov    $0x0,%edi
  800820:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800827:	00 00 00 
  80082a:	ff d0                	callq  *%rax
	return r;
  80082c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80082f:	c9                   	leaveq 
  800830:	c3                   	retq   

0000000000800831 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800831:	55                   	push   %rbp
  800832:	48 89 e5             	mov    %rsp,%rbp
  800835:	48 83 ec 20          	sub    $0x20,%rsp
  800839:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80083c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800840:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800847:	eb 41                	jmp    80088a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800849:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800850:	00 00 00 
  800853:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800856:	48 63 d2             	movslq %edx,%rdx
  800859:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80085d:	8b 00                	mov    (%rax),%eax
  80085f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800862:	75 22                	jne    800886 <dev_lookup+0x55>
			*dev = devtab[i];
  800864:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80086b:	00 00 00 
  80086e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800871:	48 63 d2             	movslq %edx,%rdx
  800874:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800878:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80087c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	eb 60                	jmp    8008e6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800886:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80088a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800891:	00 00 00 
  800894:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800897:	48 63 d2             	movslq %edx,%rdx
  80089a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80089e:	48 85 c0             	test   %rax,%rax
  8008a1:	75 a6                	jne    800849 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008a3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008aa:	00 00 00 
  8008ad:	48 8b 00             	mov    (%rax),%rax
  8008b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008b6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 58 35 80 00 00 	movabs $0x803558,%rdi
  8008c2:	00 00 00 
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	48 b9 d0 1e 80 00 00 	movabs $0x801ed0,%rcx
  8008d1:	00 00 00 
  8008d4:	ff d1                	callq  *%rcx
	*dev = 0;
  8008d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008da:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8008e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <close>:

int
close(int fdnum)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	48 83 ec 20          	sub    $0x20,%rsp
  8008f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8008f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008fa:	48 89 d6             	mov    %rdx,%rsi
  8008fd:	89 c7                	mov    %eax,%edi
  8008ff:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800906:	00 00 00 
  800909:	ff d0                	callq  *%rax
  80090b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80090e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800912:	79 05                	jns    800919 <close+0x31>
		return r;
  800914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800917:	eb 18                	jmp    800931 <close+0x49>
	else
		return fd_close(fd, 1);
  800919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80091d:	be 01 00 00 00       	mov    $0x1,%esi
  800922:	48 89 c7             	mov    %rax,%rdi
  800925:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  80092c:	00 00 00 
  80092f:	ff d0                	callq  *%rax
}
  800931:	c9                   	leaveq 
  800932:	c3                   	retq   

0000000000800933 <close_all>:

void
close_all(void)
{
  800933:	55                   	push   %rbp
  800934:	48 89 e5             	mov    %rsp,%rbp
  800937:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80093b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800942:	eb 15                	jmp    800959 <close_all+0x26>
		close(i);
  800944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800947:	89 c7                	mov    %eax,%edi
  800949:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800950:	00 00 00 
  800953:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800955:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800959:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80095d:	7e e5                	jle    800944 <close_all+0x11>
		close(i);
}
  80095f:	c9                   	leaveq 
  800960:	c3                   	retq   

0000000000800961 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800961:	55                   	push   %rbp
  800962:	48 89 e5             	mov    %rsp,%rbp
  800965:	48 83 ec 40          	sub    $0x40,%rsp
  800969:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80096c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80096f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800973:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800976:	48 89 d6             	mov    %rdx,%rsi
  800979:	89 c7                	mov    %eax,%edi
  80097b:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80098a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80098e:	79 08                	jns    800998 <dup+0x37>
		return r;
  800990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800993:	e9 70 01 00 00       	jmpq   800b08 <dup+0x1a7>
	close(newfdnum);
  800998:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80099b:	89 c7                	mov    %eax,%edi
  80099d:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  8009a4:	00 00 00 
  8009a7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009ac:	48 98                	cltq   
  8009ae:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009b4:	48 c1 e0 0c          	shl    $0xc,%rax
  8009b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c0:	48 89 c7             	mov    %rax,%rdi
  8009c3:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8009ca:	00 00 00 
  8009cd:	ff d0                	callq  *%rax
  8009cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8009d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009d7:	48 89 c7             	mov    %rax,%rdi
  8009da:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8009e1:	00 00 00 
  8009e4:	ff d0                	callq  *%rax
  8009e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ee:	48 c1 e8 15          	shr    $0x15,%rax
  8009f2:	48 89 c2             	mov    %rax,%rdx
  8009f5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8009fc:	01 00 00 
  8009ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a03:	83 e0 01             	and    $0x1,%eax
  800a06:	48 85 c0             	test   %rax,%rax
  800a09:	74 73                	je     800a7e <dup+0x11d>
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	48 c1 e8 0c          	shr    $0xc,%rax
  800a13:	48 89 c2             	mov    %rax,%rdx
  800a16:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a1d:	01 00 00 
  800a20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a24:	83 e0 01             	and    $0x1,%eax
  800a27:	48 85 c0             	test   %rax,%rax
  800a2a:	74 52                	je     800a7e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a30:	48 c1 e8 0c          	shr    $0xc,%rax
  800a34:	48 89 c2             	mov    %rax,%rdx
  800a37:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a3e:	01 00 00 
  800a41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a45:	25 07 0e 00 00       	and    $0xe07,%eax
  800a4a:	89 c1                	mov    %eax,%ecx
  800a4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a54:	41 89 c8             	mov    %ecx,%r8d
  800a57:	48 89 d1             	mov    %rdx,%rcx
  800a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5f:	48 89 c6             	mov    %rax,%rsi
  800a62:	bf 00 00 00 00       	mov    $0x0,%edi
  800a67:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800a6e:	00 00 00 
  800a71:	ff d0                	callq  *%rax
  800a73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a7a:	79 02                	jns    800a7e <dup+0x11d>
			goto err;
  800a7c:	eb 57                	jmp    800ad5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a82:	48 c1 e8 0c          	shr    $0xc,%rax
  800a86:	48 89 c2             	mov    %rax,%rdx
  800a89:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a90:	01 00 00 
  800a93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a97:	25 07 0e 00 00       	and    $0xe07,%eax
  800a9c:	89 c1                	mov    %eax,%ecx
  800a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aa2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aa6:	41 89 c8             	mov    %ecx,%r8d
  800aa9:	48 89 d1             	mov    %rdx,%rcx
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	48 89 c6             	mov    %rax,%rsi
  800ab4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab9:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	callq  *%rax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800acc:	79 02                	jns    800ad0 <dup+0x16f>
		goto err;
  800ace:	eb 05                	jmp    800ad5 <dup+0x174>

	return newfdnum;
  800ad0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800ad3:	eb 33                	jmp    800b08 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad9:	48 89 c6             	mov    %rax,%rsi
  800adc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae1:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800aed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800af1:	48 89 c6             	mov    %rax,%rsi
  800af4:	bf 00 00 00 00       	mov    $0x0,%edi
  800af9:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  800b00:	00 00 00 
  800b03:	ff d0                	callq  *%rax
	return r;
  800b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b08:	c9                   	leaveq 
  800b09:	c3                   	retq   

0000000000800b0a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b0a:	55                   	push   %rbp
  800b0b:	48 89 e5             	mov    %rsp,%rbp
  800b0e:	48 83 ec 40          	sub    $0x40,%rsp
  800b12:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b15:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b19:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b1d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b21:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b24:	48 89 d6             	mov    %rdx,%rsi
  800b27:	89 c7                	mov    %eax,%edi
  800b29:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
  800b35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b3c:	78 24                	js     800b62 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b42:	8b 00                	mov    (%rax),%eax
  800b44:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b48:	48 89 d6             	mov    %rdx,%rsi
  800b4b:	89 c7                	mov    %eax,%edi
  800b4d:	48 b8 31 08 80 00 00 	movabs $0x800831,%rax
  800b54:	00 00 00 
  800b57:	ff d0                	callq  *%rax
  800b59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b60:	79 05                	jns    800b67 <read+0x5d>
		return r;
  800b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b65:	eb 76                	jmp    800bdd <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6b:	8b 40 08             	mov    0x8(%rax),%eax
  800b6e:	83 e0 03             	and    $0x3,%eax
  800b71:	83 f8 01             	cmp    $0x1,%eax
  800b74:	75 3a                	jne    800bb0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b76:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b7d:	00 00 00 
  800b80:	48 8b 00             	mov    (%rax),%rax
  800b83:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b89:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b8c:	89 c6                	mov    %eax,%esi
  800b8e:	48 bf 77 35 80 00 00 	movabs $0x803577,%rdi
  800b95:	00 00 00 
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9d:	48 b9 d0 1e 80 00 00 	movabs $0x801ed0,%rcx
  800ba4:	00 00 00 
  800ba7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800ba9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bae:	eb 2d                	jmp    800bdd <read+0xd3>
	}
	if (!dev->dev_read)
  800bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bb4:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bb8:	48 85 c0             	test   %rax,%rax
  800bbb:	75 07                	jne    800bc4 <read+0xba>
		return -E_NOT_SUPP;
  800bbd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800bc2:	eb 19                	jmp    800bdd <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800bc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc8:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bcc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800bd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800bd8:	48 89 cf             	mov    %rcx,%rdi
  800bdb:	ff d0                	callq  *%rax
}
  800bdd:	c9                   	leaveq 
  800bde:	c3                   	retq   

0000000000800bdf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800bdf:	55                   	push   %rbp
  800be0:	48 89 e5             	mov    %rsp,%rbp
  800be3:	48 83 ec 30          	sub    $0x30,%rsp
  800be7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800bea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800bf9:	eb 49                	jmp    800c44 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bfe:	48 98                	cltq   
  800c00:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c04:	48 29 c2             	sub    %rax,%rdx
  800c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c0a:	48 63 c8             	movslq %eax,%rcx
  800c0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c11:	48 01 c1             	add    %rax,%rcx
  800c14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c17:	48 89 ce             	mov    %rcx,%rsi
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  800c23:	00 00 00 
  800c26:	ff d0                	callq  *%rax
  800c28:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c2b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c2f:	79 05                	jns    800c36 <readn+0x57>
			return m;
  800c31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c34:	eb 1c                	jmp    800c52 <readn+0x73>
		if (m == 0)
  800c36:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c3a:	75 02                	jne    800c3e <readn+0x5f>
			break;
  800c3c:	eb 11                	jmp    800c4f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c41:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c47:	48 98                	cltq   
  800c49:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c4d:	72 ac                	jb     800bfb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c52:	c9                   	leaveq 
  800c53:	c3                   	retq   

0000000000800c54 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c54:	55                   	push   %rbp
  800c55:	48 89 e5             	mov    %rsp,%rbp
  800c58:	48 83 ec 40          	sub    $0x40,%rsp
  800c5c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c63:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c67:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	89 c7                	mov    %eax,%edi
  800c73:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800c7a:	00 00 00 
  800c7d:	ff d0                	callq  *%rax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c86:	78 24                	js     800cac <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c8c:	8b 00                	mov    (%rax),%eax
  800c8e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c92:	48 89 d6             	mov    %rdx,%rsi
  800c95:	89 c7                	mov    %eax,%edi
  800c97:	48 b8 31 08 80 00 00 	movabs $0x800831,%rax
  800c9e:	00 00 00 
  800ca1:	ff d0                	callq  *%rax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ca6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800caa:	79 05                	jns    800cb1 <write+0x5d>
		return r;
  800cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800caf:	eb 75                	jmp    800d26 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb5:	8b 40 08             	mov    0x8(%rax),%eax
  800cb8:	83 e0 03             	and    $0x3,%eax
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	75 3a                	jne    800cf9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cbf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cc6:	00 00 00 
  800cc9:	48 8b 00             	mov    (%rax),%rax
  800ccc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800cd2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800cd5:	89 c6                	mov    %eax,%esi
  800cd7:	48 bf 93 35 80 00 00 	movabs $0x803593,%rdi
  800cde:	00 00 00 
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	48 b9 d0 1e 80 00 00 	movabs $0x801ed0,%rcx
  800ced:	00 00 00 
  800cf0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cf2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cf7:	eb 2d                	jmp    800d26 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cfd:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d01:	48 85 c0             	test   %rax,%rax
  800d04:	75 07                	jne    800d0d <write+0xb9>
		return -E_NOT_SUPP;
  800d06:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d0b:	eb 19                	jmp    800d26 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d11:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d15:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d19:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d1d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d21:	48 89 cf             	mov    %rcx,%rdi
  800d24:	ff d0                	callq  *%rax
}
  800d26:	c9                   	leaveq 
  800d27:	c3                   	retq   

0000000000800d28 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d28:	55                   	push   %rbp
  800d29:	48 89 e5             	mov    %rsp,%rbp
  800d2c:	48 83 ec 18          	sub    $0x18,%rsp
  800d30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d33:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d3d:	48 89 d6             	mov    %rdx,%rsi
  800d40:	89 c7                	mov    %eax,%edi
  800d42:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800d49:	00 00 00 
  800d4c:	ff d0                	callq  *%rax
  800d4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d55:	79 05                	jns    800d5c <seek+0x34>
		return r;
  800d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d5a:	eb 0f                	jmp    800d6b <seek+0x43>
	fd->fd_offset = offset;
  800d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d60:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800d63:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6b:	c9                   	leaveq 
  800d6c:	c3                   	retq   

0000000000800d6d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d6d:	55                   	push   %rbp
  800d6e:	48 89 e5             	mov    %rsp,%rbp
  800d71:	48 83 ec 30          	sub    $0x30,%rsp
  800d75:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d78:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d7b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d7f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d82:	48 89 d6             	mov    %rdx,%rsi
  800d85:	89 c7                	mov    %eax,%edi
  800d87:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800d8e:	00 00 00 
  800d91:	ff d0                	callq  *%rax
  800d93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d9a:	78 24                	js     800dc0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da0:	8b 00                	mov    (%rax),%eax
  800da2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800da6:	48 89 d6             	mov    %rdx,%rsi
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	48 b8 31 08 80 00 00 	movabs $0x800831,%rax
  800db2:	00 00 00 
  800db5:	ff d0                	callq  *%rax
  800db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dbe:	79 05                	jns    800dc5 <ftruncate+0x58>
		return r;
  800dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dc3:	eb 72                	jmp    800e37 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc9:	8b 40 08             	mov    0x8(%rax),%eax
  800dcc:	83 e0 03             	and    $0x3,%eax
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	75 3a                	jne    800e0d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800dd3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800dda:	00 00 00 
  800ddd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800de0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800de6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800de9:	89 c6                	mov    %eax,%esi
  800deb:	48 bf b0 35 80 00 00 	movabs $0x8035b0,%rdi
  800df2:	00 00 00 
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfa:	48 b9 d0 1e 80 00 00 	movabs $0x801ed0,%rcx
  800e01:	00 00 00 
  800e04:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e0b:	eb 2a                	jmp    800e37 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e11:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e15:	48 85 c0             	test   %rax,%rax
  800e18:	75 07                	jne    800e21 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e1a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e1f:	eb 16                	jmp    800e37 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e25:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e2d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e30:	89 ce                	mov    %ecx,%esi
  800e32:	48 89 d7             	mov    %rdx,%rdi
  800e35:	ff d0                	callq  *%rax
}
  800e37:	c9                   	leaveq 
  800e38:	c3                   	retq   

0000000000800e39 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e39:	55                   	push   %rbp
  800e3a:	48 89 e5             	mov    %rsp,%rbp
  800e3d:	48 83 ec 30          	sub    $0x30,%rsp
  800e41:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e44:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e48:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e4c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e4f:	48 89 d6             	mov    %rdx,%rsi
  800e52:	89 c7                	mov    %eax,%edi
  800e54:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  800e5b:	00 00 00 
  800e5e:	ff d0                	callq  *%rax
  800e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e67:	78 24                	js     800e8d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6d:	8b 00                	mov    (%rax),%eax
  800e6f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e73:	48 89 d6             	mov    %rdx,%rsi
  800e76:	89 c7                	mov    %eax,%edi
  800e78:	48 b8 31 08 80 00 00 	movabs $0x800831,%rax
  800e7f:	00 00 00 
  800e82:	ff d0                	callq  *%rax
  800e84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e8b:	79 05                	jns    800e92 <fstat+0x59>
		return r;
  800e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e90:	eb 5e                	jmp    800ef0 <fstat+0xb7>
	if (!dev->dev_stat)
  800e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e96:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e9a:	48 85 c0             	test   %rax,%rax
  800e9d:	75 07                	jne    800ea6 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e9f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ea4:	eb 4a                	jmp    800ef0 <fstat+0xb7>
	stat->st_name[0] = 0;
  800ea6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eaa:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800eb8:	00 00 00 
	stat->st_isdir = 0;
  800ebb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ebf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800ec6:	00 00 00 
	stat->st_dev = dev;
  800ec9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ecd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edc:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ee0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800ee8:	48 89 ce             	mov    %rcx,%rsi
  800eeb:	48 89 d7             	mov    %rdx,%rdi
  800eee:	ff d0                	callq  *%rax
}
  800ef0:	c9                   	leaveq 
  800ef1:	c3                   	retq   

0000000000800ef2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 83 ec 20          	sub    $0x20,%rsp
  800efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f06:	be 00 00 00 00       	mov    $0x0,%esi
  800f0b:	48 89 c7             	mov    %rax,%rdi
  800f0e:	48 b8 e0 0f 80 00 00 	movabs $0x800fe0,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	callq  *%rax
  800f1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f21:	79 05                	jns    800f28 <stat+0x36>
		return fd;
  800f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f26:	eb 2f                	jmp    800f57 <stat+0x65>
	r = fstat(fd, stat);
  800f28:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2f:	48 89 d6             	mov    %rdx,%rsi
  800f32:	89 c7                	mov    %eax,%edi
  800f34:	48 b8 39 0e 80 00 00 	movabs $0x800e39,%rax
  800f3b:	00 00 00 
  800f3e:	ff d0                	callq  *%rax
  800f40:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f46:	89 c7                	mov    %eax,%edi
  800f48:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800f4f:	00 00 00 
  800f52:	ff d0                	callq  *%rax
	return r;
  800f54:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f57:	c9                   	leaveq 
  800f58:	c3                   	retq   

0000000000800f59 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
  800f5d:	48 83 ec 10          	sub    $0x10,%rsp
  800f61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800f68:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f6f:	00 00 00 
  800f72:	8b 00                	mov    (%rax),%eax
  800f74:	85 c0                	test   %eax,%eax
  800f76:	75 1d                	jne    800f95 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f78:	bf 01 00 00 00       	mov    $0x1,%edi
  800f7d:	48 b8 ff 33 80 00 00 	movabs $0x8033ff,%rax
  800f84:	00 00 00 
  800f87:	ff d0                	callq  *%rax
  800f89:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f90:	00 00 00 
  800f93:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f95:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f9c:	00 00 00 
  800f9f:	8b 00                	mov    (%rax),%eax
  800fa1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fa4:	b9 07 00 00 00       	mov    $0x7,%ecx
  800fa9:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fb0:	00 00 00 
  800fb3:	89 c7                	mov    %eax,%edi
  800fb5:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  800fbc:	00 00 00 
  800fbf:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fca:	48 89 c6             	mov    %rax,%rsi
  800fcd:	bf 00 00 00 00       	mov    $0x0,%edi
  800fd2:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  800fd9:	00 00 00 
  800fdc:	ff d0                	callq  *%rax
}
  800fde:	c9                   	leaveq 
  800fdf:	c3                   	retq   

0000000000800fe0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800fe0:	55                   	push   %rbp
  800fe1:	48 89 e5             	mov    %rsp,%rbp
  800fe4:	48 83 ec 30          	sub    $0x30,%rsp
  800fe8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800fec:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  800fef:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  800ff6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  800ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  801004:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801009:	75 08                	jne    801013 <open+0x33>
	{
		return r;
  80100b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80100e:	e9 f2 00 00 00       	jmpq   801105 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  801013:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801017:	48 89 c7             	mov    %rax,%rdi
  80101a:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  801021:	00 00 00 
  801024:	ff d0                	callq  *%rax
  801026:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801029:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801030:	7e 0a                	jle    80103c <open+0x5c>
	{
		return -E_BAD_PATH;
  801032:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801037:	e9 c9 00 00 00       	jmpq   801105 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80103c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801043:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801044:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801048:	48 89 c7             	mov    %rax,%rdi
  80104b:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  801052:	00 00 00 
  801055:	ff d0                	callq  *%rax
  801057:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80105e:	78 09                	js     801069 <open+0x89>
  801060:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801064:	48 85 c0             	test   %rax,%rax
  801067:	75 08                	jne    801071 <open+0x91>
		{
			return r;
  801069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106c:	e9 94 00 00 00       	jmpq   801105 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801071:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801075:	ba 00 04 00 00       	mov    $0x400,%edx
  80107a:	48 89 c6             	mov    %rax,%rsi
  80107d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801084:	00 00 00 
  801087:	48 b8 17 2b 80 00 00 	movabs $0x802b17,%rax
  80108e:	00 00 00 
  801091:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801093:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80109a:	00 00 00 
  80109d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010a0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8010a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010aa:	48 89 c6             	mov    %rax,%rsi
  8010ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b2:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax
  8010be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c5:	79 2b                	jns    8010f2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	be 00 00 00 00       	mov    $0x0,%esi
  8010d0:	48 89 c7             	mov    %rax,%rdi
  8010d3:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  8010da:	00 00 00 
  8010dd:	ff d0                	callq  *%rax
  8010df:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8010e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8010e6:	79 05                	jns    8010ed <open+0x10d>
			{
				return d;
  8010e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010eb:	eb 18                	jmp    801105 <open+0x125>
			}
			return r;
  8010ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010f0:	eb 13                	jmp    801105 <open+0x125>
		}	
		return fd2num(fd_store);
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  801100:	00 00 00 
  801103:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801105:	c9                   	leaveq 
  801106:	c3                   	retq   

0000000000801107 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801107:	55                   	push   %rbp
  801108:	48 89 e5             	mov    %rsp,%rbp
  80110b:	48 83 ec 10          	sub    $0x10,%rsp
  80110f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801117:	8b 50 0c             	mov    0xc(%rax),%edx
  80111a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801121:	00 00 00 
  801124:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801126:	be 00 00 00 00       	mov    $0x0,%esi
  80112b:	bf 06 00 00 00       	mov    $0x6,%edi
  801130:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  801137:	00 00 00 
  80113a:	ff d0                	callq  *%rax
}
  80113c:	c9                   	leaveq 
  80113d:	c3                   	retq   

000000000080113e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	48 83 ec 30          	sub    $0x30,%rsp
  801146:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801159:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115e:	74 07                	je     801167 <devfile_read+0x29>
  801160:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801165:	75 07                	jne    80116e <devfile_read+0x30>
		return -E_INVAL;
  801167:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116c:	eb 77                	jmp    8011e5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80116e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801172:	8b 50 0c             	mov    0xc(%rax),%edx
  801175:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80117c:	00 00 00 
  80117f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801181:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801188:	00 00 00 
  80118b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80118f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801193:	be 00 00 00 00       	mov    $0x0,%esi
  801198:	bf 03 00 00 00       	mov    $0x3,%edi
  80119d:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  8011a4:	00 00 00 
  8011a7:	ff d0                	callq  *%rax
  8011a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011b0:	7f 05                	jg     8011b7 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8011b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b5:	eb 2e                	jmp    8011e5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8011b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ba:	48 63 d0             	movslq %eax,%rdx
  8011bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c1:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011c8:	00 00 00 
  8011cb:	48 89 c7             	mov    %rax,%rdi
  8011ce:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  8011d5:	00 00 00 
  8011d8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8011da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8011e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8011e5:	c9                   	leaveq 
  8011e6:	c3                   	retq   

00000000008011e7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8011e7:	55                   	push   %rbp
  8011e8:	48 89 e5             	mov    %rsp,%rbp
  8011eb:	48 83 ec 30          	sub    $0x30,%rsp
  8011ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8011fb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801202:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801207:	74 07                	je     801210 <devfile_write+0x29>
  801209:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80120e:	75 08                	jne    801218 <devfile_write+0x31>
		return r;
  801210:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801213:	e9 9a 00 00 00       	jmpq   8012b2 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121c:	8b 50 0c             	mov    0xc(%rax),%edx
  80121f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801226:	00 00 00 
  801229:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80122b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801232:	00 
  801233:	76 08                	jbe    80123d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801235:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80123c:	00 
	}
	fsipcbuf.write.req_n = n;
  80123d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801244:	00 00 00 
  801247:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80124b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80124f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801253:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801257:	48 89 c6             	mov    %rax,%rsi
  80125a:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801261:	00 00 00 
  801264:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  80126b:	00 00 00 
  80126e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801270:	be 00 00 00 00       	mov    $0x0,%esi
  801275:	bf 04 00 00 00       	mov    $0x4,%edi
  80127a:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
  801286:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128d:	7f 20                	jg     8012af <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80128f:	48 bf d6 35 80 00 00 	movabs $0x8035d6,%rdi
  801296:	00 00 00 
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	48 ba d0 1e 80 00 00 	movabs $0x801ed0,%rdx
  8012a5:	00 00 00 
  8012a8:	ff d2                	callq  *%rdx
		return r;
  8012aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ad:	eb 03                	jmp    8012b2 <devfile_write+0xcb>
	}
	return r;
  8012af:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8012b2:	c9                   	leaveq 
  8012b3:	c3                   	retq   

00000000008012b4 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
  8012b8:	48 83 ec 20          	sub    $0x20,%rsp
  8012bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	8b 50 0c             	mov    0xc(%rax),%edx
  8012cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d2:	00 00 00 
  8012d5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012d7:	be 00 00 00 00       	mov    $0x0,%esi
  8012dc:	bf 05 00 00 00       	mov    $0x5,%edi
  8012e1:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  8012e8:	00 00 00 
  8012eb:	ff d0                	callq  *%rax
  8012ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012f4:	79 05                	jns    8012fb <devfile_stat+0x47>
		return r;
  8012f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012f9:	eb 56                	jmp    801351 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ff:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801306:	00 00 00 
  801309:	48 89 c7             	mov    %rax,%rdi
  80130c:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  801313:	00 00 00 
  801316:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801318:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80131f:	00 00 00 
  801322:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801328:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801332:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801339:	00 00 00 
  80133c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801342:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801346:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 10          	sub    $0x10,%rsp
  80135b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	8b 50 0c             	mov    0xc(%rax),%edx
  801369:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801370:	00 00 00 
  801373:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801375:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80137c:	00 00 00 
  80137f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801382:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801385:	be 00 00 00 00       	mov    $0x0,%esi
  80138a:	bf 02 00 00 00       	mov    $0x2,%edi
  80138f:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  801396:	00 00 00 
  801399:	ff d0                	callq  *%rax
}
  80139b:	c9                   	leaveq 
  80139c:	c3                   	retq   

000000000080139d <remove>:

// Delete a file
int
remove(const char *path)
{
  80139d:	55                   	push   %rbp
  80139e:	48 89 e5             	mov    %rsp,%rbp
  8013a1:	48 83 ec 10          	sub    $0x10,%rsp
  8013a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ad:	48 89 c7             	mov    %rax,%rdi
  8013b0:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  8013b7:	00 00 00 
  8013ba:	ff d0                	callq  *%rax
  8013bc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013c1:	7e 07                	jle    8013ca <remove+0x2d>
		return -E_BAD_PATH;
  8013c3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8013c8:	eb 33                	jmp    8013fd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	48 89 c6             	mov    %rax,%rsi
  8013d1:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8013d8:	00 00 00 
  8013db:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8013e7:	be 00 00 00 00       	mov    $0x0,%esi
  8013ec:	bf 07 00 00 00       	mov    $0x7,%edi
  8013f1:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  8013f8:	00 00 00 
  8013fb:	ff d0                	callq  *%rax
}
  8013fd:	c9                   	leaveq 
  8013fe:	c3                   	retq   

00000000008013ff <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8013ff:	55                   	push   %rbp
  801400:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801403:	be 00 00 00 00       	mov    $0x0,%esi
  801408:	bf 08 00 00 00       	mov    $0x8,%edi
  80140d:	48 b8 59 0f 80 00 00 	movabs $0x800f59,%rax
  801414:	00 00 00 
  801417:	ff d0                	callq  *%rax
}
  801419:	5d                   	pop    %rbp
  80141a:	c3                   	retq   

000000000080141b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80141b:	55                   	push   %rbp
  80141c:	48 89 e5             	mov    %rsp,%rbp
  80141f:	53                   	push   %rbx
  801420:	48 83 ec 38          	sub    $0x38,%rsp
  801424:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801428:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80142c:	48 89 c7             	mov    %rax,%rdi
  80142f:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  801436:	00 00 00 
  801439:	ff d0                	callq  *%rax
  80143b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80143e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801442:	0f 88 bf 01 00 00    	js     801607 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	ba 07 04 00 00       	mov    $0x407,%edx
  801451:	48 89 c6             	mov    %rax,%rsi
  801454:	bf 00 00 00 00       	mov    $0x0,%edi
  801459:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801460:	00 00 00 
  801463:	ff d0                	callq  *%rax
  801465:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801468:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80146c:	0f 88 95 01 00 00    	js     801607 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801472:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801476:	48 89 c7             	mov    %rax,%rdi
  801479:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  801480:	00 00 00 
  801483:	ff d0                	callq  *%rax
  801485:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801488:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80148c:	0f 88 5d 01 00 00    	js     8015ef <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801496:	ba 07 04 00 00       	mov    $0x407,%edx
  80149b:	48 89 c6             	mov    %rax,%rsi
  80149e:	bf 00 00 00 00       	mov    $0x0,%edi
  8014a3:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
  8014af:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014b6:	0f 88 33 01 00 00    	js     8015ef <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8014bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c0:	48 89 c7             	mov    %rax,%rdi
  8014c3:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8014ca:	00 00 00 
  8014cd:	ff d0                	callq  *%rax
  8014cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d7:	ba 07 04 00 00       	mov    $0x407,%edx
  8014dc:	48 89 c6             	mov    %rax,%rsi
  8014df:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e4:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  8014eb:	00 00 00 
  8014ee:	ff d0                	callq  *%rax
  8014f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014f7:	79 05                	jns    8014fe <pipe+0xe3>
		goto err2;
  8014f9:	e9 d9 00 00 00       	jmpq   8015d7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801502:	48 89 c7             	mov    %rax,%rdi
  801505:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  80150c:	00 00 00 
  80150f:	ff d0                	callq  *%rax
  801511:	48 89 c2             	mov    %rax,%rdx
  801514:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801518:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80151e:	48 89 d1             	mov    %rdx,%rcx
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	48 89 c6             	mov    %rax,%rsi
  801529:	bf 00 00 00 00       	mov    $0x0,%edi
  80152e:	48 b8 4e 03 80 00 00 	movabs $0x80034e,%rax
  801535:	00 00 00 
  801538:	ff d0                	callq  *%rax
  80153a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80153d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801541:	79 1b                	jns    80155e <pipe+0x143>
		goto err3;
  801543:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801544:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801548:	48 89 c6             	mov    %rax,%rsi
  80154b:	bf 00 00 00 00       	mov    $0x0,%edi
  801550:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  801557:	00 00 00 
  80155a:	ff d0                	callq  *%rax
  80155c:	eb 79                	jmp    8015d7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80155e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801562:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801569:	00 00 00 
  80156c:	8b 12                	mov    (%rdx),%edx
  80156e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801570:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801574:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80157b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801586:	00 00 00 
  801589:	8b 12                	mov    (%rdx),%edx
  80158b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80158d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801591:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 89 c7             	mov    %rax,%rdi
  80159f:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  8015a6:	00 00 00 
  8015a9:	ff d0                	callq  *%rax
  8015ab:	89 c2                	mov    %eax,%edx
  8015ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8015b1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8015b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8015b7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8015bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bf:	48 89 c7             	mov    %rax,%rdi
  8015c2:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	callq  *%rax
  8015ce:	89 03                	mov    %eax,(%rbx)
	return 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	eb 33                	jmp    80160a <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8015d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015db:	48 89 c6             	mov    %rax,%rsi
  8015de:	bf 00 00 00 00       	mov    $0x0,%edi
  8015e3:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8015ea:	00 00 00 
  8015ed:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	48 89 c6             	mov    %rax,%rsi
  8015f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8015fb:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  801602:	00 00 00 
  801605:	ff d0                	callq  *%rax
    err:
	return r;
  801607:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80160a:	48 83 c4 38          	add    $0x38,%rsp
  80160e:	5b                   	pop    %rbx
  80160f:	5d                   	pop    %rbp
  801610:	c3                   	retq   

0000000000801611 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	53                   	push   %rbx
  801616:	48 83 ec 28          	sub    $0x28,%rsp
  80161a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80161e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801622:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801629:	00 00 00 
  80162c:	48 8b 00             	mov    (%rax),%rax
  80162f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801635:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	48 89 c7             	mov    %rax,%rdi
  80163f:	48 b8 81 34 80 00 00 	movabs $0x803481,%rax
  801646:	00 00 00 
  801649:	ff d0                	callq  *%rax
  80164b:	89 c3                	mov    %eax,%ebx
  80164d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801651:	48 89 c7             	mov    %rax,%rdi
  801654:	48 b8 81 34 80 00 00 	movabs $0x803481,%rax
  80165b:	00 00 00 
  80165e:	ff d0                	callq  *%rax
  801660:	39 c3                	cmp    %eax,%ebx
  801662:	0f 94 c0             	sete   %al
  801665:	0f b6 c0             	movzbl %al,%eax
  801668:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80166b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801672:	00 00 00 
  801675:	48 8b 00             	mov    (%rax),%rax
  801678:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80167e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801681:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801684:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801687:	75 05                	jne    80168e <_pipeisclosed+0x7d>
			return ret;
  801689:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80168c:	eb 4f                	jmp    8016dd <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80168e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801691:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801694:	74 42                	je     8016d8 <_pipeisclosed+0xc7>
  801696:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80169a:	75 3c                	jne    8016d8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80169c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8016a3:	00 00 00 
  8016a6:	48 8b 00             	mov    (%rax),%rax
  8016a9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8016af:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8016b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b5:	89 c6                	mov    %eax,%esi
  8016b7:	48 bf f7 35 80 00 00 	movabs $0x8035f7,%rdi
  8016be:	00 00 00 
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	49 b8 d0 1e 80 00 00 	movabs $0x801ed0,%r8
  8016cd:	00 00 00 
  8016d0:	41 ff d0             	callq  *%r8
	}
  8016d3:	e9 4a ff ff ff       	jmpq   801622 <_pipeisclosed+0x11>
  8016d8:	e9 45 ff ff ff       	jmpq   801622 <_pipeisclosed+0x11>
}
  8016dd:	48 83 c4 28          	add    $0x28,%rsp
  8016e1:	5b                   	pop    %rbx
  8016e2:	5d                   	pop    %rbp
  8016e3:	c3                   	retq   

00000000008016e4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	48 83 ec 30          	sub    $0x30,%rsp
  8016ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8016f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016f6:	48 89 d6             	mov    %rdx,%rsi
  8016f9:	89 c7                	mov    %eax,%edi
  8016fb:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  801702:	00 00 00 
  801705:	ff d0                	callq  *%rax
  801707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80170a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80170e:	79 05                	jns    801715 <pipeisclosed+0x31>
		return r;
  801710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801713:	eb 31                	jmp    801746 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	48 89 c7             	mov    %rax,%rdi
  80171c:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  801723:	00 00 00 
  801726:	ff d0                	callq  *%rax
  801728:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80172c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801734:	48 89 d6             	mov    %rdx,%rsi
  801737:	48 89 c7             	mov    %rax,%rdi
  80173a:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
}
  801746:	c9                   	leaveq 
  801747:	c3                   	retq   

0000000000801748 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 40          	sub    $0x40,%rsp
  801750:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801754:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801758:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801760:	48 89 c7             	mov    %rax,%rdi
  801763:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  80176a:	00 00 00 
  80176d:	ff d0                	callq  *%rax
  80176f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801773:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801777:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80177b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801782:	00 
  801783:	e9 92 00 00 00       	jmpq   80181a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801788:	eb 41                	jmp    8017cb <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80178a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80178f:	74 09                	je     80179a <devpipe_read+0x52>
				return i;
  801791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801795:	e9 92 00 00 00       	jmpq   80182c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80179a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 89 d6             	mov    %rdx,%rsi
  8017a5:	48 89 c7             	mov    %rax,%rdi
  8017a8:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  8017af:	00 00 00 
  8017b2:	ff d0                	callq  *%rax
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	74 07                	je     8017bf <devpipe_read+0x77>
				return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bd:	eb 6d                	jmp    80182c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8017bf:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8017cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cf:	8b 10                	mov    (%rax),%edx
  8017d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d5:	8b 40 04             	mov    0x4(%rax),%eax
  8017d8:	39 c2                	cmp    %eax,%edx
  8017da:	74 ae                	je     80178a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8017e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ec:	8b 00                	mov    (%rax),%eax
  8017ee:	99                   	cltd   
  8017ef:	c1 ea 1b             	shr    $0x1b,%edx
  8017f2:	01 d0                	add    %edx,%eax
  8017f4:	83 e0 1f             	and    $0x1f,%eax
  8017f7:	29 d0                	sub    %edx,%eax
  8017f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017fd:	48 98                	cltq   
  8017ff:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801804:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180a:	8b 00                	mov    (%rax),%eax
  80180c:	8d 50 01             	lea    0x1(%rax),%edx
  80180f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801813:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801815:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80181a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801822:	0f 82 60 ff ff ff    	jb     801788 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 40          	sub    $0x40,%rsp
  801836:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80183a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80183e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	48 89 c7             	mov    %rax,%rdi
  801849:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  801850:	00 00 00 
  801853:	ff d0                	callq  *%rax
  801855:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801859:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80185d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801861:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801868:	00 
  801869:	e9 8e 00 00 00       	jmpq   8018fc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80186e:	eb 31                	jmp    8018a1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801870:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801874:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801878:	48 89 d6             	mov    %rdx,%rsi
  80187b:	48 89 c7             	mov    %rax,%rdi
  80187e:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  801885:	00 00 00 
  801888:	ff d0                	callq  *%rax
  80188a:	85 c0                	test   %eax,%eax
  80188c:	74 07                	je     801895 <devpipe_write+0x67>
				return 0;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	eb 79                	jmp    80190e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801895:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  80189c:	00 00 00 
  80189f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a5:	8b 40 04             	mov    0x4(%rax),%eax
  8018a8:	48 63 d0             	movslq %eax,%rdx
  8018ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018af:	8b 00                	mov    (%rax),%eax
  8018b1:	48 98                	cltq   
  8018b3:	48 83 c0 20          	add    $0x20,%rax
  8018b7:	48 39 c2             	cmp    %rax,%rdx
  8018ba:	73 b4                	jae    801870 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c0:	8b 40 04             	mov    0x4(%rax),%eax
  8018c3:	99                   	cltd   
  8018c4:	c1 ea 1b             	shr    $0x1b,%edx
  8018c7:	01 d0                	add    %edx,%eax
  8018c9:	83 e0 1f             	and    $0x1f,%eax
  8018cc:	29 d0                	sub    %edx,%eax
  8018ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018d6:	48 01 ca             	add    %rcx,%rdx
  8018d9:	0f b6 0a             	movzbl (%rdx),%ecx
  8018dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e0:	48 98                	cltq   
  8018e2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8018e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ea:	8b 40 04             	mov    0x4(%rax),%eax
  8018ed:	8d 50 01             	lea    0x1(%rax),%edx
  8018f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801900:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801904:	0f 82 64 ff ff ff    	jb     80186e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80190a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	48 83 ec 20          	sub    $0x20,%rsp
  801918:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80191c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801924:	48 89 c7             	mov    %rax,%rdi
  801927:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  80192e:	00 00 00 
  801931:	ff d0                	callq  *%rax
  801933:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80193b:	48 be 0a 36 80 00 00 	movabs $0x80360a,%rsi
  801942:	00 00 00 
  801945:	48 89 c7             	mov    %rax,%rdi
  801948:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  80194f:	00 00 00 
  801952:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801958:	8b 50 04             	mov    0x4(%rax),%edx
  80195b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195f:	8b 00                	mov    (%rax),%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801967:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80196d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801971:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801978:	00 00 00 
	stat->st_dev = &devpipe;
  80197b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80197f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801986:	00 00 00 
  801989:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801990:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801995:	c9                   	leaveq 
  801996:	c3                   	retq   

0000000000801997 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801997:	55                   	push   %rbp
  801998:	48 89 e5             	mov    %rsp,%rbp
  80199b:	48 83 ec 10          	sub    $0x10,%rsp
  80199f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8019a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a7:	48 89 c6             	mov    %rax,%rsi
  8019aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8019af:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8019bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bf:	48 89 c7             	mov    %rax,%rdi
  8019c2:	48 b8 15 06 80 00 00 	movabs $0x800615,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	callq  *%rax
  8019ce:	48 89 c6             	mov    %rax,%rsi
  8019d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d6:	48 b8 a9 03 80 00 00 	movabs $0x8003a9,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
}
  8019e2:	c9                   	leaveq 
  8019e3:	c3                   	retq   

00000000008019e4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8019e4:	55                   	push   %rbp
  8019e5:	48 89 e5             	mov    %rsp,%rbp
  8019e8:	48 83 ec 20          	sub    $0x20,%rsp
  8019ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8019ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019f2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8019f5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8019f9:	be 01 00 00 00       	mov    $0x1,%esi
  8019fe:	48 89 c7             	mov    %rax,%rdi
  801a01:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	callq  *%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <getchar>:

int
getchar(void)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801a17:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801a1b:	ba 01 00 00 00       	mov    $0x1,%edx
  801a20:	48 89 c6             	mov    %rax,%rsi
  801a23:	bf 00 00 00 00       	mov    $0x0,%edi
  801a28:	48 b8 0a 0b 80 00 00 	movabs $0x800b0a,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
  801a34:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a3b:	79 05                	jns    801a42 <getchar+0x33>
		return r;
  801a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a40:	eb 14                	jmp    801a56 <getchar+0x47>
	if (r < 1)
  801a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a46:	7f 07                	jg     801a4f <getchar+0x40>
		return -E_EOF;
  801a48:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801a4d:	eb 07                	jmp    801a56 <getchar+0x47>
	return c;
  801a4f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801a53:	0f b6 c0             	movzbl %al,%eax
}
  801a56:	c9                   	leaveq 
  801a57:	c3                   	retq   

0000000000801a58 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801a58:	55                   	push   %rbp
  801a59:	48 89 e5             	mov    %rsp,%rbp
  801a5c:	48 83 ec 20          	sub    $0x20,%rsp
  801a60:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a63:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801a67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a6a:	48 89 d6             	mov    %rdx,%rsi
  801a6d:	89 c7                	mov    %eax,%edi
  801a6f:	48 b8 d8 06 80 00 00 	movabs $0x8006d8,%rax
  801a76:	00 00 00 
  801a79:	ff d0                	callq  *%rax
  801a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a82:	79 05                	jns    801a89 <iscons+0x31>
		return r;
  801a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a87:	eb 1a                	jmp    801aa3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801a89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8d:	8b 10                	mov    (%rax),%edx
  801a8f:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801a96:	00 00 00 
  801a99:	8b 00                	mov    (%rax),%eax
  801a9b:	39 c2                	cmp    %eax,%edx
  801a9d:	0f 94 c0             	sete   %al
  801aa0:	0f b6 c0             	movzbl %al,%eax
}
  801aa3:	c9                   	leaveq 
  801aa4:	c3                   	retq   

0000000000801aa5 <opencons>:

int
opencons(void)
{
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
  801aa9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801aad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ab1:	48 89 c7             	mov    %rax,%rdi
  801ab4:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  801abb:	00 00 00 
  801abe:	ff d0                	callq  *%rax
  801ac0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac7:	79 05                	jns    801ace <opencons+0x29>
		return r;
  801ac9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801acc:	eb 5b                	jmp    801b29 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ace:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad2:	ba 07 04 00 00       	mov    $0x407,%edx
  801ad7:	48 89 c6             	mov    %rax,%rsi
  801ada:	bf 00 00 00 00       	mov    $0x0,%edi
  801adf:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	callq  *%rax
  801aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801af2:	79 05                	jns    801af9 <opencons+0x54>
		return r;
  801af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af7:	eb 30                	jmp    801b29 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801afd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801b04:	00 00 00 
  801b07:	8b 12                	mov    (%rdx),%edx
  801b09:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b1a:	48 89 c7             	mov    %rax,%rdi
  801b1d:	48 b8 f2 05 80 00 00 	movabs $0x8005f2,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	callq  *%rax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   

0000000000801b2b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801b2b:	55                   	push   %rbp
  801b2c:	48 89 e5             	mov    %rsp,%rbp
  801b2f:	48 83 ec 30          	sub    $0x30,%rsp
  801b33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801b3f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801b44:	75 07                	jne    801b4d <devcons_read+0x22>
		return 0;
  801b46:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4b:	eb 4b                	jmp    801b98 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801b4d:	eb 0c                	jmp    801b5b <devcons_read+0x30>
		sys_yield();
  801b4f:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  801b56:	00 00 00 
  801b59:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801b5b:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	callq  *%rax
  801b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6e:	74 df                	je     801b4f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b74:	79 05                	jns    801b7b <devcons_read+0x50>
		return c;
  801b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b79:	eb 1d                	jmp    801b98 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801b7b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801b7f:	75 07                	jne    801b88 <devcons_read+0x5d>
		return 0;
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
  801b86:	eb 10                	jmp    801b98 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8b:	89 c2                	mov    %eax,%edx
  801b8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b91:	88 10                	mov    %dl,(%rax)
	return 1;
  801b93:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b98:	c9                   	leaveq 
  801b99:	c3                   	retq   

0000000000801b9a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b9a:	55                   	push   %rbp
  801b9b:	48 89 e5             	mov    %rsp,%rbp
  801b9e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801ba5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801bac:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801bb3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bc1:	eb 76                	jmp    801c39 <devcons_write+0x9f>
		m = n - tot;
  801bc3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801bca:	89 c2                	mov    %eax,%edx
  801bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcf:	29 c2                	sub    %eax,%edx
  801bd1:	89 d0                	mov    %edx,%eax
  801bd3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801bd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd9:	83 f8 7f             	cmp    $0x7f,%eax
  801bdc:	76 07                	jbe    801be5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801bde:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801be5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be8:	48 63 d0             	movslq %eax,%rdx
  801beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bee:	48 63 c8             	movslq %eax,%rcx
  801bf1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801bf8:	48 01 c1             	add    %rax,%rcx
  801bfb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801c02:	48 89 ce             	mov    %rcx,%rsi
  801c05:	48 89 c7             	mov    %rax,%rdi
  801c08:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  801c0f:	00 00 00 
  801c12:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801c14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c17:	48 63 d0             	movslq %eax,%rdx
  801c1a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801c21:	48 89 d6             	mov    %rdx,%rsi
  801c24:	48 89 c7             	mov    %rax,%rdi
  801c27:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c36:	01 45 fc             	add    %eax,-0x4(%rbp)
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	48 98                	cltq   
  801c3e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801c45:	0f 82 78 ff ff ff    	jb     801bc3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c4e:	c9                   	leaveq 
  801c4f:	c3                   	retq   

0000000000801c50 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801c50:	55                   	push   %rbp
  801c51:	48 89 e5             	mov    %rsp,%rbp
  801c54:	48 83 ec 08          	sub    $0x8,%rsp
  801c58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 10          	sub    $0x10,%rsp
  801c6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c77:	48 be 16 36 80 00 00 	movabs $0x803616,%rsi
  801c7e:	00 00 00 
  801c81:	48 89 c7             	mov    %rax,%rdi
  801c84:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
	return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	c9                   	leaveq 
  801c96:	c3                   	retq   

0000000000801c97 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c97:	55                   	push   %rbp
  801c98:	48 89 e5             	mov    %rsp,%rbp
  801c9b:	53                   	push   %rbx
  801c9c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801ca3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801caa:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801cb0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801cb7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801cbe:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801cc5:	84 c0                	test   %al,%al
  801cc7:	74 23                	je     801cec <_panic+0x55>
  801cc9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801cd0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801cd4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801cd8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801cdc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801ce0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801ce4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801ce8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801cec:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801cf3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801cfa:	00 00 00 
  801cfd:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801d04:	00 00 00 
  801d07:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d0b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801d12:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801d19:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d20:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801d27:	00 00 00 
  801d2a:	48 8b 18             	mov    (%rax),%rbx
  801d2d:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	callq  *%rax
  801d39:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801d3f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801d46:	41 89 c8             	mov    %ecx,%r8d
  801d49:	48 89 d1             	mov    %rdx,%rcx
  801d4c:	48 89 da             	mov    %rbx,%rdx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801d58:	00 00 00 
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	49 b9 d0 1e 80 00 00 	movabs $0x801ed0,%r9
  801d67:	00 00 00 
  801d6a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d6d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801d74:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801d7b:	48 89 d6             	mov    %rdx,%rsi
  801d7e:	48 89 c7             	mov    %rax,%rdi
  801d81:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
	cprintf("\n");
  801d8d:	48 bf 43 36 80 00 00 	movabs $0x803643,%rdi
  801d94:	00 00 00 
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9c:	48 ba d0 1e 80 00 00 	movabs $0x801ed0,%rdx
  801da3:	00 00 00 
  801da6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801da8:	cc                   	int3   
  801da9:	eb fd                	jmp    801da8 <_panic+0x111>

0000000000801dab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 10          	sub    $0x10,%rsp
  801db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbe:	8b 00                	mov    (%rax),%eax
  801dc0:	8d 48 01             	lea    0x1(%rax),%ecx
  801dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc7:	89 0a                	mov    %ecx,(%rdx)
  801dc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dcc:	89 d1                	mov    %edx,%ecx
  801dce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd2:	48 98                	cltq   
  801dd4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddc:	8b 00                	mov    (%rax),%eax
  801dde:	3d ff 00 00 00       	cmp    $0xff,%eax
  801de3:	75 2c                	jne    801e11 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de9:	8b 00                	mov    (%rax),%eax
  801deb:	48 98                	cltq   
  801ded:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df1:	48 83 c2 08          	add    $0x8,%rdx
  801df5:	48 89 c6             	mov    %rax,%rsi
  801df8:	48 89 d7             	mov    %rdx,%rdi
  801dfb:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
		b->idx = 0;
  801e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e15:	8b 40 04             	mov    0x4(%rax),%eax
  801e18:	8d 50 01             	lea    0x1(%rax),%edx
  801e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e1f:	89 50 04             	mov    %edx,0x4(%rax)
}
  801e22:	c9                   	leaveq 
  801e23:	c3                   	retq   

0000000000801e24 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801e24:	55                   	push   %rbp
  801e25:	48 89 e5             	mov    %rsp,%rbp
  801e28:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801e2f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801e36:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801e3d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801e44:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801e4b:	48 8b 0a             	mov    (%rdx),%rcx
  801e4e:	48 89 08             	mov    %rcx,(%rax)
  801e51:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e55:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e59:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e5d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801e61:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801e68:	00 00 00 
	b.cnt = 0;
  801e6b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801e72:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801e75:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801e7c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801e83:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801e8a:	48 89 c6             	mov    %rax,%rsi
  801e8d:	48 bf ab 1d 80 00 00 	movabs $0x801dab,%rdi
  801e94:	00 00 00 
  801e97:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801ea3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801ea9:	48 98                	cltq   
  801eab:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801eb2:	48 83 c2 08          	add    $0x8,%rdx
  801eb6:	48 89 c6             	mov    %rax,%rsi
  801eb9:	48 89 d7             	mov    %rdx,%rdi
  801ebc:	48 b8 b6 01 80 00 00 	movabs $0x8001b6,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801ec8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801edb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801ee2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801ee9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ef0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ef7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801efe:	84 c0                	test   %al,%al
  801f00:	74 20                	je     801f22 <cprintf+0x52>
  801f02:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801f06:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801f0a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f0e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f12:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f16:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f1a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f1e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f22:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801f29:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801f30:	00 00 00 
  801f33:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f3a:	00 00 00 
  801f3d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f41:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f48:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f4f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f56:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f5d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f64:	48 8b 0a             	mov    (%rdx),%rcx
  801f67:	48 89 08             	mov    %rcx,(%rax)
  801f6a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f6e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f72:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f76:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801f7a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801f81:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f88:	48 89 d6             	mov    %rdx,%rsi
  801f8b:	48 89 c7             	mov    %rax,%rdi
  801f8e:	48 b8 24 1e 80 00 00 	movabs $0x801e24,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
  801f9a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801fa0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fa6:	c9                   	leaveq 
  801fa7:	c3                   	retq   

0000000000801fa8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801fa8:	55                   	push   %rbp
  801fa9:	48 89 e5             	mov    %rsp,%rbp
  801fac:	53                   	push   %rbx
  801fad:	48 83 ec 38          	sub    $0x38,%rsp
  801fb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fbd:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801fc0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801fc4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801fc8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801fcb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801fcf:	77 3b                	ja     80200c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801fd1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801fd4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801fd8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801fdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe4:	48 f7 f3             	div    %rbx
  801fe7:	48 89 c2             	mov    %rax,%rdx
  801fea:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801fed:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801ff0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff8:	41 89 f9             	mov    %edi,%r9d
  801ffb:	48 89 c7             	mov    %rax,%rdi
  801ffe:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802005:	00 00 00 
  802008:	ff d0                	callq  *%rax
  80200a:	eb 1e                	jmp    80202a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80200c:	eb 12                	jmp    802020 <printnum+0x78>
			putch(padc, putdat);
  80200e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802012:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	48 89 ce             	mov    %rcx,%rsi
  80201c:	89 d7                	mov    %edx,%edi
  80201e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802020:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802024:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802028:	7f e4                	jg     80200e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80202a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80202d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802031:	ba 00 00 00 00       	mov    $0x0,%edx
  802036:	48 f7 f1             	div    %rcx
  802039:	48 89 d0             	mov    %rdx,%rax
  80203c:	48 ba 28 38 80 00 00 	movabs $0x803828,%rdx
  802043:	00 00 00 
  802046:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80204a:	0f be d0             	movsbl %al,%edx
  80204d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802055:	48 89 ce             	mov    %rcx,%rsi
  802058:	89 d7                	mov    %edx,%edi
  80205a:	ff d0                	callq  *%rax
}
  80205c:	48 83 c4 38          	add    $0x38,%rsp
  802060:	5b                   	pop    %rbx
  802061:	5d                   	pop    %rbp
  802062:	c3                   	retq   

0000000000802063 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802063:	55                   	push   %rbp
  802064:	48 89 e5             	mov    %rsp,%rbp
  802067:	48 83 ec 1c          	sub    $0x1c,%rsp
  80206b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80206f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802072:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802076:	7e 52                	jle    8020ca <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207c:	8b 00                	mov    (%rax),%eax
  80207e:	83 f8 30             	cmp    $0x30,%eax
  802081:	73 24                	jae    8020a7 <getuint+0x44>
  802083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802087:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80208b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208f:	8b 00                	mov    (%rax),%eax
  802091:	89 c0                	mov    %eax,%eax
  802093:	48 01 d0             	add    %rdx,%rax
  802096:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80209a:	8b 12                	mov    (%rdx),%edx
  80209c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80209f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020a3:	89 0a                	mov    %ecx,(%rdx)
  8020a5:	eb 17                	jmp    8020be <getuint+0x5b>
  8020a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ab:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020af:	48 89 d0             	mov    %rdx,%rax
  8020b2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020be:	48 8b 00             	mov    (%rax),%rax
  8020c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020c5:	e9 a3 00 00 00       	jmpq   80216d <getuint+0x10a>
	else if (lflag)
  8020ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020ce:	74 4f                	je     80211f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8020d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d4:	8b 00                	mov    (%rax),%eax
  8020d6:	83 f8 30             	cmp    $0x30,%eax
  8020d9:	73 24                	jae    8020ff <getuint+0x9c>
  8020db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e7:	8b 00                	mov    (%rax),%eax
  8020e9:	89 c0                	mov    %eax,%eax
  8020eb:	48 01 d0             	add    %rdx,%rax
  8020ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020f2:	8b 12                	mov    (%rdx),%edx
  8020f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020fb:	89 0a                	mov    %ecx,(%rdx)
  8020fd:	eb 17                	jmp    802116 <getuint+0xb3>
  8020ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802103:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802107:	48 89 d0             	mov    %rdx,%rax
  80210a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80210e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802112:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802116:	48 8b 00             	mov    (%rax),%rax
  802119:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80211d:	eb 4e                	jmp    80216d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80211f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802123:	8b 00                	mov    (%rax),%eax
  802125:	83 f8 30             	cmp    $0x30,%eax
  802128:	73 24                	jae    80214e <getuint+0xeb>
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802136:	8b 00                	mov    (%rax),%eax
  802138:	89 c0                	mov    %eax,%eax
  80213a:	48 01 d0             	add    %rdx,%rax
  80213d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802141:	8b 12                	mov    (%rdx),%edx
  802143:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80214a:	89 0a                	mov    %ecx,(%rdx)
  80214c:	eb 17                	jmp    802165 <getuint+0x102>
  80214e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802152:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802156:	48 89 d0             	mov    %rdx,%rax
  802159:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80215d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802161:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802165:	8b 00                	mov    (%rax),%eax
  802167:	89 c0                	mov    %eax,%eax
  802169:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80216d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802171:	c9                   	leaveq 
  802172:	c3                   	retq   

0000000000802173 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802173:	55                   	push   %rbp
  802174:	48 89 e5             	mov    %rsp,%rbp
  802177:	48 83 ec 1c          	sub    $0x1c,%rsp
  80217b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80217f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802182:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802186:	7e 52                	jle    8021da <getint+0x67>
		x=va_arg(*ap, long long);
  802188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218c:	8b 00                	mov    (%rax),%eax
  80218e:	83 f8 30             	cmp    $0x30,%eax
  802191:	73 24                	jae    8021b7 <getint+0x44>
  802193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802197:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80219b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219f:	8b 00                	mov    (%rax),%eax
  8021a1:	89 c0                	mov    %eax,%eax
  8021a3:	48 01 d0             	add    %rdx,%rax
  8021a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021aa:	8b 12                	mov    (%rdx),%edx
  8021ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b3:	89 0a                	mov    %ecx,(%rdx)
  8021b5:	eb 17                	jmp    8021ce <getint+0x5b>
  8021b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021bf:	48 89 d0             	mov    %rdx,%rax
  8021c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021ce:	48 8b 00             	mov    (%rax),%rax
  8021d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021d5:	e9 a3 00 00 00       	jmpq   80227d <getint+0x10a>
	else if (lflag)
  8021da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021de:	74 4f                	je     80222f <getint+0xbc>
		x=va_arg(*ap, long);
  8021e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e4:	8b 00                	mov    (%rax),%eax
  8021e6:	83 f8 30             	cmp    $0x30,%eax
  8021e9:	73 24                	jae    80220f <getint+0x9c>
  8021eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	8b 00                	mov    (%rax),%eax
  8021f9:	89 c0                	mov    %eax,%eax
  8021fb:	48 01 d0             	add    %rdx,%rax
  8021fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802202:	8b 12                	mov    (%rdx),%edx
  802204:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802207:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220b:	89 0a                	mov    %ecx,(%rdx)
  80220d:	eb 17                	jmp    802226 <getint+0xb3>
  80220f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802213:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802217:	48 89 d0             	mov    %rdx,%rax
  80221a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80221e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802222:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802226:	48 8b 00             	mov    (%rax),%rax
  802229:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80222d:	eb 4e                	jmp    80227d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80222f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802233:	8b 00                	mov    (%rax),%eax
  802235:	83 f8 30             	cmp    $0x30,%eax
  802238:	73 24                	jae    80225e <getint+0xeb>
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802246:	8b 00                	mov    (%rax),%eax
  802248:	89 c0                	mov    %eax,%eax
  80224a:	48 01 d0             	add    %rdx,%rax
  80224d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802251:	8b 12                	mov    (%rdx),%edx
  802253:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802256:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80225a:	89 0a                	mov    %ecx,(%rdx)
  80225c:	eb 17                	jmp    802275 <getint+0x102>
  80225e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802262:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802266:	48 89 d0             	mov    %rdx,%rax
  802269:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80226d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802271:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802275:	8b 00                	mov    (%rax),%eax
  802277:	48 98                	cltq   
  802279:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80227d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802281:	c9                   	leaveq 
  802282:	c3                   	retq   

0000000000802283 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802283:	55                   	push   %rbp
  802284:	48 89 e5             	mov    %rsp,%rbp
  802287:	41 54                	push   %r12
  802289:	53                   	push   %rbx
  80228a:	48 83 ec 60          	sub    $0x60,%rsp
  80228e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802292:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802296:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80229a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80229e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8022a2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8022a6:	48 8b 0a             	mov    (%rdx),%rcx
  8022a9:	48 89 08             	mov    %rcx,(%rax)
  8022ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8022b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8022b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8022b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8022bc:	eb 17                	jmp    8022d5 <vprintfmt+0x52>
			if (ch == '\0')
  8022be:	85 db                	test   %ebx,%ebx
  8022c0:	0f 84 cc 04 00 00    	je     802792 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8022c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8022ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8022ce:	48 89 d6             	mov    %rdx,%rsi
  8022d1:	89 df                	mov    %ebx,%edi
  8022d3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8022d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8022d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8022e1:	0f b6 00             	movzbl (%rax),%eax
  8022e4:	0f b6 d8             	movzbl %al,%ebx
  8022e7:	83 fb 25             	cmp    $0x25,%ebx
  8022ea:	75 d2                	jne    8022be <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8022ec:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8022f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8022f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8022fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802305:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80230c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802310:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802314:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802318:	0f b6 00             	movzbl (%rax),%eax
  80231b:	0f b6 d8             	movzbl %al,%ebx
  80231e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802321:	83 f8 55             	cmp    $0x55,%eax
  802324:	0f 87 34 04 00 00    	ja     80275e <vprintfmt+0x4db>
  80232a:	89 c0                	mov    %eax,%eax
  80232c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802333:	00 
  802334:	48 b8 50 38 80 00 00 	movabs $0x803850,%rax
  80233b:	00 00 00 
  80233e:	48 01 d0             	add    %rdx,%rax
  802341:	48 8b 00             	mov    (%rax),%rax
  802344:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802346:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80234a:	eb c0                	jmp    80230c <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80234c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802350:	eb ba                	jmp    80230c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802352:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802359:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80235c:	89 d0                	mov    %edx,%eax
  80235e:	c1 e0 02             	shl    $0x2,%eax
  802361:	01 d0                	add    %edx,%eax
  802363:	01 c0                	add    %eax,%eax
  802365:	01 d8                	add    %ebx,%eax
  802367:	83 e8 30             	sub    $0x30,%eax
  80236a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80236d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802371:	0f b6 00             	movzbl (%rax),%eax
  802374:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802377:	83 fb 2f             	cmp    $0x2f,%ebx
  80237a:	7e 0c                	jle    802388 <vprintfmt+0x105>
  80237c:	83 fb 39             	cmp    $0x39,%ebx
  80237f:	7f 07                	jg     802388 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802381:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802386:	eb d1                	jmp    802359 <vprintfmt+0xd6>
			goto process_precision;
  802388:	eb 58                	jmp    8023e2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80238a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80238d:	83 f8 30             	cmp    $0x30,%eax
  802390:	73 17                	jae    8023a9 <vprintfmt+0x126>
  802392:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802396:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802399:	89 c0                	mov    %eax,%eax
  80239b:	48 01 d0             	add    %rdx,%rax
  80239e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8023a1:	83 c2 08             	add    $0x8,%edx
  8023a4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8023a7:	eb 0f                	jmp    8023b8 <vprintfmt+0x135>
  8023a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023ad:	48 89 d0             	mov    %rdx,%rax
  8023b0:	48 83 c2 08          	add    $0x8,%rdx
  8023b4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8023b8:	8b 00                	mov    (%rax),%eax
  8023ba:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8023bd:	eb 23                	jmp    8023e2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8023bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8023c3:	79 0c                	jns    8023d1 <vprintfmt+0x14e>
				width = 0;
  8023c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8023cc:	e9 3b ff ff ff       	jmpq   80230c <vprintfmt+0x89>
  8023d1:	e9 36 ff ff ff       	jmpq   80230c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8023d6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8023dd:	e9 2a ff ff ff       	jmpq   80230c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8023e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8023e6:	79 12                	jns    8023fa <vprintfmt+0x177>
				width = precision, precision = -1;
  8023e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8023eb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8023ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8023f5:	e9 12 ff ff ff       	jmpq   80230c <vprintfmt+0x89>
  8023fa:	e9 0d ff ff ff       	jmpq   80230c <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8023ff:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802403:	e9 04 ff ff ff       	jmpq   80230c <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802408:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80240b:	83 f8 30             	cmp    $0x30,%eax
  80240e:	73 17                	jae    802427 <vprintfmt+0x1a4>
  802410:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802414:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802417:	89 c0                	mov    %eax,%eax
  802419:	48 01 d0             	add    %rdx,%rax
  80241c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80241f:	83 c2 08             	add    $0x8,%edx
  802422:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802425:	eb 0f                	jmp    802436 <vprintfmt+0x1b3>
  802427:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80242b:	48 89 d0             	mov    %rdx,%rax
  80242e:	48 83 c2 08          	add    $0x8,%rdx
  802432:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802436:	8b 10                	mov    (%rax),%edx
  802438:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80243c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802440:	48 89 ce             	mov    %rcx,%rsi
  802443:	89 d7                	mov    %edx,%edi
  802445:	ff d0                	callq  *%rax
			break;
  802447:	e9 40 03 00 00       	jmpq   80278c <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80244c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80244f:	83 f8 30             	cmp    $0x30,%eax
  802452:	73 17                	jae    80246b <vprintfmt+0x1e8>
  802454:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802458:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80245b:	89 c0                	mov    %eax,%eax
  80245d:	48 01 d0             	add    %rdx,%rax
  802460:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802463:	83 c2 08             	add    $0x8,%edx
  802466:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802469:	eb 0f                	jmp    80247a <vprintfmt+0x1f7>
  80246b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80246f:	48 89 d0             	mov    %rdx,%rax
  802472:	48 83 c2 08          	add    $0x8,%rdx
  802476:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80247a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80247c:	85 db                	test   %ebx,%ebx
  80247e:	79 02                	jns    802482 <vprintfmt+0x1ff>
				err = -err;
  802480:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802482:	83 fb 10             	cmp    $0x10,%ebx
  802485:	7f 16                	jg     80249d <vprintfmt+0x21a>
  802487:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  80248e:	00 00 00 
  802491:	48 63 d3             	movslq %ebx,%rdx
  802494:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802498:	4d 85 e4             	test   %r12,%r12
  80249b:	75 2e                	jne    8024cb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80249d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8024a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024a5:	89 d9                	mov    %ebx,%ecx
  8024a7:	48 ba 39 38 80 00 00 	movabs $0x803839,%rdx
  8024ae:	00 00 00 
  8024b1:	48 89 c7             	mov    %rax,%rdi
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b9:	49 b8 9b 27 80 00 00 	movabs $0x80279b,%r8
  8024c0:	00 00 00 
  8024c3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8024c6:	e9 c1 02 00 00       	jmpq   80278c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8024cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8024cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024d3:	4c 89 e1             	mov    %r12,%rcx
  8024d6:	48 ba 42 38 80 00 00 	movabs $0x803842,%rdx
  8024dd:	00 00 00 
  8024e0:	48 89 c7             	mov    %rax,%rdi
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	49 b8 9b 27 80 00 00 	movabs $0x80279b,%r8
  8024ef:	00 00 00 
  8024f2:	41 ff d0             	callq  *%r8
			break;
  8024f5:	e9 92 02 00 00       	jmpq   80278c <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8024fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024fd:	83 f8 30             	cmp    $0x30,%eax
  802500:	73 17                	jae    802519 <vprintfmt+0x296>
  802502:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802506:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802509:	89 c0                	mov    %eax,%eax
  80250b:	48 01 d0             	add    %rdx,%rax
  80250e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802511:	83 c2 08             	add    $0x8,%edx
  802514:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802517:	eb 0f                	jmp    802528 <vprintfmt+0x2a5>
  802519:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80251d:	48 89 d0             	mov    %rdx,%rax
  802520:	48 83 c2 08          	add    $0x8,%rdx
  802524:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802528:	4c 8b 20             	mov    (%rax),%r12
  80252b:	4d 85 e4             	test   %r12,%r12
  80252e:	75 0a                	jne    80253a <vprintfmt+0x2b7>
				p = "(null)";
  802530:	49 bc 45 38 80 00 00 	movabs $0x803845,%r12
  802537:	00 00 00 
			if (width > 0 && padc != '-')
  80253a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80253e:	7e 3f                	jle    80257f <vprintfmt+0x2fc>
  802540:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802544:	74 39                	je     80257f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802546:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802549:	48 98                	cltq   
  80254b:	48 89 c6             	mov    %rax,%rsi
  80254e:	4c 89 e7             	mov    %r12,%rdi
  802551:	48 b8 47 2a 80 00 00 	movabs $0x802a47,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802560:	eb 17                	jmp    802579 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802562:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802566:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80256a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80256e:	48 89 ce             	mov    %rcx,%rsi
  802571:	89 d7                	mov    %edx,%edi
  802573:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802575:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802579:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80257d:	7f e3                	jg     802562 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80257f:	eb 37                	jmp    8025b8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802581:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802585:	74 1e                	je     8025a5 <vprintfmt+0x322>
  802587:	83 fb 1f             	cmp    $0x1f,%ebx
  80258a:	7e 05                	jle    802591 <vprintfmt+0x30e>
  80258c:	83 fb 7e             	cmp    $0x7e,%ebx
  80258f:	7e 14                	jle    8025a5 <vprintfmt+0x322>
					putch('?', putdat);
  802591:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802595:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802599:	48 89 d6             	mov    %rdx,%rsi
  80259c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8025a1:	ff d0                	callq  *%rax
  8025a3:	eb 0f                	jmp    8025b4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8025a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8025a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025ad:	48 89 d6             	mov    %rdx,%rsi
  8025b0:	89 df                	mov    %ebx,%edi
  8025b2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8025b4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8025b8:	4c 89 e0             	mov    %r12,%rax
  8025bb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8025bf:	0f b6 00             	movzbl (%rax),%eax
  8025c2:	0f be d8             	movsbl %al,%ebx
  8025c5:	85 db                	test   %ebx,%ebx
  8025c7:	74 10                	je     8025d9 <vprintfmt+0x356>
  8025c9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8025cd:	78 b2                	js     802581 <vprintfmt+0x2fe>
  8025cf:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8025d3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8025d7:	79 a8                	jns    802581 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8025d9:	eb 16                	jmp    8025f1 <vprintfmt+0x36e>
				putch(' ', putdat);
  8025db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8025df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025e3:	48 89 d6             	mov    %rdx,%rsi
  8025e6:	bf 20 00 00 00       	mov    $0x20,%edi
  8025eb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8025ed:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8025f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025f5:	7f e4                	jg     8025db <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8025f7:	e9 90 01 00 00       	jmpq   80278c <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8025fc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802600:	be 03 00 00 00       	mov    $0x3,%esi
  802605:	48 89 c7             	mov    %rax,%rdi
  802608:	48 b8 73 21 80 00 00 	movabs $0x802173,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
  802614:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261c:	48 85 c0             	test   %rax,%rax
  80261f:	79 1d                	jns    80263e <vprintfmt+0x3bb>
				putch('-', putdat);
  802621:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802625:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802629:	48 89 d6             	mov    %rdx,%rsi
  80262c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802631:	ff d0                	callq  *%rax
				num = -(long long) num;
  802633:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802637:	48 f7 d8             	neg    %rax
  80263a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80263e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802645:	e9 d5 00 00 00       	jmpq   80271f <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80264a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80264e:	be 03 00 00 00       	mov    $0x3,%esi
  802653:	48 89 c7             	mov    %rax,%rdi
  802656:	48 b8 63 20 80 00 00 	movabs $0x802063,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802666:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80266d:	e9 ad 00 00 00       	jmpq   80271f <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  802672:	8b 55 e0             	mov    -0x20(%rbp),%edx
  802675:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802679:	89 d6                	mov    %edx,%esi
  80267b:	48 89 c7             	mov    %rax,%rdi
  80267e:	48 b8 73 21 80 00 00 	movabs $0x802173,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80268e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802695:	e9 85 00 00 00       	jmpq   80271f <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  80269a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80269e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026a2:	48 89 d6             	mov    %rdx,%rsi
  8026a5:	bf 30 00 00 00       	mov    $0x30,%edi
  8026aa:	ff d0                	callq  *%rax
			putch('x', putdat);
  8026ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026b4:	48 89 d6             	mov    %rdx,%rsi
  8026b7:	bf 78 00 00 00       	mov    $0x78,%edi
  8026bc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8026be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026c1:	83 f8 30             	cmp    $0x30,%eax
  8026c4:	73 17                	jae    8026dd <vprintfmt+0x45a>
  8026c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8026cd:	89 c0                	mov    %eax,%eax
  8026cf:	48 01 d0             	add    %rdx,%rax
  8026d2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8026d5:	83 c2 08             	add    $0x8,%edx
  8026d8:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8026db:	eb 0f                	jmp    8026ec <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8026dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026e1:	48 89 d0             	mov    %rdx,%rax
  8026e4:	48 83 c2 08          	add    $0x8,%rdx
  8026e8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8026ec:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8026ef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8026f3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8026fa:	eb 23                	jmp    80271f <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8026fc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802700:	be 03 00 00 00       	mov    $0x3,%esi
  802705:	48 89 c7             	mov    %rax,%rdi
  802708:	48 b8 63 20 80 00 00 	movabs $0x802063,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
  802714:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802718:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80271f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802724:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802727:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80272a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80272e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802732:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802736:	45 89 c1             	mov    %r8d,%r9d
  802739:	41 89 f8             	mov    %edi,%r8d
  80273c:	48 89 c7             	mov    %rax,%rdi
  80273f:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
			break;
  80274b:	eb 3f                	jmp    80278c <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80274d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802751:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802755:	48 89 d6             	mov    %rdx,%rsi
  802758:	89 df                	mov    %ebx,%edi
  80275a:	ff d0                	callq  *%rax
			break;
  80275c:	eb 2e                	jmp    80278c <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80275e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802762:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	bf 25 00 00 00       	mov    $0x25,%edi
  80276e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802770:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802775:	eb 05                	jmp    80277c <vprintfmt+0x4f9>
  802777:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80277c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802780:	48 83 e8 01          	sub    $0x1,%rax
  802784:	0f b6 00             	movzbl (%rax),%eax
  802787:	3c 25                	cmp    $0x25,%al
  802789:	75 ec                	jne    802777 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80278b:	90                   	nop
		}
	}
  80278c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80278d:	e9 43 fb ff ff       	jmpq   8022d5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802792:	48 83 c4 60          	add    $0x60,%rsp
  802796:	5b                   	pop    %rbx
  802797:	41 5c                	pop    %r12
  802799:	5d                   	pop    %rbp
  80279a:	c3                   	retq   

000000000080279b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80279b:	55                   	push   %rbp
  80279c:	48 89 e5             	mov    %rsp,%rbp
  80279f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8027a6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8027ad:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8027b4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8027bb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8027c2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8027c9:	84 c0                	test   %al,%al
  8027cb:	74 20                	je     8027ed <printfmt+0x52>
  8027cd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8027d1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8027d5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8027d9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8027dd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8027e1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8027e5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8027e9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8027ed:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8027f4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8027fb:	00 00 00 
  8027fe:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802805:	00 00 00 
  802808:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80280c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802813:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80281a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802821:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802828:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80282f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802836:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80283d:	48 89 c7             	mov    %rax,%rdi
  802840:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  802847:	00 00 00 
  80284a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80284c:	c9                   	leaveq 
  80284d:	c3                   	retq   

000000000080284e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80284e:	55                   	push   %rbp
  80284f:	48 89 e5             	mov    %rsp,%rbp
  802852:	48 83 ec 10          	sub    $0x10,%rsp
  802856:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802859:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80285d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802861:	8b 40 10             	mov    0x10(%rax),%eax
  802864:	8d 50 01             	lea    0x1(%rax),%edx
  802867:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80286e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802872:	48 8b 10             	mov    (%rax),%rdx
  802875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802879:	48 8b 40 08          	mov    0x8(%rax),%rax
  80287d:	48 39 c2             	cmp    %rax,%rdx
  802880:	73 17                	jae    802899 <sprintputch+0x4b>
		*b->buf++ = ch;
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 8b 00             	mov    (%rax),%rax
  802889:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80288d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802891:	48 89 0a             	mov    %rcx,(%rdx)
  802894:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802897:	88 10                	mov    %dl,(%rax)
}
  802899:	c9                   	leaveq 
  80289a:	c3                   	retq   

000000000080289b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	48 83 ec 50          	sub    $0x50,%rsp
  8028a3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8028a7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8028aa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8028ae:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8028b2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028b6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8028ba:	48 8b 0a             	mov    (%rdx),%rcx
  8028bd:	48 89 08             	mov    %rcx,(%rax)
  8028c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8028c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8028c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8028cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8028d0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028d4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8028d8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8028db:	48 98                	cltq   
  8028dd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8028e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8028e5:	48 01 d0             	add    %rdx,%rax
  8028e8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8028ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8028f3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8028f8:	74 06                	je     802900 <vsnprintf+0x65>
  8028fa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8028fe:	7f 07                	jg     802907 <vsnprintf+0x6c>
		return -E_INVAL;
  802900:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802905:	eb 2f                	jmp    802936 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802907:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80290b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80290f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802913:	48 89 c6             	mov    %rax,%rsi
  802916:	48 bf 4e 28 80 00 00 	movabs $0x80284e,%rdi
  80291d:	00 00 00 
  802920:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  802927:	00 00 00 
  80292a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80292c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802930:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802933:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802936:	c9                   	leaveq 
  802937:	c3                   	retq   

0000000000802938 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802938:	55                   	push   %rbp
  802939:	48 89 e5             	mov    %rsp,%rbp
  80293c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802943:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80294a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802950:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802957:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80295e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802965:	84 c0                	test   %al,%al
  802967:	74 20                	je     802989 <snprintf+0x51>
  802969:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80296d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802971:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802975:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802979:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80297d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802981:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802985:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802989:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802990:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802997:	00 00 00 
  80299a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8029a1:	00 00 00 
  8029a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8029a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8029af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8029b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8029bd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8029c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029cb:	48 8b 0a             	mov    (%rdx),%rcx
  8029ce:	48 89 08             	mov    %rcx,(%rax)
  8029d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8029e1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8029e8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8029ef:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8029f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029fc:	48 89 c7             	mov    %rax,%rdi
  8029ff:	48 b8 9b 28 80 00 00 	movabs $0x80289b,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802a11:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802a17:	c9                   	leaveq 
  802a18:	c3                   	retq   

0000000000802a19 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 18          	sub    $0x18,%rsp
  802a21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802a25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a2c:	eb 09                	jmp    802a37 <strlen+0x1e>
		n++;
  802a2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802a32:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3b:	0f b6 00             	movzbl (%rax),%eax
  802a3e:	84 c0                	test   %al,%al
  802a40:	75 ec                	jne    802a2e <strlen+0x15>
		n++;
	return n;
  802a42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a45:	c9                   	leaveq 
  802a46:	c3                   	retq   

0000000000802a47 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802a47:	55                   	push   %rbp
  802a48:	48 89 e5             	mov    %rsp,%rbp
  802a4b:	48 83 ec 20          	sub    $0x20,%rsp
  802a4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a5e:	eb 0e                	jmp    802a6e <strnlen+0x27>
		n++;
  802a60:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802a64:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802a69:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802a6e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a73:	74 0b                	je     802a80 <strnlen+0x39>
  802a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a79:	0f b6 00             	movzbl (%rax),%eax
  802a7c:	84 c0                	test   %al,%al
  802a7e:	75 e0                	jne    802a60 <strnlen+0x19>
		n++;
	return n;
  802a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a83:	c9                   	leaveq 
  802a84:	c3                   	retq   

0000000000802a85 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802a85:	55                   	push   %rbp
  802a86:	48 89 e5             	mov    %rsp,%rbp
  802a89:	48 83 ec 20          	sub    $0x20,%rsp
  802a8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a99:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802a9d:	90                   	nop
  802a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802aa6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802aaa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aae:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802ab2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802ab6:	0f b6 12             	movzbl (%rdx),%edx
  802ab9:	88 10                	mov    %dl,(%rax)
  802abb:	0f b6 00             	movzbl (%rax),%eax
  802abe:	84 c0                	test   %al,%al
  802ac0:	75 dc                	jne    802a9e <strcpy+0x19>
		/* do nothing */;
	return ret;
  802ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ac6:	c9                   	leaveq 
  802ac7:	c3                   	retq   

0000000000802ac8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802ac8:	55                   	push   %rbp
  802ac9:	48 89 e5             	mov    %rsp,%rbp
  802acc:	48 83 ec 20          	sub    $0x20,%rsp
  802ad0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ad4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adc:	48 89 c7             	mov    %rax,%rdi
  802adf:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af1:	48 63 d0             	movslq %eax,%rdx
  802af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af8:	48 01 c2             	add    %rax,%rdx
  802afb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aff:	48 89 c6             	mov    %rax,%rsi
  802b02:	48 89 d7             	mov    %rdx,%rdi
  802b05:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  802b0c:	00 00 00 
  802b0f:	ff d0                	callq  *%rax
	return dst;
  802b11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802b15:	c9                   	leaveq 
  802b16:	c3                   	retq   

0000000000802b17 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
  802b1b:	48 83 ec 28          	sub    $0x28,%rsp
  802b1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b27:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802b33:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802b3a:	00 
  802b3b:	eb 2a                	jmp    802b67 <strncpy+0x50>
		*dst++ = *src;
  802b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b45:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b49:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b4d:	0f b6 12             	movzbl (%rdx),%edx
  802b50:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802b52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b56:	0f b6 00             	movzbl (%rax),%eax
  802b59:	84 c0                	test   %al,%al
  802b5b:	74 05                	je     802b62 <strncpy+0x4b>
			src++;
  802b5d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802b62:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802b67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b6b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b6f:	72 cc                	jb     802b3d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802b75:	c9                   	leaveq 
  802b76:	c3                   	retq   

0000000000802b77 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	48 83 ec 28          	sub    $0x28,%rsp
  802b7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802b8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802b93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b98:	74 3d                	je     802bd7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802b9a:	eb 1d                	jmp    802bb9 <strlcpy+0x42>
			*dst++ = *src++;
  802b9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ba4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ba8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802bb0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802bb4:	0f b6 12             	movzbl (%rdx),%edx
  802bb7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802bb9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802bbe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802bc3:	74 0b                	je     802bd0 <strlcpy+0x59>
  802bc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc9:	0f b6 00             	movzbl (%rax),%eax
  802bcc:	84 c0                	test   %al,%al
  802bce:	75 cc                	jne    802b9c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802bd7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bdf:	48 29 c2             	sub    %rax,%rdx
  802be2:	48 89 d0             	mov    %rdx,%rax
}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
  802beb:	48 83 ec 10          	sub    $0x10,%rsp
  802bef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802bf7:	eb 0a                	jmp    802c03 <strcmp+0x1c>
		p++, q++;
  802bf9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802bfe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802c03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c07:	0f b6 00             	movzbl (%rax),%eax
  802c0a:	84 c0                	test   %al,%al
  802c0c:	74 12                	je     802c20 <strcmp+0x39>
  802c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c12:	0f b6 10             	movzbl (%rax),%edx
  802c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c19:	0f b6 00             	movzbl (%rax),%eax
  802c1c:	38 c2                	cmp    %al,%dl
  802c1e:	74 d9                	je     802bf9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c24:	0f b6 00             	movzbl (%rax),%eax
  802c27:	0f b6 d0             	movzbl %al,%edx
  802c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2e:	0f b6 00             	movzbl (%rax),%eax
  802c31:	0f b6 c0             	movzbl %al,%eax
  802c34:	29 c2                	sub    %eax,%edx
  802c36:	89 d0                	mov    %edx,%eax
}
  802c38:	c9                   	leaveq 
  802c39:	c3                   	retq   

0000000000802c3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802c3a:	55                   	push   %rbp
  802c3b:	48 89 e5             	mov    %rsp,%rbp
  802c3e:	48 83 ec 18          	sub    $0x18,%rsp
  802c42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c4a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802c4e:	eb 0f                	jmp    802c5f <strncmp+0x25>
		n--, p++, q++;
  802c50:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802c55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c5a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802c5f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c64:	74 1d                	je     802c83 <strncmp+0x49>
  802c66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c6a:	0f b6 00             	movzbl (%rax),%eax
  802c6d:	84 c0                	test   %al,%al
  802c6f:	74 12                	je     802c83 <strncmp+0x49>
  802c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c75:	0f b6 10             	movzbl (%rax),%edx
  802c78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7c:	0f b6 00             	movzbl (%rax),%eax
  802c7f:	38 c2                	cmp    %al,%dl
  802c81:	74 cd                	je     802c50 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802c83:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c88:	75 07                	jne    802c91 <strncmp+0x57>
		return 0;
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	eb 18                	jmp    802ca9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c95:	0f b6 00             	movzbl (%rax),%eax
  802c98:	0f b6 d0             	movzbl %al,%edx
  802c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9f:	0f b6 00             	movzbl (%rax),%eax
  802ca2:	0f b6 c0             	movzbl %al,%eax
  802ca5:	29 c2                	sub    %eax,%edx
  802ca7:	89 d0                	mov    %edx,%eax
}
  802ca9:	c9                   	leaveq 
  802caa:	c3                   	retq   

0000000000802cab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802cab:	55                   	push   %rbp
  802cac:	48 89 e5             	mov    %rsp,%rbp
  802caf:	48 83 ec 0c          	sub    $0xc,%rsp
  802cb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cb7:	89 f0                	mov    %esi,%eax
  802cb9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802cbc:	eb 17                	jmp    802cd5 <strchr+0x2a>
		if (*s == c)
  802cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc2:	0f b6 00             	movzbl (%rax),%eax
  802cc5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802cc8:	75 06                	jne    802cd0 <strchr+0x25>
			return (char *) s;
  802cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cce:	eb 15                	jmp    802ce5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802cd0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd9:	0f b6 00             	movzbl (%rax),%eax
  802cdc:	84 c0                	test   %al,%al
  802cde:	75 de                	jne    802cbe <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce5:	c9                   	leaveq 
  802ce6:	c3                   	retq   

0000000000802ce7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802ce7:	55                   	push   %rbp
  802ce8:	48 89 e5             	mov    %rsp,%rbp
  802ceb:	48 83 ec 0c          	sub    $0xc,%rsp
  802cef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cf3:	89 f0                	mov    %esi,%eax
  802cf5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802cf8:	eb 13                	jmp    802d0d <strfind+0x26>
		if (*s == c)
  802cfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cfe:	0f b6 00             	movzbl (%rax),%eax
  802d01:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802d04:	75 02                	jne    802d08 <strfind+0x21>
			break;
  802d06:	eb 10                	jmp    802d18 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802d08:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d11:	0f b6 00             	movzbl (%rax),%eax
  802d14:	84 c0                	test   %al,%al
  802d16:	75 e2                	jne    802cfa <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d1c:	c9                   	leaveq 
  802d1d:	c3                   	retq   

0000000000802d1e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 18          	sub    $0x18,%rsp
  802d26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d2a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802d2d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802d31:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d36:	75 06                	jne    802d3e <memset+0x20>
		return v;
  802d38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d3c:	eb 69                	jmp    802da7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d42:	83 e0 03             	and    $0x3,%eax
  802d45:	48 85 c0             	test   %rax,%rax
  802d48:	75 48                	jne    802d92 <memset+0x74>
  802d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4e:	83 e0 03             	and    $0x3,%eax
  802d51:	48 85 c0             	test   %rax,%rax
  802d54:	75 3c                	jne    802d92 <memset+0x74>
		c &= 0xFF;
  802d56:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802d5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d60:	c1 e0 18             	shl    $0x18,%eax
  802d63:	89 c2                	mov    %eax,%edx
  802d65:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d68:	c1 e0 10             	shl    $0x10,%eax
  802d6b:	09 c2                	or     %eax,%edx
  802d6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d70:	c1 e0 08             	shl    $0x8,%eax
  802d73:	09 d0                	or     %edx,%eax
  802d75:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7c:	48 c1 e8 02          	shr    $0x2,%rax
  802d80:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802d83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d87:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d8a:	48 89 d7             	mov    %rdx,%rdi
  802d8d:	fc                   	cld    
  802d8e:	f3 ab                	rep stos %eax,%es:(%rdi)
  802d90:	eb 11                	jmp    802da3 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802d92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9d:	48 89 d7             	mov    %rdx,%rdi
  802da0:	fc                   	cld    
  802da1:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802da3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 28          	sub    $0x28,%rsp
  802db1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802db9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802dbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802dd5:	0f 83 88 00 00 00    	jae    802e63 <memmove+0xba>
  802ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802de3:	48 01 d0             	add    %rdx,%rax
  802de6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802dea:	76 77                	jbe    802e63 <memmove+0xba>
		s += n;
  802dec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e00:	83 e0 03             	and    $0x3,%eax
  802e03:	48 85 c0             	test   %rax,%rax
  802e06:	75 3b                	jne    802e43 <memmove+0x9a>
  802e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0c:	83 e0 03             	and    $0x3,%eax
  802e0f:	48 85 c0             	test   %rax,%rax
  802e12:	75 2f                	jne    802e43 <memmove+0x9a>
  802e14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e18:	83 e0 03             	and    $0x3,%eax
  802e1b:	48 85 c0             	test   %rax,%rax
  802e1e:	75 23                	jne    802e43 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802e20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e24:	48 83 e8 04          	sub    $0x4,%rax
  802e28:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e2c:	48 83 ea 04          	sub    $0x4,%rdx
  802e30:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802e34:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802e38:	48 89 c7             	mov    %rax,%rdi
  802e3b:	48 89 d6             	mov    %rdx,%rsi
  802e3e:	fd                   	std    
  802e3f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802e41:	eb 1d                	jmp    802e60 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e47:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802e53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e57:	48 89 d7             	mov    %rdx,%rdi
  802e5a:	48 89 c1             	mov    %rax,%rcx
  802e5d:	fd                   	std    
  802e5e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802e60:	fc                   	cld    
  802e61:	eb 57                	jmp    802eba <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e67:	83 e0 03             	and    $0x3,%eax
  802e6a:	48 85 c0             	test   %rax,%rax
  802e6d:	75 36                	jne    802ea5 <memmove+0xfc>
  802e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e73:	83 e0 03             	and    $0x3,%eax
  802e76:	48 85 c0             	test   %rax,%rax
  802e79:	75 2a                	jne    802ea5 <memmove+0xfc>
  802e7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e7f:	83 e0 03             	and    $0x3,%eax
  802e82:	48 85 c0             	test   %rax,%rax
  802e85:	75 1e                	jne    802ea5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802e87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e8b:	48 c1 e8 02          	shr    $0x2,%rax
  802e8f:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e9a:	48 89 c7             	mov    %rax,%rdi
  802e9d:	48 89 d6             	mov    %rdx,%rsi
  802ea0:	fc                   	cld    
  802ea1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802ea3:	eb 15                	jmp    802eba <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ead:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802eb1:	48 89 c7             	mov    %rax,%rdi
  802eb4:	48 89 d6             	mov    %rdx,%rsi
  802eb7:	fc                   	cld    
  802eb8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802ebe:	c9                   	leaveq 
  802ebf:	c3                   	retq   

0000000000802ec0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802ec0:	55                   	push   %rbp
  802ec1:	48 89 e5             	mov    %rsp,%rbp
  802ec4:	48 83 ec 18          	sub    $0x18,%rsp
  802ec8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ecc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ed0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802ed4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ed8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee0:	48 89 ce             	mov    %rcx,%rsi
  802ee3:	48 89 c7             	mov    %rax,%rdi
  802ee6:	48 b8 a9 2d 80 00 00 	movabs $0x802da9,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
}
  802ef2:	c9                   	leaveq 
  802ef3:	c3                   	retq   

0000000000802ef4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802ef4:	55                   	push   %rbp
  802ef5:	48 89 e5             	mov    %rsp,%rbp
  802ef8:	48 83 ec 28          	sub    $0x28,%rsp
  802efc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802f10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802f18:	eb 36                	jmp    802f50 <memcmp+0x5c>
		if (*s1 != *s2)
  802f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1e:	0f b6 10             	movzbl (%rax),%edx
  802f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f25:	0f b6 00             	movzbl (%rax),%eax
  802f28:	38 c2                	cmp    %al,%dl
  802f2a:	74 1a                	je     802f46 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f30:	0f b6 00             	movzbl (%rax),%eax
  802f33:	0f b6 d0             	movzbl %al,%edx
  802f36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3a:	0f b6 00             	movzbl (%rax),%eax
  802f3d:	0f b6 c0             	movzbl %al,%eax
  802f40:	29 c2                	sub    %eax,%edx
  802f42:	89 d0                	mov    %edx,%eax
  802f44:	eb 20                	jmp    802f66 <memcmp+0x72>
		s1++, s2++;
  802f46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f4b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f54:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802f5c:	48 85 c0             	test   %rax,%rax
  802f5f:	75 b9                	jne    802f1a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f66:	c9                   	leaveq 
  802f67:	c3                   	retq   

0000000000802f68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802f68:	55                   	push   %rbp
  802f69:	48 89 e5             	mov    %rsp,%rbp
  802f6c:	48 83 ec 28          	sub    $0x28,%rsp
  802f70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f74:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802f77:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802f7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f83:	48 01 d0             	add    %rdx,%rax
  802f86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802f8a:	eb 15                	jmp    802fa1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f90:	0f b6 10             	movzbl (%rax),%edx
  802f93:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f96:	38 c2                	cmp    %al,%dl
  802f98:	75 02                	jne    802f9c <memfind+0x34>
			break;
  802f9a:	eb 0f                	jmp    802fab <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802f9c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802fa9:	72 e1                	jb     802f8c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802faf:	c9                   	leaveq 
  802fb0:	c3                   	retq   

0000000000802fb1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802fb1:	55                   	push   %rbp
  802fb2:	48 89 e5             	mov    %rsp,%rbp
  802fb5:	48 83 ec 34          	sub    $0x34,%rsp
  802fb9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fbd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fc1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802fcb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802fd2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802fd3:	eb 05                	jmp    802fda <strtol+0x29>
		s++;
  802fd5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802fda:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fde:	0f b6 00             	movzbl (%rax),%eax
  802fe1:	3c 20                	cmp    $0x20,%al
  802fe3:	74 f0                	je     802fd5 <strtol+0x24>
  802fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe9:	0f b6 00             	movzbl (%rax),%eax
  802fec:	3c 09                	cmp    $0x9,%al
  802fee:	74 e5                	je     802fd5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff4:	0f b6 00             	movzbl (%rax),%eax
  802ff7:	3c 2b                	cmp    $0x2b,%al
  802ff9:	75 07                	jne    803002 <strtol+0x51>
		s++;
  802ffb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803000:	eb 17                	jmp    803019 <strtol+0x68>
	else if (*s == '-')
  803002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803006:	0f b6 00             	movzbl (%rax),%eax
  803009:	3c 2d                	cmp    $0x2d,%al
  80300b:	75 0c                	jne    803019 <strtol+0x68>
		s++, neg = 1;
  80300d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803012:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803019:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80301d:	74 06                	je     803025 <strtol+0x74>
  80301f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803023:	75 28                	jne    80304d <strtol+0x9c>
  803025:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803029:	0f b6 00             	movzbl (%rax),%eax
  80302c:	3c 30                	cmp    $0x30,%al
  80302e:	75 1d                	jne    80304d <strtol+0x9c>
  803030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803034:	48 83 c0 01          	add    $0x1,%rax
  803038:	0f b6 00             	movzbl (%rax),%eax
  80303b:	3c 78                	cmp    $0x78,%al
  80303d:	75 0e                	jne    80304d <strtol+0x9c>
		s += 2, base = 16;
  80303f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803044:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80304b:	eb 2c                	jmp    803079 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80304d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803051:	75 19                	jne    80306c <strtol+0xbb>
  803053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803057:	0f b6 00             	movzbl (%rax),%eax
  80305a:	3c 30                	cmp    $0x30,%al
  80305c:	75 0e                	jne    80306c <strtol+0xbb>
		s++, base = 8;
  80305e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803063:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80306a:	eb 0d                	jmp    803079 <strtol+0xc8>
	else if (base == 0)
  80306c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803070:	75 07                	jne    803079 <strtol+0xc8>
		base = 10;
  803072:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307d:	0f b6 00             	movzbl (%rax),%eax
  803080:	3c 2f                	cmp    $0x2f,%al
  803082:	7e 1d                	jle    8030a1 <strtol+0xf0>
  803084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803088:	0f b6 00             	movzbl (%rax),%eax
  80308b:	3c 39                	cmp    $0x39,%al
  80308d:	7f 12                	jg     8030a1 <strtol+0xf0>
			dig = *s - '0';
  80308f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803093:	0f b6 00             	movzbl (%rax),%eax
  803096:	0f be c0             	movsbl %al,%eax
  803099:	83 e8 30             	sub    $0x30,%eax
  80309c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80309f:	eb 4e                	jmp    8030ef <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8030a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a5:	0f b6 00             	movzbl (%rax),%eax
  8030a8:	3c 60                	cmp    $0x60,%al
  8030aa:	7e 1d                	jle    8030c9 <strtol+0x118>
  8030ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b0:	0f b6 00             	movzbl (%rax),%eax
  8030b3:	3c 7a                	cmp    $0x7a,%al
  8030b5:	7f 12                	jg     8030c9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8030b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bb:	0f b6 00             	movzbl (%rax),%eax
  8030be:	0f be c0             	movsbl %al,%eax
  8030c1:	83 e8 57             	sub    $0x57,%eax
  8030c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030c7:	eb 26                	jmp    8030ef <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8030c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cd:	0f b6 00             	movzbl (%rax),%eax
  8030d0:	3c 40                	cmp    $0x40,%al
  8030d2:	7e 48                	jle    80311c <strtol+0x16b>
  8030d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d8:	0f b6 00             	movzbl (%rax),%eax
  8030db:	3c 5a                	cmp    $0x5a,%al
  8030dd:	7f 3d                	jg     80311c <strtol+0x16b>
			dig = *s - 'A' + 10;
  8030df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e3:	0f b6 00             	movzbl (%rax),%eax
  8030e6:	0f be c0             	movsbl %al,%eax
  8030e9:	83 e8 37             	sub    $0x37,%eax
  8030ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8030ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8030f5:	7c 02                	jl     8030f9 <strtol+0x148>
			break;
  8030f7:	eb 23                	jmp    80311c <strtol+0x16b>
		s++, val = (val * base) + dig;
  8030f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030fe:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803101:	48 98                	cltq   
  803103:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803108:	48 89 c2             	mov    %rax,%rdx
  80310b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80310e:	48 98                	cltq   
  803110:	48 01 d0             	add    %rdx,%rax
  803113:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803117:	e9 5d ff ff ff       	jmpq   803079 <strtol+0xc8>

	if (endptr)
  80311c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803121:	74 0b                	je     80312e <strtol+0x17d>
		*endptr = (char *) s;
  803123:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803127:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80312b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80312e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803132:	74 09                	je     80313d <strtol+0x18c>
  803134:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803138:	48 f7 d8             	neg    %rax
  80313b:	eb 04                	jmp    803141 <strtol+0x190>
  80313d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803141:	c9                   	leaveq 
  803142:	c3                   	retq   

0000000000803143 <strstr>:

char * strstr(const char *in, const char *str)
{
  803143:	55                   	push   %rbp
  803144:	48 89 e5             	mov    %rsp,%rbp
  803147:	48 83 ec 30          	sub    $0x30,%rsp
  80314b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  803153:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803157:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80315b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80315f:	0f b6 00             	movzbl (%rax),%eax
  803162:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  803165:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803169:	75 06                	jne    803171 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80316b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316f:	eb 6b                	jmp    8031dc <strstr+0x99>

    len = strlen(str);
  803171:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803175:	48 89 c7             	mov    %rax,%rdi
  803178:	48 b8 19 2a 80 00 00 	movabs $0x802a19,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
  803184:	48 98                	cltq   
  803186:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80318a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803192:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803196:	0f b6 00             	movzbl (%rax),%eax
  803199:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80319c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8031a0:	75 07                	jne    8031a9 <strstr+0x66>
                return (char *) 0;
  8031a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a7:	eb 33                	jmp    8031dc <strstr+0x99>
        } while (sc != c);
  8031a9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8031ad:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8031b0:	75 d8                	jne    80318a <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8031b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031b6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8031ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031be:	48 89 ce             	mov    %rcx,%rsi
  8031c1:	48 89 c7             	mov    %rax,%rdi
  8031c4:	48 b8 3a 2c 80 00 00 	movabs $0x802c3a,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	75 b6                	jne    80318a <strstr+0x47>

    return (char *) (in - 1);
  8031d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d8:	48 83 e8 01          	sub    $0x1,%rax
}
  8031dc:	c9                   	leaveq 
  8031dd:	c3                   	retq   

00000000008031de <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8031de:	55                   	push   %rbp
  8031df:	48 89 e5             	mov    %rsp,%rbp
  8031e2:	48 83 ec 10          	sub    $0x10,%rsp
  8031e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8031ea:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8031f1:	00 00 00 
  8031f4:	48 8b 00             	mov    (%rax),%rax
  8031f7:	48 85 c0             	test   %rax,%rax
  8031fa:	0f 85 84 00 00 00    	jne    803284 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803200:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803207:	00 00 00 
  80320a:	48 8b 00             	mov    (%rax),%rax
  80320d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803213:	ba 07 00 00 00       	mov    $0x7,%edx
  803218:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80321d:	89 c7                	mov    %eax,%edi
  80321f:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  803226:	00 00 00 
  803229:	ff d0                	callq  *%rax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	79 2a                	jns    803259 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80322f:	48 ba 00 3b 80 00 00 	movabs $0x803b00,%rdx
  803236:	00 00 00 
  803239:	be 23 00 00 00       	mov    $0x23,%esi
  80323e:	48 bf 27 3b 80 00 00 	movabs $0x803b27,%rdi
  803245:	00 00 00 
  803248:	b8 00 00 00 00       	mov    $0x0,%eax
  80324d:	48 b9 97 1c 80 00 00 	movabs $0x801c97,%rcx
  803254:	00 00 00 
  803257:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803259:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803260:	00 00 00 
  803263:	48 8b 00             	mov    (%rax),%rax
  803266:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80326c:	48 be 6b 05 80 00 00 	movabs $0x80056b,%rsi
  803273:	00 00 00 
  803276:	89 c7                	mov    %eax,%edi
  803278:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803284:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80328b:	00 00 00 
  80328e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803292:	48 89 10             	mov    %rdx,(%rax)
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 30          	sub    $0x30,%rsp
  80329f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8032ab:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032b2:	00 00 00 
  8032b5:	48 8b 00             	mov    (%rax),%rax
  8032b8:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	75 3c                	jne    8032fe <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8032c2:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
  8032ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8032d3:	48 63 d0             	movslq %eax,%rdx
  8032d6:	48 89 d0             	mov    %rdx,%rax
  8032d9:	48 c1 e0 03          	shl    $0x3,%rax
  8032dd:	48 01 d0             	add    %rdx,%rax
  8032e0:	48 c1 e0 05          	shl    $0x5,%rax
  8032e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8032eb:	00 00 00 
  8032ee:	48 01 c2             	add    %rax,%rdx
  8032f1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032f8:	00 00 00 
  8032fb:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8032fe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803303:	75 0e                	jne    803313 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803305:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80330c:	00 00 00 
  80330f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803317:	48 89 c7             	mov    %rax,%rdi
  80331a:	48 b8 27 05 80 00 00 	movabs $0x800527,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332d:	79 19                	jns    803348 <ipc_recv+0xb1>
		*from_env_store = 0;
  80332f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803339:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80333d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803346:	eb 53                	jmp    80339b <ipc_recv+0x104>
	}
	if(from_env_store)
  803348:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80334d:	74 19                	je     803368 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80334f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803356:	00 00 00 
  803359:	48 8b 00             	mov    (%rax),%rax
  80335c:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803366:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803368:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80336d:	74 19                	je     803388 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80336f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803376:	00 00 00 
  803379:	48 8b 00             	mov    (%rax),%rax
  80337c:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803386:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803388:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80338f:	00 00 00 
  803392:	48 8b 00             	mov    (%rax),%rax
  803395:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 30          	sub    $0x30,%rsp
  8033a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033a8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033ab:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8033af:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8033b2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033b7:	75 0e                	jne    8033c7 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8033b9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8033c0:	00 00 00 
  8033c3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8033c7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033ca:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d4:	89 c7                	mov    %eax,%edi
  8033d6:	48 b8 d2 04 80 00 00 	movabs $0x8004d2,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8033e5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8033e9:	75 0c                	jne    8033f7 <ipc_send+0x5a>
			sys_yield();
  8033eb:	48 b8 c0 02 80 00 00 	movabs $0x8002c0,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8033f7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8033fb:	74 ca                	je     8033c7 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8033fd:	c9                   	leaveq 
  8033fe:	c3                   	retq   

00000000008033ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8033ff:	55                   	push   %rbp
  803400:	48 89 e5             	mov    %rsp,%rbp
  803403:	48 83 ec 14          	sub    $0x14,%rsp
  803407:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80340a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803411:	eb 5e                	jmp    803471 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803413:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80341a:	00 00 00 
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803420:	48 63 d0             	movslq %eax,%rdx
  803423:	48 89 d0             	mov    %rdx,%rax
  803426:	48 c1 e0 03          	shl    $0x3,%rax
  80342a:	48 01 d0             	add    %rdx,%rax
  80342d:	48 c1 e0 05          	shl    $0x5,%rax
  803431:	48 01 c8             	add    %rcx,%rax
  803434:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80343a:	8b 00                	mov    (%rax),%eax
  80343c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80343f:	75 2c                	jne    80346d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803441:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803448:	00 00 00 
  80344b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344e:	48 63 d0             	movslq %eax,%rdx
  803451:	48 89 d0             	mov    %rdx,%rax
  803454:	48 c1 e0 03          	shl    $0x3,%rax
  803458:	48 01 d0             	add    %rdx,%rax
  80345b:	48 c1 e0 05          	shl    $0x5,%rax
  80345f:	48 01 c8             	add    %rcx,%rax
  803462:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803468:	8b 40 08             	mov    0x8(%rax),%eax
  80346b:	eb 12                	jmp    80347f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80346d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803471:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803478:	7e 99                	jle    803413 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80347a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80347f:	c9                   	leaveq 
  803480:	c3                   	retq   

0000000000803481 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	48 83 ec 18          	sub    $0x18,%rsp
  803489:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80348d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803491:	48 c1 e8 15          	shr    $0x15,%rax
  803495:	48 89 c2             	mov    %rax,%rdx
  803498:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80349f:	01 00 00 
  8034a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034a6:	83 e0 01             	and    $0x1,%eax
  8034a9:	48 85 c0             	test   %rax,%rax
  8034ac:	75 07                	jne    8034b5 <pageref+0x34>
		return 0;
  8034ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b3:	eb 53                	jmp    803508 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8034bd:	48 89 c2             	mov    %rax,%rdx
  8034c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034c7:	01 00 00 
  8034ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d6:	83 e0 01             	and    $0x1,%eax
  8034d9:	48 85 c0             	test   %rax,%rax
  8034dc:	75 07                	jne    8034e5 <pageref+0x64>
		return 0;
  8034de:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e3:	eb 23                	jmp    803508 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e9:	48 c1 e8 0c          	shr    $0xc,%rax
  8034ed:	48 89 c2             	mov    %rax,%rdx
  8034f0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034f7:	00 00 00 
  8034fa:	48 c1 e2 04          	shl    $0x4,%rdx
  8034fe:	48 01 d0             	add    %rdx,%rax
  803501:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803505:	0f b7 c0             	movzwl %ax,%eax
}
  803508:	c9                   	leaveq 
  803509:	c3                   	retq   
