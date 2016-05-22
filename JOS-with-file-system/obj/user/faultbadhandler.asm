
obj/user/faultbadhandler.debug:     file format elf64-x86-64


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
  80003c:	e8 4f 00 00 00       	callq  800090 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  80006d:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 9e 04 80 00 00 	movabs $0x80049e,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	c9                   	leaveq 
  80008f:	c3                   	retq   

0000000000800090 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800090:	55                   	push   %rbp
  800091:	48 89 e5             	mov    %rsp,%rbp
  800094:	48 83 ec 10          	sub    $0x10,%rsp
  800098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80009f:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  8000a6:	00 00 00 
  8000a9:	ff d0                	callq  *%rax
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	48 63 d0             	movslq %eax,%rdx
  8000b3:	48 89 d0             	mov    %rdx,%rax
  8000b6:	48 c1 e0 03          	shl    $0x3,%rax
  8000ba:	48 01 d0             	add    %rdx,%rax
  8000bd:	48 c1 e0 05          	shl    $0x5,%rax
  8000c1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c8:	00 00 00 
  8000cb:	48 01 c2             	add    %rax,%rdx
  8000ce:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000d5:	00 00 00 
  8000d8:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000df:	7e 14                	jle    8000f5 <libmain+0x65>
		binaryname = argv[0];
  8000e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e5:	48 8b 10             	mov    (%rax),%rdx
  8000e8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000ef:	00 00 00 
  8000f2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000fc:	48 89 d6             	mov    %rdx,%rsi
  8000ff:	89 c7                	mov    %eax,%edi
  800101:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80010d:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
}
  800119:	c9                   	leaveq 
  80011a:	c3                   	retq   

000000000080011b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011b:	55                   	push   %rbp
  80011c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80011f:	48 b8 c2 08 80 00 00 	movabs $0x8008c2,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80012b:	bf 00 00 00 00       	mov    $0x0,%edi
  800130:	48 b8 54 02 80 00 00 	movabs $0x800254,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax

}
  80013c:	5d                   	pop    %rbp
  80013d:	c3                   	retq   

000000000080013e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	53                   	push   %rbx
  800143:	48 83 ec 48          	sub    $0x48,%rsp
  800147:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80014a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80014d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800151:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800155:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800159:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80015d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800160:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800164:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800168:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80016c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800170:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800174:	4c 89 c3             	mov    %r8,%rbx
  800177:	cd 30                	int    $0x30
  800179:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80017d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800181:	74 3e                	je     8001c1 <syscall+0x83>
  800183:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800188:	7e 37                	jle    8001c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80018e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800191:	49 89 d0             	mov    %rdx,%r8
  800194:	89 c1                	mov    %eax,%ecx
  800196:	48 ba ea 33 80 00 00 	movabs $0x8033ea,%rdx
  80019d:	00 00 00 
  8001a0:	be 23 00 00 00       	mov    $0x23,%esi
  8001a5:	48 bf 07 34 80 00 00 	movabs $0x803407,%rdi
  8001ac:	00 00 00 
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b4:	49 b9 26 1c 80 00 00 	movabs $0x801c26,%r9
  8001bb:	00 00 00 
  8001be:	41 ff d1             	callq  *%r9

	return ret;
  8001c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001c5:	48 83 c4 48          	add    $0x48,%rsp
  8001c9:	5b                   	pop    %rbx
  8001ca:	5d                   	pop    %rbp
  8001cb:	c3                   	retq   

00000000008001cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 20          	sub    $0x20,%rsp
  8001d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001eb:	00 
  8001ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001f8:	48 89 d1             	mov    %rdx,%rcx
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	be 00 00 00 00       	mov    $0x0,%esi
  800203:	bf 00 00 00 00       	mov    $0x0,%edi
  800208:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
}
  800214:	c9                   	leaveq 
  800215:	c3                   	retq   

0000000000800216 <sys_cgetc>:

int
sys_cgetc(void)
{
  800216:	55                   	push   %rbp
  800217:	48 89 e5             	mov    %rsp,%rbp
  80021a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80021e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800225:	00 
  800226:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80022c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	ba 00 00 00 00       	mov    $0x0,%edx
  80023c:	be 00 00 00 00       	mov    $0x0,%esi
  800241:	bf 01 00 00 00       	mov    $0x1,%edi
  800246:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
}
  800252:	c9                   	leaveq 
  800253:	c3                   	retq   

0000000000800254 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800254:	55                   	push   %rbp
  800255:	48 89 e5             	mov    %rsp,%rbp
  800258:	48 83 ec 10          	sub    $0x10,%rsp
  80025c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80025f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800262:	48 98                	cltq   
  800264:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80026b:	00 
  80026c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800272:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800278:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027d:	48 89 c2             	mov    %rax,%rdx
  800280:	be 01 00 00 00       	mov    $0x1,%esi
  800285:	bf 03 00 00 00       	mov    $0x3,%edi
  80028a:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800291:	00 00 00 
  800294:	ff d0                	callq  *%rax
}
  800296:	c9                   	leaveq 
  800297:	c3                   	retq   

0000000000800298 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800298:	55                   	push   %rbp
  800299:	48 89 e5             	mov    %rsp,%rbp
  80029c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002a7:	00 
  8002a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002be:	be 00 00 00 00       	mov    $0x0,%esi
  8002c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8002c8:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax
}
  8002d4:	c9                   	leaveq 
  8002d5:	c3                   	retq   

00000000008002d6 <sys_yield>:

void
sys_yield(void)
{
  8002d6:	55                   	push   %rbp
  8002d7:	48 89 e5             	mov    %rsp,%rbp
  8002da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002e5:	00 
  8002e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	bf 0b 00 00 00       	mov    $0xb,%edi
  800306:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
}
  800312:	c9                   	leaveq 
  800313:	c3                   	retq   

0000000000800314 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800314:	55                   	push   %rbp
  800315:	48 89 e5             	mov    %rsp,%rbp
  800318:	48 83 ec 20          	sub    $0x20,%rsp
  80031c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80031f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800323:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800326:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800329:	48 63 c8             	movslq %eax,%rcx
  80032c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800333:	48 98                	cltq   
  800335:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80033c:	00 
  80033d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800343:	49 89 c8             	mov    %rcx,%r8
  800346:	48 89 d1             	mov    %rdx,%rcx
  800349:	48 89 c2             	mov    %rax,%rdx
  80034c:	be 01 00 00 00       	mov    $0x1,%esi
  800351:	bf 04 00 00 00       	mov    $0x4,%edi
  800356:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80035d:	00 00 00 
  800360:	ff d0                	callq  *%rax
}
  800362:	c9                   	leaveq 
  800363:	c3                   	retq   

0000000000800364 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	48 83 ec 30          	sub    $0x30,%rsp
  80036c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800373:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800376:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80037a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80037e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800381:	48 63 c8             	movslq %eax,%rcx
  800384:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800388:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80038b:	48 63 f0             	movslq %eax,%rsi
  80038e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800395:	48 98                	cltq   
  800397:	48 89 0c 24          	mov    %rcx,(%rsp)
  80039b:	49 89 f9             	mov    %rdi,%r9
  80039e:	49 89 f0             	mov    %rsi,%r8
  8003a1:	48 89 d1             	mov    %rdx,%rcx
  8003a4:	48 89 c2             	mov    %rax,%rdx
  8003a7:	be 01 00 00 00       	mov    $0x1,%esi
  8003ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8003b1:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	callq  *%rax
}
  8003bd:	c9                   	leaveq 
  8003be:	c3                   	retq   

00000000008003bf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003bf:	55                   	push   %rbp
  8003c0:	48 89 e5             	mov    %rsp,%rbp
  8003c3:	48 83 ec 20          	sub    $0x20,%rsp
  8003c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003d5:	48 98                	cltq   
  8003d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003de:	00 
  8003df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003eb:	48 89 d1             	mov    %rdx,%rcx
  8003ee:	48 89 c2             	mov    %rax,%rdx
  8003f1:	be 01 00 00 00       	mov    $0x1,%esi
  8003f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8003fb:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
}
  800407:	c9                   	leaveq 
  800408:	c3                   	retq   

0000000000800409 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800409:	55                   	push   %rbp
  80040a:	48 89 e5             	mov    %rsp,%rbp
  80040d:	48 83 ec 10          	sub    $0x10,%rsp
  800411:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800414:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800417:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80041a:	48 63 d0             	movslq %eax,%rdx
  80041d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800420:	48 98                	cltq   
  800422:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800429:	00 
  80042a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800430:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800436:	48 89 d1             	mov    %rdx,%rcx
  800439:	48 89 c2             	mov    %rax,%rdx
  80043c:	be 01 00 00 00       	mov    $0x1,%esi
  800441:	bf 08 00 00 00       	mov    $0x8,%edi
  800446:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
}
  800452:	c9                   	leaveq 
  800453:	c3                   	retq   

0000000000800454 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800454:	55                   	push   %rbp
  800455:	48 89 e5             	mov    %rsp,%rbp
  800458:	48 83 ec 20          	sub    $0x20,%rsp
  80045c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80045f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800463:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80046a:	48 98                	cltq   
  80046c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800473:	00 
  800474:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80047a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800480:	48 89 d1             	mov    %rdx,%rcx
  800483:	48 89 c2             	mov    %rax,%rdx
  800486:	be 01 00 00 00       	mov    $0x1,%esi
  80048b:	bf 09 00 00 00       	mov    $0x9,%edi
  800490:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
}
  80049c:	c9                   	leaveq 
  80049d:	c3                   	retq   

000000000080049e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80049e:	55                   	push   %rbp
  80049f:	48 89 e5             	mov    %rsp,%rbp
  8004a2:	48 83 ec 20          	sub    $0x20,%rsp
  8004a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b4:	48 98                	cltq   
  8004b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004bd:	00 
  8004be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ca:	48 89 d1             	mov    %rdx,%rcx
  8004cd:	48 89 c2             	mov    %rax,%rdx
  8004d0:	be 01 00 00 00       	mov    $0x1,%esi
  8004d5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004da:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax
}
  8004e6:	c9                   	leaveq 
  8004e7:	c3                   	retq   

00000000008004e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	48 83 ec 20          	sub    $0x20,%rsp
  8004f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004fb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800501:	48 63 f0             	movslq %eax,%rsi
  800504:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800508:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80050b:	48 98                	cltq   
  80050d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800511:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800518:	00 
  800519:	49 89 f1             	mov    %rsi,%r9
  80051c:	49 89 c8             	mov    %rcx,%r8
  80051f:	48 89 d1             	mov    %rdx,%rcx
  800522:	48 89 c2             	mov    %rax,%rdx
  800525:	be 00 00 00 00       	mov    $0x0,%esi
  80052a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80052f:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800536:	00 00 00 
  800539:	ff d0                	callq  *%rax
}
  80053b:	c9                   	leaveq 
  80053c:	c3                   	retq   

000000000080053d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80053d:	55                   	push   %rbp
  80053e:	48 89 e5             	mov    %rsp,%rbp
  800541:	48 83 ec 10          	sub    $0x10,%rsp
  800545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80054d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800554:	00 
  800555:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80055b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800561:	b9 00 00 00 00       	mov    $0x0,%ecx
  800566:	48 89 c2             	mov    %rax,%rdx
  800569:	be 01 00 00 00       	mov    $0x1,%esi
  80056e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800573:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	callq  *%rax
}
  80057f:	c9                   	leaveq 
  800580:	c3                   	retq   

0000000000800581 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800581:	55                   	push   %rbp
  800582:	48 89 e5             	mov    %rsp,%rbp
  800585:	48 83 ec 08          	sub    $0x8,%rsp
  800589:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80058d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800591:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800598:	ff ff ff 
  80059b:	48 01 d0             	add    %rdx,%rax
  80059e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005a2:	c9                   	leaveq 
  8005a3:	c3                   	retq   

00000000008005a4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005a4:	55                   	push   %rbp
  8005a5:	48 89 e5             	mov    %rsp,%rbp
  8005a8:	48 83 ec 08          	sub    $0x8,%rsp
  8005ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8005b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b4:	48 89 c7             	mov    %rax,%rdi
  8005b7:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  8005be:	00 00 00 
  8005c1:	ff d0                	callq  *%rax
  8005c3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005c9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005cd:	c9                   	leaveq 
  8005ce:	c3                   	retq   

00000000008005cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005cf:	55                   	push   %rbp
  8005d0:	48 89 e5             	mov    %rsp,%rbp
  8005d3:	48 83 ec 18          	sub    $0x18,%rsp
  8005d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005e2:	eb 6b                	jmp    80064f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e7:	48 98                	cltq   
  8005e9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8005f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005fb:	48 c1 e8 15          	shr    $0x15,%rax
  8005ff:	48 89 c2             	mov    %rax,%rdx
  800602:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800609:	01 00 00 
  80060c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800610:	83 e0 01             	and    $0x1,%eax
  800613:	48 85 c0             	test   %rax,%rax
  800616:	74 21                	je     800639 <fd_alloc+0x6a>
  800618:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061c:	48 c1 e8 0c          	shr    $0xc,%rax
  800620:	48 89 c2             	mov    %rax,%rdx
  800623:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80062a:	01 00 00 
  80062d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800631:	83 e0 01             	and    $0x1,%eax
  800634:	48 85 c0             	test   %rax,%rax
  800637:	75 12                	jne    80064b <fd_alloc+0x7c>
			*fd_store = fd;
  800639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800641:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	eb 1a                	jmp    800665 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80064b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80064f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800653:	7e 8f                	jle    8005e4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800660:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800665:	c9                   	leaveq 
  800666:	c3                   	retq   

0000000000800667 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800667:	55                   	push   %rbp
  800668:	48 89 e5             	mov    %rsp,%rbp
  80066b:	48 83 ec 20          	sub    $0x20,%rsp
  80066f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800676:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80067a:	78 06                	js     800682 <fd_lookup+0x1b>
  80067c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800680:	7e 07                	jle    800689 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800682:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800687:	eb 6c                	jmp    8006f5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800689:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80068c:	48 98                	cltq   
  80068e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800694:	48 c1 e0 0c          	shl    $0xc,%rax
  800698:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80069c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a0:	48 c1 e8 15          	shr    $0x15,%rax
  8006a4:	48 89 c2             	mov    %rax,%rdx
  8006a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006ae:	01 00 00 
  8006b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006b5:	83 e0 01             	and    $0x1,%eax
  8006b8:	48 85 c0             	test   %rax,%rax
  8006bb:	74 21                	je     8006de <fd_lookup+0x77>
  8006bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c1:	48 c1 e8 0c          	shr    $0xc,%rax
  8006c5:	48 89 c2             	mov    %rax,%rdx
  8006c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006cf:	01 00 00 
  8006d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006d6:	83 e0 01             	and    $0x1,%eax
  8006d9:	48 85 c0             	test   %rax,%rax
  8006dc:	75 07                	jne    8006e5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e3:	eb 10                	jmp    8006f5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006ed:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006f5:	c9                   	leaveq 
  8006f6:	c3                   	retq   

