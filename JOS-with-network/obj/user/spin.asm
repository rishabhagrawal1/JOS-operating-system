
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
  800052:	48 bf 40 47 80 00 00 	movabs $0x804740,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 1f 1f 80 00 00 	movabs $0x801f1f,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 68 47 80 00 00 	movabs $0x804768,%rdi
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
  80009f:	48 bf 88 47 80 00 00 	movabs $0x804788,%rdi
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
  80011a:	48 bf b0 47 80 00 00 	movabs $0x8047b0,%rdi
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
  8001d7:	48 b8 11 25 80 00 00 	movabs $0x802511,%rax
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
  800487:	48 ba f0 49 80 00 00 	movabs $0x8049f0,%rdx
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
  80077f:	48 b8 18 4a 80 00 00 	movabs $0x804a18,%rax
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
  8008cd:	83 fb 15             	cmp    $0x15,%ebx
  8008d0:	7f 16                	jg     8008e8 <vprintfmt+0x21a>
  8008d2:	48 b8 40 49 80 00 00 	movabs $0x804940,%rax
  8008d9:	00 00 00 
  8008dc:	48 63 d3             	movslq %ebx,%rdx
  8008df:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e3:	4d 85 e4             	test   %r12,%r12
  8008e6:	75 2e                	jne    800916 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f0:	89 d9                	mov    %ebx,%ecx
  8008f2:	48 ba 01 4a 80 00 00 	movabs $0x804a01,%rdx
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
  800921:	48 ba 0a 4a 80 00 00 	movabs $0x804a0a,%rdx
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
  80097b:	49 bc 0d 4a 80 00 00 	movabs $0x804a0d,%r12
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
  801681:	48 ba c8 4c 80 00 00 	movabs $0x804cc8,%rdx
  801688:	00 00 00 
  80168b:	be 23 00 00 00       	mov    $0x23,%esi
  801690:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  801697:	00 00 00 
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
  80169f:	49 b9 5c 42 80 00 00 	movabs $0x80425c,%r9
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

0000000000801a6c <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801a7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8b:	00 
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	89 c6                	mov    %eax,%esi
  801a9f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801aa4:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801aab:	00 00 00 
  801aae:	ff d0                	callq  *%rax
}
  801ab0:	c9                   	leaveq 
  801ab1:	c3                   	retq   

0000000000801ab2 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801ab2:	55                   	push   %rbp
  801ab3:	48 89 e5             	mov    %rsp,%rbp
  801ab6:	48 83 ec 20          	sub    $0x20,%rsp
  801aba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801abe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad1:	00 
  801ad2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ade:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae3:	89 c6                	mov    %eax,%esi
  801ae5:	bf 10 00 00 00       	mov    $0x10,%edi
  801aea:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	callq  *%rax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b19:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1e:	be 00 00 00 00       	mov    $0x0,%esi
  801b23:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b28:	48 b8 29 16 80 00 00 	movabs $0x801629,%rax
  801b2f:	00 00 00 
  801b32:	ff d0                	callq  *%rax
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 30          	sub    $0x30,%rsp
  801b3e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b46:	48 8b 00             	mov    (%rax),%rax
  801b49:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b51:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b55:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b58:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b5b:	83 e0 02             	and    $0x2,%eax
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	75 4d                	jne    801baf <pgfault+0x79>
  801b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b66:	48 c1 e8 0c          	shr    $0xc,%rax
  801b6a:	48 89 c2             	mov    %rax,%rdx
  801b6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b74:	01 00 00 
  801b77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b7b:	25 00 08 00 00       	and    $0x800,%eax
  801b80:	48 85 c0             	test   %rax,%rax
  801b83:	74 2a                	je     801baf <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801b85:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  801b8c:	00 00 00 
  801b8f:	be 23 00 00 00       	mov    $0x23,%esi
  801b94:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801b9b:	00 00 00 
  801b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba3:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801baa:	00 00 00 
  801bad:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801baf:	ba 07 00 00 00       	mov    $0x7,%edx
  801bb4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bbe:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	callq  *%rax
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	0f 85 cd 00 00 00    	jne    801c9f <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bde:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801be4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bec:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf1:	48 89 c6             	mov    %rax,%rsi
  801bf4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bf9:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801c00:	00 00 00 
  801c03:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c09:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c0f:	48 89 c1             	mov    %rax,%rcx
  801c12:	ba 00 00 00 00       	mov    $0x0,%edx
  801c17:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801c21:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	79 2a                	jns    801c5b <pgfault+0x125>
				panic("Page map at temp address failed");
  801c31:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801c38:	00 00 00 
  801c3b:	be 30 00 00 00       	mov    $0x30,%esi
  801c40:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801c47:	00 00 00 
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801c56:	00 00 00 
  801c59:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c5b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c60:	bf 00 00 00 00       	mov    $0x0,%edi
  801c65:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  801c6c:	00 00 00 
  801c6f:	ff d0                	callq  *%rax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	79 54                	jns    801cc9 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c75:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  801c7c:	00 00 00 
  801c7f:	be 32 00 00 00       	mov    $0x32,%esi
  801c84:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801c8b:	00 00 00 
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c93:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801c9a:	00 00 00 
  801c9d:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801c9f:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  801ca6:	00 00 00 
  801ca9:	be 34 00 00 00       	mov    $0x34,%esi
  801cae:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801cb5:	00 00 00 
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbd:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801cc4:	00 00 00 
  801cc7:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 20          	sub    $0x20,%rsp
  801cd3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cd6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cd9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ce0:	01 00 00 
  801ce3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ce6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cea:	25 07 0e 00 00       	and    $0xe07,%eax
  801cef:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801cf2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801cf5:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d00:	25 00 04 00 00       	and    $0x400,%eax
  801d05:	85 c0                	test   %eax,%eax
  801d07:	74 57                	je     801d60 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d09:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d0c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d10:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d17:	41 89 f0             	mov    %esi,%r8d
  801d1a:	48 89 c6             	mov    %rax,%rsi
  801d1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d22:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	callq  *%rax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	0f 8e 52 01 00 00    	jle    801e88 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d36:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801d3d:	00 00 00 
  801d40:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d45:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801d4c:	00 00 00 
  801d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d54:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801d5b:	00 00 00 
  801d5e:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d63:	83 e0 02             	and    $0x2,%eax
  801d66:	85 c0                	test   %eax,%eax
  801d68:	75 10                	jne    801d7a <duppage+0xaf>
  801d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6d:	25 00 08 00 00       	and    $0x800,%eax
  801d72:	85 c0                	test   %eax,%eax
  801d74:	0f 84 bb 00 00 00    	je     801e35 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7d:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d82:	80 cc 08             	or     $0x8,%ah
  801d85:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d88:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d8b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d96:	41 89 f0             	mov    %esi,%r8d
  801d99:	48 89 c6             	mov    %rax,%rsi
  801d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801da1:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
  801dad:	85 c0                	test   %eax,%eax
  801daf:	7e 2a                	jle    801ddb <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801db1:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801db8:	00 00 00 
  801dbb:	be 55 00 00 00       	mov    $0x55,%esi
  801dc0:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801dc7:	00 00 00 
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801dd6:	00 00 00 
  801dd9:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ddb:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801dde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de6:	41 89 c8             	mov    %ecx,%r8d
  801de9:	48 89 d1             	mov    %rdx,%rcx
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	48 89 c6             	mov    %rax,%rsi
  801df4:	bf 00 00 00 00       	mov    $0x0,%edi
  801df9:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e00:	00 00 00 
  801e03:	ff d0                	callq  *%rax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	7e 2a                	jle    801e33 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e09:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801e10:	00 00 00 
  801e13:	be 57 00 00 00       	mov    $0x57,%esi
  801e18:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801e1f:	00 00 00 
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801e2e:	00 00 00 
  801e31:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e33:	eb 53                	jmp    801e88 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e38:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e43:	41 89 f0             	mov    %esi,%r8d
  801e46:	48 89 c6             	mov    %rax,%rsi
  801e49:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4e:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	7e 2a                	jle    801e88 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e5e:	48 ba b2 4d 80 00 00 	movabs $0x804db2,%rdx
  801e65:	00 00 00 
  801e68:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e6d:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801e74:	00 00 00 
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  801e83:	00 00 00 
  801e86:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8d:	c9                   	leaveq 
  801e8e:	c3                   	retq   

0000000000801e8f <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801e8f:	55                   	push   %rbp
  801e90:	48 89 e5             	mov    %rsp,%rbp
  801e93:	48 83 ec 18          	sub    $0x18,%rsp
  801e97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ea3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea7:	48 c1 e8 27          	shr    $0x27,%rax
  801eab:	48 89 c2             	mov    %rax,%rdx
  801eae:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801eb5:	01 00 00 
  801eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebc:	83 e0 01             	and    $0x1,%eax
  801ebf:	48 85 c0             	test   %rax,%rax
  801ec2:	74 51                	je     801f15 <pt_is_mapped+0x86>
  801ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec8:	48 c1 e0 0c          	shl    $0xc,%rax
  801ecc:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed0:	48 89 c2             	mov    %rax,%rdx
  801ed3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801eda:	01 00 00 
  801edd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee1:	83 e0 01             	and    $0x1,%eax
  801ee4:	48 85 c0             	test   %rax,%rax
  801ee7:	74 2c                	je     801f15 <pt_is_mapped+0x86>
  801ee9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eed:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef1:	48 c1 e8 15          	shr    $0x15,%rax
  801ef5:	48 89 c2             	mov    %rax,%rdx
  801ef8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eff:	01 00 00 
  801f02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f06:	83 e0 01             	and    $0x1,%eax
  801f09:	48 85 c0             	test   %rax,%rax
  801f0c:	74 07                	je     801f15 <pt_is_mapped+0x86>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	eb 05                	jmp    801f1a <pt_is_mapped+0x8b>
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1a:	83 e0 01             	and    $0x1,%eax
}
  801f1d:	c9                   	leaveq 
  801f1e:	c3                   	retq   

0000000000801f1f <fork>:

envid_t
fork(void)
{
  801f1f:	55                   	push   %rbp
  801f20:	48 89 e5             	mov    %rsp,%rbp
  801f23:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f27:	48 bf 36 1b 80 00 00 	movabs $0x801b36,%rdi
  801f2e:	00 00 00 
  801f31:	48 b8 70 43 80 00 00 	movabs $0x804370,%rax
  801f38:	00 00 00 
  801f3b:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f3d:	b8 07 00 00 00       	mov    $0x7,%eax
  801f42:	cd 30                	int    $0x30
  801f44:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f47:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f4a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f51:	79 30                	jns    801f83 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f53:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f56:	89 c1                	mov    %eax,%ecx
  801f58:	48 ba d0 4d 80 00 00 	movabs $0x804dd0,%rdx
  801f5f:	00 00 00 
  801f62:	be 86 00 00 00       	mov    $0x86,%esi
  801f67:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  801f6e:	00 00 00 
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
  801f76:	49 b8 5c 42 80 00 00 	movabs $0x80425c,%r8
  801f7d:	00 00 00 
  801f80:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f87:	75 46                	jne    801fcf <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801f89:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  801f90:	00 00 00 
  801f93:	ff d0                	callq  *%rax
  801f95:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f9a:	48 63 d0             	movslq %eax,%rdx
  801f9d:	48 89 d0             	mov    %rdx,%rax
  801fa0:	48 c1 e0 03          	shl    $0x3,%rax
  801fa4:	48 01 d0             	add    %rdx,%rax
  801fa7:	48 c1 e0 05          	shl    $0x5,%rax
  801fab:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fb2:	00 00 00 
  801fb5:	48 01 c2             	add    %rax,%rdx
  801fb8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fbf:	00 00 00 
  801fc2:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	e9 d1 01 00 00       	jmpq   8021a0 <fork+0x281>
	}
	uint64_t ad = 0;
  801fcf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fd6:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801fd7:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fe0:	e9 df 00 00 00       	jmpq   8020c4 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fe5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe9:	48 c1 e8 27          	shr    $0x27,%rax
  801fed:	48 89 c2             	mov    %rax,%rdx
  801ff0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ff7:	01 00 00 
  801ffa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffe:	83 e0 01             	and    $0x1,%eax
  802001:	48 85 c0             	test   %rax,%rax
  802004:	0f 84 9e 00 00 00    	je     8020a8 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80200a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802012:	48 89 c2             	mov    %rax,%rdx
  802015:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80201c:	01 00 00 
  80201f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802023:	83 e0 01             	and    $0x1,%eax
  802026:	48 85 c0             	test   %rax,%rax
  802029:	74 73                	je     80209e <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80202b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202f:	48 c1 e8 15          	shr    $0x15,%rax
  802033:	48 89 c2             	mov    %rax,%rdx
  802036:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80203d:	01 00 00 
  802040:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802044:	83 e0 01             	and    $0x1,%eax
  802047:	48 85 c0             	test   %rax,%rax
  80204a:	74 48                	je     802094 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  80204c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802050:	48 c1 e8 0c          	shr    $0xc,%rax
  802054:	48 89 c2             	mov    %rax,%rdx
  802057:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80205e:	01 00 00 
  802061:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802065:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206d:	83 e0 01             	and    $0x1,%eax
  802070:	48 85 c0             	test   %rax,%rax
  802073:	74 47                	je     8020bc <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802075:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802079:	48 c1 e8 0c          	shr    $0xc,%rax
  80207d:	89 c2                	mov    %eax,%edx
  80207f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802082:	89 d6                	mov    %edx,%esi
  802084:	89 c7                	mov    %eax,%edi
  802086:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  80208d:	00 00 00 
  802090:	ff d0                	callq  *%rax
  802092:	eb 28                	jmp    8020bc <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802094:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80209b:	00 
  80209c:	eb 1e                	jmp    8020bc <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80209e:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020a5:	40 
  8020a6:	eb 14                	jmp    8020bc <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ac:	48 c1 e8 27          	shr    $0x27,%rax
  8020b0:	48 83 c0 01          	add    $0x1,%rax
  8020b4:	48 c1 e0 27          	shl    $0x27,%rax
  8020b8:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020bc:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020c3:	00 
  8020c4:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020cb:	00 
  8020cc:	0f 87 13 ff ff ff    	ja     801fe5 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8020da:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020df:	89 c7                	mov    %eax,%edi
  8020e1:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f0:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f5:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020fa:	89 c7                	mov    %eax,%edi
  8020fc:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  802103:	00 00 00 
  802106:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802108:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802111:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802116:	ba 00 00 00 00       	mov    $0x0,%edx
  80211b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802120:	89 c7                	mov    %eax,%edi
  802122:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80212e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802133:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802138:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80213d:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802144:	00 00 00 
  802147:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802149:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80214e:	bf 00 00 00 00       	mov    $0x0,%edi
  802153:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80215f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802166:	00 00 00 
  802169:	48 8b 00             	mov    (%rax),%rax
  80216c:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802176:	48 89 d6             	mov    %rdx,%rsi
  802179:	89 c7                	mov    %eax,%edi
  80217b:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  802182:	00 00 00 
  802185:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802187:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80218a:	be 02 00 00 00       	mov    $0x2,%esi
  80218f:	89 c7                	mov    %eax,%edi
  802191:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  802198:	00 00 00 
  80219b:	ff d0                	callq  *%rax

	return envid;
  80219d:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021a0:	c9                   	leaveq 
  8021a1:	c3                   	retq   

00000000008021a2 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021a2:	55                   	push   %rbp
  8021a3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021a6:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  8021ad:	00 00 00 
  8021b0:	be bf 00 00 00       	mov    $0xbf,%esi
  8021b5:	48 bf 2d 4d 80 00 00 	movabs $0x804d2d,%rdi
  8021bc:	00 00 00 
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  8021cb:	00 00 00 
  8021ce:	ff d1                	callq  *%rcx

00000000008021d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 08          	sub    $0x8,%rsp
  8021d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021e0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021e7:	ff ff ff 
  8021ea:	48 01 d0             	add    %rdx,%rax
  8021ed:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021f1:	c9                   	leaveq 
  8021f2:	c3                   	retq   

00000000008021f3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021f3:	55                   	push   %rbp
  8021f4:	48 89 e5             	mov    %rsp,%rbp
  8021f7:	48 83 ec 08          	sub    $0x8,%rsp
  8021fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802203:	48 89 c7             	mov    %rax,%rdi
  802206:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  80220d:	00 00 00 
  802210:	ff d0                	callq  *%rax
  802212:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802218:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80221c:	c9                   	leaveq 
  80221d:	c3                   	retq   

000000000080221e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80221e:	55                   	push   %rbp
  80221f:	48 89 e5             	mov    %rsp,%rbp
  802222:	48 83 ec 18          	sub    $0x18,%rsp
  802226:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80222a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802231:	eb 6b                	jmp    80229e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802236:	48 98                	cltq   
  802238:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223e:	48 c1 e0 0c          	shl    $0xc,%rax
  802242:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224a:	48 c1 e8 15          	shr    $0x15,%rax
  80224e:	48 89 c2             	mov    %rax,%rdx
  802251:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802258:	01 00 00 
  80225b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225f:	83 e0 01             	and    $0x1,%eax
  802262:	48 85 c0             	test   %rax,%rax
  802265:	74 21                	je     802288 <fd_alloc+0x6a>
  802267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226b:	48 c1 e8 0c          	shr    $0xc,%rax
  80226f:	48 89 c2             	mov    %rax,%rdx
  802272:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802279:	01 00 00 
  80227c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802280:	83 e0 01             	and    $0x1,%eax
  802283:	48 85 c0             	test   %rax,%rax
  802286:	75 12                	jne    80229a <fd_alloc+0x7c>
			*fd_store = fd;
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802290:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	eb 1a                	jmp    8022b4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80229a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80229e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022a2:	7e 8f                	jle    802233 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022af:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022b4:	c9                   	leaveq 
  8022b5:	c3                   	retq   

00000000008022b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022b6:	55                   	push   %rbp
  8022b7:	48 89 e5             	mov    %rsp,%rbp
  8022ba:	48 83 ec 20          	sub    $0x20,%rsp
  8022be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022c9:	78 06                	js     8022d1 <fd_lookup+0x1b>
  8022cb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022cf:	7e 07                	jle    8022d8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d6:	eb 6c                	jmp    802344 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022db:	48 98                	cltq   
  8022dd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022e3:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ef:	48 c1 e8 15          	shr    $0x15,%rax
  8022f3:	48 89 c2             	mov    %rax,%rdx
  8022f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	83 e0 01             	and    $0x1,%eax
  802307:	48 85 c0             	test   %rax,%rax
  80230a:	74 21                	je     80232d <fd_lookup+0x77>
  80230c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802310:	48 c1 e8 0c          	shr    $0xc,%rax
  802314:	48 89 c2             	mov    %rax,%rdx
  802317:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80231e:	01 00 00 
  802321:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802325:	83 e0 01             	and    $0x1,%eax
  802328:	48 85 c0             	test   %rax,%rax
  80232b:	75 07                	jne    802334 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80232d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802332:	eb 10                	jmp    802344 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802334:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802338:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80233c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802344:	c9                   	leaveq 
  802345:	c3                   	retq   

0000000000802346 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802346:	55                   	push   %rbp
  802347:	48 89 e5             	mov    %rsp,%rbp
  80234a:	48 83 ec 30          	sub    $0x30,%rsp
  80234e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802352:	89 f0                	mov    %esi,%eax
  802354:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802357:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235b:	48 89 c7             	mov    %rax,%rdi
  80235e:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802365:	00 00 00 
  802368:	ff d0                	callq  *%rax
  80236a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80236e:	48 89 d6             	mov    %rdx,%rsi
  802371:	89 c7                	mov    %eax,%edi
  802373:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	callq  *%rax
  80237f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802386:	78 0a                	js     802392 <fd_close+0x4c>
	    || fd != fd2)
  802388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802390:	74 12                	je     8023a4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802392:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802396:	74 05                	je     80239d <fd_close+0x57>
  802398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239b:	eb 05                	jmp    8023a2 <fd_close+0x5c>
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	eb 69                	jmp    80240d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a8:	8b 00                	mov    (%rax),%eax
  8023aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023ae:	48 89 d6             	mov    %rdx,%rsi
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	48 b8 0f 24 80 00 00 	movabs $0x80240f,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	callq  *%rax
  8023bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c6:	78 2a                	js     8023f2 <fd_close+0xac>
		if (dev->dev_close)
  8023c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023d0:	48 85 c0             	test   %rax,%rax
  8023d3:	74 16                	je     8023eb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023dd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023e1:	48 89 d7             	mov    %rdx,%rdi
  8023e4:	ff d0                	callq  *%rax
  8023e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e9:	eb 07                	jmp    8023f2 <fd_close+0xac>
		else
			r = 0;
  8023eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023f6:	48 89 c6             	mov    %rax,%rsi
  8023f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fe:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  802405:	00 00 00 
  802408:	ff d0                	callq  *%rax
	return r;
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80240d:	c9                   	leaveq 
  80240e:	c3                   	retq   

000000000080240f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80240f:	55                   	push   %rbp
  802410:	48 89 e5             	mov    %rsp,%rbp
  802413:	48 83 ec 20          	sub    $0x20,%rsp
  802417:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80241a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80241e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802425:	eb 41                	jmp    802468 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802427:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80242e:	00 00 00 
  802431:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802434:	48 63 d2             	movslq %edx,%rdx
  802437:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243b:	8b 00                	mov    (%rax),%eax
  80243d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802440:	75 22                	jne    802464 <dev_lookup+0x55>
			*dev = devtab[i];
  802442:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802449:	00 00 00 
  80244c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80244f:	48 63 d2             	movslq %edx,%rdx
  802452:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802456:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80245a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	eb 60                	jmp    8024c4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802464:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802468:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80246f:	00 00 00 
  802472:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802475:	48 63 d2             	movslq %edx,%rdx
  802478:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247c:	48 85 c0             	test   %rax,%rax
  80247f:	75 a6                	jne    802427 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802481:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802488:	00 00 00 
  80248b:	48 8b 00             	mov    (%rax),%rax
  80248e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802494:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802497:	89 c6                	mov    %eax,%esi
  802499:	48 bf 00 4e 80 00 00 	movabs $0x804e00,%rdi
  8024a0:	00 00 00 
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8024af:	00 00 00 
  8024b2:	ff d1                	callq  *%rcx
	*dev = 0;
  8024b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024c4:	c9                   	leaveq 
  8024c5:	c3                   	retq   

00000000008024c6 <close>:

int
close(int fdnum)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	48 83 ec 20          	sub    $0x20,%rsp
  8024ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d8:	48 89 d6             	mov    %rdx,%rsi
  8024db:	89 c7                	mov    %eax,%edi
  8024dd:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
  8024e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f0:	79 05                	jns    8024f7 <close+0x31>
		return r;
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	eb 18                	jmp    80250f <close+0x49>
	else
		return fd_close(fd, 1);
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	be 01 00 00 00       	mov    $0x1,%esi
  802500:	48 89 c7             	mov    %rax,%rdi
  802503:	48 b8 46 23 80 00 00 	movabs $0x802346,%rax
  80250a:	00 00 00 
  80250d:	ff d0                	callq  *%rax
}
  80250f:	c9                   	leaveq 
  802510:	c3                   	retq   

0000000000802511 <close_all>:

void
close_all(void)
{
  802511:	55                   	push   %rbp
  802512:	48 89 e5             	mov    %rsp,%rbp
  802515:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802519:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802520:	eb 15                	jmp    802537 <close_all+0x26>
		close(i);
  802522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802525:	89 c7                	mov    %eax,%edi
  802527:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802533:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802537:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80253b:	7e e5                	jle    802522 <close_all+0x11>
		close(i);
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 40          	sub    $0x40,%rsp
  802547:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80254a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80254d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802551:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802554:	48 89 d6             	mov    %rdx,%rsi
  802557:	89 c7                	mov    %eax,%edi
  802559:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  802560:	00 00 00 
  802563:	ff d0                	callq  *%rax
  802565:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256c:	79 08                	jns    802576 <dup+0x37>
		return r;
  80256e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802571:	e9 70 01 00 00       	jmpq   8026e6 <dup+0x1a7>
	close(newfdnum);
  802576:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802579:	89 c7                	mov    %eax,%edi
  80257b:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802587:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80258a:	48 98                	cltq   
  80258c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802592:	48 c1 e0 0c          	shl    $0xc,%rax
  802596:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80259a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80259e:	48 89 c7             	mov    %rax,%rdi
  8025a1:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b5:	48 89 c7             	mov    %rax,%rdi
  8025b8:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  8025bf:	00 00 00 
  8025c2:	ff d0                	callq  *%rax
  8025c4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cc:	48 c1 e8 15          	shr    $0x15,%rax
  8025d0:	48 89 c2             	mov    %rax,%rdx
  8025d3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025da:	01 00 00 
  8025dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e1:	83 e0 01             	and    $0x1,%eax
  8025e4:	48 85 c0             	test   %rax,%rax
  8025e7:	74 73                	je     80265c <dup+0x11d>
  8025e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8025f1:	48 89 c2             	mov    %rax,%rdx
  8025f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025fb:	01 00 00 
  8025fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802602:	83 e0 01             	and    $0x1,%eax
  802605:	48 85 c0             	test   %rax,%rax
  802608:	74 52                	je     80265c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80260a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260e:	48 c1 e8 0c          	shr    $0xc,%rax
  802612:	48 89 c2             	mov    %rax,%rdx
  802615:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80261c:	01 00 00 
  80261f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802623:	25 07 0e 00 00       	and    $0xe07,%eax
  802628:	89 c1                	mov    %eax,%ecx
  80262a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80262e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802632:	41 89 c8             	mov    %ecx,%r8d
  802635:	48 89 d1             	mov    %rdx,%rcx
  802638:	ba 00 00 00 00       	mov    $0x0,%edx
  80263d:	48 89 c6             	mov    %rax,%rsi
  802640:	bf 00 00 00 00       	mov    $0x0,%edi
  802645:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	callq  *%rax
  802651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802658:	79 02                	jns    80265c <dup+0x11d>
			goto err;
  80265a:	eb 57                	jmp    8026b3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80265c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802660:	48 c1 e8 0c          	shr    $0xc,%rax
  802664:	48 89 c2             	mov    %rax,%rdx
  802667:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80266e:	01 00 00 
  802671:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802675:	25 07 0e 00 00       	and    $0xe07,%eax
  80267a:	89 c1                	mov    %eax,%ecx
  80267c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802680:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802684:	41 89 c8             	mov    %ecx,%r8d
  802687:	48 89 d1             	mov    %rdx,%rcx
  80268a:	ba 00 00 00 00       	mov    $0x0,%edx
  80268f:	48 89 c6             	mov    %rax,%rsi
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
  8026a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026aa:	79 02                	jns    8026ae <dup+0x16f>
		goto err;
  8026ac:	eb 05                	jmp    8026b3 <dup+0x174>

	return newfdnum;
  8026ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026b1:	eb 33                	jmp    8026e6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b7:	48 89 c6             	mov    %rax,%rsi
  8026ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bf:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8026c6:	00 00 00 
  8026c9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026cf:	48 89 c6             	mov    %rax,%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
	return r;
  8026e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 40          	sub    $0x40,%rsp
  8026f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802702:	48 89 d6             	mov    %rdx,%rsi
  802705:	89 c7                	mov    %eax,%edi
  802707:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
  802713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271a:	78 24                	js     802740 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	8b 00                	mov    (%rax),%eax
  802722:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802726:	48 89 d6             	mov    %rdx,%rsi
  802729:	89 c7                	mov    %eax,%edi
  80272b:	48 b8 0f 24 80 00 00 	movabs $0x80240f,%rax
  802732:	00 00 00 
  802735:	ff d0                	callq  *%rax
  802737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273e:	79 05                	jns    802745 <read+0x5d>
		return r;
  802740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802743:	eb 76                	jmp    8027bb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802749:	8b 40 08             	mov    0x8(%rax),%eax
  80274c:	83 e0 03             	and    $0x3,%eax
  80274f:	83 f8 01             	cmp    $0x1,%eax
  802752:	75 3a                	jne    80278e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802754:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80275b:	00 00 00 
  80275e:	48 8b 00             	mov    (%rax),%rax
  802761:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802767:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80276a:	89 c6                	mov    %eax,%esi
  80276c:	48 bf 1f 4e 80 00 00 	movabs $0x804e1f,%rdi
  802773:	00 00 00 
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
  80277b:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  802782:	00 00 00 
  802785:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802787:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80278c:	eb 2d                	jmp    8027bb <read+0xd3>
	}
	if (!dev->dev_read)
  80278e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802792:	48 8b 40 10          	mov    0x10(%rax),%rax
  802796:	48 85 c0             	test   %rax,%rax
  802799:	75 07                	jne    8027a2 <read+0xba>
		return -E_NOT_SUPP;
  80279b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027a0:	eb 19                	jmp    8027bb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027aa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027ae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027b2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027b6:	48 89 cf             	mov    %rcx,%rdi
  8027b9:	ff d0                	callq  *%rax
}
  8027bb:	c9                   	leaveq 
  8027bc:	c3                   	retq   

00000000008027bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027bd:	55                   	push   %rbp
  8027be:	48 89 e5             	mov    %rsp,%rbp
  8027c1:	48 83 ec 30          	sub    $0x30,%rsp
  8027c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027d7:	eb 49                	jmp    802822 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dc:	48 98                	cltq   
  8027de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e2:	48 29 c2             	sub    %rax,%rdx
  8027e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e8:	48 63 c8             	movslq %eax,%rcx
  8027eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ef:	48 01 c1             	add    %rax,%rcx
  8027f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f5:	48 89 ce             	mov    %rcx,%rsi
  8027f8:	89 c7                	mov    %eax,%edi
  8027fa:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
  802806:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802809:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80280d:	79 05                	jns    802814 <readn+0x57>
			return m;
  80280f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802812:	eb 1c                	jmp    802830 <readn+0x73>
		if (m == 0)
  802814:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802818:	75 02                	jne    80281c <readn+0x5f>
			break;
  80281a:	eb 11                	jmp    80282d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80281c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80281f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802822:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802825:	48 98                	cltq   
  802827:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80282b:	72 ac                	jb     8027d9 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80282d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802830:	c9                   	leaveq 
  802831:	c3                   	retq   

0000000000802832 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802832:	55                   	push   %rbp
  802833:	48 89 e5             	mov    %rsp,%rbp
  802836:	48 83 ec 40          	sub    $0x40,%rsp
  80283a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80283d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802841:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802845:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802849:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80284c:	48 89 d6             	mov    %rdx,%rsi
  80284f:	89 c7                	mov    %eax,%edi
  802851:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
  80285d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802860:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802864:	78 24                	js     80288a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286a:	8b 00                	mov    (%rax),%eax
  80286c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802870:	48 89 d6             	mov    %rdx,%rsi
  802873:	89 c7                	mov    %eax,%edi
  802875:	48 b8 0f 24 80 00 00 	movabs $0x80240f,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
  802881:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802888:	79 05                	jns    80288f <write+0x5d>
		return r;
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	eb 75                	jmp    802904 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80288f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802893:	8b 40 08             	mov    0x8(%rax),%eax
  802896:	83 e0 03             	and    $0x3,%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	75 3a                	jne    8028d7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80289d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028a4:	00 00 00 
  8028a7:	48 8b 00             	mov    (%rax),%rax
  8028aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028b0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028b3:	89 c6                	mov    %eax,%esi
  8028b5:	48 bf 3b 4e 80 00 00 	movabs $0x804e3b,%rdi
  8028bc:	00 00 00 
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8028cb:	00 00 00 
  8028ce:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028d5:	eb 2d                	jmp    802904 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8028d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028db:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028df:	48 85 c0             	test   %rax,%rax
  8028e2:	75 07                	jne    8028eb <write+0xb9>
		return -E_NOT_SUPP;
  8028e4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e9:	eb 19                	jmp    802904 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028fb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028ff:	48 89 cf             	mov    %rcx,%rdi
  802902:	ff d0                	callq  *%rax
}
  802904:	c9                   	leaveq 
  802905:	c3                   	retq   

0000000000802906 <seek>:

int
seek(int fdnum, off_t offset)
{
  802906:	55                   	push   %rbp
  802907:	48 89 e5             	mov    %rsp,%rbp
  80290a:	48 83 ec 18          	sub    $0x18,%rsp
  80290e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802911:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802914:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802918:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80291b:	48 89 d6             	mov    %rdx,%rsi
  80291e:	89 c7                	mov    %eax,%edi
  802920:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  802927:	00 00 00 
  80292a:	ff d0                	callq  *%rax
  80292c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802933:	79 05                	jns    80293a <seek+0x34>
		return r;
  802935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802938:	eb 0f                	jmp    802949 <seek+0x43>
	fd->fd_offset = offset;
  80293a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802941:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802949:	c9                   	leaveq 
  80294a:	c3                   	retq   

000000000080294b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80294b:	55                   	push   %rbp
  80294c:	48 89 e5             	mov    %rsp,%rbp
  80294f:	48 83 ec 30          	sub    $0x30,%rsp
  802953:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802956:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802959:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80295d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802960:	48 89 d6             	mov    %rdx,%rsi
  802963:	89 c7                	mov    %eax,%edi
  802965:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
  802971:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802974:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802978:	78 24                	js     80299e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297e:	8b 00                	mov    (%rax),%eax
  802980:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802984:	48 89 d6             	mov    %rdx,%rsi
  802987:	89 c7                	mov    %eax,%edi
  802989:	48 b8 0f 24 80 00 00 	movabs $0x80240f,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
  802995:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299c:	79 05                	jns    8029a3 <ftruncate+0x58>
		return r;
  80299e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a1:	eb 72                	jmp    802a15 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a7:	8b 40 08             	mov    0x8(%rax),%eax
  8029aa:	83 e0 03             	and    $0x3,%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	75 3a                	jne    8029eb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029b8:	00 00 00 
  8029bb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029c7:	89 c6                	mov    %eax,%esi
  8029c9:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
  8029d0:	00 00 00 
  8029d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d8:	48 b9 1b 03 80 00 00 	movabs $0x80031b,%rcx
  8029df:	00 00 00 
  8029e2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e9:	eb 2a                	jmp    802a15 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ef:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029f3:	48 85 c0             	test   %rax,%rax
  8029f6:	75 07                	jne    8029ff <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029fd:	eb 16                	jmp    802a15 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a03:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a0b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a0e:	89 ce                	mov    %ecx,%esi
  802a10:	48 89 d7             	mov    %rdx,%rdi
  802a13:	ff d0                	callq  *%rax
}
  802a15:	c9                   	leaveq 
  802a16:	c3                   	retq   

0000000000802a17 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a17:	55                   	push   %rbp
  802a18:	48 89 e5             	mov    %rsp,%rbp
  802a1b:	48 83 ec 30          	sub    $0x30,%rsp
  802a1f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a22:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a26:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a2a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a2d:	48 89 d6             	mov    %rdx,%rsi
  802a30:	89 c7                	mov    %eax,%edi
  802a32:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  802a39:	00 00 00 
  802a3c:	ff d0                	callq  *%rax
  802a3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a45:	78 24                	js     802a6b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4b:	8b 00                	mov    (%rax),%eax
  802a4d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a51:	48 89 d6             	mov    %rdx,%rsi
  802a54:	89 c7                	mov    %eax,%edi
  802a56:	48 b8 0f 24 80 00 00 	movabs $0x80240f,%rax
  802a5d:	00 00 00 
  802a60:	ff d0                	callq  *%rax
  802a62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a69:	79 05                	jns    802a70 <fstat+0x59>
		return r;
  802a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6e:	eb 5e                	jmp    802ace <fstat+0xb7>
	if (!dev->dev_stat)
  802a70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a74:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a78:	48 85 c0             	test   %rax,%rax
  802a7b:	75 07                	jne    802a84 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a7d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a82:	eb 4a                	jmp    802ace <fstat+0xb7>
	stat->st_name[0] = 0;
  802a84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a88:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a8f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a96:	00 00 00 
	stat->st_isdir = 0;
  802a99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a9d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802aa4:	00 00 00 
	stat->st_dev = dev;
  802aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802aab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aaf:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	48 8b 40 28          	mov    0x28(%rax),%rax
  802abe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ac2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ac6:	48 89 ce             	mov    %rcx,%rsi
  802ac9:	48 89 d7             	mov    %rdx,%rdi
  802acc:	ff d0                	callq  *%rax
}
  802ace:	c9                   	leaveq 
  802acf:	c3                   	retq   

0000000000802ad0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	48 83 ec 20          	sub    $0x20,%rsp
  802ad8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802adc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae4:	be 00 00 00 00       	mov    $0x0,%esi
  802ae9:	48 89 c7             	mov    %rax,%rdi
  802aec:	48 b8 be 2b 80 00 00 	movabs $0x802bbe,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
  802af8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aff:	79 05                	jns    802b06 <stat+0x36>
		return fd;
  802b01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b04:	eb 2f                	jmp    802b35 <stat+0x65>
	r = fstat(fd, stat);
  802b06:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0d:	48 89 d6             	mov    %rdx,%rsi
  802b10:	89 c7                	mov    %eax,%edi
  802b12:	48 b8 17 2a 80 00 00 	movabs $0x802a17,%rax
  802b19:	00 00 00 
  802b1c:	ff d0                	callq  *%rax
  802b1e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b24:	89 c7                	mov    %eax,%edi
  802b26:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
	return r;
  802b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b35:	c9                   	leaveq 
  802b36:	c3                   	retq   

