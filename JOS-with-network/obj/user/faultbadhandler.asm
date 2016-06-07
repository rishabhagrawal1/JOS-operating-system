
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
  8000ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8000e8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  80011f:	48 b8 8c 09 80 00 00 	movabs $0x80098c,%rax
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
  800196:	48 ba aa 3e 80 00 00 	movabs $0x803eaa,%rdx
  80019d:	00 00 00 
  8001a0:	be 23 00 00 00       	mov    $0x23,%esi
  8001a5:	48 bf c7 3e 80 00 00 	movabs $0x803ec7,%rdi
  8001ac:	00 00 00 
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b4:	49 b9 d7 26 80 00 00 	movabs $0x8026d7,%r9
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

0000000000800581 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800581:	55                   	push   %rbp
  800582:	48 89 e5             	mov    %rsp,%rbp
  800585:	48 83 ec 20          	sub    $0x20,%rsp
  800589:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80058d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800599:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005a0:	00 
  8005a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005a7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b2:	89 c6                	mov    %eax,%esi
  8005b4:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005b9:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8005c0:	00 00 00 
  8005c3:	ff d0                	callq  *%rax
}
  8005c5:	c9                   	leaveq 
  8005c6:	c3                   	retq   

00000000008005c7 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  8005c7:	55                   	push   %rbp
  8005c8:	48 89 e5             	mov    %rsp,%rbp
  8005cb:	48 83 ec 20          	sub    $0x20,%rsp
  8005cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  8005d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8005e6:	00 
  8005e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f8:	89 c6                	mov    %eax,%esi
  8005fa:	bf 10 00 00 00       	mov    $0x10,%edi
  8005ff:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800606:	00 00 00 
  800609:	ff d0                	callq  *%rax
}
  80060b:	c9                   	leaveq 
  80060c:	c3                   	retq   

000000000080060d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800615:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80061c:	00 
  80061d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800623:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800629:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062e:	ba 00 00 00 00       	mov    $0x0,%edx
  800633:	be 00 00 00 00       	mov    $0x0,%esi
  800638:	bf 0e 00 00 00       	mov    $0xe,%edi
  80063d:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  800644:	00 00 00 
  800647:	ff d0                	callq  *%rax
}
  800649:	c9                   	leaveq 
  80064a:	c3                   	retq   

000000000080064b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80064b:	55                   	push   %rbp
  80064c:	48 89 e5             	mov    %rsp,%rbp
  80064f:	48 83 ec 08          	sub    $0x8,%rsp
  800653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800657:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80065b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800662:	ff ff ff 
  800665:	48 01 d0             	add    %rdx,%rax
  800668:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80066c:	c9                   	leaveq 
  80066d:	c3                   	retq   

000000000080066e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80066e:	55                   	push   %rbp
  80066f:	48 89 e5             	mov    %rsp,%rbp
  800672:	48 83 ec 08          	sub    $0x8,%rsp
  800676:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80067a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80067e:	48 89 c7             	mov    %rax,%rdi
  800681:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  800688:	00 00 00 
  80068b:	ff d0                	callq  *%rax
  80068d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800693:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800697:	c9                   	leaveq 
  800698:	c3                   	retq   

0000000000800699 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800699:	55                   	push   %rbp
  80069a:	48 89 e5             	mov    %rsp,%rbp
  80069d:	48 83 ec 18          	sub    $0x18,%rsp
  8006a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8006ac:	eb 6b                	jmp    800719 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8006ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8006b1:	48 98                	cltq   
  8006b3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8006b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8006bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8006c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006c5:	48 c1 e8 15          	shr    $0x15,%rax
  8006c9:	48 89 c2             	mov    %rax,%rdx
  8006cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006d3:	01 00 00 
  8006d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006da:	83 e0 01             	and    $0x1,%eax
  8006dd:	48 85 c0             	test   %rax,%rax
  8006e0:	74 21                	je     800703 <fd_alloc+0x6a>
  8006e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8006ea:	48 89 c2             	mov    %rax,%rdx
  8006ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006f4:	01 00 00 
  8006f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006fb:	83 e0 01             	and    $0x1,%eax
  8006fe:	48 85 c0             	test   %rax,%rax
  800701:	75 12                	jne    800715 <fd_alloc+0x7c>
			*fd_store = fd;
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80070b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80070e:	b8 00 00 00 00       	mov    $0x0,%eax
  800713:	eb 1a                	jmp    80072f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800715:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800719:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80071d:	7e 8f                	jle    8006ae <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80072a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80072f:	c9                   	leaveq 
  800730:	c3                   	retq   

0000000000800731 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800731:	55                   	push   %rbp
  800732:	48 89 e5             	mov    %rsp,%rbp
  800735:	48 83 ec 20          	sub    $0x20,%rsp
  800739:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80073c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800740:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800744:	78 06                	js     80074c <fd_lookup+0x1b>
  800746:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80074a:	7e 07                	jle    800753 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800751:	eb 6c                	jmp    8007bf <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800753:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800756:	48 98                	cltq   
  800758:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80075e:	48 c1 e0 0c          	shl    $0xc,%rax
  800762:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80076a:	48 c1 e8 15          	shr    $0x15,%rax
  80076e:	48 89 c2             	mov    %rax,%rdx
  800771:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800778:	01 00 00 
  80077b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80077f:	83 e0 01             	and    $0x1,%eax
  800782:	48 85 c0             	test   %rax,%rax
  800785:	74 21                	je     8007a8 <fd_lookup+0x77>
  800787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80078b:	48 c1 e8 0c          	shr    $0xc,%rax
  80078f:	48 89 c2             	mov    %rax,%rdx
  800792:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800799:	01 00 00 
  80079c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007a0:	83 e0 01             	and    $0x1,%eax
  8007a3:	48 85 c0             	test   %rax,%rax
  8007a6:	75 07                	jne    8007af <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb 10                	jmp    8007bf <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8007af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007b7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8007ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007bf:	c9                   	leaveq 
  8007c0:	c3                   	retq   

00000000008007c1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8007c1:	55                   	push   %rbp
  8007c2:	48 89 e5             	mov    %rsp,%rbp
  8007c5:	48 83 ec 30          	sub    $0x30,%rsp
  8007c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8007d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d6:	48 89 c7             	mov    %rax,%rdi
  8007d9:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  8007e0:	00 00 00 
  8007e3:	ff d0                	callq  *%rax
  8007e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8007e9:	48 89 d6             	mov    %rdx,%rsi
  8007ec:	89 c7                	mov    %eax,%edi
  8007ee:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
  8007fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800801:	78 0a                	js     80080d <fd_close+0x4c>
	    || fd != fd2)
  800803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800807:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80080b:	74 12                	je     80081f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80080d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800811:	74 05                	je     800818 <fd_close+0x57>
  800813:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800816:	eb 05                	jmp    80081d <fd_close+0x5c>
  800818:	b8 00 00 00 00       	mov    $0x0,%eax
  80081d:	eb 69                	jmp    800888 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80081f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800829:	48 89 d6             	mov    %rdx,%rsi
  80082c:	89 c7                	mov    %eax,%edi
  80082e:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
  80083a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800841:	78 2a                	js     80086d <fd_close+0xac>
		if (dev->dev_close)
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 40 20          	mov    0x20(%rax),%rax
  80084b:	48 85 c0             	test   %rax,%rax
  80084e:	74 16                	je     800866 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 40 20          	mov    0x20(%rax),%rax
  800858:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80085c:	48 89 d7             	mov    %rdx,%rdi
  80085f:	ff d0                	callq  *%rax
  800861:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800864:	eb 07                	jmp    80086d <fd_close+0xac>
		else
			r = 0;
  800866:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80086d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800871:	48 89 c6             	mov    %rax,%rsi
  800874:	bf 00 00 00 00       	mov    $0x0,%edi
  800879:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800880:	00 00 00 
  800883:	ff d0                	callq  *%rax
	return r;
  800885:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800888:	c9                   	leaveq 
  800889:	c3                   	retq   

000000000080088a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80088a:	55                   	push   %rbp
  80088b:	48 89 e5             	mov    %rsp,%rbp
  80088e:	48 83 ec 20          	sub    $0x20,%rsp
  800892:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800895:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008a0:	eb 41                	jmp    8008e3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8008a2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008a9:	00 00 00 
  8008ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008af:	48 63 d2             	movslq %edx,%rdx
  8008b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8008bb:	75 22                	jne    8008df <dev_lookup+0x55>
			*dev = devtab[i];
  8008bd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008c4:	00 00 00 
  8008c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008ca:	48 63 d2             	movslq %edx,%rdx
  8008cd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8008d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008d5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dd:	eb 60                	jmp    80093f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8008df:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008e3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8008ea:	00 00 00 
  8008ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8008f0:	48 63 d2             	movslq %edx,%rdx
  8008f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008f7:	48 85 c0             	test   %rax,%rax
  8008fa:	75 a6                	jne    8008a2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008fc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800903:	00 00 00 
  800906:	48 8b 00             	mov    (%rax),%rax
  800909:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80090f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800912:	89 c6                	mov    %eax,%esi
  800914:	48 bf d8 3e 80 00 00 	movabs $0x803ed8,%rdi
  80091b:	00 00 00 
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
  800923:	48 b9 10 29 80 00 00 	movabs $0x802910,%rcx
  80092a:	00 00 00 
  80092d:	ff d1                	callq  *%rcx
	*dev = 0;
  80092f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800933:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80093a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80093f:	c9                   	leaveq 
  800940:	c3                   	retq   

0000000000800941 <close>:

int
close(int fdnum)
{
  800941:	55                   	push   %rbp
  800942:	48 89 e5             	mov    %rsp,%rbp
  800945:	48 83 ec 20          	sub    $0x20,%rsp
  800949:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80094c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800950:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800953:	48 89 d6             	mov    %rdx,%rsi
  800956:	89 c7                	mov    %eax,%edi
  800958:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  80095f:	00 00 00 
  800962:	ff d0                	callq  *%rax
  800964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80096b:	79 05                	jns    800972 <close+0x31>
		return r;
  80096d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800970:	eb 18                	jmp    80098a <close+0x49>
	else
		return fd_close(fd, 1);
  800972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800976:	be 01 00 00 00       	mov    $0x1,%esi
  80097b:	48 89 c7             	mov    %rax,%rdi
  80097e:	48 b8 c1 07 80 00 00 	movabs $0x8007c1,%rax
  800985:	00 00 00 
  800988:	ff d0                	callq  *%rax
}
  80098a:	c9                   	leaveq 
  80098b:	c3                   	retq   

000000000080098c <close_all>:

void
close_all(void)
{
  80098c:	55                   	push   %rbp
  80098d:	48 89 e5             	mov    %rsp,%rbp
  800990:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800994:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80099b:	eb 15                	jmp    8009b2 <close_all+0x26>
		close(i);
  80099d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a0:	89 c7                	mov    %eax,%edi
  8009a2:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  8009a9:	00 00 00 
  8009ac:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8009ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8009b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8009b6:	7e e5                	jle    80099d <close_all+0x11>
		close(i);
}
  8009b8:	c9                   	leaveq 
  8009b9:	c3                   	retq   

00000000008009ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8009ba:	55                   	push   %rbp
  8009bb:	48 89 e5             	mov    %rsp,%rbp
  8009be:	48 83 ec 40          	sub    $0x40,%rsp
  8009c2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8009c5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8009c8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8009cc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8009cf:	48 89 d6             	mov    %rdx,%rsi
  8009d2:	89 c7                	mov    %eax,%edi
  8009d4:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  8009db:	00 00 00 
  8009de:	ff d0                	callq  *%rax
  8009e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009e7:	79 08                	jns    8009f1 <dup+0x37>
		return r;
  8009e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009ec:	e9 70 01 00 00       	jmpq   800b61 <dup+0x1a7>
	close(newfdnum);
  8009f1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009f4:	89 c7                	mov    %eax,%edi
  8009f6:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  8009fd:	00 00 00 
  800a00:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800a02:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a05:	48 98                	cltq   
  800a07:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800a0d:	48 c1 e0 0c          	shl    $0xc,%rax
  800a11:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a19:	48 89 c7             	mov    %rax,%rdi
  800a1c:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  800a23:	00 00 00 
  800a26:	ff d0                	callq  *%rax
  800a28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a30:	48 89 c7             	mov    %rax,%rdi
  800a33:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  800a3a:	00 00 00 
  800a3d:	ff d0                	callq  *%rax
  800a3f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a47:	48 c1 e8 15          	shr    $0x15,%rax
  800a4b:	48 89 c2             	mov    %rax,%rdx
  800a4e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a55:	01 00 00 
  800a58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a5c:	83 e0 01             	and    $0x1,%eax
  800a5f:	48 85 c0             	test   %rax,%rax
  800a62:	74 73                	je     800ad7 <dup+0x11d>
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	48 c1 e8 0c          	shr    $0xc,%rax
  800a6c:	48 89 c2             	mov    %rax,%rdx
  800a6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a76:	01 00 00 
  800a79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a7d:	83 e0 01             	and    $0x1,%eax
  800a80:	48 85 c0             	test   %rax,%rax
  800a83:	74 52                	je     800ad7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 c1 e8 0c          	shr    $0xc,%rax
  800a8d:	48 89 c2             	mov    %rax,%rdx
  800a90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a97:	01 00 00 
  800a9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9e:	25 07 0e 00 00       	and    $0xe07,%eax
  800aa3:	89 c1                	mov    %eax,%ecx
  800aa5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	41 89 c8             	mov    %ecx,%r8d
  800ab0:	48 89 d1             	mov    %rdx,%rcx
  800ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab8:	48 89 c6             	mov    %rax,%rsi
  800abb:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac0:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
  800acc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800acf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad3:	79 02                	jns    800ad7 <dup+0x11d>
			goto err;
  800ad5:	eb 57                	jmp    800b2e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ad7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800adb:	48 c1 e8 0c          	shr    $0xc,%rax
  800adf:	48 89 c2             	mov    %rax,%rdx
  800ae2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800ae9:	01 00 00 
  800aec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800af0:	25 07 0e 00 00       	and    $0xe07,%eax
  800af5:	89 c1                	mov    %eax,%ecx
  800af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800afb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aff:	41 89 c8             	mov    %ecx,%r8d
  800b02:	48 89 d1             	mov    %rdx,%rcx
  800b05:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0a:	48 89 c6             	mov    %rax,%rsi
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b12:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  800b19:	00 00 00 
  800b1c:	ff d0                	callq  *%rax
  800b1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b25:	79 02                	jns    800b29 <dup+0x16f>
		goto err;
  800b27:	eb 05                	jmp    800b2e <dup+0x174>

	return newfdnum;
  800b29:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b2c:	eb 33                	jmp    800b61 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800b2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b32:	48 89 c6             	mov    %rax,%rsi
  800b35:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3a:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800b41:	00 00 00 
  800b44:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800b46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b4a:	48 89 c6             	mov    %rax,%rsi
  800b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b52:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	callq  *%rax
	return r;
  800b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b61:	c9                   	leaveq 
  800b62:	c3                   	retq   

0000000000800b63 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b63:	55                   	push   %rbp
  800b64:	48 89 e5             	mov    %rsp,%rbp
  800b67:	48 83 ec 40          	sub    $0x40,%rsp
  800b6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b72:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b7d:	48 89 d6             	mov    %rdx,%rsi
  800b80:	89 c7                	mov    %eax,%edi
  800b82:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  800b89:	00 00 00 
  800b8c:	ff d0                	callq  *%rax
  800b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b95:	78 24                	js     800bbb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9b:	8b 00                	mov    (%rax),%eax
  800b9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ba1:	48 89 d6             	mov    %rdx,%rsi
  800ba4:	89 c7                	mov    %eax,%edi
  800ba6:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800bad:	00 00 00 
  800bb0:	ff d0                	callq  *%rax
  800bb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800bb9:	79 05                	jns    800bc0 <read+0x5d>
		return r;
  800bbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbe:	eb 76                	jmp    800c36 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc4:	8b 40 08             	mov    0x8(%rax),%eax
  800bc7:	83 e0 03             	and    $0x3,%eax
  800bca:	83 f8 01             	cmp    $0x1,%eax
  800bcd:	75 3a                	jne    800c09 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800bcf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800bd6:	00 00 00 
  800bd9:	48 8b 00             	mov    (%rax),%rax
  800bdc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800be2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800be5:	89 c6                	mov    %eax,%esi
  800be7:	48 bf f7 3e 80 00 00 	movabs $0x803ef7,%rdi
  800bee:	00 00 00 
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	48 b9 10 29 80 00 00 	movabs $0x802910,%rcx
  800bfd:	00 00 00 
  800c00:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c07:	eb 2d                	jmp    800c36 <read+0xd3>
	}
	if (!dev->dev_read)
  800c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c11:	48 85 c0             	test   %rax,%rax
  800c14:	75 07                	jne    800c1d <read+0xba>
		return -E_NOT_SUPP;
  800c16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c1b:	eb 19                	jmp    800c36 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c21:	48 8b 40 10          	mov    0x10(%rax),%rax
  800c25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c2d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c31:	48 89 cf             	mov    %rcx,%rdi
  800c34:	ff d0                	callq  *%rax
}
  800c36:	c9                   	leaveq 
  800c37:	c3                   	retq   

