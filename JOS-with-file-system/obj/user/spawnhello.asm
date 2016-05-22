
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
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf a0 3f 80 00 00 	movabs $0x803fa0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be be 3f 80 00 00 	movabs $0x803fbe,%rsi
  80008e:	00 00 00 
  800091:	48 bf c4 3f 80 00 00 	movabs $0x803fc4,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 a3 2c 80 00 00 	movabs $0x802ca3,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba cf 3f 80 00 00 	movabs $0x803fcf,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf e7 3f 80 00 00 	movabs $0x803fe7,%rdi
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
  800125:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  800176:	48 b8 60 1e 80 00 00 	movabs $0x801e60,%rax
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
  80021e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  80024f:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
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
  80028b:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
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
  80053a:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
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
  800832:	48 b8 30 42 80 00 00 	movabs $0x804230,%rax
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
  800980:	83 fb 10             	cmp    $0x10,%ebx
  800983:	7f 16                	jg     80099b <vprintfmt+0x21a>
  800985:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  80098c:	00 00 00 
  80098f:	48 63 d3             	movslq %ebx,%rdx
  800992:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800996:	4d 85 e4             	test   %r12,%r12
  800999:	75 2e                	jne    8009c9 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80099b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a3:	89 d9                	mov    %ebx,%ecx
  8009a5:	48 ba 19 42 80 00 00 	movabs $0x804219,%rdx
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
  8009d4:	48 ba 22 42 80 00 00 	movabs $0x804222,%rdx
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
  800a2e:	49 bc 25 42 80 00 00 	movabs $0x804225,%r12
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
  801734:	48 ba e0 44 80 00 00 	movabs $0x8044e0,%rdx
  80173b:	00 00 00 
  80173e:	be 23 00 00 00       	mov    $0x23,%esi
  801743:	48 bf fd 44 80 00 00 	movabs $0x8044fd,%rdi
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

0000000000801b1f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 08          	sub    $0x8,%rsp
  801b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b2f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b36:	ff ff ff 
  801b39:	48 01 d0             	add    %rdx,%rax
  801b3c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b40:	c9                   	leaveq 
  801b41:	c3                   	retq   

0000000000801b42 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b42:	55                   	push   %rbp
  801b43:	48 89 e5             	mov    %rsp,%rbp
  801b46:	48 83 ec 08          	sub    $0x8,%rsp
  801b4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b52:	48 89 c7             	mov    %rax,%rdi
  801b55:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
  801b61:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b67:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 18          	sub    $0x18,%rsp
  801b75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b80:	eb 6b                	jmp    801bed <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b85:	48 98                	cltq   
  801b87:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b8d:	48 c1 e0 0c          	shl    $0xc,%rax
  801b91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b99:	48 c1 e8 15          	shr    $0x15,%rax
  801b9d:	48 89 c2             	mov    %rax,%rdx
  801ba0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ba7:	01 00 00 
  801baa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bae:	83 e0 01             	and    $0x1,%eax
  801bb1:	48 85 c0             	test   %rax,%rax
  801bb4:	74 21                	je     801bd7 <fd_alloc+0x6a>
  801bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bba:	48 c1 e8 0c          	shr    $0xc,%rax
  801bbe:	48 89 c2             	mov    %rax,%rdx
  801bc1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bc8:	01 00 00 
  801bcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bcf:	83 e0 01             	and    $0x1,%eax
  801bd2:	48 85 c0             	test   %rax,%rax
  801bd5:	75 12                	jne    801be9 <fd_alloc+0x7c>
			*fd_store = fd;
  801bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdf:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	eb 1a                	jmp    801c03 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801be9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bf1:	7e 8f                	jle    801b82 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801bfe:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c03:	c9                   	leaveq 
  801c04:	c3                   	retq   

0000000000801c05 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c05:	55                   	push   %rbp
  801c06:	48 89 e5             	mov    %rsp,%rbp
  801c09:	48 83 ec 20          	sub    $0x20,%rsp
  801c0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c18:	78 06                	js     801c20 <fd_lookup+0x1b>
  801c1a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c1e:	7e 07                	jle    801c27 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c25:	eb 6c                	jmp    801c93 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c2a:	48 98                	cltq   
  801c2c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c32:	48 c1 e0 0c          	shl    $0xc,%rax
  801c36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3e:	48 c1 e8 15          	shr    $0x15,%rax
  801c42:	48 89 c2             	mov    %rax,%rdx
  801c45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c4c:	01 00 00 
  801c4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c53:	83 e0 01             	and    $0x1,%eax
  801c56:	48 85 c0             	test   %rax,%rax
  801c59:	74 21                	je     801c7c <fd_lookup+0x77>
  801c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5f:	48 c1 e8 0c          	shr    $0xc,%rax
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c6d:	01 00 00 
  801c70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c74:	83 e0 01             	and    $0x1,%eax
  801c77:	48 85 c0             	test   %rax,%rax
  801c7a:	75 07                	jne    801c83 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c81:	eb 10                	jmp    801c93 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c8b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 30          	sub    $0x30,%rsp
  801c9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ca1:	89 f0                	mov    %esi,%eax
  801ca3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ca6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801caa:	48 89 c7             	mov    %rax,%rdi
  801cad:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  801cb4:	00 00 00 
  801cb7:	ff d0                	callq  *%rax
  801cb9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cbd:	48 89 d6             	mov    %rdx,%rsi
  801cc0:	89 c7                	mov    %eax,%edi
  801cc2:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
  801cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cd5:	78 0a                	js     801ce1 <fd_close+0x4c>
	    || fd != fd2)
  801cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdb:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cdf:	74 12                	je     801cf3 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ce1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ce5:	74 05                	je     801cec <fd_close+0x57>
  801ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cea:	eb 05                	jmp    801cf1 <fd_close+0x5c>
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf1:	eb 69                	jmp    801d5c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf7:	8b 00                	mov    (%rax),%eax
  801cf9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801cfd:	48 89 d6             	mov    %rdx,%rsi
  801d00:	89 c7                	mov    %eax,%edi
  801d02:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	callq  *%rax
  801d0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d15:	78 2a                	js     801d41 <fd_close+0xac>
		if (dev->dev_close)
  801d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d1f:	48 85 c0             	test   %rax,%rax
  801d22:	74 16                	je     801d3a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d28:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d2c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d30:	48 89 d7             	mov    %rdx,%rdi
  801d33:	ff d0                	callq  *%rax
  801d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d38:	eb 07                	jmp    801d41 <fd_close+0xac>
		else
			r = 0;
  801d3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d45:	48 89 c6             	mov    %rax,%rsi
  801d48:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4d:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	callq  *%rax
	return r;
  801d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 20          	sub    $0x20,%rsp
  801d66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d74:	eb 41                	jmp    801db7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d76:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d7d:	00 00 00 
  801d80:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d83:	48 63 d2             	movslq %edx,%rdx
  801d86:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d8a:	8b 00                	mov    (%rax),%eax
  801d8c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d8f:	75 22                	jne    801db3 <dev_lookup+0x55>
			*dev = devtab[i];
  801d91:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d98:	00 00 00 
  801d9b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d9e:	48 63 d2             	movslq %edx,%rdx
  801da1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801da5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801da9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
  801db1:	eb 60                	jmp    801e13 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801db3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801db7:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dbe:	00 00 00 
  801dc1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dc4:	48 63 d2             	movslq %edx,%rdx
  801dc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcb:	48 85 c0             	test   %rax,%rax
  801dce:	75 a6                	jne    801d76 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dd0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801dd7:	00 00 00 
  801dda:	48 8b 00             	mov    (%rax),%rax
  801ddd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801de3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801de6:	89 c6                	mov    %eax,%esi
  801de8:	48 bf 10 45 80 00 00 	movabs $0x804510,%rdi
  801def:	00 00 00 
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  801dfe:	00 00 00 
  801e01:	ff d1                	callq  *%rcx
	*dev = 0;
  801e03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e07:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <close>:

int
close(int fdnum)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
  801e19:	48 83 ec 20          	sub    $0x20,%rsp
  801e1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e27:	48 89 d6             	mov    %rdx,%rsi
  801e2a:	89 c7                	mov    %eax,%edi
  801e2c:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
  801e38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3f:	79 05                	jns    801e46 <close+0x31>
		return r;
  801e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e44:	eb 18                	jmp    801e5e <close+0x49>
	else
		return fd_close(fd, 1);
  801e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4a:	be 01 00 00 00       	mov    $0x1,%esi
  801e4f:	48 89 c7             	mov    %rax,%rdi
  801e52:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  801e59:	00 00 00 
  801e5c:	ff d0                	callq  *%rax
}
  801e5e:	c9                   	leaveq 
  801e5f:	c3                   	retq   

0000000000801e60 <close_all>:

void
close_all(void)
{
  801e60:	55                   	push   %rbp
  801e61:	48 89 e5             	mov    %rsp,%rbp
  801e64:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e6f:	eb 15                	jmp    801e86 <close_all+0x26>
		close(i);
  801e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e74:	89 c7                	mov    %eax,%edi
  801e76:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e82:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e86:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e8a:	7e e5                	jle    801e71 <close_all+0x11>
		close(i);
}
  801e8c:	c9                   	leaveq 
  801e8d:	c3                   	retq   

