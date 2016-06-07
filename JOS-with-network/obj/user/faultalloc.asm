
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
  800061:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
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
  8000bd:	48 ba f0 40 80 00 00 	movabs $0x8040f0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 1b 41 80 00 00 	movabs $0x80411b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 2e 02 80 00 00 	movabs $0x80022e,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 30 41 80 00 00 	movabs $0x804130,%rdx
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
  800132:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf 51 41 80 00 00 	movabs $0x804151,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf 51 41 80 00 00 	movabs $0x804151,%rdi
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
  8001be:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8001d8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  80020f:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
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
  8002b7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8002e8:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
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
  800324:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
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
  8005d3:	48 ba 90 43 80 00 00 	movabs $0x804390,%rdx
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
  8008cb:	48 b8 b8 43 80 00 00 	movabs $0x8043b8,%rax
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
  800a19:	83 fb 15             	cmp    $0x15,%ebx
  800a1c:	7f 16                	jg     800a34 <vprintfmt+0x21a>
  800a1e:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  800a25:	00 00 00 
  800a28:	48 63 d3             	movslq %ebx,%rdx
  800a2b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a2f:	4d 85 e4             	test   %r12,%r12
  800a32:	75 2e                	jne    800a62 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	89 d9                	mov    %ebx,%ecx
  800a3e:	48 ba a1 43 80 00 00 	movabs $0x8043a1,%rdx
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
  800a6d:	48 ba aa 43 80 00 00 	movabs $0x8043aa,%rdx
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
  800ac7:	49 bc ad 43 80 00 00 	movabs $0x8043ad,%r12
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
  8017cd:	48 ba 68 46 80 00 00 	movabs $0x804668,%rdx
  8017d4:	00 00 00 
  8017d7:	be 23 00 00 00       	mov    $0x23,%esi
  8017dc:	48 bf 85 46 80 00 00 	movabs $0x804685,%rdi
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

0000000000801bb8 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 20          	sub    $0x20,%rsp
  801bc0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd7:	00 
  801bd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be9:	89 c6                	mov    %eax,%esi
  801beb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bf0:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801bf7:	00 00 00 
  801bfa:	ff d0                	callq  *%rax
}
  801bfc:	c9                   	leaveq 
  801bfd:	c3                   	retq   

0000000000801bfe <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801bfe:	55                   	push   %rbp
  801bff:	48 89 e5             	mov    %rsp,%rbp
  801c02:	48 83 ec 20          	sub    $0x20,%rsp
  801c06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c0a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1d:	00 
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2f:	89 c6                	mov    %eax,%esi
  801c31:	bf 10 00 00 00       	mov    $0x10,%edi
  801c36:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801c3d:	00 00 00 
  801c40:	ff d0                	callq  *%rax
}
  801c42:	c9                   	leaveq 
  801c43:	c3                   	retq   

0000000000801c44 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c44:	55                   	push   %rbp
  801c45:	48 89 e5             	mov    %rsp,%rbp
  801c48:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c53:	00 
  801c54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c60:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c65:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6a:	be 00 00 00 00       	mov    $0x0,%esi
  801c6f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c74:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 10          	sub    $0x10,%rsp
  801c8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801c8e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801c95:	00 00 00 
  801c98:	48 8b 00             	mov    (%rax),%rax
  801c9b:	48 85 c0             	test   %rax,%rax
  801c9e:	0f 85 84 00 00 00    	jne    801d28 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801ca4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801cab:	00 00 00 
  801cae:	48 8b 00             	mov    (%rax),%rax
  801cb1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801cb7:	ba 07 00 00 00       	mov    $0x7,%edx
  801cbc:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801cc1:	89 c7                	mov    %eax,%edi
  801cc3:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	79 2a                	jns    801cfd <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801cd3:	48 ba 98 46 80 00 00 	movabs $0x804698,%rdx
  801cda:	00 00 00 
  801cdd:	be 23 00 00 00       	mov    $0x23,%esi
  801ce2:	48 bf bf 46 80 00 00 	movabs $0x8046bf,%rdi
  801ce9:	00 00 00 
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf1:	48 b9 2e 02 80 00 00 	movabs $0x80022e,%rcx
  801cf8:	00 00 00 
  801cfb:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801cfd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801d04:	00 00 00 
  801d07:	48 8b 00             	mov    (%rax),%rax
  801d0a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d10:	48 be 3b 1d 80 00 00 	movabs $0x801d3b,%rsi
  801d17:	00 00 00 
  801d1a:	89 c7                	mov    %eax,%edi
  801d1c:	48 b8 d5 1a 80 00 00 	movabs $0x801ad5,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801d28:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801d2f:	00 00 00 
  801d32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d36:	48 89 10             	mov    %rdx,(%rax)
}
  801d39:	c9                   	leaveq 
  801d3a:	c3                   	retq   

0000000000801d3b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801d3b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801d3e:	48 a1 10 70 80 00 00 	movabs 0x807010,%rax
  801d45:	00 00 00 
call *%rax
  801d48:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  801d4a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801d51:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801d52:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801d59:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801d5a:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801d5e:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801d61:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801d68:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801d69:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801d6d:	4c 8b 3c 24          	mov    (%rsp),%r15
  801d71:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801d76:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801d7b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801d80:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801d85:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801d8a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801d8f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801d94:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801d99:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801d9e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801da3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801da8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801dad:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801db2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801db7:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801dbb:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801dbf:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801dc0:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801dc1:	c3                   	retq   

0000000000801dc2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 08          	sub    $0x8,%rsp
  801dca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dd9:	ff ff ff 
  801ddc:	48 01 d0             	add    %rdx,%rax
  801ddf:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	48 83 ec 08          	sub    $0x8,%rsp
  801ded:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df5:	48 89 c7             	mov    %rax,%rdi
  801df8:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  801dff:	00 00 00 
  801e02:	ff d0                	callq  *%rax
  801e04:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e0a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e0e:	c9                   	leaveq 
  801e0f:	c3                   	retq   

0000000000801e10 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e10:	55                   	push   %rbp
  801e11:	48 89 e5             	mov    %rsp,%rbp
  801e14:	48 83 ec 18          	sub    $0x18,%rsp
  801e18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e23:	eb 6b                	jmp    801e90 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e28:	48 98                	cltq   
  801e2a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e30:	48 c1 e0 0c          	shl    $0xc,%rax
  801e34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e3c:	48 c1 e8 15          	shr    $0x15,%rax
  801e40:	48 89 c2             	mov    %rax,%rdx
  801e43:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e4a:	01 00 00 
  801e4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e51:	83 e0 01             	and    $0x1,%eax
  801e54:	48 85 c0             	test   %rax,%rax
  801e57:	74 21                	je     801e7a <fd_alloc+0x6a>
  801e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5d:	48 c1 e8 0c          	shr    $0xc,%rax
  801e61:	48 89 c2             	mov    %rax,%rdx
  801e64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e6b:	01 00 00 
  801e6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e72:	83 e0 01             	and    $0x1,%eax
  801e75:	48 85 c0             	test   %rax,%rax
  801e78:	75 12                	jne    801e8c <fd_alloc+0x7c>
			*fd_store = fd;
  801e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e82:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8a:	eb 1a                	jmp    801ea6 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e90:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e94:	7e 8f                	jle    801e25 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ea1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ea6:	c9                   	leaveq 
  801ea7:	c3                   	retq   

0000000000801ea8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	48 83 ec 20          	sub    $0x20,%rsp
  801eb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801eb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ebb:	78 06                	js     801ec3 <fd_lookup+0x1b>
  801ebd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ec1:	7e 07                	jle    801eca <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec8:	eb 6c                	jmp    801f36 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801eca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ecd:	48 98                	cltq   
  801ecf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ed5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801edd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee1:	48 c1 e8 15          	shr    $0x15,%rax
  801ee5:	48 89 c2             	mov    %rax,%rdx
  801ee8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eef:	01 00 00 
  801ef2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef6:	83 e0 01             	and    $0x1,%eax
  801ef9:	48 85 c0             	test   %rax,%rax
  801efc:	74 21                	je     801f1f <fd_lookup+0x77>
  801efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f02:	48 c1 e8 0c          	shr    $0xc,%rax
  801f06:	48 89 c2             	mov    %rax,%rdx
  801f09:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f10:	01 00 00 
  801f13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f17:	83 e0 01             	and    $0x1,%eax
  801f1a:	48 85 c0             	test   %rax,%rax
  801f1d:	75 07                	jne    801f26 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f24:	eb 10                	jmp    801f36 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f2a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f2e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f36:	c9                   	leaveq 
  801f37:	c3                   	retq   

0000000000801f38 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f38:	55                   	push   %rbp
  801f39:	48 89 e5             	mov    %rsp,%rbp
  801f3c:	48 83 ec 30          	sub    $0x30,%rsp
  801f40:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f44:	89 f0                	mov    %esi,%eax
  801f46:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f4d:	48 89 c7             	mov    %rax,%rdi
  801f50:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  801f57:	00 00 00 
  801f5a:	ff d0                	callq  *%rax
  801f5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f60:	48 89 d6             	mov    %rdx,%rsi
  801f63:	89 c7                	mov    %eax,%edi
  801f65:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f78:	78 0a                	js     801f84 <fd_close+0x4c>
	    || fd != fd2)
  801f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f82:	74 12                	je     801f96 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f84:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f88:	74 05                	je     801f8f <fd_close+0x57>
  801f8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8d:	eb 05                	jmp    801f94 <fd_close+0x5c>
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	eb 69                	jmp    801fff <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9a:	8b 00                	mov    (%rax),%eax
  801f9c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa0:	48 89 d6             	mov    %rdx,%rsi
  801fa3:	89 c7                	mov    %eax,%edi
  801fa5:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
  801fb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb8:	78 2a                	js     801fe4 <fd_close+0xac>
		if (dev->dev_close)
  801fba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbe:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fc2:	48 85 c0             	test   %rax,%rax
  801fc5:	74 16                	je     801fdd <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fcb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fcf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd3:	48 89 d7             	mov    %rdx,%rdi
  801fd6:	ff d0                	callq  *%rax
  801fd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fdb:	eb 07                	jmp    801fe4 <fd_close+0xac>
		else
			r = 0;
  801fdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fe4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe8:	48 89 c6             	mov    %rax,%rsi
  801feb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff0:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
	return r;
  801ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fff:	c9                   	leaveq 
  802000:	c3                   	retq   

