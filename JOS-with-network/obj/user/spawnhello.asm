
obj/user/spawnhello.debug:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 5e 4a 80 00 00 	movabs $0x804a5e,%rsi
  80008e:	00 00 00 
  800091:	48 bf 64 4a 80 00 00 	movabs $0x804a64,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 48 2f 80 00 00 	movabs $0x802f48,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 6f 4a 80 00 00 	movabs $0x804a6f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 87 4a 80 00 00 	movabs $0x804a87,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	25 ff 03 00 00       	and    $0x3ff,%eax
  800107:	48 63 d0             	movslq %eax,%rdx
  80010a:	48 89 d0             	mov    %rdx,%rax
  80010d:	48 c1 e0 03          	shl    $0x3,%rax
  800111:	48 01 d0             	add    %rdx,%rax
  800114:	48 c1 e0 05          	shl    $0x5,%rax
  800118:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80011f:	00 00 00 
  800122:	48 01 c2             	add    %rax,%rdx
  800125:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80012c:	00 00 00 
  80012f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800132:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800136:	7e 14                	jle    80014c <libmain+0x65>
		binaryname = argv[0];
  800138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013c:	48 8b 10             	mov    (%rax),%rdx
  80013f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800146:	00 00 00 
  800149:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80014c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	48 89 d6             	mov    %rdx,%rsi
  800156:	89 c7                	mov    %eax,%edi
  800158:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80015f:	00 00 00 
  800162:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800164:	48 b8 72 01 80 00 00 	movabs $0x800172,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
}
  800170:	c9                   	leaveq 
  800171:	c3                   	retq   

0000000000800172 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800172:	55                   	push   %rbp
  800173:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800176:	48 b8 2a 1f 80 00 00 	movabs $0x801f2a,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800182:	bf 00 00 00 00       	mov    $0x0,%edi
  800187:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80018e:	00 00 00 
  800191:	ff d0                	callq  *%rax

}
  800193:	5d                   	pop    %rbp
  800194:	c3                   	retq   

0000000000800195 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800195:	55                   	push   %rbp
  800196:	48 89 e5             	mov    %rsp,%rbp
  800199:	53                   	push   %rbx
  80019a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001a1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001a8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001ae:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001b5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001bc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c3:	84 c0                	test   %al,%al
  8001c5:	74 23                	je     8001ea <_panic+0x55>
  8001c7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001ce:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001d6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001da:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001de:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001e6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001ea:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001f1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001f8:	00 00 00 
  8001fb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800202:	00 00 00 
  800205:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800209:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800210:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800217:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80021e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800225:	00 00 00 
  800228:	48 8b 18             	mov    (%rax),%rbx
  80022b:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
  800237:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80023d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800244:	41 89 c8             	mov    %ecx,%r8d
  800247:	48 89 d1             	mov    %rdx,%rcx
  80024a:	48 89 da             	mov    %rbx,%rdx
  80024d:	89 c6                	mov    %eax,%esi
  80024f:	48 bf a8 4a 80 00 00 	movabs $0x804aa8,%rdi
  800256:	00 00 00 
  800259:	b8 00 00 00 00       	mov    $0x0,%eax
  80025e:	49 b9 ce 03 80 00 00 	movabs $0x8003ce,%r9
  800265:	00 00 00 
  800268:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800272:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800279:	48 89 d6             	mov    %rdx,%rsi
  80027c:	48 89 c7             	mov    %rax,%rdi
  80027f:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
	cprintf("\n");
  80028b:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  800292:	00 00 00 
  800295:	b8 00 00 00 00       	mov    $0x0,%eax
  80029a:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  8002a1:	00 00 00 
  8002a4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a6:	cc                   	int3   
  8002a7:	eb fd                	jmp    8002a6 <_panic+0x111>

00000000008002a9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a9:	55                   	push   %rbp
  8002aa:	48 89 e5             	mov    %rsp,%rbp
  8002ad:	48 83 ec 10          	sub    $0x10,%rsp
  8002b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bc:	8b 00                	mov    (%rax),%eax
  8002be:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c5:	89 0a                	mov    %ecx,(%rdx)
  8002c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002ca:	89 d1                	mov    %edx,%ecx
  8002cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d0:	48 98                	cltq   
  8002d2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002da:	8b 00                	mov    (%rax),%eax
  8002dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e1:	75 2c                	jne    80030f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e7:	8b 00                	mov    (%rax),%eax
  8002e9:	48 98                	cltq   
  8002eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ef:	48 83 c2 08          	add    $0x8,%rdx
  8002f3:	48 89 c6             	mov    %rax,%rsi
  8002f6:	48 89 d7             	mov    %rdx,%rdi
  8002f9:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
        b->idx = 0;
  800305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800309:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80030f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800313:	8b 40 04             	mov    0x4(%rax),%eax
  800316:	8d 50 01             	lea    0x1(%rax),%edx
  800319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800320:	c9                   	leaveq 
  800321:	c3                   	retq   

0000000000800322 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80032d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800334:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80033b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800342:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800349:	48 8b 0a             	mov    (%rdx),%rcx
  80034c:	48 89 08             	mov    %rcx,(%rax)
  80034f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800353:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800357:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80035f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800366:	00 00 00 
    b.cnt = 0;
  800369:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800370:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800373:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800381:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800388:	48 89 c6             	mov    %rax,%rsi
  80038b:	48 bf a9 02 80 00 00 	movabs $0x8002a9,%rdi
  800392:	00 00 00 
  800395:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a7:	48 98                	cltq   
  8003a9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b0:	48 83 c2 08          	add    $0x8,%rdx
  8003b4:	48 89 c6             	mov    %rax,%rsi
  8003b7:	48 89 d7             	mov    %rdx,%rdi
  8003ba:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  8003c1:	00 00 00 
  8003c4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ee:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003fc:	84 c0                	test   %al,%al
  8003fe:	74 20                	je     800420 <cprintf+0x52>
  800400:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800404:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800408:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800410:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800414:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800418:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800420:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800427:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042e:	00 00 00 
  800431:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800438:	00 00 00 
  80043b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800446:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80044d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800454:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80045b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800462:	48 8b 0a             	mov    (%rdx),%rcx
  800465:	48 89 08             	mov    %rcx,(%rax)
  800468:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800470:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800474:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800478:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80047f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800486:	48 89 d6             	mov    %rdx,%rsi
  800489:	48 89 c7             	mov    %rax,%rdi
  80048c:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800493:	00 00 00 
  800496:	ff d0                	callq  *%rax
  800498:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a4:	c9                   	leaveq 
  8004a5:	c3                   	retq   

00000000008004a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a6:	55                   	push   %rbp
  8004a7:	48 89 e5             	mov    %rsp,%rbp
  8004aa:	53                   	push   %rbx
  8004ab:	48 83 ec 38          	sub    $0x38,%rsp
  8004af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004bb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004be:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c2:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004cd:	77 3b                	ja     80050a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cf:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d2:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d6:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	48 f7 f3             	div    %rbx
  8004e5:	48 89 c2             	mov    %rax,%rdx
  8004e8:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004eb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ee:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f6:	41 89 f9             	mov    %edi,%r9d
  8004f9:	48 89 c7             	mov    %rax,%rdi
  8004fc:	48 b8 a6 04 80 00 00 	movabs $0x8004a6,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
  800508:	eb 1e                	jmp    800528 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050a:	eb 12                	jmp    80051e <printnum+0x78>
			putch(padc, putdat);
  80050c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800510:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800517:	48 89 ce             	mov    %rcx,%rsi
  80051a:	89 d7                	mov    %edx,%edi
  80051c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800522:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800526:	7f e4                	jg     80050c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800528:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80052b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80052f:	ba 00 00 00 00       	mov    $0x0,%edx
  800534:	48 f7 f1             	div    %rcx
  800537:	48 89 d0             	mov    %rdx,%rax
  80053a:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  800541:	00 00 00 
  800544:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800548:	0f be d0             	movsbl %al,%edx
  80054b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 89 ce             	mov    %rcx,%rsi
  800556:	89 d7                	mov    %edx,%edi
  800558:	ff d0                	callq  *%rax
}
  80055a:	48 83 c4 38          	add    $0x38,%rsp
  80055e:	5b                   	pop    %rbx
  80055f:	5d                   	pop    %rbp
  800560:	c3                   	retq   

0000000000800561 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800561:	55                   	push   %rbp
  800562:	48 89 e5             	mov    %rsp,%rbp
  800565:	48 83 ec 1c          	sub    $0x1c,%rsp
  800569:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800570:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800574:	7e 52                	jle    8005c8 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057a:	8b 00                	mov    (%rax),%eax
  80057c:	83 f8 30             	cmp    $0x30,%eax
  80057f:	73 24                	jae    8005a5 <getuint+0x44>
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058d:	8b 00                	mov    (%rax),%eax
  80058f:	89 c0                	mov    %eax,%eax
  800591:	48 01 d0             	add    %rdx,%rax
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	8b 12                	mov    (%rdx),%edx
  80059a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	89 0a                	mov    %ecx,(%rdx)
  8005a3:	eb 17                	jmp    8005bc <getuint+0x5b>
  8005a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ad:	48 89 d0             	mov    %rdx,%rax
  8005b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bc:	48 8b 00             	mov    (%rax),%rax
  8005bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c3:	e9 a3 00 00 00       	jmpq   80066b <getuint+0x10a>
	else if (lflag)
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005cc:	74 4f                	je     80061d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	83 f8 30             	cmp    $0x30,%eax
  8005d7:	73 24                	jae    8005fd <getuint+0x9c>
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	8b 00                	mov    (%rax),%eax
  8005e7:	89 c0                	mov    %eax,%eax
  8005e9:	48 01 d0             	add    %rdx,%rax
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	8b 12                	mov    (%rdx),%edx
  8005f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	89 0a                	mov    %ecx,(%rdx)
  8005fb:	eb 17                	jmp    800614 <getuint+0xb3>
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800605:	48 89 d0             	mov    %rdx,%rax
  800608:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800614:	48 8b 00             	mov    (%rax),%rax
  800617:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061b:	eb 4e                	jmp    80066b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	8b 00                	mov    (%rax),%eax
  800623:	83 f8 30             	cmp    $0x30,%eax
  800626:	73 24                	jae    80064c <getuint+0xeb>
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	89 c0                	mov    %eax,%eax
  800638:	48 01 d0             	add    %rdx,%rax
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	8b 12                	mov    (%rdx),%edx
  800641:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	89 0a                	mov    %ecx,(%rdx)
  80064a:	eb 17                	jmp    800663 <getuint+0x102>
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800654:	48 89 d0             	mov    %rdx,%rax
  800657:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800663:	8b 00                	mov    (%rax),%eax
  800665:	89 c0                	mov    %eax,%eax
  800667:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80066b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80066f:	c9                   	leaveq 
  800670:	c3                   	retq   

0000000000800671 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800671:	55                   	push   %rbp
  800672:	48 89 e5             	mov    %rsp,%rbp
  800675:	48 83 ec 1c          	sub    $0x1c,%rsp
  800679:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800680:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800684:	7e 52                	jle    8006d8 <getint+0x67>
		x=va_arg(*ap, long long);
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	8b 00                	mov    (%rax),%eax
  80068c:	83 f8 30             	cmp    $0x30,%eax
  80068f:	73 24                	jae    8006b5 <getint+0x44>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	8b 00                	mov    (%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a8:	8b 12                	mov    (%rdx),%edx
  8006aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	89 0a                	mov    %ecx,(%rdx)
  8006b3:	eb 17                	jmp    8006cc <getint+0x5b>
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bd:	48 89 d0             	mov    %rdx,%rax
  8006c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cc:	48 8b 00             	mov    (%rax),%rax
  8006cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d3:	e9 a3 00 00 00       	jmpq   80077b <getint+0x10a>
	else if (lflag)
  8006d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006dc:	74 4f                	je     80072d <getint+0xbc>
		x=va_arg(*ap, long);
  8006de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	83 f8 30             	cmp    $0x30,%eax
  8006e7:	73 24                	jae    80070d <getint+0x9c>
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	89 c0                	mov    %eax,%eax
  8006f9:	48 01 d0             	add    %rdx,%rax
  8006fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800700:	8b 12                	mov    (%rdx),%edx
  800702:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	89 0a                	mov    %ecx,(%rdx)
  80070b:	eb 17                	jmp    800724 <getint+0xb3>
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800715:	48 89 d0             	mov    %rdx,%rax
  800718:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800720:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800724:	48 8b 00             	mov    (%rax),%rax
  800727:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072b:	eb 4e                	jmp    80077b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80072d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800731:	8b 00                	mov    (%rax),%eax
  800733:	83 f8 30             	cmp    $0x30,%eax
  800736:	73 24                	jae    80075c <getint+0xeb>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	8b 00                	mov    (%rax),%eax
  800746:	89 c0                	mov    %eax,%eax
  800748:	48 01 d0             	add    %rdx,%rax
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	8b 12                	mov    (%rdx),%edx
  800751:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	89 0a                	mov    %ecx,(%rdx)
  80075a:	eb 17                	jmp    800773 <getint+0x102>
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800764:	48 89 d0             	mov    %rdx,%rax
  800767:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800773:	8b 00                	mov    (%rax),%eax
  800775:	48 98                	cltq   
  800777:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077f:	c9                   	leaveq 
  800780:	c3                   	retq   

0000000000800781 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800781:	55                   	push   %rbp
  800782:	48 89 e5             	mov    %rsp,%rbp
  800785:	41 54                	push   %r12
  800787:	53                   	push   %rbx
  800788:	48 83 ec 60          	sub    $0x60,%rsp
  80078c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800790:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800794:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800798:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80079c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a4:	48 8b 0a             	mov    (%rdx),%rcx
  8007a7:	48 89 08             	mov    %rcx,(%rax)
  8007aa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ae:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ba:	eb 17                	jmp    8007d3 <vprintfmt+0x52>
			if (ch == '\0')
  8007bc:	85 db                	test   %ebx,%ebx
  8007be:	0f 84 cc 04 00 00    	je     800c90 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	89 df                	mov    %ebx,%edi
  8007d1:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007db:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007df:	0f b6 00             	movzbl (%rax),%eax
  8007e2:	0f b6 d8             	movzbl %al,%ebx
  8007e5:	83 fb 25             	cmp    $0x25,%ebx
  8007e8:	75 d2                	jne    8007bc <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ea:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007ee:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800803:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80080e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800812:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800816:	0f b6 00             	movzbl (%rax),%eax
  800819:	0f b6 d8             	movzbl %al,%ebx
  80081c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80081f:	83 f8 55             	cmp    $0x55,%eax
  800822:	0f 87 34 04 00 00    	ja     800c5c <vprintfmt+0x4db>
  800828:	89 c0                	mov    %eax,%eax
  80082a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800831:	00 
  800832:	48 b8 f8 4c 80 00 00 	movabs $0x804cf8,%rax
  800839:	00 00 00 
  80083c:	48 01 d0             	add    %rdx,%rax
  80083f:	48 8b 00             	mov    (%rax),%rax
  800842:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800844:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800848:	eb c0                	jmp    80080a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80084e:	eb ba                	jmp    80080a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800850:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800857:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80085a:	89 d0                	mov    %edx,%eax
  80085c:	c1 e0 02             	shl    $0x2,%eax
  80085f:	01 d0                	add    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d8                	add    %ebx,%eax
  800865:	83 e8 30             	sub    $0x30,%eax
  800868:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80086b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086f:	0f b6 00             	movzbl (%rax),%eax
  800872:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800875:	83 fb 2f             	cmp    $0x2f,%ebx
  800878:	7e 0c                	jle    800886 <vprintfmt+0x105>
  80087a:	83 fb 39             	cmp    $0x39,%ebx
  80087d:	7f 07                	jg     800886 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800884:	eb d1                	jmp    800857 <vprintfmt+0xd6>
			goto process_precision;
  800886:	eb 58                	jmp    8008e0 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800888:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088b:	83 f8 30             	cmp    $0x30,%eax
  80088e:	73 17                	jae    8008a7 <vprintfmt+0x126>
  800890:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800894:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800897:	89 c0                	mov    %eax,%eax
  800899:	48 01 d0             	add    %rdx,%rax
  80089c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089f:	83 c2 08             	add    $0x8,%edx
  8008a2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a5:	eb 0f                	jmp    8008b6 <vprintfmt+0x135>
  8008a7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ab:	48 89 d0             	mov    %rdx,%rax
  8008ae:	48 83 c2 08          	add    $0x8,%rdx
  8008b2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008bb:	eb 23                	jmp    8008e0 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c1:	79 0c                	jns    8008cf <vprintfmt+0x14e>
				width = 0;
  8008c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008ca:	e9 3b ff ff ff       	jmpq   80080a <vprintfmt+0x89>
  8008cf:	e9 36 ff ff ff       	jmpq   80080a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008db:	e9 2a ff ff ff       	jmpq   80080a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e4:	79 12                	jns    8008f8 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008ec:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f3:	e9 12 ff ff ff       	jmpq   80080a <vprintfmt+0x89>
  8008f8:	e9 0d ff ff ff       	jmpq   80080a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fd:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800901:	e9 04 ff ff ff       	jmpq   80080a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800906:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800909:	83 f8 30             	cmp    $0x30,%eax
  80090c:	73 17                	jae    800925 <vprintfmt+0x1a4>
  80090e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800912:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800915:	89 c0                	mov    %eax,%eax
  800917:	48 01 d0             	add    %rdx,%rax
  80091a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091d:	83 c2 08             	add    $0x8,%edx
  800920:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x1b3>
  800925:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800929:	48 89 d0             	mov    %rdx,%rax
  80092c:	48 83 c2 08          	add    $0x8,%rdx
  800930:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800934:	8b 10                	mov    (%rax),%edx
  800936:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80093a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093e:	48 89 ce             	mov    %rcx,%rsi
  800941:	89 d7                	mov    %edx,%edi
  800943:	ff d0                	callq  *%rax
			break;
  800945:	e9 40 03 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 17                	jae    800969 <vprintfmt+0x1e8>
  800952:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800961:	83 c2 08             	add    $0x8,%edx
  800964:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800967:	eb 0f                	jmp    800978 <vprintfmt+0x1f7>
  800969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096d:	48 89 d0             	mov    %rdx,%rax
  800970:	48 83 c2 08          	add    $0x8,%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80097a:	85 db                	test   %ebx,%ebx
  80097c:	79 02                	jns    800980 <vprintfmt+0x1ff>
				err = -err;
  80097e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800980:	83 fb 15             	cmp    $0x15,%ebx
  800983:	7f 16                	jg     80099b <vprintfmt+0x21a>
  800985:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  80098c:	00 00 00 
  80098f:	48 63 d3             	movslq %ebx,%rdx
  800992:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800996:	4d 85 e4             	test   %r12,%r12
  800999:	75 2e                	jne    8009c9 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80099b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	89 d9                	mov    %ebx,%ecx
  8009a5:	48 ba e1 4c 80 00 00 	movabs $0x804ce1,%rdx
  8009ac:	00 00 00 
  8009af:	48 89 c7             	mov    %rax,%rdi
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	49 b8 99 0c 80 00 00 	movabs $0x800c99,%r8
  8009be:	00 00 00 
  8009c1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c4:	e9 c1 02 00 00       	jmpq   800c8a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d1:	4c 89 e1             	mov    %r12,%rcx
  8009d4:	48 ba ea 4c 80 00 00 	movabs $0x804cea,%rdx
  8009db:	00 00 00 
  8009de:	48 89 c7             	mov    %rax,%rdi
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e6:	49 b8 99 0c 80 00 00 	movabs $0x800c99,%r8
  8009ed:	00 00 00 
  8009f0:	41 ff d0             	callq  *%r8
			break;
  8009f3:	e9 92 02 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fb:	83 f8 30             	cmp    $0x30,%eax
  8009fe:	73 17                	jae    800a17 <vprintfmt+0x296>
  800a00:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a07:	89 c0                	mov    %eax,%eax
  800a09:	48 01 d0             	add    %rdx,%rax
  800a0c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0f:	83 c2 08             	add    $0x8,%edx
  800a12:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a15:	eb 0f                	jmp    800a26 <vprintfmt+0x2a5>
  800a17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1b:	48 89 d0             	mov    %rdx,%rax
  800a1e:	48 83 c2 08          	add    $0x8,%rdx
  800a22:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a26:	4c 8b 20             	mov    (%rax),%r12
  800a29:	4d 85 e4             	test   %r12,%r12
  800a2c:	75 0a                	jne    800a38 <vprintfmt+0x2b7>
				p = "(null)";
  800a2e:	49 bc ed 4c 80 00 00 	movabs $0x804ced,%r12
  800a35:	00 00 00 
			if (width > 0 && padc != '-')
  800a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3c:	7e 3f                	jle    800a7d <vprintfmt+0x2fc>
  800a3e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a42:	74 39                	je     800a7d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a44:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a47:	48 98                	cltq   
  800a49:	48 89 c6             	mov    %rax,%rsi
  800a4c:	4c 89 e7             	mov    %r12,%rdi
  800a4f:	48 b8 45 0f 80 00 00 	movabs $0x800f45,%rax
  800a56:	00 00 00 
  800a59:	ff d0                	callq  *%rax
  800a5b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a5e:	eb 17                	jmp    800a77 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a60:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a64:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6c:	48 89 ce             	mov    %rcx,%rsi
  800a6f:	89 d7                	mov    %edx,%edi
  800a71:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a7b:	7f e3                	jg     800a60 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7d:	eb 37                	jmp    800ab6 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a83:	74 1e                	je     800aa3 <vprintfmt+0x322>
  800a85:	83 fb 1f             	cmp    $0x1f,%ebx
  800a88:	7e 05                	jle    800a8f <vprintfmt+0x30e>
  800a8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a8d:	7e 14                	jle    800aa3 <vprintfmt+0x322>
					putch('?', putdat);
  800a8f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	48 89 d6             	mov    %rdx,%rsi
  800a9a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a9f:	ff d0                	callq  *%rax
  800aa1:	eb 0f                	jmp    800ab2 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aab:	48 89 d6             	mov    %rdx,%rsi
  800aae:	89 df                	mov    %ebx,%edi
  800ab0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab6:	4c 89 e0             	mov    %r12,%rax
  800ab9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800abd:	0f b6 00             	movzbl (%rax),%eax
  800ac0:	0f be d8             	movsbl %al,%ebx
  800ac3:	85 db                	test   %ebx,%ebx
  800ac5:	74 10                	je     800ad7 <vprintfmt+0x356>
  800ac7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800acb:	78 b2                	js     800a7f <vprintfmt+0x2fe>
  800acd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad5:	79 a8                	jns    800a7f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad7:	eb 16                	jmp    800aef <vprintfmt+0x36e>
				putch(' ', putdat);
  800ad9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800add:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae1:	48 89 d6             	mov    %rdx,%rsi
  800ae4:	bf 20 00 00 00       	mov    $0x20,%edi
  800ae9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aeb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af3:	7f e4                	jg     800ad9 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af5:	e9 90 01 00 00       	jmpq   800c8a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800afa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afe:	be 03 00 00 00       	mov    $0x3,%esi
  800b03:	48 89 c7             	mov    %rax,%rdi
  800b06:	48 b8 71 06 80 00 00 	movabs $0x800671,%rax
  800b0d:	00 00 00 
  800b10:	ff d0                	callq  *%rax
  800b12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1a:	48 85 c0             	test   %rax,%rax
  800b1d:	79 1d                	jns    800b3c <vprintfmt+0x3bb>
				putch('-', putdat);
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b2f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b35:	48 f7 d8             	neg    %rax
  800b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b3c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b43:	e9 d5 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b48:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4c:	be 03 00 00 00       	mov    $0x3,%esi
  800b51:	48 89 c7             	mov    %rax,%rdi
  800b54:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  800b5b:	00 00 00 
  800b5e:	ff d0                	callq  *%rax
  800b60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b64:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b6b:	e9 ad 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b70:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b77:	89 d6                	mov    %edx,%esi
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	48 b8 71 06 80 00 00 	movabs $0x800671,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	callq  *%rax
  800b88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b8c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b93:	e9 85 00 00 00       	jmpq   800c1d <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	48 89 d6             	mov    %rdx,%rsi
  800ba3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800baa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb2:	48 89 d6             	mov    %rdx,%rsi
  800bb5:	bf 78 00 00 00       	mov    $0x78,%edi
  800bba:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbf:	83 f8 30             	cmp    $0x30,%eax
  800bc2:	73 17                	jae    800bdb <vprintfmt+0x45a>
  800bc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcb:	89 c0                	mov    %eax,%eax
  800bcd:	48 01 d0             	add    %rdx,%rax
  800bd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd3:	83 c2 08             	add    $0x8,%edx
  800bd6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd9:	eb 0f                	jmp    800bea <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bdb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdf:	48 89 d0             	mov    %rdx,%rax
  800be2:	48 83 c2 08          	add    $0x8,%rdx
  800be6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bea:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf8:	eb 23                	jmp    800c1d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bfa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfe:	be 03 00 00 00       	mov    $0x3,%esi
  800c03:	48 89 c7             	mov    %rax,%rdi
  800c06:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  800c0d:	00 00 00 
  800c10:	ff d0                	callq  *%rax
  800c12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c16:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c1d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c22:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c25:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c34:	45 89 c1             	mov    %r8d,%r9d
  800c37:	41 89 f8             	mov    %edi,%r8d
  800c3a:	48 89 c7             	mov    %rax,%rdi
  800c3d:	48 b8 a6 04 80 00 00 	movabs $0x8004a6,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
			break;
  800c49:	eb 3f                	jmp    800c8a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c53:	48 89 d6             	mov    %rdx,%rsi
  800c56:	89 df                	mov    %ebx,%edi
  800c58:	ff d0                	callq  *%rax
			break;
  800c5a:	eb 2e                	jmp    800c8a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 25 00 00 00       	mov    $0x25,%edi
  800c6c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c73:	eb 05                	jmp    800c7a <vprintfmt+0x4f9>
  800c75:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7e:	48 83 e8 01          	sub    $0x1,%rax
  800c82:	0f b6 00             	movzbl (%rax),%eax
  800c85:	3c 25                	cmp    $0x25,%al
  800c87:	75 ec                	jne    800c75 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c89:	90                   	nop
		}
	}
  800c8a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c8b:	e9 43 fb ff ff       	jmpq   8007d3 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c90:	48 83 c4 60          	add    $0x60,%rsp
  800c94:	5b                   	pop    %rbx
  800c95:	41 5c                	pop    %r12
  800c97:	5d                   	pop    %rbp
  800c98:	c3                   	retq   