0000000000800c38 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c38:	55                   	push   %rbp
  800c39:	48 89 e5             	mov    %rsp,%rbp
  800c3c:	48 83 ec 30          	sub    $0x30,%rsp
  800c40:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800c43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c47:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c52:	eb 49                	jmp    800c9d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c57:	48 98                	cltq   
  800c59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c5d:	48 29 c2             	sub    %rax,%rdx
  800c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c63:	48 63 c8             	movslq %eax,%rcx
  800c66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c6a:	48 01 c1             	add    %rax,%rcx
  800c6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c70:	48 89 ce             	mov    %rcx,%rsi
  800c73:	89 c7                	mov    %eax,%edi
  800c75:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  800c7c:	00 00 00 
  800c7f:	ff d0                	callq  *%rax
  800c81:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c84:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c88:	79 05                	jns    800c8f <readn+0x57>
			return m;
  800c8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c8d:	eb 1c                	jmp    800cab <readn+0x73>
		if (m == 0)
  800c8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c93:	75 02                	jne    800c97 <readn+0x5f>
			break;
  800c95:	eb 11                	jmp    800ca8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c9a:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ca0:	48 98                	cltq   
  800ca2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ca6:	72 ac                	jb     800c54 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800cab:	c9                   	leaveq 
  800cac:	c3                   	retq   

0000000000800cad <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cad:	55                   	push   %rbp
  800cae:	48 89 e5             	mov    %rsp,%rbp
  800cb1:	48 83 ec 40          	sub    $0x40,%rsp
  800cb5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cb8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800cbc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cc0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cc4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cc7:	48 89 d6             	mov    %rdx,%rsi
  800cca:	89 c7                	mov    %eax,%edi
  800ccc:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  800cd3:	00 00 00 
  800cd6:	ff d0                	callq  *%rax
  800cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cdf:	78 24                	js     800d05 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce5:	8b 00                	mov    (%rax),%eax
  800ce7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ceb:	48 89 d6             	mov    %rdx,%rsi
  800cee:	89 c7                	mov    %eax,%edi
  800cf0:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d03:	79 05                	jns    800d0a <write+0x5d>
		return r;
  800d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d08:	eb 75                	jmp    800d7f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d0e:	8b 40 08             	mov    0x8(%rax),%eax
  800d11:	83 e0 03             	and    $0x3,%eax
  800d14:	85 c0                	test   %eax,%eax
  800d16:	75 3a                	jne    800d52 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d18:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d1f:	00 00 00 
  800d22:	48 8b 00             	mov    (%rax),%rax
  800d25:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d2b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d2e:	89 c6                	mov    %eax,%esi
  800d30:	48 bf 13 3f 80 00 00 	movabs $0x803f13,%rdi
  800d37:	00 00 00 
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	48 b9 10 29 80 00 00 	movabs $0x802910,%rcx
  800d46:	00 00 00 
  800d49:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800d4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d50:	eb 2d                	jmp    800d7f <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  800d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d56:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d5a:	48 85 c0             	test   %rax,%rax
  800d5d:	75 07                	jne    800d66 <write+0xb9>
		return -E_NOT_SUPP;
  800d5f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d64:	eb 19                	jmp    800d7f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6a:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d6e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d72:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d76:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d7a:	48 89 cf             	mov    %rcx,%rdi
  800d7d:	ff d0                	callq  *%rax
}
  800d7f:	c9                   	leaveq 
  800d80:	c3                   	retq   

0000000000800d81 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d81:	55                   	push   %rbp
  800d82:	48 89 e5             	mov    %rsp,%rbp
  800d85:	48 83 ec 18          	sub    $0x18,%rsp
  800d89:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d8c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d96:	48 89 d6             	mov    %rdx,%rsi
  800d99:	89 c7                	mov    %eax,%edi
  800d9b:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  800da2:	00 00 00 
  800da5:	ff d0                	callq  *%rax
  800da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dae:	79 05                	jns    800db5 <seek+0x34>
		return r;
  800db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800db3:	eb 0f                	jmp    800dc4 <seek+0x43>
	fd->fd_offset = offset;
  800db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800dbc:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leaveq 
  800dc5:	c3                   	retq   

0000000000800dc6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	48 83 ec 30          	sub    $0x30,%rsp
  800dce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dd4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dd8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ddb:	48 89 d6             	mov    %rdx,%rsi
  800dde:	89 c7                	mov    %eax,%edi
  800de0:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  800de7:	00 00 00 
  800dea:	ff d0                	callq  *%rax
  800dec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800def:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800df3:	78 24                	js     800e19 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df9:	8b 00                	mov    (%rax),%eax
  800dfb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dff:	48 89 d6             	mov    %rdx,%rsi
  800e02:	89 c7                	mov    %eax,%edi
  800e04:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	callq  *%rax
  800e10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e17:	79 05                	jns    800e1e <ftruncate+0x58>
		return r;
  800e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e1c:	eb 72                	jmp    800e90 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e22:	8b 40 08             	mov    0x8(%rax),%eax
  800e25:	83 e0 03             	and    $0x3,%eax
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	75 3a                	jne    800e66 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e2c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800e33:	00 00 00 
  800e36:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e39:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800e3f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e42:	89 c6                	mov    %eax,%esi
  800e44:	48 bf 30 3f 80 00 00 	movabs $0x803f30,%rdi
  800e4b:	00 00 00 
  800e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e53:	48 b9 10 29 80 00 00 	movabs $0x802910,%rcx
  800e5a:	00 00 00 
  800e5d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e64:	eb 2a                	jmp    800e90 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6a:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e6e:	48 85 c0             	test   %rax,%rax
  800e71:	75 07                	jne    800e7a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e73:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e78:	eb 16                	jmp    800e90 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7e:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e86:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e89:	89 ce                	mov    %ecx,%esi
  800e8b:	48 89 d7             	mov    %rdx,%rdi
  800e8e:	ff d0                	callq  *%rax
}
  800e90:	c9                   	leaveq 
  800e91:	c3                   	retq   

0000000000800e92 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e92:	55                   	push   %rbp
  800e93:	48 89 e5             	mov    %rsp,%rbp
  800e96:	48 83 ec 30          	sub    $0x30,%rsp
  800e9a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ea1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ea5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ea8:	48 89 d6             	mov    %rdx,%rsi
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
  800eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ec0:	78 24                	js     800ee6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ec2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec6:	8b 00                	mov    (%rax),%eax
  800ec8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ecc:	48 89 d6             	mov    %rdx,%rsi
  800ecf:	89 c7                	mov    %eax,%edi
  800ed1:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800ed8:	00 00 00 
  800edb:	ff d0                	callq  *%rax
  800edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ee4:	79 05                	jns    800eeb <fstat+0x59>
		return r;
  800ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ee9:	eb 5e                	jmp    800f49 <fstat+0xb7>
	if (!dev->dev_stat)
  800eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eef:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ef3:	48 85 c0             	test   %rax,%rax
  800ef6:	75 07                	jne    800eff <fstat+0x6d>
		return -E_NOT_SUPP;
  800ef8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800efd:	eb 4a                	jmp    800f49 <fstat+0xb7>
	stat->st_name[0] = 0;
  800eff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f03:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800f06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f0a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800f11:	00 00 00 
	stat->st_isdir = 0;
  800f14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f18:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800f1f:	00 00 00 
	stat->st_dev = dev;
  800f22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f2a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f35:	48 8b 40 28          	mov    0x28(%rax),%rax
  800f39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800f41:	48 89 ce             	mov    %rcx,%rsi
  800f44:	48 89 d7             	mov    %rdx,%rdi
  800f47:	ff d0                	callq  *%rax
}
  800f49:	c9                   	leaveq 
  800f4a:	c3                   	retq   

0000000000800f4b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800f4b:	55                   	push   %rbp
  800f4c:	48 89 e5             	mov    %rsp,%rbp
  800f4f:	48 83 ec 20          	sub    $0x20,%rsp
  800f53:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f57:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5f:	be 00 00 00 00       	mov    $0x0,%esi
  800f64:	48 89 c7             	mov    %rax,%rdi
  800f67:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	callq  *%rax
  800f73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f7a:	79 05                	jns    800f81 <stat+0x36>
		return fd;
  800f7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f7f:	eb 2f                	jmp    800fb0 <stat+0x65>
	r = fstat(fd, stat);
  800f81:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f88:	48 89 d6             	mov    %rdx,%rsi
  800f8b:	89 c7                	mov    %eax,%edi
  800f8d:	48 b8 92 0e 80 00 00 	movabs $0x800e92,%rax
  800f94:	00 00 00 
  800f97:	ff d0                	callq  *%rax
  800f99:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f9f:	89 c7                	mov    %eax,%edi
  800fa1:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  800fa8:	00 00 00 
  800fab:	ff d0                	callq  *%rax
	return r;
  800fad:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800fb0:	c9                   	leaveq 
  800fb1:	c3                   	retq   

0000000000800fb2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	48 83 ec 10          	sub    $0x10,%rsp
  800fba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800fc1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fc8:	00 00 00 
  800fcb:	8b 00                	mov    (%rax),%eax
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	75 1d                	jne    800fee <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800fd1:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd6:	48 b8 86 3d 80 00 00 	movabs $0x803d86,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	callq  *%rax
  800fe2:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fe9:	00 00 00 
  800fec:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800fee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800ff5:	00 00 00 
  800ff8:	8b 00                	mov    (%rax),%eax
  800ffa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800ffd:	b9 07 00 00 00       	mov    $0x7,%ecx
  801002:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801009:	00 00 00 
  80100c:	89 c7                	mov    %eax,%edi
  80100e:	48 b8 24 3d 80 00 00 	movabs $0x803d24,%rax
  801015:	00 00 00 
  801018:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80101a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101e:	ba 00 00 00 00       	mov    $0x0,%edx
  801023:	48 89 c6             	mov    %rax,%rsi
  801026:	bf 00 00 00 00       	mov    $0x0,%edi
  80102b:	48 b8 1e 3c 80 00 00 	movabs $0x803c1e,%rax
  801032:	00 00 00 
  801035:	ff d0                	callq  *%rax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	48 83 ec 30          	sub    $0x30,%rsp
  801041:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801045:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  801048:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80104f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  801056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80105d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801062:	75 08                	jne    80106c <open+0x33>
	{
		return r;
  801064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801067:	e9 f2 00 00 00       	jmpq   80115e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80106c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801070:	48 89 c7             	mov    %rax,%rdi
  801073:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  80107a:	00 00 00 
  80107d:	ff d0                	callq  *%rax
  80107f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801082:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801089:	7e 0a                	jle    801095 <open+0x5c>
	{
		return -E_BAD_PATH;
  80108b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801090:	e9 c9 00 00 00       	jmpq   80115e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  801095:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80109c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80109d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010a1:	48 89 c7             	mov    %rax,%rdi
  8010a4:	48 b8 99 06 80 00 00 	movabs $0x800699,%rax
  8010ab:	00 00 00 
  8010ae:	ff d0                	callq  *%rax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010b7:	78 09                	js     8010c2 <open+0x89>
  8010b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bd:	48 85 c0             	test   %rax,%rax
  8010c0:	75 08                	jne    8010ca <open+0x91>
		{
			return r;
  8010c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c5:	e9 94 00 00 00       	jmpq   80115e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8010ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010ce:	ba 00 04 00 00       	mov    $0x400,%edx
  8010d3:	48 89 c6             	mov    %rax,%rsi
  8010d6:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8010dd:	00 00 00 
  8010e0:	48 b8 57 35 80 00 00 	movabs $0x803557,%rax
  8010e7:	00 00 00 
  8010ea:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8010ec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010f3:	00 00 00 
  8010f6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8010f9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8010ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801103:	48 89 c6             	mov    %rax,%rsi
  801106:	bf 01 00 00 00       	mov    $0x1,%edi
  80110b:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  801112:	00 00 00 
  801115:	ff d0                	callq  *%rax
  801117:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80111a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80111e:	79 2b                	jns    80114b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	be 00 00 00 00       	mov    $0x0,%esi
  801129:	48 89 c7             	mov    %rax,%rdi
  80112c:	48 b8 c1 07 80 00 00 	movabs $0x8007c1,%rax
  801133:	00 00 00 
  801136:	ff d0                	callq  *%rax
  801138:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80113b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80113f:	79 05                	jns    801146 <open+0x10d>
			{
				return d;
  801141:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801144:	eb 18                	jmp    80115e <open+0x125>
			}
			return r;
  801146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801149:	eb 13                	jmp    80115e <open+0x125>
		}	
		return fd2num(fd_store);
  80114b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114f:	48 89 c7             	mov    %rax,%rdi
  801152:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  801159:	00 00 00 
  80115c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80115e:	c9                   	leaveq 
  80115f:	c3                   	retq   

0000000000801160 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801160:	55                   	push   %rbp
  801161:	48 89 e5             	mov    %rsp,%rbp
  801164:	48 83 ec 10          	sub    $0x10,%rsp
  801168:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80116c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801170:	8b 50 0c             	mov    0xc(%rax),%edx
  801173:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80117a:	00 00 00 
  80117d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80117f:	be 00 00 00 00       	mov    $0x0,%esi
  801184:	bf 06 00 00 00       	mov    $0x6,%edi
  801189:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  801190:	00 00 00 
  801193:	ff d0                	callq  *%rax
}
  801195:	c9                   	leaveq 
  801196:	c3                   	retq   

0000000000801197 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801197:	55                   	push   %rbp
  801198:	48 89 e5             	mov    %rsp,%rbp
  80119b:	48 83 ec 30          	sub    $0x30,%rsp
  80119f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8011b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011b7:	74 07                	je     8011c0 <devfile_read+0x29>
  8011b9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011be:	75 07                	jne    8011c7 <devfile_read+0x30>
		return -E_INVAL;
  8011c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c5:	eb 77                	jmp    80123e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8011ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011d5:	00 00 00 
  8011d8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8011da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8011e1:	00 00 00 
  8011e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011e8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8011ec:	be 00 00 00 00       	mov    $0x0,%esi
  8011f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8011f6:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  8011fd:	00 00 00 
  801200:	ff d0                	callq  *%rax
  801202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801209:	7f 05                	jg     801210 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80120b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120e:	eb 2e                	jmp    80123e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801210:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801213:	48 63 d0             	movslq %eax,%rdx
  801216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801221:	00 00 00 
  801224:	48 89 c7             	mov    %rax,%rdi
  801227:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  80122e:	00 00 00 
  801231:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801233:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801237:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80123b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80123e:	c9                   	leaveq 
  80123f:	c3                   	retq   

0000000000801240 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801240:	55                   	push   %rbp
  801241:	48 89 e5             	mov    %rsp,%rbp
  801244:	48 83 ec 30          	sub    $0x30,%rsp
  801248:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801250:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801254:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80125b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801260:	74 07                	je     801269 <devfile_write+0x29>
  801262:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801267:	75 08                	jne    801271 <devfile_write+0x31>
		return r;
  801269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126c:	e9 9a 00 00 00       	jmpq   80130b <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801275:	8b 50 0c             	mov    0xc(%rax),%edx
  801278:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80127f:	00 00 00 
  801282:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801284:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80128b:	00 
  80128c:	76 08                	jbe    801296 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80128e:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801295:	00 
	}
	fsipcbuf.write.req_n = n;
  801296:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80129d:	00 00 00 
  8012a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012a4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8012a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b0:	48 89 c6             	mov    %rax,%rsi
  8012b3:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8012ba:	00 00 00 
  8012bd:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  8012c4:	00 00 00 
  8012c7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8012c9:	be 00 00 00 00       	mov    $0x0,%esi
  8012ce:	bf 04 00 00 00       	mov    $0x4,%edi
  8012d3:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  8012da:	00 00 00 
  8012dd:	ff d0                	callq  *%rax
  8012df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e6:	7f 20                	jg     801308 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8012e8:	48 bf 56 3f 80 00 00 	movabs $0x803f56,%rdi
  8012ef:	00 00 00 
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f7:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  8012fe:	00 00 00 
  801301:	ff d2                	callq  *%rdx
		return r;
  801303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801306:	eb 03                	jmp    80130b <devfile_write+0xcb>
	}
	return r;
  801308:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80130b:	c9                   	leaveq 
  80130c:	c3                   	retq   

000000000080130d <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	48 83 ec 20          	sub    $0x20,%rsp
  801315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801319:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80131d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801321:	8b 50 0c             	mov    0xc(%rax),%edx
  801324:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80132b:	00 00 00 
  80132e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801330:	be 00 00 00 00       	mov    $0x0,%esi
  801335:	bf 05 00 00 00       	mov    $0x5,%edi
  80133a:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  801341:	00 00 00 
  801344:	ff d0                	callq  *%rax
  801346:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801349:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80134d:	79 05                	jns    801354 <devfile_stat+0x47>
		return r;
  80134f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801352:	eb 56                	jmp    8013aa <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801354:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801358:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80135f:	00 00 00 
  801362:	48 89 c7             	mov    %rax,%rdi
  801365:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  80136c:	00 00 00 
  80136f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801371:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801378:	00 00 00 
  80137b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801385:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80138b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801392:	00 00 00 
  801395:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80139b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80139f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013aa:	c9                   	leaveq 
  8013ab:	c3                   	retq   

