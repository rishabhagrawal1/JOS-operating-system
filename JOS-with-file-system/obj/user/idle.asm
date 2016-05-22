
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
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba e0 33 80 00 00 	movabs $0x8033e0,%rdx
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
  8000b5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
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
  8000cf:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
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
  800106:	48 b8 a9 08 80 00 00 	movabs $0x8008a9,%rax
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
  80017d:	48 ba ef 33 80 00 00 	movabs $0x8033ef,%rdx
  800184:	00 00 00 
  800187:	be 23 00 00 00       	mov    $0x23,%esi
  80018c:	48 bf 0c 34 80 00 00 	movabs $0x80340c,%rdi
  800193:	00 00 00 
  800196:	b8 00 00 00 00       	mov    $0x0,%eax
  80019b:	49 b9 0d 1c 80 00 00 	movabs $0x801c0d,%r9
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

0000000000800568 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800568:	55                   	push   %rbp
  800569:	48 89 e5             	mov    %rsp,%rbp
  80056c:	48 83 ec 08          	sub    $0x8,%rsp
  800570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800574:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800578:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80057f:	ff ff ff 
  800582:	48 01 d0             	add    %rdx,%rax
  800585:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800589:	c9                   	leaveq 
  80058a:	c3                   	retq   

000000000080058b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80058b:	55                   	push   %rbp
  80058c:	48 89 e5             	mov    %rsp,%rbp
  80058f:	48 83 ec 08          	sub    $0x8,%rsp
  800593:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800597:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80059b:	48 89 c7             	mov    %rax,%rdi
  80059e:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  8005a5:	00 00 00 
  8005a8:	ff d0                	callq  *%rax
  8005aa:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005b0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005b4:	c9                   	leaveq 
  8005b5:	c3                   	retq   

00000000008005b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005b6:	55                   	push   %rbp
  8005b7:	48 89 e5             	mov    %rsp,%rbp
  8005ba:	48 83 ec 18          	sub    $0x18,%rsp
  8005be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005c9:	eb 6b                	jmp    800636 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ce:	48 98                	cltq   
  8005d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8005da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e2:	48 c1 e8 15          	shr    $0x15,%rax
  8005e6:	48 89 c2             	mov    %rax,%rdx
  8005e9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005f0:	01 00 00 
  8005f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005f7:	83 e0 01             	and    $0x1,%eax
  8005fa:	48 85 c0             	test   %rax,%rax
  8005fd:	74 21                	je     800620 <fd_alloc+0x6a>
  8005ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800603:	48 c1 e8 0c          	shr    $0xc,%rax
  800607:	48 89 c2             	mov    %rax,%rdx
  80060a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800611:	01 00 00 
  800614:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800618:	83 e0 01             	and    $0x1,%eax
  80061b:	48 85 c0             	test   %rax,%rax
  80061e:	75 12                	jne    800632 <fd_alloc+0x7c>
			*fd_store = fd;
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800628:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	eb 1a                	jmp    80064c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800632:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800636:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80063a:	7e 8f                	jle    8005cb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800647:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80064c:	c9                   	leaveq 
  80064d:	c3                   	retq   

000000000080064e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80064e:	55                   	push   %rbp
  80064f:	48 89 e5             	mov    %rsp,%rbp
  800652:	48 83 ec 20          	sub    $0x20,%rsp
  800656:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800659:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80065d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800661:	78 06                	js     800669 <fd_lookup+0x1b>
  800663:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800667:	7e 07                	jle    800670 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800669:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80066e:	eb 6c                	jmp    8006dc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800670:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800673:	48 98                	cltq   
  800675:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80067b:	48 c1 e0 0c          	shl    $0xc,%rax
  80067f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800687:	48 c1 e8 15          	shr    $0x15,%rax
  80068b:	48 89 c2             	mov    %rax,%rdx
  80068e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800695:	01 00 00 
  800698:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80069c:	83 e0 01             	and    $0x1,%eax
  80069f:	48 85 c0             	test   %rax,%rax
  8006a2:	74 21                	je     8006c5 <fd_lookup+0x77>
  8006a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a8:	48 c1 e8 0c          	shr    $0xc,%rax
  8006ac:	48 89 c2             	mov    %rax,%rdx
  8006af:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006b6:	01 00 00 
  8006b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006bd:	83 e0 01             	and    $0x1,%eax
  8006c0:	48 85 c0             	test   %rax,%rax
  8006c3:	75 07                	jne    8006cc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ca:	eb 10                	jmp    8006dc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006d4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006dc:	c9                   	leaveq 
  8006dd:	c3                   	retq   

00000000008006de <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006de:	55                   	push   %rbp
  8006df:	48 89 e5             	mov    %rsp,%rbp
  8006e2:	48 83 ec 30          	sub    $0x30,%rsp
  8006e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006ea:	89 f0                	mov    %esi,%eax
  8006ec:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f3:	48 89 c7             	mov    %rax,%rdi
  8006f6:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  8006fd:	00 00 00 
  800700:	ff d0                	callq  *%rax
  800702:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800706:	48 89 d6             	mov    %rdx,%rsi
  800709:	89 c7                	mov    %eax,%edi
  80070b:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800712:	00 00 00 
  800715:	ff d0                	callq  *%rax
  800717:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80071a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80071e:	78 0a                	js     80072a <fd_close+0x4c>
	    || fd != fd2)
  800720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800724:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800728:	74 12                	je     80073c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80072a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80072e:	74 05                	je     800735 <fd_close+0x57>
  800730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800733:	eb 05                	jmp    80073a <fd_close+0x5c>
  800735:	b8 00 00 00 00       	mov    $0x0,%eax
  80073a:	eb 69                	jmp    8007a5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80073c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800746:	48 89 d6             	mov    %rdx,%rsi
  800749:	89 c7                	mov    %eax,%edi
  80074b:	48 b8 a7 07 80 00 00 	movabs $0x8007a7,%rax
  800752:	00 00 00 
  800755:	ff d0                	callq  *%rax
  800757:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80075a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80075e:	78 2a                	js     80078a <fd_close+0xac>
		if (dev->dev_close)
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 40 20          	mov    0x20(%rax),%rax
  800768:	48 85 c0             	test   %rax,%rax
  80076b:	74 16                	je     800783 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	48 8b 40 20          	mov    0x20(%rax),%rax
  800775:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800779:	48 89 d7             	mov    %rdx,%rdi
  80077c:	ff d0                	callq  *%rax
  80077e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800781:	eb 07                	jmp    80078a <fd_close+0xac>
		else
			r = 0;
  800783:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80078a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80078e:	48 89 c6             	mov    %rax,%rsi
  800791:	bf 00 00 00 00       	mov    $0x0,%edi
  800796:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  80079d:	00 00 00 
  8007a0:	ff d0                	callq  *%rax
	return r;
  8007a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007a5:	c9                   	leaveq 
  8007a6:	c3                   	retq   

00000000008007a7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007a7:	55                   	push   %rbp
  8007a8:	48 89 e5             	mov    %rsp,%rbp
  8007ab:	48 83 ec 20          	sub    $0x20,%rsp
  8007af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007bd:	eb 41                	jmp    800800 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007bf:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007c6:	00 00 00 
  8007c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007cc:	48 63 d2             	movslq %edx,%rdx
  8007cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d3:	8b 00                	mov    (%rax),%eax
  8007d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007d8:	75 22                	jne    8007fc <dev_lookup+0x55>
			*dev = devtab[i];
  8007da:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e1:	00 00 00 
  8007e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007e7:	48 63 d2             	movslq %edx,%rdx
  8007ea:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fa:	eb 60                	jmp    80085c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8007fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800800:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800807:	00 00 00 
  80080a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80080d:	48 63 d2             	movslq %edx,%rdx
  800810:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800814:	48 85 c0             	test   %rax,%rax
  800817:	75 a6                	jne    8007bf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800819:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800820:	00 00 00 
  800823:	48 8b 00             	mov    (%rax),%rax
  800826:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80082c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80082f:	89 c6                	mov    %eax,%esi
  800831:	48 bf 20 34 80 00 00 	movabs $0x803420,%rdi
  800838:	00 00 00 
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	48 b9 46 1e 80 00 00 	movabs $0x801e46,%rcx
  800847:	00 00 00 
  80084a:	ff d1                	callq  *%rcx
	*dev = 0;
  80084c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800850:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80085c:	c9                   	leaveq 
  80085d:	c3                   	retq   

000000000080085e <close>:

int
close(int fdnum)
{
  80085e:	55                   	push   %rbp
  80085f:	48 89 e5             	mov    %rsp,%rbp
  800862:	48 83 ec 20          	sub    $0x20,%rsp
  800866:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800869:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80086d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800870:	48 89 d6             	mov    %rdx,%rsi
  800873:	89 c7                	mov    %eax,%edi
  800875:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  80087c:	00 00 00 
  80087f:	ff d0                	callq  *%rax
  800881:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800888:	79 05                	jns    80088f <close+0x31>
		return r;
  80088a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80088d:	eb 18                	jmp    8008a7 <close+0x49>
	else
		return fd_close(fd, 1);
  80088f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800893:	be 01 00 00 00       	mov    $0x1,%esi
  800898:	48 89 c7             	mov    %rax,%rdi
  80089b:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  8008a2:	00 00 00 
  8008a5:	ff d0                	callq  *%rax
}
  8008a7:	c9                   	leaveq 
  8008a8:	c3                   	retq   

00000000008008a9 <close_all>:

void
close_all(void)
{
  8008a9:	55                   	push   %rbp
  8008aa:	48 89 e5             	mov    %rsp,%rbp
  8008ad:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008b8:	eb 15                	jmp    8008cf <close_all+0x26>
		close(i);
  8008ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008bd:	89 c7                	mov    %eax,%edi
  8008bf:	48 b8 5e 08 80 00 00 	movabs $0x80085e,%rax
  8008c6:	00 00 00 
  8008c9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008cf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d3:	7e e5                	jle    8008ba <close_all+0x11>
		close(i);
}
  8008d5:	c9                   	leaveq 
  8008d6:	c3                   	retq   

00000000008008d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008d7:	55                   	push   %rbp
  8008d8:	48 89 e5             	mov    %rsp,%rbp
  8008db:	48 83 ec 40          	sub    $0x40,%rsp
  8008df:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008e5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008e9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008ec:	48 89 d6             	mov    %rdx,%rsi
  8008ef:	89 c7                	mov    %eax,%edi
  8008f1:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  8008f8:	00 00 00 
  8008fb:	ff d0                	callq  *%rax
  8008fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800900:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800904:	79 08                	jns    80090e <dup+0x37>
		return r;
  800906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800909:	e9 70 01 00 00       	jmpq   800a7e <dup+0x1a7>
	close(newfdnum);
  80090e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800911:	89 c7                	mov    %eax,%edi
  800913:	48 b8 5e 08 80 00 00 	movabs $0x80085e,%rax
  80091a:	00 00 00 
  80091d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80091f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800922:	48 98                	cltq   
  800924:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80092a:	48 c1 e0 0c          	shl    $0xc,%rax
  80092e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800932:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800936:	48 89 c7             	mov    %rax,%rdi
  800939:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  800940:	00 00 00 
  800943:	ff d0                	callq  *%rax
  800945:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800949:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80094d:	48 89 c7             	mov    %rax,%rdi
  800950:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  800957:	00 00 00 
  80095a:	ff d0                	callq  *%rax
  80095c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	48 c1 e8 15          	shr    $0x15,%rax
  800968:	48 89 c2             	mov    %rax,%rdx
  80096b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800972:	01 00 00 
  800975:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800979:	83 e0 01             	and    $0x1,%eax
  80097c:	48 85 c0             	test   %rax,%rax
  80097f:	74 73                	je     8009f4 <dup+0x11d>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 c1 e8 0c          	shr    $0xc,%rax
  800989:	48 89 c2             	mov    %rax,%rdx
  80098c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800993:	01 00 00 
  800996:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80099a:	83 e0 01             	and    $0x1,%eax
  80099d:	48 85 c0             	test   %rax,%rax
  8009a0:	74 52                	je     8009f4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8009aa:	48 89 c2             	mov    %rax,%rdx
  8009ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b4:	01 00 00 
  8009b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	41 89 c8             	mov    %ecx,%r8d
  8009cd:	48 89 d1             	mov    %rdx,%rcx
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	48 89 c6             	mov    %rax,%rsi
  8009d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8009dd:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  8009e4:	00 00 00 
  8009e7:	ff d0                	callq  *%rax
  8009e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009f0:	79 02                	jns    8009f4 <dup+0x11d>
			goto err;
  8009f2:	eb 57                	jmp    800a4b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8009fc:	48 89 c2             	mov    %rax,%rdx
  8009ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a06:	01 00 00 
  800a09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a0d:	25 07 0e 00 00       	and    $0xe07,%eax
  800a12:	89 c1                	mov    %eax,%ecx
  800a14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a1c:	41 89 c8             	mov    %ecx,%r8d
  800a1f:	48 89 d1             	mov    %rdx,%rcx
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
  800a27:	48 89 c6             	mov    %rax,%rsi
  800a2a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2f:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  800a36:	00 00 00 
  800a39:	ff d0                	callq  *%rax
  800a3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a42:	79 02                	jns    800a46 <dup+0x16f>
		goto err;
  800a44:	eb 05                	jmp    800a4b <dup+0x174>

	return newfdnum;
  800a46:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a49:	eb 33                	jmp    800a7e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a4f:	48 89 c6             	mov    %rax,%rsi
  800a52:	bf 00 00 00 00       	mov    $0x0,%edi
  800a57:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800a5e:	00 00 00 
  800a61:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a67:	48 89 c6             	mov    %rax,%rsi
  800a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6f:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  800a76:	00 00 00 
  800a79:	ff d0                	callq  *%rax
	return r;
  800a7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a7e:	c9                   	leaveq 
  800a7f:	c3                   	retq   