0000000000802001 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802001:	55                   	push   %rbp
  802002:	48 89 e5             	mov    %rsp,%rbp
  802005:	48 83 ec 20          	sub    $0x20,%rsp
  802009:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80200c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802017:	eb 41                	jmp    80205a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802019:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802020:	00 00 00 
  802023:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802026:	48 63 d2             	movslq %edx,%rdx
  802029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202d:	8b 00                	mov    (%rax),%eax
  80202f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802032:	75 22                	jne    802056 <dev_lookup+0x55>
			*dev = devtab[i];
  802034:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80203b:	00 00 00 
  80203e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802041:	48 63 d2             	movslq %edx,%rdx
  802044:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	eb 60                	jmp    8020b6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802056:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802061:	00 00 00 
  802064:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802067:	48 63 d2             	movslq %edx,%rdx
  80206a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206e:	48 85 c0             	test   %rax,%rax
  802071:	75 a6                	jne    802019 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802073:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80207a:	00 00 00 
  80207d:	48 8b 00             	mov    (%rax),%rax
  802080:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802086:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802089:	89 c6                	mov    %eax,%esi
  80208b:	48 bf d0 46 80 00 00 	movabs $0x8046d0,%rdi
  802092:	00 00 00 
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  8020a1:	00 00 00 
  8020a4:	ff d1                	callq  *%rcx
	*dev = 0;
  8020a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020aa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020b6:	c9                   	leaveq 
  8020b7:	c3                   	retq   

00000000008020b8 <close>:

int
close(int fdnum)
{
  8020b8:	55                   	push   %rbp
  8020b9:	48 89 e5             	mov    %rsp,%rbp
  8020bc:	48 83 ec 20          	sub    $0x20,%rsp
  8020c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ca:	48 89 d6             	mov    %rdx,%rsi
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e2:	79 05                	jns    8020e9 <close+0x31>
		return r;
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e7:	eb 18                	jmp    802101 <close+0x49>
	else
		return fd_close(fd, 1);
  8020e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ed:	be 01 00 00 00       	mov    $0x1,%esi
  8020f2:	48 89 c7             	mov    %rax,%rdi
  8020f5:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <close_all>:

void
close_all(void)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80210b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802112:	eb 15                	jmp    802129 <close_all+0x26>
		close(i);
  802114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802125:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802129:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80212d:	7e e5                	jle    802114 <close_all+0x11>
		close(i);
}
  80212f:	c9                   	leaveq 
  802130:	c3                   	retq   

0000000000802131 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802131:	55                   	push   %rbp
  802132:	48 89 e5             	mov    %rsp,%rbp
  802135:	48 83 ec 40          	sub    $0x40,%rsp
  802139:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80213c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80213f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802143:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802146:	48 89 d6             	mov    %rdx,%rsi
  802149:	89 c7                	mov    %eax,%edi
  80214b:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802152:	00 00 00 
  802155:	ff d0                	callq  *%rax
  802157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215e:	79 08                	jns    802168 <dup+0x37>
		return r;
  802160:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802163:	e9 70 01 00 00       	jmpq   8022d8 <dup+0x1a7>
	close(newfdnum);
  802168:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80216b:	89 c7                	mov    %eax,%edi
  80216d:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802179:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80217c:	48 98                	cltq   
  80217e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802184:	48 c1 e0 0c          	shl    $0xc,%rax
  802188:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80218c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802190:	48 89 c7             	mov    %rax,%rdi
  802193:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  80219a:	00 00 00 
  80219d:	ff d0                	callq  *%rax
  80219f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a7:	48 89 c7             	mov    %rax,%rdi
  8021aa:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
  8021b6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021be:	48 c1 e8 15          	shr    $0x15,%rax
  8021c2:	48 89 c2             	mov    %rax,%rdx
  8021c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021cc:	01 00 00 
  8021cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d3:	83 e0 01             	and    $0x1,%eax
  8021d6:	48 85 c0             	test   %rax,%rax
  8021d9:	74 73                	je     80224e <dup+0x11d>
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e3:	48 89 c2             	mov    %rax,%rdx
  8021e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ed:	01 00 00 
  8021f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f4:	83 e0 01             	and    $0x1,%eax
  8021f7:	48 85 c0             	test   %rax,%rax
  8021fa:	74 52                	je     80224e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802200:	48 c1 e8 0c          	shr    $0xc,%rax
  802204:	48 89 c2             	mov    %rax,%rdx
  802207:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220e:	01 00 00 
  802211:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802215:	25 07 0e 00 00       	and    $0xe07,%eax
  80221a:	89 c1                	mov    %eax,%ecx
  80221c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802224:	41 89 c8             	mov    %ecx,%r8d
  802227:	48 89 d1             	mov    %rdx,%rcx
  80222a:	ba 00 00 00 00       	mov    $0x0,%edx
  80222f:	48 89 c6             	mov    %rax,%rsi
  802232:	bf 00 00 00 00       	mov    $0x0,%edi
  802237:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
  802243:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802246:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224a:	79 02                	jns    80224e <dup+0x11d>
			goto err;
  80224c:	eb 57                	jmp    8022a5 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80224e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802252:	48 c1 e8 0c          	shr    $0xc,%rax
  802256:	48 89 c2             	mov    %rax,%rdx
  802259:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802260:	01 00 00 
  802263:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802267:	25 07 0e 00 00       	and    $0xe07,%eax
  80226c:	89 c1                	mov    %eax,%ecx
  80226e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802272:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802276:	41 89 c8             	mov    %ecx,%r8d
  802279:	48 89 d1             	mov    %rdx,%rcx
  80227c:	ba 00 00 00 00       	mov    $0x0,%edx
  802281:	48 89 c6             	mov    %rax,%rsi
  802284:	bf 00 00 00 00       	mov    $0x0,%edi
  802289:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
  802295:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802298:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229c:	79 02                	jns    8022a0 <dup+0x16f>
		goto err;
  80229e:	eb 05                	jmp    8022a5 <dup+0x174>

	return newfdnum;
  8022a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a3:	eb 33                	jmp    8022d8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a9:	48 89 c6             	mov    %rax,%rsi
  8022ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b1:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8022b8:	00 00 00 
  8022bb:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c1:	48 89 c6             	mov    %rax,%rsi
  8022c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c9:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
	return r;
  8022d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022d8:	c9                   	leaveq 
  8022d9:	c3                   	retq   

00000000008022da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022da:	55                   	push   %rbp
  8022db:	48 89 e5             	mov    %rsp,%rbp
  8022de:	48 83 ec 40          	sub    $0x40,%rsp
  8022e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f4:	48 89 d6             	mov    %rdx,%rsi
  8022f7:	89 c7                	mov    %eax,%edi
  8022f9:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
  802305:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802308:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80230c:	78 24                	js     802332 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80230e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802312:	8b 00                	mov    (%rax),%eax
  802314:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802318:	48 89 d6             	mov    %rdx,%rsi
  80231b:	89 c7                	mov    %eax,%edi
  80231d:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  802324:	00 00 00 
  802327:	ff d0                	callq  *%rax
  802329:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802330:	79 05                	jns    802337 <read+0x5d>
		return r;
  802332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802335:	eb 76                	jmp    8023ad <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233b:	8b 40 08             	mov    0x8(%rax),%eax
  80233e:	83 e0 03             	and    $0x3,%eax
  802341:	83 f8 01             	cmp    $0x1,%eax
  802344:	75 3a                	jne    802380 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802346:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80234d:	00 00 00 
  802350:	48 8b 00             	mov    (%rax),%rax
  802353:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802359:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80235c:	89 c6                	mov    %eax,%esi
  80235e:	48 bf ef 46 80 00 00 	movabs $0x8046ef,%rdi
  802365:	00 00 00 
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
  80236d:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  802374:	00 00 00 
  802377:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802379:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237e:	eb 2d                	jmp    8023ad <read+0xd3>
	}
	if (!dev->dev_read)
  802380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802384:	48 8b 40 10          	mov    0x10(%rax),%rax
  802388:	48 85 c0             	test   %rax,%rax
  80238b:	75 07                	jne    802394 <read+0xba>
		return -E_NOT_SUPP;
  80238d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802392:	eb 19                	jmp    8023ad <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802398:	48 8b 40 10          	mov    0x10(%rax),%rax
  80239c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023a4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023a8:	48 89 cf             	mov    %rcx,%rdi
  8023ab:	ff d0                	callq  *%rax
}
  8023ad:	c9                   	leaveq 
  8023ae:	c3                   	retq   

00000000008023af <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023af:	55                   	push   %rbp
  8023b0:	48 89 e5             	mov    %rsp,%rbp
  8023b3:	48 83 ec 30          	sub    $0x30,%rsp
  8023b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c9:	eb 49                	jmp    802414 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ce:	48 98                	cltq   
  8023d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d4:	48 29 c2             	sub    %rax,%rdx
  8023d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023da:	48 63 c8             	movslq %eax,%rcx
  8023dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e1:	48 01 c1             	add    %rax,%rcx
  8023e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e7:	48 89 ce             	mov    %rcx,%rsi
  8023ea:	89 c7                	mov    %eax,%edi
  8023ec:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  8023f3:	00 00 00 
  8023f6:	ff d0                	callq  *%rax
  8023f8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023ff:	79 05                	jns    802406 <readn+0x57>
			return m;
  802401:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802404:	eb 1c                	jmp    802422 <readn+0x73>
		if (m == 0)
  802406:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80240a:	75 02                	jne    80240e <readn+0x5f>
			break;
  80240c:	eb 11                	jmp    80241f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80240e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802411:	01 45 fc             	add    %eax,-0x4(%rbp)
  802414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802417:	48 98                	cltq   
  802419:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80241d:	72 ac                	jb     8023cb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80241f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 40          	sub    $0x40,%rsp
  80242c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80242f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802433:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802437:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80243b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243e:	48 89 d6             	mov    %rdx,%rsi
  802441:	89 c7                	mov    %eax,%edi
  802443:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
  80244f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802452:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802456:	78 24                	js     80247c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245c:	8b 00                	mov    (%rax),%eax
  80245e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802462:	48 89 d6             	mov    %rdx,%rsi
  802465:	89 c7                	mov    %eax,%edi
  802467:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  80246e:	00 00 00 
  802471:	ff d0                	callq  *%rax
  802473:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247a:	79 05                	jns    802481 <write+0x5d>
		return r;
  80247c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247f:	eb 75                	jmp    8024f6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802485:	8b 40 08             	mov    0x8(%rax),%eax
  802488:	83 e0 03             	and    $0x3,%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	75 3a                	jne    8024c9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80248f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802496:	00 00 00 
  802499:	48 8b 00             	mov    (%rax),%rax
  80249c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	48 bf 0b 47 80 00 00 	movabs $0x80470b,%rdi
  8024ae:	00 00 00 
  8024b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b6:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  8024bd:	00 00 00 
  8024c0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c7:	eb 2d                	jmp    8024f6 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8024c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024d1:	48 85 c0             	test   %rax,%rax
  8024d4:	75 07                	jne    8024dd <write+0xb9>
		return -E_NOT_SUPP;
  8024d6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024db:	eb 19                	jmp    8024f6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024e5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ed:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024f1:	48 89 cf             	mov    %rcx,%rdi
  8024f4:	ff d0                	callq  *%rax
}
  8024f6:	c9                   	leaveq 
  8024f7:	c3                   	retq   

