
obj/user/yield.debug:     file format elf64-x86-64


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
  80003c:	e8 c5 00 00 00       	callq  800106 <libmain>
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
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 60 34 80 00 00 	movabs $0x803460,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf 80 34 80 00 00 	movabs $0x803480,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf b0 34 80 00 00 	movabs $0x8034b0,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
  80010a:	48 83 ec 10          	sub    $0x10,%rsp
  80010e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800111:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800115:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	48 63 d0             	movslq %eax,%rdx
  800129:	48 89 d0             	mov    %rdx,%rax
  80012c:	48 c1 e0 03          	shl    $0x3,%rax
  800130:	48 01 d0             	add    %rdx,%rax
  800133:	48 c1 e0 05          	shl    $0x5,%rax
  800137:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80013e:	00 00 00 
  800141:	48 01 c2             	add    %rax,%rdx
  800144:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80014b:	00 00 00 
  80014e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800155:	7e 14                	jle    80016b <libmain+0x65>
		binaryname = argv[0];
  800157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015b:	48 8b 10             	mov    (%rax),%rdx
  80015e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800165:	00 00 00 
  800168:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80016b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800172:	48 89 d6             	mov    %rdx,%rsi
  800175:	89 c7                	mov    %eax,%edi
  800177:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800183:	48 b8 91 01 80 00 00 	movabs $0x800191,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
}
  80018f:	c9                   	leaveq 
  800190:	c3                   	retq   

0000000000800191 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800191:	55                   	push   %rbp
  800192:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800195:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a6:	48 b8 fd 16 80 00 00 	movabs $0x8016fd,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax

}
  8001b2:	5d                   	pop    %rbp
  8001b3:	c3                   	retq   

00000000008001b4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b4:	55                   	push   %rbp
  8001b5:	48 89 e5             	mov    %rsp,%rbp
  8001b8:	48 83 ec 10          	sub    $0x10,%rsp
  8001bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c7:	8b 00                	mov    (%rax),%eax
  8001c9:	8d 48 01             	lea    0x1(%rax),%ecx
  8001cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d0:	89 0a                	mov    %ecx,(%rdx)
  8001d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001db:	48 98                	cltq   
  8001dd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e5:	8b 00                	mov    (%rax),%eax
  8001e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ec:	75 2c                	jne    80021a <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8001ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f2:	8b 00                	mov    (%rax),%eax
  8001f4:	48 98                	cltq   
  8001f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001fa:	48 83 c2 08          	add    $0x8,%rdx
  8001fe:	48 89 c6             	mov    %rax,%rsi
  800201:	48 89 d7             	mov    %rdx,%rdi
  800204:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  80020b:	00 00 00 
  80020e:	ff d0                	callq  *%rax
		b->idx = 0;
  800210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800214:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 40 04             	mov    0x4(%rax),%eax
  800221:	8d 50 01             	lea    0x1(%rax),%edx
  800224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800228:	89 50 04             	mov    %edx,0x4(%rax)
}
  80022b:	c9                   	leaveq 
  80022c:	c3                   	retq   

000000000080022d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800238:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80023f:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800246:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80024d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800254:	48 8b 0a             	mov    (%rdx),%rcx
  800257:	48 89 08             	mov    %rcx,(%rax)
  80025a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80025e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800262:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800266:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80026a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800271:	00 00 00 
	b.cnt = 0;
  800274:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80027b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80027e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800285:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80028c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800293:	48 89 c6             	mov    %rax,%rsi
  800296:	48 bf b4 01 80 00 00 	movabs $0x8001b4,%rdi
  80029d:	00 00 00 
  8002a0:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002ac:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002b2:	48 98                	cltq   
  8002b4:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002bb:	48 83 c2 08          	add    $0x8,%rdx
  8002bf:	48 89 c6             	mov    %rax,%rsi
  8002c2:	48 89 d7             	mov    %rdx,%rdi
  8002c5:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002d1:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002d7:	c9                   	leaveq 
  8002d8:	c3                   	retq   

00000000008002d9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d9:	55                   	push   %rbp
  8002da:	48 89 e5             	mov    %rsp,%rbp
  8002dd:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002e4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002eb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002f9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800300:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800307:	84 c0                	test   %al,%al
  800309:	74 20                	je     80032b <cprintf+0x52>
  80030b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80030f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800313:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800317:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80031b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80031f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800323:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800327:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80032b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800332:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800339:	00 00 00 
  80033c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800343:	00 00 00 
  800346:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80034a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800351:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800358:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80035f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800366:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80036d:	48 8b 0a             	mov    (%rdx),%rcx
  800370:	48 89 08             	mov    %rcx,(%rax)
  800373:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800377:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80037b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80037f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800383:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80038a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800391:	48 89 d6             	mov    %rdx,%rsi
  800394:	48 89 c7             	mov    %rax,%rdi
  800397:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
  8003a3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003a9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003af:	c9                   	leaveq 
  8003b0:	c3                   	retq   

00000000008003b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	53                   	push   %rbx
  8003b6:	48 83 ec 38          	sub    $0x38,%rsp
  8003ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003c6:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003c9:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003cd:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003d4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003d8:	77 3b                	ja     800415 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003da:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003dd:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003e1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	48 f7 f3             	div    %rbx
  8003f0:	48 89 c2             	mov    %rax,%rdx
  8003f3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003f6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003f9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800401:	41 89 f9             	mov    %edi,%r9d
  800404:	48 89 c7             	mov    %rax,%rdi
  800407:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  80040e:	00 00 00 
  800411:	ff d0                	callq  *%rax
  800413:	eb 1e                	jmp    800433 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800415:	eb 12                	jmp    800429 <printnum+0x78>
			putch(padc, putdat);
  800417:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80041b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80041e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800422:	48 89 ce             	mov    %rcx,%rsi
  800425:	89 d7                	mov    %edx,%edi
  800427:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800429:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80042d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800431:	7f e4                	jg     800417 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800433:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043a:	ba 00 00 00 00       	mov    $0x0,%edx
  80043f:	48 f7 f1             	div    %rcx
  800442:	48 89 d0             	mov    %rdx,%rax
  800445:	48 ba a8 36 80 00 00 	movabs $0x8036a8,%rdx
  80044c:	00 00 00 
  80044f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800453:	0f be d0             	movsbl %al,%edx
  800456:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045e:	48 89 ce             	mov    %rcx,%rsi
  800461:	89 d7                	mov    %edx,%edi
  800463:	ff d0                	callq  *%rax
}
  800465:	48 83 c4 38          	add    $0x38,%rsp
  800469:	5b                   	pop    %rbx
  80046a:	5d                   	pop    %rbp
  80046b:	c3                   	retq   

000000000080046c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 83 ec 1c          	sub    $0x1c,%rsp
  800474:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800478:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80047b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80047f:	7e 52                	jle    8004d3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800485:	8b 00                	mov    (%rax),%eax
  800487:	83 f8 30             	cmp    $0x30,%eax
  80048a:	73 24                	jae    8004b0 <getuint+0x44>
  80048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800490:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800498:	8b 00                	mov    (%rax),%eax
  80049a:	89 c0                	mov    %eax,%eax
  80049c:	48 01 d0             	add    %rdx,%rax
  80049f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a3:	8b 12                	mov    (%rdx),%edx
  8004a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ac:	89 0a                	mov    %ecx,(%rdx)
  8004ae:	eb 17                	jmp    8004c7 <getuint+0x5b>
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004b8:	48 89 d0             	mov    %rdx,%rax
  8004bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004c7:	48 8b 00             	mov    (%rax),%rax
  8004ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ce:	e9 a3 00 00 00       	jmpq   800576 <getuint+0x10a>
	else if (lflag)
  8004d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004d7:	74 4f                	je     800528 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	83 f8 30             	cmp    $0x30,%eax
  8004e2:	73 24                	jae    800508 <getuint+0x9c>
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	89 c0                	mov    %eax,%eax
  8004f4:	48 01 d0             	add    %rdx,%rax
  8004f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fb:	8b 12                	mov    (%rdx),%edx
  8004fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	89 0a                	mov    %ecx,(%rdx)
  800506:	eb 17                	jmp    80051f <getuint+0xb3>
  800508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800510:	48 89 d0             	mov    %rdx,%rax
  800513:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800517:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80051f:	48 8b 00             	mov    (%rax),%rax
  800522:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800526:	eb 4e                	jmp    800576 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	83 f8 30             	cmp    $0x30,%eax
  800531:	73 24                	jae    800557 <getuint+0xeb>
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	8b 00                	mov    (%rax),%eax
  800541:	89 c0                	mov    %eax,%eax
  800543:	48 01 d0             	add    %rdx,%rax
  800546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054a:	8b 12                	mov    (%rdx),%edx
  80054c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800553:	89 0a                	mov    %ecx,(%rdx)
  800555:	eb 17                	jmp    80056e <getuint+0x102>
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055f:	48 89 d0             	mov    %rdx,%rax
  800562:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056e:	8b 00                	mov    (%rax),%eax
  800570:	89 c0                	mov    %eax,%eax
  800572:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80057a:	c9                   	leaveq 
  80057b:	c3                   	retq   