00000000008013ac <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013ac:	55                   	push   %rbp
  8013ad:	48 89 e5             	mov    %rsp,%rbp
  8013b0:	48 83 ec 10          	sub    $0x10,%rsp
  8013b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8013c2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013c9:	00 00 00 
  8013cc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8013ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8013d5:	00 00 00 
  8013d8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013db:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013de:	be 00 00 00 00       	mov    $0x0,%esi
  8013e3:	bf 02 00 00 00       	mov    $0x2,%edi
  8013e8:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  8013ef:	00 00 00 
  8013f2:	ff d0                	callq  *%rax
}
  8013f4:	c9                   	leaveq 
  8013f5:	c3                   	retq   

00000000008013f6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8013f6:	55                   	push   %rbp
  8013f7:	48 89 e5             	mov    %rsp,%rbp
  8013fa:	48 83 ec 10          	sub    $0x10,%rsp
  8013fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	48 89 c7             	mov    %rax,%rdi
  801409:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  801410:	00 00 00 
  801413:	ff d0                	callq  *%rax
  801415:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80141a:	7e 07                	jle    801423 <remove+0x2d>
		return -E_BAD_PATH;
  80141c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801421:	eb 33                	jmp    801456 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	48 89 c6             	mov    %rax,%rsi
  80142a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801431:	00 00 00 
  801434:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  80143b:	00 00 00 
  80143e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801440:	be 00 00 00 00       	mov    $0x0,%esi
  801445:	bf 07 00 00 00       	mov    $0x7,%edi
  80144a:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  801451:	00 00 00 
  801454:	ff d0                	callq  *%rax
}
  801456:	c9                   	leaveq 
  801457:	c3                   	retq   

0000000000801458 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801458:	55                   	push   %rbp
  801459:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80145c:	be 00 00 00 00       	mov    $0x0,%esi
  801461:	bf 08 00 00 00       	mov    $0x8,%edi
  801466:	48 b8 b2 0f 80 00 00 	movabs $0x800fb2,%rax
  80146d:	00 00 00 
  801470:	ff d0                	callq  *%rax
}
  801472:	5d                   	pop    %rbp
  801473:	c3                   	retq   

0000000000801474 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801474:	55                   	push   %rbp
  801475:	48 89 e5             	mov    %rsp,%rbp
  801478:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80147f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801486:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80148d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801494:	be 00 00 00 00       	mov    $0x0,%esi
  801499:	48 89 c7             	mov    %rax,%rdi
  80149c:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  8014a3:	00 00 00 
  8014a6:	ff d0                	callq  *%rax
  8014a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014af:	79 28                	jns    8014d9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8014b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014b4:	89 c6                	mov    %eax,%esi
  8014b6:	48 bf 72 3f 80 00 00 	movabs $0x803f72,%rdi
  8014bd:	00 00 00 
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  8014cc:	00 00 00 
  8014cf:	ff d2                	callq  *%rdx
		return fd_src;
  8014d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014d4:	e9 74 01 00 00       	jmpq   80164d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8014d9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8014e0:	be 01 01 00 00       	mov    $0x101,%esi
  8014e5:	48 89 c7             	mov    %rax,%rdi
  8014e8:	48 b8 39 10 80 00 00 	movabs $0x801039,%rax
  8014ef:	00 00 00 
  8014f2:	ff d0                	callq  *%rax
  8014f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8014f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8014fb:	79 39                	jns    801536 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8014fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801500:	89 c6                	mov    %eax,%esi
  801502:	48 bf 88 3f 80 00 00 	movabs $0x803f88,%rdi
  801509:	00 00 00 
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  801518:	00 00 00 
  80151b:	ff d2                	callq  *%rdx
		close(fd_src);
  80151d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801520:	89 c7                	mov    %eax,%edi
  801522:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  801529:	00 00 00 
  80152c:	ff d0                	callq  *%rax
		return fd_dest;
  80152e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801531:	e9 17 01 00 00       	jmpq   80164d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801536:	eb 74                	jmp    8015ac <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801538:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153b:	48 63 d0             	movslq %eax,%rdx
  80153e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801545:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801548:	48 89 ce             	mov    %rcx,%rsi
  80154b:	89 c7                	mov    %eax,%edi
  80154d:	48 b8 ad 0c 80 00 00 	movabs $0x800cad,%rax
  801554:	00 00 00 
  801557:	ff d0                	callq  *%rax
  801559:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80155c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801560:	79 4a                	jns    8015ac <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801562:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801565:	89 c6                	mov    %eax,%esi
  801567:	48 bf a2 3f 80 00 00 	movabs $0x803fa2,%rdi
  80156e:	00 00 00 
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
  801576:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  80157d:	00 00 00 
  801580:	ff d2                	callq  *%rdx
			close(fd_src);
  801582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801585:	89 c7                	mov    %eax,%edi
  801587:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  80158e:	00 00 00 
  801591:	ff d0                	callq  *%rax
			close(fd_dest);
  801593:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801596:	89 c7                	mov    %eax,%edi
  801598:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  80159f:	00 00 00 
  8015a2:	ff d0                	callq  *%rax
			return write_size;
  8015a4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8015a7:	e9 a1 00 00 00       	jmpq   80164d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8015ac:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8015b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015b6:	ba 00 02 00 00       	mov    $0x200,%edx
  8015bb:	48 89 ce             	mov    %rcx,%rsi
  8015be:	89 c7                	mov    %eax,%edi
  8015c0:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  8015c7:	00 00 00 
  8015ca:	ff d0                	callq  *%rax
  8015cc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8015cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015d3:	0f 8f 5f ff ff ff    	jg     801538 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8015d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8015dd:	79 47                	jns    801626 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8015df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e2:	89 c6                	mov    %eax,%esi
  8015e4:	48 bf b5 3f 80 00 00 	movabs $0x803fb5,%rdi
  8015eb:	00 00 00 
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f3:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  8015fa:	00 00 00 
  8015fd:	ff d2                	callq  *%rdx
		close(fd_src);
  8015ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801602:	89 c7                	mov    %eax,%edi
  801604:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  80160b:	00 00 00 
  80160e:	ff d0                	callq  *%rax
		close(fd_dest);
  801610:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801613:	89 c7                	mov    %eax,%edi
  801615:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  80161c:	00 00 00 
  80161f:	ff d0                	callq  *%rax
		return read_size;
  801621:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801624:	eb 27                	jmp    80164d <copy+0x1d9>
	}
	close(fd_src);
  801626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801629:	89 c7                	mov    %eax,%edi
  80162b:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  801632:	00 00 00 
  801635:	ff d0                	callq  *%rax
	close(fd_dest);
  801637:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80163a:	89 c7                	mov    %eax,%edi
  80163c:	48 b8 41 09 80 00 00 	movabs $0x800941,%rax
  801643:	00 00 00 
  801646:	ff d0                	callq  *%rax
	return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 20          	sub    $0x20,%rsp
  801657:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80165a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80165e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801661:	48 89 d6             	mov    %rdx,%rsi
  801664:	89 c7                	mov    %eax,%edi
  801666:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  80166d:	00 00 00 
  801670:	ff d0                	callq  *%rax
  801672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801679:	79 05                	jns    801680 <fd2sockid+0x31>
		return r;
  80167b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80167e:	eb 24                	jmp    8016a4 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801684:	8b 10                	mov    (%rax),%edx
  801686:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80168d:	00 00 00 
  801690:	8b 00                	mov    (%rax),%eax
  801692:	39 c2                	cmp    %eax,%edx
  801694:	74 07                	je     80169d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801696:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80169b:	eb 07                	jmp    8016a4 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80169d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a1:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8016a4:	c9                   	leaveq 
  8016a5:	c3                   	retq   

00000000008016a6 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8016a6:	55                   	push   %rbp
  8016a7:	48 89 e5             	mov    %rsp,%rbp
  8016aa:	48 83 ec 20          	sub    $0x20,%rsp
  8016ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8016b1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8016b5:	48 89 c7             	mov    %rax,%rdi
  8016b8:	48 b8 99 06 80 00 00 	movabs $0x800699,%rax
  8016bf:	00 00 00 
  8016c2:	ff d0                	callq  *%rax
  8016c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016cb:	78 26                	js     8016f3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8016cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d1:	ba 07 04 00 00       	mov    $0x407,%edx
  8016d6:	48 89 c6             	mov    %rax,%rsi
  8016d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016de:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  8016e5:	00 00 00 
  8016e8:	ff d0                	callq  *%rax
  8016ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8016ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f1:	79 16                	jns    801709 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8016f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f6:	89 c7                	mov    %eax,%edi
  8016f8:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  8016ff:	00 00 00 
  801702:	ff d0                	callq  *%rax
		return r;
  801704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801707:	eb 3a                	jmp    801743 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170d:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801714:	00 00 00 
  801717:	8b 12                	mov    (%rdx),%edx
  801719:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80171b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80172d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801734:	48 89 c7             	mov    %rax,%rdi
  801737:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  80173e:	00 00 00 
  801741:	ff d0                	callq  *%rax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 30          	sub    $0x30,%rsp
  80174d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801750:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801754:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801758:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80175b:	89 c7                	mov    %eax,%edi
  80175d:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  801764:	00 00 00 
  801767:	ff d0                	callq  *%rax
  801769:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80176c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801770:	79 05                	jns    801777 <accept+0x32>
		return r;
  801772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801775:	eb 3b                	jmp    8017b2 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801777:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80177b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80177f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801782:	48 89 ce             	mov    %rcx,%rsi
  801785:	89 c7                	mov    %eax,%edi
  801787:	48 b8 90 1a 80 00 00 	movabs $0x801a90,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
  801793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80179a:	79 05                	jns    8017a1 <accept+0x5c>
		return r;
  80179c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80179f:	eb 11                	jmp    8017b2 <accept+0x6d>
	return alloc_sockfd(r);
  8017a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a4:	89 c7                	mov    %eax,%edi
  8017a6:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 20          	sub    $0x20,%rsp
  8017bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017c3:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c9:	89 c7                	mov    %eax,%edi
  8017cb:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  8017d2:	00 00 00 
  8017d5:	ff d0                	callq  *%rax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017de:	79 05                	jns    8017e5 <bind+0x31>
		return r;
  8017e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e3:	eb 1b                	jmp    801800 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8017e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8017e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8017ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ef:	48 89 ce             	mov    %rcx,%rsi
  8017f2:	89 c7                	mov    %eax,%edi
  8017f4:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
}
  801800:	c9                   	leaveq 
  801801:	c3                   	retq   

0000000000801802 <shutdown>:

int
shutdown(int s, int how)
{
  801802:	55                   	push   %rbp
  801803:	48 89 e5             	mov    %rsp,%rbp
  801806:	48 83 ec 20          	sub    $0x20,%rsp
  80180a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80180d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801810:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801813:	89 c7                	mov    %eax,%edi
  801815:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  80181c:	00 00 00 
  80181f:	ff d0                	callq  *%rax
  801821:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801828:	79 05                	jns    80182f <shutdown+0x2d>
		return r;
  80182a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182d:	eb 16                	jmp    801845 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80182f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801835:	89 d6                	mov    %edx,%esi
  801837:	89 c7                	mov    %eax,%edi
  801839:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  801840:	00 00 00 
  801843:	ff d0                	callq  *%rax
}
  801845:	c9                   	leaveq 
  801846:	c3                   	retq   

0000000000801847 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801847:	55                   	push   %rbp
  801848:	48 89 e5             	mov    %rsp,%rbp
  80184b:	48 83 ec 10          	sub    $0x10,%rsp
  80184f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801853:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801857:	48 89 c7             	mov    %rax,%rdi
  80185a:	48 b8 08 3e 80 00 00 	movabs $0x803e08,%rax
  801861:	00 00 00 
  801864:	ff d0                	callq  *%rax
  801866:	83 f8 01             	cmp    $0x1,%eax
  801869:	75 17                	jne    801882 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80186b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186f:	8b 40 0c             	mov    0xc(%rax),%eax
  801872:	89 c7                	mov    %eax,%edi
  801874:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
  801880:	eb 05                	jmp    801887 <devsock_close+0x40>
	else
		return 0;
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 20          	sub    $0x20,%rsp
  801891:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801894:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801898:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80189b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189e:	89 c7                	mov    %eax,%edi
  8018a0:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
  8018ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018b3:	79 05                	jns    8018ba <connect+0x31>
		return r;
  8018b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b8:	eb 1b                	jmp    8018d5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8018ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8018bd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8018c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c4:	48 89 ce             	mov    %rcx,%rsi
  8018c7:	89 c7                	mov    %eax,%edi
  8018c9:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <listen>:

int
listen(int s, int backlog)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 20          	sub    $0x20,%rsp
  8018df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8018e2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018e8:	89 c7                	mov    %eax,%edi
  8018ea:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018fd:	79 05                	jns    801904 <listen+0x2d>
		return r;
  8018ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801902:	eb 16                	jmp    80191a <listen+0x43>
	return nsipc_listen(r, backlog);
  801904:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	89 d6                	mov    %edx,%esi
  80190c:	89 c7                	mov    %eax,%edi
  80190e:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
}
  80191a:	c9                   	leaveq 
  80191b:	c3                   	retq   

000000000080191c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 20          	sub    $0x20,%rsp
  801924:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801928:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80192c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801934:	89 c2                	mov    %eax,%edx
  801936:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193a:	8b 40 0c             	mov    0xc(%rax),%eax
  80193d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801941:	b9 00 00 00 00       	mov    $0x0,%ecx
  801946:	89 c7                	mov    %eax,%edi
  801948:	48 b8 84 1c 80 00 00 	movabs $0x801c84,%rax
  80194f:	00 00 00 
  801952:	ff d0                	callq  *%rax
}
  801954:	c9                   	leaveq 
  801955:	c3                   	retq   

0000000000801956 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801956:	55                   	push   %rbp
  801957:	48 89 e5             	mov    %rsp,%rbp
  80195a:	48 83 ec 20          	sub    $0x20,%rsp
  80195e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801962:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801966:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80196a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80196e:	89 c2                	mov    %eax,%edx
  801970:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801974:	8b 40 0c             	mov    0xc(%rax),%eax
  801977:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80197b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801980:	89 c7                	mov    %eax,%edi
  801982:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  801989:	00 00 00 
  80198c:	ff d0                	callq  *%rax
}
  80198e:	c9                   	leaveq 
  80198f:	c3                   	retq   

0000000000801990 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	48 83 ec 10          	sub    $0x10,%rsp
  801998:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80199c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8019a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a4:	48 be d0 3f 80 00 00 	movabs $0x803fd0,%rsi
  8019ab:	00 00 00 
  8019ae:	48 89 c7             	mov    %rax,%rdi
  8019b1:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	callq  *%rax
	return 0;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 20          	sub    $0x20,%rsp
  8019cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019cf:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8019d2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8019d8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8019db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019de:	89 ce                	mov    %ecx,%esi
  8019e0:	89 c7                	mov    %eax,%edi
  8019e2:	48 b8 08 1e 80 00 00 	movabs $0x801e08,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
  8019ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f5:	79 05                	jns    8019fc <socket+0x38>
		return r;
  8019f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fa:	eb 11                	jmp    801a0d <socket+0x49>
	return alloc_sockfd(r);
  8019fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ff:	89 c7                	mov    %eax,%edi
  801a01:	48 b8 a6 16 80 00 00 	movabs $0x8016a6,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	callq  *%rax
}
  801a0d:	c9                   	leaveq 
  801a0e:	c3                   	retq   

0000000000801a0f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a0f:	55                   	push   %rbp
  801a10:	48 89 e5             	mov    %rsp,%rbp
  801a13:	48 83 ec 10          	sub    $0x10,%rsp
  801a17:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801a1a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a21:	00 00 00 
  801a24:	8b 00                	mov    (%rax),%eax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	75 1d                	jne    801a47 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a2a:	bf 02 00 00 00       	mov    $0x2,%edi
  801a2f:	48 b8 86 3d 80 00 00 	movabs $0x803d86,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
  801a3b:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  801a42:	00 00 00 
  801a45:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a47:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801a4e:	00 00 00 
  801a51:	8b 00                	mov    (%rax),%eax
  801a53:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a56:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a5b:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801a62:	00 00 00 
  801a65:	89 c7                	mov    %eax,%edi
  801a67:	48 b8 24 3d 80 00 00 	movabs $0x803d24,%rax
  801a6e:	00 00 00 
  801a71:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801a73:	ba 00 00 00 00       	mov    $0x0,%edx
  801a78:	be 00 00 00 00       	mov    $0x0,%esi
  801a7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801a82:	48 b8 1e 3c 80 00 00 	movabs $0x803c1e,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	callq  *%rax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 30          	sub    $0x30,%rsp
  801a98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801aa3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801aaa:	00 00 00 
  801aad:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ab0:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab2:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab7:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801abe:	00 00 00 
  801ac1:	ff d0                	callq  *%rax
  801ac3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801aca:	78 3e                	js     801b0a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801acc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ad3:	00 00 00 
  801ad6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ada:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ade:	8b 40 10             	mov    0x10(%rax),%eax
  801ae1:	89 c2                	mov    %eax,%edx
  801ae3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aeb:	48 89 ce             	mov    %rcx,%rsi
  801aee:	48 89 c7             	mov    %rax,%rdi
  801af1:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b01:	8b 50 10             	mov    0x10(%rax),%edx
  801b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b08:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 10          	sub    $0x10,%rsp
  801b17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801b21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b28:	00 00 00 
  801b2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b2e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b37:	48 89 c6             	mov    %rax,%rsi
  801b3a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801b41:	00 00 00 
  801b44:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801b50:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b57:	00 00 00 
  801b5a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b5d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801b60:	bf 02 00 00 00       	mov    $0x2,%edi
  801b65:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	callq  *%rax
}
  801b71:	c9                   	leaveq 
  801b72:	c3                   	retq   

