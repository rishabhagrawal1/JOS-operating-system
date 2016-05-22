
obj/user/hello.debug:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 00 34 80 00 00 	movabs $0x803400,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 0e 34 80 00 00 	movabs $0x80340e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ae:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bf:	48 63 d0             	movslq %eax,%rdx
  8000c2:	48 89 d0             	mov    %rdx,%rax
  8000c5:	48 c1 e0 03          	shl    $0x3,%rax
  8000c9:	48 01 d0             	add    %rdx,%rax
  8000cc:	48 c1 e0 05          	shl    $0x5,%rax
  8000d0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000d7:	00 00 00 
  8000da:	48 01 c2             	add    %rax,%rdx
  8000dd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000e4:	00 00 00 
  8000e7:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ee:	7e 14                	jle    800104 <libmain+0x65>
		binaryname = argv[0];
  8000f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f4:	48 8b 10             	mov    (%rax),%rdx
  8000f7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000fe:	00 00 00 
  800101:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800104:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010b:	48 89 d6             	mov    %rdx,%rsi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80011c:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
}
  800128:	c9                   	leaveq 
  800129:	c3                   	retq   

000000000080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80012e:	48 b8 04 1d 80 00 00 	movabs $0x801d04,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80013a:	bf 00 00 00 00       	mov    $0x0,%edi
  80013f:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  800146:	00 00 00 
  800149:	ff d0                	callq  *%rax

}
  80014b:	5d                   	pop    %rbp
  80014c:	c3                   	retq   

000000000080014d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014d:	55                   	push   %rbp
  80014e:	48 89 e5             	mov    %rsp,%rbp
  800151:	48 83 ec 10          	sub    $0x10,%rsp
  800155:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800158:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	8b 00                	mov    (%rax),%eax
  800162:	8d 48 01             	lea    0x1(%rax),%ecx
  800165:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800169:	89 0a                	mov    %ecx,(%rdx)
  80016b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800174:	48 98                	cltq   
  800176:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80017a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017e:	8b 00                	mov    (%rax),%eax
  800180:	3d ff 00 00 00       	cmp    $0xff,%eax
  800185:	75 2c                	jne    8001b3 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018b:	8b 00                	mov    (%rax),%eax
  80018d:	48 98                	cltq   
  80018f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800193:	48 83 c2 08          	add    $0x8,%rdx
  800197:	48 89 c6             	mov    %rax,%rsi
  80019a:	48 89 d7             	mov    %rdx,%rdi
  80019d:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax
		b->idx = 0;
  8001a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b7:	8b 40 04             	mov    0x4(%rax),%eax
  8001ba:	8d 50 01             	lea    0x1(%rax),%edx
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c4:	c9                   	leaveq 
  8001c5:	c3                   	retq   

00000000008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %rbp
  8001c7:	48 89 e5             	mov    %rsp,%rbp
  8001ca:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001d8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001df:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001ed:	48 8b 0a             	mov    (%rdx),%rcx
  8001f0:	48 89 08             	mov    %rcx,(%rax)
  8001f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800203:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80020a:	00 00 00 
	b.cnt = 0;
  80020d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800214:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800217:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80021e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800225:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80022c:	48 89 c6             	mov    %rax,%rsi
  80022f:	48 bf 4d 01 80 00 00 	movabs $0x80014d,%rdi
  800236:	00 00 00 
  800239:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800245:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80024b:	48 98                	cltq   
  80024d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800254:	48 83 c2 08          	add    $0x8,%rdx
  800258:	48 89 c6             	mov    %rax,%rsi
  80025b:	48 89 d7             	mov    %rdx,%rdi
  80025e:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80026a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800270:	c9                   	leaveq 
  800271:	c3                   	retq   

0000000000800272 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800272:	55                   	push   %rbp
  800273:	48 89 e5             	mov    %rsp,%rbp
  800276:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80027d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800284:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80028b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800292:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800299:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a0:	84 c0                	test   %al,%al
  8002a2:	74 20                	je     8002c4 <cprintf+0x52>
  8002a4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002a8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002b8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002bc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002cb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d2:	00 00 00 
  8002d5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002dc:	00 00 00 
  8002df:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8002f8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002ff:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800306:	48 8b 0a             	mov    (%rdx),%rcx
  800309:	48 89 08             	mov    %rcx,(%rax)
  80030c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800310:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800314:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800318:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80031c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800323:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80032a:	48 89 d6             	mov    %rdx,%rsi
  80032d:	48 89 c7             	mov    %rax,%rdi
  800330:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
  80033c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800342:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800348:	c9                   	leaveq 
  800349:	c3                   	retq   

000000000080034a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034a:	55                   	push   %rbp
  80034b:	48 89 e5             	mov    %rsp,%rbp
  80034e:	53                   	push   %rbx
  80034f:	48 83 ec 38          	sub    $0x38,%rsp
  800353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800357:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80035b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80035f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800362:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800366:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80036d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800371:	77 3b                	ja     8003ae <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800373:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800376:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80037a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80037d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	48 f7 f3             	div    %rbx
  800389:	48 89 c2             	mov    %rax,%rdx
  80038c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80038f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800392:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039a:	41 89 f9             	mov    %edi,%r9d
  80039d:	48 89 c7             	mov    %rax,%rdi
  8003a0:	48 b8 4a 03 80 00 00 	movabs $0x80034a,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax
  8003ac:	eb 1e                	jmp    8003cc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ae:	eb 12                	jmp    8003c2 <printnum+0x78>
			putch(padc, putdat);
  8003b0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003bb:	48 89 ce             	mov    %rcx,%rsi
  8003be:	89 d7                	mov    %edx,%edi
  8003c0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003ca:	7f e4                	jg     8003b0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	48 f7 f1             	div    %rcx
  8003db:	48 89 d0             	mov    %rdx,%rax
  8003de:	48 ba 08 36 80 00 00 	movabs $0x803608,%rdx
  8003e5:	00 00 00 
  8003e8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003ec:	0f be d0             	movsbl %al,%edx
  8003ef:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f7:	48 89 ce             	mov    %rcx,%rsi
  8003fa:	89 d7                	mov    %edx,%edi
  8003fc:	ff d0                	callq  *%rax
}
  8003fe:	48 83 c4 38          	add    $0x38,%rsp
  800402:	5b                   	pop    %rbx
  800403:	5d                   	pop    %rbp
  800404:	c3                   	retq   

0000000000800405 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800405:	55                   	push   %rbp
  800406:	48 89 e5             	mov    %rsp,%rbp
  800409:	48 83 ec 1c          	sub    $0x1c,%rsp
  80040d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800411:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800414:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800418:	7e 52                	jle    80046c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	8b 00                	mov    (%rax),%eax
  800420:	83 f8 30             	cmp    $0x30,%eax
  800423:	73 24                	jae    800449 <getuint+0x44>
  800425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800429:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80042d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800431:	8b 00                	mov    (%rax),%eax
  800433:	89 c0                	mov    %eax,%eax
  800435:	48 01 d0             	add    %rdx,%rax
  800438:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043c:	8b 12                	mov    (%rdx),%edx
  80043e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800445:	89 0a                	mov    %ecx,(%rdx)
  800447:	eb 17                	jmp    800460 <getuint+0x5b>
  800449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800451:	48 89 d0             	mov    %rdx,%rax
  800454:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800458:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800460:	48 8b 00             	mov    (%rax),%rax
  800463:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800467:	e9 a3 00 00 00       	jmpq   80050f <getuint+0x10a>
	else if (lflag)
  80046c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800470:	74 4f                	je     8004c1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800476:	8b 00                	mov    (%rax),%eax
  800478:	83 f8 30             	cmp    $0x30,%eax
  80047b:	73 24                	jae    8004a1 <getuint+0x9c>
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800489:	8b 00                	mov    (%rax),%eax
  80048b:	89 c0                	mov    %eax,%eax
  80048d:	48 01 d0             	add    %rdx,%rax
  800490:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800494:	8b 12                	mov    (%rdx),%edx
  800496:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800499:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049d:	89 0a                	mov    %ecx,(%rdx)
  80049f:	eb 17                	jmp    8004b8 <getuint+0xb3>
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004a9:	48 89 d0             	mov    %rdx,%rax
  8004ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004b8:	48 8b 00             	mov    (%rax),%rax
  8004bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004bf:	eb 4e                	jmp    80050f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c5:	8b 00                	mov    (%rax),%eax
  8004c7:	83 f8 30             	cmp    $0x30,%eax
  8004ca:	73 24                	jae    8004f0 <getuint+0xeb>
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d8:	8b 00                	mov    (%rax),%eax
  8004da:	89 c0                	mov    %eax,%eax
  8004dc:	48 01 d0             	add    %rdx,%rax
  8004df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e3:	8b 12                	mov    (%rdx),%edx
  8004e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ec:	89 0a                	mov    %ecx,(%rdx)
  8004ee:	eb 17                	jmp    800507 <getuint+0x102>
  8004f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f8:	48 89 d0             	mov    %rdx,%rax
  8004fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800503:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800507:	8b 00                	mov    (%rax),%eax
  800509:	89 c0                	mov    %eax,%eax
  80050b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80050f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800513:	c9                   	leaveq 
  800514:	c3                   	retq   

0000000000800515 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800515:	55                   	push   %rbp
  800516:	48 89 e5             	mov    %rsp,%rbp
  800519:	48 83 ec 1c          	sub    $0x1c,%rsp
  80051d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800521:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800524:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800528:	7e 52                	jle    80057c <getint+0x67>
		x=va_arg(*ap, long long);
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	8b 00                	mov    (%rax),%eax
  800530:	83 f8 30             	cmp    $0x30,%eax
  800533:	73 24                	jae    800559 <getint+0x44>
  800535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800539:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	89 c0                	mov    %eax,%eax
  800545:	48 01 d0             	add    %rdx,%rax
  800548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054c:	8b 12                	mov    (%rdx),%edx
  80054e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800555:	89 0a                	mov    %ecx,(%rdx)
  800557:	eb 17                	jmp    800570 <getint+0x5b>
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800561:	48 89 d0             	mov    %rdx,%rax
  800564:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800568:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800570:	48 8b 00             	mov    (%rax),%rax
  800573:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800577:	e9 a3 00 00 00       	jmpq   80061f <getint+0x10a>
	else if (lflag)
  80057c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800580:	74 4f                	je     8005d1 <getint+0xbc>
		x=va_arg(*ap, long);
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	83 f8 30             	cmp    $0x30,%eax
  80058b:	73 24                	jae    8005b1 <getint+0x9c>
  80058d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800591:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	89 c0                	mov    %eax,%eax
  80059d:	48 01 d0             	add    %rdx,%rax
  8005a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a4:	8b 12                	mov    (%rdx),%edx
  8005a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ad:	89 0a                	mov    %ecx,(%rdx)
  8005af:	eb 17                	jmp    8005c8 <getint+0xb3>
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b9:	48 89 d0             	mov    %rdx,%rax
  8005bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c8:	48 8b 00             	mov    (%rax),%rax
  8005cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005cf:	eb 4e                	jmp    80061f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	8b 00                	mov    (%rax),%eax
  8005d7:	83 f8 30             	cmp    $0x30,%eax
  8005da:	73 24                	jae    800600 <getint+0xeb>
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	8b 00                	mov    (%rax),%eax
  8005ea:	89 c0                	mov    %eax,%eax
  8005ec:	48 01 d0             	add    %rdx,%rax
  8005ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f3:	8b 12                	mov    (%rdx),%edx
  8005f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fc:	89 0a                	mov    %ecx,(%rdx)
  8005fe:	eb 17                	jmp    800617 <getint+0x102>
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800608:	48 89 d0             	mov    %rdx,%rax
  80060b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800613:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800617:	8b 00                	mov    (%rax),%eax
  800619:	48 98                	cltq   
  80061b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80061f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800623:	c9                   	leaveq 
  800624:	c3                   	retq   

