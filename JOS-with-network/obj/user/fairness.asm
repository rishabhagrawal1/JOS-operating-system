
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
  800061:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  80008e:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf 20 3f 80 00 00 	movabs $0x803f20,%rdi
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
  8000d4:	48 bf 31 3f 80 00 00 	movabs $0x803f31,%rdi
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
  800110:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
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
  80015c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  800176:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
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
  8001ad:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
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
  80045d:	48 ba 50 41 80 00 00 	movabs $0x804150,%rdx
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
  800755:	48 b8 78 41 80 00 00 	movabs $0x804178,%rax
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
  8008a3:	83 fb 15             	cmp    $0x15,%ebx
  8008a6:	7f 16                	jg     8008be <vprintfmt+0x21a>
  8008a8:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8008af:	00 00 00 
  8008b2:	48 63 d3             	movslq %ebx,%rdx
  8008b5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008b9:	4d 85 e4             	test   %r12,%r12
  8008bc:	75 2e                	jne    8008ec <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008be:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c6:	89 d9                	mov    %ebx,%ecx
  8008c8:	48 ba 61 41 80 00 00 	movabs $0x804161,%rdx
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
  8008f7:	48 ba 6a 41 80 00 00 	movabs $0x80416a,%rdx
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
  800951:	49 bc 6d 41 80 00 00 	movabs $0x80416d,%r12
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
  801657:	48 ba 28 44 80 00 00 	movabs $0x804428,%rdx
  80165e:	00 00 00 
  801661:	be 23 00 00 00       	mov    $0x23,%esi
  801666:	48 bf 45 44 80 00 00 	movabs $0x804445,%rdi
  80166d:	00 00 00 
  801670:	b8 00 00 00 00       	mov    $0x0,%eax
  801675:	49 b9 82 3d 80 00 00 	movabs $0x803d82,%r9
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

0000000000801a42 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	48 83 ec 20          	sub    $0x20,%rsp
  801a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a61:	00 
  801a62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a73:	89 c6                	mov    %eax,%esi
  801a75:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a7a:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 20          	sub    $0x20,%rsp
  801a90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801a98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa7:	00 
  801aa8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab9:	89 c6                	mov    %eax,%esi
  801abb:	bf 10 00 00 00       	mov    $0x10,%edi
  801ac0:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801ac7:	00 00 00 
  801aca:	ff d0                	callq  *%rax
}
  801acc:	c9                   	leaveq 
  801acd:	c3                   	retq   

0000000000801ace <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ace:	55                   	push   %rbp
  801acf:	48 89 e5             	mov    %rsp,%rbp
  801ad2:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ad6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801add:	00 
  801ade:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aea:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aef:	ba 00 00 00 00       	mov    $0x0,%edx
  801af4:	be 00 00 00 00       	mov    $0x0,%esi
  801af9:	bf 0e 00 00 00       	mov    $0xe,%edi
  801afe:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
}
  801b0a:	c9                   	leaveq 
  801b0b:	c3                   	retq   

0000000000801b0c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b0c:	55                   	push   %rbp
  801b0d:	48 89 e5             	mov    %rsp,%rbp
  801b10:	48 83 ec 30          	sub    $0x30,%rsp
  801b14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  801b20:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801b27:	00 00 00 
  801b2a:	48 8b 00             	mov    (%rax),%rax
  801b2d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  801b33:	85 c0                	test   %eax,%eax
  801b35:	75 3c                	jne    801b73 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b37:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  801b3e:	00 00 00 
  801b41:	ff d0                	callq  *%rax
  801b43:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b48:	48 63 d0             	movslq %eax,%rdx
  801b4b:	48 89 d0             	mov    %rdx,%rax
  801b4e:	48 c1 e0 03          	shl    $0x3,%rax
  801b52:	48 01 d0             	add    %rdx,%rax
  801b55:	48 c1 e0 05          	shl    $0x5,%rax
  801b59:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801b60:	00 00 00 
  801b63:	48 01 c2             	add    %rax,%rdx
  801b66:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801b6d:	00 00 00 
  801b70:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  801b73:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b78:	75 0e                	jne    801b88 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  801b7a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801b81:	00 00 00 
  801b84:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  801b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b8c:	48 89 c7             	mov    %rax,%rdi
  801b8f:	48 b8 fe 19 80 00 00 	movabs $0x8019fe,%rax
  801b96:	00 00 00 
  801b99:	ff d0                	callq  *%rax
  801b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  801b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ba2:	79 19                	jns    801bbd <ipc_recv+0xb1>
		*from_env_store = 0;
  801ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  801bae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	eb 53                	jmp    801c10 <ipc_recv+0x104>
	}
	if(from_env_store)
  801bbd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc2:	74 19                	je     801bdd <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  801bc4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801bcb:	00 00 00 
  801bce:	48 8b 00             	mov    (%rax),%rax
  801bd1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bdb:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  801bdd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801be2:	74 19                	je     801bfd <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  801be4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801beb:	00 00 00 
  801bee:	48 8b 00             	mov    (%rax),%rax
  801bf1:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801bf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfb:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  801bfd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801c04:	00 00 00 
  801c07:	48 8b 00             	mov    (%rax),%rax
  801c0a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  801c10:	c9                   	leaveq 
  801c11:	c3                   	retq   

0000000000801c12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c12:	55                   	push   %rbp
  801c13:	48 89 e5             	mov    %rsp,%rbp
  801c16:	48 83 ec 30          	sub    $0x30,%rsp
  801c1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c1d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801c20:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801c24:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  801c27:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801c2c:	75 0e                	jne    801c3c <ipc_send+0x2a>
		pg = (void*)UTOP;
  801c2e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801c35:	00 00 00 
  801c38:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  801c3c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801c3f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c42:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c49:	89 c7                	mov    %eax,%edi
  801c4b:	48 b8 a9 19 80 00 00 	movabs $0x8019a9,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	callq  *%rax
  801c57:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  801c5a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801c5e:	75 0c                	jne    801c6c <ipc_send+0x5a>
			sys_yield();
  801c60:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  801c67:	00 00 00 
  801c6a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  801c6c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801c70:	74 ca                	je     801c3c <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  801c72:	c9                   	leaveq 
  801c73:	c3                   	retq   

0000000000801c74 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c74:	55                   	push   %rbp
  801c75:	48 89 e5             	mov    %rsp,%rbp
  801c78:	48 83 ec 14          	sub    $0x14,%rsp
  801c7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801c7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c86:	eb 5e                	jmp    801ce6 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801c88:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801c8f:	00 00 00 
  801c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c95:	48 63 d0             	movslq %eax,%rdx
  801c98:	48 89 d0             	mov    %rdx,%rax
  801c9b:	48 c1 e0 03          	shl    $0x3,%rax
  801c9f:	48 01 d0             	add    %rdx,%rax
  801ca2:	48 c1 e0 05          	shl    $0x5,%rax
  801ca6:	48 01 c8             	add    %rcx,%rax
  801ca9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801caf:	8b 00                	mov    (%rax),%eax
  801cb1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801cb4:	75 2c                	jne    801ce2 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801cb6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801cbd:	00 00 00 
  801cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc3:	48 63 d0             	movslq %eax,%rdx
  801cc6:	48 89 d0             	mov    %rdx,%rax
  801cc9:	48 c1 e0 03          	shl    $0x3,%rax
  801ccd:	48 01 d0             	add    %rdx,%rax
  801cd0:	48 c1 e0 05          	shl    $0x5,%rax
  801cd4:	48 01 c8             	add    %rcx,%rax
  801cd7:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801cdd:	8b 40 08             	mov    0x8(%rax),%eax
  801ce0:	eb 12                	jmp    801cf4 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  801ce2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ce6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801ced:	7e 99                	jle    801c88 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 83 ec 08          	sub    $0x8,%rsp
  801cfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d06:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d0d:	ff ff ff 
  801d10:	48 01 d0             	add    %rdx,%rax
  801d13:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d17:	c9                   	leaveq 
  801d18:	c3                   	retq   

0000000000801d19 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d19:	55                   	push   %rbp
  801d1a:	48 89 e5             	mov    %rsp,%rbp
  801d1d:	48 83 ec 08          	sub    $0x8,%rsp
  801d21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d29:	48 89 c7             	mov    %rax,%rdi
  801d2c:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801d33:	00 00 00 
  801d36:	ff d0                	callq  *%rax
  801d38:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d3e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d42:	c9                   	leaveq 
  801d43:	c3                   	retq   

0000000000801d44 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d44:	55                   	push   %rbp
  801d45:	48 89 e5             	mov    %rsp,%rbp
  801d48:	48 83 ec 18          	sub    $0x18,%rsp
  801d4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d57:	eb 6b                	jmp    801dc4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5c:	48 98                	cltq   
  801d5e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d64:	48 c1 e0 0c          	shl    $0xc,%rax
  801d68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d70:	48 c1 e8 15          	shr    $0x15,%rax
  801d74:	48 89 c2             	mov    %rax,%rdx
  801d77:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d7e:	01 00 00 
  801d81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d85:	83 e0 01             	and    $0x1,%eax
  801d88:	48 85 c0             	test   %rax,%rax
  801d8b:	74 21                	je     801dae <fd_alloc+0x6a>
  801d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d91:	48 c1 e8 0c          	shr    $0xc,%rax
  801d95:	48 89 c2             	mov    %rax,%rdx
  801d98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d9f:	01 00 00 
  801da2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da6:	83 e0 01             	and    $0x1,%eax
  801da9:	48 85 c0             	test   %rax,%rax
  801dac:	75 12                	jne    801dc0 <fd_alloc+0x7c>
			*fd_store = fd;
  801dae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	eb 1a                	jmp    801dda <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dc8:	7e 8f                	jle    801d59 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dce:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dd5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dda:	c9                   	leaveq 
  801ddb:	c3                   	retq   

0000000000801ddc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ddc:	55                   	push   %rbp
  801ddd:	48 89 e5             	mov    %rsp,%rbp
  801de0:	48 83 ec 20          	sub    $0x20,%rsp
  801de4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801de7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801deb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801def:	78 06                	js     801df7 <fd_lookup+0x1b>
  801df1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801df5:	7e 07                	jle    801dfe <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfc:	eb 6c                	jmp    801e6a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801dfe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e01:	48 98                	cltq   
  801e03:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e09:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e15:	48 c1 e8 15          	shr    $0x15,%rax
  801e19:	48 89 c2             	mov    %rax,%rdx
  801e1c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e23:	01 00 00 
  801e26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2a:	83 e0 01             	and    $0x1,%eax
  801e2d:	48 85 c0             	test   %rax,%rax
  801e30:	74 21                	je     801e53 <fd_lookup+0x77>
  801e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e36:	48 c1 e8 0c          	shr    $0xc,%rax
  801e3a:	48 89 c2             	mov    %rax,%rdx
  801e3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e44:	01 00 00 
  801e47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4b:	83 e0 01             	and    $0x1,%eax
  801e4e:	48 85 c0             	test   %rax,%rax
  801e51:	75 07                	jne    801e5a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e58:	eb 10                	jmp    801e6a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e62:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6a:	c9                   	leaveq 
  801e6b:	c3                   	retq   