0000000000801b73 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	48 83 ec 10          	sub    $0x10,%rsp
  801b7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801b81:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b88:	00 00 00 
  801b8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801b8e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801b90:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801b97:	00 00 00 
  801b9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801b9d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801ba0:	bf 03 00 00 00       	mov    $0x3,%edi
  801ba5:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	callq  *%rax
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <nsipc_close>:

int
nsipc_close(int s)
{
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 10          	sub    $0x10,%rsp
  801bbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801bbe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bc5:	00 00 00 
  801bc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bcb:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801bcd:	bf 04 00 00 00       	mov    $0x4,%edi
  801bd2:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 10          	sub    $0x10,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801bf2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801bf9:	00 00 00 
  801bfc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bff:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c01:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c08:	48 89 c6             	mov    %rax,%rsi
  801c0b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801c12:	00 00 00 
  801c15:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801c21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c28:	00 00 00 
  801c2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c2e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801c31:	bf 05 00 00 00       	mov    $0x5,%edi
  801c36:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801c3d:	00 00 00 
  801c40:	ff d0                	callq  *%rax
}
  801c42:	c9                   	leaveq 
  801c43:	c3                   	retq   

0000000000801c44 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c44:	55                   	push   %rbp
  801c45:	48 89 e5             	mov    %rsp,%rbp
  801c48:	48 83 ec 10          	sub    $0x10,%rsp
  801c4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801c52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c59:	00 00 00 
  801c5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c5f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801c61:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c68:	00 00 00 
  801c6b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801c6e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801c71:	bf 06 00 00 00       	mov    $0x6,%edi
  801c76:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801c7d:	00 00 00 
  801c80:	ff d0                	callq  *%rax
}
  801c82:	c9                   	leaveq 
  801c83:	c3                   	retq   

0000000000801c84 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c84:	55                   	push   %rbp
  801c85:	48 89 e5             	mov    %rsp,%rbp
  801c88:	48 83 ec 30          	sub    $0x30,%rsp
  801c8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c93:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801c96:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801c99:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ca0:	00 00 00 
  801ca3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ca6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801ca8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801caf:	00 00 00 
  801cb2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801cb5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801cb8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cbf:	00 00 00 
  801cc2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cc5:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cc8:	bf 07 00 00 00       	mov    $0x7,%edi
  801ccd:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
  801cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce0:	78 69                	js     801d4b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801ce2:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801ce9:	7f 08                	jg     801cf3 <nsipc_recv+0x6f>
  801ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cee:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801cf1:	7e 35                	jle    801d28 <nsipc_recv+0xa4>
  801cf3:	48 b9 d7 3f 80 00 00 	movabs $0x803fd7,%rcx
  801cfa:	00 00 00 
  801cfd:	48 ba ec 3f 80 00 00 	movabs $0x803fec,%rdx
  801d04:	00 00 00 
  801d07:	be 61 00 00 00       	mov    $0x61,%esi
  801d0c:	48 bf 01 40 80 00 00 	movabs $0x804001,%rdi
  801d13:	00 00 00 
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	49 b8 d7 26 80 00 00 	movabs $0x8026d7,%r8
  801d22:	00 00 00 
  801d25:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2b:	48 63 d0             	movslq %eax,%rdx
  801d2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d32:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801d39:	00 00 00 
  801d3c:	48 89 c7             	mov    %rax,%rdi
  801d3f:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
	}

	return r;
  801d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 20          	sub    $0x20,%rsp
  801d58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d62:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801d65:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d6c:	00 00 00 
  801d6f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d72:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801d74:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801d7b:	7e 35                	jle    801db2 <nsipc_send+0x62>
  801d7d:	48 b9 0d 40 80 00 00 	movabs $0x80400d,%rcx
  801d84:	00 00 00 
  801d87:	48 ba ec 3f 80 00 00 	movabs $0x803fec,%rdx
  801d8e:	00 00 00 
  801d91:	be 6c 00 00 00       	mov    $0x6c,%esi
  801d96:	48 bf 01 40 80 00 00 	movabs $0x804001,%rdi
  801d9d:	00 00 00 
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
  801da5:	49 b8 d7 26 80 00 00 	movabs $0x8026d7,%r8
  801dac:	00 00 00 
  801daf:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db5:	48 63 d0             	movslq %eax,%rdx
  801db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbc:	48 89 c6             	mov    %rax,%rsi
  801dbf:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801dc6:	00 00 00 
  801dc9:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801dd5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ddc:	00 00 00 
  801ddf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801de2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801de5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dec:	00 00 00 
  801def:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801df2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801df5:	bf 08 00 00 00       	mov    $0x8,%edi
  801dfa:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801e01:	00 00 00 
  801e04:	ff d0                	callq  *%rax
}
  801e06:	c9                   	leaveq 
  801e07:	c3                   	retq   

0000000000801e08 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e08:	55                   	push   %rbp
  801e09:	48 89 e5             	mov    %rsp,%rbp
  801e0c:	48 83 ec 10          	sub    $0x10,%rsp
  801e10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e13:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801e16:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801e19:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e20:	00 00 00 
  801e23:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e26:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801e28:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e2f:	00 00 00 
  801e32:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e35:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  801e38:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e3f:	00 00 00 
  801e42:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e45:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  801e48:	bf 09 00 00 00       	mov    $0x9,%edi
  801e4d:	48 b8 0f 1a 80 00 00 	movabs $0x801a0f,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	53                   	push   %rbx
  801e60:	48 83 ec 38          	sub    $0x38,%rsp
  801e64:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e68:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801e6c:	48 89 c7             	mov    %rax,%rdi
  801e6f:	48 b8 99 06 80 00 00 	movabs $0x800699,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax
  801e7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e82:	0f 88 bf 01 00 00    	js     802047 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8c:	ba 07 04 00 00       	mov    $0x407,%edx
  801e91:	48 89 c6             	mov    %rax,%rsi
  801e94:	bf 00 00 00 00       	mov    $0x0,%edi
  801e99:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801ea0:	00 00 00 
  801ea3:	ff d0                	callq  *%rax
  801ea5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ea8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eac:	0f 88 95 01 00 00    	js     802047 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801eb2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801eb6:	48 89 c7             	mov    %rax,%rdi
  801eb9:	48 b8 99 06 80 00 00 	movabs $0x800699,%rax
  801ec0:	00 00 00 
  801ec3:	ff d0                	callq  *%rax
  801ec5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ecc:	0f 88 5d 01 00 00    	js     80202f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ed6:	ba 07 04 00 00       	mov    $0x407,%edx
  801edb:	48 89 c6             	mov    %rax,%rsi
  801ede:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee3:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801eea:	00 00 00 
  801eed:	ff d0                	callq  *%rax
  801eef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ef2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef6:	0f 88 33 01 00 00    	js     80202f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f00:	48 89 c7             	mov    %rax,%rdi
  801f03:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	callq  *%rax
  801f0f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f17:	ba 07 04 00 00       	mov    $0x407,%edx
  801f1c:	48 89 c6             	mov    %rax,%rsi
  801f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f24:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
  801f30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f37:	79 05                	jns    801f3e <pipe+0xe3>
		goto err2;
  801f39:	e9 d9 00 00 00       	jmpq   802017 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f42:	48 89 c7             	mov    %rax,%rdi
  801f45:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
  801f51:	48 89 c2             	mov    %rax,%rdx
  801f54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f58:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801f5e:	48 89 d1             	mov    %rdx,%rcx
  801f61:	ba 00 00 00 00       	mov    $0x0,%edx
  801f66:	48 89 c6             	mov    %rax,%rsi
  801f69:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6e:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f81:	79 1b                	jns    801f9e <pipe+0x143>
		goto err3;
  801f83:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f88:	48 89 c6             	mov    %rax,%rsi
  801f8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f90:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  801f97:	00 00 00 
  801f9a:	ff d0                	callq  *%rax
  801f9c:	eb 79                	jmp    802017 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801fa9:	00 00 00 
  801fac:	8b 12                	mov    (%rdx),%edx
  801fae:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbf:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  801fc6:	00 00 00 
  801fc9:	8b 12                	mov    (%rdx),%edx
  801fcb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801fcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fd1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdc:	48 89 c7             	mov    %rax,%rdi
  801fdf:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  801fe6:	00 00 00 
  801fe9:	ff d0                	callq  *%rax
  801feb:	89 c2                	mov    %eax,%edx
  801fed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ff1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801ff3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ff7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801ffb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fff:	48 89 c7             	mov    %rax,%rdi
  802002:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  802009:	00 00 00 
  80200c:	ff d0                	callq  *%rax
  80200e:	89 03                	mov    %eax,(%rbx)
	return 0;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	eb 33                	jmp    80204a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802017:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80201b:	48 89 c6             	mov    %rax,%rsi
  80201e:	bf 00 00 00 00       	mov    $0x0,%edi
  802023:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80202f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802033:	48 89 c6             	mov    %rax,%rsi
  802036:	bf 00 00 00 00       	mov    $0x0,%edi
  80203b:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
err:
	return r;
  802047:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80204a:	48 83 c4 38          	add    $0x38,%rsp
  80204e:	5b                   	pop    %rbx
  80204f:	5d                   	pop    %rbp
  802050:	c3                   	retq   

0000000000802051 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802051:	55                   	push   %rbp
  802052:	48 89 e5             	mov    %rsp,%rbp
  802055:	53                   	push   %rbx
  802056:	48 83 ec 28          	sub    $0x28,%rsp
  80205a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80205e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802062:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802069:	00 00 00 
  80206c:	48 8b 00             	mov    (%rax),%rax
  80206f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802075:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802078:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207c:	48 89 c7             	mov    %rax,%rdi
  80207f:	48 b8 08 3e 80 00 00 	movabs $0x803e08,%rax
  802086:	00 00 00 
  802089:	ff d0                	callq  *%rax
  80208b:	89 c3                	mov    %eax,%ebx
  80208d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802091:	48 89 c7             	mov    %rax,%rdi
  802094:	48 b8 08 3e 80 00 00 	movabs $0x803e08,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
  8020a0:	39 c3                	cmp    %eax,%ebx
  8020a2:	0f 94 c0             	sete   %al
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8020ab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020b2:	00 00 00 
  8020b5:	48 8b 00             	mov    (%rax),%rax
  8020b8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8020be:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8020c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020c7:	75 05                	jne    8020ce <_pipeisclosed+0x7d>
			return ret;
  8020c9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020cc:	eb 4f                	jmp    80211d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8020ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020d1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8020d4:	74 42                	je     802118 <_pipeisclosed+0xc7>
  8020d6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8020da:	75 3c                	jne    802118 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020dc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020e3:	00 00 00 
  8020e6:	48 8b 00             	mov    (%rax),%rax
  8020e9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8020ef:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8020f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f5:	89 c6                	mov    %eax,%esi
  8020f7:	48 bf 1e 40 80 00 00 	movabs $0x80401e,%rdi
  8020fe:	00 00 00 
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	49 b8 10 29 80 00 00 	movabs $0x802910,%r8
  80210d:	00 00 00 
  802110:	41 ff d0             	callq  *%r8
	}
  802113:	e9 4a ff ff ff       	jmpq   802062 <_pipeisclosed+0x11>
  802118:	e9 45 ff ff ff       	jmpq   802062 <_pipeisclosed+0x11>
}
  80211d:	48 83 c4 28          	add    $0x28,%rsp
  802121:	5b                   	pop    %rbx
  802122:	5d                   	pop    %rbp
  802123:	c3                   	retq   

0000000000802124 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802124:	55                   	push   %rbp
  802125:	48 89 e5             	mov    %rsp,%rbp
  802128:	48 83 ec 30          	sub    $0x30,%rsp
  80212c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802133:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802136:	48 89 d6             	mov    %rdx,%rsi
  802139:	89 c7                	mov    %eax,%edi
  80213b:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  802142:	00 00 00 
  802145:	ff d0                	callq  *%rax
  802147:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80214a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214e:	79 05                	jns    802155 <pipeisclosed+0x31>
		return r;
  802150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802153:	eb 31                	jmp    802186 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802159:	48 89 c7             	mov    %rax,%rdi
  80215c:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
  802168:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80216c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802174:	48 89 d6             	mov    %rdx,%rsi
  802177:	48 89 c7             	mov    %rax,%rdi
  80217a:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
  80218c:	48 83 ec 40          	sub    $0x40,%rsp
  802190:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802194:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802198:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80219c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a0:	48 89 c7             	mov    %rax,%rdi
  8021a3:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax
  8021af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8021b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8021bb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8021c2:	00 
  8021c3:	e9 92 00 00 00       	jmpq   80225a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8021c8:	eb 41                	jmp    80220b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021ca:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8021cf:	74 09                	je     8021da <devpipe_read+0x52>
				return i;
  8021d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d5:	e9 92 00 00 00       	jmpq   80226c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e2:	48 89 d6             	mov    %rdx,%rsi
  8021e5:	48 89 c7             	mov    %rax,%rdi
  8021e8:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	74 07                	je     8021ff <devpipe_read+0x77>
				return 0;
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	eb 6d                	jmp    80226c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021ff:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80220b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220f:	8b 10                	mov    (%rax),%edx
  802211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802215:	8b 40 04             	mov    0x4(%rax),%eax
  802218:	39 c2                	cmp    %eax,%edx
  80221a:	74 ae                	je     8021ca <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80221c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802220:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802224:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222c:	8b 00                	mov    (%rax),%eax
  80222e:	99                   	cltd   
  80222f:	c1 ea 1b             	shr    $0x1b,%edx
  802232:	01 d0                	add    %edx,%eax
  802234:	83 e0 1f             	and    $0x1f,%eax
  802237:	29 d0                	sub    %edx,%eax
  802239:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80223d:	48 98                	cltq   
  80223f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802244:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224a:	8b 00                	mov    (%rax),%eax
  80224c:	8d 50 01             	lea    0x1(%rax),%edx
  80224f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802253:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802255:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80225a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802262:	0f 82 60 ff ff ff    	jb     8021c8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80226c:	c9                   	leaveq 
  80226d:	c3                   	retq   

000000000080226e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226e:	55                   	push   %rbp
  80226f:	48 89 e5             	mov    %rsp,%rbp
  802272:	48 83 ec 40          	sub    $0x40,%rsp
  802276:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80227a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80227e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802282:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802286:	48 89 c7             	mov    %rax,%rdi
  802289:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802299:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80229d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8022a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022a8:	00 
  8022a9:	e9 8e 00 00 00       	jmpq   80233c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022ae:	eb 31                	jmp    8022e1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022b8:	48 89 d6             	mov    %rdx,%rsi
  8022bb:	48 89 c7             	mov    %rax,%rdi
  8022be:	48 b8 51 20 80 00 00 	movabs $0x802051,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	74 07                	je     8022d5 <devpipe_write+0x67>
				return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 79                	jmp    80234e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022d5:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  8022dc:	00 00 00 
  8022df:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e5:	8b 40 04             	mov    0x4(%rax),%eax
  8022e8:	48 63 d0             	movslq %eax,%rdx
  8022eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ef:	8b 00                	mov    (%rax),%eax
  8022f1:	48 98                	cltq   
  8022f3:	48 83 c0 20          	add    $0x20,%rax
  8022f7:	48 39 c2             	cmp    %rax,%rdx
  8022fa:	73 b4                	jae    8022b0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802300:	8b 40 04             	mov    0x4(%rax),%eax
  802303:	99                   	cltd   
  802304:	c1 ea 1b             	shr    $0x1b,%edx
  802307:	01 d0                	add    %edx,%eax
  802309:	83 e0 1f             	and    $0x1f,%eax
  80230c:	29 d0                	sub    %edx,%eax
  80230e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802312:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802316:	48 01 ca             	add    %rcx,%rdx
  802319:	0f b6 0a             	movzbl (%rdx),%ecx
  80231c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802320:	48 98                	cltq   
  802322:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232a:	8b 40 04             	mov    0x4(%rax),%eax
  80232d:	8d 50 01             	lea    0x1(%rax),%edx
  802330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802334:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802337:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80233c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802340:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802344:	0f 82 64 ff ff ff    	jb     8022ae <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80234a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80234e:	c9                   	leaveq 
  80234f:	c3                   	retq   

0000000000802350 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	48 83 ec 20          	sub    $0x20,%rsp
  802358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80235c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802364:	48 89 c7             	mov    %rax,%rdi
  802367:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax
  802373:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237b:	48 be 31 40 80 00 00 	movabs $0x804031,%rsi
  802382:	00 00 00 
  802385:	48 89 c7             	mov    %rax,%rdi
  802388:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  80238f:	00 00 00 
  802392:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802398:	8b 50 04             	mov    0x4(%rax),%edx
  80239b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239f:	8b 00                	mov    (%rax),%eax
  8023a1:	29 c2                	sub    %eax,%edx
  8023a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8023ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023b8:	00 00 00 
	stat->st_dev = &devpipe;
  8023bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023bf:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8023c6:	00 00 00 
  8023c9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d5:	c9                   	leaveq 
  8023d6:	c3                   	retq   