000000000080057c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	48 83 ec 1c          	sub    $0x1c,%rsp
  800584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80058b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80058f:	7e 52                	jle    8005e3 <getint+0x67>
		x=va_arg(*ap, long long);
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	8b 00                	mov    (%rax),%eax
  800597:	83 f8 30             	cmp    $0x30,%eax
  80059a:	73 24                	jae    8005c0 <getint+0x44>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	8b 00                	mov    (%rax),%eax
  8005aa:	89 c0                	mov    %eax,%eax
  8005ac:	48 01 d0             	add    %rdx,%rax
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	8b 12                	mov    (%rdx),%edx
  8005b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	89 0a                	mov    %ecx,(%rdx)
  8005be:	eb 17                	jmp    8005d7 <getint+0x5b>
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c8:	48 89 d0             	mov    %rdx,%rax
  8005cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d7:	48 8b 00             	mov    (%rax),%rax
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005de:	e9 a3 00 00 00       	jmpq   800686 <getint+0x10a>
	else if (lflag)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e7:	74 4f                	je     800638 <getint+0xbc>
		x=va_arg(*ap, long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getint+0x9c>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 17                	jmp    80062f <getint+0xb3>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800620:	48 89 d0             	mov    %rdx,%rax
  800623:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062f:	48 8b 00             	mov    (%rax),%rax
  800632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800636:	eb 4e                	jmp    800686 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getint+0xeb>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getint+0x102>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	48 98                	cltq   
  800682:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068a:	c9                   	leaveq 
  80068b:	c3                   	retq   

000000000080068c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80068c:	55                   	push   %rbp
  80068d:	48 89 e5             	mov    %rsp,%rbp
  800690:	41 54                	push   %r12
  800692:	53                   	push   %rbx
  800693:	48 83 ec 60          	sub    $0x60,%rsp
  800697:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80069b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80069f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006a7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ab:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006af:	48 8b 0a             	mov    (%rdx),%rcx
  8006b2:	48 89 08             	mov    %rcx,(%rax)
  8006b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	eb 17                	jmp    8006de <vprintfmt+0x52>
			if (ch == '\0')
  8006c7:	85 db                	test   %ebx,%ebx
  8006c9:	0f 84 cc 04 00 00    	je     800b9b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006cf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006d7:	48 89 d6             	mov    %rdx,%rsi
  8006da:	89 df                	mov    %ebx,%edi
  8006dc:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ea:	0f b6 00             	movzbl (%rax),%eax
  8006ed:	0f b6 d8             	movzbl %al,%ebx
  8006f0:	83 fb 25             	cmp    $0x25,%ebx
  8006f3:	75 d2                	jne    8006c7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006f5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006f9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800700:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800707:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80070e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800715:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800719:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80071d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800721:	0f b6 00             	movzbl (%rax),%eax
  800724:	0f b6 d8             	movzbl %al,%ebx
  800727:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80072a:	83 f8 55             	cmp    $0x55,%eax
  80072d:	0f 87 34 04 00 00    	ja     800b67 <vprintfmt+0x4db>
  800733:	89 c0                	mov    %eax,%eax
  800735:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80073c:	00 
  80073d:	48 b8 d0 36 80 00 00 	movabs $0x8036d0,%rax
  800744:	00 00 00 
  800747:	48 01 d0             	add    %rdx,%rax
  80074a:	48 8b 00             	mov    (%rax),%rax
  80074d:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80074f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800753:	eb c0                	jmp    800715 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800755:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800759:	eb ba                	jmp    800715 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800762:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800765:	89 d0                	mov    %edx,%eax
  800767:	c1 e0 02             	shl    $0x2,%eax
  80076a:	01 d0                	add    %edx,%eax
  80076c:	01 c0                	add    %eax,%eax
  80076e:	01 d8                	add    %ebx,%eax
  800770:	83 e8 30             	sub    $0x30,%eax
  800773:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800776:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077a:	0f b6 00             	movzbl (%rax),%eax
  80077d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800780:	83 fb 2f             	cmp    $0x2f,%ebx
  800783:	7e 0c                	jle    800791 <vprintfmt+0x105>
  800785:	83 fb 39             	cmp    $0x39,%ebx
  800788:	7f 07                	jg     800791 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80078f:	eb d1                	jmp    800762 <vprintfmt+0xd6>
			goto process_precision;
  800791:	eb 58                	jmp    8007eb <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800793:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 17                	jae    8007b2 <vprintfmt+0x126>
  80079b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 01 d0             	add    %rdx,%rax
  8007a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007aa:	83 c2 08             	add    $0x8,%edx
  8007ad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b0:	eb 0f                	jmp    8007c1 <vprintfmt+0x135>
  8007b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 83 c2 08          	add    $0x8,%rdx
  8007bd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007c6:	eb 23                	jmp    8007eb <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cc:	79 0c                	jns    8007da <vprintfmt+0x14e>
				width = 0;
  8007ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007d5:	e9 3b ff ff ff       	jmpq   800715 <vprintfmt+0x89>
  8007da:	e9 36 ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007df:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007e6:	e9 2a ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ef:	79 12                	jns    800803 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007f1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007f4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007fe:	e9 12 ff ff ff       	jmpq   800715 <vprintfmt+0x89>
  800803:	e9 0d ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800808:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80080c:	e9 04 ff ff ff       	jmpq   800715 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800811:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800814:	83 f8 30             	cmp    $0x30,%eax
  800817:	73 17                	jae    800830 <vprintfmt+0x1a4>
  800819:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80081d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800820:	89 c0                	mov    %eax,%eax
  800822:	48 01 d0             	add    %rdx,%rax
  800825:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800828:	83 c2 08             	add    $0x8,%edx
  80082b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082e:	eb 0f                	jmp    80083f <vprintfmt+0x1b3>
  800830:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800834:	48 89 d0             	mov    %rdx,%rax
  800837:	48 83 c2 08          	add    $0x8,%rdx
  80083b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083f:	8b 10                	mov    (%rax),%edx
  800841:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800845:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800849:	48 89 ce             	mov    %rcx,%rsi
  80084c:	89 d7                	mov    %edx,%edi
  80084e:	ff d0                	callq  *%rax
			break;
  800850:	e9 40 03 00 00       	jmpq   800b95 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800855:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800858:	83 f8 30             	cmp    $0x30,%eax
  80085b:	73 17                	jae    800874 <vprintfmt+0x1e8>
  80085d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800861:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800864:	89 c0                	mov    %eax,%eax
  800866:	48 01 d0             	add    %rdx,%rax
  800869:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086c:	83 c2 08             	add    $0x8,%edx
  80086f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800872:	eb 0f                	jmp    800883 <vprintfmt+0x1f7>
  800874:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800878:	48 89 d0             	mov    %rdx,%rax
  80087b:	48 83 c2 08          	add    $0x8,%rdx
  80087f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800883:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800885:	85 db                	test   %ebx,%ebx
  800887:	79 02                	jns    80088b <vprintfmt+0x1ff>
				err = -err;
  800889:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80088b:	83 fb 10             	cmp    $0x10,%ebx
  80088e:	7f 16                	jg     8008a6 <vprintfmt+0x21a>
  800890:	48 b8 20 36 80 00 00 	movabs $0x803620,%rax
  800897:	00 00 00 
  80089a:	48 63 d3             	movslq %ebx,%rdx
  80089d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008a1:	4d 85 e4             	test   %r12,%r12
  8008a4:	75 2e                	jne    8008d4 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008a6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ae:	89 d9                	mov    %ebx,%ecx
  8008b0:	48 ba b9 36 80 00 00 	movabs $0x8036b9,%rdx
  8008b7:	00 00 00 
  8008ba:	48 89 c7             	mov    %rax,%rdi
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c2:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008c9:	00 00 00 
  8008cc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cf:	e9 c1 02 00 00       	jmpq   800b95 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008dc:	4c 89 e1             	mov    %r12,%rcx
  8008df:	48 ba c2 36 80 00 00 	movabs $0x8036c2,%rdx
  8008e6:	00 00 00 
  8008e9:	48 89 c7             	mov    %rax,%rdi
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008f8:	00 00 00 
  8008fb:	41 ff d0             	callq  *%r8
			break;
  8008fe:	e9 92 02 00 00       	jmpq   800b95 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800903:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800906:	83 f8 30             	cmp    $0x30,%eax
  800909:	73 17                	jae    800922 <vprintfmt+0x296>
  80090b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091a:	83 c2 08             	add    $0x8,%edx
  80091d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800920:	eb 0f                	jmp    800931 <vprintfmt+0x2a5>
  800922:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800926:	48 89 d0             	mov    %rdx,%rax
  800929:	48 83 c2 08          	add    $0x8,%rdx
  80092d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800931:	4c 8b 20             	mov    (%rax),%r12
  800934:	4d 85 e4             	test   %r12,%r12
  800937:	75 0a                	jne    800943 <vprintfmt+0x2b7>
				p = "(null)";
  800939:	49 bc c5 36 80 00 00 	movabs $0x8036c5,%r12
  800940:	00 00 00 
			if (width > 0 && padc != '-')
  800943:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800947:	7e 3f                	jle    800988 <vprintfmt+0x2fc>
  800949:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80094d:	74 39                	je     800988 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80094f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800952:	48 98                	cltq   
  800954:	48 89 c6             	mov    %rax,%rsi
  800957:	4c 89 e7             	mov    %r12,%rdi
  80095a:	48 b8 50 0e 80 00 00 	movabs $0x800e50,%rax
  800961:	00 00 00 
  800964:	ff d0                	callq  *%rax
  800966:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800969:	eb 17                	jmp    800982 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80096b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80096f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800973:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800977:	48 89 ce             	mov    %rcx,%rsi
  80097a:	89 d7                	mov    %edx,%edi
  80097c:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800982:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800986:	7f e3                	jg     80096b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800988:	eb 37                	jmp    8009c1 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80098a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80098e:	74 1e                	je     8009ae <vprintfmt+0x322>
  800990:	83 fb 1f             	cmp    $0x1f,%ebx
  800993:	7e 05                	jle    80099a <vprintfmt+0x30e>
  800995:	83 fb 7e             	cmp    $0x7e,%ebx
  800998:	7e 14                	jle    8009ae <vprintfmt+0x322>
					putch('?', putdat);
  80099a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80099e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a2:	48 89 d6             	mov    %rdx,%rsi
  8009a5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009aa:	ff d0                	callq  *%rax
  8009ac:	eb 0f                	jmp    8009bd <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009ae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b6:	48 89 d6             	mov    %rdx,%rsi
  8009b9:	89 df                	mov    %ebx,%edi
  8009bb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009bd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c1:	4c 89 e0             	mov    %r12,%rax
  8009c4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009c8:	0f b6 00             	movzbl (%rax),%eax
  8009cb:	0f be d8             	movsbl %al,%ebx
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	74 10                	je     8009e2 <vprintfmt+0x356>
  8009d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009d6:	78 b2                	js     80098a <vprintfmt+0x2fe>
  8009d8:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009e0:	79 a8                	jns    80098a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e2:	eb 16                	jmp    8009fa <vprintfmt+0x36e>
				putch(' ', putdat);
  8009e4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ec:	48 89 d6             	mov    %rdx,%rsi
  8009ef:	bf 20 00 00 00       	mov    $0x20,%edi
  8009f4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	7f e4                	jg     8009e4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a00:	e9 90 01 00 00       	jmpq   800b95 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a09:	be 03 00 00 00       	mov    $0x3,%esi
  800a0e:	48 89 c7             	mov    %rax,%rdi
  800a11:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800a18:	00 00 00 
  800a1b:	ff d0                	callq  *%rax
  800a1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a25:	48 85 c0             	test   %rax,%rax
  800a28:	79 1d                	jns    800a47 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	48 89 d6             	mov    %rdx,%rsi
  800a35:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a3a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a40:	48 f7 d8             	neg    %rax
  800a43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a47:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4e:	e9 d5 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a57:	be 03 00 00 00       	mov    $0x3,%esi
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 6c 04 80 00 00 	movabs $0x80046c,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a76:	e9 ad 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a7b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a82:	89 d6                	mov    %edx,%esi
  800a84:	48 89 c7             	mov    %rax,%rdi
  800a87:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800a8e:	00 00 00 
  800a91:	ff d0                	callq  *%rax
  800a93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a97:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a9e:	e9 85 00 00 00       	jmpq   800b28 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aab:	48 89 d6             	mov    %rdx,%rsi
  800aae:	bf 30 00 00 00       	mov    $0x30,%edi
  800ab3:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ab5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abd:	48 89 d6             	mov    %rdx,%rsi
  800ac0:	bf 78 00 00 00       	mov    $0x78,%edi
  800ac5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 30             	cmp    $0x30,%eax
  800acd:	73 17                	jae    800ae6 <vprintfmt+0x45a>
  800acf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 01 d0             	add    %rdx,%rax
  800adb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ade:	83 c2 08             	add    $0x8,%edx
  800ae1:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae4:	eb 0f                	jmp    800af5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ae6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aea:	48 89 d0             	mov    %rdx,%rax
  800aed:	48 83 c2 08          	add    $0x8,%rdx
  800af1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af5:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800afc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b03:	eb 23                	jmp    800b28 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b09:	be 03 00 00 00       	mov    $0x3,%esi
  800b0e:	48 89 c7             	mov    %rax,%rdi
  800b11:	48 b8 6c 04 80 00 00 	movabs $0x80046c,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
  800b1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b21:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b28:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b2d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b30:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b37:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3f:	45 89 c1             	mov    %r8d,%r9d
  800b42:	41 89 f8             	mov    %edi,%r8d
  800b45:	48 89 c7             	mov    %rax,%rdi
  800b48:	48 b8 b1 03 80 00 00 	movabs $0x8003b1,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax
			break;
  800b54:	eb 3f                	jmp    800b95 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5e:	48 89 d6             	mov    %rdx,%rsi
  800b61:	89 df                	mov    %ebx,%edi
  800b63:	ff d0                	callq  *%rax
			break;
  800b65:	eb 2e                	jmp    800b95 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6f:	48 89 d6             	mov    %rdx,%rsi
  800b72:	bf 25 00 00 00       	mov    $0x25,%edi
  800b77:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b79:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b7e:	eb 05                	jmp    800b85 <vprintfmt+0x4f9>
  800b80:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b85:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b89:	48 83 e8 01          	sub    $0x1,%rax
  800b8d:	0f b6 00             	movzbl (%rax),%eax
  800b90:	3c 25                	cmp    $0x25,%al
  800b92:	75 ec                	jne    800b80 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b94:	90                   	nop
		}
	}
  800b95:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b96:	e9 43 fb ff ff       	jmpq   8006de <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800b9b:	48 83 c4 60          	add    $0x60,%rsp
  800b9f:	5b                   	pop    %rbx
  800ba0:	41 5c                	pop    %r12
  800ba2:	5d                   	pop    %rbp
  800ba3:	c3                   	retq   

0000000000800ba4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba4:	55                   	push   %rbp
  800ba5:	48 89 e5             	mov    %rsp,%rbp
  800ba8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800baf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bb6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bbd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bc4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bcb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bd2:	84 c0                	test   %al,%al
  800bd4:	74 20                	je     800bf6 <printfmt+0x52>
  800bd6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bde:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800be2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800be6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bf2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bf6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bfd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c04:	00 00 00 
  800c07:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c0e:	00 00 00 
  800c11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c15:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c23:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c2a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c31:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c38:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c3f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c46:	48 89 c7             	mov    %rax,%rdi
  800c49:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c55:	c9                   	leaveq 
  800c56:	c3                   	retq   

0000000000800c57 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c57:	55                   	push   %rbp
  800c58:	48 89 e5             	mov    %rsp,%rbp
  800c5b:	48 83 ec 10          	sub    $0x10,%rsp
  800c5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6a:	8b 40 10             	mov    0x10(%rax),%eax
  800c6d:	8d 50 01             	lea    0x1(%rax),%edx
  800c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c74:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7b:	48 8b 10             	mov    (%rax),%rdx
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c86:	48 39 c2             	cmp    %rax,%rdx
  800c89:	73 17                	jae    800ca2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	48 8b 00             	mov    (%rax),%rax
  800c92:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c9a:	48 89 0a             	mov    %rcx,(%rdx)
  800c9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ca0:	88 10                	mov    %dl,(%rax)
}
  800ca2:	c9                   	leaveq 
  800ca3:	c3                   	retq   

0000000000800ca4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca4:	55                   	push   %rbp
  800ca5:	48 89 e5             	mov    %rsp,%rbp
  800ca8:	48 83 ec 50          	sub    $0x50,%rsp
  800cac:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cb0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cb3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cb7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cbb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cbf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cc3:	48 8b 0a             	mov    (%rdx),%rcx
  800cc6:	48 89 08             	mov    %rcx,(%rax)
  800cc9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ccd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cd1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cd5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cdd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ce1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ce4:	48 98                	cltq   
  800ce6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cee:	48 01 d0             	add    %rdx,%rax
  800cf1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cf5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cfc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d01:	74 06                	je     800d09 <vsnprintf+0x65>
  800d03:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d07:	7f 07                	jg     800d10 <vsnprintf+0x6c>
		return -E_INVAL;
  800d09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d0e:	eb 2f                	jmp    800d3f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d10:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d14:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d18:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d1c:	48 89 c6             	mov    %rax,%rsi
  800d1f:	48 bf 57 0c 80 00 00 	movabs $0x800c57,%rdi
  800d26:	00 00 00 
  800d29:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800d30:	00 00 00 
  800d33:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d39:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d3c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d3f:	c9                   	leaveq 
  800d40:	c3                   	retq   

0000000000800d41 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d41:	55                   	push   %rbp
  800d42:	48 89 e5             	mov    %rsp,%rbp
  800d45:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d4c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d53:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d59:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d60:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d67:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6e:	84 c0                	test   %al,%al
  800d70:	74 20                	je     800d92 <snprintf+0x51>
  800d72:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d76:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d82:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d86:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d92:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d99:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800da0:	00 00 00 
  800da3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800daa:	00 00 00 
  800dad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800db8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dc6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dcd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dd4:	48 8b 0a             	mov    (%rdx),%rcx
  800dd7:	48 89 08             	mov    %rcx,(%rax)
  800dda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dde:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800de2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dea:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800df1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800df8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dfe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e05:	48 89 c7             	mov    %rax,%rdi
  800e08:	48 b8 a4 0c 80 00 00 	movabs $0x800ca4,%rax
  800e0f:	00 00 00 
  800e12:	ff d0                	callq  *%rax
  800e14:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e1a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e20:	c9                   	leaveq 
  800e21:	c3                   	retq   

0000000000800e22 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e22:	55                   	push   %rbp
  800e23:	48 89 e5             	mov    %rsp,%rbp
  800e26:	48 83 ec 18          	sub    $0x18,%rsp
  800e2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e35:	eb 09                	jmp    800e40 <strlen+0x1e>
		n++;
  800e37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	0f b6 00             	movzbl (%rax),%eax
  800e47:	84 c0                	test   %al,%al
  800e49:	75 ec                	jne    800e37 <strlen+0x15>
		n++;
	return n;
  800e4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e4e:	c9                   	leaveq 
  800e4f:	c3                   	retq   

