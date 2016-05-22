
obj/user/fairness.debug:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf 80 34 80 00 00 	movabs $0x803480,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf 91 34 80 00 00 	movabs $0x803491,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80012d:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013e:	48 63 d0             	movslq %eax,%rdx
  800141:	48 89 d0             	mov    %rdx,%rax
  800144:	48 c1 e0 03          	shl    $0x3,%rax
  800148:	48 01 d0             	add    %rdx,%rax
  80014b:	48 c1 e0 05          	shl    $0x5,%rax
  80014f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800156:	00 00 00 
  800159:	48 01 c2             	add    %rax,%rdx
  80015c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800163:	00 00 00 
  800166:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016d:	7e 14                	jle    800183 <libmain+0x65>
		binaryname = argv[0];
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	48 8b 10             	mov    (%rax),%rdx
  800176:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80017d:	00 00 00 
  800180:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800183:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	48 89 d6             	mov    %rdx,%rsi
  80018d:	89 c7                	mov    %eax,%edi
  80018f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80019b:	48 b8 a9 01 80 00 00 	movabs $0x8001a9,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	callq  *%rax
}
  8001a7:	c9                   	leaveq 
  8001a8:	c3                   	retq   

00000000008001a9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a9:	55                   	push   %rbp
  8001aa:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ad:	48 b8 6d 1f 80 00 00 	movabs $0x801f6d,%rax
  8001b4:	00 00 00 
  8001b7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001be:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax

}
  8001ca:	5d                   	pop    %rbp
  8001cb:	c3                   	retq   

00000000008001cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	8b 00                	mov    (%rax),%eax
  8001e1:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e8:	89 0a                	mov    %ecx,(%rdx)
  8001ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ed:	89 d1                	mov    %edx,%ecx
  8001ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f3:	48 98                	cltq   
  8001f5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fd:	8b 00                	mov    (%rax),%eax
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	75 2c                	jne    800232 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	8b 00                	mov    (%rax),%eax
  80020c:	48 98                	cltq   
  80020e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800212:	48 83 c2 08          	add    $0x8,%rdx
  800216:	48 89 c6             	mov    %rax,%rsi
  800219:	48 89 d7             	mov    %rdx,%rdi
  80021c:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
		b->idx = 0;
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800236:	8b 40 04             	mov    0x4(%rax),%eax
  800239:	8d 50 01             	lea    0x1(%rax),%edx
  80023c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800240:	89 50 04             	mov    %edx,0x4(%rax)
}
  800243:	c9                   	leaveq 
  800244:	c3                   	retq   

0000000000800245 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
  800249:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800250:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800257:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80025e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800265:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80026c:	48 8b 0a             	mov    (%rdx),%rcx
  80026f:	48 89 08             	mov    %rcx,(%rax)
  800272:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800276:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80027a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80027e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800293:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800296:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80029d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	48 bf cc 01 80 00 00 	movabs $0x8001cc,%rdi
  8002b5:	00 00 00 
  8002b8:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002c4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002ca:	48 98                	cltq   
  8002cc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d3:	48 83 c2 08          	add    $0x8,%rdx
  8002d7:	48 89 c6             	mov    %rax,%rsi
  8002da:	48 89 d7             	mov    %rdx,%rdi
  8002dd:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002ef:	c9                   	leaveq 
  8002f0:	c3                   	retq   

00000000008002f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f1:	55                   	push   %rbp
  8002f2:	48 89 e5             	mov    %rsp,%rbp
  8002f5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002fc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800303:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80030a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800311:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800318:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80031f:	84 c0                	test   %al,%al
  800321:	74 20                	je     800343 <cprintf+0x52>
  800323:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800327:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80032b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80032f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800333:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800337:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80033b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80033f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800343:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80034a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800351:	00 00 00 
  800354:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80035b:	00 00 00 
  80035e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800362:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800369:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800370:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800377:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80037e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800385:	48 8b 0a             	mov    (%rdx),%rcx
  800388:	48 89 08             	mov    %rcx,(%rax)
  80038b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80038f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800393:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800397:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80039b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003a9:	48 89 d6             	mov    %rdx,%rsi
  8003ac:	48 89 c7             	mov    %rax,%rdi
  8003af:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  8003b6:	00 00 00 
  8003b9:	ff d0                	callq  *%rax
  8003bb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003c1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003c7:	c9                   	leaveq 
  8003c8:	c3                   	retq   

00000000008003c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	53                   	push   %rbx
  8003ce:	48 83 ec 38          	sub    $0x38,%rsp
  8003d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003de:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003e5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003e9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003f0:	77 3b                	ja     80042d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003f5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003f9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800400:	ba 00 00 00 00       	mov    $0x0,%edx
  800405:	48 f7 f3             	div    %rbx
  800408:	48 89 c2             	mov    %rax,%rdx
  80040b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80040e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800411:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800419:	41 89 f9             	mov    %edi,%r9d
  80041c:	48 89 c7             	mov    %rax,%rdi
  80041f:	48 b8 c9 03 80 00 00 	movabs $0x8003c9,%rax
  800426:	00 00 00 
  800429:	ff d0                	callq  *%rax
  80042b:	eb 1e                	jmp    80044b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042d:	eb 12                	jmp    800441 <printnum+0x78>
			putch(padc, putdat);
  80042f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800433:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 89 ce             	mov    %rcx,%rsi
  80043d:	89 d7                	mov    %edx,%edi
  80043f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800441:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800445:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800449:	7f e4                	jg     80042f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80044e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	48 f7 f1             	div    %rcx
  80045a:	48 89 d0             	mov    %rdx,%rax
  80045d:	48 ba 88 36 80 00 00 	movabs $0x803688,%rdx
  800464:	00 00 00 
  800467:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80046b:	0f be d0             	movsbl %al,%edx
  80046e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 d7                	mov    %edx,%edi
  80047b:	ff d0                	callq  *%rax
}
  80047d:	48 83 c4 38          	add    $0x38,%rsp
  800481:	5b                   	pop    %rbx
  800482:	5d                   	pop    %rbp
  800483:	c3                   	retq   

0000000000800484 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800484:	55                   	push   %rbp
  800485:	48 89 e5             	mov    %rsp,%rbp
  800488:	48 83 ec 1c          	sub    $0x1c,%rsp
  80048c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800490:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800493:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800497:	7e 52                	jle    8004eb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	8b 00                	mov    (%rax),%eax
  80049f:	83 f8 30             	cmp    $0x30,%eax
  8004a2:	73 24                	jae    8004c8 <getuint+0x44>
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	8b 00                	mov    (%rax),%eax
  8004b2:	89 c0                	mov    %eax,%eax
  8004b4:	48 01 d0             	add    %rdx,%rax
  8004b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bb:	8b 12                	mov    (%rdx),%edx
  8004bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c4:	89 0a                	mov    %ecx,(%rdx)
  8004c6:	eb 17                	jmp    8004df <getuint+0x5b>
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d0:	48 89 d0             	mov    %rdx,%rax
  8004d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004df:	48 8b 00             	mov    (%rax),%rax
  8004e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004e6:	e9 a3 00 00 00       	jmpq   80058e <getuint+0x10a>
	else if (lflag)
  8004eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004ef:	74 4f                	je     800540 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	8b 00                	mov    (%rax),%eax
  8004f7:	83 f8 30             	cmp    $0x30,%eax
  8004fa:	73 24                	jae    800520 <getuint+0x9c>
  8004fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800500:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	89 c0                	mov    %eax,%eax
  80050c:	48 01 d0             	add    %rdx,%rax
  80050f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800513:	8b 12                	mov    (%rdx),%edx
  800515:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051c:	89 0a                	mov    %ecx,(%rdx)
  80051e:	eb 17                	jmp    800537 <getuint+0xb3>
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800528:	48 89 d0             	mov    %rdx,%rax
  80052b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80052f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800533:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800537:	48 8b 00             	mov    (%rax),%rax
  80053a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80053e:	eb 4e                	jmp    80058e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	83 f8 30             	cmp    $0x30,%eax
  800549:	73 24                	jae    80056f <getuint+0xeb>
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800557:	8b 00                	mov    (%rax),%eax
  800559:	89 c0                	mov    %eax,%eax
  80055b:	48 01 d0             	add    %rdx,%rax
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	8b 12                	mov    (%rdx),%edx
  800564:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	89 0a                	mov    %ecx,(%rdx)
  80056d:	eb 17                	jmp    800586 <getuint+0x102>
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800577:	48 89 d0             	mov    %rdx,%rax
  80057a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800582:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80058e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800592:	c9                   	leaveq 
  800593:	c3                   	retq   

0000000000800594 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 83 ec 1c          	sub    $0x1c,%rsp
  80059c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005a7:	7e 52                	jle    8005fb <getint+0x67>
		x=va_arg(*ap, long long);
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	83 f8 30             	cmp    $0x30,%eax
  8005b2:	73 24                	jae    8005d8 <getint+0x44>
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	8b 00                	mov    (%rax),%eax
  8005c2:	89 c0                	mov    %eax,%eax
  8005c4:	48 01 d0             	add    %rdx,%rax
  8005c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cb:	8b 12                	mov    (%rdx),%edx
  8005cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d4:	89 0a                	mov    %ecx,(%rdx)
  8005d6:	eb 17                	jmp    8005ef <getint+0x5b>
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e0:	48 89 d0             	mov    %rdx,%rax
  8005e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ef:	48 8b 00             	mov    (%rax),%rax
  8005f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005f6:	e9 a3 00 00 00       	jmpq   80069e <getint+0x10a>
	else if (lflag)
  8005fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ff:	74 4f                	je     800650 <getint+0xbc>
		x=va_arg(*ap, long);
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	83 f8 30             	cmp    $0x30,%eax
  80060a:	73 24                	jae    800630 <getint+0x9c>
  80060c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800610:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	89 c0                	mov    %eax,%eax
  80061c:	48 01 d0             	add    %rdx,%rax
  80061f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800623:	8b 12                	mov    (%rdx),%edx
  800625:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	89 0a                	mov    %ecx,(%rdx)
  80062e:	eb 17                	jmp    800647 <getint+0xb3>
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800638:	48 89 d0             	mov    %rdx,%rax
  80063b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800643:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800647:	48 8b 00             	mov    (%rax),%rax
  80064a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80064e:	eb 4e                	jmp    80069e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	83 f8 30             	cmp    $0x30,%eax
  800659:	73 24                	jae    80067f <getint+0xeb>
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	8b 00                	mov    (%rax),%eax
  800669:	89 c0                	mov    %eax,%eax
  80066b:	48 01 d0             	add    %rdx,%rax
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	8b 12                	mov    (%rdx),%edx
  800674:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067b:	89 0a                	mov    %ecx,(%rdx)
  80067d:	eb 17                	jmp    800696 <getint+0x102>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800687:	48 89 d0             	mov    %rdx,%rax
  80068a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800692:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800696:	8b 00                	mov    (%rax),%eax
  800698:	48 98                	cltq   
  80069a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80069e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a2:	c9                   	leaveq 
  8006a3:	c3                   	retq   

