
obj/user/faultallocbad.debug:     file format elf64-x86-64


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
  80003c:	e8 15 01 00 00       	callq  800156 <libmain>
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
  800061:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
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
  80009b:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
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
  8000bd:	48 ba b0 40 80 00 00 	movabs $0x8040b0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf db 40 80 00 00 	movabs $0x8040db,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 04 02 80 00 00 	movabs $0x800204,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba f0 40 80 00 00 	movabs $0x8040f0,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 a5 0e 80 00 00 	movabs $0x800ea5,%r8
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
  800132:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
}
  800154:	c9                   	leaveq 
  800155:	c3                   	retq   

0000000000800156 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	48 83 ec 10          	sub    $0x10,%rsp
  80015e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800165:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
  800171:	25 ff 03 00 00       	and    $0x3ff,%eax
  800176:	48 63 d0             	movslq %eax,%rdx
  800179:	48 89 d0             	mov    %rdx,%rax
  80017c:	48 c1 e0 03          	shl    $0x3,%rax
  800180:	48 01 d0             	add    %rdx,%rax
  800183:	48 c1 e0 05          	shl    $0x5,%rax
  800187:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80018e:	00 00 00 
  800191:	48 01 c2             	add    %rax,%rdx
  800194:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80019b:	00 00 00 
  80019e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a5:	7e 14                	jle    8001bb <libmain+0x65>
		binaryname = argv[0];
  8001a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ab:	48 8b 10             	mov    (%rax),%rdx
  8001ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001b5:	00 00 00 
  8001b8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c2:	48 89 d6             	mov    %rdx,%rsi
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001d3:	48 b8 e1 01 80 00 00 	movabs $0x8001e1,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	callq  *%rax
}
  8001df:	c9                   	leaveq 
  8001e0:	c3                   	retq   

00000000008001e1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e1:	55                   	push   %rbp
  8001e2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e5:	48 b8 d9 20 80 00 00 	movabs $0x8020d9,%rax
  8001ec:	00 00 00 
  8001ef:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f6:	48 b8 61 18 80 00 00 	movabs $0x801861,%rax
  8001fd:	00 00 00 
  800200:	ff d0                	callq  *%rax

}
  800202:	5d                   	pop    %rbp
  800203:	c3                   	retq   

0000000000800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800204:	55                   	push   %rbp
  800205:	48 89 e5             	mov    %rsp,%rbp
  800208:	53                   	push   %rbx
  800209:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800210:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800217:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80021d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800224:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80022b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800232:	84 c0                	test   %al,%al
  800234:	74 23                	je     800259 <_panic+0x55>
  800236:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80023d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800241:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800245:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800249:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80024d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800251:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800255:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800259:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800260:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800267:	00 00 00 
  80026a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800271:	00 00 00 
  800274:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800278:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80027f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800286:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80028d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800294:	00 00 00 
  800297:	48 8b 18             	mov    (%rax),%rbx
  80029a:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
  8002a6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002ac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002b3:	41 89 c8             	mov    %ecx,%r8d
  8002b6:	48 89 d1             	mov    %rdx,%rcx
  8002b9:	48 89 da             	mov    %rbx,%rdx
  8002bc:	89 c6                	mov    %eax,%esi
  8002be:	48 bf 20 41 80 00 00 	movabs $0x804120,%rdi
  8002c5:	00 00 00 
  8002c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cd:	49 b9 3d 04 80 00 00 	movabs $0x80043d,%r9
  8002d4:	00 00 00 
  8002d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002e8:	48 89 d6             	mov    %rdx,%rsi
  8002eb:	48 89 c7             	mov    %rax,%rdi
  8002ee:	48 b8 91 03 80 00 00 	movabs $0x800391,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8002fa:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  800310:	00 00 00 
  800313:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800315:	cc                   	int3   
  800316:	eb fd                	jmp    800315 <_panic+0x111>

0000000000800318 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800318:	55                   	push   %rbp
  800319:	48 89 e5             	mov    %rsp,%rbp
  80031c:	48 83 ec 10          	sub    $0x10,%rsp
  800320:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800323:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032b:	8b 00                	mov    (%rax),%eax
  80032d:	8d 48 01             	lea    0x1(%rax),%ecx
  800330:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800334:	89 0a                	mov    %ecx,(%rdx)
  800336:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800339:	89 d1                	mov    %edx,%ecx
  80033b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80033f:	48 98                	cltq   
  800341:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800345:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800349:	8b 00                	mov    (%rax),%eax
  80034b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800350:	75 2c                	jne    80037e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800356:	8b 00                	mov    (%rax),%eax
  800358:	48 98                	cltq   
  80035a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80035e:	48 83 c2 08          	add    $0x8,%rdx
  800362:	48 89 c6             	mov    %rax,%rsi
  800365:	48 89 d7             	mov    %rdx,%rdi
  800368:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80036f:	00 00 00 
  800372:	ff d0                	callq  *%rax
        b->idx = 0;
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80037e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800382:	8b 40 04             	mov    0x4(%rax),%eax
  800385:	8d 50 01             	lea    0x1(%rax),%edx
  800388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80038f:	c9                   	leaveq 
  800390:	c3                   	retq   

0000000000800391 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800391:	55                   	push   %rbp
  800392:	48 89 e5             	mov    %rsp,%rbp
  800395:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80039c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003b8:	48 8b 0a             	mov    (%rdx),%rcx
  8003bb:	48 89 08             	mov    %rcx,(%rax)
  8003be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003d5:	00 00 00 
    b.cnt = 0;
  8003d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003df:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8003e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003f7:	48 89 c6             	mov    %rax,%rsi
  8003fa:	48 bf 18 03 80 00 00 	movabs $0x800318,%rdi
  800401:	00 00 00 
  800404:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  80040b:	00 00 00 
  80040e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800410:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800416:	48 98                	cltq   
  800418:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80041f:	48 83 c2 08          	add    $0x8,%rdx
  800423:	48 89 c6             	mov    %rax,%rsi
  800426:	48 89 d7             	mov    %rdx,%rdi
  800429:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  800430:	00 00 00 
  800433:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800435:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80043b:	c9                   	leaveq 
  80043c:	c3                   	retq   

000000000080043d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80043d:	55                   	push   %rbp
  80043e:	48 89 e5             	mov    %rsp,%rbp
  800441:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800448:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80044f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800456:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80045d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800464:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80046b:	84 c0                	test   %al,%al
  80046d:	74 20                	je     80048f <cprintf+0x52>
  80046f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800473:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800477:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80047b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80047f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800483:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800487:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80048b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80048f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800496:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80049d:	00 00 00 
  8004a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004a7:	00 00 00 
  8004aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004d1:	48 8b 0a             	mov    (%rdx),%rcx
  8004d4:	48 89 08             	mov    %rcx,(%rax)
  8004d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8004e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004f5:	48 89 d6             	mov    %rdx,%rsi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	48 b8 91 03 80 00 00 	movabs $0x800391,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
  800507:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80050d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800513:	c9                   	leaveq 
  800514:	c3                   	retq   

0000000000800515 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800515:	55                   	push   %rbp
  800516:	48 89 e5             	mov    %rsp,%rbp
  800519:	53                   	push   %rbx
  80051a:	48 83 ec 38          	sub    $0x38,%rsp
  80051e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800522:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800526:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80052a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80052d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800531:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800535:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800538:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80053c:	77 3b                	ja     800579 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80053e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800541:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800545:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
  800551:	48 f7 f3             	div    %rbx
  800554:	48 89 c2             	mov    %rax,%rdx
  800557:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80055a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80055d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	41 89 f9             	mov    %edi,%r9d
  800568:	48 89 c7             	mov    %rax,%rdi
  80056b:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800572:	00 00 00 
  800575:	ff d0                	callq  *%rax
  800577:	eb 1e                	jmp    800597 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800579:	eb 12                	jmp    80058d <printnum+0x78>
			putch(padc, putdat);
  80057b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80057f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 89 ce             	mov    %rcx,%rsi
  800589:	89 d7                	mov    %edx,%edi
  80058b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80058d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800591:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800595:	7f e4                	jg     80057b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800597:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	48 f7 f1             	div    %rcx
  8005a6:	48 89 d0             	mov    %rdx,%rax
  8005a9:	48 ba 50 43 80 00 00 	movabs $0x804350,%rdx
  8005b0:	00 00 00 
  8005b3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005b7:	0f be d0             	movsbl %al,%edx
  8005ba:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c2:	48 89 ce             	mov    %rcx,%rsi
  8005c5:	89 d7                	mov    %edx,%edi
  8005c7:	ff d0                	callq  *%rax
}
  8005c9:	48 83 c4 38          	add    $0x38,%rsp
  8005cd:	5b                   	pop    %rbx
  8005ce:	5d                   	pop    %rbp
  8005cf:	c3                   	retq   

00000000008005d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d0:	55                   	push   %rbp
  8005d1:	48 89 e5             	mov    %rsp,%rbp
  8005d4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e3:	7e 52                	jle    800637 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	83 f8 30             	cmp    $0x30,%eax
  8005ee:	73 24                	jae    800614 <getuint+0x44>
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	8b 00                	mov    (%rax),%eax
  8005fe:	89 c0                	mov    %eax,%eax
  800600:	48 01 d0             	add    %rdx,%rax
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	8b 12                	mov    (%rdx),%edx
  800609:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	89 0a                	mov    %ecx,(%rdx)
  800612:	eb 17                	jmp    80062b <getuint+0x5b>
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061c:	48 89 d0             	mov    %rdx,%rax
  80061f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062b:	48 8b 00             	mov    (%rax),%rax
  80062e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800632:	e9 a3 00 00 00       	jmpq   8006da <getuint+0x10a>
	else if (lflag)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80063b:	74 4f                	je     80068c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 30             	cmp    $0x30,%eax
  800646:	73 24                	jae    80066c <getuint+0x9c>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	89 c0                	mov    %eax,%eax
  800658:	48 01 d0             	add    %rdx,%rax
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	8b 12                	mov    (%rdx),%edx
  800661:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	89 0a                	mov    %ecx,(%rdx)
  80066a:	eb 17                	jmp    800683 <getuint+0xb3>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800683:	48 8b 00             	mov    (%rax),%rax
  800686:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068a:	eb 4e                	jmp    8006da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	83 f8 30             	cmp    $0x30,%eax
  800695:	73 24                	jae    8006bb <getuint+0xeb>
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	89 c0                	mov    %eax,%eax
  8006a7:	48 01 d0             	add    %rdx,%rax
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	8b 12                	mov    (%rdx),%edx
  8006b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b7:	89 0a                	mov    %ecx,(%rdx)
  8006b9:	eb 17                	jmp    8006d2 <getuint+0x102>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c3:	48 89 d0             	mov    %rdx,%rax
  8006c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f3:	7e 52                	jle    800747 <getint+0x67>
		x=va_arg(*ap, long long);
  8006f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f9:	8b 00                	mov    (%rax),%eax
  8006fb:	83 f8 30             	cmp    $0x30,%eax
  8006fe:	73 24                	jae    800724 <getint+0x44>
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	89 c0                	mov    %eax,%eax
  800710:	48 01 d0             	add    %rdx,%rax
  800713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800717:	8b 12                	mov    (%rdx),%edx
  800719:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	89 0a                	mov    %ecx,(%rdx)
  800722:	eb 17                	jmp    80073b <getint+0x5b>
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072c:	48 89 d0             	mov    %rdx,%rax
  80072f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800737:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073b:	48 8b 00             	mov    (%rax),%rax
  80073e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800742:	e9 a3 00 00 00       	jmpq   8007ea <getint+0x10a>
	else if (lflag)
  800747:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80074b:	74 4f                	je     80079c <getint+0xbc>
		x=va_arg(*ap, long);
  80074d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800751:	8b 00                	mov    (%rax),%eax
  800753:	83 f8 30             	cmp    $0x30,%eax
  800756:	73 24                	jae    80077c <getint+0x9c>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	8b 00                	mov    (%rax),%eax
  800766:	89 c0                	mov    %eax,%eax
  800768:	48 01 d0             	add    %rdx,%rax
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	8b 12                	mov    (%rdx),%edx
  800771:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	89 0a                	mov    %ecx,(%rdx)
  80077a:	eb 17                	jmp    800793 <getint+0xb3>
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800784:	48 89 d0             	mov    %rdx,%rax
  800787:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800793:	48 8b 00             	mov    (%rax),%rax
  800796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079a:	eb 4e                	jmp    8007ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	83 f8 30             	cmp    $0x30,%eax
  8007a5:	73 24                	jae    8007cb <getint+0xeb>
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	8b 00                	mov    (%rax),%eax
  8007b5:	89 c0                	mov    %eax,%eax
  8007b7:	48 01 d0             	add    %rdx,%rax
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	8b 12                	mov    (%rdx),%edx
  8007c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c7:	89 0a                	mov    %ecx,(%rdx)
  8007c9:	eb 17                	jmp    8007e2 <getint+0x102>
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d3:	48 89 d0             	mov    %rdx,%rax
  8007d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	48 98                	cltq   
  8007e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ee:	c9                   	leaveq 
  8007ef:	c3                   	retq   