0000000000800625 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	41 54                	push   %r12
  80062b:	53                   	push   %rbx
  80062c:	48 83 ec 60          	sub    $0x60,%rsp
  800630:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800634:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800638:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80063c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800640:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800644:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800648:	48 8b 0a             	mov    (%rdx),%rcx
  80064b:	48 89 08             	mov    %rcx,(%rax)
  80064e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800652:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800656:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	eb 17                	jmp    800677 <vprintfmt+0x52>
			if (ch == '\0')
  800660:	85 db                	test   %ebx,%ebx
  800662:	0f 84 cc 04 00 00    	je     800b34 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800668:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80066c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800670:	48 89 d6             	mov    %rdx,%rsi
  800673:	89 df                	mov    %ebx,%edi
  800675:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800677:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80067b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80067f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800683:	0f b6 00             	movzbl (%rax),%eax
  800686:	0f b6 d8             	movzbl %al,%ebx
  800689:	83 fb 25             	cmp    $0x25,%ebx
  80068c:	75 d2                	jne    800660 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80068e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800692:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800699:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006a7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ba:	0f b6 00             	movzbl (%rax),%eax
  8006bd:	0f b6 d8             	movzbl %al,%ebx
  8006c0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006c3:	83 f8 55             	cmp    $0x55,%eax
  8006c6:	0f 87 34 04 00 00    	ja     800b00 <vprintfmt+0x4db>
  8006cc:	89 c0                	mov    %eax,%eax
  8006ce:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006d5:	00 
  8006d6:	48 b8 30 36 80 00 00 	movabs $0x803630,%rax
  8006dd:	00 00 00 
  8006e0:	48 01 d0             	add    %rdx,%rax
  8006e3:	48 8b 00             	mov    (%rax),%rax
  8006e6:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006e8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ec:	eb c0                	jmp    8006ae <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006f2:	eb ba                	jmp    8006ae <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006fb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006fe:	89 d0                	mov    %edx,%eax
  800700:	c1 e0 02             	shl    $0x2,%eax
  800703:	01 d0                	add    %edx,%eax
  800705:	01 c0                	add    %eax,%eax
  800707:	01 d8                	add    %ebx,%eax
  800709:	83 e8 30             	sub    $0x30,%eax
  80070c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80070f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800713:	0f b6 00             	movzbl (%rax),%eax
  800716:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800719:	83 fb 2f             	cmp    $0x2f,%ebx
  80071c:	7e 0c                	jle    80072a <vprintfmt+0x105>
  80071e:	83 fb 39             	cmp    $0x39,%ebx
  800721:	7f 07                	jg     80072a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800723:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800728:	eb d1                	jmp    8006fb <vprintfmt+0xd6>
			goto process_precision;
  80072a:	eb 58                	jmp    800784 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80072c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072f:	83 f8 30             	cmp    $0x30,%eax
  800732:	73 17                	jae    80074b <vprintfmt+0x126>
  800734:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800738:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073b:	89 c0                	mov    %eax,%eax
  80073d:	48 01 d0             	add    %rdx,%rax
  800740:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800743:	83 c2 08             	add    $0x8,%edx
  800746:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800749:	eb 0f                	jmp    80075a <vprintfmt+0x135>
  80074b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80074f:	48 89 d0             	mov    %rdx,%rax
  800752:	48 83 c2 08          	add    $0x8,%rdx
  800756:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80075a:	8b 00                	mov    (%rax),%eax
  80075c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80075f:	eb 23                	jmp    800784 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800761:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800765:	79 0c                	jns    800773 <vprintfmt+0x14e>
				width = 0;
  800767:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80076e:	e9 3b ff ff ff       	jmpq   8006ae <vprintfmt+0x89>
  800773:	e9 36 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800778:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80077f:	e9 2a ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800784:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800788:	79 12                	jns    80079c <vprintfmt+0x177>
				width = precision, precision = -1;
  80078a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80078d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800790:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800797:	e9 12 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>
  80079c:	e9 0d ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007a5:	e9 04 ff ff ff       	jmpq   8006ae <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ad:	83 f8 30             	cmp    $0x30,%eax
  8007b0:	73 17                	jae    8007c9 <vprintfmt+0x1a4>
  8007b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b9:	89 c0                	mov    %eax,%eax
  8007bb:	48 01 d0             	add    %rdx,%rax
  8007be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c1:	83 c2 08             	add    $0x8,%edx
  8007c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c7:	eb 0f                	jmp    8007d8 <vprintfmt+0x1b3>
  8007c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007cd:	48 89 d0             	mov    %rdx,%rax
  8007d0:	48 83 c2 08          	add    $0x8,%rdx
  8007d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d8:	8b 10                	mov    (%rax),%edx
  8007da:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e2:	48 89 ce             	mov    %rcx,%rsi
  8007e5:	89 d7                	mov    %edx,%edi
  8007e7:	ff d0                	callq  *%rax
			break;
  8007e9:	e9 40 03 00 00       	jmpq   800b2e <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 17                	jae    80080d <vprintfmt+0x1e8>
  8007f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fd:	89 c0                	mov    %eax,%eax
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800805:	83 c2 08             	add    $0x8,%edx
  800808:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080b:	eb 0f                	jmp    80081c <vprintfmt+0x1f7>
  80080d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800811:	48 89 d0             	mov    %rdx,%rax
  800814:	48 83 c2 08          	add    $0x8,%rdx
  800818:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80081e:	85 db                	test   %ebx,%ebx
  800820:	79 02                	jns    800824 <vprintfmt+0x1ff>
				err = -err;
  800822:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800824:	83 fb 10             	cmp    $0x10,%ebx
  800827:	7f 16                	jg     80083f <vprintfmt+0x21a>
  800829:	48 b8 80 35 80 00 00 	movabs $0x803580,%rax
  800830:	00 00 00 
  800833:	48 63 d3             	movslq %ebx,%rdx
  800836:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80083a:	4d 85 e4             	test   %r12,%r12
  80083d:	75 2e                	jne    80086d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80083f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800843:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800847:	89 d9                	mov    %ebx,%ecx
  800849:	48 ba 19 36 80 00 00 	movabs $0x803619,%rdx
  800850:	00 00 00 
  800853:	48 89 c7             	mov    %rax,%rdi
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	49 b8 3d 0b 80 00 00 	movabs $0x800b3d,%r8
  800862:	00 00 00 
  800865:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800868:	e9 c1 02 00 00       	jmpq   800b2e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80086d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800871:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800875:	4c 89 e1             	mov    %r12,%rcx
  800878:	48 ba 22 36 80 00 00 	movabs $0x803622,%rdx
  80087f:	00 00 00 
  800882:	48 89 c7             	mov    %rax,%rdi
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
  80088a:	49 b8 3d 0b 80 00 00 	movabs $0x800b3d,%r8
  800891:	00 00 00 
  800894:	41 ff d0             	callq  *%r8
			break;
  800897:	e9 92 02 00 00       	jmpq   800b2e <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80089c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 17                	jae    8008bb <vprintfmt+0x296>
  8008a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	89 c0                	mov    %eax,%eax
  8008ad:	48 01 d0             	add    %rdx,%rax
  8008b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b3:	83 c2 08             	add    $0x8,%edx
  8008b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b9:	eb 0f                	jmp    8008ca <vprintfmt+0x2a5>
  8008bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bf:	48 89 d0             	mov    %rdx,%rax
  8008c2:	48 83 c2 08          	add    $0x8,%rdx
  8008c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ca:	4c 8b 20             	mov    (%rax),%r12
  8008cd:	4d 85 e4             	test   %r12,%r12
  8008d0:	75 0a                	jne    8008dc <vprintfmt+0x2b7>
				p = "(null)";
  8008d2:	49 bc 25 36 80 00 00 	movabs $0x803625,%r12
  8008d9:	00 00 00 
			if (width > 0 && padc != '-')
  8008dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e0:	7e 3f                	jle    800921 <vprintfmt+0x2fc>
  8008e2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008e6:	74 39                	je     800921 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008eb:	48 98                	cltq   
  8008ed:	48 89 c6             	mov    %rax,%rsi
  8008f0:	4c 89 e7             	mov    %r12,%rdi
  8008f3:	48 b8 e9 0d 80 00 00 	movabs $0x800de9,%rax
  8008fa:	00 00 00 
  8008fd:	ff d0                	callq  *%rax
  8008ff:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800902:	eb 17                	jmp    80091b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800904:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800908:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80090c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800910:	48 89 ce             	mov    %rcx,%rsi
  800913:	89 d7                	mov    %edx,%edi
  800915:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800917:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80091b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80091f:	7f e3                	jg     800904 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800921:	eb 37                	jmp    80095a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800923:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800927:	74 1e                	je     800947 <vprintfmt+0x322>
  800929:	83 fb 1f             	cmp    $0x1f,%ebx
  80092c:	7e 05                	jle    800933 <vprintfmt+0x30e>
  80092e:	83 fb 7e             	cmp    $0x7e,%ebx
  800931:	7e 14                	jle    800947 <vprintfmt+0x322>
					putch('?', putdat);
  800933:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800937:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093b:	48 89 d6             	mov    %rdx,%rsi
  80093e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800943:	ff d0                	callq  *%rax
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800947:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094f:	48 89 d6             	mov    %rdx,%rsi
  800952:	89 df                	mov    %ebx,%edi
  800954:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095a:	4c 89 e0             	mov    %r12,%rax
  80095d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800961:	0f b6 00             	movzbl (%rax),%eax
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 10                	je     80097b <vprintfmt+0x356>
  80096b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80096f:	78 b2                	js     800923 <vprintfmt+0x2fe>
  800971:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800975:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800979:	79 a8                	jns    800923 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097b:	eb 16                	jmp    800993 <vprintfmt+0x36e>
				putch(' ', putdat);
  80097d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800981:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800985:	48 89 d6             	mov    %rdx,%rsi
  800988:	bf 20 00 00 00       	mov    $0x20,%edi
  80098d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800993:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800997:	7f e4                	jg     80097d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800999:	e9 90 01 00 00       	jmpq   800b2e <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80099e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a2:	be 03 00 00 00       	mov    $0x3,%esi
  8009a7:	48 89 c7             	mov    %rax,%rdi
  8009aa:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  8009b1:	00 00 00 
  8009b4:	ff d0                	callq  *%rax
  8009b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	48 85 c0             	test   %rax,%rax
  8009c1:	79 1d                	jns    8009e0 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cb:	48 89 d6             	mov    %rdx,%rsi
  8009ce:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009d3:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	48 f7 d8             	neg    %rax
  8009dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e7:	e9 d5 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009ec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f0:	be 03 00 00 00       	mov    $0x3,%esi
  8009f5:	48 89 c7             	mov    %rax,%rdi
  8009f8:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  8009ff:	00 00 00 
  800a02:	ff d0                	callq  *%rax
  800a04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a08:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a0f:	e9 ad 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a14:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1b:	89 d6                	mov    %edx,%esi
  800a1d:	48 89 c7             	mov    %rax,%rdi
  800a20:	48 b8 15 05 80 00 00 	movabs $0x800515,%rax
  800a27:	00 00 00 
  800a2a:	ff d0                	callq  *%rax
  800a2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a30:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a37:	e9 85 00 00 00       	jmpq   800ac1 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800a3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a44:	48 89 d6             	mov    %rdx,%rsi
  800a47:	bf 30 00 00 00       	mov    $0x30,%edi
  800a4c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a56:	48 89 d6             	mov    %rdx,%rsi
  800a59:	bf 78 00 00 00       	mov    $0x78,%edi
  800a5e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a60:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a63:	83 f8 30             	cmp    $0x30,%eax
  800a66:	73 17                	jae    800a7f <vprintfmt+0x45a>
  800a68:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	89 c0                	mov    %eax,%eax
  800a71:	48 01 d0             	add    %rdx,%rax
  800a74:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a77:	83 c2 08             	add    $0x8,%edx
  800a7a:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7d:	eb 0f                	jmp    800a8e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a83:	48 89 d0             	mov    %rdx,%rax
  800a86:	48 83 c2 08          	add    $0x8,%rdx
  800a8a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8e:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a95:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a9e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa2:	be 03 00 00 00       	mov    $0x3,%esi
  800aa7:	48 89 c7             	mov    %rax,%rdi
  800aaa:	48 b8 05 04 80 00 00 	movabs $0x800405,%rax
  800ab1:	00 00 00 
  800ab4:	ff d0                	callq  *%rax
  800ab6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aba:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ac6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800acc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad8:	45 89 c1             	mov    %r8d,%r9d
  800adb:	41 89 f8             	mov    %edi,%r8d
  800ade:	48 89 c7             	mov    %rax,%rdi
  800ae1:	48 b8 4a 03 80 00 00 	movabs $0x80034a,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
			break;
  800aed:	eb 3f                	jmp    800b2e <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af7:	48 89 d6             	mov    %rdx,%rsi
  800afa:	89 df                	mov    %ebx,%edi
  800afc:	ff d0                	callq  *%rax
			break;
  800afe:	eb 2e                	jmp    800b2e <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b08:	48 89 d6             	mov    %rdx,%rsi
  800b0b:	bf 25 00 00 00       	mov    $0x25,%edi
  800b10:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b17:	eb 05                	jmp    800b1e <vprintfmt+0x4f9>
  800b19:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b22:	48 83 e8 01          	sub    $0x1,%rax
  800b26:	0f b6 00             	movzbl (%rax),%eax
  800b29:	3c 25                	cmp    $0x25,%al
  800b2b:	75 ec                	jne    800b19 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b2d:	90                   	nop
		}
	}
  800b2e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2f:	e9 43 fb ff ff       	jmpq   800677 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800b34:	48 83 c4 60          	add    $0x60,%rsp
  800b38:	5b                   	pop    %rbx
  800b39:	41 5c                	pop    %r12
  800b3b:	5d                   	pop    %rbp
  800b3c:	c3                   	retq   

0000000000800b3d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b3d:	55                   	push   %rbp
  800b3e:	48 89 e5             	mov    %rsp,%rbp
  800b41:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b48:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b4f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b6b:	84 c0                	test   %al,%al
  800b6d:	74 20                	je     800b8f <printfmt+0x52>
  800b6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b8f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b96:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b9d:	00 00 00 
  800ba0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ba7:	00 00 00 
  800baa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bb5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bbc:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bca:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bd1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bd8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bdf:	48 89 c7             	mov    %rax,%rdi
  800be2:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800be9:	00 00 00 
  800bec:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bee:	c9                   	leaveq 
  800bef:	c3                   	retq   

0000000000800bf0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf0:	55                   	push   %rbp
  800bf1:	48 89 e5             	mov    %rsp,%rbp
  800bf4:	48 83 ec 10          	sub    $0x10,%rsp
  800bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c03:	8b 40 10             	mov    0x10(%rax),%eax
  800c06:	8d 50 01             	lea    0x1(%rax),%edx
  800c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c14:	48 8b 10             	mov    (%rax),%rdx
  800c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c1f:	48 39 c2             	cmp    %rax,%rdx
  800c22:	73 17                	jae    800c3b <sprintputch+0x4b>
		*b->buf++ = ch;
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	48 8b 00             	mov    (%rax),%rax
  800c2b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c33:	48 89 0a             	mov    %rcx,(%rdx)
  800c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c39:	88 10                	mov    %dl,(%rax)
}
  800c3b:	c9                   	leaveq 
  800c3c:	c3                   	retq   

0000000000800c3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c3d:	55                   	push   %rbp
  800c3e:	48 89 e5             	mov    %rsp,%rbp
  800c41:	48 83 ec 50          	sub    $0x50,%rsp
  800c45:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c49:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c4c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c50:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c54:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c58:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c5c:	48 8b 0a             	mov    (%rdx),%rcx
  800c5f:	48 89 08             	mov    %rcx,(%rax)
  800c62:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c66:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c6a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c6e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c76:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c7a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c7d:	48 98                	cltq   
  800c7f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c87:	48 01 d0             	add    %rdx,%rax
  800c8a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c8e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c95:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c9a:	74 06                	je     800ca2 <vsnprintf+0x65>
  800c9c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ca0:	7f 07                	jg     800ca9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ca2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca7:	eb 2f                	jmp    800cd8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ca9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cad:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cb1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cb5:	48 89 c6             	mov    %rax,%rsi
  800cb8:	48 bf f0 0b 80 00 00 	movabs $0x800bf0,%rdi
  800cbf:	00 00 00 
  800cc2:	48 b8 25 06 80 00 00 	movabs $0x800625,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cd2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cd5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cd8:	c9                   	leaveq 
  800cd9:	c3                   	retq   

0000000000800cda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cda:	55                   	push   %rbp
  800cdb:	48 89 e5             	mov    %rsp,%rbp
  800cde:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ce5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cec:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cf2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d00:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d07:	84 c0                	test   %al,%al
  800d09:	74 20                	je     800d2b <snprintf+0x51>
  800d0b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d0f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d13:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d17:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d1b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d1f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d23:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d27:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d2b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d32:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d39:	00 00 00 
  800d3c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d43:	00 00 00 
  800d46:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d4a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d51:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d58:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d5f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d66:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d6d:	48 8b 0a             	mov    (%rdx),%rcx
  800d70:	48 89 08             	mov    %rcx,(%rax)
  800d73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d83:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d8a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d91:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d97:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d9e:	48 89 c7             	mov    %rax,%rdi
  800da1:	48 b8 3d 0c 80 00 00 	movabs $0x800c3d,%rax
  800da8:	00 00 00 
  800dab:	ff d0                	callq  *%rax
  800dad:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800db3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800db9:	c9                   	leaveq 
  800dba:	c3                   	retq   