00000000008006a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a4:	55                   	push   %rbp
  8006a5:	48 89 e5             	mov    %rsp,%rbp
  8006a8:	41 54                	push   %r12
  8006aa:	53                   	push   %rbx
  8006ab:	48 83 ec 60          	sub    $0x60,%rsp
  8006af:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006b7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006bf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006c7:	48 8b 0a             	mov    (%rdx),%rcx
  8006ca:	48 89 08             	mov    %rcx,(%rax)
  8006cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006dd:	eb 17                	jmp    8006f6 <vprintfmt+0x52>
			if (ch == '\0')
  8006df:	85 db                	test   %ebx,%ebx
  8006e1:	0f 84 cc 04 00 00    	je     800bb3 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ef:	48 89 d6             	mov    %rdx,%rsi
  8006f2:	89 df                	mov    %ebx,%edi
  8006f4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800702:	0f b6 00             	movzbl (%rax),%eax
  800705:	0f b6 d8             	movzbl %al,%ebx
  800708:	83 fb 25             	cmp    $0x25,%ebx
  80070b:	75 d2                	jne    8006df <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80070d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800711:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800718:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80071f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800726:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800731:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800735:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800739:	0f b6 00             	movzbl (%rax),%eax
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800742:	83 f8 55             	cmp    $0x55,%eax
  800745:	0f 87 34 04 00 00    	ja     800b7f <vprintfmt+0x4db>
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800754:	00 
  800755:	48 b8 b0 36 80 00 00 	movabs $0x8036b0,%rax
  80075c:	00 00 00 
  80075f:	48 01 d0             	add    %rdx,%rax
  800762:	48 8b 00             	mov    (%rax),%rax
  800765:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800767:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80076b:	eb c0                	jmp    80072d <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800771:	eb ba                	jmp    80072d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800773:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80077a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80077d:	89 d0                	mov    %edx,%eax
  80077f:	c1 e0 02             	shl    $0x2,%eax
  800782:	01 d0                	add    %edx,%eax
  800784:	01 c0                	add    %eax,%eax
  800786:	01 d8                	add    %ebx,%eax
  800788:	83 e8 30             	sub    $0x30,%eax
  80078b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80078e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800792:	0f b6 00             	movzbl (%rax),%eax
  800795:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800798:	83 fb 2f             	cmp    $0x2f,%ebx
  80079b:	7e 0c                	jle    8007a9 <vprintfmt+0x105>
  80079d:	83 fb 39             	cmp    $0x39,%ebx
  8007a0:	7f 07                	jg     8007a9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a7:	eb d1                	jmp    80077a <vprintfmt+0xd6>
			goto process_precision;
  8007a9:	eb 58                	jmp    800803 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ae:	83 f8 30             	cmp    $0x30,%eax
  8007b1:	73 17                	jae    8007ca <vprintfmt+0x126>
  8007b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	89 c0                	mov    %eax,%eax
  8007bc:	48 01 d0             	add    %rdx,%rax
  8007bf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c2:	83 c2 08             	add    $0x8,%edx
  8007c5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007c8:	eb 0f                	jmp    8007d9 <vprintfmt+0x135>
  8007ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ce:	48 89 d0             	mov    %rdx,%rax
  8007d1:	48 83 c2 08          	add    $0x8,%rdx
  8007d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007de:	eb 23                	jmp    800803 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e4:	79 0c                	jns    8007f2 <vprintfmt+0x14e>
				width = 0;
  8007e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007ed:	e9 3b ff ff ff       	jmpq   80072d <vprintfmt+0x89>
  8007f2:	e9 36 ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007fe:	e9 2a ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800803:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800807:	79 12                	jns    80081b <vprintfmt+0x177>
				width = precision, precision = -1;
  800809:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80080c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80080f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800816:	e9 12 ff ff ff       	jmpq   80072d <vprintfmt+0x89>
  80081b:	e9 0d ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800820:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800824:	e9 04 ff ff ff       	jmpq   80072d <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800829:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082c:	83 f8 30             	cmp    $0x30,%eax
  80082f:	73 17                	jae    800848 <vprintfmt+0x1a4>
  800831:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800835:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800838:	89 c0                	mov    %eax,%eax
  80083a:	48 01 d0             	add    %rdx,%rax
  80083d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800840:	83 c2 08             	add    $0x8,%edx
  800843:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800846:	eb 0f                	jmp    800857 <vprintfmt+0x1b3>
  800848:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80084c:	48 89 d0             	mov    %rdx,%rax
  80084f:	48 83 c2 08          	add    $0x8,%rdx
  800853:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800857:	8b 10                	mov    (%rax),%edx
  800859:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80085d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800861:	48 89 ce             	mov    %rcx,%rsi
  800864:	89 d7                	mov    %edx,%edi
  800866:	ff d0                	callq  *%rax
			break;
  800868:	e9 40 03 00 00       	jmpq   800bad <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80086d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800870:	83 f8 30             	cmp    $0x30,%eax
  800873:	73 17                	jae    80088c <vprintfmt+0x1e8>
  800875:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800884:	83 c2 08             	add    $0x8,%edx
  800887:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088a:	eb 0f                	jmp    80089b <vprintfmt+0x1f7>
  80088c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800890:	48 89 d0             	mov    %rdx,%rax
  800893:	48 83 c2 08          	add    $0x8,%rdx
  800897:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80089d:	85 db                	test   %ebx,%ebx
  80089f:	79 02                	jns    8008a3 <vprintfmt+0x1ff>
				err = -err;
  8008a1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a3:	83 fb 10             	cmp    $0x10,%ebx
  8008a6:	7f 16                	jg     8008be <vprintfmt+0x21a>
  8008a8:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  8008af:	00 00 00 
  8008b2:	48 63 d3             	movslq %ebx,%rdx
  8008b5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008b9:	4d 85 e4             	test   %r12,%r12
  8008bc:	75 2e                	jne    8008ec <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008be:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c6:	89 d9                	mov    %ebx,%ecx
  8008c8:	48 ba 99 36 80 00 00 	movabs $0x803699,%rdx
  8008cf:	00 00 00 
  8008d2:	48 89 c7             	mov    %rax,%rdi
  8008d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008da:	49 b8 bc 0b 80 00 00 	movabs $0x800bbc,%r8
  8008e1:	00 00 00 
  8008e4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e7:	e9 c1 02 00 00       	jmpq   800bad <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f4:	4c 89 e1             	mov    %r12,%rcx
  8008f7:	48 ba a2 36 80 00 00 	movabs $0x8036a2,%rdx
  8008fe:	00 00 00 
  800901:	48 89 c7             	mov    %rax,%rdi
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	49 b8 bc 0b 80 00 00 	movabs $0x800bbc,%r8
  800910:	00 00 00 
  800913:	41 ff d0             	callq  *%r8
			break;
  800916:	e9 92 02 00 00       	jmpq   800bad <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80091b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091e:	83 f8 30             	cmp    $0x30,%eax
  800921:	73 17                	jae    80093a <vprintfmt+0x296>
  800923:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800927:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092a:	89 c0                	mov    %eax,%eax
  80092c:	48 01 d0             	add    %rdx,%rax
  80092f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800932:	83 c2 08             	add    $0x8,%edx
  800935:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800938:	eb 0f                	jmp    800949 <vprintfmt+0x2a5>
  80093a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093e:	48 89 d0             	mov    %rdx,%rax
  800941:	48 83 c2 08          	add    $0x8,%rdx
  800945:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800949:	4c 8b 20             	mov    (%rax),%r12
  80094c:	4d 85 e4             	test   %r12,%r12
  80094f:	75 0a                	jne    80095b <vprintfmt+0x2b7>
				p = "(null)";
  800951:	49 bc a5 36 80 00 00 	movabs $0x8036a5,%r12
  800958:	00 00 00 
			if (width > 0 && padc != '-')
  80095b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095f:	7e 3f                	jle    8009a0 <vprintfmt+0x2fc>
  800961:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800965:	74 39                	je     8009a0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800967:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80096a:	48 98                	cltq   
  80096c:	48 89 c6             	mov    %rax,%rsi
  80096f:	4c 89 e7             	mov    %r12,%rdi
  800972:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800981:	eb 17                	jmp    80099a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800983:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800987:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80098b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098f:	48 89 ce             	mov    %rcx,%rsi
  800992:	89 d7                	mov    %edx,%edi
  800994:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800996:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099e:	7f e3                	jg     800983 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a0:	eb 37                	jmp    8009d9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009a6:	74 1e                	je     8009c6 <vprintfmt+0x322>
  8009a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ab:	7e 05                	jle    8009b2 <vprintfmt+0x30e>
  8009ad:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b0:	7e 14                	jle    8009c6 <vprintfmt+0x322>
					putch('?', putdat);
  8009b2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ba:	48 89 d6             	mov    %rdx,%rsi
  8009bd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c2:	ff d0                	callq  *%rax
  8009c4:	eb 0f                	jmp    8009d5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ce:	48 89 d6             	mov    %rdx,%rsi
  8009d1:	89 df                	mov    %ebx,%edi
  8009d3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d9:	4c 89 e0             	mov    %r12,%rax
  8009dc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009e0:	0f b6 00             	movzbl (%rax),%eax
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 10                	je     8009fa <vprintfmt+0x356>
  8009ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ee:	78 b2                	js     8009a2 <vprintfmt+0x2fe>
  8009f0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f8:	79 a8                	jns    8009a2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fa:	eb 16                	jmp    800a12 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a04:	48 89 d6             	mov    %rdx,%rsi
  800a07:	bf 20 00 00 00       	mov    $0x20,%edi
  800a0c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a16:	7f e4                	jg     8009fc <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a18:	e9 90 01 00 00       	jmpq   800bad <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a21:	be 03 00 00 00       	mov    $0x3,%esi
  800a26:	48 89 c7             	mov    %rax,%rdi
  800a29:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  800a30:	00 00 00 
  800a33:	ff d0                	callq  *%rax
  800a35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	48 85 c0             	test   %rax,%rax
  800a40:	79 1d                	jns    800a5f <vprintfmt+0x3bb>
				putch('-', putdat);
  800a42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4a:	48 89 d6             	mov    %rdx,%rsi
  800a4d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a52:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a58:	48 f7 d8             	neg    %rax
  800a5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a5f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a66:	e9 d5 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a6b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6f:	be 03 00 00 00       	mov    $0x3,%esi
  800a74:	48 89 c7             	mov    %rax,%rdi
  800a77:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  800a7e:	00 00 00 
  800a81:	ff d0                	callq  *%rax
  800a83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a87:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8e:	e9 ad 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800a93:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800a96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9a:	89 d6                	mov    %edx,%esi
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
  800aab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800aaf:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ab6:	e9 85 00 00 00       	jmpq   800b40 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800abb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	bf 30 00 00 00       	mov    $0x30,%edi
  800acb:	ff d0                	callq  *%rax
			putch('x', putdat);
  800acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad5:	48 89 d6             	mov    %rdx,%rsi
  800ad8:	bf 78 00 00 00       	mov    $0x78,%edi
  800add:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae2:	83 f8 30             	cmp    $0x30,%eax
  800ae5:	73 17                	jae    800afe <vprintfmt+0x45a>
  800ae7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	89 c0                	mov    %eax,%eax
  800af0:	48 01 d0             	add    %rdx,%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	83 c2 08             	add    $0x8,%edx
  800af9:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afc:	eb 0f                	jmp    800b0d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0d:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b14:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b1b:	eb 23                	jmp    800b40 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b21:	be 03 00 00 00       	mov    $0x3,%esi
  800b26:	48 89 c7             	mov    %rax,%rdi
  800b29:	48 b8 84 04 80 00 00 	movabs $0x800484,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	callq  *%rax
  800b35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b39:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b40:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b45:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b48:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b4f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b57:	45 89 c1             	mov    %r8d,%r9d
  800b5a:	41 89 f8             	mov    %edi,%r8d
  800b5d:	48 89 c7             	mov    %rax,%rdi
  800b60:	48 b8 c9 03 80 00 00 	movabs $0x8003c9,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	callq  *%rax
			break;
  800b6c:	eb 3f                	jmp    800bad <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b76:	48 89 d6             	mov    %rdx,%rsi
  800b79:	89 df                	mov    %ebx,%edi
  800b7b:	ff d0                	callq  *%rax
			break;
  800b7d:	eb 2e                	jmp    800bad <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b87:	48 89 d6             	mov    %rdx,%rsi
  800b8a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b8f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b91:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b96:	eb 05                	jmp    800b9d <vprintfmt+0x4f9>
  800b98:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba1:	48 83 e8 01          	sub    $0x1,%rax
  800ba5:	0f b6 00             	movzbl (%rax),%eax
  800ba8:	3c 25                	cmp    $0x25,%al
  800baa:	75 ec                	jne    800b98 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bac:	90                   	nop
		}
	}
  800bad:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bae:	e9 43 fb ff ff       	jmpq   8006f6 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bb3:	48 83 c4 60          	add    $0x60,%rsp
  800bb7:	5b                   	pop    %rbx
  800bb8:	41 5c                	pop    %r12
  800bba:	5d                   	pop    %rbp
  800bbb:	c3                   	retq   

0000000000800bbc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbc:	55                   	push   %rbp
  800bbd:	48 89 e5             	mov    %rsp,%rbp
  800bc0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bc7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bce:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bd5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bdc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bea:	84 c0                	test   %al,%al
  800bec:	74 20                	je     800c0e <printfmt+0x52>
  800bee:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bf6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bfa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bfe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c02:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c06:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c0a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c0e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c15:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c1c:	00 00 00 
  800c1f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c26:	00 00 00 
  800c29:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c2d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c34:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c3b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c42:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c49:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c50:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c57:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c5e:	48 89 c7             	mov    %rax,%rdi
  800c61:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  800c68:	00 00 00 
  800c6b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c6d:	c9                   	leaveq 
  800c6e:	c3                   	retq   

0000000000800c6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c6f:	55                   	push   %rbp
  800c70:	48 89 e5             	mov    %rsp,%rbp
  800c73:	48 83 ec 10          	sub    $0x10,%rsp
  800c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	8b 40 10             	mov    0x10(%rax),%eax
  800c85:	8d 50 01             	lea    0x1(%rax),%edx
  800c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c93:	48 8b 10             	mov    (%rax),%rdx
  800c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c9e:	48 39 c2             	cmp    %rax,%rdx
  800ca1:	73 17                	jae    800cba <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca7:	48 8b 00             	mov    (%rax),%rax
  800caa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb2:	48 89 0a             	mov    %rcx,(%rdx)
  800cb5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cb8:	88 10                	mov    %dl,(%rax)
}
  800cba:	c9                   	leaveq 
  800cbb:	c3                   	retq   

0000000000800cbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
  800cc0:	48 83 ec 50          	sub    $0x50,%rsp
  800cc4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cc8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ccb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ccf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cd7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cdb:	48 8b 0a             	mov    (%rdx),%rcx
  800cde:	48 89 08             	mov    %rcx,(%rax)
  800ce1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ce5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ce9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ced:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cf9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cfc:	48 98                	cltq   
  800cfe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d06:	48 01 d0             	add    %rdx,%rax
  800d09:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d14:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d19:	74 06                	je     800d21 <vsnprintf+0x65>
  800d1b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d1f:	7f 07                	jg     800d28 <vsnprintf+0x6c>
		return -E_INVAL;
  800d21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d26:	eb 2f                	jmp    800d57 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d28:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d2c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d30:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d34:	48 89 c6             	mov    %rax,%rsi
  800d37:	48 bf 6f 0c 80 00 00 	movabs $0x800c6f,%rdi
  800d3e:	00 00 00 
  800d41:	48 b8 a4 06 80 00 00 	movabs $0x8006a4,%rax
  800d48:	00 00 00 
  800d4b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d51:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d54:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d57:	c9                   	leaveq 
  800d58:	c3                   	retq   

0000000000800d59 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d59:	55                   	push   %rbp
  800d5a:	48 89 e5             	mov    %rsp,%rbp
  800d5d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d64:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d6b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d71:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d78:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d7f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d86:	84 c0                	test   %al,%al
  800d88:	74 20                	je     800daa <snprintf+0x51>
  800d8a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d8e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d92:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d96:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d9e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800da6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800daa:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800db8:	00 00 00 
  800dbb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc2:	00 00 00 
  800dc5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dc9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dd7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dde:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800de5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dec:	48 8b 0a             	mov    (%rdx),%rcx
  800def:	48 89 08             	mov    %rcx,(%rax)
  800df2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800df6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dfa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dfe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e02:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e09:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e10:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e16:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e1d:	48 89 c7             	mov    %rax,%rdi
  800e20:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800e27:	00 00 00 
  800e2a:	ff d0                	callq  *%rax
  800e2c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e32:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e38:	c9                   	leaveq 
  800e39:	c3                   	retq   