0000000000802b37 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b37:	55                   	push   %rbp
  802b38:	48 89 e5             	mov    %rsp,%rbp
  802b3b:	48 83 ec 10          	sub    $0x10,%rsp
  802b3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b46:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b4d:	00 00 00 
  802b50:	8b 00                	mov    (%rax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	75 1d                	jne    802b73 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b56:	bf 01 00 00 00       	mov    $0x1,%edi
  802b5b:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  802b62:	00 00 00 
  802b65:	ff d0                	callq  *%rax
  802b67:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b6e:	00 00 00 
  802b71:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b73:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b7a:	00 00 00 
  802b7d:	8b 00                	mov    (%rax),%eax
  802b7f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b82:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b87:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b8e:	00 00 00 
  802b91:	89 c7                	mov    %eax,%edi
  802b93:	48 b8 b6 45 80 00 00 	movabs $0x8045b6,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba8:	48 89 c6             	mov    %rax,%rsi
  802bab:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb0:	48 b8 b0 44 80 00 00 	movabs $0x8044b0,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
}
  802bbc:	c9                   	leaveq 
  802bbd:	c3                   	retq   

0000000000802bbe <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	48 83 ec 30          	sub    $0x30,%rsp
  802bc6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802bca:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bcd:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bd4:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802be2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802be7:	75 08                	jne    802bf1 <open+0x33>
	{
		return r;
  802be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bec:	e9 f2 00 00 00       	jmpq   802ce3 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf5:	48 89 c7             	mov    %rax,%rdi
  802bf8:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
  802c04:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c07:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c0e:	7e 0a                	jle    802c1a <open+0x5c>
	{
		return -E_BAD_PATH;
  802c10:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c15:	e9 c9 00 00 00       	jmpq   802ce3 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c1a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c21:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c22:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c26:	48 89 c7             	mov    %rax,%rdi
  802c29:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3c:	78 09                	js     802c47 <open+0x89>
  802c3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c42:	48 85 c0             	test   %rax,%rax
  802c45:	75 08                	jne    802c4f <open+0x91>
		{
			return r;
  802c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4a:	e9 94 00 00 00       	jmpq   802ce3 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c53:	ba 00 04 00 00       	mov    $0x400,%edx
  802c58:	48 89 c6             	mov    %rax,%rsi
  802c5b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c62:	00 00 00 
  802c65:	48 b8 62 0f 80 00 00 	movabs $0x800f62,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c71:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c78:	00 00 00 
  802c7b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c7e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c88:	48 89 c6             	mov    %rax,%rsi
  802c8b:	bf 01 00 00 00       	mov    $0x1,%edi
  802c90:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca3:	79 2b                	jns    802cd0 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca9:	be 00 00 00 00       	mov    $0x0,%esi
  802cae:	48 89 c7             	mov    %rax,%rdi
  802cb1:	48 b8 46 23 80 00 00 	movabs $0x802346,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
  802cbd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802cc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cc4:	79 05                	jns    802ccb <open+0x10d>
			{
				return d;
  802cc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc9:	eb 18                	jmp    802ce3 <open+0x125>
			}
			return r;
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	eb 13                	jmp    802ce3 <open+0x125>
		}	
		return fd2num(fd_store);
  802cd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd4:	48 89 c7             	mov    %rax,%rdi
  802cd7:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802ce3:	c9                   	leaveq 
  802ce4:	c3                   	retq   

0000000000802ce5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ce5:	55                   	push   %rbp
  802ce6:	48 89 e5             	mov    %rsp,%rbp
  802ce9:	48 83 ec 10          	sub    $0x10,%rsp
  802ced:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802cf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf5:	8b 50 0c             	mov    0xc(%rax),%edx
  802cf8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cff:	00 00 00 
  802d02:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d04:	be 00 00 00 00       	mov    $0x0,%esi
  802d09:	bf 06 00 00 00       	mov    $0x6,%edi
  802d0e:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	48 83 ec 30          	sub    $0x30,%rsp
  802d24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d37:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d3c:	74 07                	je     802d45 <devfile_read+0x29>
  802d3e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d43:	75 07                	jne    802d4c <devfile_read+0x30>
		return -E_INVAL;
  802d45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d4a:	eb 77                	jmp    802dc3 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d50:	8b 50 0c             	mov    0xc(%rax),%edx
  802d53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d5a:	00 00 00 
  802d5d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d66:	00 00 00 
  802d69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d6d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d71:	be 00 00 00 00       	mov    $0x0,%esi
  802d76:	bf 03 00 00 00       	mov    $0x3,%edi
  802d7b:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802d82:	00 00 00 
  802d85:	ff d0                	callq  *%rax
  802d87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8e:	7f 05                	jg     802d95 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802d90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d93:	eb 2e                	jmp    802dc3 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	48 63 d0             	movslq %eax,%rdx
  802d9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802da6:	00 00 00 
  802da9:	48 89 c7             	mov    %rax,%rdi
  802dac:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802db8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dbc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802dc3:	c9                   	leaveq 
  802dc4:	c3                   	retq   

0000000000802dc5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802dc5:	55                   	push   %rbp
  802dc6:	48 89 e5             	mov    %rsp,%rbp
  802dc9:	48 83 ec 30          	sub    $0x30,%rsp
  802dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802dd9:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802de0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802de5:	74 07                	je     802dee <devfile_write+0x29>
  802de7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dec:	75 08                	jne    802df6 <devfile_write+0x31>
		return r;
  802dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df1:	e9 9a 00 00 00       	jmpq   802e90 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802df6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfa:	8b 50 0c             	mov    0xc(%rax),%edx
  802dfd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e04:	00 00 00 
  802e07:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802e09:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e10:	00 
  802e11:	76 08                	jbe    802e1b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e13:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e1a:	00 
	}
	fsipcbuf.write.req_n = n;
  802e1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e22:	00 00 00 
  802e25:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e29:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e2d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e35:	48 89 c6             	mov    %rax,%rsi
  802e38:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e3f:	00 00 00 
  802e42:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e4e:	be 00 00 00 00       	mov    $0x0,%esi
  802e53:	bf 04 00 00 00       	mov    $0x4,%edi
  802e58:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
  802e64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6b:	7f 20                	jg     802e8d <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e6d:	48 bf 7e 4e 80 00 00 	movabs $0x804e7e,%rdi
  802e74:	00 00 00 
  802e77:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7c:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  802e83:	00 00 00 
  802e86:	ff d2                	callq  *%rdx
		return r;
  802e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8b:	eb 03                	jmp    802e90 <devfile_write+0xcb>
	}
	return r;
  802e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802e90:	c9                   	leaveq 
  802e91:	c3                   	retq   

0000000000802e92 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e92:	55                   	push   %rbp
  802e93:	48 89 e5             	mov    %rsp,%rbp
  802e96:	48 83 ec 20          	sub    $0x20,%rsp
  802e9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ea9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb0:	00 00 00 
  802eb3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802eb5:	be 00 00 00 00       	mov    $0x0,%esi
  802eba:	bf 05 00 00 00       	mov    $0x5,%edi
  802ebf:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
  802ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed2:	79 05                	jns    802ed9 <devfile_stat+0x47>
		return r;
  802ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed7:	eb 56                	jmp    802f2f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ed9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edd:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ee4:	00 00 00 
  802ee7:	48 89 c7             	mov    %rax,%rdi
  802eea:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ef6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802efd:	00 00 00 
  802f00:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f0a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f10:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f17:	00 00 00 
  802f1a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f24:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f2f:	c9                   	leaveq 
  802f30:	c3                   	retq   

0000000000802f31 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f31:	55                   	push   %rbp
  802f32:	48 89 e5             	mov    %rsp,%rbp
  802f35:	48 83 ec 10          	sub    $0x10,%rsp
  802f39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f3d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f44:	8b 50 0c             	mov    0xc(%rax),%edx
  802f47:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f4e:	00 00 00 
  802f51:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f53:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5a:	00 00 00 
  802f5d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f63:	be 00 00 00 00       	mov    $0x0,%esi
  802f68:	bf 02 00 00 00       	mov    $0x2,%edi
  802f6d:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
}
  802f79:	c9                   	leaveq 
  802f7a:	c3                   	retq   

0000000000802f7b <remove>:

// Delete a file
int
remove(const char *path)
{
  802f7b:	55                   	push   %rbp
  802f7c:	48 89 e5             	mov    %rsp,%rbp
  802f7f:	48 83 ec 10          	sub    $0x10,%rsp
  802f83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8b:	48 89 c7             	mov    %rax,%rdi
  802f8e:	48 b8 64 0e 80 00 00 	movabs $0x800e64,%rax
  802f95:	00 00 00 
  802f98:	ff d0                	callq  *%rax
  802f9a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f9f:	7e 07                	jle    802fa8 <remove+0x2d>
		return -E_BAD_PATH;
  802fa1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fa6:	eb 33                	jmp    802fdb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fac:	48 89 c6             	mov    %rax,%rsi
  802faf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fb6:	00 00 00 
  802fb9:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fc5:	be 00 00 00 00       	mov    $0x0,%esi
  802fca:	bf 07 00 00 00       	mov    $0x7,%edi
  802fcf:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802fd6:	00 00 00 
  802fd9:	ff d0                	callq  *%rax
}
  802fdb:	c9                   	leaveq 
  802fdc:	c3                   	retq   

0000000000802fdd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802fdd:	55                   	push   %rbp
  802fde:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802fe1:	be 00 00 00 00       	mov    $0x0,%esi
  802fe6:	bf 08 00 00 00       	mov    $0x8,%edi
  802feb:	48 b8 37 2b 80 00 00 	movabs $0x802b37,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
}
  802ff7:	5d                   	pop    %rbp
  802ff8:	c3                   	retq   

0000000000802ff9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ff9:	55                   	push   %rbp
  802ffa:	48 89 e5             	mov    %rsp,%rbp
  802ffd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803004:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80300b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803012:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803019:	be 00 00 00 00       	mov    $0x0,%esi
  80301e:	48 89 c7             	mov    %rax,%rdi
  803021:	48 b8 be 2b 80 00 00 	movabs $0x802bbe,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
  80302d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803030:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803034:	79 28                	jns    80305e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803039:	89 c6                	mov    %eax,%esi
  80303b:	48 bf 9a 4e 80 00 00 	movabs $0x804e9a,%rdi
  803042:	00 00 00 
  803045:	b8 00 00 00 00       	mov    $0x0,%eax
  80304a:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  803051:	00 00 00 
  803054:	ff d2                	callq  *%rdx
		return fd_src;
  803056:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803059:	e9 74 01 00 00       	jmpq   8031d2 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80305e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803065:	be 01 01 00 00       	mov    $0x101,%esi
  80306a:	48 89 c7             	mov    %rax,%rdi
  80306d:	48 b8 be 2b 80 00 00 	movabs $0x802bbe,%rax
  803074:	00 00 00 
  803077:	ff d0                	callq  *%rax
  803079:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80307c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803080:	79 39                	jns    8030bb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803082:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803085:	89 c6                	mov    %eax,%esi
  803087:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  80308e:	00 00 00 
  803091:	b8 00 00 00 00       	mov    $0x0,%eax
  803096:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  80309d:	00 00 00 
  8030a0:	ff d2                	callq  *%rdx
		close(fd_src);
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	89 c7                	mov    %eax,%edi
  8030a7:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
		return fd_dest;
  8030b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b6:	e9 17 01 00 00       	jmpq   8031d2 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030bb:	eb 74                	jmp    803131 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030c0:	48 63 d0             	movslq %eax,%rdx
  8030c3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030cd:	48 89 ce             	mov    %rcx,%rsi
  8030d0:	89 c7                	mov    %eax,%edi
  8030d2:	48 b8 32 28 80 00 00 	movabs $0x802832,%rax
  8030d9:	00 00 00 
  8030dc:	ff d0                	callq  *%rax
  8030de:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8030e5:	79 4a                	jns    803131 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8030e7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030ea:	89 c6                	mov    %eax,%esi
  8030ec:	48 bf ca 4e 80 00 00 	movabs $0x804eca,%rdi
  8030f3:	00 00 00 
  8030f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fb:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  803102:	00 00 00 
  803105:	ff d2                	callq  *%rdx
			close(fd_src);
  803107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310a:	89 c7                	mov    %eax,%edi
  80310c:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  803113:	00 00 00 
  803116:	ff d0                	callq  *%rax
			close(fd_dest);
  803118:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80311b:	89 c7                	mov    %eax,%edi
  80311d:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  803124:	00 00 00 
  803127:	ff d0                	callq  *%rax
			return write_size;
  803129:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80312c:	e9 a1 00 00 00       	jmpq   8031d2 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803131:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313b:	ba 00 02 00 00       	mov    $0x200,%edx
  803140:	48 89 ce             	mov    %rcx,%rsi
  803143:	89 c7                	mov    %eax,%edi
  803145:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	callq  *%rax
  803151:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803154:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803158:	0f 8f 5f ff ff ff    	jg     8030bd <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80315e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803162:	79 47                	jns    8031ab <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803164:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803167:	89 c6                	mov    %eax,%esi
  803169:	48 bf dd 4e 80 00 00 	movabs $0x804edd,%rdi
  803170:	00 00 00 
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  80317f:	00 00 00 
  803182:	ff d2                	callq  *%rdx
		close(fd_src);
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803187:	89 c7                	mov    %eax,%edi
  803189:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
		close(fd_dest);
  803195:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803198:	89 c7                	mov    %eax,%edi
  80319a:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
		return read_size;
  8031a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031a9:	eb 27                	jmp    8031d2 <copy+0x1d9>
	}
	close(fd_src);
  8031ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ae:	89 c7                	mov    %eax,%edi
  8031b0:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
	close(fd_dest);
  8031bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031bf:	89 c7                	mov    %eax,%edi
  8031c1:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
	return 0;
  8031cd:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031d2:	c9                   	leaveq 
  8031d3:	c3                   	retq   

