
obj/user/faultdie.debug:     file format elf64-x86-64


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
  80003c:	e8 9c 00 00 00       	callq  8000dd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 80 35 80 00 00 	movabs $0x803580,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	c9                   	leaveq 
  8000aa:	c3                   	retq   

00000000008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %rbp
  8000ac:	48 89 e5             	mov    %rsp,%rbp
  8000af:	48 83 ec 10          	sub    $0x10,%rsp
  8000b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000ba:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c1:	00 00 00 
  8000c4:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d0:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
  8000e1:	48 83 ec 10          	sub    $0x10,%rsp
  8000e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ec:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	48 63 d0             	movslq %eax,%rdx
  800100:	48 89 d0             	mov    %rdx,%rax
  800103:	48 c1 e0 03          	shl    $0x3,%rax
  800107:	48 01 d0             	add    %rdx,%rax
  80010a:	48 c1 e0 05          	shl    $0x5,%rax
  80010e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800115:	00 00 00 
  800118:	48 01 c2             	add    %rax,%rdx
  80011b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800122:	00 00 00 
  800125:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80012c:	7e 14                	jle    800142 <libmain+0x65>
		binaryname = argv[0];
  80012e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800132:	48 8b 10             	mov    (%rax),%rdx
  800135:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80013c:	00 00 00 
  80013f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800142:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800146:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800149:	48 89 d6             	mov    %rdx,%rsi
  80014c:	89 c7                	mov    %eax,%edi
  80014e:	48 b8 ab 00 80 00 00 	movabs $0x8000ab,%rax
  800155:	00 00 00 
  800158:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80015a:	48 b8 68 01 80 00 00 	movabs $0x800168,%rax
  800161:	00 00 00 
  800164:	ff d0                	callq  *%rax
}
  800166:	c9                   	leaveq 
  800167:	c3                   	retq   

0000000000800168 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800168:	55                   	push   %rbp
  800169:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80016c:	48 b8 82 1e 80 00 00 	movabs $0x801e82,%rax
  800173:	00 00 00 
  800176:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800178:	bf 00 00 00 00       	mov    $0x0,%edi
  80017d:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  800184:	00 00 00 
  800187:	ff d0                	callq  *%rax

}
  800189:	5d                   	pop    %rbp
  80018a:	c3                   	retq   

000000000080018b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018b:	55                   	push   %rbp
  80018c:	48 89 e5             	mov    %rsp,%rbp
  80018f:	48 83 ec 10          	sub    $0x10,%rsp
  800193:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800196:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80019a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019e:	8b 00                	mov    (%rax),%eax
  8001a0:	8d 48 01             	lea    0x1(%rax),%ecx
  8001a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a7:	89 0a                	mov    %ecx,(%rdx)
  8001a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ac:	89 d1                	mov    %edx,%ecx
  8001ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b2:	48 98                	cltq   
  8001b4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	8b 00                	mov    (%rax),%eax
  8001be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c3:	75 2c                	jne    8001f1 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8001c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c9:	8b 00                	mov    (%rax),%eax
  8001cb:	48 98                	cltq   
  8001cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d1:	48 83 c2 08          	add    $0x8,%rdx
  8001d5:	48 89 c6             	mov    %rax,%rsi
  8001d8:	48 89 d7             	mov    %rdx,%rdi
  8001db:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
		b->idx = 0;
  8001e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001eb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f5:	8b 40 04             	mov    0x4(%rax),%eax
  8001f8:	8d 50 01             	lea    0x1(%rax),%edx
  8001fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ff:	89 50 04             	mov    %edx,0x4(%rax)
}
  800202:	c9                   	leaveq 
  800203:	c3                   	retq   

0000000000800204 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800204:	55                   	push   %rbp
  800205:	48 89 e5             	mov    %rsp,%rbp
  800208:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80020f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800216:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80021d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800224:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80022b:	48 8b 0a             	mov    (%rdx),%rcx
  80022e:	48 89 08             	mov    %rcx,(%rax)
  800231:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800235:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800239:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80023d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800241:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800248:	00 00 00 
	b.cnt = 0;
  80024b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800252:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800255:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80025c:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800263:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80026a:	48 89 c6             	mov    %rax,%rsi
  80026d:	48 bf 8b 01 80 00 00 	movabs $0x80018b,%rdi
  800274:	00 00 00 
  800277:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800283:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800289:	48 98                	cltq   
  80028b:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800292:	48 83 c2 08          	add    $0x8,%rdx
  800296:	48 89 c6             	mov    %rax,%rsi
  800299:	48 89 d7             	mov    %rdx,%rdi
  80029c:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002ae:	c9                   	leaveq 
  8002af:	c3                   	retq   

00000000008002b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b0:	55                   	push   %rbp
  8002b1:	48 89 e5             	mov    %rsp,%rbp
  8002b4:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002bb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002c9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002d7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002de:	84 c0                	test   %al,%al
  8002e0:	74 20                	je     800302 <cprintf+0x52>
  8002e2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002e6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002ee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002f6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002fa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002fe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800302:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800309:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800310:	00 00 00 
  800313:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80031a:	00 00 00 
  80031d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800321:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800328:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80032f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800336:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80033d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800344:	48 8b 0a             	mov    (%rdx),%rcx
  800347:	48 89 08             	mov    %rcx,(%rax)
  80034a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800352:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800356:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80035a:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800361:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800368:	48 89 d6             	mov    %rdx,%rsi
  80036b:	48 89 c7             	mov    %rax,%rdi
  80036e:	48 b8 04 02 80 00 00 	movabs $0x800204,%rax
  800375:	00 00 00 
  800378:	ff d0                	callq  *%rax
  80037a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800380:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800386:	c9                   	leaveq 
  800387:	c3                   	retq   

0000000000800388 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	53                   	push   %rbx
  80038d:	48 83 ec 38          	sub    $0x38,%rsp
  800391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80039d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003a0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003a4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003ab:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003af:	77 3b                	ja     8003ec <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003b4:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003b8:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c4:	48 f7 f3             	div    %rbx
  8003c7:	48 89 c2             	mov    %rax,%rdx
  8003ca:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003cd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d0:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003d8:	41 89 f9             	mov    %edi,%r9d
  8003db:	48 89 c7             	mov    %rax,%rdi
  8003de:	48 b8 88 03 80 00 00 	movabs $0x800388,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
  8003ea:	eb 1e                	jmp    80040a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ec:	eb 12                	jmp    800400 <printnum+0x78>
			putch(padc, putdat);
  8003ee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f9:	48 89 ce             	mov    %rcx,%rsi
  8003fc:	89 d7                	mov    %edx,%edi
  8003fe:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800400:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800404:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800408:	7f e4                	jg     8003ee <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80040d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	48 f7 f1             	div    %rcx
  800419:	48 89 d0             	mov    %rdx,%rax
  80041c:	48 ba 88 37 80 00 00 	movabs $0x803788,%rdx
  800423:	00 00 00 
  800426:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80042a:	0f be d0             	movsbl %al,%edx
  80042d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800435:	48 89 ce             	mov    %rcx,%rsi
  800438:	89 d7                	mov    %edx,%edi
  80043a:	ff d0                	callq  *%rax
}
  80043c:	48 83 c4 38          	add    $0x38,%rsp
  800440:	5b                   	pop    %rbx
  800441:	5d                   	pop    %rbp
  800442:	c3                   	retq   

0000000000800443 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 1c          	sub    $0x1c,%rsp
  80044b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80044f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800452:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800456:	7e 52                	jle    8004aa <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045c:	8b 00                	mov    (%rax),%eax
  80045e:	83 f8 30             	cmp    $0x30,%eax
  800461:	73 24                	jae    800487 <getuint+0x44>
  800463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800467:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80046b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046f:	8b 00                	mov    (%rax),%eax
  800471:	89 c0                	mov    %eax,%eax
  800473:	48 01 d0             	add    %rdx,%rax
  800476:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047a:	8b 12                	mov    (%rdx),%edx
  80047c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80047f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800483:	89 0a                	mov    %ecx,(%rdx)
  800485:	eb 17                	jmp    80049e <getuint+0x5b>
  800487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048f:	48 89 d0             	mov    %rdx,%rax
  800492:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80049e:	48 8b 00             	mov    (%rax),%rax
  8004a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a5:	e9 a3 00 00 00       	jmpq   80054d <getuint+0x10a>
	else if (lflag)
  8004aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ae:	74 4f                	je     8004ff <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	8b 00                	mov    (%rax),%eax
  8004b6:	83 f8 30             	cmp    $0x30,%eax
  8004b9:	73 24                	jae    8004df <getuint+0x9c>
  8004bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	8b 00                	mov    (%rax),%eax
  8004c9:	89 c0                	mov    %eax,%eax
  8004cb:	48 01 d0             	add    %rdx,%rax
  8004ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d2:	8b 12                	mov    (%rdx),%edx
  8004d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	89 0a                	mov    %ecx,(%rdx)
  8004dd:	eb 17                	jmp    8004f6 <getuint+0xb3>
  8004df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004e7:	48 89 d0             	mov    %rdx,%rax
  8004ea:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f6:	48 8b 00             	mov    (%rax),%rax
  8004f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004fd:	eb 4e                	jmp    80054d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	8b 00                	mov    (%rax),%eax
  800505:	83 f8 30             	cmp    $0x30,%eax
  800508:	73 24                	jae    80052e <getuint+0xeb>
  80050a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800516:	8b 00                	mov    (%rax),%eax
  800518:	89 c0                	mov    %eax,%eax
  80051a:	48 01 d0             	add    %rdx,%rax
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	8b 12                	mov    (%rdx),%edx
  800523:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800526:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052a:	89 0a                	mov    %ecx,(%rdx)
  80052c:	eb 17                	jmp    800545 <getuint+0x102>
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800536:	48 89 d0             	mov    %rdx,%rax
  800539:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80053d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800541:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800545:	8b 00                	mov    (%rax),%eax
  800547:	89 c0                	mov    %eax,%eax
  800549:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80054d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800551:	c9                   	leaveq 
  800552:	c3                   	retq   