0000000000801e6c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e6c:	55                   	push   %rbp
  801e6d:	48 89 e5             	mov    %rsp,%rbp
  801e70:	48 83 ec 30          	sub    $0x30,%rsp
  801e74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e78:	89 f0                	mov    %esi,%eax
  801e7a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 89 c7             	mov    %rax,%rdi
  801e84:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
  801e90:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e94:	48 89 d6             	mov    %rdx,%rsi
  801e97:	89 c7                	mov    %eax,%edi
  801e99:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  801ea0:	00 00 00 
  801ea3:	ff d0                	callq  *%rax
  801ea5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eac:	78 0a                	js     801eb8 <fd_close+0x4c>
	    || fd != fd2)
  801eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eb6:	74 12                	je     801eca <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eb8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ebc:	74 05                	je     801ec3 <fd_close+0x57>
  801ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec1:	eb 05                	jmp    801ec8 <fd_close+0x5c>
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	eb 69                	jmp    801f33 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801eca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ece:	8b 00                	mov    (%rax),%eax
  801ed0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ed4:	48 89 d6             	mov    %rdx,%rsi
  801ed7:	89 c7                	mov    %eax,%edi
  801ed9:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	callq  *%rax
  801ee5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ee8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eec:	78 2a                	js     801f18 <fd_close+0xac>
		if (dev->dev_close)
  801eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef2:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ef6:	48 85 c0             	test   %rax,%rax
  801ef9:	74 16                	je     801f11 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eff:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f07:	48 89 d7             	mov    %rdx,%rdi
  801f0a:	ff d0                	callq  *%rax
  801f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0f:	eb 07                	jmp    801f18 <fd_close+0xac>
		else
			r = 0;
  801f11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1c:	48 89 c6             	mov    %rax,%rsi
  801f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f24:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
	return r;
  801f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f33:	c9                   	leaveq 
  801f34:	c3                   	retq   

0000000000801f35 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f35:	55                   	push   %rbp
  801f36:	48 89 e5             	mov    %rsp,%rbp
  801f39:	48 83 ec 20          	sub    $0x20,%rsp
  801f3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f4b:	eb 41                	jmp    801f8e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f4d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f54:	00 00 00 
  801f57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5a:	48 63 d2             	movslq %edx,%rdx
  801f5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f61:	8b 00                	mov    (%rax),%eax
  801f63:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f66:	75 22                	jne    801f8a <dev_lookup+0x55>
			*dev = devtab[i];
  801f68:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f6f:	00 00 00 
  801f72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f75:	48 63 d2             	movslq %edx,%rdx
  801f78:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f80:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	eb 60                	jmp    801fea <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f8e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f95:	00 00 00 
  801f98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f9b:	48 63 d2             	movslq %edx,%rdx
  801f9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa2:	48 85 c0             	test   %rax,%rax
  801fa5:	75 a6                	jne    801f4d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fa7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fae:	00 00 00 
  801fb1:	48 8b 00             	mov    (%rax),%rax
  801fb4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fbd:	89 c6                	mov    %eax,%esi
  801fbf:	48 bf 58 44 80 00 00 	movabs $0x804458,%rdi
  801fc6:	00 00 00 
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  801fd5:	00 00 00 
  801fd8:	ff d1                	callq  *%rcx
	*dev = 0;
  801fda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fde:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fe5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fea:	c9                   	leaveq 
  801feb:	c3                   	retq   

0000000000801fec <close>:

int
close(int fdnum)
{
  801fec:	55                   	push   %rbp
  801fed:	48 89 e5             	mov    %rsp,%rbp
  801ff0:	48 83 ec 20          	sub    $0x20,%rsp
  801ff4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ffb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ffe:	48 89 d6             	mov    %rdx,%rsi
  802001:	89 c7                	mov    %eax,%edi
  802003:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  80200a:	00 00 00 
  80200d:	ff d0                	callq  *%rax
  80200f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802012:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802016:	79 05                	jns    80201d <close+0x31>
		return r;
  802018:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201b:	eb 18                	jmp    802035 <close+0x49>
	else
		return fd_close(fd, 1);
  80201d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802021:	be 01 00 00 00       	mov    $0x1,%esi
  802026:	48 89 c7             	mov    %rax,%rdi
  802029:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  802030:	00 00 00 
  802033:	ff d0                	callq  *%rax
}
  802035:	c9                   	leaveq 
  802036:	c3                   	retq   

0000000000802037 <close_all>:

void
close_all(void)
{
  802037:	55                   	push   %rbp
  802038:	48 89 e5             	mov    %rsp,%rbp
  80203b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80203f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802046:	eb 15                	jmp    80205d <close_all+0x26>
		close(i);
  802048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204b:	89 c7                	mov    %eax,%edi
  80204d:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802054:	00 00 00 
  802057:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802059:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802061:	7e e5                	jle    802048 <close_all+0x11>
		close(i);
}
  802063:	c9                   	leaveq 
  802064:	c3                   	retq   

0000000000802065 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802065:	55                   	push   %rbp
  802066:	48 89 e5             	mov    %rsp,%rbp
  802069:	48 83 ec 40          	sub    $0x40,%rsp
  80206d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802070:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802073:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802077:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80207a:	48 89 d6             	mov    %rdx,%rsi
  80207d:	89 c7                	mov    %eax,%edi
  80207f:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  802086:	00 00 00 
  802089:	ff d0                	callq  *%rax
  80208b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802092:	79 08                	jns    80209c <dup+0x37>
		return r;
  802094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802097:	e9 70 01 00 00       	jmpq   80220c <dup+0x1a7>
	close(newfdnum);
  80209c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80209f:	89 c7                	mov    %eax,%edi
  8020a1:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020ad:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b0:	48 98                	cltq   
  8020b2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020b8:	48 c1 e0 0c          	shl    $0xc,%rax
  8020bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c4:	48 89 c7             	mov    %rax,%rdi
  8020c7:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  8020ce:	00 00 00 
  8020d1:	ff d0                	callq  *%rax
  8020d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020db:	48 89 c7             	mov    %rax,%rdi
  8020de:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  8020e5:	00 00 00 
  8020e8:	ff d0                	callq  *%rax
  8020ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f2:	48 c1 e8 15          	shr    $0x15,%rax
  8020f6:	48 89 c2             	mov    %rax,%rdx
  8020f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802100:	01 00 00 
  802103:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802107:	83 e0 01             	and    $0x1,%eax
  80210a:	48 85 c0             	test   %rax,%rax
  80210d:	74 73                	je     802182 <dup+0x11d>
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	48 c1 e8 0c          	shr    $0xc,%rax
  802117:	48 89 c2             	mov    %rax,%rdx
  80211a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802121:	01 00 00 
  802124:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802128:	83 e0 01             	and    $0x1,%eax
  80212b:	48 85 c0             	test   %rax,%rax
  80212e:	74 52                	je     802182 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802134:	48 c1 e8 0c          	shr    $0xc,%rax
  802138:	48 89 c2             	mov    %rax,%rdx
  80213b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802142:	01 00 00 
  802145:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802149:	25 07 0e 00 00       	and    $0xe07,%eax
  80214e:	89 c1                	mov    %eax,%ecx
  802150:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802158:	41 89 c8             	mov    %ecx,%r8d
  80215b:	48 89 d1             	mov    %rdx,%rcx
  80215e:	ba 00 00 00 00       	mov    $0x0,%edx
  802163:	48 89 c6             	mov    %rax,%rsi
  802166:	bf 00 00 00 00       	mov    $0x0,%edi
  80216b:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  802172:	00 00 00 
  802175:	ff d0                	callq  *%rax
  802177:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217e:	79 02                	jns    802182 <dup+0x11d>
			goto err;
  802180:	eb 57                	jmp    8021d9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802186:	48 c1 e8 0c          	shr    $0xc,%rax
  80218a:	48 89 c2             	mov    %rax,%rdx
  80218d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802194:	01 00 00 
  802197:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219b:	25 07 0e 00 00       	and    $0xe07,%eax
  8021a0:	89 c1                	mov    %eax,%ecx
  8021a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021aa:	41 89 c8             	mov    %ecx,%r8d
  8021ad:	48 89 d1             	mov    %rdx,%rcx
  8021b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b5:	48 89 c6             	mov    %rax,%rsi
  8021b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bd:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d0:	79 02                	jns    8021d4 <dup+0x16f>
		goto err;
  8021d2:	eb 05                	jmp    8021d9 <dup+0x174>

	return newfdnum;
  8021d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d7:	eb 33                	jmp    80220c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021dd:	48 89 c6             	mov    %rax,%rsi
  8021e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e5:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f5:	48 89 c6             	mov    %rax,%rsi
  8021f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fd:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
	return r;
  802209:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80220c:	c9                   	leaveq 
  80220d:	c3                   	retq   

000000000080220e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80220e:	55                   	push   %rbp
  80220f:	48 89 e5             	mov    %rsp,%rbp
  802212:	48 83 ec 40          	sub    $0x40,%rsp
  802216:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802219:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80221d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802221:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802225:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802228:	48 89 d6             	mov    %rdx,%rsi
  80222b:	89 c7                	mov    %eax,%edi
  80222d:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802240:	78 24                	js     802266 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802246:	8b 00                	mov    (%rax),%eax
  802248:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80224c:	48 89 d6             	mov    %rdx,%rsi
  80224f:	89 c7                	mov    %eax,%edi
  802251:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802260:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802264:	79 05                	jns    80226b <read+0x5d>
		return r;
  802266:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802269:	eb 76                	jmp    8022e1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80226b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226f:	8b 40 08             	mov    0x8(%rax),%eax
  802272:	83 e0 03             	and    $0x3,%eax
  802275:	83 f8 01             	cmp    $0x1,%eax
  802278:	75 3a                	jne    8022b4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80227a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802281:	00 00 00 
  802284:	48 8b 00             	mov    (%rax),%rax
  802287:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80228d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802290:	89 c6                	mov    %eax,%esi
  802292:	48 bf 77 44 80 00 00 	movabs $0x804477,%rdi
  802299:	00 00 00 
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a1:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8022a8:	00 00 00 
  8022ab:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b2:	eb 2d                	jmp    8022e1 <read+0xd3>
	}
	if (!dev->dev_read)
  8022b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022bc:	48 85 c0             	test   %rax,%rax
  8022bf:	75 07                	jne    8022c8 <read+0xba>
		return -E_NOT_SUPP;
  8022c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022c6:	eb 19                	jmp    8022e1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cc:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022d0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022d8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022dc:	48 89 cf             	mov    %rcx,%rdi
  8022df:	ff d0                	callq  *%rax
}
  8022e1:	c9                   	leaveq 
  8022e2:	c3                   	retq   