00000000008031d4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	48 83 ec 20          	sub    $0x20,%rsp
  8031dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e6:	48 89 d6             	mov    %rdx,%rsi
  8031e9:	89 c7                	mov    %eax,%edi
  8031eb:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
  8031f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fe:	79 05                	jns    803205 <fd2sockid+0x31>
		return r;
  803200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803203:	eb 24                	jmp    803229 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803209:	8b 10                	mov    (%rax),%edx
  80320b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803212:	00 00 00 
  803215:	8b 00                	mov    (%rax),%eax
  803217:	39 c2                	cmp    %eax,%edx
  803219:	74 07                	je     803222 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80321b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803220:	eb 07                	jmp    803229 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803226:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803229:	c9                   	leaveq 
  80322a:	c3                   	retq   

000000000080322b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80322b:	55                   	push   %rbp
  80322c:	48 89 e5             	mov    %rsp,%rbp
  80322f:	48 83 ec 20          	sub    $0x20,%rsp
  803233:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803236:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803250:	78 26                	js     803278 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803256:	ba 07 04 00 00       	mov    $0x407,%edx
  80325b:	48 89 c6             	mov    %rax,%rsi
  80325e:	bf 00 00 00 00       	mov    $0x0,%edi
  803263:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
  80326f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803272:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803276:	79 16                	jns    80328e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803278:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327b:	89 c7                	mov    %eax,%edi
  80327d:	48 b8 38 37 80 00 00 	movabs $0x803738,%rax
  803284:	00 00 00 
  803287:	ff d0                	callq  *%rax
		return r;
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	eb 3a                	jmp    8032c8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803299:	00 00 00 
  80329c:	8b 12                	mov    (%rdx),%edx
  80329e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032af:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
}
  8032c8:	c9                   	leaveq 
  8032c9:	c3                   	retq   

00000000008032ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032ca:	55                   	push   %rbp
  8032cb:	48 89 e5             	mov    %rsp,%rbp
  8032ce:	48 83 ec 30          	sub    $0x30,%rsp
  8032d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e0:	89 c7                	mov    %eax,%edi
  8032e2:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
  8032ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f5:	79 05                	jns    8032fc <accept+0x32>
		return r;
  8032f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fa:	eb 3b                	jmp    803337 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8032fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803300:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803307:	48 89 ce             	mov    %rcx,%rsi
  80330a:	89 c7                	mov    %eax,%edi
  80330c:	48 b8 15 36 80 00 00 	movabs $0x803615,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331f:	79 05                	jns    803326 <accept+0x5c>
		return r;
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	eb 11                	jmp    803337 <accept+0x6d>
	return alloc_sockfd(r);
  803326:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803329:	89 c7                	mov    %eax,%edi
  80332b:	48 b8 2b 32 80 00 00 	movabs $0x80322b,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
}
  803337:	c9                   	leaveq 
  803338:	c3                   	retq   

0000000000803339 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803339:	55                   	push   %rbp
  80333a:	48 89 e5             	mov    %rsp,%rbp
  80333d:	48 83 ec 20          	sub    $0x20,%rsp
  803341:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803344:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803348:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80334b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80334e:	89 c7                	mov    %eax,%edi
  803350:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803363:	79 05                	jns    80336a <bind+0x31>
		return r;
  803365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803368:	eb 1b                	jmp    803385 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80336a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80336d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803374:	48 89 ce             	mov    %rcx,%rsi
  803377:	89 c7                	mov    %eax,%edi
  803379:	48 b8 94 36 80 00 00 	movabs $0x803694,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
}
  803385:	c9                   	leaveq 
  803386:	c3                   	retq   

0000000000803387 <shutdown>:

int
shutdown(int s, int how)
{
  803387:	55                   	push   %rbp
  803388:	48 89 e5             	mov    %rsp,%rbp
  80338b:	48 83 ec 20          	sub    $0x20,%rsp
  80338f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803392:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803395:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803398:	89 c7                	mov    %eax,%edi
  80339a:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax
  8033a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ad:	79 05                	jns    8033b4 <shutdown+0x2d>
		return r;
  8033af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b2:	eb 16                	jmp    8033ca <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ba:	89 d6                	mov    %edx,%esi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	48 83 ec 10          	sub    $0x10,%rsp
  8033d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033dc:	48 89 c7             	mov    %rax,%rdi
  8033df:	48 b8 9a 46 80 00 00 	movabs $0x80469a,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
  8033eb:	83 f8 01             	cmp    $0x1,%eax
  8033ee:	75 17                	jne    803407 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8033f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8033f7:	89 c7                	mov    %eax,%edi
  8033f9:	48 b8 38 37 80 00 00 	movabs $0x803738,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
  803405:	eb 05                	jmp    80340c <devsock_close+0x40>
	else
		return 0;
  803407:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80340c:	c9                   	leaveq 
  80340d:	c3                   	retq   

000000000080340e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80340e:	55                   	push   %rbp
  80340f:	48 89 e5             	mov    %rsp,%rbp
  803412:	48 83 ec 20          	sub    $0x20,%rsp
  803416:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803419:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80341d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803420:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803423:	89 c7                	mov    %eax,%edi
  803425:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  80342c:	00 00 00 
  80342f:	ff d0                	callq  *%rax
  803431:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803434:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803438:	79 05                	jns    80343f <connect+0x31>
		return r;
  80343a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343d:	eb 1b                	jmp    80345a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80343f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803442:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803446:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803449:	48 89 ce             	mov    %rcx,%rsi
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 65 37 80 00 00 	movabs $0x803765,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
}
  80345a:	c9                   	leaveq 
  80345b:	c3                   	retq   

000000000080345c <listen>:

int
listen(int s, int backlog)
{
  80345c:	55                   	push   %rbp
  80345d:	48 89 e5             	mov    %rsp,%rbp
  803460:	48 83 ec 20          	sub    $0x20,%rsp
  803464:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803467:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80346a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80346d:	89 c7                	mov    %eax,%edi
  80346f:	48 b8 d4 31 80 00 00 	movabs $0x8031d4,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 05                	jns    803489 <listen+0x2d>
		return r;
  803484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803487:	eb 16                	jmp    80349f <listen+0x43>
	return nsipc_listen(r, backlog);
  803489:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80348c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348f:	89 d6                	mov    %edx,%esi
  803491:	89 c7                	mov    %eax,%edi
  803493:	48 b8 c9 37 80 00 00 	movabs $0x8037c9,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 20          	sub    $0x20,%rsp
  8034a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b9:	89 c2                	mov    %eax,%edx
  8034bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bf:	8b 40 0c             	mov    0xc(%rax),%eax
  8034c2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 09 38 80 00 00 	movabs $0x803809,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 20          	sub    $0x20,%rsp
  8034e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f3:	89 c2                	mov    %eax,%edx
  8034f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f9:	8b 40 0c             	mov    0xc(%rax),%eax
  8034fc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803500:	b9 00 00 00 00       	mov    $0x0,%ecx
  803505:	89 c7                	mov    %eax,%edi
  803507:	48 b8 d5 38 80 00 00 	movabs $0x8038d5,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 10          	sub    $0x10,%rsp
  80351d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803521:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803529:	48 be f8 4e 80 00 00 	movabs $0x804ef8,%rsi
  803530:	00 00 00 
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
	return 0;
  803542:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803547:	c9                   	leaveq 
  803548:	c3                   	retq   

0000000000803549 <socket>:

int
socket(int domain, int type, int protocol)
{
  803549:	55                   	push   %rbp
  80354a:	48 89 e5             	mov    %rsp,%rbp
  80354d:	48 83 ec 20          	sub    $0x20,%rsp
  803551:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803554:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803557:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80355a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80355d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803563:	89 ce                	mov    %ecx,%esi
  803565:	89 c7                	mov    %eax,%edi
  803567:	48 b8 8d 39 80 00 00 	movabs $0x80398d,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357a:	79 05                	jns    803581 <socket+0x38>
		return r;
  80357c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357f:	eb 11                	jmp    803592 <socket+0x49>
	return alloc_sockfd(r);
  803581:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803584:	89 c7                	mov    %eax,%edi
  803586:	48 b8 2b 32 80 00 00 	movabs $0x80322b,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
}
  803592:	c9                   	leaveq 
  803593:	c3                   	retq   

0000000000803594 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 10          	sub    $0x10,%rsp
  80359c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80359f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035a6:	00 00 00 
  8035a9:	8b 00                	mov    (%rax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	75 1d                	jne    8035cc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035af:	bf 02 00 00 00       	mov    $0x2,%edi
  8035b4:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  8035bb:	00 00 00 
  8035be:	ff d0                	callq  *%rax
  8035c0:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8035c7:	00 00 00 
  8035ca:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035cc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035d3:	00 00 00 
  8035d6:	8b 00                	mov    (%rax),%eax
  8035d8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035e0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8035e7:	00 00 00 
  8035ea:	89 c7                	mov    %eax,%edi
  8035ec:	48 b8 b6 45 80 00 00 	movabs $0x8045b6,%rax
  8035f3:	00 00 00 
  8035f6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8035f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8035fd:	be 00 00 00 00       	mov    $0x0,%esi
  803602:	bf 00 00 00 00       	mov    $0x0,%edi
  803607:	48 b8 b0 44 80 00 00 	movabs $0x8044b0,%rax
  80360e:	00 00 00 
  803611:	ff d0                	callq  *%rax
}
  803613:	c9                   	leaveq 
  803614:	c3                   	retq   

0000000000803615 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803615:	55                   	push   %rbp
  803616:	48 89 e5             	mov    %rsp,%rbp
  803619:	48 83 ec 30          	sub    $0x30,%rsp
  80361d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803624:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803628:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80362f:	00 00 00 
  803632:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803635:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803637:	bf 01 00 00 00       	mov    $0x1,%edi
  80363c:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364f:	78 3e                	js     80368f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803651:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803658:	00 00 00 
  80365b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80365f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803663:	8b 40 10             	mov    0x10(%rax),%eax
  803666:	89 c2                	mov    %eax,%edx
  803668:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80366c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803670:	48 89 ce             	mov    %rcx,%rsi
  803673:	48 89 c7             	mov    %rax,%rdi
  803676:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  80367d:	00 00 00 
  803680:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803686:	8b 50 10             	mov    0x10(%rax),%edx
  803689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80368f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803692:	c9                   	leaveq 
  803693:	c3                   	retq   

0000000000803694 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803694:	55                   	push   %rbp
  803695:	48 89 e5             	mov    %rsp,%rbp
  803698:	48 83 ec 10          	sub    $0x10,%rsp
  80369c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80369f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036a3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ad:	00 00 00 
  8036b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036b3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bc:	48 89 c6             	mov    %rax,%rsi
  8036bf:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036c6:	00 00 00 
  8036c9:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036dc:	00 00 00 
  8036df:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036e2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8036e5:	bf 02 00 00 00       	mov    $0x2,%edi
  8036ea:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
}
  8036f6:	c9                   	leaveq 
  8036f7:	c3                   	retq   