0000000000800c99 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c99:	55                   	push   %rbp
  800c9a:	48 89 e5             	mov    %rsp,%rbp
  800c9d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cab:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cb2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc7:	84 c0                	test   %al,%al
  800cc9:	74 20                	je     800ceb <printfmt+0x52>
  800ccb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ccf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cd3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cdb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cdf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ce3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ceb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cf2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf9:	00 00 00 
  800cfc:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d03:	00 00 00 
  800d06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d11:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d18:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d26:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d2d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d34:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d3b:	48 89 c7             	mov    %rax,%rdi
  800d3e:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d4a:	c9                   	leaveq 
  800d4b:	c3                   	retq   

0000000000800d4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d4c:	55                   	push   %rbp
  800d4d:	48 89 e5             	mov    %rsp,%rbp
  800d50:	48 83 ec 10          	sub    $0x10,%rsp
  800d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5f:	8b 40 10             	mov    0x10(%rax),%eax
  800d62:	8d 50 01             	lea    0x1(%rax),%edx
  800d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d69:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d70:	48 8b 10             	mov    (%rax),%rdx
  800d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d77:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d7b:	48 39 c2             	cmp    %rax,%rdx
  800d7e:	73 17                	jae    800d97 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d84:	48 8b 00             	mov    (%rax),%rax
  800d87:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d8f:	48 89 0a             	mov    %rcx,(%rdx)
  800d92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d95:	88 10                	mov    %dl,(%rax)
}
  800d97:	c9                   	leaveq 
  800d98:	c3                   	retq   

0000000000800d99 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d99:	55                   	push   %rbp
  800d9a:	48 89 e5             	mov    %rsp,%rbp
  800d9d:	48 83 ec 50          	sub    $0x50,%rsp
  800da1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dac:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db8:	48 8b 0a             	mov    (%rdx),%rcx
  800dbb:	48 89 08             	mov    %rcx,(%rax)
  800dbe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dca:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd9:	48 98                	cltq   
  800ddb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ddf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de3:	48 01 d0             	add    %rdx,%rax
  800de6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800dea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800df1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df6:	74 06                	je     800dfe <vsnprintf+0x65>
  800df8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800dfc:	7f 07                	jg     800e05 <vsnprintf+0x6c>
		return -E_INVAL;
  800dfe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e03:	eb 2f                	jmp    800e34 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e05:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e09:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e0d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e11:	48 89 c6             	mov    %rax,%rsi
  800e14:	48 bf 4c 0d 80 00 00 	movabs $0x800d4c,%rdi
  800e1b:	00 00 00 
  800e1e:	48 b8 81 07 80 00 00 	movabs $0x800781,%rax
  800e25:	00 00 00 
  800e28:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e31:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e34:	c9                   	leaveq 
  800e35:	c3                   	retq   

0000000000800e36 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e36:	55                   	push   %rbp
  800e37:	48 89 e5             	mov    %rsp,%rbp
  800e3a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e41:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e48:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e55:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e63:	84 c0                	test   %al,%al
  800e65:	74 20                	je     800e87 <snprintf+0x51>
  800e67:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e73:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e77:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e83:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e87:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e95:	00 00 00 
  800e98:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9f:	00 00 00 
  800ea2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ead:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ebb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ec2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec9:	48 8b 0a             	mov    (%rdx),%rcx
  800ecc:	48 89 08             	mov    %rcx,(%rax)
  800ecf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800edb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800edf:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800eed:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ef3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800efa:	48 89 c7             	mov    %rax,%rdi
  800efd:	48 b8 99 0d 80 00 00 	movabs $0x800d99,%rax
  800f04:	00 00 00 
  800f07:	ff d0                	callq  *%rax
  800f09:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 83 ec 18          	sub    $0x18,%rsp
  800f1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2a:	eb 09                	jmp    800f35 <strlen+0x1e>
		n++;
  800f2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f30:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	0f b6 00             	movzbl (%rax),%eax
  800f3c:	84 c0                	test   %al,%al
  800f3e:	75 ec                	jne    800f2c <strlen+0x15>
		n++;
	return n;
  800f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 20          	sub    $0x20,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f5c:	eb 0e                	jmp    800f6c <strnlen+0x27>
		n++;
  800f5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f62:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f67:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f6c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f71:	74 0b                	je     800f7e <strnlen+0x39>
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	84 c0                	test   %al,%al
  800f7c:	75 e0                	jne    800f5e <strnlen+0x19>
		n++;
	return n;
  800f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f81:	c9                   	leaveq 
  800f82:	c3                   	retq   

0000000000800f83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f83:	55                   	push   %rbp
  800f84:	48 89 e5             	mov    %rsp,%rbp
  800f87:	48 83 ec 20          	sub    $0x20,%rsp
  800f8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f9b:	90                   	nop
  800f9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fac:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb4:	0f b6 12             	movzbl (%rdx),%edx
  800fb7:	88 10                	mov    %dl,(%rax)
  800fb9:	0f b6 00             	movzbl (%rax),%eax
  800fbc:	84 c0                	test   %al,%al
  800fbe:	75 dc                	jne    800f9c <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc4:	c9                   	leaveq 
  800fc5:	c3                   	retq   

0000000000800fc6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 83 ec 20          	sub    $0x20,%rsp
  800fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 89 c7             	mov    %rax,%rdi
  800fdd:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
  800fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fef:	48 63 d0             	movslq %eax,%rdx
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	48 01 c2             	add    %rax,%rdx
  800ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ffd:	48 89 c6             	mov    %rax,%rsi
  801000:	48 89 d7             	mov    %rdx,%rdi
  801003:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  80100a:	00 00 00 
  80100d:	ff d0                	callq  *%rax
	return dst;
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801013:	c9                   	leaveq 
  801014:	c3                   	retq   

0000000000801015 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801015:	55                   	push   %rbp
  801016:	48 89 e5             	mov    %rsp,%rbp
  801019:	48 83 ec 28          	sub    $0x28,%rsp
  80101d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801021:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801025:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801029:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801031:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801038:	00 
  801039:	eb 2a                	jmp    801065 <strncpy+0x50>
		*dst++ = *src;
  80103b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801043:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801047:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104b:	0f b6 12             	movzbl (%rdx),%edx
  80104e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801050:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	84 c0                	test   %al,%al
  801059:	74 05                	je     801060 <strncpy+0x4b>
			src++;
  80105b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801060:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801069:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80106d:	72 cc                	jb     80103b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801073:	c9                   	leaveq 
  801074:	c3                   	retq   

0000000000801075 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801075:	55                   	push   %rbp
  801076:	48 89 e5             	mov    %rsp,%rbp
  801079:	48 83 ec 28          	sub    $0x28,%rsp
  80107d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801081:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801085:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801091:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801096:	74 3d                	je     8010d5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801098:	eb 1d                	jmp    8010b7 <strlcpy+0x42>
			*dst++ = *src++;
  80109a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010aa:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010ae:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b2:	0f b6 12             	movzbl (%rdx),%edx
  8010b5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010bc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010c1:	74 0b                	je     8010ce <strlcpy+0x59>
  8010c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	84 c0                	test   %al,%al
  8010cc:	75 cc                	jne    80109a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	48 29 c2             	sub    %rax,%rdx
  8010e0:	48 89 d0             	mov    %rdx,%rax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 10          	sub    $0x10,%rsp
  8010ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f5:	eb 0a                	jmp    801101 <strcmp+0x1c>
		p++, q++;
  8010f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801105:	0f b6 00             	movzbl (%rax),%eax
  801108:	84 c0                	test   %al,%al
  80110a:	74 12                	je     80111e <strcmp+0x39>
  80110c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801110:	0f b6 10             	movzbl (%rax),%edx
  801113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801117:	0f b6 00             	movzbl (%rax),%eax
  80111a:	38 c2                	cmp    %al,%dl
  80111c:	74 d9                	je     8010f7 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112c:	0f b6 00             	movzbl (%rax),%eax
  80112f:	0f b6 c0             	movzbl %al,%eax
  801132:	29 c2                	sub    %eax,%edx
  801134:	89 d0                	mov    %edx,%eax
}
  801136:	c9                   	leaveq 
  801137:	c3                   	retq   

0000000000801138 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801138:	55                   	push   %rbp
  801139:	48 89 e5             	mov    %rsp,%rbp
  80113c:	48 83 ec 18          	sub    $0x18,%rsp
  801140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801148:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80114c:	eb 0f                	jmp    80115d <strncmp+0x25>
		n--, p++, q++;
  80114e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801153:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801158:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80115d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801162:	74 1d                	je     801181 <strncmp+0x49>
  801164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801168:	0f b6 00             	movzbl (%rax),%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	74 12                	je     801181 <strncmp+0x49>
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801173:	0f b6 10             	movzbl (%rax),%edx
  801176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	38 c2                	cmp    %al,%dl
  80117f:	74 cd                	je     80114e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801181:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801186:	75 07                	jne    80118f <strncmp+0x57>
		return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
  80118d:	eb 18                	jmp    8011a7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	0f b6 d0             	movzbl %al,%edx
  801199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119d:	0f b6 00             	movzbl (%rax),%eax
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	c9                   	leaveq 
  8011a8:	c3                   	retq   

00000000008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %rbp
  8011aa:	48 89 e5             	mov    %rsp,%rbp
  8011ad:	48 83 ec 0c          	sub    $0xc,%rsp
  8011b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b5:	89 f0                	mov    %esi,%eax
  8011b7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011ba:	eb 17                	jmp    8011d3 <strchr+0x2a>
		if (*s == c)
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c6:	75 06                	jne    8011ce <strchr+0x25>
			return (char *) s;
  8011c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cc:	eb 15                	jmp    8011e3 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	84 c0                	test   %al,%al
  8011dc:	75 de                	jne    8011bc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e3:	c9                   	leaveq 
  8011e4:	c3                   	retq   

00000000008011e5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f1:	89 f0                	mov    %esi,%eax
  8011f3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f6:	eb 13                	jmp    80120b <strfind+0x26>
		if (*s == c)
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801202:	75 02                	jne    801206 <strfind+0x21>
			break;
  801204:	eb 10                	jmp    801216 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801206:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 00             	movzbl (%rax),%eax
  801212:	84 c0                	test   %al,%al
  801214:	75 e2                	jne    8011f8 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 18          	sub    $0x18,%rsp
  801224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801228:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80122b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801234:	75 06                	jne    80123c <memset+0x20>
		return v;
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123a:	eb 69                	jmp    8012a5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801240:	83 e0 03             	and    $0x3,%eax
  801243:	48 85 c0             	test   %rax,%rax
  801246:	75 48                	jne    801290 <memset+0x74>
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	83 e0 03             	and    $0x3,%eax
  80124f:	48 85 c0             	test   %rax,%rax
  801252:	75 3c                	jne    801290 <memset+0x74>
		c &= 0xFF;
  801254:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80125b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125e:	c1 e0 18             	shl    $0x18,%eax
  801261:	89 c2                	mov    %eax,%edx
  801263:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801266:	c1 e0 10             	shl    $0x10,%eax
  801269:	09 c2                	or     %eax,%edx
  80126b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126e:	c1 e0 08             	shl    $0x8,%eax
  801271:	09 d0                	or     %edx,%eax
  801273:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127a:	48 c1 e8 02          	shr    $0x2,%rax
  80127e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801281:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801285:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801288:	48 89 d7             	mov    %rdx,%rdi
  80128b:	fc                   	cld    
  80128c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128e:	eb 11                	jmp    8012a1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801290:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801294:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801297:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80129b:	48 89 d7             	mov    %rdx,%rdi
  80129e:	fc                   	cld    
  80129f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a5:	c9                   	leaveq 
  8012a6:	c3                   	retq   

00000000008012a7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a7:	55                   	push   %rbp
  8012a8:	48 89 e5             	mov    %rsp,%rbp
  8012ab:	48 83 ec 28          	sub    $0x28,%rsp
  8012af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012d3:	0f 83 88 00 00 00    	jae    801361 <memmove+0xba>
  8012d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e1:	48 01 d0             	add    %rdx,%rax
  8012e4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e8:	76 77                	jbe    801361 <memmove+0xba>
		s += n;
  8012ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ee:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f6:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 3b                	jne    801341 <memmove+0x9a>
  801306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130a:	83 e0 03             	and    $0x3,%eax
  80130d:	48 85 c0             	test   %rax,%rax
  801310:	75 2f                	jne    801341 <memmove+0x9a>
  801312:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801316:	83 e0 03             	and    $0x3,%eax
  801319:	48 85 c0             	test   %rax,%rax
  80131c:	75 23                	jne    801341 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	48 83 e8 04          	sub    $0x4,%rax
  801326:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132a:	48 83 ea 04          	sub    $0x4,%rdx
  80132e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801332:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801336:	48 89 c7             	mov    %rax,%rdi
  801339:	48 89 d6             	mov    %rdx,%rsi
  80133c:	fd                   	std    
  80133d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133f:	eb 1d                	jmp    80135e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801345:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801355:	48 89 d7             	mov    %rdx,%rdi
  801358:	48 89 c1             	mov    %rax,%rcx
  80135b:	fd                   	std    
  80135c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135e:	fc                   	cld    
  80135f:	eb 57                	jmp    8013b8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	83 e0 03             	and    $0x3,%eax
  801368:	48 85 c0             	test   %rax,%rax
  80136b:	75 36                	jne    8013a3 <memmove+0xfc>
  80136d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801371:	83 e0 03             	and    $0x3,%eax
  801374:	48 85 c0             	test   %rax,%rax
  801377:	75 2a                	jne    8013a3 <memmove+0xfc>
  801379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137d:	83 e0 03             	and    $0x3,%eax
  801380:	48 85 c0             	test   %rax,%rax
  801383:	75 1e                	jne    8013a3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 c1 e8 02          	shr    $0x2,%rax
  80138d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801394:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801398:	48 89 c7             	mov    %rax,%rdi
  80139b:	48 89 d6             	mov    %rdx,%rsi
  80139e:	fc                   	cld    
  80139f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013a1:	eb 15                	jmp    8013b8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ab:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013af:	48 89 c7             	mov    %rax,%rdi
  8013b2:	48 89 d6             	mov    %rdx,%rsi
  8013b5:	fc                   	cld    
  8013b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013bc:	c9                   	leaveq 
  8013bd:	c3                   	retq   