00000000008007f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f0:	55                   	push   %rbp
  8007f1:	48 89 e5             	mov    %rsp,%rbp
  8007f4:	41 54                	push   %r12
  8007f6:	53                   	push   %rbx
  8007f7:	48 83 ec 60          	sub    $0x60,%rsp
  8007fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800803:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800807:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80080b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80080f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800813:	48 8b 0a             	mov    (%rdx),%rcx
  800816:	48 89 08             	mov    %rcx,(%rax)
  800819:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80081d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800821:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800825:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800829:	eb 17                	jmp    800842 <vprintfmt+0x52>
			if (ch == '\0')
  80082b:	85 db                	test   %ebx,%ebx
  80082d:	0f 84 cc 04 00 00    	je     800cff <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800833:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800837:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083b:	48 89 d6             	mov    %rdx,%rsi
  80083e:	89 df                	mov    %ebx,%edi
  800840:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800842:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800846:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80084a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80084e:	0f b6 00             	movzbl (%rax),%eax
  800851:	0f b6 d8             	movzbl %al,%ebx
  800854:	83 fb 25             	cmp    $0x25,%ebx
  800857:	75 d2                	jne    80082b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800859:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80085d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800864:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80086b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800872:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800879:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80087d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800881:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800885:	0f b6 00             	movzbl (%rax),%eax
  800888:	0f b6 d8             	movzbl %al,%ebx
  80088b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80088e:	83 f8 55             	cmp    $0x55,%eax
  800891:	0f 87 34 04 00 00    	ja     800ccb <vprintfmt+0x4db>
  800897:	89 c0                	mov    %eax,%eax
  800899:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008a0:	00 
  8008a1:	48 b8 78 43 80 00 00 	movabs $0x804378,%rax
  8008a8:	00 00 00 
  8008ab:	48 01 d0             	add    %rdx,%rax
  8008ae:	48 8b 00             	mov    (%rax),%rax
  8008b1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008b3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008b7:	eb c0                	jmp    800879 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008bd:	eb ba                	jmp    800879 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008c6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008c9:	89 d0                	mov    %edx,%eax
  8008cb:	c1 e0 02             	shl    $0x2,%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	01 c0                	add    %eax,%eax
  8008d2:	01 d8                	add    %ebx,%eax
  8008d4:	83 e8 30             	sub    $0x30,%eax
  8008d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008de:	0f b6 00             	movzbl (%rax),%eax
  8008e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008e7:	7e 0c                	jle    8008f5 <vprintfmt+0x105>
  8008e9:	83 fb 39             	cmp    $0x39,%ebx
  8008ec:	7f 07                	jg     8008f5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ee:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f3:	eb d1                	jmp    8008c6 <vprintfmt+0xd6>
			goto process_precision;
  8008f5:	eb 58                	jmp    80094f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8008f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 17                	jae    800916 <vprintfmt+0x126>
  8008ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 01 d0             	add    %rdx,%rax
  80090b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80090e:	83 c2 08             	add    $0x8,%edx
  800911:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800914:	eb 0f                	jmp    800925 <vprintfmt+0x135>
  800916:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091a:	48 89 d0             	mov    %rdx,%rax
  80091d:	48 83 c2 08          	add    $0x8,%rdx
  800921:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800925:	8b 00                	mov    (%rax),%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80092a:	eb 23                	jmp    80094f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80092c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800930:	79 0c                	jns    80093e <vprintfmt+0x14e>
				width = 0;
  800932:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800939:	e9 3b ff ff ff       	jmpq   800879 <vprintfmt+0x89>
  80093e:	e9 36 ff ff ff       	jmpq   800879 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800943:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80094a:	e9 2a ff ff ff       	jmpq   800879 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80094f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800953:	79 12                	jns    800967 <vprintfmt+0x177>
				width = precision, precision = -1;
  800955:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800958:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80095b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800962:	e9 12 ff ff ff       	jmpq   800879 <vprintfmt+0x89>
  800967:	e9 0d ff ff ff       	jmpq   800879 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80096c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800970:	e9 04 ff ff ff       	jmpq   800879 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	83 f8 30             	cmp    $0x30,%eax
  80097b:	73 17                	jae    800994 <vprintfmt+0x1a4>
  80097d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800981:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800984:	89 c0                	mov    %eax,%eax
  800986:	48 01 d0             	add    %rdx,%rax
  800989:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098c:	83 c2 08             	add    $0x8,%edx
  80098f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800992:	eb 0f                	jmp    8009a3 <vprintfmt+0x1b3>
  800994:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800998:	48 89 d0             	mov    %rdx,%rax
  80099b:	48 83 c2 08          	add    $0x8,%rdx
  80099f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a3:	8b 10                	mov    (%rax),%edx
  8009a5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ad:	48 89 ce             	mov    %rcx,%rsi
  8009b0:	89 d7                	mov    %edx,%edi
  8009b2:	ff d0                	callq  *%rax
			break;
  8009b4:	e9 40 03 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bc:	83 f8 30             	cmp    $0x30,%eax
  8009bf:	73 17                	jae    8009d8 <vprintfmt+0x1e8>
  8009c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	89 c0                	mov    %eax,%eax
  8009ca:	48 01 d0             	add    %rdx,%rax
  8009cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d0:	83 c2 08             	add    $0x8,%edx
  8009d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d6:	eb 0f                	jmp    8009e7 <vprintfmt+0x1f7>
  8009d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dc:	48 89 d0             	mov    %rdx,%rax
  8009df:	48 83 c2 08          	add    $0x8,%rdx
  8009e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009e9:	85 db                	test   %ebx,%ebx
  8009eb:	79 02                	jns    8009ef <vprintfmt+0x1ff>
				err = -err;
  8009ed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009ef:	83 fb 15             	cmp    $0x15,%ebx
  8009f2:	7f 16                	jg     800a0a <vprintfmt+0x21a>
  8009f4:	48 b8 a0 42 80 00 00 	movabs $0x8042a0,%rax
  8009fb:	00 00 00 
  8009fe:	48 63 d3             	movslq %ebx,%rdx
  800a01:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a05:	4d 85 e4             	test   %r12,%r12
  800a08:	75 2e                	jne    800a38 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a0a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a12:	89 d9                	mov    %ebx,%ecx
  800a14:	48 ba 61 43 80 00 00 	movabs $0x804361,%rdx
  800a1b:	00 00 00 
  800a1e:	48 89 c7             	mov    %rax,%rdi
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
  800a26:	49 b8 08 0d 80 00 00 	movabs $0x800d08,%r8
  800a2d:	00 00 00 
  800a30:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a33:	e9 c1 02 00 00       	jmpq   800cf9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a40:	4c 89 e1             	mov    %r12,%rcx
  800a43:	48 ba 6a 43 80 00 00 	movabs $0x80436a,%rdx
  800a4a:	00 00 00 
  800a4d:	48 89 c7             	mov    %rax,%rdi
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	49 b8 08 0d 80 00 00 	movabs $0x800d08,%r8
  800a5c:	00 00 00 
  800a5f:	41 ff d0             	callq  *%r8
			break;
  800a62:	e9 92 02 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6a:	83 f8 30             	cmp    $0x30,%eax
  800a6d:	73 17                	jae    800a86 <vprintfmt+0x296>
  800a6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a76:	89 c0                	mov    %eax,%eax
  800a78:	48 01 d0             	add    %rdx,%rax
  800a7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7e:	83 c2 08             	add    $0x8,%edx
  800a81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a84:	eb 0f                	jmp    800a95 <vprintfmt+0x2a5>
  800a86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8a:	48 89 d0             	mov    %rdx,%rax
  800a8d:	48 83 c2 08          	add    $0x8,%rdx
  800a91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a95:	4c 8b 20             	mov    (%rax),%r12
  800a98:	4d 85 e4             	test   %r12,%r12
  800a9b:	75 0a                	jne    800aa7 <vprintfmt+0x2b7>
				p = "(null)";
  800a9d:	49 bc 6d 43 80 00 00 	movabs $0x80436d,%r12
  800aa4:	00 00 00 
			if (width > 0 && padc != '-')
  800aa7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aab:	7e 3f                	jle    800aec <vprintfmt+0x2fc>
  800aad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab1:	74 39                	je     800aec <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab6:	48 98                	cltq   
  800ab8:	48 89 c6             	mov    %rax,%rsi
  800abb:	4c 89 e7             	mov    %r12,%rdi
  800abe:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800acd:	eb 17                	jmp    800ae6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800acf:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	48 89 ce             	mov    %rcx,%rsi
  800ade:	89 d7                	mov    %edx,%edi
  800ae0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aea:	7f e3                	jg     800acf <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aec:	eb 37                	jmp    800b25 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800aee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af2:	74 1e                	je     800b12 <vprintfmt+0x322>
  800af4:	83 fb 1f             	cmp    $0x1f,%ebx
  800af7:	7e 05                	jle    800afe <vprintfmt+0x30e>
  800af9:	83 fb 7e             	cmp    $0x7e,%ebx
  800afc:	7e 14                	jle    800b12 <vprintfmt+0x322>
					putch('?', putdat);
  800afe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b06:	48 89 d6             	mov    %rdx,%rsi
  800b09:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b0e:	ff d0                	callq  *%rax
  800b10:	eb 0f                	jmp    800b21 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1a:	48 89 d6             	mov    %rdx,%rsi
  800b1d:	89 df                	mov    %ebx,%edi
  800b1f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b21:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b25:	4c 89 e0             	mov    %r12,%rax
  800b28:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b2c:	0f b6 00             	movzbl (%rax),%eax
  800b2f:	0f be d8             	movsbl %al,%ebx
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	74 10                	je     800b46 <vprintfmt+0x356>
  800b36:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b3a:	78 b2                	js     800aee <vprintfmt+0x2fe>
  800b3c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b44:	79 a8                	jns    800aee <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b46:	eb 16                	jmp    800b5e <vprintfmt+0x36e>
				putch(' ', putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	bf 20 00 00 00       	mov    $0x20,%edi
  800b58:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b62:	7f e4                	jg     800b48 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b64:	e9 90 01 00 00       	jmpq   800cf9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6d:	be 03 00 00 00       	mov    $0x3,%esi
  800b72:	48 89 c7             	mov    %rax,%rdi
  800b75:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800b7c:	00 00 00 
  800b7f:	ff d0                	callq  *%rax
  800b81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b89:	48 85 c0             	test   %rax,%rax
  800b8c:	79 1d                	jns    800bab <vprintfmt+0x3bb>
				putch('-', putdat);
  800b8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b96:	48 89 d6             	mov    %rdx,%rsi
  800b99:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b9e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba4:	48 f7 d8             	neg    %rax
  800ba7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb2:	e9 d5 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bb7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bbb:	be 03 00 00 00       	mov    $0x3,%esi
  800bc0:	48 89 c7             	mov    %rax,%rdi
  800bc3:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800bca:	00 00 00 
  800bcd:	ff d0                	callq  *%rax
  800bcf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bda:	e9 ad 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800bdf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800be2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	48 89 c7             	mov    %rax,%rdi
  800beb:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800bf2:	00 00 00 
  800bf5:	ff d0                	callq  *%rax
  800bf7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800bfb:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c02:	e9 85 00 00 00       	jmpq   800c8c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0f:	48 89 d6             	mov    %rdx,%rsi
  800c12:	bf 30 00 00 00       	mov    $0x30,%edi
  800c17:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c21:	48 89 d6             	mov    %rdx,%rsi
  800c24:	bf 78 00 00 00       	mov    $0x78,%edi
  800c29:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2e:	83 f8 30             	cmp    $0x30,%eax
  800c31:	73 17                	jae    800c4a <vprintfmt+0x45a>
  800c33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3a:	89 c0                	mov    %eax,%eax
  800c3c:	48 01 d0             	add    %rdx,%rax
  800c3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c42:	83 c2 08             	add    $0x8,%edx
  800c45:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	eb 0f                	jmp    800c59 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c4e:	48 89 d0             	mov    %rdx,%rax
  800c51:	48 83 c2 08          	add    $0x8,%rdx
  800c55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c59:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c60:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c67:	eb 23                	jmp    800c8c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6d:	be 03 00 00 00       	mov    $0x3,%esi
  800c72:	48 89 c7             	mov    %rax,%rdi
  800c75:	48 b8 d0 05 80 00 00 	movabs $0x8005d0,%rax
  800c7c:	00 00 00 
  800c7f:	ff d0                	callq  *%rax
  800c81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c91:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c94:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c9b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca3:	45 89 c1             	mov    %r8d,%r9d
  800ca6:	41 89 f8             	mov    %edi,%r8d
  800ca9:	48 89 c7             	mov    %rax,%rdi
  800cac:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
			break;
  800cb8:	eb 3f                	jmp    800cf9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc2:	48 89 d6             	mov    %rdx,%rsi
  800cc5:	89 df                	mov    %ebx,%edi
  800cc7:	ff d0                	callq  *%rax
			break;
  800cc9:	eb 2e                	jmp    800cf9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ccb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd3:	48 89 d6             	mov    %rdx,%rsi
  800cd6:	bf 25 00 00 00       	mov    $0x25,%edi
  800cdb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cdd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce2:	eb 05                	jmp    800ce9 <vprintfmt+0x4f9>
  800ce4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ced:	48 83 e8 01          	sub    $0x1,%rax
  800cf1:	0f b6 00             	movzbl (%rax),%eax
  800cf4:	3c 25                	cmp    $0x25,%al
  800cf6:	75 ec                	jne    800ce4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800cf8:	90                   	nop
		}
	}
  800cf9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cfa:	e9 43 fb ff ff       	jmpq   800842 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800cff:	48 83 c4 60          	add    $0x60,%rsp
  800d03:	5b                   	pop    %rbx
  800d04:	41 5c                	pop    %r12
  800d06:	5d                   	pop    %rbp
  800d07:	c3                   	retq   

0000000000800d08 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d08:	55                   	push   %rbp
  800d09:	48 89 e5             	mov    %rsp,%rbp
  800d0c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d13:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d1a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d36:	84 c0                	test   %al,%al
  800d38:	74 20                	je     800d5a <printfmt+0x52>
  800d3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d5a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d61:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d68:	00 00 00 
  800d6b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d72:	00 00 00 
  800d75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d87:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d8e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d95:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d9c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800da3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800daa:	48 89 c7             	mov    %rax,%rdi
  800dad:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  800db4:	00 00 00 
  800db7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800db9:	c9                   	leaveq 
  800dba:	c3                   	retq   

0000000000800dbb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	48 83 ec 10          	sub    $0x10,%rsp
  800dc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dce:	8b 40 10             	mov    0x10(%rax),%eax
  800dd1:	8d 50 01             	lea    0x1(%rax),%edx
  800dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dd8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddf:	48 8b 10             	mov    (%rax),%rdx
  800de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dea:	48 39 c2             	cmp    %rax,%rdx
  800ded:	73 17                	jae    800e06 <sprintputch+0x4b>
		*b->buf++ = ch;
  800def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df3:	48 8b 00             	mov    (%rax),%rax
  800df6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800dfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800dfe:	48 89 0a             	mov    %rcx,(%rdx)
  800e01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e04:	88 10                	mov    %dl,(%rax)
}
  800e06:	c9                   	leaveq 
  800e07:	c3                   	retq   

0000000000800e08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 50          	sub    $0x50,%rsp
  800e10:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e14:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e17:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e1b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e1f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e23:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e27:	48 8b 0a             	mov    (%rdx),%rcx
  800e2a:	48 89 08             	mov    %rcx,(%rax)
  800e2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e41:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e45:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e48:	48 98                	cltq   
  800e4a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e52:	48 01 d0             	add    %rdx,%rax
  800e55:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e60:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e65:	74 06                	je     800e6d <vsnprintf+0x65>
  800e67:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e6b:	7f 07                	jg     800e74 <vsnprintf+0x6c>
		return -E_INVAL;
  800e6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e72:	eb 2f                	jmp    800ea3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e74:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e78:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e7c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e80:	48 89 c6             	mov    %rax,%rsi
  800e83:	48 bf bb 0d 80 00 00 	movabs $0x800dbb,%rdi
  800e8a:	00 00 00 
  800e8d:	48 b8 f0 07 80 00 00 	movabs $0x8007f0,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e9d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ea0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ea3:	c9                   	leaveq 
  800ea4:	c3                   	retq   

0000000000800ea5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ea5:	55                   	push   %rbp
  800ea6:	48 89 e5             	mov    %rsp,%rbp
  800ea9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eb0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800eb7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ebd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ecb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed2:	84 c0                	test   %al,%al
  800ed4:	74 20                	je     800ef6 <snprintf+0x51>
  800ed6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ede:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ee6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ef6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800efd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f04:	00 00 00 
  800f07:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f0e:	00 00 00 
  800f11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f15:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f23:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f2a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f31:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f38:	48 8b 0a             	mov    (%rdx),%rcx
  800f3b:	48 89 08             	mov    %rcx,(%rax)
  800f3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f4e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f55:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f5c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f62:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f69:	48 89 c7             	mov    %rax,%rdi
  800f6c:	48 b8 08 0e 80 00 00 	movabs $0x800e08,%rax
  800f73:	00 00 00 
  800f76:	ff d0                	callq  *%rax
  800f78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f7e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f84:	c9                   	leaveq 
  800f85:	c3                   	retq   

0000000000800f86 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f86:	55                   	push   %rbp
  800f87:	48 89 e5             	mov    %rsp,%rbp
  800f8a:	48 83 ec 18          	sub    $0x18,%rsp
  800f8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f99:	eb 09                	jmp    800fa4 <strlen+0x1e>
		n++;
  800f9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa8:	0f b6 00             	movzbl (%rax),%eax
  800fab:	84 c0                	test   %al,%al
  800fad:	75 ec                	jne    800f9b <strlen+0x15>
		n++;
	return n;
  800faf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fb2:	c9                   	leaveq 
  800fb3:	c3                   	retq   

0000000000800fb4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fb4:	55                   	push   %rbp
  800fb5:	48 89 e5             	mov    %rsp,%rbp
  800fb8:	48 83 ec 20          	sub    $0x20,%rsp
  800fbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fcb:	eb 0e                	jmp    800fdb <strnlen+0x27>
		n++;
  800fcd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fdb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fe0:	74 0b                	je     800fed <strnlen+0x39>
  800fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe6:	0f b6 00             	movzbl (%rax),%eax
  800fe9:	84 c0                	test   %al,%al
  800feb:	75 e0                	jne    800fcd <strnlen+0x19>
		n++;
	return n;
  800fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ff0:	c9                   	leaveq 
  800ff1:	c3                   	retq   

0000000000800ff2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff2:	55                   	push   %rbp
  800ff3:	48 89 e5             	mov    %rsp,%rbp
  800ff6:	48 83 ec 20          	sub    $0x20,%rsp
  800ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801006:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80100a:	90                   	nop
  80100b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801013:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801017:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80101b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80101f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801023:	0f b6 12             	movzbl (%rdx),%edx
  801026:	88 10                	mov    %dl,(%rax)
  801028:	0f b6 00             	movzbl (%rax),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	75 dc                	jne    80100b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 20          	sub    $0x20,%rsp
  80103d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801041:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801049:	48 89 c7             	mov    %rax,%rdi
  80104c:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  801053:	00 00 00 
  801056:	ff d0                	callq  *%rax
  801058:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80105b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80105e:	48 63 d0             	movslq %eax,%rdx
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 01 c2             	add    %rax,%rdx
  801068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80106c:	48 89 c6             	mov    %rax,%rsi
  80106f:	48 89 d7             	mov    %rdx,%rdi
  801072:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  801079:	00 00 00 
  80107c:	ff d0                	callq  *%rax
	return dst;
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 28          	sub    $0x28,%rsp
  80108c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801090:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801094:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010a0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010a7:	00 
  8010a8:	eb 2a                	jmp    8010d4 <strncpy+0x50>
		*dst++ = *src;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ba:	0f b6 12             	movzbl (%rdx),%edx
  8010bd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 05                	je     8010cf <strncpy+0x4b>
			src++;
  8010ca:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010dc:	72 cc                	jb     8010aa <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010e2:	c9                   	leaveq 
  8010e3:	c3                   	retq   

00000000008010e4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010e4:	55                   	push   %rbp
  8010e5:	48 89 e5             	mov    %rsp,%rbp
  8010e8:	48 83 ec 28          	sub    $0x28,%rsp
  8010ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801100:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801105:	74 3d                	je     801144 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801107:	eb 1d                	jmp    801126 <strlcpy+0x42>
			*dst++ = *src++;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801115:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801119:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80111d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801121:	0f b6 12             	movzbl (%rdx),%edx
  801124:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801126:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80112b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801130:	74 0b                	je     80113d <strlcpy+0x59>
  801132:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	84 c0                	test   %al,%al
  80113b:	75 cc                	jne    801109 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801144:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114c:	48 29 c2             	sub    %rax,%rdx
  80114f:	48 89 d0             	mov    %rdx,%rax
}
  801152:	c9                   	leaveq 
  801153:	c3                   	retq   

0000000000801154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	48 83 ec 10          	sub    $0x10,%rsp
  80115c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801160:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801164:	eb 0a                	jmp    801170 <strcmp+0x1c>
		p++, q++;
  801166:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80116b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	84 c0                	test   %al,%al
  801179:	74 12                	je     80118d <strcmp+0x39>
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	0f b6 10             	movzbl (%rax),%edx
  801182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801186:	0f b6 00             	movzbl (%rax),%eax
  801189:	38 c2                	cmp    %al,%dl
  80118b:	74 d9                	je     801166 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	0f b6 d0             	movzbl %al,%edx
  801197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119b:	0f b6 00             	movzbl (%rax),%eax
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	29 c2                	sub    %eax,%edx
  8011a3:	89 d0                	mov    %edx,%eax
}
  8011a5:	c9                   	leaveq 
  8011a6:	c3                   	retq   