0000000000800e3a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e3a:	55                   	push   %rbp
  800e3b:	48 89 e5             	mov    %rsp,%rbp
  800e3e:	48 83 ec 18          	sub    $0x18,%rsp
  800e42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e4d:	eb 09                	jmp    800e58 <strlen+0x1e>
		n++;
  800e4f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e53:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5c:	0f b6 00             	movzbl (%rax),%eax
  800e5f:	84 c0                	test   %al,%al
  800e61:	75 ec                	jne    800e4f <strlen+0x15>
		n++;
	return n;
  800e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e66:	c9                   	leaveq 
  800e67:	c3                   	retq   

0000000000800e68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e68:	55                   	push   %rbp
  800e69:	48 89 e5             	mov    %rsp,%rbp
  800e6c:	48 83 ec 20          	sub    $0x20,%rsp
  800e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e7f:	eb 0e                	jmp    800e8f <strnlen+0x27>
		n++;
  800e81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e85:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e8f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e94:	74 0b                	je     800ea1 <strnlen+0x39>
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	0f b6 00             	movzbl (%rax),%eax
  800e9d:	84 c0                	test   %al,%al
  800e9f:	75 e0                	jne    800e81 <strnlen+0x19>
		n++;
	return n;
  800ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea4:	c9                   	leaveq 
  800ea5:	c3                   	retq   

0000000000800ea6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea6:	55                   	push   %rbp
  800ea7:	48 89 e5             	mov    %rsp,%rbp
  800eaa:	48 83 ec 20          	sub    $0x20,%rsp
  800eae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ebe:	90                   	nop
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ecb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ecf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ed7:	0f b6 12             	movzbl (%rdx),%edx
  800eda:	88 10                	mov    %dl,(%rax)
  800edc:	0f b6 00             	movzbl (%rax),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 dc                	jne    800ebf <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ee7:	c9                   	leaveq 
  800ee8:	c3                   	retq   

0000000000800ee9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ee9:	55                   	push   %rbp
  800eea:	48 89 e5             	mov    %rsp,%rbp
  800eed:	48 83 ec 20          	sub    $0x20,%rsp
  800ef1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efd:	48 89 c7             	mov    %rax,%rdi
  800f00:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	callq  *%rax
  800f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f12:	48 63 d0             	movslq %eax,%rdx
  800f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f19:	48 01 c2             	add    %rax,%rdx
  800f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f20:	48 89 c6             	mov    %rax,%rsi
  800f23:	48 89 d7             	mov    %rdx,%rdi
  800f26:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  800f2d:	00 00 00 
  800f30:	ff d0                	callq  *%rax
	return dst;
  800f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f36:	c9                   	leaveq 
  800f37:	c3                   	retq   

0000000000800f38 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f38:	55                   	push   %rbp
  800f39:	48 89 e5             	mov    %rsp,%rbp
  800f3c:	48 83 ec 28          	sub    $0x28,%rsp
  800f40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f48:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f54:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f5b:	00 
  800f5c:	eb 2a                	jmp    800f88 <strncpy+0x50>
		*dst++ = *src;
  800f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f62:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f6e:	0f b6 12             	movzbl (%rdx),%edx
  800f71:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f77:	0f b6 00             	movzbl (%rax),%eax
  800f7a:	84 c0                	test   %al,%al
  800f7c:	74 05                	je     800f83 <strncpy+0x4b>
			src++;
  800f7e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f83:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f90:	72 cc                	jb     800f5e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 28          	sub    $0x28,%rsp
  800fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fb4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fb9:	74 3d                	je     800ff8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fbb:	eb 1d                	jmp    800fda <strlcpy+0x42>
			*dst++ = *src++;
  800fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fc9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fcd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fd1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fd5:	0f b6 12             	movzbl (%rdx),%edx
  800fd8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fda:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fdf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe4:	74 0b                	je     800ff1 <strlcpy+0x59>
  800fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fea:	0f b6 00             	movzbl (%rax),%eax
  800fed:	84 c0                	test   %al,%al
  800fef:	75 cc                	jne    800fbd <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ff8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801000:	48 29 c2             	sub    %rax,%rdx
  801003:	48 89 d0             	mov    %rdx,%rax
}
  801006:	c9                   	leaveq 
  801007:	c3                   	retq   

0000000000801008 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801008:	55                   	push   %rbp
  801009:	48 89 e5             	mov    %rsp,%rbp
  80100c:	48 83 ec 10          	sub    $0x10,%rsp
  801010:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801014:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801018:	eb 0a                	jmp    801024 <strcmp+0x1c>
		p++, q++;
  80101a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801028:	0f b6 00             	movzbl (%rax),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	74 12                	je     801041 <strcmp+0x39>
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801033:	0f b6 10             	movzbl (%rax),%edx
  801036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103a:	0f b6 00             	movzbl (%rax),%eax
  80103d:	38 c2                	cmp    %al,%dl
  80103f:	74 d9                	je     80101a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	0f b6 d0             	movzbl %al,%edx
  80104b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	0f b6 c0             	movzbl %al,%eax
  801055:	29 c2                	sub    %eax,%edx
  801057:	89 d0                	mov    %edx,%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 18          	sub    $0x18,%rsp
  801063:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801067:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80106b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80106f:	eb 0f                	jmp    801080 <strncmp+0x25>
		n--, p++, q++;
  801071:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801076:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801080:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801085:	74 1d                	je     8010a4 <strncmp+0x49>
  801087:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108b:	0f b6 00             	movzbl (%rax),%eax
  80108e:	84 c0                	test   %al,%al
  801090:	74 12                	je     8010a4 <strncmp+0x49>
  801092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801096:	0f b6 10             	movzbl (%rax),%edx
  801099:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109d:	0f b6 00             	movzbl (%rax),%eax
  8010a0:	38 c2                	cmp    %al,%dl
  8010a2:	74 cd                	je     801071 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a9:	75 07                	jne    8010b2 <strncmp+0x57>
		return 0;
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b0:	eb 18                	jmp    8010ca <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	0f b6 d0             	movzbl %al,%edx
  8010bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c0:	0f b6 00             	movzbl (%rax),%eax
  8010c3:	0f b6 c0             	movzbl %al,%eax
  8010c6:	29 c2                	sub    %eax,%edx
  8010c8:	89 d0                	mov    %edx,%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8010d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d8:	89 f0                	mov    %esi,%eax
  8010da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010dd:	eb 17                	jmp    8010f6 <strchr+0x2a>
		if (*s == c)
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e3:	0f b6 00             	movzbl (%rax),%eax
  8010e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e9:	75 06                	jne    8010f1 <strchr+0x25>
			return (char *) s;
  8010eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ef:	eb 15                	jmp    801106 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	75 de                	jne    8010df <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801106:	c9                   	leaveq 
  801107:	c3                   	retq   

0000000000801108 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801108:	55                   	push   %rbp
  801109:	48 89 e5             	mov    %rsp,%rbp
  80110c:	48 83 ec 0c          	sub    $0xc,%rsp
  801110:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801114:	89 f0                	mov    %esi,%eax
  801116:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801119:	eb 13                	jmp    80112e <strfind+0x26>
		if (*s == c)
  80111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111f:	0f b6 00             	movzbl (%rax),%eax
  801122:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801125:	75 02                	jne    801129 <strfind+0x21>
			break;
  801127:	eb 10                	jmp    801139 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801129:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801132:	0f b6 00             	movzbl (%rax),%eax
  801135:	84 c0                	test   %al,%al
  801137:	75 e2                	jne    80111b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 18          	sub    $0x18,%rsp
  801147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80114e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801152:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801157:	75 06                	jne    80115f <memset+0x20>
		return v;
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115d:	eb 69                	jmp    8011c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801163:	83 e0 03             	and    $0x3,%eax
  801166:	48 85 c0             	test   %rax,%rax
  801169:	75 48                	jne    8011b3 <memset+0x74>
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116f:	83 e0 03             	and    $0x3,%eax
  801172:	48 85 c0             	test   %rax,%rax
  801175:	75 3c                	jne    8011b3 <memset+0x74>
		c &= 0xFF;
  801177:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80117e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801181:	c1 e0 18             	shl    $0x18,%eax
  801184:	89 c2                	mov    %eax,%edx
  801186:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801189:	c1 e0 10             	shl    $0x10,%eax
  80118c:	09 c2                	or     %eax,%edx
  80118e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801191:	c1 e0 08             	shl    $0x8,%eax
  801194:	09 d0                	or     %edx,%eax
  801196:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119d:	48 c1 e8 02          	shr    $0x2,%rax
  8011a1:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ab:	48 89 d7             	mov    %rdx,%rdi
  8011ae:	fc                   	cld    
  8011af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011b1:	eb 11                	jmp    8011c4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011be:	48 89 d7             	mov    %rdx,%rdi
  8011c1:	fc                   	cld    
  8011c2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 83 ec 28          	sub    $0x28,%rsp
  8011d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f6:	0f 83 88 00 00 00    	jae    801284 <memmove+0xba>
  8011fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801200:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801204:	48 01 d0             	add    %rdx,%rax
  801207:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80120b:	76 77                	jbe    801284 <memmove+0xba>
		s += n;
  80120d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801211:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801219:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	83 e0 03             	and    $0x3,%eax
  801224:	48 85 c0             	test   %rax,%rax
  801227:	75 3b                	jne    801264 <memmove+0x9a>
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	83 e0 03             	and    $0x3,%eax
  801230:	48 85 c0             	test   %rax,%rax
  801233:	75 2f                	jne    801264 <memmove+0x9a>
  801235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801239:	83 e0 03             	and    $0x3,%eax
  80123c:	48 85 c0             	test   %rax,%rax
  80123f:	75 23                	jne    801264 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801245:	48 83 e8 04          	sub    $0x4,%rax
  801249:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124d:	48 83 ea 04          	sub    $0x4,%rdx
  801251:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801255:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801259:	48 89 c7             	mov    %rax,%rdi
  80125c:	48 89 d6             	mov    %rdx,%rsi
  80125f:	fd                   	std    
  801260:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801262:	eb 1d                	jmp    801281 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801268:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801278:	48 89 d7             	mov    %rdx,%rdi
  80127b:	48 89 c1             	mov    %rax,%rcx
  80127e:	fd                   	std    
  80127f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801281:	fc                   	cld    
  801282:	eb 57                	jmp    8012db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	83 e0 03             	and    $0x3,%eax
  80128b:	48 85 c0             	test   %rax,%rax
  80128e:	75 36                	jne    8012c6 <memmove+0xfc>
  801290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801294:	83 e0 03             	and    $0x3,%eax
  801297:	48 85 c0             	test   %rax,%rax
  80129a:	75 2a                	jne    8012c6 <memmove+0xfc>
  80129c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a0:	83 e0 03             	and    $0x3,%eax
  8012a3:	48 85 c0             	test   %rax,%rax
  8012a6:	75 1e                	jne    8012c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ac:	48 c1 e8 02          	shr    $0x2,%rax
  8012b0:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bb:	48 89 c7             	mov    %rax,%rdi
  8012be:	48 89 d6             	mov    %rdx,%rsi
  8012c1:	fc                   	cld    
  8012c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c4:	eb 15                	jmp    8012db <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d2:	48 89 c7             	mov    %rax,%rdi
  8012d5:	48 89 d6             	mov    %rdx,%rsi
  8012d8:	fc                   	cld    
  8012d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012df:	c9                   	leaveq 
  8012e0:	c3                   	retq   

00000000008012e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e1:	55                   	push   %rbp
  8012e2:	48 89 e5             	mov    %rsp,%rbp
  8012e5:	48 83 ec 18          	sub    $0x18,%rsp
  8012e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801301:	48 89 ce             	mov    %rcx,%rsi
  801304:	48 89 c7             	mov    %rax,%rdi
  801307:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80130e:	00 00 00 
  801311:	ff d0                	callq  *%rax
}
  801313:	c9                   	leaveq 
  801314:	c3                   	retq   

0000000000801315 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801315:	55                   	push   %rbp
  801316:	48 89 e5             	mov    %rsp,%rbp
  801319:	48 83 ec 28          	sub    $0x28,%rsp
  80131d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801325:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801339:	eb 36                	jmp    801371 <memcmp+0x5c>
		if (*s1 != *s2)
  80133b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133f:	0f b6 10             	movzbl (%rax),%edx
  801342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801346:	0f b6 00             	movzbl (%rax),%eax
  801349:	38 c2                	cmp    %al,%dl
  80134b:	74 1a                	je     801367 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	0f b6 d0             	movzbl %al,%edx
  801357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	0f b6 c0             	movzbl %al,%eax
  801361:	29 c2                	sub    %eax,%edx
  801363:	89 d0                	mov    %edx,%eax
  801365:	eb 20                	jmp    801387 <memcmp+0x72>
		s1++, s2++;
  801367:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801375:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801379:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 b9                	jne    80133b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801387:	c9                   	leaveq 
  801388:	c3                   	retq   

0000000000801389 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801389:	55                   	push   %rbp
  80138a:	48 89 e5             	mov    %rsp,%rbp
  80138d:	48 83 ec 28          	sub    $0x28,%rsp
  801391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801395:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801398:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a4:	48 01 d0             	add    %rdx,%rax
  8013a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013ab:	eb 15                	jmp    8013c2 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b1:	0f b6 10             	movzbl (%rax),%edx
  8013b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013b7:	38 c2                	cmp    %al,%dl
  8013b9:	75 02                	jne    8013bd <memfind+0x34>
			break;
  8013bb:	eb 0f                	jmp    8013cc <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013ca:	72 e1                	jb     8013ad <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d0:	c9                   	leaveq 
  8013d1:	c3                   	retq   