00000000008024f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024f8:	55                   	push   %rbp
  8024f9:	48 89 e5             	mov    %rsp,%rbp
  8024fc:	48 83 ec 18          	sub    $0x18,%rsp
  802500:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802503:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802506:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80250a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250d:	48 89 d6             	mov    %rdx,%rsi
  802510:	89 c7                	mov    %eax,%edi
  802512:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802519:	00 00 00 
  80251c:	ff d0                	callq  *%rax
  80251e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802521:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802525:	79 05                	jns    80252c <seek+0x34>
		return r;
  802527:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252a:	eb 0f                	jmp    80253b <seek+0x43>
	fd->fd_offset = offset;
  80252c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802530:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802533:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253b:	c9                   	leaveq 
  80253c:	c3                   	retq   

000000000080253d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80253d:	55                   	push   %rbp
  80253e:	48 89 e5             	mov    %rsp,%rbp
  802541:	48 83 ec 30          	sub    $0x30,%rsp
  802545:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802548:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802552:	48 89 d6             	mov    %rdx,%rsi
  802555:	89 c7                	mov    %eax,%edi
  802557:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256a:	78 24                	js     802590 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802570:	8b 00                	mov    (%rax),%eax
  802572:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802576:	48 89 d6             	mov    %rdx,%rsi
  802579:	89 c7                	mov    %eax,%edi
  80257b:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
  802587:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258e:	79 05                	jns    802595 <ftruncate+0x58>
		return r;
  802590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802593:	eb 72                	jmp    802607 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802599:	8b 40 08             	mov    0x8(%rax),%eax
  80259c:	83 e0 03             	and    $0x3,%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	75 3a                	jne    8025dd <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025aa:	00 00 00 
  8025ad:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025b9:	89 c6                	mov    %eax,%esi
  8025bb:	48 bf 28 47 80 00 00 	movabs $0x804728,%rdi
  8025c2:	00 00 00 
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ca:	48 b9 67 04 80 00 00 	movabs $0x800467,%rcx
  8025d1:	00 00 00 
  8025d4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025db:	eb 2a                	jmp    802607 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e5:	48 85 c0             	test   %rax,%rax
  8025e8:	75 07                	jne    8025f1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ef:	eb 16                	jmp    802607 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025fd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802600:	89 ce                	mov    %ecx,%esi
  802602:	48 89 d7             	mov    %rdx,%rdi
  802605:	ff d0                	callq  *%rax
}
  802607:	c9                   	leaveq 
  802608:	c3                   	retq   

0000000000802609 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802609:	55                   	push   %rbp
  80260a:	48 89 e5             	mov    %rsp,%rbp
  80260d:	48 83 ec 30          	sub    $0x30,%rsp
  802611:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802614:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802618:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80261c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80261f:	48 89 d6             	mov    %rdx,%rsi
  802622:	89 c7                	mov    %eax,%edi
  802624:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax
  802630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802637:	78 24                	js     80265d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263d:	8b 00                	mov    (%rax),%eax
  80263f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802643:	48 89 d6             	mov    %rdx,%rsi
  802646:	89 c7                	mov    %eax,%edi
  802648:	48 b8 01 20 80 00 00 	movabs $0x802001,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
  802654:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802657:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265b:	79 05                	jns    802662 <fstat+0x59>
		return r;
  80265d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802660:	eb 5e                	jmp    8026c0 <fstat+0xb7>
	if (!dev->dev_stat)
  802662:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802666:	48 8b 40 28          	mov    0x28(%rax),%rax
  80266a:	48 85 c0             	test   %rax,%rax
  80266d:	75 07                	jne    802676 <fstat+0x6d>
		return -E_NOT_SUPP;
  80266f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802674:	eb 4a                	jmp    8026c0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802676:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80267d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802681:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802688:	00 00 00 
	stat->st_isdir = 0;
  80268b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802696:	00 00 00 
	stat->st_dev = dev;
  802699:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026b8:	48 89 ce             	mov    %rcx,%rsi
  8026bb:	48 89 d7             	mov    %rdx,%rdi
  8026be:	ff d0                	callq  *%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 20          	sub    $0x20,%rsp
  8026ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d6:	be 00 00 00 00       	mov    $0x0,%esi
  8026db:	48 89 c7             	mov    %rax,%rdi
  8026de:	48 b8 b0 27 80 00 00 	movabs $0x8027b0,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
  8026ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f1:	79 05                	jns    8026f8 <stat+0x36>
		return fd;
  8026f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f6:	eb 2f                	jmp    802727 <stat+0x65>
	r = fstat(fd, stat);
  8026f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ff:	48 89 d6             	mov    %rdx,%rsi
  802702:	89 c7                	mov    %eax,%edi
  802704:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802716:	89 c7                	mov    %eax,%edi
  802718:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
	return r;
  802724:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802727:	c9                   	leaveq 
  802728:	c3                   	retq   

0000000000802729 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802729:	55                   	push   %rbp
  80272a:	48 89 e5             	mov    %rsp,%rbp
  80272d:	48 83 ec 10          	sub    $0x10,%rsp
  802731:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802734:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802738:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80273f:	00 00 00 
  802742:	8b 00                	mov    (%rax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	75 1d                	jne    802765 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802748:	bf 01 00 00 00       	mov    $0x1,%edi
  80274d:	48 b8 b6 3f 80 00 00 	movabs $0x803fb6,%rax
  802754:	00 00 00 
  802757:	ff d0                	callq  *%rax
  802759:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802760:	00 00 00 
  802763:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802765:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80276c:	00 00 00 
  80276f:	8b 00                	mov    (%rax),%eax
  802771:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802774:	b9 07 00 00 00       	mov    $0x7,%ecx
  802779:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802780:	00 00 00 
  802783:	89 c7                	mov    %eax,%edi
  802785:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802791:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802795:	ba 00 00 00 00       	mov    $0x0,%edx
  80279a:	48 89 c6             	mov    %rax,%rsi
  80279d:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a2:	48 b8 4e 3e 80 00 00 	movabs $0x803e4e,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
}
  8027ae:	c9                   	leaveq 
  8027af:	c3                   	retq   

00000000008027b0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027b0:	55                   	push   %rbp
  8027b1:	48 89 e5             	mov    %rsp,%rbp
  8027b4:	48 83 ec 30          	sub    $0x30,%rsp
  8027b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027bc:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8027bf:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8027c6:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027d4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027d9:	75 08                	jne    8027e3 <open+0x33>
	{
		return r;
  8027db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027de:	e9 f2 00 00 00       	jmpq   8028d5 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e7:	48 89 c7             	mov    %rax,%rdi
  8027ea:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  8027f1:	00 00 00 
  8027f4:	ff d0                	callq  *%rax
  8027f6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8027f9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802800:	7e 0a                	jle    80280c <open+0x5c>
	{
		return -E_BAD_PATH;
  802802:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802807:	e9 c9 00 00 00       	jmpq   8028d5 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80280c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802813:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802814:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802818:	48 89 c7             	mov    %rax,%rdi
  80281b:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  802822:	00 00 00 
  802825:	ff d0                	callq  *%rax
  802827:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282e:	78 09                	js     802839 <open+0x89>
  802830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802834:	48 85 c0             	test   %rax,%rax
  802837:	75 08                	jne    802841 <open+0x91>
		{
			return r;
  802839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283c:	e9 94 00 00 00       	jmpq   8028d5 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802845:	ba 00 04 00 00       	mov    $0x400,%edx
  80284a:	48 89 c6             	mov    %rax,%rsi
  80284d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802854:	00 00 00 
  802857:	48 b8 ae 10 80 00 00 	movabs $0x8010ae,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802863:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80286a:	00 00 00 
  80286d:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802870:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287a:	48 89 c6             	mov    %rax,%rsi
  80287d:	bf 01 00 00 00       	mov    $0x1,%edi
  802882:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 2b                	jns    8028c2 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289b:	be 00 00 00 00       	mov    $0x0,%esi
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8028b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028b6:	79 05                	jns    8028bd <open+0x10d>
			{
				return d;
  8028b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028bb:	eb 18                	jmp    8028d5 <open+0x125>
			}
			return r;
  8028bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c0:	eb 13                	jmp    8028d5 <open+0x125>
		}	
		return fd2num(fd_store);
  8028c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c6:	48 89 c7             	mov    %rax,%rdi
  8028c9:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  8028d0:	00 00 00 
  8028d3:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028d5:	c9                   	leaveq 
  8028d6:	c3                   	retq   

00000000008028d7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028d7:	55                   	push   %rbp
  8028d8:	48 89 e5             	mov    %rsp,%rbp
  8028db:	48 83 ec 10          	sub    $0x10,%rsp
  8028df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028e7:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f1:	00 00 00 
  8028f4:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028f6:	be 00 00 00 00       	mov    $0x0,%esi
  8028fb:	bf 06 00 00 00       	mov    $0x6,%edi
  802900:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
}
  80290c:	c9                   	leaveq 
  80290d:	c3                   	retq   

000000000080290e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80290e:	55                   	push   %rbp
  80290f:	48 89 e5             	mov    %rsp,%rbp
  802912:	48 83 ec 30          	sub    $0x30,%rsp
  802916:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80291a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80291e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802929:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80292e:	74 07                	je     802937 <devfile_read+0x29>
  802930:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802935:	75 07                	jne    80293e <devfile_read+0x30>
		return -E_INVAL;
  802937:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80293c:	eb 77                	jmp    8029b5 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80293e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802942:	8b 50 0c             	mov    0xc(%rax),%edx
  802945:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80294c:	00 00 00 
  80294f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802951:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802958:	00 00 00 
  80295b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80295f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802963:	be 00 00 00 00       	mov    $0x0,%esi
  802968:	bf 03 00 00 00       	mov    $0x3,%edi
  80296d:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802980:	7f 05                	jg     802987 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802985:	eb 2e                	jmp    8029b5 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298a:	48 63 d0             	movslq %eax,%rdx
  80298d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802991:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802998:	00 00 00 
  80299b:	48 89 c7             	mov    %rax,%rdi
  80299e:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  8029a5:	00 00 00 
  8029a8:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8029aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8029b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 30          	sub    $0x30,%rsp
  8029bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029cb:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029d7:	74 07                	je     8029e0 <devfile_write+0x29>
  8029d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029de:	75 08                	jne    8029e8 <devfile_write+0x31>
		return r;
  8029e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e3:	e9 9a 00 00 00       	jmpq   802a82 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f6:	00 00 00 
  8029f9:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8029fb:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a02:	00 
  802a03:	76 08                	jbe    802a0d <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802a05:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a0c:	00 
	}
	fsipcbuf.write.req_n = n;
  802a0d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a14:	00 00 00 
  802a17:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a1b:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802a1f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a27:	48 89 c6             	mov    %rax,%rsi
  802a2a:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a31:	00 00 00 
  802a34:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  802a3b:	00 00 00 
  802a3e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a40:	be 00 00 00 00       	mov    $0x0,%esi
  802a45:	bf 04 00 00 00       	mov    $0x4,%edi
  802a4a:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	callq  *%rax
  802a56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5d:	7f 20                	jg     802a7f <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a5f:	48 bf 4e 47 80 00 00 	movabs $0x80474e,%rdi
  802a66:	00 00 00 
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  802a75:	00 00 00 
  802a78:	ff d2                	callq  *%rdx
		return r;
  802a7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7d:	eb 03                	jmp    802a82 <devfile_write+0xcb>
	}
	return r;
  802a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a82:	c9                   	leaveq 
  802a83:	c3                   	retq   