00000000008013be <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013be:	55                   	push   %rbp
  8013bf:	48 89 e5             	mov    %rsp,%rbp
  8013c2:	48 83 ec 18          	sub    $0x18,%rsp
  8013c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	48 89 ce             	mov    %rcx,%rsi
  8013e1:	48 89 c7             	mov    %rax,%rdi
  8013e4:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8013eb:	00 00 00 
  8013ee:	ff d0                	callq  *%rax
}
  8013f0:	c9                   	leaveq 
  8013f1:	c3                   	retq   

00000000008013f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013f2:	55                   	push   %rbp
  8013f3:	48 89 e5             	mov    %rsp,%rbp
  8013f6:	48 83 ec 28          	sub    $0x28,%rsp
  8013fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801402:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801412:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801416:	eb 36                	jmp    80144e <memcmp+0x5c>
		if (*s1 != *s2)
  801418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141c:	0f b6 10             	movzbl (%rax),%edx
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	0f b6 00             	movzbl (%rax),%eax
  801426:	38 c2                	cmp    %al,%dl
  801428:	74 1a                	je     801444 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 d0             	movzbl %al,%edx
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	0f b6 c0             	movzbl %al,%eax
  80143e:	29 c2                	sub    %eax,%edx
  801440:	89 d0                	mov    %edx,%eax
  801442:	eb 20                	jmp    801464 <memcmp+0x72>
		s1++, s2++;
  801444:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801449:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801456:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80145a:	48 85 c0             	test   %rax,%rax
  80145d:	75 b9                	jne    801418 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leaveq 
  801465:	c3                   	retq   

0000000000801466 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 83 ec 28          	sub    $0x28,%rsp
  80146e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801472:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801475:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801481:	48 01 d0             	add    %rdx,%rax
  801484:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801488:	eb 15                	jmp    80149f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	0f b6 10             	movzbl (%rax),%edx
  801491:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801494:	38 c2                	cmp    %al,%dl
  801496:	75 02                	jne    80149a <memfind+0x34>
			break;
  801498:	eb 0f                	jmp    8014a9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80149a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a7:	72 e1                	jb     80148a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014ad:	c9                   	leaveq 
  8014ae:	c3                   	retq   

00000000008014af <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014af:	55                   	push   %rbp
  8014b0:	48 89 e5             	mov    %rsp,%rbp
  8014b3:	48 83 ec 34          	sub    $0x34,%rsp
  8014b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014bf:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d1:	eb 05                	jmp    8014d8 <strtol+0x29>
		s++;
  8014d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	3c 20                	cmp    $0x20,%al
  8014e1:	74 f0                	je     8014d3 <strtol+0x24>
  8014e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	3c 09                	cmp    $0x9,%al
  8014ec:	74 e5                	je     8014d3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	3c 2b                	cmp    $0x2b,%al
  8014f7:	75 07                	jne    801500 <strtol+0x51>
		s++;
  8014f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014fe:	eb 17                	jmp    801517 <strtol+0x68>
	else if (*s == '-')
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	3c 2d                	cmp    $0x2d,%al
  801509:	75 0c                	jne    801517 <strtol+0x68>
		s++, neg = 1;
  80150b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801510:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801517:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80151b:	74 06                	je     801523 <strtol+0x74>
  80151d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801521:	75 28                	jne    80154b <strtol+0x9c>
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	3c 30                	cmp    $0x30,%al
  80152c:	75 1d                	jne    80154b <strtol+0x9c>
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	48 83 c0 01          	add    $0x1,%rax
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	3c 78                	cmp    $0x78,%al
  80153b:	75 0e                	jne    80154b <strtol+0x9c>
		s += 2, base = 16;
  80153d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801542:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801549:	eb 2c                	jmp    801577 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80154b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154f:	75 19                	jne    80156a <strtol+0xbb>
  801551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	3c 30                	cmp    $0x30,%al
  80155a:	75 0e                	jne    80156a <strtol+0xbb>
		s++, base = 8;
  80155c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801561:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801568:	eb 0d                	jmp    801577 <strtol+0xc8>
	else if (base == 0)
  80156a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80156e:	75 07                	jne    801577 <strtol+0xc8>
		base = 10;
  801570:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	3c 2f                	cmp    $0x2f,%al
  801580:	7e 1d                	jle    80159f <strtol+0xf0>
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	3c 39                	cmp    $0x39,%al
  80158b:	7f 12                	jg     80159f <strtol+0xf0>
			dig = *s - '0';
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	0f b6 00             	movzbl (%rax),%eax
  801594:	0f be c0             	movsbl %al,%eax
  801597:	83 e8 30             	sub    $0x30,%eax
  80159a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80159d:	eb 4e                	jmp    8015ed <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 60                	cmp    $0x60,%al
  8015a8:	7e 1d                	jle    8015c7 <strtol+0x118>
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	3c 7a                	cmp    $0x7a,%al
  8015b3:	7f 12                	jg     8015c7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	0f b6 00             	movzbl (%rax),%eax
  8015bc:	0f be c0             	movsbl %al,%eax
  8015bf:	83 e8 57             	sub    $0x57,%eax
  8015c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c5:	eb 26                	jmp    8015ed <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3c 40                	cmp    $0x40,%al
  8015d0:	7e 48                	jle    80161a <strtol+0x16b>
  8015d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	3c 5a                	cmp    $0x5a,%al
  8015db:	7f 3d                	jg     80161a <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	0f be c0             	movsbl %al,%eax
  8015e7:	83 e8 37             	sub    $0x37,%eax
  8015ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f0:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015f3:	7c 02                	jl     8015f7 <strtol+0x148>
			break;
  8015f5:	eb 23                	jmp    80161a <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015ff:	48 98                	cltq   
  801601:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801606:	48 89 c2             	mov    %rax,%rdx
  801609:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80160c:	48 98                	cltq   
  80160e:	48 01 d0             	add    %rdx,%rax
  801611:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801615:	e9 5d ff ff ff       	jmpq   801577 <strtol+0xc8>

	if (endptr)
  80161a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80161f:	74 0b                	je     80162c <strtol+0x17d>
		*endptr = (char *) s;
  801621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801625:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801629:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80162c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801630:	74 09                	je     80163b <strtol+0x18c>
  801632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801636:	48 f7 d8             	neg    %rax
  801639:	eb 04                	jmp    80163f <strtol+0x190>
  80163b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163f:	c9                   	leaveq 
  801640:	c3                   	retq   

0000000000801641 <strstr>:

char * strstr(const char *in, const char *str)
{
  801641:	55                   	push   %rbp
  801642:	48 89 e5             	mov    %rsp,%rbp
  801645:	48 83 ec 30          	sub    $0x30,%rsp
  801649:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80164d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801651:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801655:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801659:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801663:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801667:	75 06                	jne    80166f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	eb 6b                	jmp    8016da <strstr+0x99>

	len = strlen(str);
  80166f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801673:	48 89 c7             	mov    %rax,%rdi
  801676:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80167d:	00 00 00 
  801680:	ff d0                	callq  *%rax
  801682:	48 98                	cltq   
  801684:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801690:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80169a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80169e:	75 07                	jne    8016a7 <strstr+0x66>
				return (char *) 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 33                	jmp    8016da <strstr+0x99>
		} while (sc != c);
  8016a7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016ab:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016ae:	75 d8                	jne    801688 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	48 89 ce             	mov    %rcx,%rsi
  8016bf:	48 89 c7             	mov    %rax,%rdi
  8016c2:	48 b8 38 11 80 00 00 	movabs $0x801138,%rax
  8016c9:	00 00 00 
  8016cc:	ff d0                	callq  *%rax
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	75 b6                	jne    801688 <strstr+0x47>

	return (char *) (in - 1);
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	48 83 e8 01          	sub    $0x1,%rax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	53                   	push   %rbx
  8016e1:	48 83 ec 48          	sub    $0x48,%rsp
  8016e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016eb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016ef:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016f3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016fe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801702:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801706:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80170a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801712:	4c 89 c3             	mov    %r8,%rbx
  801715:	cd 30                	int    $0x30
  801717:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80171b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80171f:	74 3e                	je     80175f <syscall+0x83>
  801721:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801726:	7e 37                	jle    80175f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172f:	49 89 d0             	mov    %rdx,%r8
  801732:	89 c1                	mov    %eax,%ecx
  801734:	48 ba a8 4f 80 00 00 	movabs $0x804fa8,%rdx
  80173b:	00 00 00 
  80173e:	be 23 00 00 00       	mov    $0x23,%esi
  801743:	48 bf c5 4f 80 00 00 	movabs $0x804fc5,%rdi
  80174a:	00 00 00 
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	49 b9 95 01 80 00 00 	movabs $0x800195,%r9
  801759:	00 00 00 
  80175c:	41 ff d1             	callq  *%r9

	return ret;
  80175f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801763:	48 83 c4 48          	add    $0x48,%rsp
  801767:	5b                   	pop    %rbx
  801768:	5d                   	pop    %rbp
  801769:	c3                   	retq   

000000000080176a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80176a:	55                   	push   %rbp
  80176b:	48 89 e5             	mov    %rsp,%rbp
  80176e:	48 83 ec 20          	sub    $0x20,%rsp
  801772:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801776:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80177a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801782:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801789:	00 
  80178a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801790:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801796:	48 89 d1             	mov    %rdx,%rcx
  801799:	48 89 c2             	mov    %rax,%rdx
  80179c:	be 00 00 00 00       	mov    $0x0,%esi
  8017a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a6:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c3:	00 
  8017c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8017eb:	00 00 00 
  8017ee:	ff d0                	callq  *%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 10          	sub    $0x10,%rsp
  8017fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801800:	48 98                	cltq   
  801802:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801809:	00 
  80180a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801810:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801816:	b9 00 00 00 00       	mov    $0x0,%ecx
  80181b:	48 89 c2             	mov    %rax,%rdx
  80181e:	be 01 00 00 00       	mov    $0x1,%esi
  801823:	bf 03 00 00 00       	mov    $0x3,%edi
  801828:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  80182f:	00 00 00 
  801832:	ff d0                	callq  *%rax
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
  80183a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80183e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801845:	00 
  801846:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801852:	b9 00 00 00 00       	mov    $0x0,%ecx
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	be 00 00 00 00       	mov    $0x0,%esi
  801861:	bf 02 00 00 00       	mov    $0x2,%edi
  801866:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  80186d:	00 00 00 
  801870:	ff d0                	callq  *%rax
}
  801872:	c9                   	leaveq 
  801873:	c3                   	retq   

0000000000801874 <sys_yield>:

void
sys_yield(void)
{
  801874:	55                   	push   %rbp
  801875:	48 89 e5             	mov    %rsp,%rbp
  801878:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80187c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801883:	00 
  801884:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801890:	b9 00 00 00 00       	mov    $0x0,%ecx
  801895:	ba 00 00 00 00       	mov    $0x0,%edx
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 20          	sub    $0x20,%rsp
  8018ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c7:	48 63 c8             	movslq %eax,%rcx
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d1:	48 98                	cltq   
  8018d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018da:	00 
  8018db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e1:	49 89 c8             	mov    %rcx,%r8
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 01 00 00 00       	mov    $0x1,%esi
  8018ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
}
  801900:	c9                   	leaveq 
  801901:	c3                   	retq   

0000000000801902 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801902:	55                   	push   %rbp
  801903:	48 89 e5             	mov    %rsp,%rbp
  801906:	48 83 ec 30          	sub    $0x30,%rsp
  80190a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801911:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801914:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801918:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80191c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191f:	48 63 c8             	movslq %eax,%rcx
  801922:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801926:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801929:	48 63 f0             	movslq %eax,%rsi
  80192c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801933:	48 98                	cltq   
  801935:	48 89 0c 24          	mov    %rcx,(%rsp)
  801939:	49 89 f9             	mov    %rdi,%r9
  80193c:	49 89 f0             	mov    %rsi,%r8
  80193f:	48 89 d1             	mov    %rdx,%rcx
  801942:	48 89 c2             	mov    %rax,%rdx
  801945:	be 01 00 00 00       	mov    $0x1,%esi
  80194a:	bf 05 00 00 00       	mov    $0x5,%edi
  80194f:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 20          	sub    $0x20,%rsp
  801965:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801968:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80196c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801973:	48 98                	cltq   
  801975:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197c:	00 
  80197d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801983:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801989:	48 89 d1             	mov    %rdx,%rcx
  80198c:	48 89 c2             	mov    %rax,%rdx
  80198f:	be 01 00 00 00       	mov    $0x1,%esi
  801994:	bf 06 00 00 00       	mov    $0x6,%edi
  801999:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8019a0:	00 00 00 
  8019a3:	ff d0                	callq  *%rax
}
  8019a5:	c9                   	leaveq 
  8019a6:	c3                   	retq   

00000000008019a7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a7:	55                   	push   %rbp
  8019a8:	48 89 e5             	mov    %rsp,%rbp
  8019ab:	48 83 ec 10          	sub    $0x10,%rsp
  8019af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b8:	48 63 d0             	movslq %eax,%rdx
  8019bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019be:	48 98                	cltq   
  8019c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c7:	00 
  8019c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d4:	48 89 d1             	mov    %rdx,%rcx
  8019d7:	48 89 c2             	mov    %rax,%rdx
  8019da:	be 01 00 00 00       	mov    $0x1,%esi
  8019df:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e4:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8019eb:	00 00 00 
  8019ee:	ff d0                	callq  *%rax
}
  8019f0:	c9                   	leaveq 
  8019f1:	c3                   	retq   

00000000008019f2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019f2:	55                   	push   %rbp
  8019f3:	48 89 e5             	mov    %rsp,%rbp
  8019f6:	48 83 ec 20          	sub    $0x20,%rsp
  8019fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a08:	48 98                	cltq   
  801a0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a11:	00 
  801a12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1e:	48 89 d1             	mov    %rdx,%rcx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 09 00 00 00       	mov    $0x9,%edi
  801a2e:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 20          	sub    $0x20,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a52:	48 98                	cltq   
  801a54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5b:	00 
  801a5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a68:	48 89 d1             	mov    %rdx,%rcx
  801a6b:	48 89 c2             	mov    %rax,%rdx
  801a6e:	be 01 00 00 00       	mov    $0x1,%esi
  801a73:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a78:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
}
  801a84:	c9                   	leaveq 
  801a85:	c3                   	retq   

0000000000801a86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	48 83 ec 20          	sub    $0x20,%rsp
  801a8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a99:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9f:	48 63 f0             	movslq %eax,%rsi
  801aa2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab6:	00 
  801ab7:	49 89 f1             	mov    %rsi,%r9
  801aba:	49 89 c8             	mov    %rcx,%r8
  801abd:	48 89 d1             	mov    %rdx,%rcx
  801ac0:	48 89 c2             	mov    %rax,%rdx
  801ac3:	be 00 00 00 00       	mov    $0x0,%esi
  801ac8:	bf 0c 00 00 00       	mov    $0xc,%edi
  801acd:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	callq  *%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 10          	sub    $0x10,%rsp
  801ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af2:	00 
  801af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b04:	48 89 c2             	mov    %rax,%rdx
  801b07:	be 01 00 00 00       	mov    $0x1,%esi
  801b0c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b11:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 20          	sub    $0x20,%rsp
  801b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3e:	00 
  801b3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b50:	89 c6                	mov    %eax,%esi
  801b52:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b57:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 20          	sub    $0x20,%rsp
  801b6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b84:	00 
  801b85:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b91:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b96:	89 c6                	mov    %eax,%esi
  801b98:	bf 10 00 00 00       	mov    $0x10,%edi
  801b9d:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bb3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bba:	00 
  801bbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd1:	be 00 00 00 00       	mov    $0x0,%esi
  801bd6:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bdb:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  801be2:	00 00 00 
  801be5:	ff d0                	callq  *%rax
}
  801be7:	c9                   	leaveq 
  801be8:	c3                   	retq   

0000000000801be9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801be9:	55                   	push   %rbp
  801bea:	48 89 e5             	mov    %rsp,%rbp
  801bed:	48 83 ec 08          	sub    $0x8,%rsp
  801bf1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bf5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bf9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c00:	ff ff ff 
  801c03:	48 01 d0             	add    %rdx,%rax
  801c06:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 08          	sub    $0x8,%rsp
  801c14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1c:	48 89 c7             	mov    %rax,%rdi
  801c1f:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
  801c2b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c31:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c35:	c9                   	leaveq 
  801c36:	c3                   	retq   

0000000000801c37 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c37:	55                   	push   %rbp
  801c38:	48 89 e5             	mov    %rsp,%rbp
  801c3b:	48 83 ec 18          	sub    $0x18,%rsp
  801c3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c4a:	eb 6b                	jmp    801cb7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4f:	48 98                	cltq   
  801c51:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c57:	48 c1 e0 0c          	shl    $0xc,%rax
  801c5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c63:	48 c1 e8 15          	shr    $0x15,%rax
  801c67:	48 89 c2             	mov    %rax,%rdx
  801c6a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c71:	01 00 00 
  801c74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c78:	83 e0 01             	and    $0x1,%eax
  801c7b:	48 85 c0             	test   %rax,%rax
  801c7e:	74 21                	je     801ca1 <fd_alloc+0x6a>
  801c80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c84:	48 c1 e8 0c          	shr    $0xc,%rax
  801c88:	48 89 c2             	mov    %rax,%rdx
  801c8b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c92:	01 00 00 
  801c95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c99:	83 e0 01             	and    $0x1,%eax
  801c9c:	48 85 c0             	test   %rax,%rax
  801c9f:	75 12                	jne    801cb3 <fd_alloc+0x7c>
			*fd_store = fd;
  801ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb1:	eb 1a                	jmp    801ccd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cb3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cb7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cbb:	7e 8f                	jle    801c4c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cc8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
  801cd3:	48 83 ec 20          	sub    $0x20,%rsp
  801cd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801cde:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ce2:	78 06                	js     801cea <fd_lookup+0x1b>
  801ce4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ce8:	7e 07                	jle    801cf1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cef:	eb 6c                	jmp    801d5d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801cf1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cf4:	48 98                	cltq   
  801cf6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cfc:	48 c1 e0 0c          	shl    $0xc,%rax
  801d00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d08:	48 c1 e8 15          	shr    $0x15,%rax
  801d0c:	48 89 c2             	mov    %rax,%rdx
  801d0f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d16:	01 00 00 
  801d19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d1d:	83 e0 01             	and    $0x1,%eax
  801d20:	48 85 c0             	test   %rax,%rax
  801d23:	74 21                	je     801d46 <fd_lookup+0x77>
  801d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d29:	48 c1 e8 0c          	shr    $0xc,%rax
  801d2d:	48 89 c2             	mov    %rax,%rdx
  801d30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d37:	01 00 00 
  801d3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d3e:	83 e0 01             	and    $0x1,%eax
  801d41:	48 85 c0             	test   %rax,%rax
  801d44:	75 07                	jne    801d4d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d4b:	eb 10                	jmp    801d5d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d51:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d55:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leaveq 
  801d5e:	c3                   	retq   