00000000008013d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d2:	55                   	push   %rbp
  8013d3:	48 89 e5             	mov    %rsp,%rbp
  8013d6:	48 83 ec 34          	sub    $0x34,%rsp
  8013da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013ec:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f4:	eb 05                	jmp    8013fb <strtol+0x29>
		s++;
  8013f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	3c 20                	cmp    $0x20,%al
  801404:	74 f0                	je     8013f6 <strtol+0x24>
  801406:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3c 09                	cmp    $0x9,%al
  80140f:	74 e5                	je     8013f6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	3c 2b                	cmp    $0x2b,%al
  80141a:	75 07                	jne    801423 <strtol+0x51>
		s++;
  80141c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801421:	eb 17                	jmp    80143a <strtol+0x68>
	else if (*s == '-')
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	3c 2d                	cmp    $0x2d,%al
  80142c:	75 0c                	jne    80143a <strtol+0x68>
		s++, neg = 1;
  80142e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801433:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80143e:	74 06                	je     801446 <strtol+0x74>
  801440:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801444:	75 28                	jne    80146e <strtol+0x9c>
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3c 30                	cmp    $0x30,%al
  80144f:	75 1d                	jne    80146e <strtol+0x9c>
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	48 83 c0 01          	add    $0x1,%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3c 78                	cmp    $0x78,%al
  80145e:	75 0e                	jne    80146e <strtol+0x9c>
		s += 2, base = 16;
  801460:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801465:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80146c:	eb 2c                	jmp    80149a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80146e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801472:	75 19                	jne    80148d <strtol+0xbb>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	3c 30                	cmp    $0x30,%al
  80147d:	75 0e                	jne    80148d <strtol+0xbb>
		s++, base = 8;
  80147f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801484:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80148b:	eb 0d                	jmp    80149a <strtol+0xc8>
	else if (base == 0)
  80148d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801491:	75 07                	jne    80149a <strtol+0xc8>
		base = 10;
  801493:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	0f b6 00             	movzbl (%rax),%eax
  8014a1:	3c 2f                	cmp    $0x2f,%al
  8014a3:	7e 1d                	jle    8014c2 <strtol+0xf0>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	3c 39                	cmp    $0x39,%al
  8014ae:	7f 12                	jg     8014c2 <strtol+0xf0>
			dig = *s - '0';
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	0f be c0             	movsbl %al,%eax
  8014ba:	83 e8 30             	sub    $0x30,%eax
  8014bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c0:	eb 4e                	jmp    801510 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	0f b6 00             	movzbl (%rax),%eax
  8014c9:	3c 60                	cmp    $0x60,%al
  8014cb:	7e 1d                	jle    8014ea <strtol+0x118>
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	0f b6 00             	movzbl (%rax),%eax
  8014d4:	3c 7a                	cmp    $0x7a,%al
  8014d6:	7f 12                	jg     8014ea <strtol+0x118>
			dig = *s - 'a' + 10;
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	0f be c0             	movsbl %al,%eax
  8014e2:	83 e8 57             	sub    $0x57,%eax
  8014e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e8:	eb 26                	jmp    801510 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 40                	cmp    $0x40,%al
  8014f3:	7e 48                	jle    80153d <strtol+0x16b>
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	3c 5a                	cmp    $0x5a,%al
  8014fe:	7f 3d                	jg     80153d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	0f be c0             	movsbl %al,%eax
  80150a:	83 e8 37             	sub    $0x37,%eax
  80150d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801513:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801516:	7c 02                	jl     80151a <strtol+0x148>
			break;
  801518:	eb 23                	jmp    80153d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80151a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80151f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801522:	48 98                	cltq   
  801524:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801529:	48 89 c2             	mov    %rax,%rdx
  80152c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80152f:	48 98                	cltq   
  801531:	48 01 d0             	add    %rdx,%rax
  801534:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801538:	e9 5d ff ff ff       	jmpq   80149a <strtol+0xc8>

	if (endptr)
  80153d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801542:	74 0b                	je     80154f <strtol+0x17d>
		*endptr = (char *) s;
  801544:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801548:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80154c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80154f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801553:	74 09                	je     80155e <strtol+0x18c>
  801555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801559:	48 f7 d8             	neg    %rax
  80155c:	eb 04                	jmp    801562 <strtol+0x190>
  80155e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801562:	c9                   	leaveq 
  801563:	c3                   	retq   

0000000000801564 <strstr>:

char * strstr(const char *in, const char *str)
{
  801564:	55                   	push   %rbp
  801565:	48 89 e5             	mov    %rsp,%rbp
  801568:	48 83 ec 30          	sub    $0x30,%rsp
  80156c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801570:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801574:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801578:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80157c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801586:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80158a:	75 06                	jne    801592 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	eb 6b                	jmp    8015fd <strstr+0x99>

    len = strlen(str);
  801592:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801596:	48 89 c7             	mov    %rax,%rdi
  801599:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  8015a0:	00 00 00 
  8015a3:	ff d0                	callq  *%rax
  8015a5:	48 98                	cltq   
  8015a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c1:	75 07                	jne    8015ca <strstr+0x66>
                return (char *) 0;
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	eb 33                	jmp    8015fd <strstr+0x99>
        } while (sc != c);
  8015ca:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015ce:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d1:	75 d8                	jne    8015ab <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8015d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015d7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 89 ce             	mov    %rcx,%rsi
  8015e2:	48 89 c7             	mov    %rax,%rdi
  8015e5:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  8015ec:	00 00 00 
  8015ef:	ff d0                	callq  *%rax
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	75 b6                	jne    8015ab <strstr+0x47>

    return (char *) (in - 1);
  8015f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f9:	48 83 e8 01          	sub    $0x1,%rax
}
  8015fd:	c9                   	leaveq 
  8015fe:	c3                   	retq   

00000000008015ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015ff:	55                   	push   %rbp
  801600:	48 89 e5             	mov    %rsp,%rbp
  801603:	53                   	push   %rbx
  801604:	48 83 ec 48          	sub    $0x48,%rsp
  801608:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80160b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80160e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801612:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801616:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80161a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801621:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801625:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801629:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80162d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801631:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801635:	4c 89 c3             	mov    %r8,%rbx
  801638:	cd 30                	int    $0x30
  80163a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80163e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801642:	74 3e                	je     801682 <syscall+0x83>
  801644:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801649:	7e 37                	jle    801682 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80164b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801652:	49 89 d0             	mov    %rdx,%r8
  801655:	89 c1                	mov    %eax,%ecx
  801657:	48 ba 60 39 80 00 00 	movabs $0x803960,%rdx
  80165e:	00 00 00 
  801661:	be 23 00 00 00       	mov    $0x23,%esi
  801666:	48 bf 7d 39 80 00 00 	movabs $0x80397d,%rdi
  80166d:	00 00 00 
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	49 b9 d1 32 80 00 00 	movabs $0x8032d1,%r9
  80167c:	00 00 00 
  80167f:	41 ff d1             	callq  *%r9

	return ret;
  801682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801686:	48 83 c4 48          	add    $0x48,%rsp
  80168a:	5b                   	pop    %rbx
  80168b:	5d                   	pop    %rbp
  80168c:	c3                   	retq   

000000000080168d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	48 83 ec 20          	sub    $0x20,%rsp
  801695:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801699:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80169d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ac:	00 
  8016ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b9:	48 89 d1             	mov    %rdx,%rcx
  8016bc:	48 89 c2             	mov    %rax,%rdx
  8016bf:	be 00 00 00 00       	mov    $0x0,%esi
  8016c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8016c9:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8016d0:	00 00 00 
  8016d3:	ff d0                	callq  *%rax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e6:	00 
  8016e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	be 00 00 00 00       	mov    $0x0,%esi
  801702:	bf 01 00 00 00       	mov    $0x1,%edi
  801707:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80170e:	00 00 00 
  801711:	ff d0                	callq  *%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	48 83 ec 10          	sub    $0x10,%rsp
  80171d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801720:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801723:	48 98                	cltq   
  801725:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172c:	00 
  80172d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801733:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173e:	48 89 c2             	mov    %rax,%rdx
  801741:	be 01 00 00 00       	mov    $0x1,%esi
  801746:	bf 03 00 00 00       	mov    $0x3,%edi
  80174b:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801752:	00 00 00 
  801755:	ff d0                	callq  *%rax
}
  801757:	c9                   	leaveq 
  801758:	c3                   	retq   

0000000000801759 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801759:	55                   	push   %rbp
  80175a:	48 89 e5             	mov    %rsp,%rbp
  80175d:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801761:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801768:	00 
  801769:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801775:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	be 00 00 00 00       	mov    $0x0,%esi
  801784:	bf 02 00 00 00       	mov    $0x2,%edi
  801789:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801790:	00 00 00 
  801793:	ff d0                	callq  *%rax
}
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   

0000000000801797 <sys_yield>:

void
sys_yield(void)
{
  801797:	55                   	push   %rbp
  801798:	48 89 e5             	mov    %rsp,%rbp
  80179b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80179f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a6:	00 
  8017a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	be 00 00 00 00       	mov    $0x0,%esi
  8017c2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017c7:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8017ce:	00 00 00 
  8017d1:	ff d0                	callq  *%rax
}
  8017d3:	c9                   	leaveq 
  8017d4:	c3                   	retq   

00000000008017d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017d5:	55                   	push   %rbp
  8017d6:	48 89 e5             	mov    %rsp,%rbp
  8017d9:	48 83 ec 20          	sub    $0x20,%rsp
  8017dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ea:	48 63 c8             	movslq %eax,%rcx
  8017ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f4:	48 98                	cltq   
  8017f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fd:	00 
  8017fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801804:	49 89 c8             	mov    %rcx,%r8
  801807:	48 89 d1             	mov    %rdx,%rcx
  80180a:	48 89 c2             	mov    %rax,%rdx
  80180d:	be 01 00 00 00       	mov    $0x1,%esi
  801812:	bf 04 00 00 00       	mov    $0x4,%edi
  801817:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
}
  801823:	c9                   	leaveq 
  801824:	c3                   	retq   

0000000000801825 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
  801829:	48 83 ec 30          	sub    $0x30,%rsp
  80182d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801830:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801834:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801837:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80183b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80183f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801842:	48 63 c8             	movslq %eax,%rcx
  801845:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801849:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80184c:	48 63 f0             	movslq %eax,%rsi
  80184f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801856:	48 98                	cltq   
  801858:	48 89 0c 24          	mov    %rcx,(%rsp)
  80185c:	49 89 f9             	mov    %rdi,%r9
  80185f:	49 89 f0             	mov    %rsi,%r8
  801862:	48 89 d1             	mov    %rdx,%rcx
  801865:	48 89 c2             	mov    %rax,%rdx
  801868:	be 01 00 00 00       	mov    $0x1,%esi
  80186d:	bf 05 00 00 00       	mov    $0x5,%edi
  801872:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801879:	00 00 00 
  80187c:	ff d0                	callq  *%rax
}
  80187e:	c9                   	leaveq 
  80187f:	c3                   	retq   

0000000000801880 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 20          	sub    $0x20,%rsp
  801888:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80188f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801893:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801896:	48 98                	cltq   
  801898:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189f:	00 
  8018a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ac:	48 89 d1             	mov    %rdx,%rcx
  8018af:	48 89 c2             	mov    %rax,%rdx
  8018b2:	be 01 00 00 00       	mov    $0x1,%esi
  8018b7:	bf 06 00 00 00       	mov    $0x6,%edi
  8018bc:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8018c3:	00 00 00 
  8018c6:	ff d0                	callq  *%rax
}
  8018c8:	c9                   	leaveq 
  8018c9:	c3                   	retq   

00000000008018ca <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	48 83 ec 10          	sub    $0x10,%rsp
  8018d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018db:	48 63 d0             	movslq %eax,%rdx
  8018de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e1:	48 98                	cltq   
  8018e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ea:	00 
  8018eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f7:	48 89 d1             	mov    %rdx,%rcx
  8018fa:	48 89 c2             	mov    %rax,%rdx
  8018fd:	be 01 00 00 00       	mov    $0x1,%esi
  801902:	bf 08 00 00 00       	mov    $0x8,%edi
  801907:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 20          	sub    $0x20,%rsp
  80191d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801920:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801924:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192b:	48 98                	cltq   
  80192d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801934:	00 
  801935:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801941:	48 89 d1             	mov    %rdx,%rcx
  801944:	48 89 c2             	mov    %rax,%rdx
  801947:	be 01 00 00 00       	mov    $0x1,%esi
  80194c:	bf 09 00 00 00       	mov    $0x9,%edi
  801951:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
}
  80195d:	c9                   	leaveq 
  80195e:	c3                   	retq   

000000000080195f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	48 83 ec 20          	sub    $0x20,%rsp
  801967:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80196e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801975:	48 98                	cltq   
  801977:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197e:	00 
  80197f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801985:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198b:	48 89 d1             	mov    %rdx,%rcx
  80198e:	48 89 c2             	mov    %rax,%rdx
  801991:	be 01 00 00 00       	mov    $0x1,%esi
  801996:	bf 0a 00 00 00       	mov    $0xa,%edi
  80199b:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	callq  *%rax
}
  8019a7:	c9                   	leaveq 
  8019a8:	c3                   	retq   

