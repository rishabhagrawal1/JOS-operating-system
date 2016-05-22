
obj/user/pingpong.debug:     file format elf64-x86-64


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
  80003c:	e8 06 01 00 00       	callq  800147 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 54 1e 80 00 00 	movabs $0x801e54,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf 96 3c 80 00 00 	movabs $0x803c96,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 1a 03 80 00 00 	movabs $0x80031a,%r8
  800103:	00 00 00 
  800106:	41 ff d0             	callq  *%r8
		if (i == 10)
  800109:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010d:	75 02                	jne    800111 <umain+0xce>
			return;
  80010f:	eb 2f                	jmp    800140 <umain+0xfd>
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	75 02                	jne    80013b <umain+0xf8>
			return;
  800139:	eb 05                	jmp    800140 <umain+0xfd>
	}
  80013b:	e9 77 ff ff ff       	jmpq   8000b7 <umain+0x74>

}
  800140:	48 83 c4 28          	add    $0x28,%rsp
  800144:	5b                   	pop    %rbx
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800156:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	25 ff 03 00 00       	and    $0x3ff,%eax
  800167:	48 63 d0             	movslq %eax,%rdx
  80016a:	48 89 d0             	mov    %rdx,%rax
  80016d:	48 c1 e0 03          	shl    $0x3,%rax
  800171:	48 01 d0             	add    %rdx,%rax
  800174:	48 c1 e0 05          	shl    $0x5,%rax
  800178:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80017f:	00 00 00 
  800182:	48 01 c2             	add    %rax,%rdx
  800185:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018c:	00 00 00 
  80018f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800192:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800196:	7e 14                	jle    8001ac <libmain+0x65>
		binaryname = argv[0];
  800198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019c:	48 8b 10             	mov    (%rax),%rdx
  80019f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001a6:	00 00 00 
  8001a9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b3:	48 89 d6             	mov    %rdx,%rsi
  8001b6:	89 c7                	mov    %eax,%edi
  8001b8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001bf:	00 00 00 
  8001c2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001c4:	48 b8 d2 01 80 00 00 	movabs $0x8001d2,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
}
  8001d0:	c9                   	leaveq 
  8001d1:	c3                   	retq   

00000000008001d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d2:	55                   	push   %rbp
  8001d3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001d6:	48 b8 30 26 80 00 00 	movabs $0x802630,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 3e 17 80 00 00 	movabs $0x80173e,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax

}
  8001f3:	5d                   	pop    %rbp
  8001f4:	c3                   	retq   

00000000008001f5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
  8001f9:	48 83 ec 10          	sub    $0x10,%rsp
  8001fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800200:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800208:	8b 00                	mov    (%rax),%eax
  80020a:	8d 48 01             	lea    0x1(%rax),%ecx
  80020d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800211:	89 0a                	mov    %ecx,(%rdx)
  800213:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800216:	89 d1                	mov    %edx,%ecx
  800218:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021c:	48 98                	cltq   
  80021e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800226:	8b 00                	mov    (%rax),%eax
  800228:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022d:	75 2c                	jne    80025b <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80022f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800233:	8b 00                	mov    (%rax),%eax
  800235:	48 98                	cltq   
  800237:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023b:	48 83 c2 08          	add    $0x8,%rdx
  80023f:	48 89 c6             	mov    %rax,%rsi
  800242:	48 89 d7             	mov    %rdx,%rdi
  800245:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  80024c:	00 00 00 
  80024f:	ff d0                	callq  *%rax
		b->idx = 0;
  800251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800255:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80025b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025f:	8b 40 04             	mov    0x4(%rax),%eax
  800262:	8d 50 01             	lea    0x1(%rax),%edx
  800265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800269:	89 50 04             	mov    %edx,0x4(%rax)
}
  80026c:	c9                   	leaveq 
  80026d:	c3                   	retq   

000000000080026e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026e:	55                   	push   %rbp
  80026f:	48 89 e5             	mov    %rsp,%rbp
  800272:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800279:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800280:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800287:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80028e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800295:	48 8b 0a             	mov    (%rdx),%rcx
  800298:	48 89 08             	mov    %rcx,(%rax)
  80029b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80029f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b2:	00 00 00 
	b.cnt = 0;
  8002b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002bc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002bf:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002c6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002cd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d4:	48 89 c6             	mov    %rax,%rsi
  8002d7:	48 bf f5 01 80 00 00 	movabs $0x8001f5,%rdi
  8002de:	00 00 00 
  8002e1:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  8002e8:	00 00 00 
  8002eb:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002ed:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f3:	48 98                	cltq   
  8002f5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002fc:	48 83 c2 08          	add    $0x8,%rdx
  800300:	48 89 c6             	mov    %rax,%rsi
  800303:	48 89 d7             	mov    %rdx,%rdi
  800306:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  80030d:	00 00 00 
  800310:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800312:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800318:	c9                   	leaveq 
  800319:	c3                   	retq   

000000000080031a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031a:	55                   	push   %rbp
  80031b:	48 89 e5             	mov    %rsp,%rbp
  80031e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800325:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80032c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800333:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800341:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800348:	84 c0                	test   %al,%al
  80034a:	74 20                	je     80036c <cprintf+0x52>
  80034c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800350:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800354:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800358:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80035c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800360:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800364:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800368:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80036c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800373:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037a:	00 00 00 
  80037d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800384:	00 00 00 
  800387:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80038b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800392:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800399:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003a0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003a7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003ae:	48 8b 0a             	mov    (%rdx),%rcx
  8003b1:	48 89 08             	mov    %rcx,(%rax)
  8003b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003c4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d2:	48 89 d6             	mov    %rdx,%rsi
  8003d5:	48 89 c7             	mov    %rax,%rdi
  8003d8:	48 b8 6e 02 80 00 00 	movabs $0x80026e,%rax
  8003df:	00 00 00 
  8003e2:	ff d0                	callq  *%rax
  8003e4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003ea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f0:	c9                   	leaveq 
  8003f1:	c3                   	retq   

00000000008003f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f2:	55                   	push   %rbp
  8003f3:	48 89 e5             	mov    %rsp,%rbp
  8003f6:	53                   	push   %rbx
  8003f7:	48 83 ec 38          	sub    $0x38,%rsp
  8003fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800403:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800407:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80040e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800412:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800415:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800419:	77 3b                	ja     800456 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80041e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800422:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800429:	ba 00 00 00 00       	mov    $0x0,%edx
  80042e:	48 f7 f3             	div    %rbx
  800431:	48 89 c2             	mov    %rax,%rdx
  800434:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800437:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80043e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800442:	41 89 f9             	mov    %edi,%r9d
  800445:	48 89 c7             	mov    %rax,%rdi
  800448:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  80044f:	00 00 00 
  800452:	ff d0                	callq  *%rax
  800454:	eb 1e                	jmp    800474 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800456:	eb 12                	jmp    80046a <printnum+0x78>
			putch(padc, putdat);
  800458:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80045f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800463:	48 89 ce             	mov    %rcx,%rsi
  800466:	89 d7                	mov    %edx,%edi
  800468:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80046e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800472:	7f e4                	jg     800458 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800474:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80047b:	ba 00 00 00 00       	mov    $0x0,%edx
  800480:	48 f7 f1             	div    %rcx
  800483:	48 89 d0             	mov    %rdx,%rax
  800486:	48 ba 88 3e 80 00 00 	movabs $0x803e88,%rdx
  80048d:	00 00 00 
  800490:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800494:	0f be d0             	movsbl %al,%edx
  800497:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80049b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049f:	48 89 ce             	mov    %rcx,%rsi
  8004a2:	89 d7                	mov    %edx,%edi
  8004a4:	ff d0                	callq  *%rax
}
  8004a6:	48 83 c4 38          	add    $0x38,%rsp
  8004aa:	5b                   	pop    %rbx
  8004ab:	5d                   	pop    %rbp
  8004ac:	c3                   	retq   

00000000008004ad <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ad:	55                   	push   %rbp
  8004ae:	48 89 e5             	mov    %rsp,%rbp
  8004b1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c0:	7e 52                	jle    800514 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c6:	8b 00                	mov    (%rax),%eax
  8004c8:	83 f8 30             	cmp    $0x30,%eax
  8004cb:	73 24                	jae    8004f1 <getuint+0x44>
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d9:	8b 00                	mov    (%rax),%eax
  8004db:	89 c0                	mov    %eax,%eax
  8004dd:	48 01 d0             	add    %rdx,%rax
  8004e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e4:	8b 12                	mov    (%rdx),%edx
  8004e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ed:	89 0a                	mov    %ecx,(%rdx)
  8004ef:	eb 17                	jmp    800508 <getuint+0x5b>
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004f9:	48 89 d0             	mov    %rdx,%rax
  8004fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800500:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800504:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800508:	48 8b 00             	mov    (%rax),%rax
  80050b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80050f:	e9 a3 00 00 00       	jmpq   8005b7 <getuint+0x10a>
	else if (lflag)
  800514:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800518:	74 4f                	je     800569 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051e:	8b 00                	mov    (%rax),%eax
  800520:	83 f8 30             	cmp    $0x30,%eax
  800523:	73 24                	jae    800549 <getuint+0x9c>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	89 c0                	mov    %eax,%eax
  800535:	48 01 d0             	add    %rdx,%rax
  800538:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053c:	8b 12                	mov    (%rdx),%edx
  80053e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800541:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800545:	89 0a                	mov    %ecx,(%rdx)
  800547:	eb 17                	jmp    800560 <getuint+0xb3>
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800551:	48 89 d0             	mov    %rdx,%rax
  800554:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800558:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800560:	48 8b 00             	mov    (%rax),%rax
  800563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800567:	eb 4e                	jmp    8005b7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056d:	8b 00                	mov    (%rax),%eax
  80056f:	83 f8 30             	cmp    $0x30,%eax
  800572:	73 24                	jae    800598 <getuint+0xeb>
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800580:	8b 00                	mov    (%rax),%eax
  800582:	89 c0                	mov    %eax,%eax
  800584:	48 01 d0             	add    %rdx,%rax
  800587:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058b:	8b 12                	mov    (%rdx),%edx
  80058d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800594:	89 0a                	mov    %ecx,(%rdx)
  800596:	eb 17                	jmp    8005af <getuint+0x102>
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a0:	48 89 d0             	mov    %rdx,%rax
  8005a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005af:	8b 00                	mov    (%rax),%eax
  8005b1:	89 c0                	mov    %eax,%eax
  8005b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005bb:	c9                   	leaveq 
  8005bc:	c3                   	retq   

00000000008005bd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005bd:	55                   	push   %rbp
  8005be:	48 89 e5             	mov    %rsp,%rbp
  8005c1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005c9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005cc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d0:	7e 52                	jle    800624 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	83 f8 30             	cmp    $0x30,%eax
  8005db:	73 24                	jae    800601 <getint+0x44>
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e9:	8b 00                	mov    (%rax),%eax
  8005eb:	89 c0                	mov    %eax,%eax
  8005ed:	48 01 d0             	add    %rdx,%rax
  8005f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f4:	8b 12                	mov    (%rdx),%edx
  8005f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fd:	89 0a                	mov    %ecx,(%rdx)
  8005ff:	eb 17                	jmp    800618 <getint+0x5b>
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800609:	48 89 d0             	mov    %rdx,%rax
  80060c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800618:	48 8b 00             	mov    (%rax),%rax
  80061b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061f:	e9 a3 00 00 00       	jmpq   8006c7 <getint+0x10a>
	else if (lflag)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800628:	74 4f                	je     800679 <getint+0xbc>
		x=va_arg(*ap, long);
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	8b 00                	mov    (%rax),%eax
  800630:	83 f8 30             	cmp    $0x30,%eax
  800633:	73 24                	jae    800659 <getint+0x9c>
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	89 c0                	mov    %eax,%eax
  800645:	48 01 d0             	add    %rdx,%rax
  800648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064c:	8b 12                	mov    (%rdx),%edx
  80064e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800651:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800655:	89 0a                	mov    %ecx,(%rdx)
  800657:	eb 17                	jmp    800670 <getint+0xb3>
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800661:	48 89 d0             	mov    %rdx,%rax
  800664:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800670:	48 8b 00             	mov    (%rax),%rax
  800673:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800677:	eb 4e                	jmp    8006c7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067d:	8b 00                	mov    (%rax),%eax
  80067f:	83 f8 30             	cmp    $0x30,%eax
  800682:	73 24                	jae    8006a8 <getint+0xeb>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	8b 00                	mov    (%rax),%eax
  800692:	89 c0                	mov    %eax,%eax
  800694:	48 01 d0             	add    %rdx,%rax
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	8b 12                	mov    (%rdx),%edx
  80069d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	89 0a                	mov    %ecx,(%rdx)
  8006a6:	eb 17                	jmp    8006bf <getint+0x102>
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b0:	48 89 d0             	mov    %rdx,%rax
  8006b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	48 98                	cltq   
  8006c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006cb:	c9                   	leaveq 
  8006cc:	c3                   	retq   