0000000000801d5f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d5f:	55                   	push   %rbp
  801d60:	48 89 e5             	mov    %rsp,%rbp
  801d63:	48 83 ec 30          	sub    $0x30,%rsp
  801d67:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d6b:	89 f0                	mov    %esi,%eax
  801d6d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d74:	48 89 c7             	mov    %rax,%rdi
  801d77:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	callq  *%rax
  801d83:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d87:	48 89 d6             	mov    %rdx,%rsi
  801d8a:	89 c7                	mov    %eax,%edi
  801d8c:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  801d93:	00 00 00 
  801d96:	ff d0                	callq  *%rax
  801d98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d9f:	78 0a                	js     801dab <fd_close+0x4c>
	    || fd != fd2)
  801da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801da9:	74 12                	je     801dbd <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dab:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801daf:	74 05                	je     801db6 <fd_close+0x57>
  801db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db4:	eb 05                	jmp    801dbb <fd_close+0x5c>
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	eb 69                	jmp    801e26 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dbd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc1:	8b 00                	mov    (%rax),%eax
  801dc3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dc7:	48 89 d6             	mov    %rdx,%rsi
  801dca:	89 c7                	mov    %eax,%edi
  801dcc:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	callq  *%rax
  801dd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ddb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ddf:	78 2a                	js     801e0b <fd_close+0xac>
		if (dev->dev_close)
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801de9:	48 85 c0             	test   %rax,%rax
  801dec:	74 16                	je     801e04 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df2:	48 8b 40 20          	mov    0x20(%rax),%rax
  801df6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dfa:	48 89 d7             	mov    %rdx,%rdi
  801dfd:	ff d0                	callq  *%rax
  801dff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e02:	eb 07                	jmp    801e0b <fd_close+0xac>
		else
			r = 0;
  801e04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0f:	48 89 c6             	mov    %rax,%rsi
  801e12:	bf 00 00 00 00       	mov    $0x0,%edi
  801e17:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  801e1e:	00 00 00 
  801e21:	ff d0                	callq  *%rax
	return r;
  801e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 20          	sub    $0x20,%rsp
  801e30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e3e:	eb 41                	jmp    801e81 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e40:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e47:	00 00 00 
  801e4a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e4d:	48 63 d2             	movslq %edx,%rdx
  801e50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e54:	8b 00                	mov    (%rax),%eax
  801e56:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e59:	75 22                	jne    801e7d <dev_lookup+0x55>
			*dev = devtab[i];
  801e5b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e62:	00 00 00 
  801e65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e68:	48 63 d2             	movslq %edx,%rdx
  801e6b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e73:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	eb 60                	jmp    801edd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e81:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e88:	00 00 00 
  801e8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e8e:	48 63 d2             	movslq %edx,%rdx
  801e91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e95:	48 85 c0             	test   %rax,%rax
  801e98:	75 a6                	jne    801e40 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e9a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801ea1:	00 00 00 
  801ea4:	48 8b 00             	mov    (%rax),%rax
  801ea7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ead:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eb0:	89 c6                	mov    %eax,%esi
  801eb2:	48 bf d8 4f 80 00 00 	movabs $0x804fd8,%rdi
  801eb9:	00 00 00 
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec1:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  801ec8:	00 00 00 
  801ecb:	ff d1                	callq  *%rcx
	*dev = 0;
  801ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ed8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801edd:	c9                   	leaveq 
  801ede:	c3                   	retq   

0000000000801edf <close>:

int
close(int fdnum)
{
  801edf:	55                   	push   %rbp
  801ee0:	48 89 e5             	mov    %rsp,%rbp
  801ee3:	48 83 ec 20          	sub    $0x20,%rsp
  801ee7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ef1:	48 89 d6             	mov    %rdx,%rsi
  801ef4:	89 c7                	mov    %eax,%edi
  801ef6:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f09:	79 05                	jns    801f10 <close+0x31>
		return r;
  801f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0e:	eb 18                	jmp    801f28 <close+0x49>
	else
		return fd_close(fd, 1);
  801f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f14:	be 01 00 00 00       	mov    $0x1,%esi
  801f19:	48 89 c7             	mov    %rax,%rdi
  801f1c:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	callq  *%rax
}
  801f28:	c9                   	leaveq 
  801f29:	c3                   	retq   

0000000000801f2a <close_all>:

void
close_all(void)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f39:	eb 15                	jmp    801f50 <close_all+0x26>
		close(i);
  801f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3e:	89 c7                	mov    %eax,%edi
  801f40:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  801f47:	00 00 00 
  801f4a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f4c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f50:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f54:	7e e5                	jle    801f3b <close_all+0x11>
		close(i);
}
  801f56:	c9                   	leaveq 
  801f57:	c3                   	retq   

0000000000801f58 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f58:	55                   	push   %rbp
  801f59:	48 89 e5             	mov    %rsp,%rbp
  801f5c:	48 83 ec 40          	sub    $0x40,%rsp
  801f60:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f63:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f66:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f6a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f6d:	48 89 d6             	mov    %rdx,%rsi
  801f70:	89 c7                	mov    %eax,%edi
  801f72:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	callq  *%rax
  801f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f85:	79 08                	jns    801f8f <dup+0x37>
		return r;
  801f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8a:	e9 70 01 00 00       	jmpq   8020ff <dup+0x1a7>
	close(newfdnum);
  801f8f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f92:	89 c7                	mov    %eax,%edi
  801f94:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fa0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fa3:	48 98                	cltq   
  801fa5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fab:	48 c1 e0 0c          	shl    $0xc,%rax
  801faf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb7:	48 89 c7             	mov    %rax,%rdi
  801fba:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  801fc1:	00 00 00 
  801fc4:	ff d0                	callq  *%rax
  801fc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fce:	48 89 c7             	mov    %rax,%rdi
  801fd1:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
  801fdd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe5:	48 c1 e8 15          	shr    $0x15,%rax
  801fe9:	48 89 c2             	mov    %rax,%rdx
  801fec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ff3:	01 00 00 
  801ff6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffa:	83 e0 01             	and    $0x1,%eax
  801ffd:	48 85 c0             	test   %rax,%rax
  802000:	74 73                	je     802075 <dup+0x11d>
  802002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802006:	48 c1 e8 0c          	shr    $0xc,%rax
  80200a:	48 89 c2             	mov    %rax,%rdx
  80200d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802014:	01 00 00 
  802017:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201b:	83 e0 01             	and    $0x1,%eax
  80201e:	48 85 c0             	test   %rax,%rax
  802021:	74 52                	je     802075 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802023:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802027:	48 c1 e8 0c          	shr    $0xc,%rax
  80202b:	48 89 c2             	mov    %rax,%rdx
  80202e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802035:	01 00 00 
  802038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203c:	25 07 0e 00 00       	and    $0xe07,%eax
  802041:	89 c1                	mov    %eax,%ecx
  802043:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80204b:	41 89 c8             	mov    %ecx,%r8d
  80204e:	48 89 d1             	mov    %rdx,%rcx
  802051:	ba 00 00 00 00       	mov    $0x0,%edx
  802056:	48 89 c6             	mov    %rax,%rsi
  802059:	bf 00 00 00 00       	mov    $0x0,%edi
  80205e:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax
  80206a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802071:	79 02                	jns    802075 <dup+0x11d>
			goto err;
  802073:	eb 57                	jmp    8020cc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802075:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802079:	48 c1 e8 0c          	shr    $0xc,%rax
  80207d:	48 89 c2             	mov    %rax,%rdx
  802080:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802087:	01 00 00 
  80208a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208e:	25 07 0e 00 00       	and    $0xe07,%eax
  802093:	89 c1                	mov    %eax,%ecx
  802095:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802099:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80209d:	41 89 c8             	mov    %ecx,%r8d
  8020a0:	48 89 d1             	mov    %rdx,%rcx
  8020a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a8:	48 89 c6             	mov    %rax,%rsi
  8020ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b0:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	callq  *%rax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c3:	79 02                	jns    8020c7 <dup+0x16f>
		goto err;
  8020c5:	eb 05                	jmp    8020cc <dup+0x174>

	return newfdnum;
  8020c7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ca:	eb 33                	jmp    8020ff <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8020cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d0:	48 89 c6             	mov    %rax,%rsi
  8020d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d8:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8020e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e8:	48 89 c6             	mov    %rax,%rsi
  8020eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f0:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8020f7:	00 00 00 
  8020fa:	ff d0                	callq  *%rax
	return r;
  8020fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020ff:	c9                   	leaveq 
  802100:	c3                   	retq   

0000000000802101 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802101:	55                   	push   %rbp
  802102:	48 89 e5             	mov    %rsp,%rbp
  802105:	48 83 ec 40          	sub    $0x40,%rsp
  802109:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80210c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802110:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802114:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802118:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80211b:	48 89 d6             	mov    %rdx,%rsi
  80211e:	89 c7                	mov    %eax,%edi
  802120:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax
  80212c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802133:	78 24                	js     802159 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802139:	8b 00                	mov    (%rax),%eax
  80213b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80213f:	48 89 d6             	mov    %rdx,%rsi
  802142:	89 c7                	mov    %eax,%edi
  802144:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
  802150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802157:	79 05                	jns    80215e <read+0x5d>
		return r;
  802159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80215c:	eb 76                	jmp    8021d4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80215e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802162:	8b 40 08             	mov    0x8(%rax),%eax
  802165:	83 e0 03             	and    $0x3,%eax
  802168:	83 f8 01             	cmp    $0x1,%eax
  80216b:	75 3a                	jne    8021a7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80216d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802174:	00 00 00 
  802177:	48 8b 00             	mov    (%rax),%rax
  80217a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802180:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802183:	89 c6                	mov    %eax,%esi
  802185:	48 bf f7 4f 80 00 00 	movabs $0x804ff7,%rdi
  80218c:	00 00 00 
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  80219b:	00 00 00 
  80219e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021a5:	eb 2d                	jmp    8021d4 <read+0xd3>
	}
	if (!dev->dev_read)
  8021a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ab:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021af:	48 85 c0             	test   %rax,%rax
  8021b2:	75 07                	jne    8021bb <read+0xba>
		return -E_NOT_SUPP;
  8021b4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021b9:	eb 19                	jmp    8021d4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021bf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021cb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021cf:	48 89 cf             	mov    %rcx,%rdi
  8021d2:	ff d0                	callq  *%rax
}
  8021d4:	c9                   	leaveq 
  8021d5:	c3                   	retq   

00000000008021d6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021d6:	55                   	push   %rbp
  8021d7:	48 89 e5             	mov    %rsp,%rbp
  8021da:	48 83 ec 30          	sub    $0x30,%rsp
  8021de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f0:	eb 49                	jmp    80223b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f5:	48 98                	cltq   
  8021f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021fb:	48 29 c2             	sub    %rax,%rdx
  8021fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802201:	48 63 c8             	movslq %eax,%rcx
  802204:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802208:	48 01 c1             	add    %rax,%rcx
  80220b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80220e:	48 89 ce             	mov    %rcx,%rsi
  802211:	89 c7                	mov    %eax,%edi
  802213:	48 b8 01 21 80 00 00 	movabs $0x802101,%rax
  80221a:	00 00 00 
  80221d:	ff d0                	callq  *%rax
  80221f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802222:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802226:	79 05                	jns    80222d <readn+0x57>
			return m;
  802228:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80222b:	eb 1c                	jmp    802249 <readn+0x73>
		if (m == 0)
  80222d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802231:	75 02                	jne    802235 <readn+0x5f>
			break;
  802233:	eb 11                	jmp    802246 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802235:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802238:	01 45 fc             	add    %eax,-0x4(%rbp)
  80223b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223e:	48 98                	cltq   
  802240:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802244:	72 ac                	jb     8021f2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802246:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802249:	c9                   	leaveq 
  80224a:	c3                   	retq   

000000000080224b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80224b:	55                   	push   %rbp
  80224c:	48 89 e5             	mov    %rsp,%rbp
  80224f:	48 83 ec 40          	sub    $0x40,%rsp
  802253:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802256:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80225a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80225e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802262:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802265:	48 89 d6             	mov    %rdx,%rsi
  802268:	89 c7                	mov    %eax,%edi
  80226a:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
  802276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227d:	78 24                	js     8022a3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80227f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802283:	8b 00                	mov    (%rax),%eax
  802285:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802289:	48 89 d6             	mov    %rdx,%rsi
  80228c:	89 c7                	mov    %eax,%edi
  80228e:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a1:	79 05                	jns    8022a8 <write+0x5d>
		return r;
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a6:	eb 75                	jmp    80231d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ac:	8b 40 08             	mov    0x8(%rax),%eax
  8022af:	83 e0 03             	and    $0x3,%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	75 3a                	jne    8022f0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022b6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022bd:	00 00 00 
  8022c0:	48 8b 00             	mov    (%rax),%rax
  8022c3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022c9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022cc:	89 c6                	mov    %eax,%esi
  8022ce:	48 bf 13 50 80 00 00 	movabs $0x805013,%rdi
  8022d5:	00 00 00 
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dd:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  8022e4:	00 00 00 
  8022e7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ee:	eb 2d                	jmp    80231d <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8022f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022f8:	48 85 c0             	test   %rax,%rax
  8022fb:	75 07                	jne    802304 <write+0xb9>
		return -E_NOT_SUPP;
  8022fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802302:	eb 19                	jmp    80231d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802308:	48 8b 40 18          	mov    0x18(%rax),%rax
  80230c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802310:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802314:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802318:	48 89 cf             	mov    %rcx,%rdi
  80231b:	ff d0                	callq  *%rax
}
  80231d:	c9                   	leaveq 
  80231e:	c3                   	retq   

000000000080231f <seek>:

int
seek(int fdnum, off_t offset)
{
  80231f:	55                   	push   %rbp
  802320:	48 89 e5             	mov    %rsp,%rbp
  802323:	48 83 ec 18          	sub    $0x18,%rsp
  802327:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80232a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802334:	48 89 d6             	mov    %rdx,%rsi
  802337:	89 c7                	mov    %eax,%edi
  802339:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
  802345:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802348:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234c:	79 05                	jns    802353 <seek+0x34>
		return r;
  80234e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802351:	eb 0f                	jmp    802362 <seek+0x43>
	fd->fd_offset = offset;
  802353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802357:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80235a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802362:	c9                   	leaveq 
  802363:	c3                   	retq   

0000000000802364 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
  802368:	48 83 ec 30          	sub    $0x30,%rsp
  80236c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80236f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802372:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802376:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802379:	48 89 d6             	mov    %rdx,%rsi
  80237c:	89 c7                	mov    %eax,%edi
  80237e:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802385:	00 00 00 
  802388:	ff d0                	callq  *%rax
  80238a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802391:	78 24                	js     8023b7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802397:	8b 00                	mov    (%rax),%eax
  802399:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80239d:	48 89 d6             	mov    %rdx,%rsi
  8023a0:	89 c7                	mov    %eax,%edi
  8023a2:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  8023a9:	00 00 00 
  8023ac:	ff d0                	callq  *%rax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b5:	79 05                	jns    8023bc <ftruncate+0x58>
		return r;
  8023b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ba:	eb 72                	jmp    80242e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c0:	8b 40 08             	mov    0x8(%rax),%eax
  8023c3:	83 e0 03             	and    $0x3,%eax
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	75 3a                	jne    802404 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023ca:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023d1:	00 00 00 
  8023d4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023dd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023e0:	89 c6                	mov    %eax,%esi
  8023e2:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  8023e9:	00 00 00 
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f1:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  8023f8:	00 00 00 
  8023fb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8023fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802402:	eb 2a                	jmp    80242e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802408:	48 8b 40 30          	mov    0x30(%rax),%rax
  80240c:	48 85 c0             	test   %rax,%rax
  80240f:	75 07                	jne    802418 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802411:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802416:	eb 16                	jmp    80242e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802420:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802424:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802427:	89 ce                	mov    %ecx,%esi
  802429:	48 89 d7             	mov    %rdx,%rdi
  80242c:	ff d0                	callq  *%rax
}
  80242e:	c9                   	leaveq 
  80242f:	c3                   	retq   

0000000000802430 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
  802434:	48 83 ec 30          	sub    $0x30,%rsp
  802438:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80243b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802443:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802446:	48 89 d6             	mov    %rdx,%rsi
  802449:	89 c7                	mov    %eax,%edi
  80244b:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
  802457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245e:	78 24                	js     802484 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802464:	8b 00                	mov    (%rax),%eax
  802466:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246a:	48 89 d6             	mov    %rdx,%rsi
  80246d:	89 c7                	mov    %eax,%edi
  80246f:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
  80247b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802482:	79 05                	jns    802489 <fstat+0x59>
		return r;
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	eb 5e                	jmp    8024e7 <fstat+0xb7>
	if (!dev->dev_stat)
  802489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802491:	48 85 c0             	test   %rax,%rax
  802494:	75 07                	jne    80249d <fstat+0x6d>
		return -E_NOT_SUPP;
  802496:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80249b:	eb 4a                	jmp    8024e7 <fstat+0xb7>
	stat->st_name[0] = 0;
  80249d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024af:	00 00 00 
	stat->st_isdir = 0;
  8024b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024b6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024bd:	00 00 00 
	stat->st_dev = dev;
  8024c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024c8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024db:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024df:	48 89 ce             	mov    %rcx,%rsi
  8024e2:	48 89 d7             	mov    %rdx,%rdi
  8024e5:	ff d0                	callq  *%rax
}
  8024e7:	c9                   	leaveq 
  8024e8:	c3                   	retq   

00000000008024e9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024e9:	55                   	push   %rbp
  8024ea:	48 89 e5             	mov    %rsp,%rbp
  8024ed:	48 83 ec 20          	sub    $0x20,%rsp
  8024f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fd:	be 00 00 00 00       	mov    $0x0,%esi
  802502:	48 89 c7             	mov    %rax,%rdi
  802505:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
  802511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802518:	79 05                	jns    80251f <stat+0x36>
		return fd;
  80251a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251d:	eb 2f                	jmp    80254e <stat+0x65>
	r = fstat(fd, stat);
  80251f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802526:	48 89 d6             	mov    %rdx,%rsi
  802529:	89 c7                	mov    %eax,%edi
  80252b:	48 b8 30 24 80 00 00 	movabs $0x802430,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
  802537:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80253a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253d:	89 c7                	mov    %eax,%edi
  80253f:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
	return r;
  80254b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80254e:	c9                   	leaveq 
  80254f:	c3                   	retq   

0000000000802550 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802550:	55                   	push   %rbp
  802551:	48 89 e5             	mov    %rsp,%rbp
  802554:	48 83 ec 10          	sub    $0x10,%rsp
  802558:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80255b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80255f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802566:	00 00 00 
  802569:	8b 00                	mov    (%rax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	75 1d                	jne    80258c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80256f:	bf 01 00 00 00       	mov    $0x1,%edi
  802574:	48 b8 31 49 80 00 00 	movabs $0x804931,%rax
  80257b:	00 00 00 
  80257e:	ff d0                	callq  *%rax
  802580:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802587:	00 00 00 
  80258a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80258c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802593:	00 00 00 
  802596:	8b 00                	mov    (%rax),%eax
  802598:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80259b:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025a0:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8025a7:	00 00 00 
  8025aa:	89 c7                	mov    %eax,%edi
  8025ac:	48 b8 cf 48 80 00 00 	movabs $0x8048cf,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c1:	48 89 c6             	mov    %rax,%rsi
  8025c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c9:	48 b8 c9 47 80 00 00 	movabs $0x8047c9,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax
}
  8025d5:	c9                   	leaveq 
  8025d6:	c3                   	retq   

