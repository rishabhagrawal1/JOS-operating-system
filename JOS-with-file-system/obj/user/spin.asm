
obj/user/spin.debug:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
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
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 55 1e 80 00 00 	movabs $0x801e55,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf a8 3c 80 00 00 	movabs $0x803ca8,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf c8 3c 80 00 00 	movabs $0x803cc8,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf f0 3c 80 00 00 	movabs $0x803cf0,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 10          	sub    $0x10,%rsp
  800150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800157:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	25 ff 03 00 00       	and    $0x3ff,%eax
  800168:	48 63 d0             	movslq %eax,%rdx
  80016b:	48 89 d0             	mov    %rdx,%rax
  80016e:	48 c1 e0 03          	shl    $0x3,%rax
  800172:	48 01 d0             	add    %rdx,%rax
  800175:	48 c1 e0 05          	shl    $0x5,%rax
  800179:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800180:	00 00 00 
  800183:	48 01 c2             	add    %rax,%rdx
  800186:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018d:	00 00 00 
  800190:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800197:	7e 14                	jle    8001ad <libmain+0x65>
		binaryname = argv[0];
  800199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019d:	48 8b 10             	mov    (%rax),%rdx
  8001a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a7:	00 00 00 
  8001aa:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b4:	48 89 d6             	mov    %rdx,%rsi
  8001b7:	89 c7                	mov    %eax,%edi
  8001b9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c0:	00 00 00 
  8001c3:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001c5:	48 b8 d3 01 80 00 00 	movabs $0x8001d3,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
}
  8001d1:	c9                   	leaveq 
  8001d2:	c3                   	retq   

00000000008001d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d3:	55                   	push   %rbp
  8001d4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001d7:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e8:	48 b8 3f 17 80 00 00 	movabs $0x80173f,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	callq  *%rax

}
  8001f4:	5d                   	pop    %rbp
  8001f5:	c3                   	retq   

00000000008001f6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f6:	55                   	push   %rbp
  8001f7:	48 89 e5             	mov    %rsp,%rbp
  8001fa:	48 83 ec 10          	sub    $0x10,%rsp
  8001fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800201:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800209:	8b 00                	mov    (%rax),%eax
  80020b:	8d 48 01             	lea    0x1(%rax),%ecx
  80020e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800212:	89 0a                	mov    %ecx,(%rdx)
  800214:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800217:	89 d1                	mov    %edx,%ecx
  800219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021d:	48 98                	cltq   
  80021f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800227:	8b 00                	mov    (%rax),%eax
  800229:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022e:	75 2c                	jne    80025c <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800234:	8b 00                	mov    (%rax),%eax
  800236:	48 98                	cltq   
  800238:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023c:	48 83 c2 08          	add    $0x8,%rdx
  800240:	48 89 c6             	mov    %rax,%rsi
  800243:	48 89 d7             	mov    %rdx,%rdi
  800246:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
		b->idx = 0;
  800252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800256:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80025c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800260:	8b 40 04             	mov    0x4(%rax),%eax
  800263:	8d 50 01             	lea    0x1(%rax),%edx
  800266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80026d:	c9                   	leaveq 
  80026e:	c3                   	retq   

000000000080026f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026f:	55                   	push   %rbp
  800270:	48 89 e5             	mov    %rsp,%rbp
  800273:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800281:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800288:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80028f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800296:	48 8b 0a             	mov    (%rdx),%rcx
  800299:	48 89 08             	mov    %rcx,(%rax)
  80029c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b3:	00 00 00 
	b.cnt = 0;
  8002b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002c0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002c7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002ce:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d5:	48 89 c6             	mov    %rax,%rsi
  8002d8:	48 bf f6 01 80 00 00 	movabs $0x8001f6,%rdi
  8002df:	00 00 00 
  8002e2:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002ee:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f4:	48 98                	cltq   
  8002f6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002fd:	48 83 c2 08          	add    $0x8,%rdx
  800301:	48 89 c6             	mov    %rax,%rsi
  800304:	48 89 d7             	mov    %rdx,%rdi
  800307:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80030e:	00 00 00 
  800311:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800313:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   

000000000080031b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031b:	55                   	push   %rbp
  80031c:	48 89 e5             	mov    %rsp,%rbp
  80031f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800326:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80032d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800334:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800342:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800349:	84 c0                	test   %al,%al
  80034b:	74 20                	je     80036d <cprintf+0x52>
  80034d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800351:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800355:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800359:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80035d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800361:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800365:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800369:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80036d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800374:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037b:	00 00 00 
  80037e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800385:	00 00 00 
  800388:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800393:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003a1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003af:	48 8b 0a             	mov    (%rdx),%rcx
  8003b2:	48 89 08             	mov    %rcx,(%rax)
  8003b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003c5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d3:	48 89 d6             	mov    %rdx,%rsi
  8003d6:	48 89 c7             	mov    %rax,%rdi
  8003d9:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
  8003e5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003eb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	53                   	push   %rbx
  8003f8:	48 83 ec 38          	sub    $0x38,%rsp
  8003fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800400:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800404:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800408:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80040f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800413:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800416:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041a:	77 3b                	ja     800457 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80041f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800423:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800426:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042a:	ba 00 00 00 00       	mov    $0x0,%edx
  80042f:	48 f7 f3             	div    %rbx
  800432:	48 89 c2             	mov    %rax,%rdx
  800435:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800438:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80043f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800443:	41 89 f9             	mov    %edi,%r9d
  800446:	48 89 c7             	mov    %rax,%rdi
  800449:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  800450:	00 00 00 
  800453:	ff d0                	callq  *%rax
  800455:	eb 1e                	jmp    800475 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800457:	eb 12                	jmp    80046b <printnum+0x78>
			putch(padc, putdat);
  800459:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800464:	48 89 ce             	mov    %rcx,%rsi
  800467:	89 d7                	mov    %edx,%edi
  800469:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80046f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800473:	7f e4                	jg     800459 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800475:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80047c:	ba 00 00 00 00       	mov    $0x0,%edx
  800481:	48 f7 f1             	div    %rcx
  800484:	48 89 d0             	mov    %rdx,%rax
  800487:	48 ba 08 3f 80 00 00 	movabs $0x803f08,%rdx
  80048e:	00 00 00 
  800491:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800495:	0f be d0             	movsbl %al,%edx
  800498:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80049c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a0:	48 89 ce             	mov    %rcx,%rsi
  8004a3:	89 d7                	mov    %edx,%edi
  8004a5:	ff d0                	callq  *%rax
}
  8004a7:	48 83 c4 38          	add    $0x38,%rsp
  8004ab:	5b                   	pop    %rbx
  8004ac:	5d                   	pop    %rbp
  8004ad:	c3                   	retq   

00000000008004ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ae:	55                   	push   %rbp
  8004af:	48 89 e5             	mov    %rsp,%rbp
  8004b2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ba:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004bd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c1:	7e 52                	jle    800515 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	8b 00                	mov    (%rax),%eax
  8004c9:	83 f8 30             	cmp    $0x30,%eax
  8004cc:	73 24                	jae    8004f2 <getuint+0x44>
  8004ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004da:	8b 00                	mov    (%rax),%eax
  8004dc:	89 c0                	mov    %eax,%eax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e5:	8b 12                	mov    (%rdx),%edx
  8004e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ee:	89 0a                	mov    %ecx,(%rdx)
  8004f0:	eb 17                	jmp    800509 <getuint+0x5b>
  8004f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fa:	48 89 d0             	mov    %rdx,%rax
  8004fd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800501:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800505:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800509:	48 8b 00             	mov    (%rax),%rax
  80050c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800510:	e9 a3 00 00 00       	jmpq   8005b8 <getuint+0x10a>
	else if (lflag)
  800515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800519:	74 4f                	je     80056a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051f:	8b 00                	mov    (%rax),%eax
  800521:	83 f8 30             	cmp    $0x30,%eax
  800524:	73 24                	jae    80054a <getuint+0x9c>
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	89 c0                	mov    %eax,%eax
  800536:	48 01 d0             	add    %rdx,%rax
  800539:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053d:	8b 12                	mov    (%rdx),%edx
  80053f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800546:	89 0a                	mov    %ecx,(%rdx)
  800548:	eb 17                	jmp    800561 <getuint+0xb3>
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800552:	48 89 d0             	mov    %rdx,%rax
  800555:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800559:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800561:	48 8b 00             	mov    (%rax),%rax
  800564:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800568:	eb 4e                	jmp    8005b8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056e:	8b 00                	mov    (%rax),%eax
  800570:	83 f8 30             	cmp    $0x30,%eax
  800573:	73 24                	jae    800599 <getuint+0xeb>
  800575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800579:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	8b 00                	mov    (%rax),%eax
  800583:	89 c0                	mov    %eax,%eax
  800585:	48 01 d0             	add    %rdx,%rax
  800588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058c:	8b 12                	mov    (%rdx),%edx
  80058e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800591:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800595:	89 0a                	mov    %ecx,(%rdx)
  800597:	eb 17                	jmp    8005b0 <getuint+0x102>
  800599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a1:	48 89 d0             	mov    %rdx,%rax
  8005a4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ac:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b0:	8b 00                	mov    (%rax),%eax
  8005b2:	89 c0                	mov    %eax,%eax
  8005b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005bc:	c9                   	leaveq 
  8005bd:	c3                   	retq   

00000000008005be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005be:	55                   	push   %rbp
  8005bf:	48 89 e5             	mov    %rsp,%rbp
  8005c2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d1:	7e 52                	jle    800625 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	83 f8 30             	cmp    $0x30,%eax
  8005dc:	73 24                	jae    800602 <getint+0x44>
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	89 c0                	mov    %eax,%eax
  8005ee:	48 01 d0             	add    %rdx,%rax
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	8b 12                	mov    (%rdx),%edx
  8005f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	89 0a                	mov    %ecx,(%rdx)
  800600:	eb 17                	jmp    800619 <getint+0x5b>
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800619:	48 8b 00             	mov    (%rax),%rax
  80061c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800620:	e9 a3 00 00 00       	jmpq   8006c8 <getint+0x10a>
	else if (lflag)
  800625:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800629:	74 4f                	je     80067a <getint+0xbc>
		x=va_arg(*ap, long);
  80062b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062f:	8b 00                	mov    (%rax),%eax
  800631:	83 f8 30             	cmp    $0x30,%eax
  800634:	73 24                	jae    80065a <getint+0x9c>
  800636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	89 c0                	mov    %eax,%eax
  800646:	48 01 d0             	add    %rdx,%rax
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	8b 12                	mov    (%rdx),%edx
  80064f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	89 0a                	mov    %ecx,(%rdx)
  800658:	eb 17                	jmp    800671 <getint+0xb3>
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800662:	48 89 d0             	mov    %rdx,%rax
  800665:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800671:	48 8b 00             	mov    (%rax),%rax
  800674:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800678:	eb 4e                	jmp    8006c8 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	83 f8 30             	cmp    $0x30,%eax
  800683:	73 24                	jae    8006a9 <getint+0xeb>
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	8b 00                	mov    (%rax),%eax
  800693:	89 c0                	mov    %eax,%eax
  800695:	48 01 d0             	add    %rdx,%rax
  800698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069c:	8b 12                	mov    (%rdx),%edx
  80069e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	89 0a                	mov    %ecx,(%rdx)
  8006a7:	eb 17                	jmp    8006c0 <getint+0x102>
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b1:	48 89 d0             	mov    %rdx,%rax
  8006b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c0:	8b 00                	mov    (%rax),%eax
  8006c2:	48 98                	cltq   
  8006c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006cc:	c9                   	leaveq 
  8006cd:	c3                   	retq   