0000000000800553 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800553:	55                   	push   %rbp
  800554:	48 89 e5             	mov    %rsp,%rbp
  800557:	48 83 ec 1c          	sub    $0x1c,%rsp
  80055b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80055f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800562:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800566:	7e 52                	jle    8005ba <getint+0x67>
		x=va_arg(*ap, long long);
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	83 f8 30             	cmp    $0x30,%eax
  800571:	73 24                	jae    800597 <getint+0x44>
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	8b 00                	mov    (%rax),%eax
  800581:	89 c0                	mov    %eax,%eax
  800583:	48 01 d0             	add    %rdx,%rax
  800586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058a:	8b 12                	mov    (%rdx),%edx
  80058c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800593:	89 0a                	mov    %ecx,(%rdx)
  800595:	eb 17                	jmp    8005ae <getint+0x5b>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80059f:	48 89 d0             	mov    %rdx,%rax
  8005a2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ae:	48 8b 00             	mov    (%rax),%rax
  8005b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b5:	e9 a3 00 00 00       	jmpq   80065d <getint+0x10a>
	else if (lflag)
  8005ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005be:	74 4f                	je     80060f <getint+0xbc>
		x=va_arg(*ap, long);
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	8b 00                	mov    (%rax),%eax
  8005c6:	83 f8 30             	cmp    $0x30,%eax
  8005c9:	73 24                	jae    8005ef <getint+0x9c>
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	89 c0                	mov    %eax,%eax
  8005db:	48 01 d0             	add    %rdx,%rax
  8005de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e2:	8b 12                	mov    (%rdx),%edx
  8005e4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	89 0a                	mov    %ecx,(%rdx)
  8005ed:	eb 17                	jmp    800606 <getint+0xb3>
  8005ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005f7:	48 89 d0             	mov    %rdx,%rax
  8005fa:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800606:	48 8b 00             	mov    (%rax),%rax
  800609:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80060d:	eb 4e                	jmp    80065d <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	83 f8 30             	cmp    $0x30,%eax
  800618:	73 24                	jae    80063e <getint+0xeb>
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
  80063c:	eb 17                	jmp    800655 <getint+0x102>
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800646:	48 89 d0             	mov    %rdx,%rax
  800649:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800655:	8b 00                	mov    (%rax),%eax
  800657:	48 98                	cltq   
  800659:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80065d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	41 54                	push   %r12
  800669:	53                   	push   %rbx
  80066a:	48 83 ec 60          	sub    $0x60,%rsp
  80066e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800672:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800676:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80067e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800682:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800686:	48 8b 0a             	mov    (%rdx),%rcx
  800689:	48 89 08             	mov    %rcx,(%rax)
  80068c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800690:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800694:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800698:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069c:	eb 17                	jmp    8006b5 <vprintfmt+0x52>
			if (ch == '\0')
  80069e:	85 db                	test   %ebx,%ebx
  8006a0:	0f 84 cc 04 00 00    	je     800b72 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006a6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ae:	48 89 d6             	mov    %rdx,%rsi
  8006b1:	89 df                	mov    %ebx,%edi
  8006b3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006bd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c1:	0f b6 00             	movzbl (%rax),%eax
  8006c4:	0f b6 d8             	movzbl %al,%ebx
  8006c7:	83 fb 25             	cmp    $0x25,%ebx
  8006ca:	75 d2                	jne    80069e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006cc:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006e5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f8:	0f b6 00             	movzbl (%rax),%eax
  8006fb:	0f b6 d8             	movzbl %al,%ebx
  8006fe:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800701:	83 f8 55             	cmp    $0x55,%eax
  800704:	0f 87 34 04 00 00    	ja     800b3e <vprintfmt+0x4db>
  80070a:	89 c0                	mov    %eax,%eax
  80070c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800713:	00 
  800714:	48 b8 b0 37 80 00 00 	movabs $0x8037b0,%rax
  80071b:	00 00 00 
  80071e:	48 01 d0             	add    %rdx,%rax
  800721:	48 8b 00             	mov    (%rax),%rax
  800724:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800726:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80072a:	eb c0                	jmp    8006ec <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80072c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800730:	eb ba                	jmp    8006ec <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800732:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800739:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80073c:	89 d0                	mov    %edx,%eax
  80073e:	c1 e0 02             	shl    $0x2,%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	01 c0                	add    %eax,%eax
  800745:	01 d8                	add    %ebx,%eax
  800747:	83 e8 30             	sub    $0x30,%eax
  80074a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80074d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800751:	0f b6 00             	movzbl (%rax),%eax
  800754:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800757:	83 fb 2f             	cmp    $0x2f,%ebx
  80075a:	7e 0c                	jle    800768 <vprintfmt+0x105>
  80075c:	83 fb 39             	cmp    $0x39,%ebx
  80075f:	7f 07                	jg     800768 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800761:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800766:	eb d1                	jmp    800739 <vprintfmt+0xd6>
			goto process_precision;
  800768:	eb 58                	jmp    8007c2 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80076a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076d:	83 f8 30             	cmp    $0x30,%eax
  800770:	73 17                	jae    800789 <vprintfmt+0x126>
  800772:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800776:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800779:	89 c0                	mov    %eax,%eax
  80077b:	48 01 d0             	add    %rdx,%rax
  80077e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800781:	83 c2 08             	add    $0x8,%edx
  800784:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800787:	eb 0f                	jmp    800798 <vprintfmt+0x135>
  800789:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80078d:	48 89 d0             	mov    %rdx,%rax
  800790:	48 83 c2 08          	add    $0x8,%rdx
  800794:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80079d:	eb 23                	jmp    8007c2 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80079f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a3:	79 0c                	jns    8007b1 <vprintfmt+0x14e>
				width = 0;
  8007a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ac:	e9 3b ff ff ff       	jmpq   8006ec <vprintfmt+0x89>
  8007b1:	e9 36 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007b6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007bd:	e9 2a ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c6:	79 12                	jns    8007da <vprintfmt+0x177>
				width = precision, precision = -1;
  8007c8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007cb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007d5:	e9 12 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>
  8007da:	e9 0d ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007df:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007e3:	e9 04 ff ff ff       	jmpq   8006ec <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 17                	jae    800807 <vprintfmt+0x1a4>
  8007f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ff:	83 c2 08             	add    $0x8,%edx
  800802:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800805:	eb 0f                	jmp    800816 <vprintfmt+0x1b3>
  800807:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80080b:	48 89 d0             	mov    %rdx,%rax
  80080e:	48 83 c2 08          	add    $0x8,%rdx
  800812:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800816:	8b 10                	mov    (%rax),%edx
  800818:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80081c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800820:	48 89 ce             	mov    %rcx,%rsi
  800823:	89 d7                	mov    %edx,%edi
  800825:	ff d0                	callq  *%rax
			break;
  800827:	e9 40 03 00 00       	jmpq   800b6c <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80082c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082f:	83 f8 30             	cmp    $0x30,%eax
  800832:	73 17                	jae    80084b <vprintfmt+0x1e8>
  800834:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800838:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083b:	89 c0                	mov    %eax,%eax
  80083d:	48 01 d0             	add    %rdx,%rax
  800840:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800843:	83 c2 08             	add    $0x8,%edx
  800846:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800849:	eb 0f                	jmp    80085a <vprintfmt+0x1f7>
  80084b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084f:	48 89 d0             	mov    %rdx,%rax
  800852:	48 83 c2 08          	add    $0x8,%rdx
  800856:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80085c:	85 db                	test   %ebx,%ebx
  80085e:	79 02                	jns    800862 <vprintfmt+0x1ff>
				err = -err;
  800860:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800862:	83 fb 10             	cmp    $0x10,%ebx
  800865:	7f 16                	jg     80087d <vprintfmt+0x21a>
  800867:	48 b8 00 37 80 00 00 	movabs $0x803700,%rax
  80086e:	00 00 00 
  800871:	48 63 d3             	movslq %ebx,%rdx
  800874:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800878:	4d 85 e4             	test   %r12,%r12
  80087b:	75 2e                	jne    8008ab <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80087d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800885:	89 d9                	mov    %ebx,%ecx
  800887:	48 ba 99 37 80 00 00 	movabs $0x803799,%rdx
  80088e:	00 00 00 
  800891:	48 89 c7             	mov    %rax,%rdi
  800894:	b8 00 00 00 00       	mov    $0x0,%eax
  800899:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  8008a0:	00 00 00 
  8008a3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a6:	e9 c1 02 00 00       	jmpq   800b6c <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ab:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b3:	4c 89 e1             	mov    %r12,%rcx
  8008b6:	48 ba a2 37 80 00 00 	movabs $0x8037a2,%rdx
  8008bd:	00 00 00 
  8008c0:	48 89 c7             	mov    %rax,%rdi
  8008c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c8:	49 b8 7b 0b 80 00 00 	movabs $0x800b7b,%r8
  8008cf:	00 00 00 
  8008d2:	41 ff d0             	callq  *%r8
			break;
  8008d5:	e9 92 02 00 00       	jmpq   800b6c <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dd:	83 f8 30             	cmp    $0x30,%eax
  8008e0:	73 17                	jae    8008f9 <vprintfmt+0x296>
  8008e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e9:	89 c0                	mov    %eax,%eax
  8008eb:	48 01 d0             	add    %rdx,%rax
  8008ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f1:	83 c2 08             	add    $0x8,%edx
  8008f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f7:	eb 0f                	jmp    800908 <vprintfmt+0x2a5>
  8008f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fd:	48 89 d0             	mov    %rdx,%rax
  800900:	48 83 c2 08          	add    $0x8,%rdx
  800904:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800908:	4c 8b 20             	mov    (%rax),%r12
  80090b:	4d 85 e4             	test   %r12,%r12
  80090e:	75 0a                	jne    80091a <vprintfmt+0x2b7>
				p = "(null)";
  800910:	49 bc a5 37 80 00 00 	movabs $0x8037a5,%r12
  800917:	00 00 00 
			if (width > 0 && padc != '-')
  80091a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091e:	7e 3f                	jle    80095f <vprintfmt+0x2fc>
  800920:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800924:	74 39                	je     80095f <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800926:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800929:	48 98                	cltq   
  80092b:	48 89 c6             	mov    %rax,%rsi
  80092e:	4c 89 e7             	mov    %r12,%rdi
  800931:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  800938:	00 00 00 
  80093b:	ff d0                	callq  *%rax
  80093d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800940:	eb 17                	jmp    800959 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800942:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800946:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80094a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094e:	48 89 ce             	mov    %rcx,%rsi
  800951:	89 d7                	mov    %edx,%edi
  800953:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800959:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095d:	7f e3                	jg     800942 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095f:	eb 37                	jmp    800998 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800961:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800965:	74 1e                	je     800985 <vprintfmt+0x322>
  800967:	83 fb 1f             	cmp    $0x1f,%ebx
  80096a:	7e 05                	jle    800971 <vprintfmt+0x30e>
  80096c:	83 fb 7e             	cmp    $0x7e,%ebx
  80096f:	7e 14                	jle    800985 <vprintfmt+0x322>
					putch('?', putdat);
  800971:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800975:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800979:	48 89 d6             	mov    %rdx,%rsi
  80097c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800981:	ff d0                	callq  *%rax
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	89 df                	mov    %ebx,%edi
  800992:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800994:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800998:	4c 89 e0             	mov    %r12,%rax
  80099b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80099f:	0f b6 00             	movzbl (%rax),%eax
  8009a2:	0f be d8             	movsbl %al,%ebx
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	74 10                	je     8009b9 <vprintfmt+0x356>
  8009a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ad:	78 b2                	js     800961 <vprintfmt+0x2fe>
  8009af:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b7:	79 a8                	jns    800961 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b9:	eb 16                	jmp    8009d1 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c3:	48 89 d6             	mov    %rdx,%rsi
  8009c6:	bf 20 00 00 00       	mov    $0x20,%edi
  8009cb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009cd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d5:	7f e4                	jg     8009bb <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009d7:	e9 90 01 00 00       	jmpq   800b6c <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009dc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e0:	be 03 00 00 00       	mov    $0x3,%esi
  8009e5:	48 89 c7             	mov    %rax,%rdi
  8009e8:	48 b8 53 05 80 00 00 	movabs $0x800553,%rax
  8009ef:	00 00 00 
  8009f2:	ff d0                	callq  *%rax
  8009f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	48 85 c0             	test   %rax,%rax
  8009ff:	79 1d                	jns    800a1e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a11:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 f7 d8             	neg    %rax
  800a1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a25:	e9 d5 00 00 00       	jmpq   800aff <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a2e:	be 03 00 00 00       	mov    $0x3,%esi
  800a33:	48 89 c7             	mov    %rax,%rdi
  800a36:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  800a3d:	00 00 00 
  800a40:	ff d0                	callq  *%rax
  800a42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a46:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4d:	e9 ad 00 00 00       	jmpq   800aff <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a52:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a59:	89 d6                	mov    %edx,%esi
  800a5b:	48 89 c7             	mov    %rax,%rdi
  800a5e:	48 b8 53 05 80 00 00 	movabs $0x800553,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	callq  *%rax
  800a6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a6e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a75:	e9 85 00 00 00       	jmpq   800aff <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800a7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a82:	48 89 d6             	mov    %rdx,%rsi
  800a85:	bf 30 00 00 00       	mov    $0x30,%edi
  800a8a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a94:	48 89 d6             	mov    %rdx,%rsi
  800a97:	bf 78 00 00 00       	mov    $0x78,%edi
  800a9c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa1:	83 f8 30             	cmp    $0x30,%eax
  800aa4:	73 17                	jae    800abd <vprintfmt+0x45a>
  800aa6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aaa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aad:	89 c0                	mov    %eax,%eax
  800aaf:	48 01 d0             	add    %rdx,%rax
  800ab2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab5:	83 c2 08             	add    $0x8,%edx
  800ab8:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abb:	eb 0f                	jmp    800acc <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800abd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac1:	48 89 d0             	mov    %rdx,%rax
  800ac4:	48 83 c2 08          	add    $0x8,%rdx
  800ac8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800acc:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ad3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ada:	eb 23                	jmp    800aff <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800adc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae0:	be 03 00 00 00       	mov    $0x3,%esi
  800ae5:	48 89 c7             	mov    %rax,%rdi
  800ae8:	48 b8 43 04 80 00 00 	movabs $0x800443,%rax
  800aef:	00 00 00 
  800af2:	ff d0                	callq  *%rax
  800af4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800af8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aff:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b04:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b07:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b16:	45 89 c1             	mov    %r8d,%r9d
  800b19:	41 89 f8             	mov    %edi,%r8d
  800b1c:	48 89 c7             	mov    %rax,%rdi
  800b1f:	48 b8 88 03 80 00 00 	movabs $0x800388,%rax
  800b26:	00 00 00 
  800b29:	ff d0                	callq  *%rax
			break;
  800b2b:	eb 3f                	jmp    800b6c <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	89 df                	mov    %ebx,%edi
  800b3a:	ff d0                	callq  *%rax
			break;
  800b3c:	eb 2e                	jmp    800b6c <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b46:	48 89 d6             	mov    %rdx,%rsi
  800b49:	bf 25 00 00 00       	mov    $0x25,%edi
  800b4e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b55:	eb 05                	jmp    800b5c <vprintfmt+0x4f9>
  800b57:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b5c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b60:	48 83 e8 01          	sub    $0x1,%rax
  800b64:	0f b6 00             	movzbl (%rax),%eax
  800b67:	3c 25                	cmp    $0x25,%al
  800b69:	75 ec                	jne    800b57 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b6b:	90                   	nop
		}
	}
  800b6c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b6d:	e9 43 fb ff ff       	jmpq   8006b5 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800b72:	48 83 c4 60          	add    $0x60,%rsp
  800b76:	5b                   	pop    %rbx
  800b77:	41 5c                	pop    %r12
  800b79:	5d                   	pop    %rbp
  800b7a:	c3                   	retq   

0000000000800b7b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7b:	55                   	push   %rbp
  800b7c:	48 89 e5             	mov    %rsp,%rbp
  800b7f:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b86:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b8d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b94:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b9b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ba9:	84 c0                	test   %al,%al
  800bab:	74 20                	je     800bcd <printfmt+0x52>
  800bad:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bb5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bb9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bbd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bc5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bc9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bcd:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bd4:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bdb:	00 00 00 
  800bde:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800be5:	00 00 00 
  800be8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bec:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bf3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bfa:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c01:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c08:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c0f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c16:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c1d:	48 89 c7             	mov    %rax,%rdi
  800c20:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  800c27:	00 00 00 
  800c2a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c2c:	c9                   	leaveq 
  800c2d:	c3                   	retq   

0000000000800c2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2e:	55                   	push   %rbp
  800c2f:	48 89 e5             	mov    %rsp,%rbp
  800c32:	48 83 ec 10          	sub    $0x10,%rsp
  800c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c41:	8b 40 10             	mov    0x10(%rax),%eax
  800c44:	8d 50 01             	lea    0x1(%rax),%edx
  800c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c52:	48 8b 10             	mov    (%rax),%rdx
  800c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c59:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c5d:	48 39 c2             	cmp    %rax,%rdx
  800c60:	73 17                	jae    800c79 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c66:	48 8b 00             	mov    (%rax),%rax
  800c69:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c71:	48 89 0a             	mov    %rcx,(%rdx)
  800c74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c77:	88 10                	mov    %dl,(%rax)
}
  800c79:	c9                   	leaveq 
  800c7a:	c3                   	retq   

0000000000800c7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c7b:	55                   	push   %rbp
  800c7c:	48 89 e5             	mov    %rsp,%rbp
  800c7f:	48 83 ec 50          	sub    $0x50,%rsp
  800c83:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c87:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c8a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c8e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c92:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c96:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c9a:	48 8b 0a             	mov    (%rdx),%rcx
  800c9d:	48 89 08             	mov    %rcx,(%rax)
  800ca0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cb8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cbb:	48 98                	cltq   
  800cbd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cc1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cc5:	48 01 d0             	add    %rdx,%rax
  800cc8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ccc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cd3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cd8:	74 06                	je     800ce0 <vsnprintf+0x65>
  800cda:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cde:	7f 07                	jg     800ce7 <vsnprintf+0x6c>
		return -E_INVAL;
  800ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce5:	eb 2f                	jmp    800d16 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ce7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ceb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cf3:	48 89 c6             	mov    %rax,%rsi
  800cf6:	48 bf 2e 0c 80 00 00 	movabs $0x800c2e,%rdi
  800cfd:	00 00 00 
  800d00:	48 b8 63 06 80 00 00 	movabs $0x800663,%rax
  800d07:	00 00 00 
  800d0a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d10:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d13:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d16:	c9                   	leaveq 
  800d17:	c3                   	retq   

0000000000800d18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d18:	55                   	push   %rbp
  800d19:	48 89 e5             	mov    %rsp,%rbp
  800d1c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d23:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d2a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d30:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d37:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d3e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d45:	84 c0                	test   %al,%al
  800d47:	74 20                	je     800d69 <snprintf+0x51>
  800d49:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d51:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d55:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d59:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d61:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d65:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d69:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d70:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d77:	00 00 00 
  800d7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d81:	00 00 00 
  800d84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d9d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dab:	48 8b 0a             	mov    (%rdx),%rcx
  800dae:	48 89 08             	mov    %rcx,(%rax)
  800db1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dbd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dc1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dc8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dcf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dd5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	48 b8 7b 0c 80 00 00 	movabs $0x800c7b,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800df1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df7:	c9                   	leaveq 
  800df8:	c3                   	retq   