00000000008022e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022e3:	55                   	push   %rbp
  8022e4:	48 89 e5             	mov    %rsp,%rbp
  8022e7:	48 83 ec 30          	sub    $0x30,%rsp
  8022eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022fd:	eb 49                	jmp    802348 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802302:	48 98                	cltq   
  802304:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802308:	48 29 c2             	sub    %rax,%rdx
  80230b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230e:	48 63 c8             	movslq %eax,%rcx
  802311:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802315:	48 01 c1             	add    %rax,%rcx
  802318:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231b:	48 89 ce             	mov    %rcx,%rsi
  80231e:	89 c7                	mov    %eax,%edi
  802320:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802327:	00 00 00 
  80232a:	ff d0                	callq  *%rax
  80232c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80232f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802333:	79 05                	jns    80233a <readn+0x57>
			return m;
  802335:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802338:	eb 1c                	jmp    802356 <readn+0x73>
		if (m == 0)
  80233a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80233e:	75 02                	jne    802342 <readn+0x5f>
			break;
  802340:	eb 11                	jmp    802353 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802342:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802345:	01 45 fc             	add    %eax,-0x4(%rbp)
  802348:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234b:	48 98                	cltq   
  80234d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802351:	72 ac                	jb     8022ff <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802353:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802356:	c9                   	leaveq 
  802357:	c3                   	retq   

0000000000802358 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802358:	55                   	push   %rbp
  802359:	48 89 e5             	mov    %rsp,%rbp
  80235c:	48 83 ec 40          	sub    $0x40,%rsp
  802360:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802363:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802367:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80236f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802372:	48 89 d6             	mov    %rdx,%rsi
  802375:	89 c7                	mov    %eax,%edi
  802377:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  80237e:	00 00 00 
  802381:	ff d0                	callq  *%rax
  802383:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802386:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238a:	78 24                	js     8023b0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80238c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802390:	8b 00                	mov    (%rax),%eax
  802392:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802396:	48 89 d6             	mov    %rdx,%rsi
  802399:	89 c7                	mov    %eax,%edi
  80239b:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	callq  *%rax
  8023a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ae:	79 05                	jns    8023b5 <write+0x5d>
		return r;
  8023b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b3:	eb 75                	jmp    80242a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b9:	8b 40 08             	mov    0x8(%rax),%eax
  8023bc:	83 e0 03             	and    $0x3,%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	75 3a                	jne    8023fd <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023c3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023ca:	00 00 00 
  8023cd:	48 8b 00             	mov    (%rax),%rax
  8023d0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023d9:	89 c6                	mov    %eax,%esi
  8023db:	48 bf 93 44 80 00 00 	movabs $0x804493,%rdi
  8023e2:	00 00 00 
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  8023f1:	00 00 00 
  8023f4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023fb:	eb 2d                	jmp    80242a <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8023fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802401:	48 8b 40 18          	mov    0x18(%rax),%rax
  802405:	48 85 c0             	test   %rax,%rax
  802408:	75 07                	jne    802411 <write+0xb9>
		return -E_NOT_SUPP;
  80240a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80240f:	eb 19                	jmp    80242a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802415:	48 8b 40 18          	mov    0x18(%rax),%rax
  802419:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80241d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802421:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802425:	48 89 cf             	mov    %rcx,%rdi
  802428:	ff d0                	callq  *%rax
}
  80242a:	c9                   	leaveq 
  80242b:	c3                   	retq   

000000000080242c <seek>:

int
seek(int fdnum, off_t offset)
{
  80242c:	55                   	push   %rbp
  80242d:	48 89 e5             	mov    %rsp,%rbp
  802430:	48 83 ec 18          	sub    $0x18,%rsp
  802434:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802437:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802441:	48 89 d6             	mov    %rdx,%rsi
  802444:	89 c7                	mov    %eax,%edi
  802446:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  80244d:	00 00 00 
  802450:	ff d0                	callq  *%rax
  802452:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802455:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802459:	79 05                	jns    802460 <seek+0x34>
		return r;
  80245b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245e:	eb 0f                	jmp    80246f <seek+0x43>
	fd->fd_offset = offset;
  802460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802464:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802467:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246f:	c9                   	leaveq 
  802470:	c3                   	retq   

0000000000802471 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802471:	55                   	push   %rbp
  802472:	48 89 e5             	mov    %rsp,%rbp
  802475:	48 83 ec 30          	sub    $0x30,%rsp
  802479:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80247f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802483:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802486:	48 89 d6             	mov    %rdx,%rsi
  802489:	89 c7                	mov    %eax,%edi
  80248b:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
  802497:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249e:	78 24                	js     8024c4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a4:	8b 00                	mov    (%rax),%eax
  8024a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024aa:	48 89 d6             	mov    %rdx,%rsi
  8024ad:	89 c7                	mov    %eax,%edi
  8024af:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
  8024bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c2:	79 05                	jns    8024c9 <ftruncate+0x58>
		return r;
  8024c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c7:	eb 72                	jmp    80253b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cd:	8b 40 08             	mov    0x8(%rax),%eax
  8024d0:	83 e0 03             	and    $0x3,%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	75 3a                	jne    802511 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024d7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024de:	00 00 00 
  8024e1:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024e4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024ea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	48 bf b0 44 80 00 00 	movabs $0x8044b0,%rdi
  8024f6:	00 00 00 
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	48 b9 f1 02 80 00 00 	movabs $0x8002f1,%rcx
  802505:	00 00 00 
  802508:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80250a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80250f:	eb 2a                	jmp    80253b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802515:	48 8b 40 30          	mov    0x30(%rax),%rax
  802519:	48 85 c0             	test   %rax,%rax
  80251c:	75 07                	jne    802525 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80251e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802523:	eb 16                	jmp    80253b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802529:	48 8b 40 30          	mov    0x30(%rax),%rax
  80252d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802531:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802534:	89 ce                	mov    %ecx,%esi
  802536:	48 89 d7             	mov    %rdx,%rdi
  802539:	ff d0                	callq  *%rax
}
  80253b:	c9                   	leaveq 
  80253c:	c3                   	retq   

000000000080253d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80253d:	55                   	push   %rbp
  80253e:	48 89 e5             	mov    %rsp,%rbp
  802541:	48 83 ec 30          	sub    $0x30,%rsp
  802545:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802548:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80254c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802550:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802553:	48 89 d6             	mov    %rdx,%rsi
  802556:	89 c7                	mov    %eax,%edi
  802558:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  80255f:	00 00 00 
  802562:	ff d0                	callq  *%rax
  802564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256b:	78 24                	js     802591 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80256d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802571:	8b 00                	mov    (%rax),%eax
  802573:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802577:	48 89 d6             	mov    %rdx,%rsi
  80257a:	89 c7                	mov    %eax,%edi
  80257c:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  802583:	00 00 00 
  802586:	ff d0                	callq  *%rax
  802588:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258f:	79 05                	jns    802596 <fstat+0x59>
		return r;
  802591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802594:	eb 5e                	jmp    8025f4 <fstat+0xb7>
	if (!dev->dev_stat)
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80259e:	48 85 c0             	test   %rax,%rax
  8025a1:	75 07                	jne    8025aa <fstat+0x6d>
		return -E_NOT_SUPP;
  8025a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a8:	eb 4a                	jmp    8025f4 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ae:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025bc:	00 00 00 
	stat->st_isdir = 0;
  8025bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025c3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025ca:	00 00 00 
	stat->st_dev = dev;
  8025cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025ec:	48 89 ce             	mov    %rcx,%rsi
  8025ef:	48 89 d7             	mov    %rdx,%rdi
  8025f2:	ff d0                	callq  *%rax
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 20          	sub    $0x20,%rsp
  8025fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802602:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260a:	be 00 00 00 00       	mov    $0x0,%esi
  80260f:	48 89 c7             	mov    %rax,%rdi
  802612:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802625:	79 05                	jns    80262c <stat+0x36>
		return fd;
  802627:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262a:	eb 2f                	jmp    80265b <stat+0x65>
	r = fstat(fd, stat);
  80262c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802630:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802633:	48 89 d6             	mov    %rdx,%rsi
  802636:	89 c7                	mov    %eax,%edi
  802638:	48 b8 3d 25 80 00 00 	movabs $0x80253d,%rax
  80263f:	00 00 00 
  802642:	ff d0                	callq  *%rax
  802644:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
	return r;
  802658:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80265b:	c9                   	leaveq 
  80265c:	c3                   	retq   

000000000080265d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80265d:	55                   	push   %rbp
  80265e:	48 89 e5             	mov    %rsp,%rbp
  802661:	48 83 ec 10          	sub    $0x10,%rsp
  802665:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802668:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80266c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802673:	00 00 00 
  802676:	8b 00                	mov    (%rax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	75 1d                	jne    802699 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80267c:	bf 01 00 00 00       	mov    $0x1,%edi
  802681:	48 b8 74 1c 80 00 00 	movabs $0x801c74,%rax
  802688:	00 00 00 
  80268b:	ff d0                	callq  *%rax
  80268d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802694:	00 00 00 
  802697:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802699:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026a0:	00 00 00 
  8026a3:	8b 00                	mov    (%rax),%eax
  8026a5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026a8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026ad:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026b4:	00 00 00 
  8026b7:	89 c7                	mov    %eax,%edi
  8026b9:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ce:	48 89 c6             	mov    %rax,%rsi
  8026d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d6:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
}
  8026e2:	c9                   	leaveq 
  8026e3:	c3                   	retq   