00000000008006ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ce:	55                   	push   %rbp
  8006cf:	48 89 e5             	mov    %rsp,%rbp
  8006d2:	41 54                	push   %r12
  8006d4:	53                   	push   %rbx
  8006d5:	48 83 ec 60          	sub    $0x60,%rsp
  8006d9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006dd:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006e9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ed:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f1:	48 8b 0a             	mov    (%rdx),%rcx
  8006f4:	48 89 08             	mov    %rcx,(%rax)
  8006f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800703:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x52>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 cc 04 00 00    	je     800bdd <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800711:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800715:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800719:	48 89 d6             	mov    %rdx,%rsi
  80071c:	89 df                	mov    %ebx,%edi
  80071e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800724:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800728:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80072c:	0f b6 00             	movzbl (%rax),%eax
  80072f:	0f b6 d8             	movzbl %al,%ebx
  800732:	83 fb 25             	cmp    $0x25,%ebx
  800735:	75 d2                	jne    800709 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800737:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80073b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800742:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800749:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800750:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800757:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80075f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800763:	0f b6 00             	movzbl (%rax),%eax
  800766:	0f b6 d8             	movzbl %al,%ebx
  800769:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80076c:	83 f8 55             	cmp    $0x55,%eax
  80076f:	0f 87 34 04 00 00    	ja     800ba9 <vprintfmt+0x4db>
  800775:	89 c0                	mov    %eax,%eax
  800777:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80077e:	00 
  80077f:	48 b8 30 3f 80 00 00 	movabs $0x803f30,%rax
  800786:	00 00 00 
  800789:	48 01 d0             	add    %rdx,%rax
  80078c:	48 8b 00             	mov    (%rax),%rax
  80078f:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800791:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800795:	eb c0                	jmp    800757 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800797:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80079b:	eb ba                	jmp    800757 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a7:	89 d0                	mov    %edx,%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	01 d0                	add    %edx,%eax
  8007ae:	01 c0                	add    %eax,%eax
  8007b0:	01 d8                	add    %ebx,%eax
  8007b2:	83 e8 30             	sub    $0x30,%eax
  8007b5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bc:	0f b6 00             	movzbl (%rax),%eax
  8007bf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c5:	7e 0c                	jle    8007d3 <vprintfmt+0x105>
  8007c7:	83 fb 39             	cmp    $0x39,%ebx
  8007ca:	7f 07                	jg     8007d3 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d1                	jmp    8007a4 <vprintfmt+0xd6>
			goto process_precision;
  8007d3:	eb 58                	jmp    80082d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d8:	83 f8 30             	cmp    $0x30,%eax
  8007db:	73 17                	jae    8007f4 <vprintfmt+0x126>
  8007dd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e4:	89 c0                	mov    %eax,%eax
  8007e6:	48 01 d0             	add    %rdx,%rax
  8007e9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ec:	83 c2 08             	add    $0x8,%edx
  8007ef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f2:	eb 0f                	jmp    800803 <vprintfmt+0x135>
  8007f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f8:	48 89 d0             	mov    %rdx,%rax
  8007fb:	48 83 c2 08          	add    $0x8,%rdx
  8007ff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800803:	8b 00                	mov    (%rax),%eax
  800805:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800808:	eb 23                	jmp    80082d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80080a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080e:	79 0c                	jns    80081c <vprintfmt+0x14e>
				width = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800817:	e9 3b ff ff ff       	jmpq   800757 <vprintfmt+0x89>
  80081c:	e9 36 ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800821:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800828:	e9 2a ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800831:	79 12                	jns    800845 <vprintfmt+0x177>
				width = precision, precision = -1;
  800833:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800836:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800839:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800840:	e9 12 ff ff ff       	jmpq   800757 <vprintfmt+0x89>
  800845:	e9 0d ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80084e:	e9 04 ff ff ff       	jmpq   800757 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800853:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800856:	83 f8 30             	cmp    $0x30,%eax
  800859:	73 17                	jae    800872 <vprintfmt+0x1a4>
  80085b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800862:	89 c0                	mov    %eax,%eax
  800864:	48 01 d0             	add    %rdx,%rax
  800867:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086a:	83 c2 08             	add    $0x8,%edx
  80086d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800870:	eb 0f                	jmp    800881 <vprintfmt+0x1b3>
  800872:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800876:	48 89 d0             	mov    %rdx,%rax
  800879:	48 83 c2 08          	add    $0x8,%rdx
  80087d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800881:	8b 10                	mov    (%rax),%edx
  800883:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800887:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088b:	48 89 ce             	mov    %rcx,%rsi
  80088e:	89 d7                	mov    %edx,%edi
  800890:	ff d0                	callq  *%rax
			break;
  800892:	e9 40 03 00 00       	jmpq   800bd7 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800897:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 17                	jae    8008b6 <vprintfmt+0x1e8>
  80089f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a6:	89 c0                	mov    %eax,%eax
  8008a8:	48 01 d0             	add    %rdx,%rax
  8008ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ae:	83 c2 08             	add    $0x8,%edx
  8008b1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b4:	eb 0f                	jmp    8008c5 <vprintfmt+0x1f7>
  8008b6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ba:	48 89 d0             	mov    %rdx,%rax
  8008bd:	48 83 c2 08          	add    $0x8,%rdx
  8008c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	79 02                	jns    8008cd <vprintfmt+0x1ff>
				err = -err;
  8008cb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008cd:	83 fb 10             	cmp    $0x10,%ebx
  8008d0:	7f 16                	jg     8008e8 <vprintfmt+0x21a>
  8008d2:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  8008d9:	00 00 00 
  8008dc:	48 63 d3             	movslq %ebx,%rdx
  8008df:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e3:	4d 85 e4             	test   %r12,%r12
  8008e6:	75 2e                	jne    800916 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f0:	89 d9                	mov    %ebx,%ecx
  8008f2:	48 ba 19 3f 80 00 00 	movabs $0x803f19,%rdx
  8008f9:	00 00 00 
  8008fc:	48 89 c7             	mov    %rax,%rdi
  8008ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800904:	49 b8 e6 0b 80 00 00 	movabs $0x800be6,%r8
  80090b:	00 00 00 
  80090e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 c1 02 00 00       	jmpq   800bd7 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091e:	4c 89 e1             	mov    %r12,%rcx
  800921:	48 ba 22 3f 80 00 00 	movabs $0x803f22,%rdx
  800928:	00 00 00 
  80092b:	48 89 c7             	mov    %rax,%rdi
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
  800933:	49 b8 e6 0b 80 00 00 	movabs $0x800be6,%r8
  80093a:	00 00 00 
  80093d:	41 ff d0             	callq  *%r8
			break;
  800940:	e9 92 02 00 00       	jmpq   800bd7 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800945:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800948:	83 f8 30             	cmp    $0x30,%eax
  80094b:	73 17                	jae    800964 <vprintfmt+0x296>
  80094d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800951:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800954:	89 c0                	mov    %eax,%eax
  800956:	48 01 d0             	add    %rdx,%rax
  800959:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095c:	83 c2 08             	add    $0x8,%edx
  80095f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800962:	eb 0f                	jmp    800973 <vprintfmt+0x2a5>
  800964:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800968:	48 89 d0             	mov    %rdx,%rax
  80096b:	48 83 c2 08          	add    $0x8,%rdx
  80096f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800973:	4c 8b 20             	mov    (%rax),%r12
  800976:	4d 85 e4             	test   %r12,%r12
  800979:	75 0a                	jne    800985 <vprintfmt+0x2b7>
				p = "(null)";
  80097b:	49 bc 25 3f 80 00 00 	movabs $0x803f25,%r12
  800982:	00 00 00 
			if (width > 0 && padc != '-')
  800985:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800989:	7e 3f                	jle    8009ca <vprintfmt+0x2fc>
  80098b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80098f:	74 39                	je     8009ca <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800994:	48 98                	cltq   
  800996:	48 89 c6             	mov    %rax,%rsi
  800999:	4c 89 e7             	mov    %r12,%rdi
  80099c:	48 b8 92 0e 80 00 00 	movabs $0x800e92,%rax
  8009a3:	00 00 00 
  8009a6:	ff d0                	callq  *%rax
  8009a8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009ab:	eb 17                	jmp    8009c4 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ad:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b9:	48 89 ce             	mov    %rcx,%rsi
  8009bc:	89 d7                	mov    %edx,%edi
  8009be:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c8:	7f e3                	jg     8009ad <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	eb 37                	jmp    800a03 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d0:	74 1e                	je     8009f0 <vprintfmt+0x322>
  8009d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d5:	7e 05                	jle    8009dc <vprintfmt+0x30e>
  8009d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8009da:	7e 14                	jle    8009f0 <vprintfmt+0x322>
					putch('?', putdat);
  8009dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e4:	48 89 d6             	mov    %rdx,%rsi
  8009e7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009ec:	ff d0                	callq  *%rax
  8009ee:	eb 0f                	jmp    8009ff <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f8:	48 89 d6             	mov    %rdx,%rsi
  8009fb:	89 df                	mov    %ebx,%edi
  8009fd:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ff:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a03:	4c 89 e0             	mov    %r12,%rax
  800a06:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a0a:	0f b6 00             	movzbl (%rax),%eax
  800a0d:	0f be d8             	movsbl %al,%ebx
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	74 10                	je     800a24 <vprintfmt+0x356>
  800a14:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a18:	78 b2                	js     8009cc <vprintfmt+0x2fe>
  800a1a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a22:	79 a8                	jns    8009cc <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a24:	eb 16                	jmp    800a3c <vprintfmt+0x36e>
				putch(' ', putdat);
  800a26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2e:	48 89 d6             	mov    %rdx,%rsi
  800a31:	bf 20 00 00 00       	mov    $0x20,%edi
  800a36:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a38:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a40:	7f e4                	jg     800a26 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a42:	e9 90 01 00 00       	jmpq   800bd7 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4b:	be 03 00 00 00       	mov    $0x3,%esi
  800a50:	48 89 c7             	mov    %rax,%rdi
  800a53:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800a5a:	00 00 00 
  800a5d:	ff d0                	callq  *%rax
  800a5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a67:	48 85 c0             	test   %rax,%rax
  800a6a:	79 1d                	jns    800a89 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a74:	48 89 d6             	mov    %rdx,%rsi
  800a77:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a7c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a82:	48 f7 d8             	neg    %rax
  800a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a89:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a90:	e9 d5 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a95:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a99:	be 03 00 00 00       	mov    $0x3,%esi
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800aa8:	00 00 00 
  800aab:	ff d0                	callq  *%rax
  800aad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab8:	e9 ad 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800abd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ac0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac4:	89 d6                	mov    %edx,%esi
  800ac6:	48 89 c7             	mov    %rax,%rdi
  800ac9:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800ad0:	00 00 00 
  800ad3:	ff d0                	callq  *%rax
  800ad5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ae0:	e9 85 00 00 00       	jmpq   800b6a <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800ae5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aed:	48 89 d6             	mov    %rdx,%rsi
  800af0:	bf 30 00 00 00       	mov    $0x30,%edi
  800af5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 d6             	mov    %rdx,%rsi
  800b02:	bf 78 00 00 00       	mov    $0x78,%edi
  800b07:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0c:	83 f8 30             	cmp    $0x30,%eax
  800b0f:	73 17                	jae    800b28 <vprintfmt+0x45a>
  800b11:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b18:	89 c0                	mov    %eax,%eax
  800b1a:	48 01 d0             	add    %rdx,%rax
  800b1d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b20:	83 c2 08             	add    $0x8,%edx
  800b23:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b26:	eb 0f                	jmp    800b37 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2c:	48 89 d0             	mov    %rdx,%rax
  800b2f:	48 83 c2 08          	add    $0x8,%rdx
  800b33:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b37:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b3e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b45:	eb 23                	jmp    800b6a <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4b:	be 03 00 00 00       	mov    $0x3,%esi
  800b50:	48 89 c7             	mov    %rax,%rdi
  800b53:	48 b8 ae 04 80 00 00 	movabs $0x8004ae,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	callq  *%rax
  800b5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b63:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b72:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b79:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b81:	45 89 c1             	mov    %r8d,%r9d
  800b84:	41 89 f8             	mov    %edi,%r8d
  800b87:	48 89 c7             	mov    %rax,%rdi
  800b8a:	48 b8 f3 03 80 00 00 	movabs $0x8003f3,%rax
  800b91:	00 00 00 
  800b94:	ff d0                	callq  *%rax
			break;
  800b96:	eb 3f                	jmp    800bd7 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	48 89 d6             	mov    %rdx,%rsi
  800ba3:	89 df                	mov    %ebx,%edi
  800ba5:	ff d0                	callq  *%rax
			break;
  800ba7:	eb 2e                	jmp    800bd7 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb1:	48 89 d6             	mov    %rdx,%rsi
  800bb4:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bbb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc0:	eb 05                	jmp    800bc7 <vprintfmt+0x4f9>
  800bc2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcb:	48 83 e8 01          	sub    $0x1,%rax
  800bcf:	0f b6 00             	movzbl (%rax),%eax
  800bd2:	3c 25                	cmp    $0x25,%al
  800bd4:	75 ec                	jne    800bc2 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bd6:	90                   	nop
		}
	}
  800bd7:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd8:	e9 43 fb ff ff       	jmpq   800720 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bdd:	48 83 c4 60          	add    $0x60,%rsp
  800be1:	5b                   	pop    %rbx
  800be2:	41 5c                	pop    %r12
  800be4:	5d                   	pop    %rbp
  800be5:	c3                   	retq   

0000000000800be6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be6:	55                   	push   %rbp
  800be7:	48 89 e5             	mov    %rsp,%rbp
  800bea:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf1:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf8:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c14:	84 c0                	test   %al,%al
  800c16:	74 20                	je     800c38 <printfmt+0x52>
  800c18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c38:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c46:	00 00 00 
  800c49:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c50:	00 00 00 
  800c53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c57:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c65:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6c:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c73:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c7a:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c81:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c88:	48 89 c7             	mov    %rax,%rdi
  800c8b:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800c92:	00 00 00 
  800c95:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c97:	c9                   	leaveq 
  800c98:	c3                   	retq   

0000000000800c99 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c99:	55                   	push   %rbp
  800c9a:	48 89 e5             	mov    %rsp,%rbp
  800c9d:	48 83 ec 10          	sub    $0x10,%rsp
  800ca1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cac:	8b 40 10             	mov    0x10(%rax),%eax
  800caf:	8d 50 01             	lea    0x1(%rax),%edx
  800cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbd:	48 8b 10             	mov    (%rax),%rdx
  800cc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc8:	48 39 c2             	cmp    %rax,%rdx
  800ccb:	73 17                	jae    800ce4 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdc:	48 89 0a             	mov    %rcx,(%rdx)
  800cdf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce2:	88 10                	mov    %dl,(%rax)
}
  800ce4:	c9                   	leaveq 
  800ce5:	c3                   	retq   

0000000000800ce6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce6:	55                   	push   %rbp
  800ce7:	48 89 e5             	mov    %rsp,%rbp
  800cea:	48 83 ec 50          	sub    $0x50,%rsp
  800cee:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf2:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf5:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf9:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d01:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d05:	48 8b 0a             	mov    (%rdx),%rcx
  800d08:	48 89 08             	mov    %rcx,(%rax)
  800d0b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d13:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d17:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d23:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d26:	48 98                	cltq   
  800d28:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d30:	48 01 d0             	add    %rdx,%rax
  800d33:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d3e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d43:	74 06                	je     800d4b <vsnprintf+0x65>
  800d45:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d49:	7f 07                	jg     800d52 <vsnprintf+0x6c>
		return -E_INVAL;
  800d4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d50:	eb 2f                	jmp    800d81 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d52:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d56:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d5a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d5e:	48 89 c6             	mov    %rax,%rsi
  800d61:	48 bf 99 0c 80 00 00 	movabs $0x800c99,%rdi
  800d68:	00 00 00 
  800d6b:	48 b8 ce 06 80 00 00 	movabs $0x8006ce,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d7b:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d7e:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d81:	c9                   	leaveq 
  800d82:	c3                   	retq   

0000000000800d83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d83:	55                   	push   %rbp
  800d84:	48 89 e5             	mov    %rsp,%rbp
  800d87:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d8e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d95:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d9b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db0:	84 c0                	test   %al,%al
  800db2:	74 20                	je     800dd4 <snprintf+0x51>
  800db4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd4:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ddb:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de2:	00 00 00 
  800de5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dec:	00 00 00 
  800def:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dfa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e01:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e08:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e16:	48 8b 0a             	mov    (%rdx),%rcx
  800e19:	48 89 08             	mov    %rcx,(%rax)
  800e1c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e20:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e24:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e28:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e2c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e33:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e3a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e40:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e47:	48 89 c7             	mov    %rax,%rdi
  800e4a:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  800e51:	00 00 00 
  800e54:	ff d0                	callq  *%rax
  800e56:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e5c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e62:	c9                   	leaveq 
  800e63:	c3                   	retq   

0000000000800e64 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e64:	55                   	push   %rbp
  800e65:	48 89 e5             	mov    %rsp,%rbp
  800e68:	48 83 ec 18          	sub    $0x18,%rsp
  800e6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e77:	eb 09                	jmp    800e82 <strlen+0x1e>
		n++;
  800e79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e86:	0f b6 00             	movzbl (%rax),%eax
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 ec                	jne    800e79 <strlen+0x15>
		n++;
	return n;
  800e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e90:	c9                   	leaveq 
  800e91:	c3                   	retq   

0000000000800e92 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e92:	55                   	push   %rbp
  800e93:	48 89 e5             	mov    %rsp,%rbp
  800e96:	48 83 ec 20          	sub    $0x20,%rsp
  800e9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea9:	eb 0e                	jmp    800eb9 <strnlen+0x27>
		n++;
  800eab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eaf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ebe:	74 0b                	je     800ecb <strnlen+0x39>
  800ec0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec4:	0f b6 00             	movzbl (%rax),%eax
  800ec7:	84 c0                	test   %al,%al
  800ec9:	75 e0                	jne    800eab <strnlen+0x19>
		n++;
	return n;
  800ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ece:	c9                   	leaveq 
  800ecf:	c3                   	retq   

0000000000800ed0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed0:	55                   	push   %rbp
  800ed1:	48 89 e5             	mov    %rsp,%rbp
  800ed4:	48 83 ec 20          	sub    $0x20,%rsp
  800ed8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee8:	90                   	nop
  800ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f01:	0f b6 12             	movzbl (%rdx),%edx
  800f04:	88 10                	mov    %dl,(%rax)
  800f06:	0f b6 00             	movzbl (%rax),%eax
  800f09:	84 c0                	test   %al,%al
  800f0b:	75 dc                	jne    800ee9 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 20          	sub    $0x20,%rsp
  800f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f27:	48 89 c7             	mov    %rax,%rdi
  800f2a:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  800f31:	00 00 00 
  800f34:	ff d0                	callq  *%rax
  800f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3c:	48 63 d0             	movslq %eax,%rdx
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f43:	48 01 c2             	add    %rax,%rdx
  800f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4a:	48 89 c6             	mov    %rax,%rsi
  800f4d:	48 89 d7             	mov    %rdx,%rdi
  800f50:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
	return dst;
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f60:	c9                   	leaveq 
  800f61:	c3                   	retq   