00000000008006f7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006f7:	55                   	push   %rbp
  8006f8:	48 89 e5             	mov    %rsp,%rbp
  8006fb:	48 83 ec 30          	sub    $0x30,%rsp
  8006ff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800703:	89 f0                	mov    %esi,%eax
  800705:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80070c:	48 89 c7             	mov    %rax,%rdi
  80070f:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  800716:	00 00 00 
  800719:	ff d0                	callq  *%rax
  80071b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80071f:	48 89 d6             	mov    %rdx,%rsi
  800722:	89 c7                	mov    %eax,%edi
  800724:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  80072b:	00 00 00 
  80072e:	ff d0                	callq  *%rax
  800730:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800733:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800737:	78 0a                	js     800743 <fd_close+0x4c>
	    || fd != fd2)
  800739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800741:	74 12                	je     800755 <fd_close+0x5e>
		return (must_exist ? r : 0);
  800743:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800747:	74 05                	je     80074e <fd_close+0x57>
  800749:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80074c:	eb 05                	jmp    800753 <fd_close+0x5c>
  80074e:	b8 00 00 00 00       	mov    $0x0,%eax
  800753:	eb 69                	jmp    8007be <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800759:	8b 00                	mov    (%rax),%eax
  80075b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80075f:	48 89 d6             	mov    %rdx,%rsi
  800762:	89 c7                	mov    %eax,%edi
  800764:	48 b8 c0 07 80 00 00 	movabs $0x8007c0,%rax
  80076b:	00 00 00 
  80076e:	ff d0                	callq  *%rax
  800770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800777:	78 2a                	js     8007a3 <fd_close+0xac>
		if (dev->dev_close)
  800779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077d:	48 8b 40 20          	mov    0x20(%rax),%rax
  800781:	48 85 c0             	test   %rax,%rax
  800784:	74 16                	je     80079c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80078e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800792:	48 89 d7             	mov    %rdx,%rdi
  800795:	ff d0                	callq  *%rax
  800797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80079a:	eb 07                	jmp    8007a3 <fd_close+0xac>
		else
			r = 0;
  80079c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8007a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007a7:	48 89 c6             	mov    %rax,%rsi
  8007aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8007af:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  8007b6:	00 00 00 
  8007b9:	ff d0                	callq  *%rax
	return r;
  8007bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007be:	c9                   	leaveq 
  8007bf:	c3                   	retq   

00000000008007c0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007c0:	55                   	push   %rbp
  8007c1:	48 89 e5             	mov    %rsp,%rbp
  8007c4:	48 83 ec 20          	sub    $0x20,%rsp
  8007c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007d6:	eb 41                	jmp    800819 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007d8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007df:	00 00 00 
  8007e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007e5:	48 63 d2             	movslq %edx,%rdx
  8007e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007f1:	75 22                	jne    800815 <dev_lookup+0x55>
			*dev = devtab[i];
  8007f3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007fa:	00 00 00 
  8007fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800800:	48 63 d2             	movslq %edx,%rdx
  800803:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800807:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80080b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	eb 60                	jmp    800875 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800815:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800819:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800820:	00 00 00 
  800823:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800826:	48 63 d2             	movslq %edx,%rdx
  800829:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80082d:	48 85 c0             	test   %rax,%rax
  800830:	75 a6                	jne    8007d8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800832:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800839:	00 00 00 
  80083c:	48 8b 00             	mov    (%rax),%rax
  80083f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800845:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800848:	89 c6                	mov    %eax,%esi
  80084a:	48 bf 18 34 80 00 00 	movabs $0x803418,%rdi
  800851:	00 00 00 
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	48 b9 5f 1e 80 00 00 	movabs $0x801e5f,%rcx
  800860:	00 00 00 
  800863:	ff d1                	callq  *%rcx
	*dev = 0;
  800865:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800869:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800870:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800875:	c9                   	leaveq 
  800876:	c3                   	retq   

0000000000800877 <close>:

int
close(int fdnum)
{
  800877:	55                   	push   %rbp
  800878:	48 89 e5             	mov    %rsp,%rbp
  80087b:	48 83 ec 20          	sub    $0x20,%rsp
  80087f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800882:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800886:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800889:	48 89 d6             	mov    %rdx,%rsi
  80088c:	89 c7                	mov    %eax,%edi
  80088e:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800895:	00 00 00 
  800898:	ff d0                	callq  *%rax
  80089a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80089d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008a1:	79 05                	jns    8008a8 <close+0x31>
		return r;
  8008a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a6:	eb 18                	jmp    8008c0 <close+0x49>
	else
		return fd_close(fd, 1);
  8008a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008ac:	be 01 00 00 00       	mov    $0x1,%esi
  8008b1:	48 89 c7             	mov    %rax,%rdi
  8008b4:	48 b8 f7 06 80 00 00 	movabs $0x8006f7,%rax
  8008bb:	00 00 00 
  8008be:	ff d0                	callq  *%rax
}
  8008c0:	c9                   	leaveq 
  8008c1:	c3                   	retq   

00000000008008c2 <close_all>:

void
close_all(void)
{
  8008c2:	55                   	push   %rbp
  8008c3:	48 89 e5             	mov    %rsp,%rbp
  8008c6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008d1:	eb 15                	jmp    8008e8 <close_all+0x26>
		close(i);
  8008d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008d6:	89 c7                	mov    %eax,%edi
  8008d8:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  8008df:	00 00 00 
  8008e2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008e4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008e8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008ec:	7e e5                	jle    8008d3 <close_all+0x11>
		close(i);
}
  8008ee:	c9                   	leaveq 
  8008ef:	c3                   	retq   

00000000008008f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008f0:	55                   	push   %rbp
  8008f1:	48 89 e5             	mov    %rsp,%rbp
  8008f4:	48 83 ec 40          	sub    $0x40,%rsp
  8008f8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008fb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008fe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800902:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800905:	48 89 d6             	mov    %rdx,%rsi
  800908:	89 c7                	mov    %eax,%edi
  80090a:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800911:	00 00 00 
  800914:	ff d0                	callq  *%rax
  800916:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800919:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091d:	79 08                	jns    800927 <dup+0x37>
		return r;
  80091f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800922:	e9 70 01 00 00       	jmpq   800a97 <dup+0x1a7>
	close(newfdnum);
  800927:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80092a:	89 c7                	mov    %eax,%edi
  80092c:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800933:	00 00 00 
  800936:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800938:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80093b:	48 98                	cltq   
  80093d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800943:	48 c1 e0 0c          	shl    $0xc,%rax
  800947:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80094b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80094f:	48 89 c7             	mov    %rax,%rdi
  800952:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  800959:	00 00 00 
  80095c:	ff d0                	callq  *%rax
  80095e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800966:	48 89 c7             	mov    %rax,%rdi
  800969:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  800970:	00 00 00 
  800973:	ff d0                	callq  *%rax
  800975:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 c1 e8 15          	shr    $0x15,%rax
  800981:	48 89 c2             	mov    %rax,%rdx
  800984:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80098b:	01 00 00 
  80098e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800992:	83 e0 01             	and    $0x1,%eax
  800995:	48 85 c0             	test   %rax,%rax
  800998:	74 73                	je     800a0d <dup+0x11d>
  80099a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099e:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a2:	48 89 c2             	mov    %rax,%rdx
  8009a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009ac:	01 00 00 
  8009af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b3:	83 e0 01             	and    $0x1,%eax
  8009b6:	48 85 c0             	test   %rax,%rax
  8009b9:	74 52                	je     800a0d <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8009c3:	48 89 c2             	mov    %rax,%rdx
  8009c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009cd:	01 00 00 
  8009d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8009d9:	89 c1                	mov    %eax,%ecx
  8009db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e3:	41 89 c8             	mov    %ecx,%r8d
  8009e6:	48 89 d1             	mov    %rdx,%rcx
  8009e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ee:	48 89 c6             	mov    %rax,%rsi
  8009f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f6:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  8009fd:	00 00 00 
  800a00:	ff d0                	callq  *%rax
  800a02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a09:	79 02                	jns    800a0d <dup+0x11d>
			goto err;
  800a0b:	eb 57                	jmp    800a64 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a11:	48 c1 e8 0c          	shr    $0xc,%rax
  800a15:	48 89 c2             	mov    %rax,%rdx
  800a18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a1f:	01 00 00 
  800a22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a26:	25 07 0e 00 00       	and    $0xe07,%eax
  800a2b:	89 c1                	mov    %eax,%ecx
  800a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a35:	41 89 c8             	mov    %ecx,%r8d
  800a38:	48 89 d1             	mov    %rdx,%rcx
  800a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a40:	48 89 c6             	mov    %rax,%rsi
  800a43:	bf 00 00 00 00       	mov    $0x0,%edi
  800a48:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  800a4f:	00 00 00 
  800a52:	ff d0                	callq  *%rax
  800a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a5b:	79 02                	jns    800a5f <dup+0x16f>
		goto err;
  800a5d:	eb 05                	jmp    800a64 <dup+0x174>

	return newfdnum;
  800a5f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a62:	eb 33                	jmp    800a97 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a68:	48 89 c6             	mov    %rax,%rsi
  800a6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a70:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800a77:	00 00 00 
  800a7a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a80:	48 89 c6             	mov    %rax,%rsi
  800a83:	bf 00 00 00 00       	mov    $0x0,%edi
  800a88:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800a8f:	00 00 00 
  800a92:	ff d0                	callq  *%rax
	return r;
  800a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a97:	c9                   	leaveq 
  800a98:	c3                   	retq   

0000000000800a99 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a99:	55                   	push   %rbp
  800a9a:	48 89 e5             	mov    %rsp,%rbp
  800a9d:	48 83 ec 40          	sub    $0x40,%rsp
  800aa1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800aa4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800aa8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800aac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ab0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ab3:	48 89 d6             	mov    %rdx,%rsi
  800ab6:	89 c7                	mov    %eax,%edi
  800ab8:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800abf:	00 00 00 
  800ac2:	ff d0                	callq  *%rax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ac7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800acb:	78 24                	js     800af1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad1:	8b 00                	mov    (%rax),%eax
  800ad3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ad7:	48 89 d6             	mov    %rdx,%rsi
  800ada:	89 c7                	mov    %eax,%edi
  800adc:	48 b8 c0 07 80 00 00 	movabs $0x8007c0,%rax
  800ae3:	00 00 00 
  800ae6:	ff d0                	callq  *%rax
  800ae8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800aeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aef:	79 05                	jns    800af6 <read+0x5d>
		return r;
  800af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800af4:	eb 76                	jmp    800b6c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afa:	8b 40 08             	mov    0x8(%rax),%eax
  800afd:	83 e0 03             	and    $0x3,%eax
  800b00:	83 f8 01             	cmp    $0x1,%eax
  800b03:	75 3a                	jne    800b3f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b05:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b0c:	00 00 00 
  800b0f:	48 8b 00             	mov    (%rax),%rax
  800b12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b18:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	48 bf 37 34 80 00 00 	movabs $0x803437,%rdi
  800b24:	00 00 00 
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	48 b9 5f 1e 80 00 00 	movabs $0x801e5f,%rcx
  800b33:	00 00 00 
  800b36:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b3d:	eb 2d                	jmp    800b6c <read+0xd3>
	}
	if (!dev->dev_read)
  800b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b43:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b47:	48 85 c0             	test   %rax,%rax
  800b4a:	75 07                	jne    800b53 <read+0xba>
		return -E_NOT_SUPP;
  800b4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b51:	eb 19                	jmp    800b6c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b57:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b63:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b67:	48 89 cf             	mov    %rcx,%rdi
  800b6a:	ff d0                	callq  *%rax
}
  800b6c:	c9                   	leaveq 
  800b6d:	c3                   	retq   

0000000000800b6e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b6e:	55                   	push   %rbp
  800b6f:	48 89 e5             	mov    %rsp,%rbp
  800b72:	48 83 ec 30          	sub    $0x30,%rsp
  800b76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b88:	eb 49                	jmp    800bd3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b8d:	48 98                	cltq   
  800b8f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b93:	48 29 c2             	sub    %rax,%rdx
  800b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b99:	48 63 c8             	movslq %eax,%rcx
  800b9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ba0:	48 01 c1             	add    %rax,%rcx
  800ba3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ba6:	48 89 ce             	mov    %rcx,%rsi
  800ba9:	89 c7                	mov    %eax,%edi
  800bab:	48 b8 99 0a 80 00 00 	movabs $0x800a99,%rax
  800bb2:	00 00 00 
  800bb5:	ff d0                	callq  *%rax
  800bb7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800bba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bbe:	79 05                	jns    800bc5 <readn+0x57>
			return m;
  800bc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc3:	eb 1c                	jmp    800be1 <readn+0x73>
		if (m == 0)
  800bc5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bc9:	75 02                	jne    800bcd <readn+0x5f>
			break;
  800bcb:	eb 11                	jmp    800bde <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bd0:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bd6:	48 98                	cltq   
  800bd8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bdc:	72 ac                	jb     800b8a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800be1:	c9                   	leaveq 
  800be2:	c3                   	retq   

0000000000800be3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800be3:	55                   	push   %rbp
  800be4:	48 89 e5             	mov    %rsp,%rbp
  800be7:	48 83 ec 40          	sub    $0x40,%rsp
  800beb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bee:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bf2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bf6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800bfd:	48 89 d6             	mov    %rdx,%rsi
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800c09:	00 00 00 
  800c0c:	ff d0                	callq  *%rax
  800c0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c15:	78 24                	js     800c3b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1b:	8b 00                	mov    (%rax),%eax
  800c1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c21:	48 89 d6             	mov    %rdx,%rsi
  800c24:	89 c7                	mov    %eax,%edi
  800c26:	48 b8 c0 07 80 00 00 	movabs $0x8007c0,%rax
  800c2d:	00 00 00 
  800c30:	ff d0                	callq  *%rax
  800c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c39:	79 05                	jns    800c40 <write+0x5d>
		return r;
  800c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c3e:	eb 75                	jmp    800cb5 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c44:	8b 40 08             	mov    0x8(%rax),%eax
  800c47:	83 e0 03             	and    $0x3,%eax
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	75 3a                	jne    800c88 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c4e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c55:	00 00 00 
  800c58:	48 8b 00             	mov    (%rax),%rax
  800c5b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c61:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c64:	89 c6                	mov    %eax,%esi
  800c66:	48 bf 53 34 80 00 00 	movabs $0x803453,%rdi
  800c6d:	00 00 00 
  800c70:	b8 00 00 00 00       	mov    $0x0,%eax
  800c75:	48 b9 5f 1e 80 00 00 	movabs $0x801e5f,%rcx
  800c7c:	00 00 00 
  800c7f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c86:	eb 2d                	jmp    800cb5 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c90:	48 85 c0             	test   %rax,%rax
  800c93:	75 07                	jne    800c9c <write+0xb9>
		return -E_NOT_SUPP;
  800c95:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c9a:	eb 19                	jmp    800cb5 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca0:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ca4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800ca8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cac:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800cb0:	48 89 cf             	mov    %rcx,%rdi
  800cb3:	ff d0                	callq  *%rax
}
  800cb5:	c9                   	leaveq 
  800cb6:	c3                   	retq   

0000000000800cb7 <seek>:

int
seek(int fdnum, off_t offset)
{
  800cb7:	55                   	push   %rbp
  800cb8:	48 89 e5             	mov    %rsp,%rbp
  800cbb:	48 83 ec 18          	sub    $0x18,%rsp
  800cbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cc2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cc5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ccc:	48 89 d6             	mov    %rdx,%rsi
  800ccf:	89 c7                	mov    %eax,%edi
  800cd1:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800cd8:	00 00 00 
  800cdb:	ff d0                	callq  *%rax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce4:	79 05                	jns    800ceb <seek+0x34>
		return r;
  800ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ce9:	eb 0f                	jmp    800cfa <seek+0x43>
	fd->fd_offset = offset;
  800ceb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cf2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfa:	c9                   	leaveq 
  800cfb:	c3                   	retq   

0000000000800cfc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800cfc:	55                   	push   %rbp
  800cfd:	48 89 e5             	mov    %rsp,%rbp
  800d00:	48 83 ec 30          	sub    $0x30,%rsp
  800d04:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d07:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d0a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d0e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d11:	48 89 d6             	mov    %rdx,%rsi
  800d14:	89 c7                	mov    %eax,%edi
  800d16:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800d1d:	00 00 00 
  800d20:	ff d0                	callq  *%rax
  800d22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d29:	78 24                	js     800d4f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d2f:	8b 00                	mov    (%rax),%eax
  800d31:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d35:	48 89 d6             	mov    %rdx,%rsi
  800d38:	89 c7                	mov    %eax,%edi
  800d3a:	48 b8 c0 07 80 00 00 	movabs $0x8007c0,%rax
  800d41:	00 00 00 
  800d44:	ff d0                	callq  *%rax
  800d46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d4d:	79 05                	jns    800d54 <ftruncate+0x58>
		return r;
  800d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d52:	eb 72                	jmp    800dc6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d58:	8b 40 08             	mov    0x8(%rax),%eax
  800d5b:	83 e0 03             	and    $0x3,%eax
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	75 3a                	jne    800d9c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d62:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d69:	00 00 00 
  800d6c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d6f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d75:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d78:	89 c6                	mov    %eax,%esi
  800d7a:	48 bf 70 34 80 00 00 	movabs $0x803470,%rdi
  800d81:	00 00 00 
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
  800d89:	48 b9 5f 1e 80 00 00 	movabs $0x801e5f,%rcx
  800d90:	00 00 00 
  800d93:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d9a:	eb 2a                	jmp    800dc6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da0:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da4:	48 85 c0             	test   %rax,%rax
  800da7:	75 07                	jne    800db0 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800da9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dae:	eb 16                	jmp    800dc6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db4:	48 8b 40 30          	mov    0x30(%rax),%rax
  800db8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dbc:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dbf:	89 ce                	mov    %ecx,%esi
  800dc1:	48 89 d7             	mov    %rdx,%rdi
  800dc4:	ff d0                	callq  *%rax
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 30          	sub    $0x30,%rsp
  800dd0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dd7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ddb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dde:	48 89 d6             	mov    %rdx,%rsi
  800de1:	89 c7                	mov    %eax,%edi
  800de3:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	callq  *%rax
  800def:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df6:	78 24                	js     800e1c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfc:	8b 00                	mov    (%rax),%eax
  800dfe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e02:	48 89 d6             	mov    %rdx,%rsi
  800e05:	89 c7                	mov    %eax,%edi
  800e07:	48 b8 c0 07 80 00 00 	movabs $0x8007c0,%rax
  800e0e:	00 00 00 
  800e11:	ff d0                	callq  *%rax
  800e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e1a:	79 05                	jns    800e21 <fstat+0x59>
		return r;
  800e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e1f:	eb 5e                	jmp    800e7f <fstat+0xb7>
	if (!dev->dev_stat)
  800e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e25:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e29:	48 85 c0             	test   %rax,%rax
  800e2c:	75 07                	jne    800e35 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e2e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e33:	eb 4a                	jmp    800e7f <fstat+0xb7>
	stat->st_name[0] = 0;
  800e35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e39:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e40:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e47:	00 00 00 
	stat->st_isdir = 0;
  800e4a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e4e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e55:	00 00 00 
	stat->st_dev = dev;
  800e58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e60:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6b:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e73:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e77:	48 89 ce             	mov    %rcx,%rsi
  800e7a:	48 89 d7             	mov    %rdx,%rdi
  800e7d:	ff d0                	callq  *%rax
}
  800e7f:	c9                   	leaveq 
  800e80:	c3                   	retq   

0000000000800e81 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e81:	55                   	push   %rbp
  800e82:	48 89 e5             	mov    %rsp,%rbp
  800e85:	48 83 ec 20          	sub    $0x20,%rsp
  800e89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e95:	be 00 00 00 00       	mov    $0x0,%esi
  800e9a:	48 89 c7             	mov    %rax,%rdi
  800e9d:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  800ea4:	00 00 00 
  800ea7:	ff d0                	callq  *%rax
  800ea9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eb0:	79 05                	jns    800eb7 <stat+0x36>
		return fd;
  800eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eb5:	eb 2f                	jmp    800ee6 <stat+0x65>
	r = fstat(fd, stat);
  800eb7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ebe:	48 89 d6             	mov    %rdx,%rsi
  800ec1:	89 c7                	mov    %eax,%edi
  800ec3:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  800eca:	00 00 00 
  800ecd:	ff d0                	callq  *%rax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed5:	89 c7                	mov    %eax,%edi
  800ed7:	48 b8 77 08 80 00 00 	movabs $0x800877,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	callq  *%rax
	return r;
  800ee3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ee6:	c9                   	leaveq 
  800ee7:	c3                   	retq   

0000000000800ee8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ee8:	55                   	push   %rbp
  800ee9:	48 89 e5             	mov    %rsp,%rbp
  800eec:	48 83 ec 10          	sub    $0x10,%rsp
  800ef0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ef7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800efe:	00 00 00 
  800f01:	8b 00                	mov    (%rax),%eax
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 1d                	jne    800f24 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f07:	bf 01 00 00 00       	mov    $0x1,%edi
  800f0c:	48 b8 d5 32 80 00 00 	movabs $0x8032d5,%rax
  800f13:	00 00 00 
  800f16:	ff d0                	callq  *%rax
  800f18:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f1f:	00 00 00 
  800f22:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f24:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f2b:	00 00 00 
  800f2e:	8b 00                	mov    (%rax),%eax
  800f30:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f33:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f38:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f3f:	00 00 00 
  800f42:	89 c7                	mov    %eax,%edi
  800f44:	48 b8 73 32 80 00 00 	movabs $0x803273,%rax
  800f4b:	00 00 00 
  800f4e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f54:	ba 00 00 00 00       	mov    $0x0,%edx
  800f59:	48 89 c6             	mov    %rax,%rsi
  800f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f61:	48 b8 6d 31 80 00 00 	movabs $0x80316d,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	callq  *%rax
}
  800f6d:	c9                   	leaveq 
  800f6e:	c3                   	retq   

0000000000800f6f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	48 83 ec 30          	sub    $0x30,%rsp
  800f77:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800f7b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  800f7e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  800f85:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  800f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  800f93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f98:	75 08                	jne    800fa2 <open+0x33>
	{
		return r;
  800f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f9d:	e9 f2 00 00 00       	jmpq   801094 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  800fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800fa6:	48 89 c7             	mov    %rax,%rdi
  800fa9:	48 b8 a8 29 80 00 00 	movabs $0x8029a8,%rax
  800fb0:	00 00 00 
  800fb3:	ff d0                	callq  *%rax
  800fb5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800fb8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  800fbf:	7e 0a                	jle    800fcb <open+0x5c>
	{
		return -E_BAD_PATH;
  800fc1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800fc6:	e9 c9 00 00 00       	jmpq   801094 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  800fcb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800fd2:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  800fd3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fd7:	48 89 c7             	mov    %rax,%rdi
  800fda:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fed:	78 09                	js     800ff8 <open+0x89>
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	48 85 c0             	test   %rax,%rax
  800ff6:	75 08                	jne    801000 <open+0x91>
		{
			return r;
  800ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ffb:	e9 94 00 00 00       	jmpq   801094 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801004:	ba 00 04 00 00       	mov    $0x400,%edx
  801009:	48 89 c6             	mov    %rax,%rsi
  80100c:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801013:	00 00 00 
  801016:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  80101d:	00 00 00 
  801020:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801022:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801029:	00 00 00 
  80102c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80102f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801039:	48 89 c6             	mov    %rax,%rsi
  80103c:	bf 01 00 00 00       	mov    $0x1,%edi
  801041:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801048:	00 00 00 
  80104b:	ff d0                	callq  *%rax
  80104d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801050:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801054:	79 2b                	jns    801081 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	be 00 00 00 00       	mov    $0x0,%esi
  80105f:	48 89 c7             	mov    %rax,%rdi
  801062:	48 b8 f7 06 80 00 00 	movabs $0x8006f7,%rax
  801069:	00 00 00 
  80106c:	ff d0                	callq  *%rax
  80106e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801071:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801075:	79 05                	jns    80107c <open+0x10d>
			{
				return d;
  801077:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80107a:	eb 18                	jmp    801094 <open+0x125>
			}
			return r;
  80107c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80107f:	eb 13                	jmp    801094 <open+0x125>
		}	
		return fd2num(fd_store);
  801081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801085:	48 89 c7             	mov    %rax,%rdi
  801088:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  80108f:	00 00 00 
  801092:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 10          	sub    $0x10,%rsp
  80109e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8010a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8010a9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010b0:	00 00 00 
  8010b3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8010b5:	be 00 00 00 00       	mov    $0x0,%esi
  8010ba:	bf 06 00 00 00       	mov    $0x6,%edi
  8010bf:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  8010c6:	00 00 00 
  8010c9:	ff d0                	callq  *%rax
}
  8010cb:	c9                   	leaveq 
  8010cc:	c3                   	retq   

00000000008010cd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 83 ec 30          	sub    $0x30,%rsp
  8010d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8010e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8010e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ed:	74 07                	je     8010f6 <devfile_read+0x29>
  8010ef:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010f4:	75 07                	jne    8010fd <devfile_read+0x30>
		return -E_INVAL;
  8010f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fb:	eb 77                	jmp    801174 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8010fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801101:	8b 50 0c             	mov    0xc(%rax),%edx
  801104:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80110b:	00 00 00 
  80110e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801110:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801117:	00 00 00 
  80111a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80111e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801122:	be 00 00 00 00       	mov    $0x0,%esi
  801127:	bf 03 00 00 00       	mov    $0x3,%edi
  80112c:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801133:	00 00 00 
  801136:	ff d0                	callq  *%rax
  801138:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80113b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80113f:	7f 05                	jg     801146 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801141:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801144:	eb 2e                	jmp    801174 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801149:	48 63 d0             	movslq %eax,%rdx
  80114c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801150:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801157:	00 00 00 
  80115a:	48 89 c7             	mov    %rax,%rdi
  80115d:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801169:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801171:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 30          	sub    $0x30,%rsp
  80117e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801182:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801186:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80118a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801191:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801196:	74 07                	je     80119f <devfile_write+0x29>
  801198:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80119d:	75 08                	jne    8011a7 <devfile_write+0x31>
		return r;
  80119f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a2:	e9 9a 00 00 00       	jmpq   801241 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8011a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ab:	8b 50 0c             	mov    0xc(%rax),%edx
  8011ae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011b5:	00 00 00 
  8011b8:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8011ba:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8011c1:	00 
  8011c2:	76 08                	jbe    8011cc <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8011c4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8011cb:	00 
	}
	fsipcbuf.write.req_n = n;
  8011cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011d3:	00 00 00 
  8011d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011da:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8011de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e6:	48 89 c6             	mov    %rax,%rsi
  8011e9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011f0:	00 00 00 
  8011f3:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8011ff:	be 00 00 00 00       	mov    $0x0,%esi
  801204:	bf 04 00 00 00       	mov    $0x4,%edi
  801209:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801210:	00 00 00 
  801213:	ff d0                	callq  *%rax
  801215:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80121c:	7f 20                	jg     80123e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80121e:	48 bf 96 34 80 00 00 	movabs $0x803496,%rdi
  801225:	00 00 00 
  801228:	b8 00 00 00 00       	mov    $0x0,%eax
  80122d:	48 ba 5f 1e 80 00 00 	movabs $0x801e5f,%rdx
  801234:	00 00 00 
  801237:	ff d2                	callq  *%rdx
		return r;
  801239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80123c:	eb 03                	jmp    801241 <devfile_write+0xcb>
	}
	return r;
  80123e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801241:	c9                   	leaveq 
  801242:	c3                   	retq   

0000000000801243 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801243:	55                   	push   %rbp
  801244:	48 89 e5             	mov    %rsp,%rbp
  801247:	48 83 ec 20          	sub    $0x20,%rsp
  80124b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801257:	8b 50 0c             	mov    0xc(%rax),%edx
  80125a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801261:	00 00 00 
  801264:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801266:	be 00 00 00 00       	mov    $0x0,%esi
  80126b:	bf 05 00 00 00       	mov    $0x5,%edi
  801270:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801277:	00 00 00 
  80127a:	ff d0                	callq  *%rax
  80127c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80127f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801283:	79 05                	jns    80128a <devfile_stat+0x47>
		return r;
  801285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801288:	eb 56                	jmp    8012e0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80128a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801295:	00 00 00 
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8012a7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012ae:	00 00 00 
  8012b1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012c1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012c8:	00 00 00 
  8012cb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 10          	sub    $0x10,%rsp
  8012ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8012f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012ff:	00 00 00 
  801302:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801304:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80130b:	00 00 00 
  80130e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801311:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801314:	be 00 00 00 00       	mov    $0x0,%esi
  801319:	bf 02 00 00 00       	mov    $0x2,%edi
  80131e:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801325:	00 00 00 
  801328:	ff d0                	callq  *%rax
}
  80132a:	c9                   	leaveq 
  80132b:	c3                   	retq   

000000000080132c <remove>:

// Delete a file
int
remove(const char *path)
{
  80132c:	55                   	push   %rbp
  80132d:	48 89 e5             	mov    %rsp,%rbp
  801330:	48 83 ec 10          	sub    $0x10,%rsp
  801334:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801338:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133c:	48 89 c7             	mov    %rax,%rdi
  80133f:	48 b8 a8 29 80 00 00 	movabs $0x8029a8,%rax
  801346:	00 00 00 
  801349:	ff d0                	callq  *%rax
  80134b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801350:	7e 07                	jle    801359 <remove+0x2d>
		return -E_BAD_PATH;
  801352:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801357:	eb 33                	jmp    80138c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135d:	48 89 c6             	mov    %rax,%rsi
  801360:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801367:	00 00 00 
  80136a:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801376:	be 00 00 00 00       	mov    $0x0,%esi
  80137b:	bf 07 00 00 00       	mov    $0x7,%edi
  801380:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  801387:	00 00 00 
  80138a:	ff d0                	callq  *%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801392:	be 00 00 00 00       	mov    $0x0,%esi
  801397:	bf 08 00 00 00       	mov    $0x8,%edi
  80139c:	48 b8 e8 0e 80 00 00 	movabs $0x800ee8,%rax
  8013a3:	00 00 00 
  8013a6:	ff d0                	callq  *%rax
}
  8013a8:	5d                   	pop    %rbp
  8013a9:	c3                   	retq   