0000000000800a80 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a80:	55                   	push   %rbp
  800a81:	48 89 e5             	mov    %rsp,%rbp
  800a84:	48 83 ec 40          	sub    $0x40,%rsp
  800a88:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a8b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a8f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a93:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a9a:	48 89 d6             	mov    %rdx,%rsi
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
  800aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab2:	78 24                	js     800ad8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	8b 00                	mov    (%rax),%eax
  800aba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800abe:	48 89 d6             	mov    %rdx,%rsi
  800ac1:	89 c7                	mov    %eax,%edi
  800ac3:	48 b8 a7 07 80 00 00 	movabs $0x8007a7,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad6:	79 05                	jns    800add <read+0x5d>
		return r;
  800ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800adb:	eb 76                	jmp    800b53 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae1:	8b 40 08             	mov    0x8(%rax),%eax
  800ae4:	83 e0 03             	and    $0x3,%eax
  800ae7:	83 f8 01             	cmp    $0x1,%eax
  800aea:	75 3a                	jne    800b26 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800aec:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af3:	00 00 00 
  800af6:	48 8b 00             	mov    (%rax),%rax
  800af9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800aff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b02:	89 c6                	mov    %eax,%esi
  800b04:	48 bf 3f 34 80 00 00 	movabs $0x80343f,%rdi
  800b0b:	00 00 00 
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b13:	48 b9 46 1e 80 00 00 	movabs $0x801e46,%rcx
  800b1a:	00 00 00 
  800b1d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b24:	eb 2d                	jmp    800b53 <read+0xd3>
	}
	if (!dev->dev_read)
  800b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2a:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b2e:	48 85 c0             	test   %rax,%rax
  800b31:	75 07                	jne    800b3a <read+0xba>
		return -E_NOT_SUPP;
  800b33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b38:	eb 19                	jmp    800b53 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b42:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b46:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b4e:	48 89 cf             	mov    %rcx,%rdi
  800b51:	ff d0                	callq  *%rax
}
  800b53:	c9                   	leaveq 
  800b54:	c3                   	retq   

0000000000800b55 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b55:	55                   	push   %rbp
  800b56:	48 89 e5             	mov    %rsp,%rbp
  800b59:	48 83 ec 30          	sub    $0x30,%rsp
  800b5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b6f:	eb 49                	jmp    800bba <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b74:	48 98                	cltq   
  800b76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b7a:	48 29 c2             	sub    %rax,%rdx
  800b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b80:	48 63 c8             	movslq %eax,%rcx
  800b83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b87:	48 01 c1             	add    %rax,%rcx
  800b8a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b8d:	48 89 ce             	mov    %rcx,%rsi
  800b90:	89 c7                	mov    %eax,%edi
  800b92:	48 b8 80 0a 80 00 00 	movabs $0x800a80,%rax
  800b99:	00 00 00 
  800b9c:	ff d0                	callq  *%rax
  800b9e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ba1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ba5:	79 05                	jns    800bac <readn+0x57>
			return m;
  800ba7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800baa:	eb 1c                	jmp    800bc8 <readn+0x73>
		if (m == 0)
  800bac:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bb0:	75 02                	jne    800bb4 <readn+0x5f>
			break;
  800bb2:	eb 11                	jmp    800bc5 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb7:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbd:	48 98                	cltq   
  800bbf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc3:	72 ac                	jb     800b71 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bc8:	c9                   	leaveq 
  800bc9:	c3                   	retq   

0000000000800bca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bca:	55                   	push   %rbp
  800bcb:	48 89 e5             	mov    %rsp,%rbp
  800bce:	48 83 ec 40          	sub    $0x40,%rsp
  800bd2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bd5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bd9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bdd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800be1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800be4:	48 89 d6             	mov    %rdx,%rsi
  800be7:	89 c7                	mov    %eax,%edi
  800be9:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800bf0:	00 00 00 
  800bf3:	ff d0                	callq  *%rax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bfc:	78 24                	js     800c22 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c02:	8b 00                	mov    (%rax),%eax
  800c04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c08:	48 89 d6             	mov    %rdx,%rsi
  800c0b:	89 c7                	mov    %eax,%edi
  800c0d:	48 b8 a7 07 80 00 00 	movabs $0x8007a7,%rax
  800c14:	00 00 00 
  800c17:	ff d0                	callq  *%rax
  800c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c20:	79 05                	jns    800c27 <write+0x5d>
		return r;
  800c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c25:	eb 75                	jmp    800c9c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	8b 40 08             	mov    0x8(%rax),%eax
  800c2e:	83 e0 03             	and    $0x3,%eax
  800c31:	85 c0                	test   %eax,%eax
  800c33:	75 3a                	jne    800c6f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c35:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c3c:	00 00 00 
  800c3f:	48 8b 00             	mov    (%rax),%rax
  800c42:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c48:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	48 bf 5b 34 80 00 00 	movabs $0x80345b,%rdi
  800c54:	00 00 00 
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	48 b9 46 1e 80 00 00 	movabs $0x801e46,%rcx
  800c63:	00 00 00 
  800c66:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c6d:	eb 2d                	jmp    800c9c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c73:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c77:	48 85 c0             	test   %rax,%rax
  800c7a:	75 07                	jne    800c83 <write+0xb9>
		return -E_NOT_SUPP;
  800c7c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c81:	eb 19                	jmp    800c9c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c87:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c93:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c97:	48 89 cf             	mov    %rcx,%rdi
  800c9a:	ff d0                	callq  *%rax
}
  800c9c:	c9                   	leaveq 
  800c9d:	c3                   	retq   

0000000000800c9e <seek>:

int
seek(int fdnum, off_t offset)
{
  800c9e:	55                   	push   %rbp
  800c9f:	48 89 e5             	mov    %rsp,%rbp
  800ca2:	48 83 ec 18          	sub    $0x18,%rsp
  800ca6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800ca9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb3:	48 89 d6             	mov    %rdx,%rsi
  800cb6:	89 c7                	mov    %eax,%edi
  800cb8:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800cbf:	00 00 00 
  800cc2:	ff d0                	callq  *%rax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ccb:	79 05                	jns    800cd2 <seek+0x34>
		return r;
  800ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd0:	eb 0f                	jmp    800ce1 <seek+0x43>
	fd->fd_offset = offset;
  800cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cd9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce1:	c9                   	leaveq 
  800ce2:	c3                   	retq   

0000000000800ce3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce3:	55                   	push   %rbp
  800ce4:	48 89 e5             	mov    %rsp,%rbp
  800ce7:	48 83 ec 30          	sub    $0x30,%rsp
  800ceb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cee:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cf5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cf8:	48 89 d6             	mov    %rdx,%rsi
  800cfb:	89 c7                	mov    %eax,%edi
  800cfd:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800d04:	00 00 00 
  800d07:	ff d0                	callq  *%rax
  800d09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d10:	78 24                	js     800d36 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d16:	8b 00                	mov    (%rax),%eax
  800d18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d1c:	48 89 d6             	mov    %rdx,%rsi
  800d1f:	89 c7                	mov    %eax,%edi
  800d21:	48 b8 a7 07 80 00 00 	movabs $0x8007a7,%rax
  800d28:	00 00 00 
  800d2b:	ff d0                	callq  *%rax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d34:	79 05                	jns    800d3b <ftruncate+0x58>
		return r;
  800d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d39:	eb 72                	jmp    800dad <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3f:	8b 40 08             	mov    0x8(%rax),%eax
  800d42:	83 e0 03             	and    $0x3,%eax
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 3a                	jne    800d83 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d49:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d50:	00 00 00 
  800d53:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d56:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d5c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d5f:	89 c6                	mov    %eax,%esi
  800d61:	48 bf 78 34 80 00 00 	movabs $0x803478,%rdi
  800d68:	00 00 00 
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	48 b9 46 1e 80 00 00 	movabs $0x801e46,%rcx
  800d77:	00 00 00 
  800d7a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d81:	eb 2a                	jmp    800dad <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d87:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d8b:	48 85 c0             	test   %rax,%rax
  800d8e:	75 07                	jne    800d97 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d90:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d95:	eb 16                	jmp    800dad <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9b:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800da6:	89 ce                	mov    %ecx,%esi
  800da8:	48 89 d7             	mov    %rdx,%rdi
  800dab:	ff d0                	callq  *%rax
}
  800dad:	c9                   	leaveq 
  800dae:	c3                   	retq   

0000000000800daf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
  800db3:	48 83 ec 30          	sub    $0x30,%rsp
  800db7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dc5:	48 89 d6             	mov    %rdx,%rsi
  800dc8:	89 c7                	mov    %eax,%edi
  800dca:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  800dd1:	00 00 00 
  800dd4:	ff d0                	callq  *%rax
  800dd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ddd:	78 24                	js     800e03 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ddf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de3:	8b 00                	mov    (%rax),%eax
  800de5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800de9:	48 89 d6             	mov    %rdx,%rsi
  800dec:	89 c7                	mov    %eax,%edi
  800dee:	48 b8 a7 07 80 00 00 	movabs $0x8007a7,%rax
  800df5:	00 00 00 
  800df8:	ff d0                	callq  *%rax
  800dfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e01:	79 05                	jns    800e08 <fstat+0x59>
		return r;
  800e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e06:	eb 5e                	jmp    800e66 <fstat+0xb7>
	if (!dev->dev_stat)
  800e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0c:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e10:	48 85 c0             	test   %rax,%rax
  800e13:	75 07                	jne    800e1c <fstat+0x6d>
		return -E_NOT_SUPP;
  800e15:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e1a:	eb 4a                	jmp    800e66 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e20:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e23:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e27:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e2e:	00 00 00 
	stat->st_isdir = 0;
  800e31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e35:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e3c:	00 00 00 
	stat->st_dev = dev;
  800e3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e47:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e5e:	48 89 ce             	mov    %rcx,%rsi
  800e61:	48 89 d7             	mov    %rdx,%rdi
  800e64:	ff d0                	callq  *%rax
}
  800e66:	c9                   	leaveq 
  800e67:	c3                   	retq   

0000000000800e68 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e68:	55                   	push   %rbp
  800e69:	48 89 e5             	mov    %rsp,%rbp
  800e6c:	48 83 ec 20          	sub    $0x20,%rsp
  800e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	48 89 c7             	mov    %rax,%rdi
  800e84:	48 b8 56 0f 80 00 00 	movabs $0x800f56,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
  800e90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e97:	79 05                	jns    800e9e <stat+0x36>
		return fd;
  800e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e9c:	eb 2f                	jmp    800ecd <stat+0x65>
	r = fstat(fd, stat);
  800e9e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea5:	48 89 d6             	mov    %rdx,%rsi
  800ea8:	89 c7                	mov    %eax,%edi
  800eaa:	48 b8 af 0d 80 00 00 	movabs $0x800daf,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
  800eb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	48 b8 5e 08 80 00 00 	movabs $0x80085e,%rax
  800ec5:	00 00 00 
  800ec8:	ff d0                	callq  *%rax
	return r;
  800eca:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ecd:	c9                   	leaveq 
  800ece:	c3                   	retq   

0000000000800ecf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 83 ec 10          	sub    $0x10,%rsp
  800ed7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ede:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800ee5:	00 00 00 
  800ee8:	8b 00                	mov    (%rax),%eax
  800eea:	85 c0                	test   %eax,%eax
  800eec:	75 1d                	jne    800f0b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800eee:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef3:	48 b8 bc 32 80 00 00 	movabs $0x8032bc,%rax
  800efa:	00 00 00 
  800efd:	ff d0                	callq  *%rax
  800eff:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f06:	00 00 00 
  800f09:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f0b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f12:	00 00 00 
  800f15:	8b 00                	mov    (%rax),%eax
  800f17:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f1a:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f1f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f26:	00 00 00 
  800f29:	89 c7                	mov    %eax,%edi
  800f2b:	48 b8 5a 32 80 00 00 	movabs $0x80325a,%rax
  800f32:	00 00 00 
  800f35:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f40:	48 89 c6             	mov    %rax,%rsi
  800f43:	bf 00 00 00 00       	mov    $0x0,%edi
  800f48:	48 b8 54 31 80 00 00 	movabs $0x803154,%rax
  800f4f:	00 00 00 
  800f52:	ff d0                	callq  *%rax
}
  800f54:	c9                   	leaveq 
  800f55:	c3                   	retq   