00000000008023d7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	48 83 ec 10          	sub    $0x10,%rsp
  8023df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8023e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e7:	48 89 c6             	mov    %rax,%rsi
  8023ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ef:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8023fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ff:	48 89 c7             	mov    %rax,%rdi
  802402:	48 b8 6e 06 80 00 00 	movabs $0x80066e,%rax
  802409:	00 00 00 
  80240c:	ff d0                	callq  *%rax
  80240e:	48 89 c6             	mov    %rax,%rsi
  802411:	bf 00 00 00 00       	mov    $0x0,%edi
  802416:	48 b8 bf 03 80 00 00 	movabs $0x8003bf,%rax
  80241d:	00 00 00 
  802420:	ff d0                	callq  *%rax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 20          	sub    $0x20,%rsp
  80242c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80242f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802432:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802435:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802439:	be 01 00 00 00       	mov    $0x1,%esi
  80243e:	48 89 c7             	mov    %rax,%rdi
  802441:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
}
  80244d:	c9                   	leaveq 
  80244e:	c3                   	retq   

000000000080244f <getchar>:

int
getchar(void)
{
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802457:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80245b:	ba 01 00 00 00       	mov    $0x1,%edx
  802460:	48 89 c6             	mov    %rax,%rsi
  802463:	bf 00 00 00 00       	mov    $0x0,%edi
  802468:	48 b8 63 0b 80 00 00 	movabs $0x800b63,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
  802474:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802477:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247b:	79 05                	jns    802482 <getchar+0x33>
		return r;
  80247d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802480:	eb 14                	jmp    802496 <getchar+0x47>
	if (r < 1)
  802482:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802486:	7f 07                	jg     80248f <getchar+0x40>
		return -E_EOF;
  802488:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80248d:	eb 07                	jmp    802496 <getchar+0x47>
	return c;
  80248f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802493:	0f b6 c0             	movzbl %al,%eax
}
  802496:	c9                   	leaveq 
  802497:	c3                   	retq   

0000000000802498 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802498:	55                   	push   %rbp
  802499:	48 89 e5             	mov    %rsp,%rbp
  80249c:	48 83 ec 20          	sub    $0x20,%rsp
  8024a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024a3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024aa:	48 89 d6             	mov    %rdx,%rsi
  8024ad:	89 c7                	mov    %eax,%edi
  8024af:	48 b8 31 07 80 00 00 	movabs $0x800731,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
  8024bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c2:	79 05                	jns    8024c9 <iscons+0x31>
		return r;
  8024c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c7:	eb 1a                	jmp    8024e3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8024c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cd:	8b 10                	mov    (%rax),%edx
  8024cf:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8024d6:	00 00 00 
  8024d9:	8b 00                	mov    (%rax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	0f 94 c0             	sete   %al
  8024e0:	0f b6 c0             	movzbl %al,%eax
}
  8024e3:	c9                   	leaveq 
  8024e4:	c3                   	retq   

00000000008024e5 <opencons>:

int
opencons(void)
{
  8024e5:	55                   	push   %rbp
  8024e6:	48 89 e5             	mov    %rsp,%rbp
  8024e9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024ed:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024f1:	48 89 c7             	mov    %rax,%rdi
  8024f4:	48 b8 99 06 80 00 00 	movabs $0x800699,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802507:	79 05                	jns    80250e <opencons+0x29>
		return r;
  802509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250c:	eb 5b                	jmp    802569 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80250e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802512:	ba 07 04 00 00       	mov    $0x407,%edx
  802517:	48 89 c6             	mov    %rax,%rsi
  80251a:	bf 00 00 00 00       	mov    $0x0,%edi
  80251f:	48 b8 14 03 80 00 00 	movabs $0x800314,%rax
  802526:	00 00 00 
  802529:	ff d0                	callq  *%rax
  80252b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802532:	79 05                	jns    802539 <opencons+0x54>
		return r;
  802534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802537:	eb 30                	jmp    802569 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802544:	00 00 00 
  802547:	8b 12                	mov    (%rdx),%edx
  802549:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80254b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	48 89 c7             	mov    %rax,%rdi
  80255d:	48 b8 4b 06 80 00 00 	movabs $0x80064b,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
}
  802569:	c9                   	leaveq 
  80256a:	c3                   	retq   

000000000080256b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80256b:	55                   	push   %rbp
  80256c:	48 89 e5             	mov    %rsp,%rbp
  80256f:	48 83 ec 30          	sub    $0x30,%rsp
  802573:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802577:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80257b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80257f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802584:	75 07                	jne    80258d <devcons_read+0x22>
		return 0;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	eb 4b                	jmp    8025d8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80258d:	eb 0c                	jmp    80259b <devcons_read+0x30>
		sys_yield();
  80258f:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  802596:	00 00 00 
  802599:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80259b:	48 b8 16 02 80 00 00 	movabs $0x800216,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
  8025a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ae:	74 df                	je     80258f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	79 05                	jns    8025bb <devcons_read+0x50>
		return c;
  8025b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b9:	eb 1d                	jmp    8025d8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8025bb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8025bf:	75 07                	jne    8025c8 <devcons_read+0x5d>
		return 0;
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	eb 10                	jmp    8025d8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8025c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025cb:	89 c2                	mov    %eax,%edx
  8025cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d1:	88 10                	mov    %dl,(%rax)
	return 1;
  8025d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025d8:	c9                   	leaveq 
  8025d9:	c3                   	retq   

00000000008025da <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025da:	55                   	push   %rbp
  8025db:	48 89 e5             	mov    %rsp,%rbp
  8025de:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8025e5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8025ec:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8025f3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802601:	eb 76                	jmp    802679 <devcons_write+0x9f>
		m = n - tot;
  802603:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80260a:	89 c2                	mov    %eax,%edx
  80260c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260f:	29 c2                	sub    %eax,%edx
  802611:	89 d0                	mov    %edx,%eax
  802613:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802616:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802619:	83 f8 7f             	cmp    $0x7f,%eax
  80261c:	76 07                	jbe    802625 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80261e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802625:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802628:	48 63 d0             	movslq %eax,%rdx
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	48 63 c8             	movslq %eax,%rcx
  802631:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802638:	48 01 c1             	add    %rax,%rcx
  80263b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802642:	48 89 ce             	mov    %rcx,%rsi
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802654:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802657:	48 63 d0             	movslq %eax,%rdx
  80265a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802661:	48 89 d6             	mov    %rdx,%rsi
  802664:	48 89 c7             	mov    %rax,%rdi
  802667:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802673:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802676:	01 45 fc             	add    %eax,-0x4(%rbp)
  802679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267c:	48 98                	cltq   
  80267e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802685:	0f 82 78 ff ff ff    	jb     802603 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80268b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80268e:	c9                   	leaveq 
  80268f:	c3                   	retq   

0000000000802690 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 08          	sub    $0x8,%rsp
  802698:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a1:	c9                   	leaveq 
  8026a2:	c3                   	retq   

00000000008026a3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a3:	55                   	push   %rbp
  8026a4:	48 89 e5             	mov    %rsp,%rbp
  8026a7:	48 83 ec 10          	sub    $0x10,%rsp
  8026ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8026b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b7:	48 be 3d 40 80 00 00 	movabs $0x80403d,%rsi
  8026be:	00 00 00 
  8026c1:	48 89 c7             	mov    %rax,%rdi
  8026c4:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
	return 0;
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   

00000000008026d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026d7:	55                   	push   %rbp
  8026d8:	48 89 e5             	mov    %rsp,%rbp
  8026db:	53                   	push   %rbx
  8026dc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8026e3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8026ea:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8026f0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8026f7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8026fe:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802705:	84 c0                	test   %al,%al
  802707:	74 23                	je     80272c <_panic+0x55>
  802709:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802710:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802714:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802718:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80271c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802720:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802724:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802728:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80272c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802733:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80273a:	00 00 00 
  80273d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802744:	00 00 00 
  802747:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80274b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802752:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802759:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802760:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802767:	00 00 00 
  80276a:	48 8b 18             	mov    (%rax),%rbx
  80276d:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80277f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802786:	41 89 c8             	mov    %ecx,%r8d
  802789:	48 89 d1             	mov    %rdx,%rcx
  80278c:	48 89 da             	mov    %rbx,%rdx
  80278f:	89 c6                	mov    %eax,%esi
  802791:	48 bf 48 40 80 00 00 	movabs $0x804048,%rdi
  802798:	00 00 00 
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	49 b9 10 29 80 00 00 	movabs $0x802910,%r9
  8027a7:	00 00 00 
  8027aa:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027ad:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8027b4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8027bb:	48 89 d6             	mov    %rdx,%rsi
  8027be:	48 89 c7             	mov    %rax,%rdi
  8027c1:	48 b8 64 28 80 00 00 	movabs $0x802864,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
	cprintf("\n");
  8027cd:	48 bf 6b 40 80 00 00 	movabs $0x80406b,%rdi
  8027d4:	00 00 00 
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	48 ba 10 29 80 00 00 	movabs $0x802910,%rdx
  8027e3:	00 00 00 
  8027e6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027e8:	cc                   	int3   
  8027e9:	eb fd                	jmp    8027e8 <_panic+0x111>

00000000008027eb <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8027eb:	55                   	push   %rbp
  8027ec:	48 89 e5             	mov    %rsp,%rbp
  8027ef:	48 83 ec 10          	sub    $0x10,%rsp
  8027f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8027fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fe:	8b 00                	mov    (%rax),%eax
  802800:	8d 48 01             	lea    0x1(%rax),%ecx
  802803:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802807:	89 0a                	mov    %ecx,(%rdx)
  802809:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80280c:	89 d1                	mov    %edx,%ecx
  80280e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802812:	48 98                	cltq   
  802814:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  802818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281c:	8b 00                	mov    (%rax),%eax
  80281e:	3d ff 00 00 00       	cmp    $0xff,%eax
  802823:	75 2c                	jne    802851 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  802825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802829:	8b 00                	mov    (%rax),%eax
  80282b:	48 98                	cltq   
  80282d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802831:	48 83 c2 08          	add    $0x8,%rdx
  802835:	48 89 c6             	mov    %rax,%rsi
  802838:	48 89 d7             	mov    %rdx,%rdi
  80283b:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
        b->idx = 0;
  802847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802851:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802855:	8b 40 04             	mov    0x4(%rax),%eax
  802858:	8d 50 01             	lea    0x1(%rax),%edx
  80285b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285f:	89 50 04             	mov    %edx,0x4(%rax)
}
  802862:	c9                   	leaveq 
  802863:	c3                   	retq   

0000000000802864 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802864:	55                   	push   %rbp
  802865:	48 89 e5             	mov    %rsp,%rbp
  802868:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80286f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802876:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80287d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802884:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80288b:	48 8b 0a             	mov    (%rdx),%rcx
  80288e:	48 89 08             	mov    %rcx,(%rax)
  802891:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802895:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802899:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80289d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8028a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8028a8:	00 00 00 
    b.cnt = 0;
  8028ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8028b2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8028b5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8028bc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8028c3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8028ca:	48 89 c6             	mov    %rax,%rsi
  8028cd:	48 bf eb 27 80 00 00 	movabs $0x8027eb,%rdi
  8028d4:	00 00 00 
  8028d7:	48 b8 c3 2c 80 00 00 	movabs $0x802cc3,%rax
  8028de:	00 00 00 
  8028e1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8028e3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8028e9:	48 98                	cltq   
  8028eb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8028f2:	48 83 c2 08          	add    $0x8,%rdx
  8028f6:	48 89 c6             	mov    %rax,%rsi
  8028f9:	48 89 d7             	mov    %rdx,%rdi
  8028fc:	48 b8 cc 01 80 00 00 	movabs $0x8001cc,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802908:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80290e:	c9                   	leaveq 
  80290f:	c3                   	retq   

0000000000802910 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802910:	55                   	push   %rbp
  802911:	48 89 e5             	mov    %rsp,%rbp
  802914:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80291b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802922:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802929:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802930:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802937:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80293e:	84 c0                	test   %al,%al
  802940:	74 20                	je     802962 <cprintf+0x52>
  802942:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802946:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80294a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80294e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802952:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802956:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80295a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80295e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802962:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802969:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802970:	00 00 00 
  802973:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80297a:	00 00 00 
  80297d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802981:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802988:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80298f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802996:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80299d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8029a4:	48 8b 0a             	mov    (%rdx),%rcx
  8029a7:	48 89 08             	mov    %rcx,(%rax)
  8029aa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029ae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029b2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029b6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8029ba:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8029c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8029c8:	48 89 d6             	mov    %rdx,%rsi
  8029cb:	48 89 c7             	mov    %rax,%rdi
  8029ce:	48 b8 64 28 80 00 00 	movabs $0x802864,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
  8029da:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8029e0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8029e6:	c9                   	leaveq 
  8029e7:	c3                   	retq   

00000000008029e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8029e8:	55                   	push   %rbp
  8029e9:	48 89 e5             	mov    %rsp,%rbp
  8029ec:	53                   	push   %rbx
  8029ed:	48 83 ec 38          	sub    $0x38,%rsp
  8029f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8029fd:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802a00:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802a04:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802a08:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a0b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a0f:	77 3b                	ja     802a4c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802a11:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802a14:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802a18:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802a1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	48 f7 f3             	div    %rbx
  802a27:	48 89 c2             	mov    %rax,%rdx
  802a2a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a2d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a30:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a38:	41 89 f9             	mov    %edi,%r9d
  802a3b:	48 89 c7             	mov    %rax,%rdi
  802a3e:	48 b8 e8 29 80 00 00 	movabs $0x8029e8,%rax
  802a45:	00 00 00 
  802a48:	ff d0                	callq  *%rax
  802a4a:	eb 1e                	jmp    802a6a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a4c:	eb 12                	jmp    802a60 <printnum+0x78>
			putch(padc, putdat);
  802a4e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a52:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a59:	48 89 ce             	mov    %rcx,%rsi
  802a5c:	89 d7                	mov    %edx,%edi
  802a5e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802a60:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802a64:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802a68:	7f e4                	jg     802a4e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802a6a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a71:	ba 00 00 00 00       	mov    $0x0,%edx
  802a76:	48 f7 f1             	div    %rcx
  802a79:	48 89 d0             	mov    %rdx,%rax
  802a7c:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  802a83:	00 00 00 
  802a86:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802a8a:	0f be d0             	movsbl %al,%edx
  802a8d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a95:	48 89 ce             	mov    %rcx,%rsi
  802a98:	89 d7                	mov    %edx,%edi
  802a9a:	ff d0                	callq  *%rax
}
  802a9c:	48 83 c4 38          	add    $0x38,%rsp
  802aa0:	5b                   	pop    %rbx
  802aa1:	5d                   	pop    %rbp
  802aa2:	c3                   	retq   

0000000000802aa3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 1c          	sub    $0x1c,%rsp
  802aab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aaf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802ab2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802ab6:	7e 52                	jle    802b0a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abc:	8b 00                	mov    (%rax),%eax
  802abe:	83 f8 30             	cmp    $0x30,%eax
  802ac1:	73 24                	jae    802ae7 <getuint+0x44>
  802ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acf:	8b 00                	mov    (%rax),%eax
  802ad1:	89 c0                	mov    %eax,%eax
  802ad3:	48 01 d0             	add    %rdx,%rax
  802ad6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ada:	8b 12                	mov    (%rdx),%edx
  802adc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802adf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ae3:	89 0a                	mov    %ecx,(%rdx)
  802ae5:	eb 17                	jmp    802afe <getuint+0x5b>
  802ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aeb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802aef:	48 89 d0             	mov    %rdx,%rax
  802af2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802af6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802afa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802afe:	48 8b 00             	mov    (%rax),%rax
  802b01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b05:	e9 a3 00 00 00       	jmpq   802bad <getuint+0x10a>
	else if (lflag)
  802b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802b0e:	74 4f                	je     802b5f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802b10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b14:	8b 00                	mov    (%rax),%eax
  802b16:	83 f8 30             	cmp    $0x30,%eax
  802b19:	73 24                	jae    802b3f <getuint+0x9c>
  802b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	8b 00                	mov    (%rax),%eax
  802b29:	89 c0                	mov    %eax,%eax
  802b2b:	48 01 d0             	add    %rdx,%rax
  802b2e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b32:	8b 12                	mov    (%rdx),%edx
  802b34:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3b:	89 0a                	mov    %ecx,(%rdx)
  802b3d:	eb 17                	jmp    802b56 <getuint+0xb3>
  802b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b43:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b47:	48 89 d0             	mov    %rdx,%rax
  802b4a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b52:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802b56:	48 8b 00             	mov    (%rax),%rax
  802b59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802b5d:	eb 4e                	jmp    802bad <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	8b 00                	mov    (%rax),%eax
  802b65:	83 f8 30             	cmp    $0x30,%eax
  802b68:	73 24                	jae    802b8e <getuint+0xeb>
  802b6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b76:	8b 00                	mov    (%rax),%eax
  802b78:	89 c0                	mov    %eax,%eax
  802b7a:	48 01 d0             	add    %rdx,%rax
  802b7d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b81:	8b 12                	mov    (%rdx),%edx
  802b83:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802b86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b8a:	89 0a                	mov    %ecx,(%rdx)
  802b8c:	eb 17                	jmp    802ba5 <getuint+0x102>
  802b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b92:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802b96:	48 89 d0             	mov    %rdx,%rax
  802b99:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802b9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ba1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802ba5:	8b 00                	mov    (%rax),%eax
  802ba7:	89 c0                	mov    %eax,%eax
  802ba9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bb1:	c9                   	leaveq 
  802bb2:	c3                   	retq   