0000000000800df9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800df9:	55                   	push   %rbp
  800dfa:	48 89 e5             	mov    %rsp,%rbp
  800dfd:	48 83 ec 18          	sub    $0x18,%rsp
  800e01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e0c:	eb 09                	jmp    800e17 <strlen+0x1e>
		n++;
  800e0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	0f b6 00             	movzbl (%rax),%eax
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 ec                	jne    800e0e <strlen+0x15>
		n++;
	return n;
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 20          	sub    $0x20,%rsp
  800e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e3e:	eb 0e                	jmp    800e4e <strnlen+0x27>
		n++;
  800e40:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e44:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e49:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e4e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e53:	74 0b                	je     800e60 <strnlen+0x39>
  800e55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e59:	0f b6 00             	movzbl (%rax),%eax
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 e0                	jne    800e40 <strnlen+0x19>
		n++;
	return n;
  800e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e63:	c9                   	leaveq 
  800e64:	c3                   	retq   

0000000000800e65 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e65:	55                   	push   %rbp
  800e66:	48 89 e5             	mov    %rsp,%rbp
  800e69:	48 83 ec 20          	sub    $0x20,%rsp
  800e6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e7d:	90                   	nop
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e86:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e8a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e8e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e92:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e96:	0f b6 12             	movzbl (%rdx),%edx
  800e99:	88 10                	mov    %dl,(%rax)
  800e9b:	0f b6 00             	movzbl (%rax),%eax
  800e9e:	84 c0                	test   %al,%al
  800ea0:	75 dc                	jne    800e7e <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ea6:	c9                   	leaveq 
  800ea7:	c3                   	retq   

0000000000800ea8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ea8:	55                   	push   %rbp
  800ea9:	48 89 e5             	mov    %rsp,%rbp
  800eac:	48 83 ec 20          	sub    $0x20,%rsp
  800eb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	48 89 c7             	mov    %rax,%rdi
  800ebf:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  800ec6:	00 00 00 
  800ec9:	ff d0                	callq  *%rax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ece:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed1:	48 63 d0             	movslq %eax,%rdx
  800ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed8:	48 01 c2             	add    %rax,%rdx
  800edb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800edf:	48 89 c6             	mov    %rax,%rsi
  800ee2:	48 89 d7             	mov    %rdx,%rdi
  800ee5:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  800eec:	00 00 00 
  800eef:	ff d0                	callq  *%rax
	return dst;
  800ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ef5:	c9                   	leaveq 
  800ef6:	c3                   	retq   

0000000000800ef7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ef7:	55                   	push   %rbp
  800ef8:	48 89 e5             	mov    %rsp,%rbp
  800efb:	48 83 ec 28          	sub    $0x28,%rsp
  800eff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f03:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f07:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f13:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f1a:	00 
  800f1b:	eb 2a                	jmp    800f47 <strncpy+0x50>
		*dst++ = *src;
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f29:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2d:	0f b6 12             	movzbl (%rdx),%edx
  800f30:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f36:	0f b6 00             	movzbl (%rax),%eax
  800f39:	84 c0                	test   %al,%al
  800f3b:	74 05                	je     800f42 <strncpy+0x4b>
			src++;
  800f3d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f42:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f4b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f4f:	72 cc                	jb     800f1d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f55:	c9                   	leaveq 
  800f56:	c3                   	retq   

0000000000800f57 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f57:	55                   	push   %rbp
  800f58:	48 89 e5             	mov    %rsp,%rbp
  800f5b:	48 83 ec 28          	sub    $0x28,%rsp
  800f5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f73:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f78:	74 3d                	je     800fb7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f7a:	eb 1d                	jmp    800f99 <strlcpy+0x42>
			*dst++ = *src++;
  800f7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f84:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f88:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f8c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f90:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f94:	0f b6 12             	movzbl (%rdx),%edx
  800f97:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f99:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f9e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa3:	74 0b                	je     800fb0 <strlcpy+0x59>
  800fa5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa9:	0f b6 00             	movzbl (%rax),%eax
  800fac:	84 c0                	test   %al,%al
  800fae:	75 cc                	jne    800f7c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbf:	48 29 c2             	sub    %rax,%rdx
  800fc2:	48 89 d0             	mov    %rdx,%rax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 10          	sub    $0x10,%rsp
  800fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fd7:	eb 0a                	jmp    800fe3 <strcmp+0x1c>
		p++, q++;
  800fd9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fde:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fe3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe7:	0f b6 00             	movzbl (%rax),%eax
  800fea:	84 c0                	test   %al,%al
  800fec:	74 12                	je     801000 <strcmp+0x39>
  800fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff2:	0f b6 10             	movzbl (%rax),%edx
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	0f b6 00             	movzbl (%rax),%eax
  800ffc:	38 c2                	cmp    %al,%dl
  800ffe:	74 d9                	je     800fd9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801004:	0f b6 00             	movzbl (%rax),%eax
  801007:	0f b6 d0             	movzbl %al,%edx
  80100a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	0f b6 c0             	movzbl %al,%eax
  801014:	29 c2                	sub    %eax,%edx
  801016:	89 d0                	mov    %edx,%eax
}
  801018:	c9                   	leaveq 
  801019:	c3                   	retq   

000000000080101a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80101a:	55                   	push   %rbp
  80101b:	48 89 e5             	mov    %rsp,%rbp
  80101e:	48 83 ec 18          	sub    $0x18,%rsp
  801022:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801026:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80102a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80102e:	eb 0f                	jmp    80103f <strncmp+0x25>
		n--, p++, q++;
  801030:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801035:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80103a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80103f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801044:	74 1d                	je     801063 <strncmp+0x49>
  801046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	74 12                	je     801063 <strncmp+0x49>
  801051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801055:	0f b6 10             	movzbl (%rax),%edx
  801058:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105c:	0f b6 00             	movzbl (%rax),%eax
  80105f:	38 c2                	cmp    %al,%dl
  801061:	74 cd                	je     801030 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801063:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801068:	75 07                	jne    801071 <strncmp+0x57>
		return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
  80106f:	eb 18                	jmp    801089 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801075:	0f b6 00             	movzbl (%rax),%eax
  801078:	0f b6 d0             	movzbl %al,%edx
  80107b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107f:	0f b6 00             	movzbl (%rax),%eax
  801082:	0f b6 c0             	movzbl %al,%eax
  801085:	29 c2                	sub    %eax,%edx
  801087:	89 d0                	mov    %edx,%eax
}
  801089:	c9                   	leaveq 
  80108a:	c3                   	retq   

000000000080108b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80108b:	55                   	push   %rbp
  80108c:	48 89 e5             	mov    %rsp,%rbp
  80108f:	48 83 ec 0c          	sub    $0xc,%rsp
  801093:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801097:	89 f0                	mov    %esi,%eax
  801099:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109c:	eb 17                	jmp    8010b5 <strchr+0x2a>
		if (*s == c)
  80109e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a8:	75 06                	jne    8010b0 <strchr+0x25>
			return (char *) s;
  8010aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ae:	eb 15                	jmp    8010c5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 de                	jne    80109e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 0c          	sub    $0xc,%rsp
  8010cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d3:	89 f0                	mov    %esi,%eax
  8010d5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010d8:	eb 13                	jmp    8010ed <strfind+0x26>
		if (*s == c)
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	0f b6 00             	movzbl (%rax),%eax
  8010e1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e4:	75 02                	jne    8010e8 <strfind+0x21>
			break;
  8010e6:	eb 10                	jmp    8010f8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f1:	0f b6 00             	movzbl (%rax),%eax
  8010f4:	84 c0                	test   %al,%al
  8010f6:	75 e2                	jne    8010da <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 18          	sub    $0x18,%rsp
  801106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80110d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801111:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801116:	75 06                	jne    80111e <memset+0x20>
		return v;
  801118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111c:	eb 69                	jmp    801187 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	83 e0 03             	and    $0x3,%eax
  801125:	48 85 c0             	test   %rax,%rax
  801128:	75 48                	jne    801172 <memset+0x74>
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112e:	83 e0 03             	and    $0x3,%eax
  801131:	48 85 c0             	test   %rax,%rax
  801134:	75 3c                	jne    801172 <memset+0x74>
		c &= 0xFF;
  801136:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801140:	c1 e0 18             	shl    $0x18,%eax
  801143:	89 c2                	mov    %eax,%edx
  801145:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801148:	c1 e0 10             	shl    $0x10,%eax
  80114b:	09 c2                	or     %eax,%edx
  80114d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801150:	c1 e0 08             	shl    $0x8,%eax
  801153:	09 d0                	or     %edx,%eax
  801155:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	48 c1 e8 02          	shr    $0x2,%rax
  801160:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801163:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801167:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80116a:	48 89 d7             	mov    %rdx,%rdi
  80116d:	fc                   	cld    
  80116e:	f3 ab                	rep stos %eax,%es:(%rdi)
  801170:	eb 11                	jmp    801183 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801172:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801179:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80117d:	48 89 d7             	mov    %rdx,%rdi
  801180:	fc                   	cld    
  801181:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801187:	c9                   	leaveq 
  801188:	c3                   	retq   

0000000000801189 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801189:	55                   	push   %rbp
  80118a:	48 89 e5             	mov    %rsp,%rbp
  80118d:	48 83 ec 28          	sub    $0x28,%rsp
  801191:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801195:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801199:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80119d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011b5:	0f 83 88 00 00 00    	jae    801243 <memmove+0xba>
  8011bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c3:	48 01 d0             	add    %rdx,%rax
  8011c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011ca:	76 77                	jbe    801243 <memmove+0xba>
		s += n;
  8011cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d0:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d8:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	83 e0 03             	and    $0x3,%eax
  8011e3:	48 85 c0             	test   %rax,%rax
  8011e6:	75 3b                	jne    801223 <memmove+0x9a>
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ec:	83 e0 03             	and    $0x3,%eax
  8011ef:	48 85 c0             	test   %rax,%rax
  8011f2:	75 2f                	jne    801223 <memmove+0x9a>
  8011f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f8:	83 e0 03             	and    $0x3,%eax
  8011fb:	48 85 c0             	test   %rax,%rax
  8011fe:	75 23                	jne    801223 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801204:	48 83 e8 04          	sub    $0x4,%rax
  801208:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80120c:	48 83 ea 04          	sub    $0x4,%rdx
  801210:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801214:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801218:	48 89 c7             	mov    %rax,%rdi
  80121b:	48 89 d6             	mov    %rdx,%rsi
  80121e:	fd                   	std    
  80121f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801221:	eb 1d                	jmp    801240 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801227:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801237:	48 89 d7             	mov    %rdx,%rdi
  80123a:	48 89 c1             	mov    %rax,%rcx
  80123d:	fd                   	std    
  80123e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801240:	fc                   	cld    
  801241:	eb 57                	jmp    80129a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	83 e0 03             	and    $0x3,%eax
  80124a:	48 85 c0             	test   %rax,%rax
  80124d:	75 36                	jne    801285 <memmove+0xfc>
  80124f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801253:	83 e0 03             	and    $0x3,%eax
  801256:	48 85 c0             	test   %rax,%rax
  801259:	75 2a                	jne    801285 <memmove+0xfc>
  80125b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125f:	83 e0 03             	and    $0x3,%eax
  801262:	48 85 c0             	test   %rax,%rax
  801265:	75 1e                	jne    801285 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801267:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126b:	48 c1 e8 02          	shr    $0x2,%rax
  80126f:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801276:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127a:	48 89 c7             	mov    %rax,%rdi
  80127d:	48 89 d6             	mov    %rdx,%rsi
  801280:	fc                   	cld    
  801281:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801283:	eb 15                	jmp    80129a <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801285:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801289:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801291:	48 89 c7             	mov    %rax,%rdi
  801294:	48 89 d6             	mov    %rdx,%rsi
  801297:	fc                   	cld    
  801298:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 18          	sub    $0x18,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	48 89 ce             	mov    %rcx,%rsi
  8012c3:	48 89 c7             	mov    %rax,%rdi
  8012c6:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8012cd:	00 00 00 
  8012d0:	ff d0                	callq  *%rax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 28          	sub    $0x28,%rsp
  8012dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012f8:	eb 36                	jmp    801330 <memcmp+0x5c>
		if (*s1 != *s2)
  8012fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fe:	0f b6 10             	movzbl (%rax),%edx
  801301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	38 c2                	cmp    %al,%dl
  80130a:	74 1a                	je     801326 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801310:	0f b6 00             	movzbl (%rax),%eax
  801313:	0f b6 d0             	movzbl %al,%edx
  801316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	0f b6 c0             	movzbl %al,%eax
  801320:	29 c2                	sub    %eax,%edx
  801322:	89 d0                	mov    %edx,%eax
  801324:	eb 20                	jmp    801346 <memcmp+0x72>
		s1++, s2++;
  801326:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801334:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801338:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80133c:	48 85 c0             	test   %rax,%rax
  80133f:	75 b9                	jne    8012fa <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801346:	c9                   	leaveq 
  801347:	c3                   	retq   

0000000000801348 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	48 83 ec 28          	sub    $0x28,%rsp
  801350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801354:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801357:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80135b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801363:	48 01 d0             	add    %rdx,%rax
  801366:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80136a:	eb 15                	jmp    801381 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80136c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801370:	0f b6 10             	movzbl (%rax),%edx
  801373:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801376:	38 c2                	cmp    %al,%dl
  801378:	75 02                	jne    80137c <memfind+0x34>
			break;
  80137a:	eb 0f                	jmp    80138b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80137c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801389:	72 e1                	jb     80136c <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80138b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80138f:	c9                   	leaveq 
  801390:	c3                   	retq   