00000000008026e4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026e4:	55                   	push   %rbp
  8026e5:	48 89 e5             	mov    %rsp,%rbp
  8026e8:	48 83 ec 30          	sub    $0x30,%rsp
  8026ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026f0:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026f3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026fa:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802708:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80270d:	75 08                	jne    802717 <open+0x33>
	{
		return r;
  80270f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802712:	e9 f2 00 00 00       	jmpq   802809 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271b:	48 89 c7             	mov    %rax,%rdi
  80271e:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
  80272a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80272d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802734:	7e 0a                	jle    802740 <open+0x5c>
	{
		return -E_BAD_PATH;
  802736:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80273b:	e9 c9 00 00 00       	jmpq   802809 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802740:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802747:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802748:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80274c:	48 89 c7             	mov    %rax,%rdi
  80274f:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  802756:	00 00 00 
  802759:	ff d0                	callq  *%rax
  80275b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80275e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802762:	78 09                	js     80276d <open+0x89>
  802764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802768:	48 85 c0             	test   %rax,%rax
  80276b:	75 08                	jne    802775 <open+0x91>
		{
			return r;
  80276d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802770:	e9 94 00 00 00       	jmpq   802809 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802779:	ba 00 04 00 00       	mov    $0x400,%edx
  80277e:	48 89 c6             	mov    %rax,%rsi
  802781:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802788:	00 00 00 
  80278b:	48 b8 38 0f 80 00 00 	movabs $0x800f38,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802797:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80279e:	00 00 00 
  8027a1:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027a4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8027aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ae:	48 89 c6             	mov    %rax,%rsi
  8027b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8027b6:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
  8027c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c9:	79 2b                	jns    8027f6 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8027cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cf:	be 00 00 00 00       	mov    $0x0,%esi
  8027d4:	48 89 c7             	mov    %rax,%rdi
  8027d7:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
  8027e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ea:	79 05                	jns    8027f1 <open+0x10d>
			{
				return d;
  8027ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ef:	eb 18                	jmp    802809 <open+0x125>
			}
			return r;
  8027f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f4:	eb 13                	jmp    802809 <open+0x125>
		}	
		return fd2num(fd_store);
  8027f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fa:	48 89 c7             	mov    %rax,%rdi
  8027fd:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  802804:	00 00 00 
  802807:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802809:	c9                   	leaveq 
  80280a:	c3                   	retq   

000000000080280b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80280b:	55                   	push   %rbp
  80280c:	48 89 e5             	mov    %rsp,%rbp
  80280f:	48 83 ec 10          	sub    $0x10,%rsp
  802813:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281b:	8b 50 0c             	mov    0xc(%rax),%edx
  80281e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802825:	00 00 00 
  802828:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80282a:	be 00 00 00 00       	mov    $0x0,%esi
  80282f:	bf 06 00 00 00       	mov    $0x6,%edi
  802834:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  80283b:	00 00 00 
  80283e:	ff d0                	callq  *%rax
}
  802840:	c9                   	leaveq 
  802841:	c3                   	retq   

0000000000802842 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802842:	55                   	push   %rbp
  802843:	48 89 e5             	mov    %rsp,%rbp
  802846:	48 83 ec 30          	sub    $0x30,%rsp
  80284a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80284e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802852:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802856:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  80285d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802862:	74 07                	je     80286b <devfile_read+0x29>
  802864:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802869:	75 07                	jne    802872 <devfile_read+0x30>
		return -E_INVAL;
  80286b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802870:	eb 77                	jmp    8028e9 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802876:	8b 50 0c             	mov    0xc(%rax),%edx
  802879:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802880:	00 00 00 
  802883:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802885:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288c:	00 00 00 
  80288f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802893:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802897:	be 00 00 00 00       	mov    $0x0,%esi
  80289c:	bf 03 00 00 00       	mov    $0x3,%edi
  8028a1:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
  8028ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b4:	7f 05                	jg     8028bb <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8028b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b9:	eb 2e                	jmp    8028e9 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8028bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028be:	48 63 d0             	movslq %eax,%rdx
  8028c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028cc:	00 00 00 
  8028cf:	48 89 c7             	mov    %rax,%rdi
  8028d2:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  8028de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  8028e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 30          	sub    $0x30,%rsp
  8028f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8028ff:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802906:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80290b:	74 07                	je     802914 <devfile_write+0x29>
  80290d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802912:	75 08                	jne    80291c <devfile_write+0x31>
		return r;
  802914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802917:	e9 9a 00 00 00       	jmpq   8029b6 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80291c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802920:	8b 50 0c             	mov    0xc(%rax),%edx
  802923:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292a:	00 00 00 
  80292d:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80292f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802936:	00 
  802937:	76 08                	jbe    802941 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802939:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802940:	00 
	}
	fsipcbuf.write.req_n = n;
  802941:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802948:	00 00 00 
  80294b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80294f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802953:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802957:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295b:	48 89 c6             	mov    %rax,%rsi
  80295e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802965:	00 00 00 
  802968:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802974:	be 00 00 00 00       	mov    $0x0,%esi
  802979:	bf 04 00 00 00       	mov    $0x4,%edi
  80297e:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
  80298a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802991:	7f 20                	jg     8029b3 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802993:	48 bf d6 44 80 00 00 	movabs $0x8044d6,%rdi
  80299a:	00 00 00 
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a2:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  8029a9:	00 00 00 
  8029ac:	ff d2                	callq  *%rdx
		return r;
  8029ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b1:	eb 03                	jmp    8029b6 <devfile_write+0xcb>
	}
	return r;
  8029b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8029b6:	c9                   	leaveq 
  8029b7:	c3                   	retq   

00000000008029b8 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 20          	sub    $0x20,%rsp
  8029c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d6:	00 00 00 
  8029d9:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029db:	be 00 00 00 00       	mov    $0x0,%esi
  8029e0:	bf 05 00 00 00       	mov    $0x5,%edi
  8029e5:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f8:	79 05                	jns    8029ff <devfile_stat+0x47>
		return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	eb 56                	jmp    802a55 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a03:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a0a:	00 00 00 
  802a0d:	48 89 c7             	mov    %rax,%rdi
  802a10:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802a17:	00 00 00 
  802a1a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a23:	00 00 00 
  802a26:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a30:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a36:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3d:	00 00 00 
  802a40:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 10          	sub    $0x10,%rsp
  802a5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a63:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a6d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a74:	00 00 00 
  802a77:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a80:	00 00 00 
  802a83:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a86:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a89:	be 00 00 00 00       	mov    $0x0,%esi
  802a8e:	bf 02 00 00 00       	mov    $0x2,%edi
  802a93:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
}
  802a9f:	c9                   	leaveq 
  802aa0:	c3                   	retq   

0000000000802aa1 <remove>:

// Delete a file
int
remove(const char *path)
{
  802aa1:	55                   	push   %rbp
  802aa2:	48 89 e5             	mov    %rsp,%rbp
  802aa5:	48 83 ec 10          	sub    $0x10,%rsp
  802aa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab1:	48 89 c7             	mov    %rax,%rdi
  802ab4:	48 b8 3a 0e 80 00 00 	movabs $0x800e3a,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
  802ac0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ac5:	7e 07                	jle    802ace <remove+0x2d>
		return -E_BAD_PATH;
  802ac7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802acc:	eb 33                	jmp    802b01 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ace:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad2:	48 89 c6             	mov    %rax,%rsi
  802ad5:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802adc:	00 00 00 
  802adf:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aeb:	be 00 00 00 00       	mov    $0x0,%esi
  802af0:	bf 07 00 00 00       	mov    $0x7,%edi
  802af5:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	callq  *%rax
}
  802b01:	c9                   	leaveq 
  802b02:	c3                   	retq   

0000000000802b03 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b03:	55                   	push   %rbp
  802b04:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b07:	be 00 00 00 00       	mov    $0x0,%esi
  802b0c:	bf 08 00 00 00       	mov    $0x8,%edi
  802b11:	48 b8 5d 26 80 00 00 	movabs $0x80265d,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
}
  802b1d:	5d                   	pop    %rbp
  802b1e:	c3                   	retq   

0000000000802b1f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b1f:	55                   	push   %rbp
  802b20:	48 89 e5             	mov    %rsp,%rbp
  802b23:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b2a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b31:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b38:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b3f:	be 00 00 00 00       	mov    $0x0,%esi
  802b44:	48 89 c7             	mov    %rax,%rdi
  802b47:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	79 28                	jns    802b84 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5f:	89 c6                	mov    %eax,%esi
  802b61:	48 bf f2 44 80 00 00 	movabs $0x8044f2,%rdi
  802b68:	00 00 00 
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b70:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802b77:	00 00 00 
  802b7a:	ff d2                	callq  *%rdx
		return fd_src;
  802b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7f:	e9 74 01 00 00       	jmpq   802cf8 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b84:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b8b:	be 01 01 00 00       	mov    $0x101,%esi
  802b90:	48 89 c7             	mov    %rax,%rdi
  802b93:	48 b8 e4 26 80 00 00 	movabs $0x8026e4,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
  802b9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ba2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ba6:	79 39                	jns    802be1 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ba8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bab:	89 c6                	mov    %eax,%esi
  802bad:	48 bf 08 45 80 00 00 	movabs $0x804508,%rdi
  802bb4:	00 00 00 
  802bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbc:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802bc3:	00 00 00 
  802bc6:	ff d2                	callq  *%rdx
		close(fd_src);
  802bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcb:	89 c7                	mov    %eax,%edi
  802bcd:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
		return fd_dest;
  802bd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdc:	e9 17 01 00 00       	jmpq   802cf8 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802be1:	eb 74                	jmp    802c57 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802be3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802be6:	48 63 d0             	movslq %eax,%rdx
  802be9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf3:	48 89 ce             	mov    %rcx,%rsi
  802bf6:	89 c7                	mov    %eax,%edi
  802bf8:	48 b8 58 23 80 00 00 	movabs $0x802358,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
  802c04:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c0b:	79 4a                	jns    802c57 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c0d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c10:	89 c6                	mov    %eax,%esi
  802c12:	48 bf 22 45 80 00 00 	movabs $0x804522,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802c28:	00 00 00 
  802c2b:	ff d2                	callq  *%rdx
			close(fd_src);
  802c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c30:	89 c7                	mov    %eax,%edi
  802c32:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802c39:	00 00 00 
  802c3c:	ff d0                	callq  *%rax
			close(fd_dest);
  802c3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802c4a:	00 00 00 
  802c4d:	ff d0                	callq  *%rax
			return write_size;
  802c4f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c52:	e9 a1 00 00 00       	jmpq   802cf8 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c57:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	ba 00 02 00 00       	mov    $0x200,%edx
  802c66:	48 89 ce             	mov    %rcx,%rsi
  802c69:	89 c7                	mov    %eax,%edi
  802c6b:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c7e:	0f 8f 5f ff ff ff    	jg     802be3 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c88:	79 47                	jns    802cd1 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c8d:	89 c6                	mov    %eax,%esi
  802c8f:	48 bf 35 45 80 00 00 	movabs $0x804535,%rdi
  802c96:	00 00 00 
  802c99:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9e:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  802ca5:	00 00 00 
  802ca8:	ff d2                	callq  *%rdx
		close(fd_src);
  802caa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cad:	89 c7                	mov    %eax,%edi
  802caf:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
		close(fd_dest);
  802cbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cbe:	89 c7                	mov    %eax,%edi
  802cc0:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
		return read_size;
  802ccc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ccf:	eb 27                	jmp    802cf8 <copy+0x1d9>
	}
	close(fd_src);
  802cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd4:	89 c7                	mov    %eax,%edi
  802cd6:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
	close(fd_dest);
  802ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce5:	89 c7                	mov    %eax,%edi
  802ce7:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
	return 0;
  802cf3:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cf8:	c9                   	leaveq 
  802cf9:	c3                   	retq   