00000000008013aa <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8013aa:	55                   	push   %rbp
  8013ab:	48 89 e5             	mov    %rsp,%rbp
  8013ae:	53                   	push   %rbx
  8013af:	48 83 ec 38          	sub    $0x38,%rsp
  8013b3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8013b7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8013bb:	48 89 c7             	mov    %rax,%rdi
  8013be:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  8013c5:	00 00 00 
  8013c8:	ff d0                	callq  *%rax
  8013ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013d1:	0f 88 bf 01 00 00    	js     801596 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013db:	ba 07 04 00 00       	mov    $0x407,%edx
  8013e0:	48 89 c6             	mov    %rax,%rsi
  8013e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8013e8:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  8013ef:	00 00 00 
  8013f2:	ff d0                	callq  *%rax
  8013f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013fb:	0f 88 95 01 00 00    	js     801596 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801401:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801405:	48 89 c7             	mov    %rax,%rdi
  801408:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  80140f:	00 00 00 
  801412:	ff d0                	callq  *%rax
  801414:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801417:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80141b:	0f 88 5d 01 00 00    	js     80157e <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801421:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801425:	ba 07 04 00 00       	mov    $0x407,%edx
  80142a:	48 89 c6             	mov    %rax,%rsi
  80142d:	bf 00 00 00 00       	mov    $0x0,%edi
  801432:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801439:	00 00 00 
  80143c:	ff d0                	callq  *%rax
  80143e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801441:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801445:	0f 88 33 01 00 00    	js     80157e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	48 89 c7             	mov    %rax,%rdi
  801452:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  801459:	00 00 00 
  80145c:	ff d0                	callq  *%rax
  80145e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801462:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801466:	ba 07 04 00 00       	mov    $0x407,%edx
  80146b:	48 89 c6             	mov    %rax,%rsi
  80146e:	bf 00 00 00 00       	mov    $0x0,%edi
  801473:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  80147a:	00 00 00 
  80147d:	ff d0                	callq  *%rax
  80147f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801482:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801486:	79 05                	jns    80148d <pipe+0xe3>
		goto err2;
  801488:	e9 d9 00 00 00       	jmpq   801566 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80148d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801491:	48 89 c7             	mov    %rax,%rdi
  801494:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
  8014a0:	48 89 c2             	mov    %rax,%rdx
  8014a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8014ad:	48 89 d1             	mov    %rdx,%rcx
  8014b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b5:	48 89 c6             	mov    %rax,%rsi
  8014b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8014bd:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  8014c4:	00 00 00 
  8014c7:	ff d0                	callq  *%rax
  8014c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014d0:	79 1b                	jns    8014ed <pipe+0x143>
		goto err3;
  8014d2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8014d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d7:	48 89 c6             	mov    %rax,%rsi
  8014da:	bf 00 00 00 00       	mov    $0x0,%edi
  8014df:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  8014e6:	00 00 00 
  8014e9:	ff d0                	callq  *%rax
  8014eb:	eb 79                	jmp    801566 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8014f8:	00 00 00 
  8014fb:	8b 12                	mov    (%rdx),%edx
  8014fd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80150a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801515:	00 00 00 
  801518:	8b 12                	mov    (%rdx),%edx
  80151a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80151c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801520:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	48 89 c7             	mov    %rax,%rdi
  80152e:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  801535:	00 00 00 
  801538:	ff d0                	callq  *%rax
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801540:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801542:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801546:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80154a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80154e:	48 89 c7             	mov    %rax,%rdi
  801551:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  801558:	00 00 00 
  80155b:	ff d0                	callq  *%rax
  80155d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	eb 33                	jmp    801599 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801566:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156a:	48 89 c6             	mov    %rax,%rsi
  80156d:	bf 00 00 00 00       	mov    $0x0,%edi
  801572:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  801579:	00 00 00 
  80157c:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	48 89 c6             	mov    %rax,%rsi
  801585:	bf 00 00 00 00       	mov    $0x0,%edi
  80158a:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  801591:	00 00 00 
  801594:	ff d0                	callq  *%rax
    err:
	return r;
  801596:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801599:	48 83 c4 38          	add    $0x38,%rsp
  80159d:	5b                   	pop    %rbx
  80159e:	5d                   	pop    %rbp
  80159f:	c3                   	retq   

00000000008015a0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8015a0:	55                   	push   %rbp
  8015a1:	48 89 e5             	mov    %rsp,%rbp
  8015a4:	53                   	push   %rbx
  8015a5:	48 83 ec 28          	sub    $0x28,%rsp
  8015a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8015b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015b8:	00 00 00 
  8015bb:	48 8b 00             	mov    (%rax),%rax
  8015be:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8015c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 89 c7             	mov    %rax,%rdi
  8015ce:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8015d5:	00 00 00 
  8015d8:	ff d0                	callq  *%rax
  8015da:	89 c3                	mov    %eax,%ebx
  8015dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e0:	48 89 c7             	mov    %rax,%rdi
  8015e3:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8015ea:	00 00 00 
  8015ed:	ff d0                	callq  *%rax
  8015ef:	39 c3                	cmp    %eax,%ebx
  8015f1:	0f 94 c0             	sete   %al
  8015f4:	0f b6 c0             	movzbl %al,%eax
  8015f7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8015fa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801601:	00 00 00 
  801604:	48 8b 00             	mov    (%rax),%rax
  801607:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80160d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801610:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801613:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801616:	75 05                	jne    80161d <_pipeisclosed+0x7d>
			return ret;
  801618:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80161b:	eb 4f                	jmp    80166c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80161d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801620:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801623:	74 42                	je     801667 <_pipeisclosed+0xc7>
  801625:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801629:	75 3c                	jne    801667 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80162b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801632:	00 00 00 
  801635:	48 8b 00             	mov    (%rax),%rax
  801638:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80163e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801641:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801644:	89 c6                	mov    %eax,%esi
  801646:	48 bf b7 34 80 00 00 	movabs $0x8034b7,%rdi
  80164d:	00 00 00 
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	49 b8 5f 1e 80 00 00 	movabs $0x801e5f,%r8
  80165c:	00 00 00 
  80165f:	41 ff d0             	callq  *%r8
	}
  801662:	e9 4a ff ff ff       	jmpq   8015b1 <_pipeisclosed+0x11>
  801667:	e9 45 ff ff ff       	jmpq   8015b1 <_pipeisclosed+0x11>
}
  80166c:	48 83 c4 28          	add    $0x28,%rsp
  801670:	5b                   	pop    %rbx
  801671:	5d                   	pop    %rbp
  801672:	c3                   	retq   

0000000000801673 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801673:	55                   	push   %rbp
  801674:	48 89 e5             	mov    %rsp,%rbp
  801677:	48 83 ec 30          	sub    $0x30,%rsp
  80167b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801682:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801685:	48 89 d6             	mov    %rdx,%rsi
  801688:	89 c7                	mov    %eax,%edi
  80168a:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  801691:	00 00 00 
  801694:	ff d0                	callq  *%rax
  801696:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801699:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80169d:	79 05                	jns    8016a4 <pipeisclosed+0x31>
		return r;
  80169f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a2:	eb 31                	jmp    8016d5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8016a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a8:	48 89 c7             	mov    %rax,%rdi
  8016ab:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  8016b2:	00 00 00 
  8016b5:	ff d0                	callq  *%rax
  8016b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8016bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016c3:	48 89 d6             	mov    %rdx,%rsi
  8016c6:	48 89 c7             	mov    %rax,%rdi
  8016c9:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	callq  *%rax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 40          	sub    $0x40,%rsp
  8016df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8016eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ef:	48 89 c7             	mov    %rax,%rdi
  8016f2:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
  8016fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801702:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801706:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80170a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801711:	00 
  801712:	e9 92 00 00 00       	jmpq   8017a9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801717:	eb 41                	jmp    80175a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801719:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80171e:	74 09                	je     801729 <devpipe_read+0x52>
				return i;
  801720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801724:	e9 92 00 00 00       	jmpq   8017bb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801729:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 89 d6             	mov    %rdx,%rsi
  801734:	48 89 c7             	mov    %rax,%rdi
  801737:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  80173e:	00 00 00 
  801741:	ff d0                	callq  *%rax
  801743:	85 c0                	test   %eax,%eax
  801745:	74 07                	je     80174e <devpipe_read+0x77>
				return 0;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 6d                	jmp    8017bb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80174e:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80175a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175e:	8b 10                	mov    (%rax),%edx
  801760:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801764:	8b 40 04             	mov    0x4(%rax),%eax
  801767:	39 c2                	cmp    %eax,%edx
  801769:	74 ae                	je     801719 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80176b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801773:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177b:	8b 00                	mov    (%rax),%eax
  80177d:	99                   	cltd   
  80177e:	c1 ea 1b             	shr    $0x1b,%edx
  801781:	01 d0                	add    %edx,%eax
  801783:	83 e0 1f             	and    $0x1f,%eax
  801786:	29 d0                	sub    %edx,%eax
  801788:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178c:	48 98                	cltq   
  80178e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801793:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801799:	8b 00                	mov    (%rax),%eax
  80179b:	8d 50 01             	lea    0x1(%rax),%edx
  80179e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8017b1:	0f 82 60 ff ff ff    	jb     801717 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8017b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	48 83 ec 40          	sub    $0x40,%rsp
  8017c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017cd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8017e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8017f0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017f7:	00 
  8017f8:	e9 8e 00 00 00       	jmpq   80188b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017fd:	eb 31                	jmp    801830 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8017ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	48 89 d6             	mov    %rdx,%rsi
  80180a:	48 89 c7             	mov    %rax,%rdi
  80180d:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801814:	00 00 00 
  801817:	ff d0                	callq  *%rax
  801819:	85 c0                	test   %eax,%eax
  80181b:	74 07                	je     801824 <devpipe_write+0x67>
				return 0;
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	eb 79                	jmp    80189d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801824:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801834:	8b 40 04             	mov    0x4(%rax),%eax
  801837:	48 63 d0             	movslq %eax,%rdx
  80183a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80183e:	8b 00                	mov    (%rax),%eax
  801840:	48 98                	cltq   
  801842:	48 83 c0 20          	add    $0x20,%rax
  801846:	48 39 c2             	cmp    %rax,%rdx
  801849:	73 b4                	jae    8017ff <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80184b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184f:	8b 40 04             	mov    0x4(%rax),%eax
  801852:	99                   	cltd   
  801853:	c1 ea 1b             	shr    $0x1b,%edx
  801856:	01 d0                	add    %edx,%eax
  801858:	83 e0 1f             	and    $0x1f,%eax
  80185b:	29 d0                	sub    %edx,%eax
  80185d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801861:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801865:	48 01 ca             	add    %rcx,%rdx
  801868:	0f b6 0a             	movzbl (%rdx),%ecx
  80186b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186f:	48 98                	cltq   
  801871:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801879:	8b 40 04             	mov    0x4(%rax),%eax
  80187c:	8d 50 01             	lea    0x1(%rax),%edx
  80187f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801883:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801886:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80188b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801893:	0f 82 64 ff ff ff    	jb     8017fd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80189d:	c9                   	leaveq 
  80189e:	c3                   	retq   

000000000080189f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80189f:	55                   	push   %rbp
  8018a0:	48 89 e5             	mov    %rsp,%rbp
  8018a3:	48 83 ec 20          	sub    $0x20,%rsp
  8018a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b3:	48 89 c7             	mov    %rax,%rdi
  8018b6:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
  8018c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8018c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018ca:	48 be ca 34 80 00 00 	movabs $0x8034ca,%rsi
  8018d1:	00 00 00 
  8018d4:	48 89 c7             	mov    %rax,%rdi
  8018d7:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  8018de:	00 00 00 
  8018e1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8018e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e7:	8b 50 04             	mov    0x4(%rax),%edx
  8018ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ee:	8b 00                	mov    (%rax),%eax
  8018f0:	29 c2                	sub    %eax,%edx
  8018f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8018fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801900:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801907:	00 00 00 
	stat->st_dev = &devpipe;
  80190a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80190e:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801915:	00 00 00 
  801918:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	48 83 ec 10          	sub    $0x10,%rsp
  80192e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801932:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801936:	48 89 c6             	mov    %rax,%rsi
  801939:	bf 00 00 00 00       	mov    $0x0,%edi
  80193e:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80194a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194e:	48 89 c7             	mov    %rax,%rdi
  801951:	48 b8 a4 05 80 00 00 	movabs $0x8005a4,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
  80195d:	48 89 c6             	mov    %rax,%rsi
  801960:	bf 00 00 00 00       	mov    $0x0,%edi
  801965:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  80196c:	00 00 00 
  80196f:	ff d0                	callq  *%rax
}
  801971:	c9                   	leaveq 
  801972:	c3                   	retq   

0000000000801973 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801973:	55                   	push   %rbp
  801974:	48 89 e5             	mov    %rsp,%rbp
  801977:	48 83 ec 20          	sub    $0x20,%rsp
  80197b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80197e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801981:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801984:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801988:	be 01 00 00 00       	mov    $0x1,%esi
  80198d:	48 89 c7             	mov    %rax,%rdi
  801990:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  801997:	00 00 00 
  80199a:	ff d0                	callq  *%rax
}
  80199c:	c9                   	leaveq 
  80199d:	c3                   	retq   

000000000080199e <getchar>:

int
getchar(void)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8019a6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8019aa:	ba 01 00 00 00       	mov    $0x1,%edx
  8019af:	48 89 c6             	mov    %rax,%rsi
  8019b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b7:	48 b8 99 0a 80 00 00 	movabs $0x800a99,%rax
  8019be:	00 00 00 
  8019c1:	ff d0                	callq  *%rax
  8019c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8019c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019ca:	79 05                	jns    8019d1 <getchar+0x33>
		return r;
  8019cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cf:	eb 14                	jmp    8019e5 <getchar+0x47>
	if (r < 1)
  8019d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019d5:	7f 07                	jg     8019de <getchar+0x40>
		return -E_EOF;
  8019d7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8019dc:	eb 07                	jmp    8019e5 <getchar+0x47>
	return c;
  8019de:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8019e2:	0f b6 c0             	movzbl %al,%eax
}
  8019e5:	c9                   	leaveq 
  8019e6:	c3                   	retq   

00000000008019e7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019e7:	55                   	push   %rbp
  8019e8:	48 89 e5             	mov    %rsp,%rbp
  8019eb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8019f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019f9:	48 89 d6             	mov    %rdx,%rsi
  8019fc:	89 c7                	mov    %eax,%edi
  8019fe:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
  801a0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a11:	79 05                	jns    801a18 <iscons+0x31>
		return r;
  801a13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a16:	eb 1a                	jmp    801a32 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a1c:	8b 10                	mov    (%rax),%edx
  801a1e:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801a25:	00 00 00 
  801a28:	8b 00                	mov    (%rax),%eax
  801a2a:	39 c2                	cmp    %eax,%edx
  801a2c:	0f 94 c0             	sete   %al
  801a2f:	0f b6 c0             	movzbl %al,%eax
}
  801a32:	c9                   	leaveq 
  801a33:	c3                   	retq   

0000000000801a34 <opencons>:

int
opencons(void)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a3c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801a40:	48 89 c7             	mov    %rax,%rdi
  801a43:	48 b8 cf 05 80 00 00 	movabs $0x8005cf,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
  801a4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a56:	79 05                	jns    801a5d <opencons+0x29>
		return r;
  801a58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5b:	eb 5b                	jmp    801ab8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a61:	ba 07 04 00 00       	mov    $0x407,%edx
  801a66:	48 89 c6             	mov    %rax,%rsi
  801a69:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6e:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801a75:	00 00 00 
  801a78:	ff d0                	callq  *%rax
  801a7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a81:	79 05                	jns    801a88 <opencons+0x54>
		return r;
  801a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a86:	eb 30                	jmp    801ab8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801a88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a8c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801a93:	00 00 00 
  801a96:	8b 12                	mov    (%rdx),%edx
  801a98:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa9:	48 89 c7             	mov    %rax,%rdi
  801aac:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	callq  *%rax
}
  801ab8:	c9                   	leaveq 
  801ab9:	c3                   	retq   

