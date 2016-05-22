
obj/user/faultalloc.debug:     file format elf64-x86-64


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
  80003c:	e8 3f 01 00 00       	callq  800180 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba 30 36 80 00 00 	movabs $0x803630,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 5b 36 80 00 00 	movabs $0x80365b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 2e 02 80 00 00 	movabs $0x80022e,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 70 36 80 00 00 	movabs $0x803670,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 cf 0e 80 00 00 	movabs $0x800ecf,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <umain>:

void
umain(int argc, char **argv)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800128:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  80012f:	00 00 00 
  800132:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf 91 36 80 00 00 	movabs $0x803691,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf 91 36 80 00 00 	movabs $0x803691,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  800179:	00 00 00 
  80017c:	ff d2                	callq  *%rdx
}
  80017e:	c9                   	leaveq 
  80017f:	c3                   	retq   

0000000000800180 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	48 83 ec 10          	sub    $0x10,%rsp
  800188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018f:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
  80019b:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a0:	48 63 d0             	movslq %eax,%rdx
  8001a3:	48 89 d0             	mov    %rdx,%rax
  8001a6:	48 c1 e0 03          	shl    $0x3,%rax
  8001aa:	48 01 d0             	add    %rdx,%rax
  8001ad:	48 c1 e0 05          	shl    $0x5,%rax
  8001b1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001b8:	00 00 00 
  8001bb:	48 01 c2             	add    %rax,%rdx
  8001be:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001c5:	00 00 00 
  8001c8:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	7e 14                	jle    8001e5 <libmain+0x65>
		binaryname = argv[0];
  8001d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d5:	48 8b 10             	mov    (%rax),%rdx
  8001d8:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001df:	00 00 00 
  8001e2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ec:	48 89 d6             	mov    %rdx,%rsi
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001fd:	48 b8 0b 02 80 00 00 	movabs $0x80020b,%rax
  800204:	00 00 00 
  800207:	ff d0                	callq  *%rax
}
  800209:	c9                   	leaveq 
  80020a:	c3                   	retq   

000000000080020b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020b:	55                   	push   %rbp
  80020c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80020f:	48 b8 39 20 80 00 00 	movabs $0x802039,%rax
  800216:	00 00 00 
  800219:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80021b:	bf 00 00 00 00       	mov    $0x0,%edi
  800220:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  800227:	00 00 00 
  80022a:	ff d0                	callq  *%rax

}
  80022c:	5d                   	pop    %rbp
  80022d:	c3                   	retq   

000000000080022e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022e:	55                   	push   %rbp
  80022f:	48 89 e5             	mov    %rsp,%rbp
  800232:	53                   	push   %rbx
  800233:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80023a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800241:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800247:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80024e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800255:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80025c:	84 c0                	test   %al,%al
  80025e:	74 23                	je     800283 <_panic+0x55>
  800260:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800267:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80026b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80026f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800273:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800277:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80027b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80027f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800283:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80028a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800291:	00 00 00 
  800294:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80029b:	00 00 00 
  80029e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a2:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002a9:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002be:	00 00 00 
  8002c1:	48 8b 18             	mov    (%rax),%rbx
  8002c4:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	callq  *%rax
  8002d0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002d6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002dd:	41 89 c8             	mov    %ecx,%r8d
  8002e0:	48 89 d1             	mov    %rdx,%rcx
  8002e3:	48 89 da             	mov    %rbx,%rdx
  8002e6:	89 c6                	mov    %eax,%esi
  8002e8:	48 bf a0 36 80 00 00 	movabs $0x8036a0,%rdi
  8002ef:	00 00 00 
  8002f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f7:	49 b9 67 04 80 00 00 	movabs $0x800467,%r9
  8002fe:	00 00 00 
  800301:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800304:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80030b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800312:	48 89 d6             	mov    %rdx,%rsi
  800315:	48 89 c7             	mov    %rax,%rdi
  800318:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax
	cprintf("\n");
  800324:	48 bf c3 36 80 00 00 	movabs $0x8036c3,%rdi
  80032b:	00 00 00 
  80032e:	b8 00 00 00 00       	mov    $0x0,%eax
  800333:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  80033a:	00 00 00 
  80033d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80033f:	cc                   	int3   
  800340:	eb fd                	jmp    80033f <_panic+0x111>

0000000000800342 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800342:	55                   	push   %rbp
  800343:	48 89 e5             	mov    %rsp,%rbp
  800346:	48 83 ec 10          	sub    $0x10,%rsp
  80034a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800355:	8b 00                	mov    (%rax),%eax
  800357:	8d 48 01             	lea    0x1(%rax),%ecx
  80035a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035e:	89 0a                	mov    %ecx,(%rdx)
  800360:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800363:	89 d1                	mov    %edx,%ecx
  800365:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800369:	48 98                	cltq   
  80036b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80036f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800373:	8b 00                	mov    (%rax),%eax
  800375:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037a:	75 2c                	jne    8003a8 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80037c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800380:	8b 00                	mov    (%rax),%eax
  800382:	48 98                	cltq   
  800384:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800388:	48 83 c2 08          	add    $0x8,%rdx
  80038c:	48 89 c6             	mov    %rax,%rsi
  80038f:	48 89 d7             	mov    %rdx,%rdi
  800392:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
		b->idx = 0;
  80039e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ac:	8b 40 04             	mov    0x4(%rax),%eax
  8003af:	8d 50 01             	lea    0x1(%rax),%edx
  8003b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003b9:	c9                   	leaveq 
  8003ba:	c3                   	retq   

00000000008003bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bb:	55                   	push   %rbp
  8003bc:	48 89 e5             	mov    %rsp,%rbp
  8003bf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003c6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003cd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003d4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003db:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003e2:	48 8b 0a             	mov    (%rdx),%rcx
  8003e5:	48 89 08             	mov    %rcx,(%rax)
  8003e8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ec:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003f0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003f4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800409:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80040c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800413:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80041a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800421:	48 89 c6             	mov    %rax,%rsi
  800424:	48 bf 42 03 80 00 00 	movabs $0x800342,%rdi
  80042b:	00 00 00 
  80042e:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80043a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800440:	48 98                	cltq   
  800442:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800449:	48 83 c2 08          	add    $0x8,%rdx
  80044d:	48 89 c6             	mov    %rax,%rsi
  800450:	48 89 d7             	mov    %rdx,%rdi
  800453:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80045f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800465:	c9                   	leaveq 
  800466:	c3                   	retq   

0000000000800467 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800467:	55                   	push   %rbp
  800468:	48 89 e5             	mov    %rsp,%rbp
  80046b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800472:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800479:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800480:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800487:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80048e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800495:	84 c0                	test   %al,%al
  800497:	74 20                	je     8004b9 <cprintf+0x52>
  800499:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80049d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004a5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004a9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004ad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004b5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004b9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004c0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004c7:	00 00 00 
  8004ca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004d1:	00 00 00 
  8004d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004df:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004e6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004ed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004f4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004fb:	48 8b 0a             	mov    (%rdx),%rcx
  8004fe:	48 89 08             	mov    %rcx,(%rax)
  800501:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800505:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800509:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80050d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800511:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800518:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80051f:	48 89 d6             	mov    %rdx,%rsi
  800522:	48 89 c7             	mov    %rax,%rdi
  800525:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  80052c:	00 00 00 
  80052f:	ff d0                	callq  *%rax
  800531:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800537:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80053d:	c9                   	leaveq 
  80053e:	c3                   	retq   

000000000080053f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	53                   	push   %rbx
  800544:	48 83 ec 38          	sub    $0x38,%rsp
  800548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80054c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800550:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800554:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800557:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80055b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80055f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800562:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800566:	77 3b                	ja     8005a3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800568:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80056b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80056f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800576:	ba 00 00 00 00       	mov    $0x0,%edx
  80057b:	48 f7 f3             	div    %rbx
  80057e:	48 89 c2             	mov    %rax,%rdx
  800581:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800584:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800587:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80058b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058f:	41 89 f9             	mov    %edi,%r9d
  800592:	48 89 c7             	mov    %rax,%rdi
  800595:	48 b8 3f 05 80 00 00 	movabs $0x80053f,%rax
  80059c:	00 00 00 
  80059f:	ff d0                	callq  *%rax
  8005a1:	eb 1e                	jmp    8005c1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a3:	eb 12                	jmp    8005b7 <printnum+0x78>
			putch(padc, putdat);
  8005a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005a9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	48 89 ce             	mov    %rcx,%rsi
  8005b3:	89 d7                	mov    %edx,%edi
  8005b5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005bf:	7f e4                	jg     8005a5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005c1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	48 f7 f1             	div    %rcx
  8005d0:	48 89 d0             	mov    %rdx,%rax
  8005d3:	48 ba a8 38 80 00 00 	movabs $0x8038a8,%rdx
  8005da:	00 00 00 
  8005dd:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005e1:	0f be d0             	movsbl %al,%edx
  8005e4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ec:	48 89 ce             	mov    %rcx,%rsi
  8005ef:	89 d7                	mov    %edx,%edi
  8005f1:	ff d0                	callq  *%rax
}
  8005f3:	48 83 c4 38          	add    $0x38,%rsp
  8005f7:	5b                   	pop    %rbx
  8005f8:	5d                   	pop    %rbp
  8005f9:	c3                   	retq   

00000000008005fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005fa:	55                   	push   %rbp
  8005fb:	48 89 e5             	mov    %rsp,%rbp
  8005fe:	48 83 ec 1c          	sub    $0x1c,%rsp
  800602:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800606:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800609:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80060d:	7e 52                	jle    800661 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	83 f8 30             	cmp    $0x30,%eax
  800618:	73 24                	jae    80063e <getuint+0x44>
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	89 c0                	mov    %eax,%eax
  80062a:	48 01 d0             	add    %rdx,%rax
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	8b 12                	mov    (%rdx),%edx
  800633:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063a:	89 0a                	mov    %ecx,(%rdx)
  80063c:	eb 17                	jmp    800655 <getuint+0x5b>
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800646:	48 89 d0             	mov    %rdx,%rax
  800649:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800655:	48 8b 00             	mov    (%rax),%rax
  800658:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80065c:	e9 a3 00 00 00       	jmpq   800704 <getuint+0x10a>
	else if (lflag)
  800661:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800665:	74 4f                	je     8006b6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	83 f8 30             	cmp    $0x30,%eax
  800670:	73 24                	jae    800696 <getuint+0x9c>
  800672:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800676:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	89 c0                	mov    %eax,%eax
  800682:	48 01 d0             	add    %rdx,%rax
  800685:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800689:	8b 12                	mov    (%rdx),%edx
  80068b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800692:	89 0a                	mov    %ecx,(%rdx)
  800694:	eb 17                	jmp    8006ad <getuint+0xb3>
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80069e:	48 89 d0             	mov    %rdx,%rax
  8006a1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ad:	48 8b 00             	mov    (%rax),%rax
  8006b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b4:	eb 4e                	jmp    800704 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	8b 00                	mov    (%rax),%eax
  8006bc:	83 f8 30             	cmp    $0x30,%eax
  8006bf:	73 24                	jae    8006e5 <getuint+0xeb>
  8006c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	89 c0                	mov    %eax,%eax
  8006d1:	48 01 d0             	add    %rdx,%rax
  8006d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d8:	8b 12                	mov    (%rdx),%edx
  8006da:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e1:	89 0a                	mov    %ecx,(%rdx)
  8006e3:	eb 17                	jmp    8006fc <getuint+0x102>
  8006e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ed:	48 89 d0             	mov    %rdx,%rax
  8006f0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fc:	8b 00                	mov    (%rax),%eax
  8006fe:	89 c0                	mov    %eax,%eax
  800700:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800704:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800708:	c9                   	leaveq 
  800709:	c3                   	retq   

000000000080070a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80070a:	55                   	push   %rbp
  80070b:	48 89 e5             	mov    %rsp,%rbp
  80070e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800712:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800716:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800719:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80071d:	7e 52                	jle    800771 <getint+0x67>
		x=va_arg(*ap, long long);
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	8b 00                	mov    (%rax),%eax
  800725:	83 f8 30             	cmp    $0x30,%eax
  800728:	73 24                	jae    80074e <getint+0x44>
  80072a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	8b 00                	mov    (%rax),%eax
  800738:	89 c0                	mov    %eax,%eax
  80073a:	48 01 d0             	add    %rdx,%rax
  80073d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800741:	8b 12                	mov    (%rdx),%edx
  800743:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	89 0a                	mov    %ecx,(%rdx)
  80074c:	eb 17                	jmp    800765 <getint+0x5b>
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800756:	48 89 d0             	mov    %rdx,%rax
  800759:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800765:	48 8b 00             	mov    (%rax),%rax
  800768:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80076c:	e9 a3 00 00 00       	jmpq   800814 <getint+0x10a>
	else if (lflag)
  800771:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800775:	74 4f                	je     8007c6 <getint+0xbc>
		x=va_arg(*ap, long);
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	8b 00                	mov    (%rax),%eax
  80077d:	83 f8 30             	cmp    $0x30,%eax
  800780:	73 24                	jae    8007a6 <getint+0x9c>
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	89 c0                	mov    %eax,%eax
  800792:	48 01 d0             	add    %rdx,%rax
  800795:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800799:	8b 12                	mov    (%rdx),%edx
  80079b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	89 0a                	mov    %ecx,(%rdx)
  8007a4:	eb 17                	jmp    8007bd <getint+0xb3>
  8007a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ae:	48 89 d0             	mov    %rdx,%rax
  8007b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007bd:	48 8b 00             	mov    (%rax),%rax
  8007c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c4:	eb 4e                	jmp    800814 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ca:	8b 00                	mov    (%rax),%eax
  8007cc:	83 f8 30             	cmp    $0x30,%eax
  8007cf:	73 24                	jae    8007f5 <getint+0xeb>
  8007d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	8b 00                	mov    (%rax),%eax
  8007df:	89 c0                	mov    %eax,%eax
  8007e1:	48 01 d0             	add    %rdx,%rax
  8007e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e8:	8b 12                	mov    (%rdx),%edx
  8007ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f1:	89 0a                	mov    %ecx,(%rdx)
  8007f3:	eb 17                	jmp    80080c <getint+0x102>
  8007f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fd:	48 89 d0             	mov    %rdx,%rax
  800800:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800808:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080c:	8b 00                	mov    (%rax),%eax
  80080e:	48 98                	cltq   
  800810:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800818:	c9                   	leaveq 
  800819:	c3                   	retq   