0000000000802cfa <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802cfa:	55                   	push   %rbp
  802cfb:	48 89 e5             	mov    %rsp,%rbp
  802cfe:	48 83 ec 20          	sub    $0x20,%rsp
  802d02:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d0c:	48 89 d6             	mov    %rdx,%rsi
  802d0f:	89 c7                	mov    %eax,%edi
  802d11:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d24:	79 05                	jns    802d2b <fd2sockid+0x31>
		return r;
  802d26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d29:	eb 24                	jmp    802d4f <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2f:	8b 10                	mov    (%rax),%edx
  802d31:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d38:	00 00 00 
  802d3b:	8b 00                	mov    (%rax),%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	74 07                	je     802d48 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d46:	eb 07                	jmp    802d4f <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4c:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d4f:	c9                   	leaveq 
  802d50:	c3                   	retq   

0000000000802d51 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d51:	55                   	push   %rbp
  802d52:	48 89 e5             	mov    %rsp,%rbp
  802d55:	48 83 ec 20          	sub    $0x20,%rsp
  802d59:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d5c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d60:	48 89 c7             	mov    %rax,%rdi
  802d63:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d76:	78 26                	js     802d9e <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7c:	ba 07 04 00 00       	mov    $0x407,%edx
  802d81:	48 89 c6             	mov    %rax,%rsi
  802d84:	bf 00 00 00 00       	mov    $0x0,%edi
  802d89:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  802d90:	00 00 00 
  802d93:	ff d0                	callq  *%rax
  802d95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9c:	79 16                	jns    802db4 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802da1:	89 c7                	mov    %eax,%edi
  802da3:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
		return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	eb 3a                	jmp    802dee <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db8:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802dbf:	00 00 00 
  802dc2:	8b 12                	mov    (%rdx),%edx
  802dc4:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802dd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dd8:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddf:	48 89 c7             	mov    %rax,%rdi
  802de2:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
}
  802dee:	c9                   	leaveq 
  802def:	c3                   	retq   

0000000000802df0 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802df0:	55                   	push   %rbp
  802df1:	48 89 e5             	mov    %rsp,%rbp
  802df4:	48 83 ec 30          	sub    $0x30,%rsp
  802df8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e06:	89 c7                	mov    %eax,%edi
  802e08:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
  802e14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1b:	79 05                	jns    802e22 <accept+0x32>
		return r;
  802e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e20:	eb 3b                	jmp    802e5d <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e26:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2d:	48 89 ce             	mov    %rcx,%rsi
  802e30:	89 c7                	mov    %eax,%edi
  802e32:	48 b8 3b 31 80 00 00 	movabs $0x80313b,%rax
  802e39:	00 00 00 
  802e3c:	ff d0                	callq  *%rax
  802e3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e45:	79 05                	jns    802e4c <accept+0x5c>
		return r;
  802e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4a:	eb 11                	jmp    802e5d <accept+0x6d>
	return alloc_sockfd(r);
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4f:	89 c7                	mov    %eax,%edi
  802e51:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 20          	sub    $0x20,%rsp
  802e67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e6e:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e74:	89 c7                	mov    %eax,%edi
  802e76:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e89:	79 05                	jns    802e90 <bind+0x31>
		return r;
  802e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8e:	eb 1b                	jmp    802eab <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e90:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e93:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9a:	48 89 ce             	mov    %rcx,%rsi
  802e9d:	89 c7                	mov    %eax,%edi
  802e9f:	48 b8 ba 31 80 00 00 	movabs $0x8031ba,%rax
  802ea6:	00 00 00 
  802ea9:	ff d0                	callq  *%rax
}
  802eab:	c9                   	leaveq 
  802eac:	c3                   	retq   

0000000000802ead <shutdown>:

int
shutdown(int s, int how)
{
  802ead:	55                   	push   %rbp
  802eae:	48 89 e5             	mov    %rsp,%rbp
  802eb1:	48 83 ec 20          	sub    $0x20,%rsp
  802eb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802eb8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ebb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ebe:	89 c7                	mov    %eax,%edi
  802ec0:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed3:	79 05                	jns    802eda <shutdown+0x2d>
		return r;
  802ed5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed8:	eb 16                	jmp    802ef0 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802eda:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee0:	89 d6                	mov    %edx,%esi
  802ee2:	89 c7                	mov    %eax,%edi
  802ee4:	48 b8 1e 32 80 00 00 	movabs $0x80321e,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
}
  802ef0:	c9                   	leaveq 
  802ef1:	c3                   	retq   

0000000000802ef2 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ef2:	55                   	push   %rbp
  802ef3:	48 89 e5             	mov    %rsp,%rbp
  802ef6:	48 83 ec 10          	sub    $0x10,%rsp
  802efa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802efe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f02:	48 89 c7             	mov    %rax,%rdi
  802f05:	48 b8 96 3e 80 00 00 	movabs $0x803e96,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	83 f8 01             	cmp    $0x1,%eax
  802f14:	75 17                	jne    802f2d <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1a:	8b 40 0c             	mov    0xc(%rax),%eax
  802f1d:	89 c7                	mov    %eax,%edi
  802f1f:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  802f26:	00 00 00 
  802f29:	ff d0                	callq  *%rax
  802f2b:	eb 05                	jmp    802f32 <devsock_close+0x40>
	else
		return 0;
  802f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f32:	c9                   	leaveq 
  802f33:	c3                   	retq   

0000000000802f34 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f34:	55                   	push   %rbp
  802f35:	48 89 e5             	mov    %rsp,%rbp
  802f38:	48 83 ec 20          	sub    $0x20,%rsp
  802f3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f43:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f49:	89 c7                	mov    %eax,%edi
  802f4b:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5e:	79 05                	jns    802f65 <connect+0x31>
		return r;
  802f60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f63:	eb 1b                	jmp    802f80 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f65:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f68:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6f:	48 89 ce             	mov    %rcx,%rsi
  802f72:	89 c7                	mov    %eax,%edi
  802f74:	48 b8 8b 32 80 00 00 	movabs $0x80328b,%rax
  802f7b:	00 00 00 
  802f7e:	ff d0                	callq  *%rax
}
  802f80:	c9                   	leaveq 
  802f81:	c3                   	retq   

0000000000802f82 <listen>:

int
listen(int s, int backlog)
{
  802f82:	55                   	push   %rbp
  802f83:	48 89 e5             	mov    %rsp,%rbp
  802f86:	48 83 ec 20          	sub    $0x20,%rsp
  802f8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f8d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f93:	89 c7                	mov    %eax,%edi
  802f95:	48 b8 fa 2c 80 00 00 	movabs $0x802cfa,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
  802fa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa8:	79 05                	jns    802faf <listen+0x2d>
		return r;
  802faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fad:	eb 16                	jmp    802fc5 <listen+0x43>
	return nsipc_listen(r, backlog);
  802faf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb5:	89 d6                	mov    %edx,%esi
  802fb7:	89 c7                	mov    %eax,%edi
  802fb9:	48 b8 ef 32 80 00 00 	movabs $0x8032ef,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	callq  *%rax
}
  802fc5:	c9                   	leaveq 
  802fc6:	c3                   	retq   

0000000000802fc7 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802fc7:	55                   	push   %rbp
  802fc8:	48 89 e5             	mov    %rsp,%rbp
  802fcb:	48 83 ec 20          	sub    $0x20,%rsp
  802fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fd7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdf:	89 c2                	mov    %eax,%edx
  802fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe5:	8b 40 0c             	mov    0xc(%rax),%eax
  802fe8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fec:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	48 b8 2f 33 80 00 00 	movabs $0x80332f,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
}
  802fff:	c9                   	leaveq 
  803000:	c3                   	retq   

0000000000803001 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 83 ec 20          	sub    $0x20,%rsp
  803009:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80300d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803011:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803019:	89 c2                	mov    %eax,%edx
  80301b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301f:	8b 40 0c             	mov    0xc(%rax),%eax
  803022:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803026:	b9 00 00 00 00       	mov    $0x0,%ecx
  80302b:	89 c7                	mov    %eax,%edi
  80302d:	48 b8 fb 33 80 00 00 	movabs $0x8033fb,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 10          	sub    $0x10,%rsp
  803043:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803047:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80304b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304f:	48 be 50 45 80 00 00 	movabs $0x804550,%rsi
  803056:	00 00 00 
  803059:	48 89 c7             	mov    %rax,%rdi
  80305c:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
	return 0;
  803068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <socket>:

int
socket(int domain, int type, int protocol)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 20          	sub    $0x20,%rsp
  803077:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80307d:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803080:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803083:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803086:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803089:	89 ce                	mov    %ecx,%esi
  80308b:	89 c7                	mov    %eax,%edi
  80308d:	48 b8 b3 34 80 00 00 	movabs $0x8034b3,%rax
  803094:	00 00 00 
  803097:	ff d0                	callq  *%rax
  803099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a0:	79 05                	jns    8030a7 <socket+0x38>
		return r;
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	eb 11                	jmp    8030b8 <socket+0x49>
	return alloc_sockfd(r);
  8030a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030aa:	89 c7                	mov    %eax,%edi
  8030ac:	48 b8 51 2d 80 00 00 	movabs $0x802d51,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	callq  *%rax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   

00000000008030ba <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 83 ec 10          	sub    $0x10,%rsp
  8030c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030c5:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030cc:	00 00 00 
  8030cf:	8b 00                	mov    (%rax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	75 1d                	jne    8030f2 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8030d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8030da:	48 b8 74 1c 80 00 00 	movabs $0x801c74,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030ed:	00 00 00 
  8030f0:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030f2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030f9:	00 00 00 
  8030fc:	8b 00                	mov    (%rax),%eax
  8030fe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803101:	b9 07 00 00 00       	mov    $0x7,%ecx
  803106:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80310d:	00 00 00 
  803110:	89 c7                	mov    %eax,%edi
  803112:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  803119:	00 00 00 
  80311c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80311e:	ba 00 00 00 00       	mov    $0x0,%edx
  803123:	be 00 00 00 00       	mov    $0x0,%esi
  803128:	bf 00 00 00 00       	mov    $0x0,%edi
  80312d:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
}
  803139:	c9                   	leaveq 
  80313a:	c3                   	retq   