0000000000800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 83 ec 28          	sub    $0x28,%rsp
  800f6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f7e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f85:	00 
  800f86:	eb 2a                	jmp    800fb2 <strncpy+0x50>
		*dst++ = *src;
  800f88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f94:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f98:	0f b6 12             	movzbl (%rdx),%edx
  800f9b:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa1:	0f b6 00             	movzbl (%rax),%eax
  800fa4:	84 c0                	test   %al,%al
  800fa6:	74 05                	je     800fad <strncpy+0x4b>
			src++;
  800fa8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fba:	72 cc                	jb     800f88 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 28          	sub    $0x28,%rsp
  800fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fde:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe3:	74 3d                	je     801022 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe5:	eb 1d                	jmp    801004 <strlcpy+0x42>
			*dst++ = *src++;
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ffb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fff:	0f b6 12             	movzbl (%rdx),%edx
  801002:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801004:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801009:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100e:	74 0b                	je     80101b <strlcpy+0x59>
  801010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801014:	0f b6 00             	movzbl (%rax),%eax
  801017:	84 c0                	test   %al,%al
  801019:	75 cc                	jne    800fe7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80101b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801022:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102a:	48 29 c2             	sub    %rax,%rdx
  80102d:	48 89 d0             	mov    %rdx,%rax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 10          	sub    $0x10,%rsp
  80103a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801042:	eb 0a                	jmp    80104e <strcmp+0x1c>
		p++, q++;
  801044:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801049:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	74 12                	je     80106b <strcmp+0x39>
  801059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105d:	0f b6 10             	movzbl (%rax),%edx
  801060:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801064:	0f b6 00             	movzbl (%rax),%eax
  801067:	38 c2                	cmp    %al,%dl
  801069:	74 d9                	je     801044 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80106b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801079:	0f b6 00             	movzbl (%rax),%eax
  80107c:	0f b6 c0             	movzbl %al,%eax
  80107f:	29 c2                	sub    %eax,%edx
  801081:	89 d0                	mov    %edx,%eax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 18          	sub    $0x18,%rsp
  80108d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801091:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801095:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801099:	eb 0f                	jmp    8010aa <strncmp+0x25>
		n--, p++, q++;
  80109b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010af:	74 1d                	je     8010ce <strncmp+0x49>
  8010b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b5:	0f b6 00             	movzbl (%rax),%eax
  8010b8:	84 c0                	test   %al,%al
  8010ba:	74 12                	je     8010ce <strncmp+0x49>
  8010bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c0:	0f b6 10             	movzbl (%rax),%edx
  8010c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c7:	0f b6 00             	movzbl (%rax),%eax
  8010ca:	38 c2                	cmp    %al,%dl
  8010cc:	74 cd                	je     80109b <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d3:	75 07                	jne    8010dc <strncmp+0x57>
		return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb 18                	jmp    8010f4 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e0:	0f b6 00             	movzbl (%rax),%eax
  8010e3:	0f b6 d0             	movzbl %al,%edx
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	0f b6 00             	movzbl (%rax),%eax
  8010ed:	0f b6 c0             	movzbl %al,%eax
  8010f0:	29 c2                	sub    %eax,%edx
  8010f2:	89 d0                	mov    %edx,%eax
}
  8010f4:	c9                   	leaveq 
  8010f5:	c3                   	retq   

00000000008010f6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f6:	55                   	push   %rbp
  8010f7:	48 89 e5             	mov    %rsp,%rbp
  8010fa:	48 83 ec 0c          	sub    $0xc,%rsp
  8010fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801102:	89 f0                	mov    %esi,%eax
  801104:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801107:	eb 17                	jmp    801120 <strchr+0x2a>
		if (*s == c)
  801109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110d:	0f b6 00             	movzbl (%rax),%eax
  801110:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801113:	75 06                	jne    80111b <strchr+0x25>
			return (char *) s;
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	eb 15                	jmp    801130 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	84 c0                	test   %al,%al
  801129:	75 de                	jne    801109 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801130:	c9                   	leaveq 
  801131:	c3                   	retq   

0000000000801132 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	48 83 ec 0c          	sub    $0xc,%rsp
  80113a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113e:	89 f0                	mov    %esi,%eax
  801140:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801143:	eb 13                	jmp    801158 <strfind+0x26>
		if (*s == c)
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801149:	0f b6 00             	movzbl (%rax),%eax
  80114c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80114f:	75 02                	jne    801153 <strfind+0x21>
			break;
  801151:	eb 10                	jmp    801163 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801153:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115c:	0f b6 00             	movzbl (%rax),%eax
  80115f:	84 c0                	test   %al,%al
  801161:	75 e2                	jne    801145 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801163:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801167:	c9                   	leaveq 
  801168:	c3                   	retq   

0000000000801169 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
  80116d:	48 83 ec 18          	sub    $0x18,%rsp
  801171:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801175:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801178:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80117c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801181:	75 06                	jne    801189 <memset+0x20>
		return v;
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801187:	eb 69                	jmp    8011f2 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	48 85 c0             	test   %rax,%rax
  801193:	75 48                	jne    8011dd <memset+0x74>
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 3c                	jne    8011dd <memset+0x74>
		c &= 0xFF;
  8011a1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ab:	c1 e0 18             	shl    $0x18,%eax
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b3:	c1 e0 10             	shl    $0x10,%eax
  8011b6:	09 c2                	or     %eax,%edx
  8011b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bb:	c1 e0 08             	shl    $0x8,%eax
  8011be:	09 d0                	or     %edx,%eax
  8011c0:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c7:	48 c1 e8 02          	shr    $0x2,%rax
  8011cb:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011ce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d5:	48 89 d7             	mov    %rdx,%rdi
  8011d8:	fc                   	cld    
  8011d9:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011db:	eb 11                	jmp    8011ee <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e8:	48 89 d7             	mov    %rdx,%rdi
  8011eb:	fc                   	cld    
  8011ec:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f2:	c9                   	leaveq 
  8011f3:	c3                   	retq   

00000000008011f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	48 83 ec 28          	sub    $0x28,%rsp
  8011fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801200:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801204:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801208:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801214:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801218:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801220:	0f 83 88 00 00 00    	jae    8012ae <memmove+0xba>
  801226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122e:	48 01 d0             	add    %rdx,%rax
  801231:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801235:	76 77                	jbe    8012ae <memmove+0xba>
		s += n;
  801237:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80123f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801243:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124b:	83 e0 03             	and    $0x3,%eax
  80124e:	48 85 c0             	test   %rax,%rax
  801251:	75 3b                	jne    80128e <memmove+0x9a>
  801253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801257:	83 e0 03             	and    $0x3,%eax
  80125a:	48 85 c0             	test   %rax,%rax
  80125d:	75 2f                	jne    80128e <memmove+0x9a>
  80125f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 23                	jne    80128e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80126b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126f:	48 83 e8 04          	sub    $0x4,%rax
  801273:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801277:	48 83 ea 04          	sub    $0x4,%rdx
  80127b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80127f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801283:	48 89 c7             	mov    %rax,%rdi
  801286:	48 89 d6             	mov    %rdx,%rsi
  801289:	fd                   	std    
  80128a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80128c:	eb 1d                	jmp    8012ab <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80129e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a2:	48 89 d7             	mov    %rdx,%rdi
  8012a5:	48 89 c1             	mov    %rax,%rcx
  8012a8:	fd                   	std    
  8012a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012ab:	fc                   	cld    
  8012ac:	eb 57                	jmp    801305 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	83 e0 03             	and    $0x3,%eax
  8012b5:	48 85 c0             	test   %rax,%rax
  8012b8:	75 36                	jne    8012f0 <memmove+0xfc>
  8012ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012be:	83 e0 03             	and    $0x3,%eax
  8012c1:	48 85 c0             	test   %rax,%rax
  8012c4:	75 2a                	jne    8012f0 <memmove+0xfc>
  8012c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ca:	83 e0 03             	and    $0x3,%eax
  8012cd:	48 85 c0             	test   %rax,%rax
  8012d0:	75 1e                	jne    8012f0 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d6:	48 c1 e8 02          	shr    $0x2,%rax
  8012da:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e5:	48 89 c7             	mov    %rax,%rdi
  8012e8:	48 89 d6             	mov    %rdx,%rsi
  8012eb:	fc                   	cld    
  8012ec:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ee:	eb 15                	jmp    801305 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012fc:	48 89 c7             	mov    %rax,%rdi
  8012ff:	48 89 d6             	mov    %rdx,%rsi
  801302:	fc                   	cld    
  801303:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 18          	sub    $0x18,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80131b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80131f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801323:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132b:	48 89 ce             	mov    %rcx,%rsi
  80132e:	48 89 c7             	mov    %rax,%rdi
  801331:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801338:	00 00 00 
  80133b:	ff d0                	callq  *%rax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 28          	sub    $0x28,%rsp
  801347:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801357:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80135b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801363:	eb 36                	jmp    80139b <memcmp+0x5c>
		if (*s1 != *s2)
  801365:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801369:	0f b6 10             	movzbl (%rax),%edx
  80136c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801370:	0f b6 00             	movzbl (%rax),%eax
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 1a                	je     801391 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	0f b6 d0             	movzbl %al,%edx
  801381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	0f b6 c0             	movzbl %al,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	eb 20                	jmp    8013b1 <memcmp+0x72>
		s1++, s2++;
  801391:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801396:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80139b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a7:	48 85 c0             	test   %rax,%rax
  8013aa:	75 b9                	jne    801365 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 28          	sub    $0x28,%rsp
  8013bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ce:	48 01 d0             	add    %rdx,%rax
  8013d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d5:	eb 15                	jmp    8013ec <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013db:	0f b6 10             	movzbl (%rax),%edx
  8013de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e1:	38 c2                	cmp    %al,%dl
  8013e3:	75 02                	jne    8013e7 <memfind+0x34>
			break;
  8013e5:	eb 0f                	jmp    8013f6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f4:	72 e1                	jb     8013d7 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013fa:	c9                   	leaveq 
  8013fb:	c3                   	retq   

00000000008013fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fc:	55                   	push   %rbp
  8013fd:	48 89 e5             	mov    %rsp,%rbp
  801400:	48 83 ec 34          	sub    $0x34,%rsp
  801404:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801408:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80140f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801416:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141e:	eb 05                	jmp    801425 <strtol+0x29>
		s++;
  801420:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	3c 20                	cmp    $0x20,%al
  80142e:	74 f0                	je     801420 <strtol+0x24>
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	3c 09                	cmp    $0x9,%al
  801439:	74 e5                	je     801420 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	3c 2b                	cmp    $0x2b,%al
  801444:	75 07                	jne    80144d <strtol+0x51>
		s++;
  801446:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144b:	eb 17                	jmp    801464 <strtol+0x68>
	else if (*s == '-')
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	3c 2d                	cmp    $0x2d,%al
  801456:	75 0c                	jne    801464 <strtol+0x68>
		s++, neg = 1;
  801458:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801464:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801468:	74 06                	je     801470 <strtol+0x74>
  80146a:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146e:	75 28                	jne    801498 <strtol+0x9c>
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	3c 30                	cmp    $0x30,%al
  801479:	75 1d                	jne    801498 <strtol+0x9c>
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	48 83 c0 01          	add    $0x1,%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	3c 78                	cmp    $0x78,%al
  801488:	75 0e                	jne    801498 <strtol+0x9c>
		s += 2, base = 16;
  80148a:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80148f:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801496:	eb 2c                	jmp    8014c4 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801498:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149c:	75 19                	jne    8014b7 <strtol+0xbb>
  80149e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a2:	0f b6 00             	movzbl (%rax),%eax
  8014a5:	3c 30                	cmp    $0x30,%al
  8014a7:	75 0e                	jne    8014b7 <strtol+0xbb>
		s++, base = 8;
  8014a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ae:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b5:	eb 0d                	jmp    8014c4 <strtol+0xc8>
	else if (base == 0)
  8014b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014bb:	75 07                	jne    8014c4 <strtol+0xc8>
		base = 10;
  8014bd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	3c 2f                	cmp    $0x2f,%al
  8014cd:	7e 1d                	jle    8014ec <strtol+0xf0>
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	0f b6 00             	movzbl (%rax),%eax
  8014d6:	3c 39                	cmp    $0x39,%al
  8014d8:	7f 12                	jg     8014ec <strtol+0xf0>
			dig = *s - '0';
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	0f be c0             	movsbl %al,%eax
  8014e4:	83 e8 30             	sub    $0x30,%eax
  8014e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ea:	eb 4e                	jmp    80153a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 60                	cmp    $0x60,%al
  8014f5:	7e 1d                	jle    801514 <strtol+0x118>
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	3c 7a                	cmp    $0x7a,%al
  801500:	7f 12                	jg     801514 <strtol+0x118>
			dig = *s - 'a' + 10;
  801502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 57             	sub    $0x57,%eax
  80150f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801512:	eb 26                	jmp    80153a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 40                	cmp    $0x40,%al
  80151d:	7e 48                	jle    801567 <strtol+0x16b>
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	3c 5a                	cmp    $0x5a,%al
  801528:	7f 3d                	jg     801567 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	0f b6 00             	movzbl (%rax),%eax
  801531:	0f be c0             	movsbl %al,%eax
  801534:	83 e8 37             	sub    $0x37,%eax
  801537:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801540:	7c 02                	jl     801544 <strtol+0x148>
			break;
  801542:	eb 23                	jmp    801567 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801544:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801549:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154c:	48 98                	cltq   
  80154e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801553:	48 89 c2             	mov    %rax,%rdx
  801556:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801559:	48 98                	cltq   
  80155b:	48 01 d0             	add    %rdx,%rax
  80155e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801562:	e9 5d ff ff ff       	jmpq   8014c4 <strtol+0xc8>

	if (endptr)
  801567:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80156c:	74 0b                	je     801579 <strtol+0x17d>
		*endptr = (char *) s;
  80156e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801572:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801576:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801579:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80157d:	74 09                	je     801588 <strtol+0x18c>
  80157f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801583:	48 f7 d8             	neg    %rax
  801586:	eb 04                	jmp    80158c <strtol+0x190>
  801588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158c:	c9                   	leaveq 
  80158d:	c3                   	retq   

000000000080158e <strstr>:

char * strstr(const char *in, const char *str)
{
  80158e:	55                   	push   %rbp
  80158f:	48 89 e5             	mov    %rsp,%rbp
  801592:	48 83 ec 30          	sub    $0x30,%rsp
  801596:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80159e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8015b0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b4:	75 06                	jne    8015bc <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	eb 6b                	jmp    801627 <strstr+0x99>

    len = strlen(str);
  8015bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c0:	48 89 c7             	mov    %rax,%rdi
  8015c3:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  8015ca:	00 00 00 
  8015cd:	ff d0                	callq  *%rax
  8015cf:	48 98                	cltq   
  8015d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e1:	0f b6 00             	movzbl (%rax),%eax
  8015e4:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015eb:	75 07                	jne    8015f4 <strstr+0x66>
                return (char *) 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	eb 33                	jmp    801627 <strstr+0x99>
        } while (sc != c);
  8015f4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015f8:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015fb:	75 d8                	jne    8015d5 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8015fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801601:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801609:	48 89 ce             	mov    %rcx,%rsi
  80160c:	48 89 c7             	mov    %rax,%rdi
  80160f:	48 b8 85 10 80 00 00 	movabs $0x801085,%rax
  801616:	00 00 00 
  801619:	ff d0                	callq  *%rax
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 b6                	jne    8015d5 <strstr+0x47>

    return (char *) (in - 1);
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	48 83 e8 01          	sub    $0x1,%rax
}
  801627:	c9                   	leaveq 
  801628:	c3                   	retq   

0000000000801629 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801629:	55                   	push   %rbp
  80162a:	48 89 e5             	mov    %rsp,%rbp
  80162d:	53                   	push   %rbx
  80162e:	48 83 ec 48          	sub    $0x48,%rsp
  801632:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801635:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801638:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801640:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801644:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801648:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80164f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801653:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801657:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80165f:	4c 89 c3             	mov    %r8,%rbx
  801662:	cd 30                	int    $0x30
  801664:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801668:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166c:	74 3e                	je     8016ac <syscall+0x83>
  80166e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801673:	7e 37                	jle    8016ac <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801679:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167c:	49 89 d0             	mov    %rdx,%r8
  80167f:	89 c1                	mov    %eax,%ecx
  801681:	48 ba e0 41 80 00 00 	movabs $0x8041e0,%rdx
  801688:	00 00 00 
  80168b:	be 23 00 00 00       	mov    $0x23,%esi
  801690:	48 bf fd 41 80 00 00 	movabs $0x8041fd,%rdi
  801697:	00 00 00 
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
  80169f:	49 b9 ab 37 80 00 00 	movabs $0x8037ab,%r9
  8016a6:	00 00 00 
  8016a9:	41 ff d1             	callq  *%r9

	return ret;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b0:	48 83 c4 48          	add    $0x48,%rsp
  8016b4:	5b                   	pop    %rbx
  8016b5:	5d                   	pop    %rbp
  8016b6:	c3                   	retq   

00000000008016b7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016b7:	55                   	push   %rbp
  8016b8:	48 89 e5             	mov    %rsp,%rbp
  8016bb:	48 83 ec 20          	sub    $0x20,%rsp
  8016bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d6:	00 
  8016d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e3:	48 89 d1             	mov    %rdx,%rcx
  8016e6:	48 89 c2             	mov    %rax,%rdx
  8016e9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f3:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8016fa:	00 00 00 
  8016fd:	ff d0                	callq  *%rax
}
  8016ff:	c9                   	leaveq 
  801700:	c3                   	retq   