0000000000801e8e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e8e:	55                   	push   %rbp
  801e8f:	48 89 e5             	mov    %rsp,%rbp
  801e92:	48 83 ec 40          	sub    $0x40,%rsp
  801e96:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e99:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e9c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ea0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ea3:	48 89 d6             	mov    %rdx,%rsi
  801ea6:	89 c7                	mov    %eax,%edi
  801ea8:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  801eaf:	00 00 00 
  801eb2:	ff d0                	callq  *%rax
  801eb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ebb:	79 08                	jns    801ec5 <dup+0x37>
		return r;
  801ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec0:	e9 70 01 00 00       	jmpq   802035 <dup+0x1a7>
	close(newfdnum);
  801ec5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ec8:	89 c7                	mov    %eax,%edi
  801eca:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ed6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ed9:	48 98                	cltq   
  801edb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eed:	48 89 c7             	mov    %rax,%rdi
  801ef0:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
  801efc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f04:	48 89 c7             	mov    %rax,%rdi
  801f07:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  801f0e:	00 00 00 
  801f11:	ff d0                	callq  *%rax
  801f13:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1b:	48 c1 e8 15          	shr    $0x15,%rax
  801f1f:	48 89 c2             	mov    %rax,%rdx
  801f22:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f29:	01 00 00 
  801f2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f30:	83 e0 01             	and    $0x1,%eax
  801f33:	48 85 c0             	test   %rax,%rax
  801f36:	74 73                	je     801fab <dup+0x11d>
  801f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4a:	01 00 00 
  801f4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	48 85 c0             	test   %rax,%rax
  801f57:	74 52                	je     801fab <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f61:	48 89 c2             	mov    %rax,%rdx
  801f64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6b:	01 00 00 
  801f6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f72:	25 07 0e 00 00       	and    $0xe07,%eax
  801f77:	89 c1                	mov    %eax,%ecx
  801f79:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f81:	41 89 c8             	mov    %ecx,%r8d
  801f84:	48 89 d1             	mov    %rdx,%rcx
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8c:	48 89 c6             	mov    %rax,%rsi
  801f8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f94:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  801f9b:	00 00 00 
  801f9e:	ff d0                	callq  *%rax
  801fa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa7:	79 02                	jns    801fab <dup+0x11d>
			goto err;
  801fa9:	eb 57                	jmp    802002 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801faf:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb3:	48 89 c2             	mov    %rax,%rdx
  801fb6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fbd:	01 00 00 
  801fc0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc4:	25 07 0e 00 00       	and    $0xe07,%eax
  801fc9:	89 c1                	mov    %eax,%ecx
  801fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd3:	41 89 c8             	mov    %ecx,%r8d
  801fd6:	48 89 d1             	mov    %rdx,%rcx
  801fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fde:	48 89 c6             	mov    %rax,%rsi
  801fe1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe6:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff9:	79 02                	jns    801ffd <dup+0x16f>
		goto err;
  801ffb:	eb 05                	jmp    802002 <dup+0x174>

	return newfdnum;
  801ffd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802000:	eb 33                	jmp    802035 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802006:	48 89 c6             	mov    %rax,%rsi
  802009:	bf 00 00 00 00       	mov    $0x0,%edi
  80200e:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  802015:	00 00 00 
  802018:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80201a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
	return r;
  802032:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802035:	c9                   	leaveq 
  802036:	c3                   	retq   

0000000000802037 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802037:	55                   	push   %rbp
  802038:	48 89 e5             	mov    %rsp,%rbp
  80203b:	48 83 ec 40          	sub    $0x40,%rsp
  80203f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802042:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802046:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80204a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80204e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802051:	48 89 d6             	mov    %rdx,%rsi
  802054:	89 c7                	mov    %eax,%edi
  802056:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  80205d:	00 00 00 
  802060:	ff d0                	callq  *%rax
  802062:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802065:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802069:	78 24                	js     80208f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	8b 00                	mov    (%rax),%eax
  802071:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802075:	48 89 d6             	mov    %rdx,%rsi
  802078:	89 c7                	mov    %eax,%edi
  80207a:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802081:	00 00 00 
  802084:	ff d0                	callq  *%rax
  802086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208d:	79 05                	jns    802094 <read+0x5d>
		return r;
  80208f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802092:	eb 76                	jmp    80210a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802094:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802098:	8b 40 08             	mov    0x8(%rax),%eax
  80209b:	83 e0 03             	and    $0x3,%eax
  80209e:	83 f8 01             	cmp    $0x1,%eax
  8020a1:	75 3a                	jne    8020dd <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020aa:	00 00 00 
  8020ad:	48 8b 00             	mov    (%rax),%rax
  8020b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020b9:	89 c6                	mov    %eax,%esi
  8020bb:	48 bf 2f 45 80 00 00 	movabs $0x80452f,%rdi
  8020c2:	00 00 00 
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ca:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  8020d1:	00 00 00 
  8020d4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020db:	eb 2d                	jmp    80210a <read+0xd3>
	}
	if (!dev->dev_read)
  8020dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020e5:	48 85 c0             	test   %rax,%rax
  8020e8:	75 07                	jne    8020f1 <read+0xba>
		return -E_NOT_SUPP;
  8020ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020ef:	eb 19                	jmp    80210a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8020f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802101:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802105:	48 89 cf             	mov    %rcx,%rdi
  802108:	ff d0                	callq  *%rax
}
  80210a:	c9                   	leaveq 
  80210b:	c3                   	retq   

000000000080210c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80210c:	55                   	push   %rbp
  80210d:	48 89 e5             	mov    %rsp,%rbp
  802110:	48 83 ec 30          	sub    $0x30,%rsp
  802114:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802117:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80211b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80211f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802126:	eb 49                	jmp    802171 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212b:	48 98                	cltq   
  80212d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802131:	48 29 c2             	sub    %rax,%rdx
  802134:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802137:	48 63 c8             	movslq %eax,%rcx
  80213a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213e:	48 01 c1             	add    %rax,%rcx
  802141:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802144:	48 89 ce             	mov    %rcx,%rsi
  802147:	89 c7                	mov    %eax,%edi
  802149:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  802150:	00 00 00 
  802153:	ff d0                	callq  *%rax
  802155:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802158:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80215c:	79 05                	jns    802163 <readn+0x57>
			return m;
  80215e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802161:	eb 1c                	jmp    80217f <readn+0x73>
		if (m == 0)
  802163:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802167:	75 02                	jne    80216b <readn+0x5f>
			break;
  802169:	eb 11                	jmp    80217c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80216b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80216e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802174:	48 98                	cltq   
  802176:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80217a:	72 ac                	jb     802128 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80217c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80217f:	c9                   	leaveq 
  802180:	c3                   	retq   

0000000000802181 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
  802185:	48 83 ec 40          	sub    $0x40,%rsp
  802189:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80218c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802190:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802194:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802198:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80219b:	48 89 d6             	mov    %rdx,%rsi
  80219e:	89 c7                	mov    %eax,%edi
  8021a0:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  8021a7:	00 00 00 
  8021aa:	ff d0                	callq  *%rax
  8021ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b3:	78 24                	js     8021d9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b9:	8b 00                	mov    (%rax),%eax
  8021bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021bf:	48 89 d6             	mov    %rdx,%rsi
  8021c2:	89 c7                	mov    %eax,%edi
  8021c4:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8021cb:	00 00 00 
  8021ce:	ff d0                	callq  *%rax
  8021d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d7:	79 05                	jns    8021de <write+0x5d>
		return r;
  8021d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021dc:	eb 75                	jmp    802253 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e2:	8b 40 08             	mov    0x8(%rax),%eax
  8021e5:	83 e0 03             	and    $0x3,%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	75 3a                	jne    802226 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021ec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021f3:	00 00 00 
  8021f6:	48 8b 00             	mov    (%rax),%rax
  8021f9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802202:	89 c6                	mov    %eax,%esi
  802204:	48 bf 4b 45 80 00 00 	movabs $0x80454b,%rdi
  80220b:	00 00 00 
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
  802213:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  80221a:	00 00 00 
  80221d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80221f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802224:	eb 2d                	jmp    802253 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80222e:	48 85 c0             	test   %rax,%rax
  802231:	75 07                	jne    80223a <write+0xb9>
		return -E_NOT_SUPP;
  802233:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802238:	eb 19                	jmp    802253 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80223a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802242:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802246:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80224a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80224e:	48 89 cf             	mov    %rcx,%rdi
  802251:	ff d0                	callq  *%rax
}
  802253:	c9                   	leaveq 
  802254:	c3                   	retq   

0000000000802255 <seek>:

int
seek(int fdnum, off_t offset)
{
  802255:	55                   	push   %rbp
  802256:	48 89 e5             	mov    %rsp,%rbp
  802259:	48 83 ec 18          	sub    $0x18,%rsp
  80225d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802260:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802263:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802267:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80226a:	48 89 d6             	mov    %rdx,%rsi
  80226d:	89 c7                	mov    %eax,%edi
  80226f:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax
  80227b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802282:	79 05                	jns    802289 <seek+0x34>
		return r;
  802284:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802287:	eb 0f                	jmp    802298 <seek+0x43>
	fd->fd_offset = offset;
  802289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802290:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802298:	c9                   	leaveq 
  802299:	c3                   	retq   

000000000080229a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80229a:	55                   	push   %rbp
  80229b:	48 89 e5             	mov    %rsp,%rbp
  80229e:	48 83 ec 30          	sub    $0x30,%rsp
  8022a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022a5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022af:	48 89 d6             	mov    %rdx,%rsi
  8022b2:	89 c7                	mov    %eax,%edi
  8022b4:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
  8022c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c7:	78 24                	js     8022ed <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cd:	8b 00                	mov    (%rax),%eax
  8022cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d3:	48 89 d6             	mov    %rdx,%rsi
  8022d6:	89 c7                	mov    %eax,%edi
  8022d8:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax
  8022e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022eb:	79 05                	jns    8022f2 <ftruncate+0x58>
		return r;
  8022ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f0:	eb 72                	jmp    802364 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f6:	8b 40 08             	mov    0x8(%rax),%eax
  8022f9:	83 e0 03             	and    $0x3,%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 3a                	jne    80233a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802300:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802307:	00 00 00 
  80230a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80230d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802313:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802316:	89 c6                	mov    %eax,%esi
  802318:	48 bf 68 45 80 00 00 	movabs $0x804568,%rdi
  80231f:	00 00 00 
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
  802327:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  80232e:	00 00 00 
  802331:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802338:	eb 2a                	jmp    802364 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80233a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802342:	48 85 c0             	test   %rax,%rax
  802345:	75 07                	jne    80234e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802347:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80234c:	eb 16                	jmp    802364 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80234e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802352:	48 8b 40 30          	mov    0x30(%rax),%rax
  802356:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80235d:	89 ce                	mov    %ecx,%esi
  80235f:	48 89 d7             	mov    %rdx,%rdi
  802362:	ff d0                	callq  *%rax
}
  802364:	c9                   	leaveq 
  802365:	c3                   	retq   

0000000000802366 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802366:	55                   	push   %rbp
  802367:	48 89 e5             	mov    %rsp,%rbp
  80236a:	48 83 ec 30          	sub    $0x30,%rsp
  80236e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802371:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802375:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802379:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80237c:	48 89 d6             	mov    %rdx,%rsi
  80237f:	89 c7                	mov    %eax,%edi
  802381:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
  80238d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802390:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802394:	78 24                	js     8023ba <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239a:	8b 00                	mov    (%rax),%eax
  80239c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a0:	48 89 d6             	mov    %rdx,%rsi
  8023a3:	89 c7                	mov    %eax,%edi
  8023a5:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8023ac:	00 00 00 
  8023af:	ff d0                	callq  *%rax
  8023b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b8:	79 05                	jns    8023bf <fstat+0x59>
		return r;
  8023ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bd:	eb 5e                	jmp    80241d <fstat+0xb7>
	if (!dev->dev_stat)
  8023bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023c7:	48 85 c0             	test   %rax,%rax
  8023ca:	75 07                	jne    8023d3 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023cc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023d1:	eb 4a                	jmp    80241d <fstat+0xb7>
	stat->st_name[0] = 0;
  8023d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023d7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023de:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023e5:	00 00 00 
	stat->st_isdir = 0;
  8023e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ec:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023f3:	00 00 00 
	stat->st_dev = dev;
  8023f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023fe:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802409:	48 8b 40 28          	mov    0x28(%rax),%rax
  80240d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802411:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802415:	48 89 ce             	mov    %rcx,%rsi
  802418:	48 89 d7             	mov    %rdx,%rdi
  80241b:	ff d0                	callq  *%rax
}
  80241d:	c9                   	leaveq 
  80241e:	c3                   	retq   

