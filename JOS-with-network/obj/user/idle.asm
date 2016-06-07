
obj/user/idle.debug:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800059:	00 00 00 
  80005c:	48 ba 80 3e 80 00 00 	movabs $0x803e80,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	25 ff 03 00 00       	and    $0x3ff,%eax
  800097:	48 63 d0             	movslq %eax,%rdx
  80009a:	48 89 d0             	mov    %rdx,%rax
  80009d:	48 c1 e0 03          	shl    $0x3,%rax
  8000a1:	48 01 d0             	add    %rdx,%rax
  8000a4:	48 c1 e0 05          	shl    $0x5,%rax
  8000a8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000af:	00 00 00 
  8000b2:	48 01 c2             	add    %rax,%rdx
  8000b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000bc:	00 00 00 
  8000bf:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c6:	7e 14                	jle    8000dc <libmain+0x65>
		binaryname = argv[0];
  8000c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cc:	48 8b 10             	mov    (%rax),%rdx
  8000cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e3:	48 89 d6             	mov    %rdx,%rsi
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8000f4:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800106:	48 b8 73 09 80 00 00 	movabs $0x800973,%rax
  80010d:	00 00 00 
  800110:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800112:	bf 00 00 00 00       	mov    $0x0,%edi
  800117:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  80011e:	00 00 00 
  800121:	ff d0                	callq  *%rax

}
  800123:	5d                   	pop    %rbp
  800124:	c3                   	retq   

0000000000800125 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800125:	55                   	push   %rbp
  800126:	48 89 e5             	mov    %rsp,%rbp
  800129:	53                   	push   %rbx
  80012a:	48 83 ec 48          	sub    $0x48,%rsp
  80012e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800131:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800134:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800138:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80013c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800140:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800144:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800147:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80014b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80014f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800153:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800157:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80015b:	4c 89 c3             	mov    %r8,%rbx
  80015e:	cd 30                	int    $0x30
  800160:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800164:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800168:	74 3e                	je     8001a8 <syscall+0x83>
  80016a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80016f:	7e 37                	jle    8001a8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800175:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800178:	49 89 d0             	mov    %rdx,%r8
  80017b:	89 c1                	mov    %eax,%ecx
  80017d:	48 ba 8f 3e 80 00 00 	movabs $0x803e8f,%rdx
  800184:	00 00 00 
  800187:	be 23 00 00 00       	mov    $0x23,%esi
  80018c:	48 bf ac 3e 80 00 00 	movabs $0x803eac,%rdi
  800193:	00 00 00 
  800196:	b8 00 00 00 00       	mov    $0x0,%eax
  80019b:	49 b9 be 26 80 00 00 	movabs $0x8026be,%r9
  8001a2:	00 00 00 
  8001a5:	41 ff d1             	callq  *%r9

	return ret;
  8001a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001ac:	48 83 c4 48          	add    $0x48,%rsp
  8001b0:	5b                   	pop    %rbx
  8001b1:	5d                   	pop    %rbp
  8001b2:	c3                   	retq   

00000000008001b3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b3:	55                   	push   %rbp
  8001b4:	48 89 e5             	mov    %rsp,%rbp
  8001b7:	48 83 ec 20          	sub    $0x20,%rsp
  8001bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d2:	00 
  8001d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001df:	48 89 d1             	mov    %rdx,%rcx
  8001e2:	48 89 c2             	mov    %rax,%rdx
  8001e5:	be 00 00 00 00       	mov    $0x0,%esi
  8001ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ef:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8001f6:	00 00 00 
  8001f9:	ff d0                	callq  *%rax
}
  8001fb:	c9                   	leaveq 
  8001fc:	c3                   	retq   

00000000008001fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fd:	55                   	push   %rbp
  8001fe:	48 89 e5             	mov    %rsp,%rbp
  800201:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800205:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80020c:	00 
  80020d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800213:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	be 00 00 00 00       	mov    $0x0,%esi
  800228:	bf 01 00 00 00       	mov    $0x1,%edi
  80022d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 83 ec 10          	sub    $0x10,%rsp
  800243:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800249:	48 98                	cltq   
  80024b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800252:	00 
  800253:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800259:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80025f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800264:	48 89 c2             	mov    %rax,%rdx
  800267:	be 01 00 00 00       	mov    $0x1,%esi
  80026c:	bf 03 00 00 00       	mov    $0x3,%edi
  800271:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
}
  80027d:	c9                   	leaveq 
  80027e:	c3                   	retq   

000000000080027f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027f:	55                   	push   %rbp
  800280:	48 89 e5             	mov    %rsp,%rbp
  800283:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800287:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80028e:	00 
  80028f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80029b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a5:	be 00 00 00 00       	mov    $0x0,%esi
  8002aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8002af:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002b6:	00 00 00 
  8002b9:	ff d0                	callq  *%rax
}
  8002bb:	c9                   	leaveq 
  8002bc:	c3                   	retq   

00000000008002bd <sys_yield>:

void
sys_yield(void)
{
  8002bd:	55                   	push   %rbp
  8002be:	48 89 e5             	mov    %rsp,%rbp
  8002c1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002cc:	00 
  8002cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002de:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e3:	be 00 00 00 00       	mov    $0x0,%esi
  8002e8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002ed:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8002f4:	00 00 00 
  8002f7:	ff d0                	callq  *%rax
}
  8002f9:	c9                   	leaveq 
  8002fa:	c3                   	retq   

00000000008002fb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002fb:	55                   	push   %rbp
  8002fc:	48 89 e5             	mov    %rsp,%rbp
  8002ff:	48 83 ec 20          	sub    $0x20,%rsp
  800303:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800306:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80030d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800310:	48 63 c8             	movslq %eax,%rcx
  800313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031a:	48 98                	cltq   
  80031c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800323:	00 
  800324:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032a:	49 89 c8             	mov    %rcx,%r8
  80032d:	48 89 d1             	mov    %rdx,%rcx
  800330:	48 89 c2             	mov    %rax,%rdx
  800333:	be 01 00 00 00       	mov    $0x1,%esi
  800338:	bf 04 00 00 00       	mov    $0x4,%edi
  80033d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
}
  800349:	c9                   	leaveq 
  80034a:	c3                   	retq   

000000000080034b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80034b:	55                   	push   %rbp
  80034c:	48 89 e5             	mov    %rsp,%rbp
  80034f:	48 83 ec 30          	sub    $0x30,%rsp
  800353:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800356:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80035d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800361:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800365:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800368:	48 63 c8             	movslq %eax,%rcx
  80036b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800372:	48 63 f0             	movslq %eax,%rsi
  800375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037c:	48 98                	cltq   
  80037e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800382:	49 89 f9             	mov    %rdi,%r9
  800385:	49 89 f0             	mov    %rsi,%r8
  800388:	48 89 d1             	mov    %rdx,%rcx
  80038b:	48 89 c2             	mov    %rax,%rdx
  80038e:	be 01 00 00 00       	mov    $0x1,%esi
  800393:	bf 05 00 00 00       	mov    $0x5,%edi
  800398:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
}
  8003a4:	c9                   	leaveq 
  8003a5:	c3                   	retq   

00000000008003a6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a6:	55                   	push   %rbp
  8003a7:	48 89 e5             	mov    %rsp,%rbp
  8003aa:	48 83 ec 20          	sub    $0x20,%rsp
  8003ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bc:	48 98                	cltq   
  8003be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003c5:	00 
  8003c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d2:	48 89 d1             	mov    %rdx,%rcx
  8003d5:	48 89 c2             	mov    %rax,%rdx
  8003d8:	be 01 00 00 00       	mov    $0x1,%esi
  8003dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e2:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
}
  8003ee:	c9                   	leaveq 
  8003ef:	c3                   	retq   

00000000008003f0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 10          	sub    $0x10,%rsp
  8003f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800401:	48 63 d0             	movslq %eax,%rdx
  800404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800407:	48 98                	cltq   
  800409:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800410:	00 
  800411:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800417:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041d:	48 89 d1             	mov    %rdx,%rcx
  800420:	48 89 c2             	mov    %rax,%rdx
  800423:	be 01 00 00 00       	mov    $0x1,%esi
  800428:	bf 08 00 00 00       	mov    $0x8,%edi
  80042d:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800434:	00 00 00 
  800437:	ff d0                	callq  *%rax
}
  800439:	c9                   	leaveq 
  80043a:	c3                   	retq   

000000000080043b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	48 83 ec 20          	sub    $0x20,%rsp
  800443:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800451:	48 98                	cltq   
  800453:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045a:	00 
  80045b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800467:	48 89 d1             	mov    %rdx,%rcx
  80046a:	48 89 c2             	mov    %rax,%rdx
  80046d:	be 01 00 00 00       	mov    $0x1,%esi
  800472:	bf 09 00 00 00       	mov    $0x9,%edi
  800477:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
}
  800483:	c9                   	leaveq 
  800484:	c3                   	retq   

0000000000800485 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800485:	55                   	push   %rbp
  800486:	48 89 e5             	mov    %rsp,%rbp
  800489:	48 83 ec 20          	sub    $0x20,%rsp
  80048d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800494:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049b:	48 98                	cltq   
  80049d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a4:	00 
  8004a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b1:	48 89 d1             	mov    %rdx,%rcx
  8004b4:	48 89 c2             	mov    %rax,%rdx
  8004b7:	be 01 00 00 00       	mov    $0x1,%esi
  8004bc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c1:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
}
  8004cd:	c9                   	leaveq 
  8004ce:	c3                   	retq   

00000000008004cf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004cf:	55                   	push   %rbp
  8004d0:	48 89 e5             	mov    %rsp,%rbp
  8004d3:	48 83 ec 20          	sub    $0x20,%rsp
  8004d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004e8:	48 63 f0             	movslq %eax,%rsi
  8004eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f2:	48 98                	cltq   
  8004f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ff:	00 
  800500:	49 89 f1             	mov    %rsi,%r9
  800503:	49 89 c8             	mov    %rcx,%r8
  800506:	48 89 d1             	mov    %rdx,%rcx
  800509:	48 89 c2             	mov    %rax,%rdx
  80050c:	be 00 00 00 00       	mov    $0x0,%esi
  800511:	bf 0c 00 00 00       	mov    $0xc,%edi
  800516:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
}
  800522:	c9                   	leaveq 
  800523:	c3                   	retq   

0000000000800524 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800534:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80053b:	00 
  80053c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800542:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800548:	b9 00 00 00 00       	mov    $0x0,%ecx
  80054d:	48 89 c2             	mov    %rax,%rdx
  800550:	be 01 00 00 00       	mov    $0x1,%esi
  800555:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055a:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  800561:	00 00 00 
  800564:	ff d0                	callq  *%rax
}
  800566:	c9                   	leaveq 
  800567:	c3                   	retq   

0000000000800568 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800568:	55                   	push   %rbp
  800569:	48 89 e5             	mov    %rsp,%rbp
  80056c:	48 83 ec 20          	sub    $0x20,%rsp
  800570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800574:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  800578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80057c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800580:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800587:	00 
  800588:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80058e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800594:	b9 00 00 00 00       	mov    $0x0,%ecx
  800599:	89 c6                	mov    %eax,%esi
  80059b:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005a0:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 20          	sub    $0x20,%rsp
  8005b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8005be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005cd:	00 
  8005ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005df:	89 c6                	mov    %eax,%esi
  8005e1:	bf 10 00 00 00       	mov    $0x10,%edi
  8005e6:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	callq  *%rax
}
  8005f2:	c9                   	leaveq 
  8005f3:	c3                   	retq   

00000000008005f4 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8005f4:	55                   	push   %rbp
  8005f5:	48 89 e5             	mov    %rsp,%rbp
  8005f8:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8005fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800603:	00 
  800604:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80060a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800610:	b9 00 00 00 00       	mov    $0x0,%ecx
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	be 00 00 00 00       	mov    $0x0,%esi
  80061f:	bf 0e 00 00 00       	mov    $0xe,%edi
  800624:	48 b8 25 01 80 00 00 	movabs $0x800125,%rax
  80062b:	00 00 00 
  80062e:	ff d0                	callq  *%rax
}
  800630:	c9                   	leaveq 
  800631:	c3                   	retq   

0000000000800632 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800632:	55                   	push   %rbp
  800633:	48 89 e5             	mov    %rsp,%rbp
  800636:	48 83 ec 08          	sub    $0x8,%rsp
  80063a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80063e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800642:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800649:	ff ff ff 
  80064c:	48 01 d0             	add    %rdx,%rax
  80064f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800653:	c9                   	leaveq 
  800654:	c3                   	retq   

0000000000800655 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800655:	55                   	push   %rbp
  800656:	48 89 e5             	mov    %rsp,%rbp
  800659:	48 83 ec 08          	sub    $0x8,%rsp
  80065d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800665:	48 89 c7             	mov    %rax,%rdi
  800668:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  80066f:	00 00 00 
  800672:	ff d0                	callq  *%rax
  800674:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80067a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80067e:	c9                   	leaveq 
  80067f:	c3                   	retq   

0000000000800680 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
  800684:	48 83 ec 18          	sub    $0x18,%rsp
  800688:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80068c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800693:	eb 6b                	jmp    800700 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800698:	48 98                	cltq   
  80069a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006a0:	48 c1 e0 0c          	shl    $0xc,%rax
  8006a4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ac:	48 c1 e8 15          	shr    $0x15,%rax
  8006b0:	48 89 c2             	mov    %rax,%rdx
  8006b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006ba:	01 00 00 
  8006bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c1:	83 e0 01             	and    $0x1,%eax
  8006c4:	48 85 c0             	test   %rax,%rax
  8006c7:	74 21                	je     8006ea <fd_alloc+0x6a>
  8006c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8006d1:	48 89 c2             	mov    %rax,%rdx
  8006d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006db:	01 00 00 
  8006de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006e2:	83 e0 01             	and    $0x1,%eax
  8006e5:	48 85 c0             	test   %rax,%rax
  8006e8:	75 12                	jne    8006fc <fd_alloc+0x7c>
			*fd_store = fd;
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	eb 1a                	jmp    800716 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800700:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800704:	7e 8f                	jle    800695 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800711:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800716:	c9                   	leaveq 
  800717:	c3                   	retq   

0000000000800718 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800718:	55                   	push   %rbp
  800719:	48 89 e5             	mov    %rsp,%rbp
  80071c:	48 83 ec 20          	sub    $0x20,%rsp
  800720:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800723:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800727:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80072b:	78 06                	js     800733 <fd_lookup+0x1b>
  80072d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800731:	7e 07                	jle    80073a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800733:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800738:	eb 6c                	jmp    8007a6 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80073a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80073d:	48 98                	cltq   
  80073f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800745:	48 c1 e0 0c          	shl    $0xc,%rax
  800749:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80074d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800751:	48 c1 e8 15          	shr    $0x15,%rax
  800755:	48 89 c2             	mov    %rax,%rdx
  800758:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80075f:	01 00 00 
  800762:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800766:	83 e0 01             	and    $0x1,%eax
  800769:	48 85 c0             	test   %rax,%rax
  80076c:	74 21                	je     80078f <fd_lookup+0x77>
  80076e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800772:	48 c1 e8 0c          	shr    $0xc,%rax
  800776:	48 89 c2             	mov    %rax,%rdx
  800779:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800780:	01 00 00 
  800783:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800787:	83 e0 01             	and    $0x1,%eax
  80078a:	48 85 c0             	test   %rax,%rax
  80078d:	75 07                	jne    800796 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80078f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800794:	eb 10                	jmp    8007a6 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800796:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80079a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80079e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007a6:	c9                   	leaveq 
  8007a7:	c3                   	retq   

00000000008007a8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007a8:	55                   	push   %rbp
  8007a9:	48 89 e5             	mov    %rsp,%rbp
  8007ac:	48 83 ec 30          	sub    $0x30,%rsp
  8007b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007b4:	89 f0                	mov    %esi,%eax
  8007b6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007bd:	48 89 c7             	mov    %rax,%rdi
  8007c0:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  8007c7:	00 00 00 
  8007ca:	ff d0                	callq  *%rax
  8007cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8007d0:	48 89 d6             	mov    %rdx,%rsi
  8007d3:	89 c7                	mov    %eax,%edi
  8007d5:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  8007dc:	00 00 00 
  8007df:	ff d0                	callq  *%rax
  8007e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007e8:	78 0a                	js     8007f4 <fd_close+0x4c>
	    || fd != fd2)
  8007ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007ee:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007f2:	74 12                	je     800806 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007f4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007f8:	74 05                	je     8007ff <fd_close+0x57>
  8007fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007fd:	eb 05                	jmp    800804 <fd_close+0x5c>
  8007ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800804:	eb 69                	jmp    80086f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800810:	48 89 d6             	mov    %rdx,%rsi
  800813:	89 c7                	mov    %eax,%edi
  800815:	48 b8 71 08 80 00 00 	movabs $0x800871,%rax
  80081c:	00 00 00 
  80081f:	ff d0                	callq  *%rax
  800821:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800828:	78 2a                	js     800854 <fd_close+0xac>
		if (dev->dev_close)
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	48 8b 40 20          	mov    0x20(%rax),%rax
  800832:	48 85 c0             	test   %rax,%rax
  800835:	74 16                	je     80084d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80083f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800843:	48 89 d7             	mov    %rdx,%rdi
  800846:	ff d0                	callq  *%rax
  800848:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80084b:	eb 07                	jmp    800854 <fd_close+0xac>
		else
			r = 0;
  80084d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800858:	48 89 c6             	mov    %rax,%rsi
  80085b:	bf 00 00 00 00       	mov    $0x0,%edi
  800860:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800867:	00 00 00 
  80086a:	ff d0                	callq  *%rax
	return r;
  80086c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80086f:	c9                   	leaveq 
  800870:	c3                   	retq   

0000000000800871 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800871:	55                   	push   %rbp
  800872:	48 89 e5             	mov    %rsp,%rbp
  800875:	48 83 ec 20          	sub    $0x20,%rsp
  800879:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80087c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800880:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800887:	eb 41                	jmp    8008ca <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800889:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800890:	00 00 00 
  800893:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800896:	48 63 d2             	movslq %edx,%rdx
  800899:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80089d:	8b 00                	mov    (%rax),%eax
  80089f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008a2:	75 22                	jne    8008c6 <dev_lookup+0x55>
			*dev = devtab[i];
  8008a4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008ab:	00 00 00 
  8008ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008b1:	48 63 d2             	movslq %edx,%rdx
  8008b4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008bc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	eb 60                	jmp    800926 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008ca:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008d1:	00 00 00 
  8008d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008d7:	48 63 d2             	movslq %edx,%rdx
  8008da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008de:	48 85 c0             	test   %rax,%rax
  8008e1:	75 a6                	jne    800889 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008e3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8008ea:	00 00 00 
  8008ed:	48 8b 00             	mov    (%rax),%rax
  8008f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008f6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008f9:	89 c6                	mov    %eax,%esi
  8008fb:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  800902:	00 00 00 
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	48 b9 f7 28 80 00 00 	movabs $0x8028f7,%rcx
  800911:	00 00 00 
  800914:	ff d1                	callq  *%rcx
	*dev = 0;
  800916:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80091a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800921:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800926:	c9                   	leaveq 
  800927:	c3                   	retq   