0000000000800e50 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e50:	55                   	push   %rbp
  800e51:	48 89 e5             	mov    %rsp,%rbp
  800e54:	48 83 ec 20          	sub    $0x20,%rsp
  800e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e67:	eb 0e                	jmp    800e77 <strnlen+0x27>
		n++;
  800e69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e72:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e77:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e7c:	74 0b                	je     800e89 <strnlen+0x39>
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	0f b6 00             	movzbl (%rax),%eax
  800e85:	84 c0                	test   %al,%al
  800e87:	75 e0                	jne    800e69 <strnlen+0x19>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8c:	c9                   	leaveq 
  800e8d:	c3                   	retq   

0000000000800e8e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8e:	55                   	push   %rbp
  800e8f:	48 89 e5             	mov    %rsp,%rbp
  800e92:	48 83 ec 20          	sub    $0x20,%rsp
  800e96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ea6:	90                   	nop
  800ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eaf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eb3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eb7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ebb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ebf:	0f b6 12             	movzbl (%rdx),%edx
  800ec2:	88 10                	mov    %dl,(%rax)
  800ec4:	0f b6 00             	movzbl (%rax),%eax
  800ec7:	84 c0                	test   %al,%al
  800ec9:	75 dc                	jne    800ea7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ecf:	c9                   	leaveq 
  800ed0:	c3                   	retq   

0000000000800ed1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ed1:	55                   	push   %rbp
  800ed2:	48 89 e5             	mov    %rsp,%rbp
  800ed5:	48 83 ec 20          	sub    $0x20,%rsp
  800ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
  800ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ef7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800efa:	48 63 d0             	movslq %eax,%rdx
  800efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f01:	48 01 c2             	add    %rax,%rdx
  800f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f08:	48 89 c6             	mov    %rax,%rsi
  800f0b:	48 89 d7             	mov    %rdx,%rdi
  800f0e:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800f15:	00 00 00 
  800f18:	ff d0                	callq  *%rax
	return dst;
  800f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 28          	sub    $0x28,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f3c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f43:	00 
  800f44:	eb 2a                	jmp    800f70 <strncpy+0x50>
		*dst++ = *src;
  800f46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f56:	0f b6 12             	movzbl (%rdx),%edx
  800f59:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f5f:	0f b6 00             	movzbl (%rax),%eax
  800f62:	84 c0                	test   %al,%al
  800f64:	74 05                	je     800f6b <strncpy+0x4b>
			src++;
  800f66:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f6b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f74:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f78:	72 cc                	jb     800f46 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 28          	sub    $0x28,%rsp
  800f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f90:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa1:	74 3d                	je     800fe0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fa3:	eb 1d                	jmp    800fc2 <strlcpy+0x42>
			*dst++ = *src++;
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fbd:	0f b6 12             	movzbl (%rdx),%edx
  800fc0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fc7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fcc:	74 0b                	je     800fd9 <strlcpy+0x59>
  800fce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 cc                	jne    800fa5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fe0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe8:	48 29 c2             	sub    %rax,%rdx
  800feb:	48 89 d0             	mov    %rdx,%rax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 83 ec 10          	sub    $0x10,%rsp
  800ff8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ffc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801000:	eb 0a                	jmp    80100c <strcmp+0x1c>
		p++, q++;
  801002:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801007:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80100c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	84 c0                	test   %al,%al
  801015:	74 12                	je     801029 <strcmp+0x39>
  801017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101b:	0f b6 10             	movzbl (%rax),%edx
  80101e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	38 c2                	cmp    %al,%dl
  801027:	74 d9                	je     801002 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	0f b6 d0             	movzbl %al,%edx
  801033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801037:	0f b6 00             	movzbl (%rax),%eax
  80103a:	0f b6 c0             	movzbl %al,%eax
  80103d:	29 c2                	sub    %eax,%edx
  80103f:	89 d0                	mov    %edx,%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 18          	sub    $0x18,%rsp
  80104b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801053:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801057:	eb 0f                	jmp    801068 <strncmp+0x25>
		n--, p++, q++;
  801059:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80105e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801063:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801068:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80106d:	74 1d                	je     80108c <strncmp+0x49>
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	84 c0                	test   %al,%al
  801078:	74 12                	je     80108c <strncmp+0x49>
  80107a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107e:	0f b6 10             	movzbl (%rax),%edx
  801081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801085:	0f b6 00             	movzbl (%rax),%eax
  801088:	38 c2                	cmp    %al,%dl
  80108a:	74 cd                	je     801059 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80108c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801091:	75 07                	jne    80109a <strncmp+0x57>
		return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	eb 18                	jmp    8010b2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 00             	movzbl (%rax),%eax
  8010a1:	0f b6 d0             	movzbl %al,%edx
  8010a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a8:	0f b6 00             	movzbl (%rax),%eax
  8010ab:	0f b6 c0             	movzbl %al,%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
}
  8010b2:	c9                   	leaveq 
  8010b3:	c3                   	retq   

00000000008010b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b4:	55                   	push   %rbp
  8010b5:	48 89 e5             	mov    %rsp,%rbp
  8010b8:	48 83 ec 0c          	sub    $0xc,%rsp
  8010bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c0:	89 f0                	mov    %esi,%eax
  8010c2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010c5:	eb 17                	jmp    8010de <strchr+0x2a>
		if (*s == c)
  8010c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cb:	0f b6 00             	movzbl (%rax),%eax
  8010ce:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010d1:	75 06                	jne    8010d9 <strchr+0x25>
			return (char *) s;
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d7:	eb 15                	jmp    8010ee <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e2:	0f b6 00             	movzbl (%rax),%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 de                	jne    8010c7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	c9                   	leaveq 
  8010ef:	c3                   	retq   

00000000008010f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	48 83 ec 0c          	sub    $0xc,%rsp
  8010f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fc:	89 f0                	mov    %esi,%eax
  8010fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801101:	eb 13                	jmp    801116 <strfind+0x26>
		if (*s == c)
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80110d:	75 02                	jne    801111 <strfind+0x21>
			break;
  80110f:	eb 10                	jmp    801121 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801111:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	75 e2                	jne    801103 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 18          	sub    $0x18,%rsp
  80112f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801133:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801136:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80113a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80113f:	75 06                	jne    801147 <memset+0x20>
		return v;
  801141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801145:	eb 69                	jmp    8011b0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801147:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114b:	83 e0 03             	and    $0x3,%eax
  80114e:	48 85 c0             	test   %rax,%rax
  801151:	75 48                	jne    80119b <memset+0x74>
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801157:	83 e0 03             	and    $0x3,%eax
  80115a:	48 85 c0             	test   %rax,%rax
  80115d:	75 3c                	jne    80119b <memset+0x74>
		c &= 0xFF;
  80115f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801166:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801169:	c1 e0 18             	shl    $0x18,%eax
  80116c:	89 c2                	mov    %eax,%edx
  80116e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801171:	c1 e0 10             	shl    $0x10,%eax
  801174:	09 c2                	or     %eax,%edx
  801176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801179:	c1 e0 08             	shl    $0x8,%eax
  80117c:	09 d0                	or     %edx,%eax
  80117e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	48 c1 e8 02          	shr    $0x2,%rax
  801189:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80118c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801190:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801193:	48 89 d7             	mov    %rdx,%rdi
  801196:	fc                   	cld    
  801197:	f3 ab                	rep stos %eax,%es:(%rdi)
  801199:	eb 11                	jmp    8011ac <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80119b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80119f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011a6:	48 89 d7             	mov    %rdx,%rdi
  8011a9:	fc                   	cld    
  8011aa:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 28          	sub    $0x28,%rsp
  8011ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011da:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011de:	0f 83 88 00 00 00    	jae    80126c <memmove+0xba>
  8011e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ec:	48 01 d0             	add    %rdx,%rax
  8011ef:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f3:	76 77                	jbe    80126c <memmove+0xba>
		s += n;
  8011f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801201:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	83 e0 03             	and    $0x3,%eax
  80120c:	48 85 c0             	test   %rax,%rax
  80120f:	75 3b                	jne    80124c <memmove+0x9a>
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	83 e0 03             	and    $0x3,%eax
  801218:	48 85 c0             	test   %rax,%rax
  80121b:	75 2f                	jne    80124c <memmove+0x9a>
  80121d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 23                	jne    80124c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	48 83 e8 04          	sub    $0x4,%rax
  801231:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801235:	48 83 ea 04          	sub    $0x4,%rdx
  801239:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80123d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 89 d6             	mov    %rdx,%rsi
  801247:	fd                   	std    
  801248:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80124a:	eb 1d                	jmp    801269 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80124c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801250:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80125c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801260:	48 89 d7             	mov    %rdx,%rdi
  801263:	48 89 c1             	mov    %rax,%rcx
  801266:	fd                   	std    
  801267:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801269:	fc                   	cld    
  80126a:	eb 57                	jmp    8012c3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	83 e0 03             	and    $0x3,%eax
  801273:	48 85 c0             	test   %rax,%rax
  801276:	75 36                	jne    8012ae <memmove+0xfc>
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	83 e0 03             	and    $0x3,%eax
  80127f:	48 85 c0             	test   %rax,%rax
  801282:	75 2a                	jne    8012ae <memmove+0xfc>
  801284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801288:	83 e0 03             	and    $0x3,%eax
  80128b:	48 85 c0             	test   %rax,%rax
  80128e:	75 1e                	jne    8012ae <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801294:	48 c1 e8 02          	shr    $0x2,%rax
  801298:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a3:	48 89 c7             	mov    %rax,%rdi
  8012a6:	48 89 d6             	mov    %rdx,%rsi
  8012a9:	fc                   	cld    
  8012aa:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ac:	eb 15                	jmp    8012c3 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012ba:	48 89 c7             	mov    %rax,%rdi
  8012bd:	48 89 d6             	mov    %rdx,%rsi
  8012c0:	fc                   	cld    
  8012c1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012c7:	c9                   	leaveq 
  8012c8:	c3                   	retq   

00000000008012c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012c9:	55                   	push   %rbp
  8012ca:	48 89 e5             	mov    %rsp,%rbp
  8012cd:	48 83 ec 18          	sub    $0x18,%rsp
  8012d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e9:	48 89 ce             	mov    %rcx,%rsi
  8012ec:	48 89 c7             	mov    %rax,%rdi
  8012ef:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
}
  8012fb:	c9                   	leaveq 
  8012fc:	c3                   	retq   

00000000008012fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
  801301:	48 83 ec 28          	sub    $0x28,%rsp
  801305:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801309:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80130d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801319:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801321:	eb 36                	jmp    801359 <memcmp+0x5c>
		if (*s1 != *s2)
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	0f b6 10             	movzbl (%rax),%edx
  80132a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	38 c2                	cmp    %al,%dl
  801333:	74 1a                	je     80134f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	0f b6 d0             	movzbl %al,%edx
  80133f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801343:	0f b6 00             	movzbl (%rax),%eax
  801346:	0f b6 c0             	movzbl %al,%eax
  801349:	29 c2                	sub    %eax,%edx
  80134b:	89 d0                	mov    %edx,%eax
  80134d:	eb 20                	jmp    80136f <memcmp+0x72>
		s1++, s2++;
  80134f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801354:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801361:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801365:	48 85 c0             	test   %rax,%rax
  801368:	75 b9                	jne    801323 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136f:	c9                   	leaveq 
  801370:	c3                   	retq   

0000000000801371 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801371:	55                   	push   %rbp
  801372:	48 89 e5             	mov    %rsp,%rbp
  801375:	48 83 ec 28          	sub    $0x28,%rsp
  801379:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801380:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801384:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801388:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80138c:	48 01 d0             	add    %rdx,%rax
  80138f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801393:	eb 15                	jmp    8013aa <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	0f b6 10             	movzbl (%rax),%edx
  80139c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80139f:	38 c2                	cmp    %al,%dl
  8013a1:	75 02                	jne    8013a5 <memfind+0x34>
			break;
  8013a3:	eb 0f                	jmp    8013b4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013b2:	72 e1                	jb     801395 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 34          	sub    $0x34,%rsp
  8013c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013ca:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013d4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013db:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013dc:	eb 05                	jmp    8013e3 <strtol+0x29>
		s++;
  8013de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	3c 20                	cmp    $0x20,%al
  8013ec:	74 f0                	je     8013de <strtol+0x24>
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	3c 09                	cmp    $0x9,%al
  8013f7:	74 e5                	je     8013de <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	0f b6 00             	movzbl (%rax),%eax
  801400:	3c 2b                	cmp    $0x2b,%al
  801402:	75 07                	jne    80140b <strtol+0x51>
		s++;
  801404:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801409:	eb 17                	jmp    801422 <strtol+0x68>
	else if (*s == '-')
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3c 2d                	cmp    $0x2d,%al
  801414:	75 0c                	jne    801422 <strtol+0x68>
		s++, neg = 1;
  801416:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80141b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801422:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801426:	74 06                	je     80142e <strtol+0x74>
  801428:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80142c:	75 28                	jne    801456 <strtol+0x9c>
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	0f b6 00             	movzbl (%rax),%eax
  801435:	3c 30                	cmp    $0x30,%al
  801437:	75 1d                	jne    801456 <strtol+0x9c>
  801439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143d:	48 83 c0 01          	add    $0x1,%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 78                	cmp    $0x78,%al
  801446:	75 0e                	jne    801456 <strtol+0x9c>
		s += 2, base = 16;
  801448:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80144d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801454:	eb 2c                	jmp    801482 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801456:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80145a:	75 19                	jne    801475 <strtol+0xbb>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	3c 30                	cmp    $0x30,%al
  801465:	75 0e                	jne    801475 <strtol+0xbb>
		s++, base = 8;
  801467:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801473:	eb 0d                	jmp    801482 <strtol+0xc8>
	else if (base == 0)
  801475:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801479:	75 07                	jne    801482 <strtol+0xc8>
		base = 10;
  80147b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	3c 2f                	cmp    $0x2f,%al
  80148b:	7e 1d                	jle    8014aa <strtol+0xf0>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 39                	cmp    $0x39,%al
  801496:	7f 12                	jg     8014aa <strtol+0xf0>
			dig = *s - '0';
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 30             	sub    $0x30,%eax
  8014a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a8:	eb 4e                	jmp    8014f8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 60                	cmp    $0x60,%al
  8014b3:	7e 1d                	jle    8014d2 <strtol+0x118>
  8014b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	3c 7a                	cmp    $0x7a,%al
  8014be:	7f 12                	jg     8014d2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c4:	0f b6 00             	movzbl (%rax),%eax
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	83 e8 57             	sub    $0x57,%eax
  8014cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014d0:	eb 26                	jmp    8014f8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	3c 40                	cmp    $0x40,%al
  8014db:	7e 48                	jle    801525 <strtol+0x16b>
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 5a                	cmp    $0x5a,%al
  8014e6:	7f 3d                	jg     801525 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	0f be c0             	movsbl %al,%eax
  8014f2:	83 e8 37             	sub    $0x37,%eax
  8014f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014fe:	7c 02                	jl     801502 <strtol+0x148>
			break;
  801500:	eb 23                	jmp    801525 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801502:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801507:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80150a:	48 98                	cltq   
  80150c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801511:	48 89 c2             	mov    %rax,%rdx
  801514:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801517:	48 98                	cltq   
  801519:	48 01 d0             	add    %rdx,%rax
  80151c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801520:	e9 5d ff ff ff       	jmpq   801482 <strtol+0xc8>

	if (endptr)
  801525:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80152a:	74 0b                	je     801537 <strtol+0x17d>
		*endptr = (char *) s;
  80152c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801530:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801534:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801537:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80153b:	74 09                	je     801546 <strtol+0x18c>
  80153d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801541:	48 f7 d8             	neg    %rax
  801544:	eb 04                	jmp    80154a <strtol+0x190>
  801546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80154a:	c9                   	leaveq 
  80154b:	c3                   	retq   