0000000000801701 <sys_cgetc>:

int
sys_cgetc(void)
{
  801701:	55                   	push   %rbp
  801702:	48 89 e5             	mov    %rsp,%rbp
  801705:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801709:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801710:	00 
  801711:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801717:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	be 00 00 00 00       	mov    $0x0,%esi
  80172c:	bf 01 00 00 00       	mov    $0x1,%edi
  801731:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801738:	00 00 00 
  80173b:	ff d0                	callq  *%rax
}
  80173d:	c9                   	leaveq 
  80173e:	c3                   	retq   

000000000080173f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80173f:	55                   	push   %rbp
  801740:	48 89 e5             	mov    %rsp,%rbp
  801743:	48 83 ec 10          	sub    $0x10,%rsp
  801747:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174d:	48 98                	cltq   
  80174f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801756:	00 
  801757:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801763:	b9 00 00 00 00       	mov    $0x0,%ecx
  801768:	48 89 c2             	mov    %rax,%rdx
  80176b:	be 01 00 00 00       	mov    $0x1,%esi
  801770:	bf 03 00 00 00       	mov    $0x3,%edi
  801775:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  80177c:	00 00 00 
  80177f:	ff d0                	callq  *%rax
}
  801781:	c9                   	leaveq 
  801782:	c3                   	retq   

0000000000801783 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801783:	55                   	push   %rbp
  801784:	48 89 e5             	mov    %rsp,%rbp
  801787:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801792:	00 
  801793:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801799:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	be 00 00 00 00       	mov    $0x0,%esi
  8017ae:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b3:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017ba:	00 00 00 
  8017bd:	ff d0                	callq  *%rax
}
  8017bf:	c9                   	leaveq 
  8017c0:	c3                   	retq   

00000000008017c1 <sys_yield>:

void
sys_yield(void)
{
  8017c1:	55                   	push   %rbp
  8017c2:	48 89 e5             	mov    %rsp,%rbp
  8017c5:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d0:	00 
  8017d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	be 00 00 00 00       	mov    $0x0,%esi
  8017ec:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f1:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
}
  8017fd:	c9                   	leaveq 
  8017fe:	c3                   	retq   

00000000008017ff <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ff:	55                   	push   %rbp
  801800:	48 89 e5             	mov    %rsp,%rbp
  801803:	48 83 ec 20          	sub    $0x20,%rsp
  801807:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801811:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801814:	48 63 c8             	movslq %eax,%rcx
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181e:	48 98                	cltq   
  801820:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801827:	00 
  801828:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182e:	49 89 c8             	mov    %rcx,%r8
  801831:	48 89 d1             	mov    %rdx,%rcx
  801834:	48 89 c2             	mov    %rax,%rdx
  801837:	be 01 00 00 00       	mov    $0x1,%esi
  80183c:	bf 04 00 00 00       	mov    $0x4,%edi
  801841:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801848:	00 00 00 
  80184b:	ff d0                	callq  *%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 30          	sub    $0x30,%rsp
  801857:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801861:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801865:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801869:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186c:	48 63 c8             	movslq %eax,%rcx
  80186f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801873:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801876:	48 63 f0             	movslq %eax,%rsi
  801879:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801880:	48 98                	cltq   
  801882:	48 89 0c 24          	mov    %rcx,(%rsp)
  801886:	49 89 f9             	mov    %rdi,%r9
  801889:	49 89 f0             	mov    %rsi,%r8
  80188c:	48 89 d1             	mov    %rdx,%rcx
  80188f:	48 89 c2             	mov    %rax,%rdx
  801892:	be 01 00 00 00       	mov    $0x1,%esi
  801897:	bf 05 00 00 00       	mov    $0x5,%edi
  80189c:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 20          	sub    $0x20,%rsp
  8018b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c0:	48 98                	cltq   
  8018c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c9:	00 
  8018ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d6:	48 89 d1             	mov    %rdx,%rcx
  8018d9:	48 89 c2             	mov    %rax,%rdx
  8018dc:	be 01 00 00 00       	mov    $0x1,%esi
  8018e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8018e6:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8018ed:	00 00 00 
  8018f0:	ff d0                	callq  *%rax
}
  8018f2:	c9                   	leaveq 
  8018f3:	c3                   	retq   

00000000008018f4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
  8018f8:	48 83 ec 10          	sub    $0x10,%rsp
  8018fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ff:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801902:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801905:	48 63 d0             	movslq %eax,%rdx
  801908:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190b:	48 98                	cltq   
  80190d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801914:	00 
  801915:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801921:	48 89 d1             	mov    %rdx,%rcx
  801924:	48 89 c2             	mov    %rax,%rdx
  801927:	be 01 00 00 00       	mov    $0x1,%esi
  80192c:	bf 08 00 00 00       	mov    $0x8,%edi
  801931:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801938:	00 00 00 
  80193b:	ff d0                	callq  *%rax
}
  80193d:	c9                   	leaveq 
  80193e:	c3                   	retq   

000000000080193f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80193f:	55                   	push   %rbp
  801940:	48 89 e5             	mov    %rsp,%rbp
  801943:	48 83 ec 20          	sub    $0x20,%rsp
  801947:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80194e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801955:	48 98                	cltq   
  801957:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195e:	00 
  80195f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196b:	48 89 d1             	mov    %rdx,%rcx
  80196e:	48 89 c2             	mov    %rax,%rdx
  801971:	be 01 00 00 00       	mov    $0x1,%esi
  801976:	bf 09 00 00 00       	mov    $0x9,%edi
  80197b:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801982:	00 00 00 
  801985:	ff d0                	callq  *%rax
}
  801987:	c9                   	leaveq 
  801988:	c3                   	retq   

0000000000801989 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801989:	55                   	push   %rbp
  80198a:	48 89 e5             	mov    %rsp,%rbp
  80198d:	48 83 ec 20          	sub    $0x20,%rsp
  801991:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801994:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199f:	48 98                	cltq   
  8019a1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a8:	00 
  8019a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b5:	48 89 d1             	mov    %rdx,%rcx
  8019b8:	48 89 c2             	mov    %rax,%rdx
  8019bb:	be 01 00 00 00       	mov    $0x1,%esi
  8019c0:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c5:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
}
  8019d1:	c9                   	leaveq 
  8019d2:	c3                   	retq   

00000000008019d3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	48 83 ec 20          	sub    $0x20,%rsp
  8019db:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019e6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ec:	48 63 f0             	movslq %eax,%rsi
  8019ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f6:	48 98                	cltq   
  8019f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	49 89 f1             	mov    %rsi,%r9
  801a07:	49 89 c8             	mov    %rcx,%r8
  801a0a:	48 89 d1             	mov    %rdx,%rcx
  801a0d:	48 89 c2             	mov    %rax,%rdx
  801a10:	be 00 00 00 00       	mov    $0x0,%esi
  801a15:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a1a:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
}
  801a26:	c9                   	leaveq 
  801a27:	c3                   	retq   

0000000000801a28 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	48 83 ec 10          	sub    $0x10,%rsp
  801a30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3f:	00 
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a51:	48 89 c2             	mov    %rax,%rdx
  801a54:	be 01 00 00 00       	mov    $0x1,%esi
  801a59:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a5e:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 30          	sub    $0x30,%rsp
  801a74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7c:	48 8b 00             	mov    (%rax),%rax
  801a7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a87:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a8b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801a8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a91:	83 e0 02             	and    $0x2,%eax
  801a94:	85 c0                	test   %eax,%eax
  801a96:	75 4d                	jne    801ae5 <pgfault+0x79>
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 c1 e8 0c          	shr    $0xc,%rax
  801aa0:	48 89 c2             	mov    %rax,%rdx
  801aa3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aaa:	01 00 00 
  801aad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ab1:	25 00 08 00 00       	and    $0x800,%eax
  801ab6:	48 85 c0             	test   %rax,%rax
  801ab9:	74 2a                	je     801ae5 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801abb:	48 ba 10 42 80 00 00 	movabs $0x804210,%rdx
  801ac2:	00 00 00 
  801ac5:	be 23 00 00 00       	mov    $0x23,%esi
  801aca:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801ad1:	00 00 00 
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801ae0:	00 00 00 
  801ae3:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ae5:	ba 07 00 00 00       	mov    $0x7,%edx
  801aea:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801aef:	bf 00 00 00 00       	mov    $0x0,%edi
  801af4:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	callq  *%rax
  801b00:	85 c0                	test   %eax,%eax
  801b02:	0f 85 cd 00 00 00    	jne    801bd5 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b14:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b1a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b22:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b27:	48 89 c6             	mov    %rax,%rsi
  801b2a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b2f:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b45:	48 89 c1             	mov    %rax,%rcx
  801b48:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b52:	bf 00 00 00 00       	mov    $0x0,%edi
  801b57:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
  801b63:	85 c0                	test   %eax,%eax
  801b65:	79 2a                	jns    801b91 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b67:	48 ba 50 42 80 00 00 	movabs $0x804250,%rdx
  801b6e:	00 00 00 
  801b71:	be 30 00 00 00       	mov    $0x30,%esi
  801b76:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801b7d:	00 00 00 
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801b8c:	00 00 00 
  801b8f:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801b91:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b96:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9b:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	79 54                	jns    801bff <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801bab:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  801bb2:	00 00 00 
  801bb5:	be 32 00 00 00       	mov    $0x32,%esi
  801bba:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801bc1:	00 00 00 
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc9:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801bd0:	00 00 00 
  801bd3:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801bd5:	48 ba 98 42 80 00 00 	movabs $0x804298,%rdx
  801bdc:	00 00 00 
  801bdf:	be 34 00 00 00       	mov    $0x34,%esi
  801be4:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801beb:	00 00 00 
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801bfa:	00 00 00 
  801bfd:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 20          	sub    $0x20,%rsp
  801c09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c0c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801c0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c16:	01 00 00 
  801c19:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c20:	25 07 0e 00 00       	and    $0xe07,%eax
  801c25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c28:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c2b:	48 c1 e0 0c          	shl    $0xc,%rax
  801c2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c36:	25 00 04 00 00       	and    $0x400,%eax
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 57                	je     801c96 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c3f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c42:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c46:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4d:	41 89 f0             	mov    %esi,%r8d
  801c50:	48 89 c6             	mov    %rax,%rsi
  801c53:	bf 00 00 00 00       	mov    $0x0,%edi
  801c58:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
  801c64:	85 c0                	test   %eax,%eax
  801c66:	0f 8e 52 01 00 00    	jle    801dbe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801c6c:	48 ba ca 42 80 00 00 	movabs $0x8042ca,%rdx
  801c73:	00 00 00 
  801c76:	be 4e 00 00 00       	mov    $0x4e,%esi
  801c7b:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801c82:	00 00 00 
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8a:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801c91:	00 00 00 
  801c94:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c99:	83 e0 02             	and    $0x2,%eax
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	75 10                	jne    801cb0 <duppage+0xaf>
  801ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca3:	25 00 08 00 00       	and    $0x800,%eax
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	0f 84 bb 00 00 00    	je     801d6b <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cb8:	80 cc 08             	or     $0x8,%ah
  801cbb:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cbe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cc1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cc5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccc:	41 89 f0             	mov    %esi,%r8d
  801ccf:	48 89 c6             	mov    %rax,%rsi
  801cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd7:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	7e 2a                	jle    801d11 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801ce7:	48 ba ca 42 80 00 00 	movabs $0x8042ca,%rdx
  801cee:	00 00 00 
  801cf1:	be 55 00 00 00       	mov    $0x55,%esi
  801cf6:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801cfd:	00 00 00 
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
  801d05:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801d0c:	00 00 00 
  801d0f:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d11:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1c:	41 89 c8             	mov    %ecx,%r8d
  801d1f:	48 89 d1             	mov    %rdx,%rcx
  801d22:	ba 00 00 00 00       	mov    $0x0,%edx
  801d27:	48 89 c6             	mov    %rax,%rsi
  801d2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2f:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d36:	00 00 00 
  801d39:	ff d0                	callq  *%rax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	7e 2a                	jle    801d69 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801d3f:	48 ba ca 42 80 00 00 	movabs $0x8042ca,%rdx
  801d46:	00 00 00 
  801d49:	be 57 00 00 00       	mov    $0x57,%esi
  801d4e:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801d55:	00 00 00 
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801d64:	00 00 00 
  801d67:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d69:	eb 53                	jmp    801dbe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d6b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d6e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d72:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d79:	41 89 f0             	mov    %esi,%r8d
  801d7c:	48 89 c6             	mov    %rax,%rsi
  801d7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d84:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d8b:	00 00 00 
  801d8e:	ff d0                	callq  *%rax
  801d90:	85 c0                	test   %eax,%eax
  801d92:	7e 2a                	jle    801dbe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d94:	48 ba ca 42 80 00 00 	movabs $0x8042ca,%rdx
  801d9b:	00 00 00 
  801d9e:	be 5b 00 00 00       	mov    $0x5b,%esi
  801da3:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801daa:	00 00 00 
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
  801db2:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  801db9:	00 00 00 
  801dbc:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc3:	c9                   	leaveq 
  801dc4:	c3                   	retq   

0000000000801dc5 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801dc5:	55                   	push   %rbp
  801dc6:	48 89 e5             	mov    %rsp,%rbp
  801dc9:	48 83 ec 18          	sub    $0x18,%rsp
  801dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddd:	48 c1 e8 27          	shr    $0x27,%rax
  801de1:	48 89 c2             	mov    %rax,%rdx
  801de4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801deb:	01 00 00 
  801dee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df2:	83 e0 01             	and    $0x1,%eax
  801df5:	48 85 c0             	test   %rax,%rax
  801df8:	74 51                	je     801e4b <pt_is_mapped+0x86>
  801dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfe:	48 c1 e0 0c          	shl    $0xc,%rax
  801e02:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e06:	48 89 c2             	mov    %rax,%rdx
  801e09:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e10:	01 00 00 
  801e13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e17:	83 e0 01             	and    $0x1,%eax
  801e1a:	48 85 c0             	test   %rax,%rax
  801e1d:	74 2c                	je     801e4b <pt_is_mapped+0x86>
  801e1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e23:	48 c1 e0 0c          	shl    $0xc,%rax
  801e27:	48 c1 e8 15          	shr    $0x15,%rax
  801e2b:	48 89 c2             	mov    %rax,%rdx
  801e2e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e35:	01 00 00 
  801e38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3c:	83 e0 01             	and    $0x1,%eax
  801e3f:	48 85 c0             	test   %rax,%rax
  801e42:	74 07                	je     801e4b <pt_is_mapped+0x86>
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <pt_is_mapped+0x8b>
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	83 e0 01             	and    $0x1,%eax
}
  801e53:	c9                   	leaveq 
  801e54:	c3                   	retq   

0000000000801e55 <fork>:

envid_t
fork(void)
{
  801e55:	55                   	push   %rbp
  801e56:	48 89 e5             	mov    %rsp,%rbp
  801e59:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801e5d:	48 bf 6c 1a 80 00 00 	movabs $0x801a6c,%rdi
  801e64:	00 00 00 
  801e67:	48 b8 bf 38 80 00 00 	movabs $0x8038bf,%rax
  801e6e:	00 00 00 
  801e71:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e73:	b8 07 00 00 00       	mov    $0x7,%eax
  801e78:	cd 30                	int    $0x30
  801e7a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e7d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e80:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e87:	79 30                	jns    801eb9 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e89:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e8c:	89 c1                	mov    %eax,%ecx
  801e8e:	48 ba e8 42 80 00 00 	movabs $0x8042e8,%rdx
  801e95:	00 00 00 
  801e98:	be 86 00 00 00       	mov    $0x86,%esi
  801e9d:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  801ea4:	00 00 00 
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	49 b8 ab 37 80 00 00 	movabs $0x8037ab,%r8
  801eb3:	00 00 00 
  801eb6:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ebd:	75 46                	jne    801f05 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801ebf:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
  801ecb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ed0:	48 63 d0             	movslq %eax,%rdx
  801ed3:	48 89 d0             	mov    %rdx,%rax
  801ed6:	48 c1 e0 03          	shl    $0x3,%rax
  801eda:	48 01 d0             	add    %rdx,%rax
  801edd:	48 c1 e0 05          	shl    $0x5,%rax
  801ee1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ee8:	00 00 00 
  801eeb:	48 01 c2             	add    %rax,%rdx
  801eee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ef5:	00 00 00 
  801ef8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	e9 d1 01 00 00       	jmpq   8020d6 <fork+0x281>
	}
	uint64_t ad = 0;
  801f05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f0c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801f0d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801f12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801f16:	e9 df 00 00 00       	jmpq   801ffa <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1f:	48 c1 e8 27          	shr    $0x27,%rax
  801f23:	48 89 c2             	mov    %rax,%rdx
  801f26:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f2d:	01 00 00 
  801f30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f34:	83 e0 01             	and    $0x1,%eax
  801f37:	48 85 c0             	test   %rax,%rax
  801f3a:	0f 84 9e 00 00 00    	je     801fde <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f44:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f48:	48 89 c2             	mov    %rax,%rdx
  801f4b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f52:	01 00 00 
  801f55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f59:	83 e0 01             	and    $0x1,%eax
  801f5c:	48 85 c0             	test   %rax,%rax
  801f5f:	74 73                	je     801fd4 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f65:	48 c1 e8 15          	shr    $0x15,%rax
  801f69:	48 89 c2             	mov    %rax,%rdx
  801f6c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f73:	01 00 00 
  801f76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7a:	83 e0 01             	and    $0x1,%eax
  801f7d:	48 85 c0             	test   %rax,%rax
  801f80:	74 48                	je     801fca <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f86:	48 c1 e8 0c          	shr    $0xc,%rax
  801f8a:	48 89 c2             	mov    %rax,%rdx
  801f8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f94:	01 00 00 
  801f97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	83 e0 01             	and    $0x1,%eax
  801fa6:	48 85 c0             	test   %rax,%rax
  801fa9:	74 47                	je     801ff2 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  801fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801faf:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb3:	89 c2                	mov    %eax,%edx
  801fb5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fb8:	89 d6                	mov    %edx,%esi
  801fba:	89 c7                	mov    %eax,%edi
  801fbc:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	eb 28                	jmp    801ff2 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  801fca:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801fd1:	00 
  801fd2:	eb 1e                	jmp    801ff2 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801fd4:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801fdb:	40 
  801fdc:	eb 14                	jmp    801ff2 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  801fde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe2:	48 c1 e8 27          	shr    $0x27,%rax
  801fe6:	48 83 c0 01          	add    $0x1,%rax
  801fea:	48 c1 e0 27          	shl    $0x27,%rax
  801fee:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801ff2:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801ff9:	00 
  801ffa:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802001:	00 
  802002:	0f 87 13 ff ff ff    	ja     801f1b <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802008:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80200b:	ba 07 00 00 00       	mov    $0x7,%edx
  802010:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802015:	89 c7                	mov    %eax,%edi
  802017:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802023:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802026:	ba 07 00 00 00       	mov    $0x7,%edx
  80202b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802030:	89 c7                	mov    %eax,%edi
  802032:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802039:	00 00 00 
  80203c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80203e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802041:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802047:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80204c:	ba 00 00 00 00       	mov    $0x0,%edx
  802051:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802056:	89 c7                	mov    %eax,%edi
  802058:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80205f:	00 00 00 
  802062:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802064:	ba 00 10 00 00       	mov    $0x1000,%edx
  802069:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80206e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802073:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80207f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802084:	bf 00 00 00 00       	mov    $0x0,%edi
  802089:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802095:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80209c:	00 00 00 
  80209f:	48 8b 00             	mov    (%rax),%rax
  8020a2:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8020a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020ac:	48 89 d6             	mov    %rdx,%rsi
  8020af:	89 c7                	mov    %eax,%edi
  8020b1:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  8020b8:	00 00 00 
  8020bb:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8020bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c0:	be 02 00 00 00       	mov    $0x2,%esi
  8020c5:	89 c7                	mov    %eax,%edi
  8020c7:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax

	return envid;
  8020d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8020d6:	c9                   	leaveq 
  8020d7:	c3                   	retq   

00000000008020d8 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020dc:	48 ba 00 43 80 00 00 	movabs $0x804300,%rdx
  8020e3:	00 00 00 
  8020e6:	be bf 00 00 00       	mov    $0xbf,%esi
  8020eb:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  8020f2:	00 00 00 
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fa:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  802101:	00 00 00 
  802104:	ff d1                	callq  *%rcx

0000000000802106 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
  80210a:	48 83 ec 08          	sub    $0x8,%rsp
  80210e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802112:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802116:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80211d:	ff ff ff 
  802120:	48 01 d0             	add    %rdx,%rax
  802123:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802127:	c9                   	leaveq 
  802128:	c3                   	retq   

0000000000802129 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802129:	55                   	push   %rbp
  80212a:	48 89 e5             	mov    %rsp,%rbp
  80212d:	48 83 ec 08          	sub    $0x8,%rsp
  802131:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802139:	48 89 c7             	mov    %rax,%rdi
  80213c:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802143:	00 00 00 
  802146:	ff d0                	callq  *%rax
  802148:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80214e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802152:	c9                   	leaveq 
  802153:	c3                   	retq   

0000000000802154 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802154:	55                   	push   %rbp
  802155:	48 89 e5             	mov    %rsp,%rbp
  802158:	48 83 ec 18          	sub    $0x18,%rsp
  80215c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802167:	eb 6b                	jmp    8021d4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216c:	48 98                	cltq   
  80216e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802174:	48 c1 e0 0c          	shl    $0xc,%rax
  802178:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80217c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802180:	48 c1 e8 15          	shr    $0x15,%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80218e:	01 00 00 
  802191:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802195:	83 e0 01             	and    $0x1,%eax
  802198:	48 85 c0             	test   %rax,%rax
  80219b:	74 21                	je     8021be <fd_alloc+0x6a>
  80219d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a5:	48 89 c2             	mov    %rax,%rdx
  8021a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021af:	01 00 00 
  8021b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b6:	83 e0 01             	and    $0x1,%eax
  8021b9:	48 85 c0             	test   %rax,%rax
  8021bc:	75 12                	jne    8021d0 <fd_alloc+0x7c>
			*fd_store = fd;
  8021be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	eb 1a                	jmp    8021ea <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021d4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021d8:	7e 8f                	jle    802169 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021de:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021e5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ea:	c9                   	leaveq 
  8021eb:	c3                   	retq   

00000000008021ec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021ec:	55                   	push   %rbp
  8021ed:	48 89 e5             	mov    %rsp,%rbp
  8021f0:	48 83 ec 20          	sub    $0x20,%rsp
  8021f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021ff:	78 06                	js     802207 <fd_lookup+0x1b>
  802201:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802205:	7e 07                	jle    80220e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802207:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80220c:	eb 6c                	jmp    80227a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80220e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802211:	48 98                	cltq   
  802213:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802219:	48 c1 e0 0c          	shl    $0xc,%rax
  80221d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802225:	48 c1 e8 15          	shr    $0x15,%rax
  802229:	48 89 c2             	mov    %rax,%rdx
  80222c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802233:	01 00 00 
  802236:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223a:	83 e0 01             	and    $0x1,%eax
  80223d:	48 85 c0             	test   %rax,%rax
  802240:	74 21                	je     802263 <fd_lookup+0x77>
  802242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802246:	48 c1 e8 0c          	shr    $0xc,%rax
  80224a:	48 89 c2             	mov    %rax,%rdx
  80224d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802254:	01 00 00 
  802257:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225b:	83 e0 01             	and    $0x1,%eax
  80225e:	48 85 c0             	test   %rax,%rax
  802261:	75 07                	jne    80226a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802263:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802268:	eb 10                	jmp    80227a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80226a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80226e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802272:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227a:	c9                   	leaveq 
  80227b:	c3                   	retq   

000000000080227c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80227c:	55                   	push   %rbp
  80227d:	48 89 e5             	mov    %rsp,%rbp
  802280:	48 83 ec 30          	sub    $0x30,%rsp
  802284:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802288:	89 f0                	mov    %esi,%eax
  80228a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80228d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802291:	48 89 c7             	mov    %rax,%rdi
  802294:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  80229b:	00 00 00 
  80229e:	ff d0                	callq  *%rax
  8022a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a4:	48 89 d6             	mov    %rdx,%rsi
  8022a7:	89 c7                	mov    %eax,%edi
  8022a9:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8022b0:	00 00 00 
  8022b3:	ff d0                	callq  *%rax
  8022b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bc:	78 0a                	js     8022c8 <fd_close+0x4c>
	    || fd != fd2)
  8022be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022c6:	74 12                	je     8022da <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022c8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022cc:	74 05                	je     8022d3 <fd_close+0x57>
  8022ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d1:	eb 05                	jmp    8022d8 <fd_close+0x5c>
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	eb 69                	jmp    802343 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022de:	8b 00                	mov    (%rax),%eax
  8022e0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022e4:	48 89 d6             	mov    %rdx,%rsi
  8022e7:	89 c7                	mov    %eax,%edi
  8022e9:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  8022f0:	00 00 00 
  8022f3:	ff d0                	callq  *%rax
  8022f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fc:	78 2a                	js     802328 <fd_close+0xac>
		if (dev->dev_close)
  8022fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802302:	48 8b 40 20          	mov    0x20(%rax),%rax
  802306:	48 85 c0             	test   %rax,%rax
  802309:	74 16                	je     802321 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802313:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802317:	48 89 d7             	mov    %rdx,%rdi
  80231a:	ff d0                	callq  *%rax
  80231c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80231f:	eb 07                	jmp    802328 <fd_close+0xac>
		else
			r = 0;
  802321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802328:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232c:	48 89 c6             	mov    %rax,%rsi
  80232f:	bf 00 00 00 00       	mov    $0x0,%edi
  802334:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
	return r;
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
  802349:	48 83 ec 20          	sub    $0x20,%rsp
  80234d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80235b:	eb 41                	jmp    80239e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80235d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802364:	00 00 00 
  802367:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236a:	48 63 d2             	movslq %edx,%rdx
  80236d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802371:	8b 00                	mov    (%rax),%eax
  802373:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802376:	75 22                	jne    80239a <dev_lookup+0x55>
			*dev = devtab[i];
  802378:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80237f:	00 00 00 
  802382:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802385:	48 63 d2             	movslq %edx,%rdx
  802388:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80238c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802390:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	eb 60                	jmp    8023fa <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80239a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80239e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023a5:	00 00 00 
  8023a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023ab:	48 63 d2             	movslq %edx,%rdx
  8023ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b2:	48 85 c0             	test   %rax,%rax
  8023b5:	75 a6                	jne    80235d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023be:	00 00 00 
  8023c1:	48 8b 00             	mov    (%rax),%rax
  8023c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023ca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023cd:	89 c6                	mov    %eax,%esi
  8023cf:	48 bf 18 43 80 00 00 	movabs $0x804318,%rdi
  8023d6:	00 00 00 
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023de:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8023e5:	00 00 00 
  8023e8:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ee:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <close>:

int
close(int fdnum)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 20          	sub    $0x20,%rsp
  802404:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802407:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80240b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240e:	48 89 d6             	mov    %rdx,%rsi
  802411:	89 c7                	mov    %eax,%edi
  802413:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	callq  *%rax
  80241f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802426:	79 05                	jns    80242d <close+0x31>
		return r;
  802428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242b:	eb 18                	jmp    802445 <close+0x49>
	else
		return fd_close(fd, 1);
  80242d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802431:	be 01 00 00 00       	mov    $0x1,%esi
  802436:	48 89 c7             	mov    %rax,%rdi
  802439:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <close_all>:

void
close_all(void)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80244f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802456:	eb 15                	jmp    80246d <close_all+0x26>
		close(i);
  802458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245b:	89 c7                	mov    %eax,%edi
  80245d:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802469:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802471:	7e e5                	jle    802458 <close_all+0x11>
		close(i);
}
  802473:	c9                   	leaveq 
  802474:	c3                   	retq   

0000000000802475 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802475:	55                   	push   %rbp
  802476:	48 89 e5             	mov    %rsp,%rbp
  802479:	48 83 ec 40          	sub    $0x40,%rsp
  80247d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802480:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802483:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802487:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80248a:	48 89 d6             	mov    %rdx,%rsi
  80248d:	89 c7                	mov    %eax,%edi
  80248f:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802496:	00 00 00 
  802499:	ff d0                	callq  *%rax
  80249b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a2:	79 08                	jns    8024ac <dup+0x37>
		return r;
  8024a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a7:	e9 70 01 00 00       	jmpq   80261c <dup+0x1a7>
	close(newfdnum);
  8024ac:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024bd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024c0:	48 98                	cltq   
  8024c2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024c8:	48 c1 e0 0c          	shl    $0xc,%rax
  8024cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d4:	48 89 c7             	mov    %rax,%rdi
  8024d7:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax
  8024e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024eb:	48 89 c7             	mov    %rax,%rdi
  8024ee:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  8024f5:	00 00 00 
  8024f8:	ff d0                	callq  *%rax
  8024fa:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802502:	48 c1 e8 15          	shr    $0x15,%rax
  802506:	48 89 c2             	mov    %rax,%rdx
  802509:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802510:	01 00 00 
  802513:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802517:	83 e0 01             	and    $0x1,%eax
  80251a:	48 85 c0             	test   %rax,%rax
  80251d:	74 73                	je     802592 <dup+0x11d>
  80251f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802523:	48 c1 e8 0c          	shr    $0xc,%rax
  802527:	48 89 c2             	mov    %rax,%rdx
  80252a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802531:	01 00 00 
  802534:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802538:	83 e0 01             	and    $0x1,%eax
  80253b:	48 85 c0             	test   %rax,%rax
  80253e:	74 52                	je     802592 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802544:	48 c1 e8 0c          	shr    $0xc,%rax
  802548:	48 89 c2             	mov    %rax,%rdx
  80254b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802552:	01 00 00 
  802555:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802559:	25 07 0e 00 00       	and    $0xe07,%eax
  80255e:	89 c1                	mov    %eax,%ecx
  802560:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802568:	41 89 c8             	mov    %ecx,%r8d
  80256b:	48 89 d1             	mov    %rdx,%rcx
  80256e:	ba 00 00 00 00       	mov    $0x0,%edx
  802573:	48 89 c6             	mov    %rax,%rsi
  802576:	bf 00 00 00 00       	mov    $0x0,%edi
  80257b:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
  802587:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258e:	79 02                	jns    802592 <dup+0x11d>
			goto err;
  802590:	eb 57                	jmp    8025e9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802596:	48 c1 e8 0c          	shr    $0xc,%rax
  80259a:	48 89 c2             	mov    %rax,%rdx
  80259d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a4:	01 00 00 
  8025a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8025b0:	89 c1                	mov    %eax,%ecx
  8025b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ba:	41 89 c8             	mov    %ecx,%r8d
  8025bd:	48 89 d1             	mov    %rdx,%rcx
  8025c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c5:	48 89 c6             	mov    %rax,%rsi
  8025c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cd:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e0:	79 02                	jns    8025e4 <dup+0x16f>
		goto err;
  8025e2:	eb 05                	jmp    8025e9 <dup+0x174>

	return newfdnum;
  8025e4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025e7:	eb 33                	jmp    80261c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ed:	48 89 c6             	mov    %rax,%rsi
  8025f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f5:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802601:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802605:	48 89 c6             	mov    %rax,%rsi
  802608:	bf 00 00 00 00       	mov    $0x0,%edi
  80260d:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
	return r;
  802619:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80261c:	c9                   	leaveq 
  80261d:	c3                   	retq   