0000000000800928 <close>:

int
close(int fdnum)
{
  800928:	55                   	push   %rbp
  800929:	48 89 e5             	mov    %rsp,%rbp
  80092c:	48 83 ec 20          	sub    $0x20,%rsp
  800930:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800933:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800937:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80093a:	48 89 d6             	mov    %rdx,%rsi
  80093d:	89 c7                	mov    %eax,%edi
  80093f:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800946:	00 00 00 
  800949:	ff d0                	callq  *%rax
  80094b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80094e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800952:	79 05                	jns    800959 <close+0x31>
		return r;
  800954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800957:	eb 18                	jmp    800971 <close+0x49>
	else
		return fd_close(fd, 1);
  800959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80095d:	be 01 00 00 00       	mov    $0x1,%esi
  800962:	48 89 c7             	mov    %rax,%rdi
  800965:	48 b8 a8 07 80 00 00 	movabs $0x8007a8,%rax
  80096c:	00 00 00 
  80096f:	ff d0                	callq  *%rax
}
  800971:	c9                   	leaveq 
  800972:	c3                   	retq   

0000000000800973 <close_all>:

void
close_all(void)
{
  800973:	55                   	push   %rbp
  800974:	48 89 e5             	mov    %rsp,%rbp
  800977:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80097b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800982:	eb 15                	jmp    800999 <close_all+0x26>
		close(i);
  800984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800987:	89 c7                	mov    %eax,%edi
  800989:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  800990:	00 00 00 
  800993:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800995:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800999:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80099d:	7e e5                	jle    800984 <close_all+0x11>
		close(i);
}
  80099f:	c9                   	leaveq 
  8009a0:	c3                   	retq   

00000000008009a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009a1:	55                   	push   %rbp
  8009a2:	48 89 e5             	mov    %rsp,%rbp
  8009a5:	48 83 ec 40          	sub    $0x40,%rsp
  8009a9:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009ac:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009af:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009b3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009b6:	48 89 d6             	mov    %rdx,%rsi
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  8009c2:	00 00 00 
  8009c5:	ff d0                	callq  *%rax
  8009c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009ce:	79 08                	jns    8009d8 <dup+0x37>
		return r;
  8009d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009d3:	e9 70 01 00 00       	jmpq   800b48 <dup+0x1a7>
	close(newfdnum);
  8009d8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  8009e4:	00 00 00 
  8009e7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009e9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009ec:	48 98                	cltq   
  8009ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8009f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a00:	48 89 c7             	mov    %rax,%rdi
  800a03:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  800a0a:	00 00 00 
  800a0d:	ff d0                	callq  *%rax
  800a0f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a17:	48 89 c7             	mov    %rax,%rdi
  800a1a:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  800a21:	00 00 00 
  800a24:	ff d0                	callq  *%rax
  800a26:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2e:	48 c1 e8 15          	shr    $0x15,%rax
  800a32:	48 89 c2             	mov    %rax,%rdx
  800a35:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a3c:	01 00 00 
  800a3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a43:	83 e0 01             	and    $0x1,%eax
  800a46:	48 85 c0             	test   %rax,%rax
  800a49:	74 73                	je     800abe <dup+0x11d>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 c1 e8 0c          	shr    $0xc,%rax
  800a53:	48 89 c2             	mov    %rax,%rdx
  800a56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a5d:	01 00 00 
  800a60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a64:	83 e0 01             	and    $0x1,%eax
  800a67:	48 85 c0             	test   %rax,%rax
  800a6a:	74 52                	je     800abe <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	48 c1 e8 0c          	shr    $0xc,%rax
  800a74:	48 89 c2             	mov    %rax,%rdx
  800a77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a7e:	01 00 00 
  800a81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a85:	25 07 0e 00 00       	and    $0xe07,%eax
  800a8a:	89 c1                	mov    %eax,%ecx
  800a8c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a94:	41 89 c8             	mov    %ecx,%r8d
  800a97:	48 89 d1             	mov    %rdx,%rcx
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	48 89 c6             	mov    %rax,%rsi
  800aa2:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa7:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
  800ab3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aba:	79 02                	jns    800abe <dup+0x11d>
			goto err;
  800abc:	eb 57                	jmp    800b15 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ac2:	48 c1 e8 0c          	shr    $0xc,%rax
  800ac6:	48 89 c2             	mov    %rax,%rdx
  800ac9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ad0:	01 00 00 
  800ad3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800ad7:	25 07 0e 00 00       	and    $0xe07,%eax
  800adc:	89 c1                	mov    %eax,%ecx
  800ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ae2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ae6:	41 89 c8             	mov    %ecx,%r8d
  800ae9:	48 89 d1             	mov    %rdx,%rcx
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	48 89 c6             	mov    %rax,%rsi
  800af4:	bf 00 00 00 00       	mov    $0x0,%edi
  800af9:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800b00:	00 00 00 
  800b03:	ff d0                	callq  *%rax
  800b05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b0c:	79 02                	jns    800b10 <dup+0x16f>
		goto err;
  800b0e:	eb 05                	jmp    800b15 <dup+0x174>

	return newfdnum;
  800b10:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b13:	eb 33                	jmp    800b48 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b19:	48 89 c6             	mov    %rax,%rsi
  800b1c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b21:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800b28:	00 00 00 
  800b2b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b31:	48 89 c6             	mov    %rax,%rsi
  800b34:	bf 00 00 00 00       	mov    $0x0,%edi
  800b39:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800b40:	00 00 00 
  800b43:	ff d0                	callq  *%rax
	return r;
  800b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b48:	c9                   	leaveq 
  800b49:	c3                   	retq   

0000000000800b4a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b4a:	55                   	push   %rbp
  800b4b:	48 89 e5             	mov    %rsp,%rbp
  800b4e:	48 83 ec 40          	sub    $0x40,%rsp
  800b52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b55:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b59:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b5d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b64:	48 89 d6             	mov    %rdx,%rsi
  800b67:	89 c7                	mov    %eax,%edi
  800b69:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800b70:	00 00 00 
  800b73:	ff d0                	callq  *%rax
  800b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b7c:	78 24                	js     800ba2 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b82:	8b 00                	mov    (%rax),%eax
  800b84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b88:	48 89 d6             	mov    %rdx,%rsi
  800b8b:	89 c7                	mov    %eax,%edi
  800b8d:	48 b8 71 08 80 00 00 	movabs $0x800871,%rax
  800b94:	00 00 00 
  800b97:	ff d0                	callq  *%rax
  800b99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ba0:	79 05                	jns    800ba7 <read+0x5d>
		return r;
  800ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ba5:	eb 76                	jmp    800c1d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bab:	8b 40 08             	mov    0x8(%rax),%eax
  800bae:	83 e0 03             	and    $0x3,%eax
  800bb1:	83 f8 01             	cmp    $0x1,%eax
  800bb4:	75 3a                	jne    800bf0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bb6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800bbd:	00 00 00 
  800bc0:	48 8b 00             	mov    (%rax),%rax
  800bc3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800bc9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800bcc:	89 c6                	mov    %eax,%esi
  800bce:	48 bf df 3e 80 00 00 	movabs $0x803edf,%rdi
  800bd5:	00 00 00 
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	48 b9 f7 28 80 00 00 	movabs $0x8028f7,%rcx
  800be4:	00 00 00 
  800be7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800be9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bee:	eb 2d                	jmp    800c1d <read+0xd3>
	}
	if (!dev->dev_read)
  800bf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf4:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bf8:	48 85 c0             	test   %rax,%rax
  800bfb:	75 07                	jne    800c04 <read+0xba>
		return -E_NOT_SUPP;
  800bfd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c02:	eb 19                	jmp    800c1d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c08:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c14:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c18:	48 89 cf             	mov    %rcx,%rdi
  800c1b:	ff d0                	callq  *%rax
}
  800c1d:	c9                   	leaveq 
  800c1e:	c3                   	retq   

0000000000800c1f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c1f:	55                   	push   %rbp
  800c20:	48 89 e5             	mov    %rsp,%rbp
  800c23:	48 83 ec 30          	sub    $0x30,%rsp
  800c27:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c39:	eb 49                	jmp    800c84 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c3e:	48 98                	cltq   
  800c40:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c44:	48 29 c2             	sub    %rax,%rdx
  800c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4a:	48 63 c8             	movslq %eax,%rcx
  800c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c51:	48 01 c1             	add    %rax,%rcx
  800c54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c57:	48 89 ce             	mov    %rcx,%rsi
  800c5a:	89 c7                	mov    %eax,%edi
  800c5c:	48 b8 4a 0b 80 00 00 	movabs $0x800b4a,%rax
  800c63:	00 00 00 
  800c66:	ff d0                	callq  *%rax
  800c68:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c6b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c6f:	79 05                	jns    800c76 <readn+0x57>
			return m;
  800c71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c74:	eb 1c                	jmp    800c92 <readn+0x73>
		if (m == 0)
  800c76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c7a:	75 02                	jne    800c7e <readn+0x5f>
			break;
  800c7c:	eb 11                	jmp    800c8f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c87:	48 98                	cltq   
  800c89:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c8d:	72 ac                	jb     800c3b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c92:	c9                   	leaveq 
  800c93:	c3                   	retq   

0000000000800c94 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c94:	55                   	push   %rbp
  800c95:	48 89 e5             	mov    %rsp,%rbp
  800c98:	48 83 ec 40          	sub    $0x40,%rsp
  800c9c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800ca3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ca7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cae:	48 89 d6             	mov    %rdx,%rsi
  800cb1:	89 c7                	mov    %eax,%edi
  800cb3:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800cba:	00 00 00 
  800cbd:	ff d0                	callq  *%rax
  800cbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc6:	78 24                	js     800cec <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccc:	8b 00                	mov    (%rax),%eax
  800cce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cd2:	48 89 d6             	mov    %rdx,%rsi
  800cd5:	89 c7                	mov    %eax,%edi
  800cd7:	48 b8 71 08 80 00 00 	movabs $0x800871,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	callq  *%rax
  800ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cea:	79 05                	jns    800cf1 <write+0x5d>
		return r;
  800cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cef:	eb 75                	jmp    800d66 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf5:	8b 40 08             	mov    0x8(%rax),%eax
  800cf8:	83 e0 03             	and    $0x3,%eax
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	75 3a                	jne    800d39 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cff:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d06:	00 00 00 
  800d09:	48 8b 00             	mov    (%rax),%rax
  800d0c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d12:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d15:	89 c6                	mov    %eax,%esi
  800d17:	48 bf fb 3e 80 00 00 	movabs $0x803efb,%rdi
  800d1e:	00 00 00 
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	48 b9 f7 28 80 00 00 	movabs $0x8028f7,%rcx
  800d2d:	00 00 00 
  800d30:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d37:	eb 2d                	jmp    800d66 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800d39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3d:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d41:	48 85 c0             	test   %rax,%rax
  800d44:	75 07                	jne    800d4d <write+0xb9>
		return -E_NOT_SUPP;
  800d46:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d4b:	eb 19                	jmp    800d66 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d51:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d55:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d59:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d61:	48 89 cf             	mov    %rcx,%rdi
  800d64:	ff d0                	callq  *%rax
}
  800d66:	c9                   	leaveq 
  800d67:	c3                   	retq   

0000000000800d68 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d68:	55                   	push   %rbp
  800d69:	48 89 e5             	mov    %rsp,%rbp
  800d6c:	48 83 ec 18          	sub    $0x18,%rsp
  800d70:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d73:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d7d:	48 89 d6             	mov    %rdx,%rsi
  800d80:	89 c7                	mov    %eax,%edi
  800d82:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
  800d8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d95:	79 05                	jns    800d9c <seek+0x34>
		return r;
  800d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d9a:	eb 0f                	jmp    800dab <seek+0x43>
	fd->fd_offset = offset;
  800d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800da3:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dab:	c9                   	leaveq 
  800dac:	c3                   	retq   

0000000000800dad <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800dad:	55                   	push   %rbp
  800dae:	48 89 e5             	mov    %rsp,%rbp
  800db1:	48 83 ec 30          	sub    $0x30,%rsp
  800db5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800db8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dbf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc2:	48 89 d6             	mov    %rdx,%rsi
  800dc5:	89 c7                	mov    %eax,%edi
  800dc7:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
  800dd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dda:	78 24                	js     800e00 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de0:	8b 00                	mov    (%rax),%eax
  800de2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de6:	48 89 d6             	mov    %rdx,%rsi
  800de9:	89 c7                	mov    %eax,%edi
  800deb:	48 b8 71 08 80 00 00 	movabs $0x800871,%rax
  800df2:	00 00 00 
  800df5:	ff d0                	callq  *%rax
  800df7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dfe:	79 05                	jns    800e05 <ftruncate+0x58>
		return r;
  800e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e03:	eb 72                	jmp    800e77 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e09:	8b 40 08             	mov    0x8(%rax),%eax
  800e0c:	83 e0 03             	and    $0x3,%eax
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	75 3a                	jne    800e4d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e13:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800e1a:	00 00 00 
  800e1d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e20:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e26:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e29:	89 c6                	mov    %eax,%esi
  800e2b:	48 bf 18 3f 80 00 00 	movabs $0x803f18,%rdi
  800e32:	00 00 00 
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	48 b9 f7 28 80 00 00 	movabs $0x8028f7,%rcx
  800e41:	00 00 00 
  800e44:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4b:	eb 2a                	jmp    800e77 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e51:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e55:	48 85 c0             	test   %rax,%rax
  800e58:	75 07                	jne    800e61 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e5a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e5f:	eb 16                	jmp    800e77 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e70:	89 ce                	mov    %ecx,%esi
  800e72:	48 89 d7             	mov    %rdx,%rdi
  800e75:	ff d0                	callq  *%rax
}
  800e77:	c9                   	leaveq 
  800e78:	c3                   	retq   

0000000000800e79 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e79:	55                   	push   %rbp
  800e7a:	48 89 e5             	mov    %rsp,%rbp
  800e7d:	48 83 ec 30          	sub    $0x30,%rsp
  800e81:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e84:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e88:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e8c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e8f:	48 89 d6             	mov    %rdx,%rsi
  800e92:	89 c7                	mov    %eax,%edi
  800e94:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800e9b:	00 00 00 
  800e9e:	ff d0                	callq  *%rax
  800ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ea7:	78 24                	js     800ecd <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ead:	8b 00                	mov    (%rax),%eax
  800eaf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800eb3:	48 89 d6             	mov    %rdx,%rsi
  800eb6:	89 c7                	mov    %eax,%edi
  800eb8:	48 b8 71 08 80 00 00 	movabs $0x800871,%rax
  800ebf:	00 00 00 
  800ec2:	ff d0                	callq  *%rax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ecb:	79 05                	jns    800ed2 <fstat+0x59>
		return r;
  800ecd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed0:	eb 5e                	jmp    800f30 <fstat+0xb7>
	if (!dev->dev_stat)
  800ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed6:	48 8b 40 28          	mov    0x28(%rax),%rax
  800eda:	48 85 c0             	test   %rax,%rax
  800edd:	75 07                	jne    800ee6 <fstat+0x6d>
		return -E_NOT_SUPP;
  800edf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800ee4:	eb 4a                	jmp    800f30 <fstat+0xb7>
	stat->st_name[0] = 0;
  800ee6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eea:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800eed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800ef8:	00 00 00 
	stat->st_isdir = 0;
  800efb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eff:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f06:	00 00 00 
	stat->st_dev = dev;
  800f09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f11:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1c:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f24:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f28:	48 89 ce             	mov    %rcx,%rsi
  800f2b:	48 89 d7             	mov    %rdx,%rdi
  800f2e:	ff d0                	callq  *%rax
}
  800f30:	c9                   	leaveq 
  800f31:	c3                   	retq   

0000000000800f32 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f32:	55                   	push   %rbp
  800f33:	48 89 e5             	mov    %rsp,%rbp
  800f36:	48 83 ec 20          	sub    $0x20,%rsp
  800f3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f46:	be 00 00 00 00       	mov    $0x0,%esi
  800f4b:	48 89 c7             	mov    %rax,%rdi
  800f4e:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f61:	79 05                	jns    800f68 <stat+0x36>
		return fd;
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	eb 2f                	jmp    800f97 <stat+0x65>
	r = fstat(fd, stat);
  800f68:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f6f:	48 89 d6             	mov    %rdx,%rsi
  800f72:	89 c7                	mov    %eax,%edi
  800f74:	48 b8 79 0e 80 00 00 	movabs $0x800e79,%rax
  800f7b:	00 00 00 
  800f7e:	ff d0                	callq  *%rax
  800f80:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f86:	89 c7                	mov    %eax,%edi
  800f88:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
	return r;
  800f94:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f97:	c9                   	leaveq 
  800f98:	c3                   	retq   

0000000000800f99 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f99:	55                   	push   %rbp
  800f9a:	48 89 e5             	mov    %rsp,%rbp
  800f9d:	48 83 ec 10          	sub    $0x10,%rsp
  800fa1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fa8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800faf:	00 00 00 
  800fb2:	8b 00                	mov    (%rax),%eax
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	75 1d                	jne    800fd5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fb8:	bf 01 00 00 00       	mov    $0x1,%edi
  800fbd:	48 b8 6d 3d 80 00 00 	movabs $0x803d6d,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
  800fc9:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fd0:	00 00 00 
  800fd3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fd5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fdc:	00 00 00 
  800fdf:	8b 00                	mov    (%rax),%eax
  800fe1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fe4:	b9 07 00 00 00       	mov    $0x7,%ecx
  800fe9:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800ff0:	00 00 00 
  800ff3:	89 c7                	mov    %eax,%edi
  800ff5:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  800ffc:	00 00 00 
  800fff:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801005:	ba 00 00 00 00       	mov    $0x0,%edx
  80100a:	48 89 c6             	mov    %rax,%rsi
  80100d:	bf 00 00 00 00       	mov    $0x0,%edi
  801012:	48 b8 05 3c 80 00 00 	movabs $0x803c05,%rax
  801019:	00 00 00 
  80101c:	ff d0                	callq  *%rax
}
  80101e:	c9                   	leaveq 
  80101f:	c3                   	retq   