0000000000800dbb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dbb:	55                   	push   %rbp
  800dbc:	48 89 e5             	mov    %rsp,%rbp
  800dbf:	48 83 ec 18          	sub    $0x18,%rsp
  800dc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dce:	eb 09                	jmp    800dd9 <strlen+0x1e>
		n++;
  800dd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddd:	0f b6 00             	movzbl (%rax),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	75 ec                	jne    800dd0 <strlen+0x15>
		n++;
	return n;
  800de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800de7:	c9                   	leaveq 
  800de8:	c3                   	retq   

0000000000800de9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800de9:	55                   	push   %rbp
  800dea:	48 89 e5             	mov    %rsp,%rbp
  800ded:	48 83 ec 20          	sub    $0x20,%rsp
  800df1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800df5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e00:	eb 0e                	jmp    800e10 <strnlen+0x27>
		n++;
  800e02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e0b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e10:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e15:	74 0b                	je     800e22 <strnlen+0x39>
  800e17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1b:	0f b6 00             	movzbl (%rax),%eax
  800e1e:	84 c0                	test   %al,%al
  800e20:	75 e0                	jne    800e02 <strnlen+0x19>
		n++;
	return n;
  800e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 20          	sub    $0x20,%rsp
  800e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e3f:	90                   	nop
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e48:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e4c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e50:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e54:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e58:	0f b6 12             	movzbl (%rdx),%edx
  800e5b:	88 10                	mov    %dl,(%rax)
  800e5d:	0f b6 00             	movzbl (%rax),%eax
  800e60:	84 c0                	test   %al,%al
  800e62:	75 dc                	jne    800e40 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e68:	c9                   	leaveq 
  800e69:	c3                   	retq   

0000000000800e6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e6a:	55                   	push   %rbp
  800e6b:	48 89 e5             	mov    %rsp,%rbp
  800e6e:	48 83 ec 20          	sub    $0x20,%rsp
  800e72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	48 89 c7             	mov    %rax,%rdi
  800e81:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  800e88:	00 00 00 
  800e8b:	ff d0                	callq  *%rax
  800e8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e93:	48 63 d0             	movslq %eax,%rdx
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	48 01 c2             	add    %rax,%rdx
  800e9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea1:	48 89 c6             	mov    %rax,%rsi
  800ea4:	48 89 d7             	mov    %rdx,%rdi
  800ea7:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  800eae:	00 00 00 
  800eb1:	ff d0                	callq  *%rax
	return dst;
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eb7:	c9                   	leaveq 
  800eb8:	c3                   	retq   

0000000000800eb9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb9:	55                   	push   %rbp
  800eba:	48 89 e5             	mov    %rsp,%rbp
  800ebd:	48 83 ec 28          	sub    $0x28,%rsp
  800ec1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ec9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ed5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800edc:	00 
  800edd:	eb 2a                	jmp    800f09 <strncpy+0x50>
		*dst++ = *src;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ee7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eeb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eef:	0f b6 12             	movzbl (%rdx),%edx
  800ef2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef8:	0f b6 00             	movzbl (%rax),%eax
  800efb:	84 c0                	test   %al,%al
  800efd:	74 05                	je     800f04 <strncpy+0x4b>
			src++;
  800eff:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f04:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f0d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f11:	72 cc                	jb     800edf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f17:	c9                   	leaveq 
  800f18:	c3                   	retq   

0000000000800f19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f19:	55                   	push   %rbp
  800f1a:	48 89 e5             	mov    %rsp,%rbp
  800f1d:	48 83 ec 28          	sub    $0x28,%rsp
  800f21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f3a:	74 3d                	je     800f79 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f3c:	eb 1d                	jmp    800f5b <strlcpy+0x42>
			*dst++ = *src++;
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f52:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f56:	0f b6 12             	movzbl (%rdx),%edx
  800f59:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f60:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f65:	74 0b                	je     800f72 <strlcpy+0x59>
  800f67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6b:	0f b6 00             	movzbl (%rax),%eax
  800f6e:	84 c0                	test   %al,%al
  800f70:	75 cc                	jne    800f3e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f81:	48 29 c2             	sub    %rax,%rdx
  800f84:	48 89 d0             	mov    %rdx,%rax
}
  800f87:	c9                   	leaveq 
  800f88:	c3                   	retq   

0000000000800f89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f89:	55                   	push   %rbp
  800f8a:	48 89 e5             	mov    %rsp,%rbp
  800f8d:	48 83 ec 10          	sub    $0x10,%rsp
  800f91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f99:	eb 0a                	jmp    800fa5 <strcmp+0x1c>
		p++, q++;
  800f9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa9:	0f b6 00             	movzbl (%rax),%eax
  800fac:	84 c0                	test   %al,%al
  800fae:	74 12                	je     800fc2 <strcmp+0x39>
  800fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb4:	0f b6 10             	movzbl (%rax),%edx
  800fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbb:	0f b6 00             	movzbl (%rax),%eax
  800fbe:	38 c2                	cmp    %al,%dl
  800fc0:	74 d9                	je     800f9b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc6:	0f b6 00             	movzbl (%rax),%eax
  800fc9:	0f b6 d0             	movzbl %al,%edx
  800fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd0:	0f b6 00             	movzbl (%rax),%eax
  800fd3:	0f b6 c0             	movzbl %al,%eax
  800fd6:	29 c2                	sub    %eax,%edx
  800fd8:	89 d0                	mov    %edx,%eax
}
  800fda:	c9                   	leaveq 
  800fdb:	c3                   	retq   

0000000000800fdc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fdc:	55                   	push   %rbp
  800fdd:	48 89 e5             	mov    %rsp,%rbp
  800fe0:	48 83 ec 18          	sub    $0x18,%rsp
  800fe4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ff0:	eb 0f                	jmp    801001 <strncmp+0x25>
		n--, p++, q++;
  800ff2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ff7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ffc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801001:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801006:	74 1d                	je     801025 <strncmp+0x49>
  801008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100c:	0f b6 00             	movzbl (%rax),%eax
  80100f:	84 c0                	test   %al,%al
  801011:	74 12                	je     801025 <strncmp+0x49>
  801013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801017:	0f b6 10             	movzbl (%rax),%edx
  80101a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101e:	0f b6 00             	movzbl (%rax),%eax
  801021:	38 c2                	cmp    %al,%dl
  801023:	74 cd                	je     800ff2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801025:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80102a:	75 07                	jne    801033 <strncmp+0x57>
		return 0;
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
  801031:	eb 18                	jmp    80104b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	0f b6 d0             	movzbl %al,%edx
  80103d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801041:	0f b6 00             	movzbl (%rax),%eax
  801044:	0f b6 c0             	movzbl %al,%eax
  801047:	29 c2                	sub    %eax,%edx
  801049:	89 d0                	mov    %edx,%eax
}
  80104b:	c9                   	leaveq 
  80104c:	c3                   	retq   

000000000080104d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104d:	55                   	push   %rbp
  80104e:	48 89 e5             	mov    %rsp,%rbp
  801051:	48 83 ec 0c          	sub    $0xc,%rsp
  801055:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801059:	89 f0                	mov    %esi,%eax
  80105b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80105e:	eb 17                	jmp    801077 <strchr+0x2a>
		if (*s == c)
  801060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801064:	0f b6 00             	movzbl (%rax),%eax
  801067:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80106a:	75 06                	jne    801072 <strchr+0x25>
			return (char *) s;
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801070:	eb 15                	jmp    801087 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801072:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107b:	0f b6 00             	movzbl (%rax),%eax
  80107e:	84 c0                	test   %al,%al
  801080:	75 de                	jne    801060 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 0c          	sub    $0xc,%rsp
  801091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801095:	89 f0                	mov    %esi,%eax
  801097:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109a:	eb 13                	jmp    8010af <strfind+0x26>
		if (*s == c)
  80109c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a0:	0f b6 00             	movzbl (%rax),%eax
  8010a3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a6:	75 02                	jne    8010aa <strfind+0x21>
			break;
  8010a8:	eb 10                	jmp    8010ba <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b3:	0f b6 00             	movzbl (%rax),%eax
  8010b6:	84 c0                	test   %al,%al
  8010b8:	75 e2                	jne    80109c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 18          	sub    $0x18,%rsp
  8010c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d8:	75 06                	jne    8010e0 <memset+0x20>
		return v;
  8010da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010de:	eb 69                	jmp    801149 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	83 e0 03             	and    $0x3,%eax
  8010e7:	48 85 c0             	test   %rax,%rax
  8010ea:	75 48                	jne    801134 <memset+0x74>
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	83 e0 03             	and    $0x3,%eax
  8010f3:	48 85 c0             	test   %rax,%rax
  8010f6:	75 3c                	jne    801134 <memset+0x74>
		c &= 0xFF;
  8010f8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801102:	c1 e0 18             	shl    $0x18,%eax
  801105:	89 c2                	mov    %eax,%edx
  801107:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110a:	c1 e0 10             	shl    $0x10,%eax
  80110d:	09 c2                	or     %eax,%edx
  80110f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801112:	c1 e0 08             	shl    $0x8,%eax
  801115:	09 d0                	or     %edx,%eax
  801117:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 c1 e8 02          	shr    $0x2,%rax
  801122:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801125:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801129:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112c:	48 89 d7             	mov    %rdx,%rdi
  80112f:	fc                   	cld    
  801130:	f3 ab                	rep stos %eax,%es:(%rdi)
  801132:	eb 11                	jmp    801145 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801134:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801138:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80113f:	48 89 d7             	mov    %rdx,%rdi
  801142:	fc                   	cld    
  801143:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801149:	c9                   	leaveq 
  80114a:	c3                   	retq   

000000000080114b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	48 83 ec 28          	sub    $0x28,%rsp
  801153:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801157:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80115f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801173:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801177:	0f 83 88 00 00 00    	jae    801205 <memmove+0xba>
  80117d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801181:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801185:	48 01 d0             	add    %rdx,%rax
  801188:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80118c:	76 77                	jbe    801205 <memmove+0xba>
		s += n;
  80118e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801192:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801196:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80119e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a2:	83 e0 03             	and    $0x3,%eax
  8011a5:	48 85 c0             	test   %rax,%rax
  8011a8:	75 3b                	jne    8011e5 <memmove+0x9a>
  8011aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ae:	83 e0 03             	and    $0x3,%eax
  8011b1:	48 85 c0             	test   %rax,%rax
  8011b4:	75 2f                	jne    8011e5 <memmove+0x9a>
  8011b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ba:	83 e0 03             	and    $0x3,%eax
  8011bd:	48 85 c0             	test   %rax,%rax
  8011c0:	75 23                	jne    8011e5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c6:	48 83 e8 04          	sub    $0x4,%rax
  8011ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ce:	48 83 ea 04          	sub    $0x4,%rdx
  8011d2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011d6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011da:	48 89 c7             	mov    %rax,%rdi
  8011dd:	48 89 d6             	mov    %rdx,%rsi
  8011e0:	fd                   	std    
  8011e1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011e3:	eb 1d                	jmp    801202 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f9:	48 89 d7             	mov    %rdx,%rdi
  8011fc:	48 89 c1             	mov    %rax,%rcx
  8011ff:	fd                   	std    
  801200:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801202:	fc                   	cld    
  801203:	eb 57                	jmp    80125c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	83 e0 03             	and    $0x3,%eax
  80120c:	48 85 c0             	test   %rax,%rax
  80120f:	75 36                	jne    801247 <memmove+0xfc>
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	83 e0 03             	and    $0x3,%eax
  801218:	48 85 c0             	test   %rax,%rax
  80121b:	75 2a                	jne    801247 <memmove+0xfc>
  80121d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 1e                	jne    801247 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801229:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122d:	48 c1 e8 02          	shr    $0x2,%rax
  801231:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123c:	48 89 c7             	mov    %rax,%rdi
  80123f:	48 89 d6             	mov    %rdx,%rsi
  801242:	fc                   	cld    
  801243:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801245:	eb 15                	jmp    80125c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801253:	48 89 c7             	mov    %rax,%rdi
  801256:	48 89 d6             	mov    %rdx,%rsi
  801259:	fc                   	cld    
  80125a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80125c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 18          	sub    $0x18,%rsp
  80126a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801272:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80127e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801282:	48 89 ce             	mov    %rcx,%rsi
  801285:	48 89 c7             	mov    %rax,%rdi
  801288:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  80128f:	00 00 00 
  801292:	ff d0                	callq  *%rax
}
  801294:	c9                   	leaveq 
  801295:	c3                   	retq   