000000000080241f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80241f:	55                   	push   %rbp
  802420:	48 89 e5             	mov    %rsp,%rbp
  802423:	48 83 ec 20          	sub    $0x20,%rsp
  802427:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80242b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80242f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802433:	be 00 00 00 00       	mov    $0x0,%esi
  802438:	48 89 c7             	mov    %rax,%rdi
  80243b:	48 b8 0d 25 80 00 00 	movabs $0x80250d,%rax
  802442:	00 00 00 
  802445:	ff d0                	callq  *%rax
  802447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244e:	79 05                	jns    802455 <stat+0x36>
		return fd;
  802450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802453:	eb 2f                	jmp    802484 <stat+0x65>
	r = fstat(fd, stat);
  802455:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245c:	48 89 d6             	mov    %rdx,%rsi
  80245f:	89 c7                	mov    %eax,%edi
  802461:	48 b8 66 23 80 00 00 	movabs $0x802366,%rax
  802468:	00 00 00 
  80246b:	ff d0                	callq  *%rax
  80246d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802473:	89 c7                	mov    %eax,%edi
  802475:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax
	return r;
  802481:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802484:	c9                   	leaveq 
  802485:	c3                   	retq   

0000000000802486 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802486:	55                   	push   %rbp
  802487:	48 89 e5             	mov    %rsp,%rbp
  80248a:	48 83 ec 10          	sub    $0x10,%rsp
  80248e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802491:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802495:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80249c:	00 00 00 
  80249f:	8b 00                	mov    (%rax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	75 1d                	jne    8024c2 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8024aa:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
  8024b6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024bd:	00 00 00 
  8024c0:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024c9:	00 00 00 
  8024cc:	8b 00                	mov    (%rax),%eax
  8024ce:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024d1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024d6:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024dd:	00 00 00 
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 1e 3e 80 00 00 	movabs $0x803e1e,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f7:	48 89 c6             	mov    %rax,%rsi
  8024fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ff:	48 b8 18 3d 80 00 00 	movabs $0x803d18,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
}
  80250b:	c9                   	leaveq 
  80250c:	c3                   	retq   

000000000080250d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80250d:	55                   	push   %rbp
  80250e:	48 89 e5             	mov    %rsp,%rbp
  802511:	48 83 ec 30          	sub    $0x30,%rsp
  802515:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802519:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80251c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802523:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80252a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802531:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802536:	75 08                	jne    802540 <open+0x33>
	{
		return r;
  802538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253b:	e9 f2 00 00 00       	jmpq   802632 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802544:	48 89 c7             	mov    %rax,%rdi
  802547:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80254e:	00 00 00 
  802551:	ff d0                	callq  *%rax
  802553:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802556:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80255d:	7e 0a                	jle    802569 <open+0x5c>
	{
		return -E_BAD_PATH;
  80255f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802564:	e9 c9 00 00 00       	jmpq   802632 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802569:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802570:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802571:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802575:	48 89 c7             	mov    %rax,%rdi
  802578:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	78 09                	js     802596 <open+0x89>
  80258d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802591:	48 85 c0             	test   %rax,%rax
  802594:	75 08                	jne    80259e <open+0x91>
		{
			return r;
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	e9 94 00 00 00       	jmpq   802632 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80259e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a2:	ba 00 04 00 00       	mov    $0x400,%edx
  8025a7:	48 89 c6             	mov    %rax,%rsi
  8025aa:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8025b1:	00 00 00 
  8025b4:	48 b8 15 10 80 00 00 	movabs $0x801015,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8025c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025c7:	00 00 00 
  8025ca:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8025cd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	48 89 c6             	mov    %rax,%rsi
  8025da:	bf 01 00 00 00       	mov    $0x1,%edi
  8025df:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax
  8025eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f2:	79 2b                	jns    80261f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8025f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f8:	be 00 00 00 00       	mov    $0x0,%esi
  8025fd:	48 89 c7             	mov    %rax,%rdi
  802600:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  802607:	00 00 00 
  80260a:	ff d0                	callq  *%rax
  80260c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80260f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802613:	79 05                	jns    80261a <open+0x10d>
			{
				return d;
  802615:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802618:	eb 18                	jmp    802632 <open+0x125>
			}
			return r;
  80261a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261d:	eb 13                	jmp    802632 <open+0x125>
		}	
		return fd2num(fd_store);
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	48 89 c7             	mov    %rax,%rdi
  802626:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802632:	c9                   	leaveq 
  802633:	c3                   	retq   

0000000000802634 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802634:	55                   	push   %rbp
  802635:	48 89 e5             	mov    %rsp,%rbp
  802638:	48 83 ec 10          	sub    $0x10,%rsp
  80263c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802644:	8b 50 0c             	mov    0xc(%rax),%edx
  802647:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80264e:	00 00 00 
  802651:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802653:	be 00 00 00 00       	mov    $0x0,%esi
  802658:	bf 06 00 00 00       	mov    $0x6,%edi
  80265d:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802664:	00 00 00 
  802667:	ff d0                	callq  *%rax
}
  802669:	c9                   	leaveq 
  80266a:	c3                   	retq   

000000000080266b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80266b:	55                   	push   %rbp
  80266c:	48 89 e5             	mov    %rsp,%rbp
  80266f:	48 83 ec 30          	sub    $0x30,%rsp
  802673:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802677:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80267b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80267f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802686:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80268b:	74 07                	je     802694 <devfile_read+0x29>
  80268d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802692:	75 07                	jne    80269b <devfile_read+0x30>
		return -E_INVAL;
  802694:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802699:	eb 77                	jmp    802712 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80269b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269f:	8b 50 0c             	mov    0xc(%rax),%edx
  8026a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026a9:	00 00 00 
  8026ac:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8026ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026b5:	00 00 00 
  8026b8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026bc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8026c0:	be 00 00 00 00       	mov    $0x0,%esi
  8026c5:	bf 03 00 00 00       	mov    $0x3,%edi
  8026ca:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8026d1:	00 00 00 
  8026d4:	ff d0                	callq  *%rax
  8026d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026dd:	7f 05                	jg     8026e4 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8026df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e2:	eb 2e                	jmp    802712 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8026e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e7:	48 63 d0             	movslq %eax,%rdx
  8026ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ee:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8026f5:	00 00 00 
  8026f8:	48 89 c7             	mov    %rax,%rdi
  8026fb:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802707:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80270b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80270f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802712:	c9                   	leaveq 
  802713:	c3                   	retq   

0000000000802714 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 30          	sub    $0x30,%rsp
  80271c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802720:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802724:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802728:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80272f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802734:	74 07                	je     80273d <devfile_write+0x29>
  802736:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80273b:	75 08                	jne    802745 <devfile_write+0x31>
		return r;
  80273d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802740:	e9 9a 00 00 00       	jmpq   8027df <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802749:	8b 50 0c             	mov    0xc(%rax),%edx
  80274c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802753:	00 00 00 
  802756:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802758:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80275f:	00 
  802760:	76 08                	jbe    80276a <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802762:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802769:	00 
	}
	fsipcbuf.write.req_n = n;
  80276a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802771:	00 00 00 
  802774:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802778:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80277c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802784:	48 89 c6             	mov    %rax,%rsi
  802787:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80278e:	00 00 00 
  802791:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80279d:	be 00 00 00 00       	mov    $0x0,%esi
  8027a2:	bf 04 00 00 00       	mov    $0x4,%edi
  8027a7:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
  8027b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ba:	7f 20                	jg     8027dc <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8027bc:	48 bf 8e 45 80 00 00 	movabs $0x80458e,%rdi
  8027c3:	00 00 00 
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	48 ba ce 03 80 00 00 	movabs $0x8003ce,%rdx
  8027d2:	00 00 00 
  8027d5:	ff d2                	callq  *%rdx
		return r;
  8027d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027da:	eb 03                	jmp    8027df <devfile_write+0xcb>
	}
	return r;
  8027dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8027df:	c9                   	leaveq 
  8027e0:	c3                   	retq   

00000000008027e1 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027e1:	55                   	push   %rbp
  8027e2:	48 89 e5             	mov    %rsp,%rbp
  8027e5:	48 83 ec 20          	sub    $0x20,%rsp
  8027e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ff:	00 00 00 
  802802:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802804:	be 00 00 00 00       	mov    $0x0,%esi
  802809:	bf 05 00 00 00       	mov    $0x5,%edi
  80280e:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
  80281a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802821:	79 05                	jns    802828 <devfile_stat+0x47>
		return r;
  802823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802826:	eb 56                	jmp    80287e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802828:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80282c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802833:	00 00 00 
  802836:	48 89 c7             	mov    %rax,%rdi
  802839:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  802840:	00 00 00 
  802843:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802845:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80284c:	00 00 00 
  80284f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802855:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802859:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80285f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802866:	00 00 00 
  802869:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80286f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802873:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287e:	c9                   	leaveq 
  80287f:	c3                   	retq   

0000000000802880 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802880:	55                   	push   %rbp
  802881:	48 89 e5             	mov    %rsp,%rbp
  802884:	48 83 ec 10          	sub    $0x10,%rsp
  802888:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80288c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80288f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802893:	8b 50 0c             	mov    0xc(%rax),%edx
  802896:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80289d:	00 00 00 
  8028a0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a9:	00 00 00 
  8028ac:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028af:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028b2:	be 00 00 00 00       	mov    $0x0,%esi
  8028b7:	bf 02 00 00 00       	mov    $0x2,%edi
  8028bc:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8028c3:	00 00 00 
  8028c6:	ff d0                	callq  *%rax
}
  8028c8:	c9                   	leaveq 
  8028c9:	c3                   	retq   

00000000008028ca <remove>:

// Delete a file
int
remove(const char *path)
{
  8028ca:	55                   	push   %rbp
  8028cb:	48 89 e5             	mov    %rsp,%rbp
  8028ce:	48 83 ec 10          	sub    $0x10,%rsp
  8028d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028da:	48 89 c7             	mov    %rax,%rdi
  8028dd:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028ee:	7e 07                	jle    8028f7 <remove+0x2d>
		return -E_BAD_PATH;
  8028f0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028f5:	eb 33                	jmp    80292a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8028f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028fb:	48 89 c6             	mov    %rax,%rsi
  8028fe:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802905:	00 00 00 
  802908:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802914:	be 00 00 00 00       	mov    $0x0,%esi
  802919:	bf 07 00 00 00       	mov    $0x7,%edi
  80291e:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
}
  80292a:	c9                   	leaveq 
  80292b:	c3                   	retq   

000000000080292c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80292c:	55                   	push   %rbp
  80292d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802930:	be 00 00 00 00       	mov    $0x0,%esi
  802935:	bf 08 00 00 00       	mov    $0x8,%edi
  80293a:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802941:	00 00 00 
  802944:	ff d0                	callq  *%rax
}
  802946:	5d                   	pop    %rbp
  802947:	c3                   	retq   

0000000000802948 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802948:	55                   	push   %rbp
  802949:	48 89 e5             	mov    %rsp,%rbp
  80294c:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802953:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80295a:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802961:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802968:	be 00 00 00 00       	mov    $0x0,%esi
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 0d 25 80 00 00 	movabs $0x80250d,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80297f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802983:	79 08                	jns    80298d <spawn+0x45>
		return r;
  802985:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802988:	e9 14 03 00 00       	jmpq   802ca1 <spawn+0x359>
	fd = r;
  80298d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802990:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802993:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80299a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80299e:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8029a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8029a8:	ba 00 02 00 00       	mov    $0x200,%edx
  8029ad:	48 89 ce             	mov    %rcx,%rsi
  8029b0:	89 c7                	mov    %eax,%edi
  8029b2:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  8029b9:	00 00 00 
  8029bc:	ff d0                	callq  *%rax
  8029be:	3d 00 02 00 00       	cmp    $0x200,%eax
  8029c3:	75 0d                	jne    8029d2 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  8029c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c9:	8b 00                	mov    (%rax),%eax
  8029cb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8029d0:	74 43                	je     802a15 <spawn+0xcd>
		close(fd);
  8029d2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8029d5:	89 c7                	mov    %eax,%edi
  8029d7:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8029e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029e7:	8b 00                	mov    (%rax),%eax
  8029e9:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8029ee:	89 c6                	mov    %eax,%esi
  8029f0:	48 bf b0 45 80 00 00 	movabs $0x8045b0,%rdi
  8029f7:	00 00 00 
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ff:	48 b9 ce 03 80 00 00 	movabs $0x8003ce,%rcx
  802a06:	00 00 00 
  802a09:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802a0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a10:	e9 8c 02 00 00       	jmpq   802ca1 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802a15:	b8 07 00 00 00       	mov    $0x7,%eax
  802a1a:	cd 30                	int    $0x30
  802a1c:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802a1f:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802a22:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802a25:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802a29:	79 08                	jns    802a33 <spawn+0xeb>
		return r;
  802a2b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802a2e:	e9 6e 02 00 00       	jmpq   802ca1 <spawn+0x359>
	child = r;
  802a33:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802a36:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802a39:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802a41:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802a48:	00 00 00 
  802a4b:	48 63 d0             	movslq %eax,%rdx
  802a4e:	48 89 d0             	mov    %rdx,%rax
  802a51:	48 c1 e0 03          	shl    $0x3,%rax
  802a55:	48 01 d0             	add    %rdx,%rax
  802a58:	48 c1 e0 05          	shl    $0x5,%rax
  802a5c:	48 01 c8             	add    %rcx,%rax
  802a5f:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802a66:	48 89 c6             	mov    %rax,%rsi
  802a69:	b8 18 00 00 00       	mov    $0x18,%eax
  802a6e:	48 89 d7             	mov    %rdx,%rdi
  802a71:	48 89 c1             	mov    %rax,%rcx
  802a74:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802a77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a7b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a7f:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802a86:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802a8d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802a94:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802a9b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802a9e:	48 89 ce             	mov    %rcx,%rsi
  802aa1:	89 c7                	mov    %eax,%edi
  802aa3:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  802aaa:	00 00 00 
  802aad:	ff d0                	callq  *%rax
  802aaf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ab2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ab6:	79 08                	jns    802ac0 <spawn+0x178>
		return r;
  802ab8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802abb:	e9 e1 01 00 00       	jmpq   802ca1 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac4:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ac8:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802acf:	48 01 d0             	add    %rdx,%rax
  802ad2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ad6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802add:	e9 a3 00 00 00       	jmpq   802b85 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae6:	8b 00                	mov    (%rax),%eax
  802ae8:	83 f8 01             	cmp    $0x1,%eax
  802aeb:	74 05                	je     802af2 <spawn+0x1aa>
			continue;
  802aed:	e9 8a 00 00 00       	jmpq   802b7c <spawn+0x234>
		perm = PTE_P | PTE_U;
  802af2:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afd:	8b 40 04             	mov    0x4(%rax),%eax
  802b00:	83 e0 02             	and    $0x2,%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	74 04                	je     802b0b <spawn+0x1c3>
			perm |= PTE_W;
  802b07:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b13:	41 89 c1             	mov    %eax,%r9d
  802b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b22:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802b2e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802b31:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b34:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802b37:	89 3c 24             	mov    %edi,(%rsp)
  802b3a:	89 c7                	mov    %eax,%edi
  802b3c:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	callq  *%rax
  802b48:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b4f:	79 2b                	jns    802b7c <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802b51:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802b52:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b55:	89 c7                	mov    %eax,%edi
  802b57:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax
	close(fd);
  802b63:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b66:	89 c7                	mov    %eax,%edi
  802b68:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
	return r;
  802b74:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b77:	e9 25 01 00 00       	jmpq   802ca1 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b7c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b80:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b89:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802b8d:	0f b7 c0             	movzwl %ax,%eax
  802b90:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802b93:	0f 8f 49 ff ff ff    	jg     802ae2 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802b99:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
	fd = -1;
  802baa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802bb1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bb4:	89 c7                	mov    %eax,%edi
  802bb6:	48 b8 a0 33 80 00 00 	movabs $0x8033a0,%rax
  802bbd:	00 00 00 
  802bc0:	ff d0                	callq  *%rax
  802bc2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802bc5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802bc9:	79 30                	jns    802bfb <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802bcb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bce:	89 c1                	mov    %eax,%ecx
  802bd0:	48 ba ca 45 80 00 00 	movabs $0x8045ca,%rdx
  802bd7:	00 00 00 
  802bda:	be 82 00 00 00       	mov    $0x82,%esi
  802bdf:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  802be6:	00 00 00 
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802bf5:	00 00 00 
  802bf8:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bfb:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802c02:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c05:	48 89 d6             	mov    %rdx,%rsi
  802c08:	89 c7                	mov    %eax,%edi
  802c0a:	48 b8 f2 19 80 00 00 	movabs $0x8019f2,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
  802c16:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c19:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c1d:	79 30                	jns    802c4f <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802c1f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c22:	89 c1                	mov    %eax,%ecx
  802c24:	48 ba ec 45 80 00 00 	movabs $0x8045ec,%rdx
  802c2b:	00 00 00 
  802c2e:	be 85 00 00 00       	mov    $0x85,%esi
  802c33:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  802c3a:	00 00 00 
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c42:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802c49:	00 00 00 
  802c4c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802c4f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c52:	be 02 00 00 00       	mov    $0x2,%esi
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 a7 19 80 00 00 	movabs $0x8019a7,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c68:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c6c:	79 30                	jns    802c9e <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802c6e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c71:	89 c1                	mov    %eax,%ecx
  802c73:	48 ba 06 46 80 00 00 	movabs $0x804606,%rdx
  802c7a:	00 00 00 
  802c7d:	be 88 00 00 00       	mov    $0x88,%esi
  802c82:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  802c89:	00 00 00 
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c91:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  802c98:	00 00 00 
  802c9b:	41 ff d0             	callq  *%r8

	return child;
  802c9e:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802ca1:	c9                   	leaveq 
  802ca2:	c3                   	retq   