0000000000801020 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801020:	55                   	push   %rbp
  801021:	48 89 e5             	mov    %rsp,%rbp
  801024:	48 83 ec 30          	sub    $0x30,%rsp
  801028:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80102c:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80102f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  801036:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80103d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  801044:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801049:	75 08                	jne    801053 <open+0x33>
	{
		return r;
  80104b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80104e:	e9 f2 00 00 00       	jmpq   801145 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  801053:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801057:	48 89 c7             	mov    %rax,%rdi
  80105a:	48 b8 40 34 80 00 00 	movabs $0x803440,%rax
  801061:	00 00 00 
  801064:	ff d0                	callq  *%rax
  801066:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801069:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801070:	7e 0a                	jle    80107c <open+0x5c>
	{
		return -E_BAD_PATH;
  801072:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801077:	e9 c9 00 00 00       	jmpq   801145 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80107c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801083:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801084:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801088:	48 89 c7             	mov    %rax,%rdi
  80108b:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801092:	00 00 00 
  801095:	ff d0                	callq  *%rax
  801097:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80109a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80109e:	78 09                	js     8010a9 <open+0x89>
  8010a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a4:	48 85 c0             	test   %rax,%rax
  8010a7:	75 08                	jne    8010b1 <open+0x91>
		{
			return r;
  8010a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ac:	e9 94 00 00 00       	jmpq   801145 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8010b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010b5:	ba 00 04 00 00       	mov    $0x400,%edx
  8010ba:	48 89 c6             	mov    %rax,%rsi
  8010bd:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010c4:	00 00 00 
  8010c7:	48 b8 3e 35 80 00 00 	movabs $0x80353e,%rax
  8010ce:	00 00 00 
  8010d1:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8010d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010da:	00 00 00 
  8010dd:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010e0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8010e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ea:	48 89 c6             	mov    %rax,%rsi
  8010ed:	bf 01 00 00 00       	mov    $0x1,%edi
  8010f2:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	callq  *%rax
  8010fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801105:	79 2b                	jns    801132 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110b:	be 00 00 00 00       	mov    $0x0,%esi
  801110:	48 89 c7             	mov    %rax,%rdi
  801113:	48 b8 a8 07 80 00 00 	movabs $0x8007a8,%rax
  80111a:	00 00 00 
  80111d:	ff d0                	callq  *%rax
  80111f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801122:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801126:	79 05                	jns    80112d <open+0x10d>
			{
				return d;
  801128:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80112b:	eb 18                	jmp    801145 <open+0x125>
			}
			return r;
  80112d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801130:	eb 13                	jmp    801145 <open+0x125>
		}	
		return fd2num(fd_store);
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	48 89 c7             	mov    %rax,%rdi
  801139:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  801140:	00 00 00 
  801143:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801145:	c9                   	leaveq 
  801146:	c3                   	retq   

0000000000801147 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801147:	55                   	push   %rbp
  801148:	48 89 e5             	mov    %rsp,%rbp
  80114b:	48 83 ec 10          	sub    $0x10,%rsp
  80114f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801157:	8b 50 0c             	mov    0xc(%rax),%edx
  80115a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801161:	00 00 00 
  801164:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801166:	be 00 00 00 00       	mov    $0x0,%esi
  80116b:	bf 06 00 00 00       	mov    $0x6,%edi
  801170:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  801177:	00 00 00 
  80117a:	ff d0                	callq  *%rax
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 30          	sub    $0x30,%rsp
  801186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80118e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801199:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119e:	74 07                	je     8011a7 <devfile_read+0x29>
  8011a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011a5:	75 07                	jne    8011ae <devfile_read+0x30>
		return -E_INVAL;
  8011a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ac:	eb 77                	jmp    801225 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	8b 50 0c             	mov    0xc(%rax),%edx
  8011b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011bc:	00 00 00 
  8011bf:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011c1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011c8:	00 00 00 
  8011cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011cf:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8011d3:	be 00 00 00 00       	mov    $0x0,%esi
  8011d8:	bf 03 00 00 00       	mov    $0x3,%edi
  8011dd:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  8011e4:	00 00 00 
  8011e7:	ff d0                	callq  *%rax
  8011e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011f0:	7f 05                	jg     8011f7 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8011f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f5:	eb 2e                	jmp    801225 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8011f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011fa:	48 63 d0             	movslq %eax,%rdx
  8011fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801201:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801208:	00 00 00 
  80120b:	48 89 c7             	mov    %rax,%rdi
  80120e:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801215:	00 00 00 
  801218:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80121a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801222:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801225:	c9                   	leaveq 
  801226:	c3                   	retq   

0000000000801227 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801227:	55                   	push   %rbp
  801228:	48 89 e5             	mov    %rsp,%rbp
  80122b:	48 83 ec 30          	sub    $0x30,%rsp
  80122f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801233:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801237:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80123b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801242:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801247:	74 07                	je     801250 <devfile_write+0x29>
  801249:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80124e:	75 08                	jne    801258 <devfile_write+0x31>
		return r;
  801250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801253:	e9 9a 00 00 00       	jmpq   8012f2 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125c:	8b 50 0c             	mov    0xc(%rax),%edx
  80125f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801266:	00 00 00 
  801269:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80126b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801272:	00 
  801273:	76 08                	jbe    80127d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801275:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80127c:	00 
	}
	fsipcbuf.write.req_n = n;
  80127d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801284:	00 00 00 
  801287:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80128b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80128f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801297:	48 89 c6             	mov    %rax,%rsi
  80129a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8012a1:	00 00 00 
  8012a4:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  8012ab:	00 00 00 
  8012ae:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8012b0:	be 00 00 00 00       	mov    $0x0,%esi
  8012b5:	bf 04 00 00 00       	mov    $0x4,%edi
  8012ba:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012cd:	7f 20                	jg     8012ef <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8012cf:	48 bf 3e 3f 80 00 00 	movabs $0x803f3e,%rdi
  8012d6:	00 00 00 
  8012d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012de:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  8012e5:	00 00 00 
  8012e8:	ff d2                	callq  *%rdx
		return r;
  8012ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ed:	eb 03                	jmp    8012f2 <devfile_write+0xcb>
	}
	return r;
  8012ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8012f2:	c9                   	leaveq 
  8012f3:	c3                   	retq   

00000000008012f4 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8012f4:	55                   	push   %rbp
  8012f5:	48 89 e5             	mov    %rsp,%rbp
  8012f8:	48 83 ec 20          	sub    $0x20,%rsp
  8012fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801308:	8b 50 0c             	mov    0xc(%rax),%edx
  80130b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801312:	00 00 00 
  801315:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801317:	be 00 00 00 00       	mov    $0x0,%esi
  80131c:	bf 05 00 00 00       	mov    $0x5,%edi
  801321:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  801328:	00 00 00 
  80132b:	ff d0                	callq  *%rax
  80132d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801330:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801334:	79 05                	jns    80133b <devfile_stat+0x47>
		return r;
  801336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801339:	eb 56                	jmp    801391 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80133b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801346:	00 00 00 
  801349:	48 89 c7             	mov    %rax,%rdi
  80134c:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  801353:	00 00 00 
  801356:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801358:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80135f:	00 00 00 
  801362:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801368:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801372:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801379:	00 00 00 
  80137c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801382:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801386:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801391:	c9                   	leaveq 
  801392:	c3                   	retq   

0000000000801393 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	48 83 ec 10          	sub    $0x10,%rsp
  80139b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8013a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013b0:	00 00 00 
  8013b3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8013b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013bc:	00 00 00 
  8013bf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013c2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013c5:	be 00 00 00 00       	mov    $0x0,%esi
  8013ca:	bf 02 00 00 00       	mov    $0x2,%edi
  8013cf:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  8013d6:	00 00 00 
  8013d9:	ff d0                	callq  *%rax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <remove>:

// Delete a file
int
remove(const char *path)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 10          	sub    $0x10,%rsp
  8013e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8013e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ed:	48 89 c7             	mov    %rax,%rdi
  8013f0:	48 b8 40 34 80 00 00 	movabs $0x803440,%rax
  8013f7:	00 00 00 
  8013fa:	ff d0                	callq  *%rax
  8013fc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801401:	7e 07                	jle    80140a <remove+0x2d>
		return -E_BAD_PATH;
  801403:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801408:	eb 33                	jmp    80143d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140e:	48 89 c6             	mov    %rax,%rsi
  801411:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801418:	00 00 00 
  80141b:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  801422:	00 00 00 
  801425:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801427:	be 00 00 00 00       	mov    $0x0,%esi
  80142c:	bf 07 00 00 00       	mov    $0x7,%edi
  801431:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  801438:	00 00 00 
  80143b:	ff d0                	callq  *%rax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801443:	be 00 00 00 00       	mov    $0x0,%esi
  801448:	bf 08 00 00 00       	mov    $0x8,%edi
  80144d:	48 b8 99 0f 80 00 00 	movabs $0x800f99,%rax
  801454:	00 00 00 
  801457:	ff d0                	callq  *%rax
}
  801459:	5d                   	pop    %rbp
  80145a:	c3                   	retq   

000000000080145b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801466:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80146d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801474:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80147b:	be 00 00 00 00       	mov    $0x0,%esi
  801480:	48 89 c7             	mov    %rax,%rdi
  801483:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	callq  *%rax
  80148f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801496:	79 28                	jns    8014c0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80149b:	89 c6                	mov    %eax,%esi
  80149d:	48 bf 5a 3f 80 00 00 	movabs $0x803f5a,%rdi
  8014a4:	00 00 00 
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  8014b3:	00 00 00 
  8014b6:	ff d2                	callq  *%rdx
		return fd_src;
  8014b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014bb:	e9 74 01 00 00       	jmpq   801634 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8014c0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014c7:	be 01 01 00 00       	mov    $0x101,%esi
  8014cc:	48 89 c7             	mov    %rax,%rdi
  8014cf:	48 b8 20 10 80 00 00 	movabs $0x801020,%rax
  8014d6:	00 00 00 
  8014d9:	ff d0                	callq  *%rax
  8014db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014e2:	79 39                	jns    80151d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014e7:	89 c6                	mov    %eax,%esi
  8014e9:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  8014f0:	00 00 00 
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  8014ff:	00 00 00 
  801502:	ff d2                	callq  *%rdx
		close(fd_src);
  801504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801507:	89 c7                	mov    %eax,%edi
  801509:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  801510:	00 00 00 
  801513:	ff d0                	callq  *%rax
		return fd_dest;
  801515:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801518:	e9 17 01 00 00       	jmpq   801634 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80151d:	eb 74                	jmp    801593 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80151f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801522:	48 63 d0             	movslq %eax,%rdx
  801525:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80152c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80152f:	48 89 ce             	mov    %rcx,%rsi
  801532:	89 c7                	mov    %eax,%edi
  801534:	48 b8 94 0c 80 00 00 	movabs $0x800c94,%rax
  80153b:	00 00 00 
  80153e:	ff d0                	callq  *%rax
  801540:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801543:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801547:	79 4a                	jns    801593 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801549:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80154c:	89 c6                	mov    %eax,%esi
  80154e:	48 bf 8a 3f 80 00 00 	movabs $0x803f8a,%rdi
  801555:	00 00 00 
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  801564:	00 00 00 
  801567:	ff d2                	callq  *%rdx
			close(fd_src);
  801569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80156c:	89 c7                	mov    %eax,%edi
  80156e:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  801575:	00 00 00 
  801578:	ff d0                	callq  *%rax
			close(fd_dest);
  80157a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80157d:	89 c7                	mov    %eax,%edi
  80157f:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  801586:	00 00 00 
  801589:	ff d0                	callq  *%rax
			return write_size;
  80158b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80158e:	e9 a1 00 00 00       	jmpq   801634 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801593:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80159a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80159d:	ba 00 02 00 00       	mov    $0x200,%edx
  8015a2:	48 89 ce             	mov    %rcx,%rsi
  8015a5:	89 c7                	mov    %eax,%edi
  8015a7:	48 b8 4a 0b 80 00 00 	movabs $0x800b4a,%rax
  8015ae:	00 00 00 
  8015b1:	ff d0                	callq  *%rax
  8015b3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8015b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015ba:	0f 8f 5f ff ff ff    	jg     80151f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8015c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015c4:	79 47                	jns    80160d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c9:	89 c6                	mov    %eax,%esi
  8015cb:	48 bf 9d 3f 80 00 00 	movabs $0x803f9d,%rdi
  8015d2:	00 00 00 
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  8015e1:	00 00 00 
  8015e4:	ff d2                	callq  *%rdx
		close(fd_src);
  8015e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e9:	89 c7                	mov    %eax,%edi
  8015eb:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  8015f2:	00 00 00 
  8015f5:	ff d0                	callq  *%rax
		close(fd_dest);
  8015f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8015fa:	89 c7                	mov    %eax,%edi
  8015fc:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  801603:	00 00 00 
  801606:	ff d0                	callq  *%rax
		return read_size;
  801608:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160b:	eb 27                	jmp    801634 <copy+0x1d9>
	}
	close(fd_src);
  80160d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801610:	89 c7                	mov    %eax,%edi
  801612:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  801619:	00 00 00 
  80161c:	ff d0                	callq  *%rax
	close(fd_dest);
  80161e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801621:	89 c7                	mov    %eax,%edi
  801623:	48 b8 28 09 80 00 00 	movabs $0x800928,%rax
  80162a:	00 00 00 
  80162d:	ff d0                	callq  *%rax
	return 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	48 83 ec 20          	sub    $0x20,%rsp
  80163e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801641:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801645:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801648:	48 89 d6             	mov    %rdx,%rsi
  80164b:	89 c7                	mov    %eax,%edi
  80164d:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  801654:	00 00 00 
  801657:	ff d0                	callq  *%rax
  801659:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80165c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801660:	79 05                	jns    801667 <fd2sockid+0x31>
		return r;
  801662:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801665:	eb 24                	jmp    80168b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166b:	8b 10                	mov    (%rax),%edx
  80166d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801674:	00 00 00 
  801677:	8b 00                	mov    (%rax),%eax
  801679:	39 c2                	cmp    %eax,%edx
  80167b:	74 07                	je     801684 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80167d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801682:	eb 07                	jmp    80168b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801688:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80168b:	c9                   	leaveq 
  80168c:	c3                   	retq   

000000000080168d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	48 83 ec 20          	sub    $0x20,%rsp
  801695:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801698:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80169c:	48 89 c7             	mov    %rax,%rdi
  80169f:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
  8016ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b2:	78 26                	js     8016da <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	ba 07 04 00 00       	mov    $0x407,%edx
  8016bd:	48 89 c6             	mov    %rax,%rsi
  8016c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c5:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  8016cc:	00 00 00 
  8016cf:	ff d0                	callq  *%rax
  8016d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016d8:	79 16                	jns    8016f0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8016da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016dd:	89 c7                	mov    %eax,%edi
  8016df:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  8016e6:	00 00 00 
  8016e9:	ff d0                	callq  *%rax
		return r;
  8016eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016ee:	eb 3a                	jmp    80172a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8016f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f4:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8016fb:	00 00 00 
  8016fe:	8b 12                	mov    (%rdx),%edx
  801700:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801706:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80170d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801711:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801714:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
}
  80172a:	c9                   	leaveq 
  80172b:	c3                   	retq   

000000000080172c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 30          	sub    $0x30,%rsp
  801734:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801737:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80173b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80173f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801742:	89 c7                	mov    %eax,%edi
  801744:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
  801750:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801757:	79 05                	jns    80175e <accept+0x32>
		return r;
  801759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175c:	eb 3b                	jmp    801799 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80175e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801762:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801769:	48 89 ce             	mov    %rcx,%rsi
  80176c:	89 c7                	mov    %eax,%edi
  80176e:	48 b8 77 1a 80 00 00 	movabs $0x801a77,%rax
  801775:	00 00 00 
  801778:	ff d0                	callq  *%rax
  80177a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80177d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801781:	79 05                	jns    801788 <accept+0x5c>
		return r;
  801783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801786:	eb 11                	jmp    801799 <accept+0x6d>
	return alloc_sockfd(r);
  801788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80178b:	89 c7                	mov    %eax,%edi
  80178d:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  801794:	00 00 00 
  801797:	ff d0                	callq  *%rax
}
  801799:	c9                   	leaveq 
  80179a:	c3                   	retq   

000000000080179b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	48 83 ec 20          	sub    $0x20,%rsp
  8017a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017aa:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b0:	89 c7                	mov    %eax,%edi
  8017b2:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	callq  *%rax
  8017be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017c5:	79 05                	jns    8017cc <bind+0x31>
		return r;
  8017c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ca:	eb 1b                	jmp    8017e7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8017cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8017cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d6:	48 89 ce             	mov    %rcx,%rsi
  8017d9:	89 c7                	mov    %eax,%edi
  8017db:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8017e2:	00 00 00 
  8017e5:	ff d0                	callq  *%rax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <shutdown>:

int
shutdown(int s, int how)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 20          	sub    $0x20,%rsp
  8017f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fa:	89 c7                	mov    %eax,%edi
  8017fc:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801803:	00 00 00 
  801806:	ff d0                	callq  *%rax
  801808:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80180b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80180f:	79 05                	jns    801816 <shutdown+0x2d>
		return r;
  801811:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801814:	eb 16                	jmp    80182c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801816:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181c:	89 d6                	mov    %edx,%esi
  80181e:	89 c7                	mov    %eax,%edi
  801820:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  801827:	00 00 00 
  80182a:	ff d0                	callq  *%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 10          	sub    $0x10,%rsp
  801836:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80183a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183e:	48 89 c7             	mov    %rax,%rdi
  801841:	48 b8 ef 3d 80 00 00 	movabs $0x803def,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
  80184d:	83 f8 01             	cmp    $0x1,%eax
  801850:	75 17                	jne    801869 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801852:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801856:	8b 40 0c             	mov    0xc(%rax),%eax
  801859:	89 c7                	mov    %eax,%edi
  80185b:	48 b8 9a 1b 80 00 00 	movabs $0x801b9a,%rax
  801862:	00 00 00 
  801865:	ff d0                	callq  *%rax
  801867:	eb 05                	jmp    80186e <devsock_close+0x40>
	else
		return 0;
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186e:	c9                   	leaveq 
  80186f:	c3                   	retq   