000000000080081a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081a:	55                   	push   %rbp
  80081b:	48 89 e5             	mov    %rsp,%rbp
  80081e:	41 54                	push   %r12
  800820:	53                   	push   %rbx
  800821:	48 83 ec 60          	sub    $0x60,%rsp
  800825:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800829:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80082d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800831:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800835:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800839:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80083d:	48 8b 0a             	mov    (%rdx),%rcx
  800840:	48 89 08             	mov    %rcx,(%rax)
  800843:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800847:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80084b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80084f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800853:	eb 17                	jmp    80086c <vprintfmt+0x52>
			if (ch == '\0')
  800855:	85 db                	test   %ebx,%ebx
  800857:	0f 84 cc 04 00 00    	je     800d29 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80085d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800861:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800865:	48 89 d6             	mov    %rdx,%rsi
  800868:	89 df                	mov    %ebx,%edi
  80086a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800870:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800874:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800878:	0f b6 00             	movzbl (%rax),%eax
  80087b:	0f b6 d8             	movzbl %al,%ebx
  80087e:	83 fb 25             	cmp    $0x25,%ebx
  800881:	75 d2                	jne    800855 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800883:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800887:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80088e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800895:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80089c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008af:	0f b6 00             	movzbl (%rax),%eax
  8008b2:	0f b6 d8             	movzbl %al,%ebx
  8008b5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008b8:	83 f8 55             	cmp    $0x55,%eax
  8008bb:	0f 87 34 04 00 00    	ja     800cf5 <vprintfmt+0x4db>
  8008c1:	89 c0                	mov    %eax,%eax
  8008c3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ca:	00 
  8008cb:	48 b8 d0 38 80 00 00 	movabs $0x8038d0,%rax
  8008d2:	00 00 00 
  8008d5:	48 01 d0             	add    %rdx,%rax
  8008d8:	48 8b 00             	mov    (%rax),%rax
  8008db:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008dd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008e1:	eb c0                	jmp    8008a3 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008e7:	eb ba                	jmp    8008a3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008f0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	c1 e0 02             	shl    $0x2,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	01 c0                	add    %eax,%eax
  8008fc:	01 d8                	add    %ebx,%eax
  8008fe:	83 e8 30             	sub    $0x30,%eax
  800901:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800904:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800908:	0f b6 00             	movzbl (%rax),%eax
  80090b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80090e:	83 fb 2f             	cmp    $0x2f,%ebx
  800911:	7e 0c                	jle    80091f <vprintfmt+0x105>
  800913:	83 fb 39             	cmp    $0x39,%ebx
  800916:	7f 07                	jg     80091f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800918:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80091d:	eb d1                	jmp    8008f0 <vprintfmt+0xd6>
			goto process_precision;
  80091f:	eb 58                	jmp    800979 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800921:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800924:	83 f8 30             	cmp    $0x30,%eax
  800927:	73 17                	jae    800940 <vprintfmt+0x126>
  800929:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80092d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800930:	89 c0                	mov    %eax,%eax
  800932:	48 01 d0             	add    %rdx,%rax
  800935:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800938:	83 c2 08             	add    $0x8,%edx
  80093b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80093e:	eb 0f                	jmp    80094f <vprintfmt+0x135>
  800940:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800944:	48 89 d0             	mov    %rdx,%rax
  800947:	48 83 c2 08          	add    $0x8,%rdx
  80094b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80094f:	8b 00                	mov    (%rax),%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800954:	eb 23                	jmp    800979 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800956:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095a:	79 0c                	jns    800968 <vprintfmt+0x14e>
				width = 0;
  80095c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800963:	e9 3b ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>
  800968:	e9 36 ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80096d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800974:	e9 2a ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800979:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097d:	79 12                	jns    800991 <vprintfmt+0x177>
				width = precision, precision = -1;
  80097f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800982:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800985:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80098c:	e9 12 ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>
  800991:	e9 0d ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800996:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80099a:	e9 04 ff ff ff       	jmpq   8008a3 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80099f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a2:	83 f8 30             	cmp    $0x30,%eax
  8009a5:	73 17                	jae    8009be <vprintfmt+0x1a4>
  8009a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ae:	89 c0                	mov    %eax,%eax
  8009b0:	48 01 d0             	add    %rdx,%rax
  8009b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b6:	83 c2 08             	add    $0x8,%edx
  8009b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009bc:	eb 0f                	jmp    8009cd <vprintfmt+0x1b3>
  8009be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c2:	48 89 d0             	mov    %rdx,%rax
  8009c5:	48 83 c2 08          	add    $0x8,%rdx
  8009c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009cd:	8b 10                	mov    (%rax),%edx
  8009cf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d7:	48 89 ce             	mov    %rcx,%rsi
  8009da:	89 d7                	mov    %edx,%edi
  8009dc:	ff d0                	callq  *%rax
			break;
  8009de:	e9 40 03 00 00       	jmpq   800d23 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8009e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e6:	83 f8 30             	cmp    $0x30,%eax
  8009e9:	73 17                	jae    800a02 <vprintfmt+0x1e8>
  8009eb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	89 c0                	mov    %eax,%eax
  8009f4:	48 01 d0             	add    %rdx,%rax
  8009f7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fa:	83 c2 08             	add    $0x8,%edx
  8009fd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a00:	eb 0f                	jmp    800a11 <vprintfmt+0x1f7>
  800a02:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a06:	48 89 d0             	mov    %rdx,%rax
  800a09:	48 83 c2 08          	add    $0x8,%rdx
  800a0d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a11:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a13:	85 db                	test   %ebx,%ebx
  800a15:	79 02                	jns    800a19 <vprintfmt+0x1ff>
				err = -err;
  800a17:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a19:	83 fb 10             	cmp    $0x10,%ebx
  800a1c:	7f 16                	jg     800a34 <vprintfmt+0x21a>
  800a1e:	48 b8 20 38 80 00 00 	movabs $0x803820,%rax
  800a25:	00 00 00 
  800a28:	48 63 d3             	movslq %ebx,%rdx
  800a2b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a2f:	4d 85 e4             	test   %r12,%r12
  800a32:	75 2e                	jne    800a62 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	89 d9                	mov    %ebx,%ecx
  800a3e:	48 ba b9 38 80 00 00 	movabs $0x8038b9,%rdx
  800a45:	00 00 00 
  800a48:	48 89 c7             	mov    %rax,%rdi
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	49 b8 32 0d 80 00 00 	movabs $0x800d32,%r8
  800a57:	00 00 00 
  800a5a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a5d:	e9 c1 02 00 00       	jmpq   800d23 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6a:	4c 89 e1             	mov    %r12,%rcx
  800a6d:	48 ba c2 38 80 00 00 	movabs $0x8038c2,%rdx
  800a74:	00 00 00 
  800a77:	48 89 c7             	mov    %rax,%rdi
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7f:	49 b8 32 0d 80 00 00 	movabs $0x800d32,%r8
  800a86:	00 00 00 
  800a89:	41 ff d0             	callq  *%r8
			break;
  800a8c:	e9 92 02 00 00       	jmpq   800d23 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a94:	83 f8 30             	cmp    $0x30,%eax
  800a97:	73 17                	jae    800ab0 <vprintfmt+0x296>
  800a99:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	89 c0                	mov    %eax,%eax
  800aa2:	48 01 d0             	add    %rdx,%rax
  800aa5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa8:	83 c2 08             	add    $0x8,%edx
  800aab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aae:	eb 0f                	jmp    800abf <vprintfmt+0x2a5>
  800ab0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab4:	48 89 d0             	mov    %rdx,%rax
  800ab7:	48 83 c2 08          	add    $0x8,%rdx
  800abb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800abf:	4c 8b 20             	mov    (%rax),%r12
  800ac2:	4d 85 e4             	test   %r12,%r12
  800ac5:	75 0a                	jne    800ad1 <vprintfmt+0x2b7>
				p = "(null)";
  800ac7:	49 bc c5 38 80 00 00 	movabs $0x8038c5,%r12
  800ace:	00 00 00 
			if (width > 0 && padc != '-')
  800ad1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad5:	7e 3f                	jle    800b16 <vprintfmt+0x2fc>
  800ad7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800adb:	74 39                	je     800b16 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800add:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae0:	48 98                	cltq   
  800ae2:	48 89 c6             	mov    %rax,%rsi
  800ae5:	4c 89 e7             	mov    %r12,%rdi
  800ae8:	48 b8 de 0f 80 00 00 	movabs $0x800fde,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	callq  *%rax
  800af4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800af7:	eb 17                	jmp    800b10 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800af9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800afd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	48 89 ce             	mov    %rcx,%rsi
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b10:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b14:	7f e3                	jg     800af9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b16:	eb 37                	jmp    800b4f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b1c:	74 1e                	je     800b3c <vprintfmt+0x322>
  800b1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b21:	7e 05                	jle    800b28 <vprintfmt+0x30e>
  800b23:	83 fb 7e             	cmp    $0x7e,%ebx
  800b26:	7e 14                	jle    800b3c <vprintfmt+0x322>
					putch('?', putdat);
  800b28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b30:	48 89 d6             	mov    %rdx,%rsi
  800b33:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b38:	ff d0                	callq  *%rax
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b44:	48 89 d6             	mov    %rdx,%rsi
  800b47:	89 df                	mov    %ebx,%edi
  800b49:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b4f:	4c 89 e0             	mov    %r12,%rax
  800b52:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b56:	0f b6 00             	movzbl (%rax),%eax
  800b59:	0f be d8             	movsbl %al,%ebx
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	74 10                	je     800b70 <vprintfmt+0x356>
  800b60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b64:	78 b2                	js     800b18 <vprintfmt+0x2fe>
  800b66:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b6e:	79 a8                	jns    800b18 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b70:	eb 16                	jmp    800b88 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7a:	48 89 d6             	mov    %rdx,%rsi
  800b7d:	bf 20 00 00 00       	mov    $0x20,%edi
  800b82:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b84:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b88:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8c:	7f e4                	jg     800b72 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b8e:	e9 90 01 00 00       	jmpq   800d23 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b97:	be 03 00 00 00       	mov    $0x3,%esi
  800b9c:	48 89 c7             	mov    %rax,%rdi
  800b9f:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  800ba6:	00 00 00 
  800ba9:	ff d0                	callq  *%rax
  800bab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb3:	48 85 c0             	test   %rax,%rax
  800bb6:	79 1d                	jns    800bd5 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bb8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc0:	48 89 d6             	mov    %rdx,%rsi
  800bc3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bc8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bce:	48 f7 d8             	neg    %rax
  800bd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bd5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bdc:	e9 d5 00 00 00       	jmpq   800cb6 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be5:	be 03 00 00 00       	mov    $0x3,%esi
  800bea:	48 89 c7             	mov    %rax,%rdi
  800bed:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800bf4:	00 00 00 
  800bf7:	ff d0                	callq  *%rax
  800bf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bfd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c04:	e9 ad 00 00 00       	jmpq   800cb6 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c09:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c10:	89 d6                	mov    %edx,%esi
  800c12:	48 89 c7             	mov    %rax,%rdi
  800c15:	48 b8 0a 07 80 00 00 	movabs $0x80070a,%rax
  800c1c:	00 00 00 
  800c1f:	ff d0                	callq  *%rax
  800c21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c25:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c2c:	e9 85 00 00 00       	jmpq   800cb6 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800c31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	48 89 d6             	mov    %rdx,%rsi
  800c3c:	bf 30 00 00 00       	mov    $0x30,%edi
  800c41:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4b:	48 89 d6             	mov    %rdx,%rsi
  800c4e:	bf 78 00 00 00       	mov    $0x78,%edi
  800c53:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c58:	83 f8 30             	cmp    $0x30,%eax
  800c5b:	73 17                	jae    800c74 <vprintfmt+0x45a>
  800c5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c64:	89 c0                	mov    %eax,%eax
  800c66:	48 01 d0             	add    %rdx,%rax
  800c69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6c:	83 c2 08             	add    $0x8,%edx
  800c6f:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c72:	eb 0f                	jmp    800c83 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c78:	48 89 d0             	mov    %rdx,%rax
  800c7b:	48 83 c2 08          	add    $0x8,%rdx
  800c7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c83:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c8a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c91:	eb 23                	jmp    800cb6 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c97:	be 03 00 00 00       	mov    $0x3,%esi
  800c9c:	48 89 c7             	mov    %rax,%rdi
  800c9f:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800ca6:	00 00 00 
  800ca9:	ff d0                	callq  *%rax
  800cab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800caf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cbb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cbe:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccd:	45 89 c1             	mov    %r8d,%r9d
  800cd0:	41 89 f8             	mov    %edi,%r8d
  800cd3:	48 89 c7             	mov    %rax,%rdi
  800cd6:	48 b8 3f 05 80 00 00 	movabs $0x80053f,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
			break;
  800ce2:	eb 3f                	jmp    800d23 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cec:	48 89 d6             	mov    %rdx,%rsi
  800cef:	89 df                	mov    %ebx,%edi
  800cf1:	ff d0                	callq  *%rax
			break;
  800cf3:	eb 2e                	jmp    800d23 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfd:	48 89 d6             	mov    %rdx,%rsi
  800d00:	bf 25 00 00 00       	mov    $0x25,%edi
  800d05:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d07:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d0c:	eb 05                	jmp    800d13 <vprintfmt+0x4f9>
  800d0e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d13:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d17:	48 83 e8 01          	sub    $0x1,%rax
  800d1b:	0f b6 00             	movzbl (%rax),%eax
  800d1e:	3c 25                	cmp    $0x25,%al
  800d20:	75 ec                	jne    800d0e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d22:	90                   	nop
		}
	}
  800d23:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d24:	e9 43 fb ff ff       	jmpq   80086c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d29:	48 83 c4 60          	add    $0x60,%rsp
  800d2d:	5b                   	pop    %rbx
  800d2e:	41 5c                	pop    %r12
  800d30:	5d                   	pop    %rbp
  800d31:	c3                   	retq   