000000000080154c <strstr>:

char * strstr(const char *in, const char *str)
{
  80154c:	55                   	push   %rbp
  80154d:	48 89 e5             	mov    %rsp,%rbp
  801550:	48 83 ec 30          	sub    $0x30,%rsp
  801554:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801558:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80155c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801560:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801564:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80156e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801572:	75 06                	jne    80157a <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	eb 6b                	jmp    8015e5 <strstr+0x99>

    len = strlen(str);
  80157a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157e:	48 89 c7             	mov    %rax,%rdi
  801581:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  801588:	00 00 00 
  80158b:	ff d0                	callq  *%rax
  80158d:	48 98                	cltq   
  80158f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80159b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015a5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015a9:	75 07                	jne    8015b2 <strstr+0x66>
                return (char *) 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	eb 33                	jmp    8015e5 <strstr+0x99>
        } while (sc != c);
  8015b2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015b6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015b9:	75 d8                	jne    801593 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8015bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015bf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	48 89 ce             	mov    %rcx,%rsi
  8015ca:	48 89 c7             	mov    %rax,%rdi
  8015cd:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	callq  *%rax
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 b6                	jne    801593 <strstr+0x47>

    return (char *) (in - 1);
  8015dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e1:	48 83 e8 01          	sub    $0x1,%rax
}
  8015e5:	c9                   	leaveq 
  8015e6:	c3                   	retq   

00000000008015e7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015e7:	55                   	push   %rbp
  8015e8:	48 89 e5             	mov    %rsp,%rbp
  8015eb:	53                   	push   %rbx
  8015ec:	48 83 ec 48          	sub    $0x48,%rsp
  8015f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015f3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015f6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015fa:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015fe:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801602:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801606:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801609:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80160d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801611:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801615:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801619:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80161d:	4c 89 c3             	mov    %r8,%rbx
  801620:	cd 30                	int    $0x30
  801622:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801626:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80162a:	74 3e                	je     80166a <syscall+0x83>
  80162c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801631:	7e 37                	jle    80166a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801637:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80163a:	49 89 d0             	mov    %rdx,%r8
  80163d:	89 c1                	mov    %eax,%ecx
  80163f:	48 ba 80 39 80 00 00 	movabs $0x803980,%rdx
  801646:	00 00 00 
  801649:	be 23 00 00 00       	mov    $0x23,%esi
  80164e:	48 bf 9d 39 80 00 00 	movabs $0x80399d,%rdi
  801655:	00 00 00 
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
  80165d:	49 b9 cf 30 80 00 00 	movabs $0x8030cf,%r9
  801664:	00 00 00 
  801667:	41 ff d1             	callq  *%r9

	return ret;
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80166e:	48 83 c4 48          	add    $0x48,%rsp
  801672:	5b                   	pop    %rbx
  801673:	5d                   	pop    %rbp
  801674:	c3                   	retq   

0000000000801675 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 20          	sub    $0x20,%rsp
  80167d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801681:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801689:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80168d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801694:	00 
  801695:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a1:	48 89 d1             	mov    %rdx,%rcx
  8016a4:	48 89 c2             	mov    %rax,%rdx
  8016a7:	be 00 00 00 00       	mov    $0x0,%esi
  8016ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b1:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8016b8:	00 00 00 
  8016bb:	ff d0                	callq  *%rax
}
  8016bd:	c9                   	leaveq 
  8016be:	c3                   	retq   

00000000008016bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8016bf:	55                   	push   %rbp
  8016c0:	48 89 e5             	mov    %rsp,%rbp
  8016c3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ce:	00 
  8016cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8016ef:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8016f6:	00 00 00 
  8016f9:	ff d0                	callq  *%rax
}
  8016fb:	c9                   	leaveq 
  8016fc:	c3                   	retq   

00000000008016fd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016fd:	55                   	push   %rbp
  8016fe:	48 89 e5             	mov    %rsp,%rbp
  801701:	48 83 ec 10          	sub    $0x10,%rsp
  801705:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80170b:	48 98                	cltq   
  80170d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801714:	00 
  801715:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801721:	b9 00 00 00 00       	mov    $0x0,%ecx
  801726:	48 89 c2             	mov    %rax,%rdx
  801729:	be 01 00 00 00       	mov    $0x1,%esi
  80172e:	bf 03 00 00 00       	mov    $0x3,%edi
  801733:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  80173a:	00 00 00 
  80173d:	ff d0                	callq  *%rax
}
  80173f:	c9                   	leaveq 
  801740:	c3                   	retq   

0000000000801741 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801749:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801750:	00 
  801751:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801757:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80175d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	be 00 00 00 00       	mov    $0x0,%esi
  80176c:	bf 02 00 00 00       	mov    $0x2,%edi
  801771:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801778:	00 00 00 
  80177b:	ff d0                	callq  *%rax
}
  80177d:	c9                   	leaveq 
  80177e:	c3                   	retq   

000000000080177f <sys_yield>:

void
sys_yield(void)
{
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801787:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178e:	00 
  80178f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801795:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	be 00 00 00 00       	mov    $0x0,%esi
  8017aa:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017af:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8017b6:	00 00 00 
  8017b9:	ff d0                	callq  *%rax
}
  8017bb:	c9                   	leaveq 
  8017bc:	c3                   	retq   

00000000008017bd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017bd:	55                   	push   %rbp
  8017be:	48 89 e5             	mov    %rsp,%rbp
  8017c1:	48 83 ec 20          	sub    $0x20,%rsp
  8017c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d2:	48 63 c8             	movslq %eax,%rcx
  8017d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017dc:	48 98                	cltq   
  8017de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e5:	00 
  8017e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ec:	49 89 c8             	mov    %rcx,%r8
  8017ef:	48 89 d1             	mov    %rdx,%rcx
  8017f2:	48 89 c2             	mov    %rax,%rdx
  8017f5:	be 01 00 00 00       	mov    $0x1,%esi
  8017fa:	bf 04 00 00 00       	mov    $0x4,%edi
  8017ff:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801806:	00 00 00 
  801809:	ff d0                	callq  *%rax
}
  80180b:	c9                   	leaveq 
  80180c:	c3                   	retq   

000000000080180d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80180d:	55                   	push   %rbp
  80180e:	48 89 e5             	mov    %rsp,%rbp
  801811:	48 83 ec 30          	sub    $0x30,%rsp
  801815:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801818:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80181f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801823:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801827:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80182a:	48 63 c8             	movslq %eax,%rcx
  80182d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801831:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801834:	48 63 f0             	movslq %eax,%rsi
  801837:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80183e:	48 98                	cltq   
  801840:	48 89 0c 24          	mov    %rcx,(%rsp)
  801844:	49 89 f9             	mov    %rdi,%r9
  801847:	49 89 f0             	mov    %rsi,%r8
  80184a:	48 89 d1             	mov    %rdx,%rcx
  80184d:	48 89 c2             	mov    %rax,%rdx
  801850:	be 01 00 00 00       	mov    $0x1,%esi
  801855:	bf 05 00 00 00       	mov    $0x5,%edi
  80185a:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801861:	00 00 00 
  801864:	ff d0                	callq  *%rax
}
  801866:	c9                   	leaveq 
  801867:	c3                   	retq   

0000000000801868 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 20          	sub    $0x20,%rsp
  801870:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801873:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801877:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187e:	48 98                	cltq   
  801880:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801887:	00 
  801888:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801894:	48 89 d1             	mov    %rdx,%rcx
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	be 01 00 00 00       	mov    $0x1,%esi
  80189f:	bf 06 00 00 00       	mov    $0x6,%edi
  8018a4:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
  8018ba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018bd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c3:	48 63 d0             	movslq %eax,%rdx
  8018c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c9:	48 98                	cltq   
  8018cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d2:	00 
  8018d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018df:	48 89 d1             	mov    %rdx,%rcx
  8018e2:	48 89 c2             	mov    %rax,%rdx
  8018e5:	be 01 00 00 00       	mov    $0x1,%esi
  8018ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8018ef:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
}
  8018fb:	c9                   	leaveq 
  8018fc:	c3                   	retq   

00000000008018fd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018fd:	55                   	push   %rbp
  8018fe:	48 89 e5             	mov    %rsp,%rbp
  801901:	48 83 ec 20          	sub    $0x20,%rsp
  801905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801908:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80190c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801913:	48 98                	cltq   
  801915:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191c:	00 
  80191d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801923:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801929:	48 89 d1             	mov    %rdx,%rcx
  80192c:	48 89 c2             	mov    %rax,%rdx
  80192f:	be 01 00 00 00       	mov    $0x1,%esi
  801934:	bf 09 00 00 00       	mov    $0x9,%edi
  801939:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
}
  801945:	c9                   	leaveq 
  801946:	c3                   	retq   

0000000000801947 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801947:	55                   	push   %rbp
  801948:	48 89 e5             	mov    %rsp,%rbp
  80194b:	48 83 ec 20          	sub    $0x20,%rsp
  80194f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801952:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195d:	48 98                	cltq   
  80195f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801966:	00 
  801967:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801973:	48 89 d1             	mov    %rdx,%rcx
  801976:	48 89 c2             	mov    %rax,%rdx
  801979:	be 01 00 00 00       	mov    $0x1,%esi
  80197e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801983:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  80198a:	00 00 00 
  80198d:	ff d0                	callq  *%rax
}
  80198f:	c9                   	leaveq 
  801990:	c3                   	retq   

0000000000801991 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801991:	55                   	push   %rbp
  801992:	48 89 e5             	mov    %rsp,%rbp
  801995:	48 83 ec 20          	sub    $0x20,%rsp
  801999:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019aa:	48 63 f0             	movslq %eax,%rsi
  8019ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b4:	48 98                	cltq   
  8019b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c1:	00 
  8019c2:	49 89 f1             	mov    %rsi,%r9
  8019c5:	49 89 c8             	mov    %rcx,%r8
  8019c8:	48 89 d1             	mov    %rdx,%rcx
  8019cb:	48 89 c2             	mov    %rax,%rdx
  8019ce:	be 00 00 00 00       	mov    $0x0,%esi
  8019d3:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019d8:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 10          	sub    $0x10,%rsp
  8019ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fd:	00 
  8019fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a1c:	48 b8 e7 15 80 00 00 	movabs $0x8015e7,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 08          	sub    $0x8,%rsp
  801a32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a36:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a3a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a41:	ff ff ff 
  801a44:	48 01 d0             	add    %rdx,%rax
  801a47:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 08          	sub    $0x8,%rsp
  801a55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5d:	48 89 c7             	mov    %rax,%rdi
  801a60:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
  801a6c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a72:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 18          	sub    $0x18,%rsp
  801a80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a8b:	eb 6b                	jmp    801af8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a90:	48 98                	cltq   
  801a92:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a98:	48 c1 e0 0c          	shl    $0xc,%rax
  801a9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa4:	48 c1 e8 15          	shr    $0x15,%rax
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ab2:	01 00 00 
  801ab5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ab9:	83 e0 01             	and    $0x1,%eax
  801abc:	48 85 c0             	test   %rax,%rax
  801abf:	74 21                	je     801ae2 <fd_alloc+0x6a>
  801ac1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ac9:	48 89 c2             	mov    %rax,%rdx
  801acc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ad3:	01 00 00 
  801ad6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ada:	83 e0 01             	and    $0x1,%eax
  801add:	48 85 c0             	test   %rax,%rax
  801ae0:	75 12                	jne    801af4 <fd_alloc+0x7c>
			*fd_store = fd;
  801ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aea:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
  801af2:	eb 1a                	jmp    801b0e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801af4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801af8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801afc:	7e 8f                	jle    801a8d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801afe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b02:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b09:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	48 83 ec 20          	sub    $0x20,%rsp
  801b18:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b23:	78 06                	js     801b2b <fd_lookup+0x1b>
  801b25:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b29:	7e 07                	jle    801b32 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b30:	eb 6c                	jmp    801b9e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801b32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b35:	48 98                	cltq   
  801b37:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b3d:	48 c1 e0 0c          	shl    $0xc,%rax
  801b41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801b45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b49:	48 c1 e8 15          	shr    $0x15,%rax
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b57:	01 00 00 
  801b5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b5e:	83 e0 01             	and    $0x1,%eax
  801b61:	48 85 c0             	test   %rax,%rax
  801b64:	74 21                	je     801b87 <fd_lookup+0x77>
  801b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6a:	48 c1 e8 0c          	shr    $0xc,%rax
  801b6e:	48 89 c2             	mov    %rax,%rdx
  801b71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b78:	01 00 00 
  801b7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b7f:	83 e0 01             	and    $0x1,%eax
  801b82:	48 85 c0             	test   %rax,%rax
  801b85:	75 07                	jne    801b8e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b8c:	eb 10                	jmp    801b9e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b96:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9e:	c9                   	leaveq 
  801b9f:	c3                   	retq   