00000000008011a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011a7:	55                   	push   %rbp
  8011a8:	48 89 e5             	mov    %rsp,%rbp
  8011ab:	48 83 ec 18          	sub    $0x18,%rsp
  8011af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011bb:	eb 0f                	jmp    8011cc <strncmp+0x25>
		n--, p++, q++;
  8011bd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011d1:	74 1d                	je     8011f0 <strncmp+0x49>
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	84 c0                	test   %al,%al
  8011dc:	74 12                	je     8011f0 <strncmp+0x49>
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	0f b6 10             	movzbl (%rax),%edx
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	0f b6 00             	movzbl (%rax),%eax
  8011ec:	38 c2                	cmp    %al,%dl
  8011ee:	74 cd                	je     8011bd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f5:	75 07                	jne    8011fe <strncmp+0x57>
		return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fc:	eb 18                	jmp    801216 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801202:	0f b6 00             	movzbl (%rax),%eax
  801205:	0f b6 d0             	movzbl %al,%edx
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	0f b6 c0             	movzbl %al,%eax
  801212:	29 c2                	sub    %eax,%edx
  801214:	89 d0                	mov    %edx,%eax
}
  801216:	c9                   	leaveq 
  801217:	c3                   	retq   

0000000000801218 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	48 83 ec 0c          	sub    $0xc,%rsp
  801220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801224:	89 f0                	mov    %esi,%eax
  801226:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801229:	eb 17                	jmp    801242 <strchr+0x2a>
		if (*s == c)
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801235:	75 06                	jne    80123d <strchr+0x25>
			return (char *) s;
  801237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123b:	eb 15                	jmp    801252 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801246:	0f b6 00             	movzbl (%rax),%eax
  801249:	84 c0                	test   %al,%al
  80124b:	75 de                	jne    80122b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801252:	c9                   	leaveq 
  801253:	c3                   	retq   

0000000000801254 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801254:	55                   	push   %rbp
  801255:	48 89 e5             	mov    %rsp,%rbp
  801258:	48 83 ec 0c          	sub    $0xc,%rsp
  80125c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801260:	89 f0                	mov    %esi,%eax
  801262:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801265:	eb 13                	jmp    80127a <strfind+0x26>
		if (*s == c)
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801271:	75 02                	jne    801275 <strfind+0x21>
			break;
  801273:	eb 10                	jmp    801285 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801275:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	75 e2                	jne    801267 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 18          	sub    $0x18,%rsp
  801293:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801297:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80129a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80129e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a3:	75 06                	jne    8012ab <memset+0x20>
		return v;
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	eb 69                	jmp    801314 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	83 e0 03             	and    $0x3,%eax
  8012b2:	48 85 c0             	test   %rax,%rax
  8012b5:	75 48                	jne    8012ff <memset+0x74>
  8012b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bb:	83 e0 03             	and    $0x3,%eax
  8012be:	48 85 c0             	test   %rax,%rax
  8012c1:	75 3c                	jne    8012ff <memset+0x74>
		c &= 0xFF;
  8012c3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012cd:	c1 e0 18             	shl    $0x18,%eax
  8012d0:	89 c2                	mov    %eax,%edx
  8012d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d5:	c1 e0 10             	shl    $0x10,%eax
  8012d8:	09 c2                	or     %eax,%edx
  8012da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012dd:	c1 e0 08             	shl    $0x8,%eax
  8012e0:	09 d0                	or     %edx,%eax
  8012e2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e9:	48 c1 e8 02          	shr    $0x2,%rax
  8012ed:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f7:	48 89 d7             	mov    %rdx,%rdi
  8012fa:	fc                   	cld    
  8012fb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012fd:	eb 11                	jmp    801310 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801306:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80130a:	48 89 d7             	mov    %rdx,%rdi
  80130d:	fc                   	cld    
  80130e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801314:	c9                   	leaveq 
  801315:	c3                   	retq   

0000000000801316 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801316:	55                   	push   %rbp
  801317:	48 89 e5             	mov    %rsp,%rbp
  80131a:	48 83 ec 28          	sub    $0x28,%rsp
  80131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801326:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80132a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801342:	0f 83 88 00 00 00    	jae    8013d0 <memmove+0xba>
  801348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80134c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801350:	48 01 d0             	add    %rdx,%rax
  801353:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801357:	76 77                	jbe    8013d0 <memmove+0xba>
		s += n;
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801361:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801365:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	48 85 c0             	test   %rax,%rax
  801373:	75 3b                	jne    8013b0 <memmove+0x9a>
  801375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801379:	83 e0 03             	and    $0x3,%eax
  80137c:	48 85 c0             	test   %rax,%rax
  80137f:	75 2f                	jne    8013b0 <memmove+0x9a>
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	83 e0 03             	and    $0x3,%eax
  801388:	48 85 c0             	test   %rax,%rax
  80138b:	75 23                	jne    8013b0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80138d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801391:	48 83 e8 04          	sub    $0x4,%rax
  801395:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801399:	48 83 ea 04          	sub    $0x4,%rdx
  80139d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013a1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013a5:	48 89 c7             	mov    %rax,%rdi
  8013a8:	48 89 d6             	mov    %rdx,%rsi
  8013ab:	fd                   	std    
  8013ac:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013ae:	eb 1d                	jmp    8013cd <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 89 d7             	mov    %rdx,%rdi
  8013c7:	48 89 c1             	mov    %rax,%rcx
  8013ca:	fd                   	std    
  8013cb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013cd:	fc                   	cld    
  8013ce:	eb 57                	jmp    801427 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	83 e0 03             	and    $0x3,%eax
  8013d7:	48 85 c0             	test   %rax,%rax
  8013da:	75 36                	jne    801412 <memmove+0xfc>
  8013dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e0:	83 e0 03             	and    $0x3,%eax
  8013e3:	48 85 c0             	test   %rax,%rax
  8013e6:	75 2a                	jne    801412 <memmove+0xfc>
  8013e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ec:	83 e0 03             	and    $0x3,%eax
  8013ef:	48 85 c0             	test   %rax,%rax
  8013f2:	75 1e                	jne    801412 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	48 c1 e8 02          	shr    $0x2,%rax
  8013fc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801403:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801407:	48 89 c7             	mov    %rax,%rdi
  80140a:	48 89 d6             	mov    %rdx,%rsi
  80140d:	fc                   	cld    
  80140e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801410:	eb 15                	jmp    801427 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801416:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80141e:	48 89 c7             	mov    %rax,%rdi
  801421:	48 89 d6             	mov    %rdx,%rsi
  801424:	fc                   	cld    
  801425:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80142b:	c9                   	leaveq 
  80142c:	c3                   	retq   

000000000080142d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80142d:	55                   	push   %rbp
  80142e:	48 89 e5             	mov    %rsp,%rbp
  801431:	48 83 ec 18          	sub    $0x18,%rsp
  801435:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801439:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80143d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801445:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	48 89 ce             	mov    %rcx,%rsi
  801450:	48 89 c7             	mov    %rax,%rdi
  801453:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80145a:	00 00 00 
  80145d:	ff d0                	callq  *%rax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80147d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801485:	eb 36                	jmp    8014bd <memcmp+0x5c>
		if (*s1 != *s2)
  801487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148b:	0f b6 10             	movzbl (%rax),%edx
  80148e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	38 c2                	cmp    %al,%dl
  801497:	74 1a                	je     8014b3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	0f b6 d0             	movzbl %al,%edx
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	0f b6 c0             	movzbl %al,%eax
  8014ad:	29 c2                	sub    %eax,%edx
  8014af:	89 d0                	mov    %edx,%eax
  8014b1:	eb 20                	jmp    8014d3 <memcmp+0x72>
		s1++, s2++;
  8014b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014c9:	48 85 c0             	test   %rax,%rax
  8014cc:	75 b9                	jne    801487 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 28          	sub    $0x28,%rsp
  8014dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f0:	48 01 d0             	add    %rdx,%rax
  8014f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014f7:	eb 15                	jmp    80150e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fd:	0f b6 10             	movzbl (%rax),%edx
  801500:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801503:	38 c2                	cmp    %al,%dl
  801505:	75 02                	jne    801509 <memfind+0x34>
			break;
  801507:	eb 0f                	jmp    801518 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801509:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801512:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801516:	72 e1                	jb     8014f9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 34          	sub    $0x34,%rsp
  801526:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80152e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801531:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801538:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80153f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801540:	eb 05                	jmp    801547 <strtol+0x29>
		s++;
  801542:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	3c 20                	cmp    $0x20,%al
  801550:	74 f0                	je     801542 <strtol+0x24>
  801552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3c 09                	cmp    $0x9,%al
  80155b:	74 e5                	je     801542 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80155d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801561:	0f b6 00             	movzbl (%rax),%eax
  801564:	3c 2b                	cmp    $0x2b,%al
  801566:	75 07                	jne    80156f <strtol+0x51>
		s++;
  801568:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80156d:	eb 17                	jmp    801586 <strtol+0x68>
	else if (*s == '-')
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	3c 2d                	cmp    $0x2d,%al
  801578:	75 0c                	jne    801586 <strtol+0x68>
		s++, neg = 1;
  80157a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801586:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80158a:	74 06                	je     801592 <strtol+0x74>
  80158c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801590:	75 28                	jne    8015ba <strtol+0x9c>
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	3c 30                	cmp    $0x30,%al
  80159b:	75 1d                	jne    8015ba <strtol+0x9c>
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	48 83 c0 01          	add    $0x1,%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	3c 78                	cmp    $0x78,%al
  8015aa:	75 0e                	jne    8015ba <strtol+0x9c>
		s += 2, base = 16;
  8015ac:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015b1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015b8:	eb 2c                	jmp    8015e6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015be:	75 19                	jne    8015d9 <strtol+0xbb>
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	0f b6 00             	movzbl (%rax),%eax
  8015c7:	3c 30                	cmp    $0x30,%al
  8015c9:	75 0e                	jne    8015d9 <strtol+0xbb>
		s++, base = 8;
  8015cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015d7:	eb 0d                	jmp    8015e6 <strtol+0xc8>
	else if (base == 0)
  8015d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015dd:	75 07                	jne    8015e6 <strtol+0xc8>
		base = 10;
  8015df:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	3c 2f                	cmp    $0x2f,%al
  8015ef:	7e 1d                	jle    80160e <strtol+0xf0>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 39                	cmp    $0x39,%al
  8015fa:	7f 12                	jg     80160e <strtol+0xf0>
			dig = *s - '0';
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	0f be c0             	movsbl %al,%eax
  801606:	83 e8 30             	sub    $0x30,%eax
  801609:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80160c:	eb 4e                	jmp    80165c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80160e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801612:	0f b6 00             	movzbl (%rax),%eax
  801615:	3c 60                	cmp    $0x60,%al
  801617:	7e 1d                	jle    801636 <strtol+0x118>
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 7a                	cmp    $0x7a,%al
  801622:	7f 12                	jg     801636 <strtol+0x118>
			dig = *s - 'a' + 10;
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	0f be c0             	movsbl %al,%eax
  80162e:	83 e8 57             	sub    $0x57,%eax
  801631:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801634:	eb 26                	jmp    80165c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	3c 40                	cmp    $0x40,%al
  80163f:	7e 48                	jle    801689 <strtol+0x16b>
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	3c 5a                	cmp    $0x5a,%al
  80164a:	7f 3d                	jg     801689 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	0f b6 00             	movzbl (%rax),%eax
  801653:	0f be c0             	movsbl %al,%eax
  801656:	83 e8 37             	sub    $0x37,%eax
  801659:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80165c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80165f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801662:	7c 02                	jl     801666 <strtol+0x148>
			break;
  801664:	eb 23                	jmp    801689 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801666:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80166e:	48 98                	cltq   
  801670:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801675:	48 89 c2             	mov    %rax,%rdx
  801678:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80167b:	48 98                	cltq   
  80167d:	48 01 d0             	add    %rdx,%rax
  801680:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801684:	e9 5d ff ff ff       	jmpq   8015e6 <strtol+0xc8>

	if (endptr)
  801689:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80168e:	74 0b                	je     80169b <strtol+0x17d>
		*endptr = (char *) s;
  801690:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801694:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801698:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80169b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80169f:	74 09                	je     8016aa <strtol+0x18c>
  8016a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a5:	48 f7 d8             	neg    %rax
  8016a8:	eb 04                	jmp    8016ae <strtol+0x190>
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 30          	sub    $0x30,%rsp
  8016b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016c8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016d2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016d6:	75 06                	jne    8016de <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	eb 6b                	jmp    801749 <strstr+0x99>

	len = strlen(str);
  8016de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e2:	48 89 c7             	mov    %rax,%rdi
  8016e5:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8016ec:	00 00 00 
  8016ef:	ff d0                	callq  *%rax
  8016f1:	48 98                	cltq   
  8016f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801703:	0f b6 00             	movzbl (%rax),%eax
  801706:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801709:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80170d:	75 07                	jne    801716 <strstr+0x66>
				return (char *) 0;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	eb 33                	jmp    801749 <strstr+0x99>
		} while (sc != c);
  801716:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80171a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80171d:	75 d8                	jne    8016f7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80171f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801723:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	48 89 ce             	mov    %rcx,%rsi
  80172e:	48 89 c7             	mov    %rax,%rdi
  801731:	48 b8 a7 11 80 00 00 	movabs $0x8011a7,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
  80173d:	85 c0                	test   %eax,%eax
  80173f:	75 b6                	jne    8016f7 <strstr+0x47>

	return (char *) (in - 1);
  801741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801745:	48 83 e8 01          	sub    $0x1,%rax
}
  801749:	c9                   	leaveq 
  80174a:	c3                   	retq   

000000000080174b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80174b:	55                   	push   %rbp
  80174c:	48 89 e5             	mov    %rsp,%rbp
  80174f:	53                   	push   %rbx
  801750:	48 83 ec 48          	sub    $0x48,%rsp
  801754:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801757:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80175a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80175e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801762:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801766:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80176d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801771:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801775:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801779:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80177d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801781:	4c 89 c3             	mov    %r8,%rbx
  801784:	cd 30                	int    $0x30
  801786:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80178a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80178e:	74 3e                	je     8017ce <syscall+0x83>
  801790:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801795:	7e 37                	jle    8017ce <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179e:	49 89 d0             	mov    %rdx,%r8
  8017a1:	89 c1                	mov    %eax,%ecx
  8017a3:	48 ba 28 46 80 00 00 	movabs $0x804628,%rdx
  8017aa:	00 00 00 
  8017ad:	be 23 00 00 00       	mov    $0x23,%esi
  8017b2:	48 bf 45 46 80 00 00 	movabs $0x804645,%rdi
  8017b9:	00 00 00 
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	49 b9 04 02 80 00 00 	movabs $0x800204,%r9
  8017c8:	00 00 00 
  8017cb:	41 ff d1             	callq  *%r9

	return ret;
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017d2:	48 83 c4 48          	add    $0x48,%rsp
  8017d6:	5b                   	pop    %rbx
  8017d7:	5d                   	pop    %rbp
  8017d8:	c3                   	retq   

00000000008017d9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 20          	sub    $0x20,%rsp
  8017e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f8:	00 
  8017f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801805:	48 89 d1             	mov    %rdx,%rcx
  801808:	48 89 c2             	mov    %rax,%rdx
  80180b:	be 00 00 00 00       	mov    $0x0,%esi
  801810:	bf 00 00 00 00       	mov    $0x0,%edi
  801815:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80181c:	00 00 00 
  80181f:	ff d0                	callq  *%rax
}
  801821:	c9                   	leaveq 
  801822:	c3                   	retq   

0000000000801823 <sys_cgetc>:

int
sys_cgetc(void)
{
  801823:	55                   	push   %rbp
  801824:	48 89 e5             	mov    %rsp,%rbp
  801827:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80182b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801832:	00 
  801833:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801839:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80183f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801844:	ba 00 00 00 00       	mov    $0x0,%edx
  801849:	be 00 00 00 00       	mov    $0x0,%esi
  80184e:	bf 01 00 00 00       	mov    $0x1,%edi
  801853:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80185a:	00 00 00 
  80185d:	ff d0                	callq  *%rax
}
  80185f:	c9                   	leaveq 
  801860:	c3                   	retq   

0000000000801861 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801861:	55                   	push   %rbp
  801862:	48 89 e5             	mov    %rsp,%rbp
  801865:	48 83 ec 10          	sub    $0x10,%rsp
  801869:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801878:	00 
  801879:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801885:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188a:	48 89 c2             	mov    %rax,%rdx
  80188d:	be 01 00 00 00       	mov    $0x1,%esi
  801892:	bf 03 00 00 00       	mov    $0x3,%edi
  801897:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b4:	00 
  8018b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	be 00 00 00 00       	mov    $0x0,%esi
  8018d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8018d5:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	callq  *%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <sys_yield>:

void
sys_yield(void)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f2:	00 
  8018f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801904:	ba 00 00 00 00       	mov    $0x0,%edx
  801909:	be 00 00 00 00       	mov    $0x0,%esi
  80190e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801913:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
}
  80191f:	c9                   	leaveq 
  801920:	c3                   	retq   