0000000000800f56 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f56:	55                   	push   %rbp
  800f57:	48 89 e5             	mov    %rsp,%rbp
  800f5a:	48 83 ec 30          	sub    $0x30,%rsp
  800f5e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f62:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  800f65:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  800f6c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  800f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  800f7a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f7f:	75 08                	jne    800f89 <open+0x33>
	{
		return r;
  800f81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f84:	e9 f2 00 00 00       	jmpq   80107b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  800f89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800f8d:	48 89 c7             	mov    %rax,%rdi
  800f90:	48 b8 8f 29 80 00 00 	movabs $0x80298f,%rax
  800f97:	00 00 00 
  800f9a:	ff d0                	callq  *%rax
  800f9c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800f9f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  800fa6:	7e 0a                	jle    800fb2 <open+0x5c>
	{
		return -E_BAD_PATH;
  800fa8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800fad:	e9 c9 00 00 00       	jmpq   80107b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  800fb2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800fb9:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  800fba:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fbe:	48 89 c7             	mov    %rax,%rdi
  800fc1:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	callq  *%rax
  800fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd4:	78 09                	js     800fdf <open+0x89>
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 85 c0             	test   %rax,%rax
  800fdd:	75 08                	jne    800fe7 <open+0x91>
		{
			return r;
  800fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fe2:	e9 94 00 00 00       	jmpq   80107b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  800fe7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800feb:	ba 00 04 00 00       	mov    $0x400,%edx
  800ff0:	48 89 c6             	mov    %rax,%rsi
  800ff3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800ffa:	00 00 00 
  800ffd:	48 b8 8d 2a 80 00 00 	movabs $0x802a8d,%rax
  801004:	00 00 00 
  801007:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801009:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801010:	00 00 00 
  801013:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801016:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80101c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801020:	48 89 c6             	mov    %rax,%rsi
  801023:	bf 01 00 00 00       	mov    $0x1,%edi
  801028:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax
  801034:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801037:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80103b:	79 2b                	jns    801068 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	be 00 00 00 00       	mov    $0x0,%esi
  801046:	48 89 c7             	mov    %rax,%rdi
  801049:	48 b8 de 06 80 00 00 	movabs $0x8006de,%rax
  801050:	00 00 00 
  801053:	ff d0                	callq  *%rax
  801055:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801058:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80105c:	79 05                	jns    801063 <open+0x10d>
			{
				return d;
  80105e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801061:	eb 18                	jmp    80107b <open+0x125>
			}
			return r;
  801063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801066:	eb 13                	jmp    80107b <open+0x125>
		}	
		return fd2num(fd_store);
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	48 89 c7             	mov    %rax,%rdi
  80106f:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  801076:	00 00 00 
  801079:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80107b:	c9                   	leaveq 
  80107c:	c3                   	retq   

000000000080107d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80107d:	55                   	push   %rbp
  80107e:	48 89 e5             	mov    %rsp,%rbp
  801081:	48 83 ec 10          	sub    $0x10,%rsp
  801085:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108d:	8b 50 0c             	mov    0xc(%rax),%edx
  801090:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801097:	00 00 00 
  80109a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80109c:	be 00 00 00 00       	mov    $0x0,%esi
  8010a1:	bf 06 00 00 00       	mov    $0x6,%edi
  8010a6:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8010ad:	00 00 00 
  8010b0:	ff d0                	callq  *%rax
}
  8010b2:	c9                   	leaveq 
  8010b3:	c3                   	retq   

00000000008010b4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010b4:	55                   	push   %rbp
  8010b5:	48 89 e5             	mov    %rsp,%rbp
  8010b8:	48 83 ec 30          	sub    $0x30,%rsp
  8010bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8010cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d4:	74 07                	je     8010dd <devfile_read+0x29>
  8010d6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010db:	75 07                	jne    8010e4 <devfile_read+0x30>
		return -E_INVAL;
  8010dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e2:	eb 77                	jmp    80115b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8010eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010f2:	00 00 00 
  8010f5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8010f7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010fe:	00 00 00 
  801101:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801105:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801109:	be 00 00 00 00       	mov    $0x0,%esi
  80110e:	bf 03 00 00 00       	mov    $0x3,%edi
  801113:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80111a:	00 00 00 
  80111d:	ff d0                	callq  *%rax
  80111f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801122:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801126:	7f 05                	jg     80112d <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112b:	eb 2e                	jmp    80115b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80112d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801130:	48 63 d0             	movslq %eax,%rdx
  801133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801137:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80113e:	00 00 00 
  801141:	48 89 c7             	mov    %rax,%rdi
  801144:	48 b8 1f 2d 80 00 00 	movabs $0x802d1f,%rax
  80114b:	00 00 00 
  80114e:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801150:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801154:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801158:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80115b:	c9                   	leaveq 
  80115c:	c3                   	retq   

000000000080115d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80115d:	55                   	push   %rbp
  80115e:	48 89 e5             	mov    %rsp,%rbp
  801161:	48 83 ec 30          	sub    $0x30,%rsp
  801165:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801169:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801171:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801178:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117d:	74 07                	je     801186 <devfile_write+0x29>
  80117f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801184:	75 08                	jne    80118e <devfile_write+0x31>
		return r;
  801186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801189:	e9 9a 00 00 00       	jmpq   801228 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	8b 50 0c             	mov    0xc(%rax),%edx
  801195:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80119c:	00 00 00 
  80119f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8011a1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011a8:	00 
  8011a9:	76 08                	jbe    8011b3 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8011ab:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8011b2:	00 
	}
	fsipcbuf.write.req_n = n;
  8011b3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011ba:	00 00 00 
  8011bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011c1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8011c5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cd:	48 89 c6             	mov    %rax,%rsi
  8011d0:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011d7:	00 00 00 
  8011da:	48 b8 1f 2d 80 00 00 	movabs $0x802d1f,%rax
  8011e1:	00 00 00 
  8011e4:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8011e6:	be 00 00 00 00       	mov    $0x0,%esi
  8011eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8011f0:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8011f7:	00 00 00 
  8011fa:	ff d0                	callq  *%rax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801203:	7f 20                	jg     801225 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801205:	48 bf 9e 34 80 00 00 	movabs $0x80349e,%rdi
  80120c:	00 00 00 
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
  801214:	48 ba 46 1e 80 00 00 	movabs $0x801e46,%rdx
  80121b:	00 00 00 
  80121e:	ff d2                	callq  *%rdx
		return r;
  801220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801223:	eb 03                	jmp    801228 <devfile_write+0xcb>
	}
	return r;
  801225:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801228:	c9                   	leaveq 
  801229:	c3                   	retq   

000000000080122a <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	48 83 ec 20          	sub    $0x20,%rsp
  801232:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801236:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80123a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123e:	8b 50 0c             	mov    0xc(%rax),%edx
  801241:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801248:	00 00 00 
  80124b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80124d:	be 00 00 00 00       	mov    $0x0,%esi
  801252:	bf 05 00 00 00       	mov    $0x5,%edi
  801257:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
  801263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80126a:	79 05                	jns    801271 <devfile_stat+0x47>
		return r;
  80126c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126f:	eb 56                	jmp    8012c7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801275:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80127c:	00 00 00 
  80127f:	48 89 c7             	mov    %rax,%rdi
  801282:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  801289:	00 00 00 
  80128c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80128e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801295:	00 00 00 
  801298:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80129e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012a8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012af:	00 00 00 
  8012b2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 10          	sub    $0x10,%rsp
  8012d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dc:	8b 50 0c             	mov    0xc(%rax),%edx
  8012df:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012e6:	00 00 00 
  8012e9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8012eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012f2:	00 00 00 
  8012f5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8012f8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012fb:	be 00 00 00 00       	mov    $0x0,%esi
  801300:	bf 02 00 00 00       	mov    $0x2,%edi
  801305:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
}
  801311:	c9                   	leaveq 
  801312:	c3                   	retq   

0000000000801313 <remove>:

// Delete a file
int
remove(const char *path)
{
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	48 83 ec 10          	sub    $0x10,%rsp
  80131b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801323:	48 89 c7             	mov    %rax,%rdi
  801326:	48 b8 8f 29 80 00 00 	movabs $0x80298f,%rax
  80132d:	00 00 00 
  801330:	ff d0                	callq  *%rax
  801332:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801337:	7e 07                	jle    801340 <remove+0x2d>
		return -E_BAD_PATH;
  801339:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80133e:	eb 33                	jmp    801373 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	48 89 c6             	mov    %rax,%rsi
  801347:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80134e:	00 00 00 
  801351:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  801358:	00 00 00 
  80135b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80135d:	be 00 00 00 00       	mov    $0x0,%esi
  801362:	bf 07 00 00 00       	mov    $0x7,%edi
  801367:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80136e:	00 00 00 
  801371:	ff d0                	callq  *%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801379:	be 00 00 00 00       	mov    $0x0,%esi
  80137e:	bf 08 00 00 00       	mov    $0x8,%edi
  801383:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80138a:	00 00 00 
  80138d:	ff d0                	callq  *%rax
}
  80138f:	5d                   	pop    %rbp
  801390:	c3                   	retq   

0000000000801391 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	53                   	push   %rbx
  801396:	48 83 ec 38          	sub    $0x38,%rsp
  80139a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80139e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8013a2:	48 89 c7             	mov    %rax,%rdi
  8013a5:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  8013ac:	00 00 00 
  8013af:	ff d0                	callq  *%rax
  8013b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013b8:	0f 88 bf 01 00 00    	js     80157d <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8013c7:	48 89 c6             	mov    %rax,%rsi
  8013ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8013cf:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  8013d6:	00 00 00 
  8013d9:	ff d0                	callq  *%rax
  8013db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013e2:	0f 88 95 01 00 00    	js     80157d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8013e8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013ec:	48 89 c7             	mov    %rax,%rdi
  8013ef:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  8013f6:	00 00 00 
  8013f9:	ff d0                	callq  *%rax
  8013fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801402:	0f 88 5d 01 00 00    	js     801565 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801408:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80140c:	ba 07 04 00 00       	mov    $0x407,%edx
  801411:	48 89 c6             	mov    %rax,%rsi
  801414:	bf 00 00 00 00       	mov    $0x0,%edi
  801419:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801420:	00 00 00 
  801423:	ff d0                	callq  *%rax
  801425:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801428:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80142c:	0f 88 33 01 00 00    	js     801565 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	48 89 c7             	mov    %rax,%rdi
  801439:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  801440:	00 00 00 
  801443:	ff d0                	callq  *%rax
  801445:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801449:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80144d:	ba 07 04 00 00       	mov    $0x407,%edx
  801452:	48 89 c6             	mov    %rax,%rsi
  801455:	bf 00 00 00 00       	mov    $0x0,%edi
  80145a:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801461:	00 00 00 
  801464:	ff d0                	callq  *%rax
  801466:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801469:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80146d:	79 05                	jns    801474 <pipe+0xe3>
		goto err2;
  80146f:	e9 d9 00 00 00       	jmpq   80154d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801474:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801478:	48 89 c7             	mov    %rax,%rdi
  80147b:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  801482:	00 00 00 
  801485:	ff d0                	callq  *%rax
  801487:	48 89 c2             	mov    %rax,%rdx
  80148a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801494:	48 89 d1             	mov    %rdx,%rcx
  801497:	ba 00 00 00 00       	mov    $0x0,%edx
  80149c:	48 89 c6             	mov    %rax,%rsi
  80149f:	bf 00 00 00 00       	mov    $0x0,%edi
  8014a4:	48 b8 4b 03 80 00 00 	movabs $0x80034b,%rax
  8014ab:	00 00 00 
  8014ae:	ff d0                	callq  *%rax
  8014b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014b7:	79 1b                	jns    8014d4 <pipe+0x143>
		goto err3;
  8014b9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8014ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014be:	48 89 c6             	mov    %rax,%rsi
  8014c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8014c6:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  8014cd:	00 00 00 
  8014d0:	ff d0                	callq  *%rax
  8014d2:	eb 79                	jmp    80154d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8014df:	00 00 00 
  8014e2:	8b 12                	mov    (%rdx),%edx
  8014e4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8014f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f5:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8014fc:	00 00 00 
  8014ff:	8b 12                	mov    (%rdx),%edx
  801501:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801507:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	48 89 c7             	mov    %rax,%rdi
  801515:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  80151c:	00 00 00 
  80151f:	ff d0                	callq  *%rax
  801521:	89 c2                	mov    %eax,%edx
  801523:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801527:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801529:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80152d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801531:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801535:	48 89 c7             	mov    %rax,%rdi
  801538:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  80153f:	00 00 00 
  801542:	ff d0                	callq  *%rax
  801544:	89 03                	mov    %eax,(%rbx)
	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	eb 33                	jmp    801580 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80154d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801551:	48 89 c6             	mov    %rax,%rsi
  801554:	bf 00 00 00 00       	mov    $0x0,%edi
  801559:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  801560:	00 00 00 
  801563:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  801565:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801569:	48 89 c6             	mov    %rax,%rsi
  80156c:	bf 00 00 00 00       	mov    $0x0,%edi
  801571:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  801578:	00 00 00 
  80157b:	ff d0                	callq  *%rax
    err:
	return r;
  80157d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801580:	48 83 c4 38          	add    $0x38,%rsp
  801584:	5b                   	pop    %rbx
  801585:	5d                   	pop    %rbp
  801586:	c3                   	retq   

0000000000801587 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801587:	55                   	push   %rbp
  801588:	48 89 e5             	mov    %rsp,%rbp
  80158b:	53                   	push   %rbx
  80158c:	48 83 ec 28          	sub    $0x28,%rsp
  801590:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801594:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801598:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80159f:	00 00 00 
  8015a2:	48 8b 00             	mov    (%rax),%rax
  8015a5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8015ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8015ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b2:	48 89 c7             	mov    %rax,%rdi
  8015b5:	48 b8 3e 33 80 00 00 	movabs $0x80333e,%rax
  8015bc:	00 00 00 
  8015bf:	ff d0                	callq  *%rax
  8015c1:	89 c3                	mov    %eax,%ebx
  8015c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c7:	48 89 c7             	mov    %rax,%rdi
  8015ca:	48 b8 3e 33 80 00 00 	movabs $0x80333e,%rax
  8015d1:	00 00 00 
  8015d4:	ff d0                	callq  *%rax
  8015d6:	39 c3                	cmp    %eax,%ebx
  8015d8:	0f 94 c0             	sete   %al
  8015db:	0f b6 c0             	movzbl %al,%eax
  8015de:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8015e1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015e8:	00 00 00 
  8015eb:	48 8b 00             	mov    (%rax),%rax
  8015ee:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8015f4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8015f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015fa:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8015fd:	75 05                	jne    801604 <_pipeisclosed+0x7d>
			return ret;
  8015ff:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801602:	eb 4f                	jmp    801653 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801604:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801607:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80160a:	74 42                	je     80164e <_pipeisclosed+0xc7>
  80160c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801610:	75 3c                	jne    80164e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801612:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801619:	00 00 00 
  80161c:	48 8b 00             	mov    (%rax),%rax
  80161f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801625:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801628:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80162b:	89 c6                	mov    %eax,%esi
  80162d:	48 bf bf 34 80 00 00 	movabs $0x8034bf,%rdi
  801634:	00 00 00 
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	49 b8 46 1e 80 00 00 	movabs $0x801e46,%r8
  801643:	00 00 00 
  801646:	41 ff d0             	callq  *%r8
	}
  801649:	e9 4a ff ff ff       	jmpq   801598 <_pipeisclosed+0x11>
  80164e:	e9 45 ff ff ff       	jmpq   801598 <_pipeisclosed+0x11>
}
  801653:	48 83 c4 28          	add    $0x28,%rsp
  801657:	5b                   	pop    %rbx
  801658:	5d                   	pop    %rbp
  801659:	c3                   	retq   

000000000080165a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	48 83 ec 30          	sub    $0x30,%rsp
  801662:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801665:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801669:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166c:	48 89 d6             	mov    %rdx,%rsi
  80166f:	89 c7                	mov    %eax,%edi
  801671:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  801678:	00 00 00 
  80167b:	ff d0                	callq  *%rax
  80167d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801680:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801684:	79 05                	jns    80168b <pipeisclosed+0x31>
		return r;
  801686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801689:	eb 31                	jmp    8016bc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	48 89 c7             	mov    %rax,%rdi
  801692:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  801699:	00 00 00 
  80169c:	ff d0                	callq  *%rax
  80169e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8016a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016aa:	48 89 d6             	mov    %rdx,%rsi
  8016ad:	48 89 c7             	mov    %rax,%rdi
  8016b0:	48 b8 87 15 80 00 00 	movabs $0x801587,%rax
  8016b7:	00 00 00 
  8016ba:	ff d0                	callq  *%rax
}
  8016bc:	c9                   	leaveq 
  8016bd:	c3                   	retq   