00000000008025d7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	48 83 ec 30          	sub    $0x30,%rsp
  8025df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025e3:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8025e6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8025ed:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8025f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8025fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802600:	75 08                	jne    80260a <open+0x33>
	{
		return r;
  802602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802605:	e9 f2 00 00 00       	jmpq   8026fc <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80260a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260e:	48 89 c7             	mov    %rax,%rdi
  802611:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
  80261d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802620:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802627:	7e 0a                	jle    802633 <open+0x5c>
	{
		return -E_BAD_PATH;
  802629:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80262e:	e9 c9 00 00 00       	jmpq   8026fc <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802633:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80263a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80263b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80263f:	48 89 c7             	mov    %rax,%rdi
  802642:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
  80264e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802655:	78 09                	js     802660 <open+0x89>
  802657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265b:	48 85 c0             	test   %rax,%rax
  80265e:	75 08                	jne    802668 <open+0x91>
		{
			return r;
  802660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802663:	e9 94 00 00 00       	jmpq   8026fc <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266c:	ba 00 04 00 00       	mov    $0x400,%edx
  802671:	48 89 c6             	mov    %rax,%rsi
  802674:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80267b:	00 00 00 
  80267e:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80268a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802691:	00 00 00 
  802694:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802697:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80269d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a1:	48 89 c6             	mov    %rax,%rsi
  8026a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a9:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
  8026b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bc:	79 2b                	jns    8026e9 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8026be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c2:	be 00 00 00 00       	mov    $0x0,%esi
  8026c7:	48 89 c7             	mov    %rax,%rdi
  8026ca:	48 b8 5f 1d 80 00 00 	movabs $0x801d5f,%rax
  8026d1:	00 00 00 
  8026d4:	ff d0                	callq  *%rax
  8026d6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026d9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026dd:	79 05                	jns    8026e4 <open+0x10d>
			{
				return d;
  8026df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026e2:	eb 18                	jmp    8026fc <open+0x125>
			}
			return r;
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e7:	eb 13                	jmp    8026fc <open+0x125>
		}	
		return fd2num(fd_store);
  8026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ed:	48 89 c7             	mov    %rax,%rdi
  8026f0:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8026f7:	00 00 00 
  8026fa:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8026fc:	c9                   	leaveq 
  8026fd:	c3                   	retq   

00000000008026fe <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026fe:	55                   	push   %rbp
  8026ff:	48 89 e5             	mov    %rsp,%rbp
  802702:	48 83 ec 10          	sub    $0x10,%rsp
  802706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80270a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80270e:	8b 50 0c             	mov    0xc(%rax),%edx
  802711:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802718:	00 00 00 
  80271b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80271d:	be 00 00 00 00       	mov    $0x0,%esi
  802722:	bf 06 00 00 00       	mov    $0x6,%edi
  802727:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  80272e:	00 00 00 
  802731:	ff d0                	callq  *%rax
}
  802733:	c9                   	leaveq 
  802734:	c3                   	retq   

0000000000802735 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802735:	55                   	push   %rbp
  802736:	48 89 e5             	mov    %rsp,%rbp
  802739:	48 83 ec 30          	sub    $0x30,%rsp
  80273d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802741:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802745:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802749:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802750:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802755:	74 07                	je     80275e <devfile_read+0x29>
  802757:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80275c:	75 07                	jne    802765 <devfile_read+0x30>
		return -E_INVAL;
  80275e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802763:	eb 77                	jmp    8027dc <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802769:	8b 50 0c             	mov    0xc(%rax),%edx
  80276c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802773:	00 00 00 
  802776:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802778:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80277f:	00 00 00 
  802782:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802786:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80278a:	be 00 00 00 00       	mov    $0x0,%esi
  80278f:	bf 03 00 00 00       	mov    $0x3,%edi
  802794:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	callq  *%rax
  8027a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a7:	7f 05                	jg     8027ae <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8027a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ac:	eb 2e                	jmp    8027dc <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b1:	48 63 d0             	movslq %eax,%rdx
  8027b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027b8:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8027bf:	00 00 00 
  8027c2:	48 89 c7             	mov    %rax,%rdi
  8027c5:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8027d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8027d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8027dc:	c9                   	leaveq 
  8027dd:	c3                   	retq   

00000000008027de <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027de:	55                   	push   %rbp
  8027df:	48 89 e5             	mov    %rsp,%rbp
  8027e2:	48 83 ec 30          	sub    $0x30,%rsp
  8027e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8027f2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8027f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027fe:	74 07                	je     802807 <devfile_write+0x29>
  802800:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802805:	75 08                	jne    80280f <devfile_write+0x31>
		return r;
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	e9 9a 00 00 00       	jmpq   8028a9 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80280f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802813:	8b 50 0c             	mov    0xc(%rax),%edx
  802816:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80281d:	00 00 00 
  802820:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802822:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802829:	00 
  80282a:	76 08                	jbe    802834 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80282c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802833:	00 
	}
	fsipcbuf.write.req_n = n;
  802834:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80283b:	00 00 00 
  80283e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802842:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802846:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284e:	48 89 c6             	mov    %rax,%rsi
  802851:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802858:	00 00 00 
  80285b:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802867:	be 00 00 00 00       	mov    $0x0,%esi
  80286c:	bf 04 00 00 00       	mov    $0x4,%edi
  802871:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
  80287d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802884:	7f 20                	jg     8028a6 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802886:	48 bf 56 50 80 00 00 	movabs $0x805056,%rdi
  80288d:	00 00 00 
  802890:	b8 00 00 00 00       	mov    $0x0,%eax
  802895:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  80289c:	00 00 00 
  80289f:	ff d2                	callq  *%rdx
		return r;
  8028a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a4:	eb 03                	jmp    8028a9 <devfile_write+0xcb>
	}
	return r;
  8028a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8028a9:	c9                   	leaveq 
  8028aa:	c3                   	retq   

00000000008028ab <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028ab:	55                   	push   %rbp
  8028ac:	48 89 e5             	mov    %rsp,%rbp
  8028af:	48 83 ec 20          	sub    $0x20,%rsp
  8028b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028c9:	00 00 00 
  8028cc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028ce:	be 00 00 00 00       	mov    $0x0,%esi
  8028d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8028d8:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  8028df:	00 00 00 
  8028e2:	ff d0                	callq  *%rax
  8028e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028eb:	79 05                	jns    8028f2 <devfile_stat+0x47>
		return r;
  8028ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f0:	eb 56                	jmp    802948 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8028fd:	00 00 00 
  802900:	48 89 c7             	mov    %rax,%rdi
  802903:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80290f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802916:	00 00 00 
  802919:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80291f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802923:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802929:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802930:	00 00 00 
  802933:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802939:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802948:	c9                   	leaveq 
  802949:	c3                   	retq   

000000000080294a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80294a:	55                   	push   %rbp
  80294b:	48 89 e5             	mov    %rsp,%rbp
  80294e:	48 83 ec 10          	sub    $0x10,%rsp
  802952:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802956:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802959:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80295d:	8b 50 0c             	mov    0xc(%rax),%edx
  802960:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802967:	00 00 00 
  80296a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80296c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802973:	00 00 00 
  802976:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802979:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80297c:	be 00 00 00 00       	mov    $0x0,%esi
  802981:	bf 02 00 00 00       	mov    $0x2,%edi
  802986:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  80298d:	00 00 00 
  802990:	ff d0                	callq  *%rax
}
  802992:	c9                   	leaveq 
  802993:	c3                   	retq   

0000000000802994 <remove>:

// Delete a file
int
remove(const char *path)
{
  802994:	55                   	push   %rbp
  802995:	48 89 e5             	mov    %rsp,%rbp
  802998:	48 83 ec 10          	sub    $0x10,%rsp
  80299c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a4:	48 89 c7             	mov    %rax,%rdi
  8029a7:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
  8029b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029b8:	7e 07                	jle    8029c1 <remove+0x2d>
		return -E_BAD_PATH;
  8029ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029bf:	eb 33                	jmp    8029f4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029c5:	48 89 c6             	mov    %rax,%rsi
  8029c8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8029cf:	00 00 00 
  8029d2:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029de:	be 00 00 00 00       	mov    $0x0,%esi
  8029e3:	bf 07 00 00 00       	mov    $0x7,%edi
  8029e8:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
}
  8029f4:	c9                   	leaveq 
  8029f5:	c3                   	retq   

00000000008029f6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029f6:	55                   	push   %rbp
  8029f7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029fa:	be 00 00 00 00       	mov    $0x0,%esi
  8029ff:	bf 08 00 00 00       	mov    $0x8,%edi
  802a04:	48 b8 50 25 80 00 00 	movabs $0x802550,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
}
  802a10:	5d                   	pop    %rbp
  802a11:	c3                   	retq   

0000000000802a12 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a1d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a24:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a2b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a32:	be 00 00 00 00       	mov    $0x0,%esi
  802a37:	48 89 c7             	mov    %rax,%rdi
  802a3a:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  802a41:	00 00 00 
  802a44:	ff d0                	callq  *%rax
  802a46:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4d:	79 28                	jns    802a77 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a52:	89 c6                	mov    %eax,%esi
  802a54:	48 bf 72 50 80 00 00 	movabs $0x805072,%rdi
  802a5b:	00 00 00 
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802a6a:	00 00 00 
  802a6d:	ff d2                	callq  *%rdx
		return fd_src;
  802a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a72:	e9 74 01 00 00       	jmpq   802beb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a77:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a7e:	be 01 01 00 00       	mov    $0x101,%esi
  802a83:	48 89 c7             	mov    %rax,%rdi
  802a86:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
  802a92:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a95:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a99:	79 39                	jns    802ad4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a9e:	89 c6                	mov    %eax,%esi
  802aa0:	48 bf 88 50 80 00 00 	movabs $0x805088,%rdi
  802aa7:	00 00 00 
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaf:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802ab6:	00 00 00 
  802ab9:	ff d2                	callq  *%rdx
		close(fd_src);
  802abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abe:	89 c7                	mov    %eax,%edi
  802ac0:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
		return fd_dest;
  802acc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802acf:	e9 17 01 00 00       	jmpq   802beb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ad4:	eb 74                	jmp    802b4a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ad6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ad9:	48 63 d0             	movslq %eax,%rdx
  802adc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae6:	48 89 ce             	mov    %rcx,%rsi
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 4b 22 80 00 00 	movabs $0x80224b,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802afa:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802afe:	79 4a                	jns    802b4a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b00:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b03:	89 c6                	mov    %eax,%esi
  802b05:	48 bf a2 50 80 00 00 	movabs $0x8050a2,%rdi
  802b0c:	00 00 00 
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802b1b:	00 00 00 
  802b1e:	ff d2                	callq  *%rdx
			close(fd_src);
  802b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
			close(fd_dest);
  802b31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b34:	89 c7                	mov    %eax,%edi
  802b36:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802b3d:	00 00 00 
  802b40:	ff d0                	callq  *%rax
			return write_size;
  802b42:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b45:	e9 a1 00 00 00       	jmpq   802beb <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b4a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b54:	ba 00 02 00 00       	mov    $0x200,%edx
  802b59:	48 89 ce             	mov    %rcx,%rsi
  802b5c:	89 c7                	mov    %eax,%edi
  802b5e:	48 b8 01 21 80 00 00 	movabs $0x802101,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
  802b6a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b71:	0f 8f 5f ff ff ff    	jg     802ad6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b7b:	79 47                	jns    802bc4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b80:	89 c6                	mov    %eax,%esi
  802b82:	48 bf b5 50 80 00 00 	movabs $0x8050b5,%rdi
  802b89:	00 00 00 
  802b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b91:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  802b98:	00 00 00 
  802b9b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba0:	89 c7                	mov    %eax,%edi
  802ba2:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax
		close(fd_dest);
  802bae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
		return read_size;
  802bbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bc2:	eb 27                	jmp    802beb <copy+0x1d9>
	}
	close(fd_src);
  802bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
	close(fd_dest);
  802bd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd8:	89 c7                	mov    %eax,%edi
  802bda:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
	return 0;
  802be6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802beb:	c9                   	leaveq 
  802bec:	c3                   	retq   

0000000000802bed <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802bed:	55                   	push   %rbp
  802bee:	48 89 e5             	mov    %rsp,%rbp
  802bf1:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802bf8:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802bff:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802c06:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802c0d:	be 00 00 00 00       	mov    $0x0,%esi
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 d7 25 80 00 00 	movabs $0x8025d7,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c24:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c28:	79 08                	jns    802c32 <spawn+0x45>
		return r;
  802c2a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c2d:	e9 14 03 00 00       	jmpq   802f46 <spawn+0x359>
	fd = r;
  802c32:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c35:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802c38:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802c3f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802c43:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802c4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c4d:	ba 00 02 00 00       	mov    $0x200,%edx
  802c52:	48 89 ce             	mov    %rcx,%rsi
  802c55:	89 c7                	mov    %eax,%edi
  802c57:	48 b8 d6 21 80 00 00 	movabs $0x8021d6,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
  802c63:	3d 00 02 00 00       	cmp    $0x200,%eax
  802c68:	75 0d                	jne    802c77 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802c6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6e:	8b 00                	mov    (%rax),%eax
  802c70:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c75:	74 43                	je     802cba <spawn+0xcd>
		close(fd);
  802c77:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c7a:	89 c7                	mov    %eax,%edi
  802c7c:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8c:	8b 00                	mov    (%rax),%eax
  802c8e:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c93:	89 c6                	mov    %eax,%esi
  802c95:	48 bf d0 50 80 00 00 	movabs $0x8050d0,%rdi
  802c9c:	00 00 00 
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca4:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  802cab:	00 00 00 
  802cae:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802cb0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cb5:	e9 8c 02 00 00       	jmpq   802f46 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802cba:	b8 07 00 00 00       	mov    $0x7,%eax
  802cbf:	cd 30                	int    $0x30
  802cc1:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802cc4:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802cc7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cca:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cce:	79 08                	jns    802cd8 <spawn+0xeb>
		return r;
  802cd0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd3:	e9 6e 02 00 00       	jmpq   802f46 <spawn+0x359>
	child = r;
  802cd8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cdb:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802cde:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ce1:	25 ff 03 00 00       	and    $0x3ff,%eax
  802ce6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802ced:	00 00 00 
  802cf0:	48 63 d0             	movslq %eax,%rdx
  802cf3:	48 89 d0             	mov    %rdx,%rax
  802cf6:	48 c1 e0 03          	shl    $0x3,%rax
  802cfa:	48 01 d0             	add    %rdx,%rax
  802cfd:	48 c1 e0 05          	shl    $0x5,%rax
  802d01:	48 01 c8             	add    %rcx,%rax
  802d04:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d0b:	48 89 c6             	mov    %rax,%rsi
  802d0e:	b8 18 00 00 00       	mov    $0x18,%eax
  802d13:	48 89 d7             	mov    %rdx,%rdi
  802d16:	48 89 c1             	mov    %rax,%rcx
  802d19:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d20:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d24:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802d2b:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802d32:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802d39:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802d40:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d43:	48 89 ce             	mov    %rcx,%rsi
  802d46:	89 c7                	mov    %eax,%edi
  802d48:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d5b:	79 08                	jns    802d65 <spawn+0x178>
		return r;
  802d5d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d60:	e9 e1 01 00 00       	jmpq   802f46 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d69:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d6d:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d74:	48 01 d0             	add    %rdx,%rax
  802d77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d82:	e9 a3 00 00 00       	jmpq   802e2a <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802d87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8b:	8b 00                	mov    (%rax),%eax
  802d8d:	83 f8 01             	cmp    $0x1,%eax
  802d90:	74 05                	je     802d97 <spawn+0x1aa>
			continue;
  802d92:	e9 8a 00 00 00       	jmpq   802e21 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802d97:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da2:	8b 40 04             	mov    0x4(%rax),%eax
  802da5:	83 e0 02             	and    $0x2,%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 04                	je     802db0 <spawn+0x1c3>
			perm |= PTE_W;
  802dac:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db4:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802db8:	41 89 c1             	mov    %eax,%r9d
  802dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbf:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc7:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802dd3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802dd6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dd9:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802ddc:	89 3c 24             	mov    %edi,(%rsp)
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 59 34 80 00 00 	movabs $0x803459,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
  802ded:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802df0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802df4:	79 2b                	jns    802e21 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802df6:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802df7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dfa:	89 c7                	mov    %eax,%edi
  802dfc:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  802e03:	00 00 00 
  802e06:	ff d0                	callq  *%rax
	close(fd);
  802e08:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e0b:	89 c7                	mov    %eax,%edi
  802e0d:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
	return r;
  802e19:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e1c:	e9 25 01 00 00       	jmpq   802f46 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e25:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802e2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e2e:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802e32:	0f b7 c0             	movzwl %ax,%eax
  802e35:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e38:	0f 8f 49 ff ff ff    	jg     802d87 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802e3e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e41:	89 c7                	mov    %eax,%edi
  802e43:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
	fd = -1;
  802e4f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802e56:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e59:	89 c7                	mov    %eax,%edi
  802e5b:	48 b8 45 36 80 00 00 	movabs $0x803645,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e6e:	79 30                	jns    802ea0 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802e70:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e73:	89 c1                	mov    %eax,%ecx
  802e75:	48 ba ea 50 80 00 00 	movabs $0x8050ea,%rdx
  802e7c:	00 00 00 
  802e7f:	be 82 00 00 00       	mov    $0x82,%esi
  802e84:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802e8b:	00 00 00 
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e93:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802e9a:	00 00 00 
  802e9d:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ea0:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802ea7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eaa:	48 89 d6             	mov    %rdx,%rsi
  802ead:	89 c7                	mov    %eax,%edi
  802eaf:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ebe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ec2:	79 30                	jns    802ef4 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802ec4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ec7:	89 c1                	mov    %eax,%ecx
  802ec9:	48 ba 0c 51 80 00 00 	movabs $0x80510c,%rdx
  802ed0:	00 00 00 
  802ed3:	be 85 00 00 00       	mov    $0x85,%esi
  802ed8:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802edf:	00 00 00 
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee7:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802eee:	00 00 00 
  802ef1:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802ef4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ef7:	be 02 00 00 00       	mov    $0x2,%esi
  802efc:	89 c7                	mov    %eax,%edi
  802efe:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
  802f0a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f11:	79 30                	jns    802f43 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802f13:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f16:	89 c1                	mov    %eax,%ecx
  802f18:	48 ba 26 51 80 00 00 	movabs $0x805126,%rdx
  802f1f:	00 00 00 
  802f22:	be 88 00 00 00       	mov    $0x88,%esi
  802f27:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  802f2e:	00 00 00 
  802f31:	b8 00 00 00 00       	mov    $0x0,%eax
  802f36:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802f3d:	00 00 00 
  802f40:	41 ff d0             	callq  *%r8

	return child;
  802f43:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	41 55                	push   %r13
  802f4e:	41 54                	push   %r12
  802f50:	53                   	push   %rbx
  802f51:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f58:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802f5f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802f66:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f6d:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f74:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f7b:	84 c0                	test   %al,%al
  802f7d:	74 26                	je     802fa5 <spawnl+0x5d>
  802f7f:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f86:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f8d:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f91:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f95:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f99:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802f9d:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802fa1:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802fa5:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802fac:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802fb3:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802fb6:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802fbd:	00 00 00 
  802fc0:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fc7:	00 00 00 
  802fca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fce:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fd5:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fdc:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802fe3:	eb 07                	jmp    802fec <spawnl+0xa4>
		argc++;
  802fe5:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802fec:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ff2:	83 f8 30             	cmp    $0x30,%eax
  802ff5:	73 23                	jae    80301a <spawnl+0xd2>
  802ff7:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802ffe:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803004:	89 c0                	mov    %eax,%eax
  803006:	48 01 d0             	add    %rdx,%rax
  803009:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80300f:	83 c2 08             	add    $0x8,%edx
  803012:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803018:	eb 15                	jmp    80302f <spawnl+0xe7>
  80301a:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803021:	48 89 d0             	mov    %rdx,%rax
  803024:	48 83 c2 08          	add    $0x8,%rdx
  803028:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80302f:	48 8b 00             	mov    (%rax),%rax
  803032:	48 85 c0             	test   %rax,%rax
  803035:	75 ae                	jne    802fe5 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803037:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80303d:	83 c0 02             	add    $0x2,%eax
  803040:	48 89 e2             	mov    %rsp,%rdx
  803043:	48 89 d3             	mov    %rdx,%rbx
  803046:	48 63 d0             	movslq %eax,%rdx
  803049:	48 83 ea 01          	sub    $0x1,%rdx
  80304d:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803054:	48 63 d0             	movslq %eax,%rdx
  803057:	49 89 d4             	mov    %rdx,%r12
  80305a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803060:	48 63 d0             	movslq %eax,%rdx
  803063:	49 89 d2             	mov    %rdx,%r10
  803066:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80306c:	48 98                	cltq   
  80306e:	48 c1 e0 03          	shl    $0x3,%rax
  803072:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803076:	b8 10 00 00 00       	mov    $0x10,%eax
  80307b:	48 83 e8 01          	sub    $0x1,%rax
  80307f:	48 01 d0             	add    %rdx,%rax
  803082:	bf 10 00 00 00       	mov    $0x10,%edi
  803087:	ba 00 00 00 00       	mov    $0x0,%edx
  80308c:	48 f7 f7             	div    %rdi
  80308f:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803093:	48 29 c4             	sub    %rax,%rsp
  803096:	48 89 e0             	mov    %rsp,%rax
  803099:	48 83 c0 07          	add    $0x7,%rax
  80309d:	48 c1 e8 03          	shr    $0x3,%rax
  8030a1:	48 c1 e0 03          	shl    $0x3,%rax
  8030a5:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8030ac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030b3:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8030ba:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8030bd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030c3:	8d 50 01             	lea    0x1(%rax),%edx
  8030c6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030cd:	48 63 d2             	movslq %edx,%rdx
  8030d0:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8030d7:	00 

	va_start(vl, arg0);
  8030d8:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030df:	00 00 00 
  8030e2:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030e9:	00 00 00 
  8030ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030f0:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8030f7:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8030fe:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803105:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80310c:	00 00 00 
  80310f:	eb 63                	jmp    803174 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803111:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803117:	8d 70 01             	lea    0x1(%rax),%esi
  80311a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803120:	83 f8 30             	cmp    $0x30,%eax
  803123:	73 23                	jae    803148 <spawnl+0x200>
  803125:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80312c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803132:	89 c0                	mov    %eax,%eax
  803134:	48 01 d0             	add    %rdx,%rax
  803137:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80313d:	83 c2 08             	add    $0x8,%edx
  803140:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803146:	eb 15                	jmp    80315d <spawnl+0x215>
  803148:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80314f:	48 89 d0             	mov    %rdx,%rax
  803152:	48 83 c2 08          	add    $0x8,%rdx
  803156:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80315d:	48 8b 08             	mov    (%rax),%rcx
  803160:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803167:	89 f2                	mov    %esi,%edx
  803169:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80316d:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803174:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80317a:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803180:	77 8f                	ja     803111 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803182:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803189:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803190:	48 89 d6             	mov    %rdx,%rsi
  803193:	48 89 c7             	mov    %rax,%rdi
  803196:	48 b8 ed 2b 80 00 00 	movabs $0x802bed,%rax
  80319d:	00 00 00 
  8031a0:	ff d0                	callq  *%rax
  8031a2:	48 89 dc             	mov    %rbx,%rsp
}
  8031a5:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8031a9:	5b                   	pop    %rbx
  8031aa:	41 5c                	pop    %r12
  8031ac:	41 5d                	pop    %r13
  8031ae:	5d                   	pop    %rbp
  8031af:	c3                   	retq   