0000000000802a84 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a84:	55                   	push   %rbp
  802a85:	48 89 e5             	mov    %rsp,%rbp
  802a88:	48 83 ec 20          	sub    $0x20,%rsp
  802a8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	8b 50 0c             	mov    0xc(%rax),%edx
  802a9b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa2:	00 00 00 
  802aa5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802aa7:	be 00 00 00 00       	mov    $0x0,%esi
  802aac:	bf 05 00 00 00       	mov    $0x5,%edi
  802ab1:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802ab8:	00 00 00 
  802abb:	ff d0                	callq  *%rax
  802abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac4:	79 05                	jns    802acb <devfile_stat+0x47>
		return r;
  802ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac9:	eb 56                	jmp    802b21 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802acf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ad6:	00 00 00 
  802ad9:	48 89 c7             	mov    %rax,%rdi
  802adc:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  802ae3:	00 00 00 
  802ae6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ae8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aef:	00 00 00 
  802af2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802af8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b09:	00 00 00 
  802b0c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b16:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b21:	c9                   	leaveq 
  802b22:	c3                   	retq   

0000000000802b23 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b23:	55                   	push   %rbp
  802b24:	48 89 e5             	mov    %rsp,%rbp
  802b27:	48 83 ec 10          	sub    $0x10,%rsp
  802b2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b2f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b36:	8b 50 0c             	mov    0xc(%rax),%edx
  802b39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b40:	00 00 00 
  802b43:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4c:	00 00 00 
  802b4f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b55:	be 00 00 00 00       	mov    $0x0,%esi
  802b5a:	bf 02 00 00 00       	mov    $0x2,%edi
  802b5f:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
}
  802b6b:	c9                   	leaveq 
  802b6c:	c3                   	retq   

0000000000802b6d <remove>:

// Delete a file
int
remove(const char *path)
{
  802b6d:	55                   	push   %rbp
  802b6e:	48 89 e5             	mov    %rsp,%rbp
  802b71:	48 83 ec 10          	sub    $0x10,%rsp
  802b75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b7d:	48 89 c7             	mov    %rax,%rdi
  802b80:	48 b8 b0 0f 80 00 00 	movabs $0x800fb0,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b91:	7e 07                	jle    802b9a <remove+0x2d>
		return -E_BAD_PATH;
  802b93:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b98:	eb 33                	jmp    802bcd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b9e:	48 89 c6             	mov    %rax,%rsi
  802ba1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ba8:	00 00 00 
  802bab:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bb7:	be 00 00 00 00       	mov    $0x0,%esi
  802bbc:	bf 07 00 00 00       	mov    $0x7,%edi
  802bc1:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
}
  802bcd:	c9                   	leaveq 
  802bce:	c3                   	retq   

0000000000802bcf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bcf:	55                   	push   %rbp
  802bd0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bd3:	be 00 00 00 00       	mov    $0x0,%esi
  802bd8:	bf 08 00 00 00       	mov    $0x8,%edi
  802bdd:	48 b8 29 27 80 00 00 	movabs $0x802729,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
}
  802be9:	5d                   	pop    %rbp
  802bea:	c3                   	retq   

0000000000802beb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802beb:	55                   	push   %rbp
  802bec:	48 89 e5             	mov    %rsp,%rbp
  802bef:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802bf6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bfd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c04:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c0b:	be 00 00 00 00       	mov    $0x0,%esi
  802c10:	48 89 c7             	mov    %rax,%rdi
  802c13:	48 b8 b0 27 80 00 00 	movabs $0x8027b0,%rax
  802c1a:	00 00 00 
  802c1d:	ff d0                	callq  *%rax
  802c1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c26:	79 28                	jns    802c50 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2b:	89 c6                	mov    %eax,%esi
  802c2d:	48 bf 6a 47 80 00 00 	movabs $0x80476a,%rdi
  802c34:	00 00 00 
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3c:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  802c43:	00 00 00 
  802c46:	ff d2                	callq  *%rdx
		return fd_src;
  802c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4b:	e9 74 01 00 00       	jmpq   802dc4 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c50:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c57:	be 01 01 00 00       	mov    $0x101,%esi
  802c5c:	48 89 c7             	mov    %rax,%rdi
  802c5f:	48 b8 b0 27 80 00 00 	movabs $0x8027b0,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
  802c6b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c6e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c72:	79 39                	jns    802cad <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c77:	89 c6                	mov    %eax,%esi
  802c79:	48 bf 80 47 80 00 00 	movabs $0x804780,%rdi
  802c80:	00 00 00 
  802c83:	b8 00 00 00 00       	mov    $0x0,%eax
  802c88:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  802c8f:	00 00 00 
  802c92:	ff d2                	callq  *%rdx
		close(fd_src);
  802c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c97:	89 c7                	mov    %eax,%edi
  802c99:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
		return fd_dest;
  802ca5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca8:	e9 17 01 00 00       	jmpq   802dc4 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cad:	eb 74                	jmp    802d23 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802caf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cb2:	48 63 d0             	movslq %eax,%rdx
  802cb5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cbf:	48 89 ce             	mov    %rcx,%rsi
  802cc2:	89 c7                	mov    %eax,%edi
  802cc4:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
  802cd0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802cd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cd7:	79 4a                	jns    802d23 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802cd9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cdc:	89 c6                	mov    %eax,%esi
  802cde:	48 bf 9a 47 80 00 00 	movabs $0x80479a,%rdi
  802ce5:	00 00 00 
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ced:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  802cf4:	00 00 00 
  802cf7:	ff d2                	callq  *%rdx
			close(fd_src);
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
			close(fd_dest);
  802d0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d0d:	89 c7                	mov    %eax,%edi
  802d0f:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
			return write_size;
  802d1b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d1e:	e9 a1 00 00 00       	jmpq   802dc4 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d23:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	ba 00 02 00 00       	mov    $0x200,%edx
  802d32:	48 89 ce             	mov    %rcx,%rsi
  802d35:	89 c7                	mov    %eax,%edi
  802d37:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
  802d43:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d4a:	0f 8f 5f ff ff ff    	jg     802caf <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d54:	79 47                	jns    802d9d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d56:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d59:	89 c6                	mov    %eax,%esi
  802d5b:	48 bf ad 47 80 00 00 	movabs $0x8047ad,%rdi
  802d62:	00 00 00 
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6a:	48 ba 67 04 80 00 00 	movabs $0x800467,%rdx
  802d71:	00 00 00 
  802d74:	ff d2                	callq  *%rdx
		close(fd_src);
  802d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d79:	89 c7                	mov    %eax,%edi
  802d7b:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
		close(fd_dest);
  802d87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d8a:	89 c7                	mov    %eax,%edi
  802d8c:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802d93:	00 00 00 
  802d96:	ff d0                	callq  *%rax
		return read_size;
  802d98:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d9b:	eb 27                	jmp    802dc4 <copy+0x1d9>
	}
	close(fd_src);
  802d9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da0:	89 c7                	mov    %eax,%edi
  802da2:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
	close(fd_dest);
  802dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db1:	89 c7                	mov    %eax,%edi
  802db3:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
	return 0;
  802dbf:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802dc4:	c9                   	leaveq 
  802dc5:	c3                   	retq   

0000000000802dc6 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802dc6:	55                   	push   %rbp
  802dc7:	48 89 e5             	mov    %rsp,%rbp
  802dca:	48 83 ec 20          	sub    $0x20,%rsp
  802dce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dd1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dd5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd8:	48 89 d6             	mov    %rdx,%rsi
  802ddb:	89 c7                	mov    %eax,%edi
  802ddd:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802de4:	00 00 00 
  802de7:	ff d0                	callq  *%rax
  802de9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df0:	79 05                	jns    802df7 <fd2sockid+0x31>
		return r;
  802df2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df5:	eb 24                	jmp    802e1b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfb:	8b 10                	mov    (%rax),%edx
  802dfd:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e04:	00 00 00 
  802e07:	8b 00                	mov    (%rax),%eax
  802e09:	39 c2                	cmp    %eax,%edx
  802e0b:	74 07                	je     802e14 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e0d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e12:	eb 07                	jmp    802e1b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e18:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e1b:	c9                   	leaveq 
  802e1c:	c3                   	retq   

0000000000802e1d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e1d:	55                   	push   %rbp
  802e1e:	48 89 e5             	mov    %rsp,%rbp
  802e21:	48 83 ec 20          	sub    $0x20,%rsp
  802e25:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e28:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e2c:	48 89 c7             	mov    %rax,%rdi
  802e2f:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
  802e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e42:	78 26                	js     802e6a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e48:	ba 07 04 00 00       	mov    $0x407,%edx
  802e4d:	48 89 c6             	mov    %rax,%rsi
  802e50:	bf 00 00 00 00       	mov    $0x0,%edi
  802e55:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  802e5c:	00 00 00 
  802e5f:	ff d0                	callq  *%rax
  802e61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e68:	79 16                	jns    802e80 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e6d:	89 c7                	mov    %eax,%edi
  802e6f:	48 b8 2a 33 80 00 00 	movabs $0x80332a,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
		return r;
  802e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7e:	eb 3a                	jmp    802eba <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e8b:	00 00 00 
  802e8e:	8b 12                	mov    (%rdx),%edx
  802e90:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e96:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ea4:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
}
  802eba:	c9                   	leaveq 
  802ebb:	c3                   	retq   