000000000080261e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 40          	sub    $0x40,%rsp
  802626:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802629:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80262d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802631:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802635:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802638:	48 89 d6             	mov    %rdx,%rsi
  80263b:	89 c7                	mov    %eax,%edi
  80263d:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
  802649:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802650:	78 24                	js     802676 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802656:	8b 00                	mov    (%rax),%eax
  802658:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265c:	48 89 d6             	mov    %rdx,%rsi
  80265f:	89 c7                	mov    %eax,%edi
  802661:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802670:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802674:	79 05                	jns    80267b <read+0x5d>
		return r;
  802676:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802679:	eb 76                	jmp    8026f1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	8b 40 08             	mov    0x8(%rax),%eax
  802682:	83 e0 03             	and    $0x3,%eax
  802685:	83 f8 01             	cmp    $0x1,%eax
  802688:	75 3a                	jne    8026c4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80268a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802691:	00 00 00 
  802694:	48 8b 00             	mov    (%rax),%rax
  802697:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80269d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026a0:	89 c6                	mov    %eax,%esi
  8026a2:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8026a9:	00 00 00 
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b1:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8026b8:	00 00 00 
  8026bb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c2:	eb 2d                	jmp    8026f1 <read+0xd3>
	}
	if (!dev->dev_read)
  8026c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026cc:	48 85 c0             	test   %rax,%rax
  8026cf:	75 07                	jne    8026d8 <read+0xba>
		return -E_NOT_SUPP;
  8026d1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d6:	eb 19                	jmp    8026f1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026e0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026e4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026e8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ec:	48 89 cf             	mov    %rcx,%rdi
  8026ef:	ff d0                	callq  *%rax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 30          	sub    $0x30,%rsp
  8026fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802702:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80270d:	eb 49                	jmp    802758 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80270f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802712:	48 98                	cltq   
  802714:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802718:	48 29 c2             	sub    %rax,%rdx
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	48 63 c8             	movslq %eax,%rcx
  802721:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802725:	48 01 c1             	add    %rax,%rcx
  802728:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80272b:	48 89 ce             	mov    %rcx,%rsi
  80272e:	89 c7                	mov    %eax,%edi
  802730:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80273f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802743:	79 05                	jns    80274a <readn+0x57>
			return m;
  802745:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802748:	eb 1c                	jmp    802766 <readn+0x73>
		if (m == 0)
  80274a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80274e:	75 02                	jne    802752 <readn+0x5f>
			break;
  802750:	eb 11                	jmp    802763 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802752:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802755:	01 45 fc             	add    %eax,-0x4(%rbp)
  802758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275b:	48 98                	cltq   
  80275d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802761:	72 ac                	jb     80270f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802763:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802766:	c9                   	leaveq 
  802767:	c3                   	retq   

0000000000802768 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802768:	55                   	push   %rbp
  802769:	48 89 e5             	mov    %rsp,%rbp
  80276c:	48 83 ec 40          	sub    $0x40,%rsp
  802770:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802773:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802777:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80277b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80277f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802782:	48 89 d6             	mov    %rdx,%rsi
  802785:	89 c7                	mov    %eax,%edi
  802787:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279a:	78 24                	js     8027c0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80279c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a0:	8b 00                	mov    (%rax),%eax
  8027a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a6:	48 89 d6             	mov    %rdx,%rsi
  8027a9:	89 c7                	mov    %eax,%edi
  8027ab:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027be:	79 05                	jns    8027c5 <write+0x5d>
		return r;
  8027c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c3:	eb 75                	jmp    80283a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c9:	8b 40 08             	mov    0x8(%rax),%eax
  8027cc:	83 e0 03             	and    $0x3,%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	75 3a                	jne    80280d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027da:	00 00 00 
  8027dd:	48 8b 00             	mov    (%rax),%rax
  8027e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027e6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027e9:	89 c6                	mov    %eax,%esi
  8027eb:	48 bf 53 43 80 00 00 	movabs $0x804353,%rdi
  8027f2:	00 00 00 
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  802801:	00 00 00 
  802804:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802806:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280b:	eb 2d                	jmp    80283a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80280d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802811:	48 8b 40 18          	mov    0x18(%rax),%rax
  802815:	48 85 c0             	test   %rax,%rax
  802818:	75 07                	jne    802821 <write+0xb9>
		return -E_NOT_SUPP;
  80281a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80281f:	eb 19                	jmp    80283a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802825:	48 8b 40 18          	mov    0x18(%rax),%rax
  802829:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80282d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802831:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802835:	48 89 cf             	mov    %rcx,%rdi
  802838:	ff d0                	callq  *%rax
}
  80283a:	c9                   	leaveq 
  80283b:	c3                   	retq   

000000000080283c <seek>:

int
seek(int fdnum, off_t offset)
{
  80283c:	55                   	push   %rbp
  80283d:	48 89 e5             	mov    %rsp,%rbp
  802840:	48 83 ec 18          	sub    $0x18,%rsp
  802844:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802847:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80284e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802851:	48 89 d6             	mov    %rdx,%rsi
  802854:	89 c7                	mov    %eax,%edi
  802856:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80285d:	00 00 00 
  802860:	ff d0                	callq  *%rax
  802862:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802865:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802869:	79 05                	jns    802870 <seek+0x34>
		return r;
  80286b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286e:	eb 0f                	jmp    80287f <seek+0x43>
	fd->fd_offset = offset;
  802870:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802874:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802877:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80287a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287f:	c9                   	leaveq 
  802880:	c3                   	retq   

0000000000802881 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802881:	55                   	push   %rbp
  802882:	48 89 e5             	mov    %rsp,%rbp
  802885:	48 83 ec 30          	sub    $0x30,%rsp
  802889:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80288c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80288f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802893:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802896:	48 89 d6             	mov    %rdx,%rsi
  802899:	89 c7                	mov    %eax,%edi
  80289b:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8028a2:	00 00 00 
  8028a5:	ff d0                	callq  *%rax
  8028a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ae:	78 24                	js     8028d4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b4:	8b 00                	mov    (%rax),%eax
  8028b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ba:	48 89 d6             	mov    %rdx,%rsi
  8028bd:	89 c7                	mov    %eax,%edi
  8028bf:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	callq  *%rax
  8028cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d2:	79 05                	jns    8028d9 <ftruncate+0x58>
		return r;
  8028d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d7:	eb 72                	jmp    80294b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dd:	8b 40 08             	mov    0x8(%rax),%eax
  8028e0:	83 e0 03             	and    $0x3,%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	75 3a                	jne    802921 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028e7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028ee:	00 00 00 
  8028f1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028f4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028fa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028fd:	89 c6                	mov    %eax,%esi
  8028ff:	48 bf 70 43 80 00 00 	movabs $0x804370,%rdi
  802906:	00 00 00 
  802909:	b8 00 00 00 00       	mov    $0x0,%eax
  80290e:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  802915:	00 00 00 
  802918:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80291a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80291f:	eb 2a                	jmp    80294b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802925:	48 8b 40 30          	mov    0x30(%rax),%rax
  802929:	48 85 c0             	test   %rax,%rax
  80292c:	75 07                	jne    802935 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80292e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802933:	eb 16                	jmp    80294b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802935:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802939:	48 8b 40 30          	mov    0x30(%rax),%rax
  80293d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802941:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802944:	89 ce                	mov    %ecx,%esi
  802946:	48 89 d7             	mov    %rdx,%rdi
  802949:	ff d0                	callq  *%rax
}
  80294b:	c9                   	leaveq 
  80294c:	c3                   	retq   

000000000080294d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80294d:	55                   	push   %rbp
  80294e:	48 89 e5             	mov    %rsp,%rbp
  802951:	48 83 ec 30          	sub    $0x30,%rsp
  802955:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802958:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802960:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802963:	48 89 d6             	mov    %rdx,%rsi
  802966:	89 c7                	mov    %eax,%edi
  802968:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
  802974:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802977:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297b:	78 24                	js     8029a1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802981:	8b 00                	mov    (%rax),%eax
  802983:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802987:	48 89 d6             	mov    %rdx,%rsi
  80298a:	89 c7                	mov    %eax,%edi
  80298c:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  802993:	00 00 00 
  802996:	ff d0                	callq  *%rax
  802998:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299f:	79 05                	jns    8029a6 <fstat+0x59>
		return r;
  8029a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a4:	eb 5e                	jmp    802a04 <fstat+0xb7>
	if (!dev->dev_stat)
  8029a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029aa:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029ae:	48 85 c0             	test   %rax,%rax
  8029b1:	75 07                	jne    8029ba <fstat+0x6d>
		return -E_NOT_SUPP;
  8029b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029b8:	eb 4a                	jmp    802a04 <fstat+0xb7>
	stat->st_name[0] = 0;
  8029ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029be:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029c5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029cc:	00 00 00 
	stat->st_isdir = 0;
  8029cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029d3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029da:	00 00 00 
	stat->st_dev = dev;
  8029dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029e5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029f8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029fc:	48 89 ce             	mov    %rcx,%rsi
  8029ff:	48 89 d7             	mov    %rdx,%rdi
  802a02:	ff d0                	callq  *%rax
}
  802a04:	c9                   	leaveq 
  802a05:	c3                   	retq   

0000000000802a06 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a06:	55                   	push   %rbp
  802a07:	48 89 e5             	mov    %rsp,%rbp
  802a0a:	48 83 ec 20          	sub    $0x20,%rsp
  802a0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1a:	be 00 00 00 00       	mov    $0x0,%esi
  802a1f:	48 89 c7             	mov    %rax,%rdi
  802a22:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a35:	79 05                	jns    802a3c <stat+0x36>
		return fd;
  802a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3a:	eb 2f                	jmp    802a6b <stat+0x65>
	r = fstat(fd, stat);
  802a3c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a43:	48 89 d6             	mov    %rdx,%rsi
  802a46:	89 c7                	mov    %eax,%edi
  802a48:	48 b8 4d 29 80 00 00 	movabs $0x80294d,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	callq  *%rax
  802a54:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
	return r;
  802a68:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a6b:	c9                   	leaveq 
  802a6c:	c3                   	retq   

0000000000802a6d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a6d:	55                   	push   %rbp
  802a6e:	48 89 e5             	mov    %rsp,%rbp
  802a71:	48 83 ec 10          	sub    $0x10,%rsp
  802a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a7c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a83:	00 00 00 
  802a86:	8b 00                	mov    (%rax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	75 1d                	jne    802aa9 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a8c:	bf 01 00 00 00       	mov    $0x1,%edi
  802a91:	48 b8 67 3b 80 00 00 	movabs $0x803b67,%rax
  802a98:	00 00 00 
  802a9b:	ff d0                	callq  *%rax
  802a9d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802aa4:	00 00 00 
  802aa7:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802aa9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ab0:	00 00 00 
  802ab3:	8b 00                	mov    (%rax),%eax
  802ab5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ab8:	b9 07 00 00 00       	mov    $0x7,%ecx
  802abd:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ac4:	00 00 00 
  802ac7:	89 c7                	mov    %eax,%edi
  802ac9:	48 b8 05 3b 80 00 00 	movabs $0x803b05,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ade:	48 89 c6             	mov    %rax,%rsi
  802ae1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae6:	48 b8 ff 39 80 00 00 	movabs $0x8039ff,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
  802af8:	48 83 ec 30          	sub    $0x30,%rsp
  802afc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b00:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802b03:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802b0a:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802b11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802b18:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b1d:	75 08                	jne    802b27 <open+0x33>
	{
		return r;
  802b1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b22:	e9 f2 00 00 00       	jmpq   802c19 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b2b:	48 89 c7             	mov    %rax,%rdi
  802b2e:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	callq  *%rax
  802b3a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b3d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802b44:	7e 0a                	jle    802b50 <open+0x5c>
	{
		return -E_BAD_PATH;
  802b46:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b4b:	e9 c9 00 00 00       	jmpq   802c19 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802b50:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802b57:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802b58:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b5c:	48 89 c7             	mov    %rax,%rdi
  802b5f:	48 b8 54 21 80 00 00 	movabs $0x802154,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
  802b6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b72:	78 09                	js     802b7d <open+0x89>
  802b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b78:	48 85 c0             	test   %rax,%rax
  802b7b:	75 08                	jne    802b85 <open+0x91>
		{
			return r;
  802b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b80:	e9 94 00 00 00       	jmpq   802c19 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b89:	ba 00 04 00 00       	mov    $0x400,%edx
  802b8e:	48 89 c6             	mov    %rax,%rsi
  802b91:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b98:	00 00 00 
  802b9b:	48 b8 62 0f 80 00 00 	movabs $0x800f62,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ba7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bae:	00 00 00 
  802bb1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802bb4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbe:	48 89 c6             	mov    %rax,%rsi
  802bc1:	bf 01 00 00 00       	mov    $0x1,%edi
  802bc6:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd9:	79 2b                	jns    802c06 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdf:	be 00 00 00 00       	mov    $0x0,%esi
  802be4:	48 89 c7             	mov    %rax,%rdi
  802be7:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  802bee:	00 00 00 
  802bf1:	ff d0                	callq  *%rax
  802bf3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802bf6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bfa:	79 05                	jns    802c01 <open+0x10d>
			{
				return d;
  802bfc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bff:	eb 18                	jmp    802c19 <open+0x125>
			}
			return r;
  802c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c04:	eb 13                	jmp    802c19 <open+0x125>
		}	
		return fd2num(fd_store);
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	48 89 c7             	mov    %rax,%rdi
  802c0d:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802c14:	00 00 00 
  802c17:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802c19:	c9                   	leaveq 
  802c1a:	c3                   	retq   

0000000000802c1b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c1b:	55                   	push   %rbp
  802c1c:	48 89 e5             	mov    %rsp,%rbp
  802c1f:	48 83 ec 10          	sub    $0x10,%rsp
  802c23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c2b:	8b 50 0c             	mov    0xc(%rax),%edx
  802c2e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c35:	00 00 00 
  802c38:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c3a:	be 00 00 00 00       	mov    $0x0,%esi
  802c3f:	bf 06 00 00 00       	mov    $0x6,%edi
  802c44:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
}
  802c50:	c9                   	leaveq 
  802c51:	c3                   	retq   

0000000000802c52 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c52:	55                   	push   %rbp
  802c53:	48 89 e5             	mov    %rsp,%rbp
  802c56:	48 83 ec 30          	sub    $0x30,%rsp
  802c5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c6d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c72:	74 07                	je     802c7b <devfile_read+0x29>
  802c74:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c79:	75 07                	jne    802c82 <devfile_read+0x30>
		return -E_INVAL;
  802c7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c80:	eb 77                	jmp    802cf9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	8b 50 0c             	mov    0xc(%rax),%edx
  802c89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c90:	00 00 00 
  802c93:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c95:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c9c:	00 00 00 
  802c9f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ca3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ca7:	be 00 00 00 00       	mov    $0x0,%esi
  802cac:	bf 03 00 00 00       	mov    $0x3,%edi
  802cb1:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
  802cbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc4:	7f 05                	jg     802ccb <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc9:	eb 2e                	jmp    802cf9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	48 63 d0             	movslq %eax,%rdx
  802cd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cdc:	00 00 00 
  802cdf:	48 89 c7             	mov    %rax,%rdi
  802ce2:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802cf9:	c9                   	leaveq 
  802cfa:	c3                   	retq   

0000000000802cfb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cfb:	55                   	push   %rbp
  802cfc:	48 89 e5             	mov    %rsp,%rbp
  802cff:	48 83 ec 30          	sub    $0x30,%rsp
  802d03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802d0f:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802d16:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d1b:	74 07                	je     802d24 <devfile_write+0x29>
  802d1d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d22:	75 08                	jne    802d2c <devfile_write+0x31>
		return r;
  802d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d27:	e9 9a 00 00 00       	jmpq   802dc6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d30:	8b 50 0c             	mov    0xc(%rax),%edx
  802d33:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d3a:	00 00 00 
  802d3d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802d3f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d46:	00 
  802d47:	76 08                	jbe    802d51 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d49:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d50:	00 
	}
	fsipcbuf.write.req_n = n;
  802d51:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d58:	00 00 00 
  802d5b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d5f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d63:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d6b:	48 89 c6             	mov    %rax,%rsi
  802d6e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d75:	00 00 00 
  802d78:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802d84:	be 00 00 00 00       	mov    $0x0,%esi
  802d89:	bf 04 00 00 00       	mov    $0x4,%edi
  802d8e:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
  802d9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da1:	7f 20                	jg     802dc3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802da3:	48 bf 96 43 80 00 00 	movabs $0x804396,%rdi
  802daa:	00 00 00 
  802dad:	b8 00 00 00 00       	mov    $0x0,%eax
  802db2:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  802db9:	00 00 00 
  802dbc:	ff d2                	callq  *%rdx
		return r;
  802dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc1:	eb 03                	jmp    802dc6 <devfile_write+0xcb>
	}
	return r;
  802dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802dc6:	c9                   	leaveq 
  802dc7:	c3                   	retq   