0000000000801aba <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801aba:	55                   	push   %rbp
  801abb:	48 89 e5             	mov    %rsp,%rbp
  801abe:	48 83 ec 30          	sub    $0x30,%rsp
  801ac2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ac6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801aca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801ace:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ad3:	75 07                	jne    801adc <devcons_read+0x22>
		return 0;
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	eb 4b                	jmp    801b27 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801adc:	eb 0c                	jmp    801aea <devcons_read+0x30>
		sys_yield();
  801ade:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801aea:	48 b8 16 02 80 00 00 	movabs $0x800216,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
  801af6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801af9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801afd:	74 df                	je     801ade <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b03:	79 05                	jns    801b0a <devcons_read+0x50>
		return c;
  801b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b08:	eb 1d                	jmp    801b27 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801b0a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801b0e:	75 07                	jne    801b17 <devcons_read+0x5d>
		return 0;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
  801b15:	eb 10                	jmp    801b27 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1a:	89 c2                	mov    %eax,%edx
  801b1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b20:	88 10                	mov    %dl,(%rax)
	return 1;
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b27:	c9                   	leaveq 
  801b28:	c3                   	retq   

0000000000801b29 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801b34:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801b3b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801b42:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b50:	eb 76                	jmp    801bc8 <devcons_write+0x9f>
		m = n - tot;
  801b52:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801b59:	89 c2                	mov    %eax,%edx
  801b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5e:	29 c2                	sub    %eax,%edx
  801b60:	89 d0                	mov    %edx,%eax
  801b62:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801b65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b68:	83 f8 7f             	cmp    $0x7f,%eax
  801b6b:	76 07                	jbe    801b74 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801b6d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801b74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b77:	48 63 d0             	movslq %eax,%rdx
  801b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7d:	48 63 c8             	movslq %eax,%rcx
  801b80:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801b87:	48 01 c1             	add    %rax,%rcx
  801b8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b91:	48 89 ce             	mov    %rcx,%rsi
  801b94:	48 89 c7             	mov    %rax,%rdi
  801b97:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801ba3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba6:	48 63 d0             	movslq %eax,%rdx
  801ba9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801bb0:	48 89 d6             	mov    %rdx,%rsi
  801bb3:	48 89 c7             	mov    %rax,%rdi
  801bb6:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801bc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc5:	01 45 fc             	add    %eax,-0x4(%rbp)
  801bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcb:	48 98                	cltq   
  801bcd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801bd4:	0f 82 78 ff ff ff    	jb     801b52 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801bdd:	c9                   	leaveq 
  801bde:	c3                   	retq   

0000000000801bdf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	48 83 ec 08          	sub    $0x8,%rsp
  801be7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 10          	sub    $0x10,%rsp
  801bfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c06:	48 be d6 34 80 00 00 	movabs $0x8034d6,%rsi
  801c0d:	00 00 00 
  801c10:	48 89 c7             	mov    %rax,%rdi
  801c13:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
	return 0;
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	53                   	push   %rbx
  801c2b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801c32:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801c39:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801c3f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801c46:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801c4d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801c54:	84 c0                	test   %al,%al
  801c56:	74 23                	je     801c7b <_panic+0x55>
  801c58:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801c5f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801c63:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801c67:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801c6b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801c6f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801c73:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801c77:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801c7b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801c82:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801c89:	00 00 00 
  801c8c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801c93:	00 00 00 
  801c96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c9a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801ca1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801ca8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801caf:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801cb6:	00 00 00 
  801cb9:	48 8b 18             	mov    (%rax),%rbx
  801cbc:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
  801cc8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801cce:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801cd5:	41 89 c8             	mov    %ecx,%r8d
  801cd8:	48 89 d1             	mov    %rdx,%rcx
  801cdb:	48 89 da             	mov    %rbx,%rdx
  801cde:	89 c6                	mov    %eax,%esi
  801ce0:	48 bf e0 34 80 00 00 	movabs $0x8034e0,%rdi
  801ce7:	00 00 00 
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
  801cef:	49 b9 5f 1e 80 00 00 	movabs $0x801e5f,%r9
  801cf6:	00 00 00 
  801cf9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801cfc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801d03:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801d0a:	48 89 d6             	mov    %rdx,%rsi
  801d0d:	48 89 c7             	mov    %rax,%rdi
  801d10:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801d17:	00 00 00 
  801d1a:	ff d0                	callq  *%rax
	cprintf("\n");
  801d1c:	48 bf 03 35 80 00 00 	movabs $0x803503,%rdi
  801d23:	00 00 00 
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2b:	48 ba 5f 1e 80 00 00 	movabs $0x801e5f,%rdx
  801d32:	00 00 00 
  801d35:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d37:	cc                   	int3   
  801d38:	eb fd                	jmp    801d37 <_panic+0x111>

0000000000801d3a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 10          	sub    $0x10,%rsp
  801d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4d:	8b 00                	mov    (%rax),%eax
  801d4f:	8d 48 01             	lea    0x1(%rax),%ecx
  801d52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d56:	89 0a                	mov    %ecx,(%rdx)
  801d58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d5b:	89 d1                	mov    %edx,%ecx
  801d5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d61:	48 98                	cltq   
  801d63:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6b:	8b 00                	mov    (%rax),%eax
  801d6d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d72:	75 2c                	jne    801da0 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d78:	8b 00                	mov    (%rax),%eax
  801d7a:	48 98                	cltq   
  801d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d80:	48 83 c2 08          	add    $0x8,%rdx
  801d84:	48 89 c6             	mov    %rax,%rsi
  801d87:	48 89 d7             	mov    %rdx,%rdi
  801d8a:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  801d91:	00 00 00 
  801d94:	ff d0                	callq  *%rax
		b->idx = 0;
  801d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da4:	8b 40 04             	mov    0x4(%rax),%eax
  801da7:	8d 50 01             	lea    0x1(%rax),%edx
  801daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dae:	89 50 04             	mov    %edx,0x4(%rax)
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801dbe:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801dc5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801dcc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801dd3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801dda:	48 8b 0a             	mov    (%rdx),%rcx
  801ddd:	48 89 08             	mov    %rcx,(%rax)
  801de0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801de4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801de8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801dec:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801df0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801df7:	00 00 00 
	b.cnt = 0;
  801dfa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801e01:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801e04:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801e0b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801e12:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801e19:	48 89 c6             	mov    %rax,%rsi
  801e1c:	48 bf 3a 1d 80 00 00 	movabs $0x801d3a,%rdi
  801e23:	00 00 00 
  801e26:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801e32:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801e38:	48 98                	cltq   
  801e3a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801e41:	48 83 c2 08          	add    $0x8,%rdx
  801e45:	48 89 c6             	mov    %rax,%rsi
  801e48:	48 89 d7             	mov    %rdx,%rdi
  801e4b:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  801e52:	00 00 00 
  801e55:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801e57:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801e5d:	c9                   	leaveq 
  801e5e:	c3                   	retq   

0000000000801e5f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e5f:	55                   	push   %rbp
  801e60:	48 89 e5             	mov    %rsp,%rbp
  801e63:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801e6a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801e71:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801e78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e8d:	84 c0                	test   %al,%al
  801e8f:	74 20                	je     801eb1 <cprintf+0x52>
  801e91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801ea1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801ea5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801ea9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801ead:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801eb1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801eb8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801ebf:	00 00 00 
  801ec2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801ec9:	00 00 00 
  801ecc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ed0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801ed7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801ede:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801ee5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801eec:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801ef3:	48 8b 0a             	mov    (%rdx),%rcx
  801ef6:	48 89 08             	mov    %rcx,(%rax)
  801ef9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801efd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f01:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f05:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801f09:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801f10:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f17:	48 89 d6             	mov    %rdx,%rsi
  801f1a:	48 89 c7             	mov    %rax,%rdi
  801f1d:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801f24:	00 00 00 
  801f27:	ff d0                	callq  *%rax
  801f29:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801f2f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
  801f3b:	53                   	push   %rbx
  801f3c:	48 83 ec 38          	sub    $0x38,%rsp
  801f40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801f4c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801f4f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801f53:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f57:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f5a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801f5e:	77 3b                	ja     801f9b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f60:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801f63:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801f67:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801f6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f73:	48 f7 f3             	div    %rbx
  801f76:	48 89 c2             	mov    %rax,%rdx
  801f79:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801f7c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801f7f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f87:	41 89 f9             	mov    %edi,%r9d
  801f8a:	48 89 c7             	mov    %rax,%rdi
  801f8d:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	callq  *%rax
  801f99:	eb 1e                	jmp    801fb9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f9b:	eb 12                	jmp    801faf <printnum+0x78>
			putch(padc, putdat);
  801f9d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801fa1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa8:	48 89 ce             	mov    %rcx,%rsi
  801fab:	89 d7                	mov    %edx,%edi
  801fad:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801faf:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801fb3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801fb7:	7f e4                	jg     801f9d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801fb9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801fbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc5:	48 f7 f1             	div    %rcx
  801fc8:	48 89 d0             	mov    %rdx,%rax
  801fcb:	48 ba e8 36 80 00 00 	movabs $0x8036e8,%rdx
  801fd2:	00 00 00 
  801fd5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  801fd9:	0f be d0             	movsbl %al,%edx
  801fdc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe4:	48 89 ce             	mov    %rcx,%rsi
  801fe7:	89 d7                	mov    %edx,%edi
  801fe9:	ff d0                	callq  *%rax
}
  801feb:	48 83 c4 38          	add    $0x38,%rsp
  801fef:	5b                   	pop    %rbx
  801ff0:	5d                   	pop    %rbp
  801ff1:	c3                   	retq   

0000000000801ff2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ff2:	55                   	push   %rbp
  801ff3:	48 89 e5             	mov    %rsp,%rbp
  801ff6:	48 83 ec 1c          	sub    $0x1c,%rsp
  801ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ffe:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802001:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802005:	7e 52                	jle    802059 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200b:	8b 00                	mov    (%rax),%eax
  80200d:	83 f8 30             	cmp    $0x30,%eax
  802010:	73 24                	jae    802036 <getuint+0x44>
  802012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802016:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80201a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201e:	8b 00                	mov    (%rax),%eax
  802020:	89 c0                	mov    %eax,%eax
  802022:	48 01 d0             	add    %rdx,%rax
  802025:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802029:	8b 12                	mov    (%rdx),%edx
  80202b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80202e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802032:	89 0a                	mov    %ecx,(%rdx)
  802034:	eb 17                	jmp    80204d <getuint+0x5b>
  802036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80203e:	48 89 d0             	mov    %rdx,%rax
  802041:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802045:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802049:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80204d:	48 8b 00             	mov    (%rax),%rax
  802050:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802054:	e9 a3 00 00 00       	jmpq   8020fc <getuint+0x10a>
	else if (lflag)
  802059:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80205d:	74 4f                	je     8020ae <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80205f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802063:	8b 00                	mov    (%rax),%eax
  802065:	83 f8 30             	cmp    $0x30,%eax
  802068:	73 24                	jae    80208e <getuint+0x9c>
  80206a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802076:	8b 00                	mov    (%rax),%eax
  802078:	89 c0                	mov    %eax,%eax
  80207a:	48 01 d0             	add    %rdx,%rax
  80207d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802081:	8b 12                	mov    (%rdx),%edx
  802083:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802086:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80208a:	89 0a                	mov    %ecx,(%rdx)
  80208c:	eb 17                	jmp    8020a5 <getuint+0xb3>
  80208e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802092:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802096:	48 89 d0             	mov    %rdx,%rax
  802099:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80209d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020a5:	48 8b 00             	mov    (%rax),%rax
  8020a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020ac:	eb 4e                	jmp    8020fc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8020ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b2:	8b 00                	mov    (%rax),%eax
  8020b4:	83 f8 30             	cmp    $0x30,%eax
  8020b7:	73 24                	jae    8020dd <getuint+0xeb>
  8020b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c5:	8b 00                	mov    (%rax),%eax
  8020c7:	89 c0                	mov    %eax,%eax
  8020c9:	48 01 d0             	add    %rdx,%rax
  8020cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d0:	8b 12                	mov    (%rdx),%edx
  8020d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d9:	89 0a                	mov    %ecx,(%rdx)
  8020db:	eb 17                	jmp    8020f4 <getuint+0x102>
  8020dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020e5:	48 89 d0             	mov    %rdx,%rax
  8020e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020f4:	8b 00                	mov    (%rax),%eax
  8020f6:	89 c0                	mov    %eax,%eax
  8020f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8020fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802100:	c9                   	leaveq 
  802101:	c3                   	retq   

0000000000802102 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802102:	55                   	push   %rbp
  802103:	48 89 e5             	mov    %rsp,%rbp
  802106:	48 83 ec 1c          	sub    $0x1c,%rsp
  80210a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80210e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802111:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802115:	7e 52                	jle    802169 <getint+0x67>
		x=va_arg(*ap, long long);
  802117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211b:	8b 00                	mov    (%rax),%eax
  80211d:	83 f8 30             	cmp    $0x30,%eax
  802120:	73 24                	jae    802146 <getint+0x44>
  802122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802126:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	8b 00                	mov    (%rax),%eax
  802130:	89 c0                	mov    %eax,%eax
  802132:	48 01 d0             	add    %rdx,%rax
  802135:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802139:	8b 12                	mov    (%rdx),%edx
  80213b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80213e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802142:	89 0a                	mov    %ecx,(%rdx)
  802144:	eb 17                	jmp    80215d <getint+0x5b>
  802146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80214e:	48 89 d0             	mov    %rdx,%rax
  802151:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802159:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80215d:	48 8b 00             	mov    (%rax),%rax
  802160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802164:	e9 a3 00 00 00       	jmpq   80220c <getint+0x10a>
	else if (lflag)
  802169:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80216d:	74 4f                	je     8021be <getint+0xbc>
		x=va_arg(*ap, long);
  80216f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802173:	8b 00                	mov    (%rax),%eax
  802175:	83 f8 30             	cmp    $0x30,%eax
  802178:	73 24                	jae    80219e <getint+0x9c>
  80217a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802186:	8b 00                	mov    (%rax),%eax
  802188:	89 c0                	mov    %eax,%eax
  80218a:	48 01 d0             	add    %rdx,%rax
  80218d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802191:	8b 12                	mov    (%rdx),%edx
  802193:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802196:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80219a:	89 0a                	mov    %ecx,(%rdx)
  80219c:	eb 17                	jmp    8021b5 <getint+0xb3>
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021a6:	48 89 d0             	mov    %rdx,%rax
  8021a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021b5:	48 8b 00             	mov    (%rax),%rax
  8021b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021bc:	eb 4e                	jmp    80220c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8021be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c2:	8b 00                	mov    (%rax),%eax
  8021c4:	83 f8 30             	cmp    $0x30,%eax
  8021c7:	73 24                	jae    8021ed <getint+0xeb>
  8021c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d5:	8b 00                	mov    (%rax),%eax
  8021d7:	89 c0                	mov    %eax,%eax
  8021d9:	48 01 d0             	add    %rdx,%rax
  8021dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021e0:	8b 12                	mov    (%rdx),%edx
  8021e2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021e9:	89 0a                	mov    %ecx,(%rdx)
  8021eb:	eb 17                	jmp    802204 <getint+0x102>
  8021ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021f5:	48 89 d0             	mov    %rdx,%rax
  8021f8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802200:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802204:	8b 00                	mov    (%rax),%eax
  802206:	48 98                	cltq   
  802208:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80220c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802210:	c9                   	leaveq 
  802211:	c3                   	retq   