0000000000801870 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801870:	55                   	push   %rbp
  801871:	48 89 e5             	mov    %rsp,%rbp
  801874:	48 83 ec 20          	sub    $0x20,%rsp
  801878:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80187b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80187f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801882:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801885:	89 c7                	mov    %eax,%edi
  801887:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80188e:	00 00 00 
  801891:	ff d0                	callq  *%rax
  801893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189a:	79 05                	jns    8018a1 <connect+0x31>
		return r;
  80189c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189f:	eb 1b                	jmp    8018bc <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8018a1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8018a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ab:	48 89 ce             	mov    %rcx,%rsi
  8018ae:	89 c7                	mov    %eax,%edi
  8018b0:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  8018b7:	00 00 00 
  8018ba:	ff d0                	callq  *%rax
}
  8018bc:	c9                   	leaveq 
  8018bd:	c3                   	retq   

00000000008018be <listen>:

int
listen(int s, int backlog)
{
  8018be:	55                   	push   %rbp
  8018bf:	48 89 e5             	mov    %rsp,%rbp
  8018c2:	48 83 ec 20          	sub    $0x20,%rsp
  8018c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018c9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018cf:	89 c7                	mov    %eax,%edi
  8018d1:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8018d8:	00 00 00 
  8018db:	ff d0                	callq  *%rax
  8018dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018e4:	79 05                	jns    8018eb <listen+0x2d>
		return r;
  8018e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e9:	eb 16                	jmp    801901 <listen+0x43>
	return nsipc_listen(r, backlog);
  8018eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f1:	89 d6                	mov    %edx,%esi
  8018f3:	89 c7                	mov    %eax,%edi
  8018f5:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  8018fc:	00 00 00 
  8018ff:	ff d0                	callq  *%rax
}
  801901:	c9                   	leaveq 
  801902:	c3                   	retq   

0000000000801903 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801903:	55                   	push   %rbp
  801904:	48 89 e5             	mov    %rsp,%rbp
  801907:	48 83 ec 20          	sub    $0x20,%rsp
  80190b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80190f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801913:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191b:	89 c2                	mov    %eax,%edx
  80191d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801921:	8b 40 0c             	mov    0xc(%rax),%eax
  801924:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801928:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192d:	89 c7                	mov    %eax,%edi
  80192f:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  801936:	00 00 00 
  801939:	ff d0                	callq  *%rax
}
  80193b:	c9                   	leaveq 
  80193c:	c3                   	retq   

000000000080193d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80193d:	55                   	push   %rbp
  80193e:	48 89 e5             	mov    %rsp,%rbp
  801941:	48 83 ec 20          	sub    $0x20,%rsp
  801945:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801949:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80194d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801955:	89 c2                	mov    %eax,%edx
  801957:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195b:	8b 40 0c             	mov    0xc(%rax),%eax
  80195e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801962:	b9 00 00 00 00       	mov    $0x0,%ecx
  801967:	89 c7                	mov    %eax,%edi
  801969:	48 b8 37 1d 80 00 00 	movabs $0x801d37,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 10          	sub    $0x10,%rsp
  80197f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801987:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198b:	48 be b8 3f 80 00 00 	movabs $0x803fb8,%rsi
  801992:	00 00 00 
  801995:	48 89 c7             	mov    %rax,%rdi
  801998:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
	return 0;
  8019a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a9:	c9                   	leaveq 
  8019aa:	c3                   	retq   

00000000008019ab <socket>:

int
socket(int domain, int type, int protocol)
{
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	48 83 ec 20          	sub    $0x20,%rsp
  8019b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8019b9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019bc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8019bf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8019c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019c5:	89 ce                	mov    %ecx,%esi
  8019c7:	89 c7                	mov    %eax,%edi
  8019c9:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
  8019d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019dc:	79 05                	jns    8019e3 <socket+0x38>
		return r;
  8019de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e1:	eb 11                	jmp    8019f4 <socket+0x49>
	return alloc_sockfd(r);
  8019e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e6:	89 c7                	mov    %eax,%edi
  8019e8:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 10          	sub    $0x10,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a01:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a08:	00 00 00 
  801a0b:	8b 00                	mov    (%rax),%eax
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	75 1d                	jne    801a2e <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a11:	bf 02 00 00 00       	mov    $0x2,%edi
  801a16:	48 b8 6d 3d 80 00 00 	movabs $0x803d6d,%rax
  801a1d:	00 00 00 
  801a20:	ff d0                	callq  *%rax
  801a22:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801a29:	00 00 00 
  801a2c:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a2e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a35:	00 00 00 
  801a38:	8b 00                	mov    (%rax),%eax
  801a3a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a3d:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a42:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801a49:	00 00 00 
  801a4c:	89 c7                	mov    %eax,%edi
  801a4e:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  801a55:	00 00 00 
  801a58:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	be 00 00 00 00       	mov    $0x0,%esi
  801a64:	bf 00 00 00 00       	mov    $0x0,%edi
  801a69:	48 b8 05 3c 80 00 00 	movabs $0x803c05,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	callq  *%rax
}
  801a75:	c9                   	leaveq 
  801a76:	c3                   	retq   

0000000000801a77 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a77:	55                   	push   %rbp
  801a78:	48 89 e5             	mov    %rsp,%rbp
  801a7b:	48 83 ec 30          	sub    $0x30,%rsp
  801a7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a86:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801a8a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801a91:	00 00 00 
  801a94:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801a97:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a99:	bf 01 00 00 00       	mov    $0x1,%edi
  801a9e:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
  801aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ab1:	78 3e                	js     801af1 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801ab3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801aba:	00 00 00 
  801abd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac5:	8b 40 10             	mov    0x10(%rax),%eax
  801ac8:	89 c2                	mov    %eax,%edx
  801aca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ace:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ad2:	48 89 ce             	mov    %rcx,%rsi
  801ad5:	48 89 c7             	mov    %rax,%rdi
  801ad8:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae8:	8b 50 10             	mov    0x10(%rax),%edx
  801aeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aef:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 10          	sub    $0x10,%rsp
  801afe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b05:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b08:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b0f:	00 00 00 
  801b12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b15:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b17:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b1e:	48 89 c6             	mov    %rax,%rsi
  801b21:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801b28:	00 00 00 
  801b2b:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801b37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b3e:	00 00 00 
  801b41:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b44:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801b47:	bf 02 00 00 00       	mov    $0x2,%edi
  801b4c:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
}
  801b58:	c9                   	leaveq 
  801b59:	c3                   	retq   

0000000000801b5a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 10          	sub    $0x10,%rsp
  801b62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b65:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801b68:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b6f:	00 00 00 
  801b72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b75:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801b77:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b7e:	00 00 00 
  801b81:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b84:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801b87:	bf 03 00 00 00       	mov    $0x3,%edi
  801b8c:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	callq  *%rax
}
  801b98:	c9                   	leaveq 
  801b99:	c3                   	retq   

0000000000801b9a <nsipc_close>:

int
nsipc_close(int s)
{
  801b9a:	55                   	push   %rbp
  801b9b:	48 89 e5             	mov    %rsp,%rbp
  801b9e:	48 83 ec 10          	sub    $0x10,%rsp
  801ba2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801ba5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bac:	00 00 00 
  801baf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bb2:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801bb4:	bf 04 00 00 00       	mov    $0x4,%edi
  801bb9:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801bc0:	00 00 00 
  801bc3:	ff d0                	callq  *%rax
}
  801bc5:	c9                   	leaveq 
  801bc6:	c3                   	retq   

0000000000801bc7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc7:	55                   	push   %rbp
  801bc8:	48 89 e5             	mov    %rsp,%rbp
  801bcb:	48 83 ec 10          	sub    $0x10,%rsp
  801bcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801bd9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801be0:	00 00 00 
  801be3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801be6:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801be8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bef:	48 89 c6             	mov    %rax,%rsi
  801bf2:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801bf9:	00 00 00 
  801bfc:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801c03:	00 00 00 
  801c06:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c08:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c0f:	00 00 00 
  801c12:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c15:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801c18:	bf 05 00 00 00       	mov    $0x5,%edi
  801c1d:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801c24:	00 00 00 
  801c27:	ff d0                	callq  *%rax
}
  801c29:	c9                   	leaveq 
  801c2a:	c3                   	retq   

0000000000801c2b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c2b:	55                   	push   %rbp
  801c2c:	48 89 e5             	mov    %rsp,%rbp
  801c2f:	48 83 ec 10          	sub    $0x10,%rsp
  801c33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c36:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801c39:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c40:	00 00 00 
  801c43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c46:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801c48:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c4f:	00 00 00 
  801c52:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c55:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801c58:	bf 06 00 00 00       	mov    $0x6,%edi
  801c5d:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	callq  *%rax
}
  801c69:	c9                   	leaveq 
  801c6a:	c3                   	retq   

0000000000801c6b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c6b:	55                   	push   %rbp
  801c6c:	48 89 e5             	mov    %rsp,%rbp
  801c6f:	48 83 ec 30          	sub    $0x30,%rsp
  801c73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c7a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801c7d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801c80:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c87:	00 00 00 
  801c8a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c8d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801c8f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c96:	00 00 00 
  801c99:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c9c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801c9f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ca6:	00 00 00 
  801ca9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cac:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801caf:	bf 07 00 00 00       	mov    $0x7,%edi
  801cb4:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801cbb:	00 00 00 
  801cbe:	ff d0                	callq  *%rax
  801cc0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cc7:	78 69                	js     801d32 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801cc9:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801cd0:	7f 08                	jg     801cda <nsipc_recv+0x6f>
  801cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd5:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801cd8:	7e 35                	jle    801d0f <nsipc_recv+0xa4>
  801cda:	48 b9 bf 3f 80 00 00 	movabs $0x803fbf,%rcx
  801ce1:	00 00 00 
  801ce4:	48 ba d4 3f 80 00 00 	movabs $0x803fd4,%rdx
  801ceb:	00 00 00 
  801cee:	be 61 00 00 00       	mov    $0x61,%esi
  801cf3:	48 bf e9 3f 80 00 00 	movabs $0x803fe9,%rdi
  801cfa:	00 00 00 
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	49 b8 be 26 80 00 00 	movabs $0x8026be,%r8
  801d09:	00 00 00 
  801d0c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d12:	48 63 d0             	movslq %eax,%rdx
  801d15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d19:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801d20:	00 00 00 
  801d23:	48 89 c7             	mov    %rax,%rdi
  801d26:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801d2d:	00 00 00 
  801d30:	ff d0                	callq  *%rax
	}

	return r;
  801d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d35:	c9                   	leaveq 
  801d36:	c3                   	retq   

0000000000801d37 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d37:	55                   	push   %rbp
  801d38:	48 89 e5             	mov    %rsp,%rbp
  801d3b:	48 83 ec 20          	sub    $0x20,%rsp
  801d3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d46:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d49:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801d4c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d53:	00 00 00 
  801d56:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d59:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801d5b:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801d62:	7e 35                	jle    801d99 <nsipc_send+0x62>
  801d64:	48 b9 f5 3f 80 00 00 	movabs $0x803ff5,%rcx
  801d6b:	00 00 00 
  801d6e:	48 ba d4 3f 80 00 00 	movabs $0x803fd4,%rdx
  801d75:	00 00 00 
  801d78:	be 6c 00 00 00       	mov    $0x6c,%esi
  801d7d:	48 bf e9 3f 80 00 00 	movabs $0x803fe9,%rdi
  801d84:	00 00 00 
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8c:	49 b8 be 26 80 00 00 	movabs $0x8026be,%r8
  801d93:	00 00 00 
  801d96:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d9c:	48 63 d0             	movslq %eax,%rdx
  801d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da3:	48 89 c6             	mov    %rax,%rsi
  801da6:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801dad:	00 00 00 
  801db0:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801dbc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dc3:	00 00 00 
  801dc6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801dc9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801dcc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dd3:	00 00 00 
  801dd6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dd9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801ddc:	bf 08 00 00 00       	mov    $0x8,%edi
  801de1:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	callq  *%rax
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 10          	sub    $0x10,%rsp
  801df7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfa:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801dfd:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e00:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e07:	00 00 00 
  801e0a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e0d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e0f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e16:	00 00 00 
  801e19:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e1c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801e1f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e26:	00 00 00 
  801e29:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e2c:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801e2f:	bf 09 00 00 00       	mov    $0x9,%edi
  801e34:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
}
  801e40:	c9                   	leaveq 
  801e41:	c3                   	retq   

0000000000801e42 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	53                   	push   %rbx
  801e47:	48 83 ec 38          	sub    $0x38,%rsp
  801e4b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e4f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801e53:	48 89 c7             	mov    %rax,%rdi
  801e56:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801e5d:	00 00 00 
  801e60:	ff d0                	callq  *%rax
  801e62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e69:	0f 88 bf 01 00 00    	js     80202e <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e73:	ba 07 04 00 00       	mov    $0x407,%edx
  801e78:	48 89 c6             	mov    %rax,%rsi
  801e7b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e80:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801e87:	00 00 00 
  801e8a:	ff d0                	callq  *%rax
  801e8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e93:	0f 88 95 01 00 00    	js     80202e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801e99:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801e9d:	48 89 c7             	mov    %rax,%rdi
  801ea0:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  801ea7:	00 00 00 
  801eaa:	ff d0                	callq  *%rax
  801eac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eb3:	0f 88 5d 01 00 00    	js     802016 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebd:	ba 07 04 00 00       	mov    $0x407,%edx
  801ec2:	48 89 c6             	mov    %rax,%rsi
  801ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eca:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
  801ed6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ed9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801edd:	0f 88 33 01 00 00    	js     802016 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ee3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee7:	48 89 c7             	mov    %rax,%rdi
  801eea:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  801ef1:	00 00 00 
  801ef4:	ff d0                	callq  *%rax
  801ef6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801efe:	ba 07 04 00 00       	mov    $0x407,%edx
  801f03:	48 89 c6             	mov    %rax,%rsi
  801f06:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0b:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801f12:	00 00 00 
  801f15:	ff d0                	callq  *%rax
  801f17:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f1e:	79 05                	jns    801f25 <pipe+0xe3>
		goto err2;
  801f20:	e9 d9 00 00 00       	jmpq   801ffe <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f29:	48 89 c7             	mov    %rax,%rdi
  801f2c:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  801f33:	00 00 00 
  801f36:	ff d0                	callq  *%rax
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f45:	48 89 d1             	mov    %rdx,%rcx
  801f48:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4d:	48 89 c6             	mov    %rax,%rsi
  801f50:	bf 00 00 00 00       	mov    $0x0,%edi
  801f55:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
  801f61:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f64:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f68:	79 1b                	jns    801f85 <pipe+0x143>
		goto err3;
  801f6a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801f6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6f:	48 89 c6             	mov    %rax,%rsi
  801f72:	bf 00 00 00 00       	mov    $0x0,%edi
  801f77:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax
  801f83:	eb 79                	jmp    801ffe <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f89:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801f90:	00 00 00 
  801f93:	8b 12                	mov    (%rdx),%edx
  801f95:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801fad:	00 00 00 
  801fb0:	8b 12                	mov    (%rdx),%edx
  801fb2:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801fb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fb8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc3:	48 89 c7             	mov    %rax,%rdi
  801fc6:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
  801fd2:	89 c2                	mov    %eax,%edx
  801fd4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fd8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801fda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801fde:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801fe2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fe6:	48 89 c7             	mov    %rax,%rdi
  801fe9:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
  801ff5:	89 03                	mov    %eax,(%rbx)
	return 0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	eb 33                	jmp    802031 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801ffe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802002:	48 89 c6             	mov    %rax,%rsi
  802005:	bf 00 00 00 00       	mov    $0x0,%edi
  80200a:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802016:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201a:	48 89 c6             	mov    %rax,%rsi
  80201d:	bf 00 00 00 00       	mov    $0x0,%edi
  802022:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
err:
	return r;
  80202e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802031:	48 83 c4 38          	add    $0x38,%rsp
  802035:	5b                   	pop    %rbx
  802036:	5d                   	pop    %rbp
  802037:	c3                   	retq   

0000000000802038 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802038:	55                   	push   %rbp
  802039:	48 89 e5             	mov    %rsp,%rbp
  80203c:	53                   	push   %rbx
  80203d:	48 83 ec 28          	sub    $0x28,%rsp
  802041:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802045:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802049:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802050:	00 00 00 
  802053:	48 8b 00             	mov    (%rax),%rax
  802056:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80205c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80205f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802063:	48 89 c7             	mov    %rax,%rdi
  802066:	48 b8 ef 3d 80 00 00 	movabs $0x803def,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
  802072:	89 c3                	mov    %eax,%ebx
  802074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802078:	48 89 c7             	mov    %rax,%rdi
  80207b:	48 b8 ef 3d 80 00 00 	movabs $0x803def,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	39 c3                	cmp    %eax,%ebx
  802089:	0f 94 c0             	sete   %al
  80208c:	0f b6 c0             	movzbl %al,%eax
  80208f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802092:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802099:	00 00 00 
  80209c:	48 8b 00             	mov    (%rax),%rax
  80209f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020a5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ab:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020ae:	75 05                	jne    8020b5 <_pipeisclosed+0x7d>
			return ret;
  8020b0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020b3:	eb 4f                	jmp    802104 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8020b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020bb:	74 42                	je     8020ff <_pipeisclosed+0xc7>
  8020bd:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8020c1:	75 3c                	jne    8020ff <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020c3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020ca:	00 00 00 
  8020cd:	48 8b 00             	mov    (%rax),%rax
  8020d0:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8020d6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8020d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020dc:	89 c6                	mov    %eax,%esi
  8020de:	48 bf 06 40 80 00 00 	movabs $0x804006,%rdi
  8020e5:	00 00 00 
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	49 b8 f7 28 80 00 00 	movabs $0x8028f7,%r8
  8020f4:	00 00 00 
  8020f7:	41 ff d0             	callq  *%r8
	}
  8020fa:	e9 4a ff ff ff       	jmpq   802049 <_pipeisclosed+0x11>
  8020ff:	e9 45 ff ff ff       	jmpq   802049 <_pipeisclosed+0x11>
}
  802104:	48 83 c4 28          	add    $0x28,%rsp
  802108:	5b                   	pop    %rbx
  802109:	5d                   	pop    %rbp
  80210a:	c3                   	retq   