00000000008006cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006cd:	55                   	push   %rbp
  8006ce:	48 89 e5             	mov    %rsp,%rbp
  8006d1:	41 54                	push   %r12
  8006d3:	53                   	push   %rbx
  8006d4:	48 83 ec 60          	sub    $0x60,%rsp
  8006d8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006dc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006ec:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f0:	48 8b 0a             	mov    (%rdx),%rcx
  8006f3:	48 89 08             	mov    %rcx,(%rax)
  8006f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800702:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800706:	eb 17                	jmp    80071f <vprintfmt+0x52>
			if (ch == '\0')
  800708:	85 db                	test   %ebx,%ebx
  80070a:	0f 84 cc 04 00 00    	je     800bdc <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800710:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800714:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800718:	48 89 d6             	mov    %rdx,%rsi
  80071b:	89 df                	mov    %ebx,%edi
  80071d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800727:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80072b:	0f b6 00             	movzbl (%rax),%eax
  80072e:	0f b6 d8             	movzbl %al,%ebx
  800731:	83 fb 25             	cmp    $0x25,%ebx
  800734:	75 d2                	jne    800708 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800736:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80073a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800741:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800748:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80074f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800756:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80075e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800762:	0f b6 00             	movzbl (%rax),%eax
  800765:	0f b6 d8             	movzbl %al,%ebx
  800768:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80076b:	83 f8 55             	cmp    $0x55,%eax
  80076e:	0f 87 34 04 00 00    	ja     800ba8 <vprintfmt+0x4db>
  800774:	89 c0                	mov    %eax,%eax
  800776:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80077d:	00 
  80077e:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  800785:	00 00 00 
  800788:	48 01 d0             	add    %rdx,%rax
  80078b:	48 8b 00             	mov    (%rax),%rax
  80078e:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800790:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800794:	eb c0                	jmp    800756 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800796:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80079a:	eb ba                	jmp    800756 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a6:	89 d0                	mov    %edx,%eax
  8007a8:	c1 e0 02             	shl    $0x2,%eax
  8007ab:	01 d0                	add    %edx,%eax
  8007ad:	01 c0                	add    %eax,%eax
  8007af:	01 d8                	add    %ebx,%eax
  8007b1:	83 e8 30             	sub    $0x30,%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bb:	0f b6 00             	movzbl (%rax),%eax
  8007be:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c4:	7e 0c                	jle    8007d2 <vprintfmt+0x105>
  8007c6:	83 fb 39             	cmp    $0x39,%ebx
  8007c9:	7f 07                	jg     8007d2 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d0:	eb d1                	jmp    8007a3 <vprintfmt+0xd6>
			goto process_precision;
  8007d2:	eb 58                	jmp    80082c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d7:	83 f8 30             	cmp    $0x30,%eax
  8007da:	73 17                	jae    8007f3 <vprintfmt+0x126>
  8007dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007eb:	83 c2 08             	add    $0x8,%edx
  8007ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f1:	eb 0f                	jmp    800802 <vprintfmt+0x135>
  8007f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f7:	48 89 d0             	mov    %rdx,%rax
  8007fa:	48 83 c2 08          	add    $0x8,%rdx
  8007fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800802:	8b 00                	mov    (%rax),%eax
  800804:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800807:	eb 23                	jmp    80082c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800809:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080d:	79 0c                	jns    80081b <vprintfmt+0x14e>
				width = 0;
  80080f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800816:	e9 3b ff ff ff       	jmpq   800756 <vprintfmt+0x89>
  80081b:	e9 36 ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800820:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800827:	e9 2a ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80082c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800830:	79 12                	jns    800844 <vprintfmt+0x177>
				width = precision, precision = -1;
  800832:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800835:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800838:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80083f:	e9 12 ff ff ff       	jmpq   800756 <vprintfmt+0x89>
  800844:	e9 0d ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80084d:	e9 04 ff ff ff       	jmpq   800756 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800852:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800855:	83 f8 30             	cmp    $0x30,%eax
  800858:	73 17                	jae    800871 <vprintfmt+0x1a4>
  80085a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80085e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800861:	89 c0                	mov    %eax,%eax
  800863:	48 01 d0             	add    %rdx,%rax
  800866:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800869:	83 c2 08             	add    $0x8,%edx
  80086c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086f:	eb 0f                	jmp    800880 <vprintfmt+0x1b3>
  800871:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800875:	48 89 d0             	mov    %rdx,%rax
  800878:	48 83 c2 08          	add    $0x8,%rdx
  80087c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800880:	8b 10                	mov    (%rax),%edx
  800882:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800886:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088a:	48 89 ce             	mov    %rcx,%rsi
  80088d:	89 d7                	mov    %edx,%edi
  80088f:	ff d0                	callq  *%rax
			break;
  800891:	e9 40 03 00 00       	jmpq   800bd6 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800896:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800899:	83 f8 30             	cmp    $0x30,%eax
  80089c:	73 17                	jae    8008b5 <vprintfmt+0x1e8>
  80089e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ad:	83 c2 08             	add    $0x8,%edx
  8008b0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b3:	eb 0f                	jmp    8008c4 <vprintfmt+0x1f7>
  8008b5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b9:	48 89 d0             	mov    %rdx,%rax
  8008bc:	48 83 c2 08          	add    $0x8,%rdx
  8008c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008c6:	85 db                	test   %ebx,%ebx
  8008c8:	79 02                	jns    8008cc <vprintfmt+0x1ff>
				err = -err;
  8008ca:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008cc:	83 fb 10             	cmp    $0x10,%ebx
  8008cf:	7f 16                	jg     8008e7 <vprintfmt+0x21a>
  8008d1:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  8008d8:	00 00 00 
  8008db:	48 63 d3             	movslq %ebx,%rdx
  8008de:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e2:	4d 85 e4             	test   %r12,%r12
  8008e5:	75 2e                	jne    800915 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ef:	89 d9                	mov    %ebx,%ecx
  8008f1:	48 ba 99 3e 80 00 00 	movabs $0x803e99,%rdx
  8008f8:	00 00 00 
  8008fb:	48 89 c7             	mov    %rax,%rdi
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	49 b8 e5 0b 80 00 00 	movabs $0x800be5,%r8
  80090a:	00 00 00 
  80090d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800910:	e9 c1 02 00 00       	jmpq   800bd6 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800915:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800919:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091d:	4c 89 e1             	mov    %r12,%rcx
  800920:	48 ba a2 3e 80 00 00 	movabs $0x803ea2,%rdx
  800927:	00 00 00 
  80092a:	48 89 c7             	mov    %rax,%rdi
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
  800932:	49 b8 e5 0b 80 00 00 	movabs $0x800be5,%r8
  800939:	00 00 00 
  80093c:	41 ff d0             	callq  *%r8
			break;
  80093f:	e9 92 02 00 00       	jmpq   800bd6 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800947:	83 f8 30             	cmp    $0x30,%eax
  80094a:	73 17                	jae    800963 <vprintfmt+0x296>
  80094c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800953:	89 c0                	mov    %eax,%eax
  800955:	48 01 d0             	add    %rdx,%rax
  800958:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095b:	83 c2 08             	add    $0x8,%edx
  80095e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x2a5>
  800963:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800967:	48 89 d0             	mov    %rdx,%rax
  80096a:	48 83 c2 08          	add    $0x8,%rdx
  80096e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800972:	4c 8b 20             	mov    (%rax),%r12
  800975:	4d 85 e4             	test   %r12,%r12
  800978:	75 0a                	jne    800984 <vprintfmt+0x2b7>
				p = "(null)";
  80097a:	49 bc a5 3e 80 00 00 	movabs $0x803ea5,%r12
  800981:	00 00 00 
			if (width > 0 && padc != '-')
  800984:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800988:	7e 3f                	jle    8009c9 <vprintfmt+0x2fc>
  80098a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80098e:	74 39                	je     8009c9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800990:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800993:	48 98                	cltq   
  800995:	48 89 c6             	mov    %rax,%rsi
  800998:	4c 89 e7             	mov    %r12,%rdi
  80099b:	48 b8 91 0e 80 00 00 	movabs $0x800e91,%rax
  8009a2:	00 00 00 
  8009a5:	ff d0                	callq  *%rax
  8009a7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009aa:	eb 17                	jmp    8009c3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ac:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b8:	48 89 ce             	mov    %rcx,%rsi
  8009bb:	89 d7                	mov    %edx,%edi
  8009bd:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009bf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c7:	7f e3                	jg     8009ac <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c9:	eb 37                	jmp    800a02 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009cf:	74 1e                	je     8009ef <vprintfmt+0x322>
  8009d1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d4:	7e 05                	jle    8009db <vprintfmt+0x30e>
  8009d6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d9:	7e 14                	jle    8009ef <vprintfmt+0x322>
					putch('?', putdat);
  8009db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e3:	48 89 d6             	mov    %rdx,%rsi
  8009e6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009eb:	ff d0                	callq  *%rax
  8009ed:	eb 0f                	jmp    8009fe <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f7:	48 89 d6             	mov    %rdx,%rsi
  8009fa:	89 df                	mov    %ebx,%edi
  8009fc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a02:	4c 89 e0             	mov    %r12,%rax
  800a05:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a09:	0f b6 00             	movzbl (%rax),%eax
  800a0c:	0f be d8             	movsbl %al,%ebx
  800a0f:	85 db                	test   %ebx,%ebx
  800a11:	74 10                	je     800a23 <vprintfmt+0x356>
  800a13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a17:	78 b2                	js     8009cb <vprintfmt+0x2fe>
  800a19:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a21:	79 a8                	jns    8009cb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a23:	eb 16                	jmp    800a3b <vprintfmt+0x36e>
				putch(' ', putdat);
  800a25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2d:	48 89 d6             	mov    %rdx,%rsi
  800a30:	bf 20 00 00 00       	mov    $0x20,%edi
  800a35:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3f:	7f e4                	jg     800a25 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a41:	e9 90 01 00 00       	jmpq   800bd6 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4a:	be 03 00 00 00       	mov    $0x3,%esi
  800a4f:	48 89 c7             	mov    %rax,%rdi
  800a52:	48 b8 bd 05 80 00 00 	movabs $0x8005bd,%rax
  800a59:	00 00 00 
  800a5c:	ff d0                	callq  *%rax
  800a5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	48 85 c0             	test   %rax,%rax
  800a69:	79 1d                	jns    800a88 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 d6             	mov    %rdx,%rsi
  800a76:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a7b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 f7 d8             	neg    %rax
  800a84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a88:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8f:	e9 d5 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a94:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a98:	be 03 00 00 00       	mov    $0x3,%esi
  800a9d:	48 89 c7             	mov    %rax,%rdi
  800aa0:	48 b8 ad 04 80 00 00 	movabs $0x8004ad,%rax
  800aa7:	00 00 00 
  800aaa:	ff d0                	callq  *%rax
  800aac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab7:	e9 ad 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800abc:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800abf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac3:	89 d6                	mov    %edx,%esi
  800ac5:	48 89 c7             	mov    %rax,%rdi
  800ac8:	48 b8 bd 05 80 00 00 	movabs $0x8005bd,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ad8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800adf:	e9 85 00 00 00       	jmpq   800b69 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800ae4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aec:	48 89 d6             	mov    %rdx,%rsi
  800aef:	bf 30 00 00 00       	mov    $0x30,%edi
  800af4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800af6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afe:	48 89 d6             	mov    %rdx,%rsi
  800b01:	bf 78 00 00 00       	mov    $0x78,%edi
  800b06:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0b:	83 f8 30             	cmp    $0x30,%eax
  800b0e:	73 17                	jae    800b27 <vprintfmt+0x45a>
  800b10:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b17:	89 c0                	mov    %eax,%eax
  800b19:	48 01 d0             	add    %rdx,%rax
  800b1c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1f:	83 c2 08             	add    $0x8,%edx
  800b22:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b25:	eb 0f                	jmp    800b36 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2b:	48 89 d0             	mov    %rdx,%rax
  800b2e:	48 83 c2 08          	add    $0x8,%rdx
  800b32:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b36:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b3d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b44:	eb 23                	jmp    800b69 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4a:	be 03 00 00 00       	mov    $0x3,%esi
  800b4f:	48 89 c7             	mov    %rax,%rdi
  800b52:	48 b8 ad 04 80 00 00 	movabs $0x8004ad,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	callq  *%rax
  800b5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b62:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b69:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b71:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b78:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	45 89 c1             	mov    %r8d,%r9d
  800b83:	41 89 f8             	mov    %edi,%r8d
  800b86:	48 89 c7             	mov    %rax,%rdi
  800b89:	48 b8 f2 03 80 00 00 	movabs $0x8003f2,%rax
  800b90:	00 00 00 
  800b93:	ff d0                	callq  *%rax
			break;
  800b95:	eb 3f                	jmp    800bd6 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9f:	48 89 d6             	mov    %rdx,%rsi
  800ba2:	89 df                	mov    %ebx,%edi
  800ba4:	ff d0                	callq  *%rax
			break;
  800ba6:	eb 2e                	jmp    800bd6 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb0:	48 89 d6             	mov    %rdx,%rsi
  800bb3:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bba:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bbf:	eb 05                	jmp    800bc6 <vprintfmt+0x4f9>
  800bc1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bca:	48 83 e8 01          	sub    $0x1,%rax
  800bce:	0f b6 00             	movzbl (%rax),%eax
  800bd1:	3c 25                	cmp    $0x25,%al
  800bd3:	75 ec                	jne    800bc1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bd5:	90                   	nop
		}
	}
  800bd6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd7:	e9 43 fb ff ff       	jmpq   80071f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bdc:	48 83 c4 60          	add    $0x60,%rsp
  800be0:	5b                   	pop    %rbx
  800be1:	41 5c                	pop    %r12
  800be3:	5d                   	pop    %rbp
  800be4:	c3                   	retq   

0000000000800be5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be5:	55                   	push   %rbp
  800be6:	48 89 e5             	mov    %rsp,%rbp
  800be9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bfe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c05:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c13:	84 c0                	test   %al,%al
  800c15:	74 20                	je     800c37 <printfmt+0x52>
  800c17:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c1f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c23:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c27:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c2f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c33:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c37:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c45:	00 00 00 
  800c48:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c4f:	00 00 00 
  800c52:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c56:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c5d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c64:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c72:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c79:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c80:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c87:	48 89 c7             	mov    %rax,%rdi
  800c8a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c96:	c9                   	leaveq 
  800c97:	c3                   	retq   

0000000000800c98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c98:	55                   	push   %rbp
  800c99:	48 89 e5             	mov    %rsp,%rbp
  800c9c:	48 83 ec 10          	sub    $0x10,%rsp
  800ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cab:	8b 40 10             	mov    0x10(%rax),%eax
  800cae:	8d 50 01             	lea    0x1(%rax),%edx
  800cb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbc:	48 8b 10             	mov    (%rax),%rdx
  800cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc7:	48 39 c2             	cmp    %rax,%rdx
  800cca:	73 17                	jae    800ce3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ccc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd0:	48 8b 00             	mov    (%rax),%rax
  800cd3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdb:	48 89 0a             	mov    %rcx,(%rdx)
  800cde:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce1:	88 10                	mov    %dl,(%rax)
}
  800ce3:	c9                   	leaveq 
  800ce4:	c3                   	retq   

0000000000800ce5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce5:	55                   	push   %rbp
  800ce6:	48 89 e5             	mov    %rsp,%rbp
  800ce9:	48 83 ec 50          	sub    $0x50,%rsp
  800ced:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d00:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d04:	48 8b 0a             	mov    (%rdx),%rcx
  800d07:	48 89 08             	mov    %rcx,(%rax)
  800d0a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d12:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d16:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d22:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d25:	48 98                	cltq   
  800d27:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2f:	48 01 d0             	add    %rdx,%rax
  800d32:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d3d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d42:	74 06                	je     800d4a <vsnprintf+0x65>
  800d44:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d48:	7f 07                	jg     800d51 <vsnprintf+0x6c>
		return -E_INVAL;
  800d4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4f:	eb 2f                	jmp    800d80 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d51:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d55:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d59:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d5d:	48 89 c6             	mov    %rax,%rsi
  800d60:	48 bf 98 0c 80 00 00 	movabs $0x800c98,%rdi
  800d67:	00 00 00 
  800d6a:	48 b8 cd 06 80 00 00 	movabs $0x8006cd,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d76:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d7a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d7d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d80:	c9                   	leaveq 
  800d81:	c3                   	retq   

0000000000800d82 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d82:	55                   	push   %rbp
  800d83:	48 89 e5             	mov    %rsp,%rbp
  800d86:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d8d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d94:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d9a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800daf:	84 c0                	test   %al,%al
  800db1:	74 20                	je     800dd3 <snprintf+0x51>
  800db3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dbf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dcb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dcf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dda:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de1:	00 00 00 
  800de4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800deb:	00 00 00 
  800dee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800df9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e00:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e07:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e15:	48 8b 0a             	mov    (%rdx),%rcx
  800e18:	48 89 08             	mov    %rcx,(%rax)
  800e1b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e1f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e23:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e27:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e2b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e32:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e39:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e3f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e46:	48 89 c7             	mov    %rax,%rdi
  800e49:	48 b8 e5 0c 80 00 00 	movabs $0x800ce5,%rax
  800e50:	00 00 00 
  800e53:	ff d0                	callq  *%rax
  800e55:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e5b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e61:	c9                   	leaveq 
  800e62:	c3                   	retq   

0000000000800e63 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e63:	55                   	push   %rbp
  800e64:	48 89 e5             	mov    %rsp,%rbp
  800e67:	48 83 ec 18          	sub    $0x18,%rsp
  800e6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e76:	eb 09                	jmp    800e81 <strlen+0x1e>
		n++;
  800e78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	0f b6 00             	movzbl (%rax),%eax
  800e88:	84 c0                	test   %al,%al
  800e8a:	75 ec                	jne    800e78 <strlen+0x15>
		n++;
	return n;
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8f:	c9                   	leaveq 
  800e90:	c3                   	retq   

0000000000800e91 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e91:	55                   	push   %rbp
  800e92:	48 89 e5             	mov    %rsp,%rbp
  800e95:	48 83 ec 20          	sub    $0x20,%rsp
  800e99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea8:	eb 0e                	jmp    800eb8 <strnlen+0x27>
		n++;
  800eaa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ebd:	74 0b                	je     800eca <strnlen+0x39>
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	0f b6 00             	movzbl (%rax),%eax
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e0                	jne    800eaa <strnlen+0x19>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ecd:	c9                   	leaveq 
  800ece:	c3                   	retq   

0000000000800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 83 ec 20          	sub    $0x20,%rsp
  800ed7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee7:	90                   	nop
  800ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800efc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f00:	0f b6 12             	movzbl (%rdx),%edx
  800f03:	88 10                	mov    %dl,(%rax)
  800f05:	0f b6 00             	movzbl (%rax),%eax
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 dc                	jne    800ee8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f10:	c9                   	leaveq 
  800f11:	c3                   	retq   