0000000000801391 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	48 83 ec 34          	sub    $0x34,%rsp
  801399:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80139d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013a1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ab:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013b2:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b3:	eb 05                	jmp    8013ba <strtol+0x29>
		s++;
  8013b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	3c 20                	cmp    $0x20,%al
  8013c3:	74 f0                	je     8013b5 <strtol+0x24>
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	3c 09                	cmp    $0x9,%al
  8013ce:	74 e5                	je     8013b5 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	3c 2b                	cmp    $0x2b,%al
  8013d9:	75 07                	jne    8013e2 <strtol+0x51>
		s++;
  8013db:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e0:	eb 17                	jmp    8013f9 <strtol+0x68>
	else if (*s == '-')
  8013e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	3c 2d                	cmp    $0x2d,%al
  8013eb:	75 0c                	jne    8013f9 <strtol+0x68>
		s++, neg = 1;
  8013ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013fd:	74 06                	je     801405 <strtol+0x74>
  8013ff:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801403:	75 28                	jne    80142d <strtol+0x9c>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3c 30                	cmp    $0x30,%al
  80140e:	75 1d                	jne    80142d <strtol+0x9c>
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 83 c0 01          	add    $0x1,%rax
  801418:	0f b6 00             	movzbl (%rax),%eax
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0e                	jne    80142d <strtol+0x9c>
		s += 2, base = 16;
  80141f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801424:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80142b:	eb 2c                	jmp    801459 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80142d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801431:	75 19                	jne    80144c <strtol+0xbb>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 30                	cmp    $0x30,%al
  80143c:	75 0e                	jne    80144c <strtol+0xbb>
		s++, base = 8;
  80143e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801443:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80144a:	eb 0d                	jmp    801459 <strtol+0xc8>
	else if (base == 0)
  80144c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801450:	75 07                	jne    801459 <strtol+0xc8>
		base = 10;
  801452:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 2f                	cmp    $0x2f,%al
  801462:	7e 1d                	jle    801481 <strtol+0xf0>
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 39                	cmp    $0x39,%al
  80146d:	7f 12                	jg     801481 <strtol+0xf0>
			dig = *s - '0';
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	0f be c0             	movsbl %al,%eax
  801479:	83 e8 30             	sub    $0x30,%eax
  80147c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80147f:	eb 4e                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 60                	cmp    $0x60,%al
  80148a:	7e 1d                	jle    8014a9 <strtol+0x118>
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 7a                	cmp    $0x7a,%al
  801495:	7f 12                	jg     8014a9 <strtol+0x118>
			dig = *s - 'a' + 10;
  801497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	0f be c0             	movsbl %al,%eax
  8014a1:	83 e8 57             	sub    $0x57,%eax
  8014a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a7:	eb 26                	jmp    8014cf <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 40                	cmp    $0x40,%al
  8014b2:	7e 48                	jle    8014fc <strtol+0x16b>
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	3c 5a                	cmp    $0x5a,%al
  8014bd:	7f 3d                	jg     8014fc <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c3:	0f b6 00             	movzbl (%rax),%eax
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	83 e8 37             	sub    $0x37,%eax
  8014cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014d5:	7c 02                	jl     8014d9 <strtol+0x148>
			break;
  8014d7:	eb 23                	jmp    8014fc <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014de:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014e1:	48 98                	cltq   
  8014e3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014e8:	48 89 c2             	mov    %rax,%rdx
  8014eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ee:	48 98                	cltq   
  8014f0:	48 01 d0             	add    %rdx,%rax
  8014f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014f7:	e9 5d ff ff ff       	jmpq   801459 <strtol+0xc8>

	if (endptr)
  8014fc:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801501:	74 0b                	je     80150e <strtol+0x17d>
		*endptr = (char *) s;
  801503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801507:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80150b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80150e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801512:	74 09                	je     80151d <strtol+0x18c>
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	48 f7 d8             	neg    %rax
  80151b:	eb 04                	jmp    801521 <strtol+0x190>
  80151d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801521:	c9                   	leaveq 
  801522:	c3                   	retq   

0000000000801523 <strstr>:

char * strstr(const char *in, const char *str)
{
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	48 83 ec 30          	sub    $0x30,%rsp
  80152b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801537:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80153f:	0f b6 00             	movzbl (%rax),%eax
  801542:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801545:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801549:	75 06                	jne    801551 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	eb 6b                	jmp    8015bc <strstr+0x99>

    len = strlen(str);
  801551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801555:	48 89 c7             	mov    %rax,%rdi
  801558:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  80155f:	00 00 00 
  801562:	ff d0                	callq  *%rax
  801564:	48 98                	cltq   
  801566:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801572:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801576:	0f b6 00             	movzbl (%rax),%eax
  801579:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80157c:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801580:	75 07                	jne    801589 <strstr+0x66>
                return (char *) 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
  801587:	eb 33                	jmp    8015bc <strstr+0x99>
        } while (sc != c);
  801589:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80158d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801590:	75 d8                	jne    80156a <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801592:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801596:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	48 89 ce             	mov    %rcx,%rsi
  8015a1:	48 89 c7             	mov    %rax,%rdi
  8015a4:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  8015ab:	00 00 00 
  8015ae:	ff d0                	callq  *%rax
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	75 b6                	jne    80156a <strstr+0x47>

    return (char *) (in - 1);
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	48 83 e8 01          	sub    $0x1,%rax
}
  8015bc:	c9                   	leaveq 
  8015bd:	c3                   	retq   

00000000008015be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015be:	55                   	push   %rbp
  8015bf:	48 89 e5             	mov    %rsp,%rbp
  8015c2:	53                   	push   %rbx
  8015c3:	48 83 ec 48          	sub    $0x48,%rsp
  8015c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015ca:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015d1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015d5:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015d9:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015e4:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015e8:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015ec:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015f0:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015f4:	4c 89 c3             	mov    %r8,%rbx
  8015f7:	cd 30                	int    $0x30
  8015f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801601:	74 3e                	je     801641 <syscall+0x83>
  801603:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801608:	7e 37                	jle    801641 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80160a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80160e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801611:	49 89 d0             	mov    %rdx,%r8
  801614:	89 c1                	mov    %eax,%ecx
  801616:	48 ba 60 3a 80 00 00 	movabs $0x803a60,%rdx
  80161d:	00 00 00 
  801620:	be 23 00 00 00       	mov    $0x23,%esi
  801625:	48 bf 7d 3a 80 00 00 	movabs $0x803a7d,%rdi
  80162c:	00 00 00 
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	49 b9 e6 31 80 00 00 	movabs $0x8031e6,%r9
  80163b:	00 00 00 
  80163e:	41 ff d1             	callq  *%r9

	return ret;
  801641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801645:	48 83 c4 48          	add    $0x48,%rsp
  801649:	5b                   	pop    %rbx
  80164a:	5d                   	pop    %rbp
  80164b:	c3                   	retq   

000000000080164c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80164c:	55                   	push   %rbp
  80164d:	48 89 e5             	mov    %rsp,%rbp
  801650:	48 83 ec 20          	sub    $0x20,%rsp
  801654:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801658:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80165c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801660:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801664:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80166b:	00 
  80166c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801672:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801678:	48 89 d1             	mov    %rdx,%rcx
  80167b:	48 89 c2             	mov    %rax,%rdx
  80167e:	be 00 00 00 00       	mov    $0x0,%esi
  801683:	bf 00 00 00 00       	mov    $0x0,%edi
  801688:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <sys_cgetc>:

int
sys_cgetc(void)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80169e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a5:	00 
  8016a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	be 00 00 00 00       	mov    $0x0,%esi
  8016c1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016c6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8016cd:	00 00 00 
  8016d0:	ff d0                	callq  *%rax
}
  8016d2:	c9                   	leaveq 
  8016d3:	c3                   	retq   

00000000008016d4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	48 83 ec 10          	sub    $0x10,%rsp
  8016dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016e2:	48 98                	cltq   
  8016e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016eb:	00 
  8016ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fd:	48 89 c2             	mov    %rax,%rdx
  801700:	be 01 00 00 00       	mov    $0x1,%esi
  801705:	bf 03 00 00 00       	mov    $0x3,%edi
  80170a:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801711:	00 00 00 
  801714:	ff d0                	callq  *%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801720:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801727:	00 
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	b9 00 00 00 00       	mov    $0x0,%ecx
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	bf 02 00 00 00       	mov    $0x2,%edi
  801748:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <sys_yield>:

void
sys_yield(void)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80175e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801765:	00 
  801766:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801772:	b9 00 00 00 00       	mov    $0x0,%ecx
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	be 00 00 00 00       	mov    $0x0,%esi
  801781:	bf 0b 00 00 00       	mov    $0xb,%edi
  801786:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  80178d:	00 00 00 
  801790:	ff d0                	callq  *%rax
}
  801792:	c9                   	leaveq 
  801793:	c3                   	retq   

0000000000801794 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801794:	55                   	push   %rbp
  801795:	48 89 e5             	mov    %rsp,%rbp
  801798:	48 83 ec 20          	sub    $0x20,%rsp
  80179c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80179f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017a9:	48 63 c8             	movslq %eax,%rcx
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b3:	48 98                	cltq   
  8017b5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bc:	00 
  8017bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c3:	49 89 c8             	mov    %rcx,%r8
  8017c6:	48 89 d1             	mov    %rdx,%rcx
  8017c9:	48 89 c2             	mov    %rax,%rdx
  8017cc:	be 01 00 00 00       	mov    $0x1,%esi
  8017d1:	bf 04 00 00 00       	mov    $0x4,%edi
  8017d6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8017dd:	00 00 00 
  8017e0:	ff d0                	callq  *%rax
}
  8017e2:	c9                   	leaveq 
  8017e3:	c3                   	retq   

00000000008017e4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017e4:	55                   	push   %rbp
  8017e5:	48 89 e5             	mov    %rsp,%rbp
  8017e8:	48 83 ec 30          	sub    $0x30,%rsp
  8017ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017f6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017fa:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017fe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801801:	48 63 c8             	movslq %eax,%rcx
  801804:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801808:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80180b:	48 63 f0             	movslq %eax,%rsi
  80180e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801815:	48 98                	cltq   
  801817:	48 89 0c 24          	mov    %rcx,(%rsp)
  80181b:	49 89 f9             	mov    %rdi,%r9
  80181e:	49 89 f0             	mov    %rsi,%r8
  801821:	48 89 d1             	mov    %rdx,%rcx
  801824:	48 89 c2             	mov    %rax,%rdx
  801827:	be 01 00 00 00       	mov    $0x1,%esi
  80182c:	bf 05 00 00 00       	mov    $0x5,%edi
  801831:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801838:	00 00 00 
  80183b:	ff d0                	callq  *%rax
}
  80183d:	c9                   	leaveq 
  80183e:	c3                   	retq   

000000000080183f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80183f:	55                   	push   %rbp
  801840:	48 89 e5             	mov    %rsp,%rbp
  801843:	48 83 ec 20          	sub    $0x20,%rsp
  801847:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80184e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801855:	48 98                	cltq   
  801857:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185e:	00 
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	48 89 d1             	mov    %rdx,%rcx
  80186e:	48 89 c2             	mov    %rax,%rdx
  801871:	be 01 00 00 00       	mov    $0x1,%esi
  801876:	bf 06 00 00 00       	mov    $0x6,%edi
  80187b:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 10          	sub    $0x10,%rsp
  801891:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801894:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801897:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80189a:	48 63 d0             	movslq %eax,%rdx
  80189d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a0:	48 98                	cltq   
  8018a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a9:	00 
  8018aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b6:	48 89 d1             	mov    %rdx,%rcx
  8018b9:	48 89 c2             	mov    %rax,%rdx
  8018bc:	be 01 00 00 00       	mov    $0x1,%esi
  8018c1:	bf 08 00 00 00       	mov    $0x8,%edi
  8018c6:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8018cd:	00 00 00 
  8018d0:	ff d0                	callq  *%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 20          	sub    $0x20,%rsp
  8018dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ea:	48 98                	cltq   
  8018ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f3:	00 
  8018f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801900:	48 89 d1             	mov    %rdx,%rcx
  801903:	48 89 c2             	mov    %rax,%rdx
  801906:	be 01 00 00 00       	mov    $0x1,%esi
  80190b:	bf 09 00 00 00       	mov    $0x9,%edi
  801910:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801917:	00 00 00 
  80191a:	ff d0                	callq  *%rax
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 20          	sub    $0x20,%rsp
  801926:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801929:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80192d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801934:	48 98                	cltq   
  801936:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193d:	00 
  80193e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801944:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194a:	48 89 d1             	mov    %rdx,%rcx
  80194d:	48 89 c2             	mov    %rax,%rdx
  801950:	be 01 00 00 00       	mov    $0x1,%esi
  801955:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195a:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 20          	sub    $0x20,%rsp
  801970:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801973:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801977:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80197b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80197e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801981:	48 63 f0             	movslq %eax,%rsi
  801984:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198b:	48 98                	cltq   
  80198d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801991:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801998:	00 
  801999:	49 89 f1             	mov    %rsi,%r9
  80199c:	49 89 c8             	mov    %rcx,%r8
  80199f:	48 89 d1             	mov    %rdx,%rcx
  8019a2:	48 89 c2             	mov    %rax,%rdx
  8019a5:	be 00 00 00 00       	mov    $0x0,%esi
  8019aa:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019af:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	callq  *%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 10          	sub    $0x10,%rsp
  8019c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d4:	00 
  8019d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e6:	48 89 c2             	mov    %rax,%rdx
  8019e9:	be 01 00 00 00       	mov    $0x1,%esi
  8019ee:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019f3:	48 b8 be 15 80 00 00 	movabs $0x8015be,%rax
  8019fa:	00 00 00 
  8019fd:	ff d0                	callq  *%rax
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 10          	sub    $0x10,%rsp
  801a09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  801a0d:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801a14:	00 00 00 
  801a17:	48 8b 00             	mov    (%rax),%rax
  801a1a:	48 85 c0             	test   %rax,%rax
  801a1d:	0f 85 84 00 00 00    	jne    801aa7 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  801a23:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801a2a:	00 00 00 
  801a2d:	48 8b 00             	mov    (%rax),%rax
  801a30:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801a36:	ba 07 00 00 00       	mov    $0x7,%edx
  801a3b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801a40:	89 c7                	mov    %eax,%edi
  801a42:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  801a49:	00 00 00 
  801a4c:	ff d0                	callq  *%rax
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	79 2a                	jns    801a7c <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  801a52:	48 ba 90 3a 80 00 00 	movabs $0x803a90,%rdx
  801a59:	00 00 00 
  801a5c:	be 23 00 00 00       	mov    $0x23,%esi
  801a61:	48 bf b7 3a 80 00 00 	movabs $0x803ab7,%rdi
  801a68:	00 00 00 
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a70:	48 b9 e6 31 80 00 00 	movabs $0x8031e6,%rcx
  801a77:	00 00 00 
  801a7a:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  801a7c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801a83:	00 00 00 
  801a86:	48 8b 00             	mov    (%rax),%rax
  801a89:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801a8f:	48 be ba 1a 80 00 00 	movabs $0x801aba,%rsi
  801a96:	00 00 00 
  801a99:	89 c7                	mov    %eax,%edi
  801a9b:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801aa2:	00 00 00 
  801aa5:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  801aa7:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801aae:	00 00 00 
  801ab1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ab5:	48 89 10             	mov    %rdx,(%rax)
}
  801ab8:	c9                   	leaveq 
  801ab9:	c3                   	retq   