000000000080313b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80313b:	55                   	push   %rbp
  80313c:	48 89 e5             	mov    %rsp,%rbp
  80313f:	48 83 ec 30          	sub    $0x30,%rsp
  803143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80314a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80314e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803155:	00 00 00 
  803158:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80315b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80315d:	bf 01 00 00 00       	mov    $0x1,%edi
  803162:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
  80316e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803171:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803175:	78 3e                	js     8031b5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803177:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80317e:	00 00 00 
  803181:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803189:	8b 40 10             	mov    0x10(%rax),%eax
  80318c:	89 c2                	mov    %eax,%edx
  80318e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803192:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803196:	48 89 ce             	mov    %rcx,%rsi
  803199:	48 89 c7             	mov    %rax,%rdi
  80319c:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8031a3:	00 00 00 
  8031a6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ac:	8b 50 10             	mov    0x10(%rax),%edx
  8031af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031b8:	c9                   	leaveq 
  8031b9:	c3                   	retq   

00000000008031ba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031ba:	55                   	push   %rbp
  8031bb:	48 89 e5             	mov    %rsp,%rbp
  8031be:	48 83 ec 10          	sub    $0x10,%rsp
  8031c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031c9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d3:	00 00 00 
  8031d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031d9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8031db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e2:	48 89 c6             	mov    %rax,%rsi
  8031e5:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031ec:	00 00 00 
  8031ef:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8031f6:	00 00 00 
  8031f9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8031fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803202:	00 00 00 
  803205:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803208:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80320b:	bf 02 00 00 00       	mov    $0x2,%edi
  803210:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
}
  80321c:	c9                   	leaveq 
  80321d:	c3                   	retq   

000000000080321e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80321e:	55                   	push   %rbp
  80321f:	48 89 e5             	mov    %rsp,%rbp
  803222:	48 83 ec 10          	sub    $0x10,%rsp
  803226:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803229:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80322c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803233:	00 00 00 
  803236:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803239:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80323b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803242:	00 00 00 
  803245:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803248:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80324b:	bf 03 00 00 00       	mov    $0x3,%edi
  803250:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
}
  80325c:	c9                   	leaveq 
  80325d:	c3                   	retq   

000000000080325e <nsipc_close>:

int
nsipc_close(int s)
{
  80325e:	55                   	push   %rbp
  80325f:	48 89 e5             	mov    %rsp,%rbp
  803262:	48 83 ec 10          	sub    $0x10,%rsp
  803266:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803269:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803270:	00 00 00 
  803273:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803276:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803278:	bf 04 00 00 00       	mov    $0x4,%edi
  80327d:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  803284:	00 00 00 
  803287:	ff d0                	callq  *%rax
}
  803289:	c9                   	leaveq 
  80328a:	c3                   	retq   

000000000080328b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80328b:	55                   	push   %rbp
  80328c:	48 89 e5             	mov    %rsp,%rbp
  80328f:	48 83 ec 10          	sub    $0x10,%rsp
  803293:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803296:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80329a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80329d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a4:	00 00 00 
  8032a7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032aa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032ac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b3:	48 89 c6             	mov    %rax,%rsi
  8032b6:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032bd:	00 00 00 
  8032c0:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d3:	00 00 00 
  8032d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8032dc:	bf 05 00 00 00       	mov    $0x5,%edi
  8032e1:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
}
  8032ed:	c9                   	leaveq 
  8032ee:	c3                   	retq   

00000000008032ef <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8032ef:	55                   	push   %rbp
  8032f0:	48 89 e5             	mov    %rsp,%rbp
  8032f3:	48 83 ec 10          	sub    $0x10,%rsp
  8032f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032fa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8032fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803304:	00 00 00 
  803307:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80330a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80330c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803313:	00 00 00 
  803316:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803319:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80331c:	bf 06 00 00 00       	mov    $0x6,%edi
  803321:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  803328:	00 00 00 
  80332b:	ff d0                	callq  *%rax
}
  80332d:	c9                   	leaveq 
  80332e:	c3                   	retq   

000000000080332f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80332f:	55                   	push   %rbp
  803330:	48 89 e5             	mov    %rsp,%rbp
  803333:	48 83 ec 30          	sub    $0x30,%rsp
  803337:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80333a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80333e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803341:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803344:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80334b:	00 00 00 
  80334e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803351:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803353:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80335a:	00 00 00 
  80335d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803360:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803363:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336a:	00 00 00 
  80336d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803370:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803373:	bf 07 00 00 00       	mov    $0x7,%edi
  803378:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  80337f:	00 00 00 
  803382:	ff d0                	callq  *%rax
  803384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338b:	78 69                	js     8033f6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80338d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803394:	7f 08                	jg     80339e <nsipc_recv+0x6f>
  803396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803399:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80339c:	7e 35                	jle    8033d3 <nsipc_recv+0xa4>
  80339e:	48 b9 57 45 80 00 00 	movabs $0x804557,%rcx
  8033a5:	00 00 00 
  8033a8:	48 ba 6c 45 80 00 00 	movabs $0x80456c,%rdx
  8033af:	00 00 00 
  8033b2:	be 61 00 00 00       	mov    $0x61,%esi
  8033b7:	48 bf 81 45 80 00 00 	movabs $0x804581,%rdi
  8033be:	00 00 00 
  8033c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c6:	49 b8 82 3d 80 00 00 	movabs $0x803d82,%r8
  8033cd:	00 00 00 
  8033d0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	48 63 d0             	movslq %eax,%rdx
  8033d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033dd:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033e4:	00 00 00 
  8033e7:	48 89 c7             	mov    %rax,%rdi
  8033ea:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
	}

	return r;
  8033f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033f9:	c9                   	leaveq 
  8033fa:	c3                   	retq   

00000000008033fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033fb:	55                   	push   %rbp
  8033fc:	48 89 e5             	mov    %rsp,%rbp
  8033ff:	48 83 ec 20          	sub    $0x20,%rsp
  803403:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803406:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80340a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80340d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803410:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803417:	00 00 00 
  80341a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80341d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80341f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803426:	7e 35                	jle    80345d <nsipc_send+0x62>
  803428:	48 b9 8d 45 80 00 00 	movabs $0x80458d,%rcx
  80342f:	00 00 00 
  803432:	48 ba 6c 45 80 00 00 	movabs $0x80456c,%rdx
  803439:	00 00 00 
  80343c:	be 6c 00 00 00       	mov    $0x6c,%esi
  803441:	48 bf 81 45 80 00 00 	movabs $0x804581,%rdi
  803448:	00 00 00 
  80344b:	b8 00 00 00 00       	mov    $0x0,%eax
  803450:	49 b8 82 3d 80 00 00 	movabs $0x803d82,%r8
  803457:	00 00 00 
  80345a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80345d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803460:	48 63 d0             	movslq %eax,%rdx
  803463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803467:	48 89 c6             	mov    %rax,%rsi
  80346a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803471:	00 00 00 
  803474:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803480:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803487:	00 00 00 
  80348a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803490:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803497:	00 00 00 
  80349a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80349d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8034a5:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
}
  8034b1:	c9                   	leaveq 
  8034b2:	c3                   	retq   

00000000008034b3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034b3:	55                   	push   %rbp
  8034b4:	48 89 e5             	mov    %rsp,%rbp
  8034b7:	48 83 ec 10          	sub    $0x10,%rsp
  8034bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034be:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034c1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034c4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034cb:	00 00 00 
  8034ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034d1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8034d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034da:	00 00 00 
  8034dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034e0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8034e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ea:	00 00 00 
  8034ed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034f0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8034f3:	bf 09 00 00 00       	mov    $0x9,%edi
  8034f8:	48 b8 ba 30 80 00 00 	movabs $0x8030ba,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
}
  803504:	c9                   	leaveq 
  803505:	c3                   	retq   

0000000000803506 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803506:	55                   	push   %rbp
  803507:	48 89 e5             	mov    %rsp,%rbp
  80350a:	53                   	push   %rbx
  80350b:	48 83 ec 38          	sub    $0x38,%rsp
  80350f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803513:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803517:	48 89 c7             	mov    %rax,%rdi
  80351a:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
  803526:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803529:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80352d:	0f 88 bf 01 00 00    	js     8036f2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803533:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803537:	ba 07 04 00 00       	mov    $0x407,%edx
  80353c:	48 89 c6             	mov    %rax,%rsi
  80353f:	bf 00 00 00 00       	mov    $0x0,%edi
  803544:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803553:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803557:	0f 88 95 01 00 00    	js     8036f2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80355d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803561:	48 89 c7             	mov    %rax,%rdi
  803564:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  80356b:	00 00 00 
  80356e:	ff d0                	callq  *%rax
  803570:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803573:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803577:	0f 88 5d 01 00 00    	js     8036da <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80357d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803581:	ba 07 04 00 00       	mov    $0x407,%edx
  803586:	48 89 c6             	mov    %rax,%rsi
  803589:	bf 00 00 00 00       	mov    $0x0,%edi
  80358e:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
  80359a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80359d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a1:	0f 88 33 01 00 00    	js     8036da <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
  8035ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c7:	48 89 c6             	mov    %rax,%rsi
  8035ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8035cf:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
  8035db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e2:	79 05                	jns    8035e9 <pipe+0xe3>
		goto err2;
  8035e4:	e9 d9 00 00 00       	jmpq   8036c2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	48 89 c2             	mov    %rax,%rdx
  8035ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803603:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803609:	48 89 d1             	mov    %rdx,%rcx
  80360c:	ba 00 00 00 00       	mov    $0x0,%edx
  803611:	48 89 c6             	mov    %rax,%rsi
  803614:	bf 00 00 00 00       	mov    $0x0,%edi
  803619:	48 b8 25 18 80 00 00 	movabs $0x801825,%rax
  803620:	00 00 00 
  803623:	ff d0                	callq  *%rax
  803625:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803628:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80362c:	79 1b                	jns    803649 <pipe+0x143>
		goto err3;
  80362e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80362f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803633:	48 89 c6             	mov    %rax,%rsi
  803636:	bf 00 00 00 00       	mov    $0x0,%edi
  80363b:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
  803647:	eb 79                	jmp    8036c2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803654:	00 00 00 
  803657:	8b 12                	mov    (%rdx),%edx
  803659:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80365b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80365f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803666:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803671:	00 00 00 
  803674:	8b 12                	mov    (%rdx),%edx
  803676:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803678:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803687:	48 89 c7             	mov    %rax,%rdi
  80368a:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 c2                	mov    %eax,%edx
  803698:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80369c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80369e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036a2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c0:	eb 33                	jmp    8036f5 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8036c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c6:	48 89 c6             	mov    %rax,%rsi
  8036c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ce:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8036d5:	00 00 00 
  8036d8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8036da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036de:	48 89 c6             	mov    %rax,%rsi
  8036e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e6:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8036ed:	00 00 00 
  8036f0:	ff d0                	callq  *%rax