0000000000800d32 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d32:	55                   	push   %rbp
  800d33:	48 89 e5             	mov    %rsp,%rbp
  800d36:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d3d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d44:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d4b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d52:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d59:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d60:	84 c0                	test   %al,%al
  800d62:	74 20                	je     800d84 <printfmt+0x52>
  800d64:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d68:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d6c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d70:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d74:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d78:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d7c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d80:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d84:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d92:	00 00 00 
  800d95:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9c:	00 00 00 
  800d9f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800daa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800db8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dbf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dcd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd4:	48 89 c7             	mov    %rax,%rdi
  800dd7:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800dde:	00 00 00 
  800de1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de3:	c9                   	leaveq 
  800de4:	c3                   	retq   

0000000000800de5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de5:	55                   	push   %rbp
  800de6:	48 89 e5             	mov    %rsp,%rbp
  800de9:	48 83 ec 10          	sub    $0x10,%rsp
  800ded:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df8:	8b 40 10             	mov    0x10(%rax),%eax
  800dfb:	8d 50 01             	lea    0x1(%rax),%edx
  800dfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e02:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e09:	48 8b 10             	mov    (%rax),%rdx
  800e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e10:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e14:	48 39 c2             	cmp    %rax,%rdx
  800e17:	73 17                	jae    800e30 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1d:	48 8b 00             	mov    (%rax),%rax
  800e20:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e28:	48 89 0a             	mov    %rcx,(%rdx)
  800e2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e2e:	88 10                	mov    %dl,(%rax)
}
  800e30:	c9                   	leaveq 
  800e31:	c3                   	retq   

0000000000800e32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e32:	55                   	push   %rbp
  800e33:	48 89 e5             	mov    %rsp,%rbp
  800e36:	48 83 ec 50          	sub    $0x50,%rsp
  800e3a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e3e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e41:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e45:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e49:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e4d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e51:	48 8b 0a             	mov    (%rdx),%rcx
  800e54:	48 89 08             	mov    %rcx,(%rax)
  800e57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e6b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e6f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e72:	48 98                	cltq   
  800e74:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7c:	48 01 d0             	add    %rdx,%rax
  800e7f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e8f:	74 06                	je     800e97 <vsnprintf+0x65>
  800e91:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e95:	7f 07                	jg     800e9e <vsnprintf+0x6c>
		return -E_INVAL;
  800e97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9c:	eb 2f                	jmp    800ecd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e9e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ea6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eaa:	48 89 c6             	mov    %rax,%rsi
  800ead:	48 bf e5 0d 80 00 00 	movabs $0x800de5,%rdi
  800eb4:	00 00 00 
  800eb7:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800ebe:	00 00 00 
  800ec1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eca:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ecd:	c9                   	leaveq 
  800ece:	c3                   	retq   

0000000000800ecf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eda:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ee7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ef5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800efc:	84 c0                	test   %al,%al
  800efe:	74 20                	je     800f20 <snprintf+0x51>
  800f00:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f04:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f08:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f0c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f10:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f14:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f18:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f1c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f20:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f27:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f2e:	00 00 00 
  800f31:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f38:	00 00 00 
  800f3b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f3f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f46:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f4d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f54:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f5b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f62:	48 8b 0a             	mov    (%rdx),%rcx
  800f65:	48 89 08             	mov    %rcx,(%rax)
  800f68:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f6c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f70:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f74:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f78:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f7f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f86:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f8c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 32 0e 80 00 00 	movabs $0x800e32,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
  800fa2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fa8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fae:	c9                   	leaveq 
  800faf:	c3                   	retq   

0000000000800fb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb0:	55                   	push   %rbp
  800fb1:	48 89 e5             	mov    %rsp,%rbp
  800fb4:	48 83 ec 18          	sub    $0x18,%rsp
  800fb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc3:	eb 09                	jmp    800fce <strlen+0x1e>
		n++;
  800fc5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 ec                	jne    800fc5 <strlen+0x15>
		n++;
	return n;
  800fd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fdc:	c9                   	leaveq 
  800fdd:	c3                   	retq   

0000000000800fde <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fde:	55                   	push   %rbp
  800fdf:	48 89 e5             	mov    %rsp,%rbp
  800fe2:	48 83 ec 20          	sub    $0x20,%rsp
  800fe6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff5:	eb 0e                	jmp    801005 <strnlen+0x27>
		n++;
  800ff7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801000:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801005:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100a:	74 0b                	je     801017 <strnlen+0x39>
  80100c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	84 c0                	test   %al,%al
  801015:	75 e0                	jne    800ff7 <strnlen+0x19>
		n++;
	return n;
  801017:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101a:	c9                   	leaveq 
  80101b:	c3                   	retq   

000000000080101c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101c:	55                   	push   %rbp
  80101d:	48 89 e5             	mov    %rsp,%rbp
  801020:	48 83 ec 20          	sub    $0x20,%rsp
  801024:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801028:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80102c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801030:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801034:	90                   	nop
  801035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801039:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801041:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801045:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801049:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80104d:	0f b6 12             	movzbl (%rdx),%edx
  801050:	88 10                	mov    %dl,(%rax)
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	75 dc                	jne    801035 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80105d:	c9                   	leaveq 
  80105e:	c3                   	retq   

000000000080105f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80105f:	55                   	push   %rbp
  801060:	48 89 e5             	mov    %rsp,%rbp
  801063:	48 83 ec 20          	sub    $0x20,%rsp
  801067:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80106f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801073:	48 89 c7             	mov    %rax,%rdi
  801076:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  80107d:	00 00 00 
  801080:	ff d0                	callq  *%rax
  801082:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801085:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801088:	48 63 d0             	movslq %eax,%rdx
  80108b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108f:	48 01 c2             	add    %rax,%rdx
  801092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801096:	48 89 c6             	mov    %rax,%rsi
  801099:	48 89 d7             	mov    %rdx,%rdi
  80109c:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax
	return dst;
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ac:	c9                   	leaveq 
  8010ad:	c3                   	retq   

00000000008010ae <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ae:	55                   	push   %rbp
  8010af:	48 89 e5             	mov    %rsp,%rbp
  8010b2:	48 83 ec 28          	sub    $0x28,%rsp
  8010b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d1:	00 
  8010d2:	eb 2a                	jmp    8010fe <strncpy+0x50>
		*dst++ = *src;
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e4:	0f b6 12             	movzbl (%rdx),%edx
  8010e7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ed:	0f b6 00             	movzbl (%rax),%eax
  8010f0:	84 c0                	test   %al,%al
  8010f2:	74 05                	je     8010f9 <strncpy+0x4b>
			src++;
  8010f4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801102:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801106:	72 cc                	jb     8010d4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 28          	sub    $0x28,%rsp
  801116:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801126:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80112f:	74 3d                	je     80116e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801131:	eb 1d                	jmp    801150 <strlcpy+0x42>
			*dst++ = *src++;
  801133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801137:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80113f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801143:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801147:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114b:	0f b6 12             	movzbl (%rdx),%edx
  80114e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801150:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801155:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115a:	74 0b                	je     801167 <strlcpy+0x59>
  80115c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	75 cc                	jne    801133 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80116e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	48 29 c2             	sub    %rax,%rdx
  801179:	48 89 d0             	mov    %rdx,%rax
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 10          	sub    $0x10,%rsp
  801186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80118e:	eb 0a                	jmp    80119a <strcmp+0x1c>
		p++, q++;
  801190:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801195:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	84 c0                	test   %al,%al
  8011a3:	74 12                	je     8011b7 <strcmp+0x39>
  8011a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a9:	0f b6 10             	movzbl (%rax),%edx
  8011ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b0:	0f b6 00             	movzbl (%rax),%eax
  8011b3:	38 c2                	cmp    %al,%dl
  8011b5:	74 d9                	je     801190 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	0f b6 d0             	movzbl %al,%edx
  8011c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c5:	0f b6 00             	movzbl (%rax),%eax
  8011c8:	0f b6 c0             	movzbl %al,%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
}
  8011cf:	c9                   	leaveq 
  8011d0:	c3                   	retq   

00000000008011d1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d1:	55                   	push   %rbp
  8011d2:	48 89 e5             	mov    %rsp,%rbp
  8011d5:	48 83 ec 18          	sub    $0x18,%rsp
  8011d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011e5:	eb 0f                	jmp    8011f6 <strncmp+0x25>
		n--, p++, q++;
  8011e7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fb:	74 1d                	je     80121a <strncmp+0x49>
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	84 c0                	test   %al,%al
  801206:	74 12                	je     80121a <strncmp+0x49>
  801208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120c:	0f b6 10             	movzbl (%rax),%edx
  80120f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	38 c2                	cmp    %al,%dl
  801218:	74 cd                	je     8011e7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121f:	75 07                	jne    801228 <strncmp+0x57>
		return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
  801226:	eb 18                	jmp    801240 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	0f b6 00             	movzbl (%rax),%eax
  80122f:	0f b6 d0             	movzbl %al,%edx
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	0f b6 c0             	movzbl %al,%eax
  80123c:	29 c2                	sub    %eax,%edx
  80123e:	89 d0                	mov    %edx,%eax
}
  801240:	c9                   	leaveq 
  801241:	c3                   	retq   

0000000000801242 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801242:	55                   	push   %rbp
  801243:	48 89 e5             	mov    %rsp,%rbp
  801246:	48 83 ec 0c          	sub    $0xc,%rsp
  80124a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124e:	89 f0                	mov    %esi,%eax
  801250:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801253:	eb 17                	jmp    80126c <strchr+0x2a>
		if (*s == c)
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80125f:	75 06                	jne    801267 <strchr+0x25>
			return (char *) s;
  801261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801265:	eb 15                	jmp    80127c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801267:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	0f b6 00             	movzbl (%rax),%eax
  801273:	84 c0                	test   %al,%al
  801275:	75 de                	jne    801255 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127c:	c9                   	leaveq 
  80127d:	c3                   	retq   

000000000080127e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80127e:	55                   	push   %rbp
  80127f:	48 89 e5             	mov    %rsp,%rbp
  801282:	48 83 ec 0c          	sub    $0xc,%rsp
  801286:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128a:	89 f0                	mov    %esi,%eax
  80128c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80128f:	eb 13                	jmp    8012a4 <strfind+0x26>
		if (*s == c)
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129b:	75 02                	jne    80129f <strfind+0x21>
			break;
  80129d:	eb 10                	jmp    8012af <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80129f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	84 c0                	test   %al,%al
  8012ad:	75 e2                	jne    801291 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b3:	c9                   	leaveq 
  8012b4:	c3                   	retq   

00000000008012b5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012b5:	55                   	push   %rbp
  8012b6:	48 89 e5             	mov    %rsp,%rbp
  8012b9:	48 83 ec 18          	sub    $0x18,%rsp
  8012bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012cd:	75 06                	jne    8012d5 <memset+0x20>
		return v;
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	eb 69                	jmp    80133e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	83 e0 03             	and    $0x3,%eax
  8012dc:	48 85 c0             	test   %rax,%rax
  8012df:	75 48                	jne    801329 <memset+0x74>
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e5:	83 e0 03             	and    $0x3,%eax
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	75 3c                	jne    801329 <memset+0x74>
		c &= 0xFF;
  8012ed:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f7:	c1 e0 18             	shl    $0x18,%eax
  8012fa:	89 c2                	mov    %eax,%edx
  8012fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ff:	c1 e0 10             	shl    $0x10,%eax
  801302:	09 c2                	or     %eax,%edx
  801304:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801307:	c1 e0 08             	shl    $0x8,%eax
  80130a:	09 d0                	or     %edx,%eax
  80130c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80130f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801313:	48 c1 e8 02          	shr    $0x2,%rax
  801317:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80131a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801321:	48 89 d7             	mov    %rdx,%rdi
  801324:	fc                   	cld    
  801325:	f3 ab                	rep stos %eax,%es:(%rdi)
  801327:	eb 11                	jmp    80133a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801329:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801330:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801334:	48 89 d7             	mov    %rdx,%rdi
  801337:	fc                   	cld    
  801338:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80133e:	c9                   	leaveq 
  80133f:	c3                   	retq   

0000000000801340 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801340:	55                   	push   %rbp
  801341:	48 89 e5             	mov    %rsp,%rbp
  801344:	48 83 ec 28          	sub    $0x28,%rsp
  801348:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801350:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801354:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801358:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801360:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801368:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80136c:	0f 83 88 00 00 00    	jae    8013fa <memmove+0xba>
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137a:	48 01 d0             	add    %rdx,%rax
  80137d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801381:	76 77                	jbe    8013fa <memmove+0xba>
		s += n;
  801383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801387:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80138b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801397:	83 e0 03             	and    $0x3,%eax
  80139a:	48 85 c0             	test   %rax,%rax
  80139d:	75 3b                	jne    8013da <memmove+0x9a>
  80139f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a3:	83 e0 03             	and    $0x3,%eax
  8013a6:	48 85 c0             	test   %rax,%rax
  8013a9:	75 2f                	jne    8013da <memmove+0x9a>
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	83 e0 03             	and    $0x3,%eax
  8013b2:	48 85 c0             	test   %rax,%rax
  8013b5:	75 23                	jne    8013da <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	48 83 e8 04          	sub    $0x4,%rax
  8013bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c3:	48 83 ea 04          	sub    $0x4,%rdx
  8013c7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013cb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013cf:	48 89 c7             	mov    %rax,%rdi
  8013d2:	48 89 d6             	mov    %rdx,%rsi
  8013d5:	fd                   	std    
  8013d6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013d8:	eb 1d                	jmp    8013f7 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013de:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ee:	48 89 d7             	mov    %rdx,%rdi
  8013f1:	48 89 c1             	mov    %rax,%rcx
  8013f4:	fd                   	std    
  8013f5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013f7:	fc                   	cld    
  8013f8:	eb 57                	jmp    801451 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fe:	83 e0 03             	and    $0x3,%eax
  801401:	48 85 c0             	test   %rax,%rax
  801404:	75 36                	jne    80143c <memmove+0xfc>
  801406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140a:	83 e0 03             	and    $0x3,%eax
  80140d:	48 85 c0             	test   %rax,%rax
  801410:	75 2a                	jne    80143c <memmove+0xfc>
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	83 e0 03             	and    $0x3,%eax
  801419:	48 85 c0             	test   %rax,%rax
  80141c:	75 1e                	jne    80143c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	48 c1 e8 02          	shr    $0x2,%rax
  801426:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801431:	48 89 c7             	mov    %rax,%rdi
  801434:	48 89 d6             	mov    %rdx,%rsi
  801437:	fc                   	cld    
  801438:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143a:	eb 15                	jmp    801451 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80143c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801440:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801444:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801448:	48 89 c7             	mov    %rax,%rdi
  80144b:	48 89 d6             	mov    %rdx,%rsi
  80144e:	fc                   	cld    
  80144f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801455:	c9                   	leaveq 
  801456:	c3                   	retq   