0000000000801aba <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801aba:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801abd:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801ac4:	00 00 00 
	call *%rax
  801ac7:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  801ac9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801ad0:	00 
	movq 152(%rsp), %rcx  //Load RSP
  801ad1:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  801ad8:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  801ad9:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  801add:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  801ae0:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  801ae7:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  801ae8:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  801aec:	4c 8b 3c 24          	mov    (%rsp),%r15
  801af0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801af5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801afa:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801aff:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801b04:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801b09:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801b0e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801b13:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801b18:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801b1d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801b22:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801b27:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801b2c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801b31:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801b36:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  801b3a:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801b3e:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  801b3f:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801b40:	c3                   	retq   

0000000000801b41 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 08          	sub    $0x8,%rsp
  801b49:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b4d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b51:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b58:	ff ff ff 
  801b5b:	48 01 d0             	add    %rdx,%rax
  801b5e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b62:	c9                   	leaveq 
  801b63:	c3                   	retq   

0000000000801b64 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	48 83 ec 08          	sub    $0x8,%rsp
  801b6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b74:	48 89 c7             	mov    %rax,%rdi
  801b77:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
  801b83:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b89:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b8d:	c9                   	leaveq 
  801b8e:	c3                   	retq   

0000000000801b8f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	48 83 ec 18          	sub    $0x18,%rsp
  801b97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ba2:	eb 6b                	jmp    801c0f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	48 98                	cltq   
  801ba9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801baf:	48 c1 e0 0c          	shl    $0xc,%rax
  801bb3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801bb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbb:	48 c1 e8 15          	shr    $0x15,%rax
  801bbf:	48 89 c2             	mov    %rax,%rdx
  801bc2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bc9:	01 00 00 
  801bcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd0:	83 e0 01             	and    $0x1,%eax
  801bd3:	48 85 c0             	test   %rax,%rax
  801bd6:	74 21                	je     801bf9 <fd_alloc+0x6a>
  801bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bdc:	48 c1 e8 0c          	shr    $0xc,%rax
  801be0:	48 89 c2             	mov    %rax,%rdx
  801be3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bea:	01 00 00 
  801bed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf1:	83 e0 01             	and    $0x1,%eax
  801bf4:	48 85 c0             	test   %rax,%rax
  801bf7:	75 12                	jne    801c0b <fd_alloc+0x7c>
			*fd_store = fd;
  801bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c01:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb 1a                	jmp    801c25 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c0f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c13:	7e 8f                	jle    801ba4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c19:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c20:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c25:	c9                   	leaveq 
  801c26:	c3                   	retq   

0000000000801c27 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c27:	55                   	push   %rbp
  801c28:	48 89 e5             	mov    %rsp,%rbp
  801c2b:	48 83 ec 20          	sub    $0x20,%rsp
  801c2f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c36:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c3a:	78 06                	js     801c42 <fd_lookup+0x1b>
  801c3c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c40:	7e 07                	jle    801c49 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c47:	eb 6c                	jmp    801cb5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c4c:	48 98                	cltq   
  801c4e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c54:	48 c1 e0 0c          	shl    $0xc,%rax
  801c58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c60:	48 c1 e8 15          	shr    $0x15,%rax
  801c64:	48 89 c2             	mov    %rax,%rdx
  801c67:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c6e:	01 00 00 
  801c71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c75:	83 e0 01             	and    $0x1,%eax
  801c78:	48 85 c0             	test   %rax,%rax
  801c7b:	74 21                	je     801c9e <fd_lookup+0x77>
  801c7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c81:	48 c1 e8 0c          	shr    $0xc,%rax
  801c85:	48 89 c2             	mov    %rax,%rdx
  801c88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c8f:	01 00 00 
  801c92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c96:	83 e0 01             	and    $0x1,%eax
  801c99:	48 85 c0             	test   %rax,%rax
  801c9c:	75 07                	jne    801ca5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca3:	eb 10                	jmp    801cb5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ca5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ca9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cad:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 30          	sub    $0x30,%rsp
  801cbf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cc3:	89 f0                	mov    %esi,%eax
  801cc5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccc:	48 89 c7             	mov    %rax,%rdi
  801ccf:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cdf:	48 89 d6             	mov    %rdx,%rsi
  801ce2:	89 c7                	mov    %eax,%edi
  801ce4:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  801ceb:	00 00 00 
  801cee:	ff d0                	callq  *%rax
  801cf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cf7:	78 0a                	js     801d03 <fd_close+0x4c>
	    || fd != fd2)
  801cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfd:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801d01:	74 12                	je     801d15 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801d03:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801d07:	74 05                	je     801d0e <fd_close+0x57>
  801d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0c:	eb 05                	jmp    801d13 <fd_close+0x5c>
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d13:	eb 69                	jmp    801d7e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d19:	8b 00                	mov    (%rax),%eax
  801d1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d1f:	48 89 d6             	mov    %rdx,%rsi
  801d22:	89 c7                	mov    %eax,%edi
  801d24:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
  801d30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d37:	78 2a                	js     801d63 <fd_close+0xac>
		if (dev->dev_close)
  801d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d41:	48 85 c0             	test   %rax,%rax
  801d44:	74 16                	je     801d5c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4a:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d52:	48 89 d7             	mov    %rdx,%rdi
  801d55:	ff d0                	callq  *%rax
  801d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d5a:	eb 07                	jmp    801d63 <fd_close+0xac>
		else
			r = 0;
  801d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d67:	48 89 c6             	mov    %rax,%rsi
  801d6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d6f:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  801d76:	00 00 00 
  801d79:	ff d0                	callq  *%rax
	return r;
  801d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 20          	sub    $0x20,%rsp
  801d88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d96:	eb 41                	jmp    801dd9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d98:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d9f:	00 00 00 
  801da2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801da5:	48 63 d2             	movslq %edx,%rdx
  801da8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dac:	8b 00                	mov    (%rax),%eax
  801dae:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801db1:	75 22                	jne    801dd5 <dev_lookup+0x55>
			*dev = devtab[i];
  801db3:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801dba:	00 00 00 
  801dbd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dc0:	48 63 d2             	movslq %edx,%rdx
  801dc3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801dc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dcb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	eb 60                	jmp    801e35 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801dd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dd9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801de0:	00 00 00 
  801de3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801de6:	48 63 d2             	movslq %edx,%rdx
  801de9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ded:	48 85 c0             	test   %rax,%rax
  801df0:	75 a6                	jne    801d98 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801df2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801df9:	00 00 00 
  801dfc:	48 8b 00             	mov    (%rax),%rax
  801dff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801e05:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e08:	89 c6                	mov    %eax,%esi
  801e0a:	48 bf c8 3a 80 00 00 	movabs $0x803ac8,%rdi
  801e11:	00 00 00 
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  801e20:	00 00 00 
  801e23:	ff d1                	callq  *%rcx
	*dev = 0;
  801e25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e29:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e35:	c9                   	leaveq 
  801e36:	c3                   	retq   

0000000000801e37 <close>:

int
close(int fdnum)
{
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	48 83 ec 20          	sub    $0x20,%rsp
  801e3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e49:	48 89 d6             	mov    %rdx,%rsi
  801e4c:	89 c7                	mov    %eax,%edi
  801e4e:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
  801e5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e61:	79 05                	jns    801e68 <close+0x31>
		return r;
  801e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e66:	eb 18                	jmp    801e80 <close+0x49>
	else
		return fd_close(fd, 1);
  801e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6c:	be 01 00 00 00       	mov    $0x1,%esi
  801e71:	48 89 c7             	mov    %rax,%rdi
  801e74:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  801e7b:	00 00 00 
  801e7e:	ff d0                	callq  *%rax
}
  801e80:	c9                   	leaveq 
  801e81:	c3                   	retq   

0000000000801e82 <close_all>:

void
close_all(void)
{
  801e82:	55                   	push   %rbp
  801e83:	48 89 e5             	mov    %rsp,%rbp
  801e86:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e91:	eb 15                	jmp    801ea8 <close_all+0x26>
		close(i);
  801e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e96:	89 c7                	mov    %eax,%edi
  801e98:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ea4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ea8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eac:	7e e5                	jle    801e93 <close_all+0x11>
		close(i);
}
  801eae:	c9                   	leaveq 
  801eaf:	c3                   	retq   

0000000000801eb0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801eb0:	55                   	push   %rbp
  801eb1:	48 89 e5             	mov    %rsp,%rbp
  801eb4:	48 83 ec 40          	sub    $0x40,%rsp
  801eb8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ebb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ebe:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ec2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ec5:	48 89 d6             	mov    %rdx,%rsi
  801ec8:	89 c7                	mov    %eax,%edi
  801eca:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
  801ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801edd:	79 08                	jns    801ee7 <dup+0x37>
		return r;
  801edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee2:	e9 70 01 00 00       	jmpq   802057 <dup+0x1a7>
	close(newfdnum);
  801ee7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801eea:	89 c7                	mov    %eax,%edi
  801eec:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ef8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801efb:	48 98                	cltq   
  801efd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f03:	48 c1 e0 0c          	shl    $0xc,%rax
  801f07:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0f:	48 89 c7             	mov    %rax,%rdi
  801f12:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
  801f1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f26:	48 89 c7             	mov    %rax,%rdi
  801f29:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801f30:	00 00 00 
  801f33:	ff d0                	callq  *%rax
  801f35:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3d:	48 c1 e8 15          	shr    $0x15,%rax
  801f41:	48 89 c2             	mov    %rax,%rdx
  801f44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f4b:	01 00 00 
  801f4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f52:	83 e0 01             	and    $0x1,%eax
  801f55:	48 85 c0             	test   %rax,%rax
  801f58:	74 73                	je     801fcd <dup+0x11d>
  801f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f5e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f62:	48 89 c2             	mov    %rax,%rdx
  801f65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6c:	01 00 00 
  801f6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f73:	83 e0 01             	and    $0x1,%eax
  801f76:	48 85 c0             	test   %rax,%rax
  801f79:	74 52                	je     801fcd <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7f:	48 c1 e8 0c          	shr    $0xc,%rax
  801f83:	48 89 c2             	mov    %rax,%rdx
  801f86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f8d:	01 00 00 
  801f90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f94:	25 07 0e 00 00       	and    $0xe07,%eax
  801f99:	89 c1                	mov    %eax,%ecx
  801f9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	41 89 c8             	mov    %ecx,%r8d
  801fa6:	48 89 d1             	mov    %rdx,%rcx
  801fa9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fae:	48 89 c6             	mov    %rax,%rsi
  801fb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb6:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc9:	79 02                	jns    801fcd <dup+0x11d>
			goto err;
  801fcb:	eb 57                	jmp    802024 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fd5:	48 89 c2             	mov    %rax,%rdx
  801fd8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fdf:	01 00 00 
  801fe2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe6:	25 07 0e 00 00       	and    $0xe07,%eax
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ff5:	41 89 c8             	mov    %ecx,%r8d
  801ff8:	48 89 d1             	mov    %rdx,%rcx
  801ffb:	ba 00 00 00 00       	mov    $0x0,%edx
  802000:	48 89 c6             	mov    %rax,%rsi
  802003:	bf 00 00 00 00       	mov    $0x0,%edi
  802008:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
  802014:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802017:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80201b:	79 02                	jns    80201f <dup+0x16f>
		goto err;
  80201d:	eb 05                	jmp    802024 <dup+0x174>

	return newfdnum;
  80201f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802022:	eb 33                	jmp    802057 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802028:	48 89 c6             	mov    %rax,%rsi
  80202b:	bf 00 00 00 00       	mov    $0x0,%edi
  802030:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80203c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802040:	48 89 c6             	mov    %rax,%rsi
  802043:	bf 00 00 00 00       	mov    $0x0,%edi
  802048:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  80204f:	00 00 00 
  802052:	ff d0                	callq  *%rax
	return r;
  802054:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802057:	c9                   	leaveq 
  802058:	c3                   	retq   

0000000000802059 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802059:	55                   	push   %rbp
  80205a:	48 89 e5             	mov    %rsp,%rbp
  80205d:	48 83 ec 40          	sub    $0x40,%rsp
  802061:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802064:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802068:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80206c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802070:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802073:	48 89 d6             	mov    %rdx,%rsi
  802076:	89 c7                	mov    %eax,%edi
  802078:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax
  802084:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802087:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208b:	78 24                	js     8020b1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80208d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802091:	8b 00                	mov    (%rax),%eax
  802093:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802097:	48 89 d6             	mov    %rdx,%rsi
  80209a:	89 c7                	mov    %eax,%edi
  80209c:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	callq  *%rax
  8020a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020af:	79 05                	jns    8020b6 <read+0x5d>
		return r;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b4:	eb 76                	jmp    80212c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ba:	8b 40 08             	mov    0x8(%rax),%eax
  8020bd:	83 e0 03             	and    $0x3,%eax
  8020c0:	83 f8 01             	cmp    $0x1,%eax
  8020c3:	75 3a                	jne    8020ff <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020c5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020cc:	00 00 00 
  8020cf:	48 8b 00             	mov    (%rax),%rax
  8020d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020db:	89 c6                	mov    %eax,%esi
  8020dd:	48 bf e7 3a 80 00 00 	movabs $0x803ae7,%rdi
  8020e4:	00 00 00 
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  8020f3:	00 00 00 
  8020f6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020fd:	eb 2d                	jmp    80212c <read+0xd3>
	}
	if (!dev->dev_read)
  8020ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802103:	48 8b 40 10          	mov    0x10(%rax),%rax
  802107:	48 85 c0             	test   %rax,%rax
  80210a:	75 07                	jne    802113 <read+0xba>
		return -E_NOT_SUPP;
  80210c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802111:	eb 19                	jmp    80212c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802117:	48 8b 40 10          	mov    0x10(%rax),%rax
  80211b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80211f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802123:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802127:	48 89 cf             	mov    %rcx,%rdi
  80212a:	ff d0                	callq  *%rax
}
  80212c:	c9                   	leaveq 
  80212d:	c3                   	retq   

000000000080212e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	48 83 ec 30          	sub    $0x30,%rsp
  802136:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80213d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802148:	eb 49                	jmp    802193 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80214a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214d:	48 98                	cltq   
  80214f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802153:	48 29 c2             	sub    %rax,%rdx
  802156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802159:	48 63 c8             	movslq %eax,%rcx
  80215c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802160:	48 01 c1             	add    %rax,%rcx
  802163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802166:	48 89 ce             	mov    %rcx,%rsi
  802169:	89 c7                	mov    %eax,%edi
  80216b:	48 b8 59 20 80 00 00 	movabs $0x802059,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
  802177:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80217a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80217e:	79 05                	jns    802185 <readn+0x57>
			return m;
  802180:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802183:	eb 1c                	jmp    8021a1 <readn+0x73>
		if (m == 0)
  802185:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802189:	75 02                	jne    80218d <readn+0x5f>
			break;
  80218b:	eb 11                	jmp    80219e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80218d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802190:	01 45 fc             	add    %eax,-0x4(%rbp)
  802193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802196:	48 98                	cltq   
  802198:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80219c:	72 ac                	jb     80214a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80219e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021a1:	c9                   	leaveq 
  8021a2:	c3                   	retq   