0000000000802bb3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 1c          	sub    $0x1c,%rsp
  802bbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bbf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802bc2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802bc6:	7e 52                	jle    802c1a <getint+0x67>
		x=va_arg(*ap, long long);
  802bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcc:	8b 00                	mov    (%rax),%eax
  802bce:	83 f8 30             	cmp    $0x30,%eax
  802bd1:	73 24                	jae    802bf7 <getint+0x44>
  802bd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdf:	8b 00                	mov    (%rax),%eax
  802be1:	89 c0                	mov    %eax,%eax
  802be3:	48 01 d0             	add    %rdx,%rax
  802be6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bea:	8b 12                	mov    (%rdx),%edx
  802bec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802bef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf3:	89 0a                	mov    %ecx,(%rdx)
  802bf5:	eb 17                	jmp    802c0e <getint+0x5b>
  802bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802bff:	48 89 d0             	mov    %rdx,%rax
  802c02:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c0a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c0e:	48 8b 00             	mov    (%rax),%rax
  802c11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c15:	e9 a3 00 00 00       	jmpq   802cbd <getint+0x10a>
	else if (lflag)
  802c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802c1e:	74 4f                	je     802c6f <getint+0xbc>
		x=va_arg(*ap, long);
  802c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c24:	8b 00                	mov    (%rax),%eax
  802c26:	83 f8 30             	cmp    $0x30,%eax
  802c29:	73 24                	jae    802c4f <getint+0x9c>
  802c2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c37:	8b 00                	mov    (%rax),%eax
  802c39:	89 c0                	mov    %eax,%eax
  802c3b:	48 01 d0             	add    %rdx,%rax
  802c3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c42:	8b 12                	mov    (%rdx),%edx
  802c44:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c47:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c4b:	89 0a                	mov    %ecx,(%rdx)
  802c4d:	eb 17                	jmp    802c66 <getint+0xb3>
  802c4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c53:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802c57:	48 89 d0             	mov    %rdx,%rax
  802c5a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802c5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c62:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802c66:	48 8b 00             	mov    (%rax),%rax
  802c69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c6d:	eb 4e                	jmp    802cbd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802c6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c73:	8b 00                	mov    (%rax),%eax
  802c75:	83 f8 30             	cmp    $0x30,%eax
  802c78:	73 24                	jae    802c9e <getint+0xeb>
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	8b 00                	mov    (%rax),%eax
  802c88:	89 c0                	mov    %eax,%eax
  802c8a:	48 01 d0             	add    %rdx,%rax
  802c8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c91:	8b 12                	mov    (%rdx),%edx
  802c93:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802c96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9a:	89 0a                	mov    %ecx,(%rdx)
  802c9c:	eb 17                	jmp    802cb5 <getint+0x102>
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802ca6:	48 89 d0             	mov    %rdx,%rax
  802ca9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802cad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cb5:	8b 00                	mov    (%rax),%eax
  802cb7:	48 98                	cltq   
  802cb9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802cbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cc1:	c9                   	leaveq 
  802cc2:	c3                   	retq   

0000000000802cc3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802cc3:	55                   	push   %rbp
  802cc4:	48 89 e5             	mov    %rsp,%rbp
  802cc7:	41 54                	push   %r12
  802cc9:	53                   	push   %rbx
  802cca:	48 83 ec 60          	sub    $0x60,%rsp
  802cce:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802cd2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802cd6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802cda:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802cde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802ce2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802ce6:	48 8b 0a             	mov    (%rdx),%rcx
  802ce9:	48 89 08             	mov    %rcx,(%rax)
  802cec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802cf0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802cf4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802cf8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802cfc:	eb 17                	jmp    802d15 <vprintfmt+0x52>
			if (ch == '\0')
  802cfe:	85 db                	test   %ebx,%ebx
  802d00:	0f 84 cc 04 00 00    	je     8031d2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802d06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802d0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802d0e:	48 89 d6             	mov    %rdx,%rsi
  802d11:	89 df                	mov    %ebx,%edi
  802d13:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802d15:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d19:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d1d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d21:	0f b6 00             	movzbl (%rax),%eax
  802d24:	0f b6 d8             	movzbl %al,%ebx
  802d27:	83 fb 25             	cmp    $0x25,%ebx
  802d2a:	75 d2                	jne    802cfe <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802d2c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802d30:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802d37:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802d3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802d45:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802d4c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802d50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d54:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802d58:	0f b6 00             	movzbl (%rax),%eax
  802d5b:	0f b6 d8             	movzbl %al,%ebx
  802d5e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802d61:	83 f8 55             	cmp    $0x55,%eax
  802d64:	0f 87 34 04 00 00    	ja     80319e <vprintfmt+0x4db>
  802d6a:	89 c0                	mov    %eax,%eax
  802d6c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802d73:	00 
  802d74:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
  802d7b:	00 00 00 
  802d7e:	48 01 d0             	add    %rdx,%rax
  802d81:	48 8b 00             	mov    (%rax),%rax
  802d84:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802d86:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802d8a:	eb c0                	jmp    802d4c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802d8c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802d90:	eb ba                	jmp    802d4c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802d92:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802d99:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d9c:	89 d0                	mov    %edx,%eax
  802d9e:	c1 e0 02             	shl    $0x2,%eax
  802da1:	01 d0                	add    %edx,%eax
  802da3:	01 c0                	add    %eax,%eax
  802da5:	01 d8                	add    %ebx,%eax
  802da7:	83 e8 30             	sub    $0x30,%eax
  802daa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802dad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802db1:	0f b6 00             	movzbl (%rax),%eax
  802db4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802db7:	83 fb 2f             	cmp    $0x2f,%ebx
  802dba:	7e 0c                	jle    802dc8 <vprintfmt+0x105>
  802dbc:	83 fb 39             	cmp    $0x39,%ebx
  802dbf:	7f 07                	jg     802dc8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802dc1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802dc6:	eb d1                	jmp    802d99 <vprintfmt+0xd6>
			goto process_precision;
  802dc8:	eb 58                	jmp    802e22 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802dca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dcd:	83 f8 30             	cmp    $0x30,%eax
  802dd0:	73 17                	jae    802de9 <vprintfmt+0x126>
  802dd2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802dd9:	89 c0                	mov    %eax,%eax
  802ddb:	48 01 d0             	add    %rdx,%rax
  802dde:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802de1:	83 c2 08             	add    $0x8,%edx
  802de4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802de7:	eb 0f                	jmp    802df8 <vprintfmt+0x135>
  802de9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ded:	48 89 d0             	mov    %rdx,%rax
  802df0:	48 83 c2 08          	add    $0x8,%rdx
  802df4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802df8:	8b 00                	mov    (%rax),%eax
  802dfa:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802dfd:	eb 23                	jmp    802e22 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802dff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e03:	79 0c                	jns    802e11 <vprintfmt+0x14e>
				width = 0;
  802e05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802e0c:	e9 3b ff ff ff       	jmpq   802d4c <vprintfmt+0x89>
  802e11:	e9 36 ff ff ff       	jmpq   802d4c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802e16:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802e1d:	e9 2a ff ff ff       	jmpq   802d4c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802e22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802e26:	79 12                	jns    802e3a <vprintfmt+0x177>
				width = precision, precision = -1;
  802e28:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802e2b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802e2e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802e35:	e9 12 ff ff ff       	jmpq   802d4c <vprintfmt+0x89>
  802e3a:	e9 0d ff ff ff       	jmpq   802d4c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802e3f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802e43:	e9 04 ff ff ff       	jmpq   802d4c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e4b:	83 f8 30             	cmp    $0x30,%eax
  802e4e:	73 17                	jae    802e67 <vprintfmt+0x1a4>
  802e50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e57:	89 c0                	mov    %eax,%eax
  802e59:	48 01 d0             	add    %rdx,%rax
  802e5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802e5f:	83 c2 08             	add    $0x8,%edx
  802e62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802e65:	eb 0f                	jmp    802e76 <vprintfmt+0x1b3>
  802e67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802e6b:	48 89 d0             	mov    %rdx,%rax
  802e6e:	48 83 c2 08          	add    $0x8,%rdx
  802e72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802e76:	8b 10                	mov    (%rax),%edx
  802e78:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802e7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802e80:	48 89 ce             	mov    %rcx,%rsi
  802e83:	89 d7                	mov    %edx,%edi
  802e85:	ff d0                	callq  *%rax
			break;
  802e87:	e9 40 03 00 00       	jmpq   8031cc <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802e8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e8f:	83 f8 30             	cmp    $0x30,%eax
  802e92:	73 17                	jae    802eab <vprintfmt+0x1e8>
  802e94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802e98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802e9b:	89 c0                	mov    %eax,%eax
  802e9d:	48 01 d0             	add    %rdx,%rax
  802ea0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802ea3:	83 c2 08             	add    $0x8,%edx
  802ea6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802ea9:	eb 0f                	jmp    802eba <vprintfmt+0x1f7>
  802eab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802eaf:	48 89 d0             	mov    %rdx,%rax
  802eb2:	48 83 c2 08          	add    $0x8,%rdx
  802eb6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802eba:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802ebc:	85 db                	test   %ebx,%ebx
  802ebe:	79 02                	jns    802ec2 <vprintfmt+0x1ff>
				err = -err;
  802ec0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802ec2:	83 fb 15             	cmp    $0x15,%ebx
  802ec5:	7f 16                	jg     802edd <vprintfmt+0x21a>
  802ec7:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  802ece:	00 00 00 
  802ed1:	48 63 d3             	movslq %ebx,%rdx
  802ed4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802ed8:	4d 85 e4             	test   %r12,%r12
  802edb:	75 2e                	jne    802f0b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802edd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802ee1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ee5:	89 d9                	mov    %ebx,%ecx
  802ee7:	48 ba 81 42 80 00 00 	movabs $0x804281,%rdx
  802eee:	00 00 00 
  802ef1:	48 89 c7             	mov    %rax,%rdi
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef9:	49 b8 db 31 80 00 00 	movabs $0x8031db,%r8
  802f00:	00 00 00 
  802f03:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802f06:	e9 c1 02 00 00       	jmpq   8031cc <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802f0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802f0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802f13:	4c 89 e1             	mov    %r12,%rcx
  802f16:	48 ba 8a 42 80 00 00 	movabs $0x80428a,%rdx
  802f1d:	00 00 00 
  802f20:	48 89 c7             	mov    %rax,%rdi
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
  802f28:	49 b8 db 31 80 00 00 	movabs $0x8031db,%r8
  802f2f:	00 00 00 
  802f32:	41 ff d0             	callq  *%r8
			break;
  802f35:	e9 92 02 00 00       	jmpq   8031cc <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802f3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f3d:	83 f8 30             	cmp    $0x30,%eax
  802f40:	73 17                	jae    802f59 <vprintfmt+0x296>
  802f42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f49:	89 c0                	mov    %eax,%eax
  802f4b:	48 01 d0             	add    %rdx,%rax
  802f4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f51:	83 c2 08             	add    $0x8,%edx
  802f54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f57:	eb 0f                	jmp    802f68 <vprintfmt+0x2a5>
  802f59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f5d:	48 89 d0             	mov    %rdx,%rax
  802f60:	48 83 c2 08          	add    $0x8,%rdx
  802f64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802f68:	4c 8b 20             	mov    (%rax),%r12
  802f6b:	4d 85 e4             	test   %r12,%r12
  802f6e:	75 0a                	jne    802f7a <vprintfmt+0x2b7>
				p = "(null)";
  802f70:	49 bc 8d 42 80 00 00 	movabs $0x80428d,%r12
  802f77:	00 00 00 
			if (width > 0 && padc != '-')
  802f7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802f7e:	7e 3f                	jle    802fbf <vprintfmt+0x2fc>
  802f80:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802f84:	74 39                	je     802fbf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802f86:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802f89:	48 98                	cltq   
  802f8b:	48 89 c6             	mov    %rax,%rsi
  802f8e:	4c 89 e7             	mov    %r12,%rdi
  802f91:	48 b8 87 34 80 00 00 	movabs $0x803487,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
  802f9d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802fa0:	eb 17                	jmp    802fb9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802fa2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802fa6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802faa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fae:	48 89 ce             	mov    %rcx,%rsi
  802fb1:	89 d7                	mov    %edx,%edi
  802fb3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802fb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802fb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fbd:	7f e3                	jg     802fa2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802fbf:	eb 37                	jmp    802ff8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802fc1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802fc5:	74 1e                	je     802fe5 <vprintfmt+0x322>
  802fc7:	83 fb 1f             	cmp    $0x1f,%ebx
  802fca:	7e 05                	jle    802fd1 <vprintfmt+0x30e>
  802fcc:	83 fb 7e             	cmp    $0x7e,%ebx
  802fcf:	7e 14                	jle    802fe5 <vprintfmt+0x322>
					putch('?', putdat);
  802fd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fd9:	48 89 d6             	mov    %rdx,%rsi
  802fdc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802fe1:	ff d0                	callq  *%rax
  802fe3:	eb 0f                	jmp    802ff4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802fe5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802fe9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802fed:	48 89 d6             	mov    %rdx,%rsi
  802ff0:	89 df                	mov    %ebx,%edi
  802ff2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802ff4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802ff8:	4c 89 e0             	mov    %r12,%rax
  802ffb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802fff:	0f b6 00             	movzbl (%rax),%eax
  803002:	0f be d8             	movsbl %al,%ebx
  803005:	85 db                	test   %ebx,%ebx
  803007:	74 10                	je     803019 <vprintfmt+0x356>
  803009:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80300d:	78 b2                	js     802fc1 <vprintfmt+0x2fe>
  80300f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803013:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803017:	79 a8                	jns    802fc1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803019:	eb 16                	jmp    803031 <vprintfmt+0x36e>
				putch(' ', putdat);
  80301b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80301f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803023:	48 89 d6             	mov    %rdx,%rsi
  803026:	bf 20 00 00 00       	mov    $0x20,%edi
  80302b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80302d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803031:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803035:	7f e4                	jg     80301b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  803037:	e9 90 01 00 00       	jmpq   8031cc <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80303c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803040:	be 03 00 00 00       	mov    $0x3,%esi
  803045:	48 89 c7             	mov    %rax,%rdi
  803048:	48 b8 b3 2b 80 00 00 	movabs $0x802bb3,%rax
  80304f:	00 00 00 
  803052:	ff d0                	callq  *%rax
  803054:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305c:	48 85 c0             	test   %rax,%rax
  80305f:	79 1d                	jns    80307e <vprintfmt+0x3bb>
				putch('-', putdat);
  803061:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803065:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803069:	48 89 d6             	mov    %rdx,%rsi
  80306c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803071:	ff d0                	callq  *%rax
				num = -(long long) num;
  803073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803077:	48 f7 d8             	neg    %rax
  80307a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80307e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803085:	e9 d5 00 00 00       	jmpq   80315f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80308a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80308e:	be 03 00 00 00       	mov    $0x3,%esi
  803093:	48 89 c7             	mov    %rax,%rdi
  803096:	48 b8 a3 2a 80 00 00 	movabs $0x802aa3,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
  8030a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8030a6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8030ad:	e9 ad 00 00 00       	jmpq   80315f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8030b2:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8030b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8030b9:	89 d6                	mov    %edx,%esi
  8030bb:	48 89 c7             	mov    %rax,%rdi
  8030be:	48 b8 b3 2b 80 00 00 	movabs $0x802bb3,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
  8030ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8030ce:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8030d5:	e9 85 00 00 00       	jmpq   80315f <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8030da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030e2:	48 89 d6             	mov    %rdx,%rsi
  8030e5:	bf 30 00 00 00       	mov    $0x30,%edi
  8030ea:	ff d0                	callq  *%rax
			putch('x', putdat);
  8030ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8030f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030f4:	48 89 d6             	mov    %rdx,%rsi
  8030f7:	bf 78 00 00 00       	mov    $0x78,%edi
  8030fc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8030fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803101:	83 f8 30             	cmp    $0x30,%eax
  803104:	73 17                	jae    80311d <vprintfmt+0x45a>
  803106:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80310a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80310d:	89 c0                	mov    %eax,%eax
  80310f:	48 01 d0             	add    %rdx,%rax
  803112:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803115:	83 c2 08             	add    $0x8,%edx
  803118:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80311b:	eb 0f                	jmp    80312c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80311d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803121:	48 89 d0             	mov    %rdx,%rax
  803124:	48 83 c2 08          	add    $0x8,%rdx
  803128:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80312c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80312f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803133:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80313a:	eb 23                	jmp    80315f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80313c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803140:	be 03 00 00 00       	mov    $0x3,%esi
  803145:	48 89 c7             	mov    %rax,%rdi
  803148:	48 b8 a3 2a 80 00 00 	movabs $0x802aa3,%rax
  80314f:	00 00 00 
  803152:	ff d0                	callq  *%rax
  803154:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803158:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80315f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803164:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803167:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80316a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80316e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803172:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803176:	45 89 c1             	mov    %r8d,%r9d
  803179:	41 89 f8             	mov    %edi,%r8d
  80317c:	48 89 c7             	mov    %rax,%rdi
  80317f:	48 b8 e8 29 80 00 00 	movabs $0x8029e8,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
			break;
  80318b:	eb 3f                	jmp    8031cc <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80318d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803191:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803195:	48 89 d6             	mov    %rdx,%rsi
  803198:	89 df                	mov    %ebx,%edi
  80319a:	ff d0                	callq  *%rax
			break;
  80319c:	eb 2e                	jmp    8031cc <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80319e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031a2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031a6:	48 89 d6             	mov    %rdx,%rsi
  8031a9:	bf 25 00 00 00       	mov    $0x25,%edi
  8031ae:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8031b0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031b5:	eb 05                	jmp    8031bc <vprintfmt+0x4f9>
  8031b7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8031bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8031c0:	48 83 e8 01          	sub    $0x1,%rax
  8031c4:	0f b6 00             	movzbl (%rax),%eax
  8031c7:	3c 25                	cmp    $0x25,%al
  8031c9:	75 ec                	jne    8031b7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8031cb:	90                   	nop
		}
	}
  8031cc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8031cd:	e9 43 fb ff ff       	jmpq   802d15 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8031d2:	48 83 c4 60          	add    $0x60,%rsp
  8031d6:	5b                   	pop    %rbx
  8031d7:	41 5c                	pop    %r12
  8031d9:	5d                   	pop    %rbp
  8031da:	c3                   	retq   