0000000000801457 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	48 83 ec 18          	sub    $0x18,%rsp
  80145f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801463:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801467:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80146b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80146f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801477:	48 89 ce             	mov    %rcx,%rsi
  80147a:	48 89 c7             	mov    %rax,%rdi
  80147d:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  801484:	00 00 00 
  801487:	ff d0                	callq  *%rax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 28          	sub    $0x28,%rsp
  801493:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801497:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014af:	eb 36                	jmp    8014e7 <memcmp+0x5c>
		if (*s1 != *s2)
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	0f b6 10             	movzbl (%rax),%edx
  8014b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bc:	0f b6 00             	movzbl (%rax),%eax
  8014bf:	38 c2                	cmp    %al,%dl
  8014c1:	74 1a                	je     8014dd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	0f b6 d0             	movzbl %al,%edx
  8014cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	0f b6 c0             	movzbl %al,%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	eb 20                	jmp    8014fd <memcmp+0x72>
		s1++, s2++;
  8014dd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f3:	48 85 c0             	test   %rax,%rax
  8014f6:	75 b9                	jne    8014b1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fd:	c9                   	leaveq 
  8014fe:	c3                   	retq   

00000000008014ff <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014ff:	55                   	push   %rbp
  801500:	48 89 e5             	mov    %rsp,%rbp
  801503:	48 83 ec 28          	sub    $0x28,%rsp
  801507:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80150e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151a:	48 01 d0             	add    %rdx,%rax
  80151d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801521:	eb 15                	jmp    801538 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801527:	0f b6 10             	movzbl (%rax),%edx
  80152a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80152d:	38 c2                	cmp    %al,%dl
  80152f:	75 02                	jne    801533 <memfind+0x34>
			break;
  801531:	eb 0f                	jmp    801542 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801533:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801540:	72 e1                	jb     801523 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801546:	c9                   	leaveq 
  801547:	c3                   	retq   

0000000000801548 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801548:	55                   	push   %rbp
  801549:	48 89 e5             	mov    %rsp,%rbp
  80154c:	48 83 ec 34          	sub    $0x34,%rsp
  801550:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801554:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801558:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80155b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801562:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801569:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80156a:	eb 05                	jmp    801571 <strtol+0x29>
		s++;
  80156c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801575:	0f b6 00             	movzbl (%rax),%eax
  801578:	3c 20                	cmp    $0x20,%al
  80157a:	74 f0                	je     80156c <strtol+0x24>
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 09                	cmp    $0x9,%al
  801585:	74 e5                	je     80156c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	3c 2b                	cmp    $0x2b,%al
  801590:	75 07                	jne    801599 <strtol+0x51>
		s++;
  801592:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801597:	eb 17                	jmp    8015b0 <strtol+0x68>
	else if (*s == '-')
  801599:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	3c 2d                	cmp    $0x2d,%al
  8015a2:	75 0c                	jne    8015b0 <strtol+0x68>
		s++, neg = 1;
  8015a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b4:	74 06                	je     8015bc <strtol+0x74>
  8015b6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015ba:	75 28                	jne    8015e4 <strtol+0x9c>
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 30                	cmp    $0x30,%al
  8015c5:	75 1d                	jne    8015e4 <strtol+0x9c>
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 83 c0 01          	add    $0x1,%rax
  8015cf:	0f b6 00             	movzbl (%rax),%eax
  8015d2:	3c 78                	cmp    $0x78,%al
  8015d4:	75 0e                	jne    8015e4 <strtol+0x9c>
		s += 2, base = 16;
  8015d6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015db:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015e2:	eb 2c                	jmp    801610 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e8:	75 19                	jne    801603 <strtol+0xbb>
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	3c 30                	cmp    $0x30,%al
  8015f3:	75 0e                	jne    801603 <strtol+0xbb>
		s++, base = 8;
  8015f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fa:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801601:	eb 0d                	jmp    801610 <strtol+0xc8>
	else if (base == 0)
  801603:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801607:	75 07                	jne    801610 <strtol+0xc8>
		base = 10;
  801609:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801614:	0f b6 00             	movzbl (%rax),%eax
  801617:	3c 2f                	cmp    $0x2f,%al
  801619:	7e 1d                	jle    801638 <strtol+0xf0>
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 39                	cmp    $0x39,%al
  801624:	7f 12                	jg     801638 <strtol+0xf0>
			dig = *s - '0';
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	0f be c0             	movsbl %al,%eax
  801630:	83 e8 30             	sub    $0x30,%eax
  801633:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801636:	eb 4e                	jmp    801686 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801638:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	3c 60                	cmp    $0x60,%al
  801641:	7e 1d                	jle    801660 <strtol+0x118>
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 7a                	cmp    $0x7a,%al
  80164c:	7f 12                	jg     801660 <strtol+0x118>
			dig = *s - 'a' + 10;
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	0f be c0             	movsbl %al,%eax
  801658:	83 e8 57             	sub    $0x57,%eax
  80165b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165e:	eb 26                	jmp    801686 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	3c 40                	cmp    $0x40,%al
  801669:	7e 48                	jle    8016b3 <strtol+0x16b>
  80166b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	3c 5a                	cmp    $0x5a,%al
  801674:	7f 3d                	jg     8016b3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	0f be c0             	movsbl %al,%eax
  801680:	83 e8 37             	sub    $0x37,%eax
  801683:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801686:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801689:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80168c:	7c 02                	jl     801690 <strtol+0x148>
			break;
  80168e:	eb 23                	jmp    8016b3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801690:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801695:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801698:	48 98                	cltq   
  80169a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80169f:	48 89 c2             	mov    %rax,%rdx
  8016a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a5:	48 98                	cltq   
  8016a7:	48 01 d0             	add    %rdx,%rax
  8016aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ae:	e9 5d ff ff ff       	jmpq   801610 <strtol+0xc8>

	if (endptr)
  8016b3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016b8:	74 0b                	je     8016c5 <strtol+0x17d>
		*endptr = (char *) s;
  8016ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016c2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016c9:	74 09                	je     8016d4 <strtol+0x18c>
  8016cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cf:	48 f7 d8             	neg    %rax
  8016d2:	eb 04                	jmp    8016d8 <strtol+0x190>
  8016d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016d8:	c9                   	leaveq 
  8016d9:	c3                   	retq   

00000000008016da <strstr>:

char * strstr(const char *in, const char *str)
{
  8016da:	55                   	push   %rbp
  8016db:	48 89 e5             	mov    %rsp,%rbp
  8016de:	48 83 ec 30          	sub    $0x30,%rsp
  8016e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8016ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8016fc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801700:	75 06                	jne    801708 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801702:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801706:	eb 6b                	jmp    801773 <strstr+0x99>

    len = strlen(str);
  801708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170c:	48 89 c7             	mov    %rax,%rdi
  80170f:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  801716:	00 00 00 
  801719:	ff d0                	callq  *%rax
  80171b:	48 98                	cltq   
  80171d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801729:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801733:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801737:	75 07                	jne    801740 <strstr+0x66>
                return (char *) 0;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
  80173e:	eb 33                	jmp    801773 <strstr+0x99>
        } while (sc != c);
  801740:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801744:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801747:	75 d8                	jne    801721 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801749:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80174d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801755:	48 89 ce             	mov    %rcx,%rsi
  801758:	48 89 c7             	mov    %rax,%rdi
  80175b:	48 b8 d1 11 80 00 00 	movabs $0x8011d1,%rax
  801762:	00 00 00 
  801765:	ff d0                	callq  *%rax
  801767:	85 c0                	test   %eax,%eax
  801769:	75 b6                	jne    801721 <strstr+0x47>

    return (char *) (in - 1);
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	48 83 e8 01          	sub    $0x1,%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	53                   	push   %rbx
  80177a:	48 83 ec 48          	sub    $0x48,%rsp
  80177e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801781:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801784:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801788:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80178c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801790:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801794:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801797:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80179b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80179f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017a3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017a7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017ab:	4c 89 c3             	mov    %r8,%rbx
  8017ae:	cd 30                	int    $0x30
  8017b0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017b4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017b8:	74 3e                	je     8017f8 <syscall+0x83>
  8017ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017bf:	7e 37                	jle    8017f8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017c8:	49 89 d0             	mov    %rdx,%r8
  8017cb:	89 c1                	mov    %eax,%ecx
  8017cd:	48 ba 80 3b 80 00 00 	movabs $0x803b80,%rdx
  8017d4:	00 00 00 
  8017d7:	be 23 00 00 00       	mov    $0x23,%esi
  8017dc:	48 bf 9d 3b 80 00 00 	movabs $0x803b9d,%rdi
  8017e3:	00 00 00 
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	49 b9 2e 02 80 00 00 	movabs $0x80022e,%r9
  8017f2:	00 00 00 
  8017f5:	41 ff d1             	callq  *%r9

	return ret;
  8017f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017fc:	48 83 c4 48          	add    $0x48,%rsp
  801800:	5b                   	pop    %rbx
  801801:	5d                   	pop    %rbp
  801802:	c3                   	retq   

0000000000801803 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801803:	55                   	push   %rbp
  801804:	48 89 e5             	mov    %rsp,%rbp
  801807:	48 83 ec 20          	sub    $0x20,%rsp
  80180b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80180f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801822:	00 
  801823:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801829:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182f:	48 89 d1             	mov    %rdx,%rcx
  801832:	48 89 c2             	mov    %rax,%rdx
  801835:	be 00 00 00 00       	mov    $0x0,%esi
  80183a:	bf 00 00 00 00       	mov    $0x0,%edi
  80183f:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801846:	00 00 00 
  801849:	ff d0                	callq  *%rax
}
  80184b:	c9                   	leaveq 
  80184c:	c3                   	retq   

000000000080184d <sys_cgetc>:

int
sys_cgetc(void)
{
  80184d:	55                   	push   %rbp
  80184e:	48 89 e5             	mov    %rsp,%rbp
  801851:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801855:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185c:	00 
  80185d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801863:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	be 00 00 00 00       	mov    $0x0,%esi
  801878:	bf 01 00 00 00       	mov    $0x1,%edi
  80187d:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801884:	00 00 00 
  801887:	ff d0                	callq  *%rax
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 10          	sub    $0x10,%rsp
  801893:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801896:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801899:	48 98                	cltq   
  80189b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a2:	00 
  8018a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b4:	48 89 c2             	mov    %rax,%rdx
  8018b7:	be 01 00 00 00       	mov    $0x1,%esi
  8018bc:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c1:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018de:	00 
  8018df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f5:	be 00 00 00 00       	mov    $0x0,%esi
  8018fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8018ff:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <sys_yield>:

void
sys_yield(void)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801915:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191c:	00 
  80191d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801923:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801929:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	be 00 00 00 00       	mov    $0x0,%esi
  801938:	bf 0b 00 00 00       	mov    $0xb,%edi
  80193d:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801944:	00 00 00 
  801947:	ff d0                	callq  *%rax
}
  801949:	c9                   	leaveq 
  80194a:	c3                   	retq   

000000000080194b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80194b:	55                   	push   %rbp
  80194c:	48 89 e5             	mov    %rsp,%rbp
  80194f:	48 83 ec 20          	sub    $0x20,%rsp
  801953:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801956:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80195d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801960:	48 63 c8             	movslq %eax,%rcx
  801963:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196a:	48 98                	cltq   
  80196c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801973:	00 
  801974:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197a:	49 89 c8             	mov    %rcx,%r8
  80197d:	48 89 d1             	mov    %rdx,%rcx
  801980:	48 89 c2             	mov    %rax,%rdx
  801983:	be 01 00 00 00       	mov    $0x1,%esi
  801988:	bf 04 00 00 00       	mov    $0x4,%edi
  80198d:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801994:	00 00 00 
  801997:	ff d0                	callq  *%rax
}
  801999:	c9                   	leaveq 
  80199a:	c3                   	retq   

000000000080199b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80199b:	55                   	push   %rbp
  80199c:	48 89 e5             	mov    %rsp,%rbp
  80199f:	48 83 ec 30          	sub    $0x30,%rsp
  8019a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019aa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ad:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019b1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019b5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019b8:	48 63 c8             	movslq %eax,%rcx
  8019bb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c2:	48 63 f0             	movslq %eax,%rsi
  8019c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cc:	48 98                	cltq   
  8019ce:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019d2:	49 89 f9             	mov    %rdi,%r9
  8019d5:	49 89 f0             	mov    %rsi,%r8
  8019d8:	48 89 d1             	mov    %rdx,%rcx
  8019db:	48 89 c2             	mov    %rax,%rdx
  8019de:	be 01 00 00 00       	mov    $0x1,%esi
  8019e3:	bf 05 00 00 00       	mov    $0x5,%edi
  8019e8:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 20          	sub    $0x20,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0c:	48 98                	cltq   
  801a0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a15:	00 
  801a16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a22:	48 89 d1             	mov    %rdx,%rcx
  801a25:	48 89 c2             	mov    %rax,%rdx
  801a28:	be 01 00 00 00       	mov    $0x1,%esi
  801a2d:	bf 06 00 00 00       	mov    $0x6,%edi
  801a32:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801a39:	00 00 00 
  801a3c:	ff d0                	callq  *%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 10          	sub    $0x10,%rsp
  801a48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a51:	48 63 d0             	movslq %eax,%rdx
  801a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a57:	48 98                	cltq   
  801a59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a60:	00 
  801a61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6d:	48 89 d1             	mov    %rdx,%rcx
  801a70:	48 89 c2             	mov    %rax,%rdx
  801a73:	be 01 00 00 00       	mov    $0x1,%esi
  801a78:	bf 08 00 00 00       	mov    $0x8,%edi
  801a7d:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	callq  *%rax
}
  801a89:	c9                   	leaveq 
  801a8a:	c3                   	retq   