0000000000801921 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801921:	55                   	push   %rbp
  801922:	48 89 e5             	mov    %rsp,%rbp
  801925:	48 83 ec 20          	sub    $0x20,%rsp
  801929:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801930:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801936:	48 63 c8             	movslq %eax,%rcx
  801939:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801940:	48 98                	cltq   
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	49 89 c8             	mov    %rcx,%r8
  801953:	48 89 d1             	mov    %rdx,%rcx
  801956:	48 89 c2             	mov    %rax,%rdx
  801959:	be 01 00 00 00       	mov    $0x1,%esi
  80195e:	bf 04 00 00 00       	mov    $0x4,%edi
  801963:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  80196a:	00 00 00 
  80196d:	ff d0                	callq  *%rax
}
  80196f:	c9                   	leaveq 
  801970:	c3                   	retq   

0000000000801971 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801971:	55                   	push   %rbp
  801972:	48 89 e5             	mov    %rsp,%rbp
  801975:	48 83 ec 30          	sub    $0x30,%rsp
  801979:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801980:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801983:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801987:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80198b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80198e:	48 63 c8             	movslq %eax,%rcx
  801991:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801995:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801998:	48 63 f0             	movslq %eax,%rsi
  80199b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a2:	48 98                	cltq   
  8019a4:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019a8:	49 89 f9             	mov    %rdi,%r9
  8019ab:	49 89 f0             	mov    %rsi,%r8
  8019ae:	48 89 d1             	mov    %rdx,%rcx
  8019b1:	48 89 c2             	mov    %rax,%rdx
  8019b4:	be 01 00 00 00       	mov    $0x1,%esi
  8019b9:	bf 05 00 00 00       	mov    $0x5,%edi
  8019be:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 20          	sub    $0x20,%rsp
  8019d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e2:	48 98                	cltq   
  8019e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019eb:	00 
  8019ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f8:	48 89 d1             	mov    %rdx,%rcx
  8019fb:	48 89 c2             	mov    %rax,%rdx
  8019fe:	be 01 00 00 00       	mov    $0x1,%esi
  801a03:	bf 06 00 00 00       	mov    $0x6,%edi
  801a08:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 10          	sub    $0x10,%rsp
  801a1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a21:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a27:	48 63 d0             	movslq %eax,%rdx
  801a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2d:	48 98                	cltq   
  801a2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a36:	00 
  801a37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a43:	48 89 d1             	mov    %rdx,%rcx
  801a46:	48 89 c2             	mov    %rax,%rdx
  801a49:	be 01 00 00 00       	mov    $0x1,%esi
  801a4e:	bf 08 00 00 00       	mov    $0x8,%edi
  801a53:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801a5a:	00 00 00 
  801a5d:	ff d0                	callq  *%rax
}
  801a5f:	c9                   	leaveq 
  801a60:	c3                   	retq   

0000000000801a61 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a61:	55                   	push   %rbp
  801a62:	48 89 e5             	mov    %rsp,%rbp
  801a65:	48 83 ec 20          	sub    $0x20,%rsp
  801a69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a80:	00 
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	48 89 d1             	mov    %rdx,%rcx
  801a90:	48 89 c2             	mov    %rax,%rdx
  801a93:	be 01 00 00 00       	mov    $0x1,%esi
  801a98:	bf 09 00 00 00       	mov    $0x9,%edi
  801a9d:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801aa4:	00 00 00 
  801aa7:	ff d0                	callq  *%rax
}
  801aa9:	c9                   	leaveq 
  801aaa:	c3                   	retq   

0000000000801aab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801aab:	55                   	push   %rbp
  801aac:	48 89 e5             	mov    %rsp,%rbp
  801aaf:	48 83 ec 20          	sub    $0x20,%rsp
  801ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ae7:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b08:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0e:	48 63 f0             	movslq %eax,%rsi
  801b11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b25:	00 
  801b26:	49 89 f1             	mov    %rsi,%r9
  801b29:	49 89 c8             	mov    %rcx,%r8
  801b2c:	48 89 d1             	mov    %rdx,%rcx
  801b2f:	48 89 c2             	mov    %rax,%rdx
  801b32:	be 00 00 00 00       	mov    $0x0,%esi
  801b37:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b3c:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 10          	sub    $0x10,%rsp
  801b52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b80:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 20          	sub    $0x20,%rsp
  801b96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bad:	00 
  801bae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bba:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbf:	89 c6                	mov    %eax,%esi
  801bc1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bc6:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	callq  *%rax
}
  801bd2:	c9                   	leaveq 
  801bd3:	c3                   	retq   

0000000000801bd4 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801bd4:	55                   	push   %rbp
  801bd5:	48 89 e5             	mov    %rsp,%rbp
  801bd8:	48 83 ec 20          	sub    $0x20,%rsp
  801bdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf3:	00 
  801bf4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c00:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c05:	89 c6                	mov    %eax,%esi
  801c07:	bf 10 00 00 00       	mov    $0x10,%edi
  801c0c:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801c13:	00 00 00 
  801c16:	ff d0                	callq  *%rax
}
  801c18:	c9                   	leaveq 
  801c19:	c3                   	retq   

0000000000801c1a <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c1a:	55                   	push   %rbp
  801c1b:	48 89 e5             	mov    %rsp,%rbp
  801c1e:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c29:	00 
  801c2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c40:	be 00 00 00 00       	mov    $0x0,%esi
  801c45:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c4a:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	callq  *%rax
}
  801c56:	c9                   	leaveq 
  801c57:	c3                   	retq   

0000000000801c58 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801c58:	55                   	push   %rbp
  801c59:	48 89 e5             	mov    %rsp,%rbp
  801c5c:	48 83 ec 10          	sub    $0x10,%rsp
  801c60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801c64:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801c6b:	00 00 00 
  801c6e:	48 8b 00             	mov    (%rax),%rax
  801c71:	48 85 c0             	test   %rax,%rax
  801c74:	0f 85 84 00 00 00    	jne    801cfe <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801c7a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801c81:	00 00 00 
  801c84:	48 8b 00             	mov    (%rax),%rax
  801c87:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c8d:	ba 07 00 00 00       	mov    $0x7,%edx
  801c92:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801c97:	89 c7                	mov    %eax,%edi
  801c99:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	79 2a                	jns    801cd3 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801ca9:	48 ba 58 46 80 00 00 	movabs $0x804658,%rdx
  801cb0:	00 00 00 
  801cb3:	be 23 00 00 00       	mov    $0x23,%esi
  801cb8:	48 bf 7f 46 80 00 00 	movabs $0x80467f,%rdi
  801cbf:	00 00 00 
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	48 b9 04 02 80 00 00 	movabs $0x800204,%rcx
  801cce:	00 00 00 
  801cd1:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801cd3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801cda:	00 00 00 
  801cdd:	48 8b 00             	mov    (%rax),%rax
  801ce0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ce6:	48 be 11 1d 80 00 00 	movabs $0x801d11,%rsi
  801ced:	00 00 00 
  801cf0:	89 c7                	mov    %eax,%edi
  801cf2:	48 b8 ab 1a 80 00 00 	movabs $0x801aab,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801cfe:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801d05:	00 00 00 
  801d08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d0c:	48 89 10             	mov    %rdx,(%rax)
}
  801d0f:	c9                   	leaveq 
  801d10:	c3                   	retq   

0000000000801d11 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  801d11:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801d14:	48 a1 10 70 80 00 00 	movabs 0x807010,%rax
  801d1b:	00 00 00 
call *%rax
  801d1e:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  801d20:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801d27:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801d28:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801d2f:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801d30:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801d34:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801d37:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801d3e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801d3f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801d43:	4c 8b 3c 24          	mov    (%rsp),%r15
  801d47:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801d4c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801d51:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801d56:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801d5b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801d60:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801d65:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801d6a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801d6f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801d74:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801d79:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801d7e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801d83:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801d88:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801d8d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801d91:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801d95:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801d96:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801d97:	c3                   	retq   

0000000000801d98 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d98:	55                   	push   %rbp
  801d99:	48 89 e5             	mov    %rsp,%rbp
  801d9c:	48 83 ec 08          	sub    $0x8,%rsp
  801da0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801da8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801daf:	ff ff ff 
  801db2:	48 01 d0             	add    %rdx,%rax
  801db5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801db9:	c9                   	leaveq 
  801dba:	c3                   	retq   

0000000000801dbb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dbb:	55                   	push   %rbp
  801dbc:	48 89 e5             	mov    %rsp,%rbp
  801dbf:	48 83 ec 08          	sub    $0x8,%rsp
  801dc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dcb:	48 89 c7             	mov    %rax,%rdi
  801dce:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	callq  *%rax
  801dda:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801de0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801de4:	c9                   	leaveq 
  801de5:	c3                   	retq   

0000000000801de6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801de6:	55                   	push   %rbp
  801de7:	48 89 e5             	mov    %rsp,%rbp
  801dea:	48 83 ec 18          	sub    $0x18,%rsp
  801dee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801df2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801df9:	eb 6b                	jmp    801e66 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfe:	48 98                	cltq   
  801e00:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e06:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e12:	48 c1 e8 15          	shr    $0x15,%rax
  801e16:	48 89 c2             	mov    %rax,%rdx
  801e19:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e20:	01 00 00 
  801e23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e27:	83 e0 01             	and    $0x1,%eax
  801e2a:	48 85 c0             	test   %rax,%rax
  801e2d:	74 21                	je     801e50 <fd_alloc+0x6a>
  801e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e33:	48 c1 e8 0c          	shr    $0xc,%rax
  801e37:	48 89 c2             	mov    %rax,%rdx
  801e3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e41:	01 00 00 
  801e44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e48:	83 e0 01             	and    $0x1,%eax
  801e4b:	48 85 c0             	test   %rax,%rax
  801e4e:	75 12                	jne    801e62 <fd_alloc+0x7c>
			*fd_store = fd;
  801e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e58:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	eb 1a                	jmp    801e7c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e62:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e66:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e6a:	7e 8f                	jle    801dfb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e70:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e77:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e7c:	c9                   	leaveq 
  801e7d:	c3                   	retq   

0000000000801e7e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e7e:	55                   	push   %rbp
  801e7f:	48 89 e5             	mov    %rsp,%rbp
  801e82:	48 83 ec 20          	sub    $0x20,%rsp
  801e86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e91:	78 06                	js     801e99 <fd_lookup+0x1b>
  801e93:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e97:	7e 07                	jle    801ea0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e9e:	eb 6c                	jmp    801f0c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ea0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ea3:	48 98                	cltq   
  801ea5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eab:	48 c1 e0 0c          	shl    $0xc,%rax
  801eaf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801eb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb7:	48 c1 e8 15          	shr    $0x15,%rax
  801ebb:	48 89 c2             	mov    %rax,%rdx
  801ebe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ec5:	01 00 00 
  801ec8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecc:	83 e0 01             	and    $0x1,%eax
  801ecf:	48 85 c0             	test   %rax,%rax
  801ed2:	74 21                	je     801ef5 <fd_lookup+0x77>
  801ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed8:	48 c1 e8 0c          	shr    $0xc,%rax
  801edc:	48 89 c2             	mov    %rax,%rdx
  801edf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ee6:	01 00 00 
  801ee9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eed:	83 e0 01             	and    $0x1,%eax
  801ef0:	48 85 c0             	test   %rax,%rax
  801ef3:	75 07                	jne    801efc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801efa:	eb 10                	jmp    801f0c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f00:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f04:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0c:	c9                   	leaveq 
  801f0d:	c3                   	retq   

0000000000801f0e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f0e:	55                   	push   %rbp
  801f0f:	48 89 e5             	mov    %rsp,%rbp
  801f12:	48 83 ec 30          	sub    $0x30,%rsp
  801f16:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f1a:	89 f0                	mov    %esi,%eax
  801f1c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f23:	48 89 c7             	mov    %rax,%rdi
  801f26:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801f2d:	00 00 00 
  801f30:	ff d0                	callq  *%rax
  801f32:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f36:	48 89 d6             	mov    %rdx,%rsi
  801f39:	89 c7                	mov    %eax,%edi
  801f3b:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  801f42:	00 00 00 
  801f45:	ff d0                	callq  *%rax
  801f47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4e:	78 0a                	js     801f5a <fd_close+0x4c>
	    || fd != fd2)
  801f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f54:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f58:	74 12                	je     801f6c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f5a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f5e:	74 05                	je     801f65 <fd_close+0x57>
  801f60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f63:	eb 05                	jmp    801f6a <fd_close+0x5c>
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	eb 69                	jmp    801fd5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f70:	8b 00                	mov    (%rax),%eax
  801f72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f76:	48 89 d6             	mov    %rdx,%rsi
  801f79:	89 c7                	mov    %eax,%edi
  801f7b:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
  801f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f8e:	78 2a                	js     801fba <fd_close+0xac>
		if (dev->dev_close)
  801f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f94:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	74 16                	je     801fb3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa1:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fa5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fa9:	48 89 d7             	mov    %rdx,%rdi
  801fac:	ff d0                	callq  *%rax
  801fae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb1:	eb 07                	jmp    801fba <fd_close+0xac>
		else
			r = 0;
  801fb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbe:	48 89 c6             	mov    %rax,%rsi
  801fc1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc6:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
	return r;
  801fd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fd5:	c9                   	leaveq 
  801fd6:	c3                   	retq   

0000000000801fd7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fd7:	55                   	push   %rbp
  801fd8:	48 89 e5             	mov    %rsp,%rbp
  801fdb:	48 83 ec 20          	sub    $0x20,%rsp
  801fdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fe2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fe6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fed:	eb 41                	jmp    802030 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fef:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ff6:	00 00 00 
  801ff9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ffc:	48 63 d2             	movslq %edx,%rdx
  801fff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802003:	8b 00                	mov    (%rax),%eax
  802005:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802008:	75 22                	jne    80202c <dev_lookup+0x55>
			*dev = devtab[i];
  80200a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802011:	00 00 00 
  802014:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802017:	48 63 d2             	movslq %edx,%rdx
  80201a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80201e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802022:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	eb 60                	jmp    80208c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80202c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802030:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802037:	00 00 00 
  80203a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203d:	48 63 d2             	movslq %edx,%rdx
  802040:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802044:	48 85 c0             	test   %rax,%rax
  802047:	75 a6                	jne    801fef <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802049:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802050:	00 00 00 
  802053:	48 8b 00             	mov    (%rax),%rax
  802056:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80205c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80205f:	89 c6                	mov    %eax,%esi
  802061:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  802068:	00 00 00 
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  802077:	00 00 00 
  80207a:	ff d1                	callq  *%rcx
	*dev = 0;
  80207c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802080:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802087:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80208c:	c9                   	leaveq 
  80208d:	c3                   	retq   

000000000080208e <close>:

int
close(int fdnum)
{
  80208e:	55                   	push   %rbp
  80208f:	48 89 e5             	mov    %rsp,%rbp
  802092:	48 83 ec 20          	sub    $0x20,%rsp
  802096:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802099:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80209d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020a0:	48 89 d6             	mov    %rdx,%rsi
  8020a3:	89 c7                	mov    %eax,%edi
  8020a5:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b8:	79 05                	jns    8020bf <close+0x31>
		return r;
  8020ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bd:	eb 18                	jmp    8020d7 <close+0x49>
	else
		return fd_close(fd, 1);
  8020bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c3:	be 01 00 00 00       	mov    $0x1,%esi
  8020c8:	48 89 c7             	mov    %rax,%rdi
  8020cb:	48 b8 0e 1f 80 00 00 	movabs $0x801f0e,%rax
  8020d2:	00 00 00 
  8020d5:	ff d0                	callq  *%rax
}
  8020d7:	c9                   	leaveq 
  8020d8:	c3                   	retq   

00000000008020d9 <close_all>:

void
close_all(void)
{
  8020d9:	55                   	push   %rbp
  8020da:	48 89 e5             	mov    %rsp,%rbp
  8020dd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020e8:	eb 15                	jmp    8020ff <close_all+0x26>
		close(i);
  8020ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ed:	89 c7                	mov    %eax,%edi
  8020ef:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8020f6:	00 00 00 
  8020f9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ff:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802103:	7e e5                	jle    8020ea <close_all+0x11>
		close(i);
}
  802105:	c9                   	leaveq 
  802106:	c3                   	retq   