0000000000800f12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f12:	55                   	push   %rbp
  800f13:	48 89 e5             	mov    %rsp,%rbp
  800f16:	48 83 ec 20          	sub    $0x20,%rsp
  800f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
  800f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3b:	48 63 d0             	movslq %eax,%rdx
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	48 01 c2             	add    %rax,%rdx
  800f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f49:	48 89 c6             	mov    %rax,%rsi
  800f4c:	48 89 d7             	mov    %rdx,%rdi
  800f4f:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
	return dst;
  800f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 83 ec 28          	sub    $0x28,%rsp
  800f69:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f71:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f7d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f84:	00 
  800f85:	eb 2a                	jmp    800fb1 <strncpy+0x50>
		*dst++ = *src;
  800f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f93:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f97:	0f b6 12             	movzbl (%rdx),%edx
  800f9a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa0:	0f b6 00             	movzbl (%rax),%eax
  800fa3:	84 c0                	test   %al,%al
  800fa5:	74 05                	je     800fac <strncpy+0x4b>
			src++;
  800fa7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fb9:	72 cc                	jb     800f87 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 28          	sub    $0x28,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fdd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe2:	74 3d                	je     801021 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe4:	eb 1d                	jmp    801003 <strlcpy+0x42>
			*dst++ = *src++;
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ff6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ffa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ffe:	0f b6 12             	movzbl (%rdx),%edx
  801001:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801003:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801008:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80100d:	74 0b                	je     80101a <strlcpy+0x59>
  80100f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	84 c0                	test   %al,%al
  801018:	75 cc                	jne    800fe6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80101a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801021:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801029:	48 29 c2             	sub    %rax,%rdx
  80102c:	48 89 d0             	mov    %rdx,%rax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	48 83 ec 10          	sub    $0x10,%rsp
  801039:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801041:	eb 0a                	jmp    80104d <strcmp+0x1c>
		p++, q++;
  801043:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801048:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801051:	0f b6 00             	movzbl (%rax),%eax
  801054:	84 c0                	test   %al,%al
  801056:	74 12                	je     80106a <strcmp+0x39>
  801058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105c:	0f b6 10             	movzbl (%rax),%edx
  80105f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801063:	0f b6 00             	movzbl (%rax),%eax
  801066:	38 c2                	cmp    %al,%dl
  801068:	74 d9                	je     801043 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80106a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	0f b6 d0             	movzbl %al,%edx
  801074:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801078:	0f b6 00             	movzbl (%rax),%eax
  80107b:	0f b6 c0             	movzbl %al,%eax
  80107e:	29 c2                	sub    %eax,%edx
  801080:	89 d0                	mov    %edx,%eax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 18          	sub    $0x18,%rsp
  80108c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801090:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801094:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801098:	eb 0f                	jmp    8010a9 <strncmp+0x25>
		n--, p++, q++;
  80109a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80109f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ae:	74 1d                	je     8010cd <strncmp+0x49>
  8010b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	74 12                	je     8010cd <strncmp+0x49>
  8010bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bf:	0f b6 10             	movzbl (%rax),%edx
  8010c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	38 c2                	cmp    %al,%dl
  8010cb:	74 cd                	je     80109a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d2:	75 07                	jne    8010db <strncmp+0x57>
		return 0;
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d9:	eb 18                	jmp    8010f3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010df:	0f b6 00             	movzbl (%rax),%eax
  8010e2:	0f b6 d0             	movzbl %al,%edx
  8010e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	0f b6 c0             	movzbl %al,%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leaveq 
  8010f4:	c3                   	retq   

00000000008010f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010f5:	55                   	push   %rbp
  8010f6:	48 89 e5             	mov    %rsp,%rbp
  8010f9:	48 83 ec 0c          	sub    $0xc,%rsp
  8010fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801101:	89 f0                	mov    %esi,%eax
  801103:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801106:	eb 17                	jmp    80111f <strchr+0x2a>
		if (*s == c)
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110c:	0f b6 00             	movzbl (%rax),%eax
  80110f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801112:	75 06                	jne    80111a <strchr+0x25>
			return (char *) s;
  801114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801118:	eb 15                	jmp    80112f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	84 c0                	test   %al,%al
  801128:	75 de                	jne    801108 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80112a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112f:	c9                   	leaveq 
  801130:	c3                   	retq   

0000000000801131 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801131:	55                   	push   %rbp
  801132:	48 89 e5             	mov    %rsp,%rbp
  801135:	48 83 ec 0c          	sub    $0xc,%rsp
  801139:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80113d:	89 f0                	mov    %esi,%eax
  80113f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801142:	eb 13                	jmp    801157 <strfind+0x26>
		if (*s == c)
  801144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801148:	0f b6 00             	movzbl (%rax),%eax
  80114b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80114e:	75 02                	jne    801152 <strfind+0x21>
			break;
  801150:	eb 10                	jmp    801162 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801152:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115b:	0f b6 00             	movzbl (%rax),%eax
  80115e:	84 c0                	test   %al,%al
  801160:	75 e2                	jne    801144 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801166:	c9                   	leaveq 
  801167:	c3                   	retq   

0000000000801168 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801168:	55                   	push   %rbp
  801169:	48 89 e5             	mov    %rsp,%rbp
  80116c:	48 83 ec 18          	sub    $0x18,%rsp
  801170:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801174:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801177:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80117b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801180:	75 06                	jne    801188 <memset+0x20>
		return v;
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	eb 69                	jmp    8011f1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	83 e0 03             	and    $0x3,%eax
  80118f:	48 85 c0             	test   %rax,%rax
  801192:	75 48                	jne    8011dc <memset+0x74>
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	83 e0 03             	and    $0x3,%eax
  80119b:	48 85 c0             	test   %rax,%rax
  80119e:	75 3c                	jne    8011dc <memset+0x74>
		c &= 0xFF;
  8011a0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011aa:	c1 e0 18             	shl    $0x18,%eax
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b2:	c1 e0 10             	shl    $0x10,%eax
  8011b5:	09 c2                	or     %eax,%edx
  8011b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ba:	c1 e0 08             	shl    $0x8,%eax
  8011bd:	09 d0                	or     %edx,%eax
  8011bf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	48 c1 e8 02          	shr    $0x2,%rax
  8011ca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d4:	48 89 d7             	mov    %rdx,%rdi
  8011d7:	fc                   	cld    
  8011d8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011da:	eb 11                	jmp    8011ed <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e7:	48 89 d7             	mov    %rdx,%rdi
  8011ea:	fc                   	cld    
  8011eb:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f1:	c9                   	leaveq 
  8011f2:	c3                   	retq   

00000000008011f3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	48 83 ec 28          	sub    $0x28,%rsp
  8011fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801203:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80120f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801213:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80121f:	0f 83 88 00 00 00    	jae    8012ad <memmove+0xba>
  801225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801229:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122d:	48 01 d0             	add    %rdx,%rax
  801230:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801234:	76 77                	jbe    8012ad <memmove+0xba>
		s += n;
  801236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80123e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801242:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124a:	83 e0 03             	and    $0x3,%eax
  80124d:	48 85 c0             	test   %rax,%rax
  801250:	75 3b                	jne    80128d <memmove+0x9a>
  801252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801256:	83 e0 03             	and    $0x3,%eax
  801259:	48 85 c0             	test   %rax,%rax
  80125c:	75 2f                	jne    80128d <memmove+0x9a>
  80125e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801262:	83 e0 03             	and    $0x3,%eax
  801265:	48 85 c0             	test   %rax,%rax
  801268:	75 23                	jne    80128d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	48 83 e8 04          	sub    $0x4,%rax
  801272:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801276:	48 83 ea 04          	sub    $0x4,%rdx
  80127a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80127e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801282:	48 89 c7             	mov    %rax,%rdi
  801285:	48 89 d6             	mov    %rdx,%rsi
  801288:	fd                   	std    
  801289:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80128b:	eb 1d                	jmp    8012aa <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801299:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80129d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a1:	48 89 d7             	mov    %rdx,%rdi
  8012a4:	48 89 c1             	mov    %rax,%rcx
  8012a7:	fd                   	std    
  8012a8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012aa:	fc                   	cld    
  8012ab:	eb 57                	jmp    801304 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	83 e0 03             	and    $0x3,%eax
  8012b4:	48 85 c0             	test   %rax,%rax
  8012b7:	75 36                	jne    8012ef <memmove+0xfc>
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bd:	83 e0 03             	and    $0x3,%eax
  8012c0:	48 85 c0             	test   %rax,%rax
  8012c3:	75 2a                	jne    8012ef <memmove+0xfc>
  8012c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c9:	83 e0 03             	and    $0x3,%eax
  8012cc:	48 85 c0             	test   %rax,%rax
  8012cf:	75 1e                	jne    8012ef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d5:	48 c1 e8 02          	shr    $0x2,%rax
  8012d9:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e4:	48 89 c7             	mov    %rax,%rdi
  8012e7:	48 89 d6             	mov    %rdx,%rsi
  8012ea:	fc                   	cld    
  8012eb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ed:	eb 15                	jmp    801304 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012fb:	48 89 c7             	mov    %rax,%rdi
  8012fe:	48 89 d6             	mov    %rdx,%rsi
  801301:	fc                   	cld    
  801302:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 18          	sub    $0x18,%rsp
  801312:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801316:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80131a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80131e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801322:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132a:	48 89 ce             	mov    %rcx,%rsi
  80132d:	48 89 c7             	mov    %rax,%rdi
  801330:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
}
  80133c:	c9                   	leaveq 
  80133d:	c3                   	retq   

000000000080133e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	48 83 ec 28          	sub    $0x28,%rsp
  801346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801356:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80135a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801362:	eb 36                	jmp    80139a <memcmp+0x5c>
		if (*s1 != *s2)
  801364:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801368:	0f b6 10             	movzbl (%rax),%edx
  80136b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	38 c2                	cmp    %al,%dl
  801374:	74 1a                	je     801390 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	0f b6 d0             	movzbl %al,%edx
  801380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801384:	0f b6 00             	movzbl (%rax),%eax
  801387:	0f b6 c0             	movzbl %al,%eax
  80138a:	29 c2                	sub    %eax,%edx
  80138c:	89 d0                	mov    %edx,%eax
  80138e:	eb 20                	jmp    8013b0 <memcmp+0x72>
		s1++, s2++;
  801390:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801395:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80139a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013a6:	48 85 c0             	test   %rax,%rax
  8013a9:	75 b9                	jne    801364 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b0:	c9                   	leaveq 
  8013b1:	c3                   	retq   

00000000008013b2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b2:	55                   	push   %rbp
  8013b3:	48 89 e5             	mov    %rsp,%rbp
  8013b6:	48 83 ec 28          	sub    $0x28,%rsp
  8013ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013cd:	48 01 d0             	add    %rdx,%rax
  8013d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d4:	eb 15                	jmp    8013eb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013da:	0f b6 10             	movzbl (%rax),%edx
  8013dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	75 02                	jne    8013e6 <memfind+0x34>
			break;
  8013e4:	eb 0f                	jmp    8013f5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ef:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f3:	72 e1                	jb     8013d6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 34          	sub    $0x34,%rsp
  801403:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801407:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80140b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80140e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801415:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141d:	eb 05                	jmp    801424 <strtol+0x29>
		s++;
  80141f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	3c 20                	cmp    $0x20,%al
  80142d:	74 f0                	je     80141f <strtol+0x24>
  80142f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	3c 09                	cmp    $0x9,%al
  801438:	74 e5                	je     80141f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	3c 2b                	cmp    $0x2b,%al
  801443:	75 07                	jne    80144c <strtol+0x51>
		s++;
  801445:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144a:	eb 17                	jmp    801463 <strtol+0x68>
	else if (*s == '-')
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3c 2d                	cmp    $0x2d,%al
  801455:	75 0c                	jne    801463 <strtol+0x68>
		s++, neg = 1;
  801457:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801463:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801467:	74 06                	je     80146f <strtol+0x74>
  801469:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146d:	75 28                	jne    801497 <strtol+0x9c>
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	3c 30                	cmp    $0x30,%al
  801478:	75 1d                	jne    801497 <strtol+0x9c>
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	48 83 c0 01          	add    $0x1,%rax
  801482:	0f b6 00             	movzbl (%rax),%eax
  801485:	3c 78                	cmp    $0x78,%al
  801487:	75 0e                	jne    801497 <strtol+0x9c>
		s += 2, base = 16;
  801489:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80148e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801495:	eb 2c                	jmp    8014c3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801497:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149b:	75 19                	jne    8014b6 <strtol+0xbb>
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	3c 30                	cmp    $0x30,%al
  8014a6:	75 0e                	jne    8014b6 <strtol+0xbb>
		s++, base = 8;
  8014a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ad:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b4:	eb 0d                	jmp    8014c3 <strtol+0xc8>
	else if (base == 0)
  8014b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014ba:	75 07                	jne    8014c3 <strtol+0xc8>
		base = 10;
  8014bc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	3c 2f                	cmp    $0x2f,%al
  8014cc:	7e 1d                	jle    8014eb <strtol+0xf0>
  8014ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	3c 39                	cmp    $0x39,%al
  8014d7:	7f 12                	jg     8014eb <strtol+0xf0>
			dig = *s - '0';
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	83 e8 30             	sub    $0x30,%eax
  8014e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e9:	eb 4e                	jmp    801539 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	3c 60                	cmp    $0x60,%al
  8014f4:	7e 1d                	jle    801513 <strtol+0x118>
  8014f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fa:	0f b6 00             	movzbl (%rax),%eax
  8014fd:	3c 7a                	cmp    $0x7a,%al
  8014ff:	7f 12                	jg     801513 <strtol+0x118>
			dig = *s - 'a' + 10;
  801501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801505:	0f b6 00             	movzbl (%rax),%eax
  801508:	0f be c0             	movsbl %al,%eax
  80150b:	83 e8 57             	sub    $0x57,%eax
  80150e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801511:	eb 26                	jmp    801539 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 48                	jle    801566 <strtol+0x16b>
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	3c 5a                	cmp    $0x5a,%al
  801527:	7f 3d                	jg     801566 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f be c0             	movsbl %al,%eax
  801533:	83 e8 37             	sub    $0x37,%eax
  801536:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80153f:	7c 02                	jl     801543 <strtol+0x148>
			break;
  801541:	eb 23                	jmp    801566 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801543:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801548:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80154b:	48 98                	cltq   
  80154d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801552:	48 89 c2             	mov    %rax,%rdx
  801555:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801558:	48 98                	cltq   
  80155a:	48 01 d0             	add    %rdx,%rax
  80155d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801561:	e9 5d ff ff ff       	jmpq   8014c3 <strtol+0xc8>

	if (endptr)
  801566:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80156b:	74 0b                	je     801578 <strtol+0x17d>
		*endptr = (char *) s;
  80156d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801571:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801575:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80157c:	74 09                	je     801587 <strtol+0x18c>
  80157e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801582:	48 f7 d8             	neg    %rax
  801585:	eb 04                	jmp    80158b <strtol+0x190>
  801587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158b:	c9                   	leaveq 
  80158c:	c3                   	retq   

000000000080158d <strstr>:

char * strstr(const char *in, const char *str)
{
  80158d:	55                   	push   %rbp
  80158e:	48 89 e5             	mov    %rsp,%rbp
  801591:	48 83 ec 30          	sub    $0x30,%rsp
  801595:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801599:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80159d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8015af:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b3:	75 06                	jne    8015bb <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	eb 6b                	jmp    801626 <strstr+0x99>

    len = strlen(str);
  8015bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bf:	48 89 c7             	mov    %rax,%rdi
  8015c2:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  8015c9:	00 00 00 
  8015cc:	ff d0                	callq  *%rax
  8015ce:	48 98                	cltq   
  8015d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e0:	0f b6 00             	movzbl (%rax),%eax
  8015e3:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ea:	75 07                	jne    8015f3 <strstr+0x66>
                return (char *) 0;
  8015ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f1:	eb 33                	jmp    801626 <strstr+0x99>
        } while (sc != c);
  8015f3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015f7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015fa:	75 d8                	jne    8015d4 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8015fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801600:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	48 89 ce             	mov    %rcx,%rsi
  80160b:	48 89 c7             	mov    %rax,%rdi
  80160e:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  801615:	00 00 00 
  801618:	ff d0                	callq  *%rax
  80161a:	85 c0                	test   %eax,%eax
  80161c:	75 b6                	jne    8015d4 <strstr+0x47>

    return (char *) (in - 1);
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	48 83 e8 01          	sub    $0x1,%rax
}
  801626:	c9                   	leaveq 
  801627:	c3                   	retq   

0000000000801628 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	53                   	push   %rbx
  80162d:	48 83 ec 48          	sub    $0x48,%rsp
  801631:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801634:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801637:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80163b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80163f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801643:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801647:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80164e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801652:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801656:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80165e:	4c 89 c3             	mov    %r8,%rbx
  801661:	cd 30                	int    $0x30
  801663:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801667:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80166b:	74 3e                	je     8016ab <syscall+0x83>
  80166d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801672:	7e 37                	jle    8016ab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801678:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167b:	49 89 d0             	mov    %rdx,%r8
  80167e:	89 c1                	mov    %eax,%ecx
  801680:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  801687:	00 00 00 
  80168a:	be 23 00 00 00       	mov    $0x23,%esi
  80168f:	48 bf 7d 41 80 00 00 	movabs $0x80417d,%rdi
  801696:	00 00 00 
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	49 b9 94 39 80 00 00 	movabs $0x803994,%r9
  8016a5:	00 00 00 
  8016a8:	41 ff d1             	callq  *%r9

	return ret;
  8016ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016af:	48 83 c4 48          	add    $0x48,%rsp
  8016b3:	5b                   	pop    %rbx
  8016b4:	5d                   	pop    %rbp
  8016b5:	c3                   	retq   