0000000000802ebc <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ebc:	55                   	push   %rbp
  802ebd:	48 89 e5             	mov    %rsp,%rbp
  802ec0:	48 83 ec 30          	sub    $0x30,%rsp
  802ec4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ec7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ecb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 c6 2d 80 00 00 	movabs $0x802dc6,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee7:	79 05                	jns    802eee <accept+0x32>
		return r;
  802ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eec:	eb 3b                	jmp    802f29 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802eee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ef2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef9:	48 89 ce             	mov    %rcx,%rsi
  802efc:	89 c7                	mov    %eax,%edi
  802efe:	48 b8 07 32 80 00 00 	movabs $0x803207,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
  802f0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f11:	79 05                	jns    802f18 <accept+0x5c>
		return r;
  802f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f16:	eb 11                	jmp    802f29 <accept+0x6d>
	return alloc_sockfd(r);
  802f18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 1d 2e 80 00 00 	movabs $0x802e1d,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
}
  802f29:	c9                   	leaveq 
  802f2a:	c3                   	retq   

0000000000802f2b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f2b:	55                   	push   %rbp
  802f2c:	48 89 e5             	mov    %rsp,%rbp
  802f2f:	48 83 ec 20          	sub    $0x20,%rsp
  802f33:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f3a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f40:	89 c7                	mov    %eax,%edi
  802f42:	48 b8 c6 2d 80 00 00 	movabs $0x802dc6,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
  802f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f55:	79 05                	jns    802f5c <bind+0x31>
		return r;
  802f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5a:	eb 1b                	jmp    802f77 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f5c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f5f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f66:	48 89 ce             	mov    %rcx,%rsi
  802f69:	89 c7                	mov    %eax,%edi
  802f6b:	48 b8 86 32 80 00 00 	movabs $0x803286,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
}
  802f77:	c9                   	leaveq 
  802f78:	c3                   	retq   

0000000000802f79 <shutdown>:

int
shutdown(int s, int how)
{
  802f79:	55                   	push   %rbp
  802f7a:	48 89 e5             	mov    %rsp,%rbp
  802f7d:	48 83 ec 20          	sub    $0x20,%rsp
  802f81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f84:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8a:	89 c7                	mov    %eax,%edi
  802f8c:	48 b8 c6 2d 80 00 00 	movabs $0x802dc6,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
  802f98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9f:	79 05                	jns    802fa6 <shutdown+0x2d>
		return r;
  802fa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa4:	eb 16                	jmp    802fbc <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fa6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fac:	89 d6                	mov    %edx,%esi
  802fae:	89 c7                	mov    %eax,%edi
  802fb0:	48 b8 ea 32 80 00 00 	movabs $0x8032ea,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
}
  802fbc:	c9                   	leaveq 
  802fbd:	c3                   	retq   

0000000000802fbe <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802fbe:	55                   	push   %rbp
  802fbf:	48 89 e5             	mov    %rsp,%rbp
  802fc2:	48 83 ec 10          	sub    $0x10,%rsp
  802fc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fce:	48 89 c7             	mov    %rax,%rdi
  802fd1:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	83 f8 01             	cmp    $0x1,%eax
  802fe0:	75 17                	jne    802ff9 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802fe2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe6:	8b 40 0c             	mov    0xc(%rax),%eax
  802fe9:	89 c7                	mov    %eax,%edi
  802feb:	48 b8 2a 33 80 00 00 	movabs $0x80332a,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	eb 05                	jmp    802ffe <devsock_close+0x40>
	else
		return 0;
  802ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffe:	c9                   	leaveq 
  802fff:	c3                   	retq   

0000000000803000 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803000:	55                   	push   %rbp
  803001:	48 89 e5             	mov    %rsp,%rbp
  803004:	48 83 ec 20          	sub    $0x20,%rsp
  803008:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80300b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80300f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803012:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803015:	89 c7                	mov    %eax,%edi
  803017:	48 b8 c6 2d 80 00 00 	movabs $0x802dc6,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
  803023:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803026:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302a:	79 05                	jns    803031 <connect+0x31>
		return r;
  80302c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302f:	eb 1b                	jmp    80304c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803031:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803034:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303b:	48 89 ce             	mov    %rcx,%rsi
  80303e:	89 c7                	mov    %eax,%edi
  803040:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
}
  80304c:	c9                   	leaveq 
  80304d:	c3                   	retq   

000000000080304e <listen>:

int
listen(int s, int backlog)
{
  80304e:	55                   	push   %rbp
  80304f:	48 89 e5             	mov    %rsp,%rbp
  803052:	48 83 ec 20          	sub    $0x20,%rsp
  803056:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803059:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80305c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305f:	89 c7                	mov    %eax,%edi
  803061:	48 b8 c6 2d 80 00 00 	movabs $0x802dc6,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
  80306d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803074:	79 05                	jns    80307b <listen+0x2d>
		return r;
  803076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803079:	eb 16                	jmp    803091 <listen+0x43>
	return nsipc_listen(r, backlog);
  80307b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80307e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803081:	89 d6                	mov    %edx,%esi
  803083:	89 c7                	mov    %eax,%edi
  803085:	48 b8 bb 33 80 00 00 	movabs $0x8033bb,%rax
  80308c:	00 00 00 
  80308f:	ff d0                	callq  *%rax
}
  803091:	c9                   	leaveq 
  803092:	c3                   	retq   

0000000000803093 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803093:	55                   	push   %rbp
  803094:	48 89 e5             	mov    %rsp,%rbp
  803097:	48 83 ec 20          	sub    $0x20,%rsp
  80309b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80309f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ab:	89 c2                	mov    %eax,%edx
  8030ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b1:	8b 40 0c             	mov    0xc(%rax),%eax
  8030b4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030bd:	89 c7                	mov    %eax,%edi
  8030bf:	48 b8 fb 33 80 00 00 	movabs $0x8033fb,%rax
  8030c6:	00 00 00 
  8030c9:	ff d0                	callq  *%rax
}
  8030cb:	c9                   	leaveq 
  8030cc:	c3                   	retq   

00000000008030cd <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030cd:	55                   	push   %rbp
  8030ce:	48 89 e5             	mov    %rsp,%rbp
  8030d1:	48 83 ec 20          	sub    $0x20,%rsp
  8030d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030dd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e5:	89 c2                	mov    %eax,%edx
  8030e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030eb:	8b 40 0c             	mov    0xc(%rax),%eax
  8030ee:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030f7:	89 c7                	mov    %eax,%edi
  8030f9:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
}
  803105:	c9                   	leaveq 
  803106:	c3                   	retq   

0000000000803107 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803107:	55                   	push   %rbp
  803108:	48 89 e5             	mov    %rsp,%rbp
  80310b:	48 83 ec 10          	sub    $0x10,%rsp
  80310f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803113:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311b:	48 be c8 47 80 00 00 	movabs $0x8047c8,%rsi
  803122:	00 00 00 
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
	return 0;
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   

000000000080313b <socket>:

int
socket(int domain, int type, int protocol)
{
  80313b:	55                   	push   %rbp
  80313c:	48 89 e5             	mov    %rsp,%rbp
  80313f:	48 83 ec 20          	sub    $0x20,%rsp
  803143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803146:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803149:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80314c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80314f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803152:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803155:	89 ce                	mov    %ecx,%esi
  803157:	89 c7                	mov    %eax,%edi
  803159:	48 b8 7f 35 80 00 00 	movabs $0x80357f,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
  803165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316c:	79 05                	jns    803173 <socket+0x38>
		return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803171:	eb 11                	jmp    803184 <socket+0x49>
	return alloc_sockfd(r);
  803173:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803176:	89 c7                	mov    %eax,%edi
  803178:	48 b8 1d 2e 80 00 00 	movabs $0x802e1d,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
}
  803184:	c9                   	leaveq 
  803185:	c3                   	retq   

0000000000803186 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803186:	55                   	push   %rbp
  803187:	48 89 e5             	mov    %rsp,%rbp
  80318a:	48 83 ec 10          	sub    $0x10,%rsp
  80318e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803191:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803198:	00 00 00 
  80319b:	8b 00                	mov    (%rax),%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	75 1d                	jne    8031be <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031a1:	bf 02 00 00 00       	mov    $0x2,%edi
  8031a6:	48 b8 b6 3f 80 00 00 	movabs $0x803fb6,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
  8031b2:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8031b9:	00 00 00 
  8031bc:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031be:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031c5:	00 00 00 
  8031c8:	8b 00                	mov    (%rax),%eax
  8031ca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031cd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031d2:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8031d9:	00 00 00 
  8031dc:	89 c7                	mov    %eax,%edi
  8031de:	48 b8 54 3f 80 00 00 	movabs $0x803f54,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8031ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ef:	be 00 00 00 00       	mov    $0x0,%esi
  8031f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f9:	48 b8 4e 3e 80 00 00 	movabs $0x803e4e,%rax
  803200:	00 00 00 
  803203:	ff d0                	callq  *%rax
}
  803205:	c9                   	leaveq 
  803206:	c3                   	retq   

0000000000803207 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803207:	55                   	push   %rbp
  803208:	48 89 e5             	mov    %rsp,%rbp
  80320b:	48 83 ec 30          	sub    $0x30,%rsp
  80320f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803212:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803216:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80321a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803221:	00 00 00 
  803224:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803227:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803229:	bf 01 00 00 00       	mov    $0x1,%edi
  80322e:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  803235:	00 00 00 
  803238:	ff d0                	callq  *%rax
  80323a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803241:	78 3e                	js     803281 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803243:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80324a:	00 00 00 
  80324d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803255:	8b 40 10             	mov    0x10(%rax),%eax
  803258:	89 c2                	mov    %eax,%edx
  80325a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80325e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803262:	48 89 ce             	mov    %rcx,%rsi
  803265:	48 89 c7             	mov    %rax,%rdi
  803268:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803278:	8b 50 10             	mov    0x10(%rax),%edx
  80327b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803281:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803284:	c9                   	leaveq 
  803285:	c3                   	retq   

0000000000803286 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803286:	55                   	push   %rbp
  803287:	48 89 e5             	mov    %rsp,%rbp
  80328a:	48 83 ec 10          	sub    $0x10,%rsp
  80328e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803291:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803295:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803298:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80329f:	00 00 00 
  8032a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032a5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ae:	48 89 c6             	mov    %rax,%rsi
  8032b1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032b8:	00 00 00 
  8032bb:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8032c7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ce:	00 00 00 
  8032d1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8032d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8032dc:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 10          	sub    $0x10,%rsp
  8032f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032f5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032ff:	00 00 00 
  803302:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803305:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803307:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80330e:	00 00 00 
  803311:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803314:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803317:	bf 03 00 00 00       	mov    $0x3,%edi
  80331c:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
}
  803328:	c9                   	leaveq 
  803329:	c3                   	retq   