00000000008016be <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016be:	55                   	push   %rbp
  8016bf:	48 89 e5             	mov    %rsp,%rbp
  8016c2:	48 83 ec 40          	sub    $0x40,%rsp
  8016c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016ce:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 89 c7             	mov    %rax,%rdi
  8016d9:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  8016e0:	00 00 00 
  8016e3:	ff d0                	callq  *%rax
  8016e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8016e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8016f1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8016f8:	00 
  8016f9:	e9 92 00 00 00       	jmpq   801790 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8016fe:	eb 41                	jmp    801741 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801700:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801705:	74 09                	je     801710 <devpipe_read+0x52>
				return i;
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170b:	e9 92 00 00 00       	jmpq   8017a2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801710:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	48 89 d6             	mov    %rdx,%rsi
  80171b:	48 89 c7             	mov    %rax,%rdi
  80171e:	48 b8 87 15 80 00 00 	movabs $0x801587,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 07                	je     801735 <devpipe_read+0x77>
				return 0;
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	eb 6d                	jmp    8017a2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801735:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801745:	8b 10                	mov    (%rax),%edx
  801747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174b:	8b 40 04             	mov    0x4(%rax),%eax
  80174e:	39 c2                	cmp    %eax,%edx
  801750:	74 ae                	je     801700 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801752:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80175e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801762:	8b 00                	mov    (%rax),%eax
  801764:	99                   	cltd   
  801765:	c1 ea 1b             	shr    $0x1b,%edx
  801768:	01 d0                	add    %edx,%eax
  80176a:	83 e0 1f             	and    $0x1f,%eax
  80176d:	29 d0                	sub    %edx,%eax
  80176f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801773:	48 98                	cltq   
  801775:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80177a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80177c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801780:	8b 00                	mov    (%rax),%eax
  801782:	8d 50 01             	lea    0x1(%rax),%edx
  801785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801789:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80178b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801790:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801794:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801798:	0f 82 60 ff ff ff    	jb     8016fe <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80179e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017a2:	c9                   	leaveq 
  8017a3:	c3                   	retq   

00000000008017a4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017a4:	55                   	push   %rbp
  8017a5:	48 89 e5             	mov    %rsp,%rbp
  8017a8:	48 83 ec 40          	sub    $0x40,%rsp
  8017ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017b4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	48 89 c7             	mov    %rax,%rdi
  8017bf:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
  8017cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8017cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8017d7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017de:	00 
  8017df:	e9 8e 00 00 00       	jmpq   801872 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017e4:	eb 31                	jmp    801817 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8017e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	48 89 d6             	mov    %rdx,%rsi
  8017f1:	48 89 c7             	mov    %rax,%rdi
  8017f4:	48 b8 87 15 80 00 00 	movabs $0x801587,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
  801800:	85 c0                	test   %eax,%eax
  801802:	74 07                	je     80180b <devpipe_write+0x67>
				return 0;
  801804:	b8 00 00 00 00       	mov    $0x0,%eax
  801809:	eb 79                	jmp    801884 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80180b:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  801812:	00 00 00 
  801815:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801817:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181b:	8b 40 04             	mov    0x4(%rax),%eax
  80181e:	48 63 d0             	movslq %eax,%rdx
  801821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801825:	8b 00                	mov    (%rax),%eax
  801827:	48 98                	cltq   
  801829:	48 83 c0 20          	add    $0x20,%rax
  80182d:	48 39 c2             	cmp    %rax,%rdx
  801830:	73 b4                	jae    8017e6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801836:	8b 40 04             	mov    0x4(%rax),%eax
  801839:	99                   	cltd   
  80183a:	c1 ea 1b             	shr    $0x1b,%edx
  80183d:	01 d0                	add    %edx,%eax
  80183f:	83 e0 1f             	and    $0x1f,%eax
  801842:	29 d0                	sub    %edx,%eax
  801844:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801848:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80184c:	48 01 ca             	add    %rcx,%rdx
  80184f:	0f b6 0a             	movzbl (%rdx),%ecx
  801852:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801856:	48 98                	cltq   
  801858:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80185c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801860:	8b 40 04             	mov    0x4(%rax),%eax
  801863:	8d 50 01             	lea    0x1(%rax),%edx
  801866:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80186d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801876:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80187a:	0f 82 64 ff ff ff    	jb     8017e4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801884:	c9                   	leaveq 
  801885:	c3                   	retq   

0000000000801886 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801886:	55                   	push   %rbp
  801887:	48 89 e5             	mov    %rsp,%rbp
  80188a:	48 83 ec 20          	sub    $0x20,%rsp
  80188e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801892:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189a:	48 89 c7             	mov    %rax,%rdi
  80189d:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  8018a4:	00 00 00 
  8018a7:	ff d0                	callq  *%rax
  8018a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8018ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018b1:	48 be d2 34 80 00 00 	movabs $0x8034d2,%rsi
  8018b8:	00 00 00 
  8018bb:	48 89 c7             	mov    %rax,%rdi
  8018be:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8018ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ce:	8b 50 04             	mov    0x4(%rax),%edx
  8018d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d5:	8b 00                	mov    (%rax),%eax
  8018d7:	29 c2                	sub    %eax,%edx
  8018d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018dd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8018e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018e7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8018ee:	00 00 00 
	stat->st_dev = &devpipe;
  8018f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f5:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8018fc:	00 00 00 
  8018ff:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 10          	sub    $0x10,%rsp
  801915:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191d:	48 89 c6             	mov    %rax,%rsi
  801920:	bf 00 00 00 00       	mov    $0x0,%edi
  801925:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801931:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801935:	48 89 c7             	mov    %rax,%rdi
  801938:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  80193f:	00 00 00 
  801942:	ff d0                	callq  *%rax
  801944:	48 89 c6             	mov    %rax,%rsi
  801947:	bf 00 00 00 00       	mov    $0x0,%edi
  80194c:	48 b8 a6 03 80 00 00 	movabs $0x8003a6,%rax
  801953:	00 00 00 
  801956:	ff d0                	callq  *%rax
}
  801958:	c9                   	leaveq 
  801959:	c3                   	retq   

000000000080195a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80195a:	55                   	push   %rbp
  80195b:	48 89 e5             	mov    %rsp,%rbp
  80195e:	48 83 ec 20          	sub    $0x20,%rsp
  801962:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801965:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801968:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80196b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80196f:	be 01 00 00 00       	mov    $0x1,%esi
  801974:	48 89 c7             	mov    %rax,%rdi
  801977:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <getchar>:

int
getchar(void)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80198d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801991:	ba 01 00 00 00       	mov    $0x1,%edx
  801996:	48 89 c6             	mov    %rax,%rsi
  801999:	bf 00 00 00 00       	mov    $0x0,%edi
  80199e:	48 b8 80 0a 80 00 00 	movabs $0x800a80,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
  8019aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8019ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b1:	79 05                	jns    8019b8 <getchar+0x33>
		return r;
  8019b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b6:	eb 14                	jmp    8019cc <getchar+0x47>
	if (r < 1)
  8019b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019bc:	7f 07                	jg     8019c5 <getchar+0x40>
		return -E_EOF;
  8019be:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8019c3:	eb 07                	jmp    8019cc <getchar+0x47>
	return c;
  8019c5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8019c9:	0f b6 c0             	movzbl %al,%eax
}
  8019cc:	c9                   	leaveq 
  8019cd:	c3                   	retq   

00000000008019ce <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	48 83 ec 20          	sub    $0x20,%rsp
  8019d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8019dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019e0:	48 89 d6             	mov    %rdx,%rsi
  8019e3:	89 c7                	mov    %eax,%edi
  8019e5:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  8019ec:	00 00 00 
  8019ef:	ff d0                	callq  *%rax
  8019f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f8:	79 05                	jns    8019ff <iscons+0x31>
		return r;
  8019fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fd:	eb 1a                	jmp    801a19 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8019ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a03:	8b 10                	mov    (%rax),%edx
  801a05:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801a0c:	00 00 00 
  801a0f:	8b 00                	mov    (%rax),%eax
  801a11:	39 c2                	cmp    %eax,%edx
  801a13:	0f 94 c0             	sete   %al
  801a16:	0f b6 c0             	movzbl %al,%eax
}
  801a19:	c9                   	leaveq 
  801a1a:	c3                   	retq   

0000000000801a1b <opencons>:

int
opencons(void)
{
  801a1b:	55                   	push   %rbp
  801a1c:	48 89 e5             	mov    %rsp,%rbp
  801a1f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a23:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801a27:	48 89 c7             	mov    %rax,%rdi
  801a2a:	48 b8 b6 05 80 00 00 	movabs $0x8005b6,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
  801a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a3d:	79 05                	jns    801a44 <opencons+0x29>
		return r;
  801a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a42:	eb 5b                	jmp    801a9f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a48:	ba 07 04 00 00       	mov    $0x407,%edx
  801a4d:	48 89 c6             	mov    %rax,%rsi
  801a50:	bf 00 00 00 00       	mov    $0x0,%edi
  801a55:	48 b8 fb 02 80 00 00 	movabs $0x8002fb,%rax
  801a5c:	00 00 00 
  801a5f:	ff d0                	callq  *%rax
  801a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a68:	79 05                	jns    801a6f <opencons+0x54>
		return r;
  801a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6d:	eb 30                	jmp    801a9f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801a7a:	00 00 00 
  801a7d:	8b 12                	mov    (%rdx),%edx
  801a7f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a85:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a90:	48 89 c7             	mov    %rax,%rdi
  801a93:	48 b8 68 05 80 00 00 	movabs $0x800568,%rax
  801a9a:	00 00 00 
  801a9d:	ff d0                	callq  *%rax
}
  801a9f:	c9                   	leaveq 
  801aa0:	c3                   	retq   

0000000000801aa1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801aa1:	55                   	push   %rbp
  801aa2:	48 89 e5             	mov    %rsp,%rbp
  801aa5:	48 83 ec 30          	sub    $0x30,%rsp
  801aa9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801aad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ab1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801ab5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801aba:	75 07                	jne    801ac3 <devcons_read+0x22>
		return 0;
  801abc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac1:	eb 4b                	jmp    801b0e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801ac3:	eb 0c                	jmp    801ad1 <devcons_read+0x30>
		sys_yield();
  801ac5:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801ad1:	48 b8 fd 01 80 00 00 	movabs $0x8001fd,%rax
  801ad8:	00 00 00 
  801adb:	ff d0                	callq  *%rax
  801add:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ae4:	74 df                	je     801ac5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aea:	79 05                	jns    801af1 <devcons_read+0x50>
		return c;
  801aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aef:	eb 1d                	jmp    801b0e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801af1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801af5:	75 07                	jne    801afe <devcons_read+0x5d>
		return 0;
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	eb 10                	jmp    801b0e <devcons_read+0x6d>
	*(char*)vbuf = c;
  801afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b07:	88 10                	mov    %dl,(%rax)
	return 1;
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801b1b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801b22:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801b29:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b37:	eb 76                	jmp    801baf <devcons_write+0x9f>
		m = n - tot;
  801b39:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801b40:	89 c2                	mov    %eax,%edx
  801b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b45:	29 c2                	sub    %eax,%edx
  801b47:	89 d0                	mov    %edx,%eax
  801b49:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801b4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4f:	83 f8 7f             	cmp    $0x7f,%eax
  801b52:	76 07                	jbe    801b5b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801b54:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801b5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b5e:	48 63 d0             	movslq %eax,%rdx
  801b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b64:	48 63 c8             	movslq %eax,%rcx
  801b67:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801b6e:	48 01 c1             	add    %rax,%rcx
  801b71:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b78:	48 89 ce             	mov    %rcx,%rsi
  801b7b:	48 89 c7             	mov    %rax,%rdi
  801b7e:	48 b8 1f 2d 80 00 00 	movabs $0x802d1f,%rax
  801b85:	00 00 00 
  801b88:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801b8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b8d:	48 63 d0             	movslq %eax,%rdx
  801b90:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b97:	48 89 d6             	mov    %rdx,%rsi
  801b9a:	48 89 c7             	mov    %rax,%rdi
  801b9d:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bac:	01 45 fc             	add    %eax,-0x4(%rbp)
  801baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb2:	48 98                	cltq   
  801bb4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801bbb:	0f 82 78 ff ff ff    	jb     801b39 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801bc4:	c9                   	leaveq 
  801bc5:	c3                   	retq   

0000000000801bc6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801bc6:	55                   	push   %rbp
  801bc7:	48 89 e5             	mov    %rsp,%rbp
  801bca:	48 83 ec 08          	sub    $0x8,%rsp
  801bce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd7:	c9                   	leaveq 
  801bd8:	c3                   	retq   

0000000000801bd9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	48 83 ec 10          	sub    $0x10,%rsp
  801be1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bed:	48 be de 34 80 00 00 	movabs $0x8034de,%rsi
  801bf4:	00 00 00 
  801bf7:	48 89 c7             	mov    %rax,%rdi
  801bfa:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	callq  *%rax
	return 0;
  801c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0b:	c9                   	leaveq 
  801c0c:	c3                   	retq   

0000000000801c0d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	53                   	push   %rbx
  801c12:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801c19:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801c20:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801c26:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801c2d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801c34:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801c3b:	84 c0                	test   %al,%al
  801c3d:	74 23                	je     801c62 <_panic+0x55>
  801c3f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801c46:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801c4a:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801c4e:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801c52:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801c56:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801c5a:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801c5e:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801c62:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801c69:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801c70:	00 00 00 
  801c73:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801c7a:	00 00 00 
  801c7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c81:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801c88:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801c8f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c96:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801c9d:	00 00 00 
  801ca0:	48 8b 18             	mov    (%rax),%rbx
  801ca3:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
  801caf:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801cb5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801cbc:	41 89 c8             	mov    %ecx,%r8d
  801cbf:	48 89 d1             	mov    %rdx,%rcx
  801cc2:	48 89 da             	mov    %rbx,%rdx
  801cc5:	89 c6                	mov    %eax,%esi
  801cc7:	48 bf e8 34 80 00 00 	movabs $0x8034e8,%rdi
  801cce:	00 00 00 
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	49 b9 46 1e 80 00 00 	movabs $0x801e46,%r9
  801cdd:	00 00 00 
  801ce0:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ce3:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801cea:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801cf1:	48 89 d6             	mov    %rdx,%rsi
  801cf4:	48 89 c7             	mov    %rax,%rdi
  801cf7:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
	cprintf("\n");
  801d03:	48 bf 0b 35 80 00 00 	movabs $0x80350b,%rdi
  801d0a:	00 00 00 
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d12:	48 ba 46 1e 80 00 00 	movabs $0x801e46,%rdx
  801d19:	00 00 00 
  801d1c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d1e:	cc                   	int3   
  801d1f:	eb fd                	jmp    801d1e <_panic+0x111>