00000000008016b6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016b6:	55                   	push   %rbp
  8016b7:	48 89 e5             	mov    %rsp,%rbp
  8016ba:	48 83 ec 20          	sub    $0x20,%rsp
  8016be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d5:	00 
  8016d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e2:	48 89 d1             	mov    %rdx,%rcx
  8016e5:	48 89 c2             	mov    %rax,%rdx
  8016e8:	be 00 00 00 00       	mov    $0x0,%esi
  8016ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f2:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
}
  8016fe:	c9                   	leaveq 
  8016ff:	c3                   	retq   

0000000000801700 <sys_cgetc>:

int
sys_cgetc(void)
{
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801708:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80170f:	00 
  801710:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801716:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801721:	ba 00 00 00 00       	mov    $0x0,%edx
  801726:	be 00 00 00 00       	mov    $0x0,%esi
  80172b:	bf 01 00 00 00       	mov    $0x1,%edi
  801730:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801737:	00 00 00 
  80173a:	ff d0                	callq  *%rax
}
  80173c:	c9                   	leaveq 
  80173d:	c3                   	retq   

000000000080173e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80173e:	55                   	push   %rbp
  80173f:	48 89 e5             	mov    %rsp,%rbp
  801742:	48 83 ec 10          	sub    $0x10,%rsp
  801746:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801749:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80174c:	48 98                	cltq   
  80174e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801755:	00 
  801756:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	48 89 c2             	mov    %rax,%rdx
  80176a:	be 01 00 00 00       	mov    $0x1,%esi
  80176f:	bf 03 00 00 00       	mov    $0x3,%edi
  801774:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  80177b:	00 00 00 
  80177e:	ff d0                	callq  *%rax
}
  801780:	c9                   	leaveq 
  801781:	c3                   	retq   

0000000000801782 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801782:	55                   	push   %rbp
  801783:	48 89 e5             	mov    %rsp,%rbp
  801786:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801791:	00 
  801792:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801798:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a8:	be 00 00 00 00       	mov    $0x0,%esi
  8017ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b2:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8017b9:	00 00 00 
  8017bc:	ff d0                	callq  *%rax
}
  8017be:	c9                   	leaveq 
  8017bf:	c3                   	retq   

00000000008017c0 <sys_yield>:

void
sys_yield(void)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017cf:	00 
  8017d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e6:	be 00 00 00 00       	mov    $0x0,%esi
  8017eb:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f0:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
}
  8017fc:	c9                   	leaveq 
  8017fd:	c3                   	retq   

00000000008017fe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017fe:	55                   	push   %rbp
  8017ff:	48 89 e5             	mov    %rsp,%rbp
  801802:	48 83 ec 20          	sub    $0x20,%rsp
  801806:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801809:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801810:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801813:	48 63 c8             	movslq %eax,%rcx
  801816:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181d:	48 98                	cltq   
  80181f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801826:	00 
  801827:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182d:	49 89 c8             	mov    %rcx,%r8
  801830:	48 89 d1             	mov    %rdx,%rcx
  801833:	48 89 c2             	mov    %rax,%rdx
  801836:	be 01 00 00 00       	mov    $0x1,%esi
  80183b:	bf 04 00 00 00       	mov    $0x4,%edi
  801840:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801847:	00 00 00 
  80184a:	ff d0                	callq  *%rax
}
  80184c:	c9                   	leaveq 
  80184d:	c3                   	retq   

000000000080184e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80184e:	55                   	push   %rbp
  80184f:	48 89 e5             	mov    %rsp,%rbp
  801852:	48 83 ec 30          	sub    $0x30,%rsp
  801856:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801859:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801860:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801864:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801868:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80186b:	48 63 c8             	movslq %eax,%rcx
  80186e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801872:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801875:	48 63 f0             	movslq %eax,%rsi
  801878:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187f:	48 98                	cltq   
  801881:	48 89 0c 24          	mov    %rcx,(%rsp)
  801885:	49 89 f9             	mov    %rdi,%r9
  801888:	49 89 f0             	mov    %rsi,%r8
  80188b:	48 89 d1             	mov    %rdx,%rcx
  80188e:	48 89 c2             	mov    %rax,%rdx
  801891:	be 01 00 00 00       	mov    $0x1,%esi
  801896:	bf 05 00 00 00       	mov    $0x5,%edi
  80189b:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8018a2:	00 00 00 
  8018a5:	ff d0                	callq  *%rax
}
  8018a7:	c9                   	leaveq 
  8018a8:	c3                   	retq   

00000000008018a9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018a9:	55                   	push   %rbp
  8018aa:	48 89 e5             	mov    %rsp,%rbp
  8018ad:	48 83 ec 20          	sub    $0x20,%rsp
  8018b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bf:	48 98                	cltq   
  8018c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c8:	00 
  8018c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d5:	48 89 d1             	mov    %rdx,%rcx
  8018d8:	48 89 c2             	mov    %rax,%rdx
  8018db:	be 01 00 00 00       	mov    $0x1,%esi
  8018e0:	bf 06 00 00 00       	mov    $0x6,%edi
  8018e5:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	callq  *%rax
}
  8018f1:	c9                   	leaveq 
  8018f2:	c3                   	retq   

00000000008018f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
  8018f7:	48 83 ec 10          	sub    $0x10,%rsp
  8018fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801904:	48 63 d0             	movslq %eax,%rdx
  801907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190a:	48 98                	cltq   
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	48 89 d1             	mov    %rdx,%rcx
  801923:	48 89 c2             	mov    %rax,%rdx
  801926:	be 01 00 00 00       	mov    $0x1,%esi
  80192b:	bf 08 00 00 00       	mov    $0x8,%edi
  801930:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
}
  80193c:	c9                   	leaveq 
  80193d:	c3                   	retq   

000000000080193e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	48 83 ec 20          	sub    $0x20,%rsp
  801946:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801949:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80194d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801954:	48 98                	cltq   
  801956:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195d:	00 
  80195e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801964:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196a:	48 89 d1             	mov    %rdx,%rcx
  80196d:	48 89 c2             	mov    %rax,%rdx
  801970:	be 01 00 00 00       	mov    $0x1,%esi
  801975:	bf 09 00 00 00       	mov    $0x9,%edi
  80197a:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801981:	00 00 00 
  801984:	ff d0                	callq  *%rax
}
  801986:	c9                   	leaveq 
  801987:	c3                   	retq   

0000000000801988 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801988:	55                   	push   %rbp
  801989:	48 89 e5             	mov    %rsp,%rbp
  80198c:	48 83 ec 20          	sub    $0x20,%rsp
  801990:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801993:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801997:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199e:	48 98                	cltq   
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	48 89 d1             	mov    %rdx,%rcx
  8019b7:	48 89 c2             	mov    %rax,%rdx
  8019ba:	be 01 00 00 00       	mov    $0x1,%esi
  8019bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c4:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
}
  8019d0:	c9                   	leaveq 
  8019d1:	c3                   	retq   

00000000008019d2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d2:	55                   	push   %rbp
  8019d3:	48 89 e5             	mov    %rsp,%rbp
  8019d6:	48 83 ec 20          	sub    $0x20,%rsp
  8019da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019e5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019eb:	48 63 f0             	movslq %eax,%rsi
  8019ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f5:	48 98                	cltq   
  8019f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a02:	00 
  801a03:	49 89 f1             	mov    %rsi,%r9
  801a06:	49 89 c8             	mov    %rcx,%r8
  801a09:	48 89 d1             	mov    %rdx,%rcx
  801a0c:	48 89 c2             	mov    %rax,%rdx
  801a0f:	be 00 00 00 00       	mov    $0x0,%esi
  801a14:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a19:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 10          	sub    $0x10,%rsp
  801a2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3e:	00 
  801a3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a50:	48 89 c2             	mov    %rax,%rdx
  801a53:	be 01 00 00 00       	mov    $0x1,%esi
  801a58:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a5d:	48 b8 28 16 80 00 00 	movabs $0x801628,%rax
  801a64:	00 00 00 
  801a67:	ff d0                	callq  *%rax
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
  801a6f:	48 83 ec 30          	sub    $0x30,%rsp
  801a73:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7b:	48 8b 00             	mov    (%rax),%rax
  801a7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a8a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801a8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a90:	83 e0 02             	and    $0x2,%eax
  801a93:	85 c0                	test   %eax,%eax
  801a95:	75 4d                	jne    801ae4 <pgfault+0x79>
  801a97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9b:	48 c1 e8 0c          	shr    $0xc,%rax
  801a9f:	48 89 c2             	mov    %rax,%rdx
  801aa2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aa9:	01 00 00 
  801aac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ab0:	25 00 08 00 00       	and    $0x800,%eax
  801ab5:	48 85 c0             	test   %rax,%rax
  801ab8:	74 2a                	je     801ae4 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801aba:	48 ba 90 41 80 00 00 	movabs $0x804190,%rdx
  801ac1:	00 00 00 
  801ac4:	be 23 00 00 00       	mov    $0x23,%esi
  801ac9:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801ad0:	00 00 00 
  801ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad8:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801adf:	00 00 00 
  801ae2:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801ae4:	ba 07 00 00 00       	mov    $0x7,%edx
  801ae9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801aee:	bf 00 00 00 00       	mov    $0x0,%edi
  801af3:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
  801aff:	85 c0                	test   %eax,%eax
  801b01:	0f 85 cd 00 00 00    	jne    801bd4 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b13:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b19:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b21:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b26:	48 89 c6             	mov    %rax,%rsi
  801b29:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b2e:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  801b35:	00 00 00 
  801b38:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b44:	48 89 c1             	mov    %rax,%rcx
  801b47:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b51:	bf 00 00 00 00       	mov    $0x0,%edi
  801b56:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	callq  *%rax
  801b62:	85 c0                	test   %eax,%eax
  801b64:	79 2a                	jns    801b90 <pgfault+0x125>
				panic("Page map at temp address failed");
  801b66:	48 ba d0 41 80 00 00 	movabs $0x8041d0,%rdx
  801b6d:	00 00 00 
  801b70:	be 30 00 00 00       	mov    $0x30,%esi
  801b75:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801b7c:	00 00 00 
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b84:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801b8b:	00 00 00 
  801b8e:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801b90:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b95:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9a:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	79 54                	jns    801bfe <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801baa:	48 ba f0 41 80 00 00 	movabs $0x8041f0,%rdx
  801bb1:	00 00 00 
  801bb4:	be 32 00 00 00       	mov    $0x32,%esi
  801bb9:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801bc0:	00 00 00 
  801bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc8:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801bcf:	00 00 00 
  801bd2:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801bd4:	48 ba 18 42 80 00 00 	movabs $0x804218,%rdx
  801bdb:	00 00 00 
  801bde:	be 34 00 00 00       	mov    $0x34,%esi
  801be3:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801bea:	00 00 00 
  801bed:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf2:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801bf9:	00 00 00 
  801bfc:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 20          	sub    $0x20,%rsp
  801c08:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c0b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801c0e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c15:	01 00 00 
  801c18:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c1f:	25 07 0e 00 00       	and    $0xe07,%eax
  801c24:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c27:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c2a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c35:	25 00 04 00 00       	and    $0x400,%eax
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	74 57                	je     801c95 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c3e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c41:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c45:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4c:	41 89 f0             	mov    %esi,%r8d
  801c4f:	48 89 c6             	mov    %rax,%rsi
  801c52:	bf 00 00 00 00       	mov    $0x0,%edi
  801c57:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801c5e:	00 00 00 
  801c61:	ff d0                	callq  *%rax
  801c63:	85 c0                	test   %eax,%eax
  801c65:	0f 8e 52 01 00 00    	jle    801dbd <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801c6b:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  801c72:	00 00 00 
  801c75:	be 4e 00 00 00       	mov    $0x4e,%esi
  801c7a:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801c81:	00 00 00 
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
  801c89:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801c90:	00 00 00 
  801c93:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801c95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c98:	83 e0 02             	and    $0x2,%eax
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	75 10                	jne    801caf <duppage+0xaf>
  801c9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca2:	25 00 08 00 00       	and    $0x800,%eax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	0f 84 bb 00 00 00    	je     801d6a <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb2:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cb7:	80 cc 08             	or     $0x8,%ah
  801cba:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cbd:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cc0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cc4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccb:	41 89 f0             	mov    %esi,%r8d
  801cce:	48 89 c6             	mov    %rax,%rsi
  801cd1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd6:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	callq  *%rax
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	7e 2a                	jle    801d10 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801ce6:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  801ced:	00 00 00 
  801cf0:	be 55 00 00 00       	mov    $0x55,%esi
  801cf5:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801cfc:	00 00 00 
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801d0b:	00 00 00 
  801d0e:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d10:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1b:	41 89 c8             	mov    %ecx,%r8d
  801d1e:	48 89 d1             	mov    %rdx,%rcx
  801d21:	ba 00 00 00 00       	mov    $0x0,%edx
  801d26:	48 89 c6             	mov    %rax,%rsi
  801d29:	bf 00 00 00 00       	mov    $0x0,%edi
  801d2e:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	7e 2a                	jle    801d68 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801d3e:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  801d45:	00 00 00 
  801d48:	be 57 00 00 00       	mov    $0x57,%esi
  801d4d:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801d54:	00 00 00 
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801d63:	00 00 00 
  801d66:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d68:	eb 53                	jmp    801dbd <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d6a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d6d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d71:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d78:	41 89 f0             	mov    %esi,%r8d
  801d7b:	48 89 c6             	mov    %rax,%rsi
  801d7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d83:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	7e 2a                	jle    801dbd <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d93:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  801d9a:	00 00 00 
  801d9d:	be 5b 00 00 00       	mov    $0x5b,%esi
  801da2:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801da9:	00 00 00 
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
  801db1:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  801db8:	00 00 00 
  801dbb:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leaveq 
  801dc3:	c3                   	retq   

0000000000801dc4 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801dc4:	55                   	push   %rbp
  801dc5:	48 89 e5             	mov    %rsp,%rbp
  801dc8:	48 83 ec 18          	sub    $0x18,%rsp
  801dcc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801dd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddc:	48 c1 e8 27          	shr    $0x27,%rax
  801de0:	48 89 c2             	mov    %rax,%rdx
  801de3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801dea:	01 00 00 
  801ded:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df1:	83 e0 01             	and    $0x1,%eax
  801df4:	48 85 c0             	test   %rax,%rax
  801df7:	74 51                	je     801e4a <pt_is_mapped+0x86>
  801df9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfd:	48 c1 e0 0c          	shl    $0xc,%rax
  801e01:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e05:	48 89 c2             	mov    %rax,%rdx
  801e08:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e0f:	01 00 00 
  801e12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e16:	83 e0 01             	and    $0x1,%eax
  801e19:	48 85 c0             	test   %rax,%rax
  801e1c:	74 2c                	je     801e4a <pt_is_mapped+0x86>
  801e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e22:	48 c1 e0 0c          	shl    $0xc,%rax
  801e26:	48 c1 e8 15          	shr    $0x15,%rax
  801e2a:	48 89 c2             	mov    %rax,%rdx
  801e2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e34:	01 00 00 
  801e37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3b:	83 e0 01             	and    $0x1,%eax
  801e3e:	48 85 c0             	test   %rax,%rax
  801e41:	74 07                	je     801e4a <pt_is_mapped+0x86>
  801e43:	b8 01 00 00 00       	mov    $0x1,%eax
  801e48:	eb 05                	jmp    801e4f <pt_is_mapped+0x8b>
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	83 e0 01             	and    $0x1,%eax
}
  801e52:	c9                   	leaveq 
  801e53:	c3                   	retq   

0000000000801e54 <fork>:

envid_t
fork(void)
{
  801e54:	55                   	push   %rbp
  801e55:	48 89 e5             	mov    %rsp,%rbp
  801e58:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801e5c:	48 bf 6b 1a 80 00 00 	movabs $0x801a6b,%rdi
  801e63:	00 00 00 
  801e66:	48 b8 a8 3a 80 00 00 	movabs $0x803aa8,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e72:	b8 07 00 00 00       	mov    $0x7,%eax
  801e77:	cd 30                	int    $0x30
  801e79:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e7c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e7f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e86:	79 30                	jns    801eb8 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801e88:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e8b:	89 c1                	mov    %eax,%ecx
  801e8d:	48 ba 68 42 80 00 00 	movabs $0x804268,%rdx
  801e94:	00 00 00 
  801e97:	be 86 00 00 00       	mov    $0x86,%esi
  801e9c:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  801ea3:	00 00 00 
  801ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eab:	49 b8 94 39 80 00 00 	movabs $0x803994,%r8
  801eb2:	00 00 00 
  801eb5:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ebc:	75 46                	jne    801f04 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801ebe:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	callq  *%rax
  801eca:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ecf:	48 63 d0             	movslq %eax,%rdx
  801ed2:	48 89 d0             	mov    %rdx,%rax
  801ed5:	48 c1 e0 03          	shl    $0x3,%rax
  801ed9:	48 01 d0             	add    %rdx,%rax
  801edc:	48 c1 e0 05          	shl    $0x5,%rax
  801ee0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ee7:	00 00 00 
  801eea:	48 01 c2             	add    %rax,%rdx
  801eed:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ef4:	00 00 00 
  801ef7:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	e9 d1 01 00 00       	jmpq   8020d5 <fork+0x281>
	}
	uint64_t ad = 0;
  801f04:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f0b:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801f0c:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801f11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801f15:	e9 df 00 00 00       	jmpq   801ff9 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1e:	48 c1 e8 27          	shr    $0x27,%rax
  801f22:	48 89 c2             	mov    %rax,%rdx
  801f25:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f2c:	01 00 00 
  801f2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f33:	83 e0 01             	and    $0x1,%eax
  801f36:	48 85 c0             	test   %rax,%rax
  801f39:	0f 84 9e 00 00 00    	je     801fdd <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f43:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f47:	48 89 c2             	mov    %rax,%rdx
  801f4a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f51:	01 00 00 
  801f54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f58:	83 e0 01             	and    $0x1,%eax
  801f5b:	48 85 c0             	test   %rax,%rax
  801f5e:	74 73                	je     801fd3 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f64:	48 c1 e8 15          	shr    $0x15,%rax
  801f68:	48 89 c2             	mov    %rax,%rdx
  801f6b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f72:	01 00 00 
  801f75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f79:	83 e0 01             	and    $0x1,%eax
  801f7c:	48 85 c0             	test   %rax,%rax
  801f7f:	74 48                	je     801fc9 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f85:	48 c1 e8 0c          	shr    $0xc,%rax
  801f89:	48 89 c2             	mov    %rax,%rdx
  801f8c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f93:	01 00 00 
  801f96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa2:	83 e0 01             	and    $0x1,%eax
  801fa5:	48 85 c0             	test   %rax,%rax
  801fa8:	74 47                	je     801ff1 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  801faa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fae:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb2:	89 c2                	mov    %eax,%edx
  801fb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fb7:	89 d6                	mov    %edx,%esi
  801fb9:	89 c7                	mov    %eax,%edi
  801fbb:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
  801fc7:	eb 28                	jmp    801ff1 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  801fc9:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801fd0:	00 
  801fd1:	eb 1e                	jmp    801ff1 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801fd3:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801fda:	40 
  801fdb:	eb 14                	jmp    801ff1 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  801fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe1:	48 c1 e8 27          	shr    $0x27,%rax
  801fe5:	48 83 c0 01          	add    $0x1,%rax
  801fe9:	48 c1 e0 27          	shl    $0x27,%rax
  801fed:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801ff1:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  801ff8:	00 
  801ff9:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802000:	00 
  802001:	0f 87 13 ff ff ff    	ja     801f1a <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802007:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80200a:	ba 07 00 00 00       	mov    $0x7,%edx
  80200f:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802014:	89 c7                	mov    %eax,%edi
  802016:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802022:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802025:	ba 07 00 00 00       	mov    $0x7,%edx
  80202a:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80202f:	89 c7                	mov    %eax,%edi
  802031:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80203d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802040:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802046:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80204b:	ba 00 00 00 00       	mov    $0x0,%edx
  802050:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802055:	89 c7                	mov    %eax,%edi
  802057:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802063:	ba 00 10 00 00       	mov    $0x1000,%edx
  802068:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80206d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802072:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  802079:	00 00 00 
  80207c:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80207e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802083:	bf 00 00 00 00       	mov    $0x0,%edi
  802088:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802094:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80209b:	00 00 00 
  80209e:	48 8b 00             	mov    (%rax),%rax
  8020a1:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8020a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020ab:	48 89 d6             	mov    %rdx,%rsi
  8020ae:	89 c7                	mov    %eax,%edi
  8020b0:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8020bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020bf:	be 02 00 00 00       	mov    $0x2,%esi
  8020c4:	89 c7                	mov    %eax,%edi
  8020c6:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax

	return envid;
  8020d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8020d5:	c9                   	leaveq 
  8020d6:	c3                   	retq   

00000000008020d7 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8020d7:	55                   	push   %rbp
  8020d8:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020db:	48 ba 80 42 80 00 00 	movabs $0x804280,%rdx
  8020e2:	00 00 00 
  8020e5:	be bf 00 00 00       	mov    $0xbf,%esi
  8020ea:	48 bf c5 41 80 00 00 	movabs $0x8041c5,%rdi
  8020f1:	00 00 00 
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  802100:	00 00 00 
  802103:	ff d1                	callq  *%rcx

0000000000802105 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802105:	55                   	push   %rbp
  802106:	48 89 e5             	mov    %rsp,%rbp
  802109:	48 83 ec 30          	sub    $0x30,%rsp
  80210d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802111:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802115:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802119:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802120:	00 00 00 
  802123:	48 8b 00             	mov    (%rax),%rax
  802126:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	75 3c                	jne    80216c <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802130:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  802137:	00 00 00 
  80213a:	ff d0                	callq  *%rax
  80213c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802141:	48 63 d0             	movslq %eax,%rdx
  802144:	48 89 d0             	mov    %rdx,%rax
  802147:	48 c1 e0 03          	shl    $0x3,%rax
  80214b:	48 01 d0             	add    %rdx,%rax
  80214e:	48 c1 e0 05          	shl    $0x5,%rax
  802152:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802159:	00 00 00 
  80215c:	48 01 c2             	add    %rax,%rdx
  80215f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802166:	00 00 00 
  802169:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80216c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802171:	75 0e                	jne    802181 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802173:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80217a:	00 00 00 
  80217d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802181:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802185:	48 89 c7             	mov    %rax,%rdi
  802188:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219b:	79 19                	jns    8021b6 <ipc_recv+0xb1>
		*from_env_store = 0;
  80219d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8021a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ab:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8021b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b4:	eb 53                	jmp    802209 <ipc_recv+0x104>
	}
	if(from_env_store)
  8021b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021bb:	74 19                	je     8021d6 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8021bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021c4:	00 00 00 
  8021c7:	48 8b 00             	mov    (%rax),%rax
  8021ca:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8021d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d4:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8021d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021db:	74 19                	je     8021f6 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8021dd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021e4:	00 00 00 
  8021e7:	48 8b 00             	mov    (%rax),%rax
  8021ea:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8021f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8021f6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021fd:	00 00 00 
  802200:	48 8b 00             	mov    (%rax),%rax
  802203:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	48 83 ec 30          	sub    $0x30,%rsp
  802213:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802216:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802219:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80221d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802220:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802225:	75 0e                	jne    802235 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802227:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80222e:	00 00 00 
  802231:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802235:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802238:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80223b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80223f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802242:	89 c7                	mov    %eax,%edi
  802244:	48 b8 d2 19 80 00 00 	movabs $0x8019d2,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
  802250:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802253:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802257:	75 0c                	jne    802265 <ipc_send+0x5a>
			sys_yield();
  802259:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  802260:	00 00 00 
  802263:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802265:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802269:	74 ca                	je     802235 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80226b:	c9                   	leaveq 
  80226c:	c3                   	retq   

000000000080226d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80226d:	55                   	push   %rbp
  80226e:	48 89 e5             	mov    %rsp,%rbp
  802271:	48 83 ec 14          	sub    $0x14,%rsp
  802275:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80227f:	eb 5e                	jmp    8022df <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802281:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802288:	00 00 00 
  80228b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228e:	48 63 d0             	movslq %eax,%rdx
  802291:	48 89 d0             	mov    %rdx,%rax
  802294:	48 c1 e0 03          	shl    $0x3,%rax
  802298:	48 01 d0             	add    %rdx,%rax
  80229b:	48 c1 e0 05          	shl    $0x5,%rax
  80229f:	48 01 c8             	add    %rcx,%rax
  8022a2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8022a8:	8b 00                	mov    (%rax),%eax
  8022aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022ad:	75 2c                	jne    8022db <ipc_find_env+0x6e>
			return envs[i].env_id;
  8022af:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022b6:	00 00 00 
  8022b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bc:	48 63 d0             	movslq %eax,%rdx
  8022bf:	48 89 d0             	mov    %rdx,%rax
  8022c2:	48 c1 e0 03          	shl    $0x3,%rax
  8022c6:	48 01 d0             	add    %rdx,%rax
  8022c9:	48 c1 e0 05          	shl    $0x5,%rax
  8022cd:	48 01 c8             	add    %rcx,%rax
  8022d0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8022d6:	8b 40 08             	mov    0x8(%rax),%eax
  8022d9:	eb 12                	jmp    8022ed <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022df:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8022e6:	7e 99                	jle    802281 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ed:	c9                   	leaveq 
  8022ee:	c3                   	retq   

00000000008022ef <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022ef:	55                   	push   %rbp
  8022f0:	48 89 e5             	mov    %rsp,%rbp
  8022f3:	48 83 ec 08          	sub    $0x8,%rsp
  8022f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022ff:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802306:	ff ff ff 
  802309:	48 01 d0             	add    %rdx,%rax
  80230c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802310:	c9                   	leaveq 
  802311:	c3                   	retq   

0000000000802312 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802312:	55                   	push   %rbp
  802313:	48 89 e5             	mov    %rsp,%rbp
  802316:	48 83 ec 08          	sub    $0x8,%rsp
  80231a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80231e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802322:	48 89 c7             	mov    %rax,%rdi
  802325:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	callq  *%rax
  802331:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802337:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	48 83 ec 18          	sub    $0x18,%rsp
  802345:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802350:	eb 6b                	jmp    8023bd <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802355:	48 98                	cltq   
  802357:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80235d:	48 c1 e0 0c          	shl    $0xc,%rax
  802361:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802369:	48 c1 e8 15          	shr    $0x15,%rax
  80236d:	48 89 c2             	mov    %rax,%rdx
  802370:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802377:	01 00 00 
  80237a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237e:	83 e0 01             	and    $0x1,%eax
  802381:	48 85 c0             	test   %rax,%rax
  802384:	74 21                	je     8023a7 <fd_alloc+0x6a>
  802386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238a:	48 c1 e8 0c          	shr    $0xc,%rax
  80238e:	48 89 c2             	mov    %rax,%rdx
  802391:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802398:	01 00 00 
  80239b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239f:	83 e0 01             	and    $0x1,%eax
  8023a2:	48 85 c0             	test   %rax,%rax
  8023a5:	75 12                	jne    8023b9 <fd_alloc+0x7c>
			*fd_store = fd;
  8023a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023af:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	eb 1a                	jmp    8023d3 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023bd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023c1:	7e 8f                	jle    802352 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023ce:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 20          	sub    $0x20,%rsp
  8023dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023e8:	78 06                	js     8023f0 <fd_lookup+0x1b>
  8023ea:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023ee:	7e 07                	jle    8023f7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023f5:	eb 6c                	jmp    802463 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023fa:	48 98                	cltq   
  8023fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802402:	48 c1 e0 0c          	shl    $0xc,%rax
  802406:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80240a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240e:	48 c1 e8 15          	shr    $0x15,%rax
  802412:	48 89 c2             	mov    %rax,%rdx
  802415:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80241c:	01 00 00 
  80241f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802423:	83 e0 01             	and    $0x1,%eax
  802426:	48 85 c0             	test   %rax,%rax
  802429:	74 21                	je     80244c <fd_lookup+0x77>
  80242b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242f:	48 c1 e8 0c          	shr    $0xc,%rax
  802433:	48 89 c2             	mov    %rax,%rdx
  802436:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80243d:	01 00 00 
  802440:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802444:	83 e0 01             	and    $0x1,%eax
  802447:	48 85 c0             	test   %rax,%rax
  80244a:	75 07                	jne    802453 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80244c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802451:	eb 10                	jmp    802463 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802453:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802457:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80245b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802463:	c9                   	leaveq 
  802464:	c3                   	retq   

0000000000802465 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802465:	55                   	push   %rbp
  802466:	48 89 e5             	mov    %rsp,%rbp
  802469:	48 83 ec 30          	sub    $0x30,%rsp
  80246d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802471:	89 f0                	mov    %esi,%eax
  802473:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247a:	48 89 c7             	mov    %rax,%rdi
  80247d:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  802484:	00 00 00 
  802487:	ff d0                	callq  *%rax
  802489:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248d:	48 89 d6             	mov    %rdx,%rsi
  802490:	89 c7                	mov    %eax,%edi
  802492:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
  80249e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a5:	78 0a                	js     8024b1 <fd_close+0x4c>
	    || fd != fd2)
  8024a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ab:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024af:	74 12                	je     8024c3 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024b1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024b5:	74 05                	je     8024bc <fd_close+0x57>
  8024b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ba:	eb 05                	jmp    8024c1 <fd_close+0x5c>
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	eb 69                	jmp    80252c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c7:	8b 00                	mov    (%rax),%eax
  8024c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024cd:	48 89 d6             	mov    %rdx,%rsi
  8024d0:	89 c7                	mov    %eax,%edi
  8024d2:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
  8024de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e5:	78 2a                	js     802511 <fd_close+0xac>
		if (dev->dev_close)
  8024e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024ef:	48 85 c0             	test   %rax,%rax
  8024f2:	74 16                	je     80250a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802500:	48 89 d7             	mov    %rdx,%rdi
  802503:	ff d0                	callq  *%rax
  802505:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802508:	eb 07                	jmp    802511 <fd_close+0xac>
		else
			r = 0;
  80250a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802515:	48 89 c6             	mov    %rax,%rsi
  802518:	bf 00 00 00 00       	mov    $0x0,%edi
  80251d:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
	return r;
  802529:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 20          	sub    $0x20,%rsp
  802536:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802539:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80253d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802544:	eb 41                	jmp    802587 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802546:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80254d:	00 00 00 
  802550:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802553:	48 63 d2             	movslq %edx,%rdx
  802556:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80255a:	8b 00                	mov    (%rax),%eax
  80255c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80255f:	75 22                	jne    802583 <dev_lookup+0x55>
			*dev = devtab[i];
  802561:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802568:	00 00 00 
  80256b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80256e:	48 63 d2             	movslq %edx,%rdx
  802571:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802575:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802579:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	eb 60                	jmp    8025e3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802583:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802587:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80258e:	00 00 00 
  802591:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802594:	48 63 d2             	movslq %edx,%rdx
  802597:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259b:	48 85 c0             	test   %rax,%rax
  80259e:	75 a6                	jne    802546 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025a0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025a7:	00 00 00 
  8025aa:	48 8b 00             	mov    (%rax),%rax
  8025ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	48 bf 98 42 80 00 00 	movabs $0x804298,%rdi
  8025bf:	00 00 00 
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c7:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  8025ce:	00 00 00 
  8025d1:	ff d1                	callq  *%rcx
	*dev = 0;
  8025d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025e3:	c9                   	leaveq 
  8025e4:	c3                   	retq   

00000000008025e5 <close>:

int
close(int fdnum)
{
  8025e5:	55                   	push   %rbp
  8025e6:	48 89 e5             	mov    %rsp,%rbp
  8025e9:	48 83 ec 20          	sub    $0x20,%rsp
  8025ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f7:	48 89 d6             	mov    %rdx,%rsi
  8025fa:	89 c7                	mov    %eax,%edi
  8025fc:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260f:	79 05                	jns    802616 <close+0x31>
		return r;
  802611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802614:	eb 18                	jmp    80262e <close+0x49>
	else
		return fd_close(fd, 1);
  802616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261a:	be 01 00 00 00       	mov    $0x1,%esi
  80261f:	48 89 c7             	mov    %rax,%rdi
  802622:	48 b8 65 24 80 00 00 	movabs $0x802465,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
}
  80262e:	c9                   	leaveq 
  80262f:	c3                   	retq   

0000000000802630 <close_all>:

void
close_all(void)
{
  802630:	55                   	push   %rbp
  802631:	48 89 e5             	mov    %rsp,%rbp
  802634:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802638:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80263f:	eb 15                	jmp    802656 <close_all+0x26>
		close(i);
  802641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802644:	89 c7                	mov    %eax,%edi
  802646:	48 b8 e5 25 80 00 00 	movabs $0x8025e5,%rax
  80264d:	00 00 00 
  802650:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802652:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802656:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80265a:	7e e5                	jle    802641 <close_all+0x11>
		close(i);
}
  80265c:	c9                   	leaveq 
  80265d:	c3                   	retq   