000000000080332a <nsipc_close>:

int
nsipc_close(int s)
{
  80332a:	55                   	push   %rbp
  80332b:	48 89 e5             	mov    %rsp,%rbp
  80332e:	48 83 ec 10          	sub    $0x10,%rsp
  803332:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803335:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333c:	00 00 00 
  80333f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803342:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803344:	bf 04 00 00 00       	mov    $0x4,%edi
  803349:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
}
  803355:	c9                   	leaveq 
  803356:	c3                   	retq   

0000000000803357 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 10          	sub    $0x10,%rsp
  80335f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803362:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803366:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803369:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803370:	00 00 00 
  803373:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803376:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803378:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80337b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337f:	48 89 c6             	mov    %rax,%rsi
  803382:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803389:	00 00 00 
  80338c:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  803393:	00 00 00 
  803396:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803398:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339f:	00 00 00 
  8033a2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033a5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033a8:	bf 05 00 00 00       	mov    $0x5,%edi
  8033ad:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
}
  8033b9:	c9                   	leaveq 
  8033ba:	c3                   	retq   

00000000008033bb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033bb:	55                   	push   %rbp
  8033bc:	48 89 e5             	mov    %rsp,%rbp
  8033bf:	48 83 ec 10          	sub    $0x10,%rsp
  8033c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033c6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8033c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d0:	00 00 00 
  8033d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8033d8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033df:	00 00 00 
  8033e2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8033e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8033ed:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  8033f4:	00 00 00 
  8033f7:	ff d0                	callq  *%rax
}
  8033f9:	c9                   	leaveq 
  8033fa:	c3                   	retq   

00000000008033fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033fb:	55                   	push   %rbp
  8033fc:	48 89 e5             	mov    %rsp,%rbp
  8033ff:	48 83 ec 30          	sub    $0x30,%rsp
  803403:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803406:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80340a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80340d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803410:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803417:	00 00 00 
  80341a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80341d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80341f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803426:	00 00 00 
  803429:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80342c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80342f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803436:	00 00 00 
  803439:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80343c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80343f:	bf 07 00 00 00       	mov    $0x7,%edi
  803444:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803457:	78 69                	js     8034c2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803459:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803460:	7f 08                	jg     80346a <nsipc_recv+0x6f>
  803462:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803465:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803468:	7e 35                	jle    80349f <nsipc_recv+0xa4>
  80346a:	48 b9 cf 47 80 00 00 	movabs $0x8047cf,%rcx
  803471:	00 00 00 
  803474:	48 ba e4 47 80 00 00 	movabs $0x8047e4,%rdx
  80347b:	00 00 00 
  80347e:	be 61 00 00 00       	mov    $0x61,%esi
  803483:	48 bf f9 47 80 00 00 	movabs $0x8047f9,%rdi
  80348a:	00 00 00 
  80348d:	b8 00 00 00 00       	mov    $0x0,%eax
  803492:	49 b8 2e 02 80 00 00 	movabs $0x80022e,%r8
  803499:	00 00 00 
  80349c:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80349f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a2:	48 63 d0             	movslq %eax,%rdx
  8034a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034a9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8034b0:	00 00 00 
  8034b3:	48 89 c7             	mov    %rax,%rdi
  8034b6:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
	}

	return r;
  8034c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 20          	sub    $0x20,%rsp
  8034cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034d6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8034d9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8034dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e3:	00 00 00 
  8034e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034e9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8034eb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034f2:	7e 35                	jle    803529 <nsipc_send+0x62>
  8034f4:	48 b9 05 48 80 00 00 	movabs $0x804805,%rcx
  8034fb:	00 00 00 
  8034fe:	48 ba e4 47 80 00 00 	movabs $0x8047e4,%rdx
  803505:	00 00 00 
  803508:	be 6c 00 00 00       	mov    $0x6c,%esi
  80350d:	48 bf f9 47 80 00 00 	movabs $0x8047f9,%rdi
  803514:	00 00 00 
  803517:	b8 00 00 00 00       	mov    $0x0,%eax
  80351c:	49 b8 2e 02 80 00 00 	movabs $0x80022e,%r8
  803523:	00 00 00 
  803526:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803529:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352c:	48 63 d0             	movslq %eax,%rdx
  80352f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803533:	48 89 c6             	mov    %rax,%rsi
  803536:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80353d:	00 00 00 
  803540:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  803547:	00 00 00 
  80354a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80354c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803553:	00 00 00 
  803556:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803559:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80355c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803563:	00 00 00 
  803566:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803569:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80356c:	bf 08 00 00 00       	mov    $0x8,%edi
  803571:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  803578:	00 00 00 
  80357b:	ff d0                	callq  *%rax
}
  80357d:	c9                   	leaveq 
  80357e:	c3                   	retq   

000000000080357f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80357f:	55                   	push   %rbp
  803580:	48 89 e5             	mov    %rsp,%rbp
  803583:	48 83 ec 10          	sub    $0x10,%rsp
  803587:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80358a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80358d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803590:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803597:	00 00 00 
  80359a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80359d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80359f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a6:	00 00 00 
  8035a9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b6:	00 00 00 
  8035b9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035bc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035bf:	bf 09 00 00 00       	mov    $0x9,%edi
  8035c4:	48 b8 86 31 80 00 00 	movabs $0x803186,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
}
  8035d0:	c9                   	leaveq 
  8035d1:	c3                   	retq   

00000000008035d2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035d2:	55                   	push   %rbp
  8035d3:	48 89 e5             	mov    %rsp,%rbp
  8035d6:	53                   	push   %rbx
  8035d7:	48 83 ec 38          	sub    $0x38,%rsp
  8035db:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035df:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f9:	0f 88 bf 01 00 00    	js     8037be <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803603:	ba 07 04 00 00       	mov    $0x407,%edx
  803608:	48 89 c6             	mov    %rax,%rsi
  80360b:	bf 00 00 00 00       	mov    $0x0,%edi
  803610:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803623:	0f 88 95 01 00 00    	js     8037be <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803629:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80362d:	48 89 c7             	mov    %rax,%rdi
  803630:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803643:	0f 88 5d 01 00 00    	js     8037a6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803649:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80364d:	ba 07 04 00 00       	mov    $0x407,%edx
  803652:	48 89 c6             	mov    %rax,%rsi
  803655:	bf 00 00 00 00       	mov    $0x0,%edi
  80365a:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
  803666:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803669:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80366d:	0f 88 33 01 00 00    	js     8037a6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803677:	48 89 c7             	mov    %rax,%rdi
  80367a:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
  803686:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80368a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368e:	ba 07 04 00 00       	mov    $0x407,%edx
  803693:	48 89 c6             	mov    %rax,%rsi
  803696:	bf 00 00 00 00       	mov    $0x0,%edi
  80369b:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
  8036a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ae:	79 05                	jns    8036b5 <pipe+0xe3>
		goto err2;
  8036b0:	e9 d9 00 00 00       	jmpq   80378e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036b9:	48 89 c7             	mov    %rax,%rdi
  8036bc:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	48 89 c2             	mov    %rax,%rdx
  8036cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cf:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036d5:	48 89 d1             	mov    %rdx,%rcx
  8036d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8036dd:	48 89 c6             	mov    %rax,%rsi
  8036e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e5:	48 b8 9b 19 80 00 00 	movabs $0x80199b,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f8:	79 1b                	jns    803715 <pipe+0x143>
		goto err3;
  8036fa:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ff:	48 89 c6             	mov    %rax,%rsi
  803702:	bf 00 00 00 00       	mov    $0x0,%edi
  803707:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
  803713:	eb 79                	jmp    80378e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803719:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803720:	00 00 00 
  803723:	8b 12                	mov    (%rdx),%edx
  803725:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80372b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803736:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80373d:	00 00 00 
  803740:	8b 12                	mov    (%rdx),%edx
  803742:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803748:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80374f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
  803762:	89 c2                	mov    %eax,%edx
  803764:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803768:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80376a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80376e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803772:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803776:	48 89 c7             	mov    %rax,%rdi
  803779:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
  803785:	89 03                	mov    %eax,(%rbx)
	return 0;
  803787:	b8 00 00 00 00       	mov    $0x0,%eax
  80378c:	eb 33                	jmp    8037c1 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80378e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803792:	48 89 c6             	mov    %rax,%rsi
  803795:	bf 00 00 00 00       	mov    $0x0,%edi
  80379a:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037aa:	48 89 c6             	mov    %rax,%rsi
  8037ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b2:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
err:
	return r;
  8037be:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037c1:	48 83 c4 38          	add    $0x38,%rsp
  8037c5:	5b                   	pop    %rbx
  8037c6:	5d                   	pop    %rbp
  8037c7:	c3                   	retq   

00000000008037c8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037c8:	55                   	push   %rbp
  8037c9:	48 89 e5             	mov    %rsp,%rbp
  8037cc:	53                   	push   %rbx
  8037cd:	48 83 ec 28          	sub    $0x28,%rsp
  8037d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037d9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037e0:	00 00 00 
  8037e3:	48 8b 00             	mov    (%rax),%rax
  8037e6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f3:	48 89 c7             	mov    %rax,%rdi
  8037f6:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
  803802:	89 c3                	mov    %eax,%ebx
  803804:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803808:	48 89 c7             	mov    %rax,%rdi
  80380b:	48 b8 38 40 80 00 00 	movabs $0x804038,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
  803817:	39 c3                	cmp    %eax,%ebx
  803819:	0f 94 c0             	sete   %al
  80381c:	0f b6 c0             	movzbl %al,%eax
  80381f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803822:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803829:	00 00 00 
  80382c:	48 8b 00             	mov    (%rax),%rax
  80382f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803835:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803838:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80383b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80383e:	75 05                	jne    803845 <_pipeisclosed+0x7d>
			return ret;
  803840:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803843:	eb 4f                	jmp    803894 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803845:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803848:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80384b:	74 42                	je     80388f <_pipeisclosed+0xc7>
  80384d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803851:	75 3c                	jne    80388f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803853:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80385a:	00 00 00 
  80385d:	48 8b 00             	mov    (%rax),%rax
  803860:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803866:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803869:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80386c:	89 c6                	mov    %eax,%esi
  80386e:	48 bf 16 48 80 00 00 	movabs $0x804816,%rdi
  803875:	00 00 00 
  803878:	b8 00 00 00 00       	mov    $0x0,%eax
  80387d:	49 b8 67 04 80 00 00 	movabs $0x800467,%r8
  803884:	00 00 00 
  803887:	41 ff d0             	callq  *%r8
	}
  80388a:	e9 4a ff ff ff       	jmpq   8037d9 <_pipeisclosed+0x11>
  80388f:	e9 45 ff ff ff       	jmpq   8037d9 <_pipeisclosed+0x11>
}
  803894:	48 83 c4 28          	add    $0x28,%rsp
  803898:	5b                   	pop    %rbx
  803899:	5d                   	pop    %rbp
  80389a:	c3                   	retq   