00000000008021a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021a3:	55                   	push   %rbp
  8021a4:	48 89 e5             	mov    %rsp,%rbp
  8021a7:	48 83 ec 40          	sub    $0x40,%rsp
  8021ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021b2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021bd:	48 89 d6             	mov    %rdx,%rsi
  8021c0:	89 c7                	mov    %eax,%edi
  8021c2:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8021c9:	00 00 00 
  8021cc:	ff d0                	callq  *%rax
  8021ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d5:	78 24                	js     8021fb <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021db:	8b 00                	mov    (%rax),%eax
  8021dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021e1:	48 89 d6             	mov    %rdx,%rsi
  8021e4:	89 c7                	mov    %eax,%edi
  8021e6:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8021ed:	00 00 00 
  8021f0:	ff d0                	callq  *%rax
  8021f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f9:	79 05                	jns    802200 <write+0x5d>
		return r;
  8021fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fe:	eb 75                	jmp    802275 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802204:	8b 40 08             	mov    0x8(%rax),%eax
  802207:	83 e0 03             	and    $0x3,%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	75 3a                	jne    802248 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80220e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802215:	00 00 00 
  802218:	48 8b 00             	mov    (%rax),%rax
  80221b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802221:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802224:	89 c6                	mov    %eax,%esi
  802226:	48 bf 03 3b 80 00 00 	movabs $0x803b03,%rdi
  80222d:	00 00 00 
  802230:	b8 00 00 00 00       	mov    $0x0,%eax
  802235:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  80223c:	00 00 00 
  80223f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802241:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802246:	eb 2d                	jmp    802275 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802250:	48 85 c0             	test   %rax,%rax
  802253:	75 07                	jne    80225c <write+0xb9>
		return -E_NOT_SUPP;
  802255:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80225a:	eb 19                	jmp    802275 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80225c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802260:	48 8b 40 18          	mov    0x18(%rax),%rax
  802264:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802268:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80226c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802270:	48 89 cf             	mov    %rcx,%rdi
  802273:	ff d0                	callq  *%rax
}
  802275:	c9                   	leaveq 
  802276:	c3                   	retq   

0000000000802277 <seek>:

int
seek(int fdnum, off_t offset)
{
  802277:	55                   	push   %rbp
  802278:	48 89 e5             	mov    %rsp,%rbp
  80227b:	48 83 ec 18          	sub    $0x18,%rsp
  80227f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802282:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802285:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802289:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80228c:	48 89 d6             	mov    %rdx,%rsi
  80228f:	89 c7                	mov    %eax,%edi
  802291:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802298:	00 00 00 
  80229b:	ff d0                	callq  *%rax
  80229d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a4:	79 05                	jns    8022ab <seek+0x34>
		return r;
  8022a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a9:	eb 0f                	jmp    8022ba <seek+0x43>
	fd->fd_offset = offset;
  8022ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ba:	c9                   	leaveq 
  8022bb:	c3                   	retq   

00000000008022bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022bc:	55                   	push   %rbp
  8022bd:	48 89 e5             	mov    %rsp,%rbp
  8022c0:	48 83 ec 30          	sub    $0x30,%rsp
  8022c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022c7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022d1:	48 89 d6             	mov    %rdx,%rsi
  8022d4:	89 c7                	mov    %eax,%edi
  8022d6:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax
  8022e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e9:	78 24                	js     80230f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	8b 00                	mov    (%rax),%eax
  8022f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f5:	48 89 d6             	mov    %rdx,%rsi
  8022f8:	89 c7                	mov    %eax,%edi
  8022fa:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802309:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80230d:	79 05                	jns    802314 <ftruncate+0x58>
		return r;
  80230f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802312:	eb 72                	jmp    802386 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802318:	8b 40 08             	mov    0x8(%rax),%eax
  80231b:	83 e0 03             	and    $0x3,%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	75 3a                	jne    80235c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802322:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802329:	00 00 00 
  80232c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80232f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802335:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802338:	89 c6                	mov    %eax,%esi
  80233a:	48 bf 20 3b 80 00 00 	movabs $0x803b20,%rdi
  802341:	00 00 00 
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	48 b9 b0 02 80 00 00 	movabs $0x8002b0,%rcx
  802350:	00 00 00 
  802353:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235a:	eb 2a                	jmp    802386 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80235c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802360:	48 8b 40 30          	mov    0x30(%rax),%rax
  802364:	48 85 c0             	test   %rax,%rax
  802367:	75 07                	jne    802370 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802369:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80236e:	eb 16                	jmp    802386 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802374:	48 8b 40 30          	mov    0x30(%rax),%rax
  802378:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80237c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80237f:	89 ce                	mov    %ecx,%esi
  802381:	48 89 d7             	mov    %rdx,%rdi
  802384:	ff d0                	callq  *%rax
}
  802386:	c9                   	leaveq 
  802387:	c3                   	retq   

0000000000802388 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802388:	55                   	push   %rbp
  802389:	48 89 e5             	mov    %rsp,%rbp
  80238c:	48 83 ec 30          	sub    $0x30,%rsp
  802390:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802393:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802397:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80239b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80239e:	48 89 d6             	mov    %rdx,%rsi
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	callq  *%rax
  8023af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023b6:	78 24                	js     8023dc <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023bc:	8b 00                	mov    (%rax),%eax
  8023be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c2:	48 89 d6             	mov    %rdx,%rsi
  8023c5:	89 c7                	mov    %eax,%edi
  8023c7:	48 b8 80 1d 80 00 00 	movabs $0x801d80,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023da:	79 05                	jns    8023e1 <fstat+0x59>
		return r;
  8023dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023df:	eb 5e                	jmp    80243f <fstat+0xb7>
	if (!dev->dev_stat)
  8023e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023e9:	48 85 c0             	test   %rax,%rax
  8023ec:	75 07                	jne    8023f5 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023f3:	eb 4a                	jmp    80243f <fstat+0xb7>
	stat->st_name[0] = 0;
  8023f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802400:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802407:	00 00 00 
	stat->st_isdir = 0;
  80240a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80240e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802415:	00 00 00 
	stat->st_dev = dev;
  802418:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80241c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802420:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802427:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80242f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802433:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802437:	48 89 ce             	mov    %rcx,%rsi
  80243a:	48 89 d7             	mov    %rdx,%rdi
  80243d:	ff d0                	callq  *%rax
}
  80243f:	c9                   	leaveq 
  802440:	c3                   	retq   

0000000000802441 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802441:	55                   	push   %rbp
  802442:	48 89 e5             	mov    %rsp,%rbp
  802445:	48 83 ec 20          	sub    $0x20,%rsp
  802449:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80244d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802455:	be 00 00 00 00       	mov    $0x0,%esi
  80245a:	48 89 c7             	mov    %rax,%rdi
  80245d:	48 b8 2f 25 80 00 00 	movabs $0x80252f,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
  802469:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802470:	79 05                	jns    802477 <stat+0x36>
		return fd;
  802472:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802475:	eb 2f                	jmp    8024a6 <stat+0x65>
	r = fstat(fd, stat);
  802477:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80247b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247e:	48 89 d6             	mov    %rdx,%rsi
  802481:	89 c7                	mov    %eax,%edi
  802483:	48 b8 88 23 80 00 00 	movabs $0x802388,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802492:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802495:	89 c7                	mov    %eax,%edi
  802497:	48 b8 37 1e 80 00 00 	movabs $0x801e37,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	callq  *%rax
	return r;
  8024a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8024a6:	c9                   	leaveq 
  8024a7:	c3                   	retq   

00000000008024a8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	48 83 ec 10          	sub    $0x10,%rsp
  8024b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024b7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024be:	00 00 00 
  8024c1:	8b 00                	mov    (%rax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	75 1d                	jne    8024e4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8024cc:	48 b8 62 34 80 00 00 	movabs $0x803462,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	callq  *%rax
  8024d8:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8024df:	00 00 00 
  8024e2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024eb:	00 00 00 
  8024ee:	8b 00                	mov    (%rax),%eax
  8024f0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024f3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024f8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024ff:	00 00 00 
  802502:	89 c7                	mov    %eax,%edi
  802504:	48 b8 00 34 80 00 00 	movabs $0x803400,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802510:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802514:	ba 00 00 00 00       	mov    $0x0,%edx
  802519:	48 89 c6             	mov    %rax,%rsi
  80251c:	bf 00 00 00 00       	mov    $0x0,%edi
  802521:	48 b8 fa 32 80 00 00 	movabs $0x8032fa,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
}
  80252d:	c9                   	leaveq 
  80252e:	c3                   	retq   

000000000080252f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80252f:	55                   	push   %rbp
  802530:	48 89 e5             	mov    %rsp,%rbp
  802533:	48 83 ec 30          	sub    $0x30,%rsp
  802537:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80253b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80253e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802545:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80254c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802553:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802558:	75 08                	jne    802562 <open+0x33>
	{
		return r;
  80255a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255d:	e9 f2 00 00 00       	jmpq   802654 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802566:	48 89 c7             	mov    %rax,%rdi
  802569:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
  802575:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802578:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80257f:	7e 0a                	jle    80258b <open+0x5c>
	{
		return -E_BAD_PATH;
  802581:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802586:	e9 c9 00 00 00       	jmpq   802654 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80258b:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802592:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802593:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802597:	48 89 c7             	mov    %rax,%rdi
  80259a:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8025a1:	00 00 00 
  8025a4:	ff d0                	callq  *%rax
  8025a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ad:	78 09                	js     8025b8 <open+0x89>
  8025af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b3:	48 85 c0             	test   %rax,%rax
  8025b6:	75 08                	jne    8025c0 <open+0x91>
		{
			return r;
  8025b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bb:	e9 94 00 00 00       	jmpq   802654 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8025c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c4:	ba 00 04 00 00       	mov    $0x400,%edx
  8025c9:	48 89 c6             	mov    %rax,%rsi
  8025cc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8025d3:	00 00 00 
  8025d6:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8025e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025e9:	00 00 00 
  8025ec:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8025ef:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8025f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f9:	48 89 c6             	mov    %rax,%rsi
  8025fc:	bf 01 00 00 00       	mov    $0x1,%edi
  802601:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802610:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802614:	79 2b                	jns    802641 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261a:	be 00 00 00 00       	mov    $0x0,%esi
  80261f:	48 89 c7             	mov    %rax,%rdi
  802622:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
  80262e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802631:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802635:	79 05                	jns    80263c <open+0x10d>
			{
				return d;
  802637:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80263a:	eb 18                	jmp    802654 <open+0x125>
			}
			return r;
  80263c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263f:	eb 13                	jmp    802654 <open+0x125>
		}	
		return fd2num(fd_store);
  802641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802645:	48 89 c7             	mov    %rax,%rdi
  802648:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802654:	c9                   	leaveq 
  802655:	c3                   	retq   

0000000000802656 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802656:	55                   	push   %rbp
  802657:	48 89 e5             	mov    %rsp,%rbp
  80265a:	48 83 ec 10          	sub    $0x10,%rsp
  80265e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802666:	8b 50 0c             	mov    0xc(%rax),%edx
  802669:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802670:	00 00 00 
  802673:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802675:	be 00 00 00 00       	mov    $0x0,%esi
  80267a:	bf 06 00 00 00       	mov    $0x6,%edi
  80267f:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
}
  80268b:	c9                   	leaveq 
  80268c:	c3                   	retq   

000000000080268d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80268d:	55                   	push   %rbp
  80268e:	48 89 e5             	mov    %rsp,%rbp
  802691:	48 83 ec 30          	sub    $0x30,%rsp
  802695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802699:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80269d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8026a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8026a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8026ad:	74 07                	je     8026b6 <devfile_read+0x29>
  8026af:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026b4:	75 07                	jne    8026bd <devfile_read+0x30>
		return -E_INVAL;
  8026b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026bb:	eb 77                	jmp    802734 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8026c4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026cb:	00 00 00 
  8026ce:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8026d0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d7:	00 00 00 
  8026da:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026de:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8026e2:	be 00 00 00 00       	mov    $0x0,%esi
  8026e7:	bf 03 00 00 00       	mov    $0x3,%edi
  8026ec:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
  8026f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ff:	7f 05                	jg     802706 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802704:	eb 2e                	jmp    802734 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802709:	48 63 d0             	movslq %eax,%rdx
  80270c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802710:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802717:	00 00 00 
  80271a:	48 89 c7             	mov    %rax,%rdi
  80271d:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802729:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802731:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802734:	c9                   	leaveq 
  802735:	c3                   	retq   

0000000000802736 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802736:	55                   	push   %rbp
  802737:	48 89 e5             	mov    %rsp,%rbp
  80273a:	48 83 ec 30          	sub    $0x30,%rsp
  80273e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802742:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802746:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80274a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802751:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802756:	74 07                	je     80275f <devfile_write+0x29>
  802758:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80275d:	75 08                	jne    802767 <devfile_write+0x31>
		return r;
  80275f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802762:	e9 9a 00 00 00       	jmpq   802801 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276b:	8b 50 0c             	mov    0xc(%rax),%edx
  80276e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802775:	00 00 00 
  802778:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80277a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802781:	00 
  802782:	76 08                	jbe    80278c <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802784:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80278b:	00 
	}
	fsipcbuf.write.req_n = n;
  80278c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802793:	00 00 00 
  802796:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80279a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80279e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a6:	48 89 c6             	mov    %rax,%rsi
  8027a9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8027b0:	00 00 00 
  8027b3:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  8027ba:	00 00 00 
  8027bd:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8027bf:	be 00 00 00 00       	mov    $0x0,%esi
  8027c4:	bf 04 00 00 00       	mov    $0x4,%edi
  8027c9:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8027d0:	00 00 00 
  8027d3:	ff d0                	callq  *%rax
  8027d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027dc:	7f 20                	jg     8027fe <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8027de:	48 bf 46 3b 80 00 00 	movabs $0x803b46,%rdi
  8027e5:	00 00 00 
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  8027f4:	00 00 00 
  8027f7:	ff d2                	callq  *%rdx
		return r;
  8027f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fc:	eb 03                	jmp    802801 <devfile_write+0xcb>
	}
	return r;
  8027fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802801:	c9                   	leaveq 
  802802:	c3                   	retq   