0000000000802ca3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	41 55                	push   %r13
  802ca9:	41 54                	push   %r12
  802cab:	53                   	push   %rbx
  802cac:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802cb3:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802cba:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802cc1:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802cc8:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802ccf:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802cd6:	84 c0                	test   %al,%al
  802cd8:	74 26                	je     802d00 <spawnl+0x5d>
  802cda:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802ce1:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802ce8:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802cec:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802cf0:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802cf4:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802cf8:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802cfc:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802d00:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802d07:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802d0e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802d11:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802d18:	00 00 00 
  802d1b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802d22:	00 00 00 
  802d25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d29:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802d30:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802d37:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802d3e:	eb 07                	jmp    802d47 <spawnl+0xa4>
		argc++;
  802d40:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802d47:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802d4d:	83 f8 30             	cmp    $0x30,%eax
  802d50:	73 23                	jae    802d75 <spawnl+0xd2>
  802d52:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802d59:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802d5f:	89 c0                	mov    %eax,%eax
  802d61:	48 01 d0             	add    %rdx,%rax
  802d64:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802d6a:	83 c2 08             	add    $0x8,%edx
  802d6d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802d73:	eb 15                	jmp    802d8a <spawnl+0xe7>
  802d75:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802d7c:	48 89 d0             	mov    %rdx,%rax
  802d7f:	48 83 c2 08          	add    $0x8,%rdx
  802d83:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802d8a:	48 8b 00             	mov    (%rax),%rax
  802d8d:	48 85 c0             	test   %rax,%rax
  802d90:	75 ae                	jne    802d40 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802d92:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802d98:	83 c0 02             	add    $0x2,%eax
  802d9b:	48 89 e2             	mov    %rsp,%rdx
  802d9e:	48 89 d3             	mov    %rdx,%rbx
  802da1:	48 63 d0             	movslq %eax,%rdx
  802da4:	48 83 ea 01          	sub    $0x1,%rdx
  802da8:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802daf:	48 63 d0             	movslq %eax,%rdx
  802db2:	49 89 d4             	mov    %rdx,%r12
  802db5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802dbb:	48 63 d0             	movslq %eax,%rdx
  802dbe:	49 89 d2             	mov    %rdx,%r10
  802dc1:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802dc7:	48 98                	cltq   
  802dc9:	48 c1 e0 03          	shl    $0x3,%rax
  802dcd:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802dd1:	b8 10 00 00 00       	mov    $0x10,%eax
  802dd6:	48 83 e8 01          	sub    $0x1,%rax
  802dda:	48 01 d0             	add    %rdx,%rax
  802ddd:	bf 10 00 00 00       	mov    $0x10,%edi
  802de2:	ba 00 00 00 00       	mov    $0x0,%edx
  802de7:	48 f7 f7             	div    %rdi
  802dea:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802dee:	48 29 c4             	sub    %rax,%rsp
  802df1:	48 89 e0             	mov    %rsp,%rax
  802df4:	48 83 c0 07          	add    $0x7,%rax
  802df8:	48 c1 e8 03          	shr    $0x3,%rax
  802dfc:	48 c1 e0 03          	shl    $0x3,%rax
  802e00:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  802e07:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802e0e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  802e15:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802e18:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e1e:	8d 50 01             	lea    0x1(%rax),%edx
  802e21:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802e28:	48 63 d2             	movslq %edx,%rdx
  802e2b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802e32:	00 

	va_start(vl, arg0);
  802e33:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802e3a:	00 00 00 
  802e3d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802e44:	00 00 00 
  802e47:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e4b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802e52:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802e59:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802e60:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  802e67:	00 00 00 
  802e6a:	eb 63                	jmp    802ecf <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  802e6c:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  802e72:	8d 70 01             	lea    0x1(%rax),%esi
  802e75:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802e7b:	83 f8 30             	cmp    $0x30,%eax
  802e7e:	73 23                	jae    802ea3 <spawnl+0x200>
  802e80:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802e87:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802e8d:	89 c0                	mov    %eax,%eax
  802e8f:	48 01 d0             	add    %rdx,%rax
  802e92:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802e98:	83 c2 08             	add    $0x8,%edx
  802e9b:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802ea1:	eb 15                	jmp    802eb8 <spawnl+0x215>
  802ea3:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802eaa:	48 89 d0             	mov    %rdx,%rax
  802ead:	48 83 c2 08          	add    $0x8,%rdx
  802eb1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802eb8:	48 8b 08             	mov    (%rax),%rcx
  802ebb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802ec2:	89 f2                	mov    %esi,%edx
  802ec4:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802ec8:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  802ecf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ed5:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  802edb:	77 8f                	ja     802e6c <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802edd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802ee4:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  802eeb:	48 89 d6             	mov    %rdx,%rsi
  802eee:	48 89 c7             	mov    %rax,%rdi
  802ef1:	48 b8 48 29 80 00 00 	movabs $0x802948,%rax
  802ef8:	00 00 00 
  802efb:	ff d0                	callq  *%rax
  802efd:	48 89 dc             	mov    %rbx,%rsp
}
  802f00:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  802f04:	5b                   	pop    %rbx
  802f05:	41 5c                	pop    %r12
  802f07:	41 5d                	pop    %r13
  802f09:	5d                   	pop    %rbp
  802f0a:	c3                   	retq   

0000000000802f0b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  802f0b:	55                   	push   %rbp
  802f0c:	48 89 e5             	mov    %rsp,%rbp
  802f0f:	48 83 ec 50          	sub    $0x50,%rsp
  802f13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802f16:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802f1a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802f1e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f25:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  802f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802f2d:	eb 33                	jmp    802f62 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  802f2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f32:	48 98                	cltq   
  802f34:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802f3b:	00 
  802f3c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802f40:	48 01 d0             	add    %rdx,%rax
  802f43:	48 8b 00             	mov    (%rax),%rax
  802f46:	48 89 c7             	mov    %rax,%rdi
  802f49:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	83 c0 01             	add    $0x1,%eax
  802f58:	48 98                	cltq   
  802f5a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802f5e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802f62:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f65:	48 98                	cltq   
  802f67:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802f6e:	00 
  802f6f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802f73:	48 01 d0             	add    %rdx,%rax
  802f76:	48 8b 00             	mov    (%rax),%rax
  802f79:	48 85 c0             	test   %rax,%rax
  802f7c:	75 b1                	jne    802f2f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f82:	48 f7 d8             	neg    %rax
  802f85:	48 05 00 10 40 00    	add    $0x401000,%rax
  802f8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  802f8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f93:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802f97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  802f9f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fa2:	83 c2 01             	add    $0x1,%edx
  802fa5:	c1 e2 03             	shl    $0x3,%edx
  802fa8:	48 63 d2             	movslq %edx,%rdx
  802fab:	48 f7 da             	neg    %rdx
  802fae:	48 01 d0             	add    %rdx,%rax
  802fb1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802fb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb9:	48 83 e8 10          	sub    $0x10,%rax
  802fbd:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802fc3:	77 0a                	ja     802fcf <init_stack+0xc4>
		return -E_NO_MEM;
  802fc5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802fca:	e9 e3 01 00 00       	jmpq   8031b2 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802fcf:	ba 07 00 00 00       	mov    $0x7,%edx
  802fd4:	be 00 00 40 00       	mov    $0x400000,%esi
  802fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fde:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ff1:	79 08                	jns    802ffb <init_stack+0xf0>
		return r;
  802ff3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff6:	e9 b7 01 00 00       	jmpq   8031b2 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802ffb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803002:	e9 8a 00 00 00       	jmpq   803091 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803007:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80300a:	48 98                	cltq   
  80300c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803013:	00 
  803014:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803018:	48 01 c2             	add    %rax,%rdx
  80301b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803024:	48 01 c8             	add    %rcx,%rax
  803027:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80302d:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803030:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803033:	48 98                	cltq   
  803035:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80303c:	00 
  80303d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803041:	48 01 d0             	add    %rdx,%rax
  803044:	48 8b 10             	mov    (%rax),%rdx
  803047:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304b:	48 89 d6             	mov    %rdx,%rsi
  80304e:	48 89 c7             	mov    %rax,%rdi
  803051:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80305d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803060:	48 98                	cltq   
  803062:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803069:	00 
  80306a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80306e:	48 01 d0             	add    %rdx,%rax
  803071:	48 8b 00             	mov    (%rax),%rax
  803074:	48 89 c7             	mov    %rax,%rdi
  803077:	48 b8 17 0f 80 00 00 	movabs $0x800f17,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	48 98                	cltq   
  803085:	48 83 c0 01          	add    $0x1,%rax
  803089:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80308d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803091:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803094:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803097:	0f 8c 6a ff ff ff    	jl     803007 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80309d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030a0:	48 98                	cltq   
  8030a2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030a9:	00 
  8030aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ae:	48 01 d0             	add    %rdx,%rax
  8030b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8030b8:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8030bf:	00 
  8030c0:	74 35                	je     8030f7 <init_stack+0x1ec>
  8030c2:	48 b9 20 46 80 00 00 	movabs $0x804620,%rcx
  8030c9:	00 00 00 
  8030cc:	48 ba 46 46 80 00 00 	movabs $0x804646,%rdx
  8030d3:	00 00 00 
  8030d6:	be f1 00 00 00       	mov    $0xf1,%esi
  8030db:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  8030e2:	00 00 00 
  8030e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ea:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  8030f1:	00 00 00 
  8030f4:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8030f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030fb:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8030ff:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803104:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803108:	48 01 c8             	add    %rcx,%rax
  80310b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803111:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803114:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803118:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80311c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80311f:	48 98                	cltq   
  803121:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803124:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803129:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80312d:	48 01 d0             	add    %rdx,%rax
  803130:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803136:	48 89 c2             	mov    %rax,%rdx
  803139:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80313d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803140:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803143:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803149:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80314e:	89 c2                	mov    %eax,%edx
  803150:	be 00 00 40 00       	mov    $0x400000,%esi
  803155:	bf 00 00 00 00       	mov    $0x0,%edi
  80315a:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803169:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80316d:	79 02                	jns    803171 <init_stack+0x266>
		goto error;
  80316f:	eb 28                	jmp    803199 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803171:	be 00 00 40 00       	mov    $0x400000,%esi
  803176:	bf 00 00 00 00       	mov    $0x0,%edi
  80317b:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
  803187:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80318e:	79 02                	jns    803192 <init_stack+0x287>
		goto error;
  803190:	eb 07                	jmp    803199 <init_stack+0x28e>

	return 0;
  803192:	b8 00 00 00 00       	mov    $0x0,%eax
  803197:	eb 19                	jmp    8031b2 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803199:	be 00 00 40 00       	mov    $0x400000,%esi
  80319e:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a3:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
	return r;
  8031af:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8031b2:	c9                   	leaveq 
  8031b3:	c3                   	retq   