0000000000801ba0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ba0:	55                   	push   %rbp
  801ba1:	48 89 e5             	mov    %rsp,%rbp
  801ba4:	48 83 ec 30          	sub    $0x30,%rsp
  801ba8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bac:	89 f0                	mov    %esi,%eax
  801bae:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb5:	48 89 c7             	mov    %rax,%rdi
  801bb8:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bc8:	48 89 d6             	mov    %rdx,%rsi
  801bcb:	89 c7                	mov    %eax,%edi
  801bcd:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
  801bd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801be0:	78 0a                	js     801bec <fd_close+0x4c>
	    || fd != fd2)
  801be2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801be6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801bea:	74 12                	je     801bfe <fd_close+0x5e>
		return (must_exist ? r : 0);
  801bec:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801bf0:	74 05                	je     801bf7 <fd_close+0x57>
  801bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf5:	eb 05                	jmp    801bfc <fd_close+0x5c>
  801bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfc:	eb 69                	jmp    801c67 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c02:	8b 00                	mov    (%rax),%eax
  801c04:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c08:	48 89 d6             	mov    %rdx,%rsi
  801c0b:	89 c7                	mov    %eax,%edi
  801c0d:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	callq  *%rax
  801c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c20:	78 2a                	js     801c4c <fd_close+0xac>
		if (dev->dev_close)
  801c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c26:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c2a:	48 85 c0             	test   %rax,%rax
  801c2d:	74 16                	je     801c45 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801c2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c33:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c3b:	48 89 d7             	mov    %rdx,%rdi
  801c3e:	ff d0                	callq  *%rax
  801c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c43:	eb 07                	jmp    801c4c <fd_close+0xac>
		else
			r = 0;
  801c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c50:	48 89 c6             	mov    %rax,%rsi
  801c53:	bf 00 00 00 00       	mov    $0x0,%edi
  801c58:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
	return r;
  801c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c67:	c9                   	leaveq 
  801c68:	c3                   	retq   

0000000000801c69 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c69:	55                   	push   %rbp
  801c6a:	48 89 e5             	mov    %rsp,%rbp
  801c6d:	48 83 ec 20          	sub    $0x20,%rsp
  801c71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c7f:	eb 41                	jmp    801cc2 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c81:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c88:	00 00 00 
  801c8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c8e:	48 63 d2             	movslq %edx,%rdx
  801c91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c95:	8b 00                	mov    (%rax),%eax
  801c97:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c9a:	75 22                	jne    801cbe <dev_lookup+0x55>
			*dev = devtab[i];
  801c9c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ca3:	00 00 00 
  801ca6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ca9:	48 63 d2             	movslq %edx,%rdx
  801cac:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801cb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbc:	eb 60                	jmp    801d1e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801cbe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cc2:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801cc9:	00 00 00 
  801ccc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ccf:	48 63 d2             	movslq %edx,%rdx
  801cd2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd6:	48 85 c0             	test   %rax,%rax
  801cd9:	75 a6                	jne    801c81 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801cdb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ce2:	00 00 00 
  801ce5:	48 8b 00             	mov    (%rax),%rax
  801ce8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801cee:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cf1:	89 c6                	mov    %eax,%esi
  801cf3:	48 bf b0 39 80 00 00 	movabs $0x8039b0,%rdi
  801cfa:	00 00 00 
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  801d09:	00 00 00 
  801d0c:	ff d1                	callq  *%rcx
	*dev = 0;
  801d0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d12:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <close>:

int
close(int fdnum)
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 20          	sub    $0x20,%rsp
  801d28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d32:	48 89 d6             	mov    %rdx,%rsi
  801d35:	89 c7                	mov    %eax,%edi
  801d37:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d3e:	00 00 00 
  801d41:	ff d0                	callq  *%rax
  801d43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d4a:	79 05                	jns    801d51 <close+0x31>
		return r;
  801d4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4f:	eb 18                	jmp    801d69 <close+0x49>
	else
		return fd_close(fd, 1);
  801d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d55:	be 01 00 00 00       	mov    $0x1,%esi
  801d5a:	48 89 c7             	mov    %rax,%rdi
  801d5d:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <close_all>:

void
close_all(void)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7a:	eb 15                	jmp    801d91 <close_all+0x26>
		close(i);
  801d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7f:	89 c7                	mov    %eax,%edi
  801d81:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d91:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d95:	7e e5                	jle    801d7c <close_all+0x11>
		close(i);
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 40          	sub    $0x40,%rsp
  801da1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801da4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801da7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801dab:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801dae:	48 89 d6             	mov    %rdx,%rsi
  801db1:	89 c7                	mov    %eax,%edi
  801db3:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801dba:	00 00 00 
  801dbd:	ff d0                	callq  *%rax
  801dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dc6:	79 08                	jns    801dd0 <dup+0x37>
		return r;
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	e9 70 01 00 00       	jmpq   801f40 <dup+0x1a7>
	close(newfdnum);
  801dd0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801dd3:	89 c7                	mov    %eax,%edi
  801dd5:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801de1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801de4:	48 98                	cltq   
  801de6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dec:	48 c1 e0 0c          	shl    $0xc,%rax
  801df0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df8:	48 89 c7             	mov    %rax,%rdi
  801dfb:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  801e02:	00 00 00 
  801e05:	ff d0                	callq  *%rax
  801e07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e0f:	48 89 c7             	mov    %rax,%rdi
  801e12:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e26:	48 c1 e8 15          	shr    $0x15,%rax
  801e2a:	48 89 c2             	mov    %rax,%rdx
  801e2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e34:	01 00 00 
  801e37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3b:	83 e0 01             	and    $0x1,%eax
  801e3e:	48 85 c0             	test   %rax,%rax
  801e41:	74 73                	je     801eb6 <dup+0x11d>
  801e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e47:	48 c1 e8 0c          	shr    $0xc,%rax
  801e4b:	48 89 c2             	mov    %rax,%rdx
  801e4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e55:	01 00 00 
  801e58:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5c:	83 e0 01             	and    $0x1,%eax
  801e5f:	48 85 c0             	test   %rax,%rax
  801e62:	74 52                	je     801eb6 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e68:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6c:	48 89 c2             	mov    %rax,%rdx
  801e6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e76:	01 00 00 
  801e79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e82:	89 c1                	mov    %eax,%ecx
  801e84:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8c:	41 89 c8             	mov    %ecx,%r8d
  801e8f:	48 89 d1             	mov    %rdx,%rcx
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
  801e97:	48 89 c6             	mov    %rax,%rsi
  801e9a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e9f:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	callq  *%rax
  801eab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eb2:	79 02                	jns    801eb6 <dup+0x11d>
			goto err;
  801eb4:	eb 57                	jmp    801f0d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eba:	48 c1 e8 0c          	shr    $0xc,%rax
  801ebe:	48 89 c2             	mov    %rax,%rdx
  801ec1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec8:	01 00 00 
  801ecb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecf:	25 07 0e 00 00       	and    $0xe07,%eax
  801ed4:	89 c1                	mov    %eax,%ecx
  801ed6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ede:	41 89 c8             	mov    %ecx,%r8d
  801ee1:	48 89 d1             	mov    %rdx,%rcx
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee9:	48 89 c6             	mov    %rax,%rsi
  801eec:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef1:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  801ef8:	00 00 00 
  801efb:	ff d0                	callq  *%rax
  801efd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f04:	79 02                	jns    801f08 <dup+0x16f>
		goto err;
  801f06:	eb 05                	jmp    801f0d <dup+0x174>

	return newfdnum;
  801f08:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f0b:	eb 33                	jmp    801f40 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f11:	48 89 c6             	mov    %rax,%rsi
  801f14:	bf 00 00 00 00       	mov    $0x0,%edi
  801f19:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f29:	48 89 c6             	mov    %rax,%rsi
  801f2c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f31:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  801f38:	00 00 00 
  801f3b:	ff d0                	callq  *%rax
	return r;
  801f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f40:	c9                   	leaveq 
  801f41:	c3                   	retq   

0000000000801f42 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f42:	55                   	push   %rbp
  801f43:	48 89 e5             	mov    %rsp,%rbp
  801f46:	48 83 ec 40          	sub    $0x40,%rsp
  801f4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f55:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f5c:	48 89 d6             	mov    %rdx,%rsi
  801f5f:	89 c7                	mov    %eax,%edi
  801f61:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	callq  *%rax
  801f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f74:	78 24                	js     801f9a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7a:	8b 00                	mov    (%rax),%eax
  801f7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f80:	48 89 d6             	mov    %rdx,%rsi
  801f83:	89 c7                	mov    %eax,%edi
  801f85:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  801f8c:	00 00 00 
  801f8f:	ff d0                	callq  *%rax
  801f91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f98:	79 05                	jns    801f9f <read+0x5d>
		return r;
  801f9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9d:	eb 76                	jmp    802015 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa3:	8b 40 08             	mov    0x8(%rax),%eax
  801fa6:	83 e0 03             	and    $0x3,%eax
  801fa9:	83 f8 01             	cmp    $0x1,%eax
  801fac:	75 3a                	jne    801fe8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fb5:	00 00 00 
  801fb8:	48 8b 00             	mov    (%rax),%rax
  801fbb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fc1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fc4:	89 c6                	mov    %eax,%esi
  801fc6:	48 bf cf 39 80 00 00 	movabs $0x8039cf,%rdi
  801fcd:	00 00 00 
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd5:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  801fdc:	00 00 00 
  801fdf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801fe1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fe6:	eb 2d                	jmp    802015 <read+0xd3>
	}
	if (!dev->dev_read)
  801fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fec:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ff0:	48 85 c0             	test   %rax,%rax
  801ff3:	75 07                	jne    801ffc <read+0xba>
		return -E_NOT_SUPP;
  801ff5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801ffa:	eb 19                	jmp    802015 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802000:	48 8b 40 10          	mov    0x10(%rax),%rax
  802004:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802008:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80200c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802010:	48 89 cf             	mov    %rcx,%rdi
  802013:	ff d0                	callq  *%rax
}
  802015:	c9                   	leaveq 
  802016:	c3                   	retq   

0000000000802017 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802017:	55                   	push   %rbp
  802018:	48 89 e5             	mov    %rsp,%rbp
  80201b:	48 83 ec 30          	sub    $0x30,%rsp
  80201f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802022:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802026:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80202a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802031:	eb 49                	jmp    80207c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802036:	48 98                	cltq   
  802038:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80203c:	48 29 c2             	sub    %rax,%rdx
  80203f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802042:	48 63 c8             	movslq %eax,%rcx
  802045:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802049:	48 01 c1             	add    %rax,%rcx
  80204c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80204f:	48 89 ce             	mov    %rcx,%rsi
  802052:	89 c7                	mov    %eax,%edi
  802054:	48 b8 42 1f 80 00 00 	movabs $0x801f42,%rax
  80205b:	00 00 00 
  80205e:	ff d0                	callq  *%rax
  802060:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802063:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802067:	79 05                	jns    80206e <readn+0x57>
			return m;
  802069:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80206c:	eb 1c                	jmp    80208a <readn+0x73>
		if (m == 0)
  80206e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802072:	75 02                	jne    802076 <readn+0x5f>
			break;
  802074:	eb 11                	jmp    802087 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802076:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802079:	01 45 fc             	add    %eax,-0x4(%rbp)
  80207c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207f:	48 98                	cltq   
  802081:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802085:	72 ac                	jb     802033 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802087:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80208a:	c9                   	leaveq 
  80208b:	c3                   	retq   

000000000080208c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80208c:	55                   	push   %rbp
  80208d:	48 89 e5             	mov    %rsp,%rbp
  802090:	48 83 ec 40          	sub    $0x40,%rsp
  802094:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802097:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80209b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80209f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020a6:	48 89 d6             	mov    %rdx,%rsi
  8020a9:	89 c7                	mov    %eax,%edi
  8020ab:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020be:	78 24                	js     8020e4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c4:	8b 00                	mov    (%rax),%eax
  8020c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020ca:	48 89 d6             	mov    %rdx,%rsi
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e2:	79 05                	jns    8020e9 <write+0x5d>
		return r;
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e7:	eb 75                	jmp    80215e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ed:	8b 40 08             	mov    0x8(%rax),%eax
  8020f0:	83 e0 03             	and    $0x3,%eax
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	75 3a                	jne    802131 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020fe:	00 00 00 
  802101:	48 8b 00             	mov    (%rax),%rax
  802104:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80210a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80210d:	89 c6                	mov    %eax,%esi
  80210f:	48 bf eb 39 80 00 00 	movabs $0x8039eb,%rdi
  802116:	00 00 00 
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  802125:	00 00 00 
  802128:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80212a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80212f:	eb 2d                	jmp    80215e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802135:	48 8b 40 18          	mov    0x18(%rax),%rax
  802139:	48 85 c0             	test   %rax,%rax
  80213c:	75 07                	jne    802145 <write+0xb9>
		return -E_NOT_SUPP;
  80213e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802143:	eb 19                	jmp    80215e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802149:	48 8b 40 18          	mov    0x18(%rax),%rax
  80214d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802151:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802155:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802159:	48 89 cf             	mov    %rcx,%rdi
  80215c:	ff d0                	callq  *%rax
}
  80215e:	c9                   	leaveq 
  80215f:	c3                   	retq   

0000000000802160 <seek>:

int
seek(int fdnum, off_t offset)
{
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	48 83 ec 18          	sub    $0x18,%rsp
  802168:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80216b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80216e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802172:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802175:	48 89 d6             	mov    %rdx,%rsi
  802178:	89 c7                	mov    %eax,%edi
  80217a:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax
  802186:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218d:	79 05                	jns    802194 <seek+0x34>
		return r;
  80218f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802192:	eb 0f                	jmp    8021a3 <seek+0x43>
	fd->fd_offset = offset;
  802194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802198:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80219b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 30          	sub    $0x30,%rsp
  8021ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021b0:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021ba:	48 89 d6             	mov    %rdx,%rsi
  8021bd:	89 c7                	mov    %eax,%edi
  8021bf:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  8021c6:	00 00 00 
  8021c9:	ff d0                	callq  *%rax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d2:	78 24                	js     8021f8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d8:	8b 00                	mov    (%rax),%eax
  8021da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021de:	48 89 d6             	mov    %rdx,%rsi
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	callq  *%rax
  8021ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f6:	79 05                	jns    8021fd <ftruncate+0x58>
		return r;
  8021f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fb:	eb 72                	jmp    80226f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802201:	8b 40 08             	mov    0x8(%rax),%eax
  802204:	83 e0 03             	and    $0x3,%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	75 3a                	jne    802245 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80220b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802212:	00 00 00 
  802215:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802218:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80221e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802221:	89 c6                	mov    %eax,%esi
  802223:	48 bf 08 3a 80 00 00 	movabs $0x803a08,%rdi
  80222a:	00 00 00 
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
  802232:	48 b9 d9 02 80 00 00 	movabs $0x8002d9,%rcx
  802239:	00 00 00 
  80223c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80223e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802243:	eb 2a                	jmp    80226f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802249:	48 8b 40 30          	mov    0x30(%rax),%rax
  80224d:	48 85 c0             	test   %rax,%rax
  802250:	75 07                	jne    802259 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802252:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802257:	eb 16                	jmp    80226f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802261:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802265:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802268:	89 ce                	mov    %ecx,%esi
  80226a:	48 89 d7             	mov    %rdx,%rdi
  80226d:	ff d0                	callq  *%rax
}
  80226f:	c9                   	leaveq 
  802270:	c3                   	retq   

0000000000802271 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802271:	55                   	push   %rbp
  802272:	48 89 e5             	mov    %rsp,%rbp
  802275:	48 83 ec 30          	sub    $0x30,%rsp
  802279:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80227c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802280:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802284:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802287:	48 89 d6             	mov    %rdx,%rsi
  80228a:	89 c7                	mov    %eax,%edi
  80228c:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802293:	00 00 00 
  802296:	ff d0                	callq  *%rax
  802298:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229f:	78 24                	js     8022c5 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a5:	8b 00                	mov    (%rax),%eax
  8022a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ab:	48 89 d6             	mov    %rdx,%rsi
  8022ae:	89 c7                	mov    %eax,%edi
  8022b0:	48 b8 69 1c 80 00 00 	movabs $0x801c69,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
  8022bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c3:	79 05                	jns    8022ca <fstat+0x59>
		return r;
  8022c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c8:	eb 5e                	jmp    802328 <fstat+0xb7>
	if (!dev->dev_stat)
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022d2:	48 85 c0             	test   %rax,%rax
  8022d5:	75 07                	jne    8022de <fstat+0x6d>
		return -E_NOT_SUPP;
  8022d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022dc:	eb 4a                	jmp    802328 <fstat+0xb7>
	stat->st_name[0] = 0;
  8022de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022e2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8022e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022e9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8022f0:	00 00 00 
	stat->st_isdir = 0;
  8022f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022f7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8022fe:	00 00 00 
	stat->st_dev = dev;
  802301:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802305:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802309:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802314:	48 8b 40 28          	mov    0x28(%rax),%rax
  802318:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80231c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802320:	48 89 ce             	mov    %rcx,%rsi
  802323:	48 89 d7             	mov    %rdx,%rdi
  802326:	ff d0                	callq  *%rax
}
  802328:	c9                   	leaveq 
  802329:	c3                   	retq   

000000000080232a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80232a:	55                   	push   %rbp
  80232b:	48 89 e5             	mov    %rsp,%rbp
  80232e:	48 83 ec 20          	sub    $0x20,%rsp
  802332:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802336:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80233a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233e:	be 00 00 00 00       	mov    $0x0,%esi
  802343:	48 89 c7             	mov    %rax,%rdi
  802346:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  80234d:	00 00 00 
  802350:	ff d0                	callq  *%rax
  802352:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802355:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802359:	79 05                	jns    802360 <stat+0x36>
		return fd;
  80235b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235e:	eb 2f                	jmp    80238f <stat+0x65>
	r = fstat(fd, stat);
  802360:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802364:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802367:	48 89 d6             	mov    %rdx,%rsi
  80236a:	89 c7                	mov    %eax,%edi
  80236c:	48 b8 71 22 80 00 00 	movabs $0x802271,%rax
  802373:	00 00 00 
  802376:	ff d0                	callq  *%rax
  802378:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80237b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237e:	89 c7                	mov    %eax,%edi
  802380:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
	return r;
  80238c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80238f:	c9                   	leaveq 
  802390:	c3                   	retq   

0000000000802391 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802391:	55                   	push   %rbp
  802392:	48 89 e5             	mov    %rsp,%rbp
  802395:	48 83 ec 10          	sub    $0x10,%rsp
  802399:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80239c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8023a0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023a7:	00 00 00 
  8023aa:	8b 00                	mov    (%rax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	75 1d                	jne    8023cd <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8023b5:	48 b8 4b 33 80 00 00 	movabs $0x80334b,%rax
  8023bc:	00 00 00 
  8023bf:	ff d0                	callq  *%rax
  8023c1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8023c8:	00 00 00 
  8023cb:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023cd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023d4:	00 00 00 
  8023d7:	8b 00                	mov    (%rax),%eax
  8023d9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8023dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8023e1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8023e8:	00 00 00 
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 e9 32 80 00 00 	movabs $0x8032e9,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8023f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802402:	48 89 c6             	mov    %rax,%rsi
  802405:	bf 00 00 00 00       	mov    $0x0,%edi
  80240a:	48 b8 e3 31 80 00 00 	movabs $0x8031e3,%rax
  802411:	00 00 00 
  802414:	ff d0                	callq  *%rax
}
  802416:	c9                   	leaveq 
  802417:	c3                   	retq   

0000000000802418 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802418:	55                   	push   %rbp
  802419:	48 89 e5             	mov    %rsp,%rbp
  80241c:	48 83 ec 30          	sub    $0x30,%rsp
  802420:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802424:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802427:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80242e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802435:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80243c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802441:	75 08                	jne    80244b <open+0x33>
	{
		return r;
  802443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802446:	e9 f2 00 00 00       	jmpq   80253d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80244b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244f:	48 89 c7             	mov    %rax,%rdi
  802452:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  802459:	00 00 00 
  80245c:	ff d0                	callq  *%rax
  80245e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802461:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802468:	7e 0a                	jle    802474 <open+0x5c>
	{
		return -E_BAD_PATH;
  80246a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80246f:	e9 c9 00 00 00       	jmpq   80253d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802474:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80247b:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80247c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802480:	48 89 c7             	mov    %rax,%rdi
  802483:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802496:	78 09                	js     8024a1 <open+0x89>
  802498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249c:	48 85 c0             	test   %rax,%rax
  80249f:	75 08                	jne    8024a9 <open+0x91>
		{
			return r;
  8024a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a4:	e9 94 00 00 00       	jmpq   80253d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8024a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ad:	ba 00 04 00 00       	mov    $0x400,%edx
  8024b2:	48 89 c6             	mov    %rax,%rsi
  8024b5:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8024bc:	00 00 00 
  8024bf:	48 b8 20 0f 80 00 00 	movabs $0x800f20,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8024cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024d2:	00 00 00 
  8024d5:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8024d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8024de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e2:	48 89 c6             	mov    %rax,%rsi
  8024e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8024ea:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	callq  *%rax
  8024f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fd:	79 2b                	jns    80252a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8024ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802503:	be 00 00 00 00       	mov    $0x0,%esi
  802508:	48 89 c7             	mov    %rax,%rdi
  80250b:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax
  802517:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80251a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80251e:	79 05                	jns    802525 <open+0x10d>
			{
				return d;
  802520:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802523:	eb 18                	jmp    80253d <open+0x125>
			}
			return r;
  802525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802528:	eb 13                	jmp    80253d <open+0x125>
		}	
		return fd2num(fd_store);
  80252a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252e:	48 89 c7             	mov    %rax,%rdi
  802531:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80253d:	c9                   	leaveq 
  80253e:	c3                   	retq   

000000000080253f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80253f:	55                   	push   %rbp
  802540:	48 89 e5             	mov    %rsp,%rbp
  802543:	48 83 ec 10          	sub    $0x10,%rsp
  802547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254f:	8b 50 0c             	mov    0xc(%rax),%edx
  802552:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802559:	00 00 00 
  80255c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80255e:	be 00 00 00 00       	mov    $0x0,%esi
  802563:	bf 06 00 00 00       	mov    $0x6,%edi
  802568:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  80256f:	00 00 00 
  802572:	ff d0                	callq  *%rax
}
  802574:	c9                   	leaveq 
  802575:	c3                   	retq   

0000000000802576 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802576:	55                   	push   %rbp
  802577:	48 89 e5             	mov    %rsp,%rbp
  80257a:	48 83 ec 30          	sub    $0x30,%rsp
  80257e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802582:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802586:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80258a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802591:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802596:	74 07                	je     80259f <devfile_read+0x29>
  802598:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80259d:	75 07                	jne    8025a6 <devfile_read+0x30>
		return -E_INVAL;
  80259f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a4:	eb 77                	jmp    80261d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8025a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8025ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025b4:	00 00 00 
  8025b7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8025b9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025c0:	00 00 00 
  8025c3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025c7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8025cb:	be 00 00 00 00       	mov    $0x0,%esi
  8025d0:	bf 03 00 00 00       	mov    $0x3,%edi
  8025d5:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	callq  *%rax
  8025e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e8:	7f 05                	jg     8025ef <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8025ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ed:	eb 2e                	jmp    80261d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8025ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f2:	48 63 d0             	movslq %eax,%rdx
  8025f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f9:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802600:	00 00 00 
  802603:	48 89 c7             	mov    %rax,%rdi
  802606:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802612:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80261a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 30          	sub    $0x30,%rsp
  802627:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80262b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80262f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802633:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80263a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80263f:	74 07                	je     802648 <devfile_write+0x29>
  802641:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802646:	75 08                	jne    802650 <devfile_write+0x31>
		return r;
  802648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264b:	e9 9a 00 00 00       	jmpq   8026ea <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802654:	8b 50 0c             	mov    0xc(%rax),%edx
  802657:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80265e:	00 00 00 
  802661:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802663:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80266a:	00 
  80266b:	76 08                	jbe    802675 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80266d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802674:	00 
	}
	fsipcbuf.write.req_n = n;
  802675:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80267c:	00 00 00 
  80267f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802683:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802687:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80268b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268f:	48 89 c6             	mov    %rax,%rsi
  802692:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802699:	00 00 00 
  80269c:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8026a8:	be 00 00 00 00       	mov    $0x0,%esi
  8026ad:	bf 04 00 00 00       	mov    $0x4,%edi
  8026b2:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	7f 20                	jg     8026e7 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8026c7:	48 bf 2e 3a 80 00 00 	movabs $0x803a2e,%rdi
  8026ce:	00 00 00 
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8026dd:	00 00 00 
  8026e0:	ff d2                	callq  *%rdx
		return r;
  8026e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e5:	eb 03                	jmp    8026ea <devfile_write+0xcb>
	}
	return r;
  8026e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8026ea:	c9                   	leaveq 
  8026eb:	c3                   	retq   

00000000008026ec <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026ec:	55                   	push   %rbp
  8026ed:	48 89 e5             	mov    %rsp,%rbp
  8026f0:	48 83 ec 20          	sub    $0x20,%rsp
  8026f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802700:	8b 50 0c             	mov    0xc(%rax),%edx
  802703:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80270a:	00 00 00 
  80270d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80270f:	be 00 00 00 00       	mov    $0x0,%esi
  802714:	bf 05 00 00 00       	mov    $0x5,%edi
  802719:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272c:	79 05                	jns    802733 <devfile_stat+0x47>
		return r;
  80272e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802731:	eb 56                	jmp    802789 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802733:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802737:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80273e:	00 00 00 
  802741:	48 89 c7             	mov    %rax,%rdi
  802744:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802750:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802757:	00 00 00 
  80275a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802760:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802764:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80276a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802771:	00 00 00 
  802774:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80277a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80277e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802789:	c9                   	leaveq 
  80278a:	c3                   	retq   

000000000080278b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80278b:	55                   	push   %rbp
  80278c:	48 89 e5             	mov    %rsp,%rbp
  80278f:	48 83 ec 10          	sub    $0x10,%rsp
  802793:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802797:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80279a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80279e:	8b 50 0c             	mov    0xc(%rax),%edx
  8027a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027a8:	00 00 00 
  8027ab:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b4:	00 00 00 
  8027b7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027ba:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027bd:	be 00 00 00 00       	mov    $0x0,%esi
  8027c2:	bf 02 00 00 00       	mov    $0x2,%edi
  8027c7:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8027ce:	00 00 00 
  8027d1:	ff d0                	callq  *%rax
}
  8027d3:	c9                   	leaveq 
  8027d4:	c3                   	retq   

00000000008027d5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8027d5:	55                   	push   %rbp
  8027d6:	48 89 e5             	mov    %rsp,%rbp
  8027d9:	48 83 ec 10          	sub    $0x10,%rsp
  8027dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e5:	48 89 c7             	mov    %rax,%rdi
  8027e8:	48 b8 22 0e 80 00 00 	movabs $0x800e22,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
  8027f4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027f9:	7e 07                	jle    802802 <remove+0x2d>
		return -E_BAD_PATH;
  8027fb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802800:	eb 33                	jmp    802835 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802806:	48 89 c6             	mov    %rax,%rsi
  802809:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802810:	00 00 00 
  802813:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80281f:	be 00 00 00 00       	mov    $0x0,%esi
  802824:	bf 07 00 00 00       	mov    $0x7,%edi
  802829:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
}
  802835:	c9                   	leaveq 
  802836:	c3                   	retq   