0000000000802803 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802803:	55                   	push   %rbp
  802804:	48 89 e5             	mov    %rsp,%rbp
  802807:	48 83 ec 20          	sub    $0x20,%rsp
  80280b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802817:	8b 50 0c             	mov    0xc(%rax),%edx
  80281a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802821:	00 00 00 
  802824:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802826:	be 00 00 00 00       	mov    $0x0,%esi
  80282b:	bf 05 00 00 00       	mov    $0x5,%edi
  802830:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	79 05                	jns    80284a <devfile_stat+0x47>
		return r;
  802845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802848:	eb 56                	jmp    8028a0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80284a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802855:	00 00 00 
  802858:	48 89 c7             	mov    %rax,%rdi
  80285b:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802867:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80286e:	00 00 00 
  802871:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802877:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802881:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802888:	00 00 00 
  80288b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802891:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802895:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80289b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a0:	c9                   	leaveq 
  8028a1:	c3                   	retq   

00000000008028a2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028a2:	55                   	push   %rbp
  8028a3:	48 89 e5             	mov    %rsp,%rbp
  8028a6:	48 83 ec 10          	sub    $0x10,%rsp
  8028aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028ae:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028bf:	00 00 00 
  8028c2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028c4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028cb:	00 00 00 
  8028ce:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028d1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028d4:	be 00 00 00 00       	mov    $0x0,%esi
  8028d9:	bf 02 00 00 00       	mov    $0x2,%edi
  8028de:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
}
  8028ea:	c9                   	leaveq 
  8028eb:	c3                   	retq   

00000000008028ec <remove>:

// Delete a file
int
remove(const char *path)
{
  8028ec:	55                   	push   %rbp
  8028ed:	48 89 e5             	mov    %rsp,%rbp
  8028f0:	48 83 ec 10          	sub    $0x10,%rsp
  8028f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028fc:	48 89 c7             	mov    %rax,%rdi
  8028ff:	48 b8 f9 0d 80 00 00 	movabs $0x800df9,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802910:	7e 07                	jle    802919 <remove+0x2d>
		return -E_BAD_PATH;
  802912:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802917:	eb 33                	jmp    80294c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291d:	48 89 c6             	mov    %rax,%rsi
  802920:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802927:	00 00 00 
  80292a:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802936:	be 00 00 00 00       	mov    $0x0,%esi
  80293b:	bf 07 00 00 00       	mov    $0x7,%edi
  802940:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802947:	00 00 00 
  80294a:	ff d0                	callq  *%rax
}
  80294c:	c9                   	leaveq 
  80294d:	c3                   	retq   

000000000080294e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80294e:	55                   	push   %rbp
  80294f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802952:	be 00 00 00 00       	mov    $0x0,%esi
  802957:	bf 08 00 00 00       	mov    $0x8,%edi
  80295c:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802963:	00 00 00 
  802966:	ff d0                	callq  *%rax
}
  802968:	5d                   	pop    %rbp
  802969:	c3                   	retq   

000000000080296a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80296a:	55                   	push   %rbp
  80296b:	48 89 e5             	mov    %rsp,%rbp
  80296e:	53                   	push   %rbx
  80296f:	48 83 ec 38          	sub    $0x38,%rsp
  802973:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802977:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80297b:	48 89 c7             	mov    %rax,%rdi
  80297e:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
  80298a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80298d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802991:	0f 88 bf 01 00 00    	js     802b56 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80299b:	ba 07 04 00 00       	mov    $0x407,%edx
  8029a0:	48 89 c6             	mov    %rax,%rsi
  8029a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a8:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029bb:	0f 88 95 01 00 00    	js     802b56 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029c1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029c5:	48 89 c7             	mov    %rax,%rdi
  8029c8:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
  8029d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029db:	0f 88 5d 01 00 00    	js     802b3e <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8029ea:	48 89 c6             	mov    %rax,%rsi
  8029ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f2:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  8029f9:	00 00 00 
  8029fc:	ff d0                	callq  *%rax
  8029fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a05:	0f 88 33 01 00 00    	js     802b3e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a0f:	48 89 c7             	mov    %rax,%rdi
  802a12:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a26:	ba 07 04 00 00       	mov    $0x407,%edx
  802a2b:	48 89 c6             	mov    %rax,%rsi
  802a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a33:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	callq  *%rax
  802a3f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a42:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a46:	79 05                	jns    802a4d <pipe+0xe3>
		goto err2;
  802a48:	e9 d9 00 00 00       	jmpq   802b26 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a51:	48 89 c7             	mov    %rax,%rdi
  802a54:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
  802a60:	48 89 c2             	mov    %rax,%rdx
  802a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a67:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802a6d:	48 89 d1             	mov    %rdx,%rcx
  802a70:	ba 00 00 00 00       	mov    $0x0,%edx
  802a75:	48 89 c6             	mov    %rax,%rsi
  802a78:	bf 00 00 00 00       	mov    $0x0,%edi
  802a7d:	48 b8 e4 17 80 00 00 	movabs $0x8017e4,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
  802a89:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a90:	79 1b                	jns    802aad <pipe+0x143>
		goto err3;
  802a92:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a97:	48 89 c6             	mov    %rax,%rsi
  802a9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9f:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	eb 79                	jmp    802b26 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802aad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ab1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ab8:	00 00 00 
  802abb:	8b 12                	mov    (%rdx),%edx
  802abd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802abf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802aca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ace:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ad5:	00 00 00 
  802ad8:	8b 12                	mov    (%rdx),%edx
  802ada:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ae7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aeb:	48 89 c7             	mov    %rax,%rdi
  802aee:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 c2                	mov    %eax,%edx
  802afc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b00:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802b02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b06:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802b0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0e:	48 89 c7             	mov    %rax,%rdi
  802b11:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
  802b1d:	89 03                	mov    %eax,(%rbx)
	return 0;
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	eb 33                	jmp    802b59 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802b26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b2a:	48 89 c6             	mov    %rax,%rsi
  802b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b32:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802b3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b42:	48 89 c6             	mov    %rax,%rsi
  802b45:	bf 00 00 00 00       	mov    $0x0,%edi
  802b4a:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
    err:
	return r;
  802b56:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802b59:	48 83 c4 38          	add    $0x38,%rsp
  802b5d:	5b                   	pop    %rbx
  802b5e:	5d                   	pop    %rbp
  802b5f:	c3                   	retq   

0000000000802b60 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b60:	55                   	push   %rbp
  802b61:	48 89 e5             	mov    %rsp,%rbp
  802b64:	53                   	push   %rbx
  802b65:	48 83 ec 28          	sub    $0x28,%rsp
  802b69:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802b71:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b78:	00 00 00 
  802b7b:	48 8b 00             	mov    (%rax),%rax
  802b7e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b84:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8b:	48 89 c7             	mov    %rax,%rdi
  802b8e:	48 b8 e4 34 80 00 00 	movabs $0x8034e4,%rax
  802b95:	00 00 00 
  802b98:	ff d0                	callq  *%rax
  802b9a:	89 c3                	mov    %eax,%ebx
  802b9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba0:	48 89 c7             	mov    %rax,%rdi
  802ba3:	48 b8 e4 34 80 00 00 	movabs $0x8034e4,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
  802baf:	39 c3                	cmp    %eax,%ebx
  802bb1:	0f 94 c0             	sete   %al
  802bb4:	0f b6 c0             	movzbl %al,%eax
  802bb7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802bba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bc1:	00 00 00 
  802bc4:	48 8b 00             	mov    (%rax),%rax
  802bc7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802bcd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802bd0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802bd6:	75 05                	jne    802bdd <_pipeisclosed+0x7d>
			return ret;
  802bd8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bdb:	eb 4f                	jmp    802c2c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802bdd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802be3:	74 42                	je     802c27 <_pipeisclosed+0xc7>
  802be5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802be9:	75 3c                	jne    802c27 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802beb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bf2:	00 00 00 
  802bf5:	48 8b 00             	mov    (%rax),%rax
  802bf8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802bfe:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c04:	89 c6                	mov    %eax,%esi
  802c06:	48 bf 67 3b 80 00 00 	movabs $0x803b67,%rdi
  802c0d:	00 00 00 
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	49 b8 b0 02 80 00 00 	movabs $0x8002b0,%r8
  802c1c:	00 00 00 
  802c1f:	41 ff d0             	callq  *%r8
	}
  802c22:	e9 4a ff ff ff       	jmpq   802b71 <_pipeisclosed+0x11>
  802c27:	e9 45 ff ff ff       	jmpq   802b71 <_pipeisclosed+0x11>
}
  802c2c:	48 83 c4 28          	add    $0x28,%rsp
  802c30:	5b                   	pop    %rbx
  802c31:	5d                   	pop    %rbp
  802c32:	c3                   	retq   

0000000000802c33 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802c33:	55                   	push   %rbp
  802c34:	48 89 e5             	mov    %rsp,%rbp
  802c37:	48 83 ec 30          	sub    $0x30,%rsp
  802c3b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c45:	48 89 d6             	mov    %rdx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	79 05                	jns    802c64 <pipeisclosed+0x31>
		return r;
  802c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c62:	eb 31                	jmp    802c95 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802c64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c68:	48 89 c7             	mov    %rax,%rdi
  802c6b:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c83:	48 89 d6             	mov    %rdx,%rsi
  802c86:	48 89 c7             	mov    %rax,%rdi
  802c89:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
}
  802c95:	c9                   	leaveq 
  802c96:	c3                   	retq   

0000000000802c97 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c97:	55                   	push   %rbp
  802c98:	48 89 e5             	mov    %rsp,%rbp
  802c9b:	48 83 ec 40          	sub    $0x40,%rsp
  802c9f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ca3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ca7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802cab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802caf:	48 89 c7             	mov    %rax,%rdi
  802cb2:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802cc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802cca:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802cd1:	00 
  802cd2:	e9 92 00 00 00       	jmpq   802d69 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802cd7:	eb 41                	jmp    802d1a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802cd9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802cde:	74 09                	je     802ce9 <devpipe_read+0x52>
				return i;
  802ce0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce4:	e9 92 00 00 00       	jmpq   802d7b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ce9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ced:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf1:	48 89 d6             	mov    %rdx,%rsi
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 07                	je     802d0e <devpipe_read+0x77>
				return 0;
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0c:	eb 6d                	jmp    802d7b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d0e:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1e:	8b 10                	mov    (%rax),%edx
  802d20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d24:	8b 40 04             	mov    0x4(%rax),%eax
  802d27:	39 c2                	cmp    %eax,%edx
  802d29:	74 ae                	je     802cd9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d33:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802d37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3b:	8b 00                	mov    (%rax),%eax
  802d3d:	99                   	cltd   
  802d3e:	c1 ea 1b             	shr    $0x1b,%edx
  802d41:	01 d0                	add    %edx,%eax
  802d43:	83 e0 1f             	and    $0x1f,%eax
  802d46:	29 d0                	sub    %edx,%eax
  802d48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d4c:	48 98                	cltq   
  802d4e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802d53:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802d55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d59:	8b 00                	mov    (%rax),%eax
  802d5b:	8d 50 01             	lea    0x1(%rax),%edx
  802d5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d62:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d64:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d6d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d71:	0f 82 60 ff ff ff    	jb     802cd7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d7b:	c9                   	leaveq 
  802d7c:	c3                   	retq   

0000000000802d7d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	48 83 ec 40          	sub    $0x40,%rsp
  802d85:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d89:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d8d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802d91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d95:	48 89 c7             	mov    %rax,%rdi
  802d98:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
  802da4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802da8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802db0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802db7:	00 
  802db8:	e9 8e 00 00 00       	jmpq   802e4b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802dbd:	eb 31                	jmp    802df0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802dbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc7:	48 89 d6             	mov    %rdx,%rsi
  802dca:	48 89 c7             	mov    %rax,%rdi
  802dcd:	48 b8 60 2b 80 00 00 	movabs $0x802b60,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 07                	je     802de4 <devpipe_write+0x67>
				return 0;
  802ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  802de2:	eb 79                	jmp    802e5d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802de4:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  802deb:	00 00 00 
  802dee:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802df0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df4:	8b 40 04             	mov    0x4(%rax),%eax
  802df7:	48 63 d0             	movslq %eax,%rdx
  802dfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfe:	8b 00                	mov    (%rax),%eax
  802e00:	48 98                	cltq   
  802e02:	48 83 c0 20          	add    $0x20,%rax
  802e06:	48 39 c2             	cmp    %rax,%rdx
  802e09:	73 b4                	jae    802dbf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0f:	8b 40 04             	mov    0x4(%rax),%eax
  802e12:	99                   	cltd   
  802e13:	c1 ea 1b             	shr    $0x1b,%edx
  802e16:	01 d0                	add    %edx,%eax
  802e18:	83 e0 1f             	and    $0x1f,%eax
  802e1b:	29 d0                	sub    %edx,%eax
  802e1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e21:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e25:	48 01 ca             	add    %rcx,%rdx
  802e28:	0f b6 0a             	movzbl (%rdx),%ecx
  802e2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e2f:	48 98                	cltq   
  802e31:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802e35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e39:	8b 40 04             	mov    0x4(%rax),%eax
  802e3c:	8d 50 01             	lea    0x1(%rax),%edx
  802e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e43:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e53:	0f 82 64 ff ff ff    	jb     802dbd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 20          	sub    $0x20,%rsp
  802e67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e73:	48 89 c7             	mov    %rax,%rdi
  802e76:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e8a:	48 be 7a 3b 80 00 00 	movabs $0x803b7a,%rsi
  802e91:	00 00 00 
  802e94:	48 89 c7             	mov    %rax,%rdi
  802e97:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea7:	8b 50 04             	mov    0x4(%rax),%edx
  802eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eae:	8b 00                	mov    (%rax),%eax
  802eb0:	29 c2                	sub    %eax,%edx
  802eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802ebc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ec7:	00 00 00 
	stat->st_dev = &devpipe;
  802eca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ece:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802ed5:	00 00 00 
  802ed8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee4:	c9                   	leaveq 
  802ee5:	c3                   	retq   

0000000000802ee6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802ee6:	55                   	push   %rbp
  802ee7:	48 89 e5             	mov    %rsp,%rbp
  802eea:	48 83 ec 10          	sub    $0x10,%rsp
  802eee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef6:	48 89 c6             	mov    %rax,%rsi
  802ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  802efe:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0e:	48 89 c7             	mov    %rax,%rdi
  802f11:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	48 89 c6             	mov    %rax,%rsi
  802f20:	bf 00 00 00 00       	mov    $0x0,%edi
  802f25:	48 b8 3f 18 80 00 00 	movabs $0x80183f,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
}
  802f31:	c9                   	leaveq 
  802f32:	c3                   	retq   