00000000008031b4 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8031b4:	55                   	push   %rbp
  8031b5:	48 89 e5             	mov    %rsp,%rbp
  8031b8:	48 83 ec 50          	sub    $0x50,%rsp
  8031bc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8031c7:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8031ca:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8031ce:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8031d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8031db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e2:	74 21                	je     803205 <map_segment+0x51>
		va -= i;
  8031e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e7:	48 98                	cltq   
  8031e9:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8031ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f0:	48 98                	cltq   
  8031f2:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8031f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f9:	48 98                	cltq   
  8031fb:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803205:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80320c:	e9 79 01 00 00       	jmpq   80338a <map_segment+0x1d6>
		if (i >= filesz) {
  803211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803214:	48 98                	cltq   
  803216:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80321a:	72 3c                	jb     803258 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80321c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80321f:	48 63 d0             	movslq %eax,%rdx
  803222:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803226:	48 01 d0             	add    %rdx,%rax
  803229:	48 89 c1             	mov    %rax,%rcx
  80322c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80322f:	8b 55 10             	mov    0x10(%rbp),%edx
  803232:	48 89 ce             	mov    %rcx,%rsi
  803235:	89 c7                	mov    %eax,%edi
  803237:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80323e:	00 00 00 
  803241:	ff d0                	callq  *%rax
  803243:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803246:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80324a:	0f 89 33 01 00 00    	jns    803383 <map_segment+0x1cf>
				return r;
  803250:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803253:	e9 46 01 00 00       	jmpq   80339e <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803258:	ba 07 00 00 00       	mov    $0x7,%edx
  80325d:	be 00 00 40 00       	mov    $0x400000,%esi
  803262:	bf 00 00 00 00       	mov    $0x0,%edi
  803267:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
  803273:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803276:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80327a:	79 08                	jns    803284 <map_segment+0xd0>
				return r;
  80327c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80327f:	e9 1a 01 00 00       	jmpq   80339e <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803284:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803287:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80328a:	01 c2                	add    %eax,%edx
  80328c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80328f:	89 d6                	mov    %edx,%esi
  803291:	89 c7                	mov    %eax,%edi
  803293:	48 b8 55 22 80 00 00 	movabs $0x802255,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
  80329f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032a6:	79 08                	jns    8032b0 <map_segment+0xfc>
				return r;
  8032a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032ab:	e9 ee 00 00 00       	jmpq   80339e <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8032b0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8032b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ba:	48 98                	cltq   
  8032bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8032c0:	48 29 c2             	sub    %rax,%rdx
  8032c3:	48 89 d0             	mov    %rdx,%rax
  8032c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8032ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032cd:	48 63 d0             	movslq %eax,%rdx
  8032d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d4:	48 39 c2             	cmp    %rax,%rdx
  8032d7:	48 0f 47 d0          	cmova  %rax,%rdx
  8032db:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8032de:	be 00 00 40 00       	mov    $0x400000,%esi
  8032e3:	89 c7                	mov    %eax,%edi
  8032e5:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  8032ec:	00 00 00 
  8032ef:	ff d0                	callq  *%rax
  8032f1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032f8:	79 08                	jns    803302 <map_segment+0x14e>
				return r;
  8032fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032fd:	e9 9c 00 00 00       	jmpq   80339e <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803305:	48 63 d0             	movslq %eax,%rdx
  803308:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330c:	48 01 d0             	add    %rdx,%rax
  80330f:	48 89 c2             	mov    %rax,%rdx
  803312:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803315:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803319:	48 89 d1             	mov    %rdx,%rcx
  80331c:	89 c2                	mov    %eax,%edx
  80331e:	be 00 00 40 00       	mov    $0x400000,%esi
  803323:	bf 00 00 00 00       	mov    $0x0,%edi
  803328:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
  803334:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803337:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80333b:	79 30                	jns    80336d <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80333d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803340:	89 c1                	mov    %eax,%ecx
  803342:	48 ba 5b 46 80 00 00 	movabs $0x80465b,%rdx
  803349:	00 00 00 
  80334c:	be 24 01 00 00       	mov    $0x124,%esi
  803351:	48 bf e0 45 80 00 00 	movabs $0x8045e0,%rdi
  803358:	00 00 00 
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax
  803360:	49 b8 95 01 80 00 00 	movabs $0x800195,%r8
  803367:	00 00 00 
  80336a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80336d:	be 00 00 40 00       	mov    $0x400000,%esi
  803372:	bf 00 00 00 00       	mov    $0x0,%edi
  803377:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803383:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80338a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338d:	48 98                	cltq   
  80338f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803393:	0f 82 78 fe ff ff    	jb     803211 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803399:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80339e:	c9                   	leaveq 
  80339f:	c3                   	retq   

00000000008033a0 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8033a0:	55                   	push   %rbp
  8033a1:	48 89 e5             	mov    %rsp,%rbp
  8033a4:	48 83 ec 20          	sub    $0x20,%rsp
  8033a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8033ab:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8033b2:	00 
  8033b3:	e9 c9 00 00 00       	jmpq   803481 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8033b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bc:	48 c1 e8 27          	shr    $0x27,%rax
  8033c0:	48 89 c2             	mov    %rax,%rdx
  8033c3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8033ca:	01 00 00 
  8033cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033d1:	48 85 c0             	test   %rax,%rax
  8033d4:	74 3c                	je     803412 <copy_shared_pages+0x72>
  8033d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033da:	48 c1 e8 1e          	shr    $0x1e,%rax
  8033de:	48 89 c2             	mov    %rax,%rdx
  8033e1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8033e8:	01 00 00 
  8033eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033ef:	48 85 c0             	test   %rax,%rax
  8033f2:	74 1e                	je     803412 <copy_shared_pages+0x72>
  8033f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f8:	48 c1 e8 15          	shr    $0x15,%rax
  8033fc:	48 89 c2             	mov    %rax,%rdx
  8033ff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803406:	01 00 00 
  803409:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80340d:	48 85 c0             	test   %rax,%rax
  803410:	75 02                	jne    803414 <copy_shared_pages+0x74>
                continue;
  803412:	eb 65                	jmp    803479 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803418:	48 c1 e8 0c          	shr    $0xc,%rax
  80341c:	48 89 c2             	mov    %rax,%rdx
  80341f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803426:	01 00 00 
  803429:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80342d:	25 00 04 00 00       	and    $0x400,%eax
  803432:	48 85 c0             	test   %rax,%rax
  803435:	74 42                	je     803479 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343b:	48 c1 e8 0c          	shr    $0xc,%rax
  80343f:	48 89 c2             	mov    %rax,%rdx
  803442:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803449:	01 00 00 
  80344c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803450:	25 07 0e 00 00       	and    $0xe07,%eax
  803455:	89 c6                	mov    %eax,%esi
  803457:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80345b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80345f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803462:	41 89 f0             	mov    %esi,%r8d
  803465:	48 89 c6             	mov    %rax,%rsi
  803468:	bf 00 00 00 00       	mov    $0x0,%edi
  80346d:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803479:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803480:	00 
  803481:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803488:	00 00 00 
  80348b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80348f:	0f 86 23 ff ff ff    	jbe    8033b8 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803495:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  80349a:	c9                   	leaveq 
  80349b:	c3                   	retq   

000000000080349c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80349c:	55                   	push   %rbp
  80349d:	48 89 e5             	mov    %rsp,%rbp
  8034a0:	53                   	push   %rbx
  8034a1:	48 83 ec 38          	sub    $0x38,%rsp
  8034a5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034a9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034ad:	48 89 c7             	mov    %rax,%rdi
  8034b0:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
  8034bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034c3:	0f 88 bf 01 00 00    	js     803688 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034cd:	ba 07 04 00 00       	mov    $0x407,%edx
  8034d2:	48 89 c6             	mov    %rax,%rsi
  8034d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8034da:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8034e1:	00 00 00 
  8034e4:	ff d0                	callq  *%rax
  8034e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034ed:	0f 88 95 01 00 00    	js     803688 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034f7:	48 89 c7             	mov    %rax,%rdi
  8034fa:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
  803506:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803509:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80350d:	0f 88 5d 01 00 00    	js     803670 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803517:	ba 07 04 00 00       	mov    $0x407,%edx
  80351c:	48 89 c6             	mov    %rax,%rsi
  80351f:	bf 00 00 00 00       	mov    $0x0,%edi
  803524:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803533:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803537:	0f 88 33 01 00 00    	js     803670 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80353d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803541:	48 89 c7             	mov    %rax,%rdi
  803544:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803558:	ba 07 04 00 00       	mov    $0x407,%edx
  80355d:	48 89 c6             	mov    %rax,%rsi
  803560:	bf 00 00 00 00       	mov    $0x0,%edi
  803565:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80356c:	00 00 00 
  80356f:	ff d0                	callq  *%rax
  803571:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803574:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803578:	79 05                	jns    80357f <pipe+0xe3>
		goto err2;
  80357a:	e9 d9 00 00 00       	jmpq   803658 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80357f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803583:	48 89 c7             	mov    %rax,%rdi
  803586:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
  803592:	48 89 c2             	mov    %rax,%rdx
  803595:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803599:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80359f:	48 89 d1             	mov    %rdx,%rcx
  8035a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a7:	48 89 c6             	mov    %rax,%rsi
  8035aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8035af:	48 b8 02 19 80 00 00 	movabs $0x801902,%rax
  8035b6:	00 00 00 
  8035b9:	ff d0                	callq  *%rax
  8035bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035c2:	79 1b                	jns    8035df <pipe+0x143>
		goto err3;
  8035c4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8035c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c9:	48 89 c6             	mov    %rax,%rsi
  8035cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d1:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	eb 79                	jmp    803658 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e3:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035ea:	00 00 00 
  8035ed:	8b 12                	mov    (%rdx),%edx
  8035ef:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8035fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803600:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803607:	00 00 00 
  80360a:	8b 12                	mov    (%rdx),%edx
  80360c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80360e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803612:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80361d:	48 89 c7             	mov    %rax,%rdi
  803620:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803627:	00 00 00 
  80362a:	ff d0                	callq  *%rax
  80362c:	89 c2                	mov    %eax,%edx
  80362e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803632:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803634:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803638:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80363c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803640:	48 89 c7             	mov    %rax,%rdi
  803643:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	eb 33                	jmp    80368b <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803658:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80365c:	48 89 c6             	mov    %rax,%rsi
  80365f:	bf 00 00 00 00       	mov    $0x0,%edi
  803664:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803674:	48 89 c6             	mov    %rax,%rsi
  803677:	bf 00 00 00 00       	mov    $0x0,%edi
  80367c:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
    err:
	return r;
  803688:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80368b:	48 83 c4 38          	add    $0x38,%rsp
  80368f:	5b                   	pop    %rbx
  803690:	5d                   	pop    %rbp
  803691:	c3                   	retq   

0000000000803692 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803692:	55                   	push   %rbp
  803693:	48 89 e5             	mov    %rsp,%rbp
  803696:	53                   	push   %rbx
  803697:	48 83 ec 28          	sub    $0x28,%rsp
  80369b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80369f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036aa:	00 00 00 
  8036ad:	48 8b 00             	mov    (%rax),%rax
  8036b0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036bd:	48 89 c7             	mov    %rax,%rdi
  8036c0:	48 b8 02 3f 80 00 00 	movabs $0x803f02,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
  8036cc:	89 c3                	mov    %eax,%ebx
  8036ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d2:	48 89 c7             	mov    %rax,%rdi
  8036d5:	48 b8 02 3f 80 00 00 	movabs $0x803f02,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	39 c3                	cmp    %eax,%ebx
  8036e3:	0f 94 c0             	sete   %al
  8036e6:	0f b6 c0             	movzbl %al,%eax
  8036e9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036ec:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036f3:	00 00 00 
  8036f6:	48 8b 00             	mov    (%rax),%rax
  8036f9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036ff:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803705:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803708:	75 05                	jne    80370f <_pipeisclosed+0x7d>
			return ret;
  80370a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80370d:	eb 4f                	jmp    80375e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80370f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803712:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803715:	74 42                	je     803759 <_pipeisclosed+0xc7>
  803717:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80371b:	75 3c                	jne    803759 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80371d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803724:	00 00 00 
  803727:	48 8b 00             	mov    (%rax),%rax
  80372a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803730:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803733:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803736:	89 c6                	mov    %eax,%esi
  803738:	48 bf 7d 46 80 00 00 	movabs $0x80467d,%rdi
  80373f:	00 00 00 
  803742:	b8 00 00 00 00       	mov    $0x0,%eax
  803747:	49 b8 ce 03 80 00 00 	movabs $0x8003ce,%r8
  80374e:	00 00 00 
  803751:	41 ff d0             	callq  *%r8
	}
  803754:	e9 4a ff ff ff       	jmpq   8036a3 <_pipeisclosed+0x11>
  803759:	e9 45 ff ff ff       	jmpq   8036a3 <_pipeisclosed+0x11>
}
  80375e:	48 83 c4 28          	add    $0x28,%rsp
  803762:	5b                   	pop    %rbx
  803763:	5d                   	pop    %rbp
  803764:	c3                   	retq   