00000000008031b0 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 50          	sub    $0x50,%rsp
  8031b8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031bb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031bf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8031c3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031ca:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8031cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8031d2:	eb 33                	jmp    803207 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8031d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031d7:	48 98                	cltq   
  8031d9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031e0:	00 
  8031e1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031e5:	48 01 d0             	add    %rdx,%rax
  8031e8:	48 8b 00             	mov    (%rax),%rax
  8031eb:	48 89 c7             	mov    %rax,%rdi
  8031ee:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
  8031fa:	83 c0 01             	add    $0x1,%eax
  8031fd:	48 98                	cltq   
  8031ff:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803203:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803207:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80320a:	48 98                	cltq   
  80320c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803213:	00 
  803214:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803218:	48 01 d0             	add    %rdx,%rax
  80321b:	48 8b 00             	mov    (%rax),%rax
  80321e:	48 85 c0             	test   %rax,%rax
  803221:	75 b1                	jne    8031d4 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803227:	48 f7 d8             	neg    %rax
  80322a:	48 05 00 10 40 00    	add    $0x401000,%rax
  803230:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803234:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803238:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80323c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803240:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803244:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803247:	83 c2 01             	add    $0x1,%edx
  80324a:	c1 e2 03             	shl    $0x3,%edx
  80324d:	48 63 d2             	movslq %edx,%rdx
  803250:	48 f7 da             	neg    %rdx
  803253:	48 01 d0             	add    %rdx,%rax
  803256:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80325a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80325e:	48 83 e8 10          	sub    $0x10,%rax
  803262:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803268:	77 0a                	ja     803274 <init_stack+0xc4>
		return -E_NO_MEM;
  80326a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80326f:	e9 e3 01 00 00       	jmpq   803457 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803274:	ba 07 00 00 00       	mov    $0x7,%edx
  803279:	be 00 00 40 00       	mov    $0x400000,%esi
  80327e:	bf 00 00 00 00       	mov    $0x0,%edi
  803283:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
  80328f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803292:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803296:	79 08                	jns    8032a0 <init_stack+0xf0>
		return r;
  803298:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329b:	e9 b7 01 00 00       	jmpq   803457 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8032a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8032a7:	e9 8a 00 00 00       	jmpq   803336 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8032ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032af:	48 98                	cltq   
  8032b1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032b8:	00 
  8032b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032bd:	48 01 c2             	add    %rax,%rdx
  8032c0:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c9:	48 01 c8             	add    %rcx,%rax
  8032cc:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8032d2:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8032d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032d8:	48 98                	cltq   
  8032da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032e1:	00 
  8032e2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032e6:	48 01 d0             	add    %rdx,%rax
  8032e9:	48 8b 10             	mov    (%rax),%rdx
  8032ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f0:	48 89 d6             	mov    %rdx,%rsi
  8032f3:	48 89 c7             	mov    %rax,%rdi
  8032f6:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803302:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803305:	48 98                	cltq   
  803307:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80330e:	00 
  80330f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803313:	48 01 d0             	add    %rdx,%rax
  803316:	48 8b 00             	mov    (%rax),%rax
  803319:	48 89 c7             	mov    %rax,%rdi
  80331c:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	48 98                	cltq   
  80332a:	48 83 c0 01          	add    $0x1,%rax
  80332e:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803332:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803336:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803339:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80333c:	0f 8c 6a ff ff ff    	jl     8032ac <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803345:	48 98                	cltq   
  803347:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80334e:	00 
  80334f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803353:	48 01 d0             	add    %rdx,%rax
  803356:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80335d:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803364:	00 
  803365:	74 35                	je     80339c <init_stack+0x1ec>
  803367:	48 b9 40 51 80 00 00 	movabs $0x805140,%rcx
  80336e:	00 00 00 
  803371:	48 ba 66 51 80 00 00 	movabs $0x805166,%rdx
  803378:	00 00 00 
  80337b:	be f1 00 00 00       	mov    $0xf1,%esi
  803380:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  803387:	00 00 00 
  80338a:	b8 00 00 00 00       	mov    $0x0,%eax
  80338f:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803396:	00 00 00 
  803399:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80339c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a0:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8033a4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ad:	48 01 c8             	add    %rcx,%rax
  8033b0:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033b6:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8033b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033bd:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8033c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033c4:	48 98                	cltq   
  8033c6:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8033c9:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8033ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d2:	48 01 d0             	add    %rdx,%rax
  8033d5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033db:	48 89 c2             	mov    %rax,%rdx
  8033de:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8033e2:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8033e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033e8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033ee:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033f3:	89 c2                	mov    %eax,%edx
  8033f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8033fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ff:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
  80340b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80340e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803412:	79 02                	jns    803416 <init_stack+0x266>
		goto error;
  803414:	eb 28                	jmp    80343e <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803416:	be 00 00 40 00       	mov    $0x400000,%esi
  80341b:	bf 00 00 00 00       	mov    $0x0,%edi
  803420:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80342f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803433:	79 02                	jns    803437 <init_stack+0x287>
		goto error;
  803435:	eb 07                	jmp    80343e <init_stack+0x28e>

	return 0;
  803437:	b8 00 00 00 00       	mov    $0x0,%eax
  80343c:	eb 19                	jmp    803457 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  80343e:	be 00 00 40 00       	mov    $0x400000,%esi
  803443:	bf 00 00 00 00       	mov    $0x0,%edi
  803448:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80344f:	00 00 00 
  803452:	ff d0                	callq  *%rax
	return r;
  803454:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803457:	c9                   	leaveq 
  803458:	c3                   	retq   

0000000000803459 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803459:	55                   	push   %rbp
  80345a:	48 89 e5             	mov    %rsp,%rbp
  80345d:	48 83 ec 50          	sub    $0x50,%rsp
  803461:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803464:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803468:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80346c:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80346f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803473:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803477:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347b:	25 ff 0f 00 00       	and    $0xfff,%eax
  803480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803487:	74 21                	je     8034aa <map_segment+0x51>
		va -= i;
  803489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348c:	48 98                	cltq   
  80348e:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803492:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803495:	48 98                	cltq   
  803497:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80349b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349e:	48 98                	cltq   
  8034a0:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034b1:	e9 79 01 00 00       	jmpq   80362f <map_segment+0x1d6>
		if (i >= filesz) {
  8034b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b9:	48 98                	cltq   
  8034bb:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8034bf:	72 3c                	jb     8034fd <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8034c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c4:	48 63 d0             	movslq %eax,%rdx
  8034c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034cb:	48 01 d0             	add    %rdx,%rax
  8034ce:	48 89 c1             	mov    %rax,%rcx
  8034d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034d4:	8b 55 10             	mov    0x10(%rbp),%edx
  8034d7:	48 89 ce             	mov    %rcx,%rsi
  8034da:	89 c7                	mov    %eax,%edi
  8034dc:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
  8034e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034ef:	0f 89 33 01 00 00    	jns    803628 <map_segment+0x1cf>
				return r;
  8034f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034f8:	e9 46 01 00 00       	jmpq   803643 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8034fd:	ba 07 00 00 00       	mov    $0x7,%edx
  803502:	be 00 00 40 00       	mov    $0x400000,%esi
  803507:	bf 00 00 00 00       	mov    $0x0,%edi
  80350c:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
  803518:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80351b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80351f:	79 08                	jns    803529 <map_segment+0xd0>
				return r;
  803521:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803524:	e9 1a 01 00 00       	jmpq   803643 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803529:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352c:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803534:	89 d6                	mov    %edx,%esi
  803536:	89 c7                	mov    %eax,%edi
  803538:	48 b8 1f 23 80 00 00 	movabs $0x80231f,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
  803544:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803547:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80354b:	79 08                	jns    803555 <map_segment+0xfc>
				return r;
  80354d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803550:	e9 ee 00 00 00       	jmpq   803643 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803555:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80355c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355f:	48 98                	cltq   
  803561:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803565:	48 29 c2             	sub    %rax,%rdx
  803568:	48 89 d0             	mov    %rdx,%rax
  80356b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80356f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803572:	48 63 d0             	movslq %eax,%rdx
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	48 39 c2             	cmp    %rax,%rdx
  80357c:	48 0f 47 d0          	cmova  %rax,%rdx
  803580:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803583:	be 00 00 40 00       	mov    $0x400000,%esi
  803588:	89 c7                	mov    %eax,%edi
  80358a:	48 b8 d6 21 80 00 00 	movabs $0x8021d6,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
  803596:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803599:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359d:	79 08                	jns    8035a7 <map_segment+0x14e>
				return r;
  80359f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a2:	e9 9c 00 00 00       	jmpq   803643 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8035a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035aa:	48 63 d0             	movslq %eax,%rdx
  8035ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b1:	48 01 d0             	add    %rdx,%rax
  8035b4:	48 89 c2             	mov    %rax,%rdx
  8035b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035ba:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8035be:	48 89 d1             	mov    %rdx,%rcx
  8035c1:	89 c2                	mov    %eax,%edx
  8035c3:	be 00 00 40 00       	mov    $0x400000,%esi
  8035c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cd:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
  8035d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035e0:	79 30                	jns    803612 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8035e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e5:	89 c1                	mov    %eax,%ecx
  8035e7:	48 ba 7b 51 80 00 00 	movabs $0x80517b,%rdx
  8035ee:	00 00 00 
  8035f1:	be 24 01 00 00       	mov    $0x124,%esi
  8035f6:	48 bf 00 51 80 00 00 	movabs $0x805100,%rdi
  8035fd:	00 00 00 
  803600:	b8 00 00 00 00       	mov    $0x0,%eax
  803605:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  80360c:	00 00 00 
  80360f:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803612:	be 00 00 40 00       	mov    $0x400000,%esi
  803617:	bf 00 00 00 00       	mov    $0x0,%edi
  80361c:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803628:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80362f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803632:	48 98                	cltq   
  803634:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803638:	0f 82 78 fe ff ff    	jb     8034b6 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80363e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803643:	c9                   	leaveq 
  803644:	c3                   	retq   

0000000000803645 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803645:	55                   	push   %rbp
  803646:	48 89 e5             	mov    %rsp,%rbp
  803649:	48 83 ec 20          	sub    $0x20,%rsp
  80364d:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803650:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803657:	00 
  803658:	e9 c9 00 00 00       	jmpq   803726 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  80365d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803661:	48 c1 e8 27          	shr    $0x27,%rax
  803665:	48 89 c2             	mov    %rax,%rdx
  803668:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80366f:	01 00 00 
  803672:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803676:	48 85 c0             	test   %rax,%rax
  803679:	74 3c                	je     8036b7 <copy_shared_pages+0x72>
  80367b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367f:	48 c1 e8 1e          	shr    $0x1e,%rax
  803683:	48 89 c2             	mov    %rax,%rdx
  803686:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80368d:	01 00 00 
  803690:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803694:	48 85 c0             	test   %rax,%rax
  803697:	74 1e                	je     8036b7 <copy_shared_pages+0x72>
  803699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369d:	48 c1 e8 15          	shr    $0x15,%rax
  8036a1:	48 89 c2             	mov    %rax,%rdx
  8036a4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036ab:	01 00 00 
  8036ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036b2:	48 85 c0             	test   %rax,%rax
  8036b5:	75 02                	jne    8036b9 <copy_shared_pages+0x74>
                continue;
  8036b7:	eb 65                	jmp    80371e <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  8036b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8036c1:	48 89 c2             	mov    %rax,%rdx
  8036c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036cb:	01 00 00 
  8036ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036d2:	25 00 04 00 00       	and    $0x400,%eax
  8036d7:	48 85 c0             	test   %rax,%rax
  8036da:	74 42                	je     80371e <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  8036dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8036e4:	48 89 c2             	mov    %rax,%rdx
  8036e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036ee:	01 00 00 
  8036f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8036fa:	89 c6                	mov    %eax,%esi
  8036fc:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803704:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803707:	41 89 f0             	mov    %esi,%r8d
  80370a:	48 89 c6             	mov    %rax,%rsi
  80370d:	bf 00 00 00 00       	mov    $0x0,%edi
  803712:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803719:	00 00 00 
  80371c:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80371e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803725:	00 
  803726:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80372d:	00 00 00 
  803730:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803734:	0f 86 23 ff ff ff    	jbe    80365d <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  80373a:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80373f:	c9                   	leaveq 
  803740:	c3                   	retq   

0000000000803741 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803741:	55                   	push   %rbp
  803742:	48 89 e5             	mov    %rsp,%rbp
  803745:	48 83 ec 20          	sub    $0x20,%rsp
  803749:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80374c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803750:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803753:	48 89 d6             	mov    %rdx,%rsi
  803756:	89 c7                	mov    %eax,%edi
  803758:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
  803764:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376b:	79 05                	jns    803772 <fd2sockid+0x31>
		return r;
  80376d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803770:	eb 24                	jmp    803796 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803776:	8b 10                	mov    (%rax),%edx
  803778:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80377f:	00 00 00 
  803782:	8b 00                	mov    (%rax),%eax
  803784:	39 c2                	cmp    %eax,%edx
  803786:	74 07                	je     80378f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803788:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80378d:	eb 07                	jmp    803796 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80378f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803793:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 20          	sub    $0x20,%rsp
  8037a0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8037a3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037a7:	48 89 c7             	mov    %rax,%rdi
  8037aa:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
  8037b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bd:	78 26                	js     8037e5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8037bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8037c8:	48 89 c6             	mov    %rax,%rsi
  8037cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d0:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e3:	79 16                	jns    8037fb <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8037e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e8:	89 c7                	mov    %eax,%edi
  8037ea:	48 b8 a5 3c 80 00 00 	movabs $0x803ca5,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
		return r;
  8037f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f9:	eb 3a                	jmp    803835 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ff:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803806:	00 00 00 
  803809:	8b 12                	mov    (%rdx),%edx
  80380b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80380d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803811:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80381f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803826:	48 89 c7             	mov    %rax,%rdi
  803829:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
}
  803835:	c9                   	leaveq 
  803836:	c3                   	retq   

0000000000803837 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803837:	55                   	push   %rbp
  803838:	48 89 e5             	mov    %rsp,%rbp
  80383b:	48 83 ec 30          	sub    $0x30,%rsp
  80383f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803842:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803846:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80384d:	89 c7                	mov    %eax,%edi
  80384f:	48 b8 41 37 80 00 00 	movabs $0x803741,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
  80385b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80385e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803862:	79 05                	jns    803869 <accept+0x32>
		return r;
  803864:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803867:	eb 3b                	jmp    8038a4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803869:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80386d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803874:	48 89 ce             	mov    %rcx,%rsi
  803877:	89 c7                	mov    %eax,%edi
  803879:	48 b8 82 3b 80 00 00 	movabs $0x803b82,%rax
  803880:	00 00 00 
  803883:	ff d0                	callq  *%rax
  803885:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803888:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388c:	79 05                	jns    803893 <accept+0x5c>
		return r;
  80388e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803891:	eb 11                	jmp    8038a4 <accept+0x6d>
	return alloc_sockfd(r);
  803893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803896:	89 c7                	mov    %eax,%edi
  803898:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
}
  8038a4:	c9                   	leaveq 
  8038a5:	c3                   	retq   

00000000008038a6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038a6:	55                   	push   %rbp
  8038a7:	48 89 e5             	mov    %rsp,%rbp
  8038aa:	48 83 ec 20          	sub    $0x20,%rsp
  8038ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038b5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038bb:	89 c7                	mov    %eax,%edi
  8038bd:	48 b8 41 37 80 00 00 	movabs $0x803741,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
  8038c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d0:	79 05                	jns    8038d7 <bind+0x31>
		return r;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d5:	eb 1b                	jmp    8038f2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8038d7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e1:	48 89 ce             	mov    %rcx,%rsi
  8038e4:	89 c7                	mov    %eax,%edi
  8038e6:	48 b8 01 3c 80 00 00 	movabs $0x803c01,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
}
  8038f2:	c9                   	leaveq 
  8038f3:	c3                   	retq   

00000000008038f4 <shutdown>:

int
shutdown(int s, int how)
{
  8038f4:	55                   	push   %rbp
  8038f5:	48 89 e5             	mov    %rsp,%rbp
  8038f8:	48 83 ec 20          	sub    $0x20,%rsp
  8038fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803902:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803905:	89 c7                	mov    %eax,%edi
  803907:	48 b8 41 37 80 00 00 	movabs $0x803741,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
  803913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391a:	79 05                	jns    803921 <shutdown+0x2d>
		return r;
  80391c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391f:	eb 16                	jmp    803937 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803921:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803927:	89 d6                	mov    %edx,%esi
  803929:	89 c7                	mov    %eax,%edi
  80392b:	48 b8 65 3c 80 00 00 	movabs $0x803c65,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
}
  803937:	c9                   	leaveq 
  803938:	c3                   	retq   

0000000000803939 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803939:	55                   	push   %rbp
  80393a:	48 89 e5             	mov    %rsp,%rbp
  80393d:	48 83 ec 10          	sub    $0x10,%rsp
  803941:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803945:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803949:	48 89 c7             	mov    %rax,%rdi
  80394c:	48 b8 b3 49 80 00 00 	movabs $0x8049b3,%rax
  803953:	00 00 00 
  803956:	ff d0                	callq  *%rax
  803958:	83 f8 01             	cmp    $0x1,%eax
  80395b:	75 17                	jne    803974 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80395d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803961:	8b 40 0c             	mov    0xc(%rax),%eax
  803964:	89 c7                	mov    %eax,%edi
  803966:	48 b8 a5 3c 80 00 00 	movabs $0x803ca5,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
  803972:	eb 05                	jmp    803979 <devsock_close+0x40>
	else
		return 0;
  803974:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803979:	c9                   	leaveq 
  80397a:	c3                   	retq   

000000000080397b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80397b:	55                   	push   %rbp
  80397c:	48 89 e5             	mov    %rsp,%rbp
  80397f:	48 83 ec 20          	sub    $0x20,%rsp
  803983:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803986:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80398a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80398d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803990:	89 c7                	mov    %eax,%edi
  803992:	48 b8 41 37 80 00 00 	movabs $0x803741,%rax
  803999:	00 00 00 
  80399c:	ff d0                	callq  *%rax
  80399e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a5:	79 05                	jns    8039ac <connect+0x31>
		return r;
  8039a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039aa:	eb 1b                	jmp    8039c7 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8039ac:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039af:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b6:	48 89 ce             	mov    %rcx,%rsi
  8039b9:	89 c7                	mov    %eax,%edi
  8039bb:	48 b8 d2 3c 80 00 00 	movabs $0x803cd2,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	callq  *%rax
}
  8039c7:	c9                   	leaveq 
  8039c8:	c3                   	retq   

00000000008039c9 <listen>:

int
listen(int s, int backlog)
{
  8039c9:	55                   	push   %rbp
  8039ca:	48 89 e5             	mov    %rsp,%rbp
  8039cd:	48 83 ec 20          	sub    $0x20,%rsp
  8039d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039d4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039da:	89 c7                	mov    %eax,%edi
  8039dc:	48 b8 41 37 80 00 00 	movabs $0x803741,%rax
  8039e3:	00 00 00 
  8039e6:	ff d0                	callq  *%rax
  8039e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ef:	79 05                	jns    8039f6 <listen+0x2d>
		return r;
  8039f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f4:	eb 16                	jmp    803a0c <listen+0x43>
	return nsipc_listen(r, backlog);
  8039f6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	89 d6                	mov    %edx,%esi
  8039fe:	89 c7                	mov    %eax,%edi
  803a00:	48 b8 36 3d 80 00 00 	movabs $0x803d36,%rax
  803a07:	00 00 00 
  803a0a:	ff d0                	callq  *%rax
}
  803a0c:	c9                   	leaveq 
  803a0d:	c3                   	retq   

0000000000803a0e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a0e:	55                   	push   %rbp
  803a0f:	48 89 e5             	mov    %rsp,%rbp
  803a12:	48 83 ec 20          	sub    $0x20,%rsp
  803a16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a1e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a26:	89 c2                	mov    %eax,%edx
  803a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2c:	8b 40 0c             	mov    0xc(%rax),%eax
  803a2f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a33:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a38:	89 c7                	mov    %eax,%edi
  803a3a:	48 b8 76 3d 80 00 00 	movabs $0x803d76,%rax
  803a41:	00 00 00 
  803a44:	ff d0                	callq  *%rax
}
  803a46:	c9                   	leaveq 
  803a47:	c3                   	retq   

0000000000803a48 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a48:	55                   	push   %rbp
  803a49:	48 89 e5             	mov    %rsp,%rbp
  803a4c:	48 83 ec 20          	sub    $0x20,%rsp
  803a50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a58:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a60:	89 c2                	mov    %eax,%edx
  803a62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a66:	8b 40 0c             	mov    0xc(%rax),%eax
  803a69:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a72:	89 c7                	mov    %eax,%edi
  803a74:	48 b8 42 3e 80 00 00 	movabs $0x803e42,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 10          	sub    $0x10,%rsp
  803a8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a96:	48 be 9d 51 80 00 00 	movabs $0x80519d,%rsi
  803a9d:	00 00 00 
  803aa0:	48 89 c7             	mov    %rax,%rdi
  803aa3:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
	return 0;
  803aaf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ab4:	c9                   	leaveq 
  803ab5:	c3                   	retq   

0000000000803ab6 <socket>:

int
socket(int domain, int type, int protocol)
{
  803ab6:	55                   	push   %rbp
  803ab7:	48 89 e5             	mov    %rsp,%rbp
  803aba:	48 83 ec 20          	sub    $0x20,%rsp
  803abe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ac1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ac4:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803ac7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803aca:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803acd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ad0:	89 ce                	mov    %ecx,%esi
  803ad2:	89 c7                	mov    %eax,%edi
  803ad4:	48 b8 fa 3e 80 00 00 	movabs $0x803efa,%rax
  803adb:	00 00 00 
  803ade:	ff d0                	callq  *%rax
  803ae0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae7:	79 05                	jns    803aee <socket+0x38>
		return r;
  803ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aec:	eb 11                	jmp    803aff <socket+0x49>
	return alloc_sockfd(r);
  803aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af1:	89 c7                	mov    %eax,%edi
  803af3:	48 b8 98 37 80 00 00 	movabs $0x803798,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
}
  803aff:	c9                   	leaveq 
  803b00:	c3                   	retq   

0000000000803b01 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b01:	55                   	push   %rbp
  803b02:	48 89 e5             	mov    %rsp,%rbp
  803b05:	48 83 ec 10          	sub    $0x10,%rsp
  803b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b0c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b13:	00 00 00 
  803b16:	8b 00                	mov    (%rax),%eax
  803b18:	85 c0                	test   %eax,%eax
  803b1a:	75 1d                	jne    803b39 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803b1c:	bf 02 00 00 00       	mov    $0x2,%edi
  803b21:	48 b8 31 49 80 00 00 	movabs $0x804931,%rax
  803b28:	00 00 00 
  803b2b:	ff d0                	callq  *%rax
  803b2d:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803b34:	00 00 00 
  803b37:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b39:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b40:	00 00 00 
  803b43:	8b 00                	mov    (%rax),%eax
  803b45:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b48:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b4d:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b54:	00 00 00 
  803b57:	89 c7                	mov    %eax,%edi
  803b59:	48 b8 cf 48 80 00 00 	movabs $0x8048cf,%rax
  803b60:	00 00 00 
  803b63:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b65:	ba 00 00 00 00       	mov    $0x0,%edx
  803b6a:	be 00 00 00 00       	mov    $0x0,%esi
  803b6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b74:	48 b8 c9 47 80 00 00 	movabs $0x8047c9,%rax
  803b7b:	00 00 00 
  803b7e:	ff d0                	callq  *%rax
}
  803b80:	c9                   	leaveq 
  803b81:	c3                   	retq   

0000000000803b82 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b82:	55                   	push   %rbp
  803b83:	48 89 e5             	mov    %rsp,%rbp
  803b86:	48 83 ec 30          	sub    $0x30,%rsp
  803b8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b9c:	00 00 00 
  803b9f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ba2:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ba4:	bf 01 00 00 00       	mov    $0x1,%edi
  803ba9:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803bb0:	00 00 00 
  803bb3:	ff d0                	callq  *%rax
  803bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bbc:	78 3e                	js     803bfc <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803bbe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc5:	00 00 00 
  803bc8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803bcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd0:	8b 40 10             	mov    0x10(%rax),%eax
  803bd3:	89 c2                	mov    %eax,%edx
  803bd5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803bd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bdd:	48 89 ce             	mov    %rcx,%rsi
  803be0:	48 89 c7             	mov    %rax,%rdi
  803be3:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803bea:	00 00 00 
  803bed:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf3:	8b 50 10             	mov    0x10(%rax),%edx
  803bf6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfa:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bff:	c9                   	leaveq 
  803c00:	c3                   	retq   

0000000000803c01 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c01:	55                   	push   %rbp
  803c02:	48 89 e5             	mov    %rsp,%rbp
  803c05:	48 83 ec 10          	sub    $0x10,%rsp
  803c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c10:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803c13:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1a:	00 00 00 
  803c1d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c20:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c22:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c29:	48 89 c6             	mov    %rax,%rsi
  803c2c:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c33:	00 00 00 
  803c36:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803c3d:	00 00 00 
  803c40:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803c42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c49:	00 00 00 
  803c4c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c4f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c52:	bf 02 00 00 00       	mov    $0x2,%edi
  803c57:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 10          	sub    $0x10,%rsp
  803c6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c70:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c73:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7a:	00 00 00 
  803c7d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c80:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c89:	00 00 00 
  803c8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c8f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c92:	bf 03 00 00 00       	mov    $0x3,%edi
  803c97:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803c9e:	00 00 00 
  803ca1:	ff d0                	callq  *%rax
}
  803ca3:	c9                   	leaveq 
  803ca4:	c3                   	retq   

0000000000803ca5 <nsipc_close>:

int
nsipc_close(int s)
{
  803ca5:	55                   	push   %rbp
  803ca6:	48 89 e5             	mov    %rsp,%rbp
  803ca9:	48 83 ec 10          	sub    $0x10,%rsp
  803cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803cb0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb7:	00 00 00 
  803cba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cbd:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803cbf:	bf 04 00 00 00       	mov    $0x4,%edi
  803cc4:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
}
  803cd0:	c9                   	leaveq 
  803cd1:	c3                   	retq   

0000000000803cd2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803cd2:	55                   	push   %rbp
  803cd3:	48 89 e5             	mov    %rsp,%rbp
  803cd6:	48 83 ec 10          	sub    $0x10,%rsp
  803cda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ce1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ce4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ceb:	00 00 00 
  803cee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cf1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803cf3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfa:	48 89 c6             	mov    %rax,%rsi
  803cfd:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d04:	00 00 00 
  803d07:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803d13:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1a:	00 00 00 
  803d1d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d20:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803d23:	bf 05 00 00 00       	mov    $0x5,%edi
  803d28:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
}
  803d34:	c9                   	leaveq 
  803d35:	c3                   	retq   

0000000000803d36 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803d36:	55                   	push   %rbp
  803d37:	48 89 e5             	mov    %rsp,%rbp
  803d3a:	48 83 ec 10          	sub    $0x10,%rsp
  803d3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d41:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803d44:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4b:	00 00 00 
  803d4e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d51:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d5a:	00 00 00 
  803d5d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d60:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d63:	bf 06 00 00 00       	mov    $0x6,%edi
  803d68:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
}
  803d74:	c9                   	leaveq 
  803d75:	c3                   	retq   

0000000000803d76 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d76:	55                   	push   %rbp
  803d77:	48 89 e5             	mov    %rsp,%rbp
  803d7a:	48 83 ec 30          	sub    $0x30,%rsp
  803d7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d85:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d88:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d92:	00 00 00 
  803d95:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d98:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d9a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da1:	00 00 00 
  803da4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803da7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803daa:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803db1:	00 00 00 
  803db4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803db7:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803dba:	bf 07 00 00 00       	mov    $0x7,%edi
  803dbf:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803dc6:	00 00 00 
  803dc9:	ff d0                	callq  *%rax
  803dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd2:	78 69                	js     803e3d <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803dd4:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ddb:	7f 08                	jg     803de5 <nsipc_recv+0x6f>
  803ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803de3:	7e 35                	jle    803e1a <nsipc_recv+0xa4>
  803de5:	48 b9 a4 51 80 00 00 	movabs $0x8051a4,%rcx
  803dec:	00 00 00 
  803def:	48 ba b9 51 80 00 00 	movabs $0x8051b9,%rdx
  803df6:	00 00 00 
  803df9:	be 61 00 00 00       	mov    $0x61,%esi
  803dfe:	48 bf ce 51 80 00 00 	movabs $0x8051ce,%rdi
  803e05:	00 00 00 
  803e08:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0d:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803e14:	00 00 00 
  803e17:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1d:	48 63 d0             	movslq %eax,%rdx
  803e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e24:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803e2b:	00 00 00 
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
	}

	return r;
  803e3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e40:	c9                   	leaveq 
  803e41:	c3                   	retq   

0000000000803e42 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e42:	55                   	push   %rbp
  803e43:	48 89 e5             	mov    %rsp,%rbp
  803e46:	48 83 ec 20          	sub    $0x20,%rsp
  803e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e51:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e54:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e57:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e5e:	00 00 00 
  803e61:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e64:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e66:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e6d:	7e 35                	jle    803ea4 <nsipc_send+0x62>
  803e6f:	48 b9 da 51 80 00 00 	movabs $0x8051da,%rcx
  803e76:	00 00 00 
  803e79:	48 ba b9 51 80 00 00 	movabs $0x8051b9,%rdx
  803e80:	00 00 00 
  803e83:	be 6c 00 00 00       	mov    $0x6c,%esi
  803e88:	48 bf ce 51 80 00 00 	movabs $0x8051ce,%rdi
  803e8f:	00 00 00 
  803e92:	b8 00 00 00 00       	mov    $0x0,%eax
  803e97:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803e9e:	00 00 00 
  803ea1:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ea4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ea7:	48 63 d0             	movslq %eax,%rdx
  803eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eae:	48 89 c6             	mov    %rax,%rsi
  803eb1:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803eb8:	00 00 00 
  803ebb:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803ec2:	00 00 00 
  803ec5:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ec7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ece:	00 00 00 
  803ed1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ed4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803ed7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ede:	00 00 00 
  803ee1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ee4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803ee7:	bf 08 00 00 00       	mov    $0x8,%edi
  803eec:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
}
  803ef8:	c9                   	leaveq 
  803ef9:	c3                   	retq   

0000000000803efa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803efa:	55                   	push   %rbp
  803efb:	48 89 e5             	mov    %rsp,%rbp
  803efe:	48 83 ec 10          	sub    $0x10,%rsp
  803f02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f05:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f08:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803f0b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f12:	00 00 00 
  803f15:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f18:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803f1a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f21:	00 00 00 
  803f24:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f27:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803f2a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f31:	00 00 00 
  803f34:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803f37:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803f3a:	bf 09 00 00 00       	mov    $0x9,%edi
  803f3f:	48 b8 01 3b 80 00 00 	movabs $0x803b01,%rax
  803f46:	00 00 00 
  803f49:	ff d0                	callq  *%rax
}
  803f4b:	c9                   	leaveq 
  803f4c:	c3                   	retq   

0000000000803f4d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f4d:	55                   	push   %rbp
  803f4e:	48 89 e5             	mov    %rsp,%rbp
  803f51:	53                   	push   %rbx
  803f52:	48 83 ec 38          	sub    $0x38,%rsp
  803f56:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f5a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f5e:	48 89 c7             	mov    %rax,%rdi
  803f61:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
  803f6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f74:	0f 88 bf 01 00 00    	js     804139 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f7e:	ba 07 04 00 00       	mov    $0x407,%edx
  803f83:	48 89 c6             	mov    %rax,%rsi
  803f86:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8b:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803f92:	00 00 00 
  803f95:	ff d0                	callq  *%rax
  803f97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f9e:	0f 88 95 01 00 00    	js     804139 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803fa4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803fa8:	48 89 c7             	mov    %rax,%rdi
  803fab:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  803fb2:	00 00 00 
  803fb5:	ff d0                	callq  *%rax
  803fb7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fbe:	0f 88 5d 01 00 00    	js     804121 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fc4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fc8:	ba 07 04 00 00       	mov    $0x407,%edx
  803fcd:	48 89 c6             	mov    %rax,%rsi
  803fd0:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd5:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803fdc:	00 00 00 
  803fdf:	ff d0                	callq  *%rax
  803fe1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fe4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fe8:	0f 88 33 01 00 00    	js     804121 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803fee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff2:	48 89 c7             	mov    %rax,%rdi
  803ff5:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  803ffc:	00 00 00 
  803fff:	ff d0                	callq  *%rax
  804001:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804005:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804009:	ba 07 04 00 00       	mov    $0x407,%edx
  80400e:	48 89 c6             	mov    %rax,%rsi
  804011:	bf 00 00 00 00       	mov    $0x0,%edi
  804016:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80401d:	00 00 00 
  804020:	ff d0                	callq  *%rax
  804022:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804025:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804029:	79 05                	jns    804030 <pipe+0xe3>
		goto err2;
  80402b:	e9 d9 00 00 00       	jmpq   804109 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804030:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804034:	48 89 c7             	mov    %rax,%rdi
  804037:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  80403e:	00 00 00 
  804041:	ff d0                	callq  *%rax
  804043:	48 89 c2             	mov    %rax,%rdx
  804046:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80404a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804050:	48 89 d1             	mov    %rdx,%rcx
  804053:	ba 00 00 00 00       	mov    $0x0,%edx
  804058:	48 89 c6             	mov    %rax,%rsi
  80405b:	bf 00 00 00 00       	mov    $0x0,%edi
  804060:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  804067:	00 00 00 
  80406a:	ff d0                	callq  *%rax
  80406c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80406f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804073:	79 1b                	jns    804090 <pipe+0x143>
		goto err3;
  804075:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804076:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80407a:	48 89 c6             	mov    %rax,%rsi
  80407d:	bf 00 00 00 00       	mov    $0x0,%edi
  804082:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
  80408e:	eb 79                	jmp    804109 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804090:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804094:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80409b:	00 00 00 
  80409e:	8b 12                	mov    (%rdx),%edx
  8040a0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8040a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8040ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040b1:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8040b8:	00 00 00 
  8040bb:	8b 12                	mov    (%rdx),%edx
  8040bd:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8040bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8040ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ce:	48 89 c7             	mov    %rax,%rdi
  8040d1:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8040d8:	00 00 00 
  8040db:	ff d0                	callq  *%rax
  8040dd:	89 c2                	mov    %eax,%edx
  8040df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040e3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8040e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040e9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8040ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040f1:	48 89 c7             	mov    %rax,%rdi
  8040f4:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8040fb:	00 00 00 
  8040fe:	ff d0                	callq  *%rax
  804100:	89 03                	mov    %eax,(%rbx)
	return 0;
  804102:	b8 00 00 00 00       	mov    $0x0,%eax
  804107:	eb 33                	jmp    80413c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804109:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80410d:	48 89 c6             	mov    %rax,%rsi
  804110:	bf 00 00 00 00       	mov    $0x0,%edi
  804115:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80411c:	00 00 00 
  80411f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804121:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804125:	48 89 c6             	mov    %rax,%rsi
  804128:	bf 00 00 00 00       	mov    $0x0,%edi
  80412d:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
err:
	return r;
  804139:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80413c:	48 83 c4 38          	add    $0x38,%rsp
  804140:	5b                   	pop    %rbx
  804141:	5d                   	pop    %rbp
  804142:	c3                   	retq   

0000000000804143 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804143:	55                   	push   %rbp
  804144:	48 89 e5             	mov    %rsp,%rbp
  804147:	53                   	push   %rbx
  804148:	48 83 ec 28          	sub    $0x28,%rsp
  80414c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804150:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804154:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80415b:	00 00 00 
  80415e:	48 8b 00             	mov    (%rax),%rax
  804161:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804167:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80416a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80416e:	48 89 c7             	mov    %rax,%rdi
  804171:	48 b8 b3 49 80 00 00 	movabs $0x8049b3,%rax
  804178:	00 00 00 
  80417b:	ff d0                	callq  *%rax
  80417d:	89 c3                	mov    %eax,%ebx
  80417f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804183:	48 89 c7             	mov    %rax,%rdi
  804186:	48 b8 b3 49 80 00 00 	movabs $0x8049b3,%rax
  80418d:	00 00 00 
  804190:	ff d0                	callq  *%rax
  804192:	39 c3                	cmp    %eax,%ebx
  804194:	0f 94 c0             	sete   %al
  804197:	0f b6 c0             	movzbl %al,%eax
  80419a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80419d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041a4:	00 00 00 
  8041a7:	48 8b 00             	mov    (%rax),%rax
  8041aa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041b0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8041b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041b9:	75 05                	jne    8041c0 <_pipeisclosed+0x7d>
			return ret;
  8041bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8041be:	eb 4f                	jmp    80420f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8041c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8041c6:	74 42                	je     80420a <_pipeisclosed+0xc7>
  8041c8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8041cc:	75 3c                	jne    80420a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8041ce:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8041d5:	00 00 00 
  8041d8:	48 8b 00             	mov    (%rax),%rax
  8041db:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8041e1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8041e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041e7:	89 c6                	mov    %eax,%esi
  8041e9:	48 bf eb 51 80 00 00 	movabs $0x8051eb,%rdi
  8041f0:	00 00 00 
  8041f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f8:	49 b8 ce 03 80 00 00 	movabs $0x8003ce,%r8
  8041ff:	00 00 00 
  804202:	41 ff d0             	callq  *%r8
	}
  804205:	e9 4a ff ff ff       	jmpq   804154 <_pipeisclosed+0x11>
  80420a:	e9 45 ff ff ff       	jmpq   804154 <_pipeisclosed+0x11>
}
  80420f:	48 83 c4 28          	add    $0x28,%rsp
  804213:	5b                   	pop    %rbx
  804214:	5d                   	pop    %rbp
  804215:	c3                   	retq   

0000000000804216 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804216:	55                   	push   %rbp
  804217:	48 89 e5             	mov    %rsp,%rbp
  80421a:	48 83 ec 30          	sub    $0x30,%rsp
  80421e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804221:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804225:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804228:	48 89 d6             	mov    %rdx,%rsi
  80422b:	89 c7                	mov    %eax,%edi
  80422d:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  804234:	00 00 00 
  804237:	ff d0                	callq  *%rax
  804239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80423c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804240:	79 05                	jns    804247 <pipeisclosed+0x31>
		return r;
  804242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804245:	eb 31                	jmp    804278 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80424b:	48 89 c7             	mov    %rax,%rdi
  80424e:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  804255:	00 00 00 
  804258:	ff d0                	callq  *%rax
  80425a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80425e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804262:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804266:	48 89 d6             	mov    %rdx,%rsi
  804269:	48 89 c7             	mov    %rax,%rdi
  80426c:	48 b8 43 41 80 00 00 	movabs $0x804143,%rax
  804273:	00 00 00 
  804276:	ff d0                	callq  *%rax
}
  804278:	c9                   	leaveq 
  804279:	c3                   	retq   