00000000008036f8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036f8:	55                   	push   %rbp
  8036f9:	48 89 e5             	mov    %rsp,%rbp
  8036fc:	48 83 ec 10          	sub    $0x10,%rsp
  803700:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803703:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803706:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370d:	00 00 00 
  803710:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803713:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803715:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371c:	00 00 00 
  80371f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803722:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803725:	bf 03 00 00 00       	mov    $0x3,%edi
  80372a:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
}
  803736:	c9                   	leaveq 
  803737:	c3                   	retq   

0000000000803738 <nsipc_close>:

int
nsipc_close(int s)
{
  803738:	55                   	push   %rbp
  803739:	48 89 e5             	mov    %rsp,%rbp
  80373c:	48 83 ec 10          	sub    $0x10,%rsp
  803740:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803743:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374a:	00 00 00 
  80374d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803750:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803752:	bf 04 00 00 00       	mov    $0x4,%edi
  803757:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  80375e:	00 00 00 
  803761:	ff d0                	callq  *%rax
}
  803763:	c9                   	leaveq 
  803764:	c3                   	retq   

0000000000803765 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803765:	55                   	push   %rbp
  803766:	48 89 e5             	mov    %rsp,%rbp
  803769:	48 83 ec 10          	sub    $0x10,%rsp
  80376d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803770:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803774:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803777:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80377e:	00 00 00 
  803781:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803784:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803786:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378d:	48 89 c6             	mov    %rax,%rsi
  803790:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803797:	00 00 00 
  80379a:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ad:	00 00 00 
  8037b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037b3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8037bb:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
}
  8037c7:	c9                   	leaveq 
  8037c8:	c3                   	retq   

00000000008037c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037c9:	55                   	push   %rbp
  8037ca:	48 89 e5             	mov    %rsp,%rbp
  8037cd:	48 83 ec 10          	sub    $0x10,%rsp
  8037d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037d7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037de:	00 00 00 
  8037e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8037e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ed:	00 00 00 
  8037f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8037f6:	bf 06 00 00 00       	mov    $0x6,%edi
  8037fb:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803802:	00 00 00 
  803805:	ff d0                	callq  *%rax
}
  803807:	c9                   	leaveq 
  803808:	c3                   	retq   

0000000000803809 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803809:	55                   	push   %rbp
  80380a:	48 89 e5             	mov    %rsp,%rbp
  80380d:	48 83 ec 30          	sub    $0x30,%rsp
  803811:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803818:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80381b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80381e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803825:	00 00 00 
  803828:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80382b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80382d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803834:	00 00 00 
  803837:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80383a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80383d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803844:	00 00 00 
  803847:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80384a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80384d:	bf 07 00 00 00       	mov    $0x7,%edi
  803852:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803859:	00 00 00 
  80385c:	ff d0                	callq  *%rax
  80385e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803861:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803865:	78 69                	js     8038d0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803867:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80386e:	7f 08                	jg     803878 <nsipc_recv+0x6f>
  803870:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803873:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803876:	7e 35                	jle    8038ad <nsipc_recv+0xa4>
  803878:	48 b9 ff 4e 80 00 00 	movabs $0x804eff,%rcx
  80387f:	00 00 00 
  803882:	48 ba 14 4f 80 00 00 	movabs $0x804f14,%rdx
  803889:	00 00 00 
  80388c:	be 61 00 00 00       	mov    $0x61,%esi
  803891:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  803898:	00 00 00 
  80389b:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a0:	49 b8 5c 42 80 00 00 	movabs $0x80425c,%r8
  8038a7:	00 00 00 
  8038aa:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b0:	48 63 d0             	movslq %eax,%rdx
  8038b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038b7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038be:	00 00 00 
  8038c1:	48 89 c7             	mov    %rax,%rdi
  8038c4:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8038cb:	00 00 00 
  8038ce:	ff d0                	callq  *%rax
	}

	return r;
  8038d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038d3:	c9                   	leaveq 
  8038d4:	c3                   	retq   

00000000008038d5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038d5:	55                   	push   %rbp
  8038d6:	48 89 e5             	mov    %rsp,%rbp
  8038d9:	48 83 ec 20          	sub    $0x20,%rsp
  8038dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8038e7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8038ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f1:	00 00 00 
  8038f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8038f9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803900:	7e 35                	jle    803937 <nsipc_send+0x62>
  803902:	48 b9 35 4f 80 00 00 	movabs $0x804f35,%rcx
  803909:	00 00 00 
  80390c:	48 ba 14 4f 80 00 00 	movabs $0x804f14,%rdx
  803913:	00 00 00 
  803916:	be 6c 00 00 00       	mov    $0x6c,%esi
  80391b:	48 bf 29 4f 80 00 00 	movabs $0x804f29,%rdi
  803922:	00 00 00 
  803925:	b8 00 00 00 00       	mov    $0x0,%eax
  80392a:	49 b8 5c 42 80 00 00 	movabs $0x80425c,%r8
  803931:	00 00 00 
  803934:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803937:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80393a:	48 63 d0             	movslq %eax,%rdx
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	48 89 c6             	mov    %rax,%rsi
  803944:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80394b:	00 00 00 
  80394e:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80395a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803961:	00 00 00 
  803964:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803967:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80396a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803971:	00 00 00 
  803974:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803977:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80397a:	bf 08 00 00 00       	mov    $0x8,%edi
  80397f:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  803986:	00 00 00 
  803989:	ff d0                	callq  *%rax
}
  80398b:	c9                   	leaveq 
  80398c:	c3                   	retq   

000000000080398d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80398d:	55                   	push   %rbp
  80398e:	48 89 e5             	mov    %rsp,%rbp
  803991:	48 83 ec 10          	sub    $0x10,%rsp
  803995:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803998:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80399b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80399e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a5:	00 00 00 
  8039a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b4:	00 00 00 
  8039b7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c4:	00 00 00 
  8039c7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039ca:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039cd:	bf 09 00 00 00       	mov    $0x9,%edi
  8039d2:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
}
  8039de:	c9                   	leaveq 
  8039df:	c3                   	retq   

00000000008039e0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039e0:	55                   	push   %rbp
  8039e1:	48 89 e5             	mov    %rsp,%rbp
  8039e4:	53                   	push   %rbx
  8039e5:	48 83 ec 38          	sub    $0x38,%rsp
  8039e9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039ed:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039f1:	48 89 c7             	mov    %rax,%rdi
  8039f4:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a07:	0f 88 bf 01 00 00    	js     803bcc <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a11:	ba 07 04 00 00       	mov    $0x407,%edx
  803a16:	48 89 c6             	mov    %rax,%rsi
  803a19:	bf 00 00 00 00       	mov    $0x0,%edi
  803a1e:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803a25:	00 00 00 
  803a28:	ff d0                	callq  *%rax
  803a2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a31:	0f 88 95 01 00 00    	js     803bcc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a37:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a3b:	48 89 c7             	mov    %rax,%rdi
  803a3e:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a51:	0f 88 5d 01 00 00    	js     803bb4 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a5b:	ba 07 04 00 00       	mov    $0x407,%edx
  803a60:	48 89 c6             	mov    %rax,%rsi
  803a63:	bf 00 00 00 00       	mov    $0x0,%edi
  803a68:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803a6f:	00 00 00 
  803a72:	ff d0                	callq  *%rax
  803a74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7b:	0f 88 33 01 00 00    	js     803bb4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a85:	48 89 c7             	mov    %rax,%rdi
  803a88:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
  803a94:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9c:	ba 07 04 00 00       	mov    $0x407,%edx
  803aa1:	48 89 c6             	mov    %rax,%rsi
  803aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa9:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
  803ab5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abc:	79 05                	jns    803ac3 <pipe+0xe3>
		goto err2;
  803abe:	e9 d9 00 00 00       	jmpq   803b9c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ac3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac7:	48 89 c7             	mov    %rax,%rdi
  803aca:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803ad1:	00 00 00 
  803ad4:	ff d0                	callq  *%rax
  803ad6:	48 89 c2             	mov    %rax,%rdx
  803ad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803add:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ae3:	48 89 d1             	mov    %rdx,%rcx
  803ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  803aeb:	48 89 c6             	mov    %rax,%rsi
  803aee:	bf 00 00 00 00       	mov    $0x0,%edi
  803af3:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
  803aff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b02:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b06:	79 1b                	jns    803b23 <pipe+0x143>
		goto err3;
  803b08:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b0d:	48 89 c6             	mov    %rax,%rsi
  803b10:	bf 00 00 00 00       	mov    $0x0,%edi
  803b15:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	eb 79                	jmp    803b9c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b27:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b2e:	00 00 00 
  803b31:	8b 12                	mov    (%rdx),%edx
  803b33:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b44:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4b:	00 00 00 
  803b4e:	8b 12                	mov    (%rdx),%edx
  803b50:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b56:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b61:	48 89 c7             	mov    %rax,%rdi
  803b64:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  803b6b:	00 00 00 
  803b6e:	ff d0                	callq  *%rax
  803b70:	89 c2                	mov    %eax,%edx
  803b72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b76:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b7c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b84:	48 89 c7             	mov    %rax,%rdi
  803b87:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
  803b93:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b95:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9a:	eb 33                	jmp    803bcf <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba0:	48 89 c6             	mov    %rax,%rsi
  803ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba8:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb8:	48 89 c6             	mov    %rax,%rsi
  803bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc0:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803bc7:	00 00 00 
  803bca:	ff d0                	callq  *%rax
err:
	return r;
  803bcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bcf:	48 83 c4 38          	add    $0x38,%rsp
  803bd3:	5b                   	pop    %rbx
  803bd4:	5d                   	pop    %rbp
  803bd5:	c3                   	retq   

0000000000803bd6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bd6:	55                   	push   %rbp
  803bd7:	48 89 e5             	mov    %rsp,%rbp
  803bda:	53                   	push   %rbx
  803bdb:	48 83 ec 28          	sub    $0x28,%rsp
  803bdf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803be3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803be7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bee:	00 00 00 
  803bf1:	48 8b 00             	mov    (%rax),%rax
  803bf4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bfa:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c01:	48 89 c7             	mov    %rax,%rdi
  803c04:	48 b8 9a 46 80 00 00 	movabs $0x80469a,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
  803c10:	89 c3                	mov    %eax,%ebx
  803c12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c16:	48 89 c7             	mov    %rax,%rdi
  803c19:	48 b8 9a 46 80 00 00 	movabs $0x80469a,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
  803c25:	39 c3                	cmp    %eax,%ebx
  803c27:	0f 94 c0             	sete   %al
  803c2a:	0f b6 c0             	movzbl %al,%eax
  803c2d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c30:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c37:	00 00 00 
  803c3a:	48 8b 00             	mov    (%rax),%rax
  803c3d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c43:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c49:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c4c:	75 05                	jne    803c53 <_pipeisclosed+0x7d>
			return ret;
  803c4e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c51:	eb 4f                	jmp    803ca2 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c56:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c59:	74 42                	je     803c9d <_pipeisclosed+0xc7>
  803c5b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c5f:	75 3c                	jne    803c9d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c61:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c68:	00 00 00 
  803c6b:	48 8b 00             	mov    (%rax),%rax
  803c6e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c74:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7a:	89 c6                	mov    %eax,%esi
  803c7c:	48 bf 46 4f 80 00 00 	movabs $0x804f46,%rdi
  803c83:	00 00 00 
  803c86:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8b:	49 b8 1b 03 80 00 00 	movabs $0x80031b,%r8
  803c92:	00 00 00 
  803c95:	41 ff d0             	callq  *%r8
	}
  803c98:	e9 4a ff ff ff       	jmpq   803be7 <_pipeisclosed+0x11>
  803c9d:	e9 45 ff ff ff       	jmpq   803be7 <_pipeisclosed+0x11>
}
  803ca2:	48 83 c4 28          	add    $0x28,%rsp
  803ca6:	5b                   	pop    %rbx
  803ca7:	5d                   	pop    %rbp
  803ca8:	c3                   	retq   

0000000000803ca9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ca9:	55                   	push   %rbp
  803caa:	48 89 e5             	mov    %rsp,%rbp
  803cad:	48 83 ec 30          	sub    $0x30,%rsp
  803cb1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cb4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cb8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cbb:	48 89 d6             	mov    %rdx,%rsi
  803cbe:	89 c7                	mov    %eax,%edi
  803cc0:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
  803ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd3:	79 05                	jns    803cda <pipeisclosed+0x31>
		return r;
  803cd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd8:	eb 31                	jmp    803d0b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cde:	48 89 c7             	mov    %rax,%rdi
  803ce1:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
  803ced:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cf9:	48 89 d6             	mov    %rdx,%rsi
  803cfc:	48 89 c7             	mov    %rax,%rdi
  803cff:	48 b8 d6 3b 80 00 00 	movabs $0x803bd6,%rax
  803d06:	00 00 00 
  803d09:	ff d0                	callq  *%rax
}
  803d0b:	c9                   	leaveq 
  803d0c:	c3                   	retq   