000000000080210b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80210b:	55                   	push   %rbp
  80210c:	48 89 e5             	mov    %rsp,%rbp
  80210f:	48 83 ec 30          	sub    $0x30,%rsp
  802113:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802116:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80211a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80211d:	48 89 d6             	mov    %rdx,%rsi
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax
  80212e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802135:	79 05                	jns    80213c <pipeisclosed+0x31>
		return r;
  802137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213a:	eb 31                	jmp    80216d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80213c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802140:	48 89 c7             	mov    %rax,%rdi
  802143:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
  80214f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802157:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80215b:	48 89 d6             	mov    %rdx,%rsi
  80215e:	48 89 c7             	mov    %rax,%rdi
  802161:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 40          	sub    $0x40,%rsp
  802177:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80217b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80217f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802183:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802187:	48 89 c7             	mov    %rax,%rdi
  80218a:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80219a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80219e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021a2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021a9:	00 
  8021aa:	e9 92 00 00 00       	jmpq   802241 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021af:	eb 41                	jmp    8021f2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021b1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8021b6:	74 09                	je     8021c1 <devpipe_read+0x52>
				return i;
  8021b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bc:	e9 92 00 00 00       	jmpq   802253 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c9:	48 89 d6             	mov    %rdx,%rsi
  8021cc:	48 89 c7             	mov    %rax,%rdi
  8021cf:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8021d6:	00 00 00 
  8021d9:	ff d0                	callq  *%rax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	74 07                	je     8021e6 <devpipe_read+0x77>
				return 0;
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	eb 6d                	jmp    802253 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021e6:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8021ed:	00 00 00 
  8021f0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	8b 10                	mov    (%rax),%edx
  8021f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fc:	8b 40 04             	mov    0x4(%rax),%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	74 ae                	je     8021b1 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802207:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80220f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802213:	8b 00                	mov    (%rax),%eax
  802215:	99                   	cltd   
  802216:	c1 ea 1b             	shr    $0x1b,%edx
  802219:	01 d0                	add    %edx,%eax
  80221b:	83 e0 1f             	and    $0x1f,%eax
  80221e:	29 d0                	sub    %edx,%eax
  802220:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802224:	48 98                	cltq   
  802226:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80222b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80222d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802231:	8b 00                	mov    (%rax),%eax
  802233:	8d 50 01             	lea    0x1(%rax),%edx
  802236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80223c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802245:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802249:	0f 82 60 ff ff ff    	jb     8021af <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80224f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802253:	c9                   	leaveq 
  802254:	c3                   	retq   

0000000000802255 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	48 83 ec 40          	sub    $0x40,%rsp
  80225d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802261:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802265:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226d:	48 89 c7             	mov    %rax,%rdi
  802270:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  802277:	00 00 00 
  80227a:	ff d0                	callq  *%rax
  80227c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802280:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802284:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802288:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80228f:	00 
  802290:	e9 8e 00 00 00       	jmpq   802323 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802295:	eb 31                	jmp    8022c8 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802297:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80229f:	48 89 d6             	mov    %rdx,%rsi
  8022a2:	48 89 c7             	mov    %rax,%rdi
  8022a5:	48 b8 38 20 80 00 00 	movabs $0x802038,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 07                	je     8022bc <devpipe_write+0x67>
				return 0;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	eb 79                	jmp    802335 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022bc:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8022c3:	00 00 00 
  8022c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cc:	8b 40 04             	mov    0x4(%rax),%eax
  8022cf:	48 63 d0             	movslq %eax,%rdx
  8022d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d6:	8b 00                	mov    (%rax),%eax
  8022d8:	48 98                	cltq   
  8022da:	48 83 c0 20          	add    $0x20,%rax
  8022de:	48 39 c2             	cmp    %rax,%rdx
  8022e1:	73 b4                	jae    802297 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e7:	8b 40 04             	mov    0x4(%rax),%eax
  8022ea:	99                   	cltd   
  8022eb:	c1 ea 1b             	shr    $0x1b,%edx
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	83 e0 1f             	and    $0x1f,%eax
  8022f3:	29 d0                	sub    %edx,%eax
  8022f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022fd:	48 01 ca             	add    %rcx,%rdx
  802300:	0f b6 0a             	movzbl (%rdx),%ecx
  802303:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802307:	48 98                	cltq   
  802309:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80230d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802311:	8b 40 04             	mov    0x4(%rax),%eax
  802314:	8d 50 01             	lea    0x1(%rax),%edx
  802317:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80231e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802327:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80232b:	0f 82 64 ff ff ff    	jb     802295 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802335:	c9                   	leaveq 
  802336:	c3                   	retq   

0000000000802337 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802337:	55                   	push   %rbp
  802338:	48 89 e5             	mov    %rsp,%rbp
  80233b:	48 83 ec 20          	sub    $0x20,%rsp
  80233f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802343:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	48 89 c7             	mov    %rax,%rdi
  80234e:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  802355:	00 00 00 
  802358:	ff d0                	callq  *%rax
  80235a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80235e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802362:	48 be 19 40 80 00 00 	movabs $0x804019,%rsi
  802369:	00 00 00 
  80236c:	48 89 c7             	mov    %rax,%rdi
  80236f:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80237b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237f:	8b 50 04             	mov    0x4(%rax),%edx
  802382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802386:	8b 00                	mov    (%rax),%eax
  802388:	29 c2                	sub    %eax,%edx
  80238a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80238e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802398:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80239f:	00 00 00 
	stat->st_dev = &devpipe;
  8023a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a6:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8023ad:	00 00 00 
  8023b0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023bc:	c9                   	leaveq 
  8023bd:	c3                   	retq   

00000000008023be <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023be:	55                   	push   %rbp
  8023bf:	48 89 e5             	mov    %rsp,%rbp
  8023c2:	48 83 ec 10          	sub    $0x10,%rsp
  8023c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8023ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ce:	48 89 c6             	mov    %rax,%rsi
  8023d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d6:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8023e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e6:	48 89 c7             	mov    %rax,%rdi
  8023e9:	48 b8 55 06 80 00 00 	movabs $0x800655,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	48 89 c6             	mov    %rax,%rsi
  8023f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fd:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
}
  802409:	c9                   	leaveq 
  80240a:	c3                   	retq   

000000000080240b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80240b:	55                   	push   %rbp
  80240c:	48 89 e5             	mov    %rsp,%rbp
  80240f:	48 83 ec 20          	sub    $0x20,%rsp
  802413:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802416:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802419:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80241c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802420:	be 01 00 00 00       	mov    $0x1,%esi
  802425:	48 89 c7             	mov    %rax,%rdi
  802428:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  80242f:	00 00 00 
  802432:	ff d0                	callq  *%rax
}
  802434:	c9                   	leaveq 
  802435:	c3                   	retq   

0000000000802436 <getchar>:

int
getchar(void)
{
  802436:	55                   	push   %rbp
  802437:	48 89 e5             	mov    %rsp,%rbp
  80243a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80243e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802442:	ba 01 00 00 00       	mov    $0x1,%edx
  802447:	48 89 c6             	mov    %rax,%rsi
  80244a:	bf 00 00 00 00       	mov    $0x0,%edi
  80244f:	48 b8 4a 0b 80 00 00 	movabs $0x800b4a,%rax
  802456:	00 00 00 
  802459:	ff d0                	callq  *%rax
  80245b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80245e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802462:	79 05                	jns    802469 <getchar+0x33>
		return r;
  802464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802467:	eb 14                	jmp    80247d <getchar+0x47>
	if (r < 1)
  802469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246d:	7f 07                	jg     802476 <getchar+0x40>
		return -E_EOF;
  80246f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802474:	eb 07                	jmp    80247d <getchar+0x47>
	return c;
  802476:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80247a:	0f b6 c0             	movzbl %al,%eax
}
  80247d:	c9                   	leaveq 
  80247e:	c3                   	retq   

000000000080247f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80247f:	55                   	push   %rbp
  802480:	48 89 e5             	mov    %rsp,%rbp
  802483:	48 83 ec 20          	sub    $0x20,%rsp
  802487:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802491:	48 89 d6             	mov    %rdx,%rsi
  802494:	89 c7                	mov    %eax,%edi
  802496:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
  8024a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a9:	79 05                	jns    8024b0 <iscons+0x31>
		return r;
  8024ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ae:	eb 1a                	jmp    8024ca <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8024b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b4:	8b 10                	mov    (%rax),%edx
  8024b6:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8024bd:	00 00 00 
  8024c0:	8b 00                	mov    (%rax),%eax
  8024c2:	39 c2                	cmp    %eax,%edx
  8024c4:	0f 94 c0             	sete   %al
  8024c7:	0f b6 c0             	movzbl %al,%eax
}
  8024ca:	c9                   	leaveq 
  8024cb:	c3                   	retq   

00000000008024cc <opencons>:

int
opencons(void)
{
  8024cc:	55                   	push   %rbp
  8024cd:	48 89 e5             	mov    %rsp,%rbp
  8024d0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024d4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024d8:	48 89 c7             	mov    %rax,%rdi
  8024db:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ee:	79 05                	jns    8024f5 <opencons+0x29>
		return r;
  8024f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f3:	eb 5b                	jmp    802550 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8024fe:	48 89 c6             	mov    %rax,%rsi
  802501:	bf 00 00 00 00       	mov    $0x0,%edi
  802506:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  80250d:	00 00 00 
  802510:	ff d0                	callq  *%rax
  802512:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802519:	79 05                	jns    802520 <opencons+0x54>
		return r;
  80251b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251e:	eb 30                	jmp    802550 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802520:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802524:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80252b:	00 00 00 
  80252e:	8b 12                	mov    (%rdx),%edx
  802530:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802536:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80253d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802541:	48 89 c7             	mov    %rax,%rdi
  802544:	48 b8 32 06 80 00 00 	movabs $0x800632,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax
}
  802550:	c9                   	leaveq 
  802551:	c3                   	retq   

0000000000802552 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802552:	55                   	push   %rbp
  802553:	48 89 e5             	mov    %rsp,%rbp
  802556:	48 83 ec 30          	sub    $0x30,%rsp
  80255a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80255e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802562:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802566:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80256b:	75 07                	jne    802574 <devcons_read+0x22>
		return 0;
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	eb 4b                	jmp    8025bf <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802574:	eb 0c                	jmp    802582 <devcons_read+0x30>
		sys_yield();
  802576:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802582:	48 b8 fd 01 80 00 00 	movabs $0x8001fd,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
  80258e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802595:	74 df                	je     802576 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259b:	79 05                	jns    8025a2 <devcons_read+0x50>
		return c;
  80259d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a0:	eb 1d                	jmp    8025bf <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025a6:	75 07                	jne    8025af <devcons_read+0x5d>
		return 0;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	eb 10                	jmp    8025bf <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b2:	89 c2                	mov    %eax,%edx
  8025b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b8:	88 10                	mov    %dl,(%rax)
	return 1;
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025bf:	c9                   	leaveq 
  8025c0:	c3                   	retq   

00000000008025c1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025c1:	55                   	push   %rbp
  8025c2:	48 89 e5             	mov    %rsp,%rbp
  8025c5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8025cc:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8025d3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8025da:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025e8:	eb 76                	jmp    802660 <devcons_write+0x9f>
		m = n - tot;
  8025ea:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8025f1:	89 c2                	mov    %eax,%edx
  8025f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f6:	29 c2                	sub    %eax,%edx
  8025f8:	89 d0                	mov    %edx,%eax
  8025fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8025fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802600:	83 f8 7f             	cmp    $0x7f,%eax
  802603:	76 07                	jbe    80260c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802605:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80260c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80260f:	48 63 d0             	movslq %eax,%rdx
  802612:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802615:	48 63 c8             	movslq %eax,%rcx
  802618:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80261f:	48 01 c1             	add    %rax,%rcx
  802622:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802629:	48 89 ce             	mov    %rcx,%rsi
  80262c:	48 89 c7             	mov    %rax,%rdi
  80262f:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  802636:	00 00 00 
  802639:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80263b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80263e:	48 63 d0             	movslq %eax,%rdx
  802641:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802648:	48 89 d6             	mov    %rdx,%rsi
  80264b:	48 89 c7             	mov    %rax,%rdi
  80264e:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80265a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80265d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	48 98                	cltq   
  802665:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80266c:	0f 82 78 ff ff ff    	jb     8025ea <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802672:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802675:	c9                   	leaveq 
  802676:	c3                   	retq   

0000000000802677 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802677:	55                   	push   %rbp
  802678:	48 89 e5             	mov    %rsp,%rbp
  80267b:	48 83 ec 08          	sub    $0x8,%rsp
  80267f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802688:	c9                   	leaveq 
  802689:	c3                   	retq   

000000000080268a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268a:	55                   	push   %rbp
  80268b:	48 89 e5             	mov    %rsp,%rbp
  80268e:	48 83 ec 10          	sub    $0x10,%rsp
  802692:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802696:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80269a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269e:	48 be 25 40 80 00 00 	movabs $0x804025,%rsi
  8026a5:	00 00 00 
  8026a8:	48 89 c7             	mov    %rax,%rdi
  8026ab:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
	return 0;
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bc:	c9                   	leaveq 
  8026bd:	c3                   	retq   

00000000008026be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026be:	55                   	push   %rbp
  8026bf:	48 89 e5             	mov    %rsp,%rbp
  8026c2:	53                   	push   %rbx
  8026c3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8026ca:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8026d1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8026d7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8026de:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8026e5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8026ec:	84 c0                	test   %al,%al
  8026ee:	74 23                	je     802713 <_panic+0x55>
  8026f0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8026f7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8026fb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8026ff:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802703:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802707:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80270b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80270f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802713:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80271a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802721:	00 00 00 
  802724:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80272b:	00 00 00 
  80272e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802732:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802739:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802740:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802747:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80274e:	00 00 00 
  802751:	48 8b 18             	mov    (%rax),%rbx
  802754:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
  802760:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802766:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80276d:	41 89 c8             	mov    %ecx,%r8d
  802770:	48 89 d1             	mov    %rdx,%rcx
  802773:	48 89 da             	mov    %rbx,%rdx
  802776:	89 c6                	mov    %eax,%esi
  802778:	48 bf 30 40 80 00 00 	movabs $0x804030,%rdi
  80277f:	00 00 00 
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	49 b9 f7 28 80 00 00 	movabs $0x8028f7,%r9
  80278e:	00 00 00 
  802791:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802794:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80279b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027a2:	48 89 d6             	mov    %rdx,%rsi
  8027a5:	48 89 c7             	mov    %rax,%rdi
  8027a8:	48 b8 4b 28 80 00 00 	movabs $0x80284b,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	callq  *%rax
	cprintf("\n");
  8027b4:	48 bf 53 40 80 00 00 	movabs $0x804053,%rdi
  8027bb:	00 00 00 
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c3:	48 ba f7 28 80 00 00 	movabs $0x8028f7,%rdx
  8027ca:	00 00 00 
  8027cd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027cf:	cc                   	int3   
  8027d0:	eb fd                	jmp    8027cf <_panic+0x111>

00000000008027d2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8027d2:	55                   	push   %rbp
  8027d3:	48 89 e5             	mov    %rsp,%rbp
  8027d6:	48 83 ec 10          	sub    $0x10,%rsp
  8027da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8027e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e5:	8b 00                	mov    (%rax),%eax
  8027e7:	8d 48 01             	lea    0x1(%rax),%ecx
  8027ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027ee:	89 0a                	mov    %ecx,(%rdx)
  8027f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027f3:	89 d1                	mov    %edx,%ecx
  8027f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027f9:	48 98                	cltq   
  8027fb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8027ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802803:	8b 00                	mov    (%rax),%eax
  802805:	3d ff 00 00 00       	cmp    $0xff,%eax
  80280a:	75 2c                	jne    802838 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80280c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802810:	8b 00                	mov    (%rax),%eax
  802812:	48 98                	cltq   
  802814:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802818:	48 83 c2 08          	add    $0x8,%rdx
  80281c:	48 89 c6             	mov    %rax,%rsi
  80281f:	48 89 d7             	mov    %rdx,%rdi
  802822:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  802829:	00 00 00 
  80282c:	ff d0                	callq  *%rax
        b->idx = 0;
  80282e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802832:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80283c:	8b 40 04             	mov    0x4(%rax),%eax
  80283f:	8d 50 01             	lea    0x1(%rax),%edx
  802842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802846:	89 50 04             	mov    %edx,0x4(%rax)
}
  802849:	c9                   	leaveq 
  80284a:	c3                   	retq   

000000000080284b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80284b:	55                   	push   %rbp
  80284c:	48 89 e5             	mov    %rsp,%rbp
  80284f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802856:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80285d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802864:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80286b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802872:	48 8b 0a             	mov    (%rdx),%rcx
  802875:	48 89 08             	mov    %rcx,(%rax)
  802878:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80287c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802880:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802884:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802888:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80288f:	00 00 00 
    b.cnt = 0;
  802892:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802899:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80289c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028a3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028aa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8028b1:	48 89 c6             	mov    %rax,%rsi
  8028b4:	48 bf d2 27 80 00 00 	movabs $0x8027d2,%rdi
  8028bb:	00 00 00 
  8028be:	48 b8 aa 2c 80 00 00 	movabs $0x802caa,%rax
  8028c5:	00 00 00 
  8028c8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8028ca:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8028d0:	48 98                	cltq   
  8028d2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8028d9:	48 83 c2 08          	add    $0x8,%rdx
  8028dd:	48 89 c6             	mov    %rax,%rsi
  8028e0:	48 89 d7             	mov    %rdx,%rdi
  8028e3:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8028ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8028f5:	c9                   	leaveq 
  8028f6:	c3                   	retq   