00000000008019a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019a9:	55                   	push   %rbp
  8019aa:	48 89 e5             	mov    %rsp,%rbp
  8019ad:	48 83 ec 20          	sub    $0x20,%rsp
  8019b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019bc:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c2:	48 63 f0             	movslq %eax,%rsi
  8019c5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cc:	48 98                	cltq   
  8019ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d9:	00 
  8019da:	49 89 f1             	mov    %rsi,%r9
  8019dd:	49 89 c8             	mov    %rcx,%r8
  8019e0:	48 89 d1             	mov    %rdx,%rcx
  8019e3:	48 89 c2             	mov    %rax,%rdx
  8019e6:	be 00 00 00 00       	mov    $0x0,%esi
  8019eb:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f0:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8019f7:	00 00 00 
  8019fa:	ff d0                	callq  *%rax
}
  8019fc:	c9                   	leaveq 
  8019fd:	c3                   	retq   

00000000008019fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019fe:	55                   	push   %rbp
  8019ff:	48 89 e5             	mov    %rsp,%rbp
  801a02:	48 83 ec 10          	sub    $0x10,%rsp
  801a06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a15:	00 
  801a16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	48 89 c2             	mov    %rax,%rdx
  801a2a:	be 01 00 00 00       	mov    $0x1,%esi
  801a2f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a34:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
}
  801a40:	c9                   	leaveq 
  801a41:	c3                   	retq   

0000000000801a42 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	48 83 ec 30          	sub    $0x30,%rsp
  801a4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  801a56:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801a5d:	00 00 00 
  801a60:	48 8b 00             	mov    (%rax),%rax
  801a63:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	75 3c                	jne    801aa9 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a6d:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  801a74:	00 00 00 
  801a77:	ff d0                	callq  *%rax
  801a79:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a7e:	48 63 d0             	movslq %eax,%rdx
  801a81:	48 89 d0             	mov    %rdx,%rax
  801a84:	48 c1 e0 03          	shl    $0x3,%rax
  801a88:	48 01 d0             	add    %rdx,%rax
  801a8b:	48 c1 e0 05          	shl    $0x5,%rax
  801a8f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801a96:	00 00 00 
  801a99:	48 01 c2             	add    %rax,%rdx
  801a9c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801aa3:	00 00 00 
  801aa6:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  801aa9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801aae:	75 0e                	jne    801abe <ipc_recv+0x7c>
		pg = (void*) UTOP;
  801ab0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801ab7:	00 00 00 
  801aba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  801abe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ac2:	48 89 c7             	mov    %rax,%rdi
  801ac5:	48 b8 fe 19 80 00 00 	movabs $0x8019fe,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
  801ad1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  801ad4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ad8:	79 19                	jns    801af3 <ipc_recv+0xb1>
		*from_env_store = 0;
  801ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ade:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  801ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  801aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af1:	eb 53                	jmp    801b46 <ipc_recv+0x104>
	}
	if(from_env_store)
  801af3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801af8:	74 19                	je     801b13 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  801afa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801b01:	00 00 00 
  801b04:	48 8b 00             	mov    (%rax),%rax
  801b07:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b11:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  801b13:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801b18:	74 19                	je     801b33 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  801b1a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801b21:	00 00 00 
  801b24:	48 8b 00             	mov    (%rax),%rax
  801b27:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801b2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b31:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  801b33:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801b3a:	00 00 00 
  801b3d:	48 8b 00             	mov    (%rax),%rax
  801b40:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 30          	sub    $0x30,%rsp
  801b50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b53:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801b56:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801b5a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  801b5d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b62:	75 0e                	jne    801b72 <ipc_send+0x2a>
		pg = (void*)UTOP;
  801b64:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801b6b:	00 00 00 
  801b6e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  801b72:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801b75:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801b78:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b7f:	89 c7                	mov    %eax,%edi
  801b81:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax
  801b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  801b90:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801b94:	75 0c                	jne    801ba2 <ipc_send+0x5a>
			sys_yield();
  801b96:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  801ba2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801ba6:	74 ca                	je     801b72 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   

0000000000801baa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	48 83 ec 14          	sub    $0x14,%rsp
  801bb2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  801bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bbc:	eb 5e                	jmp    801c1c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801bbe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bc5:	00 00 00 
  801bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcb:	48 63 d0             	movslq %eax,%rdx
  801bce:	48 89 d0             	mov    %rdx,%rax
  801bd1:	48 c1 e0 03          	shl    $0x3,%rax
  801bd5:	48 01 d0             	add    %rdx,%rax
  801bd8:	48 c1 e0 05          	shl    $0x5,%rax
  801bdc:	48 01 c8             	add    %rcx,%rax
  801bdf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801be5:	8b 00                	mov    (%rax),%eax
  801be7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801bea:	75 2c                	jne    801c18 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801bec:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bf3:	00 00 00 
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 63 d0             	movslq %eax,%rdx
  801bfc:	48 89 d0             	mov    %rdx,%rax
  801bff:	48 c1 e0 03          	shl    $0x3,%rax
  801c03:	48 01 d0             	add    %rdx,%rax
  801c06:	48 c1 e0 05          	shl    $0x5,%rax
  801c0a:	48 01 c8             	add    %rcx,%rax
  801c0d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801c13:	8b 40 08             	mov    0x8(%rax),%eax
  801c16:	eb 12                	jmp    801c2a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c1c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801c23:	7e 99                	jle    801bbe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	c9                   	leaveq 
  801c2b:	c3                   	retq   

0000000000801c2c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	48 83 ec 08          	sub    $0x8,%rsp
  801c34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c43:	ff ff ff 
  801c46:	48 01 d0             	add    %rdx,%rax
  801c49:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 08          	sub    $0x8,%rsp
  801c57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5f:	48 89 c7             	mov    %rax,%rdi
  801c62:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
  801c6e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c74:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 18          	sub    $0x18,%rsp
  801c82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c8d:	eb 6b                	jmp    801cfa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c9a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca6:	48 c1 e8 15          	shr    $0x15,%rax
  801caa:	48 89 c2             	mov    %rax,%rdx
  801cad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cb4:	01 00 00 
  801cb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cbb:	83 e0 01             	and    $0x1,%eax
  801cbe:	48 85 c0             	test   %rax,%rax
  801cc1:	74 21                	je     801ce4 <fd_alloc+0x6a>
  801cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ccb:	48 89 c2             	mov    %rax,%rdx
  801cce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cd5:	01 00 00 
  801cd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cdc:	83 e0 01             	and    $0x1,%eax
  801cdf:	48 85 c0             	test   %rax,%rax
  801ce2:	75 12                	jne    801cf6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cec:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 1a                	jmp    801d10 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cfa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cfe:	7e 8f                	jle    801c8f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d0b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 20          	sub    $0x20,%rsp
  801d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d25:	78 06                	js     801d2d <fd_lookup+0x1b>
  801d27:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d2b:	7e 07                	jle    801d34 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d32:	eb 6c                	jmp    801da0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	48 98                	cltq   
  801d39:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d3f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4b:	48 c1 e8 15          	shr    $0x15,%rax
  801d4f:	48 89 c2             	mov    %rax,%rdx
  801d52:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d59:	01 00 00 
  801d5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d60:	83 e0 01             	and    $0x1,%eax
  801d63:	48 85 c0             	test   %rax,%rax
  801d66:	74 21                	je     801d89 <fd_lookup+0x77>
  801d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d70:	48 89 c2             	mov    %rax,%rdx
  801d73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d7a:	01 00 00 
  801d7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d81:	83 e0 01             	and    $0x1,%eax
  801d84:	48 85 c0             	test   %rax,%rax
  801d87:	75 07                	jne    801d90 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8e:	eb 10                	jmp    801da0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d98:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 30          	sub    $0x30,%rsp
  801daa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dae:	89 f0                	mov    %esi,%eax
  801db0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801db3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db7:	48 89 c7             	mov    %rax,%rdi
  801dba:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dca:	48 89 d6             	mov    %rdx,%rsi
  801dcd:	89 c7                	mov    %eax,%edi
  801dcf:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	callq  *%rax
  801ddb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de2:	78 0a                	js     801dee <fd_close+0x4c>
	    || fd != fd2)
  801de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dec:	74 12                	je     801e00 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dee:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801df2:	74 05                	je     801df9 <fd_close+0x57>
  801df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df7:	eb 05                	jmp    801dfe <fd_close+0x5c>
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfe:	eb 69                	jmp    801e69 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e04:	8b 00                	mov    (%rax),%eax
  801e06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e0a:	48 89 d6             	mov    %rdx,%rsi
  801e0d:	89 c7                	mov    %eax,%edi
  801e0f:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
  801e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e22:	78 2a                	js     801e4e <fd_close+0xac>
		if (dev->dev_close)
  801e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e28:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e2c:	48 85 c0             	test   %rax,%rax
  801e2f:	74 16                	je     801e47 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e35:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e3d:	48 89 d7             	mov    %rdx,%rdi
  801e40:	ff d0                	callq  *%rax
  801e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e45:	eb 07                	jmp    801e4e <fd_close+0xac>
		else
			r = 0;
  801e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e52:	48 89 c6             	mov    %rax,%rsi
  801e55:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	callq  *%rax
	return r;
  801e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 20          	sub    $0x20,%rsp
  801e73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e81:	eb 41                	jmp    801ec4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e83:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e8a:	00 00 00 
  801e8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e90:	48 63 d2             	movslq %edx,%rdx
  801e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e97:	8b 00                	mov    (%rax),%eax
  801e99:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e9c:	75 22                	jne    801ec0 <dev_lookup+0x55>
			*dev = devtab[i];
  801e9e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ea5:	00 00 00 
  801ea8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eab:	48 63 d2             	movslq %edx,%rdx
  801eae:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	eb 60                	jmp    801f20 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ec0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ecb:	00 00 00 
  801ece:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ed1:	48 63 d2             	movslq %edx,%rdx
  801ed4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed8:	48 85 c0             	test   %rax,%rax
  801edb:	75 a6                	jne    801e83 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801edd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ee4:	00 00 00 
  801ee7:	48 8b 00             	mov    (%rax),%rax
  801eea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ef0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef3:	89 c6                	mov    %eax,%esi
  801ef5:	48 bf 90 39 80 00 00 	movabs $0x803990,%rdi
  801efc:	00 00 00 
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  801f0b:	00 00 00 
  801f0e:	ff d1                	callq  *%rcx
	*dev = 0;
  801f10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f14:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f20:	c9                   	leaveq 
  801f21:	c3                   	retq   

0000000000801f22 <close>:

int
close(int fdnum)
{
  801f22:	55                   	push   %rbp
  801f23:	48 89 e5             	mov    %rsp,%rbp
  801f26:	48 83 ec 20          	sub    $0x20,%rsp
  801f2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f34:	48 89 d6             	mov    %rdx,%rsi
  801f37:	89 c7                	mov    %eax,%edi
  801f39:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	callq  *%rax
  801f45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4c:	79 05                	jns    801f53 <close+0x31>
		return r;
  801f4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f51:	eb 18                	jmp    801f6b <close+0x49>
	else
		return fd_close(fd, 1);
  801f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f57:	be 01 00 00 00       	mov    $0x1,%esi
  801f5c:	48 89 c7             	mov    %rax,%rdi
  801f5f:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <close_all>:

void
close_all(void)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7c:	eb 15                	jmp    801f93 <close_all+0x26>
		close(i);
  801f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f81:	89 c7                	mov    %eax,%edi
  801f83:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f93:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f97:	7e e5                	jle    801f7e <close_all+0x11>
		close(i);
}
  801f99:	c9                   	leaveq 
  801f9a:	c3                   	retq   

0000000000801f9b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f9b:	55                   	push   %rbp
  801f9c:	48 89 e5             	mov    %rsp,%rbp
  801f9f:	48 83 ec 40          	sub    $0x40,%rsp
  801fa3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fa6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fa9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fb0:	48 89 d6             	mov    %rdx,%rsi
  801fb3:	89 c7                	mov    %eax,%edi
  801fb5:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
  801fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc8:	79 08                	jns    801fd2 <dup+0x37>
		return r;
  801fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcd:	e9 70 01 00 00       	jmpq   802142 <dup+0x1a7>
	close(newfdnum);
  801fd2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fd5:	89 c7                	mov    %eax,%edi
  801fd7:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fe3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fe6:	48 98                	cltq   
  801fe8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fee:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ff6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffa:	48 89 c7             	mov    %rax,%rdi
  801ffd:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802004:	00 00 00 
  802007:	ff d0                	callq  *%rax
  802009:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80200d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802011:	48 89 c7             	mov    %rax,%rdi
  802014:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	callq  *%rax
  802020:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802028:	48 c1 e8 15          	shr    $0x15,%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802036:	01 00 00 
  802039:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203d:	83 e0 01             	and    $0x1,%eax
  802040:	48 85 c0             	test   %rax,%rax
  802043:	74 73                	je     8020b8 <dup+0x11d>
  802045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802049:	48 c1 e8 0c          	shr    $0xc,%rax
  80204d:	48 89 c2             	mov    %rax,%rdx
  802050:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802057:	01 00 00 
  80205a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205e:	83 e0 01             	and    $0x1,%eax
  802061:	48 85 c0             	test   %rax,%rax
  802064:	74 52                	je     8020b8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206a:	48 c1 e8 0c          	shr    $0xc,%rax
  80206e:	48 89 c2             	mov    %rax,%rdx
  802071:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802078:	01 00 00 
  80207b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80207f:	25 07 0e 00 00       	and    $0xe07,%eax
  802084:	89 c1                	mov    %eax,%ecx
  802086:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80208a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208e:	41 89 c8             	mov    %ecx,%r8d
  802091:	48 89 d1             	mov    %rdx,%rcx
  802094:	ba 00 00 00 00       	mov    $0x0,%edx
  802099:	48 89 c6             	mov    %rax,%rsi
  80209c:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a1:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
  8020ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b4:	79 02                	jns    8020b8 <dup+0x11d>
			goto err;
  8020b6:	eb 57                	jmp    80210f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ca:	01 00 00 
  8020cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d6:	89 c1                	mov    %eax,%ecx
  8020d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e0:	41 89 c8             	mov    %ecx,%r8d
  8020e3:	48 89 d1             	mov    %rdx,%rcx
  8020e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020eb:	48 89 c6             	mov    %rax,%rsi
  8020ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f3:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8020fa:	00 00 00 
  8020fd:	ff d0                	callq  *%rax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802106:	79 02                	jns    80210a <dup+0x16f>
		goto err;
  802108:	eb 05                	jmp    80210f <dup+0x174>

	return newfdnum;
  80210a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210d:	eb 33                	jmp    802142 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80210f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802113:	48 89 c6             	mov    %rax,%rsi
  802116:	bf 00 00 00 00       	mov    $0x0,%edi
  80211b:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212b:	48 89 c6             	mov    %rax,%rsi
  80212e:	bf 00 00 00 00       	mov    $0x0,%edi
  802133:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
	return r;
  80213f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802142:	c9                   	leaveq 
  802143:	c3                   	retq   