0000000000802837 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802837:	55                   	push   %rbp
  802838:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80283b:	be 00 00 00 00       	mov    $0x0,%esi
  802840:	bf 08 00 00 00       	mov    $0x8,%edi
  802845:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
}
  802851:	5d                   	pop    %rbp
  802852:	c3                   	retq   

0000000000802853 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	53                   	push   %rbx
  802858:	48 83 ec 38          	sub    $0x38,%rsp
  80285c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802860:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802864:	48 89 c7             	mov    %rax,%rdi
  802867:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80286e:	00 00 00 
  802871:	ff d0                	callq  *%rax
  802873:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802876:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80287a:	0f 88 bf 01 00 00    	js     802a3f <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802884:	ba 07 04 00 00       	mov    $0x407,%edx
  802889:	48 89 c6             	mov    %rax,%rsi
  80288c:	bf 00 00 00 00       	mov    $0x0,%edi
  802891:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
  80289d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028a4:	0f 88 95 01 00 00    	js     802a3f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028aa:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8028ae:	48 89 c7             	mov    %rax,%rdi
  8028b1:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028c4:	0f 88 5d 01 00 00    	js     802a27 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ce:	ba 07 04 00 00       	mov    $0x407,%edx
  8028d3:	48 89 c6             	mov    %rax,%rsi
  8028d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028db:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax
  8028e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028ee:	0f 88 33 01 00 00    	js     802a27 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f8:	48 89 c7             	mov    %rax,%rdi
  8028fb:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802902:	00 00 00 
  802905:	ff d0                	callq  *%rax
  802907:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80290b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290f:	ba 07 04 00 00       	mov    $0x407,%edx
  802914:	48 89 c6             	mov    %rax,%rsi
  802917:	bf 00 00 00 00       	mov    $0x0,%edi
  80291c:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80292b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80292f:	79 05                	jns    802936 <pipe+0xe3>
		goto err2;
  802931:	e9 d9 00 00 00       	jmpq   802a0f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802936:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80293a:	48 89 c7             	mov    %rax,%rdi
  80293d:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	48 89 c2             	mov    %rax,%rdx
  80294c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802950:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802956:	48 89 d1             	mov    %rdx,%rcx
  802959:	ba 00 00 00 00       	mov    $0x0,%edx
  80295e:	48 89 c6             	mov    %rax,%rsi
  802961:	bf 00 00 00 00       	mov    $0x0,%edi
  802966:	48 b8 0d 18 80 00 00 	movabs $0x80180d,%rax
  80296d:	00 00 00 
  802970:	ff d0                	callq  *%rax
  802972:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802975:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802979:	79 1b                	jns    802996 <pipe+0x143>
		goto err3;
  80297b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80297c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802980:	48 89 c6             	mov    %rax,%rsi
  802983:	bf 00 00 00 00       	mov    $0x0,%edi
  802988:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax
  802994:	eb 79                	jmp    802a0f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80299a:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8029a1:	00 00 00 
  8029a4:	8b 12                	mov    (%rdx),%edx
  8029a6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8029a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8029b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b7:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8029be:	00 00 00 
  8029c1:	8b 12                	mov    (%rdx),%edx
  8029c3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8029c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8029d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029d4:	48 89 c7             	mov    %rax,%rdi
  8029d7:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
  8029e3:	89 c2                	mov    %eax,%edx
  8029e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029e9:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8029eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029ef:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8029f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f7:	48 89 c7             	mov    %rax,%rdi
  8029fa:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax
  802a06:	89 03                	mov    %eax,(%rbx)
	return 0;
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	eb 33                	jmp    802a42 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802a0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a13:	48 89 c6             	mov    %rax,%rsi
  802a16:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1b:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a2b:	48 89 c6             	mov    %rax,%rsi
  802a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a33:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	callq  *%rax
    err:
	return r;
  802a3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802a42:	48 83 c4 38          	add    $0x38,%rsp
  802a46:	5b                   	pop    %rbx
  802a47:	5d                   	pop    %rbp
  802a48:	c3                   	retq   

0000000000802a49 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802a49:	55                   	push   %rbp
  802a4a:	48 89 e5             	mov    %rsp,%rbp
  802a4d:	53                   	push   %rbx
  802a4e:	48 83 ec 28          	sub    $0x28,%rsp
  802a52:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a56:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802a5a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802a61:	00 00 00 
  802a64:	48 8b 00             	mov    (%rax),%rax
  802a67:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802a6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a74:	48 89 c7             	mov    %rax,%rdi
  802a77:	48 b8 cd 33 80 00 00 	movabs $0x8033cd,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	callq  *%rax
  802a83:	89 c3                	mov    %eax,%ebx
  802a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a89:	48 89 c7             	mov    %rax,%rdi
  802a8c:	48 b8 cd 33 80 00 00 	movabs $0x8033cd,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
  802a98:	39 c3                	cmp    %eax,%ebx
  802a9a:	0f 94 c0             	sete   %al
  802a9d:	0f b6 c0             	movzbl %al,%eax
  802aa0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802aa3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802aaa:	00 00 00 
  802aad:	48 8b 00             	mov    (%rax),%rax
  802ab0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802ab6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802ab9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802abc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802abf:	75 05                	jne    802ac6 <_pipeisclosed+0x7d>
			return ret;
  802ac1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ac4:	eb 4f                	jmp    802b15 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ac6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802acc:	74 42                	je     802b10 <_pipeisclosed+0xc7>
  802ace:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802ad2:	75 3c                	jne    802b10 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ad4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802adb:	00 00 00 
  802ade:	48 8b 00             	mov    (%rax),%rax
  802ae1:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802ae7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802aea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	48 bf 4f 3a 80 00 00 	movabs $0x803a4f,%rdi
  802af6:	00 00 00 
  802af9:	b8 00 00 00 00       	mov    $0x0,%eax
  802afe:	49 b8 d9 02 80 00 00 	movabs $0x8002d9,%r8
  802b05:	00 00 00 
  802b08:	41 ff d0             	callq  *%r8
	}
  802b0b:	e9 4a ff ff ff       	jmpq   802a5a <_pipeisclosed+0x11>
  802b10:	e9 45 ff ff ff       	jmpq   802a5a <_pipeisclosed+0x11>
}
  802b15:	48 83 c4 28          	add    $0x28,%rsp
  802b19:	5b                   	pop    %rbx
  802b1a:	5d                   	pop    %rbp
  802b1b:	c3                   	retq   

0000000000802b1c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802b1c:	55                   	push   %rbp
  802b1d:	48 89 e5             	mov    %rsp,%rbp
  802b20:	48 83 ec 30          	sub    $0x30,%rsp
  802b24:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b27:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b2b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b2e:	48 89 d6             	mov    %rdx,%rsi
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
  802b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b46:	79 05                	jns    802b4d <pipeisclosed+0x31>
		return r;
  802b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4b:	eb 31                	jmp    802b7e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	48 89 c7             	mov    %rax,%rdi
  802b54:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802b5b:	00 00 00 
  802b5e:	ff d0                	callq  *%rax
  802b60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b6c:	48 89 d6             	mov    %rdx,%rsi
  802b6f:	48 89 c7             	mov    %rax,%rdi
  802b72:	48 b8 49 2a 80 00 00 	movabs $0x802a49,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	callq  *%rax
}
  802b7e:	c9                   	leaveq 
  802b7f:	c3                   	retq   

0000000000802b80 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	48 83 ec 40          	sub    $0x40,%rsp
  802b88:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b90:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802b94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b98:	48 89 c7             	mov    %rax,%rdi
  802b9b:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802bab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802bb3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802bba:	00 
  802bbb:	e9 92 00 00 00       	jmpq   802c52 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802bc0:	eb 41                	jmp    802c03 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802bc2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802bc7:	74 09                	je     802bd2 <devpipe_read+0x52>
				return i;
  802bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcd:	e9 92 00 00 00       	jmpq   802c64 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bda:	48 89 d6             	mov    %rdx,%rsi
  802bdd:	48 89 c7             	mov    %rax,%rdi
  802be0:	48 b8 49 2a 80 00 00 	movabs $0x802a49,%rax
  802be7:	00 00 00 
  802bea:	ff d0                	callq  *%rax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 07                	je     802bf7 <devpipe_read+0x77>
				return 0;
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf5:	eb 6d                	jmp    802c64 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802bf7:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c07:	8b 10                	mov    (%rax),%edx
  802c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0d:	8b 40 04             	mov    0x4(%rax),%eax
  802c10:	39 c2                	cmp    %eax,%edx
  802c12:	74 ae                	je     802bc2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c1c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802c20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c24:	8b 00                	mov    (%rax),%eax
  802c26:	99                   	cltd   
  802c27:	c1 ea 1b             	shr    $0x1b,%edx
  802c2a:	01 d0                	add    %edx,%eax
  802c2c:	83 e0 1f             	and    $0x1f,%eax
  802c2f:	29 d0                	sub    %edx,%eax
  802c31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c35:	48 98                	cltq   
  802c37:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802c3c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c42:	8b 00                	mov    (%rax),%eax
  802c44:	8d 50 01             	lea    0x1(%rax),%edx
  802c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c4d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c56:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802c5a:	0f 82 60 ff ff ff    	jb     802bc0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c64:	c9                   	leaveq 
  802c65:	c3                   	retq   

0000000000802c66 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c66:	55                   	push   %rbp
  802c67:	48 89 e5             	mov    %rsp,%rbp
  802c6a:	48 83 ec 40          	sub    $0x40,%rsp
  802c6e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c72:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c76:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7e:	48 89 c7             	mov    %rax,%rdi
  802c81:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
  802c8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802c91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802c99:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ca0:	00 
  802ca1:	e9 8e 00 00 00       	jmpq   802d34 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ca6:	eb 31                	jmp    802cd9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ca8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb0:	48 89 d6             	mov    %rdx,%rsi
  802cb3:	48 89 c7             	mov    %rax,%rdi
  802cb6:	48 b8 49 2a 80 00 00 	movabs $0x802a49,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 07                	je     802ccd <devpipe_write+0x67>
				return 0;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccb:	eb 79                	jmp    802d46 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ccd:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cdd:	8b 40 04             	mov    0x4(%rax),%eax
  802ce0:	48 63 d0             	movslq %eax,%rdx
  802ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce7:	8b 00                	mov    (%rax),%eax
  802ce9:	48 98                	cltq   
  802ceb:	48 83 c0 20          	add    $0x20,%rax
  802cef:	48 39 c2             	cmp    %rax,%rdx
  802cf2:	73 b4                	jae    802ca8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf8:	8b 40 04             	mov    0x4(%rax),%eax
  802cfb:	99                   	cltd   
  802cfc:	c1 ea 1b             	shr    $0x1b,%edx
  802cff:	01 d0                	add    %edx,%eax
  802d01:	83 e0 1f             	and    $0x1f,%eax
  802d04:	29 d0                	sub    %edx,%eax
  802d06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d0a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d0e:	48 01 ca             	add    %rcx,%rdx
  802d11:	0f b6 0a             	movzbl (%rdx),%ecx
  802d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d18:	48 98                	cltq   
  802d1a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d22:	8b 40 04             	mov    0x4(%rax),%eax
  802d25:	8d 50 01             	lea    0x1(%rax),%edx
  802d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d2f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d38:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d3c:	0f 82 64 ff ff ff    	jb     802ca6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d46:	c9                   	leaveq 
  802d47:	c3                   	retq   

0000000000802d48 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802d48:	55                   	push   %rbp
  802d49:	48 89 e5             	mov    %rsp,%rbp
  802d4c:	48 83 ec 20          	sub    $0x20,%rsp
  802d50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5c:	48 89 c7             	mov    %rax,%rdi
  802d5f:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
  802d6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802d6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d73:	48 be 62 3a 80 00 00 	movabs $0x803a62,%rsi
  802d7a:	00 00 00 
  802d7d:	48 89 c7             	mov    %rax,%rdi
  802d80:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d90:	8b 50 04             	mov    0x4(%rax),%edx
  802d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d97:	8b 00                	mov    (%rax),%eax
  802d99:	29 c2                	sub    %eax,%edx
  802d9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d9f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802da5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802db0:	00 00 00 
	stat->st_dev = &devpipe;
  802db3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802db7:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802dbe:	00 00 00 
  802dc1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dcd:	c9                   	leaveq 
  802dce:	c3                   	retq   

0000000000802dcf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802dcf:	55                   	push   %rbp
  802dd0:	48 89 e5             	mov    %rsp,%rbp
  802dd3:	48 83 ec 10          	sub    $0x10,%rsp
  802dd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddf:	48 89 c6             	mov    %rax,%rsi
  802de2:	bf 00 00 00 00       	mov    $0x0,%edi
  802de7:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802df3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df7:	48 89 c7             	mov    %rax,%rdi
  802dfa:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
  802e06:	48 89 c6             	mov    %rax,%rsi
  802e09:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0e:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  802e15:	00 00 00 
  802e18:	ff d0                	callq  *%rax
}
  802e1a:	c9                   	leaveq 
  802e1b:	c3                   	retq   

0000000000802e1c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	48 83 ec 20          	sub    $0x20,%rsp
  802e24:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802e27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802e2d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802e31:	be 01 00 00 00       	mov    $0x1,%esi
  802e36:	48 89 c7             	mov    %rax,%rdi
  802e39:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  802e40:	00 00 00 
  802e43:	ff d0                	callq  *%rax
}
  802e45:	c9                   	leaveq 
  802e46:	c3                   	retq   

0000000000802e47 <getchar>:

int
getchar(void)
{
  802e47:	55                   	push   %rbp
  802e48:	48 89 e5             	mov    %rsp,%rbp
  802e4b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e4f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802e53:	ba 01 00 00 00       	mov    $0x1,%edx
  802e58:	48 89 c6             	mov    %rax,%rsi
  802e5b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e60:	48 b8 42 1f 80 00 00 	movabs $0x801f42,%rax
  802e67:	00 00 00 
  802e6a:	ff d0                	callq  *%rax
  802e6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802e6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e73:	79 05                	jns    802e7a <getchar+0x33>
		return r;
  802e75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e78:	eb 14                	jmp    802e8e <getchar+0x47>
	if (r < 1)
  802e7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7e:	7f 07                	jg     802e87 <getchar+0x40>
		return -E_EOF;
  802e80:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802e85:	eb 07                	jmp    802e8e <getchar+0x47>
	return c;
  802e87:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802e8b:	0f b6 c0             	movzbl %al,%eax
}
  802e8e:	c9                   	leaveq 
  802e8f:	c3                   	retq   

0000000000802e90 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802e90:	55                   	push   %rbp
  802e91:	48 89 e5             	mov    %rsp,%rbp
  802e94:	48 83 ec 20          	sub    $0x20,%rsp
  802e98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea2:	48 89 d6             	mov    %rdx,%rsi
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
  802eb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eba:	79 05                	jns    802ec1 <iscons+0x31>
		return r;
  802ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebf:	eb 1a                	jmp    802edb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802ec1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec5:	8b 10                	mov    (%rax),%edx
  802ec7:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802ece:	00 00 00 
  802ed1:	8b 00                	mov    (%rax),%eax
  802ed3:	39 c2                	cmp    %eax,%edx
  802ed5:	0f 94 c0             	sete   %al
  802ed8:	0f b6 c0             	movzbl %al,%eax
}
  802edb:	c9                   	leaveq 
  802edc:	c3                   	retq   

0000000000802edd <opencons>:

int
opencons(void)
{
  802edd:	55                   	push   %rbp
  802ede:	48 89 e5             	mov    %rsp,%rbp
  802ee1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ee5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ee9:	48 89 c7             	mov    %rax,%rdi
  802eec:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
  802ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eff:	79 05                	jns    802f06 <opencons+0x29>
		return r;
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	eb 5b                	jmp    802f61 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0a:	ba 07 04 00 00       	mov    $0x407,%edx
  802f0f:	48 89 c6             	mov    %rax,%rsi
  802f12:	bf 00 00 00 00       	mov    $0x0,%edi
  802f17:	48 b8 bd 17 80 00 00 	movabs $0x8017bd,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
  802f23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2a:	79 05                	jns    802f31 <opencons+0x54>
		return r;
  802f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2f:	eb 30                	jmp    802f61 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f35:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  802f3c:	00 00 00 
  802f3f:	8b 12                	mov    (%rdx),%edx
  802f41:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f47:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f52:	48 89 c7             	mov    %rax,%rdi
  802f55:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
}
  802f61:	c9                   	leaveq 
  802f62:	c3                   	retq   

0000000000802f63 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f63:	55                   	push   %rbp
  802f64:	48 89 e5             	mov    %rsp,%rbp
  802f67:	48 83 ec 30          	sub    $0x30,%rsp
  802f6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f73:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802f77:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f7c:	75 07                	jne    802f85 <devcons_read+0x22>
		return 0;
  802f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f83:	eb 4b                	jmp    802fd0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802f85:	eb 0c                	jmp    802f93 <devcons_read+0x30>
		sys_yield();
  802f87:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802f93:	48 b8 bf 16 80 00 00 	movabs $0x8016bf,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
  802f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa6:	74 df                	je     802f87 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802fa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fac:	79 05                	jns    802fb3 <devcons_read+0x50>
		return c;
  802fae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb1:	eb 1d                	jmp    802fd0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802fb3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802fb7:	75 07                	jne    802fc0 <devcons_read+0x5d>
		return 0;
  802fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbe:	eb 10                	jmp    802fd0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  802fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc3:	89 c2                	mov    %eax,%edx
  802fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc9:	88 10                	mov    %dl,(%rax)
	return 1;
  802fcb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802fd0:	c9                   	leaveq 
  802fd1:	c3                   	retq   

0000000000802fd2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fd2:	55                   	push   %rbp
  802fd3:	48 89 e5             	mov    %rsp,%rbp
  802fd6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802fdd:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802fe4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802feb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ff2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ff9:	eb 76                	jmp    803071 <devcons_write+0x9f>
		m = n - tot;
  802ffb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803002:	89 c2                	mov    %eax,%edx
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	29 c2                	sub    %eax,%edx
  803009:	89 d0                	mov    %edx,%eax
  80300b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80300e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803011:	83 f8 7f             	cmp    $0x7f,%eax
  803014:	76 07                	jbe    80301d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803016:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80301d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803020:	48 63 d0             	movslq %eax,%rdx
  803023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803026:	48 63 c8             	movslq %eax,%rcx
  803029:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803030:	48 01 c1             	add    %rax,%rcx
  803033:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80303a:	48 89 ce             	mov    %rcx,%rsi
  80303d:	48 89 c7             	mov    %rax,%rdi
  803040:	48 b8 b2 11 80 00 00 	movabs $0x8011b2,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80304c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80304f:	48 63 d0             	movslq %eax,%rdx
  803052:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803059:	48 89 d6             	mov    %rdx,%rsi
  80305c:	48 89 c7             	mov    %rax,%rdi
  80305f:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80306b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80306e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803074:	48 98                	cltq   
  803076:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80307d:	0f 82 78 ff ff ff    	jb     802ffb <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803083:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803086:	c9                   	leaveq 
  803087:	c3                   	retq   

0000000000803088 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803088:	55                   	push   %rbp
  803089:	48 89 e5             	mov    %rsp,%rbp
  80308c:	48 83 ec 08          	sub    $0x8,%rsp
  803090:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803099:	c9                   	leaveq 
  80309a:	c3                   	retq   

000000000080309b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80309b:	55                   	push   %rbp
  80309c:	48 89 e5             	mov    %rsp,%rbp
  80309f:	48 83 ec 10          	sub    $0x10,%rsp
  8030a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	48 be 6e 3a 80 00 00 	movabs $0x803a6e,%rsi
  8030b6:	00 00 00 
  8030b9:	48 89 c7             	mov    %rax,%rdi
  8030bc:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  8030c3:	00 00 00 
  8030c6:	ff d0                	callq  *%rax
	return 0;
  8030c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030cd:	c9                   	leaveq 
  8030ce:	c3                   	retq   

00000000008030cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8030cf:	55                   	push   %rbp
  8030d0:	48 89 e5             	mov    %rsp,%rbp
  8030d3:	53                   	push   %rbx
  8030d4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8030db:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8030e2:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8030e8:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8030ef:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8030f6:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8030fd:	84 c0                	test   %al,%al
  8030ff:	74 23                	je     803124 <_panic+0x55>
  803101:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803108:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80310c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803110:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803114:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803118:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80311c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803120:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803124:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80312b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803132:	00 00 00 
  803135:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80313c:	00 00 00 
  80313f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803143:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80314a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803151:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803158:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80315f:	00 00 00 
  803162:	48 8b 18             	mov    (%rax),%rbx
  803165:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
  803171:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803177:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80317e:	41 89 c8             	mov    %ecx,%r8d
  803181:	48 89 d1             	mov    %rdx,%rcx
  803184:	48 89 da             	mov    %rbx,%rdx
  803187:	89 c6                	mov    %eax,%esi
  803189:	48 bf 78 3a 80 00 00 	movabs $0x803a78,%rdi
  803190:	00 00 00 
  803193:	b8 00 00 00 00       	mov    $0x0,%eax
  803198:	49 b9 d9 02 80 00 00 	movabs $0x8002d9,%r9
  80319f:	00 00 00 
  8031a2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8031a5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8031ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8031b3:	48 89 d6             	mov    %rdx,%rsi
  8031b6:	48 89 c7             	mov    %rax,%rdi
  8031b9:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
	cprintf("\n");
  8031c5:	48 bf 9b 3a 80 00 00 	movabs $0x803a9b,%rdi
  8031cc:	00 00 00 
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d4:	48 ba d9 02 80 00 00 	movabs $0x8002d9,%rdx
  8031db:	00 00 00 
  8031de:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8031e0:	cc                   	int3   
  8031e1:	eb fd                	jmp    8031e0 <_panic+0x111>

00000000008031e3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8031e3:	55                   	push   %rbp
  8031e4:	48 89 e5             	mov    %rsp,%rbp
  8031e7:	48 83 ec 30          	sub    $0x30,%rsp
  8031eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8031f7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8031fe:	00 00 00 
  803201:	48 8b 00             	mov    (%rax),%rax
  803204:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	75 3c                	jne    80324a <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80320e:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
  80321a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80321f:	48 63 d0             	movslq %eax,%rdx
  803222:	48 89 d0             	mov    %rdx,%rax
  803225:	48 c1 e0 03          	shl    $0x3,%rax
  803229:	48 01 d0             	add    %rdx,%rax
  80322c:	48 c1 e0 05          	shl    $0x5,%rax
  803230:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803237:	00 00 00 
  80323a:	48 01 c2             	add    %rax,%rdx
  80323d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803244:	00 00 00 
  803247:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80324a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80324f:	75 0e                	jne    80325f <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803251:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803258:	00 00 00 
  80325b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80325f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803263:	48 89 c7             	mov    %rax,%rdi
  803266:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
  803272:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803275:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803279:	79 19                	jns    803294 <ipc_recv+0xb1>
		*from_env_store = 0;
  80327b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803289:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80328f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803292:	eb 53                	jmp    8032e7 <ipc_recv+0x104>
	}
	if(from_env_store)
  803294:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803299:	74 19                	je     8032b4 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80329b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032a2:	00 00 00 
  8032a5:	48 8b 00             	mov    (%rax),%rax
  8032a8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8032ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b2:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8032b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032b9:	74 19                	je     8032d4 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8032bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032c2:	00 00 00 
  8032c5:	48 8b 00             	mov    (%rax),%rax
  8032c8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8032ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d2:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8032d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032db:	00 00 00 
  8032de:	48 8b 00             	mov    (%rax),%rax
  8032e1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8032e7:	c9                   	leaveq 
  8032e8:	c3                   	retq   

00000000008032e9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8032e9:	55                   	push   %rbp
  8032ea:	48 89 e5             	mov    %rsp,%rbp
  8032ed:	48 83 ec 30          	sub    $0x30,%rsp
  8032f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8032f7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8032fb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8032fe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803303:	75 0e                	jne    803313 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803305:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80330c:	00 00 00 
  80330f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803313:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803316:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803319:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80331d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803320:	89 c7                	mov    %eax,%edi
  803322:	48 b8 91 19 80 00 00 	movabs $0x801991,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
  80332e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803331:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803335:	75 0c                	jne    803343 <ipc_send+0x5a>
			sys_yield();
  803337:	48 b8 7f 17 80 00 00 	movabs $0x80177f,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803343:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803347:	74 ca                	je     803313 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803349:	c9                   	leaveq 
  80334a:	c3                   	retq   

000000000080334b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80334b:	55                   	push   %rbp
  80334c:	48 89 e5             	mov    %rsp,%rbp
  80334f:	48 83 ec 14          	sub    $0x14,%rsp
  803353:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80335d:	eb 5e                	jmp    8033bd <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80335f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803366:	00 00 00 
  803369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336c:	48 63 d0             	movslq %eax,%rdx
  80336f:	48 89 d0             	mov    %rdx,%rax
  803372:	48 c1 e0 03          	shl    $0x3,%rax
  803376:	48 01 d0             	add    %rdx,%rax
  803379:	48 c1 e0 05          	shl    $0x5,%rax
  80337d:	48 01 c8             	add    %rcx,%rax
  803380:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803386:	8b 00                	mov    (%rax),%eax
  803388:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80338b:	75 2c                	jne    8033b9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80338d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803394:	00 00 00 
  803397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339a:	48 63 d0             	movslq %eax,%rdx
  80339d:	48 89 d0             	mov    %rdx,%rax
  8033a0:	48 c1 e0 03          	shl    $0x3,%rax
  8033a4:	48 01 d0             	add    %rdx,%rax
  8033a7:	48 c1 e0 05          	shl    $0x5,%rax
  8033ab:	48 01 c8             	add    %rcx,%rax
  8033ae:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8033b4:	8b 40 08             	mov    0x8(%rax),%eax
  8033b7:	eb 12                	jmp    8033cb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8033b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8033c4:	7e 99                	jle    80335f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8033c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033cb:	c9                   	leaveq 
  8033cc:	c3                   	retq   

00000000008033cd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033cd:	55                   	push   %rbp
  8033ce:	48 89 e5             	mov    %rsp,%rbp
  8033d1:	48 83 ec 18          	sub    $0x18,%rsp
  8033d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8033d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033dd:	48 c1 e8 15          	shr    $0x15,%rax
  8033e1:	48 89 c2             	mov    %rax,%rdx
  8033e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8033eb:	01 00 00 
  8033ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033f2:	83 e0 01             	and    $0x1,%eax
  8033f5:	48 85 c0             	test   %rax,%rax
  8033f8:	75 07                	jne    803401 <pageref+0x34>
		return 0;
  8033fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ff:	eb 53                	jmp    803454 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803405:	48 c1 e8 0c          	shr    $0xc,%rax
  803409:	48 89 c2             	mov    %rax,%rdx
  80340c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803413:	01 00 00 
  803416:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80341a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80341e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803422:	83 e0 01             	and    $0x1,%eax
  803425:	48 85 c0             	test   %rax,%rax
  803428:	75 07                	jne    803431 <pageref+0x64>
		return 0;
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
  80342f:	eb 23                	jmp    803454 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803435:	48 c1 e8 0c          	shr    $0xc,%rax
  803439:	48 89 c2             	mov    %rax,%rdx
  80343c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803443:	00 00 00 
  803446:	48 c1 e2 04          	shl    $0x4,%rdx
  80344a:	48 01 d0             	add    %rdx,%rax
  80344d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803451:	0f b7 c0             	movzwl %ax,%eax
}
  803454:	c9                   	leaveq 
  803455:	c3                   	retq   