0000000000801296 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801296:	55                   	push   %rbp
  801297:	48 89 e5             	mov    %rsp,%rbp
  80129a:	48 83 ec 28          	sub    $0x28,%rsp
  80129e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012ba:	eb 36                	jmp    8012f2 <memcmp+0x5c>
		if (*s1 != *s2)
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	0f b6 10             	movzbl (%rax),%edx
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	38 c2                	cmp    %al,%dl
  8012cc:	74 1a                	je     8012e8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	0f b6 d0             	movzbl %al,%edx
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	0f b6 c0             	movzbl %al,%eax
  8012e2:	29 c2                	sub    %eax,%edx
  8012e4:	89 d0                	mov    %edx,%eax
  8012e6:	eb 20                	jmp    801308 <memcmp+0x72>
		s1++, s2++;
  8012e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012fe:	48 85 c0             	test   %rax,%rax
  801301:	75 b9                	jne    8012bc <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 28          	sub    $0x28,%rsp
  801312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801316:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801319:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80131d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801321:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801325:	48 01 d0             	add    %rdx,%rax
  801328:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80132c:	eb 15                	jmp    801343 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	0f b6 10             	movzbl (%rax),%edx
  801335:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801338:	38 c2                	cmp    %al,%dl
  80133a:	75 02                	jne    80133e <memfind+0x34>
			break;
  80133c:	eb 0f                	jmp    80134d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80134b:	72 e1                	jb     80132e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 34          	sub    $0x34,%rsp
  80135b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80135f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801363:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80136d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801374:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801375:	eb 05                	jmp    80137c <strtol+0x29>
		s++;
  801377:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f0                	je     801377 <strtol+0x24>
  801387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	3c 09                	cmp    $0x9,%al
  801390:	74 e5                	je     801377 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	3c 2b                	cmp    $0x2b,%al
  80139b:	75 07                	jne    8013a4 <strtol+0x51>
		s++;
  80139d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a2:	eb 17                	jmp    8013bb <strtol+0x68>
	else if (*s == '-')
  8013a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a8:	0f b6 00             	movzbl (%rax),%eax
  8013ab:	3c 2d                	cmp    $0x2d,%al
  8013ad:	75 0c                	jne    8013bb <strtol+0x68>
		s++, neg = 1;
  8013af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013bf:	74 06                	je     8013c7 <strtol+0x74>
  8013c1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013c5:	75 28                	jne    8013ef <strtol+0x9c>
  8013c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	3c 30                	cmp    $0x30,%al
  8013d0:	75 1d                	jne    8013ef <strtol+0x9c>
  8013d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d6:	48 83 c0 01          	add    $0x1,%rax
  8013da:	0f b6 00             	movzbl (%rax),%eax
  8013dd:	3c 78                	cmp    $0x78,%al
  8013df:	75 0e                	jne    8013ef <strtol+0x9c>
		s += 2, base = 16;
  8013e1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013e6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013ed:	eb 2c                	jmp    80141b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f3:	75 19                	jne    80140e <strtol+0xbb>
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	0f b6 00             	movzbl (%rax),%eax
  8013fc:	3c 30                	cmp    $0x30,%al
  8013fe:	75 0e                	jne    80140e <strtol+0xbb>
		s++, base = 8;
  801400:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801405:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80140c:	eb 0d                	jmp    80141b <strtol+0xc8>
	else if (base == 0)
  80140e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801412:	75 07                	jne    80141b <strtol+0xc8>
		base = 10;
  801414:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80141b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	3c 2f                	cmp    $0x2f,%al
  801424:	7e 1d                	jle    801443 <strtol+0xf0>
  801426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	3c 39                	cmp    $0x39,%al
  80142f:	7f 12                	jg     801443 <strtol+0xf0>
			dig = *s - '0';
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	0f be c0             	movsbl %al,%eax
  80143b:	83 e8 30             	sub    $0x30,%eax
  80143e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801441:	eb 4e                	jmp    801491 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	3c 60                	cmp    $0x60,%al
  80144c:	7e 1d                	jle    80146b <strtol+0x118>
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	3c 7a                	cmp    $0x7a,%al
  801457:	7f 12                	jg     80146b <strtol+0x118>
			dig = *s - 'a' + 10;
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 57             	sub    $0x57,%eax
  801466:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801469:	eb 26                	jmp    801491 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80146b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146f:	0f b6 00             	movzbl (%rax),%eax
  801472:	3c 40                	cmp    $0x40,%al
  801474:	7e 48                	jle    8014be <strtol+0x16b>
  801476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	3c 5a                	cmp    $0x5a,%al
  80147f:	7f 3d                	jg     8014be <strtol+0x16b>
			dig = *s - 'A' + 10;
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	0f be c0             	movsbl %al,%eax
  80148b:	83 e8 37             	sub    $0x37,%eax
  80148e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801494:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801497:	7c 02                	jl     80149b <strtol+0x148>
			break;
  801499:	eb 23                	jmp    8014be <strtol+0x16b>
		s++, val = (val * base) + dig;
  80149b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014a3:	48 98                	cltq   
  8014a5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014aa:	48 89 c2             	mov    %rax,%rdx
  8014ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014b0:	48 98                	cltq   
  8014b2:	48 01 d0             	add    %rdx,%rax
  8014b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014b9:	e9 5d ff ff ff       	jmpq   80141b <strtol+0xc8>

	if (endptr)
  8014be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014c3:	74 0b                	je     8014d0 <strtol+0x17d>
		*endptr = (char *) s;
  8014c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014cd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d4:	74 09                	je     8014df <strtol+0x18c>
  8014d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014da:	48 f7 d8             	neg    %rax
  8014dd:	eb 04                	jmp    8014e3 <strtol+0x190>
  8014df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e3:	c9                   	leaveq 
  8014e4:	c3                   	retq   

00000000008014e5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014e5:	55                   	push   %rbp
  8014e6:	48 89 e5             	mov    %rsp,%rbp
  8014e9:	48 83 ec 30          	sub    $0x30,%rsp
  8014ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8014f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014fd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801501:	0f b6 00             	movzbl (%rax),%eax
  801504:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801507:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80150b:	75 06                	jne    801513 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	eb 6b                	jmp    80157e <strstr+0x99>

    len = strlen(str);
  801513:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801517:	48 89 c7             	mov    %rax,%rdi
  80151a:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  801521:	00 00 00 
  801524:	ff d0                	callq  *%rax
  801526:	48 98                	cltq   
  801528:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801534:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80153e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801542:	75 07                	jne    80154b <strstr+0x66>
                return (char *) 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 33                	jmp    80157e <strstr+0x99>
        } while (sc != c);
  80154b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80154f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801552:	75 d8                	jne    80152c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801558:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	48 89 ce             	mov    %rcx,%rsi
  801563:	48 89 c7             	mov    %rax,%rdi
  801566:	48 b8 dc 0f 80 00 00 	movabs $0x800fdc,%rax
  80156d:	00 00 00 
  801570:	ff d0                	callq  *%rax
  801572:	85 c0                	test   %eax,%eax
  801574:	75 b6                	jne    80152c <strstr+0x47>

    return (char *) (in - 1);
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	48 83 e8 01          	sub    $0x1,%rax
}
  80157e:	c9                   	leaveq 
  80157f:	c3                   	retq   

0000000000801580 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801580:	55                   	push   %rbp
  801581:	48 89 e5             	mov    %rsp,%rbp
  801584:	53                   	push   %rbx
  801585:	48 83 ec 48          	sub    $0x48,%rsp
  801589:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80158c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80158f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801593:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801597:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80159b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80159f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015a6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015aa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015ae:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015b2:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015b6:	4c 89 c3             	mov    %r8,%rbx
  8015b9:	cd 30                	int    $0x30
  8015bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015c3:	74 3e                	je     801603 <syscall+0x83>
  8015c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ca:	7e 37                	jle    801603 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d3:	49 89 d0             	mov    %rdx,%r8
  8015d6:	89 c1                	mov    %eax,%ecx
  8015d8:	48 ba e0 38 80 00 00 	movabs $0x8038e0,%rdx
  8015df:	00 00 00 
  8015e2:	be 23 00 00 00       	mov    $0x23,%esi
  8015e7:	48 bf fd 38 80 00 00 	movabs $0x8038fd,%rdi
  8015ee:	00 00 00 
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	49 b9 68 30 80 00 00 	movabs $0x803068,%r9
  8015fd:	00 00 00 
  801600:	41 ff d1             	callq  *%r9

	return ret;
  801603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801607:	48 83 c4 48          	add    $0x48,%rsp
  80160b:	5b                   	pop    %rbx
  80160c:	5d                   	pop    %rbp
  80160d:	c3                   	retq   

000000000080160e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80160e:	55                   	push   %rbp
  80160f:	48 89 e5             	mov    %rsp,%rbp
  801612:	48 83 ec 20          	sub    $0x20,%rsp
  801616:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801626:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80162d:	00 
  80162e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801634:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80163a:	48 89 d1             	mov    %rdx,%rcx
  80163d:	48 89 c2             	mov    %rax,%rdx
  801640:	be 00 00 00 00       	mov    $0x0,%esi
  801645:	bf 00 00 00 00       	mov    $0x0,%edi
  80164a:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801651:	00 00 00 
  801654:	ff d0                	callq  *%rax
}
  801656:	c9                   	leaveq 
  801657:	c3                   	retq   

0000000000801658 <sys_cgetc>:

int
sys_cgetc(void)
{
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801660:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801667:	00 
  801668:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801674:	b9 00 00 00 00       	mov    $0x0,%ecx
  801679:	ba 00 00 00 00       	mov    $0x0,%edx
  80167e:	be 00 00 00 00       	mov    $0x0,%esi
  801683:	bf 01 00 00 00       	mov    $0x1,%edi
  801688:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80168f:	00 00 00 
  801692:	ff d0                	callq  *%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	48 83 ec 10          	sub    $0x10,%rsp
  80169e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a4:	48 98                	cltq   
  8016a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ad:	00 
  8016ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bf:	48 89 c2             	mov    %rax,%rdx
  8016c2:	be 01 00 00 00       	mov    $0x1,%esi
  8016c7:	bf 03 00 00 00       	mov    $0x3,%edi
  8016cc:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8016d3:	00 00 00 
  8016d6:	ff d0                	callq  *%rax
}
  8016d8:	c9                   	leaveq 
  8016d9:	c3                   	retq   

00000000008016da <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016da:	55                   	push   %rbp
  8016db:	48 89 e5             	mov    %rsp,%rbp
  8016de:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016e2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e9:	00 
  8016ea:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801700:	be 00 00 00 00       	mov    $0x0,%esi
  801705:	bf 02 00 00 00       	mov    $0x2,%edi
  80170a:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801711:	00 00 00 
  801714:	ff d0                	callq  *%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <sys_yield>:

void
sys_yield(void)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801720:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801727:	00 
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	b9 00 00 00 00       	mov    $0x0,%ecx
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	be 00 00 00 00       	mov    $0x0,%esi
  801743:	bf 0b 00 00 00       	mov    $0xb,%edi
  801748:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80174f:	00 00 00 
  801752:	ff d0                	callq  *%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 20          	sub    $0x20,%rsp
  80175e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801761:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801765:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801768:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80176b:	48 63 c8             	movslq %eax,%rcx
  80176e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801772:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801775:	48 98                	cltq   
  801777:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177e:	00 
  80177f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801785:	49 89 c8             	mov    %rcx,%r8
  801788:	48 89 d1             	mov    %rdx,%rcx
  80178b:	48 89 c2             	mov    %rax,%rdx
  80178e:	be 01 00 00 00       	mov    $0x1,%esi
  801793:	bf 04 00 00 00       	mov    $0x4,%edi
  801798:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80179f:	00 00 00 
  8017a2:	ff d0                	callq  *%rax
}
  8017a4:	c9                   	leaveq 
  8017a5:	c3                   	retq   

00000000008017a6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017a6:	55                   	push   %rbp
  8017a7:	48 89 e5             	mov    %rsp,%rbp
  8017aa:	48 83 ec 30          	sub    $0x30,%rsp
  8017ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017b5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017b8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017bc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c3:	48 63 c8             	movslq %eax,%rcx
  8017c6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017cd:	48 63 f0             	movslq %eax,%rsi
  8017d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d7:	48 98                	cltq   
  8017d9:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017dd:	49 89 f9             	mov    %rdi,%r9
  8017e0:	49 89 f0             	mov    %rsi,%r8
  8017e3:	48 89 d1             	mov    %rdx,%rcx
  8017e6:	48 89 c2             	mov    %rax,%rdx
  8017e9:	be 01 00 00 00       	mov    $0x1,%esi
  8017ee:	bf 05 00 00 00       	mov    $0x5,%edi
  8017f3:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8017fa:	00 00 00 
  8017fd:	ff d0                	callq  *%rax
}
  8017ff:	c9                   	leaveq 
  801800:	c3                   	retq   

0000000000801801 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801801:	55                   	push   %rbp
  801802:	48 89 e5             	mov    %rsp,%rbp
  801805:	48 83 ec 20          	sub    $0x20,%rsp
  801809:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801810:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801814:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801817:	48 98                	cltq   
  801819:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801820:	00 
  801821:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801827:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182d:	48 89 d1             	mov    %rdx,%rcx
  801830:	48 89 c2             	mov    %rax,%rdx
  801833:	be 01 00 00 00       	mov    $0x1,%esi
  801838:	bf 06 00 00 00       	mov    $0x6,%edi
  80183d:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
}
  801849:	c9                   	leaveq 
  80184a:	c3                   	retq   

000000000080184b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	48 83 ec 10          	sub    $0x10,%rsp
  801853:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801856:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801859:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80185c:	48 63 d0             	movslq %eax,%rdx
  80185f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801862:	48 98                	cltq   
  801864:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186b:	00 
  80186c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801872:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801878:	48 89 d1             	mov    %rdx,%rcx
  80187b:	48 89 c2             	mov    %rax,%rdx
  80187e:	be 01 00 00 00       	mov    $0x1,%esi
  801883:	bf 08 00 00 00       	mov    $0x8,%edi
  801888:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 20          	sub    $0x20,%rsp
  80189e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c2:	48 89 d1             	mov    %rdx,%rcx
  8018c5:	48 89 c2             	mov    %rax,%rdx
  8018c8:	be 01 00 00 00       	mov    $0x1,%esi
  8018cd:	bf 09 00 00 00       	mov    $0x9,%edi
  8018d2:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f6:	48 98                	cltq   
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	48 89 d1             	mov    %rdx,%rcx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 01 00 00 00       	mov    $0x1,%esi
  801917:	bf 0a 00 00 00       	mov    $0xa,%edi
  80191c:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 20          	sub    $0x20,%rsp
  801932:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801935:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801939:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80193d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801943:	48 63 f0             	movslq %eax,%rsi
  801946:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	48 98                	cltq   
  80194f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801953:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195a:	00 
  80195b:	49 89 f1             	mov    %rsi,%r9
  80195e:	49 89 c8             	mov    %rcx,%r8
  801961:	48 89 d1             	mov    %rdx,%rcx
  801964:	48 89 c2             	mov    %rax,%rdx
  801967:	be 00 00 00 00       	mov    $0x0,%esi
  80196c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801971:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  801978:	00 00 00 
  80197b:	ff d0                	callq  *%rax
}
  80197d:	c9                   	leaveq 
  80197e:	c3                   	retq   

000000000080197f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80197f:	55                   	push   %rbp
  801980:	48 89 e5             	mov    %rsp,%rbp
  801983:	48 83 ec 10          	sub    $0x10,%rsp
  801987:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80198b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801996:	00 
  801997:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a8:	48 89 c2             	mov    %rax,%rdx
  8019ab:	be 01 00 00 00       	mov    $0x1,%esi
  8019b0:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019b5:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	callq  *%rax
}
  8019c1:	c9                   	leaveq 
  8019c2:	c3                   	retq   

00000000008019c3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019c3:	55                   	push   %rbp
  8019c4:	48 89 e5             	mov    %rsp,%rbp
  8019c7:	48 83 ec 08          	sub    $0x8,%rsp
  8019cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019da:	ff ff ff 
  8019dd:	48 01 d0             	add    %rdx,%rax
  8019e0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 08          	sub    $0x8,%rsp
  8019ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8019f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f6:	48 89 c7             	mov    %rax,%rdi
  8019f9:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  801a00:	00 00 00 
  801a03:	ff d0                	callq  *%rax
  801a05:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a0b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a0f:	c9                   	leaveq 
  801a10:	c3                   	retq   