000000000080265e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80265e:	55                   	push   %rbp
  80265f:	48 89 e5             	mov    %rsp,%rbp
  802662:	48 83 ec 40          	sub    $0x40,%rsp
  802666:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802669:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80266c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802670:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802673:	48 89 d6             	mov    %rdx,%rsi
  802676:	89 c7                	mov    %eax,%edi
  802678:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  80267f:	00 00 00 
  802682:	ff d0                	callq  *%rax
  802684:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802687:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268b:	79 08                	jns    802695 <dup+0x37>
		return r;
  80268d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802690:	e9 70 01 00 00       	jmpq   802805 <dup+0x1a7>
	close(newfdnum);
  802695:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802698:	89 c7                	mov    %eax,%edi
  80269a:	48 b8 e5 25 80 00 00 	movabs $0x8025e5,%rax
  8026a1:	00 00 00 
  8026a4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026a6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026a9:	48 98                	cltq   
  8026ab:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026b1:	48 c1 e0 0c          	shl    $0xc,%rax
  8026b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026bd:	48 89 c7             	mov    %rax,%rdi
  8026c0:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  8026c7:	00 00 00 
  8026ca:	ff d0                	callq  *%rax
  8026cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d4:	48 89 c7             	mov    %rax,%rdi
  8026d7:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026eb:	48 c1 e8 15          	shr    $0x15,%rax
  8026ef:	48 89 c2             	mov    %rax,%rdx
  8026f2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026f9:	01 00 00 
  8026fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802700:	83 e0 01             	and    $0x1,%eax
  802703:	48 85 c0             	test   %rax,%rax
  802706:	74 73                	je     80277b <dup+0x11d>
  802708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270c:	48 c1 e8 0c          	shr    $0xc,%rax
  802710:	48 89 c2             	mov    %rax,%rdx
  802713:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80271a:	01 00 00 
  80271d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802721:	83 e0 01             	and    $0x1,%eax
  802724:	48 85 c0             	test   %rax,%rax
  802727:	74 52                	je     80277b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272d:	48 c1 e8 0c          	shr    $0xc,%rax
  802731:	48 89 c2             	mov    %rax,%rdx
  802734:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80273b:	01 00 00 
  80273e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802742:	25 07 0e 00 00       	and    $0xe07,%eax
  802747:	89 c1                	mov    %eax,%ecx
  802749:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80274d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802751:	41 89 c8             	mov    %ecx,%r8d
  802754:	48 89 d1             	mov    %rdx,%rcx
  802757:	ba 00 00 00 00       	mov    $0x0,%edx
  80275c:	48 89 c6             	mov    %rax,%rsi
  80275f:	bf 00 00 00 00       	mov    $0x0,%edi
  802764:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	callq  *%rax
  802770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802777:	79 02                	jns    80277b <dup+0x11d>
			goto err;
  802779:	eb 57                	jmp    8027d2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80277b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277f:	48 c1 e8 0c          	shr    $0xc,%rax
  802783:	48 89 c2             	mov    %rax,%rdx
  802786:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80278d:	01 00 00 
  802790:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802794:	25 07 0e 00 00       	and    $0xe07,%eax
  802799:	89 c1                	mov    %eax,%ecx
  80279b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80279f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a3:	41 89 c8             	mov    %ecx,%r8d
  8027a6:	48 89 d1             	mov    %rdx,%rcx
  8027a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ae:	48 89 c6             	mov    %rax,%rsi
  8027b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b6:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
  8027c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c9:	79 02                	jns    8027cd <dup+0x16f>
		goto err;
  8027cb:	eb 05                	jmp    8027d2 <dup+0x174>

	return newfdnum;
  8027cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027d0:	eb 33                	jmp    802805 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d6:	48 89 c6             	mov    %rax,%rsi
  8027d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027de:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ee:	48 89 c6             	mov    %rax,%rsi
  8027f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f6:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8027fd:	00 00 00 
  802800:	ff d0                	callq  *%rax
	return r;
  802802:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802805:	c9                   	leaveq 
  802806:	c3                   	retq   

0000000000802807 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802807:	55                   	push   %rbp
  802808:	48 89 e5             	mov    %rsp,%rbp
  80280b:	48 83 ec 40          	sub    $0x40,%rsp
  80280f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802812:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802816:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80281a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80281e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802821:	48 89 d6             	mov    %rdx,%rsi
  802824:	89 c7                	mov    %eax,%edi
  802826:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  80282d:	00 00 00 
  802830:	ff d0                	callq  *%rax
  802832:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802835:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802839:	78 24                	js     80285f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80283b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283f:	8b 00                	mov    (%rax),%eax
  802841:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802845:	48 89 d6             	mov    %rdx,%rsi
  802848:	89 c7                	mov    %eax,%edi
  80284a:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
  802856:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285d:	79 05                	jns    802864 <read+0x5d>
		return r;
  80285f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802862:	eb 76                	jmp    8028da <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802868:	8b 40 08             	mov    0x8(%rax),%eax
  80286b:	83 e0 03             	and    $0x3,%eax
  80286e:	83 f8 01             	cmp    $0x1,%eax
  802871:	75 3a                	jne    8028ad <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802873:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80287a:	00 00 00 
  80287d:	48 8b 00             	mov    (%rax),%rax
  802880:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802886:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802889:	89 c6                	mov    %eax,%esi
  80288b:	48 bf b7 42 80 00 00 	movabs $0x8042b7,%rdi
  802892:	00 00 00 
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  8028a1:	00 00 00 
  8028a4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028ab:	eb 2d                	jmp    8028da <read+0xd3>
	}
	if (!dev->dev_read)
  8028ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028b5:	48 85 c0             	test   %rax,%rax
  8028b8:	75 07                	jne    8028c1 <read+0xba>
		return -E_NOT_SUPP;
  8028ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028bf:	eb 19                	jmp    8028da <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028c9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028cd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028d1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028d5:	48 89 cf             	mov    %rcx,%rdi
  8028d8:	ff d0                	callq  *%rax
}
  8028da:	c9                   	leaveq 
  8028db:	c3                   	retq   

00000000008028dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028dc:	55                   	push   %rbp
  8028dd:	48 89 e5             	mov    %rsp,%rbp
  8028e0:	48 83 ec 30          	sub    $0x30,%rsp
  8028e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028f6:	eb 49                	jmp    802941 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	48 98                	cltq   
  8028fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802901:	48 29 c2             	sub    %rax,%rdx
  802904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802907:	48 63 c8             	movslq %eax,%rcx
  80290a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290e:	48 01 c1             	add    %rax,%rcx
  802911:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802914:	48 89 ce             	mov    %rcx,%rsi
  802917:	89 c7                	mov    %eax,%edi
  802919:	48 b8 07 28 80 00 00 	movabs $0x802807,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
  802925:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802928:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80292c:	79 05                	jns    802933 <readn+0x57>
			return m;
  80292e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802931:	eb 1c                	jmp    80294f <readn+0x73>
		if (m == 0)
  802933:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802937:	75 02                	jne    80293b <readn+0x5f>
			break;
  802939:	eb 11                	jmp    80294c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80293b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80293e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802944:	48 98                	cltq   
  802946:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80294a:	72 ac                	jb     8028f8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80294c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80294f:	c9                   	leaveq 
  802950:	c3                   	retq   

0000000000802951 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802951:	55                   	push   %rbp
  802952:	48 89 e5             	mov    %rsp,%rbp
  802955:	48 83 ec 40          	sub    $0x40,%rsp
  802959:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80295c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802960:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802964:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802968:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80296b:	48 89 d6             	mov    %rdx,%rsi
  80296e:	89 c7                	mov    %eax,%edi
  802970:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
  80297c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802983:	78 24                	js     8029a9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802989:	8b 00                	mov    (%rax),%eax
  80298b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80298f:	48 89 d6             	mov    %rdx,%rsi
  802992:	89 c7                	mov    %eax,%edi
  802994:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a7:	79 05                	jns    8029ae <write+0x5d>
		return r;
  8029a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ac:	eb 75                	jmp    802a23 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b2:	8b 40 08             	mov    0x8(%rax),%eax
  8029b5:	83 e0 03             	and    $0x3,%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	75 3a                	jne    8029f6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029c3:	00 00 00 
  8029c6:	48 8b 00             	mov    (%rax),%rax
  8029c9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029d2:	89 c6                	mov    %eax,%esi
  8029d4:	48 bf d3 42 80 00 00 	movabs $0x8042d3,%rdi
  8029db:	00 00 00 
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e3:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  8029ea:	00 00 00 
  8029ed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f4:	eb 2d                	jmp    802a23 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fa:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029fe:	48 85 c0             	test   %rax,%rax
  802a01:	75 07                	jne    802a0a <write+0xb9>
		return -E_NOT_SUPP;
  802a03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a08:	eb 19                	jmp    802a23 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a12:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a1a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a1e:	48 89 cf             	mov    %rcx,%rdi
  802a21:	ff d0                	callq  *%rax
}
  802a23:	c9                   	leaveq 
  802a24:	c3                   	retq   

0000000000802a25 <seek>:

int
seek(int fdnum, off_t offset)
{
  802a25:	55                   	push   %rbp
  802a26:	48 89 e5             	mov    %rsp,%rbp
  802a29:	48 83 ec 18          	sub    $0x18,%rsp
  802a2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a30:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a33:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a3a:	48 89 d6             	mov    %rdx,%rsi
  802a3d:	89 c7                	mov    %eax,%edi
  802a3f:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	79 05                	jns    802a59 <seek+0x34>
		return r;
  802a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a57:	eb 0f                	jmp    802a68 <seek+0x43>
	fd->fd_offset = offset;
  802a59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a68:	c9                   	leaveq 
  802a69:	c3                   	retq   

0000000000802a6a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a6a:	55                   	push   %rbp
  802a6b:	48 89 e5             	mov    %rsp,%rbp
  802a6e:	48 83 ec 30          	sub    $0x30,%rsp
  802a72:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a75:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a7f:	48 89 d6             	mov    %rdx,%rsi
  802a82:	89 c7                	mov    %eax,%edi
  802a84:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	callq  *%rax
  802a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a97:	78 24                	js     802abd <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9d:	8b 00                	mov    (%rax),%eax
  802a9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa3:	48 89 d6             	mov    %rdx,%rsi
  802aa6:	89 c7                	mov    %eax,%edi
  802aa8:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	callq  *%rax
  802ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abb:	79 05                	jns    802ac2 <ftruncate+0x58>
		return r;
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac0:	eb 72                	jmp    802b34 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac6:	8b 40 08             	mov    0x8(%rax),%eax
  802ac9:	83 e0 03             	and    $0x3,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	75 3a                	jne    802b0a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ad0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ad7:	00 00 00 
  802ada:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802add:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ae3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae6:	89 c6                	mov    %eax,%esi
  802ae8:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  802aef:	00 00 00 
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	48 b9 1a 03 80 00 00 	movabs $0x80031a,%rcx
  802afe:	00 00 00 
  802b01:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b08:	eb 2a                	jmp    802b34 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b12:	48 85 c0             	test   %rax,%rax
  802b15:	75 07                	jne    802b1e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1c:	eb 16                	jmp    802b34 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b22:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b2a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b2d:	89 ce                	mov    %ecx,%esi
  802b2f:	48 89 d7             	mov    %rdx,%rdi
  802b32:	ff d0                	callq  *%rax
}
  802b34:	c9                   	leaveq 
  802b35:	c3                   	retq   

0000000000802b36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b36:	55                   	push   %rbp
  802b37:	48 89 e5             	mov    %rsp,%rbp
  802b3a:	48 83 ec 30          	sub    $0x30,%rsp
  802b3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b41:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b4c:	48 89 d6             	mov    %rdx,%rsi
  802b4f:	89 c7                	mov    %eax,%edi
  802b51:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
  802b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b64:	78 24                	js     802b8a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6a:	8b 00                	mov    (%rax),%eax
  802b6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b70:	48 89 d6             	mov    %rdx,%rsi
  802b73:	89 c7                	mov    %eax,%edi
  802b75:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b88:	79 05                	jns    802b8f <fstat+0x59>
		return r;
  802b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8d:	eb 5e                	jmp    802bed <fstat+0xb7>
	if (!dev->dev_stat)
  802b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b93:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b97:	48 85 c0             	test   %rax,%rax
  802b9a:	75 07                	jne    802ba3 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b9c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ba1:	eb 4a                	jmp    802bed <fstat+0xb7>
	stat->st_name[0] = 0;
  802ba3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802baa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bae:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bb5:	00 00 00 
	stat->st_isdir = 0;
  802bb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bc3:	00 00 00 
	stat->st_dev = dev;
  802bc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bce:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd9:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bdd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802be1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802be5:	48 89 ce             	mov    %rcx,%rsi
  802be8:	48 89 d7             	mov    %rdx,%rdi
  802beb:	ff d0                	callq  *%rax
}
  802bed:	c9                   	leaveq 
  802bee:	c3                   	retq   

0000000000802bef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
  802bf3:	48 83 ec 20          	sub    $0x20,%rsp
  802bf7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c03:	be 00 00 00 00       	mov    $0x0,%esi
  802c08:	48 89 c7             	mov    %rax,%rdi
  802c0b:	48 b8 dd 2c 80 00 00 	movabs $0x802cdd,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1e:	79 05                	jns    802c25 <stat+0x36>
		return fd;
  802c20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c23:	eb 2f                	jmp    802c54 <stat+0x65>
	r = fstat(fd, stat);
  802c25:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2c:	48 89 d6             	mov    %rdx,%rsi
  802c2f:	89 c7                	mov    %eax,%edi
  802c31:	48 b8 36 2b 80 00 00 	movabs $0x802b36,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
  802c3d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 e5 25 80 00 00 	movabs $0x8025e5,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
	return r;
  802c51:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c54:	c9                   	leaveq 
  802c55:	c3                   	retq   

0000000000802c56 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	48 83 ec 10          	sub    $0x10,%rsp
  802c5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c65:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c6c:	00 00 00 
  802c6f:	8b 00                	mov    (%rax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	75 1d                	jne    802c92 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c75:	bf 01 00 00 00       	mov    $0x1,%edi
  802c7a:	48 b8 6d 22 80 00 00 	movabs $0x80226d,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
  802c86:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802c8d:	00 00 00 
  802c90:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c92:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c99:	00 00 00 
  802c9c:	8b 00                	mov    (%rax),%eax
  802c9e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ca1:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ca6:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802cad:	00 00 00 
  802cb0:	89 c7                	mov    %eax,%edi
  802cb2:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc7:	48 89 c6             	mov    %rax,%rsi
  802cca:	bf 00 00 00 00       	mov    $0x0,%edi
  802ccf:	48 b8 05 21 80 00 00 	movabs $0x802105,%rax
  802cd6:	00 00 00 
  802cd9:	ff d0                	callq  *%rax
}
  802cdb:	c9                   	leaveq 
  802cdc:	c3                   	retq   