0000000000802144 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
  802148:	48 83 ec 40          	sub    $0x40,%rsp
  80214c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80214f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802153:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802157:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80215b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80215e:	48 89 d6             	mov    %rdx,%rsi
  802161:	89 c7                	mov    %eax,%edi
  802163:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802176:	78 24                	js     80219c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	8b 00                	mov    (%rax),%eax
  80217e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802182:	48 89 d6             	mov    %rdx,%rsi
  802185:	89 c7                	mov    %eax,%edi
  802187:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
  802193:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219a:	79 05                	jns    8021a1 <read+0x5d>
		return r;
  80219c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219f:	eb 76                	jmp    802217 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	8b 40 08             	mov    0x8(%rax),%eax
  8021a8:	83 e0 03             	and    $0x3,%eax
  8021ab:	83 f8 01             	cmp    $0x1,%eax
  8021ae:	75 3a                	jne    8021ea <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021b0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021b7:	00 00 00 
  8021ba:	48 8b 00             	mov    (%rax),%rax
  8021bd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c6:	89 c6                	mov    %eax,%esi
  8021c8:	48 bf af 39 80 00 00 	movabs $0x8039af,%rdi
  8021cf:	00 00 00 
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8021de:	00 00 00 
  8021e1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021e8:	eb 2d                	jmp    802217 <read+0xd3>
	}
	if (!dev->dev_read)
  8021ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ee:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021f2:	48 85 c0             	test   %rax,%rax
  8021f5:	75 07                	jne    8021fe <read+0xba>
		return -E_NOT_SUPP;
  8021f7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021fc:	eb 19                	jmp    802217 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 8b 40 10          	mov    0x10(%rax),%rax
  802206:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80220a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80220e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802212:	48 89 cf             	mov    %rcx,%rdi
  802215:	ff d0                	callq  *%rax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 83 ec 30          	sub    $0x30,%rsp
  802221:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802224:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802228:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80222c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802233:	eb 49                	jmp    80227e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802238:	48 98                	cltq   
  80223a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80223e:	48 29 c2             	sub    %rax,%rdx
  802241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802244:	48 63 c8             	movslq %eax,%rcx
  802247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224b:	48 01 c1             	add    %rax,%rcx
  80224e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802251:	48 89 ce             	mov    %rcx,%rsi
  802254:	89 c7                	mov    %eax,%edi
  802256:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  80225d:	00 00 00 
  802260:	ff d0                	callq  *%rax
  802262:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802265:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802269:	79 05                	jns    802270 <readn+0x57>
			return m;
  80226b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80226e:	eb 1c                	jmp    80228c <readn+0x73>
		if (m == 0)
  802270:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802274:	75 02                	jne    802278 <readn+0x5f>
			break;
  802276:	eb 11                	jmp    802289 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802278:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80227b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80227e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802281:	48 98                	cltq   
  802283:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802287:	72 ac                	jb     802235 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802289:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80228c:	c9                   	leaveq 
  80228d:	c3                   	retq   

000000000080228e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	48 83 ec 40          	sub    $0x40,%rsp
  802296:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802299:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80229d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022a8:	48 89 d6             	mov    %rdx,%rsi
  8022ab:	89 c7                	mov    %eax,%edi
  8022ad:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	callq  *%rax
  8022b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c0:	78 24                	js     8022e6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	8b 00                	mov    (%rax),%eax
  8022c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022cc:	48 89 d6             	mov    %rdx,%rsi
  8022cf:	89 c7                	mov    %eax,%edi
  8022d1:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	79 05                	jns    8022eb <write+0x5d>
		return r;
  8022e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e9:	eb 75                	jmp    802360 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	8b 40 08             	mov    0x8(%rax),%eax
  8022f2:	83 e0 03             	and    $0x3,%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	75 3a                	jne    802333 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802300:	00 00 00 
  802303:	48 8b 00             	mov    (%rax),%rax
  802306:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80230c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	48 bf cb 39 80 00 00 	movabs $0x8039cb,%rdi
  802318:	00 00 00 
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  802327:	00 00 00 
  80232a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80232c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802331:	eb 2d                	jmp    802360 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	48 8b 40 18          	mov    0x18(%rax),%rax
  80233b:	48 85 c0             	test   %rax,%rax
  80233e:	75 07                	jne    802347 <write+0xb9>
		return -E_NOT_SUPP;
  802340:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802345:	eb 19                	jmp    802360 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80234f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802353:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802357:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80235b:	48 89 cf             	mov    %rcx,%rdi
  80235e:	ff d0                	callq  *%rax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   

0000000000802362 <seek>:

int
seek(int fdnum, off_t offset)
{
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	48 83 ec 18          	sub    $0x18,%rsp
  80236a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80236d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802370:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802374:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802377:	48 89 d6             	mov    %rdx,%rsi
  80237a:	89 c7                	mov    %eax,%edi
  80237c:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
  802388:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238f:	79 05                	jns    802396 <seek+0x34>
		return r;
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802394:	eb 0f                	jmp    8023a5 <seek+0x43>
	fd->fd_offset = offset;
  802396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80239d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a5:	c9                   	leaveq 
  8023a6:	c3                   	retq   

00000000008023a7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023a7:	55                   	push   %rbp
  8023a8:	48 89 e5             	mov    %rsp,%rbp
  8023ab:	48 83 ec 30          	sub    $0x30,%rsp
  8023af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023bc:	48 89 d6             	mov    %rdx,%rsi
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
  8023cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d4:	78 24                	js     8023fa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 00                	mov    (%rax),%eax
  8023dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	79 05                	jns    8023ff <ftruncate+0x58>
		return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	eb 72                	jmp    802471 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802403:	8b 40 08             	mov    0x8(%rax),%eax
  802406:	83 e0 03             	and    $0x3,%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 3a                	jne    802447 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80240d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802414:	00 00 00 
  802417:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80241a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802420:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802423:	89 c6                	mov    %eax,%esi
  802425:	48 bf e8 39 80 00 00 	movabs $0x8039e8,%rdi
  80242c:	00 00 00 
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
  802434:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  80243b:	00 00 00 
  80243e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802440:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802445:	eb 2a                	jmp    802471 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80244f:	48 85 c0             	test   %rax,%rax
  802452:	75 07                	jne    80245b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802454:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802459:	eb 16                	jmp    802471 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80245b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802463:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802467:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80246a:	89 ce                	mov    %ecx,%esi
  80246c:	48 89 d7             	mov    %rdx,%rdi
  80246f:	ff d0                	callq  *%rax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 30          	sub    $0x30,%rsp
  80247b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802482:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802486:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802489:	48 89 d6             	mov    %rdx,%rsi
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
  80249a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a1:	78 24                	js     8024c7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a7:	8b 00                	mov    (%rax),%eax
  8024a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ad:	48 89 d6             	mov    %rdx,%rsi
  8024b0:	89 c7                	mov    %eax,%edi
  8024b2:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	callq  *%rax
  8024be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c5:	79 05                	jns    8024cc <fstat+0x59>
		return r;
  8024c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ca:	eb 5e                	jmp    80252a <fstat+0xb7>
	if (!dev->dev_stat)
  8024cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d4:	48 85 c0             	test   %rax,%rax
  8024d7:	75 07                	jne    8024e0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024de:	eb 4a                	jmp    80252a <fstat+0xb7>
	stat->st_name[0] = 0;
  8024e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024f2:	00 00 00 
	stat->st_isdir = 0;
  8024f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802500:	00 00 00 
	stat->st_dev = dev;
  802503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802507:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80250b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802516:	48 8b 40 28          	mov    0x28(%rax),%rax
  80251a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80251e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802522:	48 89 ce             	mov    %rcx,%rsi
  802525:	48 89 d7             	mov    %rdx,%rdi
  802528:	ff d0                	callq  *%rax
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80252c:	55                   	push   %rbp
  80252d:	48 89 e5             	mov    %rsp,%rbp
  802530:	48 83 ec 20          	sub    $0x20,%rsp
  802534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802538:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80253c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802540:	be 00 00 00 00       	mov    $0x0,%esi
  802545:	48 89 c7             	mov    %rax,%rdi
  802548:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  80254f:	00 00 00 
  802552:	ff d0                	callq  *%rax
  802554:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802557:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255b:	79 05                	jns    802562 <stat+0x36>
		return fd;
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	eb 2f                	jmp    802591 <stat+0x65>
	r = fstat(fd, stat);
  802562:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	48 89 d6             	mov    %rdx,%rsi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
  80257a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80257d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802580:	89 c7                	mov    %eax,%edi
  802582:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
	return r;
  80258e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802591:	c9                   	leaveq 
  802592:	c3                   	retq   

0000000000802593 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802593:	55                   	push   %rbp
  802594:	48 89 e5             	mov    %rsp,%rbp
  802597:	48 83 ec 10          	sub    $0x10,%rsp
  80259b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80259e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025a2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025a9:	00 00 00 
  8025ac:	8b 00                	mov    (%rax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	75 1d                	jne    8025cf <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b7:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8025ca:	00 00 00 
  8025cd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025d6:	00 00 00 
  8025d9:	8b 00                	mov    (%rax),%eax
  8025db:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025de:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025e3:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025ea:	00 00 00 
  8025ed:	89 c7                	mov    %eax,%edi
  8025ef:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  8025f6:	00 00 00 
  8025f9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	bf 00 00 00 00       	mov    $0x0,%edi
  80260c:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
}
  802618:	c9                   	leaveq 
  802619:	c3                   	retq   

000000000080261a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80261a:	55                   	push   %rbp
  80261b:	48 89 e5             	mov    %rsp,%rbp
  80261e:	48 83 ec 30          	sub    $0x30,%rsp
  802622:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802626:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802629:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802630:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802637:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80263e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802643:	75 08                	jne    80264d <open+0x33>
	{
		return r;
  802645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802648:	e9 f2 00 00 00       	jmpq   80273f <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80264d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802651:	48 89 c7             	mov    %rax,%rdi
  802654:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  80265b:	00 00 00 
  80265e:	ff d0                	callq  *%rax
  802660:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802663:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80266a:	7e 0a                	jle    802676 <open+0x5c>
	{
		return -E_BAD_PATH;
  80266c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802671:	e9 c9 00 00 00       	jmpq   80273f <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802676:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80267d:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  80267e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802682:	48 89 c7             	mov    %rax,%rdi
  802685:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	78 09                	js     8026a3 <open+0x89>
  80269a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 08                	jne    8026ab <open+0x91>
		{
			return r;
  8026a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a6:	e9 94 00 00 00       	jmpq   80273f <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8026ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026af:	ba 00 04 00 00       	mov    $0x400,%edx
  8026b4:	48 89 c6             	mov    %rax,%rsi
  8026b7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8026be:	00 00 00 
  8026c1:	48 b8 38 0f 80 00 00 	movabs $0x800f38,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8026cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d4:	00 00 00 
  8026d7:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8026da:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8026e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e4:	48 89 c6             	mov    %rax,%rsi
  8026e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ec:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
  8026f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ff:	79 2b                	jns    80272c <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802705:	be 00 00 00 00       	mov    $0x0,%esi
  80270a:	48 89 c7             	mov    %rax,%rdi
  80270d:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  802714:	00 00 00 
  802717:	ff d0                	callq  *%rax
  802719:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80271c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802720:	79 05                	jns    802727 <open+0x10d>
			{
				return d;
  802722:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802725:	eb 18                	jmp    80273f <open+0x125>
			}
			return r;
  802727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272a:	eb 13                	jmp    80273f <open+0x125>
		}	
		return fd2num(fd_store);
  80272c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802730:	48 89 c7             	mov    %rax,%rdi
  802733:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80273f:	c9                   	leaveq 
  802740:	c3                   	retq   

0000000000802741 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802741:	55                   	push   %rbp
  802742:	48 89 e5             	mov    %rsp,%rbp
  802745:	48 83 ec 10          	sub    $0x10,%rsp
  802749:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80274d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802751:	8b 50 0c             	mov    0xc(%rax),%edx
  802754:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80275b:	00 00 00 
  80275e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802760:	be 00 00 00 00       	mov    $0x0,%esi
  802765:	bf 06 00 00 00       	mov    $0x6,%edi
  80276a:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
}
  802776:	c9                   	leaveq 
  802777:	c3                   	retq   

0000000000802778 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802778:	55                   	push   %rbp
  802779:	48 89 e5             	mov    %rsp,%rbp
  80277c:	48 83 ec 30          	sub    $0x30,%rsp
  802780:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802784:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802788:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80278c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802793:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802798:	74 07                	je     8027a1 <devfile_read+0x29>
  80279a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80279f:	75 07                	jne    8027a8 <devfile_read+0x30>
		return -E_INVAL;
  8027a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027a6:	eb 77                	jmp    80281f <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ac:	8b 50 0c             	mov    0xc(%rax),%edx
  8027af:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b6:	00 00 00 
  8027b9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027bb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027c2:	00 00 00 
  8027c5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8027cd:	be 00 00 00 00       	mov    $0x0,%esi
  8027d2:	bf 03 00 00 00       	mov    $0x3,%edi
  8027d7:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
  8027e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ea:	7f 05                	jg     8027f1 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8027ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ef:	eb 2e                	jmp    80281f <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8027f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f4:	48 63 d0             	movslq %eax,%rdx
  8027f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027fb:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802802:	00 00 00 
  802805:	48 89 c7             	mov    %rax,%rdi
  802808:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802814:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802818:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80281c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80281f:	c9                   	leaveq 
  802820:	c3                   	retq   

0000000000802821 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802821:	55                   	push   %rbp
  802822:	48 89 e5             	mov    %rsp,%rbp
  802825:	48 83 ec 30          	sub    $0x30,%rsp
  802829:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80282d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802831:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802835:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80283c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802841:	74 07                	je     80284a <devfile_write+0x29>
  802843:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802848:	75 08                	jne    802852 <devfile_write+0x31>
		return r;
  80284a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284d:	e9 9a 00 00 00       	jmpq   8028ec <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802856:	8b 50 0c             	mov    0xc(%rax),%edx
  802859:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802860:	00 00 00 
  802863:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802865:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80286c:	00 
  80286d:	76 08                	jbe    802877 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80286f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802876:	00 
	}
	fsipcbuf.write.req_n = n;
  802877:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80287e:	00 00 00 
  802881:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802885:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802889:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80288d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802891:	48 89 c6             	mov    %rax,%rsi
  802894:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80289b:	00 00 00 
  80289e:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8028a5:	00 00 00 
  8028a8:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8028aa:	be 00 00 00 00       	mov    $0x0,%esi
  8028af:	bf 04 00 00 00       	mov    $0x4,%edi
  8028b4:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c7:	7f 20                	jg     8028e9 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8028c9:	48 bf 0e 3a 80 00 00 	movabs $0x803a0e,%rdi
  8028d0:	00 00 00 
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d8:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  8028df:	00 00 00 
  8028e2:	ff d2                	callq  *%rdx
		return r;
  8028e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e7:	eb 03                	jmp    8028ec <devfile_write+0xcb>
	}
	return r;
  8028e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8028ec:	c9                   	leaveq 
  8028ed:	c3                   	retq   