0000000000802107 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802107:	55                   	push   %rbp
  802108:	48 89 e5             	mov    %rsp,%rbp
  80210b:	48 83 ec 40          	sub    $0x40,%rsp
  80210f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802112:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802115:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802119:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80211c:	48 89 d6             	mov    %rdx,%rsi
  80211f:	89 c7                	mov    %eax,%edi
  802121:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802128:	00 00 00 
  80212b:	ff d0                	callq  *%rax
  80212d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802130:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802134:	79 08                	jns    80213e <dup+0x37>
		return r;
  802136:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802139:	e9 70 01 00 00       	jmpq   8022ae <dup+0x1a7>
	close(newfdnum);
  80213e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802141:	89 c7                	mov    %eax,%edi
  802143:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80214f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802152:	48 98                	cltq   
  802154:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80215a:	48 c1 e0 0c          	shl    $0xc,%rax
  80215e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802162:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802166:	48 89 c7             	mov    %rax,%rdi
  802169:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  802170:	00 00 00 
  802173:	ff d0                	callq  *%rax
  802175:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217d:	48 89 c7             	mov    %rax,%rdi
  802180:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  802187:	00 00 00 
  80218a:	ff d0                	callq  *%rax
  80218c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802194:	48 c1 e8 15          	shr    $0x15,%rax
  802198:	48 89 c2             	mov    %rax,%rdx
  80219b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021a2:	01 00 00 
  8021a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a9:	83 e0 01             	and    $0x1,%eax
  8021ac:	48 85 c0             	test   %rax,%rax
  8021af:	74 73                	je     802224 <dup+0x11d>
  8021b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b9:	48 89 c2             	mov    %rax,%rdx
  8021bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c3:	01 00 00 
  8021c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ca:	83 e0 01             	and    $0x1,%eax
  8021cd:	48 85 c0             	test   %rax,%rax
  8021d0:	74 52                	je     802224 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8021da:	48 89 c2             	mov    %rax,%rdx
  8021dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e4:	01 00 00 
  8021e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8021f0:	89 c1                	mov    %eax,%ecx
  8021f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fa:	41 89 c8             	mov    %ecx,%r8d
  8021fd:	48 89 d1             	mov    %rdx,%rcx
  802200:	ba 00 00 00 00       	mov    $0x0,%edx
  802205:	48 89 c6             	mov    %rax,%rsi
  802208:	bf 00 00 00 00       	mov    $0x0,%edi
  80220d:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802220:	79 02                	jns    802224 <dup+0x11d>
			goto err;
  802222:	eb 57                	jmp    80227b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802224:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802228:	48 c1 e8 0c          	shr    $0xc,%rax
  80222c:	48 89 c2             	mov    %rax,%rdx
  80222f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802236:	01 00 00 
  802239:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223d:	25 07 0e 00 00       	and    $0xe07,%eax
  802242:	89 c1                	mov    %eax,%ecx
  802244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802248:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80224c:	41 89 c8             	mov    %ecx,%r8d
  80224f:	48 89 d1             	mov    %rdx,%rcx
  802252:	ba 00 00 00 00       	mov    $0x0,%edx
  802257:	48 89 c6             	mov    %rax,%rsi
  80225a:	bf 00 00 00 00       	mov    $0x0,%edi
  80225f:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax
  80226b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802272:	79 02                	jns    802276 <dup+0x16f>
		goto err;
  802274:	eb 05                	jmp    80227b <dup+0x174>

	return newfdnum;
  802276:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802279:	eb 33                	jmp    8022ae <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80227b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80227f:	48 89 c6             	mov    %rax,%rsi
  802282:	bf 00 00 00 00       	mov    $0x0,%edi
  802287:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  80228e:	00 00 00 
  802291:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802297:	48 89 c6             	mov    %rax,%rsi
  80229a:	bf 00 00 00 00       	mov    $0x0,%edi
  80229f:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
	return r;
  8022ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022ae:	c9                   	leaveq 
  8022af:	c3                   	retq   

00000000008022b0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022b0:	55                   	push   %rbp
  8022b1:	48 89 e5             	mov    %rsp,%rbp
  8022b4:	48 83 ec 40          	sub    $0x40,%rsp
  8022b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ca:	48 89 d6             	mov    %rdx,%rsi
  8022cd:	89 c7                	mov    %eax,%edi
  8022cf:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  8022d6:	00 00 00 
  8022d9:	ff d0                	callq  *%rax
  8022db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e2:	78 24                	js     802308 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e8:	8b 00                	mov    (%rax),%eax
  8022ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ee:	48 89 d6             	mov    %rdx,%rsi
  8022f1:	89 c7                	mov    %eax,%edi
  8022f3:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  8022fa:	00 00 00 
  8022fd:	ff d0                	callq  *%rax
  8022ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802302:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802306:	79 05                	jns    80230d <read+0x5d>
		return r;
  802308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230b:	eb 76                	jmp    802383 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80230d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802311:	8b 40 08             	mov    0x8(%rax),%eax
  802314:	83 e0 03             	and    $0x3,%eax
  802317:	83 f8 01             	cmp    $0x1,%eax
  80231a:	75 3a                	jne    802356 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80231c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802323:	00 00 00 
  802326:	48 8b 00             	mov    (%rax),%rax
  802329:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80232f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802332:	89 c6                	mov    %eax,%esi
  802334:	48 bf af 46 80 00 00 	movabs $0x8046af,%rdi
  80233b:	00 00 00 
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  80234a:	00 00 00 
  80234d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80234f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802354:	eb 2d                	jmp    802383 <read+0xd3>
	}
	if (!dev->dev_read)
  802356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80235e:	48 85 c0             	test   %rax,%rax
  802361:	75 07                	jne    80236a <read+0xba>
		return -E_NOT_SUPP;
  802363:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802368:	eb 19                	jmp    802383 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80236a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80236e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802372:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802376:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80237a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80237e:	48 89 cf             	mov    %rcx,%rdi
  802381:	ff d0                	callq  *%rax
}
  802383:	c9                   	leaveq 
  802384:	c3                   	retq   

0000000000802385 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802385:	55                   	push   %rbp
  802386:	48 89 e5             	mov    %rsp,%rbp
  802389:	48 83 ec 30          	sub    $0x30,%rsp
  80238d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802390:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802394:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80239f:	eb 49                	jmp    8023ea <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a4:	48 98                	cltq   
  8023a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023aa:	48 29 c2             	sub    %rax,%rdx
  8023ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b0:	48 63 c8             	movslq %eax,%rcx
  8023b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b7:	48 01 c1             	add    %rax,%rcx
  8023ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023bd:	48 89 ce             	mov    %rcx,%rsi
  8023c0:	89 c7                	mov    %eax,%edi
  8023c2:	48 b8 b0 22 80 00 00 	movabs $0x8022b0,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
  8023ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023d5:	79 05                	jns    8023dc <readn+0x57>
			return m;
  8023d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023da:	eb 1c                	jmp    8023f8 <readn+0x73>
		if (m == 0)
  8023dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023e0:	75 02                	jne    8023e4 <readn+0x5f>
			break;
  8023e2:	eb 11                	jmp    8023f5 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ed:	48 98                	cltq   
  8023ef:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023f3:	72 ac                	jb     8023a1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023f8:	c9                   	leaveq 
  8023f9:	c3                   	retq   

00000000008023fa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023fa:	55                   	push   %rbp
  8023fb:	48 89 e5             	mov    %rsp,%rbp
  8023fe:	48 83 ec 40          	sub    $0x40,%rsp
  802402:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802405:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802409:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802411:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802414:	48 89 d6             	mov    %rdx,%rsi
  802417:	89 c7                	mov    %eax,%edi
  802419:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802420:	00 00 00 
  802423:	ff d0                	callq  *%rax
  802425:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802428:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242c:	78 24                	js     802452 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80242e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802432:	8b 00                	mov    (%rax),%eax
  802434:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802438:	48 89 d6             	mov    %rdx,%rsi
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  802444:	00 00 00 
  802447:	ff d0                	callq  *%rax
  802449:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802450:	79 05                	jns    802457 <write+0x5d>
		return r;
  802452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802455:	eb 75                	jmp    8024cc <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245b:	8b 40 08             	mov    0x8(%rax),%eax
  80245e:	83 e0 03             	and    $0x3,%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	75 3a                	jne    80249f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802465:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80246c:	00 00 00 
  80246f:	48 8b 00             	mov    (%rax),%rax
  802472:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802478:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80247b:	89 c6                	mov    %eax,%esi
  80247d:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  802484:	00 00 00 
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
  80248c:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  802493:	00 00 00 
  802496:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802498:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249d:	eb 2d                	jmp    8024cc <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80249f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a7:	48 85 c0             	test   %rax,%rax
  8024aa:	75 07                	jne    8024b3 <write+0xb9>
		return -E_NOT_SUPP;
  8024ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b1:	eb 19                	jmp    8024cc <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024c7:	48 89 cf             	mov    %rcx,%rdi
  8024ca:	ff d0                	callq  *%rax
}
  8024cc:	c9                   	leaveq 
  8024cd:	c3                   	retq   

00000000008024ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8024ce:	55                   	push   %rbp
  8024cf:	48 89 e5             	mov    %rsp,%rbp
  8024d2:	48 83 ec 18          	sub    $0x18,%rsp
  8024d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	79 05                	jns    802502 <seek+0x34>
		return r;
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	eb 0f                	jmp    802511 <seek+0x43>
	fd->fd_offset = offset;
  802502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802506:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802509:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 30          	sub    $0x30,%rsp
  80251b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80251e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802521:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802525:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802528:	48 89 d6             	mov    %rdx,%rsi
  80252b:	89 c7                	mov    %eax,%edi
  80252d:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802540:	78 24                	js     802566 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	8b 00                	mov    (%rax),%eax
  802548:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80254c:	48 89 d6             	mov    %rdx,%rsi
  80254f:	89 c7                	mov    %eax,%edi
  802551:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802564:	79 05                	jns    80256b <ftruncate+0x58>
		return r;
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	eb 72                	jmp    8025dd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80256b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256f:	8b 40 08             	mov    0x8(%rax),%eax
  802572:	83 e0 03             	and    $0x3,%eax
  802575:	85 c0                	test   %eax,%eax
  802577:	75 3a                	jne    8025b3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802579:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802580:	00 00 00 
  802583:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802586:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80258c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80258f:	89 c6                	mov    %eax,%esi
  802591:	48 bf e8 46 80 00 00 	movabs $0x8046e8,%rdi
  802598:	00 00 00 
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	48 b9 3d 04 80 00 00 	movabs $0x80043d,%rcx
  8025a7:	00 00 00 
  8025aa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025b1:	eb 2a                	jmp    8025dd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025bb:	48 85 c0             	test   %rax,%rax
  8025be:	75 07                	jne    8025c7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c5:	eb 16                	jmp    8025dd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025d3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025d6:	89 ce                	mov    %ecx,%esi
  8025d8:	48 89 d7             	mov    %rdx,%rdi
  8025db:	ff d0                	callq  *%rax
}
  8025dd:	c9                   	leaveq 
  8025de:	c3                   	retq   

00000000008025df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025df:	55                   	push   %rbp
  8025e0:	48 89 e5             	mov    %rsp,%rbp
  8025e3:	48 83 ec 30          	sub    $0x30,%rsp
  8025e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f5:	48 89 d6             	mov    %rdx,%rsi
  8025f8:	89 c7                	mov    %eax,%edi
  8025fa:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802601:	00 00 00 
  802604:	ff d0                	callq  *%rax
  802606:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802609:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260d:	78 24                	js     802633 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802613:	8b 00                	mov    (%rax),%eax
  802615:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802619:	48 89 d6             	mov    %rdx,%rsi
  80261c:	89 c7                	mov    %eax,%edi
  80261e:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  802625:	00 00 00 
  802628:	ff d0                	callq  *%rax
  80262a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802631:	79 05                	jns    802638 <fstat+0x59>
		return r;
  802633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802636:	eb 5e                	jmp    802696 <fstat+0xb7>
	if (!dev->dev_stat)
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802640:	48 85 c0             	test   %rax,%rax
  802643:	75 07                	jne    80264c <fstat+0x6d>
		return -E_NOT_SUPP;
  802645:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80264a:	eb 4a                	jmp    802696 <fstat+0xb7>
	stat->st_name[0] = 0;
  80264c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802650:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802653:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802657:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80265e:	00 00 00 
	stat->st_isdir = 0;
  802661:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802665:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80266c:	00 00 00 
	stat->st_dev = dev;
  80266f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802673:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802677:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80267e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802682:	48 8b 40 28          	mov    0x28(%rax),%rax
  802686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80268a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80268e:	48 89 ce             	mov    %rcx,%rsi
  802691:	48 89 d7             	mov    %rdx,%rdi
  802694:	ff d0                	callq  *%rax
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 20          	sub    $0x20,%rsp
  8026a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ac:	be 00 00 00 00       	mov    $0x0,%esi
  8026b1:	48 89 c7             	mov    %rax,%rdi
  8026b4:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c7:	79 05                	jns    8026ce <stat+0x36>
		return fd;
  8026c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cc:	eb 2f                	jmp    8026fd <stat+0x65>
	r = fstat(fd, stat);
  8026ce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d5:	48 89 d6             	mov    %rdx,%rsi
  8026d8:	89 c7                	mov    %eax,%edi
  8026da:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ec:	89 c7                	mov    %eax,%edi
  8026ee:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  8026f5:	00 00 00 
  8026f8:	ff d0                	callq  *%rax
	return r;
  8026fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 10          	sub    $0x10,%rsp
  802707:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80270a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80270e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802715:	00 00 00 
  802718:	8b 00                	mov    (%rax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	75 1d                	jne    80273b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80271e:	bf 01 00 00 00       	mov    $0x1,%edi
  802723:	48 b8 8c 3f 80 00 00 	movabs $0x803f8c,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
  80272f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802736:	00 00 00 
  802739:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80273b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802742:	00 00 00 
  802745:	8b 00                	mov    (%rax),%eax
  802747:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80274a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80274f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802756:	00 00 00 
  802759:	89 c7                	mov    %eax,%edi
  80275b:	48 b8 2a 3f 80 00 00 	movabs $0x803f2a,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276b:	ba 00 00 00 00       	mov    $0x0,%edx
  802770:	48 89 c6             	mov    %rax,%rsi
  802773:	bf 00 00 00 00       	mov    $0x0,%edi
  802778:	48 b8 24 3e 80 00 00 	movabs $0x803e24,%rax
  80277f:	00 00 00 
  802782:	ff d0                	callq  *%rax
}
  802784:	c9                   	leaveq 
  802785:	c3                   	retq   

0000000000802786 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802786:	55                   	push   %rbp
  802787:	48 89 e5             	mov    %rsp,%rbp
  80278a:	48 83 ec 30          	sub    $0x30,%rsp
  80278e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802792:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802795:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80279c:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8027a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8027aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027af:	75 08                	jne    8027b9 <open+0x33>
	{
		return r;
  8027b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b4:	e9 f2 00 00 00       	jmpq   8028ab <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8027b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bd:	48 89 c7             	mov    %rax,%rdi
  8027c0:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	callq  *%rax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8027cf:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8027d6:	7e 0a                	jle    8027e2 <open+0x5c>
	{
		return -E_BAD_PATH;
  8027d8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027dd:	e9 c9 00 00 00       	jmpq   8028ab <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8027e2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027e9:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8027ea:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8027ee:	48 89 c7             	mov    %rax,%rdi
  8027f1:	48 b8 e6 1d 80 00 00 	movabs $0x801de6,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802804:	78 09                	js     80280f <open+0x89>
  802806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280a:	48 85 c0             	test   %rax,%rax
  80280d:	75 08                	jne    802817 <open+0x91>
		{
			return r;
  80280f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802812:	e9 94 00 00 00       	jmpq   8028ab <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281b:	ba 00 04 00 00       	mov    $0x400,%edx
  802820:	48 89 c6             	mov    %rax,%rsi
  802823:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80282a:	00 00 00 
  80282d:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802839:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802840:	00 00 00 
  802843:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802846:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80284c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802850:	48 89 c6             	mov    %rax,%rsi
  802853:	bf 01 00 00 00       	mov    $0x1,%edi
  802858:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
  802864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286b:	79 2b                	jns    802898 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80286d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802871:	be 00 00 00 00       	mov    $0x0,%esi
  802876:	48 89 c7             	mov    %rax,%rdi
  802879:	48 b8 0e 1f 80 00 00 	movabs $0x801f0e,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802888:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80288c:	79 05                	jns    802893 <open+0x10d>
			{
				return d;
  80288e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802891:	eb 18                	jmp    8028ab <open+0x125>
			}
			return r;
  802893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802896:	eb 13                	jmp    8028ab <open+0x125>
		}	
		return fd2num(fd_store);
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	48 89 c7             	mov    %rax,%rdi
  80289f:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8028ab:	c9                   	leaveq 
  8028ac:	c3                   	retq   

00000000008028ad <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028ad:	55                   	push   %rbp
  8028ae:	48 89 e5             	mov    %rsp,%rbp
  8028b1:	48 83 ec 10          	sub    $0x10,%rsp
  8028b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028c7:	00 00 00 
  8028ca:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028cc:	be 00 00 00 00       	mov    $0x0,%esi
  8028d1:	bf 06 00 00 00       	mov    $0x6,%edi
  8028d6:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
}
  8028e2:	c9                   	leaveq 
  8028e3:	c3                   	retq   

00000000008028e4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028e4:	55                   	push   %rbp
  8028e5:	48 89 e5             	mov    %rsp,%rbp
  8028e8:	48 83 ec 30          	sub    $0x30,%rsp
  8028ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802904:	74 07                	je     80290d <devfile_read+0x29>
  802906:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80290b:	75 07                	jne    802914 <devfile_read+0x30>
		return -E_INVAL;
  80290d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802912:	eb 77                	jmp    80298b <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 50 0c             	mov    0xc(%rax),%edx
  80291b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802922:	00 00 00 
  802925:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802927:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292e:	00 00 00 
  802931:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802935:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802939:	be 00 00 00 00       	mov    $0x0,%esi
  80293e:	bf 03 00 00 00       	mov    $0x3,%edi
  802943:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802956:	7f 05                	jg     80295d <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295b:	eb 2e                	jmp    80298b <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802960:	48 63 d0             	movslq %eax,%rdx
  802963:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802967:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80296e:	00 00 00 
  802971:	48 89 c7             	mov    %rax,%rdi
  802974:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802980:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802984:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802988:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80298b:	c9                   	leaveq 
  80298c:	c3                   	retq   

000000000080298d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80298d:	55                   	push   %rbp
  80298e:	48 89 e5             	mov    %rsp,%rbp
  802991:	48 83 ec 30          	sub    $0x30,%rsp
  802995:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802999:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8029a1:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8029a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029ad:	74 07                	je     8029b6 <devfile_write+0x29>
  8029af:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029b4:	75 08                	jne    8029be <devfile_write+0x31>
		return r;
  8029b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b9:	e9 9a 00 00 00       	jmpq   802a58 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c2:	8b 50 0c             	mov    0xc(%rax),%edx
  8029c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029cc:	00 00 00 
  8029cf:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8029d1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029d8:	00 
  8029d9:	76 08                	jbe    8029e3 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8029db:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029e2:	00 
	}
	fsipcbuf.write.req_n = n;
  8029e3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ea:	00 00 00 
  8029ed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029f5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fd:	48 89 c6             	mov    %rax,%rsi
  802a00:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a07:	00 00 00 
  802a0a:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802a16:	be 00 00 00 00       	mov    $0x0,%esi
  802a1b:	bf 04 00 00 00       	mov    $0x4,%edi
  802a20:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a33:	7f 20                	jg     802a55 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a35:	48 bf 0e 47 80 00 00 	movabs $0x80470e,%rdi
  802a3c:	00 00 00 
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802a4b:	00 00 00 
  802a4e:	ff d2                	callq  *%rdx
		return r;
  802a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a53:	eb 03                	jmp    802a58 <devfile_write+0xcb>
	}
	return r;
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a58:	c9                   	leaveq 
  802a59:	c3                   	retq   