0000000000802212 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802212:	55                   	push   %rbp
  802213:	48 89 e5             	mov    %rsp,%rbp
  802216:	41 54                	push   %r12
  802218:	53                   	push   %rbx
  802219:	48 83 ec 60          	sub    $0x60,%rsp
  80221d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802221:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802225:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802229:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80222d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802231:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802235:	48 8b 0a             	mov    (%rdx),%rcx
  802238:	48 89 08             	mov    %rcx,(%rax)
  80223b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80223f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802243:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802247:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80224b:	eb 17                	jmp    802264 <vprintfmt+0x52>
			if (ch == '\0')
  80224d:	85 db                	test   %ebx,%ebx
  80224f:	0f 84 cc 04 00 00    	je     802721 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802255:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802259:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80225d:	48 89 d6             	mov    %rdx,%rsi
  802260:	89 df                	mov    %ebx,%edi
  802262:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802264:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802268:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80226c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802270:	0f b6 00             	movzbl (%rax),%eax
  802273:	0f b6 d8             	movzbl %al,%ebx
  802276:	83 fb 25             	cmp    $0x25,%ebx
  802279:	75 d2                	jne    80224d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80227b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80227f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802286:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80228d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802294:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80229b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80229f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022a3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8022a7:	0f b6 00             	movzbl (%rax),%eax
  8022aa:	0f b6 d8             	movzbl %al,%ebx
  8022ad:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8022b0:	83 f8 55             	cmp    $0x55,%eax
  8022b3:	0f 87 34 04 00 00    	ja     8026ed <vprintfmt+0x4db>
  8022b9:	89 c0                	mov    %eax,%eax
  8022bb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022c2:	00 
  8022c3:	48 b8 10 37 80 00 00 	movabs $0x803710,%rax
  8022ca:	00 00 00 
  8022cd:	48 01 d0             	add    %rdx,%rax
  8022d0:	48 8b 00             	mov    (%rax),%rax
  8022d3:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8022d5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8022d9:	eb c0                	jmp    80229b <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8022db:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8022df:	eb ba                	jmp    80229b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8022e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8022e8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	c1 e0 02             	shl    $0x2,%eax
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	01 c0                	add    %eax,%eax
  8022f4:	01 d8                	add    %ebx,%eax
  8022f6:	83 e8 30             	sub    $0x30,%eax
  8022f9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8022fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802300:	0f b6 00             	movzbl (%rax),%eax
  802303:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802306:	83 fb 2f             	cmp    $0x2f,%ebx
  802309:	7e 0c                	jle    802317 <vprintfmt+0x105>
  80230b:	83 fb 39             	cmp    $0x39,%ebx
  80230e:	7f 07                	jg     802317 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802310:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802315:	eb d1                	jmp    8022e8 <vprintfmt+0xd6>
			goto process_precision;
  802317:	eb 58                	jmp    802371 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802319:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80231c:	83 f8 30             	cmp    $0x30,%eax
  80231f:	73 17                	jae    802338 <vprintfmt+0x126>
  802321:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802325:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802328:	89 c0                	mov    %eax,%eax
  80232a:	48 01 d0             	add    %rdx,%rax
  80232d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802330:	83 c2 08             	add    $0x8,%edx
  802333:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802336:	eb 0f                	jmp    802347 <vprintfmt+0x135>
  802338:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80233c:	48 89 d0             	mov    %rdx,%rax
  80233f:	48 83 c2 08          	add    $0x8,%rdx
  802343:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802347:	8b 00                	mov    (%rax),%eax
  802349:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80234c:	eb 23                	jmp    802371 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80234e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802352:	79 0c                	jns    802360 <vprintfmt+0x14e>
				width = 0;
  802354:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80235b:	e9 3b ff ff ff       	jmpq   80229b <vprintfmt+0x89>
  802360:	e9 36 ff ff ff       	jmpq   80229b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802365:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80236c:	e9 2a ff ff ff       	jmpq   80229b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802371:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802375:	79 12                	jns    802389 <vprintfmt+0x177>
				width = precision, precision = -1;
  802377:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80237a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80237d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802384:	e9 12 ff ff ff       	jmpq   80229b <vprintfmt+0x89>
  802389:	e9 0d ff ff ff       	jmpq   80229b <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80238e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802392:	e9 04 ff ff ff       	jmpq   80229b <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802397:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80239a:	83 f8 30             	cmp    $0x30,%eax
  80239d:	73 17                	jae    8023b6 <vprintfmt+0x1a4>
  80239f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023a6:	89 c0                	mov    %eax,%eax
  8023a8:	48 01 d0             	add    %rdx,%rax
  8023ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8023ae:	83 c2 08             	add    $0x8,%edx
  8023b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8023b4:	eb 0f                	jmp    8023c5 <vprintfmt+0x1b3>
  8023b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023ba:	48 89 d0             	mov    %rdx,%rax
  8023bd:	48 83 c2 08          	add    $0x8,%rdx
  8023c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8023c5:	8b 10                	mov    (%rax),%edx
  8023c7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8023cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8023cf:	48 89 ce             	mov    %rcx,%rsi
  8023d2:	89 d7                	mov    %edx,%edi
  8023d4:	ff d0                	callq  *%rax
			break;
  8023d6:	e9 40 03 00 00       	jmpq   80271b <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8023db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023de:	83 f8 30             	cmp    $0x30,%eax
  8023e1:	73 17                	jae    8023fa <vprintfmt+0x1e8>
  8023e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8023ea:	89 c0                	mov    %eax,%eax
  8023ec:	48 01 d0             	add    %rdx,%rax
  8023ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8023f2:	83 c2 08             	add    $0x8,%edx
  8023f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8023f8:	eb 0f                	jmp    802409 <vprintfmt+0x1f7>
  8023fa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8023fe:	48 89 d0             	mov    %rdx,%rax
  802401:	48 83 c2 08          	add    $0x8,%rdx
  802405:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802409:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80240b:	85 db                	test   %ebx,%ebx
  80240d:	79 02                	jns    802411 <vprintfmt+0x1ff>
				err = -err;
  80240f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802411:	83 fb 10             	cmp    $0x10,%ebx
  802414:	7f 16                	jg     80242c <vprintfmt+0x21a>
  802416:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  80241d:	00 00 00 
  802420:	48 63 d3             	movslq %ebx,%rdx
  802423:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802427:	4d 85 e4             	test   %r12,%r12
  80242a:	75 2e                	jne    80245a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80242c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802430:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802434:	89 d9                	mov    %ebx,%ecx
  802436:	48 ba f9 36 80 00 00 	movabs $0x8036f9,%rdx
  80243d:	00 00 00 
  802440:	48 89 c7             	mov    %rax,%rdi
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	49 b8 2a 27 80 00 00 	movabs $0x80272a,%r8
  80244f:	00 00 00 
  802452:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802455:	e9 c1 02 00 00       	jmpq   80271b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80245a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80245e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802462:	4c 89 e1             	mov    %r12,%rcx
  802465:	48 ba 02 37 80 00 00 	movabs $0x803702,%rdx
  80246c:	00 00 00 
  80246f:	48 89 c7             	mov    %rax,%rdi
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	49 b8 2a 27 80 00 00 	movabs $0x80272a,%r8
  80247e:	00 00 00 
  802481:	41 ff d0             	callq  *%r8
			break;
  802484:	e9 92 02 00 00       	jmpq   80271b <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802489:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80248c:	83 f8 30             	cmp    $0x30,%eax
  80248f:	73 17                	jae    8024a8 <vprintfmt+0x296>
  802491:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802495:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802498:	89 c0                	mov    %eax,%eax
  80249a:	48 01 d0             	add    %rdx,%rax
  80249d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024a0:	83 c2 08             	add    $0x8,%edx
  8024a3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024a6:	eb 0f                	jmp    8024b7 <vprintfmt+0x2a5>
  8024a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024ac:	48 89 d0             	mov    %rdx,%rax
  8024af:	48 83 c2 08          	add    $0x8,%rdx
  8024b3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024b7:	4c 8b 20             	mov    (%rax),%r12
  8024ba:	4d 85 e4             	test   %r12,%r12
  8024bd:	75 0a                	jne    8024c9 <vprintfmt+0x2b7>
				p = "(null)";
  8024bf:	49 bc 05 37 80 00 00 	movabs $0x803705,%r12
  8024c6:	00 00 00 
			if (width > 0 && padc != '-')
  8024c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024cd:	7e 3f                	jle    80250e <vprintfmt+0x2fc>
  8024cf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8024d3:	74 39                	je     80250e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8024d5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8024d8:	48 98                	cltq   
  8024da:	48 89 c6             	mov    %rax,%rsi
  8024dd:	4c 89 e7             	mov    %r12,%rdi
  8024e0:	48 b8 d6 29 80 00 00 	movabs $0x8029d6,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
  8024ec:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8024ef:	eb 17                	jmp    802508 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8024f1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8024f5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024fd:	48 89 ce             	mov    %rcx,%rsi
  802500:	89 d7                	mov    %edx,%edi
  802502:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802504:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802508:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80250c:	7f e3                	jg     8024f1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80250e:	eb 37                	jmp    802547 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802510:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802514:	74 1e                	je     802534 <vprintfmt+0x322>
  802516:	83 fb 1f             	cmp    $0x1f,%ebx
  802519:	7e 05                	jle    802520 <vprintfmt+0x30e>
  80251b:	83 fb 7e             	cmp    $0x7e,%ebx
  80251e:	7e 14                	jle    802534 <vprintfmt+0x322>
					putch('?', putdat);
  802520:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802524:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802530:	ff d0                	callq  *%rax
  802532:	eb 0f                	jmp    802543 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802534:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802538:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80253c:	48 89 d6             	mov    %rdx,%rsi
  80253f:	89 df                	mov    %ebx,%edi
  802541:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802543:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802547:	4c 89 e0             	mov    %r12,%rax
  80254a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80254e:	0f b6 00             	movzbl (%rax),%eax
  802551:	0f be d8             	movsbl %al,%ebx
  802554:	85 db                	test   %ebx,%ebx
  802556:	74 10                	je     802568 <vprintfmt+0x356>
  802558:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80255c:	78 b2                	js     802510 <vprintfmt+0x2fe>
  80255e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802562:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802566:	79 a8                	jns    802510 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802568:	eb 16                	jmp    802580 <vprintfmt+0x36e>
				putch(' ', putdat);
  80256a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80256e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802572:	48 89 d6             	mov    %rdx,%rsi
  802575:	bf 20 00 00 00       	mov    $0x20,%edi
  80257a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80257c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802580:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802584:	7f e4                	jg     80256a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802586:	e9 90 01 00 00       	jmpq   80271b <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80258b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80258f:	be 03 00 00 00       	mov    $0x3,%esi
  802594:	48 89 c7             	mov    %rax,%rdi
  802597:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	48 85 c0             	test   %rax,%rax
  8025ae:	79 1d                	jns    8025cd <vprintfmt+0x3bb>
				putch('-', putdat);
  8025b0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8025b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025b8:	48 89 d6             	mov    %rdx,%rsi
  8025bb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8025c0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8025c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c6:	48 f7 d8             	neg    %rax
  8025c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8025cd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8025d4:	e9 d5 00 00 00       	jmpq   8026ae <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8025d9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8025dd:	be 03 00 00 00       	mov    $0x3,%esi
  8025e2:	48 89 c7             	mov    %rax,%rdi
  8025e5:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	callq  *%rax
  8025f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8025f5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8025fc:	e9 ad 00 00 00       	jmpq   8026ae <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  802601:	8b 55 e0             	mov    -0x20(%rbp),%edx
  802604:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802608:	89 d6                	mov    %edx,%esi
  80260a:	48 89 c7             	mov    %rax,%rdi
  80260d:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
  802619:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80261d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802624:	e9 85 00 00 00       	jmpq   8026ae <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  802629:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80262d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802631:	48 89 d6             	mov    %rdx,%rsi
  802634:	bf 30 00 00 00       	mov    $0x30,%edi
  802639:	ff d0                	callq  *%rax
			putch('x', putdat);
  80263b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80263f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802643:	48 89 d6             	mov    %rdx,%rsi
  802646:	bf 78 00 00 00       	mov    $0x78,%edi
  80264b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80264d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802650:	83 f8 30             	cmp    $0x30,%eax
  802653:	73 17                	jae    80266c <vprintfmt+0x45a>
  802655:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802659:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80265c:	89 c0                	mov    %eax,%eax
  80265e:	48 01 d0             	add    %rdx,%rax
  802661:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802664:	83 c2 08             	add    $0x8,%edx
  802667:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80266a:	eb 0f                	jmp    80267b <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80266c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802670:	48 89 d0             	mov    %rdx,%rax
  802673:	48 83 c2 08          	add    $0x8,%rdx
  802677:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80267b:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80267e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802682:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  802689:	eb 23                	jmp    8026ae <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80268b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80268f:	be 03 00 00 00       	mov    $0x3,%esi
  802694:	48 89 c7             	mov    %rax,%rdi
  802697:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
  8026a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8026a7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8026ae:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8026b3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8026b6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8026b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8026c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c5:	45 89 c1             	mov    %r8d,%r9d
  8026c8:	41 89 f8             	mov    %edi,%r8d
  8026cb:	48 89 c7             	mov    %rax,%rdi
  8026ce:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
			break;
  8026da:	eb 3f                	jmp    80271b <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8026dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026e4:	48 89 d6             	mov    %rdx,%rsi
  8026e7:	89 df                	mov    %ebx,%edi
  8026e9:	ff d0                	callq  *%rax
			break;
  8026eb:	eb 2e                	jmp    80271b <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8026ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026f5:	48 89 d6             	mov    %rdx,%rsi
  8026f8:	bf 25 00 00 00       	mov    $0x25,%edi
  8026fd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8026ff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802704:	eb 05                	jmp    80270b <vprintfmt+0x4f9>
  802706:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80270b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80270f:	48 83 e8 01          	sub    $0x1,%rax
  802713:	0f b6 00             	movzbl (%rax),%eax
  802716:	3c 25                	cmp    $0x25,%al
  802718:	75 ec                	jne    802706 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80271a:	90                   	nop
		}
	}
  80271b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80271c:	e9 43 fb ff ff       	jmpq   802264 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  802721:	48 83 c4 60          	add    $0x60,%rsp
  802725:	5b                   	pop    %rbx
  802726:	41 5c                	pop    %r12
  802728:	5d                   	pop    %rbp
  802729:	c3                   	retq   

000000000080272a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80272a:	55                   	push   %rbp
  80272b:	48 89 e5             	mov    %rsp,%rbp
  80272e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802735:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80273c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802743:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80274a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802751:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802758:	84 c0                	test   %al,%al
  80275a:	74 20                	je     80277c <printfmt+0x52>
  80275c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802760:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802764:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802768:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80276c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802770:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802774:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802778:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80277c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802783:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80278a:	00 00 00 
  80278d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802794:	00 00 00 
  802797:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80279b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8027a2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8027a9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8027b0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8027b7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8027be:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8027c5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8027cc:	48 89 c7             	mov    %rax,%rdi
  8027cf:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
	va_end(ap);
}
  8027db:	c9                   	leaveq 
  8027dc:	c3                   	retq   