0000000000802f33 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f33:	55                   	push   %rbp
  802f34:	48 89 e5             	mov    %rsp,%rbp
  802f37:	48 83 ec 20          	sub    $0x20,%rsp
  802f3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802f3e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f41:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802f44:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802f48:	be 01 00 00 00       	mov    $0x1,%esi
  802f4d:	48 89 c7             	mov    %rax,%rdi
  802f50:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
}
  802f5c:	c9                   	leaveq 
  802f5d:	c3                   	retq   

0000000000802f5e <getchar>:

int
getchar(void)
{
  802f5e:	55                   	push   %rbp
  802f5f:	48 89 e5             	mov    %rsp,%rbp
  802f62:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802f66:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802f6a:	ba 01 00 00 00       	mov    $0x1,%edx
  802f6f:	48 89 c6             	mov    %rax,%rsi
  802f72:	bf 00 00 00 00       	mov    $0x0,%edi
  802f77:	48 b8 59 20 80 00 00 	movabs $0x802059,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	79 05                	jns    802f91 <getchar+0x33>
		return r;
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	eb 14                	jmp    802fa5 <getchar+0x47>
	if (r < 1)
  802f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f95:	7f 07                	jg     802f9e <getchar+0x40>
		return -E_EOF;
  802f97:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802f9c:	eb 07                	jmp    802fa5 <getchar+0x47>
	return c;
  802f9e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802fa2:	0f b6 c0             	movzbl %al,%eax
}
  802fa5:	c9                   	leaveq 
  802fa6:	c3                   	retq   

0000000000802fa7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802fa7:	55                   	push   %rbp
  802fa8:	48 89 e5             	mov    %rsp,%rbp
  802fab:	48 83 ec 20          	sub    $0x20,%rsp
  802faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fb2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fb9:	48 89 d6             	mov    %rdx,%rsi
  802fbc:	89 c7                	mov    %eax,%edi
  802fbe:	48 b8 27 1c 80 00 00 	movabs $0x801c27,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd1:	79 05                	jns    802fd8 <iscons+0x31>
		return r;
  802fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd6:	eb 1a                	jmp    802ff2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdc:	8b 10                	mov    (%rax),%edx
  802fde:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802fe5:	00 00 00 
  802fe8:	8b 00                	mov    (%rax),%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	0f 94 c0             	sete   %al
  802fef:	0f b6 c0             	movzbl %al,%eax
}
  802ff2:	c9                   	leaveq 
  802ff3:	c3                   	retq   

0000000000802ff4 <opencons>:

int
opencons(void)
{
  802ff4:	55                   	push   %rbp
  802ff5:	48 89 e5             	mov    %rsp,%rbp
  802ff8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ffc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803000:	48 89 c7             	mov    %rax,%rdi
  803003:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  80300a:	00 00 00 
  80300d:	ff d0                	callq  *%rax
  80300f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803012:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803016:	79 05                	jns    80301d <opencons+0x29>
		return r;
  803018:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301b:	eb 5b                	jmp    803078 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80301d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803021:	ba 07 04 00 00       	mov    $0x407,%edx
  803026:	48 89 c6             	mov    %rax,%rsi
  803029:	bf 00 00 00 00       	mov    $0x0,%edi
  80302e:	48 b8 94 17 80 00 00 	movabs $0x801794,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
  80303a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803041:	79 05                	jns    803048 <opencons+0x54>
		return r;
  803043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803046:	eb 30                	jmp    803078 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803053:	00 00 00 
  803056:	8b 12                	mov    (%rdx),%edx
  803058:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80305a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803069:	48 89 c7             	mov    %rax,%rdi
  80306c:	48 b8 41 1b 80 00 00 	movabs $0x801b41,%rax
  803073:	00 00 00 
  803076:	ff d0                	callq  *%rax
}
  803078:	c9                   	leaveq 
  803079:	c3                   	retq   

000000000080307a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80307a:	55                   	push   %rbp
  80307b:	48 89 e5             	mov    %rsp,%rbp
  80307e:	48 83 ec 30          	sub    $0x30,%rsp
  803082:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803086:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80308e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803093:	75 07                	jne    80309c <devcons_read+0x22>
		return 0;
  803095:	b8 00 00 00 00       	mov    $0x0,%eax
  80309a:	eb 4b                	jmp    8030e7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80309c:	eb 0c                	jmp    8030aa <devcons_read+0x30>
		sys_yield();
  80309e:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8030aa:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bd:	74 df                	je     80309e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8030bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c3:	79 05                	jns    8030ca <devcons_read+0x50>
		return c;
  8030c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c8:	eb 1d                	jmp    8030e7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8030ca:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8030ce:	75 07                	jne    8030d7 <devcons_read+0x5d>
		return 0;
  8030d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d5:	eb 10                	jmp    8030e7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030da:	89 c2                	mov    %eax,%edx
  8030dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e0:	88 10                	mov    %dl,(%rax)
	return 1;
  8030e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8030e7:	c9                   	leaveq 
  8030e8:	c3                   	retq   

00000000008030e9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8030e9:	55                   	push   %rbp
  8030ea:	48 89 e5             	mov    %rsp,%rbp
  8030ed:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8030f4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8030fb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803102:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803110:	eb 76                	jmp    803188 <devcons_write+0x9f>
		m = n - tot;
  803112:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803119:	89 c2                	mov    %eax,%edx
  80311b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311e:	29 c2                	sub    %eax,%edx
  803120:	89 d0                	mov    %edx,%eax
  803122:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803125:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803128:	83 f8 7f             	cmp    $0x7f,%eax
  80312b:	76 07                	jbe    803134 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80312d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803137:	48 63 d0             	movslq %eax,%rdx
  80313a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313d:	48 63 c8             	movslq %eax,%rcx
  803140:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803147:	48 01 c1             	add    %rax,%rcx
  80314a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803151:	48 89 ce             	mov    %rcx,%rsi
  803154:	48 89 c7             	mov    %rax,%rdi
  803157:	48 b8 89 11 80 00 00 	movabs $0x801189,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803163:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803166:	48 63 d0             	movslq %eax,%rdx
  803169:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803170:	48 89 d6             	mov    %rdx,%rsi
  803173:	48 89 c7             	mov    %rax,%rdi
  803176:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803182:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803185:	01 45 fc             	add    %eax,-0x4(%rbp)
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	48 98                	cltq   
  80318d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803194:	0f 82 78 ff ff ff    	jb     803112 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80319a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 08          	sub    $0x8,%rsp
  8031a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8031ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 10          	sub    $0x10,%rsp
  8031ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8031c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c6:	48 be 86 3b 80 00 00 	movabs $0x803b86,%rsi
  8031cd:	00 00 00 
  8031d0:	48 89 c7             	mov    %rax,%rdi
  8031d3:	48 b8 65 0e 80 00 00 	movabs $0x800e65,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
	return 0;
  8031df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e4:	c9                   	leaveq 
  8031e5:	c3                   	retq   

00000000008031e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8031e6:	55                   	push   %rbp
  8031e7:	48 89 e5             	mov    %rsp,%rbp
  8031ea:	53                   	push   %rbx
  8031eb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8031f2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8031f9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8031ff:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803206:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80320d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803214:	84 c0                	test   %al,%al
  803216:	74 23                	je     80323b <_panic+0x55>
  803218:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80321f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803223:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803227:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80322b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80322f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803233:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803237:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80323b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803242:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803249:	00 00 00 
  80324c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803253:	00 00 00 
  803256:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80325a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803261:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803268:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80326f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803276:	00 00 00 
  803279:	48 8b 18             	mov    (%rax),%rbx
  80327c:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80328e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803295:	41 89 c8             	mov    %ecx,%r8d
  803298:	48 89 d1             	mov    %rdx,%rcx
  80329b:	48 89 da             	mov    %rbx,%rdx
  80329e:	89 c6                	mov    %eax,%esi
  8032a0:	48 bf 90 3b 80 00 00 	movabs $0x803b90,%rdi
  8032a7:	00 00 00 
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	49 b9 b0 02 80 00 00 	movabs $0x8002b0,%r9
  8032b6:	00 00 00 
  8032b9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8032bc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8032c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8032ca:	48 89 d6             	mov    %rdx,%rsi
  8032cd:	48 89 c7             	mov    %rax,%rdi
  8032d0:	48 b8 04 02 80 00 00 	movabs $0x800204,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
	cprintf("\n");
  8032dc:	48 bf b3 3b 80 00 00 	movabs $0x803bb3,%rdi
  8032e3:	00 00 00 
  8032e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032eb:	48 ba b0 02 80 00 00 	movabs $0x8002b0,%rdx
  8032f2:	00 00 00 
  8032f5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8032f7:	cc                   	int3   
  8032f8:	eb fd                	jmp    8032f7 <_panic+0x111>

00000000008032fa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032fa:	55                   	push   %rbp
  8032fb:	48 89 e5             	mov    %rsp,%rbp
  8032fe:	48 83 ec 30          	sub    $0x30,%rsp
  803302:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803306:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80330a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80330e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803315:	00 00 00 
  803318:	48 8b 00             	mov    (%rax),%rax
  80331b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	75 3c                	jne    803361 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803325:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	callq  *%rax
  803331:	25 ff 03 00 00       	and    $0x3ff,%eax
  803336:	48 63 d0             	movslq %eax,%rdx
  803339:	48 89 d0             	mov    %rdx,%rax
  80333c:	48 c1 e0 03          	shl    $0x3,%rax
  803340:	48 01 d0             	add    %rdx,%rax
  803343:	48 c1 e0 05          	shl    $0x5,%rax
  803347:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80334e:	00 00 00 
  803351:	48 01 c2             	add    %rax,%rdx
  803354:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80335b:	00 00 00 
  80335e:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803361:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803366:	75 0e                	jne    803376 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803368:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80336f:	00 00 00 
  803372:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337a:	48 89 c7             	mov    %rax,%rdi
  80337d:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  803384:	00 00 00 
  803387:	ff d0                	callq  *%rax
  803389:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80338c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803390:	79 19                	jns    8033ab <ipc_recv+0xb1>
		*from_env_store = 0;
  803392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803396:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80339c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8033a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a9:	eb 53                	jmp    8033fe <ipc_recv+0x104>
	}
	if(from_env_store)
  8033ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033b0:	74 19                	je     8033cb <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8033b2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033b9:	00 00 00 
  8033bc:	48 8b 00             	mov    (%rax),%rax
  8033bf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c9:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8033cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033d0:	74 19                	je     8033eb <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8033d2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033d9:	00 00 00 
  8033dc:	48 8b 00             	mov    (%rax),%rax
  8033df:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8033e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e9:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8033eb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033f2:	00 00 00 
  8033f5:	48 8b 00             	mov    (%rax),%rax
  8033f8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8033fe:	c9                   	leaveq 
  8033ff:	c3                   	retq   

0000000000803400 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803400:	55                   	push   %rbp
  803401:	48 89 e5             	mov    %rsp,%rbp
  803404:	48 83 ec 30          	sub    $0x30,%rsp
  803408:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80340b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80340e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803412:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803415:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80341a:	75 0e                	jne    80342a <ipc_send+0x2a>
		pg = (void*)UTOP;
  80341c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803423:	00 00 00 
  803426:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80342a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80342d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803430:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803434:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803437:	89 c7                	mov    %eax,%edi
  803439:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
  803445:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803448:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80344c:	75 0c                	jne    80345a <ipc_send+0x5a>
			sys_yield();
  80344e:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80345a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80345e:	74 ca                	je     80342a <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803460:	c9                   	leaveq 
  803461:	c3                   	retq   

0000000000803462 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803462:	55                   	push   %rbp
  803463:	48 89 e5             	mov    %rsp,%rbp
  803466:	48 83 ec 14          	sub    $0x14,%rsp
  80346a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80346d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803474:	eb 5e                	jmp    8034d4 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803476:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80347d:	00 00 00 
  803480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803483:	48 63 d0             	movslq %eax,%rdx
  803486:	48 89 d0             	mov    %rdx,%rax
  803489:	48 c1 e0 03          	shl    $0x3,%rax
  80348d:	48 01 d0             	add    %rdx,%rax
  803490:	48 c1 e0 05          	shl    $0x5,%rax
  803494:	48 01 c8             	add    %rcx,%rax
  803497:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80349d:	8b 00                	mov    (%rax),%eax
  80349f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8034a2:	75 2c                	jne    8034d0 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8034a4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034ab:	00 00 00 
  8034ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b1:	48 63 d0             	movslq %eax,%rdx
  8034b4:	48 89 d0             	mov    %rdx,%rax
  8034b7:	48 c1 e0 03          	shl    $0x3,%rax
  8034bb:	48 01 d0             	add    %rdx,%rax
  8034be:	48 c1 e0 05          	shl    $0x5,%rax
  8034c2:	48 01 c8             	add    %rcx,%rax
  8034c5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8034cb:	8b 40 08             	mov    0x8(%rax),%eax
  8034ce:	eb 12                	jmp    8034e2 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8034d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8034d4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8034db:	7e 99                	jle    803476 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8034dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034e2:	c9                   	leaveq 
  8034e3:	c3                   	retq   

00000000008034e4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034e4:	55                   	push   %rbp
  8034e5:	48 89 e5             	mov    %rsp,%rbp
  8034e8:	48 83 ec 18          	sub    $0x18,%rsp
  8034ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8034f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f4:	48 c1 e8 15          	shr    $0x15,%rax
  8034f8:	48 89 c2             	mov    %rax,%rdx
  8034fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803502:	01 00 00 
  803505:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803509:	83 e0 01             	and    $0x1,%eax
  80350c:	48 85 c0             	test   %rax,%rax
  80350f:	75 07                	jne    803518 <pageref+0x34>
		return 0;
  803511:	b8 00 00 00 00       	mov    $0x0,%eax
  803516:	eb 53                	jmp    80356b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351c:	48 c1 e8 0c          	shr    $0xc,%rax
  803520:	48 89 c2             	mov    %rax,%rdx
  803523:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80352a:	01 00 00 
  80352d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803531:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803539:	83 e0 01             	and    $0x1,%eax
  80353c:	48 85 c0             	test   %rax,%rax
  80353f:	75 07                	jne    803548 <pageref+0x64>
		return 0;
  803541:	b8 00 00 00 00       	mov    $0x0,%eax
  803546:	eb 23                	jmp    80356b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354c:	48 c1 e8 0c          	shr    $0xc,%rax
  803550:	48 89 c2             	mov    %rax,%rdx
  803553:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80355a:	00 00 00 
  80355d:	48 c1 e2 04          	shl    $0x4,%rdx
  803561:	48 01 d0             	add    %rdx,%rax
  803564:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803568:	0f b7 c0             	movzwl %ax,%eax
}
  80356b:	c9                   	leaveq 
  80356c:	c3                   	retq   