00000000008028f7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8028f7:	55                   	push   %rbp
  8028f8:	48 89 e5             	mov    %rsp,%rbp
  8028fb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802902:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802909:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802910:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802917:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80291e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802925:	84 c0                	test   %al,%al
  802927:	74 20                	je     802949 <cprintf+0x52>
  802929:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80292d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802931:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802935:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802939:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80293d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802941:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802945:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802949:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802950:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802957:	00 00 00 
  80295a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802961:	00 00 00 
  802964:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802968:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80296f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802976:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80297d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802984:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80298b:	48 8b 0a             	mov    (%rdx),%rcx
  80298e:	48 89 08             	mov    %rcx,(%rax)
  802991:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802995:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802999:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80299d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029a1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029af:	48 89 d6             	mov    %rdx,%rsi
  8029b2:	48 89 c7             	mov    %rax,%rdi
  8029b5:	48 b8 4b 28 80 00 00 	movabs $0x80284b,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
  8029c1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8029c7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	53                   	push   %rbx
  8029d4:	48 83 ec 38          	sub    $0x38,%rsp
  8029d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8029e4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8029e7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8029eb:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8029ef:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8029f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029f6:	77 3b                	ja     802a33 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8029f8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8029fb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8029ff:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a06:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0b:	48 f7 f3             	div    %rbx
  802a0e:	48 89 c2             	mov    %rax,%rdx
  802a11:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a14:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a17:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1f:	41 89 f9             	mov    %edi,%r9d
  802a22:	48 89 c7             	mov    %rax,%rdi
  802a25:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	eb 1e                	jmp    802a51 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a33:	eb 12                	jmp    802a47 <printnum+0x78>
			putch(padc, putdat);
  802a35:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a39:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a40:	48 89 ce             	mov    %rcx,%rsi
  802a43:	89 d7                	mov    %edx,%edi
  802a45:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a47:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a4b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a4f:	7f e4                	jg     802a35 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802a51:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a58:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5d:	48 f7 f1             	div    %rcx
  802a60:	48 89 d0             	mov    %rdx,%rax
  802a63:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  802a6a:	00 00 00 
  802a6d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802a71:	0f be d0             	movsbl %al,%edx
  802a74:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7c:	48 89 ce             	mov    %rcx,%rsi
  802a7f:	89 d7                	mov    %edx,%edi
  802a81:	ff d0                	callq  *%rax
}
  802a83:	48 83 c4 38          	add    $0x38,%rsp
  802a87:	5b                   	pop    %rbx
  802a88:	5d                   	pop    %rbp
  802a89:	c3                   	retq   

0000000000802a8a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802a92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a96:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802a99:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802a9d:	7e 52                	jle    802af1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa3:	8b 00                	mov    (%rax),%eax
  802aa5:	83 f8 30             	cmp    $0x30,%eax
  802aa8:	73 24                	jae    802ace <getuint+0x44>
  802aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab6:	8b 00                	mov    (%rax),%eax
  802ab8:	89 c0                	mov    %eax,%eax
  802aba:	48 01 d0             	add    %rdx,%rax
  802abd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac1:	8b 12                	mov    (%rdx),%edx
  802ac3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ac6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aca:	89 0a                	mov    %ecx,(%rdx)
  802acc:	eb 17                	jmp    802ae5 <getuint+0x5b>
  802ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ad6:	48 89 d0             	mov    %rdx,%rax
  802ad9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802ae5:	48 8b 00             	mov    (%rax),%rax
  802ae8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802aec:	e9 a3 00 00 00       	jmpq   802b94 <getuint+0x10a>
	else if (lflag)
  802af1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802af5:	74 4f                	je     802b46 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afb:	8b 00                	mov    (%rax),%eax
  802afd:	83 f8 30             	cmp    $0x30,%eax
  802b00:	73 24                	jae    802b26 <getuint+0x9c>
  802b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b06:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0e:	8b 00                	mov    (%rax),%eax
  802b10:	89 c0                	mov    %eax,%eax
  802b12:	48 01 d0             	add    %rdx,%rax
  802b15:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b19:	8b 12                	mov    (%rdx),%edx
  802b1b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b22:	89 0a                	mov    %ecx,(%rdx)
  802b24:	eb 17                	jmp    802b3d <getuint+0xb3>
  802b26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b2e:	48 89 d0             	mov    %rdx,%rax
  802b31:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b39:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b3d:	48 8b 00             	mov    (%rax),%rax
  802b40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b44:	eb 4e                	jmp    802b94 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4a:	8b 00                	mov    (%rax),%eax
  802b4c:	83 f8 30             	cmp    $0x30,%eax
  802b4f:	73 24                	jae    802b75 <getuint+0xeb>
  802b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b55:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5d:	8b 00                	mov    (%rax),%eax
  802b5f:	89 c0                	mov    %eax,%eax
  802b61:	48 01 d0             	add    %rdx,%rax
  802b64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b68:	8b 12                	mov    (%rdx),%edx
  802b6a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b71:	89 0a                	mov    %ecx,(%rdx)
  802b73:	eb 17                	jmp    802b8c <getuint+0x102>
  802b75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b79:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b7d:	48 89 d0             	mov    %rdx,%rax
  802b80:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b88:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b8c:	8b 00                	mov    (%rax),%eax
  802b8e:	89 c0                	mov    %eax,%eax
  802b90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802b98:	c9                   	leaveq 
  802b99:	c3                   	retq   

0000000000802b9a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802b9a:	55                   	push   %rbp
  802b9b:	48 89 e5             	mov    %rsp,%rbp
  802b9e:	48 83 ec 1c          	sub    $0x1c,%rsp
  802ba2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ba6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802ba9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802bad:	7e 52                	jle    802c01 <getint+0x67>
		x=va_arg(*ap, long long);
  802baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb3:	8b 00                	mov    (%rax),%eax
  802bb5:	83 f8 30             	cmp    $0x30,%eax
  802bb8:	73 24                	jae    802bde <getint+0x44>
  802bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbe:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc6:	8b 00                	mov    (%rax),%eax
  802bc8:	89 c0                	mov    %eax,%eax
  802bca:	48 01 d0             	add    %rdx,%rax
  802bcd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bd1:	8b 12                	mov    (%rdx),%edx
  802bd3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bda:	89 0a                	mov    %ecx,(%rdx)
  802bdc:	eb 17                	jmp    802bf5 <getint+0x5b>
  802bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802be6:	48 89 d0             	mov    %rdx,%rax
  802be9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802bed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802bf5:	48 8b 00             	mov    (%rax),%rax
  802bf8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802bfc:	e9 a3 00 00 00       	jmpq   802ca4 <getint+0x10a>
	else if (lflag)
  802c01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c05:	74 4f                	je     802c56 <getint+0xbc>
		x=va_arg(*ap, long);
  802c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0b:	8b 00                	mov    (%rax),%eax
  802c0d:	83 f8 30             	cmp    $0x30,%eax
  802c10:	73 24                	jae    802c36 <getint+0x9c>
  802c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c16:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1e:	8b 00                	mov    (%rax),%eax
  802c20:	89 c0                	mov    %eax,%eax
  802c22:	48 01 d0             	add    %rdx,%rax
  802c25:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c29:	8b 12                	mov    (%rdx),%edx
  802c2b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c32:	89 0a                	mov    %ecx,(%rdx)
  802c34:	eb 17                	jmp    802c4d <getint+0xb3>
  802c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c3e:	48 89 d0             	mov    %rdx,%rax
  802c41:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c49:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c4d:	48 8b 00             	mov    (%rax),%rax
  802c50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c54:	eb 4e                	jmp    802ca4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802c56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5a:	8b 00                	mov    (%rax),%eax
  802c5c:	83 f8 30             	cmp    $0x30,%eax
  802c5f:	73 24                	jae    802c85 <getint+0xeb>
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6d:	8b 00                	mov    (%rax),%eax
  802c6f:	89 c0                	mov    %eax,%eax
  802c71:	48 01 d0             	add    %rdx,%rax
  802c74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c78:	8b 12                	mov    (%rdx),%edx
  802c7a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c81:	89 0a                	mov    %ecx,(%rdx)
  802c83:	eb 17                	jmp    802c9c <getint+0x102>
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c8d:	48 89 d0             	mov    %rdx,%rax
  802c90:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c98:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c9c:	8b 00                	mov    (%rax),%eax
  802c9e:	48 98                	cltq   
  802ca0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ca8:	c9                   	leaveq 
  802ca9:	c3                   	retq   

0000000000802caa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802caa:	55                   	push   %rbp
  802cab:	48 89 e5             	mov    %rsp,%rbp
  802cae:	41 54                	push   %r12
  802cb0:	53                   	push   %rbx
  802cb1:	48 83 ec 60          	sub    $0x60,%rsp
  802cb5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802cb9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802cbd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802cc1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802cc5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802cc9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ccd:	48 8b 0a             	mov    (%rdx),%rcx
  802cd0:	48 89 08             	mov    %rcx,(%rax)
  802cd3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802cd7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cdb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802cdf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ce3:	eb 17                	jmp    802cfc <vprintfmt+0x52>
			if (ch == '\0')
  802ce5:	85 db                	test   %ebx,%ebx
  802ce7:	0f 84 cc 04 00 00    	je     8031b9 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802ced:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802cf1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802cf5:	48 89 d6             	mov    %rdx,%rsi
  802cf8:	89 df                	mov    %ebx,%edi
  802cfa:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802cfc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d04:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d08:	0f b6 00             	movzbl (%rax),%eax
  802d0b:	0f b6 d8             	movzbl %al,%ebx
  802d0e:	83 fb 25             	cmp    $0x25,%ebx
  802d11:	75 d2                	jne    802ce5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d13:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d17:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d1e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d2c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d3b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d3f:	0f b6 00             	movzbl (%rax),%eax
  802d42:	0f b6 d8             	movzbl %al,%ebx
  802d45:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802d48:	83 f8 55             	cmp    $0x55,%eax
  802d4b:	0f 87 34 04 00 00    	ja     803185 <vprintfmt+0x4db>
  802d51:	89 c0                	mov    %eax,%eax
  802d53:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d5a:	00 
  802d5b:	48 b8 78 42 80 00 00 	movabs $0x804278,%rax
  802d62:	00 00 00 
  802d65:	48 01 d0             	add    %rdx,%rax
  802d68:	48 8b 00             	mov    (%rax),%rax
  802d6b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802d6d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802d71:	eb c0                	jmp    802d33 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802d73:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802d77:	eb ba                	jmp    802d33 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802d79:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802d80:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d83:	89 d0                	mov    %edx,%eax
  802d85:	c1 e0 02             	shl    $0x2,%eax
  802d88:	01 d0                	add    %edx,%eax
  802d8a:	01 c0                	add    %eax,%eax
  802d8c:	01 d8                	add    %ebx,%eax
  802d8e:	83 e8 30             	sub    $0x30,%eax
  802d91:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802d94:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d98:	0f b6 00             	movzbl (%rax),%eax
  802d9b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802d9e:	83 fb 2f             	cmp    $0x2f,%ebx
  802da1:	7e 0c                	jle    802daf <vprintfmt+0x105>
  802da3:	83 fb 39             	cmp    $0x39,%ebx
  802da6:	7f 07                	jg     802daf <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802da8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802dad:	eb d1                	jmp    802d80 <vprintfmt+0xd6>
			goto process_precision;
  802daf:	eb 58                	jmp    802e09 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802db4:	83 f8 30             	cmp    $0x30,%eax
  802db7:	73 17                	jae    802dd0 <vprintfmt+0x126>
  802db9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dc0:	89 c0                	mov    %eax,%eax
  802dc2:	48 01 d0             	add    %rdx,%rax
  802dc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802dc8:	83 c2 08             	add    $0x8,%edx
  802dcb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802dce:	eb 0f                	jmp    802ddf <vprintfmt+0x135>
  802dd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802dd4:	48 89 d0             	mov    %rdx,%rax
  802dd7:	48 83 c2 08          	add    $0x8,%rdx
  802ddb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ddf:	8b 00                	mov    (%rax),%eax
  802de1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802de4:	eb 23                	jmp    802e09 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802de6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802dea:	79 0c                	jns    802df8 <vprintfmt+0x14e>
				width = 0;
  802dec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802df3:	e9 3b ff ff ff       	jmpq   802d33 <vprintfmt+0x89>
  802df8:	e9 36 ff ff ff       	jmpq   802d33 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802dfd:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e04:	e9 2a ff ff ff       	jmpq   802d33 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e0d:	79 12                	jns    802e21 <vprintfmt+0x177>
				width = precision, precision = -1;
  802e0f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e12:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e15:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e1c:	e9 12 ff ff ff       	jmpq   802d33 <vprintfmt+0x89>
  802e21:	e9 0d ff ff ff       	jmpq   802d33 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e26:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e2a:	e9 04 ff ff ff       	jmpq   802d33 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e32:	83 f8 30             	cmp    $0x30,%eax
  802e35:	73 17                	jae    802e4e <vprintfmt+0x1a4>
  802e37:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e3e:	89 c0                	mov    %eax,%eax
  802e40:	48 01 d0             	add    %rdx,%rax
  802e43:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e46:	83 c2 08             	add    $0x8,%edx
  802e49:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e4c:	eb 0f                	jmp    802e5d <vprintfmt+0x1b3>
  802e4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e52:	48 89 d0             	mov    %rdx,%rax
  802e55:	48 83 c2 08          	add    $0x8,%rdx
  802e59:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e5d:	8b 10                	mov    (%rax),%edx
  802e5f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802e63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e67:	48 89 ce             	mov    %rcx,%rsi
  802e6a:	89 d7                	mov    %edx,%edi
  802e6c:	ff d0                	callq  *%rax
			break;
  802e6e:	e9 40 03 00 00       	jmpq   8031b3 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802e73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e76:	83 f8 30             	cmp    $0x30,%eax
  802e79:	73 17                	jae    802e92 <vprintfmt+0x1e8>
  802e7b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e82:	89 c0                	mov    %eax,%eax
  802e84:	48 01 d0             	add    %rdx,%rax
  802e87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e8a:	83 c2 08             	add    $0x8,%edx
  802e8d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e90:	eb 0f                	jmp    802ea1 <vprintfmt+0x1f7>
  802e92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e96:	48 89 d0             	mov    %rdx,%rax
  802e99:	48 83 c2 08          	add    $0x8,%rdx
  802e9d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802ea1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802ea3:	85 db                	test   %ebx,%ebx
  802ea5:	79 02                	jns    802ea9 <vprintfmt+0x1ff>
				err = -err;
  802ea7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802ea9:	83 fb 15             	cmp    $0x15,%ebx
  802eac:	7f 16                	jg     802ec4 <vprintfmt+0x21a>
  802eae:	48 b8 a0 41 80 00 00 	movabs $0x8041a0,%rax
  802eb5:	00 00 00 
  802eb8:	48 63 d3             	movslq %ebx,%rdx
  802ebb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802ebf:	4d 85 e4             	test   %r12,%r12
  802ec2:	75 2e                	jne    802ef2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802ec4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ec8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ecc:	89 d9                	mov    %ebx,%ecx
  802ece:	48 ba 61 42 80 00 00 	movabs $0x804261,%rdx
  802ed5:	00 00 00 
  802ed8:	48 89 c7             	mov    %rax,%rdi
  802edb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee0:	49 b8 c2 31 80 00 00 	movabs $0x8031c2,%r8
  802ee7:	00 00 00 
  802eea:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802eed:	e9 c1 02 00 00       	jmpq   8031b3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802ef2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802efa:	4c 89 e1             	mov    %r12,%rcx
  802efd:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  802f04:	00 00 00 
  802f07:	48 89 c7             	mov    %rax,%rdi
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	49 b8 c2 31 80 00 00 	movabs $0x8031c2,%r8
  802f16:	00 00 00 
  802f19:	41 ff d0             	callq  *%r8
			break;
  802f1c:	e9 92 02 00 00       	jmpq   8031b3 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f24:	83 f8 30             	cmp    $0x30,%eax
  802f27:	73 17                	jae    802f40 <vprintfmt+0x296>
  802f29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f30:	89 c0                	mov    %eax,%eax
  802f32:	48 01 d0             	add    %rdx,%rax
  802f35:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f38:	83 c2 08             	add    $0x8,%edx
  802f3b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f3e:	eb 0f                	jmp    802f4f <vprintfmt+0x2a5>
  802f40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f44:	48 89 d0             	mov    %rdx,%rax
  802f47:	48 83 c2 08          	add    $0x8,%rdx
  802f4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f4f:	4c 8b 20             	mov    (%rax),%r12
  802f52:	4d 85 e4             	test   %r12,%r12
  802f55:	75 0a                	jne    802f61 <vprintfmt+0x2b7>
				p = "(null)";
  802f57:	49 bc 6d 42 80 00 00 	movabs $0x80426d,%r12
  802f5e:	00 00 00 
			if (width > 0 && padc != '-')
  802f61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f65:	7e 3f                	jle    802fa6 <vprintfmt+0x2fc>
  802f67:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802f6b:	74 39                	je     802fa6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802f6d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f70:	48 98                	cltq   
  802f72:	48 89 c6             	mov    %rax,%rsi
  802f75:	4c 89 e7             	mov    %r12,%rdi
  802f78:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  802f7f:	00 00 00 
  802f82:	ff d0                	callq  *%rax
  802f84:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802f87:	eb 17                	jmp    802fa0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802f89:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802f8d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802f91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f95:	48 89 ce             	mov    %rcx,%rsi
  802f98:	89 d7                	mov    %edx,%edi
  802f9a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802f9c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fa0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fa4:	7f e3                	jg     802f89 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fa6:	eb 37                	jmp    802fdf <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802fa8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802fac:	74 1e                	je     802fcc <vprintfmt+0x322>
  802fae:	83 fb 1f             	cmp    $0x1f,%ebx
  802fb1:	7e 05                	jle    802fb8 <vprintfmt+0x30e>
  802fb3:	83 fb 7e             	cmp    $0x7e,%ebx
  802fb6:	7e 14                	jle    802fcc <vprintfmt+0x322>
					putch('?', putdat);
  802fb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fc0:	48 89 d6             	mov    %rdx,%rsi
  802fc3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802fc8:	ff d0                	callq  *%rax
  802fca:	eb 0f                	jmp    802fdb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802fcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fd4:	48 89 d6             	mov    %rdx,%rsi
  802fd7:	89 df                	mov    %ebx,%edi
  802fd9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fdb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fdf:	4c 89 e0             	mov    %r12,%rax
  802fe2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802fe6:	0f b6 00             	movzbl (%rax),%eax
  802fe9:	0f be d8             	movsbl %al,%ebx
  802fec:	85 db                	test   %ebx,%ebx
  802fee:	74 10                	je     803000 <vprintfmt+0x356>
  802ff0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ff4:	78 b2                	js     802fa8 <vprintfmt+0x2fe>
  802ff6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802ffa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ffe:	79 a8                	jns    802fa8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803000:	eb 16                	jmp    803018 <vprintfmt+0x36e>
				putch(' ', putdat);
  803002:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803006:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80300a:	48 89 d6             	mov    %rdx,%rsi
  80300d:	bf 20 00 00 00       	mov    $0x20,%edi
  803012:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803014:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803018:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80301c:	7f e4                	jg     803002 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80301e:	e9 90 01 00 00       	jmpq   8031b3 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803023:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803027:	be 03 00 00 00       	mov    $0x3,%esi
  80302c:	48 89 c7             	mov    %rax,%rdi
  80302f:	48 b8 9a 2b 80 00 00 	movabs $0x802b9a,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
  80303b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80303f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803043:	48 85 c0             	test   %rax,%rax
  803046:	79 1d                	jns    803065 <vprintfmt+0x3bb>
				putch('-', putdat);
  803048:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80304c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803050:	48 89 d6             	mov    %rdx,%rsi
  803053:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803058:	ff d0                	callq  *%rax
				num = -(long long) num;
  80305a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305e:	48 f7 d8             	neg    %rax
  803061:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803065:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80306c:	e9 d5 00 00 00       	jmpq   803146 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803071:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803075:	be 03 00 00 00       	mov    $0x3,%esi
  80307a:	48 89 c7             	mov    %rax,%rdi
  80307d:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
  803089:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80308d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803094:	e9 ad 00 00 00       	jmpq   803146 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  803099:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80309c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030a0:	89 d6                	mov    %edx,%esi
  8030a2:	48 89 c7             	mov    %rax,%rdi
  8030a5:	48 b8 9a 2b 80 00 00 	movabs $0x802b9a,%rax
  8030ac:	00 00 00 
  8030af:	ff d0                	callq  *%rax
  8030b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8030b5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8030bc:	e9 85 00 00 00       	jmpq   803146 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8030c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030c9:	48 89 d6             	mov    %rdx,%rsi
  8030cc:	bf 30 00 00 00       	mov    $0x30,%edi
  8030d1:	ff d0                	callq  *%rax
			putch('x', putdat);
  8030d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030db:	48 89 d6             	mov    %rdx,%rsi
  8030de:	bf 78 00 00 00       	mov    $0x78,%edi
  8030e3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8030e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030e8:	83 f8 30             	cmp    $0x30,%eax
  8030eb:	73 17                	jae    803104 <vprintfmt+0x45a>
  8030ed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030f4:	89 c0                	mov    %eax,%eax
  8030f6:	48 01 d0             	add    %rdx,%rax
  8030f9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030fc:	83 c2 08             	add    $0x8,%edx
  8030ff:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803102:	eb 0f                	jmp    803113 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  803104:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803108:	48 89 d0             	mov    %rdx,%rax
  80310b:	48 83 c2 08          	add    $0x8,%rdx
  80310f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803113:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803116:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80311a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803121:	eb 23                	jmp    803146 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803123:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803127:	be 03 00 00 00       	mov    $0x3,%esi
  80312c:	48 89 c7             	mov    %rax,%rdi
  80312f:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80313f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803146:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80314b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80314e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803151:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803155:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803159:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80315d:	45 89 c1             	mov    %r8d,%r9d
  803160:	41 89 f8             	mov    %edi,%r8d
  803163:	48 89 c7             	mov    %rax,%rdi
  803166:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  80316d:	00 00 00 
  803170:	ff d0                	callq  *%rax
			break;
  803172:	eb 3f                	jmp    8031b3 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803174:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803178:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80317c:	48 89 d6             	mov    %rdx,%rsi
  80317f:	89 df                	mov    %ebx,%edi
  803181:	ff d0                	callq  *%rax
			break;
  803183:	eb 2e                	jmp    8031b3 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803185:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803189:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80318d:	48 89 d6             	mov    %rdx,%rsi
  803190:	bf 25 00 00 00       	mov    $0x25,%edi
  803195:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803197:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80319c:	eb 05                	jmp    8031a3 <vprintfmt+0x4f9>
  80319e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031a3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031a7:	48 83 e8 01          	sub    $0x1,%rax
  8031ab:	0f b6 00             	movzbl (%rax),%eax
  8031ae:	3c 25                	cmp    $0x25,%al
  8031b0:	75 ec                	jne    80319e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8031b2:	90                   	nop
		}
	}
  8031b3:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031b4:	e9 43 fb ff ff       	jmpq   802cfc <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8031b9:	48 83 c4 60          	add    $0x60,%rsp
  8031bd:	5b                   	pop    %rbx
  8031be:	41 5c                	pop    %r12
  8031c0:	5d                   	pop    %rbp
  8031c1:	c3                   	retq   