0000000000802a5a <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a5a:	55                   	push   %rbp
  802a5b:	48 89 e5             	mov    %rsp,%rbp
  802a5e:	48 83 ec 20          	sub    $0x20,%rsp
  802a62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6e:	8b 50 0c             	mov    0xc(%rax),%edx
  802a71:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a78:	00 00 00 
  802a7b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a7d:	be 00 00 00 00       	mov    $0x0,%esi
  802a82:	bf 05 00 00 00       	mov    $0x5,%edi
  802a87:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802a8e:	00 00 00 
  802a91:	ff d0                	callq  *%rax
  802a93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9a:	79 05                	jns    802aa1 <devfile_stat+0x47>
		return r;
  802a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9f:	eb 56                	jmp    802af7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802aa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802aac:	00 00 00 
  802aaf:	48 89 c7             	mov    %rax,%rdi
  802ab2:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802abe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ac5:	00 00 00 
  802ac8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ace:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ad8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802adf:	00 00 00 
  802ae2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ae8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aec:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af7:	c9                   	leaveq 
  802af8:	c3                   	retq   

0000000000802af9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802af9:	55                   	push   %rbp
  802afa:	48 89 e5             	mov    %rsp,%rbp
  802afd:	48 83 ec 10          	sub    $0x10,%rsp
  802b01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b05:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b0f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b16:	00 00 00 
  802b19:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b22:	00 00 00 
  802b25:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b2b:	be 00 00 00 00       	mov    $0x0,%esi
  802b30:	bf 02 00 00 00       	mov    $0x2,%edi
  802b35:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802b3c:	00 00 00 
  802b3f:	ff d0                	callq  *%rax
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
  802b47:	48 83 ec 10          	sub    $0x10,%rsp
  802b4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b53:	48 89 c7             	mov    %rax,%rdi
  802b56:	48 b8 86 0f 80 00 00 	movabs $0x800f86,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b67:	7e 07                	jle    802b70 <remove+0x2d>
		return -E_BAD_PATH;
  802b69:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b6e:	eb 33                	jmp    802ba3 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b74:	48 89 c6             	mov    %rax,%rsi
  802b77:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b7e:	00 00 00 
  802b81:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b8d:	be 00 00 00 00       	mov    $0x0,%esi
  802b92:	bf 07 00 00 00       	mov    $0x7,%edi
  802b97:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	callq  *%rax
}
  802ba3:	c9                   	leaveq 
  802ba4:	c3                   	retq   

0000000000802ba5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ba5:	55                   	push   %rbp
  802ba6:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ba9:	be 00 00 00 00       	mov    $0x0,%esi
  802bae:	bf 08 00 00 00       	mov    $0x8,%edi
  802bb3:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
}
  802bbf:	5d                   	pop    %rbp
  802bc0:	c3                   	retq   

0000000000802bc1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802bc1:	55                   	push   %rbp
  802bc2:	48 89 e5             	mov    %rsp,%rbp
  802bc5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802bcc:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802bd3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802bda:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802be1:	be 00 00 00 00       	mov    $0x0,%esi
  802be6:	48 89 c7             	mov    %rax,%rdi
  802be9:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfc:	79 28                	jns    802c26 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c01:	89 c6                	mov    %eax,%esi
  802c03:	48 bf 2a 47 80 00 00 	movabs $0x80472a,%rdi
  802c0a:	00 00 00 
  802c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c12:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802c19:	00 00 00 
  802c1c:	ff d2                	callq  *%rdx
		return fd_src;
  802c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c21:	e9 74 01 00 00       	jmpq   802d9a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c26:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c2d:	be 01 01 00 00       	mov    $0x101,%esi
  802c32:	48 89 c7             	mov    %rax,%rdi
  802c35:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
  802c41:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c44:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c48:	79 39                	jns    802c83 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4d:	89 c6                	mov    %eax,%esi
  802c4f:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  802c56:	00 00 00 
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5e:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802c65:	00 00 00 
  802c68:	ff d2                	callq  *%rdx
		close(fd_src);
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
		return fd_dest;
  802c7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c7e:	e9 17 01 00 00       	jmpq   802d9a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c83:	eb 74                	jmp    802cf9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c88:	48 63 d0             	movslq %eax,%rdx
  802c8b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c95:	48 89 ce             	mov    %rcx,%rsi
  802c98:	89 c7                	mov    %eax,%edi
  802c9a:	48 b8 fa 23 80 00 00 	movabs $0x8023fa,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
  802ca6:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ca9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cad:	79 4a                	jns    802cf9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802caf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cb2:	89 c6                	mov    %eax,%esi
  802cb4:	48 bf 5a 47 80 00 00 	movabs $0x80475a,%rdi
  802cbb:	00 00 00 
  802cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc3:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802cca:	00 00 00 
  802ccd:	ff d2                	callq  *%rdx
			close(fd_src);
  802ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
			close(fd_dest);
  802ce0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce3:	89 c7                	mov    %eax,%edi
  802ce5:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
			return write_size;
  802cf1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cf4:	e9 a1 00 00 00       	jmpq   802d9a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cf9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d03:	ba 00 02 00 00       	mov    $0x200,%edx
  802d08:	48 89 ce             	mov    %rcx,%rsi
  802d0b:	89 c7                	mov    %eax,%edi
  802d0d:	48 b8 b0 22 80 00 00 	movabs $0x8022b0,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d20:	0f 8f 5f ff ff ff    	jg     802c85 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d2a:	79 47                	jns    802d73 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d2c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d2f:	89 c6                	mov    %eax,%esi
  802d31:	48 bf 6d 47 80 00 00 	movabs $0x80476d,%rdi
  802d38:	00 00 00 
  802d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d40:	48 ba 3d 04 80 00 00 	movabs $0x80043d,%rdx
  802d47:	00 00 00 
  802d4a:	ff d2                	callq  *%rdx
		close(fd_src);
  802d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4f:	89 c7                	mov    %eax,%edi
  802d51:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
		close(fd_dest);
  802d5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
		return read_size;
  802d6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d71:	eb 27                	jmp    802d9a <copy+0x1d9>
	}
	close(fd_src);
  802d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d76:	89 c7                	mov    %eax,%edi
  802d78:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
	close(fd_dest);
  802d84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d87:	89 c7                	mov    %eax,%edi
  802d89:	48 b8 8e 20 80 00 00 	movabs $0x80208e,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
	return 0;
  802d95:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 83 ec 20          	sub    $0x20,%rsp
  802da4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802da7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dae:	48 89 d6             	mov    %rdx,%rsi
  802db1:	89 c7                	mov    %eax,%edi
  802db3:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
  802dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc6:	79 05                	jns    802dcd <fd2sockid+0x31>
		return r;
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	eb 24                	jmp    802df1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd1:	8b 10                	mov    (%rax),%edx
  802dd3:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802dda:	00 00 00 
  802ddd:	8b 00                	mov    (%rax),%eax
  802ddf:	39 c2                	cmp    %eax,%edx
  802de1:	74 07                	je     802dea <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802de3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802de8:	eb 07                	jmp    802df1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dee:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802df1:	c9                   	leaveq 
  802df2:	c3                   	retq   

0000000000802df3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802df3:	55                   	push   %rbp
  802df4:	48 89 e5             	mov    %rsp,%rbp
  802df7:	48 83 ec 20          	sub    $0x20,%rsp
  802dfb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802dfe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e02:	48 89 c7             	mov    %rax,%rdi
  802e05:	48 b8 e6 1d 80 00 00 	movabs $0x801de6,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e18:	78 26                	js     802e40 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1e:	ba 07 04 00 00       	mov    $0x407,%edx
  802e23:	48 89 c6             	mov    %rax,%rsi
  802e26:	bf 00 00 00 00       	mov    $0x0,%edi
  802e2b:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
  802e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3e:	79 16                	jns    802e56 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e43:	89 c7                	mov    %eax,%edi
  802e45:	48 b8 00 33 80 00 00 	movabs $0x803300,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
		return r;
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e54:	eb 3a                	jmp    802e90 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e61:	00 00 00 
  802e64:	8b 12                	mov    (%rdx),%edx
  802e66:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e77:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e7a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e81:	48 89 c7             	mov    %rax,%rdi
  802e84:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802e8b:	00 00 00 
  802e8e:	ff d0                	callq  *%rax
}
  802e90:	c9                   	leaveq 
  802e91:	c3                   	retq   

0000000000802e92 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e92:	55                   	push   %rbp
  802e93:	48 89 e5             	mov    %rsp,%rbp
  802e96:	48 83 ec 30          	sub    $0x30,%rsp
  802e9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ea5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea8:	89 c7                	mov    %eax,%edi
  802eaa:	48 b8 9c 2d 80 00 00 	movabs $0x802d9c,%rax
  802eb1:	00 00 00 
  802eb4:	ff d0                	callq  *%rax
  802eb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebd:	79 05                	jns    802ec4 <accept+0x32>
		return r;
  802ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec2:	eb 3b                	jmp    802eff <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ec4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ec8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ecc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecf:	48 89 ce             	mov    %rcx,%rsi
  802ed2:	89 c7                	mov    %eax,%edi
  802ed4:	48 b8 dd 31 80 00 00 	movabs $0x8031dd,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
  802ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee7:	79 05                	jns    802eee <accept+0x5c>
		return r;
  802ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eec:	eb 11                	jmp    802eff <accept+0x6d>
	return alloc_sockfd(r);
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef1:	89 c7                	mov    %eax,%edi
  802ef3:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	callq  *%rax
}
  802eff:	c9                   	leaveq 
  802f00:	c3                   	retq   

0000000000802f01 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f01:	55                   	push   %rbp
  802f02:	48 89 e5             	mov    %rsp,%rbp
  802f05:	48 83 ec 20          	sub    $0x20,%rsp
  802f09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f10:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f16:	89 c7                	mov    %eax,%edi
  802f18:	48 b8 9c 2d 80 00 00 	movabs $0x802d9c,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	callq  *%rax
  802f24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2b:	79 05                	jns    802f32 <bind+0x31>
		return r;
  802f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f30:	eb 1b                	jmp    802f4d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f32:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f35:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3c:	48 89 ce             	mov    %rcx,%rsi
  802f3f:	89 c7                	mov    %eax,%edi
  802f41:	48 b8 5c 32 80 00 00 	movabs $0x80325c,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
}
  802f4d:	c9                   	leaveq 
  802f4e:	c3                   	retq   

0000000000802f4f <shutdown>:

int
shutdown(int s, int how)
{
  802f4f:	55                   	push   %rbp
  802f50:	48 89 e5             	mov    %rsp,%rbp
  802f53:	48 83 ec 20          	sub    $0x20,%rsp
  802f57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f5a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f60:	89 c7                	mov    %eax,%edi
  802f62:	48 b8 9c 2d 80 00 00 	movabs $0x802d9c,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f75:	79 05                	jns    802f7c <shutdown+0x2d>
		return r;
  802f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7a:	eb 16                	jmp    802f92 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f7c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f82:	89 d6                	mov    %edx,%esi
  802f84:	89 c7                	mov    %eax,%edi
  802f86:	48 b8 c0 32 80 00 00 	movabs $0x8032c0,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
}
  802f92:	c9                   	leaveq 
  802f93:	c3                   	retq   

0000000000802f94 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f94:	55                   	push   %rbp
  802f95:	48 89 e5             	mov    %rsp,%rbp
  802f98:	48 83 ec 10          	sub    $0x10,%rsp
  802f9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802fa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa4:	48 89 c7             	mov    %rax,%rdi
  802fa7:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
  802fb3:	83 f8 01             	cmp    $0x1,%eax
  802fb6:	75 17                	jne    802fcf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbc:	8b 40 0c             	mov    0xc(%rax),%eax
  802fbf:	89 c7                	mov    %eax,%edi
  802fc1:	48 b8 00 33 80 00 00 	movabs $0x803300,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	eb 05                	jmp    802fd4 <devsock_close+0x40>
	else
		return 0;
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fd4:	c9                   	leaveq 
  802fd5:	c3                   	retq   

0000000000802fd6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fd6:	55                   	push   %rbp
  802fd7:	48 89 e5             	mov    %rsp,%rbp
  802fda:	48 83 ec 20          	sub    $0x20,%rsp
  802fde:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fe8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802feb:	89 c7                	mov    %eax,%edi
  802fed:	48 b8 9c 2d 80 00 00 	movabs $0x802d9c,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
  802ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803000:	79 05                	jns    803007 <connect+0x31>
		return r;
  803002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803005:	eb 1b                	jmp    803022 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803007:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80300a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80300e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803011:	48 89 ce             	mov    %rcx,%rsi
  803014:	89 c7                	mov    %eax,%edi
  803016:	48 b8 2d 33 80 00 00 	movabs $0x80332d,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <listen>:

int
listen(int s, int backlog)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 20          	sub    $0x20,%rsp
  80302c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80302f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803032:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803035:	89 c7                	mov    %eax,%edi
  803037:	48 b8 9c 2d 80 00 00 	movabs $0x802d9c,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
  803043:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803046:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304a:	79 05                	jns    803051 <listen+0x2d>
		return r;
  80304c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304f:	eb 16                	jmp    803067 <listen+0x43>
	return nsipc_listen(r, backlog);
  803051:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803057:	89 d6                	mov    %edx,%esi
  803059:	89 c7                	mov    %eax,%edi
  80305b:	48 b8 91 33 80 00 00 	movabs $0x803391,%rax
  803062:	00 00 00 
  803065:	ff d0                	callq  *%rax
}
  803067:	c9                   	leaveq 
  803068:	c3                   	retq   

0000000000803069 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803069:	55                   	push   %rbp
  80306a:	48 89 e5             	mov    %rsp,%rbp
  80306d:	48 83 ec 20          	sub    $0x20,%rsp
  803071:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803075:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803079:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80307d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803081:	89 c2                	mov    %eax,%edx
  803083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803087:	8b 40 0c             	mov    0xc(%rax),%eax
  80308a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80308e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803093:	89 c7                	mov    %eax,%edi
  803095:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
}
  8030a1:	c9                   	leaveq 
  8030a2:	c3                   	retq   

00000000008030a3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030a3:	55                   	push   %rbp
  8030a4:	48 89 e5             	mov    %rsp,%rbp
  8030a7:	48 83 ec 20          	sub    $0x20,%rsp
  8030ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8030b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bb:	89 c2                	mov    %eax,%edx
  8030bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8030c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030cd:	89 c7                	mov    %eax,%edi
  8030cf:	48 b8 9d 34 80 00 00 	movabs $0x80349d,%rax
  8030d6:	00 00 00 
  8030d9:	ff d0                	callq  *%rax
}
  8030db:	c9                   	leaveq 
  8030dc:	c3                   	retq   

00000000008030dd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030dd:	55                   	push   %rbp
  8030de:	48 89 e5             	mov    %rsp,%rbp
  8030e1:	48 83 ec 10          	sub    $0x10,%rsp
  8030e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f1:	48 be 88 47 80 00 00 	movabs $0x804788,%rsi
  8030f8:	00 00 00 
  8030fb:	48 89 c7             	mov    %rax,%rdi
  8030fe:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
	return 0;
  80310a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310f:	c9                   	leaveq 
  803110:	c3                   	retq   

0000000000803111 <socket>:

int
socket(int domain, int type, int protocol)
{
  803111:	55                   	push   %rbp
  803112:	48 89 e5             	mov    %rsp,%rbp
  803115:	48 83 ec 20          	sub    $0x20,%rsp
  803119:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80311c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80311f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803122:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803125:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803128:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80312b:	89 ce                	mov    %ecx,%esi
  80312d:	89 c7                	mov    %eax,%edi
  80312f:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803142:	79 05                	jns    803149 <socket+0x38>
		return r;
  803144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803147:	eb 11                	jmp    80315a <socket+0x49>
	return alloc_sockfd(r);
  803149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314c:	89 c7                	mov    %eax,%edi
  80314e:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
}
  80315a:	c9                   	leaveq 
  80315b:	c3                   	retq   