0000000000802cdd <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cdd:	55                   	push   %rbp
  802cde:	48 89 e5             	mov    %rsp,%rbp
  802ce1:	48 83 ec 30          	sub    $0x30,%rsp
  802ce5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ce9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802cec:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802cf3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d01:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d06:	75 08                	jne    802d10 <open+0x33>
	{
		return r;
  802d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0b:	e9 f2 00 00 00       	jmpq   802e02 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d14:	48 89 c7             	mov    %rax,%rdi
  802d17:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
  802d23:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d26:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d2d:	7e 0a                	jle    802d39 <open+0x5c>
	{
		return -E_BAD_PATH;
  802d2f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d34:	e9 c9 00 00 00       	jmpq   802e02 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d39:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802d40:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802d41:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d45:	48 89 c7             	mov    %rax,%rdi
  802d48:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5b:	78 09                	js     802d66 <open+0x89>
  802d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d61:	48 85 c0             	test   %rax,%rax
  802d64:	75 08                	jne    802d6e <open+0x91>
		{
			return r;
  802d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d69:	e9 94 00 00 00       	jmpq   802e02 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d72:	ba 00 04 00 00       	mov    $0x400,%edx
  802d77:	48 89 c6             	mov    %rax,%rsi
  802d7a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d81:	00 00 00 
  802d84:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  802d8b:	00 00 00 
  802d8e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802d90:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d97:	00 00 00 
  802d9a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802d9d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da7:	48 89 c6             	mov    %rax,%rsi
  802daa:	bf 01 00 00 00       	mov    $0x1,%edi
  802daf:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
  802dbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc2:	79 2b                	jns    802def <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc8:	be 00 00 00 00       	mov    $0x0,%esi
  802dcd:	48 89 c7             	mov    %rax,%rdi
  802dd0:	48 b8 65 24 80 00 00 	movabs $0x802465,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
  802ddc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802ddf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802de3:	79 05                	jns    802dea <open+0x10d>
			{
				return d;
  802de5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de8:	eb 18                	jmp    802e02 <open+0x125>
			}
			return r;
  802dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ded:	eb 13                	jmp    802e02 <open+0x125>
		}	
		return fd2num(fd_store);
  802def:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df3:	48 89 c7             	mov    %rax,%rdi
  802df6:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  802dfd:	00 00 00 
  802e00:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e02:	c9                   	leaveq 
  802e03:	c3                   	retq   

0000000000802e04 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e04:	55                   	push   %rbp
  802e05:	48 89 e5             	mov    %rsp,%rbp
  802e08:	48 83 ec 10          	sub    $0x10,%rsp
  802e0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e14:	8b 50 0c             	mov    0xc(%rax),%edx
  802e17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1e:	00 00 00 
  802e21:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e23:	be 00 00 00 00       	mov    $0x0,%esi
  802e28:	bf 06 00 00 00       	mov    $0x6,%edi
  802e2d:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
}
  802e39:	c9                   	leaveq 
  802e3a:	c3                   	retq   

0000000000802e3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e3b:	55                   	push   %rbp
  802e3c:	48 89 e5             	mov    %rsp,%rbp
  802e3f:	48 83 ec 30          	sub    $0x30,%rsp
  802e43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802e56:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e5b:	74 07                	je     802e64 <devfile_read+0x29>
  802e5d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e62:	75 07                	jne    802e6b <devfile_read+0x30>
		return -E_INVAL;
  802e64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e69:	eb 77                	jmp    802ee2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6f:	8b 50 0c             	mov    0xc(%rax),%edx
  802e72:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e79:	00 00 00 
  802e7c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e85:	00 00 00 
  802e88:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e8c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802e90:	be 00 00 00 00       	mov    $0x0,%esi
  802e95:	bf 03 00 00 00       	mov    $0x3,%edi
  802e9a:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802ea1:	00 00 00 
  802ea4:	ff d0                	callq  *%rax
  802ea6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ead:	7f 05                	jg     802eb4 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb2:	eb 2e                	jmp    802ee2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb7:	48 63 d0             	movslq %eax,%rdx
  802eba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebe:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ec5:	00 00 00 
  802ec8:	48 89 c7             	mov    %rax,%rdi
  802ecb:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  802ed2:	00 00 00 
  802ed5:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ee2:	c9                   	leaveq 
  802ee3:	c3                   	retq   

0000000000802ee4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ee4:	55                   	push   %rbp
  802ee5:	48 89 e5             	mov    %rsp,%rbp
  802ee8:	48 83 ec 30          	sub    $0x30,%rsp
  802eec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ef4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802ef8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802eff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f04:	74 07                	je     802f0d <devfile_write+0x29>
  802f06:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f0b:	75 08                	jne    802f15 <devfile_write+0x31>
		return r;
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f10:	e9 9a 00 00 00       	jmpq   802faf <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f19:	8b 50 0c             	mov    0xc(%rax),%edx
  802f1c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f23:	00 00 00 
  802f26:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f28:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f2f:	00 
  802f30:	76 08                	jbe    802f3a <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f32:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f39:	00 
	}
	fsipcbuf.write.req_n = n;
  802f3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f41:	00 00 00 
  802f44:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f48:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802f4c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f54:	48 89 c6             	mov    %rax,%rsi
  802f57:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802f5e:	00 00 00 
  802f61:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f6d:	be 00 00 00 00       	mov    $0x0,%esi
  802f72:	bf 04 00 00 00       	mov    $0x4,%edi
  802f77:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	7f 20                	jg     802fac <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802f8c:	48 bf 16 43 80 00 00 	movabs $0x804316,%rdi
  802f93:	00 00 00 
  802f96:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9b:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  802fa2:	00 00 00 
  802fa5:	ff d2                	callq  *%rdx
		return r;
  802fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faa:	eb 03                	jmp    802faf <devfile_write+0xcb>
	}
	return r;
  802fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802faf:	c9                   	leaveq 
  802fb0:	c3                   	retq   

0000000000802fb1 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fb1:	55                   	push   %rbp
  802fb2:	48 89 e5             	mov    %rsp,%rbp
  802fb5:	48 83 ec 20          	sub    $0x20,%rsp
  802fb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc5:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fcf:	00 00 00 
  802fd2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fd4:	be 00 00 00 00       	mov    $0x0,%esi
  802fd9:	bf 05 00 00 00       	mov    $0x5,%edi
  802fde:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff1:	79 05                	jns    802ff8 <devfile_stat+0x47>
		return r;
  802ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff6:	eb 56                	jmp    80304e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ff8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803003:	00 00 00 
  803006:	48 89 c7             	mov    %rax,%rdi
  803009:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803015:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80301c:	00 00 00 
  80301f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803025:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803029:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80302f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803036:	00 00 00 
  803039:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80303f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803043:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80304e:	c9                   	leaveq 
  80304f:	c3                   	retq   

0000000000803050 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803050:	55                   	push   %rbp
  803051:	48 89 e5             	mov    %rsp,%rbp
  803054:	48 83 ec 10          	sub    $0x10,%rsp
  803058:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80305c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80305f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803063:	8b 50 0c             	mov    0xc(%rax),%edx
  803066:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80306d:	00 00 00 
  803070:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803072:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803079:	00 00 00 
  80307c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80307f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803082:	be 00 00 00 00       	mov    $0x0,%esi
  803087:	bf 02 00 00 00       	mov    $0x2,%edi
  80308c:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  803093:	00 00 00 
  803096:	ff d0                	callq  *%rax
}
  803098:	c9                   	leaveq 
  803099:	c3                   	retq   

000000000080309a <remove>:

// Delete a file
int
remove(const char *path)
{
  80309a:	55                   	push   %rbp
  80309b:	48 89 e5             	mov    %rsp,%rbp
  80309e:	48 83 ec 10          	sub    $0x10,%rsp
  8030a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030aa:	48 89 c7             	mov    %rax,%rdi
  8030ad:	48 b8 63 0e 80 00 00 	movabs $0x800e63,%rax
  8030b4:	00 00 00 
  8030b7:	ff d0                	callq  *%rax
  8030b9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030be:	7e 07                	jle    8030c7 <remove+0x2d>
		return -E_BAD_PATH;
  8030c0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030c5:	eb 33                	jmp    8030fa <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030cb:	48 89 c6             	mov    %rax,%rsi
  8030ce:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030d5:	00 00 00 
  8030d8:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030e4:	be 00 00 00 00       	mov    $0x0,%esi
  8030e9:	bf 07 00 00 00       	mov    $0x7,%edi
  8030ee:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
}
  8030fa:	c9                   	leaveq 
  8030fb:	c3                   	retq   

00000000008030fc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030fc:	55                   	push   %rbp
  8030fd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803100:	be 00 00 00 00       	mov    $0x0,%esi
  803105:	bf 08 00 00 00       	mov    $0x8,%edi
  80310a:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
}
  803116:	5d                   	pop    %rbp
  803117:	c3                   	retq   

0000000000803118 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	53                   	push   %rbx
  80311d:	48 83 ec 38          	sub    $0x38,%rsp
  803121:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803125:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803129:	48 89 c7             	mov    %rax,%rdi
  80312c:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80313b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80313f:	0f 88 bf 01 00 00    	js     803304 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803145:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803149:	ba 07 04 00 00       	mov    $0x407,%edx
  80314e:	48 89 c6             	mov    %rax,%rsi
  803151:	bf 00 00 00 00       	mov    $0x0,%edi
  803156:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
  803162:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803165:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803169:	0f 88 95 01 00 00    	js     803304 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80316f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803173:	48 89 c7             	mov    %rax,%rdi
  803176:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  80317d:	00 00 00 
  803180:	ff d0                	callq  *%rax
  803182:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803185:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803189:	0f 88 5d 01 00 00    	js     8032ec <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80318f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803193:	ba 07 04 00 00       	mov    $0x407,%edx
  803198:	48 89 c6             	mov    %rax,%rsi
  80319b:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a0:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031b3:	0f 88 33 01 00 00    	js     8032ec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031bd:	48 89 c7             	mov    %rax,%rdi
  8031c0:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  8031c7:	00 00 00 
  8031ca:	ff d0                	callq  *%rax
  8031cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d4:	ba 07 04 00 00       	mov    $0x407,%edx
  8031d9:	48 89 c6             	mov    %rax,%rsi
  8031dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e1:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
  8031ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031f4:	79 05                	jns    8031fb <pipe+0xe3>
		goto err2;
  8031f6:	e9 d9 00 00 00       	jmpq   8032d4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	48 89 c2             	mov    %rax,%rdx
  803211:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803215:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80321b:	48 89 d1             	mov    %rdx,%rcx
  80321e:	ba 00 00 00 00       	mov    $0x0,%edx
  803223:	48 89 c6             	mov    %rax,%rsi
  803226:	bf 00 00 00 00       	mov    $0x0,%edi
  80322b:	48 b8 4e 18 80 00 00 	movabs $0x80184e,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
  803237:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80323a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80323e:	79 1b                	jns    80325b <pipe+0x143>
		goto err3;
  803240:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803241:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803245:	48 89 c6             	mov    %rax,%rsi
  803248:	bf 00 00 00 00       	mov    $0x0,%edi
  80324d:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  803254:	00 00 00 
  803257:	ff d0                	callq  *%rax
  803259:	eb 79                	jmp    8032d4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80325b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80325f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803266:	00 00 00 
  803269:	8b 12                	mov    (%rdx),%edx
  80326b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80326d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803271:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803283:	00 00 00 
  803286:	8b 12                	mov    (%rdx),%edx
  803288:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80328a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803299:	48 89 c7             	mov    %rax,%rdi
  80329c:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 c2                	mov    %eax,%edx
  8032aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032ae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8032b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032b4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8032b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032bc:	48 89 c7             	mov    %rax,%rdi
  8032bf:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
  8032cb:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d2:	eb 33                	jmp    803307 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8032d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d8:	48 89 c6             	mov    %rax,%rsi
  8032db:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e0:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8032e7:	00 00 00 
  8032ea:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8032ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f0:	48 89 c6             	mov    %rax,%rsi
  8032f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f8:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8032ff:	00 00 00 
  803302:	ff d0                	callq  *%rax
    err:
	return r;
  803304:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803307:	48 83 c4 38          	add    $0x38,%rsp
  80330b:	5b                   	pop    %rbx
  80330c:	5d                   	pop    %rbp
  80330d:	c3                   	retq   

000000000080330e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80330e:	55                   	push   %rbp
  80330f:	48 89 e5             	mov    %rsp,%rbp
  803312:	53                   	push   %rbx
  803313:	48 83 ec 28          	sub    $0x28,%rsp
  803317:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80331b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80331f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803326:	00 00 00 
  803329:	48 8b 00             	mov    (%rax),%rax
  80332c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803332:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803339:	48 89 c7             	mov    %rax,%rdi
  80333c:	48 b8 e8 3b 80 00 00 	movabs $0x803be8,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 c3                	mov    %eax,%ebx
  80334a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80334e:	48 89 c7             	mov    %rax,%rdi
  803351:	48 b8 e8 3b 80 00 00 	movabs $0x803be8,%rax
  803358:	00 00 00 
  80335b:	ff d0                	callq  *%rax
  80335d:	39 c3                	cmp    %eax,%ebx
  80335f:	0f 94 c0             	sete   %al
  803362:	0f b6 c0             	movzbl %al,%eax
  803365:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803368:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80336f:	00 00 00 
  803372:	48 8b 00             	mov    (%rax),%rax
  803375:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80337b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80337e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803381:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803384:	75 05                	jne    80338b <_pipeisclosed+0x7d>
			return ret;
  803386:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803389:	eb 4f                	jmp    8033da <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80338b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803391:	74 42                	je     8033d5 <_pipeisclosed+0xc7>
  803393:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803397:	75 3c                	jne    8033d5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803399:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033a0:	00 00 00 
  8033a3:	48 8b 00             	mov    (%rax),%rax
  8033a6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8033ac:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8033af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b2:	89 c6                	mov    %eax,%esi
  8033b4:	48 bf 37 43 80 00 00 	movabs $0x804337,%rdi
  8033bb:	00 00 00 
  8033be:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c3:	49 b8 1a 03 80 00 00 	movabs $0x80031a,%r8
  8033ca:	00 00 00 
  8033cd:	41 ff d0             	callq  *%r8
	}
  8033d0:	e9 4a ff ff ff       	jmpq   80331f <_pipeisclosed+0x11>
  8033d5:	e9 45 ff ff ff       	jmpq   80331f <_pipeisclosed+0x11>
}
  8033da:	48 83 c4 28          	add    $0x28,%rsp
  8033de:	5b                   	pop    %rbx
  8033df:	5d                   	pop    %rbp
  8033e0:	c3                   	retq   

00000000008033e1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033e1:	55                   	push   %rbp
  8033e2:	48 89 e5             	mov    %rsp,%rbp
  8033e5:	48 83 ec 30          	sub    $0x30,%rsp
  8033e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033f3:	48 89 d6             	mov    %rdx,%rsi
  8033f6:	89 c7                	mov    %eax,%edi
  8033f8:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
  803404:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803407:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340b:	79 05                	jns    803412 <pipeisclosed+0x31>
		return r;
  80340d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803410:	eb 31                	jmp    803443 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803416:	48 89 c7             	mov    %rax,%rdi
  803419:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
  803425:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803431:	48 89 d6             	mov    %rdx,%rsi
  803434:	48 89 c7             	mov    %rax,%rdi
  803437:	48 b8 0e 33 80 00 00 	movabs $0x80330e,%rax
  80343e:	00 00 00 
  803441:	ff d0                	callq  *%rax
}
  803443:	c9                   	leaveq 
  803444:	c3                   	retq   

0000000000803445 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803445:	55                   	push   %rbp
  803446:	48 89 e5             	mov    %rsp,%rbp
  803449:	48 83 ec 40          	sub    $0x40,%rsp
  80344d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803451:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803455:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80345d:	48 89 c7             	mov    %rax,%rdi
  803460:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
  80346c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803470:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803474:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803478:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80347f:	00 
  803480:	e9 92 00 00 00       	jmpq   803517 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803485:	eb 41                	jmp    8034c8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803487:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80348c:	74 09                	je     803497 <devpipe_read+0x52>
				return i;
  80348e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803492:	e9 92 00 00 00       	jmpq   803529 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80349b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349f:	48 89 d6             	mov    %rdx,%rsi
  8034a2:	48 89 c7             	mov    %rax,%rdi
  8034a5:	48 b8 0e 33 80 00 00 	movabs $0x80330e,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 07                	je     8034bc <devpipe_read+0x77>
				return 0;
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ba:	eb 6d                	jmp    803529 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8034bc:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cc:	8b 10                	mov    (%rax),%edx
  8034ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d2:	8b 40 04             	mov    0x4(%rax),%eax
  8034d5:	39 c2                	cmp    %eax,%edx
  8034d7:	74 ae                	je     803487 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034e1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e9:	8b 00                	mov    (%rax),%eax
  8034eb:	99                   	cltd   
  8034ec:	c1 ea 1b             	shr    $0x1b,%edx
  8034ef:	01 d0                	add    %edx,%eax
  8034f1:	83 e0 1f             	and    $0x1f,%eax
  8034f4:	29 d0                	sub    %edx,%eax
  8034f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034fa:	48 98                	cltq   
  8034fc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803501:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803507:	8b 00                	mov    (%rax),%eax
  803509:	8d 50 01             	lea    0x1(%rax),%edx
  80350c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803510:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803512:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80351f:	0f 82 60 ff ff ff    	jb     803485 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803529:	c9                   	leaveq 
  80352a:	c3                   	retq   