000000000080389b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80389b:	55                   	push   %rbp
  80389c:	48 89 e5             	mov    %rsp,%rbp
  80389f:	48 83 ec 30          	sub    $0x30,%rsp
  8038a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038ad:	48 89 d6             	mov    %rdx,%rsi
  8038b0:	89 c7                	mov    %eax,%edi
  8038b2:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
  8038be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c5:	79 05                	jns    8038cc <pipeisclosed+0x31>
		return r;
  8038c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ca:	eb 31                	jmp    8038fd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d0:	48 89 c7             	mov    %rax,%rdi
  8038d3:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
  8038df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038eb:	48 89 d6             	mov    %rdx,%rsi
  8038ee:	48 89 c7             	mov    %rax,%rdi
  8038f1:	48 b8 c8 37 80 00 00 	movabs $0x8037c8,%rax
  8038f8:	00 00 00 
  8038fb:	ff d0                	callq  *%rax
}
  8038fd:	c9                   	leaveq 
  8038fe:	c3                   	retq   

00000000008038ff <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ff:	55                   	push   %rbp
  803900:	48 89 e5             	mov    %rsp,%rbp
  803903:	48 83 ec 40          	sub    $0x40,%rsp
  803907:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80390b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80390f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803917:	48 89 c7             	mov    %rax,%rdi
  80391a:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803921:	00 00 00 
  803924:	ff d0                	callq  *%rax
  803926:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80392a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803932:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803939:	00 
  80393a:	e9 92 00 00 00       	jmpq   8039d1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80393f:	eb 41                	jmp    803982 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803941:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803946:	74 09                	je     803951 <devpipe_read+0x52>
				return i;
  803948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80394c:	e9 92 00 00 00       	jmpq   8039e3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803951:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803959:	48 89 d6             	mov    %rdx,%rsi
  80395c:	48 89 c7             	mov    %rax,%rdi
  80395f:	48 b8 c8 37 80 00 00 	movabs $0x8037c8,%rax
  803966:	00 00 00 
  803969:	ff d0                	callq  *%rax
  80396b:	85 c0                	test   %eax,%eax
  80396d:	74 07                	je     803976 <devpipe_read+0x77>
				return 0;
  80396f:	b8 00 00 00 00       	mov    $0x0,%eax
  803974:	eb 6d                	jmp    8039e3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803976:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803986:	8b 10                	mov    (%rax),%edx
  803988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398c:	8b 40 04             	mov    0x4(%rax),%eax
  80398f:	39 c2                	cmp    %eax,%edx
  803991:	74 ae                	je     803941 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803993:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80399b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80399f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a3:	8b 00                	mov    (%rax),%eax
  8039a5:	99                   	cltd   
  8039a6:	c1 ea 1b             	shr    $0x1b,%edx
  8039a9:	01 d0                	add    %edx,%eax
  8039ab:	83 e0 1f             	and    $0x1f,%eax
  8039ae:	29 d0                	sub    %edx,%eax
  8039b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039b4:	48 98                	cltq   
  8039b6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039bb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c1:	8b 00                	mov    (%rax),%eax
  8039c3:	8d 50 01             	lea    0x1(%rax),%edx
  8039c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ca:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039d9:	0f 82 60 ff ff ff    	jb     80393f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039e3:	c9                   	leaveq 
  8039e4:	c3                   	retq   

00000000008039e5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039e5:	55                   	push   %rbp
  8039e6:	48 89 e5             	mov    %rsp,%rbp
  8039e9:	48 83 ec 40          	sub    $0x40,%rsp
  8039ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fd:	48 89 c7             	mov    %rax,%rdi
  803a00:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803a07:	00 00 00 
  803a0a:	ff d0                	callq  *%rax
  803a0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a14:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a18:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a1f:	00 
  803a20:	e9 8e 00 00 00       	jmpq   803ab3 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a25:	eb 31                	jmp    803a58 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2f:	48 89 d6             	mov    %rdx,%rsi
  803a32:	48 89 c7             	mov    %rax,%rdi
  803a35:	48 b8 c8 37 80 00 00 	movabs $0x8037c8,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 07                	je     803a4c <devpipe_write+0x67>
				return 0;
  803a45:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4a:	eb 79                	jmp    803ac5 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a4c:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  803a53:	00 00 00 
  803a56:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5c:	8b 40 04             	mov    0x4(%rax),%eax
  803a5f:	48 63 d0             	movslq %eax,%rdx
  803a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a66:	8b 00                	mov    (%rax),%eax
  803a68:	48 98                	cltq   
  803a6a:	48 83 c0 20          	add    $0x20,%rax
  803a6e:	48 39 c2             	cmp    %rax,%rdx
  803a71:	73 b4                	jae    803a27 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	8b 40 04             	mov    0x4(%rax),%eax
  803a7a:	99                   	cltd   
  803a7b:	c1 ea 1b             	shr    $0x1b,%edx
  803a7e:	01 d0                	add    %edx,%eax
  803a80:	83 e0 1f             	and    $0x1f,%eax
  803a83:	29 d0                	sub    %edx,%eax
  803a85:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a8d:	48 01 ca             	add    %rcx,%rdx
  803a90:	0f b6 0a             	movzbl (%rdx),%ecx
  803a93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a97:	48 98                	cltq   
  803a99:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa1:	8b 40 04             	mov    0x4(%rax),%eax
  803aa4:	8d 50 01             	lea    0x1(%rax),%edx
  803aa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aab:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803aae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803abb:	0f 82 64 ff ff ff    	jb     803a25 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ac1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ac5:	c9                   	leaveq 
  803ac6:	c3                   	retq   

0000000000803ac7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ac7:	55                   	push   %rbp
  803ac8:	48 89 e5             	mov    %rsp,%rbp
  803acb:	48 83 ec 20          	sub    $0x20,%rsp
  803acf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ad3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803adb:	48 89 c7             	mov    %rax,%rdi
  803ade:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803ae5:	00 00 00 
  803ae8:	ff d0                	callq  *%rax
  803aea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803aee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af2:	48 be 29 48 80 00 00 	movabs $0x804829,%rsi
  803af9:	00 00 00 
  803afc:	48 89 c7             	mov    %rax,%rdi
  803aff:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  803b06:	00 00 00 
  803b09:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b0f:	8b 50 04             	mov    0x4(%rax),%edx
  803b12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b16:	8b 00                	mov    (%rax),%eax
  803b18:	29 c2                	sub    %eax,%edx
  803b1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b28:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b2f:	00 00 00 
	stat->st_dev = &devpipe;
  803b32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b36:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b3d:	00 00 00 
  803b40:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b4c:	c9                   	leaveq 
  803b4d:	c3                   	retq   

0000000000803b4e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b4e:	55                   	push   %rbp
  803b4f:	48 89 e5             	mov    %rsp,%rbp
  803b52:	48 83 ec 10          	sub    $0x10,%rsp
  803b56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5e:	48 89 c6             	mov    %rax,%rsi
  803b61:	bf 00 00 00 00       	mov    $0x0,%edi
  803b66:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803b6d:	00 00 00 
  803b70:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b76:	48 89 c7             	mov    %rax,%rdi
  803b79:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	48 89 c6             	mov    %rax,%rsi
  803b88:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8d:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803b94:	00 00 00 
  803b97:	ff d0                	callq  *%rax
}
  803b99:	c9                   	leaveq 
  803b9a:	c3                   	retq   

0000000000803b9b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b9b:	55                   	push   %rbp
  803b9c:	48 89 e5             	mov    %rsp,%rbp
  803b9f:	48 83 ec 20          	sub    $0x20,%rsp
  803ba3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ba9:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bac:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bb0:	be 01 00 00 00       	mov    $0x1,%esi
  803bb5:	48 89 c7             	mov    %rax,%rdi
  803bb8:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803bbf:	00 00 00 
  803bc2:	ff d0                	callq  *%rax
}
  803bc4:	c9                   	leaveq 
  803bc5:	c3                   	retq   

0000000000803bc6 <getchar>:

int
getchar(void)
{
  803bc6:	55                   	push   %rbp
  803bc7:	48 89 e5             	mov    %rsp,%rbp
  803bca:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bce:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803bd2:	ba 01 00 00 00       	mov    $0x1,%edx
  803bd7:	48 89 c6             	mov    %rax,%rsi
  803bda:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdf:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf2:	79 05                	jns    803bf9 <getchar+0x33>
		return r;
  803bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf7:	eb 14                	jmp    803c0d <getchar+0x47>
	if (r < 1)
  803bf9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bfd:	7f 07                	jg     803c06 <getchar+0x40>
		return -E_EOF;
  803bff:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c04:	eb 07                	jmp    803c0d <getchar+0x47>
	return c;
  803c06:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c0a:	0f b6 c0             	movzbl %al,%eax
}
  803c0d:	c9                   	leaveq 
  803c0e:	c3                   	retq   

0000000000803c0f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c0f:	55                   	push   %rbp
  803c10:	48 89 e5             	mov    %rsp,%rbp
  803c13:	48 83 ec 20          	sub    $0x20,%rsp
  803c17:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c1a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c1e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c21:	48 89 d6             	mov    %rdx,%rsi
  803c24:	89 c7                	mov    %eax,%edi
  803c26:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  803c2d:	00 00 00 
  803c30:	ff d0                	callq  *%rax
  803c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c39:	79 05                	jns    803c40 <iscons+0x31>
		return r;
  803c3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c3e:	eb 1a                	jmp    803c5a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c44:	8b 10                	mov    (%rax),%edx
  803c46:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c4d:	00 00 00 
  803c50:	8b 00                	mov    (%rax),%eax
  803c52:	39 c2                	cmp    %eax,%edx
  803c54:	0f 94 c0             	sete   %al
  803c57:	0f b6 c0             	movzbl %al,%eax
}
  803c5a:	c9                   	leaveq 
  803c5b:	c3                   	retq   

0000000000803c5c <opencons>:

int
opencons(void)
{
  803c5c:	55                   	push   %rbp
  803c5d:	48 89 e5             	mov    %rsp,%rbp
  803c60:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c64:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c68:	48 89 c7             	mov    %rax,%rdi
  803c6b:	48 b8 10 1e 80 00 00 	movabs $0x801e10,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7e:	79 05                	jns    803c85 <opencons+0x29>
		return r;
  803c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c83:	eb 5b                	jmp    803ce0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c89:	ba 07 04 00 00       	mov    $0x407,%edx
  803c8e:	48 89 c6             	mov    %rax,%rsi
  803c91:	bf 00 00 00 00       	mov    $0x0,%edi
  803c96:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca9:	79 05                	jns    803cb0 <opencons+0x54>
		return r;
  803cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cae:	eb 30                	jmp    803ce0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb4:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cbb:	00 00 00 
  803cbe:	8b 12                	mov    (%rdx),%edx
  803cc0:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd1:	48 89 c7             	mov    %rax,%rdi
  803cd4:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  803cdb:	00 00 00 
  803cde:	ff d0                	callq  *%rax
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 30          	sub    $0x30,%rsp
  803cea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803cf6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cfb:	75 07                	jne    803d04 <devcons_read+0x22>
		return 0;
  803cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  803d02:	eb 4b                	jmp    803d4f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d04:	eb 0c                	jmp    803d12 <devcons_read+0x30>
		sys_yield();
  803d06:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  803d0d:	00 00 00 
  803d10:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d12:	48 b8 4d 18 80 00 00 	movabs $0x80184d,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d25:	74 df                	je     803d06 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803d27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2b:	79 05                	jns    803d32 <devcons_read+0x50>
		return c;
  803d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d30:	eb 1d                	jmp    803d4f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d32:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d36:	75 07                	jne    803d3f <devcons_read+0x5d>
		return 0;
  803d38:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3d:	eb 10                	jmp    803d4f <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d42:	89 c2                	mov    %eax,%edx
  803d44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d48:	88 10                	mov    %dl,(%rax)
	return 1;
  803d4a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d4f:	c9                   	leaveq 
  803d50:	c3                   	retq   

0000000000803d51 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d51:	55                   	push   %rbp
  803d52:	48 89 e5             	mov    %rsp,%rbp
  803d55:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d5c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d63:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d6a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d78:	eb 76                	jmp    803df0 <devcons_write+0x9f>
		m = n - tot;
  803d7a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d81:	89 c2                	mov    %eax,%edx
  803d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d86:	29 c2                	sub    %eax,%edx
  803d88:	89 d0                	mov    %edx,%eax
  803d8a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d90:	83 f8 7f             	cmp    $0x7f,%eax
  803d93:	76 07                	jbe    803d9c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d95:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9f:	48 63 d0             	movslq %eax,%rdx
  803da2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da5:	48 63 c8             	movslq %eax,%rcx
  803da8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803daf:	48 01 c1             	add    %rax,%rcx
  803db2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803db9:	48 89 ce             	mov    %rcx,%rsi
  803dbc:	48 89 c7             	mov    %rax,%rdi
  803dbf:	48 b8 40 13 80 00 00 	movabs $0x801340,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803dcb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dce:	48 63 d0             	movslq %eax,%rdx
  803dd1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dd8:	48 89 d6             	mov    %rdx,%rsi
  803ddb:	48 89 c7             	mov    %rax,%rdi
  803dde:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803de5:	00 00 00 
  803de8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ded:	01 45 fc             	add    %eax,-0x4(%rbp)
  803df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df3:	48 98                	cltq   
  803df5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dfc:	0f 82 78 ff ff ff    	jb     803d7a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e05:	c9                   	leaveq 
  803e06:	c3                   	retq   

0000000000803e07 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e07:	55                   	push   %rbp
  803e08:	48 89 e5             	mov    %rsp,%rbp
  803e0b:	48 83 ec 08          	sub    $0x8,%rsp
  803e0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e18:	c9                   	leaveq 
  803e19:	c3                   	retq   

0000000000803e1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e1a:	55                   	push   %rbp
  803e1b:	48 89 e5             	mov    %rsp,%rbp
  803e1e:	48 83 ec 10          	sub    $0x10,%rsp
  803e22:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2e:	48 be 35 48 80 00 00 	movabs $0x804835,%rsi
  803e35:	00 00 00 
  803e38:	48 89 c7             	mov    %rax,%rdi
  803e3b:	48 b8 1c 10 80 00 00 	movabs $0x80101c,%rax
  803e42:	00 00 00 
  803e45:	ff d0                	callq  *%rax
	return 0;
  803e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e4c:	c9                   	leaveq 
  803e4d:	c3                   	retq   

0000000000803e4e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e4e:	55                   	push   %rbp
  803e4f:	48 89 e5             	mov    %rsp,%rbp
  803e52:	48 83 ec 30          	sub    $0x30,%rsp
  803e56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e5e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e62:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e69:	00 00 00 
  803e6c:	48 8b 00             	mov    (%rax),%rax
  803e6f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e75:	85 c0                	test   %eax,%eax
  803e77:	75 3c                	jne    803eb5 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803e79:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
  803e85:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e8a:	48 63 d0             	movslq %eax,%rdx
  803e8d:	48 89 d0             	mov    %rdx,%rax
  803e90:	48 c1 e0 03          	shl    $0x3,%rax
  803e94:	48 01 d0             	add    %rdx,%rax
  803e97:	48 c1 e0 05          	shl    $0x5,%rax
  803e9b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ea2:	00 00 00 
  803ea5:	48 01 c2             	add    %rax,%rdx
  803ea8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803eaf:	00 00 00 
  803eb2:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803eb5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eba:	75 0e                	jne    803eca <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803ebc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ec3:	00 00 00 
  803ec6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803eca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ece:	48 89 c7             	mov    %rax,%rdi
  803ed1:	48 b8 74 1b 80 00 00 	movabs $0x801b74,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
  803edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee4:	79 19                	jns    803eff <ipc_recv+0xb1>
		*from_env_store = 0;
  803ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ef0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efd:	eb 53                	jmp    803f52 <ipc_recv+0x104>
	}
	if(from_env_store)
  803eff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f04:	74 19                	je     803f1f <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803f06:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f0d:	00 00 00 
  803f10:	48 8b 00             	mov    (%rax),%rax
  803f13:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f1d:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803f1f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f24:	74 19                	je     803f3f <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803f26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f2d:	00 00 00 
  803f30:	48 8b 00             	mov    (%rax),%rax
  803f33:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f3d:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f3f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f46:	00 00 00 
  803f49:	48 8b 00             	mov    (%rax),%rax
  803f4c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f52:	c9                   	leaveq 
  803f53:	c3                   	retq   

0000000000803f54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f54:	55                   	push   %rbp
  803f55:	48 89 e5             	mov    %rsp,%rbp
  803f58:	48 83 ec 30          	sub    $0x30,%rsp
  803f5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f5f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f62:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f66:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f69:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f6e:	75 0e                	jne    803f7e <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f70:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f77:	00 00 00 
  803f7a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803f7e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f81:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f84:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8b:	89 c7                	mov    %eax,%edi
  803f8d:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803f94:	00 00 00 
  803f97:	ff d0                	callq  *%rax
  803f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803f9c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fa0:	75 0c                	jne    803fae <ipc_send+0x5a>
			sys_yield();
  803fa2:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  803fa9:	00 00 00 
  803fac:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803fae:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fb2:	74 ca                	je     803f7e <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803fb4:	c9                   	leaveq 
  803fb5:	c3                   	retq   

0000000000803fb6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803fb6:	55                   	push   %rbp
  803fb7:	48 89 e5             	mov    %rsp,%rbp
  803fba:	48 83 ec 14          	sub    $0x14,%rsp
  803fbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fc8:	eb 5e                	jmp    804028 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803fca:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fd1:	00 00 00 
  803fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd7:	48 63 d0             	movslq %eax,%rdx
  803fda:	48 89 d0             	mov    %rdx,%rax
  803fdd:	48 c1 e0 03          	shl    $0x3,%rax
  803fe1:	48 01 d0             	add    %rdx,%rax
  803fe4:	48 c1 e0 05          	shl    $0x5,%rax
  803fe8:	48 01 c8             	add    %rcx,%rax
  803feb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ff1:	8b 00                	mov    (%rax),%eax
  803ff3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ff6:	75 2c                	jne    804024 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ff8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fff:	00 00 00 
  804002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804005:	48 63 d0             	movslq %eax,%rdx
  804008:	48 89 d0             	mov    %rdx,%rax
  80400b:	48 c1 e0 03          	shl    $0x3,%rax
  80400f:	48 01 d0             	add    %rdx,%rax
  804012:	48 c1 e0 05          	shl    $0x5,%rax
  804016:	48 01 c8             	add    %rcx,%rax
  804019:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80401f:	8b 40 08             	mov    0x8(%rax),%eax
  804022:	eb 12                	jmp    804036 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804024:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804028:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80402f:	7e 99                	jle    803fca <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804036:	c9                   	leaveq 
  804037:	c3                   	retq   

0000000000804038 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804038:	55                   	push   %rbp
  804039:	48 89 e5             	mov    %rsp,%rbp
  80403c:	48 83 ec 18          	sub    $0x18,%rsp
  804040:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804048:	48 c1 e8 15          	shr    $0x15,%rax
  80404c:	48 89 c2             	mov    %rax,%rdx
  80404f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804056:	01 00 00 
  804059:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80405d:	83 e0 01             	and    $0x1,%eax
  804060:	48 85 c0             	test   %rax,%rax
  804063:	75 07                	jne    80406c <pageref+0x34>
		return 0;
  804065:	b8 00 00 00 00       	mov    $0x0,%eax
  80406a:	eb 53                	jmp    8040bf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80406c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804070:	48 c1 e8 0c          	shr    $0xc,%rax
  804074:	48 89 c2             	mov    %rax,%rdx
  804077:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80407e:	01 00 00 
  804081:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804085:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408d:	83 e0 01             	and    $0x1,%eax
  804090:	48 85 c0             	test   %rax,%rax
  804093:	75 07                	jne    80409c <pageref+0x64>
		return 0;
  804095:	b8 00 00 00 00       	mov    $0x0,%eax
  80409a:	eb 23                	jmp    8040bf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80409c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8040a4:	48 89 c2             	mov    %rax,%rdx
  8040a7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040ae:	00 00 00 
  8040b1:	48 c1 e2 04          	shl    $0x4,%rdx
  8040b5:	48 01 d0             	add    %rdx,%rax
  8040b8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8040bc:	0f b7 c0             	movzwl %ax,%eax
}
  8040bf:	c9                   	leaveq 
  8040c0:	c3                   	retq   