0000000000803d0d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d0d:	55                   	push   %rbp
  803d0e:	48 89 e5             	mov    %rsp,%rbp
  803d11:	48 83 ec 40          	sub    $0x40,%rsp
  803d15:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d19:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d1d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d25:	48 89 c7             	mov    %rax,%rdi
  803d28:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
  803d34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d40:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d47:	00 
  803d48:	e9 92 00 00 00       	jmpq   803ddf <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d4d:	eb 41                	jmp    803d90 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d4f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d54:	74 09                	je     803d5f <devpipe_read+0x52>
				return i;
  803d56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d5a:	e9 92 00 00 00       	jmpq   803df1 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d67:	48 89 d6             	mov    %rdx,%rsi
  803d6a:	48 89 c7             	mov    %rax,%rdi
  803d6d:	48 b8 d6 3b 80 00 00 	movabs $0x803bd6,%rax
  803d74:	00 00 00 
  803d77:	ff d0                	callq  *%rax
  803d79:	85 c0                	test   %eax,%eax
  803d7b:	74 07                	je     803d84 <devpipe_read+0x77>
				return 0;
  803d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d82:	eb 6d                	jmp    803df1 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d84:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d94:	8b 10                	mov    (%rax),%edx
  803d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d9a:	8b 40 04             	mov    0x4(%rax),%eax
  803d9d:	39 c2                	cmp    %eax,%edx
  803d9f:	74 ae                	je     803d4f <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803da9:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db1:	8b 00                	mov    (%rax),%eax
  803db3:	99                   	cltd   
  803db4:	c1 ea 1b             	shr    $0x1b,%edx
  803db7:	01 d0                	add    %edx,%eax
  803db9:	83 e0 1f             	and    $0x1f,%eax
  803dbc:	29 d0                	sub    %edx,%eax
  803dbe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dc2:	48 98                	cltq   
  803dc4:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803dc9:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcf:	8b 00                	mov    (%rax),%eax
  803dd1:	8d 50 01             	lea    0x1(%rax),%edx
  803dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd8:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dda:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ddf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803de7:	0f 82 60 ff ff ff    	jb     803d4d <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ded:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803df1:	c9                   	leaveq 
  803df2:	c3                   	retq   

0000000000803df3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803df3:	55                   	push   %rbp
  803df4:	48 89 e5             	mov    %rsp,%rbp
  803df7:	48 83 ec 40          	sub    $0x40,%rsp
  803dfb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e03:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e0b:	48 89 c7             	mov    %rax,%rdi
  803e0e:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803e15:	00 00 00 
  803e18:	ff d0                	callq  *%rax
  803e1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e26:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e2d:	00 
  803e2e:	e9 8e 00 00 00       	jmpq   803ec1 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e33:	eb 31                	jmp    803e66 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3d:	48 89 d6             	mov    %rdx,%rsi
  803e40:	48 89 c7             	mov    %rax,%rdi
  803e43:	48 b8 d6 3b 80 00 00 	movabs $0x803bd6,%rax
  803e4a:	00 00 00 
  803e4d:	ff d0                	callq  *%rax
  803e4f:	85 c0                	test   %eax,%eax
  803e51:	74 07                	je     803e5a <devpipe_write+0x67>
				return 0;
  803e53:	b8 00 00 00 00       	mov    $0x0,%eax
  803e58:	eb 79                	jmp    803ed3 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e5a:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  803e61:	00 00 00 
  803e64:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6a:	8b 40 04             	mov    0x4(%rax),%eax
  803e6d:	48 63 d0             	movslq %eax,%rdx
  803e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e74:	8b 00                	mov    (%rax),%eax
  803e76:	48 98                	cltq   
  803e78:	48 83 c0 20          	add    $0x20,%rax
  803e7c:	48 39 c2             	cmp    %rax,%rdx
  803e7f:	73 b4                	jae    803e35 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e85:	8b 40 04             	mov    0x4(%rax),%eax
  803e88:	99                   	cltd   
  803e89:	c1 ea 1b             	shr    $0x1b,%edx
  803e8c:	01 d0                	add    %edx,%eax
  803e8e:	83 e0 1f             	and    $0x1f,%eax
  803e91:	29 d0                	sub    %edx,%eax
  803e93:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e97:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e9b:	48 01 ca             	add    %rcx,%rdx
  803e9e:	0f b6 0a             	movzbl (%rdx),%ecx
  803ea1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea5:	48 98                	cltq   
  803ea7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eaf:	8b 40 04             	mov    0x4(%rax),%eax
  803eb2:	8d 50 01             	lea    0x1(%rax),%edx
  803eb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb9:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ebc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ec9:	0f 82 64 ff ff ff    	jb     803e33 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ed3:	c9                   	leaveq 
  803ed4:	c3                   	retq   

0000000000803ed5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ed5:	55                   	push   %rbp
  803ed6:	48 89 e5             	mov    %rsp,%rbp
  803ed9:	48 83 ec 20          	sub    $0x20,%rsp
  803edd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ee1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee9:	48 89 c7             	mov    %rax,%rdi
  803eec:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
  803ef8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803efc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f00:	48 be 59 4f 80 00 00 	movabs $0x804f59,%rsi
  803f07:	00 00 00 
  803f0a:	48 89 c7             	mov    %rax,%rdi
  803f0d:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f1d:	8b 50 04             	mov    0x4(%rax),%edx
  803f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f24:	8b 00                	mov    (%rax),%eax
  803f26:	29 c2                	sub    %eax,%edx
  803f28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f2c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f36:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f3d:	00 00 00 
	stat->st_dev = &devpipe;
  803f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f44:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f4b:	00 00 00 
  803f4e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f5a:	c9                   	leaveq 
  803f5b:	c3                   	retq   

0000000000803f5c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f5c:	55                   	push   %rbp
  803f5d:	48 89 e5             	mov    %rsp,%rbp
  803f60:	48 83 ec 10          	sub    $0x10,%rsp
  803f64:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f6c:	48 89 c6             	mov    %rax,%rsi
  803f6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f74:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803f7b:	00 00 00 
  803f7e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f84:	48 89 c7             	mov    %rax,%rdi
  803f87:	48 b8 f3 21 80 00 00 	movabs $0x8021f3,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
  803f93:	48 89 c6             	mov    %rax,%rsi
  803f96:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9b:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803fa2:	00 00 00 
  803fa5:	ff d0                	callq  *%rax
}
  803fa7:	c9                   	leaveq 
  803fa8:	c3                   	retq   

0000000000803fa9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fa9:	55                   	push   %rbp
  803faa:	48 89 e5             	mov    %rsp,%rbp
  803fad:	48 83 ec 20          	sub    $0x20,%rsp
  803fb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fba:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803fbe:	be 01 00 00 00       	mov    $0x1,%esi
  803fc3:	48 89 c7             	mov    %rax,%rdi
  803fc6:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  803fcd:	00 00 00 
  803fd0:	ff d0                	callq  *%rax
}
  803fd2:	c9                   	leaveq 
  803fd3:	c3                   	retq   

0000000000803fd4 <getchar>:

int
getchar(void)
{
  803fd4:	55                   	push   %rbp
  803fd5:	48 89 e5             	mov    %rsp,%rbp
  803fd8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fdc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fe0:	ba 01 00 00 00       	mov    $0x1,%edx
  803fe5:	48 89 c6             	mov    %rax,%rsi
  803fe8:	bf 00 00 00 00       	mov    $0x0,%edi
  803fed:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
  803ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ffc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804000:	79 05                	jns    804007 <getchar+0x33>
		return r;
  804002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804005:	eb 14                	jmp    80401b <getchar+0x47>
	if (r < 1)
  804007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400b:	7f 07                	jg     804014 <getchar+0x40>
		return -E_EOF;
  80400d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804012:	eb 07                	jmp    80401b <getchar+0x47>
	return c;
  804014:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804018:	0f b6 c0             	movzbl %al,%eax
}
  80401b:	c9                   	leaveq 
  80401c:	c3                   	retq   

000000000080401d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80401d:	55                   	push   %rbp
  80401e:	48 89 e5             	mov    %rsp,%rbp
  804021:	48 83 ec 20          	sub    $0x20,%rsp
  804025:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804028:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80402c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402f:	48 89 d6             	mov    %rdx,%rsi
  804032:	89 c7                	mov    %eax,%edi
  804034:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  80403b:	00 00 00 
  80403e:	ff d0                	callq  *%rax
  804040:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804043:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804047:	79 05                	jns    80404e <iscons+0x31>
		return r;
  804049:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80404c:	eb 1a                	jmp    804068 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80404e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804052:	8b 10                	mov    (%rax),%edx
  804054:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80405b:	00 00 00 
  80405e:	8b 00                	mov    (%rax),%eax
  804060:	39 c2                	cmp    %eax,%edx
  804062:	0f 94 c0             	sete   %al
  804065:	0f b6 c0             	movzbl %al,%eax
}
  804068:	c9                   	leaveq 
  804069:	c3                   	retq   

000000000080406a <opencons>:

int
opencons(void)
{
  80406a:	55                   	push   %rbp
  80406b:	48 89 e5             	mov    %rsp,%rbp
  80406e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804072:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804076:	48 89 c7             	mov    %rax,%rdi
  804079:	48 b8 1e 22 80 00 00 	movabs $0x80221e,%rax
  804080:	00 00 00 
  804083:	ff d0                	callq  *%rax
  804085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80408c:	79 05                	jns    804093 <opencons+0x29>
		return r;
  80408e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804091:	eb 5b                	jmp    8040ee <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804097:	ba 07 04 00 00       	mov    $0x407,%edx
  80409c:	48 89 c6             	mov    %rax,%rsi
  80409f:	bf 00 00 00 00       	mov    $0x0,%edi
  8040a4:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8040ab:	00 00 00 
  8040ae:	ff d0                	callq  *%rax
  8040b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040b7:	79 05                	jns    8040be <opencons+0x54>
		return r;
  8040b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bc:	eb 30                	jmp    8040ee <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c2:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040c9:	00 00 00 
  8040cc:	8b 12                	mov    (%rdx),%edx
  8040ce:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040d4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040df:	48 89 c7             	mov    %rax,%rdi
  8040e2:	48 b8 d0 21 80 00 00 	movabs $0x8021d0,%rax
  8040e9:	00 00 00 
  8040ec:	ff d0                	callq  *%rax
}
  8040ee:	c9                   	leaveq 
  8040ef:	c3                   	retq   

00000000008040f0 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040f0:	55                   	push   %rbp
  8040f1:	48 89 e5             	mov    %rsp,%rbp
  8040f4:	48 83 ec 30          	sub    $0x30,%rsp
  8040f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804100:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804104:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804109:	75 07                	jne    804112 <devcons_read+0x22>
		return 0;
  80410b:	b8 00 00 00 00       	mov    $0x0,%eax
  804110:	eb 4b                	jmp    80415d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804112:	eb 0c                	jmp    804120 <devcons_read+0x30>
		sys_yield();
  804114:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  80411b:	00 00 00 
  80411e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804120:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  804127:	00 00 00 
  80412a:	ff d0                	callq  *%rax
  80412c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80412f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804133:	74 df                	je     804114 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804135:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804139:	79 05                	jns    804140 <devcons_read+0x50>
		return c;
  80413b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413e:	eb 1d                	jmp    80415d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804140:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804144:	75 07                	jne    80414d <devcons_read+0x5d>
		return 0;
  804146:	b8 00 00 00 00       	mov    $0x0,%eax
  80414b:	eb 10                	jmp    80415d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80414d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804150:	89 c2                	mov    %eax,%edx
  804152:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804156:	88 10                	mov    %dl,(%rax)
	return 1;
  804158:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80415d:	c9                   	leaveq 
  80415e:	c3                   	retq   