00000000008027dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8027dd:	55                   	push   %rbp
  8027de:	48 89 e5             	mov    %rsp,%rbp
  8027e1:	48 83 ec 10          	sub    $0x10,%rsp
  8027e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8027ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f0:	8b 40 10             	mov    0x10(%rax),%eax
  8027f3:	8d 50 01             	lea    0x1(%rax),%edx
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8027fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802801:	48 8b 10             	mov    (%rax),%rdx
  802804:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802808:	48 8b 40 08          	mov    0x8(%rax),%rax
  80280c:	48 39 c2             	cmp    %rax,%rdx
  80280f:	73 17                	jae    802828 <sprintputch+0x4b>
		*b->buf++ = ch;
  802811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802815:	48 8b 00             	mov    (%rax),%rax
  802818:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80281c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802820:	48 89 0a             	mov    %rcx,(%rdx)
  802823:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802826:	88 10                	mov    %dl,(%rax)
}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	48 83 ec 50          	sub    $0x50,%rsp
  802832:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802836:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802839:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80283d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802841:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802845:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802849:	48 8b 0a             	mov    (%rdx),%rcx
  80284c:	48 89 08             	mov    %rcx,(%rax)
  80284f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802853:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802857:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80285b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80285f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802863:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802867:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80286a:	48 98                	cltq   
  80286c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802870:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802874:	48 01 d0             	add    %rdx,%rax
  802877:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80287b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802882:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802887:	74 06                	je     80288f <vsnprintf+0x65>
  802889:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80288d:	7f 07                	jg     802896 <vsnprintf+0x6c>
		return -E_INVAL;
  80288f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802894:	eb 2f                	jmp    8028c5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802896:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80289a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80289e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028a2:	48 89 c6             	mov    %rax,%rsi
  8028a5:	48 bf dd 27 80 00 00 	movabs $0x8027dd,%rdi
  8028ac:	00 00 00 
  8028af:	48 b8 12 22 80 00 00 	movabs $0x802212,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8028bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028bf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8028c2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8028c5:	c9                   	leaveq 
  8028c6:	c3                   	retq   

00000000008028c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8028c7:	55                   	push   %rbp
  8028c8:	48 89 e5             	mov    %rsp,%rbp
  8028cb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8028d2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8028d9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8028df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8028e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8028ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8028f4:	84 c0                	test   %al,%al
  8028f6:	74 20                	je     802918 <snprintf+0x51>
  8028f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8028fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802900:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802904:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802908:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80290c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802910:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802914:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802918:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80291f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802926:	00 00 00 
  802929:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802930:	00 00 00 
  802933:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802937:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80293e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802945:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80294c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802953:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80295a:	48 8b 0a             	mov    (%rdx),%rcx
  80295d:	48 89 08             	mov    %rcx,(%rax)
  802960:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802964:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802968:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80296c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802970:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802977:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80297e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802984:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80298b:	48 89 c7             	mov    %rax,%rdi
  80298e:	48 b8 2a 28 80 00 00 	movabs $0x80282a,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
  80299a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8029a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029a6:	c9                   	leaveq 
  8029a7:	c3                   	retq   

00000000008029a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8029a8:	55                   	push   %rbp
  8029a9:	48 89 e5             	mov    %rsp,%rbp
  8029ac:	48 83 ec 18          	sub    $0x18,%rsp
  8029b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8029b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029bb:	eb 09                	jmp    8029c6 <strlen+0x1e>
		n++;
  8029bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8029c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8029c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ca:	0f b6 00             	movzbl (%rax),%eax
  8029cd:	84 c0                	test   %al,%al
  8029cf:	75 ec                	jne    8029bd <strlen+0x15>
		n++;
	return n;
  8029d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029d4:	c9                   	leaveq 
  8029d5:	c3                   	retq   

00000000008029d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8029d6:	55                   	push   %rbp
  8029d7:	48 89 e5             	mov    %rsp,%rbp
  8029da:	48 83 ec 20          	sub    $0x20,%rsp
  8029de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8029e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029ed:	eb 0e                	jmp    8029fd <strnlen+0x27>
		n++;
  8029ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8029f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8029f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8029fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a02:	74 0b                	je     802a0f <strnlen+0x39>
  802a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a08:	0f b6 00             	movzbl (%rax),%eax
  802a0b:	84 c0                	test   %al,%al
  802a0d:	75 e0                	jne    8029ef <strnlen+0x19>
		n++;
	return n;
  802a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a12:	c9                   	leaveq 
  802a13:	c3                   	retq   

0000000000802a14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802a14:	55                   	push   %rbp
  802a15:	48 89 e5             	mov    %rsp,%rbp
  802a18:	48 83 ec 20          	sub    $0x20,%rsp
  802a1c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802a24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a28:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802a2c:	90                   	nop
  802a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802a35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802a39:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a3d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802a41:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802a45:	0f b6 12             	movzbl (%rdx),%edx
  802a48:	88 10                	mov    %dl,(%rax)
  802a4a:	0f b6 00             	movzbl (%rax),%eax
  802a4d:	84 c0                	test   %al,%al
  802a4f:	75 dc                	jne    802a2d <strcpy+0x19>
		/* do nothing */;
	return ret;
  802a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 20          	sub    $0x20,%rsp
  802a5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6b:	48 89 c7             	mov    %rax,%rdi
  802a6e:	48 b8 a8 29 80 00 00 	movabs $0x8029a8,%rax
  802a75:	00 00 00 
  802a78:	ff d0                	callq  *%rax
  802a7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a80:	48 63 d0             	movslq %eax,%rdx
  802a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a87:	48 01 c2             	add    %rax,%rdx
  802a8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8e:	48 89 c6             	mov    %rax,%rsi
  802a91:	48 89 d7             	mov    %rdx,%rdi
  802a94:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
	return dst;
  802aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802aa4:	c9                   	leaveq 
  802aa5:	c3                   	retq   

0000000000802aa6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802aa6:	55                   	push   %rbp
  802aa7:	48 89 e5             	mov    %rsp,%rbp
  802aaa:	48 83 ec 28          	sub    $0x28,%rsp
  802aae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ab2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ab6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802ac2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ac9:	00 
  802aca:	eb 2a                	jmp    802af6 <strncpy+0x50>
		*dst++ = *src;
  802acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ad4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802ad8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802adc:	0f b6 12             	movzbl (%rdx),%edx
  802adf:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ae1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae5:	0f b6 00             	movzbl (%rax),%eax
  802ae8:	84 c0                	test   %al,%al
  802aea:	74 05                	je     802af1 <strncpy+0x4b>
			src++;
  802aec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802af1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802af6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802afe:	72 cc                	jb     802acc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802b04:	c9                   	leaveq 
  802b05:	c3                   	retq   

0000000000802b06 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802b06:	55                   	push   %rbp
  802b07:	48 89 e5             	mov    %rsp,%rbp
  802b0a:	48 83 ec 28          	sub    $0x28,%rsp
  802b0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b16:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802b22:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b27:	74 3d                	je     802b66 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802b29:	eb 1d                	jmp    802b48 <strlcpy+0x42>
			*dst++ = *src++;
  802b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b37:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b3b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b3f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b43:	0f b6 12             	movzbl (%rdx),%edx
  802b46:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802b48:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802b4d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b52:	74 0b                	je     802b5f <strlcpy+0x59>
  802b54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b58:	0f b6 00             	movzbl (%rax),%eax
  802b5b:	84 c0                	test   %al,%al
  802b5d:	75 cc                	jne    802b2b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802b66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b6e:	48 29 c2             	sub    %rax,%rdx
  802b71:	48 89 d0             	mov    %rdx,%rax
}
  802b74:	c9                   	leaveq 
  802b75:	c3                   	retq   

0000000000802b76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802b76:	55                   	push   %rbp
  802b77:	48 89 e5             	mov    %rsp,%rbp
  802b7a:	48 83 ec 10          	sub    $0x10,%rsp
  802b7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b82:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802b86:	eb 0a                	jmp    802b92 <strcmp+0x1c>
		p++, q++;
  802b88:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802b8d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b96:	0f b6 00             	movzbl (%rax),%eax
  802b99:	84 c0                	test   %al,%al
  802b9b:	74 12                	je     802baf <strcmp+0x39>
  802b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ba1:	0f b6 10             	movzbl (%rax),%edx
  802ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba8:	0f b6 00             	movzbl (%rax),%eax
  802bab:	38 c2                	cmp    %al,%dl
  802bad:	74 d9                	je     802b88 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb3:	0f b6 00             	movzbl (%rax),%eax
  802bb6:	0f b6 d0             	movzbl %al,%edx
  802bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbd:	0f b6 00             	movzbl (%rax),%eax
  802bc0:	0f b6 c0             	movzbl %al,%eax
  802bc3:	29 c2                	sub    %eax,%edx
  802bc5:	89 d0                	mov    %edx,%eax
}
  802bc7:	c9                   	leaveq 
  802bc8:	c3                   	retq   

0000000000802bc9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802bc9:	55                   	push   %rbp
  802bca:	48 89 e5             	mov    %rsp,%rbp
  802bcd:	48 83 ec 18          	sub    $0x18,%rsp
  802bd1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802bdd:	eb 0f                	jmp    802bee <strncmp+0x25>
		n--, p++, q++;
  802bdf:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802be4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802be9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802bee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802bf3:	74 1d                	je     802c12 <strncmp+0x49>
  802bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf9:	0f b6 00             	movzbl (%rax),%eax
  802bfc:	84 c0                	test   %al,%al
  802bfe:	74 12                	je     802c12 <strncmp+0x49>
  802c00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c04:	0f b6 10             	movzbl (%rax),%edx
  802c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0b:	0f b6 00             	movzbl (%rax),%eax
  802c0e:	38 c2                	cmp    %al,%dl
  802c10:	74 cd                	je     802bdf <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802c12:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c17:	75 07                	jne    802c20 <strncmp+0x57>
		return 0;
  802c19:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1e:	eb 18                	jmp    802c38 <strncmp+0x6f>
	else
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

0000000000802c3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802c3a:	55                   	push   %rbp
  802c3b:	48 89 e5             	mov    %rsp,%rbp
  802c3e:	48 83 ec 0c          	sub    $0xc,%rsp
  802c42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c46:	89 f0                	mov    %esi,%eax
  802c48:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802c4b:	eb 17                	jmp    802c64 <strchr+0x2a>
		if (*s == c)
  802c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c51:	0f b6 00             	movzbl (%rax),%eax
  802c54:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802c57:	75 06                	jne    802c5f <strchr+0x25>
			return (char *) s;
  802c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5d:	eb 15                	jmp    802c74 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802c5f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c68:	0f b6 00             	movzbl (%rax),%eax
  802c6b:	84 c0                	test   %al,%al
  802c6d:	75 de                	jne    802c4d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c74:	c9                   	leaveq 
  802c75:	c3                   	retq   

0000000000802c76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802c76:	55                   	push   %rbp
  802c77:	48 89 e5             	mov    %rsp,%rbp
  802c7a:	48 83 ec 0c          	sub    $0xc,%rsp
  802c7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c82:	89 f0                	mov    %esi,%eax
  802c84:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802c87:	eb 13                	jmp    802c9c <strfind+0x26>
		if (*s == c)
  802c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c8d:	0f b6 00             	movzbl (%rax),%eax
  802c90:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802c93:	75 02                	jne    802c97 <strfind+0x21>
			break;
  802c95:	eb 10                	jmp    802ca7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802c97:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca0:	0f b6 00             	movzbl (%rax),%eax
  802ca3:	84 c0                	test   %al,%al
  802ca5:	75 e2                	jne    802c89 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ca7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cab:	c9                   	leaveq 
  802cac:	c3                   	retq   

0000000000802cad <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802cad:	55                   	push   %rbp
  802cae:	48 89 e5             	mov    %rsp,%rbp
  802cb1:	48 83 ec 18          	sub    $0x18,%rsp
  802cb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cb9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802cbc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802cc0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cc5:	75 06                	jne    802ccd <memset+0x20>
		return v;
  802cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ccb:	eb 69                	jmp    802d36 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd1:	83 e0 03             	and    $0x3,%eax
  802cd4:	48 85 c0             	test   %rax,%rax
  802cd7:	75 48                	jne    802d21 <memset+0x74>
  802cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cdd:	83 e0 03             	and    $0x3,%eax
  802ce0:	48 85 c0             	test   %rax,%rax
  802ce3:	75 3c                	jne    802d21 <memset+0x74>
		c &= 0xFF;
  802ce5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802cec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cef:	c1 e0 18             	shl    $0x18,%eax
  802cf2:	89 c2                	mov    %eax,%edx
  802cf4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cf7:	c1 e0 10             	shl    $0x10,%eax
  802cfa:	09 c2                	or     %eax,%edx
  802cfc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cff:	c1 e0 08             	shl    $0x8,%eax
  802d02:	09 d0                	or     %edx,%eax
  802d04:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0b:	48 c1 e8 02          	shr    $0x2,%rax
  802d0f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802d12:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d19:	48 89 d7             	mov    %rdx,%rdi
  802d1c:	fc                   	cld    
  802d1d:	f3 ab                	rep stos %eax,%es:(%rdi)
  802d1f:	eb 11                	jmp    802d32 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802d21:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d2c:	48 89 d7             	mov    %rdx,%rdi
  802d2f:	fc                   	cld    
  802d30:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d36:	c9                   	leaveq 
  802d37:	c3                   	retq   

0000000000802d38 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802d38:	55                   	push   %rbp
  802d39:	48 89 e5             	mov    %rsp,%rbp
  802d3c:	48 83 ec 28          	sub    $0x28,%rsp
  802d40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802d4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d50:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d60:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802d64:	0f 83 88 00 00 00    	jae    802df2 <memmove+0xba>
  802d6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d72:	48 01 d0             	add    %rdx,%rax
  802d75:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802d79:	76 77                	jbe    802df2 <memmove+0xba>
		s += n;
  802d7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d7f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802d83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d87:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8f:	83 e0 03             	and    $0x3,%eax
  802d92:	48 85 c0             	test   %rax,%rax
  802d95:	75 3b                	jne    802dd2 <memmove+0x9a>
  802d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9b:	83 e0 03             	and    $0x3,%eax
  802d9e:	48 85 c0             	test   %rax,%rax
  802da1:	75 2f                	jne    802dd2 <memmove+0x9a>
  802da3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da7:	83 e0 03             	and    $0x3,%eax
  802daa:	48 85 c0             	test   %rax,%rax
  802dad:	75 23                	jne    802dd2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db3:	48 83 e8 04          	sub    $0x4,%rax
  802db7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dbb:	48 83 ea 04          	sub    $0x4,%rdx
  802dbf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802dc3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802dc7:	48 89 c7             	mov    %rax,%rdi
  802dca:	48 89 d6             	mov    %rdx,%rsi
  802dcd:	fd                   	std    
  802dce:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802dd0:	eb 1d                	jmp    802def <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802dd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dde:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802de2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de6:	48 89 d7             	mov    %rdx,%rdi
  802de9:	48 89 c1             	mov    %rax,%rcx
  802dec:	fd                   	std    
  802ded:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802def:	fc                   	cld    
  802df0:	eb 57                	jmp    802e49 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df6:	83 e0 03             	and    $0x3,%eax
  802df9:	48 85 c0             	test   %rax,%rax
  802dfc:	75 36                	jne    802e34 <memmove+0xfc>
  802dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e02:	83 e0 03             	and    $0x3,%eax
  802e05:	48 85 c0             	test   %rax,%rax
  802e08:	75 2a                	jne    802e34 <memmove+0xfc>
  802e0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e0e:	83 e0 03             	and    $0x3,%eax
  802e11:	48 85 c0             	test   %rax,%rax
  802e14:	75 1e                	jne    802e34 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802e16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e1a:	48 c1 e8 02          	shr    $0x2,%rax
  802e1e:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e25:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e29:	48 89 c7             	mov    %rax,%rdi
  802e2c:	48 89 d6             	mov    %rdx,%rsi
  802e2f:	fc                   	cld    
  802e30:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802e32:	eb 15                	jmp    802e49 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802e34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e3c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802e40:	48 89 c7             	mov    %rax,%rdi
  802e43:	48 89 d6             	mov    %rdx,%rsi
  802e46:	fc                   	cld    
  802e47:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802e4d:	c9                   	leaveq 
  802e4e:	c3                   	retq   