000000000080352b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80352b:	55                   	push   %rbp
  80352c:	48 89 e5             	mov    %rsp,%rbp
  80352f:	48 83 ec 40          	sub    $0x40,%rsp
  803533:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803537:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80353b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80353f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803543:	48 89 c7             	mov    %rax,%rdi
  803546:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
  803552:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803556:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80355a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80355e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803565:	00 
  803566:	e9 8e 00 00 00       	jmpq   8035f9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80356b:	eb 31                	jmp    80359e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80356d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803575:	48 89 d6             	mov    %rdx,%rsi
  803578:	48 89 c7             	mov    %rax,%rdi
  80357b:	48 b8 0e 33 80 00 00 	movabs $0x80330e,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 07                	je     803592 <devpipe_write+0x67>
				return 0;
  80358b:	b8 00 00 00 00       	mov    $0x0,%eax
  803590:	eb 79                	jmp    80360b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803592:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80359e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a2:	8b 40 04             	mov    0x4(%rax),%eax
  8035a5:	48 63 d0             	movslq %eax,%rdx
  8035a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ac:	8b 00                	mov    (%rax),%eax
  8035ae:	48 98                	cltq   
  8035b0:	48 83 c0 20          	add    $0x20,%rax
  8035b4:	48 39 c2             	cmp    %rax,%rdx
  8035b7:	73 b4                	jae    80356d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8035b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bd:	8b 40 04             	mov    0x4(%rax),%eax
  8035c0:	99                   	cltd   
  8035c1:	c1 ea 1b             	shr    $0x1b,%edx
  8035c4:	01 d0                	add    %edx,%eax
  8035c6:	83 e0 1f             	and    $0x1f,%eax
  8035c9:	29 d0                	sub    %edx,%eax
  8035cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035d3:	48 01 ca             	add    %rcx,%rdx
  8035d6:	0f b6 0a             	movzbl (%rdx),%ecx
  8035d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035dd:	48 98                	cltq   
  8035df:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e7:	8b 40 04             	mov    0x4(%rax),%eax
  8035ea:	8d 50 01             	lea    0x1(%rax),%edx
  8035ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803601:	0f 82 64 ff ff ff    	jb     80356b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80360b:	c9                   	leaveq 
  80360c:	c3                   	retq   

000000000080360d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80360d:	55                   	push   %rbp
  80360e:	48 89 e5             	mov    %rsp,%rbp
  803611:	48 83 ec 20          	sub    $0x20,%rsp
  803615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803619:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80361d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803621:	48 89 c7             	mov    %rax,%rdi
  803624:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  80362b:	00 00 00 
  80362e:	ff d0                	callq  *%rax
  803630:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803634:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803638:	48 be 4a 43 80 00 00 	movabs $0x80434a,%rsi
  80363f:	00 00 00 
  803642:	48 89 c7             	mov    %rax,%rdi
  803645:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  80364c:	00 00 00 
  80364f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803655:	8b 50 04             	mov    0x4(%rax),%edx
  803658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365c:	8b 00                	mov    (%rax),%eax
  80365e:	29 c2                	sub    %eax,%edx
  803660:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803664:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80366a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80366e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803675:	00 00 00 
	stat->st_dev = &devpipe;
  803678:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80367c:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803683:	00 00 00 
  803686:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80368d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803692:	c9                   	leaveq 
  803693:	c3                   	retq   

0000000000803694 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803694:	55                   	push   %rbp
  803695:	48 89 e5             	mov    %rsp,%rbp
  803698:	48 83 ec 10          	sub    $0x10,%rsp
  80369c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a4:	48 89 c6             	mov    %rax,%rsi
  8036a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ac:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8036b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bc:	48 89 c7             	mov    %rax,%rdi
  8036bf:	48 b8 12 23 80 00 00 	movabs $0x802312,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	48 89 c6             	mov    %rax,%rsi
  8036ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d3:	48 b8 a9 18 80 00 00 	movabs $0x8018a9,%rax
  8036da:	00 00 00 
  8036dd:	ff d0                	callq  *%rax
}
  8036df:	c9                   	leaveq 
  8036e0:	c3                   	retq   

00000000008036e1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036e1:	55                   	push   %rbp
  8036e2:	48 89 e5             	mov    %rsp,%rbp
  8036e5:	48 83 ec 20          	sub    $0x20,%rsp
  8036e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8036ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ef:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036f2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036f6:	be 01 00 00 00       	mov    $0x1,%esi
  8036fb:	48 89 c7             	mov    %rax,%rdi
  8036fe:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
}
  80370a:	c9                   	leaveq 
  80370b:	c3                   	retq   

000000000080370c <getchar>:

int
getchar(void)
{
  80370c:	55                   	push   %rbp
  80370d:	48 89 e5             	mov    %rsp,%rbp
  803710:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803714:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803718:	ba 01 00 00 00       	mov    $0x1,%edx
  80371d:	48 89 c6             	mov    %rax,%rsi
  803720:	bf 00 00 00 00       	mov    $0x0,%edi
  803725:	48 b8 07 28 80 00 00 	movabs $0x802807,%rax
  80372c:	00 00 00 
  80372f:	ff d0                	callq  *%rax
  803731:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803734:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803738:	79 05                	jns    80373f <getchar+0x33>
		return r;
  80373a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373d:	eb 14                	jmp    803753 <getchar+0x47>
	if (r < 1)
  80373f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803743:	7f 07                	jg     80374c <getchar+0x40>
		return -E_EOF;
  803745:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80374a:	eb 07                	jmp    803753 <getchar+0x47>
	return c;
  80374c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803750:	0f b6 c0             	movzbl %al,%eax
}
  803753:	c9                   	leaveq 
  803754:	c3                   	retq   

0000000000803755 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803755:	55                   	push   %rbp
  803756:	48 89 e5             	mov    %rsp,%rbp
  803759:	48 83 ec 20          	sub    $0x20,%rsp
  80375d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803760:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803764:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803767:	48 89 d6             	mov    %rdx,%rsi
  80376a:	89 c7                	mov    %eax,%edi
  80376c:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
  803778:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377f:	79 05                	jns    803786 <iscons+0x31>
		return r;
  803781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803784:	eb 1a                	jmp    8037a0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803786:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378a:	8b 10                	mov    (%rax),%edx
  80378c:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803793:	00 00 00 
  803796:	8b 00                	mov    (%rax),%eax
  803798:	39 c2                	cmp    %eax,%edx
  80379a:	0f 94 c0             	sete   %al
  80379d:	0f b6 c0             	movzbl %al,%eax
}
  8037a0:	c9                   	leaveq 
  8037a1:	c3                   	retq   

00000000008037a2 <opencons>:

int
opencons(void)
{
  8037a2:	55                   	push   %rbp
  8037a3:	48 89 e5             	mov    %rsp,%rbp
  8037a6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8037aa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037ae:	48 89 c7             	mov    %rax,%rdi
  8037b1:	48 b8 3d 23 80 00 00 	movabs $0x80233d,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
  8037bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c4:	79 05                	jns    8037cb <opencons+0x29>
		return r;
  8037c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c9:	eb 5b                	jmp    803826 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8037d4:	48 89 c6             	mov    %rax,%rsi
  8037d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8037dc:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
  8037e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ef:	79 05                	jns    8037f6 <opencons+0x54>
		return r;
  8037f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f4:	eb 30                	jmp    803826 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fa:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803801:	00 00 00 
  803804:	8b 12                	mov    (%rdx),%edx
  803806:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803817:	48 89 c7             	mov    %rax,%rdi
  80381a:	48 b8 ef 22 80 00 00 	movabs $0x8022ef,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
}
  803826:	c9                   	leaveq 
  803827:	c3                   	retq   

0000000000803828 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803828:	55                   	push   %rbp
  803829:	48 89 e5             	mov    %rsp,%rbp
  80382c:	48 83 ec 30          	sub    $0x30,%rsp
  803830:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803834:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803838:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80383c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803841:	75 07                	jne    80384a <devcons_read+0x22>
		return 0;
  803843:	b8 00 00 00 00       	mov    $0x0,%eax
  803848:	eb 4b                	jmp    803895 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80384a:	eb 0c                	jmp    803858 <devcons_read+0x30>
		sys_yield();
  80384c:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803858:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386b:	74 df                	je     80384c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80386d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803871:	79 05                	jns    803878 <devcons_read+0x50>
		return c;
  803873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803876:	eb 1d                	jmp    803895 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803878:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80387c:	75 07                	jne    803885 <devcons_read+0x5d>
		return 0;
  80387e:	b8 00 00 00 00       	mov    $0x0,%eax
  803883:	eb 10                	jmp    803895 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803885:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803888:	89 c2                	mov    %eax,%edx
  80388a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388e:	88 10                	mov    %dl,(%rax)
	return 1;
  803890:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803895:	c9                   	leaveq 
  803896:	c3                   	retq   

0000000000803897 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803897:	55                   	push   %rbp
  803898:	48 89 e5             	mov    %rsp,%rbp
  80389b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8038a2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8038a9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8038b0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038be:	eb 76                	jmp    803936 <devcons_write+0x9f>
		m = n - tot;
  8038c0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038c7:	89 c2                	mov    %eax,%edx
  8038c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cc:	29 c2                	sub    %eax,%edx
  8038ce:	89 d0                	mov    %edx,%eax
  8038d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038d6:	83 f8 7f             	cmp    $0x7f,%eax
  8038d9:	76 07                	jbe    8038e2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038db:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e5:	48 63 d0             	movslq %eax,%rdx
  8038e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038eb:	48 63 c8             	movslq %eax,%rcx
  8038ee:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038f5:	48 01 c1             	add    %rax,%rcx
  8038f8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038ff:	48 89 ce             	mov    %rcx,%rsi
  803902:	48 89 c7             	mov    %rax,%rdi
  803905:	48 b8 f3 11 80 00 00 	movabs $0x8011f3,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803911:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803914:	48 63 d0             	movslq %eax,%rdx
  803917:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80391e:	48 89 d6             	mov    %rdx,%rsi
  803921:	48 89 c7             	mov    %rax,%rdi
  803924:	48 b8 b6 16 80 00 00 	movabs $0x8016b6,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803930:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803933:	01 45 fc             	add    %eax,-0x4(%rbp)
  803936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803939:	48 98                	cltq   
  80393b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803942:	0f 82 78 ff ff ff    	jb     8038c0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803948:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80394b:	c9                   	leaveq 
  80394c:	c3                   	retq   

000000000080394d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80394d:	55                   	push   %rbp
  80394e:	48 89 e5             	mov    %rsp,%rbp
  803951:	48 83 ec 08          	sub    $0x8,%rsp
  803955:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80395e:	c9                   	leaveq 
  80395f:	c3                   	retq   

0000000000803960 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803960:	55                   	push   %rbp
  803961:	48 89 e5             	mov    %rsp,%rbp
  803964:	48 83 ec 10          	sub    $0x10,%rsp
  803968:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80396c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803974:	48 be 56 43 80 00 00 	movabs $0x804356,%rsi
  80397b:	00 00 00 
  80397e:	48 89 c7             	mov    %rax,%rdi
  803981:	48 b8 cf 0e 80 00 00 	movabs $0x800ecf,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
	return 0;
  80398d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803992:	c9                   	leaveq 
  803993:	c3                   	retq   

0000000000803994 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	53                   	push   %rbx
  803999:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8039a0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8039a7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8039ad:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8039b4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8039bb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8039c2:	84 c0                	test   %al,%al
  8039c4:	74 23                	je     8039e9 <_panic+0x55>
  8039c6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8039cd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8039d1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8039d5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8039d9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8039dd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8039e1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8039e5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8039e9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039f0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8039f7:	00 00 00 
  8039fa:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a01:	00 00 00 
  803a04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a08:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a0f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a16:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a1d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803a24:	00 00 00 
  803a27:	48 8b 18             	mov    (%rax),%rbx
  803a2a:	48 b8 82 17 80 00 00 	movabs $0x801782,%rax
  803a31:	00 00 00 
  803a34:	ff d0                	callq  *%rax
  803a36:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a3c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a43:	41 89 c8             	mov    %ecx,%r8d
  803a46:	48 89 d1             	mov    %rdx,%rcx
  803a49:	48 89 da             	mov    %rbx,%rdx
  803a4c:	89 c6                	mov    %eax,%esi
  803a4e:	48 bf 60 43 80 00 00 	movabs $0x804360,%rdi
  803a55:	00 00 00 
  803a58:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5d:	49 b9 1a 03 80 00 00 	movabs $0x80031a,%r9
  803a64:	00 00 00 
  803a67:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a6a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a71:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a78:	48 89 d6             	mov    %rdx,%rsi
  803a7b:	48 89 c7             	mov    %rax,%rdi
  803a7e:	48 b8 6e 02 80 00 00 	movabs $0x80026e,%rax
  803a85:	00 00 00 
  803a88:	ff d0                	callq  *%rax
	cprintf("\n");
  803a8a:	48 bf 83 43 80 00 00 	movabs $0x804383,%rdi
  803a91:	00 00 00 
  803a94:	b8 00 00 00 00       	mov    $0x0,%eax
  803a99:	48 ba 1a 03 80 00 00 	movabs $0x80031a,%rdx
  803aa0:	00 00 00 
  803aa3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803aa5:	cc                   	int3   
  803aa6:	eb fd                	jmp    803aa5 <_panic+0x111>

0000000000803aa8 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803aa8:	55                   	push   %rbp
  803aa9:	48 89 e5             	mov    %rsp,%rbp
  803aac:	48 83 ec 10          	sub    $0x10,%rsp
  803ab0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803ab4:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803abb:	00 00 00 
  803abe:	48 8b 00             	mov    (%rax),%rax
  803ac1:	48 85 c0             	test   %rax,%rax
  803ac4:	0f 85 84 00 00 00    	jne    803b4e <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803aca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ad1:	00 00 00 
  803ad4:	48 8b 00             	mov    (%rax),%rax
  803ad7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803add:	ba 07 00 00 00       	mov    $0x7,%edx
  803ae2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803ae7:	89 c7                	mov    %eax,%edi
  803ae9:	48 b8 fe 17 80 00 00 	movabs $0x8017fe,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
  803af5:	85 c0                	test   %eax,%eax
  803af7:	79 2a                	jns    803b23 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803af9:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  803b00:	00 00 00 
  803b03:	be 23 00 00 00       	mov    $0x23,%esi
  803b08:	48 bf af 43 80 00 00 	movabs $0x8043af,%rdi
  803b0f:	00 00 00 
  803b12:	b8 00 00 00 00       	mov    $0x0,%eax
  803b17:	48 b9 94 39 80 00 00 	movabs $0x803994,%rcx
  803b1e:	00 00 00 
  803b21:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803b23:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b2a:	00 00 00 
  803b2d:	48 8b 00             	mov    (%rax),%rax
  803b30:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b36:	48 be 61 3b 80 00 00 	movabs $0x803b61,%rsi
  803b3d:	00 00 00 
  803b40:	89 c7                	mov    %eax,%edi
  803b42:	48 b8 88 19 80 00 00 	movabs $0x801988,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803b4e:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b55:	00 00 00 
  803b58:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b5c:	48 89 10             	mov    %rdx,(%rax)
}
  803b5f:	c9                   	leaveq 
  803b60:	c3                   	retq   

0000000000803b61 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803b61:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803b64:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b6b:	00 00 00 
	call *%rax
  803b6e:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803b70:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b77:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803b78:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803b7f:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803b80:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803b84:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803b87:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803b8e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803b8f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803b93:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b97:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b9c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803ba1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803ba6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803bab:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803bb0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803bb5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bba:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bbf:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bc4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bc9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803bce:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803bd3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bd8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bdd:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803be1:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803be5:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803be6:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803be7:	c3                   	retq   

0000000000803be8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803be8:	55                   	push   %rbp
  803be9:	48 89 e5             	mov    %rsp,%rbp
  803bec:	48 83 ec 18          	sub    $0x18,%rsp
  803bf0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf8:	48 c1 e8 15          	shr    $0x15,%rax
  803bfc:	48 89 c2             	mov    %rax,%rdx
  803bff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c06:	01 00 00 
  803c09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0d:	83 e0 01             	and    $0x1,%eax
  803c10:	48 85 c0             	test   %rax,%rax
  803c13:	75 07                	jne    803c1c <pageref+0x34>
		return 0;
  803c15:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1a:	eb 53                	jmp    803c6f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c20:	48 c1 e8 0c          	shr    $0xc,%rax
  803c24:	48 89 c2             	mov    %rax,%rdx
  803c27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c2e:	01 00 00 
  803c31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c35:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3d:	83 e0 01             	and    $0x1,%eax
  803c40:	48 85 c0             	test   %rax,%rax
  803c43:	75 07                	jne    803c4c <pageref+0x64>
		return 0;
  803c45:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4a:	eb 23                	jmp    803c6f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c50:	48 c1 e8 0c          	shr    $0xc,%rax
  803c54:	48 89 c2             	mov    %rax,%rdx
  803c57:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c5e:	00 00 00 
  803c61:	48 c1 e2 04          	shl    $0x4,%rdx
  803c65:	48 01 d0             	add    %rdx,%rax
  803c68:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c6c:	0f b7 c0             	movzwl %ax,%eax
}
  803c6f:	c9                   	leaveq 
  803c70:	c3                   	retq   