0000000000801a11 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a11:	55                   	push   %rbp
  801a12:	48 89 e5             	mov    %rsp,%rbp
  801a15:	48 83 ec 18          	sub    $0x18,%rsp
  801a19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a24:	eb 6b                	jmp    801a91 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a29:	48 98                	cltq   
  801a2b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a31:	48 c1 e0 0c          	shl    $0xc,%rax
  801a35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a3d:	48 c1 e8 15          	shr    $0x15,%rax
  801a41:	48 89 c2             	mov    %rax,%rdx
  801a44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a4b:	01 00 00 
  801a4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a52:	83 e0 01             	and    $0x1,%eax
  801a55:	48 85 c0             	test   %rax,%rax
  801a58:	74 21                	je     801a7b <fd_alloc+0x6a>
  801a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5e:	48 c1 e8 0c          	shr    $0xc,%rax
  801a62:	48 89 c2             	mov    %rax,%rdx
  801a65:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a6c:	01 00 00 
  801a6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a73:	83 e0 01             	and    $0x1,%eax
  801a76:	48 85 c0             	test   %rax,%rax
  801a79:	75 12                	jne    801a8d <fd_alloc+0x7c>
			*fd_store = fd;
  801a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a83:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	eb 1a                	jmp    801aa7 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a91:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801a95:	7e 8f                	jle    801a26 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801aa2:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801aa7:	c9                   	leaveq 
  801aa8:	c3                   	retq   

0000000000801aa9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801aa9:	55                   	push   %rbp
  801aaa:	48 89 e5             	mov    %rsp,%rbp
  801aad:	48 83 ec 20          	sub    $0x20,%rsp
  801ab1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ab4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ab8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801abc:	78 06                	js     801ac4 <fd_lookup+0x1b>
  801abe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ac2:	7e 07                	jle    801acb <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ac4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac9:	eb 6c                	jmp    801b37 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801acb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ace:	48 98                	cltq   
  801ad0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ad6:	48 c1 e0 0c          	shl    $0xc,%rax
  801ada:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae2:	48 c1 e8 15          	shr    $0x15,%rax
  801ae6:	48 89 c2             	mov    %rax,%rdx
  801ae9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801af0:	01 00 00 
  801af3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801af7:	83 e0 01             	and    $0x1,%eax
  801afa:	48 85 c0             	test   %rax,%rax
  801afd:	74 21                	je     801b20 <fd_lookup+0x77>
  801aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b03:	48 c1 e8 0c          	shr    $0xc,%rax
  801b07:	48 89 c2             	mov    %rax,%rdx
  801b0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b11:	01 00 00 
  801b14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b18:	83 e0 01             	and    $0x1,%eax
  801b1b:	48 85 c0             	test   %rax,%rax
  801b1e:	75 07                	jne    801b27 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b25:	eb 10                	jmp    801b37 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b2f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leaveq 
  801b38:	c3                   	retq   

0000000000801b39 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	48 83 ec 30          	sub    $0x30,%rsp
  801b41:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b45:	89 f0                	mov    %esi,%eax
  801b47:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4e:	48 89 c7             	mov    %rax,%rdi
  801b51:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  801b58:	00 00 00 
  801b5b:	ff d0                	callq  *%rax
  801b5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b61:	48 89 d6             	mov    %rdx,%rsi
  801b64:	89 c7                	mov    %eax,%edi
  801b66:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	callq  *%rax
  801b72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b79:	78 0a                	js     801b85 <fd_close+0x4c>
	    || fd != fd2)
  801b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b83:	74 12                	je     801b97 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b85:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801b89:	74 05                	je     801b90 <fd_close+0x57>
  801b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8e:	eb 05                	jmp    801b95 <fd_close+0x5c>
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	eb 69                	jmp    801c00 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9b:	8b 00                	mov    (%rax),%eax
  801b9d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ba1:	48 89 d6             	mov    %rdx,%rsi
  801ba4:	89 c7                	mov    %eax,%edi
  801ba6:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	callq  *%rax
  801bb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb9:	78 2a                	js     801be5 <fd_close+0xac>
		if (dev->dev_close)
  801bbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbf:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bc3:	48 85 c0             	test   %rax,%rax
  801bc6:	74 16                	je     801bde <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcc:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bd0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bd4:	48 89 d7             	mov    %rdx,%rdi
  801bd7:	ff d0                	callq  *%rax
  801bd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bdc:	eb 07                	jmp    801be5 <fd_close+0xac>
		else
			r = 0;
  801bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801be5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be9:	48 89 c6             	mov    %rax,%rsi
  801bec:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf1:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801bf8:	00 00 00 
  801bfb:	ff d0                	callq  *%rax
	return r;
  801bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c00:	c9                   	leaveq 
  801c01:	c3                   	retq   

0000000000801c02 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	48 83 ec 20          	sub    $0x20,%rsp
  801c0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c18:	eb 41                	jmp    801c5b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c1a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c21:	00 00 00 
  801c24:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c27:	48 63 d2             	movslq %edx,%rdx
  801c2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2e:	8b 00                	mov    (%rax),%eax
  801c30:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c33:	75 22                	jne    801c57 <dev_lookup+0x55>
			*dev = devtab[i];
  801c35:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c3c:	00 00 00 
  801c3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c42:	48 63 d2             	movslq %edx,%rdx
  801c45:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c4d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c50:	b8 00 00 00 00       	mov    $0x0,%eax
  801c55:	eb 60                	jmp    801cb7 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c5b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c62:	00 00 00 
  801c65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c68:	48 63 d2             	movslq %edx,%rdx
  801c6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c6f:	48 85 c0             	test   %rax,%rax
  801c72:	75 a6                	jne    801c1a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c74:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c7b:	00 00 00 
  801c7e:	48 8b 00             	mov    (%rax),%rax
  801c81:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c87:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c8a:	89 c6                	mov    %eax,%esi
  801c8c:	48 bf 10 39 80 00 00 	movabs $0x803910,%rdi
  801c93:	00 00 00 
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  801ca2:	00 00 00 
  801ca5:	ff d1                	callq  *%rcx
	*dev = 0;
  801ca7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cab:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801cb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cb7:	c9                   	leaveq 
  801cb8:	c3                   	retq   

0000000000801cb9 <close>:

int
close(int fdnum)
{
  801cb9:	55                   	push   %rbp
  801cba:	48 89 e5             	mov    %rsp,%rbp
  801cbd:	48 83 ec 20          	sub    $0x20,%rsp
  801cc1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ccb:	48 89 d6             	mov    %rdx,%rsi
  801cce:	89 c7                	mov    %eax,%edi
  801cd0:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
  801cdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce3:	79 05                	jns    801cea <close+0x31>
		return r;
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	eb 18                	jmp    801d02 <close+0x49>
	else
		return fd_close(fd, 1);
  801cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cee:	be 01 00 00 00       	mov    $0x1,%esi
  801cf3:	48 89 c7             	mov    %rax,%rdi
  801cf6:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  801cfd:	00 00 00 
  801d00:	ff d0                	callq  *%rax
}
  801d02:	c9                   	leaveq 
  801d03:	c3                   	retq   

0000000000801d04 <close_all>:

void
close_all(void)
{
  801d04:	55                   	push   %rbp
  801d05:	48 89 e5             	mov    %rsp,%rbp
  801d08:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d13:	eb 15                	jmp    801d2a <close_all+0x26>
		close(i);
  801d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d18:	89 c7                	mov    %eax,%edi
  801d1a:	48 b8 b9 1c 80 00 00 	movabs $0x801cb9,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d26:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d2a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d2e:	7e e5                	jle    801d15 <close_all+0x11>
		close(i);
}
  801d30:	c9                   	leaveq 
  801d31:	c3                   	retq   

0000000000801d32 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d32:	55                   	push   %rbp
  801d33:	48 89 e5             	mov    %rsp,%rbp
  801d36:	48 83 ec 40          	sub    $0x40,%rsp
  801d3a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d3d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d40:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d44:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d47:	48 89 d6             	mov    %rdx,%rsi
  801d4a:	89 c7                	mov    %eax,%edi
  801d4c:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
  801d58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d5f:	79 08                	jns    801d69 <dup+0x37>
		return r;
  801d61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d64:	e9 70 01 00 00       	jmpq   801ed9 <dup+0x1a7>
	close(newfdnum);
  801d69:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d6c:	89 c7                	mov    %eax,%edi
  801d6e:	48 b8 b9 1c 80 00 00 	movabs $0x801cb9,%rax
  801d75:	00 00 00 
  801d78:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d7d:	48 98                	cltq   
  801d7f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d85:	48 c1 e0 0c          	shl    $0xc,%rax
  801d89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801d8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d91:	48 89 c7             	mov    %rax,%rdi
  801d94:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	callq  *%rax
  801da0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbf:	48 c1 e8 15          	shr    $0x15,%rax
  801dc3:	48 89 c2             	mov    %rax,%rdx
  801dc6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dcd:	01 00 00 
  801dd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd4:	83 e0 01             	and    $0x1,%eax
  801dd7:	48 85 c0             	test   %rax,%rax
  801dda:	74 73                	je     801e4f <dup+0x11d>
  801ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de0:	48 c1 e8 0c          	shr    $0xc,%rax
  801de4:	48 89 c2             	mov    %rax,%rdx
  801de7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dee:	01 00 00 
  801df1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df5:	83 e0 01             	and    $0x1,%eax
  801df8:	48 85 c0             	test   %rax,%rax
  801dfb:	74 52                	je     801e4f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e01:	48 c1 e8 0c          	shr    $0xc,%rax
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e0f:	01 00 00 
  801e12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e16:	25 07 0e 00 00       	and    $0xe07,%eax
  801e1b:	89 c1                	mov    %eax,%ecx
  801e1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e25:	41 89 c8             	mov    %ecx,%r8d
  801e28:	48 89 d1             	mov    %rdx,%rcx
  801e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e30:	48 89 c6             	mov    %rax,%rsi
  801e33:	bf 00 00 00 00       	mov    $0x0,%edi
  801e38:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  801e3f:	00 00 00 
  801e42:	ff d0                	callq  *%rax
  801e44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4b:	79 02                	jns    801e4f <dup+0x11d>
			goto err;
  801e4d:	eb 57                	jmp    801ea6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e53:	48 c1 e8 0c          	shr    $0xc,%rax
  801e57:	48 89 c2             	mov    %rax,%rdx
  801e5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e61:	01 00 00 
  801e64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e68:	25 07 0e 00 00       	and    $0xe07,%eax
  801e6d:	89 c1                	mov    %eax,%ecx
  801e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e77:	41 89 c8             	mov    %ecx,%r8d
  801e7a:	48 89 d1             	mov    %rdx,%rcx
  801e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e82:	48 89 c6             	mov    %rax,%rsi
  801e85:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8a:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  801e91:	00 00 00 
  801e94:	ff d0                	callq  *%rax
  801e96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e9d:	79 02                	jns    801ea1 <dup+0x16f>
		goto err;
  801e9f:	eb 05                	jmp    801ea6 <dup+0x174>

	return newfdnum;
  801ea1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ea4:	eb 33                	jmp    801ed9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eaa:	48 89 c6             	mov    %rax,%rsi
  801ead:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb2:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801eb9:	00 00 00 
  801ebc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801ebe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec2:	48 89 c6             	mov    %rax,%rsi
  801ec5:	bf 00 00 00 00       	mov    $0x0,%edi
  801eca:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
	return r;
  801ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ed9:	c9                   	leaveq 
  801eda:	c3                   	retq   

0000000000801edb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801edb:	55                   	push   %rbp
  801edc:	48 89 e5             	mov    %rsp,%rbp
  801edf:	48 83 ec 40          	sub    $0x40,%rsp
  801ee3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ee6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801eea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801eee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ef2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ef5:	48 89 d6             	mov    %rdx,%rsi
  801ef8:	89 c7                	mov    %eax,%edi
  801efa:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
  801f06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f0d:	78 24                	js     801f33 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f13:	8b 00                	mov    (%rax),%eax
  801f15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f19:	48 89 d6             	mov    %rdx,%rsi
  801f1c:	89 c7                	mov    %eax,%edi
  801f1e:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
  801f2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f31:	79 05                	jns    801f38 <read+0x5d>
		return r;
  801f33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f36:	eb 76                	jmp    801fae <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3c:	8b 40 08             	mov    0x8(%rax),%eax
  801f3f:	83 e0 03             	and    $0x3,%eax
  801f42:	83 f8 01             	cmp    $0x1,%eax
  801f45:	75 3a                	jne    801f81 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f47:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f4e:	00 00 00 
  801f51:	48 8b 00             	mov    (%rax),%rax
  801f54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f5d:	89 c6                	mov    %eax,%esi
  801f5f:	48 bf 2f 39 80 00 00 	movabs $0x80392f,%rdi
  801f66:	00 00 00 
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  801f75:	00 00 00 
  801f78:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7f:	eb 2d                	jmp    801fae <read+0xd3>
	}
	if (!dev->dev_read)
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f89:	48 85 c0             	test   %rax,%rax
  801f8c:	75 07                	jne    801f95 <read+0xba>
		return -E_NOT_SUPP;
  801f8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f93:	eb 19                	jmp    801fae <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f99:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f9d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fa1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801fa5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801fa9:	48 89 cf             	mov    %rcx,%rdi
  801fac:	ff d0                	callq  *%rax
}
  801fae:	c9                   	leaveq 
  801faf:	c3                   	retq   

0000000000801fb0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fb0:	55                   	push   %rbp
  801fb1:	48 89 e5             	mov    %rsp,%rbp
  801fb4:	48 83 ec 30          	sub    $0x30,%rsp
  801fb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fca:	eb 49                	jmp    802015 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcf:	48 98                	cltq   
  801fd1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd5:	48 29 c2             	sub    %rax,%rdx
  801fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fdb:	48 63 c8             	movslq %eax,%rcx
  801fde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe2:	48 01 c1             	add    %rax,%rcx
  801fe5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe8:	48 89 ce             	mov    %rcx,%rsi
  801feb:	89 c7                	mov    %eax,%edi
  801fed:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
  801ff9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  801ffc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802000:	79 05                	jns    802007 <readn+0x57>
			return m;
  802002:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802005:	eb 1c                	jmp    802023 <readn+0x73>
		if (m == 0)
  802007:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80200b:	75 02                	jne    80200f <readn+0x5f>
			break;
  80200d:	eb 11                	jmp    802020 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80200f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802012:	01 45 fc             	add    %eax,-0x4(%rbp)
  802015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802018:	48 98                	cltq   
  80201a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80201e:	72 ac                	jb     801fcc <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802020:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802023:	c9                   	leaveq 
  802024:	c3                   	retq   