00000000008031c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8031c2:	55                   	push   %rbp
  8031c3:	48 89 e5             	mov    %rsp,%rbp
  8031c6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8031cd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8031d4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8031db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031f0:	84 c0                	test   %al,%al
  8031f2:	74 20                	je     803214 <printfmt+0x52>
  8031f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803200:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803204:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803208:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80320c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803210:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803214:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80321b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803222:	00 00 00 
  803225:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80322c:	00 00 00 
  80322f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803233:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80323a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803241:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803248:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80324f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803256:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80325d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803264:	48 89 c7             	mov    %rax,%rdi
  803267:	48 b8 aa 2c 80 00 00 	movabs $0x802caa,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
	va_end(ap);
}
  803273:	c9                   	leaveq 
  803274:	c3                   	retq   

0000000000803275 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803275:	55                   	push   %rbp
  803276:	48 89 e5             	mov    %rsp,%rbp
  803279:	48 83 ec 10          	sub    $0x10,%rsp
  80327d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803280:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803288:	8b 40 10             	mov    0x10(%rax),%eax
  80328b:	8d 50 01             	lea    0x1(%rax),%edx
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803299:	48 8b 10             	mov    (%rax),%rdx
  80329c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032a4:	48 39 c2             	cmp    %rax,%rdx
  8032a7:	73 17                	jae    8032c0 <sprintputch+0x4b>
		*b->buf++ = ch;
  8032a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ad:	48 8b 00             	mov    (%rax),%rax
  8032b0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8032b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032b8:	48 89 0a             	mov    %rcx,(%rdx)
  8032bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032be:	88 10                	mov    %dl,(%rax)
}
  8032c0:	c9                   	leaveq 
  8032c1:	c3                   	retq   

00000000008032c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8032c2:	55                   	push   %rbp
  8032c3:	48 89 e5             	mov    %rsp,%rbp
  8032c6:	48 83 ec 50          	sub    $0x50,%rsp
  8032ca:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8032ce:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8032d1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8032d5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8032d9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032dd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8032e1:	48 8b 0a             	mov    (%rdx),%rcx
  8032e4:	48 89 08             	mov    %rcx,(%rax)
  8032e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8032eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8032ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8032f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8032f7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032fb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8032ff:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803302:	48 98                	cltq   
  803304:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803308:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80330c:	48 01 d0             	add    %rdx,%rax
  80330f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803313:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80331a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80331f:	74 06                	je     803327 <vsnprintf+0x65>
  803321:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803325:	7f 07                	jg     80332e <vsnprintf+0x6c>
		return -E_INVAL;
  803327:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80332c:	eb 2f                	jmp    80335d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80332e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803332:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803336:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80333a:	48 89 c6             	mov    %rax,%rsi
  80333d:	48 bf 75 32 80 00 00 	movabs $0x803275,%rdi
  803344:	00 00 00 
  803347:	48 b8 aa 2c 80 00 00 	movabs $0x802caa,%rax
  80334e:	00 00 00 
  803351:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803353:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803357:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80335a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80335d:	c9                   	leaveq 
  80335e:	c3                   	retq   

000000000080335f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80335f:	55                   	push   %rbp
  803360:	48 89 e5             	mov    %rsp,%rbp
  803363:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80336a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803371:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803377:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80337e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803385:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80338c:	84 c0                	test   %al,%al
  80338e:	74 20                	je     8033b0 <snprintf+0x51>
  803390:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803394:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803398:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80339c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033a0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033a4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033a8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033ac:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033b0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8033b7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8033be:	00 00 00 
  8033c1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033c8:	00 00 00 
  8033cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033cf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033d6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033dd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8033e4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8033eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033f2:	48 8b 0a             	mov    (%rdx),%rcx
  8033f5:	48 89 08             	mov    %rcx,(%rax)
  8033f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8033fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803400:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803404:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803408:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80340f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803416:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80341c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803423:	48 89 c7             	mov    %rax,%rdi
  803426:	48 b8 c2 32 80 00 00 	movabs $0x8032c2,%rax
  80342d:	00 00 00 
  803430:	ff d0                	callq  *%rax
  803432:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803438:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80343e:	c9                   	leaveq 
  80343f:	c3                   	retq   

0000000000803440 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803440:	55                   	push   %rbp
  803441:	48 89 e5             	mov    %rsp,%rbp
  803444:	48 83 ec 18          	sub    $0x18,%rsp
  803448:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80344c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803453:	eb 09                	jmp    80345e <strlen+0x1e>
		n++;
  803455:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803459:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80345e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803462:	0f b6 00             	movzbl (%rax),%eax
  803465:	84 c0                	test   %al,%al
  803467:	75 ec                	jne    803455 <strlen+0x15>
		n++;
	return n;
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   

000000000080346e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 20          	sub    $0x20,%rsp
  803476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80347a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80347e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803485:	eb 0e                	jmp    803495 <strnlen+0x27>
		n++;
  803487:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80348b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803490:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803495:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80349a:	74 0b                	je     8034a7 <strnlen+0x39>
  80349c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a0:	0f b6 00             	movzbl (%rax),%eax
  8034a3:	84 c0                	test   %al,%al
  8034a5:	75 e0                	jne    803487 <strnlen+0x19>
		n++;
	return n;
  8034a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034aa:	c9                   	leaveq 
  8034ab:	c3                   	retq   

00000000008034ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8034ac:	55                   	push   %rbp
  8034ad:	48 89 e5             	mov    %rsp,%rbp
  8034b0:	48 83 ec 20          	sub    $0x20,%rsp
  8034b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8034bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8034c4:	90                   	nop
  8034c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034cd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8034d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034d5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8034d9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8034dd:	0f b6 12             	movzbl (%rdx),%edx
  8034e0:	88 10                	mov    %dl,(%rax)
  8034e2:	0f b6 00             	movzbl (%rax),%eax
  8034e5:	84 c0                	test   %al,%al
  8034e7:	75 dc                	jne    8034c5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8034e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034ed:	c9                   	leaveq 
  8034ee:	c3                   	retq   

00000000008034ef <strcat>:

char *
strcat(char *dst, const char *src)
{
  8034ef:	55                   	push   %rbp
  8034f0:	48 89 e5             	mov    %rsp,%rbp
  8034f3:	48 83 ec 20          	sub    $0x20,%rsp
  8034f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8034ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803503:	48 89 c7             	mov    %rax,%rdi
  803506:	48 b8 40 34 80 00 00 	movabs $0x803440,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803518:	48 63 d0             	movslq %eax,%rdx
  80351b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351f:	48 01 c2             	add    %rax,%rdx
  803522:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803526:	48 89 c6             	mov    %rax,%rsi
  803529:	48 89 d7             	mov    %rdx,%rdi
  80352c:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
	return dst;
  803538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80353c:	c9                   	leaveq 
  80353d:	c3                   	retq   

000000000080353e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80353e:	55                   	push   %rbp
  80353f:	48 89 e5             	mov    %rsp,%rbp
  803542:	48 83 ec 28          	sub    $0x28,%rsp
  803546:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80354a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80354e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80355a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803561:	00 
  803562:	eb 2a                	jmp    80358e <strncpy+0x50>
		*dst++ = *src;
  803564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803568:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80356c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803570:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803574:	0f b6 12             	movzbl (%rdx),%edx
  803577:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357d:	0f b6 00             	movzbl (%rax),%eax
  803580:	84 c0                	test   %al,%al
  803582:	74 05                	je     803589 <strncpy+0x4b>
			src++;
  803584:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80358e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803592:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803596:	72 cc                	jb     803564 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80359c:	c9                   	leaveq 
  80359d:	c3                   	retq   

000000000080359e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80359e:	55                   	push   %rbp
  80359f:	48 89 e5             	mov    %rsp,%rbp
  8035a2:	48 83 ec 28          	sub    $0x28,%rsp
  8035a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8035b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8035ba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035bf:	74 3d                	je     8035fe <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8035c1:	eb 1d                	jmp    8035e0 <strlcpy+0x42>
			*dst++ = *src++;
  8035c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035d3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8035d7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8035db:	0f b6 12             	movzbl (%rdx),%edx
  8035de:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8035e0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8035e5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035ea:	74 0b                	je     8035f7 <strlcpy+0x59>
  8035ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f0:	0f b6 00             	movzbl (%rax),%eax
  8035f3:	84 c0                	test   %al,%al
  8035f5:	75 cc                	jne    8035c3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8035f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8035fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803606:	48 29 c2             	sub    %rax,%rdx
  803609:	48 89 d0             	mov    %rdx,%rax
}
  80360c:	c9                   	leaveq 
  80360d:	c3                   	retq   

000000000080360e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80360e:	55                   	push   %rbp
  80360f:	48 89 e5             	mov    %rsp,%rbp
  803612:	48 83 ec 10          	sub    $0x10,%rsp
  803616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80361a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80361e:	eb 0a                	jmp    80362a <strcmp+0x1c>
		p++, q++;
  803620:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803625:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80362a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362e:	0f b6 00             	movzbl (%rax),%eax
  803631:	84 c0                	test   %al,%al
  803633:	74 12                	je     803647 <strcmp+0x39>
  803635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803639:	0f b6 10             	movzbl (%rax),%edx
  80363c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803640:	0f b6 00             	movzbl (%rax),%eax
  803643:	38 c2                	cmp    %al,%dl
  803645:	74 d9                	je     803620 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364b:	0f b6 00             	movzbl (%rax),%eax
  80364e:	0f b6 d0             	movzbl %al,%edx
  803651:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803655:	0f b6 00             	movzbl (%rax),%eax
  803658:	0f b6 c0             	movzbl %al,%eax
  80365b:	29 c2                	sub    %eax,%edx
  80365d:	89 d0                	mov    %edx,%eax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 18          	sub    $0x18,%rsp
  803669:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80366d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803671:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  803675:	eb 0f                	jmp    803686 <strncmp+0x25>
		n--, p++, q++;
  803677:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80367c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803681:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  803686:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80368b:	74 1d                	je     8036aa <strncmp+0x49>
  80368d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803691:	0f b6 00             	movzbl (%rax),%eax
  803694:	84 c0                	test   %al,%al
  803696:	74 12                	je     8036aa <strncmp+0x49>
  803698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369c:	0f b6 10             	movzbl (%rax),%edx
  80369f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a3:	0f b6 00             	movzbl (%rax),%eax
  8036a6:	38 c2                	cmp    %al,%dl
  8036a8:	74 cd                	je     803677 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8036aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036af:	75 07                	jne    8036b8 <strncmp+0x57>
		return 0;
  8036b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b6:	eb 18                	jmp    8036d0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8036b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bc:	0f b6 00             	movzbl (%rax),%eax
  8036bf:	0f b6 d0             	movzbl %al,%edx
  8036c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c6:	0f b6 00             	movzbl (%rax),%eax
  8036c9:	0f b6 c0             	movzbl %al,%eax
  8036cc:	29 c2                	sub    %eax,%edx
  8036ce:	89 d0                	mov    %edx,%eax
}
  8036d0:	c9                   	leaveq 
  8036d1:	c3                   	retq   

00000000008036d2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8036d2:	55                   	push   %rbp
  8036d3:	48 89 e5             	mov    %rsp,%rbp
  8036d6:	48 83 ec 0c          	sub    $0xc,%rsp
  8036da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036de:	89 f0                	mov    %esi,%eax
  8036e0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8036e3:	eb 17                	jmp    8036fc <strchr+0x2a>
		if (*s == c)
  8036e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e9:	0f b6 00             	movzbl (%rax),%eax
  8036ec:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8036ef:	75 06                	jne    8036f7 <strchr+0x25>
			return (char *) s;
  8036f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f5:	eb 15                	jmp    80370c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8036f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803700:	0f b6 00             	movzbl (%rax),%eax
  803703:	84 c0                	test   %al,%al
  803705:	75 de                	jne    8036e5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80370c:	c9                   	leaveq 
  80370d:	c3                   	retq   

000000000080370e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80370e:	55                   	push   %rbp
  80370f:	48 89 e5             	mov    %rsp,%rbp
  803712:	48 83 ec 0c          	sub    $0xc,%rsp
  803716:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371a:	89 f0                	mov    %esi,%eax
  80371c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80371f:	eb 13                	jmp    803734 <strfind+0x26>
		if (*s == c)
  803721:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803725:	0f b6 00             	movzbl (%rax),%eax
  803728:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80372b:	75 02                	jne    80372f <strfind+0x21>
			break;
  80372d:	eb 10                	jmp    80373f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80372f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803738:	0f b6 00             	movzbl (%rax),%eax
  80373b:	84 c0                	test   %al,%al
  80373d:	75 e2                	jne    803721 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80373f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803743:	c9                   	leaveq 
  803744:	c3                   	retq   

0000000000803745 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 18          	sub    $0x18,%rsp
  80374d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803751:	89 75 f4             	mov    %esi,-0xc(%rbp)
  803754:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803758:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80375d:	75 06                	jne    803765 <memset+0x20>
		return v;
  80375f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803763:	eb 69                	jmp    8037ce <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  803765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803769:	83 e0 03             	and    $0x3,%eax
  80376c:	48 85 c0             	test   %rax,%rax
  80376f:	75 48                	jne    8037b9 <memset+0x74>
  803771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803775:	83 e0 03             	and    $0x3,%eax
  803778:	48 85 c0             	test   %rax,%rax
  80377b:	75 3c                	jne    8037b9 <memset+0x74>
		c &= 0xFF;
  80377d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  803784:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803787:	c1 e0 18             	shl    $0x18,%eax
  80378a:	89 c2                	mov    %eax,%edx
  80378c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80378f:	c1 e0 10             	shl    $0x10,%eax
  803792:	09 c2                	or     %eax,%edx
  803794:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803797:	c1 e0 08             	shl    $0x8,%eax
  80379a:	09 d0                	or     %edx,%eax
  80379c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80379f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a3:	48 c1 e8 02          	shr    $0x2,%rax
  8037a7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8037aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b1:	48 89 d7             	mov    %rdx,%rdi
  8037b4:	fc                   	cld    
  8037b5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8037b7:	eb 11                	jmp    8037ca <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8037b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037c4:	48 89 d7             	mov    %rdx,%rdi
  8037c7:	fc                   	cld    
  8037c8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8037ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037ce:	c9                   	leaveq 
  8037cf:	c3                   	retq   