0000000000802dc8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802dc8:	55                   	push   %rbp
  802dc9:	48 89 e5             	mov    %rsp,%rbp
  802dcc:	48 83 ec 20          	sub    $0x20,%rsp
  802dd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddc:	8b 50 0c             	mov    0xc(%rax),%edx
  802ddf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de6:	00 00 00 
  802de9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802deb:	be 00 00 00 00       	mov    $0x0,%esi
  802df0:	bf 05 00 00 00       	mov    $0x5,%edi
  802df5:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
  802e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e08:	79 05                	jns    802e0f <devfile_stat+0x47>
		return r;
  802e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0d:	eb 56                	jmp    802e65 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e13:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e1a:	00 00 00 
  802e1d:	48 89 c7             	mov    %rax,%rdi
  802e20:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e2c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e33:	00 00 00 
  802e36:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e40:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e46:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4d:	00 00 00 
  802e50:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e5a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e65:	c9                   	leaveq 
  802e66:	c3                   	retq   

0000000000802e67 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e67:	55                   	push   %rbp
  802e68:	48 89 e5             	mov    %rsp,%rbp
  802e6b:	48 83 ec 10          	sub    $0x10,%rsp
  802e6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e73:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7a:	8b 50 0c             	mov    0xc(%rax),%edx
  802e7d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e84:	00 00 00 
  802e87:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e89:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e90:	00 00 00 
  802e93:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e96:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e99:	be 00 00 00 00       	mov    $0x0,%esi
  802e9e:	bf 02 00 00 00       	mov    $0x2,%edi
  802ea3:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802eaa:	00 00 00 
  802ead:	ff d0                	callq  *%rax
}
  802eaf:	c9                   	leaveq 
  802eb0:	c3                   	retq   

0000000000802eb1 <remove>:

// Delete a file
int
remove(const char *path)
{
  802eb1:	55                   	push   %rbp
  802eb2:	48 89 e5             	mov    %rsp,%rbp
  802eb5:	48 83 ec 10          	sub    $0x10,%rsp
  802eb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec1:	48 89 c7             	mov    %rax,%rdi
  802ec4:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
  802ed0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ed5:	7e 07                	jle    802ede <remove+0x2d>
		return -E_BAD_PATH;
  802ed7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802edc:	eb 33                	jmp    802f11 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee2:	48 89 c6             	mov    %rax,%rsi
  802ee5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802eec:	00 00 00 
  802eef:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802efb:	be 00 00 00 00       	mov    $0x0,%esi
  802f00:	bf 07 00 00 00       	mov    $0x7,%edi
  802f05:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
}
  802f11:	c9                   	leaveq 
  802f12:	c3                   	retq   

0000000000802f13 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f13:	55                   	push   %rbp
  802f14:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f17:	be 00 00 00 00       	mov    $0x0,%esi
  802f1c:	bf 08 00 00 00       	mov    $0x8,%edi
  802f21:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
}
  802f2d:	5d                   	pop    %rbp
  802f2e:	c3                   	retq   

0000000000802f2f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
  802f33:	53                   	push   %rbx
  802f34:	48 83 ec 38          	sub    $0x38,%rsp
  802f38:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f3c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f40:	48 89 c7             	mov    %rax,%rdi
  802f43:	48 b8 54 21 80 00 00 	movabs $0x802154,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f56:	0f 88 bf 01 00 00    	js     80311b <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f60:	ba 07 04 00 00       	mov    $0x407,%edx
  802f65:	48 89 c6             	mov    %rax,%rsi
  802f68:	bf 00 00 00 00       	mov    $0x0,%edi
  802f6d:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f80:	0f 88 95 01 00 00    	js     80311b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f86:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f8a:	48 89 c7             	mov    %rax,%rdi
  802f8d:	48 b8 54 21 80 00 00 	movabs $0x802154,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fa0:	0f 88 5d 01 00 00    	js     803103 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802faa:	ba 07 04 00 00       	mov    $0x407,%edx
  802faf:	48 89 c6             	mov    %rax,%rsi
  802fb2:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb7:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802fbe:	00 00 00 
  802fc1:	ff d0                	callq  *%rax
  802fc3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fca:	0f 88 33 01 00 00    	js     803103 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd4:	48 89 c7             	mov    %rax,%rdi
  802fd7:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
  802fe3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fe7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802feb:	ba 07 04 00 00       	mov    $0x407,%edx
  802ff0:	48 89 c6             	mov    %rax,%rsi
  802ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff8:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
  803004:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803007:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80300b:	79 05                	jns    803012 <pipe+0xe3>
		goto err2;
  80300d:	e9 d9 00 00 00       	jmpq   8030eb <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803012:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803016:	48 89 c7             	mov    %rax,%rdi
  803019:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	48 89 c2             	mov    %rax,%rdx
  803028:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80302c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803032:	48 89 d1             	mov    %rdx,%rcx
  803035:	ba 00 00 00 00       	mov    $0x0,%edx
  80303a:	48 89 c6             	mov    %rax,%rsi
  80303d:	bf 00 00 00 00       	mov    $0x0,%edi
  803042:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
  80304e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803051:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803055:	79 1b                	jns    803072 <pipe+0x143>
		goto err3;
  803057:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803058:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80305c:	48 89 c6             	mov    %rax,%rsi
  80305f:	bf 00 00 00 00       	mov    $0x0,%edi
  803064:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	callq  *%rax
  803070:	eb 79                	jmp    8030eb <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803072:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803076:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80307d:	00 00 00 
  803080:	8b 12                	mov    (%rdx),%edx
  803082:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803084:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803088:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80308f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803093:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80309a:	00 00 00 
  80309d:	8b 12                	mov    (%rdx),%edx
  80309f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8030a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b0:	48 89 c7             	mov    %rax,%rdi
  8030b3:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8030ba:	00 00 00 
  8030bd:	ff d0                	callq  *%rax
  8030bf:	89 c2                	mov    %eax,%edx
  8030c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030c5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8030c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030cb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030d3:	48 89 c7             	mov    %rax,%rdi
  8030d6:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
  8030e2:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e9:	eb 33                	jmp    80311e <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8030eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ef:	48 89 c6             	mov    %rax,%rsi
  8030f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f7:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8030fe:	00 00 00 
  803101:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803107:	48 89 c6             	mov    %rax,%rsi
  80310a:	bf 00 00 00 00       	mov    $0x0,%edi
  80310f:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
    err:
	return r;
  80311b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80311e:	48 83 c4 38          	add    $0x38,%rsp
  803122:	5b                   	pop    %rbx
  803123:	5d                   	pop    %rbp
  803124:	c3                   	retq   

0000000000803125 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803125:	55                   	push   %rbp
  803126:	48 89 e5             	mov    %rsp,%rbp
  803129:	53                   	push   %rbx
  80312a:	48 83 ec 28          	sub    $0x28,%rsp
  80312e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803132:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803136:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80313d:	00 00 00 
  803140:	48 8b 00             	mov    (%rax),%rax
  803143:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803149:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80314c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803150:	48 89 c7             	mov    %rax,%rdi
  803153:	48 b8 e9 3b 80 00 00 	movabs $0x803be9,%rax
  80315a:	00 00 00 
  80315d:	ff d0                	callq  *%rax
  80315f:	89 c3                	mov    %eax,%ebx
  803161:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803165:	48 89 c7             	mov    %rax,%rdi
  803168:	48 b8 e9 3b 80 00 00 	movabs $0x803be9,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
  803174:	39 c3                	cmp    %eax,%ebx
  803176:	0f 94 c0             	sete   %al
  803179:	0f b6 c0             	movzbl %al,%eax
  80317c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80317f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803186:	00 00 00 
  803189:	48 8b 00             	mov    (%rax),%rax
  80318c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803192:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803195:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803198:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80319b:	75 05                	jne    8031a2 <_pipeisclosed+0x7d>
			return ret;
  80319d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031a0:	eb 4f                	jmp    8031f1 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8031a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031a8:	74 42                	je     8031ec <_pipeisclosed+0xc7>
  8031aa:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031ae:	75 3c                	jne    8031ec <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031b0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031b7:	00 00 00 
  8031ba:	48 8b 00             	mov    (%rax),%rax
  8031bd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031c3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c9:	89 c6                	mov    %eax,%esi
  8031cb:	48 bf b7 43 80 00 00 	movabs $0x8043b7,%rdi
  8031d2:	00 00 00 
  8031d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031da:	49 b8 1b 03 80 00 00 	movabs $0x80031b,%r8
  8031e1:	00 00 00 
  8031e4:	41 ff d0             	callq  *%r8
	}
  8031e7:	e9 4a ff ff ff       	jmpq   803136 <_pipeisclosed+0x11>
  8031ec:	e9 45 ff ff ff       	jmpq   803136 <_pipeisclosed+0x11>
}
  8031f1:	48 83 c4 28          	add    $0x28,%rsp
  8031f5:	5b                   	pop    %rbx
  8031f6:	5d                   	pop    %rbp
  8031f7:	c3                   	retq   

00000000008031f8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031f8:	55                   	push   %rbp
  8031f9:	48 89 e5             	mov    %rsp,%rbp
  8031fc:	48 83 ec 30          	sub    $0x30,%rsp
  803200:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803203:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803207:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80320a:	48 89 d6             	mov    %rdx,%rsi
  80320d:	89 c7                	mov    %eax,%edi
  80320f:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
  80321b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803222:	79 05                	jns    803229 <pipeisclosed+0x31>
		return r;
  803224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803227:	eb 31                	jmp    80325a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322d:	48 89 c7             	mov    %rax,%rdi
  803230:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
  80323c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803244:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803248:	48 89 d6             	mov    %rdx,%rsi
  80324b:	48 89 c7             	mov    %rax,%rdi
  80324e:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
}
  80325a:	c9                   	leaveq 
  80325b:	c3                   	retq   

000000000080325c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80325c:	55                   	push   %rbp
  80325d:	48 89 e5             	mov    %rsp,%rbp
  803260:	48 83 ec 40          	sub    $0x40,%rsp
  803264:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803268:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80326c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803270:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803274:	48 89 c7             	mov    %rax,%rdi
  803277:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  80327e:	00 00 00 
  803281:	ff d0                	callq  *%rax
  803283:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803287:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80328f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803296:	00 
  803297:	e9 92 00 00 00       	jmpq   80332e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80329c:	eb 41                	jmp    8032df <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80329e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032a3:	74 09                	je     8032ae <devpipe_read+0x52>
				return i;
  8032a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a9:	e9 92 00 00 00       	jmpq   803340 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8032ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b6:	48 89 d6             	mov    %rdx,%rsi
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
  8032c8:	85 c0                	test   %eax,%eax
  8032ca:	74 07                	je     8032d3 <devpipe_read+0x77>
				return 0;
  8032cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d1:	eb 6d                	jmp    803340 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032d3:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e3:	8b 10                	mov    (%rax),%edx
  8032e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e9:	8b 40 04             	mov    0x4(%rax),%eax
  8032ec:	39 c2                	cmp    %eax,%edx
  8032ee:	74 ae                	je     80329e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032f8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	8b 00                	mov    (%rax),%eax
  803302:	99                   	cltd   
  803303:	c1 ea 1b             	shr    $0x1b,%edx
  803306:	01 d0                	add    %edx,%eax
  803308:	83 e0 1f             	and    $0x1f,%eax
  80330b:	29 d0                	sub    %edx,%eax
  80330d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803311:	48 98                	cltq   
  803313:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803318:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331e:	8b 00                	mov    (%rax),%eax
  803320:	8d 50 01             	lea    0x1(%rax),%edx
  803323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803327:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803329:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80332e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803332:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803336:	0f 82 60 ff ff ff    	jb     80329c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80333c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803340:	c9                   	leaveq 
  803341:	c3                   	retq   

0000000000803342 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803342:	55                   	push   %rbp
  803343:	48 89 e5             	mov    %rsp,%rbp
  803346:	48 83 ec 40          	sub    $0x40,%rsp
  80334a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80334e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803352:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335a:	48 89 c7             	mov    %rax,%rdi
  80335d:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80336d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803371:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803375:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80337c:	00 
  80337d:	e9 8e 00 00 00       	jmpq   803410 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803382:	eb 31                	jmp    8033b5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803384:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338c:	48 89 d6             	mov    %rdx,%rsi
  80338f:	48 89 c7             	mov    %rax,%rdi
  803392:	48 b8 25 31 80 00 00 	movabs $0x803125,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	74 07                	je     8033a9 <devpipe_write+0x67>
				return 0;
  8033a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a7:	eb 79                	jmp    803422 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8033a9:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b9:	8b 40 04             	mov    0x4(%rax),%eax
  8033bc:	48 63 d0             	movslq %eax,%rdx
  8033bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c3:	8b 00                	mov    (%rax),%eax
  8033c5:	48 98                	cltq   
  8033c7:	48 83 c0 20          	add    $0x20,%rax
  8033cb:	48 39 c2             	cmp    %rax,%rdx
  8033ce:	73 b4                	jae    803384 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d4:	8b 40 04             	mov    0x4(%rax),%eax
  8033d7:	99                   	cltd   
  8033d8:	c1 ea 1b             	shr    $0x1b,%edx
  8033db:	01 d0                	add    %edx,%eax
  8033dd:	83 e0 1f             	and    $0x1f,%eax
  8033e0:	29 d0                	sub    %edx,%eax
  8033e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033e6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033ea:	48 01 ca             	add    %rcx,%rdx
  8033ed:	0f b6 0a             	movzbl (%rdx),%ecx
  8033f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033f4:	48 98                	cltq   
  8033f6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fe:	8b 40 04             	mov    0x4(%rax),%eax
  803401:	8d 50 01             	lea    0x1(%rax),%edx
  803404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803408:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80340b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803414:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803418:	0f 82 64 ff ff ff    	jb     803382 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80341e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803422:	c9                   	leaveq 
  803423:	c3                   	retq   

0000000000803424 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803424:	55                   	push   %rbp
  803425:	48 89 e5             	mov    %rsp,%rbp
  803428:	48 83 ec 20          	sub    $0x20,%rsp
  80342c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803438:	48 89 c7             	mov    %rax,%rdi
  80343b:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
  803447:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80344b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344f:	48 be ca 43 80 00 00 	movabs $0x8043ca,%rsi
  803456:	00 00 00 
  803459:	48 89 c7             	mov    %rax,%rdi
  80345c:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346c:	8b 50 04             	mov    0x4(%rax),%edx
  80346f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803473:	8b 00                	mov    (%rax),%eax
  803475:	29 c2                	sub    %eax,%edx
  803477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803485:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80348c:	00 00 00 
	stat->st_dev = &devpipe;
  80348f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803493:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  80349a:	00 00 00 
  80349d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8034a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 10          	sub    $0x10,%rsp
  8034b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bb:	48 89 c6             	mov    %rax,%rsi
  8034be:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c3:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 29 21 80 00 00 	movabs $0x802129,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
  8034e2:	48 89 c6             	mov    %rax,%rsi
  8034e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ea:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
}
  8034f6:	c9                   	leaveq 
  8034f7:	c3                   	retq   

00000000008034f8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034f8:	55                   	push   %rbp
  8034f9:	48 89 e5             	mov    %rsp,%rbp
  8034fc:	48 83 ec 20          	sub    $0x20,%rsp
  803500:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803503:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803506:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803509:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80350d:	be 01 00 00 00       	mov    $0x1,%esi
  803512:	48 89 c7             	mov    %rax,%rdi
  803515:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
}
  803521:	c9                   	leaveq 
  803522:	c3                   	retq   

0000000000803523 <getchar>:

int
getchar(void)
{
  803523:	55                   	push   %rbp
  803524:	48 89 e5             	mov    %rsp,%rbp
  803527:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80352b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80352f:	ba 01 00 00 00       	mov    $0x1,%edx
  803534:	48 89 c6             	mov    %rax,%rsi
  803537:	bf 00 00 00 00       	mov    $0x0,%edi
  80353c:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80354b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354f:	79 05                	jns    803556 <getchar+0x33>
		return r;
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	eb 14                	jmp    80356a <getchar+0x47>
	if (r < 1)
  803556:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355a:	7f 07                	jg     803563 <getchar+0x40>
		return -E_EOF;
  80355c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803561:	eb 07                	jmp    80356a <getchar+0x47>
	return c;
  803563:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803567:	0f b6 c0             	movzbl %al,%eax
}
  80356a:	c9                   	leaveq 
  80356b:	c3                   	retq   

000000000080356c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80356c:	55                   	push   %rbp
  80356d:	48 89 e5             	mov    %rsp,%rbp
  803570:	48 83 ec 20          	sub    $0x20,%rsp
  803574:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803577:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80357b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357e:	48 89 d6             	mov    %rdx,%rsi
  803581:	89 c7                	mov    %eax,%edi
  803583:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
  80358f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803592:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803596:	79 05                	jns    80359d <iscons+0x31>
		return r;
  803598:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359b:	eb 1a                	jmp    8035b7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80359d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a1:	8b 10                	mov    (%rax),%edx
  8035a3:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8035aa:	00 00 00 
  8035ad:	8b 00                	mov    (%rax),%eax
  8035af:	39 c2                	cmp    %eax,%edx
  8035b1:	0f 94 c0             	sete   %al
  8035b4:	0f b6 c0             	movzbl %al,%eax
}
  8035b7:	c9                   	leaveq 
  8035b8:	c3                   	retq   

00000000008035b9 <opencons>:

int
opencons(void)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035c1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035c5:	48 89 c7             	mov    %rax,%rdi
  8035c8:	48 b8 54 21 80 00 00 	movabs $0x802154,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035db:	79 05                	jns    8035e2 <opencons+0x29>
		return r;
  8035dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e0:	eb 5b                	jmp    80363d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e6:	ba 07 04 00 00       	mov    $0x407,%edx
  8035eb:	48 89 c6             	mov    %rax,%rsi
  8035ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f3:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8035fa:	00 00 00 
  8035fd:	ff d0                	callq  *%rax
  8035ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803602:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803606:	79 05                	jns    80360d <opencons+0x54>
		return r;
  803608:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360b:	eb 30                	jmp    80363d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803611:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803618:	00 00 00 
  80361b:	8b 12                	mov    (%rdx),%edx
  80361d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80361f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803623:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	48 89 c7             	mov    %rax,%rdi
  803631:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
}
  80363d:	c9                   	leaveq 
  80363e:	c3                   	retq   

000000000080363f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
  803643:	48 83 ec 30          	sub    $0x30,%rsp
  803647:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80364b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80364f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803653:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803658:	75 07                	jne    803661 <devcons_read+0x22>
		return 0;
  80365a:	b8 00 00 00 00       	mov    $0x0,%eax
  80365f:	eb 4b                	jmp    8036ac <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803661:	eb 0c                	jmp    80366f <devcons_read+0x30>
		sys_yield();
  803663:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  80366a:	00 00 00 
  80366d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80366f:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  803676:	00 00 00 
  803679:	ff d0                	callq  *%rax
  80367b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803682:	74 df                	je     803663 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803684:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803688:	79 05                	jns    80368f <devcons_read+0x50>
		return c;
  80368a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368d:	eb 1d                	jmp    8036ac <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80368f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803693:	75 07                	jne    80369c <devcons_read+0x5d>
		return 0;
  803695:	b8 00 00 00 00       	mov    $0x0,%eax
  80369a:	eb 10                	jmp    8036ac <devcons_read+0x6d>
	*(char*)vbuf = c;
  80369c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369f:	89 c2                	mov    %eax,%edx
  8036a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a5:	88 10                	mov    %dl,(%rax)
	return 1;
  8036a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8036ac:	c9                   	leaveq 
  8036ad:	c3                   	retq   

00000000008036ae <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036ae:	55                   	push   %rbp
  8036af:	48 89 e5             	mov    %rsp,%rbp
  8036b2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036b9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036c0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036c7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036d5:	eb 76                	jmp    80374d <devcons_write+0x9f>
		m = n - tot;
  8036d7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036de:	89 c2                	mov    %eax,%edx
  8036e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e3:	29 c2                	sub    %eax,%edx
  8036e5:	89 d0                	mov    %edx,%eax
  8036e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ed:	83 f8 7f             	cmp    $0x7f,%eax
  8036f0:	76 07                	jbe    8036f9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036f2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036fc:	48 63 d0             	movslq %eax,%rdx
  8036ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803702:	48 63 c8             	movslq %eax,%rcx
  803705:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80370c:	48 01 c1             	add    %rax,%rcx
  80370f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803716:	48 89 ce             	mov    %rcx,%rsi
  803719:	48 89 c7             	mov    %rax,%rdi
  80371c:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  803723:	00 00 00 
  803726:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803728:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80372b:	48 63 d0             	movslq %eax,%rdx
  80372e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803735:	48 89 d6             	mov    %rdx,%rsi
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803747:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80374a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80374d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803750:	48 98                	cltq   
  803752:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803759:	0f 82 78 ff ff ff    	jb     8036d7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80375f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803762:	c9                   	leaveq 
  803763:	c3                   	retq   

0000000000803764 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803764:	55                   	push   %rbp
  803765:	48 89 e5             	mov    %rsp,%rbp
  803768:	48 83 ec 08          	sub    $0x8,%rsp
  80376c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803770:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803775:	c9                   	leaveq 
  803776:	c3                   	retq   

0000000000803777 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803777:	55                   	push   %rbp
  803778:	48 89 e5             	mov    %rsp,%rbp
  80377b:	48 83 ec 10          	sub    $0x10,%rsp
  80377f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803783:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378b:	48 be d6 43 80 00 00 	movabs $0x8043d6,%rsi
  803792:	00 00 00 
  803795:	48 89 c7             	mov    %rax,%rdi
  803798:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
	return 0;
  8037a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037a9:	c9                   	leaveq 
  8037aa:	c3                   	retq   

00000000008037ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8037ab:	55                   	push   %rbp
  8037ac:	48 89 e5             	mov    %rsp,%rbp
  8037af:	53                   	push   %rbx
  8037b0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037b7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8037be:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8037c4:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037cb:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037d2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037d9:	84 c0                	test   %al,%al
  8037db:	74 23                	je     803800 <_panic+0x55>
  8037dd:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037e4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037e8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037ec:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037f0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037f4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037f8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037fc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803800:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803807:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80380e:	00 00 00 
  803811:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803818:	00 00 00 
  80381b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80381f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803826:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80382d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803834:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80383b:	00 00 00 
  80383e:	48 8b 18             	mov    (%rax),%rbx
  803841:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  803848:	00 00 00 
  80384b:	ff d0                	callq  *%rax
  80384d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803853:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80385a:	41 89 c8             	mov    %ecx,%r8d
  80385d:	48 89 d1             	mov    %rdx,%rcx
  803860:	48 89 da             	mov    %rbx,%rdx
  803863:	89 c6                	mov    %eax,%esi
  803865:	48 bf e0 43 80 00 00 	movabs $0x8043e0,%rdi
  80386c:	00 00 00 
  80386f:	b8 00 00 00 00       	mov    $0x0,%eax
  803874:	49 b9 1b 03 80 00 00 	movabs $0x80031b,%r9
  80387b:	00 00 00 
  80387e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803881:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803888:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80388f:	48 89 d6             	mov    %rdx,%rsi
  803892:	48 89 c7             	mov    %rax,%rdi
  803895:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
	cprintf("\n");
  8038a1:	48 bf 03 44 80 00 00 	movabs $0x804403,%rdi
  8038a8:	00 00 00 
  8038ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b0:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  8038b7:	00 00 00 
  8038ba:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8038bc:	cc                   	int3   
  8038bd:	eb fd                	jmp    8038bc <_panic+0x111>

00000000008038bf <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038bf:	55                   	push   %rbp
  8038c0:	48 89 e5             	mov    %rsp,%rbp
  8038c3:	48 83 ec 10          	sub    $0x10,%rsp
  8038c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8038cb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038d2:	00 00 00 
  8038d5:	48 8b 00             	mov    (%rax),%rax
  8038d8:	48 85 c0             	test   %rax,%rax
  8038db:	0f 85 84 00 00 00    	jne    803965 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8038e1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038e8:	00 00 00 
  8038eb:	48 8b 00             	mov    (%rax),%rax
  8038ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8038f4:	ba 07 00 00 00       	mov    $0x7,%edx
  8038f9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8038fe:	89 c7                	mov    %eax,%edi
  803900:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	79 2a                	jns    80393a <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803910:	48 ba 08 44 80 00 00 	movabs $0x804408,%rdx
  803917:	00 00 00 
  80391a:	be 23 00 00 00       	mov    $0x23,%esi
  80391f:	48 bf 2f 44 80 00 00 	movabs $0x80442f,%rdi
  803926:	00 00 00 
  803929:	b8 00 00 00 00       	mov    $0x0,%eax
  80392e:	48 b9 ab 37 80 00 00 	movabs $0x8037ab,%rcx
  803935:	00 00 00 
  803938:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80393a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803941:	00 00 00 
  803944:	48 8b 00             	mov    (%rax),%rax
  803947:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80394d:	48 be 78 39 80 00 00 	movabs $0x803978,%rsi
  803954:	00 00 00 
  803957:	89 c7                	mov    %eax,%edi
  803959:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  803960:	00 00 00 
  803963:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803965:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80396c:	00 00 00 
  80396f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803973:	48 89 10             	mov    %rdx,(%rax)
}
  803976:	c9                   	leaveq 
  803977:	c3                   	retq   

0000000000803978 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803978:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80397b:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803982:	00 00 00 
	call *%rax
  803985:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803987:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80398e:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80398f:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803996:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803997:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80399b:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80399e:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8039a5:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8039a6:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8039aa:	4c 8b 3c 24          	mov    (%rsp),%r15
  8039ae:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8039b3:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8039b8:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8039bd:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8039c2:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8039c7:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8039cc:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8039d1:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8039d6:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8039db:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8039e0:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8039e5:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8039ea:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8039ef:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8039f4:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8039f8:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8039fc:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8039fd:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8039fe:	c3                   	retq   

00000000008039ff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039ff:	55                   	push   %rbp
  803a00:	48 89 e5             	mov    %rsp,%rbp
  803a03:	48 83 ec 30          	sub    $0x30,%rsp
  803a07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803a13:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a1a:	00 00 00 
  803a1d:	48 8b 00             	mov    (%rax),%rax
  803a20:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a26:	85 c0                	test   %eax,%eax
  803a28:	75 3c                	jne    803a66 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a2a:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  803a31:	00 00 00 
  803a34:	ff d0                	callq  *%rax
  803a36:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a3b:	48 63 d0             	movslq %eax,%rdx
  803a3e:	48 89 d0             	mov    %rdx,%rax
  803a41:	48 c1 e0 03          	shl    $0x3,%rax
  803a45:	48 01 d0             	add    %rdx,%rax
  803a48:	48 c1 e0 05          	shl    $0x5,%rax
  803a4c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a53:	00 00 00 
  803a56:	48 01 c2             	add    %rax,%rdx
  803a59:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a60:	00 00 00 
  803a63:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a66:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a6b:	75 0e                	jne    803a7b <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803a6d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a74:	00 00 00 
  803a77:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803a7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7f:	48 89 c7             	mov    %rax,%rdi
  803a82:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
  803a8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803a91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a95:	79 19                	jns    803ab0 <ipc_recv+0xb1>
		*from_env_store = 0;
  803a97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a9b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aae:	eb 53                	jmp    803b03 <ipc_recv+0x104>
	}
	if(from_env_store)
  803ab0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ab5:	74 19                	je     803ad0 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803ab7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803abe:	00 00 00 
  803ac1:	48 8b 00             	mov    (%rax),%rax
  803ac4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803aca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ace:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803ad0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ad5:	74 19                	je     803af0 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803ad7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ade:	00 00 00 
  803ae1:	48 8b 00             	mov    (%rax),%rax
  803ae4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aee:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803af0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803af7:	00 00 00 
  803afa:	48 8b 00             	mov    (%rax),%rax
  803afd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803b03:	c9                   	leaveq 
  803b04:	c3                   	retq   

0000000000803b05 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b05:	55                   	push   %rbp
  803b06:	48 89 e5             	mov    %rsp,%rbp
  803b09:	48 83 ec 30          	sub    $0x30,%rsp
  803b0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b10:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b13:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b17:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803b1a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b1f:	75 0e                	jne    803b2f <ipc_send+0x2a>
		pg = (void*)UTOP;
  803b21:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b28:	00 00 00 
  803b2b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b2f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b32:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b3c:	89 c7                	mov    %eax,%edi
  803b3e:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  803b45:	00 00 00 
  803b48:	ff d0                	callq  *%rax
  803b4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803b4d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b51:	75 0c                	jne    803b5f <ipc_send+0x5a>
			sys_yield();
  803b53:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b5f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b63:	74 ca                	je     803b2f <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803b65:	c9                   	leaveq 
  803b66:	c3                   	retq   

0000000000803b67 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b67:	55                   	push   %rbp
  803b68:	48 89 e5             	mov    %rsp,%rbp
  803b6b:	48 83 ec 14          	sub    $0x14,%rsp
  803b6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b79:	eb 5e                	jmp    803bd9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b7b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b82:	00 00 00 
  803b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b88:	48 63 d0             	movslq %eax,%rdx
  803b8b:	48 89 d0             	mov    %rdx,%rax
  803b8e:	48 c1 e0 03          	shl    $0x3,%rax
  803b92:	48 01 d0             	add    %rdx,%rax
  803b95:	48 c1 e0 05          	shl    $0x5,%rax
  803b99:	48 01 c8             	add    %rcx,%rax
  803b9c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ba2:	8b 00                	mov    (%rax),%eax
  803ba4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ba7:	75 2c                	jne    803bd5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ba9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803bb0:	00 00 00 
  803bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb6:	48 63 d0             	movslq %eax,%rdx
  803bb9:	48 89 d0             	mov    %rdx,%rax
  803bbc:	48 c1 e0 03          	shl    $0x3,%rax
  803bc0:	48 01 d0             	add    %rdx,%rax
  803bc3:	48 c1 e0 05          	shl    $0x5,%rax
  803bc7:	48 01 c8             	add    %rcx,%rax
  803bca:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bd0:	8b 40 08             	mov    0x8(%rax),%eax
  803bd3:	eb 12                	jmp    803be7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803bd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bd9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803be0:	7e 99                	jle    803b7b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803be7:	c9                   	leaveq 
  803be8:	c3                   	retq   

0000000000803be9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803be9:	55                   	push   %rbp
  803bea:	48 89 e5             	mov    %rsp,%rbp
  803bed:	48 83 ec 18          	sub    $0x18,%rsp
  803bf1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf9:	48 c1 e8 15          	shr    $0x15,%rax
  803bfd:	48 89 c2             	mov    %rax,%rdx
  803c00:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c07:	01 00 00 
  803c0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0e:	83 e0 01             	and    $0x1,%eax
  803c11:	48 85 c0             	test   %rax,%rax
  803c14:	75 07                	jne    803c1d <pageref+0x34>
		return 0;
  803c16:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1b:	eb 53                	jmp    803c70 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c21:	48 c1 e8 0c          	shr    $0xc,%rax
  803c25:	48 89 c2             	mov    %rax,%rdx
  803c28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c2f:	01 00 00 
  803c32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3e:	83 e0 01             	and    $0x1,%eax
  803c41:	48 85 c0             	test   %rax,%rax
  803c44:	75 07                	jne    803c4d <pageref+0x64>
		return 0;
  803c46:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4b:	eb 23                	jmp    803c70 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c51:	48 c1 e8 0c          	shr    $0xc,%rax
  803c55:	48 89 c2             	mov    %rax,%rdx
  803c58:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c5f:	00 00 00 
  803c62:	48 c1 e2 04          	shl    $0x4,%rdx
  803c66:	48 01 d0             	add    %rdx,%rax
  803c69:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c6d:	0f b7 c0             	movzwl %ax,%eax
}
  803c70:	c9                   	leaveq 
  803c71:	c3                   	retq   