0000000000802025 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802025:	55                   	push   %rbp
  802026:	48 89 e5             	mov    %rsp,%rbp
  802029:	48 83 ec 40          	sub    $0x40,%rsp
  80202d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802030:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802034:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802038:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80203c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80203f:	48 89 d6             	mov    %rdx,%rsi
  802042:	89 c7                	mov    %eax,%edi
  802044:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
  802050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802057:	78 24                	js     80207d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205d:	8b 00                	mov    (%rax),%eax
  80205f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802063:	48 89 d6             	mov    %rdx,%rsi
  802066:	89 c7                	mov    %eax,%edi
  802068:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  80206f:	00 00 00 
  802072:	ff d0                	callq  *%rax
  802074:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802077:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80207b:	79 05                	jns    802082 <write+0x5d>
		return r;
  80207d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802080:	eb 75                	jmp    8020f7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802086:	8b 40 08             	mov    0x8(%rax),%eax
  802089:	83 e0 03             	and    $0x3,%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	75 3a                	jne    8020ca <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802090:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802097:	00 00 00 
  80209a:	48 8b 00             	mov    (%rax),%rax
  80209d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020a6:	89 c6                	mov    %eax,%esi
  8020a8:	48 bf 4b 39 80 00 00 	movabs $0x80394b,%rdi
  8020af:	00 00 00 
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b7:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  8020be:	00 00 00 
  8020c1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020c8:	eb 2d                	jmp    8020f7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020d2:	48 85 c0             	test   %rax,%rax
  8020d5:	75 07                	jne    8020de <write+0xb9>
		return -E_NOT_SUPP;
  8020d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020dc:	eb 19                	jmp    8020f7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020ee:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8020f2:	48 89 cf             	mov    %rcx,%rdi
  8020f5:	ff d0                	callq  *%rax
}
  8020f7:	c9                   	leaveq 
  8020f8:	c3                   	retq   

00000000008020f9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8020f9:	55                   	push   %rbp
  8020fa:	48 89 e5             	mov    %rsp,%rbp
  8020fd:	48 83 ec 18          	sub    $0x18,%rsp
  802101:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802104:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802107:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80210b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80210e:	48 89 d6             	mov    %rdx,%rsi
  802111:	89 c7                	mov    %eax,%edi
  802113:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax
  80211f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802122:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802126:	79 05                	jns    80212d <seek+0x34>
		return r;
  802128:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212b:	eb 0f                	jmp    80213c <seek+0x43>
	fd->fd_offset = offset;
  80212d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802131:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802134:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213c:	c9                   	leaveq 
  80213d:	c3                   	retq   

000000000080213e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80213e:	55                   	push   %rbp
  80213f:	48 89 e5             	mov    %rsp,%rbp
  802142:	48 83 ec 30          	sub    $0x30,%rsp
  802146:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802149:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802150:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802153:	48 89 d6             	mov    %rdx,%rsi
  802156:	89 c7                	mov    %eax,%edi
  802158:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax
  802164:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216b:	78 24                	js     802191 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80216d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802171:	8b 00                	mov    (%rax),%eax
  802173:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802177:	48 89 d6             	mov    %rdx,%rsi
  80217a:	89 c7                	mov    %eax,%edi
  80217c:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
  802188:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218f:	79 05                	jns    802196 <ftruncate+0x58>
		return r;
  802191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802194:	eb 72                	jmp    802208 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219a:	8b 40 08             	mov    0x8(%rax),%eax
  80219d:	83 e0 03             	and    $0x3,%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	75 3a                	jne    8021de <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8021a4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021ab:	00 00 00 
  8021ae:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ba:	89 c6                	mov    %eax,%esi
  8021bc:	48 bf 68 39 80 00 00 	movabs $0x803968,%rdi
  8021c3:	00 00 00 
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	48 b9 72 02 80 00 00 	movabs $0x800272,%rcx
  8021d2:	00 00 00 
  8021d5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021dc:	eb 2a                	jmp    802208 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021e6:	48 85 c0             	test   %rax,%rax
  8021e9:	75 07                	jne    8021f2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8021eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021f0:	eb 16                	jmp    802208 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021fe:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802201:	89 ce                	mov    %ecx,%esi
  802203:	48 89 d7             	mov    %rdx,%rdi
  802206:	ff d0                	callq  *%rax
}
  802208:	c9                   	leaveq 
  802209:	c3                   	retq   

000000000080220a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80220a:	55                   	push   %rbp
  80220b:	48 89 e5             	mov    %rsp,%rbp
  80220e:	48 83 ec 30          	sub    $0x30,%rsp
  802212:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802215:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802219:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80221d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802220:	48 89 d6             	mov    %rdx,%rsi
  802223:	89 c7                	mov    %eax,%edi
  802225:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	callq  *%rax
  802231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802238:	78 24                	js     80225e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	8b 00                	mov    (%rax),%eax
  802240:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802244:	48 89 d6             	mov    %rdx,%rsi
  802247:	89 c7                	mov    %eax,%edi
  802249:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
  802255:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802258:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225c:	79 05                	jns    802263 <fstat+0x59>
		return r;
  80225e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802261:	eb 5e                	jmp    8022c1 <fstat+0xb7>
	if (!dev->dev_stat)
  802263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802267:	48 8b 40 28          	mov    0x28(%rax),%rax
  80226b:	48 85 c0             	test   %rax,%rax
  80226e:	75 07                	jne    802277 <fstat+0x6d>
		return -E_NOT_SUPP;
  802270:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802275:	eb 4a                	jmp    8022c1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802277:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80227b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80227e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802282:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802289:	00 00 00 
	stat->st_isdir = 0;
  80228c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802290:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802297:	00 00 00 
	stat->st_dev = dev;
  80229a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80229e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022a2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8022a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ad:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022b9:	48 89 ce             	mov    %rcx,%rsi
  8022bc:	48 89 d7             	mov    %rdx,%rdi
  8022bf:	ff d0                	callq  *%rax
}
  8022c1:	c9                   	leaveq 
  8022c2:	c3                   	retq   

00000000008022c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022c3:	55                   	push   %rbp
  8022c4:	48 89 e5             	mov    %rsp,%rbp
  8022c7:	48 83 ec 20          	sub    $0x20,%rsp
  8022cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d7:	be 00 00 00 00       	mov    $0x0,%esi
  8022dc:	48 89 c7             	mov    %rax,%rdi
  8022df:	48 b8 b1 23 80 00 00 	movabs $0x8023b1,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	callq  *%rax
  8022eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f2:	79 05                	jns    8022f9 <stat+0x36>
		return fd;
  8022f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f7:	eb 2f                	jmp    802328 <stat+0x65>
	r = fstat(fd, stat);
  8022f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802300:	48 89 d6             	mov    %rdx,%rsi
  802303:	89 c7                	mov    %eax,%edi
  802305:	48 b8 0a 22 80 00 00 	movabs $0x80220a,%rax
  80230c:	00 00 00 
  80230f:	ff d0                	callq  *%rax
  802311:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802317:	89 c7                	mov    %eax,%edi
  802319:	48 b8 b9 1c 80 00 00 	movabs $0x801cb9,%rax
  802320:	00 00 00 
  802323:	ff d0                	callq  *%rax
	return r;
  802325:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802328:	c9                   	leaveq 
  802329:	c3                   	retq   

000000000080232a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80232a:	55                   	push   %rbp
  80232b:	48 89 e5             	mov    %rsp,%rbp
  80232e:	48 83 ec 10          	sub    $0x10,%rsp
  802332:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802335:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802339:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802340:	00 00 00 
  802343:	8b 00                	mov    (%rax),%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	75 1d                	jne    802366 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802349:	bf 01 00 00 00       	mov    $0x1,%edi
  80234e:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  802355:	00 00 00 
  802358:	ff d0                	callq  *%rax
  80235a:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802361:	00 00 00 
  802364:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802366:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80236d:	00 00 00 
  802370:	8b 00                	mov    (%rax),%eax
  802372:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802375:	b9 07 00 00 00       	mov    $0x7,%ecx
  80237a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802381:	00 00 00 
  802384:	89 c7                	mov    %eax,%edi
  802386:	48 b8 82 32 80 00 00 	movabs $0x803282,%rax
  80238d:	00 00 00 
  802390:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802396:	ba 00 00 00 00       	mov    $0x0,%edx
  80239b:	48 89 c6             	mov    %rax,%rsi
  80239e:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a3:	48 b8 7c 31 80 00 00 	movabs $0x80317c,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	callq  *%rax
}
  8023af:	c9                   	leaveq 
  8023b0:	c3                   	retq   

00000000008023b1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023b1:	55                   	push   %rbp
  8023b2:	48 89 e5             	mov    %rsp,%rbp
  8023b5:	48 83 ec 30          	sub    $0x30,%rsp
  8023b9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023bd:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8023c0:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8023c7:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8023ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8023d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8023da:	75 08                	jne    8023e4 <open+0x33>
	{
		return r;
  8023dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023df:	e9 f2 00 00 00       	jmpq   8024d6 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8023e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023e8:	48 89 c7             	mov    %rax,%rdi
  8023eb:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8023fa:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802401:	7e 0a                	jle    80240d <open+0x5c>
	{
		return -E_BAD_PATH;
  802403:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802408:	e9 c9 00 00 00       	jmpq   8024d6 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80240d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802414:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802415:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802419:	48 89 c7             	mov    %rax,%rdi
  80241c:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
  802428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242f:	78 09                	js     80243a <open+0x89>
  802431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802435:	48 85 c0             	test   %rax,%rax
  802438:	75 08                	jne    802442 <open+0x91>
		{
			return r;
  80243a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243d:	e9 94 00 00 00       	jmpq   8024d6 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802446:	ba 00 04 00 00       	mov    $0x400,%edx
  80244b:	48 89 c6             	mov    %rax,%rsi
  80244e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802455:	00 00 00 
  802458:	48 b8 b9 0e 80 00 00 	movabs $0x800eb9,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802464:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80246b:	00 00 00 
  80246e:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802471:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247b:	48 89 c6             	mov    %rax,%rsi
  80247e:	bf 01 00 00 00       	mov    $0x1,%edi
  802483:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802496:	79 2b                	jns    8024c3 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249c:	be 00 00 00 00       	mov    $0x0,%esi
  8024a1:	48 89 c7             	mov    %rax,%rdi
  8024a4:	48 b8 39 1b 80 00 00 	movabs $0x801b39,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8024b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b7:	79 05                	jns    8024be <open+0x10d>
			{
				return d;
  8024b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bc:	eb 18                	jmp    8024d6 <open+0x125>
			}
			return r;
  8024be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c1:	eb 13                	jmp    8024d6 <open+0x125>
		}	
		return fd2num(fd_store);
  8024c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c7:	48 89 c7             	mov    %rax,%rdi
  8024ca:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8024d6:	c9                   	leaveq 
  8024d7:	c3                   	retq   

00000000008024d8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024d8:	55                   	push   %rbp
  8024d9:	48 89 e5             	mov    %rsp,%rbp
  8024dc:	48 83 ec 10          	sub    $0x10,%rsp
  8024e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8024eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024f2:	00 00 00 
  8024f5:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024f7:	be 00 00 00 00       	mov    $0x0,%esi
  8024fc:	bf 06 00 00 00       	mov    $0x6,%edi
  802501:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  802508:	00 00 00 
  80250b:	ff d0                	callq  *%rax
}
  80250d:	c9                   	leaveq 
  80250e:	c3                   	retq   

000000000080250f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
  802513:	48 83 ec 30          	sub    $0x30,%rsp
  802517:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80251b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80251f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802523:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80252a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80252f:	74 07                	je     802538 <devfile_read+0x29>
  802531:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802536:	75 07                	jne    80253f <devfile_read+0x30>
		return -E_INVAL;
  802538:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80253d:	eb 77                	jmp    8025b6 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80253f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802543:	8b 50 0c             	mov    0xc(%rax),%edx
  802546:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80254d:	00 00 00 
  802550:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802552:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802559:	00 00 00 
  80255c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802560:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802564:	be 00 00 00 00       	mov    $0x0,%esi
  802569:	bf 03 00 00 00       	mov    $0x3,%edi
  80256e:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
  80257a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802581:	7f 05                	jg     802588 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802586:	eb 2e                	jmp    8025b6 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802588:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258b:	48 63 d0             	movslq %eax,%rdx
  80258e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802592:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802599:	00 00 00 
  80259c:	48 89 c7             	mov    %rax,%rdi
  80259f:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8025ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8025b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8025b6:	c9                   	leaveq 
  8025b7:	c3                   	retq   

00000000008025b8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025b8:	55                   	push   %rbp
  8025b9:	48 89 e5             	mov    %rsp,%rbp
  8025bc:	48 83 ec 30          	sub    $0x30,%rsp
  8025c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8025cc:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8025d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8025d8:	74 07                	je     8025e1 <devfile_write+0x29>
  8025da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025df:	75 08                	jne    8025e9 <devfile_write+0x31>
		return r;
  8025e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e4:	e9 9a 00 00 00       	jmpq   802683 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8025f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025f7:	00 00 00 
  8025fa:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8025fc:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802603:	00 
  802604:	76 08                	jbe    80260e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802606:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80260d:	00 
	}
	fsipcbuf.write.req_n = n;
  80260e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802615:	00 00 00 
  802618:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80261c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802620:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802624:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802628:	48 89 c6             	mov    %rax,%rsi
  80262b:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802632:	00 00 00 
  802635:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802641:	be 00 00 00 00       	mov    $0x0,%esi
  802646:	bf 04 00 00 00       	mov    $0x4,%edi
  80264b:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	7f 20                	jg     802680 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802660:	48 bf 8e 39 80 00 00 	movabs $0x80398e,%rdi
  802667:	00 00 00 
  80266a:	b8 00 00 00 00       	mov    $0x0,%eax
  80266f:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  802676:	00 00 00 
  802679:	ff d2                	callq  *%rdx
		return r;
  80267b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267e:	eb 03                	jmp    802683 <devfile_write+0xcb>
	}
	return r;
  802680:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802683:	c9                   	leaveq 
  802684:	c3                   	retq   

0000000000802685 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802685:	55                   	push   %rbp
  802686:	48 89 e5             	mov    %rsp,%rbp
  802689:	48 83 ec 20          	sub    $0x20,%rsp
  80268d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802691:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802699:	8b 50 0c             	mov    0xc(%rax),%edx
  80269c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026a3:	00 00 00 
  8026a6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026a8:	be 00 00 00 00       	mov    $0x0,%esi
  8026ad:	bf 05 00 00 00       	mov    $0x5,%edi
  8026b2:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	79 05                	jns    8026cc <devfile_stat+0x47>
		return r;
  8026c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ca:	eb 56                	jmp    802722 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8026d7:	00 00 00 
  8026da:	48 89 c7             	mov    %rax,%rdi
  8026dd:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8026e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f0:	00 00 00 
  8026f3:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8026f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026fd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802703:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80270a:	00 00 00 
  80270d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802713:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802717:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leaveq 
  802723:	c3                   	retq   

0000000000802724 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802724:	55                   	push   %rbp
  802725:	48 89 e5             	mov    %rsp,%rbp
  802728:	48 83 ec 10          	sub    $0x10,%rsp
  80272c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802730:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802737:	8b 50 0c             	mov    0xc(%rax),%edx
  80273a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802741:	00 00 00 
  802744:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802746:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80274d:	00 00 00 
  802750:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802753:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802756:	be 00 00 00 00       	mov    $0x0,%esi
  80275b:	bf 02 00 00 00       	mov    $0x2,%edi
  802760:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
}
  80276c:	c9                   	leaveq 
  80276d:	c3                   	retq   