000000000080415f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80415f:	55                   	push   %rbp
  804160:	48 89 e5             	mov    %rsp,%rbp
  804163:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80416a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804171:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804178:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80417f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804186:	eb 76                	jmp    8041fe <devcons_write+0x9f>
		m = n - tot;
  804188:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80418f:	89 c2                	mov    %eax,%edx
  804191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804194:	29 c2                	sub    %eax,%edx
  804196:	89 d0                	mov    %edx,%eax
  804198:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80419b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80419e:	83 f8 7f             	cmp    $0x7f,%eax
  8041a1:	76 07                	jbe    8041aa <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041a3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ad:	48 63 d0             	movslq %eax,%rdx
  8041b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b3:	48 63 c8             	movslq %eax,%rcx
  8041b6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041bd:	48 01 c1             	add    %rax,%rcx
  8041c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041c7:	48 89 ce             	mov    %rcx,%rsi
  8041ca:	48 89 c7             	mov    %rax,%rdi
  8041cd:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8041d4:	00 00 00 
  8041d7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041dc:	48 63 d0             	movslq %eax,%rdx
  8041df:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041e6:	48 89 d6             	mov    %rdx,%rsi
  8041e9:	48 89 c7             	mov    %rax,%rdi
  8041ec:	48 b8 b7 16 80 00 00 	movabs $0x8016b7,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041fb:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804201:	48 98                	cltq   
  804203:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80420a:	0f 82 78 ff ff ff    	jb     804188 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804210:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804213:	c9                   	leaveq 
  804214:	c3                   	retq   

0000000000804215 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804215:	55                   	push   %rbp
  804216:	48 89 e5             	mov    %rsp,%rbp
  804219:	48 83 ec 08          	sub    $0x8,%rsp
  80421d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804226:	c9                   	leaveq 
  804227:	c3                   	retq   

0000000000804228 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804228:	55                   	push   %rbp
  804229:	48 89 e5             	mov    %rsp,%rbp
  80422c:	48 83 ec 10          	sub    $0x10,%rsp
  804230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804234:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423c:	48 be 65 4f 80 00 00 	movabs $0x804f65,%rsi
  804243:	00 00 00 
  804246:	48 89 c7             	mov    %rax,%rdi
  804249:	48 b8 d0 0e 80 00 00 	movabs $0x800ed0,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
	return 0;
  804255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80425a:	c9                   	leaveq 
  80425b:	c3                   	retq   

000000000080425c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80425c:	55                   	push   %rbp
  80425d:	48 89 e5             	mov    %rsp,%rbp
  804260:	53                   	push   %rbx
  804261:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804268:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80426f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804275:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80427c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804283:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80428a:	84 c0                	test   %al,%al
  80428c:	74 23                	je     8042b1 <_panic+0x55>
  80428e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804295:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804299:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80429d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8042a1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8042a5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8042a9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8042ad:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8042b1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8042b8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8042bf:	00 00 00 
  8042c2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8042c9:	00 00 00 
  8042cc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8042d0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8042d7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042de:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8042e5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8042ec:	00 00 00 
  8042ef:	48 8b 18             	mov    (%rax),%rbx
  8042f2:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  8042f9:	00 00 00 
  8042fc:	ff d0                	callq  *%rax
  8042fe:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804304:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80430b:	41 89 c8             	mov    %ecx,%r8d
  80430e:	48 89 d1             	mov    %rdx,%rcx
  804311:	48 89 da             	mov    %rbx,%rdx
  804314:	89 c6                	mov    %eax,%esi
  804316:	48 bf 70 4f 80 00 00 	movabs $0x804f70,%rdi
  80431d:	00 00 00 
  804320:	b8 00 00 00 00       	mov    $0x0,%eax
  804325:	49 b9 1b 03 80 00 00 	movabs $0x80031b,%r9
  80432c:	00 00 00 
  80432f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804332:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804339:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804340:	48 89 d6             	mov    %rdx,%rsi
  804343:	48 89 c7             	mov    %rax,%rdi
  804346:	48 b8 6f 02 80 00 00 	movabs $0x80026f,%rax
  80434d:	00 00 00 
  804350:	ff d0                	callq  *%rax
	cprintf("\n");
  804352:	48 bf 93 4f 80 00 00 	movabs $0x804f93,%rdi
  804359:	00 00 00 
  80435c:	b8 00 00 00 00       	mov    $0x0,%eax
  804361:	48 ba 1b 03 80 00 00 	movabs $0x80031b,%rdx
  804368:	00 00 00 
  80436b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80436d:	cc                   	int3   
  80436e:	eb fd                	jmp    80436d <_panic+0x111>

0000000000804370 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804370:	55                   	push   %rbp
  804371:	48 89 e5             	mov    %rsp,%rbp
  804374:	48 83 ec 10          	sub    $0x10,%rsp
  804378:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80437c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804383:	00 00 00 
  804386:	48 8b 00             	mov    (%rax),%rax
  804389:	48 85 c0             	test   %rax,%rax
  80438c:	0f 85 84 00 00 00    	jne    804416 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804392:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804399:	00 00 00 
  80439c:	48 8b 00             	mov    (%rax),%rax
  80439f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043a5:	ba 07 00 00 00       	mov    $0x7,%edx
  8043aa:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8043af:	89 c7                	mov    %eax,%edi
  8043b1:	48 b8 ff 17 80 00 00 	movabs $0x8017ff,%rax
  8043b8:	00 00 00 
  8043bb:	ff d0                	callq  *%rax
  8043bd:	85 c0                	test   %eax,%eax
  8043bf:	79 2a                	jns    8043eb <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8043c1:	48 ba 98 4f 80 00 00 	movabs $0x804f98,%rdx
  8043c8:	00 00 00 
  8043cb:	be 23 00 00 00       	mov    $0x23,%esi
  8043d0:	48 bf bf 4f 80 00 00 	movabs $0x804fbf,%rdi
  8043d7:	00 00 00 
  8043da:	b8 00 00 00 00       	mov    $0x0,%eax
  8043df:	48 b9 5c 42 80 00 00 	movabs $0x80425c,%rcx
  8043e6:	00 00 00 
  8043e9:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8043eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043f2:	00 00 00 
  8043f5:	48 8b 00             	mov    (%rax),%rax
  8043f8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043fe:	48 be 29 44 80 00 00 	movabs $0x804429,%rsi
  804405:	00 00 00 
  804408:	89 c7                	mov    %eax,%edi
  80440a:	48 b8 89 19 80 00 00 	movabs $0x801989,%rax
  804411:	00 00 00 
  804414:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804416:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80441d:	00 00 00 
  804420:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804424:	48 89 10             	mov    %rdx,(%rax)
}
  804427:	c9                   	leaveq 
  804428:	c3                   	retq   

0000000000804429 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804429:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80442c:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804433:	00 00 00 
call *%rax
  804436:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804438:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80443f:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804440:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804447:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804448:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80444c:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80444f:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804456:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804457:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80445b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80445f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804464:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804469:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80446e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804473:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804478:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80447d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804482:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804487:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80448c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804491:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804496:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80449b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044a0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044a5:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8044a9:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8044ad:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8044ae:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8044af:	c3                   	retq   

00000000008044b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044b0:	55                   	push   %rbp
  8044b1:	48 89 e5             	mov    %rsp,%rbp
  8044b4:	48 83 ec 30          	sub    $0x30,%rsp
  8044b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8044c4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8044cb:	00 00 00 
  8044ce:	48 8b 00             	mov    (%rax),%rax
  8044d1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8044d7:	85 c0                	test   %eax,%eax
  8044d9:	75 3c                	jne    804517 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8044db:	48 b8 83 17 80 00 00 	movabs $0x801783,%rax
  8044e2:	00 00 00 
  8044e5:	ff d0                	callq  *%rax
  8044e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8044ec:	48 63 d0             	movslq %eax,%rdx
  8044ef:	48 89 d0             	mov    %rdx,%rax
  8044f2:	48 c1 e0 03          	shl    $0x3,%rax
  8044f6:	48 01 d0             	add    %rdx,%rax
  8044f9:	48 c1 e0 05          	shl    $0x5,%rax
  8044fd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804504:	00 00 00 
  804507:	48 01 c2             	add    %rax,%rdx
  80450a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804511:	00 00 00 
  804514:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804517:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80451c:	75 0e                	jne    80452c <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80451e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804525:	00 00 00 
  804528:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80452c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804530:	48 89 c7             	mov    %rax,%rdi
  804533:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  80453a:	00 00 00 
  80453d:	ff d0                	callq  *%rax
  80453f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804542:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804546:	79 19                	jns    804561 <ipc_recv+0xb1>
		*from_env_store = 0;
  804548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80454c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804556:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80455c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455f:	eb 53                	jmp    8045b4 <ipc_recv+0x104>
	}
	if(from_env_store)
  804561:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804566:	74 19                	je     804581 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804568:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80456f:	00 00 00 
  804572:	48 8b 00             	mov    (%rax),%rax
  804575:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80457b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80457f:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804581:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804586:	74 19                	je     8045a1 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804588:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80458f:	00 00 00 
  804592:	48 8b 00             	mov    (%rax),%rax
  804595:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80459b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80459f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8045a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045a8:	00 00 00 
  8045ab:	48 8b 00             	mov    (%rax),%rax
  8045ae:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8045b4:	c9                   	leaveq 
  8045b5:	c3                   	retq   

00000000008045b6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045b6:	55                   	push   %rbp
  8045b7:	48 89 e5             	mov    %rsp,%rbp
  8045ba:	48 83 ec 30          	sub    $0x30,%rsp
  8045be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045c1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045c4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045c8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8045cb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045d0:	75 0e                	jne    8045e0 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8045d2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8045d9:	00 00 00 
  8045dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8045e0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045e3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ed:	89 c7                	mov    %eax,%edi
  8045ef:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  8045f6:	00 00 00 
  8045f9:	ff d0                	callq  *%rax
  8045fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8045fe:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804602:	75 0c                	jne    804610 <ipc_send+0x5a>
			sys_yield();
  804604:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  80460b:	00 00 00 
  80460e:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804610:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804614:	74 ca                	je     8045e0 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804616:	c9                   	leaveq 
  804617:	c3                   	retq   

0000000000804618 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804618:	55                   	push   %rbp
  804619:	48 89 e5             	mov    %rsp,%rbp
  80461c:	48 83 ec 14          	sub    $0x14,%rsp
  804620:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804623:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80462a:	eb 5e                	jmp    80468a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80462c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804633:	00 00 00 
  804636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804639:	48 63 d0             	movslq %eax,%rdx
  80463c:	48 89 d0             	mov    %rdx,%rax
  80463f:	48 c1 e0 03          	shl    $0x3,%rax
  804643:	48 01 d0             	add    %rdx,%rax
  804646:	48 c1 e0 05          	shl    $0x5,%rax
  80464a:	48 01 c8             	add    %rcx,%rax
  80464d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804653:	8b 00                	mov    (%rax),%eax
  804655:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804658:	75 2c                	jne    804686 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80465a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804661:	00 00 00 
  804664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804667:	48 63 d0             	movslq %eax,%rdx
  80466a:	48 89 d0             	mov    %rdx,%rax
  80466d:	48 c1 e0 03          	shl    $0x3,%rax
  804671:	48 01 d0             	add    %rdx,%rax
  804674:	48 c1 e0 05          	shl    $0x5,%rax
  804678:	48 01 c8             	add    %rcx,%rax
  80467b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804681:	8b 40 08             	mov    0x8(%rax),%eax
  804684:	eb 12                	jmp    804698 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804686:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80468a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804691:	7e 99                	jle    80462c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804698:	c9                   	leaveq 
  804699:	c3                   	retq   

000000000080469a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80469a:	55                   	push   %rbp
  80469b:	48 89 e5             	mov    %rsp,%rbp
  80469e:	48 83 ec 18          	sub    $0x18,%rsp
  8046a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046aa:	48 c1 e8 15          	shr    $0x15,%rax
  8046ae:	48 89 c2             	mov    %rax,%rdx
  8046b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046b8:	01 00 00 
  8046bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046bf:	83 e0 01             	and    $0x1,%eax
  8046c2:	48 85 c0             	test   %rax,%rax
  8046c5:	75 07                	jne    8046ce <pageref+0x34>
		return 0;
  8046c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cc:	eb 53                	jmp    804721 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d2:	48 c1 e8 0c          	shr    $0xc,%rax
  8046d6:	48 89 c2             	mov    %rax,%rdx
  8046d9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046e0:	01 00 00 
  8046e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8046eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046ef:	83 e0 01             	and    $0x1,%eax
  8046f2:	48 85 c0             	test   %rax,%rax
  8046f5:	75 07                	jne    8046fe <pageref+0x64>
		return 0;
  8046f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fc:	eb 23                	jmp    804721 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8046fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804702:	48 c1 e8 0c          	shr    $0xc,%rax
  804706:	48 89 c2             	mov    %rax,%rdx
  804709:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804710:	00 00 00 
  804713:	48 c1 e2 04          	shl    $0x4,%rdx
  804717:	48 01 d0             	add    %rdx,%rax
  80471a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80471e:	0f b7 c0             	movzwl %ax,%eax
}
  804721:	c9                   	leaveq 
  804722:	c3                   	retq   