0000000000801d21 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d21:	55                   	push   %rbp
  801d22:	48 89 e5             	mov    %rsp,%rbp
  801d25:	48 83 ec 10          	sub    $0x10,%rsp
  801d29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d34:	8b 00                	mov    (%rax),%eax
  801d36:	8d 48 01             	lea    0x1(%rax),%ecx
  801d39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3d:	89 0a                	mov    %ecx,(%rdx)
  801d3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d42:	89 d1                	mov    %edx,%ecx
  801d44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d48:	48 98                	cltq   
  801d4a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d52:	8b 00                	mov    (%rax),%eax
  801d54:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d59:	75 2c                	jne    801d87 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5f:	8b 00                	mov    (%rax),%eax
  801d61:	48 98                	cltq   
  801d63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d67:	48 83 c2 08          	add    $0x8,%rdx
  801d6b:	48 89 c6             	mov    %rax,%rsi
  801d6e:	48 89 d7             	mov    %rdx,%rdi
  801d71:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
		b->idx = 0;
  801d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d81:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801d87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8b:	8b 40 04             	mov    0x4(%rax),%eax
  801d8e:	8d 50 01             	lea    0x1(%rax),%edx
  801d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d95:	89 50 04             	mov    %edx,0x4(%rax)
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801da5:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801dac:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801db3:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801dba:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801dc1:	48 8b 0a             	mov    (%rdx),%rcx
  801dc4:	48 89 08             	mov    %rcx,(%rax)
  801dc7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801dcb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801dcf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801dd3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801dd7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801dde:	00 00 00 
	b.cnt = 0;
  801de1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801de8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801deb:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801df2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801df9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801e00:	48 89 c6             	mov    %rax,%rsi
  801e03:	48 bf 21 1d 80 00 00 	movabs $0x801d21,%rdi
  801e0a:	00 00 00 
  801e0d:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  801e14:	00 00 00 
  801e17:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801e19:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801e1f:	48 98                	cltq   
  801e21:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801e28:	48 83 c2 08          	add    $0x8,%rdx
  801e2c:	48 89 c6             	mov    %rax,%rsi
  801e2f:	48 89 d7             	mov    %rdx,%rdi
  801e32:	48 b8 b3 01 80 00 00 	movabs $0x8001b3,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801e3e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801e44:	c9                   	leaveq 
  801e45:	c3                   	retq   

0000000000801e46 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e46:	55                   	push   %rbp
  801e47:	48 89 e5             	mov    %rsp,%rbp
  801e4a:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801e51:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801e58:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801e5f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e66:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e6d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e74:	84 c0                	test   %al,%al
  801e76:	74 20                	je     801e98 <cprintf+0x52>
  801e78:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e7c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e80:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e84:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e88:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e8c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e90:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e94:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e98:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801e9f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801ea6:	00 00 00 
  801ea9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801eb0:	00 00 00 
  801eb3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801eb7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801ebe:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801ec5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801ecc:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801ed3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801eda:	48 8b 0a             	mov    (%rdx),%rcx
  801edd:	48 89 08             	mov    %rcx,(%rax)
  801ee0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801ee4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801ee8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801eec:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801ef0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801ef7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801efe:	48 89 d6             	mov    %rdx,%rsi
  801f01:	48 89 c7             	mov    %rax,%rdi
  801f04:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	callq  *%rax
  801f10:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801f16:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801f1c:	c9                   	leaveq 
  801f1d:	c3                   	retq   

0000000000801f1e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f1e:	55                   	push   %rbp
  801f1f:	48 89 e5             	mov    %rsp,%rbp
  801f22:	53                   	push   %rbx
  801f23:	48 83 ec 38          	sub    $0x38,%rsp
  801f27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801f33:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801f36:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801f3a:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f3e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f41:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801f45:	77 3b                	ja     801f82 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f47:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801f4a:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801f4e:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801f51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f55:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5a:	48 f7 f3             	div    %rbx
  801f5d:	48 89 c2             	mov    %rax,%rdx
  801f60:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801f63:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801f66:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6e:	41 89 f9             	mov    %edi,%r9d
  801f71:	48 89 c7             	mov    %rax,%rdi
  801f74:	48 b8 1e 1f 80 00 00 	movabs $0x801f1e,%rax
  801f7b:	00 00 00 
  801f7e:	ff d0                	callq  *%rax
  801f80:	eb 1e                	jmp    801fa0 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f82:	eb 12                	jmp    801f96 <printnum+0x78>
			putch(padc, putdat);
  801f84:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f88:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8f:	48 89 ce             	mov    %rcx,%rsi
  801f92:	89 d7                	mov    %edx,%edi
  801f94:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f96:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801f9a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801f9e:	7f e4                	jg     801f84 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801fa0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801fa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fac:	48 f7 f1             	div    %rcx
  801faf:	48 89 d0             	mov    %rdx,%rax
  801fb2:	48 ba e8 36 80 00 00 	movabs $0x8036e8,%rdx
  801fb9:	00 00 00 
  801fbc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  801fc0:	0f be d0             	movsbl %al,%edx
  801fc3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcb:	48 89 ce             	mov    %rcx,%rsi
  801fce:	89 d7                	mov    %edx,%edi
  801fd0:	ff d0                	callq  *%rax
}
  801fd2:	48 83 c4 38          	add    $0x38,%rsp
  801fd6:	5b                   	pop    %rbx
  801fd7:	5d                   	pop    %rbp
  801fd8:	c3                   	retq   

0000000000801fd9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 1c          	sub    $0x1c,%rsp
  801fe1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fe5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801fe8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801fec:	7e 52                	jle    802040 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff2:	8b 00                	mov    (%rax),%eax
  801ff4:	83 f8 30             	cmp    $0x30,%eax
  801ff7:	73 24                	jae    80201d <getuint+0x44>
  801ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802005:	8b 00                	mov    (%rax),%eax
  802007:	89 c0                	mov    %eax,%eax
  802009:	48 01 d0             	add    %rdx,%rax
  80200c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802010:	8b 12                	mov    (%rdx),%edx
  802012:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802015:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802019:	89 0a                	mov    %ecx,(%rdx)
  80201b:	eb 17                	jmp    802034 <getuint+0x5b>
  80201d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802021:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802025:	48 89 d0             	mov    %rdx,%rax
  802028:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80202c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802030:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802034:	48 8b 00             	mov    (%rax),%rax
  802037:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80203b:	e9 a3 00 00 00       	jmpq   8020e3 <getuint+0x10a>
	else if (lflag)
  802040:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802044:	74 4f                	je     802095 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204a:	8b 00                	mov    (%rax),%eax
  80204c:	83 f8 30             	cmp    $0x30,%eax
  80204f:	73 24                	jae    802075 <getuint+0x9c>
  802051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802055:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205d:	8b 00                	mov    (%rax),%eax
  80205f:	89 c0                	mov    %eax,%eax
  802061:	48 01 d0             	add    %rdx,%rax
  802064:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802068:	8b 12                	mov    (%rdx),%edx
  80206a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80206d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802071:	89 0a                	mov    %ecx,(%rdx)
  802073:	eb 17                	jmp    80208c <getuint+0xb3>
  802075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802079:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80207d:	48 89 d0             	mov    %rdx,%rax
  802080:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802084:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802088:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80208c:	48 8b 00             	mov    (%rax),%rax
  80208f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802093:	eb 4e                	jmp    8020e3 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802099:	8b 00                	mov    (%rax),%eax
  80209b:	83 f8 30             	cmp    $0x30,%eax
  80209e:	73 24                	jae    8020c4 <getuint+0xeb>
  8020a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ac:	8b 00                	mov    (%rax),%eax
  8020ae:	89 c0                	mov    %eax,%eax
  8020b0:	48 01 d0             	add    %rdx,%rax
  8020b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020b7:	8b 12                	mov    (%rdx),%edx
  8020b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020c0:	89 0a                	mov    %ecx,(%rdx)
  8020c2:	eb 17                	jmp    8020db <getuint+0x102>
  8020c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020cc:	48 89 d0             	mov    %rdx,%rax
  8020cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020db:	8b 00                	mov    (%rax),%eax
  8020dd:	89 c0                	mov    %eax,%eax
  8020df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8020e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8020e7:	c9                   	leaveq 
  8020e8:	c3                   	retq   

00000000008020e9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8020e9:	55                   	push   %rbp
  8020ea:	48 89 e5             	mov    %rsp,%rbp
  8020ed:	48 83 ec 1c          	sub    $0x1c,%rsp
  8020f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8020f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8020f8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8020fc:	7e 52                	jle    802150 <getint+0x67>
		x=va_arg(*ap, long long);
  8020fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802102:	8b 00                	mov    (%rax),%eax
  802104:	83 f8 30             	cmp    $0x30,%eax
  802107:	73 24                	jae    80212d <getint+0x44>
  802109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	8b 00                	mov    (%rax),%eax
  802117:	89 c0                	mov    %eax,%eax
  802119:	48 01 d0             	add    %rdx,%rax
  80211c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802120:	8b 12                	mov    (%rdx),%edx
  802122:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802125:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802129:	89 0a                	mov    %ecx,(%rdx)
  80212b:	eb 17                	jmp    802144 <getint+0x5b>
  80212d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802131:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802135:	48 89 d0             	mov    %rdx,%rax
  802138:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80213c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802140:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802144:	48 8b 00             	mov    (%rax),%rax
  802147:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80214b:	e9 a3 00 00 00       	jmpq   8021f3 <getint+0x10a>
	else if (lflag)
  802150:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802154:	74 4f                	je     8021a5 <getint+0xbc>
		x=va_arg(*ap, long);
  802156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215a:	8b 00                	mov    (%rax),%eax
  80215c:	83 f8 30             	cmp    $0x30,%eax
  80215f:	73 24                	jae    802185 <getint+0x9c>
  802161:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802165:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216d:	8b 00                	mov    (%rax),%eax
  80216f:	89 c0                	mov    %eax,%eax
  802171:	48 01 d0             	add    %rdx,%rax
  802174:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802178:	8b 12                	mov    (%rdx),%edx
  80217a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80217d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802181:	89 0a                	mov    %ecx,(%rdx)
  802183:	eb 17                	jmp    80219c <getint+0xb3>
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80218d:	48 89 d0             	mov    %rdx,%rax
  802190:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802194:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802198:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80219c:	48 8b 00             	mov    (%rax),%rax
  80219f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021a3:	eb 4e                	jmp    8021f3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8021a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a9:	8b 00                	mov    (%rax),%eax
  8021ab:	83 f8 30             	cmp    $0x30,%eax
  8021ae:	73 24                	jae    8021d4 <getint+0xeb>
  8021b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bc:	8b 00                	mov    (%rax),%eax
  8021be:	89 c0                	mov    %eax,%eax
  8021c0:	48 01 d0             	add    %rdx,%rax
  8021c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021c7:	8b 12                	mov    (%rdx),%edx
  8021c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021d0:	89 0a                	mov    %ecx,(%rdx)
  8021d2:	eb 17                	jmp    8021eb <getint+0x102>
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021dc:	48 89 d0             	mov    %rdx,%rax
  8021df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021eb:	8b 00                	mov    (%rax),%eax
  8021ed:	48 98                	cltq   
  8021ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8021f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021f7:	c9                   	leaveq 
  8021f8:	c3                   	retq   