000000000080427a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80427a:	55                   	push   %rbp
  80427b:	48 89 e5             	mov    %rsp,%rbp
  80427e:	48 83 ec 40          	sub    $0x40,%rsp
  804282:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804286:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80428a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80428e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804292:	48 89 c7             	mov    %rax,%rdi
  804295:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
  8042a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042b4:	00 
  8042b5:	e9 92 00 00 00       	jmpq   80434c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8042ba:	eb 41                	jmp    8042fd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8042bc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042c1:	74 09                	je     8042cc <devpipe_read+0x52>
				return i;
  8042c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c7:	e9 92 00 00 00       	jmpq   80435e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8042cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d4:	48 89 d6             	mov    %rdx,%rsi
  8042d7:	48 89 c7             	mov    %rax,%rdi
  8042da:	48 b8 43 41 80 00 00 	movabs $0x804143,%rax
  8042e1:	00 00 00 
  8042e4:	ff d0                	callq  *%rax
  8042e6:	85 c0                	test   %eax,%eax
  8042e8:	74 07                	je     8042f1 <devpipe_read+0x77>
				return 0;
  8042ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ef:	eb 6d                	jmp    80435e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8042f1:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8042f8:	00 00 00 
  8042fb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8042fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804301:	8b 10                	mov    (%rax),%edx
  804303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804307:	8b 40 04             	mov    0x4(%rax),%eax
  80430a:	39 c2                	cmp    %eax,%edx
  80430c:	74 ae                	je     8042bc <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80430e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804312:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804316:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80431a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431e:	8b 00                	mov    (%rax),%eax
  804320:	99                   	cltd   
  804321:	c1 ea 1b             	shr    $0x1b,%edx
  804324:	01 d0                	add    %edx,%eax
  804326:	83 e0 1f             	and    $0x1f,%eax
  804329:	29 d0                	sub    %edx,%eax
  80432b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80432f:	48 98                	cltq   
  804331:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804336:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433c:	8b 00                	mov    (%rax),%eax
  80433e:	8d 50 01             	lea    0x1(%rax),%edx
  804341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804345:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804347:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80434c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804350:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804354:	0f 82 60 ff ff ff    	jb     8042ba <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80435a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80435e:	c9                   	leaveq 
  80435f:	c3                   	retq   

0000000000804360 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804360:	55                   	push   %rbp
  804361:	48 89 e5             	mov    %rsp,%rbp
  804364:	48 83 ec 40          	sub    $0x40,%rsp
  804368:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80436c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804370:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804378:	48 89 c7             	mov    %rax,%rdi
  80437b:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
  804387:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80438b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80438f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804393:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80439a:	00 
  80439b:	e9 8e 00 00 00       	jmpq   80442e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043a0:	eb 31                	jmp    8043d3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8043a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043aa:	48 89 d6             	mov    %rdx,%rsi
  8043ad:	48 89 c7             	mov    %rax,%rdi
  8043b0:	48 b8 43 41 80 00 00 	movabs $0x804143,%rax
  8043b7:	00 00 00 
  8043ba:	ff d0                	callq  *%rax
  8043bc:	85 c0                	test   %eax,%eax
  8043be:	74 07                	je     8043c7 <devpipe_write+0x67>
				return 0;
  8043c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c5:	eb 79                	jmp    804440 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8043c7:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  8043ce:	00 00 00 
  8043d1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8043d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d7:	8b 40 04             	mov    0x4(%rax),%eax
  8043da:	48 63 d0             	movslq %eax,%rdx
  8043dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e1:	8b 00                	mov    (%rax),%eax
  8043e3:	48 98                	cltq   
  8043e5:	48 83 c0 20          	add    $0x20,%rax
  8043e9:	48 39 c2             	cmp    %rax,%rdx
  8043ec:	73 b4                	jae    8043a2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8043ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f2:	8b 40 04             	mov    0x4(%rax),%eax
  8043f5:	99                   	cltd   
  8043f6:	c1 ea 1b             	shr    $0x1b,%edx
  8043f9:	01 d0                	add    %edx,%eax
  8043fb:	83 e0 1f             	and    $0x1f,%eax
  8043fe:	29 d0                	sub    %edx,%eax
  804400:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804404:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804408:	48 01 ca             	add    %rcx,%rdx
  80440b:	0f b6 0a             	movzbl (%rdx),%ecx
  80440e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804412:	48 98                	cltq   
  804414:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441c:	8b 40 04             	mov    0x4(%rax),%eax
  80441f:	8d 50 01             	lea    0x1(%rax),%edx
  804422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804426:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804429:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80442e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804432:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804436:	0f 82 64 ff ff ff    	jb     8043a0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80443c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804440:	c9                   	leaveq 
  804441:	c3                   	retq   

0000000000804442 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804442:	55                   	push   %rbp
  804443:	48 89 e5             	mov    %rsp,%rbp
  804446:	48 83 ec 20          	sub    $0x20,%rsp
  80444a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80444e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804456:	48 89 c7             	mov    %rax,%rdi
  804459:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  804460:	00 00 00 
  804463:	ff d0                	callq  *%rax
  804465:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804469:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80446d:	48 be fe 51 80 00 00 	movabs $0x8051fe,%rsi
  804474:	00 00 00 
  804477:	48 89 c7             	mov    %rax,%rdi
  80447a:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  804481:	00 00 00 
  804484:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448a:	8b 50 04             	mov    0x4(%rax),%edx
  80448d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804491:	8b 00                	mov    (%rax),%eax
  804493:	29 c2                	sub    %eax,%edx
  804495:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804499:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80449f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8044aa:	00 00 00 
	stat->st_dev = &devpipe;
  8044ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b1:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8044b8:	00 00 00 
  8044bb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8044c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044c7:	c9                   	leaveq 
  8044c8:	c3                   	retq   

00000000008044c9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8044c9:	55                   	push   %rbp
  8044ca:	48 89 e5             	mov    %rsp,%rbp
  8044cd:	48 83 ec 10          	sub    $0x10,%rsp
  8044d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8044d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d9:	48 89 c6             	mov    %rax,%rsi
  8044dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e1:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8044e8:	00 00 00 
  8044eb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8044ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f1:	48 89 c7             	mov    %rax,%rdi
  8044f4:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
  804500:	48 89 c6             	mov    %rax,%rsi
  804503:	bf 00 00 00 00       	mov    $0x0,%edi
  804508:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80450f:	00 00 00 
  804512:	ff d0                	callq  *%rax
}
  804514:	c9                   	leaveq 
  804515:	c3                   	retq   

0000000000804516 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804516:	55                   	push   %rbp
  804517:	48 89 e5             	mov    %rsp,%rbp
  80451a:	48 83 ec 20          	sub    $0x20,%rsp
  80451e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804521:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804524:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804527:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80452b:	be 01 00 00 00       	mov    $0x1,%esi
  804530:	48 89 c7             	mov    %rax,%rdi
  804533:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  80453a:	00 00 00 
  80453d:	ff d0                	callq  *%rax
}
  80453f:	c9                   	leaveq 
  804540:	c3                   	retq   

0000000000804541 <getchar>:

int
getchar(void)
{
  804541:	55                   	push   %rbp
  804542:	48 89 e5             	mov    %rsp,%rbp
  804545:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804549:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80454d:	ba 01 00 00 00       	mov    $0x1,%edx
  804552:	48 89 c6             	mov    %rax,%rsi
  804555:	bf 00 00 00 00       	mov    $0x0,%edi
  80455a:	48 b8 01 21 80 00 00 	movabs $0x802101,%rax
  804561:	00 00 00 
  804564:	ff d0                	callq  *%rax
  804566:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456d:	79 05                	jns    804574 <getchar+0x33>
		return r;
  80456f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804572:	eb 14                	jmp    804588 <getchar+0x47>
	if (r < 1)
  804574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804578:	7f 07                	jg     804581 <getchar+0x40>
		return -E_EOF;
  80457a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80457f:	eb 07                	jmp    804588 <getchar+0x47>
	return c;
  804581:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804585:	0f b6 c0             	movzbl %al,%eax
}
  804588:	c9                   	leaveq 
  804589:	c3                   	retq   

000000000080458a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80458a:	55                   	push   %rbp
  80458b:	48 89 e5             	mov    %rsp,%rbp
  80458e:	48 83 ec 20          	sub    $0x20,%rsp
  804592:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804595:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804599:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80459c:	48 89 d6             	mov    %rdx,%rsi
  80459f:	89 c7                	mov    %eax,%edi
  8045a1:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  8045a8:	00 00 00 
  8045ab:	ff d0                	callq  *%rax
  8045ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b4:	79 05                	jns    8045bb <iscons+0x31>
		return r;
  8045b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b9:	eb 1a                	jmp    8045d5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8045bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bf:	8b 10                	mov    (%rax),%edx
  8045c1:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8045c8:	00 00 00 
  8045cb:	8b 00                	mov    (%rax),%eax
  8045cd:	39 c2                	cmp    %eax,%edx
  8045cf:	0f 94 c0             	sete   %al
  8045d2:	0f b6 c0             	movzbl %al,%eax
}
  8045d5:	c9                   	leaveq 
  8045d6:	c3                   	retq   

00000000008045d7 <opencons>:

int
opencons(void)
{
  8045d7:	55                   	push   %rbp
  8045d8:	48 89 e5             	mov    %rsp,%rbp
  8045db:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8045df:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8045e3:	48 89 c7             	mov    %rax,%rdi
  8045e6:	48 b8 37 1c 80 00 00 	movabs $0x801c37,%rax
  8045ed:	00 00 00 
  8045f0:	ff d0                	callq  *%rax
  8045f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f9:	79 05                	jns    804600 <opencons+0x29>
		return r;
  8045fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fe:	eb 5b                	jmp    80465b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804604:	ba 07 04 00 00       	mov    $0x407,%edx
  804609:	48 89 c6             	mov    %rax,%rsi
  80460c:	bf 00 00 00 00       	mov    $0x0,%edi
  804611:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  804618:	00 00 00 
  80461b:	ff d0                	callq  *%rax
  80461d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804620:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804624:	79 05                	jns    80462b <opencons+0x54>
		return r;
  804626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804629:	eb 30                	jmp    80465b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80462b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80462f:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804636:	00 00 00 
  804639:	8b 12                	mov    (%rdx),%edx
  80463b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80463d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804641:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804648:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80464c:	48 89 c7             	mov    %rax,%rdi
  80464f:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  804656:	00 00 00 
  804659:	ff d0                	callq  *%rax
}
  80465b:	c9                   	leaveq 
  80465c:	c3                   	retq   

000000000080465d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80465d:	55                   	push   %rbp
  80465e:	48 89 e5             	mov    %rsp,%rbp
  804661:	48 83 ec 30          	sub    $0x30,%rsp
  804665:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804669:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80466d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804671:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804676:	75 07                	jne    80467f <devcons_read+0x22>
		return 0;
  804678:	b8 00 00 00 00       	mov    $0x0,%eax
  80467d:	eb 4b                	jmp    8046ca <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80467f:	eb 0c                	jmp    80468d <devcons_read+0x30>
		sys_yield();
  804681:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  804688:	00 00 00 
  80468b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80468d:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  804694:	00 00 00 
  804697:	ff d0                	callq  *%rax
  804699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80469c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a0:	74 df                	je     804681 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8046a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a6:	79 05                	jns    8046ad <devcons_read+0x50>
		return c;
  8046a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ab:	eb 1d                	jmp    8046ca <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8046ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046b1:	75 07                	jne    8046ba <devcons_read+0x5d>
		return 0;
  8046b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8046b8:	eb 10                	jmp    8046ca <devcons_read+0x6d>
	*(char*)vbuf = c;
  8046ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046bd:	89 c2                	mov    %eax,%edx
  8046bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046c3:	88 10                	mov    %dl,(%rax)
	return 1;
  8046c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8046ca:	c9                   	leaveq 
  8046cb:	c3                   	retq   

00000000008046cc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046cc:	55                   	push   %rbp
  8046cd:	48 89 e5             	mov    %rsp,%rbp
  8046d0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8046d7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8046de:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8046e5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046f3:	eb 76                	jmp    80476b <devcons_write+0x9f>
		m = n - tot;
  8046f5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8046fc:	89 c2                	mov    %eax,%edx
  8046fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804701:	29 c2                	sub    %eax,%edx
  804703:	89 d0                	mov    %edx,%eax
  804705:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804708:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80470b:	83 f8 7f             	cmp    $0x7f,%eax
  80470e:	76 07                	jbe    804717 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804710:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804717:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80471a:	48 63 d0             	movslq %eax,%rdx
  80471d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804720:	48 63 c8             	movslq %eax,%rcx
  804723:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80472a:	48 01 c1             	add    %rax,%rcx
  80472d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804734:	48 89 ce             	mov    %rcx,%rsi
  804737:	48 89 c7             	mov    %rax,%rdi
  80473a:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  804741:	00 00 00 
  804744:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804746:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804749:	48 63 d0             	movslq %eax,%rdx
  80474c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804753:	48 89 d6             	mov    %rdx,%rsi
  804756:	48 89 c7             	mov    %rax,%rdi
  804759:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  804760:	00 00 00 
  804763:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804765:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804768:	01 45 fc             	add    %eax,-0x4(%rbp)
  80476b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80476e:	48 98                	cltq   
  804770:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804777:	0f 82 78 ff ff ff    	jb     8046f5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80477d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804780:	c9                   	leaveq 
  804781:	c3                   	retq   

0000000000804782 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804782:	55                   	push   %rbp
  804783:	48 89 e5             	mov    %rsp,%rbp
  804786:	48 83 ec 08          	sub    $0x8,%rsp
  80478a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80478e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804793:	c9                   	leaveq 
  804794:	c3                   	retq   

0000000000804795 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804795:	55                   	push   %rbp
  804796:	48 89 e5             	mov    %rsp,%rbp
  804799:	48 83 ec 10          	sub    $0x10,%rsp
  80479d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a9:	48 be 0a 52 80 00 00 	movabs $0x80520a,%rsi
  8047b0:	00 00 00 
  8047b3:	48 89 c7             	mov    %rax,%rdi
  8047b6:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8047bd:	00 00 00 
  8047c0:	ff d0                	callq  *%rax
	return 0;
  8047c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047c7:	c9                   	leaveq 
  8047c8:	c3                   	retq   

00000000008047c9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8047c9:	55                   	push   %rbp
  8047ca:	48 89 e5             	mov    %rsp,%rbp
  8047cd:	48 83 ec 30          	sub    $0x30,%rsp
  8047d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8047dd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8047e4:	00 00 00 
  8047e7:	48 8b 00             	mov    (%rax),%rax
  8047ea:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8047f0:	85 c0                	test   %eax,%eax
  8047f2:	75 3c                	jne    804830 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8047f4:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  8047fb:	00 00 00 
  8047fe:	ff d0                	callq  *%rax
  804800:	25 ff 03 00 00       	and    $0x3ff,%eax
  804805:	48 63 d0             	movslq %eax,%rdx
  804808:	48 89 d0             	mov    %rdx,%rax
  80480b:	48 c1 e0 03          	shl    $0x3,%rax
  80480f:	48 01 d0             	add    %rdx,%rax
  804812:	48 c1 e0 05          	shl    $0x5,%rax
  804816:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80481d:	00 00 00 
  804820:	48 01 c2             	add    %rax,%rdx
  804823:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80482a:	00 00 00 
  80482d:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804830:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804835:	75 0e                	jne    804845 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804837:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80483e:	00 00 00 
  804841:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804845:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804849:	48 89 c7             	mov    %rax,%rdi
  80484c:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  804853:	00 00 00 
  804856:	ff d0                	callq  *%rax
  804858:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80485b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80485f:	79 19                	jns    80487a <ipc_recv+0xb1>
		*from_env_store = 0;
  804861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804865:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80486b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80486f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804878:	eb 53                	jmp    8048cd <ipc_recv+0x104>
	}
	if(from_env_store)
  80487a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80487f:	74 19                	je     80489a <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804881:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804888:	00 00 00 
  80488b:	48 8b 00             	mov    (%rax),%rax
  80488e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804898:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80489a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80489f:	74 19                	je     8048ba <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8048a1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048a8:	00 00 00 
  8048ab:	48 8b 00             	mov    (%rax),%rax
  8048ae:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8048b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048b8:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8048ba:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8048c1:	00 00 00 
  8048c4:	48 8b 00             	mov    (%rax),%rax
  8048c7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8048cd:	c9                   	leaveq 
  8048ce:	c3                   	retq   

00000000008048cf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8048cf:	55                   	push   %rbp
  8048d0:	48 89 e5             	mov    %rsp,%rbp
  8048d3:	48 83 ec 30          	sub    $0x30,%rsp
  8048d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8048da:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8048dd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8048e1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8048e4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048e9:	75 0e                	jne    8048f9 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8048eb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048f2:	00 00 00 
  8048f5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8048f9:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048fc:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048ff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804903:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804906:	89 c7                	mov    %eax,%edi
  804908:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  80490f:	00 00 00 
  804912:	ff d0                	callq  *%rax
  804914:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804917:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80491b:	75 0c                	jne    804929 <ipc_send+0x5a>
			sys_yield();
  80491d:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  804924:	00 00 00 
  804927:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804929:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80492d:	74 ca                	je     8048f9 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80492f:	c9                   	leaveq 
  804930:	c3                   	retq   

0000000000804931 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804931:	55                   	push   %rbp
  804932:	48 89 e5             	mov    %rsp,%rbp
  804935:	48 83 ec 14          	sub    $0x14,%rsp
  804939:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80493c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804943:	eb 5e                	jmp    8049a3 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804945:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80494c:	00 00 00 
  80494f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804952:	48 63 d0             	movslq %eax,%rdx
  804955:	48 89 d0             	mov    %rdx,%rax
  804958:	48 c1 e0 03          	shl    $0x3,%rax
  80495c:	48 01 d0             	add    %rdx,%rax
  80495f:	48 c1 e0 05          	shl    $0x5,%rax
  804963:	48 01 c8             	add    %rcx,%rax
  804966:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80496c:	8b 00                	mov    (%rax),%eax
  80496e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804971:	75 2c                	jne    80499f <ipc_find_env+0x6e>
			return envs[i].env_id;
  804973:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80497a:	00 00 00 
  80497d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804980:	48 63 d0             	movslq %eax,%rdx
  804983:	48 89 d0             	mov    %rdx,%rax
  804986:	48 c1 e0 03          	shl    $0x3,%rax
  80498a:	48 01 d0             	add    %rdx,%rax
  80498d:	48 c1 e0 05          	shl    $0x5,%rax
  804991:	48 01 c8             	add    %rcx,%rax
  804994:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80499a:	8b 40 08             	mov    0x8(%rax),%eax
  80499d:	eb 12                	jmp    8049b1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80499f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8049a3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8049aa:	7e 99                	jle    804945 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8049ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8049b1:	c9                   	leaveq 
  8049b2:	c3                   	retq   

00000000008049b3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8049b3:	55                   	push   %rbp
  8049b4:	48 89 e5             	mov    %rsp,%rbp
  8049b7:	48 83 ec 18          	sub    $0x18,%rsp
  8049bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8049bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049c3:	48 c1 e8 15          	shr    $0x15,%rax
  8049c7:	48 89 c2             	mov    %rax,%rdx
  8049ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8049d1:	01 00 00 
  8049d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049d8:	83 e0 01             	and    $0x1,%eax
  8049db:	48 85 c0             	test   %rax,%rax
  8049de:	75 07                	jne    8049e7 <pageref+0x34>
		return 0;
  8049e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8049e5:	eb 53                	jmp    804a3a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8049e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049eb:	48 c1 e8 0c          	shr    $0xc,%rax
  8049ef:	48 89 c2             	mov    %rax,%rdx
  8049f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049f9:	01 00 00 
  8049fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a00:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a08:	83 e0 01             	and    $0x1,%eax
  804a0b:	48 85 c0             	test   %rax,%rax
  804a0e:	75 07                	jne    804a17 <pageref+0x64>
		return 0;
  804a10:	b8 00 00 00 00       	mov    $0x0,%eax
  804a15:	eb 23                	jmp    804a3a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804a17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a1b:	48 c1 e8 0c          	shr    $0xc,%rax
  804a1f:	48 89 c2             	mov    %rax,%rdx
  804a22:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a29:	00 00 00 
  804a2c:	48 c1 e2 04          	shl    $0x4,%rdx
  804a30:	48 01 d0             	add    %rdx,%rax
  804a33:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804a37:	0f b7 c0             	movzwl %ax,%eax
}
  804a3a:	c9                   	leaveq 
  804a3b:	c3                   	retq   