0000000000801a8b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a8b:	55                   	push   %rbp
  801a8c:	48 89 e5             	mov    %rsp,%rbp
  801a8f:	48 83 ec 20          	sub    $0x20,%rsp
  801a93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa1:	48 98                	cltq   
  801aa3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aaa:	00 
  801aab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab7:	48 89 d1             	mov    %rdx,%rcx
  801aba:	48 89 c2             	mov    %rax,%rdx
  801abd:	be 01 00 00 00       	mov    $0x1,%esi
  801ac2:	bf 09 00 00 00       	mov    $0x9,%edi
  801ac7:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801ace:	00 00 00 
  801ad1:	ff d0                	callq  *%rax
}
  801ad3:	c9                   	leaveq 
  801ad4:	c3                   	retq   

0000000000801ad5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ad5:	55                   	push   %rbp
  801ad6:	48 89 e5             	mov    %rsp,%rbp
  801ad9:	48 83 ec 20          	sub    $0x20,%rsp
  801add:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aeb:	48 98                	cltq   
  801aed:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af4:	00 
  801af5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b01:	48 89 d1             	mov    %rdx,%rcx
  801b04:	48 89 c2             	mov    %rax,%rdx
  801b07:	be 01 00 00 00       	mov    $0x1,%esi
  801b0c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b11:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 20          	sub    $0x20,%rsp
  801b27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b2e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b32:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b38:	48 63 f0             	movslq %eax,%rsi
  801b3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b42:	48 98                	cltq   
  801b44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4f:	00 
  801b50:	49 89 f1             	mov    %rsi,%r9
  801b53:	49 89 c8             	mov    %rcx,%r8
  801b56:	48 89 d1             	mov    %rdx,%rcx
  801b59:	48 89 c2             	mov    %rax,%rdx
  801b5c:	be 00 00 00 00       	mov    $0x0,%esi
  801b61:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b66:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	callq  *%rax
}
  801b72:	c9                   	leaveq 
  801b73:	c3                   	retq   

0000000000801b74 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b74:	55                   	push   %rbp
  801b75:	48 89 e5             	mov    %rsp,%rbp
  801b78:	48 83 ec 10          	sub    $0x10,%rsp
  801b7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8b:	00 
  801b8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9d:	48 89 c2             	mov    %rax,%rdx
  801ba0:	be 01 00 00 00       	mov    $0x1,%esi
  801ba5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801baa:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801bb1:	00 00 00 
  801bb4:	ff d0                	callq  *%rax
}
  801bb6:	c9                   	leaveq 
  801bb7:	c3                   	retq   

0000000000801bb8 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 10          	sub    $0x10,%rsp
  801bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801bc4:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801bcb:	00 00 00 
  801bce:	48 8b 00             	mov    (%rax),%rax
  801bd1:	48 85 c0             	test   %rax,%rax
  801bd4:	0f 85 84 00 00 00    	jne    801c5e <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801bda:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801be1:	00 00 00 
  801be4:	48 8b 00             	mov    (%rax),%rax
  801be7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801bed:	ba 07 00 00 00       	mov    $0x7,%edx
  801bf2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801bf7:	89 c7                	mov    %eax,%edi
  801bf9:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  801c00:	00 00 00 
  801c03:	ff d0                	callq  *%rax
  801c05:	85 c0                	test   %eax,%eax
  801c07:	79 2a                	jns    801c33 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801c09:	48 ba b0 3b 80 00 00 	movabs $0x803bb0,%rdx
  801c10:	00 00 00 
  801c13:	be 23 00 00 00       	mov    $0x23,%esi
  801c18:	48 bf d7 3b 80 00 00 	movabs $0x803bd7,%rdi
  801c1f:	00 00 00 
  801c22:	b8 00 00 00 00       	mov    $0x0,%eax
  801c27:	48 b9 2e 02 80 00 00 	movabs $0x80022e,%rcx
  801c2e:	00 00 00 
  801c31:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801c33:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c3a:	00 00 00 
  801c3d:	48 8b 00             	mov    (%rax),%rax
  801c40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c46:	48 be 71 1c 80 00 00 	movabs $0x801c71,%rsi
  801c4d:	00 00 00 
  801c50:	89 c7                	mov    %eax,%edi
  801c52:	48 b8 d5 1a 80 00 00 	movabs $0x801ad5,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801c5e:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c65:	00 00 00 
  801c68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c6c:	48 89 10             	mov    %rdx,(%rax)
}
  801c6f:	c9                   	leaveq 
  801c70:	c3                   	retq   

0000000000801c71 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801c71:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801c74:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c7b:	00 00 00 
	call *%rax
  801c7e:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  801c80:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801c87:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801c88:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801c8f:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801c90:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801c94:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801c97:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801c9e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801c9f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801ca3:	4c 8b 3c 24          	mov    (%rsp),%r15
  801ca7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801cac:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801cb1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801cb6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801cbb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801cc0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801cc5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801cca:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801ccf:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801cd4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801cd9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801cde:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801ce3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801ce8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801ced:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801cf1:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801cf5:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801cf6:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801cf7:	c3                   	retq   

0000000000801cf8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf8:	55                   	push   %rbp
  801cf9:	48 89 e5             	mov    %rsp,%rbp
  801cfc:	48 83 ec 08          	sub    $0x8,%rsp
  801d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d08:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d0f:	ff ff ff 
  801d12:	48 01 d0             	add    %rdx,%rax
  801d15:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 08          	sub    $0x8,%rsp
  801d23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2b:	48 89 c7             	mov    %rax,%rdi
  801d2e:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d40:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 18          	sub    $0x18,%rsp
  801d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d59:	eb 6b                	jmp    801dc6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5e:	48 98                	cltq   
  801d60:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d66:	48 c1 e0 0c          	shl    $0xc,%rax
  801d6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d72:	48 c1 e8 15          	shr    $0x15,%rax
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d80:	01 00 00 
  801d83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d87:	83 e0 01             	and    $0x1,%eax
  801d8a:	48 85 c0             	test   %rax,%rax
  801d8d:	74 21                	je     801db0 <fd_alloc+0x6a>
  801d8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d93:	48 c1 e8 0c          	shr    $0xc,%rax
  801d97:	48 89 c2             	mov    %rax,%rdx
  801d9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da1:	01 00 00 
  801da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da8:	83 e0 01             	and    $0x1,%eax
  801dab:	48 85 c0             	test   %rax,%rax
  801dae:	75 12                	jne    801dc2 <fd_alloc+0x7c>
			*fd_store = fd;
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	eb 1a                	jmp    801ddc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dca:	7e 8f                	jle    801d5b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 20          	sub    $0x20,%rsp
  801de6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ded:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801df1:	78 06                	js     801df9 <fd_lookup+0x1b>
  801df3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df7:	7e 07                	jle    801e00 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfe:	eb 6c                	jmp    801e6c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e0b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e17:	48 c1 e8 15          	shr    $0x15,%rax
  801e1b:	48 89 c2             	mov    %rax,%rdx
  801e1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e25:	01 00 00 
  801e28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2c:	83 e0 01             	and    $0x1,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	74 21                	je     801e55 <fd_lookup+0x77>
  801e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e38:	48 c1 e8 0c          	shr    $0xc,%rax
  801e3c:	48 89 c2             	mov    %rax,%rdx
  801e3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e46:	01 00 00 
  801e49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4d:	83 e0 01             	and    $0x1,%eax
  801e50:	48 85 c0             	test   %rax,%rax
  801e53:	75 07                	jne    801e5c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e5a:	eb 10                	jmp    801e6c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e64:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6c:	c9                   	leaveq 
  801e6d:	c3                   	retq   

0000000000801e6e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e6e:	55                   	push   %rbp
  801e6f:	48 89 e5             	mov    %rsp,%rbp
  801e72:	48 83 ec 30          	sub    $0x30,%rsp
  801e76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e7a:	89 f0                	mov    %esi,%eax
  801e7c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e83:	48 89 c7             	mov    %rax,%rdi
  801e86:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
  801e92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e96:	48 89 d6             	mov    %rdx,%rsi
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  801ea2:	00 00 00 
  801ea5:	ff d0                	callq  *%rax
  801ea7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eae:	78 0a                	js     801eba <fd_close+0x4c>
	    || fd != fd2)
  801eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb8:	74 12                	je     801ecc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eba:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ebe:	74 05                	je     801ec5 <fd_close+0x57>
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec3:	eb 05                	jmp    801eca <fd_close+0x5c>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb 69                	jmp    801f35 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed0:	8b 00                	mov    (%rax),%eax
  801ed2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed6:	48 89 d6             	mov    %rdx,%rsi
  801ed9:	89 c7                	mov    %eax,%edi
  801edb:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eee:	78 2a                	js     801f1a <fd_close+0xac>
		if (dev->dev_close)
  801ef0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef8:	48 85 c0             	test   %rax,%rax
  801efb:	74 16                	je     801f13 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f01:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f05:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f09:	48 89 d7             	mov    %rdx,%rdi
  801f0c:	ff d0                	callq  *%rax
  801f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f11:	eb 07                	jmp    801f1a <fd_close+0xac>
		else
			r = 0;
  801f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	48 89 c6             	mov    %rax,%rsi
  801f21:	bf 00 00 00 00       	mov    $0x0,%edi
  801f26:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
	return r;
  801f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f35:	c9                   	leaveq 
  801f36:	c3                   	retq   

0000000000801f37 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f37:	55                   	push   %rbp
  801f38:	48 89 e5             	mov    %rsp,%rbp
  801f3b:	48 83 ec 20          	sub    $0x20,%rsp
  801f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4d:	eb 41                	jmp    801f90 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f4f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f56:	00 00 00 
  801f59:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5c:	48 63 d2             	movslq %edx,%rdx
  801f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f63:	8b 00                	mov    (%rax),%eax
  801f65:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f68:	75 22                	jne    801f8c <dev_lookup+0x55>
			*dev = devtab[i];
  801f6a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f71:	00 00 00 
  801f74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f77:	48 63 d2             	movslq %edx,%rdx
  801f7a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f82:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	eb 60                	jmp    801fec <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f90:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f97:	00 00 00 
  801f9a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f9d:	48 63 d2             	movslq %edx,%rdx
  801fa0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa4:	48 85 c0             	test   %rax,%rax
  801fa7:	75 a6                	jne    801f4f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fb0:	00 00 00 
  801fb3:	48 8b 00             	mov    (%rax),%rax
  801fb6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbf:	89 c6                	mov    %eax,%esi
  801fc1:	48 bf e8 3b 80 00 00 	movabs $0x803be8,%rdi
  801fc8:	00 00 00 
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  801fd7:	00 00 00 
  801fda:	ff d1                	callq  *%rcx
	*dev = 0;
  801fdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <close>:

int
close(int fdnum)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 20          	sub    $0x20,%rsp
  801ff6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ffd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802000:	48 89 d6             	mov    %rdx,%rsi
  802003:	89 c7                	mov    %eax,%edi
  802005:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802018:	79 05                	jns    80201f <close+0x31>
		return r;
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	eb 18                	jmp    802037 <close+0x49>
	else
		return fd_close(fd, 1);
  80201f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802023:	be 01 00 00 00       	mov    $0x1,%esi
  802028:	48 89 c7             	mov    %rax,%rdi
  80202b:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <close_all>:

void
close_all(void)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802041:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802048:	eb 15                	jmp    80205f <close_all+0x26>
		close(i);
  80204a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80205b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802063:	7e e5                	jle    80204a <close_all+0x11>
		close(i);
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 40          	sub    $0x40,%rsp
  80206f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802072:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802075:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802079:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80207c:	48 89 d6             	mov    %rdx,%rsi
  80207f:	89 c7                	mov    %eax,%edi
  802081:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802088:	00 00 00 
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802094:	79 08                	jns    80209e <dup+0x37>
		return r;
  802096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802099:	e9 70 01 00 00       	jmpq   80220e <dup+0x1a7>
	close(newfdnum);
  80209e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b2:	48 98                	cltq   
  8020b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8020be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c6:	48 89 c7             	mov    %rax,%rdi
  8020c9:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020dd:	48 89 c7             	mov    %rax,%rdi
  8020e0:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8020e7:	00 00 00 
  8020ea:	ff d0                	callq  *%rax
  8020ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f4:	48 c1 e8 15          	shr    $0x15,%rax
  8020f8:	48 89 c2             	mov    %rax,%rdx
  8020fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802102:	01 00 00 
  802105:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802109:	83 e0 01             	and    $0x1,%eax
  80210c:	48 85 c0             	test   %rax,%rax
  80210f:	74 73                	je     802184 <dup+0x11d>
  802111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802115:	48 c1 e8 0c          	shr    $0xc,%rax
  802119:	48 89 c2             	mov    %rax,%rdx
  80211c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802123:	01 00 00 
  802126:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212a:	83 e0 01             	and    $0x1,%eax
  80212d:	48 85 c0             	test   %rax,%rax
  802130:	74 52                	je     802184 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802136:	48 c1 e8 0c          	shr    $0xc,%rax
  80213a:	48 89 c2             	mov    %rax,%rdx
  80213d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802144:	01 00 00 
  802147:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214b:	25 07 0e 00 00       	and    $0xe07,%eax
  802150:	89 c1                	mov    %eax,%ecx
  802152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215a:	41 89 c8             	mov    %ecx,%r8d
  80215d:	48 89 d1             	mov    %rdx,%rcx
  802160:	ba 00 00 00 00       	mov    $0x0,%edx
  802165:	48 89 c6             	mov    %rax,%rsi
  802168:	bf 00 00 00 00       	mov    $0x0,%edi
  80216d:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802180:	79 02                	jns    802184 <dup+0x11d>
			goto err;
  802182:	eb 57                	jmp    8021db <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802184:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802188:	48 c1 e8 0c          	shr    $0xc,%rax
  80218c:	48 89 c2             	mov    %rax,%rdx
  80218f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802196:	01 00 00 
  802199:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219d:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021ac:	41 89 c8             	mov    %ecx,%r8d
  8021af:	48 89 d1             	mov    %rdx,%rcx
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b7:	48 89 c6             	mov    %rax,%rsi
  8021ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bf:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d2:	79 02                	jns    8021d6 <dup+0x16f>
		goto err;
  8021d4:	eb 05                	jmp    8021db <dup+0x174>

	return newfdnum;
  8021d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d9:	eb 33                	jmp    80220e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021df:	48 89 c6             	mov    %rax,%rsi
  8021e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e7:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f7:	48 89 c6             	mov    %rax,%rsi
  8021fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ff:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802206:	00 00 00 
  802209:	ff d0                	callq  *%rax
	return r;
  80220b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 40          	sub    $0x40,%rsp
  802218:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80221b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80221f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802223:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802227:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80222a:	48 89 d6             	mov    %rdx,%rsi
  80222d:	89 c7                	mov    %eax,%edi
  80222f:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802236:	00 00 00 
  802239:	ff d0                	callq  *%rax
  80223b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802242:	78 24                	js     802268 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	8b 00                	mov    (%rax),%eax
  80224a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80224e:	48 89 d6             	mov    %rdx,%rsi
  802251:	89 c7                	mov    %eax,%edi
  802253:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
  80225f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802262:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802266:	79 05                	jns    80226d <read+0x5d>
		return r;
  802268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80226b:	eb 76                	jmp    8022e3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80226d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802271:	8b 40 08             	mov    0x8(%rax),%eax
  802274:	83 e0 03             	and    $0x3,%eax
  802277:	83 f8 01             	cmp    $0x1,%eax
  80227a:	75 3a                	jne    8022b6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80227c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802283:	00 00 00 
  802286:	48 8b 00             	mov    (%rax),%rax
  802289:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80228f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802292:	89 c6                	mov    %eax,%esi
  802294:	48 bf 07 3c 80 00 00 	movabs $0x803c07,%rdi
  80229b:	00 00 00 
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  8022aa:	00 00 00 
  8022ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b4:	eb 2d                	jmp    8022e3 <read+0xd3>
	}
	if (!dev->dev_read)
  8022b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ba:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022be:	48 85 c0             	test   %rax,%rax
  8022c1:	75 07                	jne    8022ca <read+0xba>
		return -E_NOT_SUPP;
  8022c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c8:	eb 19                	jmp    8022e3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022de:	48 89 cf             	mov    %rcx,%rdi
  8022e1:	ff d0                	callq  *%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 30          	sub    $0x30,%rsp
  8022ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ff:	eb 49                	jmp    80234a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802304:	48 98                	cltq   
  802306:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80230a:	48 29 c2             	sub    %rax,%rdx
  80230d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802310:	48 63 c8             	movslq %eax,%rcx
  802313:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802317:	48 01 c1             	add    %rax,%rcx
  80231a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231d:	48 89 ce             	mov    %rcx,%rsi
  802320:	89 c7                	mov    %eax,%edi
  802322:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  802329:	00 00 00 
  80232c:	ff d0                	callq  *%rax
  80232e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802331:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802335:	79 05                	jns    80233c <readn+0x57>
			return m;
  802337:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80233a:	eb 1c                	jmp    802358 <readn+0x73>
		if (m == 0)
  80233c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802340:	75 02                	jne    802344 <readn+0x5f>
			break;
  802342:	eb 11                	jmp    802355 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802347:	01 45 fc             	add    %eax,-0x4(%rbp)
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	48 98                	cltq   
  80234f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802353:	72 ac                	jb     802301 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802355:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802358:	c9                   	leaveq 
  802359:	c3                   	retq   

000000000080235a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80235a:	55                   	push   %rbp
  80235b:	48 89 e5             	mov    %rsp,%rbp
  80235e:	48 83 ec 40          	sub    $0x40,%rsp
  802362:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802365:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802369:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802371:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802374:	48 89 d6             	mov    %rdx,%rsi
  802377:	89 c7                	mov    %eax,%edi
  802379:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
  802385:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802388:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238c:	78 24                	js     8023b2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	8b 00                	mov    (%rax),%eax
  802394:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802398:	48 89 d6             	mov    %rdx,%rsi
  80239b:	89 c7                	mov    %eax,%edi
  80239d:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
  8023a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b0:	79 05                	jns    8023b7 <write+0x5d>
		return r;
  8023b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b5:	eb 75                	jmp    80242c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bb:	8b 40 08             	mov    0x8(%rax),%eax
  8023be:	83 e0 03             	and    $0x3,%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	75 3a                	jne    8023ff <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023c5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023cc:	00 00 00 
  8023cf:	48 8b 00             	mov    (%rax),%rax
  8023d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023db:	89 c6                	mov    %eax,%esi
  8023dd:	48 bf 23 3c 80 00 00 	movabs $0x803c23,%rdi
  8023e4:	00 00 00 
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ec:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  8023f3:	00 00 00 
  8023f6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023fd:	eb 2d                	jmp    80242c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802403:	48 8b 40 18          	mov    0x18(%rax),%rax
  802407:	48 85 c0             	test   %rax,%rax
  80240a:	75 07                	jne    802413 <write+0xb9>
		return -E_NOT_SUPP;
  80240c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802411:	eb 19                	jmp    80242c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802417:	48 8b 40 18          	mov    0x18(%rax),%rax
  80241b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80241f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802423:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802427:	48 89 cf             	mov    %rcx,%rdi
  80242a:	ff d0                	callq  *%rax
}
  80242c:	c9                   	leaveq 
  80242d:	c3                   	retq   

000000000080242e <seek>:

int
seek(int fdnum, off_t offset)
{
  80242e:	55                   	push   %rbp
  80242f:	48 89 e5             	mov    %rsp,%rbp
  802432:	48 83 ec 18          	sub    $0x18,%rsp
  802436:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802439:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802440:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802443:	48 89 d6             	mov    %rdx,%rsi
  802446:	89 c7                	mov    %eax,%edi
  802448:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80244f:	00 00 00 
  802452:	ff d0                	callq  *%rax
  802454:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802457:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245b:	79 05                	jns    802462 <seek+0x34>
		return r;
  80245d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802460:	eb 0f                	jmp    802471 <seek+0x43>
	fd->fd_offset = offset;
  802462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802466:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802469:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 30          	sub    $0x30,%rsp
  80247b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802481:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802485:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802488:	48 89 d6             	mov    %rdx,%rsi
  80248b:	89 c7                	mov    %eax,%edi
  80248d:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802494:	00 00 00 
  802497:	ff d0                	callq  *%rax
  802499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a0:	78 24                	js     8024c6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a6:	8b 00                	mov    (%rax),%eax
  8024a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ac:	48 89 d6             	mov    %rdx,%rsi
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax
  8024bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c4:	79 05                	jns    8024cb <ftruncate+0x58>
		return r;
  8024c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c9:	eb 72                	jmp    80253d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cf:	8b 40 08             	mov    0x8(%rax),%eax
  8024d2:	83 e0 03             	and    $0x3,%eax
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	75 3a                	jne    802513 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024e0:	00 00 00 
  8024e3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  8024f8:	00 00 00 
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  802507:	00 00 00 
  80250a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80250c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802511:	eb 2a                	jmp    80253d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802517:	48 8b 40 30          	mov    0x30(%rax),%rax
  80251b:	48 85 c0             	test   %rax,%rax
  80251e:	75 07                	jne    802527 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802520:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802525:	eb 16                	jmp    80253d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802533:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802536:	89 ce                	mov    %ecx,%esi
  802538:	48 89 d7             	mov    %rdx,%rdi
  80253b:	ff d0                	callq  *%rax
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 30          	sub    $0x30,%rsp
  802547:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80254a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802552:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802555:	48 89 d6             	mov    %rdx,%rsi
  802558:	89 c7                	mov    %eax,%edi
  80255a:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802561:	00 00 00 
  802564:	ff d0                	callq  *%rax
  802566:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256d:	78 24                	js     802593 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802573:	8b 00                	mov    (%rax),%eax
  802575:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802579:	48 89 d6             	mov    %rdx,%rsi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 37 1f 80 00 00 	movabs $0x801f37,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802591:	79 05                	jns    802598 <fstat+0x59>
		return r;
  802593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802596:	eb 5e                	jmp    8025f6 <fstat+0xb7>
	if (!dev->dev_stat)
  802598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025a0:	48 85 c0             	test   %rax,%rax
  8025a3:	75 07                	jne    8025ac <fstat+0x6d>
		return -E_NOT_SUPP;
  8025a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025aa:	eb 4a                	jmp    8025f6 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025be:	00 00 00 
	stat->st_isdir = 0;
  8025c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025cc:	00 00 00 
	stat->st_dev = dev;
  8025cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025ea:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025ee:	48 89 ce             	mov    %rcx,%rsi
  8025f1:	48 89 d7             	mov    %rdx,%rdi
  8025f4:	ff d0                	callq  *%rax
}
  8025f6:	c9                   	leaveq 
  8025f7:	c3                   	retq   

00000000008025f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025f8:	55                   	push   %rbp
  8025f9:	48 89 e5             	mov    %rsp,%rbp
  8025fc:	48 83 ec 20          	sub    $0x20,%rsp
  802600:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802604:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	be 00 00 00 00       	mov    $0x0,%esi
  802611:	48 89 c7             	mov    %rax,%rdi
  802614:	48 b8 e6 26 80 00 00 	movabs $0x8026e6,%rax
  80261b:	00 00 00 
  80261e:	ff d0                	callq  *%rax
  802620:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802623:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802627:	79 05                	jns    80262e <stat+0x36>
		return fd;
  802629:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262c:	eb 2f                	jmp    80265d <stat+0x65>
	r = fstat(fd, stat);
  80262e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802635:	48 89 d6             	mov    %rdx,%rsi
  802638:	89 c7                	mov    %eax,%edi
  80263a:	48 b8 3f 25 80 00 00 	movabs $0x80253f,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802655:	00 00 00 
  802658:	ff d0                	callq  *%rax
	return r;
  80265a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80265d:	c9                   	leaveq 
  80265e:	c3                   	retq   

000000000080265f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80265f:	55                   	push   %rbp
  802660:	48 89 e5             	mov    %rsp,%rbp
  802663:	48 83 ec 10          	sub    $0x10,%rsp
  802667:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80266a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80266e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802675:	00 00 00 
  802678:	8b 00                	mov    (%rax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	75 1d                	jne    80269b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80267e:	bf 01 00 00 00       	mov    $0x1,%edi
  802683:	48 b8 05 35 80 00 00 	movabs $0x803505,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
  80268f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802696:	00 00 00 
  802699:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80269b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8026a2:	00 00 00 
  8026a5:	8b 00                	mov    (%rax),%eax
  8026a7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026aa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026af:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026b6:	00 00 00 
  8026b9:	89 c7                	mov    %eax,%edi
  8026bb:	48 b8 a3 34 80 00 00 	movabs $0x8034a3,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d0:	48 89 c6             	mov    %rax,%rsi
  8026d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d8:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
}
  8026e4:	c9                   	leaveq 
  8026e5:	c3                   	retq   

00000000008026e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026e6:	55                   	push   %rbp
  8026e7:	48 89 e5             	mov    %rsp,%rbp
  8026ea:	48 83 ec 30          	sub    $0x30,%rsp
  8026ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026f2:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026f5:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026fc:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80270a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80270f:	75 08                	jne    802719 <open+0x33>
	{
		return r;
  802711:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802714:	e9 f2 00 00 00       	jmpq   80280b <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271d:	48 89 c7             	mov    %rax,%rdi
  802720:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  802727:	00 00 00 
  80272a:	ff d0                	callq  *%rax
  80272c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80272f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802736:	7e 0a                	jle    802742 <open+0x5c>
	{
		return -E_BAD_PATH;
  802738:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80273d:	e9 c9 00 00 00       	jmpq   80280b <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802742:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802749:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80274a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80274e:	48 89 c7             	mov    %rax,%rdi
  802751:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	78 09                	js     80276f <open+0x89>
  802766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276a:	48 85 c0             	test   %rax,%rax
  80276d:	75 08                	jne    802777 <open+0x91>
		{
			return r;
  80276f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802772:	e9 94 00 00 00       	jmpq   80280b <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277b:	ba 00 04 00 00       	mov    $0x400,%edx
  802780:	48 89 c6             	mov    %rax,%rsi
  802783:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80278a:	00 00 00 
  80278d:	48 b8 ae 10 80 00 00 	movabs $0x8010ae,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802799:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027a0:	00 00 00 
  8027a3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027a6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	48 89 c6             	mov    %rax,%rsi
  8027b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8027b8:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8027bf:	00 00 00 
  8027c2:	ff d0                	callq  *%rax
  8027c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cb:	79 2b                	jns    8027f8 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d1:	be 00 00 00 00       	mov    $0x0,%esi
  8027d6:	48 89 c7             	mov    %rax,%rdi
  8027d9:	48 b8 6e 1e 80 00 00 	movabs $0x801e6e,%rax
  8027e0:	00 00 00 
  8027e3:	ff d0                	callq  *%rax
  8027e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ec:	79 05                	jns    8027f3 <open+0x10d>
			{
				return d;
  8027ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027f1:	eb 18                	jmp    80280b <open+0x125>
			}
			return r;
  8027f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f6:	eb 13                	jmp    80280b <open+0x125>
		}	
		return fd2num(fd_store);
  8027f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fc:	48 89 c7             	mov    %rax,%rdi
  8027ff:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80280b:	c9                   	leaveq 
  80280c:	c3                   	retq   

000000000080280d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80280d:	55                   	push   %rbp
  80280e:	48 89 e5             	mov    %rsp,%rbp
  802811:	48 83 ec 10          	sub    $0x10,%rsp
  802815:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281d:	8b 50 0c             	mov    0xc(%rax),%edx
  802820:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802827:	00 00 00 
  80282a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80282c:	be 00 00 00 00       	mov    $0x0,%esi
  802831:	bf 06 00 00 00       	mov    $0x6,%edi
  802836:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  80283d:	00 00 00 
  802840:	ff d0                	callq  *%rax
}
  802842:	c9                   	leaveq 
  802843:	c3                   	retq   

0000000000802844 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802844:	55                   	push   %rbp
  802845:	48 89 e5             	mov    %rsp,%rbp
  802848:	48 83 ec 30          	sub    $0x30,%rsp
  80284c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802850:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802854:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80285f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802864:	74 07                	je     80286d <devfile_read+0x29>
  802866:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80286b:	75 07                	jne    802874 <devfile_read+0x30>
		return -E_INVAL;
  80286d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802872:	eb 77                	jmp    8028eb <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	8b 50 0c             	mov    0xc(%rax),%edx
  80287b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802882:	00 00 00 
  802885:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802887:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80288e:	00 00 00 
  802891:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802895:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802899:	be 00 00 00 00       	mov    $0x0,%esi
  80289e:	bf 03 00 00 00       	mov    $0x3,%edi
  8028a3:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	7f 05                	jg     8028bd <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bb:	eb 2e                	jmp    8028eb <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c0:	48 63 d0             	movslq %eax,%rdx
  8028c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c7:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8028ce:	00 00 00 
  8028d1:	48 89 c7             	mov    %rax,%rdi
  8028d4:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028eb:	c9                   	leaveq 
  8028ec:	c3                   	retq   

00000000008028ed <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028ed:	55                   	push   %rbp
  8028ee:	48 89 e5             	mov    %rsp,%rbp
  8028f1:	48 83 ec 30          	sub    $0x30,%rsp
  8028f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802901:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802908:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80290d:	74 07                	je     802916 <devfile_write+0x29>
  80290f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802914:	75 08                	jne    80291e <devfile_write+0x31>
		return r;
  802916:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802919:	e9 9a 00 00 00       	jmpq   8029b8 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80291e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802922:	8b 50 0c             	mov    0xc(%rax),%edx
  802925:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80292c:	00 00 00 
  80292f:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802931:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802938:	00 
  802939:	76 08                	jbe    802943 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80293b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802942:	00 
	}
	fsipcbuf.write.req_n = n;
  802943:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80294a:	00 00 00 
  80294d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802951:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802955:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802959:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295d:	48 89 c6             	mov    %rax,%rsi
  802960:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802967:	00 00 00 
  80296a:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802976:	be 00 00 00 00       	mov    $0x0,%esi
  80297b:	bf 04 00 00 00       	mov    $0x4,%edi
  802980:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
  80298c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802993:	7f 20                	jg     8029b5 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802995:	48 bf 66 3c 80 00 00 	movabs $0x803c66,%rdi
  80299c:	00 00 00 
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  8029ab:	00 00 00 
  8029ae:	ff d2                	callq  *%rdx
		return r;
  8029b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b3:	eb 03                	jmp    8029b8 <devfile_write+0xcb>
	}
	return r;
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029b8:	c9                   	leaveq 
  8029b9:	c3                   	retq   