00000000008021f9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8021f9:	55                   	push   %rbp
  8021fa:	48 89 e5             	mov    %rsp,%rbp
  8021fd:	41 54                	push   %r12
  8021ff:	53                   	push   %rbx
  802200:	48 83 ec 60          	sub    $0x60,%rsp
  802204:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802208:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80220c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802210:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802214:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802218:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80221c:	48 8b 0a             	mov    (%rdx),%rcx
  80221f:	48 89 08             	mov    %rcx,(%rax)
  802222:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802226:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80222a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80222e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802232:	eb 17                	jmp    80224b <vprintfmt+0x52>
			if (ch == '\0')
  802234:	85 db                	test   %ebx,%ebx
  802236:	0f 84 cc 04 00 00    	je     802708 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80223c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802240:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802244:	48 89 d6             	mov    %rdx,%rsi
  802247:	89 df                	mov    %ebx,%edi
  802249:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80224b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80224f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802253:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802257:	0f b6 00             	movzbl (%rax),%eax
  80225a:	0f b6 d8             	movzbl %al,%ebx
  80225d:	83 fb 25             	cmp    $0x25,%ebx
  802260:	75 d2                	jne    802234 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802262:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802266:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80226d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802274:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80227b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802282:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802286:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80228a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80228e:	0f b6 00             	movzbl (%rax),%eax
  802291:	0f b6 d8             	movzbl %al,%ebx
  802294:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802297:	83 f8 55             	cmp    $0x55,%eax
  80229a:	0f 87 34 04 00 00    	ja     8026d4 <vprintfmt+0x4db>
  8022a0:	89 c0                	mov    %eax,%eax
  8022a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022a9:	00 
  8022aa:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  8022b1:	00 00 00 
  8022b4:	48 01 d0             	add    %rdx,%rax
  8022b7:	48 8b 00             	mov    (%rax),%rax
  8022ba:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8022bc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8022c0:	eb c0                	jmp    802282 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8022c2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8022c6:	eb ba                	jmp    802282 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8022c8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8022cf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	c1 e0 02             	shl    $0x2,%eax
  8022d7:	01 d0                	add    %edx,%eax
  8022d9:	01 c0                	add    %eax,%eax
  8022db:	01 d8                	add    %ebx,%eax
  8022dd:	83 e8 30             	sub    $0x30,%eax
  8022e0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8022e3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8022e7:	0f b6 00             	movzbl (%rax),%eax
  8022ea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8022ed:	83 fb 2f             	cmp    $0x2f,%ebx
  8022f0:	7e 0c                	jle    8022fe <vprintfmt+0x105>
  8022f2:	83 fb 39             	cmp    $0x39,%ebx
  8022f5:	7f 07                	jg     8022fe <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8022f7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8022fc:	eb d1                	jmp    8022cf <vprintfmt+0xd6>
			goto process_precision;
  8022fe:	eb 58                	jmp    802358 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802300:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802303:	83 f8 30             	cmp    $0x30,%eax
  802306:	73 17                	jae    80231f <vprintfmt+0x126>
  802308:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80230c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80230f:	89 c0                	mov    %eax,%eax
  802311:	48 01 d0             	add    %rdx,%rax
  802314:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802317:	83 c2 08             	add    $0x8,%edx
  80231a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80231d:	eb 0f                	jmp    80232e <vprintfmt+0x135>
  80231f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802323:	48 89 d0             	mov    %rdx,%rax
  802326:	48 83 c2 08          	add    $0x8,%rdx
  80232a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80232e:	8b 00                	mov    (%rax),%eax
  802330:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802333:	eb 23                	jmp    802358 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802335:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802339:	79 0c                	jns    802347 <vprintfmt+0x14e>
				width = 0;
  80233b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802342:	e9 3b ff ff ff       	jmpq   802282 <vprintfmt+0x89>
  802347:	e9 36 ff ff ff       	jmpq   802282 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80234c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802353:	e9 2a ff ff ff       	jmpq   802282 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802358:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80235c:	79 12                	jns    802370 <vprintfmt+0x177>
				width = precision, precision = -1;
  80235e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802361:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802364:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80236b:	e9 12 ff ff ff       	jmpq   802282 <vprintfmt+0x89>
  802370:	e9 0d ff ff ff       	jmpq   802282 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802375:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802379:	e9 04 ff ff ff       	jmpq   802282 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80237e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802381:	83 f8 30             	cmp    $0x30,%eax
  802384:	73 17                	jae    80239d <vprintfmt+0x1a4>
  802386:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80238a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80238d:	89 c0                	mov    %eax,%eax
  80238f:	48 01 d0             	add    %rdx,%rax
  802392:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802395:	83 c2 08             	add    $0x8,%edx
  802398:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80239b:	eb 0f                	jmp    8023ac <vprintfmt+0x1b3>
  80239d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023a1:	48 89 d0             	mov    %rdx,%rax
  8023a4:	48 83 c2 08          	add    $0x8,%rdx
  8023a8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8023ac:	8b 10                	mov    (%rax),%edx
  8023ae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8023b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8023b6:	48 89 ce             	mov    %rcx,%rsi
  8023b9:	89 d7                	mov    %edx,%edi
  8023bb:	ff d0                	callq  *%rax
			break;
  8023bd:	e9 40 03 00 00       	jmpq   802702 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8023c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023c5:	83 f8 30             	cmp    $0x30,%eax
  8023c8:	73 17                	jae    8023e1 <vprintfmt+0x1e8>
  8023ca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023d1:	89 c0                	mov    %eax,%eax
  8023d3:	48 01 d0             	add    %rdx,%rax
  8023d6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8023d9:	83 c2 08             	add    $0x8,%edx
  8023dc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8023df:	eb 0f                	jmp    8023f0 <vprintfmt+0x1f7>
  8023e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023e5:	48 89 d0             	mov    %rdx,%rax
  8023e8:	48 83 c2 08          	add    $0x8,%rdx
  8023ec:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8023f0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8023f2:	85 db                	test   %ebx,%ebx
  8023f4:	79 02                	jns    8023f8 <vprintfmt+0x1ff>
				err = -err;
  8023f6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8023f8:	83 fb 10             	cmp    $0x10,%ebx
  8023fb:	7f 16                	jg     802413 <vprintfmt+0x21a>
  8023fd:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  802404:	00 00 00 
  802407:	48 63 d3             	movslq %ebx,%rdx
  80240a:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80240e:	4d 85 e4             	test   %r12,%r12
  802411:	75 2e                	jne    802441 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802413:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802417:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80241b:	89 d9                	mov    %ebx,%ecx
  80241d:	48 ba f9 36 80 00 00 	movabs $0x8036f9,%rdx
  802424:	00 00 00 
  802427:	48 89 c7             	mov    %rax,%rdi
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
  80242f:	49 b8 11 27 80 00 00 	movabs $0x802711,%r8
  802436:	00 00 00 
  802439:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80243c:	e9 c1 02 00 00       	jmpq   802702 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802441:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802445:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802449:	4c 89 e1             	mov    %r12,%rcx
  80244c:	48 ba 02 37 80 00 00 	movabs $0x803702,%rdx
  802453:	00 00 00 
  802456:	48 89 c7             	mov    %rax,%rdi
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	49 b8 11 27 80 00 00 	movabs $0x802711,%r8
  802465:	00 00 00 
  802468:	41 ff d0             	callq  *%r8
			break;
  80246b:	e9 92 02 00 00       	jmpq   802702 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802470:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802473:	83 f8 30             	cmp    $0x30,%eax
  802476:	73 17                	jae    80248f <vprintfmt+0x296>
  802478:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80247c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80247f:	89 c0                	mov    %eax,%eax
  802481:	48 01 d0             	add    %rdx,%rax
  802484:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802487:	83 c2 08             	add    $0x8,%edx
  80248a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80248d:	eb 0f                	jmp    80249e <vprintfmt+0x2a5>
  80248f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802493:	48 89 d0             	mov    %rdx,%rax
  802496:	48 83 c2 08          	add    $0x8,%rdx
  80249a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80249e:	4c 8b 20             	mov    (%rax),%r12
  8024a1:	4d 85 e4             	test   %r12,%r12
  8024a4:	75 0a                	jne    8024b0 <vprintfmt+0x2b7>
				p = "(null)";
  8024a6:	49 bc 05 37 80 00 00 	movabs $0x803705,%r12
  8024ad:	00 00 00 
			if (width > 0 && padc != '-')
  8024b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024b4:	7e 3f                	jle    8024f5 <vprintfmt+0x2fc>
  8024b6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8024ba:	74 39                	je     8024f5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8024bc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8024bf:	48 98                	cltq   
  8024c1:	48 89 c6             	mov    %rax,%rsi
  8024c4:	4c 89 e7             	mov    %r12,%rdi
  8024c7:	48 b8 bd 29 80 00 00 	movabs $0x8029bd,%rax
  8024ce:	00 00 00 
  8024d1:	ff d0                	callq  *%rax
  8024d3:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8024d6:	eb 17                	jmp    8024ef <vprintfmt+0x2f6>
					putch(padc, putdat);
  8024d8:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8024dc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024e4:	48 89 ce             	mov    %rcx,%rsi
  8024e7:	89 d7                	mov    %edx,%edi
  8024e9:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8024eb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8024ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024f3:	7f e3                	jg     8024d8 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8024f5:	eb 37                	jmp    80252e <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8024f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8024fb:	74 1e                	je     80251b <vprintfmt+0x322>
  8024fd:	83 fb 1f             	cmp    $0x1f,%ebx
  802500:	7e 05                	jle    802507 <vprintfmt+0x30e>
  802502:	83 fb 7e             	cmp    $0x7e,%ebx
  802505:	7e 14                	jle    80251b <vprintfmt+0x322>
					putch('?', putdat);
  802507:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80250b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80250f:	48 89 d6             	mov    %rdx,%rsi
  802512:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802517:	ff d0                	callq  *%rax
  802519:	eb 0f                	jmp    80252a <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80251b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80251f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802523:	48 89 d6             	mov    %rdx,%rsi
  802526:	89 df                	mov    %ebx,%edi
  802528:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80252a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80252e:	4c 89 e0             	mov    %r12,%rax
  802531:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802535:	0f b6 00             	movzbl (%rax),%eax
  802538:	0f be d8             	movsbl %al,%ebx
  80253b:	85 db                	test   %ebx,%ebx
  80253d:	74 10                	je     80254f <vprintfmt+0x356>
  80253f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802543:	78 b2                	js     8024f7 <vprintfmt+0x2fe>
  802545:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802549:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80254d:	79 a8                	jns    8024f7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80254f:	eb 16                	jmp    802567 <vprintfmt+0x36e>
				putch(' ', putdat);
  802551:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802555:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802559:	48 89 d6             	mov    %rdx,%rsi
  80255c:	bf 20 00 00 00       	mov    $0x20,%edi
  802561:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802563:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802567:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80256b:	7f e4                	jg     802551 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80256d:	e9 90 01 00 00       	jmpq   802702 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802572:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802576:	be 03 00 00 00       	mov    $0x3,%esi
  80257b:	48 89 c7             	mov    %rax,%rdi
  80257e:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80258e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802592:	48 85 c0             	test   %rax,%rax
  802595:	79 1d                	jns    8025b4 <vprintfmt+0x3bb>
				putch('-', putdat);
  802597:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80259b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80259f:	48 89 d6             	mov    %rdx,%rsi
  8025a2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8025a7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8025a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ad:	48 f7 d8             	neg    %rax
  8025b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8025b4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8025bb:	e9 d5 00 00 00       	jmpq   802695 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8025c0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8025c4:	be 03 00 00 00       	mov    $0x3,%esi
  8025c9:	48 89 c7             	mov    %rax,%rdi
  8025cc:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8025d3:	00 00 00 
  8025d6:	ff d0                	callq  *%rax
  8025d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8025dc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8025e3:	e9 ad 00 00 00       	jmpq   802695 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8025e8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8025eb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8025ef:	89 d6                	mov    %edx,%esi
  8025f1:	48 89 c7             	mov    %rax,%rdi
  8025f4:	48 b8 e9 20 80 00 00 	movabs $0x8020e9,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  802604:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80260b:	e9 85 00 00 00       	jmpq   802695 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  802610:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802614:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802618:	48 89 d6             	mov    %rdx,%rsi
  80261b:	bf 30 00 00 00       	mov    $0x30,%edi
  802620:	ff d0                	callq  *%rax
			putch('x', putdat);
  802622:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802626:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80262a:	48 89 d6             	mov    %rdx,%rsi
  80262d:	bf 78 00 00 00       	mov    $0x78,%edi
  802632:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802634:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802637:	83 f8 30             	cmp    $0x30,%eax
  80263a:	73 17                	jae    802653 <vprintfmt+0x45a>
  80263c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802640:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802643:	89 c0                	mov    %eax,%eax
  802645:	48 01 d0             	add    %rdx,%rax
  802648:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80264b:	83 c2 08             	add    $0x8,%edx
  80264e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802651:	eb 0f                	jmp    802662 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  802653:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802657:	48 89 d0             	mov    %rdx,%rax
  80265a:	48 83 c2 08          	add    $0x8,%rdx
  80265e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802662:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802665:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802669:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802670:	eb 23                	jmp    802695 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  802672:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802676:	be 03 00 00 00       	mov    $0x3,%esi
  80267b:	48 89 c7             	mov    %rax,%rdi
  80267e:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80268e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802695:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80269a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80269d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8026a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026a4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026ac:	45 89 c1             	mov    %r8d,%r9d
  8026af:	41 89 f8             	mov    %edi,%r8d
  8026b2:	48 89 c7             	mov    %rax,%rdi
  8026b5:	48 b8 1e 1f 80 00 00 	movabs $0x801f1e,%rax
  8026bc:	00 00 00 
  8026bf:	ff d0                	callq  *%rax
			break;
  8026c1:	eb 3f                	jmp    802702 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8026c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026cb:	48 89 d6             	mov    %rdx,%rsi
  8026ce:	89 df                	mov    %ebx,%edi
  8026d0:	ff d0                	callq  *%rax
			break;
  8026d2:	eb 2e                	jmp    802702 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8026d4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026dc:	48 89 d6             	mov    %rdx,%rsi
  8026df:	bf 25 00 00 00       	mov    $0x25,%edi
  8026e4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8026e6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8026eb:	eb 05                	jmp    8026f2 <vprintfmt+0x4f9>
  8026ed:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8026f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8026f6:	48 83 e8 01          	sub    $0x1,%rax
  8026fa:	0f b6 00             	movzbl (%rax),%eax
  8026fd:	3c 25                	cmp    $0x25,%al
  8026ff:	75 ec                	jne    8026ed <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  802701:	90                   	nop
		}
	}
  802702:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802703:	e9 43 fb ff ff       	jmpq   80224b <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802708:	48 83 c4 60          	add    $0x60,%rsp
  80270c:	5b                   	pop    %rbx
  80270d:	41 5c                	pop    %r12
  80270f:	5d                   	pop    %rbp
  802710:	c3                   	retq   

0000000000802711 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802711:	55                   	push   %rbp
  802712:	48 89 e5             	mov    %rsp,%rbp
  802715:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80271c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802723:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80272a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802731:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802738:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80273f:	84 c0                	test   %al,%al
  802741:	74 20                	je     802763 <printfmt+0x52>
  802743:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802747:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80274b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80274f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802753:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802757:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80275b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80275f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802763:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80276a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  802771:	00 00 00 
  802774:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80277b:	00 00 00 
  80277e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802782:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802789:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802790:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802797:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80279e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027a5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8027ac:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8027b3:	48 89 c7             	mov    %rax,%rdi
  8027b6:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8027c2:	c9                   	leaveq 
  8027c3:	c3                   	retq   

00000000008027c4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8027c4:	55                   	push   %rbp
  8027c5:	48 89 e5             	mov    %rsp,%rbp
  8027c8:	48 83 ec 10          	sub    $0x10,%rsp
  8027cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8027d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d7:	8b 40 10             	mov    0x10(%rax),%eax
  8027da:	8d 50 01             	lea    0x1(%rax),%edx
  8027dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e8:	48 8b 10             	mov    (%rax),%rdx
  8027eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ef:	48 8b 40 08          	mov    0x8(%rax),%rax
  8027f3:	48 39 c2             	cmp    %rax,%rdx
  8027f6:	73 17                	jae    80280f <sprintputch+0x4b>
		*b->buf++ = ch;
  8027f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fc:	48 8b 00             	mov    (%rax),%rax
  8027ff:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802803:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802807:	48 89 0a             	mov    %rcx,(%rdx)
  80280a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80280d:	88 10                	mov    %dl,(%rax)
}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 50          	sub    $0x50,%rsp
  802819:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80281d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802820:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802824:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802828:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80282c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802830:	48 8b 0a             	mov    (%rdx),%rcx
  802833:	48 89 08             	mov    %rcx,(%rax)
  802836:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80283a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80283e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802842:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802846:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80284a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80284e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802851:	48 98                	cltq   
  802853:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802857:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80285b:	48 01 d0             	add    %rdx,%rax
  80285e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802869:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80286e:	74 06                	je     802876 <vsnprintf+0x65>
  802870:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802874:	7f 07                	jg     80287d <vsnprintf+0x6c>
		return -E_INVAL;
  802876:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80287b:	eb 2f                	jmp    8028ac <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80287d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802881:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802885:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802889:	48 89 c6             	mov    %rax,%rsi
  80288c:	48 bf c4 27 80 00 00 	movabs $0x8027c4,%rdi
  802893:	00 00 00 
  802896:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8028a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8028a9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8028ac:	c9                   	leaveq 
  8028ad:	c3                   	retq   

00000000008028ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8028ae:	55                   	push   %rbp
  8028af:	48 89 e5             	mov    %rsp,%rbp
  8028b2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8028b9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8028c0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8028c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8028cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8028d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8028db:	84 c0                	test   %al,%al
  8028dd:	74 20                	je     8028ff <snprintf+0x51>
  8028df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8028e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8028e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8028eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8028ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8028f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8028f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8028fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8028ff:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802906:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80290d:	00 00 00 
  802910:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802917:	00 00 00 
  80291a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80291e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802925:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80292c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802933:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80293a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802941:	48 8b 0a             	mov    (%rdx),%rcx
  802944:	48 89 08             	mov    %rcx,(%rax)
  802947:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80294b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80294f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802953:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802957:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80295e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802965:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80296b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802972:	48 89 c7             	mov    %rax,%rdi
  802975:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
  802981:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802987:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80298d:	c9                   	leaveq 
  80298e:	c3                   	retq   