00000000008028ee <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028ee:	55                   	push   %rbp
  8028ef:	48 89 e5             	mov    %rsp,%rbp
  8028f2:	48 83 ec 20          	sub    $0x20,%rsp
  8028f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802902:	8b 50 0c             	mov    0xc(%rax),%edx
  802905:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80290c:	00 00 00 
  80290f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802911:	be 00 00 00 00       	mov    $0x0,%esi
  802916:	bf 05 00 00 00       	mov    $0x5,%edi
  80291b:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
  802927:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292e:	79 05                	jns    802935 <devfile_stat+0x47>
		return r;
  802930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802933:	eb 56                	jmp    80298b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802935:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802939:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802940:	00 00 00 
  802943:	48 89 c7             	mov    %rax,%rdi
  802946:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  80294d:	00 00 00 
  802950:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802952:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802959:	00 00 00 
  80295c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802962:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802966:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80296c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802973:	00 00 00 
  802976:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80297c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802980:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298b:	c9                   	leaveq 
  80298c:	c3                   	retq   

000000000080298d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80298d:	55                   	push   %rbp
  80298e:	48 89 e5             	mov    %rsp,%rbp
  802991:	48 83 ec 10          	sub    $0x10,%rsp
  802995:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802999:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80299c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029aa:	00 00 00 
  8029ad:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029af:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029b6:	00 00 00 
  8029b9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029bc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029bf:	be 00 00 00 00       	mov    $0x0,%esi
  8029c4:	bf 02 00 00 00       	mov    $0x2,%edi
  8029c9:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
}
  8029d5:	c9                   	leaveq 
  8029d6:	c3                   	retq   

00000000008029d7 <remove>:

// Delete a file
int
remove(const char *path)
{
  8029d7:	55                   	push   %rbp
  8029d8:	48 89 e5             	mov    %rsp,%rbp
  8029db:	48 83 ec 10          	sub    $0x10,%rsp
  8029df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e7:	48 89 c7             	mov    %rax,%rdi
  8029ea:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
  8029f6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029fb:	7e 07                	jle    802a04 <remove+0x2d>
		return -E_BAD_PATH;
  8029fd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a02:	eb 33                	jmp    802a37 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a08:	48 89 c6             	mov    %rax,%rsi
  802a0b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a12:	00 00 00 
  802a15:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a21:	be 00 00 00 00       	mov    $0x0,%esi
  802a26:	bf 07 00 00 00       	mov    $0x7,%edi
  802a2b:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax
}
  802a37:	c9                   	leaveq 
  802a38:	c3                   	retq   

0000000000802a39 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a39:	55                   	push   %rbp
  802a3a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a3d:	be 00 00 00 00       	mov    $0x0,%esi
  802a42:	bf 08 00 00 00       	mov    $0x8,%edi
  802a47:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
}
  802a53:	5d                   	pop    %rbp
  802a54:	c3                   	retq   

0000000000802a55 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a55:	55                   	push   %rbp
  802a56:	48 89 e5             	mov    %rsp,%rbp
  802a59:	53                   	push   %rbx
  802a5a:	48 83 ec 38          	sub    $0x38,%rsp
  802a5e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a62:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a66:	48 89 c7             	mov    %rax,%rdi
  802a69:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802a70:	00 00 00 
  802a73:	ff d0                	callq  *%rax
  802a75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a7c:	0f 88 bf 01 00 00    	js     802c41 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a86:	ba 07 04 00 00       	mov    $0x407,%edx
  802a8b:	48 89 c6             	mov    %rax,%rsi
  802a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a93:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aa6:	0f 88 95 01 00 00    	js     802c41 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802aac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ab0:	48 89 c7             	mov    %rax,%rdi
  802ab3:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802aba:	00 00 00 
  802abd:	ff d0                	callq  *%rax
  802abf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ac2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ac6:	0f 88 5d 01 00 00    	js     802c29 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802acc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad0:	ba 07 04 00 00       	mov    $0x407,%edx
  802ad5:	48 89 c6             	mov    %rax,%rsi
  802ad8:	bf 00 00 00 00       	mov    $0x0,%edi
  802add:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
  802ae9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802af0:	0f 88 33 01 00 00    	js     802c29 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802afa:	48 89 c7             	mov    %rax,%rdi
  802afd:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
  802b09:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b11:	ba 07 04 00 00       	mov    $0x407,%edx
  802b16:	48 89 c6             	mov    %rax,%rsi
  802b19:	bf 00 00 00 00       	mov    $0x0,%edi
  802b1e:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
  802b2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b31:	79 05                	jns    802b38 <pipe+0xe3>
		goto err2;
  802b33:	e9 d9 00 00 00       	jmpq   802c11 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b3c:	48 89 c7             	mov    %rax,%rdi
  802b3f:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
  802b4b:	48 89 c2             	mov    %rax,%rdx
  802b4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b52:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b58:	48 89 d1             	mov    %rdx,%rcx
  802b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b60:	48 89 c6             	mov    %rax,%rsi
  802b63:	bf 00 00 00 00       	mov    $0x0,%edi
  802b68:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
  802b74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b7b:	79 1b                	jns    802b98 <pipe+0x143>
		goto err3;
  802b7d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802b7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b82:	48 89 c6             	mov    %rax,%rsi
  802b85:	bf 00 00 00 00       	mov    $0x0,%edi
  802b8a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
  802b96:	eb 79                	jmp    802c11 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802b98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b9c:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ba3:	00 00 00 
  802ba6:	8b 12                	mov    (%rdx),%edx
  802ba8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802baa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bb9:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bc0:	00 00 00 
  802bc3:	8b 12                	mov    (%rdx),%edx
  802bc5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802bc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bcb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802bd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd6:	48 89 c7             	mov    %rax,%rdi
  802bd9:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	89 c2                	mov    %eax,%edx
  802be7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802beb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802bed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bf1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802bf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf9:	48 89 c7             	mov    %rax,%rdi
  802bfc:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
  802c08:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0f:	eb 33                	jmp    802c44 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802c11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c15:	48 89 c6             	mov    %rax,%rsi
  802c18:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1d:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802c29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c2d:	48 89 c6             	mov    %rax,%rsi
  802c30:	bf 00 00 00 00       	mov    $0x0,%edi
  802c35:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
    err:
	return r;
  802c41:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c44:	48 83 c4 38          	add    $0x38,%rsp
  802c48:	5b                   	pop    %rbx
  802c49:	5d                   	pop    %rbp
  802c4a:	c3                   	retq   

0000000000802c4b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c4b:	55                   	push   %rbp
  802c4c:	48 89 e5             	mov    %rsp,%rbp
  802c4f:	53                   	push   %rbx
  802c50:	48 83 ec 28          	sub    $0x28,%rsp
  802c54:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c58:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c5c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c63:	00 00 00 
  802c66:	48 8b 00             	mov    (%rax),%rax
  802c69:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c76:	48 89 c7             	mov    %rax,%rdi
  802c79:	48 b8 e5 33 80 00 00 	movabs $0x8033e5,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 c3                	mov    %eax,%ebx
  802c87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c8b:	48 89 c7             	mov    %rax,%rdi
  802c8e:	48 b8 e5 33 80 00 00 	movabs $0x8033e5,%rax
  802c95:	00 00 00 
  802c98:	ff d0                	callq  *%rax
  802c9a:	39 c3                	cmp    %eax,%ebx
  802c9c:	0f 94 c0             	sete   %al
  802c9f:	0f b6 c0             	movzbl %al,%eax
  802ca2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802ca5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cac:	00 00 00 
  802caf:	48 8b 00             	mov    (%rax),%rax
  802cb2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cb8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cbe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cc1:	75 05                	jne    802cc8 <_pipeisclosed+0x7d>
			return ret;
  802cc3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cc6:	eb 4f                	jmp    802d17 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802cc8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ccb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cce:	74 42                	je     802d12 <_pipeisclosed+0xc7>
  802cd0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802cd4:	75 3c                	jne    802d12 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cd6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cdd:	00 00 00 
  802ce0:	48 8b 00             	mov    (%rax),%rax
  802ce3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802ce9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802cec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cef:	89 c6                	mov    %eax,%esi
  802cf1:	48 bf 2f 3a 80 00 00 	movabs $0x803a2f,%rdi
  802cf8:	00 00 00 
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802d00:	49 b8 f1 02 80 00 00 	movabs $0x8002f1,%r8
  802d07:	00 00 00 
  802d0a:	41 ff d0             	callq  *%r8
	}
  802d0d:	e9 4a ff ff ff       	jmpq   802c5c <_pipeisclosed+0x11>
  802d12:	e9 45 ff ff ff       	jmpq   802c5c <_pipeisclosed+0x11>
}
  802d17:	48 83 c4 28          	add    $0x28,%rsp
  802d1b:	5b                   	pop    %rbx
  802d1c:	5d                   	pop    %rbp
  802d1d:	c3                   	retq   

0000000000802d1e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 30          	sub    $0x30,%rsp
  802d26:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d29:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d30:	48 89 d6             	mov    %rdx,%rsi
  802d33:	89 c7                	mov    %eax,%edi
  802d35:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802d3c:	00 00 00 
  802d3f:	ff d0                	callq  *%rax
  802d41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d48:	79 05                	jns    802d4f <pipeisclosed+0x31>
		return r;
  802d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4d:	eb 31                	jmp    802d80 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d53:	48 89 c7             	mov    %rax,%rdi
  802d56:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	callq  *%rax
  802d62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d6e:	48 89 d6             	mov    %rdx,%rsi
  802d71:	48 89 c7             	mov    %rax,%rdi
  802d74:	48 b8 4b 2c 80 00 00 	movabs $0x802c4b,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
}
  802d80:	c9                   	leaveq 
  802d81:	c3                   	retq   

0000000000802d82 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d82:	55                   	push   %rbp
  802d83:	48 89 e5             	mov    %rsp,%rbp
  802d86:	48 83 ec 40          	sub    $0x40,%rsp
  802d8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d8e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d92:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d9a:	48 89 c7             	mov    %rax,%rdi
  802d9d:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802db5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802dbc:	00 
  802dbd:	e9 92 00 00 00       	jmpq   802e54 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802dc2:	eb 41                	jmp    802e05 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802dc4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802dc9:	74 09                	je     802dd4 <devpipe_read+0x52>
				return i;
  802dcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dcf:	e9 92 00 00 00       	jmpq   802e66 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802dd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddc:	48 89 d6             	mov    %rdx,%rsi
  802ddf:	48 89 c7             	mov    %rax,%rdi
  802de2:	48 b8 4b 2c 80 00 00 	movabs $0x802c4b,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 07                	je     802df9 <devpipe_read+0x77>
				return 0;
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	eb 6d                	jmp    802e66 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802df9:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e09:	8b 10                	mov    (%rax),%edx
  802e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0f:	8b 40 04             	mov    0x4(%rax),%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	74 ae                	je     802dc4 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e1e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e26:	8b 00                	mov    (%rax),%eax
  802e28:	99                   	cltd   
  802e29:	c1 ea 1b             	shr    $0x1b,%edx
  802e2c:	01 d0                	add    %edx,%eax
  802e2e:	83 e0 1f             	and    $0x1f,%eax
  802e31:	29 d0                	sub    %edx,%eax
  802e33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e37:	48 98                	cltq   
  802e39:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e3e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	8b 00                	mov    (%rax),%eax
  802e46:	8d 50 01             	lea    0x1(%rax),%edx
  802e49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e58:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e5c:	0f 82 60 ff ff ff    	jb     802dc2 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e66:	c9                   	leaveq 
  802e67:	c3                   	retq   