000000000080315c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80315c:	55                   	push   %rbp
  80315d:	48 89 e5             	mov    %rsp,%rbp
  803160:	48 83 ec 10          	sub    $0x10,%rsp
  803164:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803167:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80316e:	00 00 00 
  803171:	8b 00                	mov    (%rax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	75 1d                	jne    803194 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803177:	bf 02 00 00 00       	mov    $0x2,%edi
  80317c:	48 b8 8c 3f 80 00 00 	movabs $0x803f8c,%rax
  803183:	00 00 00 
  803186:	ff d0                	callq  *%rax
  803188:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  80318f:	00 00 00 
  803192:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803194:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80319b:	00 00 00 
  80319e:	8b 00                	mov    (%rax),%eax
  8031a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031a8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8031af:	00 00 00 
  8031b2:	89 c7                	mov    %eax,%edi
  8031b4:	48 b8 2a 3f 80 00 00 	movabs $0x803f2a,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8031c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c5:	be 00 00 00 00       	mov    $0x0,%esi
  8031ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8031cf:	48 b8 24 3e 80 00 00 	movabs $0x803e24,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
}
  8031db:	c9                   	leaveq 
  8031dc:	c3                   	retq   

00000000008031dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031dd:	55                   	push   %rbp
  8031de:	48 89 e5             	mov    %rsp,%rbp
  8031e1:	48 83 ec 30          	sub    $0x30,%rsp
  8031e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031f0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031f7:	00 00 00 
  8031fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031fd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031ff:	bf 01 00 00 00       	mov    $0x1,%edi
  803204:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803217:	78 3e                	js     803257 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803219:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803220:	00 00 00 
  803223:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322b:	8b 40 10             	mov    0x10(%rax),%eax
  80322e:	89 c2                	mov    %eax,%edx
  803230:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803234:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803238:	48 89 ce             	mov    %rcx,%rsi
  80323b:	48 89 c7             	mov    %rax,%rdi
  80323e:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80324a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324e:	8b 50 10             	mov    0x10(%rax),%edx
  803251:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803255:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803257:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80325a:	c9                   	leaveq 
  80325b:	c3                   	retq   

000000000080325c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80325c:	55                   	push   %rbp
  80325d:	48 89 e5             	mov    %rsp,%rbp
  803260:	48 83 ec 10          	sub    $0x10,%rsp
  803264:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803267:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80326b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80326e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803275:	00 00 00 
  803278:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80327b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80327d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803284:	48 89 c6             	mov    %rax,%rsi
  803287:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80328e:	00 00 00 
  803291:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80329d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a4:	00 00 00 
  8032a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032aa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8032ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b2:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
}
  8032be:	c9                   	leaveq 
  8032bf:	c3                   	retq   

00000000008032c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8032c0:	55                   	push   %rbp
  8032c1:	48 89 e5             	mov    %rsp,%rbp
  8032c4:	48 83 ec 10          	sub    $0x10,%rsp
  8032c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d5:	00 00 00 
  8032d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032db:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e4:	00 00 00 
  8032e7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8032f2:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8032f9:	00 00 00 
  8032fc:	ff d0                	callq  *%rax
}
  8032fe:	c9                   	leaveq 
  8032ff:	c3                   	retq   

0000000000803300 <nsipc_close>:

int
nsipc_close(int s)
{
  803300:	55                   	push   %rbp
  803301:	48 89 e5             	mov    %rsp,%rbp
  803304:	48 83 ec 10          	sub    $0x10,%rsp
  803308:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80330b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803312:	00 00 00 
  803315:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803318:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80331a:	bf 04 00 00 00       	mov    $0x4,%edi
  80331f:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
}
  80332b:	c9                   	leaveq 
  80332c:	c3                   	retq   

000000000080332d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80332d:	55                   	push   %rbp
  80332e:	48 89 e5             	mov    %rsp,%rbp
  803331:	48 83 ec 10          	sub    $0x10,%rsp
  803335:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803338:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80333c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80333f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803346:	00 00 00 
  803349:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80334c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80334e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803351:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803355:	48 89 c6             	mov    %rax,%rsi
  803358:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80335f:	00 00 00 
  803362:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80336e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803375:	00 00 00 
  803378:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80337b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80337e:	bf 05 00 00 00       	mov    $0x5,%edi
  803383:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
}
  80338f:	c9                   	leaveq 
  803390:	c3                   	retq   

0000000000803391 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803391:	55                   	push   %rbp
  803392:	48 89 e5             	mov    %rsp,%rbp
  803395:	48 83 ec 10          	sub    $0x10,%rsp
  803399:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80339c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80339f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a6:	00 00 00 
  8033a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8033ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b5:	00 00 00 
  8033b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033bb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8033be:	bf 06 00 00 00       	mov    $0x6,%edi
  8033c3:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
}
  8033cf:	c9                   	leaveq 
  8033d0:	c3                   	retq   

00000000008033d1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033d1:	55                   	push   %rbp
  8033d2:	48 89 e5             	mov    %rsp,%rbp
  8033d5:	48 83 ec 30          	sub    $0x30,%rsp
  8033d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ed:	00 00 00 
  8033f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033fc:	00 00 00 
  8033ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803402:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803405:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340c:	00 00 00 
  80340f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803412:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803415:	bf 07 00 00 00       	mov    $0x7,%edi
  80341a:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
  803426:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803429:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342d:	78 69                	js     803498 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80342f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803436:	7f 08                	jg     803440 <nsipc_recv+0x6f>
  803438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80343e:	7e 35                	jle    803475 <nsipc_recv+0xa4>
  803440:	48 b9 8f 47 80 00 00 	movabs $0x80478f,%rcx
  803447:	00 00 00 
  80344a:	48 ba a4 47 80 00 00 	movabs $0x8047a4,%rdx
  803451:	00 00 00 
  803454:	be 61 00 00 00       	mov    $0x61,%esi
  803459:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  803460:	00 00 00 
  803463:	b8 00 00 00 00       	mov    $0x0,%eax
  803468:	49 b8 04 02 80 00 00 	movabs $0x800204,%r8
  80346f:	00 00 00 
  803472:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803478:	48 63 d0             	movslq %eax,%rdx
  80347b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803486:	00 00 00 
  803489:	48 89 c7             	mov    %rax,%rdi
  80348c:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803493:	00 00 00 
  803496:	ff d0                	callq  *%rax
	}

	return r;
  803498:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80349b:	c9                   	leaveq 
  80349c:	c3                   	retq   

000000000080349d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80349d:	55                   	push   %rbp
  80349e:	48 89 e5             	mov    %rsp,%rbp
  8034a1:	48 83 ec 20          	sub    $0x20,%rsp
  8034a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8034af:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8034b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b9:	00 00 00 
  8034bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034bf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8034c1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034c8:	7e 35                	jle    8034ff <nsipc_send+0x62>
  8034ca:	48 b9 c5 47 80 00 00 	movabs $0x8047c5,%rcx
  8034d1:	00 00 00 
  8034d4:	48 ba a4 47 80 00 00 	movabs $0x8047a4,%rdx
  8034db:	00 00 00 
  8034de:	be 6c 00 00 00       	mov    $0x6c,%esi
  8034e3:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  8034ea:	00 00 00 
  8034ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f2:	49 b8 04 02 80 00 00 	movabs $0x800204,%r8
  8034f9:	00 00 00 
  8034fc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803502:	48 63 d0             	movslq %eax,%rdx
  803505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803509:	48 89 c6             	mov    %rax,%rsi
  80350c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803513:	00 00 00 
  803516:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803522:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803529:	00 00 00 
  80352c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803532:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803539:	00 00 00 
  80353c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80353f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803542:	bf 08 00 00 00       	mov    $0x8,%edi
  803547:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 10          	sub    $0x10,%rsp
  80355d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803560:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803563:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803566:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356d:	00 00 00 
  803570:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803573:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803575:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80357c:	00 00 00 
  80357f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803582:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803585:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80358c:	00 00 00 
  80358f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803592:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803595:	bf 09 00 00 00       	mov    $0x9,%edi
  80359a:	48 b8 5c 31 80 00 00 	movabs $0x80315c,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
}
  8035a6:	c9                   	leaveq 
  8035a7:	c3                   	retq   

00000000008035a8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035a8:	55                   	push   %rbp
  8035a9:	48 89 e5             	mov    %rsp,%rbp
  8035ac:	53                   	push   %rbx
  8035ad:	48 83 ec 38          	sub    $0x38,%rsp
  8035b1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8035b5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8035b9:	48 89 c7             	mov    %rax,%rdi
  8035bc:	48 b8 e6 1d 80 00 00 	movabs $0x801de6,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
  8035c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035cf:	0f 88 bf 01 00 00    	js     803794 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8035de:	48 89 c6             	mov    %rax,%rsi
  8035e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e6:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
  8035f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f9:	0f 88 95 01 00 00    	js     803794 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035ff:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803603:	48 89 c7             	mov    %rax,%rdi
  803606:	48 b8 e6 1d 80 00 00 	movabs $0x801de6,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
  803612:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803615:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803619:	0f 88 5d 01 00 00    	js     80377c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80361f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803623:	ba 07 04 00 00       	mov    $0x407,%edx
  803628:	48 89 c6             	mov    %rax,%rsi
  80362b:	bf 00 00 00 00       	mov    $0x0,%edi
  803630:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80363f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803643:	0f 88 33 01 00 00    	js     80377c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364d:	48 89 c7             	mov    %rax,%rdi
  803650:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
  80365c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803660:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803664:	ba 07 04 00 00       	mov    $0x407,%edx
  803669:	48 89 c6             	mov    %rax,%rsi
  80366c:	bf 00 00 00 00       	mov    $0x0,%edi
  803671:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
  80367d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803680:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803684:	79 05                	jns    80368b <pipe+0xe3>
		goto err2;
  803686:	e9 d9 00 00 00       	jmpq   803764 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80368b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368f:	48 89 c7             	mov    %rax,%rdi
  803692:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	48 89 c2             	mov    %rax,%rdx
  8036a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8036ab:	48 89 d1             	mov    %rdx,%rcx
  8036ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8036b3:	48 89 c6             	mov    %rax,%rsi
  8036b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bb:	48 b8 71 19 80 00 00 	movabs $0x801971,%rax
  8036c2:	00 00 00 
  8036c5:	ff d0                	callq  *%rax
  8036c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036ce:	79 1b                	jns    8036eb <pipe+0x143>
		goto err3;
  8036d0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8036d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d5:	48 89 c6             	mov    %rax,%rsi
  8036d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036dd:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
  8036e9:	eb 79                	jmp    803764 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ef:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036f6:	00 00 00 
  8036f9:	8b 12                	mov    (%rdx),%edx
  8036fb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803701:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803713:	00 00 00 
  803716:	8b 12                	mov    (%rdx),%edx
  803718:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80371a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80371e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803729:	48 89 c7             	mov    %rax,%rdi
  80372c:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
  803738:	89 c2                	mov    %eax,%edx
  80373a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80373e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803740:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803744:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803748:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374c:	48 89 c7             	mov    %rax,%rdi
  80374f:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803756:	00 00 00 
  803759:	ff d0                	callq  *%rax
  80375b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80375d:	b8 00 00 00 00       	mov    $0x0,%eax
  803762:	eb 33                	jmp    803797 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803764:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803768:	48 89 c6             	mov    %rax,%rsi
  80376b:	bf 00 00 00 00       	mov    $0x0,%edi
  803770:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80377c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803780:	48 89 c6             	mov    %rax,%rsi
  803783:	bf 00 00 00 00       	mov    $0x0,%edi
  803788:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
err:
	return r;
  803794:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803797:	48 83 c4 38          	add    $0x38,%rsp
  80379b:	5b                   	pop    %rbx
  80379c:	5d                   	pop    %rbp
  80379d:	c3                   	retq   

000000000080379e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80379e:	55                   	push   %rbp
  80379f:	48 89 e5             	mov    %rsp,%rbp
  8037a2:	53                   	push   %rbx
  8037a3:	48 83 ec 28          	sub    $0x28,%rsp
  8037a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8037af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037b6:	00 00 00 
  8037b9:	48 8b 00             	mov    (%rax),%rax
  8037bc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c9:	48 89 c7             	mov    %rax,%rdi
  8037cc:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  8037d3:	00 00 00 
  8037d6:	ff d0                	callq  *%rax
  8037d8:	89 c3                	mov    %eax,%ebx
  8037da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
  8037ed:	39 c3                	cmp    %eax,%ebx
  8037ef:	0f 94 c0             	sete   %al
  8037f2:	0f b6 c0             	movzbl %al,%eax
  8037f5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8037ff:	00 00 00 
  803802:	48 8b 00             	mov    (%rax),%rax
  803805:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80380b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80380e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803811:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803814:	75 05                	jne    80381b <_pipeisclosed+0x7d>
			return ret;
  803816:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803819:	eb 4f                	jmp    80386a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80381b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80381e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803821:	74 42                	je     803865 <_pipeisclosed+0xc7>
  803823:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803827:	75 3c                	jne    803865 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803829:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803830:	00 00 00 
  803833:	48 8b 00             	mov    (%rax),%rax
  803836:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80383c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80383f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803842:	89 c6                	mov    %eax,%esi
  803844:	48 bf d6 47 80 00 00 	movabs $0x8047d6,%rdi
  80384b:	00 00 00 
  80384e:	b8 00 00 00 00       	mov    $0x0,%eax
  803853:	49 b8 3d 04 80 00 00 	movabs $0x80043d,%r8
  80385a:	00 00 00 
  80385d:	41 ff d0             	callq  *%r8
	}
  803860:	e9 4a ff ff ff       	jmpq   8037af <_pipeisclosed+0x11>
  803865:	e9 45 ff ff ff       	jmpq   8037af <_pipeisclosed+0x11>
}
  80386a:	48 83 c4 28          	add    $0x28,%rsp
  80386e:	5b                   	pop    %rbx
  80386f:	5d                   	pop    %rbp
  803870:	c3                   	retq   

0000000000803871 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803871:	55                   	push   %rbp
  803872:	48 89 e5             	mov    %rsp,%rbp
  803875:	48 83 ec 30          	sub    $0x30,%rsp
  803879:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80387c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803880:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803883:	48 89 d6             	mov    %rdx,%rsi
  803886:	89 c7                	mov    %eax,%edi
  803888:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
  803894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389b:	79 05                	jns    8038a2 <pipeisclosed+0x31>
		return r;
  80389d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a0:	eb 31                	jmp    8038d3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a6:	48 89 c7             	mov    %rax,%rdi
  8038a9:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  8038b0:	00 00 00 
  8038b3:	ff d0                	callq  *%rax
  8038b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8038b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038c1:	48 89 d6             	mov    %rdx,%rsi
  8038c4:	48 89 c7             	mov    %rax,%rdi
  8038c7:	48 b8 9e 37 80 00 00 	movabs $0x80379e,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
}
  8038d3:	c9                   	leaveq 
  8038d4:	c3                   	retq   

00000000008038d5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038d5:	55                   	push   %rbp
  8038d6:	48 89 e5             	mov    %rsp,%rbp
  8038d9:	48 83 ec 40          	sub    $0x40,%rsp
  8038dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ed:	48 89 c7             	mov    %rax,%rdi
  8038f0:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
  8038fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803900:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803904:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803908:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80390f:	00 
  803910:	e9 92 00 00 00       	jmpq   8039a7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803915:	eb 41                	jmp    803958 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803917:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80391c:	74 09                	je     803927 <devpipe_read+0x52>
				return i;
  80391e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803922:	e9 92 00 00 00       	jmpq   8039b9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803927:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80392b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392f:	48 89 d6             	mov    %rdx,%rsi
  803932:	48 89 c7             	mov    %rax,%rdi
  803935:	48 b8 9e 37 80 00 00 	movabs $0x80379e,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
  803941:	85 c0                	test   %eax,%eax
  803943:	74 07                	je     80394c <devpipe_read+0x77>
				return 0;
  803945:	b8 00 00 00 00       	mov    $0x0,%eax
  80394a:	eb 6d                	jmp    8039b9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80394c:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803953:	00 00 00 
  803956:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	8b 10                	mov    (%rax),%edx
  80395e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803962:	8b 40 04             	mov    0x4(%rax),%eax
  803965:	39 c2                	cmp    %eax,%edx
  803967:	74 ae                	je     803917 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80396d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803971:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803979:	8b 00                	mov    (%rax),%eax
  80397b:	99                   	cltd   
  80397c:	c1 ea 1b             	shr    $0x1b,%edx
  80397f:	01 d0                	add    %edx,%eax
  803981:	83 e0 1f             	and    $0x1f,%eax
  803984:	29 d0                	sub    %edx,%eax
  803986:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398a:	48 98                	cltq   
  80398c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803991:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803997:	8b 00                	mov    (%rax),%eax
  803999:	8d 50 01             	lea    0x1(%rax),%edx
  80399c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ab:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039af:	0f 82 60 ff ff ff    	jb     803915 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8039b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039b9:	c9                   	leaveq 
  8039ba:	c3                   	retq   