00000000008037d0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8037d0:	55                   	push   %rbp
  8037d1:	48 89 e5             	mov    %rsp,%rbp
  8037d4:	48 83 ec 28          	sub    $0x28,%rsp
  8037d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8037e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8037ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8037f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8037fc:	0f 83 88 00 00 00    	jae    80388a <memmove+0xba>
  803802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803806:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80380a:	48 01 d0             	add    %rdx,%rax
  80380d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803811:	76 77                	jbe    80388a <memmove+0xba>
		s += n;
  803813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803817:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80381b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803827:	83 e0 03             	and    $0x3,%eax
  80382a:	48 85 c0             	test   %rax,%rax
  80382d:	75 3b                	jne    80386a <memmove+0x9a>
  80382f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803833:	83 e0 03             	and    $0x3,%eax
  803836:	48 85 c0             	test   %rax,%rax
  803839:	75 2f                	jne    80386a <memmove+0x9a>
  80383b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383f:	83 e0 03             	and    $0x3,%eax
  803842:	48 85 c0             	test   %rax,%rax
  803845:	75 23                	jne    80386a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384b:	48 83 e8 04          	sub    $0x4,%rax
  80384f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803853:	48 83 ea 04          	sub    $0x4,%rdx
  803857:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80385b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80385f:	48 89 c7             	mov    %rax,%rdi
  803862:	48 89 d6             	mov    %rdx,%rsi
  803865:	fd                   	std    
  803866:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803868:	eb 1d                	jmp    803887 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80386a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803876:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80387a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387e:	48 89 d7             	mov    %rdx,%rdi
  803881:	48 89 c1             	mov    %rax,%rcx
  803884:	fd                   	std    
  803885:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803887:	fc                   	cld    
  803888:	eb 57                	jmp    8038e1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80388a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388e:	83 e0 03             	and    $0x3,%eax
  803891:	48 85 c0             	test   %rax,%rax
  803894:	75 36                	jne    8038cc <memmove+0xfc>
  803896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389a:	83 e0 03             	and    $0x3,%eax
  80389d:	48 85 c0             	test   %rax,%rax
  8038a0:	75 2a                	jne    8038cc <memmove+0xfc>
  8038a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a6:	83 e0 03             	and    $0x3,%eax
  8038a9:	48 85 c0             	test   %rax,%rax
  8038ac:	75 1e                	jne    8038cc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8038ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b2:	48 c1 e8 02          	shr    $0x2,%rax
  8038b6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8038b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038c1:	48 89 c7             	mov    %rax,%rdi
  8038c4:	48 89 d6             	mov    %rdx,%rsi
  8038c7:	fc                   	cld    
  8038c8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038ca:	eb 15                	jmp    8038e1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8038cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038d8:	48 89 c7             	mov    %rax,%rdi
  8038db:	48 89 d6             	mov    %rdx,%rsi
  8038de:	fc                   	cld    
  8038df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8038e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8038e5:	c9                   	leaveq 
  8038e6:	c3                   	retq   

00000000008038e7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8038e7:	55                   	push   %rbp
  8038e8:	48 89 e5             	mov    %rsp,%rbp
  8038eb:	48 83 ec 18          	sub    $0x18,%rsp
  8038ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8038fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038ff:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803903:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803907:	48 89 ce             	mov    %rcx,%rsi
  80390a:	48 89 c7             	mov    %rax,%rdi
  80390d:	48 b8 d0 37 80 00 00 	movabs $0x8037d0,%rax
  803914:	00 00 00 
  803917:	ff d0                	callq  *%rax
}
  803919:	c9                   	leaveq 
  80391a:	c3                   	retq   

000000000080391b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80391b:	55                   	push   %rbp
  80391c:	48 89 e5             	mov    %rsp,%rbp
  80391f:	48 83 ec 28          	sub    $0x28,%rsp
  803923:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803927:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80392b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80392f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803933:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80393f:	eb 36                	jmp    803977 <memcmp+0x5c>
		if (*s1 != *s2)
  803941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803945:	0f b6 10             	movzbl (%rax),%edx
  803948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394c:	0f b6 00             	movzbl (%rax),%eax
  80394f:	38 c2                	cmp    %al,%dl
  803951:	74 1a                	je     80396d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803953:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803957:	0f b6 00             	movzbl (%rax),%eax
  80395a:	0f b6 d0             	movzbl %al,%edx
  80395d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803961:	0f b6 00             	movzbl (%rax),%eax
  803964:	0f b6 c0             	movzbl %al,%eax
  803967:	29 c2                	sub    %eax,%edx
  803969:	89 d0                	mov    %edx,%eax
  80396b:	eb 20                	jmp    80398d <memcmp+0x72>
		s1++, s2++;
  80396d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803972:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80397b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80397f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803983:	48 85 c0             	test   %rax,%rax
  803986:	75 b9                	jne    803941 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80398d:	c9                   	leaveq 
  80398e:	c3                   	retq   

000000000080398f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80398f:	55                   	push   %rbp
  803990:	48 89 e5             	mov    %rsp,%rbp
  803993:	48 83 ec 28          	sub    $0x28,%rsp
  803997:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80399b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80399e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8039a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039aa:	48 01 d0             	add    %rdx,%rax
  8039ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8039b1:	eb 15                	jmp    8039c8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8039b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b7:	0f b6 10             	movzbl (%rax),%edx
  8039ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8039bd:	38 c2                	cmp    %al,%dl
  8039bf:	75 02                	jne    8039c3 <memfind+0x34>
			break;
  8039c1:	eb 0f                	jmp    8039d2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8039c3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8039c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039cc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8039d0:	72 e1                	jb     8039b3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8039d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8039d6:	c9                   	leaveq 
  8039d7:	c3                   	retq   

00000000008039d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8039d8:	55                   	push   %rbp
  8039d9:	48 89 e5             	mov    %rsp,%rbp
  8039dc:	48 83 ec 34          	sub    $0x34,%rsp
  8039e0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039e8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8039eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8039f2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8039f9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8039fa:	eb 05                	jmp    803a01 <strtol+0x29>
		s++;
  8039fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a05:	0f b6 00             	movzbl (%rax),%eax
  803a08:	3c 20                	cmp    $0x20,%al
  803a0a:	74 f0                	je     8039fc <strtol+0x24>
  803a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a10:	0f b6 00             	movzbl (%rax),%eax
  803a13:	3c 09                	cmp    $0x9,%al
  803a15:	74 e5                	je     8039fc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1b:	0f b6 00             	movzbl (%rax),%eax
  803a1e:	3c 2b                	cmp    $0x2b,%al
  803a20:	75 07                	jne    803a29 <strtol+0x51>
		s++;
  803a22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a27:	eb 17                	jmp    803a40 <strtol+0x68>
	else if (*s == '-')
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	0f b6 00             	movzbl (%rax),%eax
  803a30:	3c 2d                	cmp    $0x2d,%al
  803a32:	75 0c                	jne    803a40 <strtol+0x68>
		s++, neg = 1;
  803a34:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803a40:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a44:	74 06                	je     803a4c <strtol+0x74>
  803a46:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803a4a:	75 28                	jne    803a74 <strtol+0x9c>
  803a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a50:	0f b6 00             	movzbl (%rax),%eax
  803a53:	3c 30                	cmp    $0x30,%al
  803a55:	75 1d                	jne    803a74 <strtol+0x9c>
  803a57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5b:	48 83 c0 01          	add    $0x1,%rax
  803a5f:	0f b6 00             	movzbl (%rax),%eax
  803a62:	3c 78                	cmp    $0x78,%al
  803a64:	75 0e                	jne    803a74 <strtol+0x9c>
		s += 2, base = 16;
  803a66:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803a6b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803a72:	eb 2c                	jmp    803aa0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803a74:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a78:	75 19                	jne    803a93 <strtol+0xbb>
  803a7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a7e:	0f b6 00             	movzbl (%rax),%eax
  803a81:	3c 30                	cmp    $0x30,%al
  803a83:	75 0e                	jne    803a93 <strtol+0xbb>
		s++, base = 8;
  803a85:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a8a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803a91:	eb 0d                	jmp    803aa0 <strtol+0xc8>
	else if (base == 0)
  803a93:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a97:	75 07                	jne    803aa0 <strtol+0xc8>
		base = 10;
  803a99:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa4:	0f b6 00             	movzbl (%rax),%eax
  803aa7:	3c 2f                	cmp    $0x2f,%al
  803aa9:	7e 1d                	jle    803ac8 <strtol+0xf0>
  803aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aaf:	0f b6 00             	movzbl (%rax),%eax
  803ab2:	3c 39                	cmp    $0x39,%al
  803ab4:	7f 12                	jg     803ac8 <strtol+0xf0>
			dig = *s - '0';
  803ab6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aba:	0f b6 00             	movzbl (%rax),%eax
  803abd:	0f be c0             	movsbl %al,%eax
  803ac0:	83 e8 30             	sub    $0x30,%eax
  803ac3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac6:	eb 4e                	jmp    803b16 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803ac8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803acc:	0f b6 00             	movzbl (%rax),%eax
  803acf:	3c 60                	cmp    $0x60,%al
  803ad1:	7e 1d                	jle    803af0 <strtol+0x118>
  803ad3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad7:	0f b6 00             	movzbl (%rax),%eax
  803ada:	3c 7a                	cmp    $0x7a,%al
  803adc:	7f 12                	jg     803af0 <strtol+0x118>
			dig = *s - 'a' + 10;
  803ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae2:	0f b6 00             	movzbl (%rax),%eax
  803ae5:	0f be c0             	movsbl %al,%eax
  803ae8:	83 e8 57             	sub    $0x57,%eax
  803aeb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aee:	eb 26                	jmp    803b16 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803af0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af4:	0f b6 00             	movzbl (%rax),%eax
  803af7:	3c 40                	cmp    $0x40,%al
  803af9:	7e 48                	jle    803b43 <strtol+0x16b>
  803afb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aff:	0f b6 00             	movzbl (%rax),%eax
  803b02:	3c 5a                	cmp    $0x5a,%al
  803b04:	7f 3d                	jg     803b43 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0a:	0f b6 00             	movzbl (%rax),%eax
  803b0d:	0f be c0             	movsbl %al,%eax
  803b10:	83 e8 37             	sub    $0x37,%eax
  803b13:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803b16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b19:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803b1c:	7c 02                	jl     803b20 <strtol+0x148>
			break;
  803b1e:	eb 23                	jmp    803b43 <strtol+0x16b>
		s++, val = (val * base) + dig;
  803b20:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b25:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b28:	48 98                	cltq   
  803b2a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803b2f:	48 89 c2             	mov    %rax,%rdx
  803b32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b35:	48 98                	cltq   
  803b37:	48 01 d0             	add    %rdx,%rax
  803b3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803b3e:	e9 5d ff ff ff       	jmpq   803aa0 <strtol+0xc8>

	if (endptr)
  803b43:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803b48:	74 0b                	je     803b55 <strtol+0x17d>
		*endptr = (char *) s;
  803b4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b52:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803b55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b59:	74 09                	je     803b64 <strtol+0x18c>
  803b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5f:	48 f7 d8             	neg    %rax
  803b62:	eb 04                	jmp    803b68 <strtol+0x190>
  803b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803b68:	c9                   	leaveq 
  803b69:	c3                   	retq   

0000000000803b6a <strstr>:

char * strstr(const char *in, const char *str)
{
  803b6a:	55                   	push   %rbp
  803b6b:	48 89 e5             	mov    %rsp,%rbp
  803b6e:	48 83 ec 30          	sub    $0x30,%rsp
  803b72:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803b7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b82:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803b86:	0f b6 00             	movzbl (%rax),%eax
  803b89:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803b8c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803b90:	75 06                	jne    803b98 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803b92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b96:	eb 6b                	jmp    803c03 <strstr+0x99>

	len = strlen(str);
  803b98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b9c:	48 89 c7             	mov    %rax,%rdi
  803b9f:	48 b8 40 34 80 00 00 	movabs $0x803440,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
  803bab:	48 98                	cltq   
  803bad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803bb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803bbd:	0f b6 00             	movzbl (%rax),%eax
  803bc0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803bc3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803bc7:	75 07                	jne    803bd0 <strstr+0x66>
				return (char *) 0;
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	eb 33                	jmp    803c03 <strstr+0x99>
		} while (sc != c);
  803bd0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803bd4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803bd7:	75 d8                	jne    803bb1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803bd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bdd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be5:	48 89 ce             	mov    %rcx,%rsi
  803be8:	48 89 c7             	mov    %rax,%rdi
  803beb:	48 b8 61 36 80 00 00 	movabs $0x803661,%rax
  803bf2:	00 00 00 
  803bf5:	ff d0                	callq  *%rax
  803bf7:	85 c0                	test   %eax,%eax
  803bf9:	75 b6                	jne    803bb1 <strstr+0x47>

	return (char *) (in - 1);
  803bfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bff:	48 83 e8 01          	sub    $0x1,%rax
}
  803c03:	c9                   	leaveq 
  803c04:	c3                   	retq   

0000000000803c05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c05:	55                   	push   %rbp
  803c06:	48 89 e5             	mov    %rsp,%rbp
  803c09:	48 83 ec 30          	sub    $0x30,%rsp
  803c0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c15:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c19:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c20:	00 00 00 
  803c23:	48 8b 00             	mov    (%rax),%rax
  803c26:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c2c:	85 c0                	test   %eax,%eax
  803c2e:	75 3c                	jne    803c6c <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c30:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
  803c3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c41:	48 63 d0             	movslq %eax,%rdx
  803c44:	48 89 d0             	mov    %rdx,%rax
  803c47:	48 c1 e0 03          	shl    $0x3,%rax
  803c4b:	48 01 d0             	add    %rdx,%rax
  803c4e:	48 c1 e0 05          	shl    $0x5,%rax
  803c52:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c59:	00 00 00 
  803c5c:	48 01 c2             	add    %rax,%rdx
  803c5f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c66:	00 00 00 
  803c69:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c71:	75 0e                	jne    803c81 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c73:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c7a:	00 00 00 
  803c7d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c85:	48 89 c7             	mov    %rax,%rdi
  803c88:	48 b8 24 05 80 00 00 	movabs $0x800524,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9b:	79 19                	jns    803cb6 <ipc_recv+0xb1>
		*from_env_store = 0;
  803c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ca7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cab:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb4:	eb 53                	jmp    803d09 <ipc_recv+0x104>
	}
	if(from_env_store)
  803cb6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cbb:	74 19                	je     803cd6 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803cbd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cc4:	00 00 00 
  803cc7:	48 8b 00             	mov    (%rax),%rax
  803cca:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd4:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cd6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cdb:	74 19                	je     803cf6 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cdd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ce4:	00 00 00 
  803ce7:	48 8b 00             	mov    (%rax),%rax
  803cea:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803cf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803cf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cfd:	00 00 00 
  803d00:	48 8b 00             	mov    (%rax),%rax
  803d03:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d09:	c9                   	leaveq 
  803d0a:	c3                   	retq   

0000000000803d0b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 30          	sub    $0x30,%rsp
  803d13:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d16:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d19:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d1d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d20:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d25:	75 0e                	jne    803d35 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d27:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d2e:	00 00 00 
  803d31:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d35:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d38:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d3b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d42:	89 c7                	mov    %eax,%edi
  803d44:	48 b8 cf 04 80 00 00 	movabs $0x8004cf,%rax
  803d4b:	00 00 00 
  803d4e:	ff d0                	callq  *%rax
  803d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d53:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d57:	75 0c                	jne    803d65 <ipc_send+0x5a>
			sys_yield();
  803d59:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  803d60:	00 00 00 
  803d63:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d65:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d69:	74 ca                	je     803d35 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d6b:	c9                   	leaveq 
  803d6c:	c3                   	retq   

0000000000803d6d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d6d:	55                   	push   %rbp
  803d6e:	48 89 e5             	mov    %rsp,%rbp
  803d71:	48 83 ec 14          	sub    $0x14,%rsp
  803d75:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d7f:	eb 5e                	jmp    803ddf <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d81:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d88:	00 00 00 
  803d8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8e:	48 63 d0             	movslq %eax,%rdx
  803d91:	48 89 d0             	mov    %rdx,%rax
  803d94:	48 c1 e0 03          	shl    $0x3,%rax
  803d98:	48 01 d0             	add    %rdx,%rax
  803d9b:	48 c1 e0 05          	shl    $0x5,%rax
  803d9f:	48 01 c8             	add    %rcx,%rax
  803da2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803da8:	8b 00                	mov    (%rax),%eax
  803daa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dad:	75 2c                	jne    803ddb <ipc_find_env+0x6e>
			return envs[i].env_id;
  803daf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803db6:	00 00 00 
  803db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbc:	48 63 d0             	movslq %eax,%rdx
  803dbf:	48 89 d0             	mov    %rdx,%rax
  803dc2:	48 c1 e0 03          	shl    $0x3,%rax
  803dc6:	48 01 d0             	add    %rdx,%rax
  803dc9:	48 c1 e0 05          	shl    $0x5,%rax
  803dcd:	48 01 c8             	add    %rcx,%rax
  803dd0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803dd6:	8b 40 08             	mov    0x8(%rax),%eax
  803dd9:	eb 12                	jmp    803ded <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ddb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ddf:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803de6:	7e 99                	jle    803d81 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ded:	c9                   	leaveq 
  803dee:	c3                   	retq   

0000000000803def <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803def:	55                   	push   %rbp
  803df0:	48 89 e5             	mov    %rsp,%rbp
  803df3:	48 83 ec 18          	sub    $0x18,%rsp
  803df7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dff:	48 c1 e8 15          	shr    $0x15,%rax
  803e03:	48 89 c2             	mov    %rax,%rdx
  803e06:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e0d:	01 00 00 
  803e10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e14:	83 e0 01             	and    $0x1,%eax
  803e17:	48 85 c0             	test   %rax,%rax
  803e1a:	75 07                	jne    803e23 <pageref+0x34>
		return 0;
  803e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e21:	eb 53                	jmp    803e76 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e27:	48 c1 e8 0c          	shr    $0xc,%rax
  803e2b:	48 89 c2             	mov    %rax,%rdx
  803e2e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e35:	01 00 00 
  803e38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e44:	83 e0 01             	and    $0x1,%eax
  803e47:	48 85 c0             	test   %rax,%rax
  803e4a:	75 07                	jne    803e53 <pageref+0x64>
		return 0;
  803e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e51:	eb 23                	jmp    803e76 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e57:	48 c1 e8 0c          	shr    $0xc,%rax
  803e5b:	48 89 c2             	mov    %rax,%rdx
  803e5e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e65:	00 00 00 
  803e68:	48 c1 e2 04          	shl    $0x4,%rdx
  803e6c:	48 01 d0             	add    %rdx,%rax
  803e6f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e73:	0f b7 c0             	movzwl %ax,%eax
}
  803e76:	c9                   	leaveq 
  803e77:	c3                   	retq   