000000000080298f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80298f:	55                   	push   %rbp
  802990:	48 89 e5             	mov    %rsp,%rbp
  802993:	48 83 ec 18          	sub    $0x18,%rsp
  802997:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80299b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029a2:	eb 09                	jmp    8029ad <strlen+0x1e>
		n++;
  8029a4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8029a8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8029ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b1:	0f b6 00             	movzbl (%rax),%eax
  8029b4:	84 c0                	test   %al,%al
  8029b6:	75 ec                	jne    8029a4 <strlen+0x15>
		n++;
	return n;
  8029b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029bb:	c9                   	leaveq 
  8029bc:	c3                   	retq   

00000000008029bd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8029bd:	55                   	push   %rbp
  8029be:	48 89 e5             	mov    %rsp,%rbp
  8029c1:	48 83 ec 20          	sub    $0x20,%rsp
  8029c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8029cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029d4:	eb 0e                	jmp    8029e4 <strnlen+0x27>
		n++;
  8029d6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8029da:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8029df:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8029e4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029e9:	74 0b                	je     8029f6 <strnlen+0x39>
  8029eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ef:	0f b6 00             	movzbl (%rax),%eax
  8029f2:	84 c0                	test   %al,%al
  8029f4:	75 e0                	jne    8029d6 <strnlen+0x19>
		n++;
	return n;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 20          	sub    $0x20,%rsp
  802a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802a13:	90                   	nop
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a1c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802a20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a24:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802a28:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802a2c:	0f b6 12             	movzbl (%rdx),%edx
  802a2f:	88 10                	mov    %dl,(%rax)
  802a31:	0f b6 00             	movzbl (%rax),%eax
  802a34:	84 c0                	test   %al,%al
  802a36:	75 dc                	jne    802a14 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802a3c:	c9                   	leaveq 
  802a3d:	c3                   	retq   

0000000000802a3e <strcat>:

char *
strcat(char *dst, const char *src)
{
  802a3e:	55                   	push   %rbp
  802a3f:	48 89 e5             	mov    %rsp,%rbp
  802a42:	48 83 ec 20          	sub    $0x20,%rsp
  802a46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a52:	48 89 c7             	mov    %rax,%rdi
  802a55:	48 b8 8f 29 80 00 00 	movabs $0x80298f,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
  802a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	48 63 d0             	movslq %eax,%rdx
  802a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6e:	48 01 c2             	add    %rax,%rdx
  802a71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a75:	48 89 c6             	mov    %rax,%rsi
  802a78:	48 89 d7             	mov    %rdx,%rdi
  802a7b:	48 b8 fb 29 80 00 00 	movabs $0x8029fb,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
	return dst;
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802a8b:	c9                   	leaveq 
  802a8c:	c3                   	retq   

0000000000802a8d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802a8d:	55                   	push   %rbp
  802a8e:	48 89 e5             	mov    %rsp,%rbp
  802a91:	48 83 ec 28          	sub    $0x28,%rsp
  802a95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802aa9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ab0:	00 
  802ab1:	eb 2a                	jmp    802add <strncpy+0x50>
		*dst++ = *src;
  802ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802abb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802abf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ac3:	0f b6 12             	movzbl (%rdx),%edx
  802ac6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ac8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802acc:	0f b6 00             	movzbl (%rax),%eax
  802acf:	84 c0                	test   %al,%al
  802ad1:	74 05                	je     802ad8 <strncpy+0x4b>
			src++;
  802ad3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802ad8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ae5:	72 cc                	jb     802ab3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802ae7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802aeb:	c9                   	leaveq 
  802aec:	c3                   	retq   

0000000000802aed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802aed:	55                   	push   %rbp
  802aee:	48 89 e5             	mov    %rsp,%rbp
  802af1:	48 83 ec 28          	sub    $0x28,%rsp
  802af5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802afd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802b09:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b0e:	74 3d                	je     802b4d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802b10:	eb 1d                	jmp    802b2f <strlcpy+0x42>
			*dst++ = *src++;
  802b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b16:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b1e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b22:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b26:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b2a:	0f b6 12             	movzbl (%rdx),%edx
  802b2d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802b2f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802b34:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b39:	74 0b                	je     802b46 <strlcpy+0x59>
  802b3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3f:	0f b6 00             	movzbl (%rax),%eax
  802b42:	84 c0                	test   %al,%al
  802b44:	75 cc                	jne    802b12 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802b4d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b55:	48 29 c2             	sub    %rax,%rdx
  802b58:	48 89 d0             	mov    %rdx,%rax
}
  802b5b:	c9                   	leaveq 
  802b5c:	c3                   	retq   

0000000000802b5d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
  802b61:	48 83 ec 10          	sub    $0x10,%rsp
  802b65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802b6d:	eb 0a                	jmp    802b79 <strcmp+0x1c>
		p++, q++;
  802b6f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802b74:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b7d:	0f b6 00             	movzbl (%rax),%eax
  802b80:	84 c0                	test   %al,%al
  802b82:	74 12                	je     802b96 <strcmp+0x39>
  802b84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b88:	0f b6 10             	movzbl (%rax),%edx
  802b8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8f:	0f b6 00             	movzbl (%rax),%eax
  802b92:	38 c2                	cmp    %al,%dl
  802b94:	74 d9                	je     802b6f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b9a:	0f b6 00             	movzbl (%rax),%eax
  802b9d:	0f b6 d0             	movzbl %al,%edx
  802ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba4:	0f b6 00             	movzbl (%rax),%eax
  802ba7:	0f b6 c0             	movzbl %al,%eax
  802baa:	29 c2                	sub    %eax,%edx
  802bac:	89 d0                	mov    %edx,%eax
}
  802bae:	c9                   	leaveq 
  802baf:	c3                   	retq   

0000000000802bb0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802bb0:	55                   	push   %rbp
  802bb1:	48 89 e5             	mov    %rsp,%rbp
  802bb4:	48 83 ec 18          	sub    $0x18,%rsp
  802bb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bc0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802bc4:	eb 0f                	jmp    802bd5 <strncmp+0x25>
		n--, p++, q++;
  802bc6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802bcb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802bd0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802bd5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802bda:	74 1d                	je     802bf9 <strncmp+0x49>
  802bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be0:	0f b6 00             	movzbl (%rax),%eax
  802be3:	84 c0                	test   %al,%al
  802be5:	74 12                	je     802bf9 <strncmp+0x49>
  802be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802beb:	0f b6 10             	movzbl (%rax),%edx
  802bee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf2:	0f b6 00             	movzbl (%rax),%eax
  802bf5:	38 c2                	cmp    %al,%dl
  802bf7:	74 cd                	je     802bc6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802bf9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802bfe:	75 07                	jne    802c07 <strncmp+0x57>
		return 0;
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
  802c05:	eb 18                	jmp    802c1f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c0b:	0f b6 00             	movzbl (%rax),%eax
  802c0e:	0f b6 d0             	movzbl %al,%edx
  802c11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c15:	0f b6 00             	movzbl (%rax),%eax
  802c18:	0f b6 c0             	movzbl %al,%eax
  802c1b:	29 c2                	sub    %eax,%edx
  802c1d:	89 d0                	mov    %edx,%eax
}
  802c1f:	c9                   	leaveq 
  802c20:	c3                   	retq   

0000000000802c21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802c21:	55                   	push   %rbp
  802c22:	48 89 e5             	mov    %rsp,%rbp
  802c25:	48 83 ec 0c          	sub    $0xc,%rsp
  802c29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c2d:	89 f0                	mov    %esi,%eax
  802c2f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802c32:	eb 17                	jmp    802c4b <strchr+0x2a>
		if (*s == c)
  802c34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c38:	0f b6 00             	movzbl (%rax),%eax
  802c3b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802c3e:	75 06                	jne    802c46 <strchr+0x25>
			return (char *) s;
  802c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c44:	eb 15                	jmp    802c5b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802c46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c4f:	0f b6 00             	movzbl (%rax),%eax
  802c52:	84 c0                	test   %al,%al
  802c54:	75 de                	jne    802c34 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5b:	c9                   	leaveq 
  802c5c:	c3                   	retq   

0000000000802c5d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802c5d:	55                   	push   %rbp
  802c5e:	48 89 e5             	mov    %rsp,%rbp
  802c61:	48 83 ec 0c          	sub    $0xc,%rsp
  802c65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c69:	89 f0                	mov    %esi,%eax
  802c6b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802c6e:	eb 13                	jmp    802c83 <strfind+0x26>
		if (*s == c)
  802c70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c74:	0f b6 00             	movzbl (%rax),%eax
  802c77:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802c7a:	75 02                	jne    802c7e <strfind+0x21>
			break;
  802c7c:	eb 10                	jmp    802c8e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802c7e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c87:	0f b6 00             	movzbl (%rax),%eax
  802c8a:	84 c0                	test   %al,%al
  802c8c:	75 e2                	jne    802c70 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c92:	c9                   	leaveq 
  802c93:	c3                   	retq   

0000000000802c94 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802c94:	55                   	push   %rbp
  802c95:	48 89 e5             	mov    %rsp,%rbp
  802c98:	48 83 ec 18          	sub    $0x18,%rsp
  802c9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ca0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802ca3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ca7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cac:	75 06                	jne    802cb4 <memset+0x20>
		return v;
  802cae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb2:	eb 69                	jmp    802d1d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb8:	83 e0 03             	and    $0x3,%eax
  802cbb:	48 85 c0             	test   %rax,%rax
  802cbe:	75 48                	jne    802d08 <memset+0x74>
  802cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc4:	83 e0 03             	and    $0x3,%eax
  802cc7:	48 85 c0             	test   %rax,%rax
  802cca:	75 3c                	jne    802d08 <memset+0x74>
		c &= 0xFF;
  802ccc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802cd3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cd6:	c1 e0 18             	shl    $0x18,%eax
  802cd9:	89 c2                	mov    %eax,%edx
  802cdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cde:	c1 e0 10             	shl    $0x10,%eax
  802ce1:	09 c2                	or     %eax,%edx
  802ce3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce6:	c1 e0 08             	shl    $0x8,%eax
  802ce9:	09 d0                	or     %edx,%eax
  802ceb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf2:	48 c1 e8 02          	shr    $0x2,%rax
  802cf6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802cf9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802cfd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d00:	48 89 d7             	mov    %rdx,%rdi
  802d03:	fc                   	cld    
  802d04:	f3 ab                	rep stos %eax,%es:(%rdi)
  802d06:	eb 11                	jmp    802d19 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802d08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d0c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d0f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d13:	48 89 d7             	mov    %rdx,%rdi
  802d16:	fc                   	cld    
  802d17:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802d19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d1d:	c9                   	leaveq 
  802d1e:	c3                   	retq   

0000000000802d1f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802d1f:	55                   	push   %rbp
  802d20:	48 89 e5             	mov    %rsp,%rbp
  802d23:	48 83 ec 28          	sub    $0x28,%rsp
  802d27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802d33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802d43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d47:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802d4b:	0f 83 88 00 00 00    	jae    802dd9 <memmove+0xba>
  802d51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d59:	48 01 d0             	add    %rdx,%rax
  802d5c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802d60:	76 77                	jbe    802dd9 <memmove+0xba>
		s += n;
  802d62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d66:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d76:	83 e0 03             	and    $0x3,%eax
  802d79:	48 85 c0             	test   %rax,%rax
  802d7c:	75 3b                	jne    802db9 <memmove+0x9a>
  802d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d82:	83 e0 03             	and    $0x3,%eax
  802d85:	48 85 c0             	test   %rax,%rax
  802d88:	75 2f                	jne    802db9 <memmove+0x9a>
  802d8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d8e:	83 e0 03             	and    $0x3,%eax
  802d91:	48 85 c0             	test   %rax,%rax
  802d94:	75 23                	jne    802db9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9a:	48 83 e8 04          	sub    $0x4,%rax
  802d9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802da2:	48 83 ea 04          	sub    $0x4,%rdx
  802da6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802daa:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802dae:	48 89 c7             	mov    %rax,%rdi
  802db1:	48 89 d6             	mov    %rdx,%rsi
  802db4:	fd                   	std    
  802db5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802db7:	eb 1d                	jmp    802dd6 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802db9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802dc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dcd:	48 89 d7             	mov    %rdx,%rdi
  802dd0:	48 89 c1             	mov    %rax,%rcx
  802dd3:	fd                   	std    
  802dd4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802dd6:	fc                   	cld    
  802dd7:	eb 57                	jmp    802e30 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddd:	83 e0 03             	and    $0x3,%eax
  802de0:	48 85 c0             	test   %rax,%rax
  802de3:	75 36                	jne    802e1b <memmove+0xfc>
  802de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de9:	83 e0 03             	and    $0x3,%eax
  802dec:	48 85 c0             	test   %rax,%rax
  802def:	75 2a                	jne    802e1b <memmove+0xfc>
  802df1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df5:	83 e0 03             	and    $0x3,%eax
  802df8:	48 85 c0             	test   %rax,%rax
  802dfb:	75 1e                	jne    802e1b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802dfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e01:	48 c1 e8 02          	shr    $0x2,%rax
  802e05:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e10:	48 89 c7             	mov    %rax,%rdi
  802e13:	48 89 d6             	mov    %rdx,%rsi
  802e16:	fc                   	cld    
  802e17:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802e19:	eb 15                	jmp    802e30 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802e1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e23:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802e27:	48 89 c7             	mov    %rax,%rdi
  802e2a:	48 89 d6             	mov    %rdx,%rsi
  802e2d:	fc                   	cld    
  802e2e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802e34:	c9                   	leaveq 
  802e35:	c3                   	retq   

0000000000802e36 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802e36:	55                   	push   %rbp
  802e37:	48 89 e5             	mov    %rsp,%rbp
  802e3a:	48 83 ec 18          	sub    $0x18,%rsp
  802e3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802e4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e4e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802e52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e56:	48 89 ce             	mov    %rcx,%rsi
  802e59:	48 89 c7             	mov    %rax,%rdi
  802e5c:	48 b8 1f 2d 80 00 00 	movabs $0x802d1f,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
}
  802e68:	c9                   	leaveq 
  802e69:	c3                   	retq   