00000000008039bb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039bb:	55                   	push   %rbp
  8039bc:	48 89 e5             	mov    %rsp,%rbp
  8039bf:	48 83 ec 40          	sub    $0x40,%rsp
  8039c3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d3:	48 89 c7             	mov    %rax,%rdi
  8039d6:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
  8039e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039f5:	00 
  8039f6:	e9 8e 00 00 00       	jmpq   803a89 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039fb:	eb 31                	jmp    803a2e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a05:	48 89 d6             	mov    %rdx,%rsi
  803a08:	48 89 c7             	mov    %rax,%rdi
  803a0b:	48 b8 9e 37 80 00 00 	movabs $0x80379e,%rax
  803a12:	00 00 00 
  803a15:	ff d0                	callq  *%rax
  803a17:	85 c0                	test   %eax,%eax
  803a19:	74 07                	je     803a22 <devpipe_write+0x67>
				return 0;
  803a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a20:	eb 79                	jmp    803a9b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a22:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a32:	8b 40 04             	mov    0x4(%rax),%eax
  803a35:	48 63 d0             	movslq %eax,%rdx
  803a38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3c:	8b 00                	mov    (%rax),%eax
  803a3e:	48 98                	cltq   
  803a40:	48 83 c0 20          	add    $0x20,%rax
  803a44:	48 39 c2             	cmp    %rax,%rdx
  803a47:	73 b4                	jae    8039fd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4d:	8b 40 04             	mov    0x4(%rax),%eax
  803a50:	99                   	cltd   
  803a51:	c1 ea 1b             	shr    $0x1b,%edx
  803a54:	01 d0                	add    %edx,%eax
  803a56:	83 e0 1f             	and    $0x1f,%eax
  803a59:	29 d0                	sub    %edx,%eax
  803a5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a5f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a63:	48 01 ca             	add    %rcx,%rdx
  803a66:	0f b6 0a             	movzbl (%rdx),%ecx
  803a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6d:	48 98                	cltq   
  803a6f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	8b 40 04             	mov    0x4(%rax),%eax
  803a7a:	8d 50 01             	lea    0x1(%rax),%edx
  803a7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a81:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a84:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a8d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a91:	0f 82 64 ff ff ff    	jb     8039fb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a9b:	c9                   	leaveq 
  803a9c:	c3                   	retq   

0000000000803a9d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a9d:	55                   	push   %rbp
  803a9e:	48 89 e5             	mov    %rsp,%rbp
  803aa1:	48 83 ec 20          	sub    $0x20,%rsp
  803aa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803aa9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab1:	48 89 c7             	mov    %rax,%rdi
  803ab4:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ac4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ac8:	48 be e9 47 80 00 00 	movabs $0x8047e9,%rsi
  803acf:	00 00 00 
  803ad2:	48 89 c7             	mov    %rax,%rdi
  803ad5:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae5:	8b 50 04             	mov    0x4(%rax),%edx
  803ae8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aec:	8b 00                	mov    (%rax),%eax
  803aee:	29 c2                	sub    %eax,%edx
  803af0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803afa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afe:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b05:	00 00 00 
	stat->st_dev = &devpipe;
  803b08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b13:	00 00 00 
  803b16:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b22:	c9                   	leaveq 
  803b23:	c3                   	retq   

0000000000803b24 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b24:	55                   	push   %rbp
  803b25:	48 89 e5             	mov    %rsp,%rbp
  803b28:	48 83 ec 10          	sub    $0x10,%rsp
  803b2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b34:	48 89 c6             	mov    %rax,%rsi
  803b37:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3c:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803b43:	00 00 00 
  803b46:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4c:	48 89 c7             	mov    %rax,%rdi
  803b4f:	48 b8 bb 1d 80 00 00 	movabs $0x801dbb,%rax
  803b56:	00 00 00 
  803b59:	ff d0                	callq  *%rax
  803b5b:	48 89 c6             	mov    %rax,%rsi
  803b5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b63:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803b6a:	00 00 00 
  803b6d:	ff d0                	callq  *%rax
}
  803b6f:	c9                   	leaveq 
  803b70:	c3                   	retq   

0000000000803b71 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b71:	55                   	push   %rbp
  803b72:	48 89 e5             	mov    %rsp,%rbp
  803b75:	48 83 ec 20          	sub    $0x20,%rsp
  803b79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b82:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b86:	be 01 00 00 00       	mov    $0x1,%esi
  803b8b:	48 89 c7             	mov    %rax,%rdi
  803b8e:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803b95:	00 00 00 
  803b98:	ff d0                	callq  *%rax
}
  803b9a:	c9                   	leaveq 
  803b9b:	c3                   	retq   

0000000000803b9c <getchar>:

int
getchar(void)
{
  803b9c:	55                   	push   %rbp
  803b9d:	48 89 e5             	mov    %rsp,%rbp
  803ba0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ba4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ba8:	ba 01 00 00 00       	mov    $0x1,%edx
  803bad:	48 89 c6             	mov    %rax,%rsi
  803bb0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb5:	48 b8 b0 22 80 00 00 	movabs $0x8022b0,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
  803bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc8:	79 05                	jns    803bcf <getchar+0x33>
		return r;
  803bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcd:	eb 14                	jmp    803be3 <getchar+0x47>
	if (r < 1)
  803bcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bd3:	7f 07                	jg     803bdc <getchar+0x40>
		return -E_EOF;
  803bd5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bda:	eb 07                	jmp    803be3 <getchar+0x47>
	return c;
  803bdc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803be0:	0f b6 c0             	movzbl %al,%eax
}
  803be3:	c9                   	leaveq 
  803be4:	c3                   	retq   

0000000000803be5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803be5:	55                   	push   %rbp
  803be6:	48 89 e5             	mov    %rsp,%rbp
  803be9:	48 83 ec 20          	sub    $0x20,%rsp
  803bed:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bf0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bf4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf7:	48 89 d6             	mov    %rdx,%rsi
  803bfa:	89 c7                	mov    %eax,%edi
  803bfc:	48 b8 7e 1e 80 00 00 	movabs $0x801e7e,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
  803c08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c0f:	79 05                	jns    803c16 <iscons+0x31>
		return r;
  803c11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c14:	eb 1a                	jmp    803c30 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c1a:	8b 10                	mov    (%rax),%edx
  803c1c:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c23:	00 00 00 
  803c26:	8b 00                	mov    (%rax),%eax
  803c28:	39 c2                	cmp    %eax,%edx
  803c2a:	0f 94 c0             	sete   %al
  803c2d:	0f b6 c0             	movzbl %al,%eax
}
  803c30:	c9                   	leaveq 
  803c31:	c3                   	retq   

0000000000803c32 <opencons>:

int
opencons(void)
{
  803c32:	55                   	push   %rbp
  803c33:	48 89 e5             	mov    %rsp,%rbp
  803c36:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c3e:	48 89 c7             	mov    %rax,%rdi
  803c41:	48 b8 e6 1d 80 00 00 	movabs $0x801de6,%rax
  803c48:	00 00 00 
  803c4b:	ff d0                	callq  *%rax
  803c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c54:	79 05                	jns    803c5b <opencons+0x29>
		return r;
  803c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c59:	eb 5b                	jmp    803cb6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5f:	ba 07 04 00 00       	mov    $0x407,%edx
  803c64:	48 89 c6             	mov    %rax,%rsi
  803c67:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6c:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
  803c78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7f:	79 05                	jns    803c86 <opencons+0x54>
		return r;
  803c81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c84:	eb 30                	jmp    803cb6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8a:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c91:	00 00 00 
  803c94:	8b 12                	mov    (%rdx),%edx
  803c96:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca7:	48 89 c7             	mov    %rax,%rdi
  803caa:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
}
  803cb6:	c9                   	leaveq 
  803cb7:	c3                   	retq   

0000000000803cb8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cb8:	55                   	push   %rbp
  803cb9:	48 89 e5             	mov    %rsp,%rbp
  803cbc:	48 83 ec 30          	sub    $0x30,%rsp
  803cc0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cc8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ccc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cd1:	75 07                	jne    803cda <devcons_read+0x22>
		return 0;
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd8:	eb 4b                	jmp    803d25 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cda:	eb 0c                	jmp    803ce8 <devcons_read+0x30>
		sys_yield();
  803cdc:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ce8:	48 b8 23 18 80 00 00 	movabs $0x801823,%rax
  803cef:	00 00 00 
  803cf2:	ff d0                	callq  *%rax
  803cf4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfb:	74 df                	je     803cdc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803cfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d01:	79 05                	jns    803d08 <devcons_read+0x50>
		return c;
  803d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d06:	eb 1d                	jmp    803d25 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d08:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d0c:	75 07                	jne    803d15 <devcons_read+0x5d>
		return 0;
  803d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d13:	eb 10                	jmp    803d25 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d18:	89 c2                	mov    %eax,%edx
  803d1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d1e:	88 10                	mov    %dl,(%rax)
	return 1;
  803d20:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d25:	c9                   	leaveq 
  803d26:	c3                   	retq   

0000000000803d27 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d27:	55                   	push   %rbp
  803d28:	48 89 e5             	mov    %rsp,%rbp
  803d2b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d32:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d39:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d40:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d4e:	eb 76                	jmp    803dc6 <devcons_write+0x9f>
		m = n - tot;
  803d50:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d57:	89 c2                	mov    %eax,%edx
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	29 c2                	sub    %eax,%edx
  803d5e:	89 d0                	mov    %edx,%eax
  803d60:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d66:	83 f8 7f             	cmp    $0x7f,%eax
  803d69:	76 07                	jbe    803d72 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d6b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d75:	48 63 d0             	movslq %eax,%rdx
  803d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7b:	48 63 c8             	movslq %eax,%rcx
  803d7e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803d85:	48 01 c1             	add    %rax,%rcx
  803d88:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d8f:	48 89 ce             	mov    %rcx,%rsi
  803d92:	48 89 c7             	mov    %rax,%rdi
  803d95:	48 b8 16 13 80 00 00 	movabs $0x801316,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803da1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da4:	48 63 d0             	movslq %eax,%rdx
  803da7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dae:	48 89 d6             	mov    %rdx,%rsi
  803db1:	48 89 c7             	mov    %rax,%rdi
  803db4:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dc3:	01 45 fc             	add    %eax,-0x4(%rbp)
  803dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc9:	48 98                	cltq   
  803dcb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dd2:	0f 82 78 ff ff ff    	jb     803d50 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ddb:	c9                   	leaveq 
  803ddc:	c3                   	retq   

0000000000803ddd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ddd:	55                   	push   %rbp
  803dde:	48 89 e5             	mov    %rsp,%rbp
  803de1:	48 83 ec 08          	sub    $0x8,%rsp
  803de5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 83 ec 10          	sub    $0x10,%rsp
  803df8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dfc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e04:	48 be f5 47 80 00 00 	movabs $0x8047f5,%rsi
  803e0b:	00 00 00 
  803e0e:	48 89 c7             	mov    %rax,%rdi
  803e11:	48 b8 f2 0f 80 00 00 	movabs $0x800ff2,%rax
  803e18:	00 00 00 
  803e1b:	ff d0                	callq  *%rax
	return 0;
  803e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e22:	c9                   	leaveq 
  803e23:	c3                   	retq   

0000000000803e24 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e24:	55                   	push   %rbp
  803e25:	48 89 e5             	mov    %rsp,%rbp
  803e28:	48 83 ec 30          	sub    $0x30,%rsp
  803e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803e38:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e3f:	00 00 00 
  803e42:	48 8b 00             	mov    (%rax),%rax
  803e45:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803e4b:	85 c0                	test   %eax,%eax
  803e4d:	75 3c                	jne    803e8b <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803e4f:	48 b8 a5 18 80 00 00 	movabs $0x8018a5,%rax
  803e56:	00 00 00 
  803e59:	ff d0                	callq  *%rax
  803e5b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e60:	48 63 d0             	movslq %eax,%rdx
  803e63:	48 89 d0             	mov    %rdx,%rax
  803e66:	48 c1 e0 03          	shl    $0x3,%rax
  803e6a:	48 01 d0             	add    %rdx,%rax
  803e6d:	48 c1 e0 05          	shl    $0x5,%rax
  803e71:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803e78:	00 00 00 
  803e7b:	48 01 c2             	add    %rax,%rdx
  803e7e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e85:	00 00 00 
  803e88:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803e8b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e90:	75 0e                	jne    803ea0 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803e92:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e99:	00 00 00 
  803e9c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803ea0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea4:	48 89 c7             	mov    %rax,%rdi
  803ea7:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  803eae:	00 00 00 
  803eb1:	ff d0                	callq  *%rax
  803eb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803eb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eba:	79 19                	jns    803ed5 <ipc_recv+0xb1>
		*from_env_store = 0;
  803ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ec0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed3:	eb 53                	jmp    803f28 <ipc_recv+0x104>
	}
	if(from_env_store)
  803ed5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803eda:	74 19                	je     803ef5 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803edc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ee3:	00 00 00 
  803ee6:	48 8b 00             	mov    (%rax),%rax
  803ee9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef3:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803ef5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803efa:	74 19                	je     803f15 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803efc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f03:	00 00 00 
  803f06:	48 8b 00             	mov    (%rax),%rax
  803f09:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f13:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803f15:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f1c:	00 00 00 
  803f1f:	48 8b 00             	mov    (%rax),%rax
  803f22:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803f28:	c9                   	leaveq 
  803f29:	c3                   	retq   

0000000000803f2a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f2a:	55                   	push   %rbp
  803f2b:	48 89 e5             	mov    %rsp,%rbp
  803f2e:	48 83 ec 30          	sub    $0x30,%rsp
  803f32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f35:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f38:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f3c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803f3f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f44:	75 0e                	jne    803f54 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803f46:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f4d:	00 00 00 
  803f50:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803f54:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f57:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f5a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f61:	89 c7                	mov    %eax,%edi
  803f63:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  803f6a:	00 00 00 
  803f6d:	ff d0                	callq  *%rax
  803f6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803f72:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f76:	75 0c                	jne    803f84 <ipc_send+0x5a>
			sys_yield();
  803f78:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803f7f:	00 00 00 
  803f82:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803f84:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f88:	74 ca                	je     803f54 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803f8a:	c9                   	leaveq 
  803f8b:	c3                   	retq   

0000000000803f8c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f8c:	55                   	push   %rbp
  803f8d:	48 89 e5             	mov    %rsp,%rbp
  803f90:	48 83 ec 14          	sub    $0x14,%rsp
  803f94:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f9e:	eb 5e                	jmp    803ffe <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803fa0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fa7:	00 00 00 
  803faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fad:	48 63 d0             	movslq %eax,%rdx
  803fb0:	48 89 d0             	mov    %rdx,%rax
  803fb3:	48 c1 e0 03          	shl    $0x3,%rax
  803fb7:	48 01 d0             	add    %rdx,%rax
  803fba:	48 c1 e0 05          	shl    $0x5,%rax
  803fbe:	48 01 c8             	add    %rcx,%rax
  803fc1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fc7:	8b 00                	mov    (%rax),%eax
  803fc9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fcc:	75 2c                	jne    803ffa <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fce:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fd5:	00 00 00 
  803fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdb:	48 63 d0             	movslq %eax,%rdx
  803fde:	48 89 d0             	mov    %rdx,%rax
  803fe1:	48 c1 e0 03          	shl    $0x3,%rax
  803fe5:	48 01 d0             	add    %rdx,%rax
  803fe8:	48 c1 e0 05          	shl    $0x5,%rax
  803fec:	48 01 c8             	add    %rcx,%rax
  803fef:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ff5:	8b 40 08             	mov    0x8(%rax),%eax
  803ff8:	eb 12                	jmp    80400c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ffe:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804005:	7e 99                	jle    803fa0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80400c:	c9                   	leaveq 
  80400d:	c3                   	retq   

000000000080400e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80400e:	55                   	push   %rbp
  80400f:	48 89 e5             	mov    %rsp,%rbp
  804012:	48 83 ec 18          	sub    $0x18,%rsp
  804016:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80401a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80401e:	48 c1 e8 15          	shr    $0x15,%rax
  804022:	48 89 c2             	mov    %rax,%rdx
  804025:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80402c:	01 00 00 
  80402f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804033:	83 e0 01             	and    $0x1,%eax
  804036:	48 85 c0             	test   %rax,%rax
  804039:	75 07                	jne    804042 <pageref+0x34>
		return 0;
  80403b:	b8 00 00 00 00       	mov    $0x0,%eax
  804040:	eb 53                	jmp    804095 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804046:	48 c1 e8 0c          	shr    $0xc,%rax
  80404a:	48 89 c2             	mov    %rax,%rdx
  80404d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804054:	01 00 00 
  804057:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80405b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80405f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804063:	83 e0 01             	and    $0x1,%eax
  804066:	48 85 c0             	test   %rax,%rax
  804069:	75 07                	jne    804072 <pageref+0x64>
		return 0;
  80406b:	b8 00 00 00 00       	mov    $0x0,%eax
  804070:	eb 23                	jmp    804095 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804076:	48 c1 e8 0c          	shr    $0xc,%rax
  80407a:	48 89 c2             	mov    %rax,%rdx
  80407d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804084:	00 00 00 
  804087:	48 c1 e2 04          	shl    $0x4,%rdx
  80408b:	48 01 d0             	add    %rdx,%rax
  80408e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804092:	0f b7 c0             	movzwl %ax,%eax
}
  804095:	c9                   	leaveq 
  804096:	c3                   	retq   