0000000000802e4f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802e4f:	55                   	push   %rbp
  802e50:	48 89 e5             	mov    %rsp,%rbp
  802e53:	48 83 ec 18          	sub    $0x18,%rsp
  802e57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802e63:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e67:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6f:	48 89 ce             	mov    %rcx,%rsi
  802e72:	48 89 c7             	mov    %rax,%rdi
  802e75:	48 b8 38 2d 80 00 00 	movabs $0x802d38,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
}
  802e81:	c9                   	leaveq 
  802e82:	c3                   	retq   

0000000000802e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802e83:	55                   	push   %rbp
  802e84:	48 89 e5             	mov    %rsp,%rbp
  802e87:	48 83 ec 28          	sub    $0x28,%rsp
  802e8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802e9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802ea7:	eb 36                	jmp    802edf <memcmp+0x5c>
		if (*s1 != *s2)
  802ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ead:	0f b6 10             	movzbl (%rax),%edx
  802eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb4:	0f b6 00             	movzbl (%rax),%eax
  802eb7:	38 c2                	cmp    %al,%dl
  802eb9:	74 1a                	je     802ed5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802ebb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebf:	0f b6 00             	movzbl (%rax),%eax
  802ec2:	0f b6 d0             	movzbl %al,%edx
  802ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec9:	0f b6 00             	movzbl (%rax),%eax
  802ecc:	0f b6 c0             	movzbl %al,%eax
  802ecf:	29 c2                	sub    %eax,%edx
  802ed1:	89 d0                	mov    %edx,%eax
  802ed3:	eb 20                	jmp    802ef5 <memcmp+0x72>
		s1++, s2++;
  802ed5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802eda:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ee7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802eeb:	48 85 c0             	test   %rax,%rax
  802eee:	75 b9                	jne    802ea9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef5:	c9                   	leaveq 
  802ef6:	c3                   	retq   

0000000000802ef7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802ef7:	55                   	push   %rbp
  802ef8:	48 89 e5             	mov    %rsp,%rbp
  802efb:	48 83 ec 28          	sub    $0x28,%rsp
  802eff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f03:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802f06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802f0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f12:	48 01 d0             	add    %rdx,%rax
  802f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802f19:	eb 15                	jmp    802f30 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1f:	0f b6 10             	movzbl (%rax),%edx
  802f22:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f25:	38 c2                	cmp    %al,%dl
  802f27:	75 02                	jne    802f2b <memfind+0x34>
			break;
  802f29:	eb 0f                	jmp    802f3a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802f2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f34:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802f38:	72 e1                	jb     802f1b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f3e:	c9                   	leaveq 
  802f3f:	c3                   	retq   

0000000000802f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802f40:	55                   	push   %rbp
  802f41:	48 89 e5             	mov    %rsp,%rbp
  802f44:	48 83 ec 34          	sub    $0x34,%rsp
  802f48:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f50:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802f53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802f5a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  802f61:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802f62:	eb 05                	jmp    802f69 <strtol+0x29>
		s++;
  802f64:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802f69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6d:	0f b6 00             	movzbl (%rax),%eax
  802f70:	3c 20                	cmp    $0x20,%al
  802f72:	74 f0                	je     802f64 <strtol+0x24>
  802f74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f78:	0f b6 00             	movzbl (%rax),%eax
  802f7b:	3c 09                	cmp    $0x9,%al
  802f7d:	74 e5                	je     802f64 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  802f7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f83:	0f b6 00             	movzbl (%rax),%eax
  802f86:	3c 2b                	cmp    $0x2b,%al
  802f88:	75 07                	jne    802f91 <strtol+0x51>
		s++;
  802f8a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802f8f:	eb 17                	jmp    802fa8 <strtol+0x68>
	else if (*s == '-')
  802f91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f95:	0f b6 00             	movzbl (%rax),%eax
  802f98:	3c 2d                	cmp    $0x2d,%al
  802f9a:	75 0c                	jne    802fa8 <strtol+0x68>
		s++, neg = 1;
  802f9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802fa1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802fa8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fac:	74 06                	je     802fb4 <strtol+0x74>
  802fae:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802fb2:	75 28                	jne    802fdc <strtol+0x9c>
  802fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb8:	0f b6 00             	movzbl (%rax),%eax
  802fbb:	3c 30                	cmp    $0x30,%al
  802fbd:	75 1d                	jne    802fdc <strtol+0x9c>
  802fbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc3:	48 83 c0 01          	add    $0x1,%rax
  802fc7:	0f b6 00             	movzbl (%rax),%eax
  802fca:	3c 78                	cmp    $0x78,%al
  802fcc:	75 0e                	jne    802fdc <strtol+0x9c>
		s += 2, base = 16;
  802fce:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802fd3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802fda:	eb 2c                	jmp    803008 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802fdc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fe0:	75 19                	jne    802ffb <strtol+0xbb>
  802fe2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe6:	0f b6 00             	movzbl (%rax),%eax
  802fe9:	3c 30                	cmp    $0x30,%al
  802feb:	75 0e                	jne    802ffb <strtol+0xbb>
		s++, base = 8;
  802fed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802ff2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802ff9:	eb 0d                	jmp    803008 <strtol+0xc8>
	else if (base == 0)
  802ffb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802fff:	75 07                	jne    803008 <strtol+0xc8>
		base = 10;
  803001:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803008:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80300c:	0f b6 00             	movzbl (%rax),%eax
  80300f:	3c 2f                	cmp    $0x2f,%al
  803011:	7e 1d                	jle    803030 <strtol+0xf0>
  803013:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803017:	0f b6 00             	movzbl (%rax),%eax
  80301a:	3c 39                	cmp    $0x39,%al
  80301c:	7f 12                	jg     803030 <strtol+0xf0>
			dig = *s - '0';
  80301e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803022:	0f b6 00             	movzbl (%rax),%eax
  803025:	0f be c0             	movsbl %al,%eax
  803028:	83 e8 30             	sub    $0x30,%eax
  80302b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80302e:	eb 4e                	jmp    80307e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803034:	0f b6 00             	movzbl (%rax),%eax
  803037:	3c 60                	cmp    $0x60,%al
  803039:	7e 1d                	jle    803058 <strtol+0x118>
  80303b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80303f:	0f b6 00             	movzbl (%rax),%eax
  803042:	3c 7a                	cmp    $0x7a,%al
  803044:	7f 12                	jg     803058 <strtol+0x118>
			dig = *s - 'a' + 10;
  803046:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304a:	0f b6 00             	movzbl (%rax),%eax
  80304d:	0f be c0             	movsbl %al,%eax
  803050:	83 e8 57             	sub    $0x57,%eax
  803053:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803056:	eb 26                	jmp    80307e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305c:	0f b6 00             	movzbl (%rax),%eax
  80305f:	3c 40                	cmp    $0x40,%al
  803061:	7e 48                	jle    8030ab <strtol+0x16b>
  803063:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803067:	0f b6 00             	movzbl (%rax),%eax
  80306a:	3c 5a                	cmp    $0x5a,%al
  80306c:	7f 3d                	jg     8030ab <strtol+0x16b>
			dig = *s - 'A' + 10;
  80306e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803072:	0f b6 00             	movzbl (%rax),%eax
  803075:	0f be c0             	movsbl %al,%eax
  803078:	83 e8 37             	sub    $0x37,%eax
  80307b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80307e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803081:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803084:	7c 02                	jl     803088 <strtol+0x148>
			break;
  803086:	eb 23                	jmp    8030ab <strtol+0x16b>
		s++, val = (val * base) + dig;
  803088:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80308d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803090:	48 98                	cltq   
  803092:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803097:	48 89 c2             	mov    %rax,%rdx
  80309a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309d:	48 98                	cltq   
  80309f:	48 01 d0             	add    %rdx,%rax
  8030a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8030a6:	e9 5d ff ff ff       	jmpq   803008 <strtol+0xc8>

	if (endptr)
  8030ab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8030b0:	74 0b                	je     8030bd <strtol+0x17d>
		*endptr = (char *) s;
  8030b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8030bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c1:	74 09                	je     8030cc <strtol+0x18c>
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	48 f7 d8             	neg    %rax
  8030ca:	eb 04                	jmp    8030d0 <strtol+0x190>
  8030cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8030d0:	c9                   	leaveq 
  8030d1:	c3                   	retq   

00000000008030d2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8030d2:	55                   	push   %rbp
  8030d3:	48 89 e5             	mov    %rsp,%rbp
  8030d6:	48 83 ec 30          	sub    $0x30,%rsp
  8030da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8030e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8030ea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8030ee:	0f b6 00             	movzbl (%rax),%eax
  8030f1:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8030f4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8030f8:	75 06                	jne    803100 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8030fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fe:	eb 6b                	jmp    80316b <strstr+0x99>

    len = strlen(str);
  803100:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803104:	48 89 c7             	mov    %rax,%rdi
  803107:	48 b8 a8 29 80 00 00 	movabs $0x8029a8,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	48 98                	cltq   
  803115:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  803119:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803121:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803125:	0f b6 00             	movzbl (%rax),%eax
  803128:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80312b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80312f:	75 07                	jne    803138 <strstr+0x66>
                return (char *) 0;
  803131:	b8 00 00 00 00       	mov    $0x0,%eax
  803136:	eb 33                	jmp    80316b <strstr+0x99>
        } while (sc != c);
  803138:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80313c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80313f:	75 d8                	jne    803119 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  803141:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803145:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803149:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314d:	48 89 ce             	mov    %rcx,%rsi
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 c9 2b 80 00 00 	movabs $0x802bc9,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	85 c0                	test   %eax,%eax
  803161:	75 b6                	jne    803119 <strstr+0x47>

    return (char *) (in - 1);
  803163:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803167:	48 83 e8 01          	sub    $0x1,%rax
}
  80316b:	c9                   	leaveq 
  80316c:	c3                   	retq   

000000000080316d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80316d:	55                   	push   %rbp
  80316e:	48 89 e5             	mov    %rsp,%rbp
  803171:	48 83 ec 30          	sub    $0x30,%rsp
  803175:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803179:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80317d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803181:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803188:	00 00 00 
  80318b:	48 8b 00             	mov    (%rax),%rax
  80318e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	75 3c                	jne    8031d4 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803198:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
  8031a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8031a9:	48 63 d0             	movslq %eax,%rdx
  8031ac:	48 89 d0             	mov    %rdx,%rax
  8031af:	48 c1 e0 03          	shl    $0x3,%rax
  8031b3:	48 01 d0             	add    %rdx,%rax
  8031b6:	48 c1 e0 05          	shl    $0x5,%rax
  8031ba:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8031c1:	00 00 00 
  8031c4:	48 01 c2             	add    %rax,%rdx
  8031c7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031ce:	00 00 00 
  8031d1:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8031d4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031d9:	75 0e                	jne    8031e9 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8031db:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8031e2:	00 00 00 
  8031e5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8031e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ed:	48 89 c7             	mov    %rax,%rdi
  8031f0:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8031ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803203:	79 19                	jns    80321e <ipc_recv+0xb1>
		*from_env_store = 0;
  803205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803209:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80320f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803213:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321c:	eb 53                	jmp    803271 <ipc_recv+0x104>
	}
	if(from_env_store)
  80321e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803223:	74 19                	je     80323e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803225:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80322c:	00 00 00 
  80322f:	48 8b 00             	mov    (%rax),%rax
  803232:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80323e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803243:	74 19                	je     80325e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803245:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80324c:	00 00 00 
  80324f:	48 8b 00             	mov    (%rax),%rax
  803252:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80325e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803265:	00 00 00 
  803268:	48 8b 00             	mov    (%rax),%rax
  80326b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 30          	sub    $0x30,%rsp
  80327b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80327e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803281:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803285:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803288:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80328d:	75 0e                	jne    80329d <ipc_send+0x2a>
		pg = (void*)UTOP;
  80328f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803296:	00 00 00 
  803299:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80329d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8032a0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8032a3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032aa:	89 c7                	mov    %eax,%edi
  8032ac:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
  8032b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8032bb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032bf:	75 0c                	jne    8032cd <ipc_send+0x5a>
			sys_yield();
  8032c1:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  8032c8:	00 00 00 
  8032cb:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8032cd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032d1:	74 ca                	je     80329d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8032d3:	c9                   	leaveq 
  8032d4:	c3                   	retq   

00000000008032d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8032d5:	55                   	push   %rbp
  8032d6:	48 89 e5             	mov    %rsp,%rbp
  8032d9:	48 83 ec 14          	sub    $0x14,%rsp
  8032dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8032e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032e7:	eb 5e                	jmp    803347 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8032e9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032f0:	00 00 00 
  8032f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f6:	48 63 d0             	movslq %eax,%rdx
  8032f9:	48 89 d0             	mov    %rdx,%rax
  8032fc:	48 c1 e0 03          	shl    $0x3,%rax
  803300:	48 01 d0             	add    %rdx,%rax
  803303:	48 c1 e0 05          	shl    $0x5,%rax
  803307:	48 01 c8             	add    %rcx,%rax
  80330a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803310:	8b 00                	mov    (%rax),%eax
  803312:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803315:	75 2c                	jne    803343 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803317:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80331e:	00 00 00 
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	48 63 d0             	movslq %eax,%rdx
  803327:	48 89 d0             	mov    %rdx,%rax
  80332a:	48 c1 e0 03          	shl    $0x3,%rax
  80332e:	48 01 d0             	add    %rdx,%rax
  803331:	48 c1 e0 05          	shl    $0x5,%rax
  803335:	48 01 c8             	add    %rcx,%rax
  803338:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80333e:	8b 40 08             	mov    0x8(%rax),%eax
  803341:	eb 12                	jmp    803355 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803343:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803347:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80334e:	7e 99                	jle    8032e9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803355:	c9                   	leaveq 
  803356:	c3                   	retq   

0000000000803357 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 18          	sub    $0x18,%rsp
  80335f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803367:	48 c1 e8 15          	shr    $0x15,%rax
  80336b:	48 89 c2             	mov    %rax,%rdx
  80336e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803375:	01 00 00 
  803378:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80337c:	83 e0 01             	and    $0x1,%eax
  80337f:	48 85 c0             	test   %rax,%rax
  803382:	75 07                	jne    80338b <pageref+0x34>
		return 0;
  803384:	b8 00 00 00 00       	mov    $0x0,%eax
  803389:	eb 53                	jmp    8033de <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80338b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338f:	48 c1 e8 0c          	shr    $0xc,%rax
  803393:	48 89 c2             	mov    %rax,%rdx
  803396:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80339d:	01 00 00 
  8033a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8033a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ac:	83 e0 01             	and    $0x1,%eax
  8033af:	48 85 c0             	test   %rax,%rax
  8033b2:	75 07                	jne    8033bb <pageref+0x64>
		return 0;
  8033b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b9:	eb 23                	jmp    8033de <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8033bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8033c3:	48 89 c2             	mov    %rax,%rdx
  8033c6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8033cd:	00 00 00 
  8033d0:	48 c1 e2 04          	shl    $0x4,%rdx
  8033d4:	48 01 d0             	add    %rdx,%rax
  8033d7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8033db:	0f b7 c0             	movzwl %ax,%eax
}
  8033de:	c9                   	leaveq 
  8033df:	c3                   	retq   