err:
	return r;
  8036f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036f5:	48 83 c4 38          	add    $0x38,%rsp
  8036f9:	5b                   	pop    %rbx
  8036fa:	5d                   	pop    %rbp
  8036fb:	c3                   	retq   

00000000008036fc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036fc:	55                   	push   %rbp
  8036fd:	48 89 e5             	mov    %rsp,%rbp
  803700:	53                   	push   %rbx
  803701:	48 83 ec 28          	sub    $0x28,%rsp
  803705:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803709:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80370d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803714:	00 00 00 
  803717:	48 8b 00             	mov    (%rax),%rax
  80371a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803720:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803727:	48 89 c7             	mov    %rax,%rdi
  80372a:	48 b8 96 3e 80 00 00 	movabs $0x803e96,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
  803736:	89 c3                	mov    %eax,%ebx
  803738:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80373c:	48 89 c7             	mov    %rax,%rdi
  80373f:	48 b8 96 3e 80 00 00 	movabs $0x803e96,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
  80374b:	39 c3                	cmp    %eax,%ebx
  80374d:	0f 94 c0             	sete   %al
  803750:	0f b6 c0             	movzbl %al,%eax
  803753:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803756:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80375d:	00 00 00 
  803760:	48 8b 00             	mov    (%rax),%rax
  803763:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803769:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80376c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803772:	75 05                	jne    803779 <_pipeisclosed+0x7d>
			return ret;
  803774:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803777:	eb 4f                	jmp    8037c8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803779:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80377f:	74 42                	je     8037c3 <_pipeisclosed+0xc7>
  803781:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803785:	75 3c                	jne    8037c3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803787:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80378e:	00 00 00 
  803791:	48 8b 00             	mov    (%rax),%rax
  803794:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80379a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80379d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037a0:	89 c6                	mov    %eax,%esi
  8037a2:	48 bf 9e 45 80 00 00 	movabs $0x80459e,%rdi
  8037a9:	00 00 00 
  8037ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b1:	49 b8 f1 02 80 00 00 	movabs $0x8002f1,%r8
  8037b8:	00 00 00 
  8037bb:	41 ff d0             	callq  *%r8
	}
  8037be:	e9 4a ff ff ff       	jmpq   80370d <_pipeisclosed+0x11>
  8037c3:	e9 45 ff ff ff       	jmpq   80370d <_pipeisclosed+0x11>
}
  8037c8:	48 83 c4 28          	add    $0x28,%rsp
  8037cc:	5b                   	pop    %rbx
  8037cd:	5d                   	pop    %rbp
  8037ce:	c3                   	retq   

00000000008037cf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037cf:	55                   	push   %rbp
  8037d0:	48 89 e5             	mov    %rsp,%rbp
  8037d3:	48 83 ec 30          	sub    $0x30,%rsp
  8037d7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037e1:	48 89 d6             	mov    %rdx,%rsi
  8037e4:	89 c7                	mov    %eax,%edi
  8037e6:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
  8037f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f9:	79 05                	jns    803800 <pipeisclosed+0x31>
		return r;
  8037fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fe:	eb 31                	jmp    803831 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80381b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80381f:	48 89 d6             	mov    %rdx,%rsi
  803822:	48 89 c7             	mov    %rax,%rdi
  803825:	48 b8 fc 36 80 00 00 	movabs $0x8036fc,%rax
  80382c:	00 00 00 
  80382f:	ff d0                	callq  *%rax
}
  803831:	c9                   	leaveq 
  803832:	c3                   	retq   

0000000000803833 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803833:	55                   	push   %rbp
  803834:	48 89 e5             	mov    %rsp,%rbp
  803837:	48 83 ec 40          	sub    $0x40,%rsp
  80383b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80383f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803843:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384b:	48 89 c7             	mov    %rax,%rdi
  80384e:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
  80385a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80385e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803862:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803866:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80386d:	00 
  80386e:	e9 92 00 00 00       	jmpq   803905 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803873:	eb 41                	jmp    8038b6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803875:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80387a:	74 09                	je     803885 <devpipe_read+0x52>
				return i;
  80387c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803880:	e9 92 00 00 00       	jmpq   803917 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803885:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388d:	48 89 d6             	mov    %rdx,%rsi
  803890:	48 89 c7             	mov    %rax,%rdi
  803893:	48 b8 fc 36 80 00 00 	movabs $0x8036fc,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	85 c0                	test   %eax,%eax
  8038a1:	74 07                	je     8038aa <devpipe_read+0x77>
				return 0;
  8038a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a8:	eb 6d                	jmp    803917 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038aa:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ba:	8b 10                	mov    (%rax),%edx
  8038bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c0:	8b 40 04             	mov    0x4(%rax),%eax
  8038c3:	39 c2                	cmp    %eax,%edx
  8038c5:	74 ae                	je     803875 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038cf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d7:	8b 00                	mov    (%rax),%eax
  8038d9:	99                   	cltd   
  8038da:	c1 ea 1b             	shr    $0x1b,%edx
  8038dd:	01 d0                	add    %edx,%eax
  8038df:	83 e0 1f             	and    $0x1f,%eax
  8038e2:	29 d0                	sub    %edx,%eax
  8038e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038e8:	48 98                	cltq   
  8038ea:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038ef:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f5:	8b 00                	mov    (%rax),%eax
  8038f7:	8d 50 01             	lea    0x1(%rax),%edx
  8038fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fe:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803900:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803909:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80390d:	0f 82 60 ff ff ff    	jb     803873 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803913:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 40          	sub    $0x40,%rsp
  803921:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803925:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803929:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80392d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803931:	48 89 c7             	mov    %rax,%rdi
  803934:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  80393b:	00 00 00 
  80393e:	ff d0                	callq  *%rax
  803940:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803944:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803948:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80394c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803953:	00 
  803954:	e9 8e 00 00 00       	jmpq   8039e7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803959:	eb 31                	jmp    80398c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80395b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80395f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803963:	48 89 d6             	mov    %rdx,%rsi
  803966:	48 89 c7             	mov    %rax,%rdi
  803969:	48 b8 fc 36 80 00 00 	movabs $0x8036fc,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
  803975:	85 c0                	test   %eax,%eax
  803977:	74 07                	je     803980 <devpipe_write+0x67>
				return 0;
  803979:	b8 00 00 00 00       	mov    $0x0,%eax
  80397e:	eb 79                	jmp    8039f9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803980:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  803987:	00 00 00 
  80398a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80398c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803990:	8b 40 04             	mov    0x4(%rax),%eax
  803993:	48 63 d0             	movslq %eax,%rdx
  803996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80399a:	8b 00                	mov    (%rax),%eax
  80399c:	48 98                	cltq   
  80399e:	48 83 c0 20          	add    $0x20,%rax
  8039a2:	48 39 c2             	cmp    %rax,%rdx
  8039a5:	73 b4                	jae    80395b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ab:	8b 40 04             	mov    0x4(%rax),%eax
  8039ae:	99                   	cltd   
  8039af:	c1 ea 1b             	shr    $0x1b,%edx
  8039b2:	01 d0                	add    %edx,%eax
  8039b4:	83 e0 1f             	and    $0x1f,%eax
  8039b7:	29 d0                	sub    %edx,%eax
  8039b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8039c1:	48 01 ca             	add    %rcx,%rdx
  8039c4:	0f b6 0a             	movzbl (%rdx),%ecx
  8039c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039cb:	48 98                	cltq   
  8039cd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d5:	8b 40 04             	mov    0x4(%rax),%eax
  8039d8:	8d 50 01             	lea    0x1(%rax),%edx
  8039db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039df:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039ef:	0f 82 64 ff ff ff    	jb     803959 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039f9:	c9                   	leaveq 
  8039fa:	c3                   	retq   

00000000008039fb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039fb:	55                   	push   %rbp
  8039fc:	48 89 e5             	mov    %rsp,%rbp
  8039ff:	48 83 ec 20          	sub    $0x20,%rsp
  803a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a0f:	48 89 c7             	mov    %rax,%rdi
  803a12:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  803a19:	00 00 00 
  803a1c:	ff d0                	callq  *%rax
  803a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a26:	48 be b1 45 80 00 00 	movabs $0x8045b1,%rsi
  803a2d:	00 00 00 
  803a30:	48 89 c7             	mov    %rax,%rdi
  803a33:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a43:	8b 50 04             	mov    0x4(%rax),%edx
  803a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4a:	8b 00                	mov    (%rax),%eax
  803a4c:	29 c2                	sub    %eax,%edx
  803a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a52:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a5c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a63:	00 00 00 
	stat->st_dev = &devpipe;
  803a66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6a:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a71:	00 00 00 
  803a74:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 10          	sub    $0x10,%rsp
  803a8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a92:	48 89 c6             	mov    %rax,%rsi
  803a95:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803aa1:	00 00 00 
  803aa4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aaa:	48 89 c7             	mov    %rax,%rdi
  803aad:	48 b8 19 1d 80 00 00 	movabs $0x801d19,%rax
  803ab4:	00 00 00 
  803ab7:	ff d0                	callq  *%rax
  803ab9:	48 89 c6             	mov    %rax,%rsi
  803abc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac1:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
}
  803acd:	c9                   	leaveq 
  803ace:	c3                   	retq   

0000000000803acf <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803acf:	55                   	push   %rbp
  803ad0:	48 89 e5             	mov    %rsp,%rbp
  803ad3:	48 83 ec 20          	sub    $0x20,%rsp
  803ad7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803add:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ae0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ae4:	be 01 00 00 00       	mov    $0x1,%esi
  803ae9:	48 89 c7             	mov    %rax,%rdi
  803aec:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
}
  803af8:	c9                   	leaveq 
  803af9:	c3                   	retq   

0000000000803afa <getchar>:

int
getchar(void)
{
  803afa:	55                   	push   %rbp
  803afb:	48 89 e5             	mov    %rsp,%rbp
  803afe:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b02:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b06:	ba 01 00 00 00       	mov    $0x1,%edx
  803b0b:	48 89 c6             	mov    %rax,%rsi
  803b0e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b13:	48 b8 0e 22 80 00 00 	movabs $0x80220e,%rax
  803b1a:	00 00 00 
  803b1d:	ff d0                	callq  *%rax
  803b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b26:	79 05                	jns    803b2d <getchar+0x33>
		return r;
  803b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2b:	eb 14                	jmp    803b41 <getchar+0x47>
	if (r < 1)
  803b2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b31:	7f 07                	jg     803b3a <getchar+0x40>
		return -E_EOF;
  803b33:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803b38:	eb 07                	jmp    803b41 <getchar+0x47>
	return c;
  803b3a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803b3e:	0f b6 c0             	movzbl %al,%eax
}
  803b41:	c9                   	leaveq 
  803b42:	c3                   	retq   

0000000000803b43 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803b43:	55                   	push   %rbp
  803b44:	48 89 e5             	mov    %rsp,%rbp
  803b47:	48 83 ec 20          	sub    $0x20,%rsp
  803b4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b4e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b55:	48 89 d6             	mov    %rdx,%rsi
  803b58:	89 c7                	mov    %eax,%edi
  803b5a:	48 b8 dc 1d 80 00 00 	movabs $0x801ddc,%rax
  803b61:	00 00 00 
  803b64:	ff d0                	callq  *%rax
  803b66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6d:	79 05                	jns    803b74 <iscons+0x31>
		return r;
  803b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b72:	eb 1a                	jmp    803b8e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b78:	8b 10                	mov    (%rax),%edx
  803b7a:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b81:	00 00 00 
  803b84:	8b 00                	mov    (%rax),%eax
  803b86:	39 c2                	cmp    %eax,%edx
  803b88:	0f 94 c0             	sete   %al
  803b8b:	0f b6 c0             	movzbl %al,%eax
}
  803b8e:	c9                   	leaveq 
  803b8f:	c3                   	retq   

0000000000803b90 <opencons>:

int
opencons(void)
{
  803b90:	55                   	push   %rbp
  803b91:	48 89 e5             	mov    %rsp,%rbp
  803b94:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b98:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b9c:	48 89 c7             	mov    %rax,%rdi
  803b9f:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  803ba6:	00 00 00 
  803ba9:	ff d0                	callq  *%rax
  803bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb2:	79 05                	jns    803bb9 <opencons+0x29>
		return r;
  803bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bb7:	eb 5b                	jmp    803c14 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbd:	ba 07 04 00 00       	mov    $0x407,%edx
  803bc2:	48 89 c6             	mov    %rax,%rsi
  803bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  803bca:	48 b8 d5 17 80 00 00 	movabs $0x8017d5,%rax
  803bd1:	00 00 00 
  803bd4:	ff d0                	callq  *%rax
  803bd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bdd:	79 05                	jns    803be4 <opencons+0x54>
		return r;
  803bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be2:	eb 30                	jmp    803c14 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be8:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803bef:	00 00 00 
  803bf2:	8b 12                	mov    (%rdx),%edx
  803bf4:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c05:	48 89 c7             	mov    %rax,%rdi
  803c08:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
}
  803c14:	c9                   	leaveq 
  803c15:	c3                   	retq   

0000000000803c16 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c16:	55                   	push   %rbp
  803c17:	48 89 e5             	mov    %rsp,%rbp
  803c1a:	48 83 ec 30          	sub    $0x30,%rsp
  803c1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803c2a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c2f:	75 07                	jne    803c38 <devcons_read+0x22>
		return 0;
  803c31:	b8 00 00 00 00       	mov    $0x0,%eax
  803c36:	eb 4b                	jmp    803c83 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803c38:	eb 0c                	jmp    803c46 <devcons_read+0x30>
		sys_yield();
  803c3a:	48 b8 97 17 80 00 00 	movabs $0x801797,%rax
  803c41:	00 00 00 
  803c44:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803c46:	48 b8 d7 16 80 00 00 	movabs $0x8016d7,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c59:	74 df                	je     803c3a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5f:	79 05                	jns    803c66 <devcons_read+0x50>
		return c;
  803c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c64:	eb 1d                	jmp    803c83 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c66:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c6a:	75 07                	jne    803c73 <devcons_read+0x5d>
		return 0;
  803c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803c71:	eb 10                	jmp    803c83 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c76:	89 c2                	mov    %eax,%edx
  803c78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c7c:	88 10                	mov    %dl,(%rax)
	return 1;
  803c7e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c83:	c9                   	leaveq 
  803c84:	c3                   	retq   

0000000000803c85 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c85:	55                   	push   %rbp
  803c86:	48 89 e5             	mov    %rsp,%rbp
  803c89:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c90:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c97:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c9e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ca5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cac:	eb 76                	jmp    803d24 <devcons_write+0x9f>
		m = n - tot;
  803cae:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803cb5:	89 c2                	mov    %eax,%edx
  803cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cba:	29 c2                	sub    %eax,%edx
  803cbc:	89 d0                	mov    %edx,%eax
  803cbe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803cc1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cc4:	83 f8 7f             	cmp    $0x7f,%eax
  803cc7:	76 07                	jbe    803cd0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803cc9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803cd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cd3:	48 63 d0             	movslq %eax,%rdx
  803cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd9:	48 63 c8             	movslq %eax,%rcx
  803cdc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ce3:	48 01 c1             	add    %rax,%rcx
  803ce6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ced:	48 89 ce             	mov    %rcx,%rsi
  803cf0:	48 89 c7             	mov    %rax,%rdi
  803cf3:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  803cfa:	00 00 00 
  803cfd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d02:	48 63 d0             	movslq %eax,%rdx
  803d05:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d0c:	48 89 d6             	mov    %rdx,%rsi
  803d0f:	48 89 c7             	mov    %rax,%rdi
  803d12:	48 b8 8d 16 80 00 00 	movabs $0x80168d,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d21:	01 45 fc             	add    %eax,-0x4(%rbp)
  803d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d27:	48 98                	cltq   
  803d29:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803d30:	0f 82 78 ff ff ff    	jb     803cae <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d39:	c9                   	leaveq 
  803d3a:	c3                   	retq   

0000000000803d3b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803d3b:	55                   	push   %rbp
  803d3c:	48 89 e5             	mov    %rsp,%rbp
  803d3f:	48 83 ec 08          	sub    $0x8,%rsp
  803d43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d4c:	c9                   	leaveq 
  803d4d:	c3                   	retq   

0000000000803d4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d4e:	55                   	push   %rbp
  803d4f:	48 89 e5             	mov    %rsp,%rbp
  803d52:	48 83 ec 10          	sub    $0x10,%rsp
  803d56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d62:	48 be bd 45 80 00 00 	movabs $0x8045bd,%rsi
  803d69:	00 00 00 
  803d6c:	48 89 c7             	mov    %rax,%rdi
  803d6f:	48 b8 a6 0e 80 00 00 	movabs $0x800ea6,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
	return 0;
  803d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d80:	c9                   	leaveq 
  803d81:	c3                   	retq   

0000000000803d82 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803d82:	55                   	push   %rbp
  803d83:	48 89 e5             	mov    %rsp,%rbp
  803d86:	53                   	push   %rbx
  803d87:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803d8e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803d95:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803d9b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803da2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803da9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803db0:	84 c0                	test   %al,%al
  803db2:	74 23                	je     803dd7 <_panic+0x55>
  803db4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803dbb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803dbf:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803dc3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803dc7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803dcb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803dcf:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803dd3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803dd7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803dde:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803de5:	00 00 00 
  803de8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803def:	00 00 00 
  803df2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803df6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803dfd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803e04:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803e0b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803e12:	00 00 00 
  803e15:	48 8b 18             	mov    (%rax),%rbx
  803e18:	48 b8 59 17 80 00 00 	movabs $0x801759,%rax
  803e1f:	00 00 00 
  803e22:	ff d0                	callq  *%rax
  803e24:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803e2a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803e31:	41 89 c8             	mov    %ecx,%r8d
  803e34:	48 89 d1             	mov    %rdx,%rcx
  803e37:	48 89 da             	mov    %rbx,%rdx
  803e3a:	89 c6                	mov    %eax,%esi
  803e3c:	48 bf c8 45 80 00 00 	movabs $0x8045c8,%rdi
  803e43:	00 00 00 
  803e46:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4b:	49 b9 f1 02 80 00 00 	movabs $0x8002f1,%r9
  803e52:	00 00 00 
  803e55:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803e58:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803e5f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e66:	48 89 d6             	mov    %rdx,%rsi
  803e69:	48 89 c7             	mov    %rax,%rdi
  803e6c:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	callq  *%rax
	cprintf("\n");
  803e78:	48 bf eb 45 80 00 00 	movabs $0x8045eb,%rdi
  803e7f:	00 00 00 
  803e82:	b8 00 00 00 00       	mov    $0x0,%eax
  803e87:	48 ba f1 02 80 00 00 	movabs $0x8002f1,%rdx
  803e8e:	00 00 00 
  803e91:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803e93:	cc                   	int3   
  803e94:	eb fd                	jmp    803e93 <_panic+0x111>

0000000000803e96 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e96:	55                   	push   %rbp
  803e97:	48 89 e5             	mov    %rsp,%rbp
  803e9a:	48 83 ec 18          	sub    $0x18,%rsp
  803e9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ea6:	48 c1 e8 15          	shr    $0x15,%rax
  803eaa:	48 89 c2             	mov    %rax,%rdx
  803ead:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eb4:	01 00 00 
  803eb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ebb:	83 e0 01             	and    $0x1,%eax
  803ebe:	48 85 c0             	test   %rax,%rax
  803ec1:	75 07                	jne    803eca <pageref+0x34>
		return 0;
  803ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec8:	eb 53                	jmp    803f1d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ece:	48 c1 e8 0c          	shr    $0xc,%rax
  803ed2:	48 89 c2             	mov    %rax,%rdx
  803ed5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803edc:	01 00 00 
  803edf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eeb:	83 e0 01             	and    $0x1,%eax
  803eee:	48 85 c0             	test   %rax,%rax
  803ef1:	75 07                	jne    803efa <pageref+0x64>
		return 0;
  803ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef8:	eb 23                	jmp    803f1d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803efe:	48 c1 e8 0c          	shr    $0xc,%rax
  803f02:	48 89 c2             	mov    %rax,%rdx
  803f05:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f0c:	00 00 00 
  803f0f:	48 c1 e2 04          	shl    $0x4,%rdx
  803f13:	48 01 d0             	add    %rdx,%rax
  803f16:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f1a:	0f b7 c0             	movzwl %ax,%eax
}
  803f1d:	c9                   	leaveq 
  803f1e:	c3                   	retq   