000000000080276e <remove>:

// Delete a file
int
remove(const char *path)
{
  80276e:	55                   	push   %rbp
  80276f:	48 89 e5             	mov    %rsp,%rbp
  802772:	48 83 ec 10          	sub    $0x10,%rsp
  802776:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80277a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80277e:	48 89 c7             	mov    %rax,%rdi
  802781:	48 b8 bb 0d 80 00 00 	movabs $0x800dbb,%rax
  802788:	00 00 00 
  80278b:	ff d0                	callq  *%rax
  80278d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802792:	7e 07                	jle    80279b <remove+0x2d>
		return -E_BAD_PATH;
  802794:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802799:	eb 33                	jmp    8027ce <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80279b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80279f:	48 89 c6             	mov    %rax,%rsi
  8027a2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8027a9:	00 00 00 
  8027ac:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8027b8:	be 00 00 00 00       	mov    $0x0,%esi
  8027bd:	bf 07 00 00 00       	mov    $0x7,%edi
  8027c2:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  8027c9:	00 00 00 
  8027cc:	ff d0                	callq  *%rax
}
  8027ce:	c9                   	leaveq 
  8027cf:	c3                   	retq   

00000000008027d0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8027d0:	55                   	push   %rbp
  8027d1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8027d4:	be 00 00 00 00       	mov    $0x0,%esi
  8027d9:	bf 08 00 00 00       	mov    $0x8,%edi
  8027de:	48 b8 2a 23 80 00 00 	movabs $0x80232a,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
}
  8027ea:	5d                   	pop    %rbp
  8027eb:	c3                   	retq   

00000000008027ec <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027ec:	55                   	push   %rbp
  8027ed:	48 89 e5             	mov    %rsp,%rbp
  8027f0:	53                   	push   %rbx
  8027f1:	48 83 ec 38          	sub    $0x38,%rsp
  8027f5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027f9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8027fd:	48 89 c7             	mov    %rax,%rdi
  802800:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax
  80280c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80280f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802813:	0f 88 bf 01 00 00    	js     8029d8 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281d:	ba 07 04 00 00       	mov    $0x407,%edx
  802822:	48 89 c6             	mov    %rax,%rsi
  802825:	bf 00 00 00 00       	mov    $0x0,%edi
  80282a:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
  802836:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802839:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80283d:	0f 88 95 01 00 00    	js     8029d8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802843:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802847:	48 89 c7             	mov    %rax,%rdi
  80284a:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
  802856:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802859:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80285d:	0f 88 5d 01 00 00    	js     8029c0 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802863:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802867:	ba 07 04 00 00       	mov    $0x407,%edx
  80286c:	48 89 c6             	mov    %rax,%rsi
  80286f:	bf 00 00 00 00       	mov    $0x0,%edi
  802874:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	callq  *%rax
  802880:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802883:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802887:	0f 88 33 01 00 00    	js     8029c0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80288d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802891:	48 89 c7             	mov    %rax,%rdi
  802894:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80289b:	00 00 00 
  80289e:	ff d0                	callq  *%rax
  8028a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a8:	ba 07 04 00 00       	mov    $0x407,%edx
  8028ad:	48 89 c6             	mov    %rax,%rsi
  8028b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b5:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028c8:	79 05                	jns    8028cf <pipe+0xe3>
		goto err2;
  8028ca:	e9 d9 00 00 00       	jmpq   8029a8 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028d3:	48 89 c7             	mov    %rax,%rdi
  8028d6:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
  8028e2:	48 89 c2             	mov    %rax,%rdx
  8028e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8028ef:	48 89 d1             	mov    %rdx,%rcx
  8028f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f7:	48 89 c6             	mov    %rax,%rsi
  8028fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ff:	48 b8 a6 17 80 00 00 	movabs $0x8017a6,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80290e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802912:	79 1b                	jns    80292f <pipe+0x143>
		goto err3;
  802914:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802915:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802919:	48 89 c6             	mov    %rax,%rsi
  80291c:	bf 00 00 00 00       	mov    $0x0,%edi
  802921:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
  80292d:	eb 79                	jmp    8029a8 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80292f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802933:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80293a:	00 00 00 
  80293d:	8b 12                	mov    (%rdx),%edx
  80293f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802941:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802945:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80294c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802950:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802957:	00 00 00 
  80295a:	8b 12                	mov    (%rdx),%edx
  80295c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80295e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802962:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 c2                	mov    %eax,%edx
  80297e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802982:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802984:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802988:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80298c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802990:	48 89 c7             	mov    %rax,%rdi
  802993:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax
  80299f:	89 03                	mov    %eax,(%rbx)
	return 0;
  8029a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a6:	eb 33                	jmp    8029db <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8029a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029ac:	48 89 c6             	mov    %rax,%rsi
  8029af:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b4:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  8029bb:	00 00 00 
  8029be:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8029c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c4:	48 89 c6             	mov    %rax,%rsi
  8029c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029cc:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  8029d3:	00 00 00 
  8029d6:	ff d0                	callq  *%rax
    err:
	return r;
  8029d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8029db:	48 83 c4 38          	add    $0x38,%rsp
  8029df:	5b                   	pop    %rbx
  8029e0:	5d                   	pop    %rbp
  8029e1:	c3                   	retq   

00000000008029e2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8029e2:	55                   	push   %rbp
  8029e3:	48 89 e5             	mov    %rsp,%rbp
  8029e6:	53                   	push   %rbx
  8029e7:	48 83 ec 28          	sub    $0x28,%rsp
  8029eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8029f3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8029fa:	00 00 00 
  8029fd:	48 8b 00             	mov    (%rax),%rax
  802a00:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802a06:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a0d:	48 89 c7             	mov    %rax,%rdi
  802a10:	48 b8 66 33 80 00 00 	movabs $0x803366,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
  802a1c:	89 c3                	mov    %eax,%ebx
  802a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a22:	48 89 c7             	mov    %rax,%rdi
  802a25:	48 b8 66 33 80 00 00 	movabs $0x803366,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	39 c3                	cmp    %eax,%ebx
  802a33:	0f 94 c0             	sete   %al
  802a36:	0f b6 c0             	movzbl %al,%eax
  802a39:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802a3c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802a43:	00 00 00 
  802a46:	48 8b 00             	mov    (%rax),%rax
  802a49:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802a4f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802a52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a55:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802a58:	75 05                	jne    802a5f <_pipeisclosed+0x7d>
			return ret;
  802a5a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802a5d:	eb 4f                	jmp    802aae <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802a5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a62:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802a65:	74 42                	je     802aa9 <_pipeisclosed+0xc7>
  802a67:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802a6b:	75 3c                	jne    802aa9 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802a6d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802a74:	00 00 00 
  802a77:	48 8b 00             	mov    (%rax),%rax
  802a7a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802a80:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802a83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a86:	89 c6                	mov    %eax,%esi
  802a88:	48 bf af 39 80 00 00 	movabs $0x8039af,%rdi
  802a8f:	00 00 00 
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
  802a97:	49 b8 72 02 80 00 00 	movabs $0x800272,%r8
  802a9e:	00 00 00 
  802aa1:	41 ff d0             	callq  *%r8
	}
  802aa4:	e9 4a ff ff ff       	jmpq   8029f3 <_pipeisclosed+0x11>
  802aa9:	e9 45 ff ff ff       	jmpq   8029f3 <_pipeisclosed+0x11>
}
  802aae:	48 83 c4 28          	add    $0x28,%rsp
  802ab2:	5b                   	pop    %rbx
  802ab3:	5d                   	pop    %rbp
  802ab4:	c3                   	retq   

0000000000802ab5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ab5:	55                   	push   %rbp
  802ab6:	48 89 e5             	mov    %rsp,%rbp
  802ab9:	48 83 ec 30          	sub    $0x30,%rsp
  802abd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ac0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ac4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac7:	48 89 d6             	mov    %rdx,%rsi
  802aca:	89 c7                	mov    %eax,%edi
  802acc:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802adf:	79 05                	jns    802ae6 <pipeisclosed+0x31>
		return r;
  802ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae4:	eb 31                	jmp    802b17 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802ae6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aea:	48 89 c7             	mov    %rax,%rdi
  802aed:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b05:	48 89 d6             	mov    %rdx,%rsi
  802b08:	48 89 c7             	mov    %rax,%rdi
  802b0b:	48 b8 e2 29 80 00 00 	movabs $0x8029e2,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
}
  802b17:	c9                   	leaveq 
  802b18:	c3                   	retq   

0000000000802b19 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b19:	55                   	push   %rbp
  802b1a:	48 89 e5             	mov    %rsp,%rbp
  802b1d:	48 83 ec 40          	sub    $0x40,%rsp
  802b21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b31:	48 89 c7             	mov    %rax,%rdi
  802b34:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802b4c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802b53:	00 
  802b54:	e9 92 00 00 00       	jmpq   802beb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802b59:	eb 41                	jmp    802b9c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802b5b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802b60:	74 09                	je     802b6b <devpipe_read+0x52>
				return i;
  802b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b66:	e9 92 00 00 00       	jmpq   802bfd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802b6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b73:	48 89 d6             	mov    %rdx,%rsi
  802b76:	48 89 c7             	mov    %rax,%rdi
  802b79:	48 b8 e2 29 80 00 00 	movabs $0x8029e2,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 07                	je     802b90 <devpipe_read+0x77>
				return 0;
  802b89:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8e:	eb 6d                	jmp    802bfd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802b90:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba0:	8b 10                	mov    (%rax),%edx
  802ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba6:	8b 40 04             	mov    0x4(%rax),%eax
  802ba9:	39 c2                	cmp    %eax,%edx
  802bab:	74 ae                	je     802b5b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb5:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbd:	8b 00                	mov    (%rax),%eax
  802bbf:	99                   	cltd   
  802bc0:	c1 ea 1b             	shr    $0x1b,%edx
  802bc3:	01 d0                	add    %edx,%eax
  802bc5:	83 e0 1f             	and    $0x1f,%eax
  802bc8:	29 d0                	sub    %edx,%eax
  802bca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bce:	48 98                	cltq   
  802bd0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802bd5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdb:	8b 00                	mov    (%rax),%eax
  802bdd:	8d 50 01             	lea    0x1(%rax),%edx
  802be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802be6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802beb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bef:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bf3:	0f 82 60 ff ff ff    	jb     802b59 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bfd:	c9                   	leaveq 
  802bfe:	c3                   	retq   

0000000000802bff <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802bff:	55                   	push   %rbp
  802c00:	48 89 e5             	mov    %rsp,%rbp
  802c03:	48 83 ec 40          	sub    $0x40,%rsp
  802c07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c17:	48 89 c7             	mov    %rax,%rdi
  802c1a:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
  802c26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802c2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802c32:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c39:	00 
  802c3a:	e9 8e 00 00 00       	jmpq   802ccd <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c3f:	eb 31                	jmp    802c72 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802c41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c49:	48 89 d6             	mov    %rdx,%rsi
  802c4c:	48 89 c7             	mov    %rax,%rdi
  802c4f:	48 b8 e2 29 80 00 00 	movabs $0x8029e2,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 07                	je     802c66 <devpipe_write+0x67>
				return 0;
  802c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c64:	eb 79                	jmp    802cdf <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802c66:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c76:	8b 40 04             	mov    0x4(%rax),%eax
  802c79:	48 63 d0             	movslq %eax,%rdx
  802c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c80:	8b 00                	mov    (%rax),%eax
  802c82:	48 98                	cltq   
  802c84:	48 83 c0 20          	add    $0x20,%rax
  802c88:	48 39 c2             	cmp    %rax,%rdx
  802c8b:	73 b4                	jae    802c41 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c91:	8b 40 04             	mov    0x4(%rax),%eax
  802c94:	99                   	cltd   
  802c95:	c1 ea 1b             	shr    $0x1b,%edx
  802c98:	01 d0                	add    %edx,%eax
  802c9a:	83 e0 1f             	and    $0x1f,%eax
  802c9d:	29 d0                	sub    %edx,%eax
  802c9f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ca3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ca7:	48 01 ca             	add    %rcx,%rdx
  802caa:	0f b6 0a             	movzbl (%rdx),%ecx
  802cad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cb1:	48 98                	cltq   
  802cb3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbb:	8b 40 04             	mov    0x4(%rax),%eax
  802cbe:	8d 50 01             	lea    0x1(%rax),%edx
  802cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cc8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802cd5:	0f 82 64 ff ff ff    	jb     802c3f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802cdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802cdf:	c9                   	leaveq 
  802ce0:	c3                   	retq   

0000000000802ce1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ce1:	55                   	push   %rbp
  802ce2:	48 89 e5             	mov    %rsp,%rbp
  802ce5:	48 83 ec 20          	sub    $0x20,%rsp
  802ce9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ced:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf5:	48 89 c7             	mov    %rax,%rdi
  802cf8:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	callq  *%rax
  802d04:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802d08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d0c:	48 be c2 39 80 00 00 	movabs $0x8039c2,%rsi
  802d13:	00 00 00 
  802d16:	48 89 c7             	mov    %rax,%rdi
  802d19:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d29:	8b 50 04             	mov    0x4(%rax),%edx
  802d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d30:	8b 00                	mov    (%rax),%eax
  802d32:	29 c2                	sub    %eax,%edx
  802d34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d38:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802d3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d42:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d49:	00 00 00 
	stat->st_dev = &devpipe;
  802d4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d50:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802d57:	00 00 00 
  802d5a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d66:	c9                   	leaveq 
  802d67:	c3                   	retq   

0000000000802d68 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802d68:	55                   	push   %rbp
  802d69:	48 89 e5             	mov    %rsp,%rbp
  802d6c:	48 83 ec 10          	sub    $0x10,%rsp
  802d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802d74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d78:	48 89 c6             	mov    %rax,%rsi
  802d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d80:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d90:	48 89 c7             	mov    %rax,%rdi
  802d93:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
  802d9f:	48 89 c6             	mov    %rax,%rsi
  802da2:	bf 00 00 00 00       	mov    $0x0,%edi
  802da7:	48 b8 01 18 80 00 00 	movabs $0x801801,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
}
  802db3:	c9                   	leaveq 
  802db4:	c3                   	retq   

0000000000802db5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802db5:	55                   	push   %rbp
  802db6:	48 89 e5             	mov    %rsp,%rbp
  802db9:	48 83 ec 20          	sub    $0x20,%rsp
  802dbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802dc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc3:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802dc6:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802dca:	be 01 00 00 00       	mov    $0x1,%esi
  802dcf:	48 89 c7             	mov    %rax,%rdi
  802dd2:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  802dd9:	00 00 00 
  802ddc:	ff d0                	callq  *%rax
}
  802dde:	c9                   	leaveq 
  802ddf:	c3                   	retq   