00000000008031db <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8031db:	55                   	push   %rbp
  8031dc:	48 89 e5             	mov    %rsp,%rbp
  8031df:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8031e6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8031ed:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8031f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803202:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803209:	84 c0                	test   %al,%al
  80320b:	74 20                	je     80322d <printfmt+0x52>
  80320d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803211:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803215:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803219:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80321d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803221:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803225:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803229:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80322d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803234:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80323b:	00 00 00 
  80323e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803245:	00 00 00 
  803248:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80324c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803253:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80325a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803261:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803268:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80326f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803276:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80327d:	48 89 c7             	mov    %rax,%rdi
  803280:	48 b8 c3 2c 80 00 00 	movabs $0x802cc3,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80328c:	c9                   	leaveq 
  80328d:	c3                   	retq   

000000000080328e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80328e:	55                   	push   %rbp
  80328f:	48 89 e5             	mov    %rsp,%rbp
  803292:	48 83 ec 10          	sub    $0x10,%rsp
  803296:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803299:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80329d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a1:	8b 40 10             	mov    0x10(%rax),%eax
  8032a4:	8d 50 01             	lea    0x1(%rax),%edx
  8032a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ab:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8032ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b2:	48 8b 10             	mov    (%rax),%rdx
  8032b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8032bd:	48 39 c2             	cmp    %rax,%rdx
  8032c0:	73 17                	jae    8032d9 <sprintputch+0x4b>
		*b->buf++ = ch;
  8032c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c6:	48 8b 00             	mov    (%rax),%rax
  8032c9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8032cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032d1:	48 89 0a             	mov    %rcx,(%rdx)
  8032d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d7:	88 10                	mov    %dl,(%rax)
}
  8032d9:	c9                   	leaveq 
  8032da:	c3                   	retq   

00000000008032db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8032db:	55                   	push   %rbp
  8032dc:	48 89 e5             	mov    %rsp,%rbp
  8032df:	48 83 ec 50          	sub    $0x50,%rsp
  8032e3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8032e7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8032ea:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8032ee:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8032f2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8032f6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8032fa:	48 8b 0a             	mov    (%rdx),%rcx
  8032fd:	48 89 08             	mov    %rcx,(%rax)
  803300:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803304:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803308:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80330c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803310:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803314:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803318:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80331b:	48 98                	cltq   
  80331d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803321:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803325:	48 01 d0             	add    %rdx,%rax
  803328:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80332c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803333:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803338:	74 06                	je     803340 <vsnprintf+0x65>
  80333a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80333e:	7f 07                	jg     803347 <vsnprintf+0x6c>
		return -E_INVAL;
  803340:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803345:	eb 2f                	jmp    803376 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803347:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80334b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80334f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803353:	48 89 c6             	mov    %rax,%rsi
  803356:	48 bf 8e 32 80 00 00 	movabs $0x80328e,%rdi
  80335d:	00 00 00 
  803360:	48 b8 c3 2c 80 00 00 	movabs $0x802cc3,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80336c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803370:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803373:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803376:	c9                   	leaveq 
  803377:	c3                   	retq   

0000000000803378 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803378:	55                   	push   %rbp
  803379:	48 89 e5             	mov    %rsp,%rbp
  80337c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803383:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80338a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803390:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803397:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80339e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033a5:	84 c0                	test   %al,%al
  8033a7:	74 20                	je     8033c9 <snprintf+0x51>
  8033a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8033c9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8033d0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8033d7:	00 00 00 
  8033da:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033e1:	00 00 00 
  8033e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033e8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033ef:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8033fd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803404:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80340b:	48 8b 0a             	mov    (%rdx),%rcx
  80340e:	48 89 08             	mov    %rcx,(%rax)
  803411:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803415:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803419:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80341d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803421:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803428:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80342f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803435:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80343c:	48 89 c7             	mov    %rax,%rdi
  80343f:	48 b8 db 32 80 00 00 	movabs $0x8032db,%rax
  803446:	00 00 00 
  803449:	ff d0                	callq  *%rax
  80344b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803451:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 18          	sub    $0x18,%rsp
  803461:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803465:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80346c:	eb 09                	jmp    803477 <strlen+0x1e>
		n++;
  80346e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803472:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80347b:	0f b6 00             	movzbl (%rax),%eax
  80347e:	84 c0                	test   %al,%al
  803480:	75 ec                	jne    80346e <strlen+0x15>
		n++;
	return n;
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803485:	c9                   	leaveq 
  803486:	c3                   	retq   

0000000000803487 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803487:	55                   	push   %rbp
  803488:	48 89 e5             	mov    %rsp,%rbp
  80348b:	48 83 ec 20          	sub    $0x20,%rsp
  80348f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803493:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803497:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80349e:	eb 0e                	jmp    8034ae <strnlen+0x27>
		n++;
  8034a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8034a4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034a9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8034ae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034b3:	74 0b                	je     8034c0 <strnlen+0x39>
  8034b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b9:	0f b6 00             	movzbl (%rax),%eax
  8034bc:	84 c0                	test   %al,%al
  8034be:	75 e0                	jne    8034a0 <strnlen+0x19>
		n++;
	return n;
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034c3:	c9                   	leaveq 
  8034c4:	c3                   	retq   

00000000008034c5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8034c5:	55                   	push   %rbp
  8034c6:	48 89 e5             	mov    %rsp,%rbp
  8034c9:	48 83 ec 20          	sub    $0x20,%rsp
  8034cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8034d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8034dd:	90                   	nop
  8034de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8034e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8034ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034ee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8034f2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8034f6:	0f b6 12             	movzbl (%rdx),%edx
  8034f9:	88 10                	mov    %dl,(%rax)
  8034fb:	0f b6 00             	movzbl (%rax),%eax
  8034fe:	84 c0                	test   %al,%al
  803500:	75 dc                	jne    8034de <strcpy+0x19>
		/* do nothing */;
	return ret;
  803502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   

0000000000803508 <strcat>:

char *
strcat(char *dst, const char *src)
{
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	48 83 ec 20          	sub    $0x20,%rsp
  803510:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803514:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351c:	48 89 c7             	mov    %rax,%rdi
  80351f:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
  80352b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80352e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803531:	48 63 d0             	movslq %eax,%rdx
  803534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803538:	48 01 c2             	add    %rax,%rdx
  80353b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353f:	48 89 c6             	mov    %rax,%rsi
  803542:	48 89 d7             	mov    %rdx,%rdi
  803545:	48 b8 c5 34 80 00 00 	movabs $0x8034c5,%rax
  80354c:	00 00 00 
  80354f:	ff d0                	callq  *%rax
	return dst;
  803551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803555:	c9                   	leaveq 
  803556:	c3                   	retq   

0000000000803557 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803557:	55                   	push   %rbp
  803558:	48 89 e5             	mov    %rsp,%rbp
  80355b:	48 83 ec 28          	sub    $0x28,%rsp
  80355f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803563:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803567:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80356b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80356f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803573:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80357a:	00 
  80357b:	eb 2a                	jmp    8035a7 <strncpy+0x50>
		*dst++ = *src;
  80357d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803581:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803585:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803589:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80358d:	0f b6 12             	movzbl (%rdx),%edx
  803590:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803592:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803596:	0f b6 00             	movzbl (%rax),%eax
  803599:	84 c0                	test   %al,%al
  80359b:	74 05                	je     8035a2 <strncpy+0x4b>
			src++;
  80359d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8035a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ab:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8035af:	72 cc                	jb     80357d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8035b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8035b5:	c9                   	leaveq 
  8035b6:	c3                   	retq   

00000000008035b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8035b7:	55                   	push   %rbp
  8035b8:	48 89 e5             	mov    %rsp,%rbp
  8035bb:	48 83 ec 28          	sub    $0x28,%rsp
  8035bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8035cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8035d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035d8:	74 3d                	je     803617 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8035da:	eb 1d                	jmp    8035f9 <strlcpy+0x42>
			*dst++ = *src++;
  8035dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8035e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035ec:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8035f0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8035f4:	0f b6 12             	movzbl (%rdx),%edx
  8035f7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8035f9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8035fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803603:	74 0b                	je     803610 <strlcpy+0x59>
  803605:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803609:	0f b6 00             	movzbl (%rax),%eax
  80360c:	84 c0                	test   %al,%al
  80360e:	75 cc                	jne    8035dc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  803610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803614:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  803617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361f:	48 29 c2             	sub    %rax,%rdx
  803622:	48 89 d0             	mov    %rdx,%rax
}
  803625:	c9                   	leaveq 
  803626:	c3                   	retq   

0000000000803627 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  803627:	55                   	push   %rbp
  803628:	48 89 e5             	mov    %rsp,%rbp
  80362b:	48 83 ec 10          	sub    $0x10,%rsp
  80362f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803633:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  803637:	eb 0a                	jmp    803643 <strcmp+0x1c>
		p++, q++;
  803639:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80363e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  803643:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803647:	0f b6 00             	movzbl (%rax),%eax
  80364a:	84 c0                	test   %al,%al
  80364c:	74 12                	je     803660 <strcmp+0x39>
  80364e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803652:	0f b6 10             	movzbl (%rax),%edx
  803655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803659:	0f b6 00             	movzbl (%rax),%eax
  80365c:	38 c2                	cmp    %al,%dl
  80365e:	74 d9                	je     803639 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803664:	0f b6 00             	movzbl (%rax),%eax
  803667:	0f b6 d0             	movzbl %al,%edx
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	0f b6 00             	movzbl (%rax),%eax
  803671:	0f b6 c0             	movzbl %al,%eax
  803674:	29 c2                	sub    %eax,%edx
  803676:	89 d0                	mov    %edx,%eax
}
  803678:	c9                   	leaveq 
  803679:	c3                   	retq   

000000000080367a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80367a:	55                   	push   %rbp
  80367b:	48 89 e5             	mov    %rsp,%rbp
  80367e:	48 83 ec 18          	sub    $0x18,%rsp
  803682:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803686:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80368a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80368e:	eb 0f                	jmp    80369f <strncmp+0x25>
		n--, p++, q++;
  803690:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803695:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80369a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80369f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036a4:	74 1d                	je     8036c3 <strncmp+0x49>
  8036a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036aa:	0f b6 00             	movzbl (%rax),%eax
  8036ad:	84 c0                	test   %al,%al
  8036af:	74 12                	je     8036c3 <strncmp+0x49>
  8036b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b5:	0f b6 10             	movzbl (%rax),%edx
  8036b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bc:	0f b6 00             	movzbl (%rax),%eax
  8036bf:	38 c2                	cmp    %al,%dl
  8036c1:	74 cd                	je     803690 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8036c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8036c8:	75 07                	jne    8036d1 <strncmp+0x57>
		return 0;
  8036ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cf:	eb 18                	jmp    8036e9 <strncmp+0x6f>
	else
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

00000000008036eb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8036eb:	55                   	push   %rbp
  8036ec:	48 89 e5             	mov    %rsp,%rbp
  8036ef:	48 83 ec 0c          	sub    $0xc,%rsp
  8036f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036f7:	89 f0                	mov    %esi,%eax
  8036f9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8036fc:	eb 17                	jmp    803715 <strchr+0x2a>
		if (*s == c)
  8036fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803702:	0f b6 00             	movzbl (%rax),%eax
  803705:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803708:	75 06                	jne    803710 <strchr+0x25>
			return (char *) s;
  80370a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370e:	eb 15                	jmp    803725 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  803710:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803719:	0f b6 00             	movzbl (%rax),%eax
  80371c:	84 c0                	test   %al,%al
  80371e:	75 de                	jne    8036fe <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  803720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803725:	c9                   	leaveq 
  803726:	c3                   	retq   

0000000000803727 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  803727:	55                   	push   %rbp
  803728:	48 89 e5             	mov    %rsp,%rbp
  80372b:	48 83 ec 0c          	sub    $0xc,%rsp
  80372f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803733:	89 f0                	mov    %esi,%eax
  803735:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  803738:	eb 13                	jmp    80374d <strfind+0x26>
		if (*s == c)
  80373a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373e:	0f b6 00             	movzbl (%rax),%eax
  803741:	3a 45 f4             	cmp    -0xc(%rbp),%al
  803744:	75 02                	jne    803748 <strfind+0x21>
			break;
  803746:	eb 10                	jmp    803758 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  803748:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80374d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803751:	0f b6 00             	movzbl (%rax),%eax
  803754:	84 c0                	test   %al,%al
  803756:	75 e2                	jne    80373a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  803758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80375c:	c9                   	leaveq 
  80375d:	c3                   	retq   

000000000080375e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80375e:	55                   	push   %rbp
  80375f:	48 89 e5             	mov    %rsp,%rbp
  803762:	48 83 ec 18          	sub    $0x18,%rsp
  803766:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80376a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80376d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803771:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803776:	75 06                	jne    80377e <memset+0x20>
		return v;
  803778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377c:	eb 69                	jmp    8037e7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80377e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803782:	83 e0 03             	and    $0x3,%eax
  803785:	48 85 c0             	test   %rax,%rax
  803788:	75 48                	jne    8037d2 <memset+0x74>
  80378a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378e:	83 e0 03             	and    $0x3,%eax
  803791:	48 85 c0             	test   %rax,%rax
  803794:	75 3c                	jne    8037d2 <memset+0x74>
		c &= 0xFF;
  803796:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80379d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037a0:	c1 e0 18             	shl    $0x18,%eax
  8037a3:	89 c2                	mov    %eax,%edx
  8037a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037a8:	c1 e0 10             	shl    $0x10,%eax
  8037ab:	09 c2                	or     %eax,%edx
  8037ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b0:	c1 e0 08             	shl    $0x8,%eax
  8037b3:	09 d0                	or     %edx,%eax
  8037b5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8037b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bc:	48 c1 e8 02          	shr    $0x2,%rax
  8037c0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8037c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037ca:	48 89 d7             	mov    %rdx,%rdi
  8037cd:	fc                   	cld    
  8037ce:	f3 ab                	rep stos %eax,%es:(%rdi)
  8037d0:	eb 11                	jmp    8037e3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8037d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037dd:	48 89 d7             	mov    %rdx,%rdi
  8037e0:	fc                   	cld    
  8037e1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8037e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e7:	c9                   	leaveq 
  8037e8:	c3                   	retq   

00000000008037e9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8037e9:	55                   	push   %rbp
  8037ea:	48 89 e5             	mov    %rsp,%rbp
  8037ed:	48 83 ec 28          	sub    $0x28,%rsp
  8037f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8037fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803801:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  803805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803809:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80380d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803811:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803815:	0f 83 88 00 00 00    	jae    8038a3 <memmove+0xba>
  80381b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803823:	48 01 d0             	add    %rdx,%rax
  803826:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80382a:	76 77                	jbe    8038a3 <memmove+0xba>
		s += n;
  80382c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803830:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  803834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803838:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80383c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803840:	83 e0 03             	and    $0x3,%eax
  803843:	48 85 c0             	test   %rax,%rax
  803846:	75 3b                	jne    803883 <memmove+0x9a>
  803848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80384c:	83 e0 03             	and    $0x3,%eax
  80384f:	48 85 c0             	test   %rax,%rax
  803852:	75 2f                	jne    803883 <memmove+0x9a>
  803854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803858:	83 e0 03             	and    $0x3,%eax
  80385b:	48 85 c0             	test   %rax,%rax
  80385e:	75 23                	jne    803883 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803860:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803864:	48 83 e8 04          	sub    $0x4,%rax
  803868:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80386c:	48 83 ea 04          	sub    $0x4,%rdx
  803870:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803874:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 89 d6             	mov    %rdx,%rsi
  80387e:	fd                   	std    
  80387f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803881:	eb 1d                	jmp    8038a0 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  803883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803887:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80388b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803897:	48 89 d7             	mov    %rdx,%rdi
  80389a:	48 89 c1             	mov    %rax,%rcx
  80389d:	fd                   	std    
  80389e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8038a0:	fc                   	cld    
  8038a1:	eb 57                	jmp    8038fa <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8038a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a7:	83 e0 03             	and    $0x3,%eax
  8038aa:	48 85 c0             	test   %rax,%rax
  8038ad:	75 36                	jne    8038e5 <memmove+0xfc>
  8038af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b3:	83 e0 03             	and    $0x3,%eax
  8038b6:	48 85 c0             	test   %rax,%rax
  8038b9:	75 2a                	jne    8038e5 <memmove+0xfc>
  8038bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038bf:	83 e0 03             	and    $0x3,%eax
  8038c2:	48 85 c0             	test   %rax,%rax
  8038c5:	75 1e                	jne    8038e5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8038c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cb:	48 c1 e8 02          	shr    $0x2,%rax
  8038cf:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8038d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038da:	48 89 c7             	mov    %rax,%rdi
  8038dd:	48 89 d6             	mov    %rdx,%rsi
  8038e0:	fc                   	cld    
  8038e1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8038e3:	eb 15                	jmp    8038fa <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038ed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8038f1:	48 89 c7             	mov    %rax,%rdi
  8038f4:	48 89 d6             	mov    %rdx,%rsi
  8038f7:	fc                   	cld    
  8038f8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8038fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8038fe:	c9                   	leaveq 
  8038ff:	c3                   	retq   