0000000000802e6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802e6a:	55                   	push   %rbp
  802e6b:	48 89 e5             	mov    %rsp,%rbp
  802e6e:	48 83 ec 28          	sub    $0x28,%rsp
  802e72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802e8e:	eb 36                	jmp    802ec6 <memcmp+0x5c>
		if (*s1 != *s2)
  802e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e94:	0f b6 10             	movzbl (%rax),%edx
  802e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9b:	0f b6 00             	movzbl (%rax),%eax
  802e9e:	38 c2                	cmp    %al,%dl
  802ea0:	74 1a                	je     802ebc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea6:	0f b6 00             	movzbl (%rax),%eax
  802ea9:	0f b6 d0             	movzbl %al,%edx
  802eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb0:	0f b6 00             	movzbl (%rax),%eax
  802eb3:	0f b6 c0             	movzbl %al,%eax
  802eb6:	29 c2                	sub    %eax,%edx
  802eb8:	89 d0                	mov    %edx,%eax
  802eba:	eb 20                	jmp    802edc <memcmp+0x72>
		s1++, s2++;
  802ebc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ec1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eca:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ece:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802ed2:	48 85 c0             	test   %rax,%rax
  802ed5:	75 b9                	jne    802e90 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 28          	sub    $0x28,%rsp
  802ee6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eea:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802eed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ef9:	48 01 d0             	add    %rdx,%rax
  802efc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802f00:	eb 15                	jmp    802f17 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f06:	0f b6 10             	movzbl (%rax),%edx
  802f09:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f0c:	38 c2                	cmp    %al,%dl
  802f0e:	75 02                	jne    802f12 <memfind+0x34>
			break;
  802f10:	eb 0f                	jmp    802f21 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802f12:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802f1f:	72 e1                	jb     802f02 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f25:	c9                   	leaveq 
  802f26:	c3                   	retq   

0000000000802f27 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802f27:	55                   	push   %rbp
  802f28:	48 89 e5             	mov    %rsp,%rbp
  802f2b:	48 83 ec 34          	sub    $0x34,%rsp
  802f2f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f33:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f37:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802f41:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802f48:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802f49:	eb 05                	jmp    802f50 <strtol+0x29>
		s++;
  802f4b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802f50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f54:	0f b6 00             	movzbl (%rax),%eax
  802f57:	3c 20                	cmp    $0x20,%al
  802f59:	74 f0                	je     802f4b <strtol+0x24>
  802f5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5f:	0f b6 00             	movzbl (%rax),%eax
  802f62:	3c 09                	cmp    $0x9,%al
  802f64:	74 e5                	je     802f4b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6a:	0f b6 00             	movzbl (%rax),%eax
  802f6d:	3c 2b                	cmp    $0x2b,%al
  802f6f:	75 07                	jne    802f78 <strtol+0x51>
		s++;
  802f71:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802f76:	eb 17                	jmp    802f8f <strtol+0x68>
	else if (*s == '-')
  802f78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7c:	0f b6 00             	movzbl (%rax),%eax
  802f7f:	3c 2d                	cmp    $0x2d,%al
  802f81:	75 0c                	jne    802f8f <strtol+0x68>
		s++, neg = 1;
  802f83:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802f88:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802f8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802f93:	74 06                	je     802f9b <strtol+0x74>
  802f95:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802f99:	75 28                	jne    802fc3 <strtol+0x9c>
  802f9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9f:	0f b6 00             	movzbl (%rax),%eax
  802fa2:	3c 30                	cmp    $0x30,%al
  802fa4:	75 1d                	jne    802fc3 <strtol+0x9c>
  802fa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802faa:	48 83 c0 01          	add    $0x1,%rax
  802fae:	0f b6 00             	movzbl (%rax),%eax
  802fb1:	3c 78                	cmp    $0x78,%al
  802fb3:	75 0e                	jne    802fc3 <strtol+0x9c>
		s += 2, base = 16;
  802fb5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802fba:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802fc1:	eb 2c                	jmp    802fef <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802fc3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fc7:	75 19                	jne    802fe2 <strtol+0xbb>
  802fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcd:	0f b6 00             	movzbl (%rax),%eax
  802fd0:	3c 30                	cmp    $0x30,%al
  802fd2:	75 0e                	jne    802fe2 <strtol+0xbb>
		s++, base = 8;
  802fd4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802fd9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802fe0:	eb 0d                	jmp    802fef <strtol+0xc8>
	else if (base == 0)
  802fe2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fe6:	75 07                	jne    802fef <strtol+0xc8>
		base = 10;
  802fe8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802fef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff3:	0f b6 00             	movzbl (%rax),%eax
  802ff6:	3c 2f                	cmp    $0x2f,%al
  802ff8:	7e 1d                	jle    803017 <strtol+0xf0>
  802ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ffe:	0f b6 00             	movzbl (%rax),%eax
  803001:	3c 39                	cmp    $0x39,%al
  803003:	7f 12                	jg     803017 <strtol+0xf0>
			dig = *s - '0';
  803005:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803009:	0f b6 00             	movzbl (%rax),%eax
  80300c:	0f be c0             	movsbl %al,%eax
  80300f:	83 e8 30             	sub    $0x30,%eax
  803012:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803015:	eb 4e                	jmp    803065 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803017:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80301b:	0f b6 00             	movzbl (%rax),%eax
  80301e:	3c 60                	cmp    $0x60,%al
  803020:	7e 1d                	jle    80303f <strtol+0x118>
  803022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803026:	0f b6 00             	movzbl (%rax),%eax
  803029:	3c 7a                	cmp    $0x7a,%al
  80302b:	7f 12                	jg     80303f <strtol+0x118>
			dig = *s - 'a' + 10;
  80302d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803031:	0f b6 00             	movzbl (%rax),%eax
  803034:	0f be c0             	movsbl %al,%eax
  803037:	83 e8 57             	sub    $0x57,%eax
  80303a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80303d:	eb 26                	jmp    803065 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80303f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803043:	0f b6 00             	movzbl (%rax),%eax
  803046:	3c 40                	cmp    $0x40,%al
  803048:	7e 48                	jle    803092 <strtol+0x16b>
  80304a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304e:	0f b6 00             	movzbl (%rax),%eax
  803051:	3c 5a                	cmp    $0x5a,%al
  803053:	7f 3d                	jg     803092 <strtol+0x16b>
			dig = *s - 'A' + 10;
  803055:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803059:	0f b6 00             	movzbl (%rax),%eax
  80305c:	0f be c0             	movsbl %al,%eax
  80305f:	83 e8 37             	sub    $0x37,%eax
  803062:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803065:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803068:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80306b:	7c 02                	jl     80306f <strtol+0x148>
			break;
  80306d:	eb 23                	jmp    803092 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80306f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803074:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803077:	48 98                	cltq   
  803079:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80307e:	48 89 c2             	mov    %rax,%rdx
  803081:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803084:	48 98                	cltq   
  803086:	48 01 d0             	add    %rdx,%rax
  803089:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80308d:	e9 5d ff ff ff       	jmpq   802fef <strtol+0xc8>

	if (endptr)
  803092:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803097:	74 0b                	je     8030a4 <strtol+0x17d>
		*endptr = (char *) s;
  803099:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80309d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8030a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a8:	74 09                	je     8030b3 <strtol+0x18c>
  8030aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ae:	48 f7 d8             	neg    %rax
  8030b1:	eb 04                	jmp    8030b7 <strtol+0x190>
  8030b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8030b7:	c9                   	leaveq 
  8030b8:	c3                   	retq   

00000000008030b9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8030b9:	55                   	push   %rbp
  8030ba:	48 89 e5             	mov    %rsp,%rbp
  8030bd:	48 83 ec 30          	sub    $0x30,%rsp
  8030c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8030c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8030d1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8030d5:	0f b6 00             	movzbl (%rax),%eax
  8030d8:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8030db:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8030df:	75 06                	jne    8030e7 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8030e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e5:	eb 6b                	jmp    803152 <strstr+0x99>

    len = strlen(str);
  8030e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030eb:	48 89 c7             	mov    %rax,%rdi
  8030ee:	48 b8 8f 29 80 00 00 	movabs $0x80298f,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	48 98                	cltq   
  8030fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  803100:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803104:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803108:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80310c:	0f b6 00             	movzbl (%rax),%eax
  80310f:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  803112:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803116:	75 07                	jne    80311f <strstr+0x66>
                return (char *) 0;
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	eb 33                	jmp    803152 <strstr+0x99>
        } while (sc != c);
  80311f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803123:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803126:	75 d8                	jne    803100 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  803128:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80312c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803130:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803134:	48 89 ce             	mov    %rcx,%rsi
  803137:	48 89 c7             	mov    %rax,%rdi
  80313a:	48 b8 b0 2b 80 00 00 	movabs $0x802bb0,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 b6                	jne    803100 <strstr+0x47>

    return (char *) (in - 1);
  80314a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314e:	48 83 e8 01          	sub    $0x1,%rax
}
  803152:	c9                   	leaveq 
  803153:	c3                   	retq   

0000000000803154 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 30          	sub    $0x30,%rsp
  80315c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803160:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803164:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803168:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80316f:	00 00 00 
  803172:	48 8b 00             	mov    (%rax),%rax
  803175:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	75 3c                	jne    8031bb <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80317f:	48 b8 7f 02 80 00 00 	movabs $0x80027f,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
  80318b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803190:	48 63 d0             	movslq %eax,%rdx
  803193:	48 89 d0             	mov    %rdx,%rax
  803196:	48 c1 e0 03          	shl    $0x3,%rax
  80319a:	48 01 d0             	add    %rdx,%rax
  80319d:	48 c1 e0 05          	shl    $0x5,%rax
  8031a1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8031a8:	00 00 00 
  8031ab:	48 01 c2             	add    %rax,%rdx
  8031ae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031b5:	00 00 00 
  8031b8:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8031bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031c0:	75 0e                	jne    8031d0 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8031c2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8031c9:	00 00 00 
  8031cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8031d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d4:	48 89 c7             	mov    %rax,%rdi
  8031d7:	48 b8 24 05 80 00 00 	movabs $0x800524,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8031e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ea:	79 19                	jns    803205 <ipc_recv+0xb1>
		*from_env_store = 0;
  8031ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8031f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803203:	eb 53                	jmp    803258 <ipc_recv+0x104>
	}
	if(from_env_store)
  803205:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80320a:	74 19                	je     803225 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80320c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803213:	00 00 00 
  803216:	48 8b 00             	mov    (%rax),%rax
  803219:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80321f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803223:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803225:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80322a:	74 19                	je     803245 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80322c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803233:	00 00 00 
  803236:	48 8b 00             	mov    (%rax),%rax
  803239:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80323f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803243:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80324c:	00 00 00 
  80324f:	48 8b 00             	mov    (%rax),%rax
  803252:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803258:	c9                   	leaveq 
  803259:	c3                   	retq   

000000000080325a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80325a:	55                   	push   %rbp
  80325b:	48 89 e5             	mov    %rsp,%rbp
  80325e:	48 83 ec 30          	sub    $0x30,%rsp
  803262:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803265:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803268:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80326c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80326f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803274:	75 0e                	jne    803284 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803276:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80327d:	00 00 00 
  803280:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803284:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803287:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80328a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80328e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803291:	89 c7                	mov    %eax,%edi
  803293:	48 b8 cf 04 80 00 00 	movabs $0x8004cf,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
  80329f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8032a2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032a6:	75 0c                	jne    8032b4 <ipc_send+0x5a>
			sys_yield();
  8032a8:	48 b8 bd 02 80 00 00 	movabs $0x8002bd,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8032b4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032b8:	74 ca                	je     803284 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 14          	sub    $0x14,%rsp
  8032c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8032c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032ce:	eb 5e                	jmp    80332e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8032d0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032d7:	00 00 00 
  8032da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032dd:	48 63 d0             	movslq %eax,%rdx
  8032e0:	48 89 d0             	mov    %rdx,%rax
  8032e3:	48 c1 e0 03          	shl    $0x3,%rax
  8032e7:	48 01 d0             	add    %rdx,%rax
  8032ea:	48 c1 e0 05          	shl    $0x5,%rax
  8032ee:	48 01 c8             	add    %rcx,%rax
  8032f1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8032f7:	8b 00                	mov    (%rax),%eax
  8032f9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8032fc:	75 2c                	jne    80332a <ipc_find_env+0x6e>
			return envs[i].env_id;
  8032fe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803305:	00 00 00 
  803308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330b:	48 63 d0             	movslq %eax,%rdx
  80330e:	48 89 d0             	mov    %rdx,%rax
  803311:	48 c1 e0 03          	shl    $0x3,%rax
  803315:	48 01 d0             	add    %rdx,%rax
  803318:	48 c1 e0 05          	shl    $0x5,%rax
  80331c:	48 01 c8             	add    %rcx,%rax
  80331f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803325:	8b 40 08             	mov    0x8(%rax),%eax
  803328:	eb 12                	jmp    80333c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80332a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80332e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803335:	7e 99                	jle    8032d0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80333c:	c9                   	leaveq 
  80333d:	c3                   	retq   

000000000080333e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80333e:	55                   	push   %rbp
  80333f:	48 89 e5             	mov    %rsp,%rbp
  803342:	48 83 ec 18          	sub    $0x18,%rsp
  803346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	48 c1 e8 15          	shr    $0x15,%rax
  803352:	48 89 c2             	mov    %rax,%rdx
  803355:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80335c:	01 00 00 
  80335f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803363:	83 e0 01             	and    $0x1,%eax
  803366:	48 85 c0             	test   %rax,%rax
  803369:	75 07                	jne    803372 <pageref+0x34>
		return 0;
  80336b:	b8 00 00 00 00       	mov    $0x0,%eax
  803370:	eb 53                	jmp    8033c5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803376:	48 c1 e8 0c          	shr    $0xc,%rax
  80337a:	48 89 c2             	mov    %rax,%rdx
  80337d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803384:	01 00 00 
  803387:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80338b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80338f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803393:	83 e0 01             	and    $0x1,%eax
  803396:	48 85 c0             	test   %rax,%rax
  803399:	75 07                	jne    8033a2 <pageref+0x64>
		return 0;
  80339b:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a0:	eb 23                	jmp    8033c5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8033a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8033aa:	48 89 c2             	mov    %rax,%rdx
  8033ad:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8033b4:	00 00 00 
  8033b7:	48 c1 e2 04          	shl    $0x4,%rdx
  8033bb:	48 01 d0             	add    %rdx,%rax
  8033be:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8033c2:	0f b7 c0             	movzwl %ax,%eax
}
  8033c5:	c9                   	leaveq 
  8033c6:	c3                   	retq   