00000000008029ba <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029ba:	55                   	push   %rbp
  8029bb:	48 89 e5             	mov    %rsp,%rbp
  8029be:	48 83 ec 20          	sub    $0x20,%rsp
  8029c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ce:	8b 50 0c             	mov    0xc(%rax),%edx
  8029d1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029d8:	00 00 00 
  8029db:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029dd:	be 00 00 00 00       	mov    $0x0,%esi
  8029e2:	bf 05 00 00 00       	mov    $0x5,%edi
  8029e7:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fa:	79 05                	jns    802a01 <devfile_stat+0x47>
		return r;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ff:	eb 56                	jmp    802a57 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a05:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a0c:	00 00 00 
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a1e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a25:	00 00 00 
  802a28:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a32:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a3f:	00 00 00 
  802a42:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a57:	c9                   	leaveq 
  802a58:	c3                   	retq   

0000000000802a59 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a59:	55                   	push   %rbp
  802a5a:	48 89 e5             	mov    %rsp,%rbp
  802a5d:	48 83 ec 10          	sub    $0x10,%rsp
  802a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a65:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a76:	00 00 00 
  802a79:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a7b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a82:	00 00 00 
  802a85:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a8b:	be 00 00 00 00       	mov    $0x0,%esi
  802a90:	bf 02 00 00 00       	mov    $0x2,%edi
  802a95:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
}
  802aa1:	c9                   	leaveq 
  802aa2:	c3                   	retq   

0000000000802aa3 <remove>:

// Delete a file
int
remove(const char *path)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 10          	sub    $0x10,%rsp
  802aab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab3:	48 89 c7             	mov    %rax,%rdi
  802ab6:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
  802ac2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ac7:	7e 07                	jle    802ad0 <remove+0x2d>
		return -E_BAD_PATH;
  802ac9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ace:	eb 33                	jmp    802b03 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad4:	48 89 c6             	mov    %rax,%rsi
  802ad7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ade:	00 00 00 
  802ae1:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aed:	be 00 00 00 00       	mov    $0x0,%esi
  802af2:	bf 07 00 00 00       	mov    $0x7,%edi
  802af7:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b09:	be 00 00 00 00       	mov    $0x0,%esi
  802b0e:	bf 08 00 00 00       	mov    $0x8,%edi
  802b13:	48 b8 5f 26 80 00 00 	movabs $0x80265f,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
}
  802b1f:	5d                   	pop    %rbp
  802b20:	c3                   	retq   

0000000000802b21 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	53                   	push   %rbx
  802b26:	48 83 ec 38          	sub    $0x38,%rsp
  802b2a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b2e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802b32:	48 89 c7             	mov    %rax,%rdi
  802b35:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
  802b41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b48:	0f 88 bf 01 00 00    	js     802d0d <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b52:	ba 07 04 00 00       	mov    $0x407,%edx
  802b57:	48 89 c6             	mov    %rax,%rsi
  802b5a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5f:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
  802b6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b72:	0f 88 95 01 00 00    	js     802d0d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b78:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b7c:	48 89 c7             	mov    %rax,%rdi
  802b7f:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
  802b8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b92:	0f 88 5d 01 00 00    	js     802cf5 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b9c:	ba 07 04 00 00       	mov    $0x407,%edx
  802ba1:	48 89 c6             	mov    %rax,%rsi
  802ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba9:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	callq  *%rax
  802bb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bbc:	0f 88 33 01 00 00    	js     802cf5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802bc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc6:	48 89 c7             	mov    %rax,%rdi
  802bc9:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
  802bd5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bdd:	ba 07 04 00 00       	mov    $0x407,%edx
  802be2:	48 89 c6             	mov    %rax,%rsi
  802be5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bea:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  802bf1:	00 00 00 
  802bf4:	ff d0                	callq  *%rax
  802bf6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bfd:	79 05                	jns    802c04 <pipe+0xe3>
		goto err2;
  802bff:	e9 d9 00 00 00       	jmpq   802cdd <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c08:	48 89 c7             	mov    %rax,%rdi
  802c0b:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	48 89 c2             	mov    %rax,%rdx
  802c1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c1e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802c24:	48 89 d1             	mov    %rdx,%rcx
  802c27:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2c:	48 89 c6             	mov    %rax,%rsi
  802c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c34:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c43:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c47:	79 1b                	jns    802c64 <pipe+0x143>
		goto err3;
  802c49:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802c4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c4e:	48 89 c6             	mov    %rax,%rsi
  802c51:	bf 00 00 00 00       	mov    $0x0,%edi
  802c56:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
  802c62:	eb 79                	jmp    802cdd <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c68:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802c6f:	00 00 00 
  802c72:	8b 12                	mov    (%rdx),%edx
  802c74:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802c81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c85:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802c8c:	00 00 00 
  802c8f:	8b 12                	mov    (%rdx),%edx
  802c91:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802c93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c97:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802c9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca2:	48 89 c7             	mov    %rax,%rdi
  802ca5:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
  802cb1:	89 c2                	mov    %eax,%edx
  802cb3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802cb7:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802cb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802cbd:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802cc1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	89 03                	mov    %eax,(%rbx)
	return 0;
  802cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdb:	eb 33                	jmp    802d10 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802cdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce1:	48 89 c6             	mov    %rax,%rsi
  802ce4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce9:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802cf0:	00 00 00 
  802cf3:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802cf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf9:	48 89 c6             	mov    %rax,%rsi
  802cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  802d01:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
    err:
	return r;
  802d0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802d10:	48 83 c4 38          	add    $0x38,%rsp
  802d14:	5b                   	pop    %rbx
  802d15:	5d                   	pop    %rbp
  802d16:	c3                   	retq   

0000000000802d17 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	53                   	push   %rbx
  802d1c:	48 83 ec 28          	sub    $0x28,%rsp
  802d20:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d24:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802d28:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d2f:	00 00 00 
  802d32:	48 8b 00             	mov    (%rax),%rax
  802d35:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802d3b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802d3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d42:	48 89 c7             	mov    %rax,%rdi
  802d45:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
  802d51:	89 c3                	mov    %eax,%ebx
  802d53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d57:	48 89 c7             	mov    %rax,%rdi
  802d5a:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
  802d66:	39 c3                	cmp    %eax,%ebx
  802d68:	0f 94 c0             	sete   %al
  802d6b:	0f b6 c0             	movzbl %al,%eax
  802d6e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802d71:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d78:	00 00 00 
  802d7b:	48 8b 00             	mov    (%rax),%rax
  802d7e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802d84:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802d87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802d8d:	75 05                	jne    802d94 <_pipeisclosed+0x7d>
			return ret;
  802d8f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d92:	eb 4f                	jmp    802de3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802d94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d97:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802d9a:	74 42                	je     802dde <_pipeisclosed+0xc7>
  802d9c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802da0:	75 3c                	jne    802dde <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802da2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802da9:	00 00 00 
  802dac:	48 8b 00             	mov    (%rax),%rax
  802daf:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802db5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802db8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dbb:	89 c6                	mov    %eax,%esi
  802dbd:	48 bf 87 3c 80 00 00 	movabs $0x803c87,%rdi
  802dc4:	00 00 00 
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcc:	49 b8 67 04 80 00 00 	movabs $0x800467,%r8
  802dd3:	00 00 00 
  802dd6:	41 ff d0             	callq  *%r8
	}
  802dd9:	e9 4a ff ff ff       	jmpq   802d28 <_pipeisclosed+0x11>
  802dde:	e9 45 ff ff ff       	jmpq   802d28 <_pipeisclosed+0x11>
}
  802de3:	48 83 c4 28          	add    $0x28,%rsp
  802de7:	5b                   	pop    %rbx
  802de8:	5d                   	pop    %rbp
  802de9:	c3                   	retq   

0000000000802dea <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802dea:	55                   	push   %rbp
  802deb:	48 89 e5             	mov    %rsp,%rbp
  802dee:	48 83 ec 30          	sub    $0x30,%rsp
  802df2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802df5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802df9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802dfc:	48 89 d6             	mov    %rdx,%rsi
  802dff:	89 c7                	mov    %eax,%edi
  802e01:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  802e08:	00 00 00 
  802e0b:	ff d0                	callq  *%rax
  802e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e14:	79 05                	jns    802e1b <pipeisclosed+0x31>
		return r;
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	eb 31                	jmp    802e4c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1f:	48 89 c7             	mov    %rax,%rdi
  802e22:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802e29:	00 00 00 
  802e2c:	ff d0                	callq  *%rax
  802e2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e3a:	48 89 d6             	mov    %rdx,%rsi
  802e3d:	48 89 c7             	mov    %rax,%rdi
  802e40:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 40          	sub    $0x40,%rsp
  802e56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e5e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e66:	48 89 c7             	mov    %rax,%rdi
  802e69:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802e70:	00 00 00 
  802e73:	ff d0                	callq  *%rax
  802e75:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e81:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802e88:	00 
  802e89:	e9 92 00 00 00       	jmpq   802f20 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802e8e:	eb 41                	jmp    802ed1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802e90:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802e95:	74 09                	je     802ea0 <devpipe_read+0x52>
				return i;
  802e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9b:	e9 92 00 00 00       	jmpq   802f32 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ea0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea8:	48 89 d6             	mov    %rdx,%rsi
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	74 07                	je     802ec5 <devpipe_read+0x77>
				return 0;
  802ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec3:	eb 6d                	jmp    802f32 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802ec5:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ed1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed5:	8b 10                	mov    (%rax),%edx
  802ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edb:	8b 40 04             	mov    0x4(%rax),%eax
  802ede:	39 c2                	cmp    %eax,%edx
  802ee0:	74 ae                	je     802e90 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eea:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef2:	8b 00                	mov    (%rax),%eax
  802ef4:	99                   	cltd   
  802ef5:	c1 ea 1b             	shr    $0x1b,%edx
  802ef8:	01 d0                	add    %edx,%eax
  802efa:	83 e0 1f             	and    $0x1f,%eax
  802efd:	29 d0                	sub    %edx,%eax
  802eff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f03:	48 98                	cltq   
  802f05:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802f0a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f10:	8b 00                	mov    (%rax),%eax
  802f12:	8d 50 01             	lea    0x1(%rax),%edx
  802f15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f19:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f1b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f24:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f28:	0f 82 60 ff ff ff    	jb     802e8e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802f2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f32:	c9                   	leaveq 
  802f33:	c3                   	retq   