0000000000803900 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803900:	55                   	push   %rbp
  803901:	48 89 e5             	mov    %rsp,%rbp
  803904:	48 83 ec 18          	sub    $0x18,%rsp
  803908:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80390c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803910:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803914:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803918:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80391c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803920:	48 89 ce             	mov    %rcx,%rsi
  803923:	48 89 c7             	mov    %rax,%rdi
  803926:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  80392d:	00 00 00 
  803930:	ff d0                	callq  *%rax
}
  803932:	c9                   	leaveq 
  803933:	c3                   	retq   

0000000000803934 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803934:	55                   	push   %rbp
  803935:	48 89 e5             	mov    %rsp,%rbp
  803938:	48 83 ec 28          	sub    $0x28,%rsp
  80393c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803940:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803944:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803950:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803954:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803958:	eb 36                	jmp    803990 <memcmp+0x5c>
		if (*s1 != *s2)
  80395a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80395e:	0f b6 10             	movzbl (%rax),%edx
  803961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803965:	0f b6 00             	movzbl (%rax),%eax
  803968:	38 c2                	cmp    %al,%dl
  80396a:	74 1a                	je     803986 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80396c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803970:	0f b6 00             	movzbl (%rax),%eax
  803973:	0f b6 d0             	movzbl %al,%edx
  803976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397a:	0f b6 00             	movzbl (%rax),%eax
  80397d:	0f b6 c0             	movzbl %al,%eax
  803980:	29 c2                	sub    %eax,%edx
  803982:	89 d0                	mov    %edx,%eax
  803984:	eb 20                	jmp    8039a6 <memcmp+0x72>
		s1++, s2++;
  803986:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80398b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803994:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803998:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80399c:	48 85 c0             	test   %rax,%rax
  80399f:	75 b9                	jne    80395a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8039a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039a6:	c9                   	leaveq 
  8039a7:	c3                   	retq   

00000000008039a8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8039a8:	55                   	push   %rbp
  8039a9:	48 89 e5             	mov    %rsp,%rbp
  8039ac:	48 83 ec 28          	sub    $0x28,%rsp
  8039b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039b4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8039b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8039bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c3:	48 01 d0             	add    %rdx,%rax
  8039c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8039ca:	eb 15                	jmp    8039e1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8039cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d0:	0f b6 10             	movzbl (%rax),%edx
  8039d3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8039d6:	38 c2                	cmp    %al,%dl
  8039d8:	75 02                	jne    8039dc <memfind+0x34>
			break;
  8039da:	eb 0f                	jmp    8039eb <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8039dc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8039e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8039e9:	72 e1                	jb     8039cc <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8039eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8039ef:	c9                   	leaveq 
  8039f0:	c3                   	retq   

00000000008039f1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8039f1:	55                   	push   %rbp
  8039f2:	48 89 e5             	mov    %rsp,%rbp
  8039f5:	48 83 ec 34          	sub    $0x34,%rsp
  8039f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a01:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803a0b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803a12:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a13:	eb 05                	jmp    803a1a <strtol+0x29>
		s++;
  803a15:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1e:	0f b6 00             	movzbl (%rax),%eax
  803a21:	3c 20                	cmp    $0x20,%al
  803a23:	74 f0                	je     803a15 <strtol+0x24>
  803a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a29:	0f b6 00             	movzbl (%rax),%eax
  803a2c:	3c 09                	cmp    $0x9,%al
  803a2e:	74 e5                	je     803a15 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a34:	0f b6 00             	movzbl (%rax),%eax
  803a37:	3c 2b                	cmp    $0x2b,%al
  803a39:	75 07                	jne    803a42 <strtol+0x51>
		s++;
  803a3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a40:	eb 17                	jmp    803a59 <strtol+0x68>
	else if (*s == '-')
  803a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a46:	0f b6 00             	movzbl (%rax),%eax
  803a49:	3c 2d                	cmp    $0x2d,%al
  803a4b:	75 0c                	jne    803a59 <strtol+0x68>
		s++, neg = 1;
  803a4d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803a52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803a59:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a5d:	74 06                	je     803a65 <strtol+0x74>
  803a5f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803a63:	75 28                	jne    803a8d <strtol+0x9c>
  803a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a69:	0f b6 00             	movzbl (%rax),%eax
  803a6c:	3c 30                	cmp    $0x30,%al
  803a6e:	75 1d                	jne    803a8d <strtol+0x9c>
  803a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a74:	48 83 c0 01          	add    $0x1,%rax
  803a78:	0f b6 00             	movzbl (%rax),%eax
  803a7b:	3c 78                	cmp    $0x78,%al
  803a7d:	75 0e                	jne    803a8d <strtol+0x9c>
		s += 2, base = 16;
  803a7f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803a84:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803a8b:	eb 2c                	jmp    803ab9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803a8d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803a91:	75 19                	jne    803aac <strtol+0xbb>
  803a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a97:	0f b6 00             	movzbl (%rax),%eax
  803a9a:	3c 30                	cmp    $0x30,%al
  803a9c:	75 0e                	jne    803aac <strtol+0xbb>
		s++, base = 8;
  803a9e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803aa3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803aaa:	eb 0d                	jmp    803ab9 <strtol+0xc8>
	else if (base == 0)
  803aac:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803ab0:	75 07                	jne    803ab9 <strtol+0xc8>
		base = 10;
  803ab2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803ab9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803abd:	0f b6 00             	movzbl (%rax),%eax
  803ac0:	3c 2f                	cmp    $0x2f,%al
  803ac2:	7e 1d                	jle    803ae1 <strtol+0xf0>
  803ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac8:	0f b6 00             	movzbl (%rax),%eax
  803acb:	3c 39                	cmp    $0x39,%al
  803acd:	7f 12                	jg     803ae1 <strtol+0xf0>
			dig = *s - '0';
  803acf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad3:	0f b6 00             	movzbl (%rax),%eax
  803ad6:	0f be c0             	movsbl %al,%eax
  803ad9:	83 e8 30             	sub    $0x30,%eax
  803adc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803adf:	eb 4e                	jmp    803b2f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae5:	0f b6 00             	movzbl (%rax),%eax
  803ae8:	3c 60                	cmp    $0x60,%al
  803aea:	7e 1d                	jle    803b09 <strtol+0x118>
  803aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af0:	0f b6 00             	movzbl (%rax),%eax
  803af3:	3c 7a                	cmp    $0x7a,%al
  803af5:	7f 12                	jg     803b09 <strtol+0x118>
			dig = *s - 'a' + 10;
  803af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afb:	0f b6 00             	movzbl (%rax),%eax
  803afe:	0f be c0             	movsbl %al,%eax
  803b01:	83 e8 57             	sub    $0x57,%eax
  803b04:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b07:	eb 26                	jmp    803b2f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803b09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0d:	0f b6 00             	movzbl (%rax),%eax
  803b10:	3c 40                	cmp    $0x40,%al
  803b12:	7e 48                	jle    803b5c <strtol+0x16b>
  803b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b18:	0f b6 00             	movzbl (%rax),%eax
  803b1b:	3c 5a                	cmp    $0x5a,%al
  803b1d:	7f 3d                	jg     803b5c <strtol+0x16b>
			dig = *s - 'A' + 10;
  803b1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b23:	0f b6 00             	movzbl (%rax),%eax
  803b26:	0f be c0             	movsbl %al,%eax
  803b29:	83 e8 37             	sub    $0x37,%eax
  803b2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803b2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b32:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803b35:	7c 02                	jl     803b39 <strtol+0x148>
			break;
  803b37:	eb 23                	jmp    803b5c <strtol+0x16b>
		s++, val = (val * base) + dig;
  803b39:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803b3e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803b41:	48 98                	cltq   
  803b43:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803b48:	48 89 c2             	mov    %rax,%rdx
  803b4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b4e:	48 98                	cltq   
  803b50:	48 01 d0             	add    %rdx,%rax
  803b53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803b57:	e9 5d ff ff ff       	jmpq   803ab9 <strtol+0xc8>

	if (endptr)
  803b5c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803b61:	74 0b                	je     803b6e <strtol+0x17d>
		*endptr = (char *) s;
  803b63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b67:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b6b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803b6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b72:	74 09                	je     803b7d <strtol+0x18c>
  803b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b78:	48 f7 d8             	neg    %rax
  803b7b:	eb 04                	jmp    803b81 <strtol+0x190>
  803b7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803b81:	c9                   	leaveq 
  803b82:	c3                   	retq   

0000000000803b83 <strstr>:

char * strstr(const char *in, const char *str)
{
  803b83:	55                   	push   %rbp
  803b84:	48 89 e5             	mov    %rsp,%rbp
  803b87:	48 83 ec 30          	sub    $0x30,%rsp
  803b8b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b8f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803b93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b97:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b9b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803b9f:	0f b6 00             	movzbl (%rax),%eax
  803ba2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803ba5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803ba9:	75 06                	jne    803bb1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803bab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803baf:	eb 6b                	jmp    803c1c <strstr+0x99>

	len = strlen(str);
  803bb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb5:	48 89 c7             	mov    %rax,%rdi
  803bb8:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  803bbf:	00 00 00 
  803bc2:	ff d0                	callq  *%rax
  803bc4:	48 98                	cltq   
  803bc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803bca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bd2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803bd6:	0f b6 00             	movzbl (%rax),%eax
  803bd9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803bdc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803be0:	75 07                	jne    803be9 <strstr+0x66>
				return (char *) 0;
  803be2:	b8 00 00 00 00       	mov    $0x0,%eax
  803be7:	eb 33                	jmp    803c1c <strstr+0x99>
		} while (sc != c);
  803be9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803bed:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803bf0:	75 d8                	jne    803bca <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bf6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803bfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfe:	48 89 ce             	mov    %rcx,%rsi
  803c01:	48 89 c7             	mov    %rax,%rdi
  803c04:	48 b8 7a 36 80 00 00 	movabs $0x80367a,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
  803c10:	85 c0                	test   %eax,%eax
  803c12:	75 b6                	jne    803bca <strstr+0x47>

	return (char *) (in - 1);
  803c14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c18:	48 83 e8 01          	sub    $0x1,%rax
}
  803c1c:	c9                   	leaveq 
  803c1d:	c3                   	retq   

0000000000803c1e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803c1e:	55                   	push   %rbp
  803c1f:	48 89 e5             	mov    %rsp,%rbp
  803c22:	48 83 ec 30          	sub    $0x30,%rsp
  803c26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803c32:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c39:	00 00 00 
  803c3c:	48 8b 00             	mov    (%rax),%rax
  803c3f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803c45:	85 c0                	test   %eax,%eax
  803c47:	75 3c                	jne    803c85 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803c49:	48 b8 98 02 80 00 00 	movabs $0x800298,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c5a:	48 63 d0             	movslq %eax,%rdx
  803c5d:	48 89 d0             	mov    %rdx,%rax
  803c60:	48 c1 e0 03          	shl    $0x3,%rax
  803c64:	48 01 d0             	add    %rdx,%rax
  803c67:	48 c1 e0 05          	shl    $0x5,%rax
  803c6b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c72:	00 00 00 
  803c75:	48 01 c2             	add    %rax,%rdx
  803c78:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c7f:	00 00 00 
  803c82:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803c85:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c8a:	75 0e                	jne    803c9a <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803c8c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803c93:	00 00 00 
  803c96:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803c9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c9e:	48 89 c7             	mov    %rax,%rdi
  803ca1:	48 b8 3d 05 80 00 00 	movabs $0x80053d,%rax
  803ca8:	00 00 00 
  803cab:	ff d0                	callq  *%rax
  803cad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803cb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb4:	79 19                	jns    803ccf <ipc_recv+0xb1>
		*from_env_store = 0;
  803cb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cba:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccd:	eb 53                	jmp    803d22 <ipc_recv+0x104>
	}
	if(from_env_store)
  803ccf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803cd4:	74 19                	je     803cef <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803cd6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cdd:	00 00 00 
  803ce0:	48 8b 00             	mov    (%rax),%rax
  803ce3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ced:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803cef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cf4:	74 19                	je     803d0f <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803cf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cfd:	00 00 00 
  803d00:	48 8b 00             	mov    (%rax),%rax
  803d03:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803d09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803d0f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d16:	00 00 00 
  803d19:	48 8b 00             	mov    (%rax),%rax
  803d1c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803d22:	c9                   	leaveq 
  803d23:	c3                   	retq   

0000000000803d24 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d24:	55                   	push   %rbp
  803d25:	48 89 e5             	mov    %rsp,%rbp
  803d28:	48 83 ec 30          	sub    $0x30,%rsp
  803d2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d2f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d32:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803d36:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803d39:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d3e:	75 0e                	jne    803d4e <ipc_send+0x2a>
		pg = (void*)UTOP;
  803d40:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d47:	00 00 00 
  803d4a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803d4e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d51:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d54:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5b:	89 c7                	mov    %eax,%edi
  803d5d:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  803d64:	00 00 00 
  803d67:	ff d0                	callq  *%rax
  803d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803d6c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d70:	75 0c                	jne    803d7e <ipc_send+0x5a>
			sys_yield();
  803d72:	48 b8 d6 02 80 00 00 	movabs $0x8002d6,%rax
  803d79:	00 00 00 
  803d7c:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803d7e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803d82:	74 ca                	je     803d4e <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803d84:	c9                   	leaveq 
  803d85:	c3                   	retq   

0000000000803d86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d86:	55                   	push   %rbp
  803d87:	48 89 e5             	mov    %rsp,%rbp
  803d8a:	48 83 ec 14          	sub    $0x14,%rsp
  803d8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d98:	eb 5e                	jmp    803df8 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d9a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803da1:	00 00 00 
  803da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da7:	48 63 d0             	movslq %eax,%rdx
  803daa:	48 89 d0             	mov    %rdx,%rax
  803dad:	48 c1 e0 03          	shl    $0x3,%rax
  803db1:	48 01 d0             	add    %rdx,%rax
  803db4:	48 c1 e0 05          	shl    $0x5,%rax
  803db8:	48 01 c8             	add    %rcx,%rax
  803dbb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803dc1:	8b 00                	mov    (%rax),%eax
  803dc3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dc6:	75 2c                	jne    803df4 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803dc8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803dcf:	00 00 00 
  803dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd5:	48 63 d0             	movslq %eax,%rdx
  803dd8:	48 89 d0             	mov    %rdx,%rax
  803ddb:	48 c1 e0 03          	shl    $0x3,%rax
  803ddf:	48 01 d0             	add    %rdx,%rax
  803de2:	48 c1 e0 05          	shl    $0x5,%rax
  803de6:	48 01 c8             	add    %rcx,%rax
  803de9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803def:	8b 40 08             	mov    0x8(%rax),%eax
  803df2:	eb 12                	jmp    803e06 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803df4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803df8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803dff:	7e 99                	jle    803d9a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e06:	c9                   	leaveq 
  803e07:	c3                   	retq   

0000000000803e08 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e08:	55                   	push   %rbp
  803e09:	48 89 e5             	mov    %rsp,%rbp
  803e0c:	48 83 ec 18          	sub    $0x18,%rsp
  803e10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e18:	48 c1 e8 15          	shr    $0x15,%rax
  803e1c:	48 89 c2             	mov    %rax,%rdx
  803e1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e26:	01 00 00 
  803e29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e2d:	83 e0 01             	and    $0x1,%eax
  803e30:	48 85 c0             	test   %rax,%rax
  803e33:	75 07                	jne    803e3c <pageref+0x34>
		return 0;
  803e35:	b8 00 00 00 00       	mov    $0x0,%eax
  803e3a:	eb 53                	jmp    803e8f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e40:	48 c1 e8 0c          	shr    $0xc,%rax
  803e44:	48 89 c2             	mov    %rax,%rdx
  803e47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e4e:	01 00 00 
  803e51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e55:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e5d:	83 e0 01             	and    $0x1,%eax
  803e60:	48 85 c0             	test   %rax,%rax
  803e63:	75 07                	jne    803e6c <pageref+0x64>
		return 0;
  803e65:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6a:	eb 23                	jmp    803e8f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e70:	48 c1 e8 0c          	shr    $0xc,%rax
  803e74:	48 89 c2             	mov    %rax,%rdx
  803e77:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e7e:	00 00 00 
  803e81:	48 c1 e2 04          	shl    $0x4,%rdx
  803e85:	48 01 d0             	add    %rdx,%rax
  803e88:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e8c:	0f b7 c0             	movzwl %ax,%eax
}
  803e8f:	c9                   	leaveq 
  803e90:	c3                   	retq   