0000000000802e68 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e68:	55                   	push   %rbp
  802e69:	48 89 e5             	mov    %rsp,%rbp
  802e6c:	48 83 ec 40          	sub    $0x40,%rsp
  802e70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e80:	48 89 c7             	mov    %rax,%rdi
  802e83:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	callq  *%rax
  802e8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802e93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802e9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ea2:	00 
  802ea3:	e9 8e 00 00 00       	jmpq   802f36 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ea8:	eb 31                	jmp    802edb <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802eaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb2:	48 89 d6             	mov    %rdx,%rsi
  802eb5:	48 89 c7             	mov    %rax,%rdi
  802eb8:	48 b8 4b 2c 80 00 00 	movabs $0x802c4b,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 07                	je     802ecf <devpipe_write+0x67>
				return 0;
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	eb 79                	jmp    802f48 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ecf:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edf:	8b 40 04             	mov    0x4(%rax),%eax
  802ee2:	48 63 d0             	movslq %eax,%rdx
  802ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee9:	8b 00                	mov    (%rax),%eax
  802eeb:	48 98                	cltq   
  802eed:	48 83 c0 20          	add    $0x20,%rax
  802ef1:	48 39 c2             	cmp    %rax,%rdx
  802ef4:	73 b4                	jae    802eaa <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	8b 40 04             	mov    0x4(%rax),%eax
  802efd:	99                   	cltd   
  802efe:	c1 ea 1b             	shr    $0x1b,%edx
  802f01:	01 d0                	add    %edx,%eax
  802f03:	83 e0 1f             	and    $0x1f,%eax
  802f06:	29 d0                	sub    %edx,%eax
  802f08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f10:	48 01 ca             	add    %rcx,%rdx
  802f13:	0f b6 0a             	movzbl (%rdx),%ecx
  802f16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f1a:	48 98                	cltq   
  802f1c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f24:	8b 40 04             	mov    0x4(%rax),%eax
  802f27:	8d 50 01             	lea    0x1(%rax),%edx
  802f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2e:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f31:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f3a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f3e:	0f 82 64 ff ff ff    	jb     802ea8 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f48:	c9                   	leaveq 
  802f49:	c3                   	retq   

0000000000802f4a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f4a:	55                   	push   %rbp
  802f4b:	48 89 e5             	mov    %rsp,%rbp
  802f4e:	48 83 ec 20          	sub    $0x20,%rsp
  802f52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5e:	48 89 c7             	mov    %rax,%rdi
  802f61:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
  802f6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f75:	48 be 42 3a 80 00 00 	movabs $0x803a42,%rsi
  802f7c:	00 00 00 
  802f7f:	48 89 c7             	mov    %rax,%rdi
  802f82:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f92:	8b 50 04             	mov    0x4(%rax),%edx
  802f95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f99:	8b 00                	mov    (%rax),%eax
  802f9b:	29 c2                	sub    %eax,%edx
  802f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fa7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fab:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fb2:	00 00 00 
	stat->st_dev = &devpipe;
  802fb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb9:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802fc0:	00 00 00 
  802fc3:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcf:	c9                   	leaveq 
  802fd0:	c3                   	retq   

0000000000802fd1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802fd1:	55                   	push   %rbp
  802fd2:	48 89 e5             	mov    %rsp,%rbp
  802fd5:	48 83 ec 10          	sub    $0x10,%rsp
  802fd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe1:	48 89 c6             	mov    %rax,%rsi
  802fe4:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe9:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	48 89 c7             	mov    %rax,%rdi
  802ffc:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803003:	00 00 00 
  803006:	ff d0                	callq  *%rax
  803008:	48 89 c6             	mov    %rax,%rsi
  80300b:	bf 00 00 00 00       	mov    $0x0,%edi
  803010:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
}
  80301c:	c9                   	leaveq 
  80301d:	c3                   	retq   

000000000080301e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80301e:	55                   	push   %rbp
  80301f:	48 89 e5             	mov    %rsp,%rbp
  803022:	48 83 ec 20          	sub    $0x20,%rsp
  803026:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803029:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80302c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80302f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803033:	be 01 00 00 00       	mov    $0x1,%esi
  803038:	48 89 c7             	mov    %rax,%rdi
  80303b:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
}
  803047:	c9                   	leaveq 
  803048:	c3                   	retq   

0000000000803049 <getchar>:

int
getchar(void)
{
  803049:	55                   	push   %rbp
  80304a:	48 89 e5             	mov    %rsp,%rbp
  80304d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803051:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803055:	ba 01 00 00 00       	mov    $0x1,%edx
  80305a:	48 89 c6             	mov    %rax,%rsi
  80305d:	bf 00 00 00 00       	mov    $0x0,%edi
  803062:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803075:	79 05                	jns    80307c <getchar+0x33>
		return r;
  803077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307a:	eb 14                	jmp    803090 <getchar+0x47>
	if (r < 1)
  80307c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803080:	7f 07                	jg     803089 <getchar+0x40>
		return -E_EOF;
  803082:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803087:	eb 07                	jmp    803090 <getchar+0x47>
	return c;
  803089:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80308d:	0f b6 c0             	movzbl %al,%eax
}
  803090:	c9                   	leaveq 
  803091:	c3                   	retq   

0000000000803092 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803092:	55                   	push   %rbp
  803093:	48 89 e5             	mov    %rsp,%rbp
  803096:	48 83 ec 20          	sub    $0x20,%rsp
  80309a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80309d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a4:	48 89 d6             	mov    %rdx,%rsi
  8030a7:	89 c7                	mov    %eax,%edi
  8030a9:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
  8030b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bc:	79 05                	jns    8030c3 <iscons+0x31>
		return r;
  8030be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c1:	eb 1a                	jmp    8030dd <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	8b 10                	mov    (%rax),%edx
  8030c9:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8030d0:	00 00 00 
  8030d3:	8b 00                	mov    (%rax),%eax
  8030d5:	39 c2                	cmp    %eax,%edx
  8030d7:	0f 94 c0             	sete   %al
  8030da:	0f b6 c0             	movzbl %al,%eax
}
  8030dd:	c9                   	leaveq 
  8030de:	c3                   	retq   

00000000008030df <opencons>:

int
opencons(void)
{
  8030df:	55                   	push   %rbp
  8030e0:	48 89 e5             	mov    %rsp,%rbp
  8030e3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8030e7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030eb:	48 89 c7             	mov    %rax,%rdi
  8030ee:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803101:	79 05                	jns    803108 <opencons+0x29>
		return r;
  803103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803106:	eb 5b                	jmp    803163 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310c:	ba 07 04 00 00       	mov    $0x407,%edx
  803111:	48 89 c6             	mov    %rax,%rsi
  803114:	bf 00 00 00 00       	mov    $0x0,%edi
  803119:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  803120:	00 00 00 
  803123:	ff d0                	callq  *%rax
  803125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312c:	79 05                	jns    803133 <opencons+0x54>
		return r;
  80312e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803131:	eb 30                	jmp    803163 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803137:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80313e:	00 00 00 
  803141:	8b 12                	mov    (%rdx),%edx
  803143:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803149:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803154:	48 89 c7             	mov    %rax,%rdi
  803157:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
}
  803163:	c9                   	leaveq 
  803164:	c3                   	retq   

0000000000803165 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803165:	55                   	push   %rbp
  803166:	48 89 e5             	mov    %rsp,%rbp
  803169:	48 83 ec 30          	sub    $0x30,%rsp
  80316d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803171:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803175:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803179:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80317e:	75 07                	jne    803187 <devcons_read+0x22>
		return 0;
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	eb 4b                	jmp    8031d2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803187:	eb 0c                	jmp    803195 <devcons_read+0x30>
		sys_yield();
  803189:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803195:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
  8031a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a8:	74 df                	je     803189 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ae:	79 05                	jns    8031b5 <devcons_read+0x50>
		return c;
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b3:	eb 1d                	jmp    8031d2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031b5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031b9:	75 07                	jne    8031c2 <devcons_read+0x5d>
		return 0;
  8031bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c0:	eb 10                	jmp    8031d2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c5:	89 c2                	mov    %eax,%edx
  8031c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cb:	88 10                	mov    %dl,(%rax)
	return 1;
  8031cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8031d2:	c9                   	leaveq 
  8031d3:	c3                   	retq   

00000000008031d4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8031df:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8031e6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8031ed:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8031f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031fb:	eb 76                	jmp    803273 <devcons_write+0x9f>
		m = n - tot;
  8031fd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803204:	89 c2                	mov    %eax,%edx
  803206:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803209:	29 c2                	sub    %eax,%edx
  80320b:	89 d0                	mov    %edx,%eax
  80320d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803210:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803213:	83 f8 7f             	cmp    $0x7f,%eax
  803216:	76 07                	jbe    80321f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803218:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80321f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803222:	48 63 d0             	movslq %eax,%rdx
  803225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803228:	48 63 c8             	movslq %eax,%rcx
  80322b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803232:	48 01 c1             	add    %rax,%rcx
  803235:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80323c:	48 89 ce             	mov    %rcx,%rsi
  80323f:	48 89 c7             	mov    %rax,%rdi
  803242:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80324e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803251:	48 63 d0             	movslq %eax,%rdx
  803254:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80325b:	48 89 d6             	mov    %rdx,%rsi
  80325e:	48 89 c7             	mov    %rax,%rdi
  803261:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80326d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803270:	01 45 fc             	add    %eax,-0x4(%rbp)
  803273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803276:	48 98                	cltq   
  803278:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80327f:	0f 82 78 ff ff ff    	jb     8031fd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803285:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803288:	c9                   	leaveq 
  803289:	c3                   	retq   

000000000080328a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80328a:	55                   	push   %rbp
  80328b:	48 89 e5             	mov    %rsp,%rbp
  80328e:	48 83 ec 08          	sub    $0x8,%rsp
  803292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803296:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 10          	sub    $0x10,%rsp
  8032a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	48 be 4e 3a 80 00 00 	movabs $0x803a4e,%rsi
  8032b8:	00 00 00 
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
	return 0;
  8032ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032cf:	c9                   	leaveq 
  8032d0:	c3                   	retq   

00000000008032d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032d1:	55                   	push   %rbp
  8032d2:	48 89 e5             	mov    %rsp,%rbp
  8032d5:	53                   	push   %rbx
  8032d6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032dd:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032e4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8032ea:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8032f1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8032f8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8032ff:	84 c0                	test   %al,%al
  803301:	74 23                	je     803326 <_panic+0x55>
  803303:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80330a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80330e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803312:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803316:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80331a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80331e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803322:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803326:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80332d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803334:	00 00 00 
  803337:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80333e:	00 00 00 
  803341:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803345:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80334c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803353:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80335a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803361:	00 00 00 
  803364:	48 8b 18             	mov    (%rax),%rbx
  803367:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803379:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803380:	41 89 c8             	mov    %ecx,%r8d
  803383:	48 89 d1             	mov    %rdx,%rcx
  803386:	48 89 da             	mov    %rbx,%rdx
  803389:	89 c6                	mov    %eax,%esi
  80338b:	48 bf 58 3a 80 00 00 	movabs $0x803a58,%rdi
  803392:	00 00 00 
  803395:	b8 00 00 00 00       	mov    $0x0,%eax
  80339a:	49 b9 f1 02 80 00 00 	movabs $0x8002f1,%r9
  8033a1:	00 00 00 
  8033a4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033a7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033ae:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033b5:	48 89 d6             	mov    %rdx,%rsi
  8033b8:	48 89 c7             	mov    %rax,%rdi
  8033bb:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
	cprintf("\n");
  8033c7:	48 bf 7b 3a 80 00 00 	movabs $0x803a7b,%rdi
  8033ce:	00 00 00 
  8033d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d6:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  8033dd:	00 00 00 
  8033e0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033e2:	cc                   	int3   
  8033e3:	eb fd                	jmp    8033e2 <_panic+0x111>

00000000008033e5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 18          	sub    $0x18,%rsp
  8033ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8033f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f5:	48 c1 e8 15          	shr    $0x15,%rax
  8033f9:	48 89 c2             	mov    %rax,%rdx
  8033fc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803403:	01 00 00 
  803406:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80340a:	83 e0 01             	and    $0x1,%eax
  80340d:	48 85 c0             	test   %rax,%rax
  803410:	75 07                	jne    803419 <pageref+0x34>
		return 0;
  803412:	b8 00 00 00 00       	mov    $0x0,%eax
  803417:	eb 53                	jmp    80346c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341d:	48 c1 e8 0c          	shr    $0xc,%rax
  803421:	48 89 c2             	mov    %rax,%rdx
  803424:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80342b:	01 00 00 
  80342e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803432:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343a:	83 e0 01             	and    $0x1,%eax
  80343d:	48 85 c0             	test   %rax,%rax
  803440:	75 07                	jne    803449 <pageref+0x64>
		return 0;
  803442:	b8 00 00 00 00       	mov    $0x0,%eax
  803447:	eb 23                	jmp    80346c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344d:	48 c1 e8 0c          	shr    $0xc,%rax
  803451:	48 89 c2             	mov    %rax,%rdx
  803454:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80345b:	00 00 00 
  80345e:	48 c1 e2 04          	shl    $0x4,%rdx
  803462:	48 01 d0             	add    %rdx,%rax
  803465:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803469:	0f b7 c0             	movzwl %ax,%eax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   