0000000000802de0 <getchar>:

int
getchar(void)
{
  802de0:	55                   	push   %rbp
  802de1:	48 89 e5             	mov    %rsp,%rbp
  802de4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802de8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802dec:	ba 01 00 00 00       	mov    $0x1,%edx
  802df1:	48 89 c6             	mov    %rax,%rsi
  802df4:	bf 00 00 00 00       	mov    $0x0,%edi
  802df9:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
  802e05:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802e08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0c:	79 05                	jns    802e13 <getchar+0x33>
		return r;
  802e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e11:	eb 14                	jmp    802e27 <getchar+0x47>
	if (r < 1)
  802e13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e17:	7f 07                	jg     802e20 <getchar+0x40>
		return -E_EOF;
  802e19:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802e1e:	eb 07                	jmp    802e27 <getchar+0x47>
	return c;
  802e20:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802e24:	0f b6 c0             	movzbl %al,%eax
}
  802e27:	c9                   	leaveq 
  802e28:	c3                   	retq   

0000000000802e29 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802e29:	55                   	push   %rbp
  802e2a:	48 89 e5             	mov    %rsp,%rbp
  802e2d:	48 83 ec 20          	sub    $0x20,%rsp
  802e31:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e34:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e3b:	48 89 d6             	mov    %rdx,%rsi
  802e3e:	89 c7                	mov    %eax,%edi
  802e40:	48 b8 a9 1a 80 00 00 	movabs $0x801aa9,%rax
  802e47:	00 00 00 
  802e4a:	ff d0                	callq  *%rax
  802e4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e53:	79 05                	jns    802e5a <iscons+0x31>
		return r;
  802e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e58:	eb 1a                	jmp    802e74 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5e:	8b 10                	mov    (%rax),%edx
  802e60:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802e67:	00 00 00 
  802e6a:	8b 00                	mov    (%rax),%eax
  802e6c:	39 c2                	cmp    %eax,%edx
  802e6e:	0f 94 c0             	sete   %al
  802e71:	0f b6 c0             	movzbl %al,%eax
}
  802e74:	c9                   	leaveq 
  802e75:	c3                   	retq   

0000000000802e76 <opencons>:

int
opencons(void)
{
  802e76:	55                   	push   %rbp
  802e77:	48 89 e5             	mov    %rsp,%rbp
  802e7a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802e7e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e82:	48 89 c7             	mov    %rax,%rdi
  802e85:	48 b8 11 1a 80 00 00 	movabs $0x801a11,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e98:	79 05                	jns    802e9f <opencons+0x29>
		return r;
  802e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9d:	eb 5b                	jmp    802efa <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea3:	ba 07 04 00 00       	mov    $0x407,%edx
  802ea8:	48 89 c6             	mov    %rax,%rsi
  802eab:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb0:	48 b8 56 17 80 00 00 	movabs $0x801756,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
  802ebc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec3:	79 05                	jns    802eca <opencons+0x54>
		return r;
  802ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec8:	eb 30                	jmp    802efa <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ece:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  802ed5:	00 00 00 
  802ed8:	8b 12                	mov    (%rdx),%edx
  802eda:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eeb:	48 89 c7             	mov    %rax,%rdi
  802eee:	48 b8 c3 19 80 00 00 	movabs $0x8019c3,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
}
  802efa:	c9                   	leaveq 
  802efb:	c3                   	retq   

0000000000802efc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802efc:	55                   	push   %rbp
  802efd:	48 89 e5             	mov    %rsp,%rbp
  802f00:	48 83 ec 30          	sub    $0x30,%rsp
  802f04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802f10:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f15:	75 07                	jne    802f1e <devcons_read+0x22>
		return 0;
  802f17:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1c:	eb 4b                	jmp    802f69 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802f1e:	eb 0c                	jmp    802f2c <devcons_read+0x30>
		sys_yield();
  802f20:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  802f27:	00 00 00 
  802f2a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802f2c:	48 b8 58 16 80 00 00 	movabs $0x801658,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
  802f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3f:	74 df                	je     802f20 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802f41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f45:	79 05                	jns    802f4c <devcons_read+0x50>
		return c;
  802f47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4a:	eb 1d                	jmp    802f69 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802f4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802f50:	75 07                	jne    802f59 <devcons_read+0x5d>
		return 0;
  802f52:	b8 00 00 00 00       	mov    $0x0,%eax
  802f57:	eb 10                	jmp    802f69 <devcons_read+0x6d>
	*(char*)vbuf = c;
  802f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5c:	89 c2                	mov    %eax,%edx
  802f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f62:	88 10                	mov    %dl,(%rax)
	return 1;
  802f64:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   

0000000000802f6b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f6b:	55                   	push   %rbp
  802f6c:	48 89 e5             	mov    %rsp,%rbp
  802f6f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802f76:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802f7d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802f84:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f92:	eb 76                	jmp    80300a <devcons_write+0x9f>
		m = n - tot;
  802f94:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa0:	29 c2                	sub    %eax,%edx
  802fa2:	89 d0                	mov    %edx,%eax
  802fa4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802fa7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802faa:	83 f8 7f             	cmp    $0x7f,%eax
  802fad:	76 07                	jbe    802fb6 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802faf:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802fb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fb9:	48 63 d0             	movslq %eax,%rdx
  802fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbf:	48 63 c8             	movslq %eax,%rcx
  802fc2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802fc9:	48 01 c1             	add    %rax,%rcx
  802fcc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802fd3:	48 89 ce             	mov    %rcx,%rsi
  802fd6:	48 89 c7             	mov    %rax,%rdi
  802fd9:	48 b8 4b 11 80 00 00 	movabs $0x80114b,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802fe5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fe8:	48 63 d0             	movslq %eax,%rdx
  802feb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802ff2:	48 89 d6             	mov    %rdx,%rsi
  802ff5:	48 89 c7             	mov    %rax,%rdi
  802ff8:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803004:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803007:	01 45 fc             	add    %eax,-0x4(%rbp)
  80300a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300d:	48 98                	cltq   
  80300f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803016:	0f 82 78 ff ff ff    	jb     802f94 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80301c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80301f:	c9                   	leaveq 
  803020:	c3                   	retq   

0000000000803021 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803021:	55                   	push   %rbp
  803022:	48 89 e5             	mov    %rsp,%rbp
  803025:	48 83 ec 08          	sub    $0x8,%rsp
  803029:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803032:	c9                   	leaveq 
  803033:	c3                   	retq   

0000000000803034 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803034:	55                   	push   %rbp
  803035:	48 89 e5             	mov    %rsp,%rbp
  803038:	48 83 ec 10          	sub    $0x10,%rsp
  80303c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803040:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803048:	48 be ce 39 80 00 00 	movabs $0x8039ce,%rsi
  80304f:	00 00 00 
  803052:	48 89 c7             	mov    %rax,%rdi
  803055:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
	return 0;
  803061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803066:	c9                   	leaveq 
  803067:	c3                   	retq   

0000000000803068 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803068:	55                   	push   %rbp
  803069:	48 89 e5             	mov    %rsp,%rbp
  80306c:	53                   	push   %rbx
  80306d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803074:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80307b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803081:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803088:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80308f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803096:	84 c0                	test   %al,%al
  803098:	74 23                	je     8030bd <_panic+0x55>
  80309a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8030a1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8030a5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8030a9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8030ad:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8030b1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8030b5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8030b9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8030bd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8030c4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8030cb:	00 00 00 
  8030ce:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8030d5:	00 00 00 
  8030d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030dc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8030e3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8030ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8030f1:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8030f8:	00 00 00 
  8030fb:	48 8b 18             	mov    (%rax),%rbx
  8030fe:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803110:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803117:	41 89 c8             	mov    %ecx,%r8d
  80311a:	48 89 d1             	mov    %rdx,%rcx
  80311d:	48 89 da             	mov    %rbx,%rdx
  803120:	89 c6                	mov    %eax,%esi
  803122:	48 bf d8 39 80 00 00 	movabs $0x8039d8,%rdi
  803129:	00 00 00 
  80312c:	b8 00 00 00 00       	mov    $0x0,%eax
  803131:	49 b9 72 02 80 00 00 	movabs $0x800272,%r9
  803138:	00 00 00 
  80313b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80313e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803145:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80314c:	48 89 d6             	mov    %rdx,%rsi
  80314f:	48 89 c7             	mov    %rax,%rdi
  803152:	48 b8 c6 01 80 00 00 	movabs $0x8001c6,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
	cprintf("\n");
  80315e:	48 bf fb 39 80 00 00 	movabs $0x8039fb,%rdi
  803165:	00 00 00 
  803168:	b8 00 00 00 00       	mov    $0x0,%eax
  80316d:	48 ba 72 02 80 00 00 	movabs $0x800272,%rdx
  803174:	00 00 00 
  803177:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803179:	cc                   	int3   
  80317a:	eb fd                	jmp    803179 <_panic+0x111>

000000000080317c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80317c:	55                   	push   %rbp
  80317d:	48 89 e5             	mov    %rsp,%rbp
  803180:	48 83 ec 30          	sub    $0x30,%rsp
  803184:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803188:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80318c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803190:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803197:	00 00 00 
  80319a:	48 8b 00             	mov    (%rax),%rax
  80319d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	75 3c                	jne    8031e3 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8031a7:	48 b8 da 16 80 00 00 	movabs $0x8016da,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	callq  *%rax
  8031b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8031b8:	48 63 d0             	movslq %eax,%rdx
  8031bb:	48 89 d0             	mov    %rdx,%rax
  8031be:	48 c1 e0 03          	shl    $0x3,%rax
  8031c2:	48 01 d0             	add    %rdx,%rax
  8031c5:	48 c1 e0 05          	shl    $0x5,%rax
  8031c9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8031d0:	00 00 00 
  8031d3:	48 01 c2             	add    %rax,%rdx
  8031d6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031dd:	00 00 00 
  8031e0:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8031e3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031e8:	75 0e                	jne    8031f8 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8031ea:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8031f1:	00 00 00 
  8031f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8031f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031fc:	48 89 c7             	mov    %rax,%rdi
  8031ff:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
  80320b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80320e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803212:	79 19                	jns    80322d <ipc_recv+0xb1>
		*from_env_store = 0;
  803214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803218:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80321e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803222:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322b:	eb 53                	jmp    803280 <ipc_recv+0x104>
	}
	if(from_env_store)
  80322d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803232:	74 19                	je     80324d <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803234:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80323b:	00 00 00 
  80323e:	48 8b 00             	mov    (%rax),%rax
  803241:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803247:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324b:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80324d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803252:	74 19                	je     80326d <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803254:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80325b:	00 00 00 
  80325e:	48 8b 00             	mov    (%rax),%rax
  803261:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803267:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  80326d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803274:	00 00 00 
  803277:	48 8b 00             	mov    (%rax),%rax
  80327a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803280:	c9                   	leaveq 
  803281:	c3                   	retq   

0000000000803282 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803282:	55                   	push   %rbp
  803283:	48 89 e5             	mov    %rsp,%rbp
  803286:	48 83 ec 30          	sub    $0x30,%rsp
  80328a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80328d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803290:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803294:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803297:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80329c:	75 0e                	jne    8032ac <ipc_send+0x2a>
		pg = (void*)UTOP;
  80329e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8032a5:	00 00 00 
  8032a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8032ac:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8032af:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8032b2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b9:	89 c7                	mov    %eax,%edi
  8032bb:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
  8032c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8032ca:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032ce:	75 0c                	jne    8032dc <ipc_send+0x5a>
			sys_yield();
  8032d0:	48 b8 18 17 80 00 00 	movabs $0x801718,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8032dc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8032e0:	74 ca                	je     8032ac <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8032e2:	c9                   	leaveq 
  8032e3:	c3                   	retq   

00000000008032e4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8032e4:	55                   	push   %rbp
  8032e5:	48 89 e5             	mov    %rsp,%rbp
  8032e8:	48 83 ec 14          	sub    $0x14,%rsp
  8032ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8032ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032f6:	eb 5e                	jmp    803356 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8032f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032ff:	00 00 00 
  803302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803305:	48 63 d0             	movslq %eax,%rdx
  803308:	48 89 d0             	mov    %rdx,%rax
  80330b:	48 c1 e0 03          	shl    $0x3,%rax
  80330f:	48 01 d0             	add    %rdx,%rax
  803312:	48 c1 e0 05          	shl    $0x5,%rax
  803316:	48 01 c8             	add    %rcx,%rax
  803319:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80331f:	8b 00                	mov    (%rax),%eax
  803321:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803324:	75 2c                	jne    803352 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803326:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80332d:	00 00 00 
  803330:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803333:	48 63 d0             	movslq %eax,%rdx
  803336:	48 89 d0             	mov    %rdx,%rax
  803339:	48 c1 e0 03          	shl    $0x3,%rax
  80333d:	48 01 d0             	add    %rdx,%rax
  803340:	48 c1 e0 05          	shl    $0x5,%rax
  803344:	48 01 c8             	add    %rcx,%rax
  803347:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80334d:	8b 40 08             	mov    0x8(%rax),%eax
  803350:	eb 12                	jmp    803364 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803352:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803356:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80335d:	7e 99                	jle    8032f8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80335f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803364:	c9                   	leaveq 
  803365:	c3                   	retq   

0000000000803366 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803366:	55                   	push   %rbp
  803367:	48 89 e5             	mov    %rsp,%rbp
  80336a:	48 83 ec 18          	sub    $0x18,%rsp
  80336e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803376:	48 c1 e8 15          	shr    $0x15,%rax
  80337a:	48 89 c2             	mov    %rax,%rdx
  80337d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803384:	01 00 00 
  803387:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80338b:	83 e0 01             	and    $0x1,%eax
  80338e:	48 85 c0             	test   %rax,%rax
  803391:	75 07                	jne    80339a <pageref+0x34>
		return 0;
  803393:	b8 00 00 00 00       	mov    $0x0,%eax
  803398:	eb 53                	jmp    8033ed <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80339a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339e:	48 c1 e8 0c          	shr    $0xc,%rax
  8033a2:	48 89 c2             	mov    %rax,%rdx
  8033a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033ac:	01 00 00 
  8033af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8033b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bb:	83 e0 01             	and    $0x1,%eax
  8033be:	48 85 c0             	test   %rax,%rax
  8033c1:	75 07                	jne    8033ca <pageref+0x64>
		return 0;
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	eb 23                	jmp    8033ed <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8033ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8033d2:	48 89 c2             	mov    %rax,%rdx
  8033d5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8033dc:	00 00 00 
  8033df:	48 c1 e2 04          	shl    $0x4,%rdx
  8033e3:	48 01 d0             	add    %rdx,%rax
  8033e6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8033ea:	0f b7 c0             	movzwl %ax,%eax
}
  8033ed:	c9                   	leaveq 
  8033ee:	c3                   	retq   