0000000000802f34 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f34:	55                   	push   %rbp
  802f35:	48 89 e5             	mov    %rsp,%rbp
  802f38:	48 83 ec 40          	sub    $0x40,%rsp
  802f3c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f40:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f44:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4c:	48 89 c7             	mov    %rax,%rdi
  802f4f:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802f56:	00 00 00 
  802f59:	ff d0                	callq  *%rax
  802f5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f67:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f6e:	00 
  802f6f:	e9 8e 00 00 00       	jmpq   803002 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f74:	eb 31                	jmp    802fa7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802f76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7e:	48 89 d6             	mov    %rdx,%rsi
  802f81:	48 89 c7             	mov    %rax,%rdi
  802f84:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 07                	je     802f9b <devpipe_write+0x67>
				return 0;
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	eb 79                	jmp    803014 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f9b:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fab:	8b 40 04             	mov    0x4(%rax),%eax
  802fae:	48 63 d0             	movslq %eax,%rdx
  802fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb5:	8b 00                	mov    (%rax),%eax
  802fb7:	48 98                	cltq   
  802fb9:	48 83 c0 20          	add    $0x20,%rax
  802fbd:	48 39 c2             	cmp    %rax,%rdx
  802fc0:	73 b4                	jae    802f76 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	8b 40 04             	mov    0x4(%rax),%eax
  802fc9:	99                   	cltd   
  802fca:	c1 ea 1b             	shr    $0x1b,%edx
  802fcd:	01 d0                	add    %edx,%eax
  802fcf:	83 e0 1f             	and    $0x1f,%eax
  802fd2:	29 d0                	sub    %edx,%eax
  802fd4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fd8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802fdc:	48 01 ca             	add    %rcx,%rdx
  802fdf:	0f b6 0a             	movzbl (%rdx),%ecx
  802fe2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fe6:	48 98                	cltq   
  802fe8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff0:	8b 40 04             	mov    0x4(%rax),%eax
  802ff3:	8d 50 01             	lea    0x1(%rax),%edx
  802ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffa:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ffd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803006:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80300a:	0f 82 64 ff ff ff    	jb     802f74 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803014:	c9                   	leaveq 
  803015:	c3                   	retq   

0000000000803016 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803016:	55                   	push   %rbp
  803017:	48 89 e5             	mov    %rsp,%rbp
  80301a:	48 83 ec 20          	sub    $0x20,%rsp
  80301e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803022:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302a:	48 89 c7             	mov    %rax,%rdi
  80302d:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
  803039:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80303d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803041:	48 be 9a 3c 80 00 00 	movabs $0x803c9a,%rsi
  803048:	00 00 00 
  80304b:	48 89 c7             	mov    %rax,%rdi
  80304e:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  803055:	00 00 00 
  803058:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80305a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80305e:	8b 50 04             	mov    0x4(%rax),%edx
  803061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803065:	8b 00                	mov    (%rax),%eax
  803067:	29 c2                	sub    %eax,%edx
  803069:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80306d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803073:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803077:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80307e:	00 00 00 
	stat->st_dev = &devpipe;
  803081:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803085:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80308c:	00 00 00 
  80308f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 10          	sub    $0x10,%rsp
  8030a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8030a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ad:	48 89 c6             	mov    %rax,%rsi
  8030b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b5:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8030c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c5:	48 89 c7             	mov    %rax,%rdi
  8030c8:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	48 89 c6             	mov    %rax,%rsi
  8030d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8030dc:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
}
  8030e8:	c9                   	leaveq 
  8030e9:	c3                   	retq   

00000000008030ea <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8030ea:	55                   	push   %rbp
  8030eb:	48 89 e5             	mov    %rsp,%rbp
  8030ee:	48 83 ec 20          	sub    $0x20,%rsp
  8030f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8030f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030f8:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8030fb:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8030ff:	be 01 00 00 00       	mov    $0x1,%esi
  803104:	48 89 c7             	mov    %rax,%rdi
  803107:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
}
  803113:	c9                   	leaveq 
  803114:	c3                   	retq   

0000000000803115 <getchar>:

int
getchar(void)
{
  803115:	55                   	push   %rbp
  803116:	48 89 e5             	mov    %rsp,%rbp
  803119:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80311d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803121:	ba 01 00 00 00       	mov    $0x1,%edx
  803126:	48 89 c6             	mov    %rax,%rsi
  803129:	bf 00 00 00 00       	mov    $0x0,%edi
  80312e:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803135:	00 00 00 
  803138:	ff d0                	callq  *%rax
  80313a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80313d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803141:	79 05                	jns    803148 <getchar+0x33>
		return r;
  803143:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803146:	eb 14                	jmp    80315c <getchar+0x47>
	if (r < 1)
  803148:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314c:	7f 07                	jg     803155 <getchar+0x40>
		return -E_EOF;
  80314e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803153:	eb 07                	jmp    80315c <getchar+0x47>
	return c;
  803155:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803159:	0f b6 c0             	movzbl %al,%eax
}
  80315c:	c9                   	leaveq 
  80315d:	c3                   	retq   

000000000080315e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80315e:	55                   	push   %rbp
  80315f:	48 89 e5             	mov    %rsp,%rbp
  803162:	48 83 ec 20          	sub    $0x20,%rsp
  803166:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803169:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80316d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803170:	48 89 d6             	mov    %rdx,%rsi
  803173:	89 c7                	mov    %eax,%edi
  803175:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  80317c:	00 00 00 
  80317f:	ff d0                	callq  *%rax
  803181:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803184:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803188:	79 05                	jns    80318f <iscons+0x31>
		return r;
  80318a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318d:	eb 1a                	jmp    8031a9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80318f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803193:	8b 10                	mov    (%rax),%edx
  803195:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80319c:	00 00 00 
  80319f:	8b 00                	mov    (%rax),%eax
  8031a1:	39 c2                	cmp    %eax,%edx
  8031a3:	0f 94 c0             	sete   %al
  8031a6:	0f b6 c0             	movzbl %al,%eax
}
  8031a9:	c9                   	leaveq 
  8031aa:	c3                   	retq   

00000000008031ab <opencons>:

int
opencons(void)
{
  8031ab:	55                   	push   %rbp
  8031ac:	48 89 e5             	mov    %rsp,%rbp
  8031af:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8031b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031b7:	48 89 c7             	mov    %rax,%rdi
  8031ba:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
  8031c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cd:	79 05                	jns    8031d4 <opencons+0x29>
		return r;
  8031cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d2:	eb 5b                	jmp    80322f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8031d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8031dd:	48 89 c6             	mov    %rax,%rsi
  8031e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e5:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f8:	79 05                	jns    8031ff <opencons+0x54>
		return r;
  8031fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fd:	eb 30                	jmp    80322f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8031ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803203:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80320a:	00 00 00 
  80320d:	8b 12                	mov    (%rdx),%edx
  80320f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80321c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803220:	48 89 c7             	mov    %rax,%rdi
  803223:	48 b8 f8 1c 80 00 00 	movabs $0x801cf8,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
}
  80322f:	c9                   	leaveq 
  803230:	c3                   	retq   

0000000000803231 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803231:	55                   	push   %rbp
  803232:	48 89 e5             	mov    %rsp,%rbp
  803235:	48 83 ec 30          	sub    $0x30,%rsp
  803239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80323d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803241:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803245:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80324a:	75 07                	jne    803253 <devcons_read+0x22>
		return 0;
  80324c:	b8 00 00 00 00       	mov    $0x0,%eax
  803251:	eb 4b                	jmp    80329e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803253:	eb 0c                	jmp    803261 <devcons_read+0x30>
		sys_yield();
  803255:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803261:	48 b8 4d 18 80 00 00 	movabs $0x80184d,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
  80326d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803274:	74 df                	je     803255 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327a:	79 05                	jns    803281 <devcons_read+0x50>
		return c;
  80327c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327f:	eb 1d                	jmp    80329e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803281:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803285:	75 07                	jne    80328e <devcons_read+0x5d>
		return 0;
  803287:	b8 00 00 00 00       	mov    $0x0,%eax
  80328c:	eb 10                	jmp    80329e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80328e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803291:	89 c2                	mov    %eax,%edx
  803293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803297:	88 10                	mov    %dl,(%rax)
	return 1;
  803299:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80329e:	c9                   	leaveq 
  80329f:	c3                   	retq   

00000000008032a0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
  8032a4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8032ab:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8032b2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8032b9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8032c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032c7:	eb 76                	jmp    80333f <devcons_write+0x9f>
		m = n - tot;
  8032c9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8032d0:	89 c2                	mov    %eax,%edx
  8032d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d5:	29 c2                	sub    %eax,%edx
  8032d7:	89 d0                	mov    %edx,%eax
  8032d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8032dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032df:	83 f8 7f             	cmp    $0x7f,%eax
  8032e2:	76 07                	jbe    8032eb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8032e4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8032eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032ee:	48 63 d0             	movslq %eax,%rdx
  8032f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f4:	48 63 c8             	movslq %eax,%rcx
  8032f7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8032fe:	48 01 c1             	add    %rax,%rcx
  803301:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803308:	48 89 ce             	mov    %rcx,%rsi
  80330b:	48 89 c7             	mov    %rax,%rdi
  80330e:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80331a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80331d:	48 63 d0             	movslq %eax,%rdx
  803320:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803327:	48 89 d6             	mov    %rdx,%rsi
  80332a:	48 89 c7             	mov    %rax,%rdi
  80332d:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803339:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80333c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80333f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803342:	48 98                	cltq   
  803344:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80334b:	0f 82 78 ff ff ff    	jb     8032c9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803351:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	48 83 ec 08          	sub    $0x8,%rsp
  80335e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803367:	c9                   	leaveq 
  803368:	c3                   	retq   

0000000000803369 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803369:	55                   	push   %rbp
  80336a:	48 89 e5             	mov    %rsp,%rbp
  80336d:	48 83 ec 10          	sub    $0x10,%rsp
  803371:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803375:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337d:	48 be a6 3c 80 00 00 	movabs $0x803ca6,%rsi
  803384:	00 00 00 
  803387:	48 89 c7             	mov    %rax,%rdi
  80338a:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
	return 0;
  803396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 30          	sub    $0x30,%rsp
  8033a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8033b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033b8:	00 00 00 
  8033bb:	48 8b 00             	mov    (%rax),%rax
  8033be:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	75 3c                	jne    803404 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8033c8:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8033d9:	48 63 d0             	movslq %eax,%rdx
  8033dc:	48 89 d0             	mov    %rdx,%rax
  8033df:	48 c1 e0 03          	shl    $0x3,%rax
  8033e3:	48 01 d0             	add    %rdx,%rax
  8033e6:	48 c1 e0 05          	shl    $0x5,%rax
  8033ea:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8033f1:	00 00 00 
  8033f4:	48 01 c2             	add    %rax,%rdx
  8033f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033fe:	00 00 00 
  803401:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803404:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803409:	75 0e                	jne    803419 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80340b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803412:	00 00 00 
  803415:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803419:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80342f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803433:	79 19                	jns    80344e <ipc_recv+0xb1>
		*from_env_store = 0;
  803435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803439:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80343f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803443:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	eb 53                	jmp    8034a1 <ipc_recv+0x104>
	}
	if(from_env_store)
  80344e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803453:	74 19                	je     80346e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803455:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80345c:	00 00 00 
  80345f:	48 8b 00             	mov    (%rax),%rax
  803462:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80346e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803473:	74 19                	je     80348e <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803475:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80347c:	00 00 00 
  80347f:	48 8b 00             	mov    (%rax),%rax
  803482:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80348c:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80348e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803495:	00 00 00 
  803498:	48 8b 00             	mov    (%rax),%rax
  80349b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8034a1:	c9                   	leaveq 
  8034a2:	c3                   	retq   

00000000008034a3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034a3:	55                   	push   %rbp
  8034a4:	48 89 e5             	mov    %rsp,%rbp
  8034a7:	48 83 ec 30          	sub    $0x30,%rsp
  8034ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034ae:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034b1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034b5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8034b8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034bd:	75 0e                	jne    8034cd <ipc_send+0x2a>
		pg = (void*)UTOP;
  8034bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034c6:	00 00 00 
  8034c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8034cd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8034d0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8034d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034da:	89 c7                	mov    %eax,%edi
  8034dc:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
  8034e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8034eb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034ef:	75 0c                	jne    8034fd <ipc_send+0x5a>
			sys_yield();
  8034f1:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8034fd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803501:	74 ca                	je     8034cd <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803503:	c9                   	leaveq 
  803504:	c3                   	retq   

0000000000803505 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	48 83 ec 14          	sub    $0x14,%rsp
  80350d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803510:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803517:	eb 5e                	jmp    803577 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803519:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803520:	00 00 00 
  803523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803526:	48 63 d0             	movslq %eax,%rdx
  803529:	48 89 d0             	mov    %rdx,%rax
  80352c:	48 c1 e0 03          	shl    $0x3,%rax
  803530:	48 01 d0             	add    %rdx,%rax
  803533:	48 c1 e0 05          	shl    $0x5,%rax
  803537:	48 01 c8             	add    %rcx,%rax
  80353a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803540:	8b 00                	mov    (%rax),%eax
  803542:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803545:	75 2c                	jne    803573 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803547:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80354e:	00 00 00 
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	48 63 d0             	movslq %eax,%rdx
  803557:	48 89 d0             	mov    %rdx,%rax
  80355a:	48 c1 e0 03          	shl    $0x3,%rax
  80355e:	48 01 d0             	add    %rdx,%rax
  803561:	48 c1 e0 05          	shl    $0x5,%rax
  803565:	48 01 c8             	add    %rcx,%rax
  803568:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80356e:	8b 40 08             	mov    0x8(%rax),%eax
  803571:	eb 12                	jmp    803585 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803573:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803577:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80357e:	7e 99                	jle    803519 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	48 83 ec 18          	sub    $0x18,%rsp
  80358f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803597:	48 c1 e8 15          	shr    $0x15,%rax
  80359b:	48 89 c2             	mov    %rax,%rdx
  80359e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035a5:	01 00 00 
  8035a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ac:	83 e0 01             	and    $0x1,%eax
  8035af:	48 85 c0             	test   %rax,%rax
  8035b2:	75 07                	jne    8035bb <pageref+0x34>
		return 0;
  8035b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b9:	eb 53                	jmp    80360e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8035c3:	48 89 c2             	mov    %rax,%rdx
  8035c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035cd:	01 00 00 
  8035d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dc:	83 e0 01             	and    $0x1,%eax
  8035df:	48 85 c0             	test   %rax,%rax
  8035e2:	75 07                	jne    8035eb <pageref+0x64>
		return 0;
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e9:	eb 23                	jmp    80360e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8035f3:	48 89 c2             	mov    %rax,%rdx
  8035f6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035fd:	00 00 00 
  803600:	48 c1 e2 04          	shl    $0x4,%rdx
  803604:	48 01 d0             	add    %rdx,%rax
  803607:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80360b:	0f b7 c0             	movzwl %ax,%eax
}
  80360e:	c9                   	leaveq 
  80360f:	c3                   	retq   