0000000000803765 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803765:	55                   	push   %rbp
  803766:	48 89 e5             	mov    %rsp,%rbp
  803769:	48 83 ec 30          	sub    $0x30,%rsp
  80376d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803770:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803774:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803777:	48 89 d6             	mov    %rdx,%rsi
  80377a:	89 c7                	mov    %eax,%edi
  80377c:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80378f:	79 05                	jns    803796 <pipeisclosed+0x31>
		return r;
  803791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803794:	eb 31                	jmp    8037c7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379a:	48 89 c7             	mov    %rax,%rdi
  80379d:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8037a4:	00 00 00 
  8037a7:	ff d0                	callq  *%rax
  8037a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b5:	48 89 d6             	mov    %rdx,%rsi
  8037b8:	48 89 c7             	mov    %rax,%rdi
  8037bb:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
}
  8037c7:	c9                   	leaveq 
  8037c8:	c3                   	retq   

00000000008037c9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037c9:	55                   	push   %rbp
  8037ca:	48 89 e5             	mov    %rsp,%rbp
  8037cd:	48 83 ec 40          	sub    $0x40,%rsp
  8037d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e1:	48 89 c7             	mov    %rax,%rdi
  8037e4:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
  8037f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037fc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803803:	00 
  803804:	e9 92 00 00 00       	jmpq   80389b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803809:	eb 41                	jmp    80384c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80380b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803810:	74 09                	je     80381b <devpipe_read+0x52>
				return i;
  803812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803816:	e9 92 00 00 00       	jmpq   8038ad <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80381b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80381f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803823:	48 89 d6             	mov    %rdx,%rsi
  803826:	48 89 c7             	mov    %rax,%rdi
  803829:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
  803835:	85 c0                	test   %eax,%eax
  803837:	74 07                	je     803840 <devpipe_read+0x77>
				return 0;
  803839:	b8 00 00 00 00       	mov    $0x0,%eax
  80383e:	eb 6d                	jmp    8038ad <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803840:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80384c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803850:	8b 10                	mov    (%rax),%edx
  803852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803856:	8b 40 04             	mov    0x4(%rax),%eax
  803859:	39 c2                	cmp    %eax,%edx
  80385b:	74 ae                	je     80380b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80385d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803861:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803865:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803869:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386d:	8b 00                	mov    (%rax),%eax
  80386f:	99                   	cltd   
  803870:	c1 ea 1b             	shr    $0x1b,%edx
  803873:	01 d0                	add    %edx,%eax
  803875:	83 e0 1f             	and    $0x1f,%eax
  803878:	29 d0                	sub    %edx,%eax
  80387a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80387e:	48 98                	cltq   
  803880:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803885:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80388b:	8b 00                	mov    (%rax),%eax
  80388d:	8d 50 01             	lea    0x1(%rax),%edx
  803890:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803894:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803896:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80389b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038a3:	0f 82 60 ff ff ff    	jb     803809 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038ad:	c9                   	leaveq 
  8038ae:	c3                   	retq   

00000000008038af <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038af:	55                   	push   %rbp
  8038b0:	48 89 e5             	mov    %rsp,%rbp
  8038b3:	48 83 ec 40          	sub    $0x40,%rsp
  8038b7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c7:	48 89 c7             	mov    %rax,%rdi
  8038ca:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
  8038d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038de:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038e2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038e9:	00 
  8038ea:	e9 8e 00 00 00       	jmpq   80397d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038ef:	eb 31                	jmp    803922 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f9:	48 89 d6             	mov    %rdx,%rsi
  8038fc:	48 89 c7             	mov    %rax,%rdi
  8038ff:	48 b8 92 36 80 00 00 	movabs $0x803692,%rax
  803906:	00 00 00 
  803909:	ff d0                	callq  *%rax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	74 07                	je     803916 <devpipe_write+0x67>
				return 0;
  80390f:	b8 00 00 00 00       	mov    $0x0,%eax
  803914:	eb 79                	jmp    80398f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803916:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  80391d:	00 00 00 
  803920:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803926:	8b 40 04             	mov    0x4(%rax),%eax
  803929:	48 63 d0             	movslq %eax,%rdx
  80392c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803930:	8b 00                	mov    (%rax),%eax
  803932:	48 98                	cltq   
  803934:	48 83 c0 20          	add    $0x20,%rax
  803938:	48 39 c2             	cmp    %rax,%rdx
  80393b:	73 b4                	jae    8038f1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	8b 40 04             	mov    0x4(%rax),%eax
  803944:	99                   	cltd   
  803945:	c1 ea 1b             	shr    $0x1b,%edx
  803948:	01 d0                	add    %edx,%eax
  80394a:	83 e0 1f             	and    $0x1f,%eax
  80394d:	29 d0                	sub    %edx,%eax
  80394f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803953:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803957:	48 01 ca             	add    %rcx,%rdx
  80395a:	0f b6 0a             	movzbl (%rdx),%ecx
  80395d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803961:	48 98                	cltq   
  803963:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396b:	8b 40 04             	mov    0x4(%rax),%eax
  80396e:	8d 50 01             	lea    0x1(%rax),%edx
  803971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803975:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803978:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80397d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803981:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803985:	0f 82 64 ff ff ff    	jb     8038ef <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80398b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80398f:	c9                   	leaveq 
  803990:	c3                   	retq   

0000000000803991 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803991:	55                   	push   %rbp
  803992:	48 89 e5             	mov    %rsp,%rbp
  803995:	48 83 ec 20          	sub    $0x20,%rsp
  803999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80399d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
  8039b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039bc:	48 be 90 46 80 00 00 	movabs $0x804690,%rsi
  8039c3:	00 00 00 
  8039c6:	48 89 c7             	mov    %rax,%rdi
  8039c9:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  8039d0:	00 00 00 
  8039d3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d9:	8b 50 04             	mov    0x4(%rax),%edx
  8039dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e0:	8b 00                	mov    (%rax),%eax
  8039e2:	29 c2                	sub    %eax,%edx
  8039e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039f9:	00 00 00 
	stat->st_dev = &devpipe;
  8039fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a00:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a07:	00 00 00 
  803a0a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a16:	c9                   	leaveq 
  803a17:	c3                   	retq   

0000000000803a18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a18:	55                   	push   %rbp
  803a19:	48 89 e5             	mov    %rsp,%rbp
  803a1c:	48 83 ec 10          	sub    $0x10,%rsp
  803a20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a28:	48 89 c6             	mov    %rax,%rsi
  803a2b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a30:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a40:	48 89 c7             	mov    %rax,%rdi
  803a43:	48 b8 42 1b 80 00 00 	movabs $0x801b42,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
  803a4f:	48 89 c6             	mov    %rax,%rsi
  803a52:	bf 00 00 00 00       	mov    $0x0,%edi
  803a57:	48 b8 5d 19 80 00 00 	movabs $0x80195d,%rax
  803a5e:	00 00 00 
  803a61:	ff d0                	callq  *%rax
}
  803a63:	c9                   	leaveq 
  803a64:	c3                   	retq   

0000000000803a65 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a65:	55                   	push   %rbp
  803a66:	48 89 e5             	mov    %rsp,%rbp
  803a69:	48 83 ec 20          	sub    $0x20,%rsp
  803a6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a73:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a76:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a7a:	be 01 00 00 00       	mov    $0x1,%esi
  803a7f:	48 89 c7             	mov    %rax,%rdi
  803a82:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
}
  803a8e:	c9                   	leaveq 
  803a8f:	c3                   	retq   

0000000000803a90 <getchar>:

int
getchar(void)
{
  803a90:	55                   	push   %rbp
  803a91:	48 89 e5             	mov    %rsp,%rbp
  803a94:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a98:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a9c:	ba 01 00 00 00       	mov    $0x1,%edx
  803aa1:	48 89 c6             	mov    %rax,%rsi
  803aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa9:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
  803ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803abc:	79 05                	jns    803ac3 <getchar+0x33>
		return r;
  803abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac1:	eb 14                	jmp    803ad7 <getchar+0x47>
	if (r < 1)
  803ac3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac7:	7f 07                	jg     803ad0 <getchar+0x40>
		return -E_EOF;
  803ac9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ace:	eb 07                	jmp    803ad7 <getchar+0x47>
	return c;
  803ad0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ad4:	0f b6 c0             	movzbl %al,%eax
}
  803ad7:	c9                   	leaveq 
  803ad8:	c3                   	retq   

0000000000803ad9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ad9:	55                   	push   %rbp
  803ada:	48 89 e5             	mov    %rsp,%rbp
  803add:	48 83 ec 20          	sub    $0x20,%rsp
  803ae1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ae4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ae8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aeb:	48 89 d6             	mov    %rdx,%rsi
  803aee:	89 c7                	mov    %eax,%edi
  803af0:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  803af7:	00 00 00 
  803afa:	ff d0                	callq  *%rax
  803afc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b03:	79 05                	jns    803b0a <iscons+0x31>
		return r;
  803b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b08:	eb 1a                	jmp    803b24 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0e:	8b 10                	mov    (%rax),%edx
  803b10:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b17:	00 00 00 
  803b1a:	8b 00                	mov    (%rax),%eax
  803b1c:	39 c2                	cmp    %eax,%edx
  803b1e:	0f 94 c0             	sete   %al
  803b21:	0f b6 c0             	movzbl %al,%eax
}
  803b24:	c9                   	leaveq 
  803b25:	c3                   	retq   

0000000000803b26 <opencons>:

int
opencons(void)
{
  803b26:	55                   	push   %rbp
  803b27:	48 89 e5             	mov    %rsp,%rbp
  803b2a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b2e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b32:	48 89 c7             	mov    %rax,%rdi
  803b35:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b48:	79 05                	jns    803b4f <opencons+0x29>
		return r;
  803b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b4d:	eb 5b                	jmp    803baa <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b53:	ba 07 04 00 00       	mov    $0x407,%edx
  803b58:	48 89 c6             	mov    %rax,%rsi
  803b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b60:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
  803b6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b73:	79 05                	jns    803b7a <opencons+0x54>
		return r;
  803b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b78:	eb 30                	jmp    803baa <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b85:	00 00 00 
  803b88:	8b 12                	mov    (%rdx),%edx
  803b8a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b90:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9b:	48 89 c7             	mov    %rax,%rdi
  803b9e:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
}
  803baa:	c9                   	leaveq 
  803bab:	c3                   	retq   

0000000000803bac <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bac:	55                   	push   %rbp
  803bad:	48 89 e5             	mov    %rsp,%rbp
  803bb0:	48 83 ec 30          	sub    $0x30,%rsp
  803bb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bc0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bc5:	75 07                	jne    803bce <devcons_read+0x22>
		return 0;
  803bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bcc:	eb 4b                	jmp    803c19 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bce:	eb 0c                	jmp    803bdc <devcons_read+0x30>
		sys_yield();
  803bd0:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803bd7:	00 00 00 
  803bda:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bdc:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  803be3:	00 00 00 
  803be6:	ff d0                	callq  *%rax
  803be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bef:	74 df                	je     803bd0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf5:	79 05                	jns    803bfc <devcons_read+0x50>
		return c;
  803bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfa:	eb 1d                	jmp    803c19 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bfc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c00:	75 07                	jne    803c09 <devcons_read+0x5d>
		return 0;
  803c02:	b8 00 00 00 00       	mov    $0x0,%eax
  803c07:	eb 10                	jmp    803c19 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0c:	89 c2                	mov    %eax,%edx
  803c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c12:	88 10                	mov    %dl,(%rax)
	return 1;
  803c14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c19:	c9                   	leaveq 
  803c1a:	c3                   	retq   

0000000000803c1b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c1b:	55                   	push   %rbp
  803c1c:	48 89 e5             	mov    %rsp,%rbp
  803c1f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c26:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c2d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c34:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c42:	eb 76                	jmp    803cba <devcons_write+0x9f>
		m = n - tot;
  803c44:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c4b:	89 c2                	mov    %eax,%edx
  803c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c50:	29 c2                	sub    %eax,%edx
  803c52:	89 d0                	mov    %edx,%eax
  803c54:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5a:	83 f8 7f             	cmp    $0x7f,%eax
  803c5d:	76 07                	jbe    803c66 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c5f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c69:	48 63 d0             	movslq %eax,%rdx
  803c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6f:	48 63 c8             	movslq %eax,%rcx
  803c72:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c79:	48 01 c1             	add    %rax,%rcx
  803c7c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c83:	48 89 ce             	mov    %rcx,%rsi
  803c86:	48 89 c7             	mov    %rax,%rdi
  803c89:	48 b8 a7 12 80 00 00 	movabs $0x8012a7,%rax
  803c90:	00 00 00 
  803c93:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c98:	48 63 d0             	movslq %eax,%rdx
  803c9b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ca2:	48 89 d6             	mov    %rdx,%rsi
  803ca5:	48 89 c7             	mov    %rax,%rdi
  803ca8:	48 b8 6a 17 80 00 00 	movabs $0x80176a,%rax
  803caf:	00 00 00 
  803cb2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cb4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cb7:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbd:	48 98                	cltq   
  803cbf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cc6:	0f 82 78 ff ff ff    	jb     803c44 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ccf:	c9                   	leaveq 
  803cd0:	c3                   	retq   

0000000000803cd1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cd1:	55                   	push   %rbp
  803cd2:	48 89 e5             	mov    %rsp,%rbp
  803cd5:	48 83 ec 08          	sub    $0x8,%rsp
  803cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ce2:	c9                   	leaveq 
  803ce3:	c3                   	retq   

0000000000803ce4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ce4:	55                   	push   %rbp
  803ce5:	48 89 e5             	mov    %rsp,%rbp
  803ce8:	48 83 ec 10          	sub    $0x10,%rsp
  803cec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cf0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf8:	48 be 9c 46 80 00 00 	movabs $0x80469c,%rsi
  803cff:	00 00 00 
  803d02:	48 89 c7             	mov    %rax,%rdi
  803d05:	48 b8 83 0f 80 00 00 	movabs $0x800f83,%rax
  803d0c:	00 00 00 
  803d0f:	ff d0                	callq  *%rax
	return 0;
  803d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d16:	c9                   	leaveq 
  803d17:	c3                   	retq   

0000000000803d18 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d18:	55                   	push   %rbp
  803d19:	48 89 e5             	mov    %rsp,%rbp
  803d1c:	48 83 ec 30          	sub    $0x30,%rsp
  803d20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803d2c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d33:	00 00 00 
  803d36:	48 8b 00             	mov    (%rax),%rax
  803d39:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d3f:	85 c0                	test   %eax,%eax
  803d41:	75 3c                	jne    803d7f <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d43:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803d4a:	00 00 00 
  803d4d:	ff d0                	callq  *%rax
  803d4f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d54:	48 63 d0             	movslq %eax,%rdx
  803d57:	48 89 d0             	mov    %rdx,%rax
  803d5a:	48 c1 e0 03          	shl    $0x3,%rax
  803d5e:	48 01 d0             	add    %rdx,%rax
  803d61:	48 c1 e0 05          	shl    $0x5,%rax
  803d65:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d6c:	00 00 00 
  803d6f:	48 01 c2             	add    %rax,%rdx
  803d72:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d79:	00 00 00 
  803d7c:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803d7f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d84:	75 0e                	jne    803d94 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803d86:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d8d:	00 00 00 
  803d90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d98:	48 89 c7             	mov    %rax,%rdi
  803d9b:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  803da2:	00 00 00 
  803da5:	ff d0                	callq  *%rax
  803da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dae:	79 19                	jns    803dc9 <ipc_recv+0xb1>
		*from_env_store = 0;
  803db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803dba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dbe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc7:	eb 53                	jmp    803e1c <ipc_recv+0x104>
	}
	if(from_env_store)
  803dc9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803dce:	74 19                	je     803de9 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803dd0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dd7:	00 00 00 
  803dda:	48 8b 00             	mov    (%rax),%rax
  803ddd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803de3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803de7:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803de9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dee:	74 19                	je     803e09 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803df0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803df7:	00 00 00 
  803dfa:	48 8b 00             	mov    (%rax),%rax
  803dfd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e07:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e09:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e10:	00 00 00 
  803e13:	48 8b 00             	mov    (%rax),%rax
  803e16:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e1c:	c9                   	leaveq 
  803e1d:	c3                   	retq   

0000000000803e1e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e1e:	55                   	push   %rbp
  803e1f:	48 89 e5             	mov    %rsp,%rbp
  803e22:	48 83 ec 30          	sub    $0x30,%rsp
  803e26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e29:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e2c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e30:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803e33:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e38:	75 0e                	jne    803e48 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e3a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e41:	00 00 00 
  803e44:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e48:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e4b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e4e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e55:	89 c7                	mov    %eax,%edi
  803e57:	48 b8 86 1a 80 00 00 	movabs $0x801a86,%rax
  803e5e:	00 00 00 
  803e61:	ff d0                	callq  *%rax
  803e63:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e66:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e6a:	75 0c                	jne    803e78 <ipc_send+0x5a>
			sys_yield();
  803e6c:	48 b8 74 18 80 00 00 	movabs $0x801874,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e78:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e7c:	74 ca                	je     803e48 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803e7e:	c9                   	leaveq 
  803e7f:	c3                   	retq   

0000000000803e80 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e80:	55                   	push   %rbp
  803e81:	48 89 e5             	mov    %rsp,%rbp
  803e84:	48 83 ec 14          	sub    $0x14,%rsp
  803e88:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803e8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e92:	eb 5e                	jmp    803ef2 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e94:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e9b:	00 00 00 
  803e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea1:	48 63 d0             	movslq %eax,%rdx
  803ea4:	48 89 d0             	mov    %rdx,%rax
  803ea7:	48 c1 e0 03          	shl    $0x3,%rax
  803eab:	48 01 d0             	add    %rdx,%rax
  803eae:	48 c1 e0 05          	shl    $0x5,%rax
  803eb2:	48 01 c8             	add    %rcx,%rax
  803eb5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ebb:	8b 00                	mov    (%rax),%eax
  803ebd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ec0:	75 2c                	jne    803eee <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ec2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ec9:	00 00 00 
  803ecc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ecf:	48 63 d0             	movslq %eax,%rdx
  803ed2:	48 89 d0             	mov    %rdx,%rax
  803ed5:	48 c1 e0 03          	shl    $0x3,%rax
  803ed9:	48 01 d0             	add    %rdx,%rax
  803edc:	48 c1 e0 05          	shl    $0x5,%rax
  803ee0:	48 01 c8             	add    %rcx,%rax
  803ee3:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ee9:	8b 40 08             	mov    0x8(%rax),%eax
  803eec:	eb 12                	jmp    803f00 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803eee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ef2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ef9:	7e 99                	jle    803e94 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803efb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f00:	c9                   	leaveq 
  803f01:	c3                   	retq   

0000000000803f02 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f02:	55                   	push   %rbp
  803f03:	48 89 e5             	mov    %rsp,%rbp
  803f06:	48 83 ec 18          	sub    $0x18,%rsp
  803f0a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f12:	48 c1 e8 15          	shr    $0x15,%rax
  803f16:	48 89 c2             	mov    %rax,%rdx
  803f19:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f20:	01 00 00 
  803f23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f27:	83 e0 01             	and    $0x1,%eax
  803f2a:	48 85 c0             	test   %rax,%rax
  803f2d:	75 07                	jne    803f36 <pageref+0x34>
		return 0;
  803f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f34:	eb 53                	jmp    803f89 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f3e:	48 89 c2             	mov    %rax,%rdx
  803f41:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f48:	01 00 00 
  803f4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f57:	83 e0 01             	and    $0x1,%eax
  803f5a:	48 85 c0             	test   %rax,%rax
  803f5d:	75 07                	jne    803f66 <pageref+0x64>
		return 0;
  803f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f64:	eb 23                	jmp    803f89 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6a:	48 c1 e8 0c          	shr    $0xc,%rax
  803f6e:	48 89 c2             	mov    %rax,%rdx
  803f71:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f78:	00 00 00 
  803f7b:	48 c1 e2 04          	shl    $0x4,%rdx
  803f7f:	48 01 d0             	add    %rdx,%rax
  803f82:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f86:	0f b7 c0             	movzwl %ax,%eax
}
  803f89:	c9                   	leaveq 
  803f8a:	c3                   	retq   
