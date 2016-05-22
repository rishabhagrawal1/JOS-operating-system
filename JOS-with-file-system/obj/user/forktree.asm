
obj/user/forktree.debug:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba a0 3c 80 00 00 	movabs $0x803ca0,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 a0 0d 80 00 00 	movabs $0x800da0,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 72 1e 80 00 00 	movabs $0x801e72,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf a5 3c 80 00 00 	movabs $0x803ca5,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf b6 3c 80 00 00 	movabs $0x803cb6,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800174:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	25 ff 03 00 00       	and    $0x3ff,%eax
  800185:	48 63 d0             	movslq %eax,%rdx
  800188:	48 89 d0             	mov    %rdx,%rax
  80018b:	48 c1 e0 03          	shl    $0x3,%rax
  80018f:	48 01 d0             	add    %rdx,%rax
  800192:	48 c1 e0 05          	shl    $0x5,%rax
  800196:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80019d:	00 00 00 
  8001a0:	48 01 c2             	add    %rax,%rdx
  8001a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001aa:	00 00 00 
  8001ad:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b4:	7e 14                	jle    8001ca <libmain+0x65>
		binaryname = argv[0];
  8001b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ba:	48 8b 10             	mov    (%rax),%rdx
  8001bd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c4:	00 00 00 
  8001c7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d1:	48 89 d6             	mov    %rdx,%rsi
  8001d4:	89 c7                	mov    %eax,%edi
  8001d6:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001e2:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
}
  8001ee:	c9                   	leaveq 
  8001ef:	c3                   	retq   

00000000008001f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f4:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800200:	bf 00 00 00 00       	mov    $0x0,%edi
  800205:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax

}
  800211:	5d                   	pop    %rbp
  800212:	c3                   	retq   

0000000000800213 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800213:	55                   	push   %rbp
  800214:	48 89 e5             	mov    %rsp,%rbp
  800217:	48 83 ec 10          	sub    $0x10,%rsp
  80021b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80021e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800226:	8b 00                	mov    (%rax),%eax
  800228:	8d 48 01             	lea    0x1(%rax),%ecx
  80022b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022f:	89 0a                	mov    %ecx,(%rdx)
  800231:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800234:	89 d1                	mov    %edx,%ecx
  800236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023a:	48 98                	cltq   
  80023c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	8b 00                	mov    (%rax),%eax
  800246:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024b:	75 2c                	jne    800279 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80024d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800251:	8b 00                	mov    (%rax),%eax
  800253:	48 98                	cltq   
  800255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800259:	48 83 c2 08          	add    $0x8,%rdx
  80025d:	48 89 c6             	mov    %rax,%rsi
  800260:	48 89 d7             	mov    %rdx,%rdi
  800263:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
		b->idx = 0;
  80026f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800273:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027d:	8b 40 04             	mov    0x4(%rax),%eax
  800280:	8d 50 01             	lea    0x1(%rax),%edx
  800283:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800287:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028a:	c9                   	leaveq 
  80028b:	c3                   	retq   

000000000080028c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800297:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80029e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8002a5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002ac:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b3:	48 8b 0a             	mov    (%rdx),%rcx
  8002b6:	48 89 08             	mov    %rcx,(%rax)
  8002b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d0:	00 00 00 
	b.cnt = 0;
  8002d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002dd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002eb:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f2:	48 89 c6             	mov    %rax,%rsi
  8002f5:	48 bf 13 02 80 00 00 	movabs $0x800213,%rdi
  8002fc:	00 00 00 
  8002ff:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80030b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800311:	48 98                	cltq   
  800313:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031a:	48 83 c2 08          	add    $0x8,%rdx
  80031e:	48 89 c6             	mov    %rax,%rsi
  800321:	48 89 d7             	mov    %rdx,%rdi
  800324:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800330:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
  80033c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800343:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80034a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800351:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800358:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80035f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800366:	84 c0                	test   %al,%al
  800368:	74 20                	je     80038a <cprintf+0x52>
  80036a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80036e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800372:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800376:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80037a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80037e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800382:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800386:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80038a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800391:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800398:	00 00 00 
  80039b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a2:	00 00 00 
  8003a5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003a9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003b7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003be:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003c5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003cc:	48 8b 0a             	mov    (%rdx),%rcx
  8003cf:	48 89 08             	mov    %rcx,(%rax)
  8003d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003de:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003e2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f0:	48 89 d6             	mov    %rdx,%rsi
  8003f3:	48 89 c7             	mov    %rax,%rdi
  8003f6:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  8003fd:	00 00 00 
  800400:	ff d0                	callq  *%rax
  800402:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800408:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80040e:	c9                   	leaveq 
  80040f:	c3                   	retq   

0000000000800410 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	53                   	push   %rbx
  800415:	48 83 ec 38          	sub    $0x38,%rsp
  800419:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80041d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800421:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800425:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800428:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80042c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800433:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800437:	77 3b                	ja     800474 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800439:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80043c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800440:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	48 f7 f3             	div    %rbx
  80044f:	48 89 c2             	mov    %rax,%rdx
  800452:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800455:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800458:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80045c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800460:	41 89 f9             	mov    %edi,%r9d
  800463:	48 89 c7             	mov    %rax,%rdi
  800466:	48 b8 10 04 80 00 00 	movabs $0x800410,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
  800472:	eb 1e                	jmp    800492 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800474:	eb 12                	jmp    800488 <printnum+0x78>
			putch(padc, putdat);
  800476:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80047a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80047d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800481:	48 89 ce             	mov    %rcx,%rsi
  800484:	89 d7                	mov    %edx,%edi
  800486:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800488:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80048c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800490:	7f e4                	jg     800476 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800492:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	48 f7 f1             	div    %rcx
  8004a1:	48 89 d0             	mov    %rdx,%rax
  8004a4:	48 ba a8 3e 80 00 00 	movabs $0x803ea8,%rdx
  8004ab:	00 00 00 
  8004ae:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b2:	0f be d0             	movsbl %al,%edx
  8004b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	48 89 ce             	mov    %rcx,%rsi
  8004c0:	89 d7                	mov    %edx,%edi
  8004c2:	ff d0                	callq  *%rax
}
  8004c4:	48 83 c4 38          	add    $0x38,%rsp
  8004c8:	5b                   	pop    %rbx
  8004c9:	5d                   	pop    %rbp
  8004ca:	c3                   	retq   

00000000008004cb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cb:	55                   	push   %rbp
  8004cc:	48 89 e5             	mov    %rsp,%rbp
  8004cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004de:	7e 52                	jle    800532 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e4:	8b 00                	mov    (%rax),%eax
  8004e6:	83 f8 30             	cmp    $0x30,%eax
  8004e9:	73 24                	jae    80050f <getuint+0x44>
  8004eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	8b 00                	mov    (%rax),%eax
  8004f9:	89 c0                	mov    %eax,%eax
  8004fb:	48 01 d0             	add    %rdx,%rax
  8004fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800502:	8b 12                	mov    (%rdx),%edx
  800504:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800507:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050b:	89 0a                	mov    %ecx,(%rdx)
  80050d:	eb 17                	jmp    800526 <getuint+0x5b>
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800517:	48 89 d0             	mov    %rdx,%rax
  80051a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800522:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800526:	48 8b 00             	mov    (%rax),%rax
  800529:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052d:	e9 a3 00 00 00       	jmpq   8005d5 <getuint+0x10a>
	else if (lflag)
  800532:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800536:	74 4f                	je     800587 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	8b 00                	mov    (%rax),%eax
  80053e:	83 f8 30             	cmp    $0x30,%eax
  800541:	73 24                	jae    800567 <getuint+0x9c>
  800543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800547:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	8b 00                	mov    (%rax),%eax
  800551:	89 c0                	mov    %eax,%eax
  800553:	48 01 d0             	add    %rdx,%rax
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	8b 12                	mov    (%rdx),%edx
  80055c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800563:	89 0a                	mov    %ecx,(%rdx)
  800565:	eb 17                	jmp    80057e <getuint+0xb3>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80056f:	48 89 d0             	mov    %rdx,%rax
  800572:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800576:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057e:	48 8b 00             	mov    (%rax),%rax
  800581:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800585:	eb 4e                	jmp    8005d5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	83 f8 30             	cmp    $0x30,%eax
  800590:	73 24                	jae    8005b6 <getuint+0xeb>
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	8b 00                	mov    (%rax),%eax
  8005a0:	89 c0                	mov    %eax,%eax
  8005a2:	48 01 d0             	add    %rdx,%rax
  8005a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a9:	8b 12                	mov    (%rdx),%edx
  8005ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	89 0a                	mov    %ecx,(%rdx)
  8005b4:	eb 17                	jmp    8005cd <getuint+0x102>
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005be:	48 89 d0             	mov    %rdx,%rax
  8005c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cd:	8b 00                	mov    (%rax),%eax
  8005cf:	89 c0                	mov    %eax,%eax
  8005d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005d9:	c9                   	leaveq 
  8005da:	c3                   	retq   

00000000008005db <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005db:	55                   	push   %rbp
  8005dc:	48 89 e5             	mov    %rsp,%rbp
  8005df:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005ea:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ee:	7e 52                	jle    800642 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	8b 00                	mov    (%rax),%eax
  8005f6:	83 f8 30             	cmp    $0x30,%eax
  8005f9:	73 24                	jae    80061f <getint+0x44>
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800607:	8b 00                	mov    (%rax),%eax
  800609:	89 c0                	mov    %eax,%eax
  80060b:	48 01 d0             	add    %rdx,%rax
  80060e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800612:	8b 12                	mov    (%rdx),%edx
  800614:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800617:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061b:	89 0a                	mov    %ecx,(%rdx)
  80061d:	eb 17                	jmp    800636 <getint+0x5b>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800627:	48 89 d0             	mov    %rdx,%rax
  80062a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800632:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800636:	48 8b 00             	mov    (%rax),%rax
  800639:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063d:	e9 a3 00 00 00       	jmpq   8006e5 <getint+0x10a>
	else if (lflag)
  800642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800646:	74 4f                	je     800697 <getint+0xbc>
		x=va_arg(*ap, long);
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	8b 00                	mov    (%rax),%eax
  80064e:	83 f8 30             	cmp    $0x30,%eax
  800651:	73 24                	jae    800677 <getint+0x9c>
  800653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800657:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	89 c0                	mov    %eax,%eax
  800663:	48 01 d0             	add    %rdx,%rax
  800666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066a:	8b 12                	mov    (%rdx),%edx
  80066c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	89 0a                	mov    %ecx,(%rdx)
  800675:	eb 17                	jmp    80068e <getint+0xb3>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80067f:	48 89 d0             	mov    %rdx,%rax
  800682:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068e:	48 8b 00             	mov    (%rax),%rax
  800691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800695:	eb 4e                	jmp    8006e5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	83 f8 30             	cmp    $0x30,%eax
  8006a0:	73 24                	jae    8006c6 <getint+0xeb>
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ae:	8b 00                	mov    (%rax),%eax
  8006b0:	89 c0                	mov    %eax,%eax
  8006b2:	48 01 d0             	add    %rdx,%rax
  8006b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b9:	8b 12                	mov    (%rdx),%edx
  8006bb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	89 0a                	mov    %ecx,(%rdx)
  8006c4:	eb 17                	jmp    8006dd <getint+0x102>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ce:	48 89 d0             	mov    %rdx,%rax
  8006d1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006dd:	8b 00                	mov    (%rax),%eax
  8006df:	48 98                	cltq   
  8006e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e9:	c9                   	leaveq 
  8006ea:	c3                   	retq   

00000000008006eb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006eb:	55                   	push   %rbp
  8006ec:	48 89 e5             	mov    %rsp,%rbp
  8006ef:	41 54                	push   %r12
  8006f1:	53                   	push   %rbx
  8006f2:	48 83 ec 60          	sub    $0x60,%rsp
  8006f6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006fa:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006fe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800702:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800706:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80070a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80070e:	48 8b 0a             	mov    (%rdx),%rcx
  800711:	48 89 08             	mov    %rcx,(%rax)
  800714:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800718:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800720:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800724:	eb 17                	jmp    80073d <vprintfmt+0x52>
			if (ch == '\0')
  800726:	85 db                	test   %ebx,%ebx
  800728:	0f 84 cc 04 00 00    	je     800bfa <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80072e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800732:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800736:	48 89 d6             	mov    %rdx,%rsi
  800739:	89 df                	mov    %ebx,%edi
  80073b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800741:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800745:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800749:	0f b6 00             	movzbl (%rax),%eax
  80074c:	0f b6 d8             	movzbl %al,%ebx
  80074f:	83 fb 25             	cmp    $0x25,%ebx
  800752:	75 d2                	jne    800726 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800754:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800758:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80075f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800766:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80076d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800774:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800778:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80077c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800780:	0f b6 00             	movzbl (%rax),%eax
  800783:	0f b6 d8             	movzbl %al,%ebx
  800786:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800789:	83 f8 55             	cmp    $0x55,%eax
  80078c:	0f 87 34 04 00 00    	ja     800bc6 <vprintfmt+0x4db>
  800792:	89 c0                	mov    %eax,%eax
  800794:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80079b:	00 
  80079c:	48 b8 d0 3e 80 00 00 	movabs $0x803ed0,%rax
  8007a3:	00 00 00 
  8007a6:	48 01 d0             	add    %rdx,%rax
  8007a9:	48 8b 00             	mov    (%rax),%rax
  8007ac:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ae:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007b2:	eb c0                	jmp    800774 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007b8:	eb ba                	jmp    800774 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007c1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	c1 e0 02             	shl    $0x2,%eax
  8007c9:	01 d0                	add    %edx,%eax
  8007cb:	01 c0                	add    %eax,%eax
  8007cd:	01 d8                	add    %ebx,%eax
  8007cf:	83 e8 30             	sub    $0x30,%eax
  8007d2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d9:	0f b6 00             	movzbl (%rax),%eax
  8007dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007df:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e2:	7e 0c                	jle    8007f0 <vprintfmt+0x105>
  8007e4:	83 fb 39             	cmp    $0x39,%ebx
  8007e7:	7f 07                	jg     8007f0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ee:	eb d1                	jmp    8007c1 <vprintfmt+0xd6>
			goto process_precision;
  8007f0:	eb 58                	jmp    80084a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f5:	83 f8 30             	cmp    $0x30,%eax
  8007f8:	73 17                	jae    800811 <vprintfmt+0x126>
  8007fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800809:	83 c2 08             	add    $0x8,%edx
  80080c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080f:	eb 0f                	jmp    800820 <vprintfmt+0x135>
  800811:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 83 c2 08          	add    $0x8,%rdx
  80081c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800820:	8b 00                	mov    (%rax),%eax
  800822:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800825:	eb 23                	jmp    80084a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800827:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80082b:	79 0c                	jns    800839 <vprintfmt+0x14e>
				width = 0;
  80082d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800834:	e9 3b ff ff ff       	jmpq   800774 <vprintfmt+0x89>
  800839:	e9 36 ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80083e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800845:	e9 2a ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80084a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80084e:	79 12                	jns    800862 <vprintfmt+0x177>
				width = precision, precision = -1;
  800850:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800853:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800856:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80085d:	e9 12 ff ff ff       	jmpq   800774 <vprintfmt+0x89>
  800862:	e9 0d ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800867:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80086b:	e9 04 ff ff ff       	jmpq   800774 <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800870:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800873:	83 f8 30             	cmp    $0x30,%eax
  800876:	73 17                	jae    80088f <vprintfmt+0x1a4>
  800878:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80087c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800887:	83 c2 08             	add    $0x8,%edx
  80088a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088d:	eb 0f                	jmp    80089e <vprintfmt+0x1b3>
  80088f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800893:	48 89 d0             	mov    %rdx,%rax
  800896:	48 83 c2 08          	add    $0x8,%rdx
  80089a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089e:	8b 10                	mov    (%rax),%edx
  8008a0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a8:	48 89 ce             	mov    %rcx,%rsi
  8008ab:	89 d7                	mov    %edx,%edi
  8008ad:	ff d0                	callq  *%rax
			break;
  8008af:	e9 40 03 00 00       	jmpq   800bf4 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	83 f8 30             	cmp    $0x30,%eax
  8008ba:	73 17                	jae    8008d3 <vprintfmt+0x1e8>
  8008bc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c3:	89 c0                	mov    %eax,%eax
  8008c5:	48 01 d0             	add    %rdx,%rax
  8008c8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008cb:	83 c2 08             	add    $0x8,%edx
  8008ce:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d1:	eb 0f                	jmp    8008e2 <vprintfmt+0x1f7>
  8008d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d7:	48 89 d0             	mov    %rdx,%rax
  8008da:	48 83 c2 08          	add    $0x8,%rdx
  8008de:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008e4:	85 db                	test   %ebx,%ebx
  8008e6:	79 02                	jns    8008ea <vprintfmt+0x1ff>
				err = -err;
  8008e8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ea:	83 fb 10             	cmp    $0x10,%ebx
  8008ed:	7f 16                	jg     800905 <vprintfmt+0x21a>
  8008ef:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  8008f6:	00 00 00 
  8008f9:	48 63 d3             	movslq %ebx,%rdx
  8008fc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800900:	4d 85 e4             	test   %r12,%r12
  800903:	75 2e                	jne    800933 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800905:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800909:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090d:	89 d9                	mov    %ebx,%ecx
  80090f:	48 ba b9 3e 80 00 00 	movabs $0x803eb9,%rdx
  800916:	00 00 00 
  800919:	48 89 c7             	mov    %rax,%rdi
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	49 b8 03 0c 80 00 00 	movabs $0x800c03,%r8
  800928:	00 00 00 
  80092b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092e:	e9 c1 02 00 00       	jmpq   800bf4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800933:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800937:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093b:	4c 89 e1             	mov    %r12,%rcx
  80093e:	48 ba c2 3e 80 00 00 	movabs $0x803ec2,%rdx
  800945:	00 00 00 
  800948:	48 89 c7             	mov    %rax,%rdi
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	49 b8 03 0c 80 00 00 	movabs $0x800c03,%r8
  800957:	00 00 00 
  80095a:	41 ff d0             	callq  *%r8
			break;
  80095d:	e9 92 02 00 00       	jmpq   800bf4 <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800962:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800965:	83 f8 30             	cmp    $0x30,%eax
  800968:	73 17                	jae    800981 <vprintfmt+0x296>
  80096a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80096e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800971:	89 c0                	mov    %eax,%eax
  800973:	48 01 d0             	add    %rdx,%rax
  800976:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800979:	83 c2 08             	add    $0x8,%edx
  80097c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80097f:	eb 0f                	jmp    800990 <vprintfmt+0x2a5>
  800981:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800985:	48 89 d0             	mov    %rdx,%rax
  800988:	48 83 c2 08          	add    $0x8,%rdx
  80098c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800990:	4c 8b 20             	mov    (%rax),%r12
  800993:	4d 85 e4             	test   %r12,%r12
  800996:	75 0a                	jne    8009a2 <vprintfmt+0x2b7>
				p = "(null)";
  800998:	49 bc c5 3e 80 00 00 	movabs $0x803ec5,%r12
  80099f:	00 00 00 
			if (width > 0 && padc != '-')
  8009a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a6:	7e 3f                	jle    8009e7 <vprintfmt+0x2fc>
  8009a8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009ac:	74 39                	je     8009e7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b1:	48 98                	cltq   
  8009b3:	48 89 c6             	mov    %rax,%rsi
  8009b6:	4c 89 e7             	mov    %r12,%rdi
  8009b9:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  8009c0:	00 00 00 
  8009c3:	ff d0                	callq  *%rax
  8009c5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009c8:	eb 17                	jmp    8009e1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ca:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009ce:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d6:	48 89 ce             	mov    %rcx,%rsi
  8009d9:	89 d7                	mov    %edx,%edi
  8009db:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e5:	7f e3                	jg     8009ca <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e7:	eb 37                	jmp    800a20 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ed:	74 1e                	je     800a0d <vprintfmt+0x322>
  8009ef:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f2:	7e 05                	jle    8009f9 <vprintfmt+0x30e>
  8009f4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009f7:	7e 14                	jle    800a0d <vprintfmt+0x322>
					putch('?', putdat);
  8009f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a01:	48 89 d6             	mov    %rdx,%rsi
  800a04:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a09:	ff d0                	callq  *%rax
  800a0b:	eb 0f                	jmp    800a1c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a15:	48 89 d6             	mov    %rdx,%rsi
  800a18:	89 df                	mov    %ebx,%edi
  800a1a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a20:	4c 89 e0             	mov    %r12,%rax
  800a23:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a27:	0f b6 00             	movzbl (%rax),%eax
  800a2a:	0f be d8             	movsbl %al,%ebx
  800a2d:	85 db                	test   %ebx,%ebx
  800a2f:	74 10                	je     800a41 <vprintfmt+0x356>
  800a31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a35:	78 b2                	js     8009e9 <vprintfmt+0x2fe>
  800a37:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3f:	79 a8                	jns    8009e9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a41:	eb 16                	jmp    800a59 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4b:	48 89 d6             	mov    %rdx,%rsi
  800a4e:	bf 20 00 00 00       	mov    $0x20,%edi
  800a53:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5d:	7f e4                	jg     800a43 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a5f:	e9 90 01 00 00       	jmpq   800bf4 <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a68:	be 03 00 00 00       	mov    $0x3,%esi
  800a6d:	48 89 c7             	mov    %rax,%rdi
  800a70:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800a77:	00 00 00 
  800a7a:	ff d0                	callq  *%rax
  800a7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 85 c0             	test   %rax,%rax
  800a87:	79 1d                	jns    800aa6 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a91:	48 89 d6             	mov    %rdx,%rsi
  800a94:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a99:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9f:	48 f7 d8             	neg    %rax
  800aa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aa6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800aad:	e9 d5 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ab2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab6:	be 03 00 00 00       	mov    $0x3,%esi
  800abb:	48 89 c7             	mov    %rax,%rdi
  800abe:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800ac5:	00 00 00 
  800ac8:	ff d0                	callq  *%rax
  800aca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ace:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ad5:	e9 ad 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ada:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800add:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae1:	89 d6                	mov    %edx,%esi
  800ae3:	48 89 c7             	mov    %rax,%rdi
  800ae6:	48 b8 db 05 80 00 00 	movabs $0x8005db,%rax
  800aed:	00 00 00 
  800af0:	ff d0                	callq  *%rax
  800af2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800af6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800afd:	e9 85 00 00 00       	jmpq   800b87 <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800b02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0a:	48 89 d6             	mov    %rdx,%rsi
  800b0d:	bf 30 00 00 00       	mov    $0x30,%edi
  800b12:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1c:	48 89 d6             	mov    %rdx,%rsi
  800b1f:	bf 78 00 00 00       	mov    $0x78,%edi
  800b24:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b29:	83 f8 30             	cmp    $0x30,%eax
  800b2c:	73 17                	jae    800b45 <vprintfmt+0x45a>
  800b2e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b35:	89 c0                	mov    %eax,%eax
  800b37:	48 01 d0             	add    %rdx,%rax
  800b3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b3d:	83 c2 08             	add    $0x8,%edx
  800b40:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b43:	eb 0f                	jmp    800b54 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b49:	48 89 d0             	mov    %rdx,%rax
  800b4c:	48 83 c2 08          	add    $0x8,%rdx
  800b50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b54:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b62:	eb 23                	jmp    800b87 <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b68:	be 03 00 00 00       	mov    $0x3,%esi
  800b6d:	48 89 c7             	mov    %rax,%rdi
  800b70:	48 b8 cb 04 80 00 00 	movabs $0x8004cb,%rax
  800b77:	00 00 00 
  800b7a:	ff d0                	callq  *%rax
  800b7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b87:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b8c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b8f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b96:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	45 89 c1             	mov    %r8d,%r9d
  800ba1:	41 89 f8             	mov    %edi,%r8d
  800ba4:	48 89 c7             	mov    %rax,%rdi
  800ba7:	48 b8 10 04 80 00 00 	movabs $0x800410,%rax
  800bae:	00 00 00 
  800bb1:	ff d0                	callq  *%rax
			break;
  800bb3:	eb 3f                	jmp    800bf4 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbd:	48 89 d6             	mov    %rdx,%rsi
  800bc0:	89 df                	mov    %ebx,%edi
  800bc2:	ff d0                	callq  *%rax
			break;
  800bc4:	eb 2e                	jmp    800bf4 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bce:	48 89 d6             	mov    %rdx,%rsi
  800bd1:	bf 25 00 00 00       	mov    $0x25,%edi
  800bd6:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bdd:	eb 05                	jmp    800be4 <vprintfmt+0x4f9>
  800bdf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be8:	48 83 e8 01          	sub    $0x1,%rax
  800bec:	0f b6 00             	movzbl (%rax),%eax
  800bef:	3c 25                	cmp    $0x25,%al
  800bf1:	75 ec                	jne    800bdf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bf3:	90                   	nop
		}
	}
  800bf4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf5:	e9 43 fb ff ff       	jmpq   80073d <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bfa:	48 83 c4 60          	add    $0x60,%rsp
  800bfe:	5b                   	pop    %rbx
  800bff:	41 5c                	pop    %r12
  800c01:	5d                   	pop    %rbp
  800c02:	c3                   	retq   

0000000000800c03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c03:	55                   	push   %rbp
  800c04:	48 89 e5             	mov    %rsp,%rbp
  800c07:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c0e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c15:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c31:	84 c0                	test   %al,%al
  800c33:	74 20                	je     800c55 <printfmt+0x52>
  800c35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c55:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c5c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c63:	00 00 00 
  800c66:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c6d:	00 00 00 
  800c70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c74:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c82:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c89:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c90:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c97:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c9e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ca5:	48 89 c7             	mov    %rax,%rdi
  800ca8:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800caf:	00 00 00 
  800cb2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cb4:	c9                   	leaveq 
  800cb5:	c3                   	retq   

0000000000800cb6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cb6:	55                   	push   %rbp
  800cb7:	48 89 e5             	mov    %rsp,%rbp
  800cba:	48 83 ec 10          	sub    $0x10,%rsp
  800cbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	8b 40 10             	mov    0x10(%rax),%eax
  800ccc:	8d 50 01             	lea    0x1(%rax),%edx
  800ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cda:	48 8b 10             	mov    (%rax),%rdx
  800cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ce5:	48 39 c2             	cmp    %rax,%rdx
  800ce8:	73 17                	jae    800d01 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cee:	48 8b 00             	mov    (%rax),%rax
  800cf1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cf9:	48 89 0a             	mov    %rcx,(%rdx)
  800cfc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cff:	88 10                	mov    %dl,(%rax)
}
  800d01:	c9                   	leaveq 
  800d02:	c3                   	retq   

0000000000800d03 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d03:	55                   	push   %rbp
  800d04:	48 89 e5             	mov    %rsp,%rbp
  800d07:	48 83 ec 50          	sub    $0x50,%rsp
  800d0b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d0f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d12:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d16:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d1a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d1e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d22:	48 8b 0a             	mov    (%rdx),%rcx
  800d25:	48 89 08             	mov    %rcx,(%rax)
  800d28:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d2c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d30:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d34:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d3c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d40:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d43:	48 98                	cltq   
  800d45:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d4d:	48 01 d0             	add    %rdx,%rax
  800d50:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d54:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d5b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d60:	74 06                	je     800d68 <vsnprintf+0x65>
  800d62:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d66:	7f 07                	jg     800d6f <vsnprintf+0x6c>
		return -E_INVAL;
  800d68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d6d:	eb 2f                	jmp    800d9e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d6f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d73:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d77:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d7b:	48 89 c6             	mov    %rax,%rsi
  800d7e:	48 bf b6 0c 80 00 00 	movabs $0x800cb6,%rdi
  800d85:	00 00 00 
  800d88:	48 b8 eb 06 80 00 00 	movabs $0x8006eb,%rax
  800d8f:	00 00 00 
  800d92:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d98:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d9b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d9e:	c9                   	leaveq 
  800d9f:	c3                   	retq   

0000000000800da0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da0:	55                   	push   %rbp
  800da1:	48 89 e5             	mov    %rsp,%rbp
  800da4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800db2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800db8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dcd:	84 c0                	test   %al,%al
  800dcf:	74 20                	je     800df1 <snprintf+0x51>
  800dd1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ddd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800de1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ded:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800df1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800df8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dff:	00 00 00 
  800e02:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e09:	00 00 00 
  800e0c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e10:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e17:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e25:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e2c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e33:	48 8b 0a             	mov    (%rdx),%rcx
  800e36:	48 89 08             	mov    %rcx,(%rax)
  800e39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e49:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e50:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e57:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e5d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e64:	48 89 c7             	mov    %rax,%rdi
  800e67:	48 b8 03 0d 80 00 00 	movabs $0x800d03,%rax
  800e6e:	00 00 00 
  800e71:	ff d0                	callq  *%rax
  800e73:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e79:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e7f:	c9                   	leaveq 
  800e80:	c3                   	retq   

0000000000800e81 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e81:	55                   	push   %rbp
  800e82:	48 89 e5             	mov    %rsp,%rbp
  800e85:	48 83 ec 18          	sub    $0x18,%rsp
  800e89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e94:	eb 09                	jmp    800e9f <strlen+0x1e>
		n++;
  800e96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea3:	0f b6 00             	movzbl (%rax),%eax
  800ea6:	84 c0                	test   %al,%al
  800ea8:	75 ec                	jne    800e96 <strlen+0x15>
		n++;
	return n;
  800eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ead:	c9                   	leaveq 
  800eae:	c3                   	retq   

0000000000800eaf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
  800eb3:	48 83 ec 20          	sub    $0x20,%rsp
  800eb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ec6:	eb 0e                	jmp    800ed6 <strnlen+0x27>
		n++;
  800ec8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ecc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ed1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ed6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800edb:	74 0b                	je     800ee8 <strnlen+0x39>
  800edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee1:	0f b6 00             	movzbl (%rax),%eax
  800ee4:	84 c0                	test   %al,%al
  800ee6:	75 e0                	jne    800ec8 <strnlen+0x19>
		n++;
	return n;
  800ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 83 ec 20          	sub    $0x20,%rsp
  800ef5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f05:	90                   	nop
  800f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f12:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f16:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f1a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f1e:	0f b6 12             	movzbl (%rdx),%edx
  800f21:	88 10                	mov    %dl,(%rax)
  800f23:	0f b6 00             	movzbl (%rax),%eax
  800f26:	84 c0                	test   %al,%al
  800f28:	75 dc                	jne    800f06 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f2e:	c9                   	leaveq 
  800f2f:	c3                   	retq   

0000000000800f30 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f30:	55                   	push   %rbp
  800f31:	48 89 e5             	mov    %rsp,%rbp
  800f34:	48 83 ec 20          	sub    $0x20,%rsp
  800f38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	48 89 c7             	mov    %rax,%rdi
  800f47:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  800f4e:	00 00 00 
  800f51:	ff d0                	callq  *%rax
  800f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f59:	48 63 d0             	movslq %eax,%rdx
  800f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f60:	48 01 c2             	add    %rax,%rdx
  800f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f67:	48 89 c6             	mov    %rax,%rsi
  800f6a:	48 89 d7             	mov    %rdx,%rdi
  800f6d:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  800f74:	00 00 00 
  800f77:	ff d0                	callq  *%rax
	return dst;
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f7d:	c9                   	leaveq 
  800f7e:	c3                   	retq   

0000000000800f7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f7f:	55                   	push   %rbp
  800f80:	48 89 e5             	mov    %rsp,%rbp
  800f83:	48 83 ec 28          	sub    $0x28,%rsp
  800f87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fa2:	00 
  800fa3:	eb 2a                	jmp    800fcf <strncpy+0x50>
		*dst++ = *src;
  800fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb5:	0f b6 12             	movzbl (%rdx),%edx
  800fb8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	84 c0                	test   %al,%al
  800fc3:	74 05                	je     800fca <strncpy+0x4b>
			src++;
  800fc5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fd7:	72 cc                	jb     800fa5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 28          	sub    $0x28,%rsp
  800fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800feb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800ffb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801000:	74 3d                	je     80103f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801002:	eb 1d                	jmp    801021 <strlcpy+0x42>
			*dst++ = *src++;
  801004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801008:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80100c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801010:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801014:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801018:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80101c:	0f b6 12             	movzbl (%rdx),%edx
  80101f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801021:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801026:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80102b:	74 0b                	je     801038 <strlcpy+0x59>
  80102d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801031:	0f b6 00             	movzbl (%rax),%eax
  801034:	84 c0                	test   %al,%al
  801036:	75 cc                	jne    801004 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80103f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801047:	48 29 c2             	sub    %rax,%rdx
  80104a:	48 89 d0             	mov    %rdx,%rax
}
  80104d:	c9                   	leaveq 
  80104e:	c3                   	retq   

000000000080104f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80104f:	55                   	push   %rbp
  801050:	48 89 e5             	mov    %rsp,%rbp
  801053:	48 83 ec 10          	sub    $0x10,%rsp
  801057:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80105f:	eb 0a                	jmp    80106b <strcmp+0x1c>
		p++, q++;
  801061:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801066:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80106b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106f:	0f b6 00             	movzbl (%rax),%eax
  801072:	84 c0                	test   %al,%al
  801074:	74 12                	je     801088 <strcmp+0x39>
  801076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107a:	0f b6 10             	movzbl (%rax),%edx
  80107d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801081:	0f b6 00             	movzbl (%rax),%eax
  801084:	38 c2                	cmp    %al,%dl
  801086:	74 d9                	je     801061 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	0f b6 d0             	movzbl %al,%edx
  801092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	0f b6 c0             	movzbl %al,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
}
  8010a0:	c9                   	leaveq 
  8010a1:	c3                   	retq   

00000000008010a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 83 ec 18          	sub    $0x18,%rsp
  8010aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010b6:	eb 0f                	jmp    8010c7 <strncmp+0x25>
		n--, p++, q++;
  8010b8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010cc:	74 1d                	je     8010eb <strncmp+0x49>
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	84 c0                	test   %al,%al
  8010d7:	74 12                	je     8010eb <strncmp+0x49>
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	0f b6 10             	movzbl (%rax),%edx
  8010e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	38 c2                	cmp    %al,%dl
  8010e9:	74 cd                	je     8010b8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f0:	75 07                	jne    8010f9 <strncmp+0x57>
		return 0;
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	eb 18                	jmp    801111 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	0f b6 d0             	movzbl %al,%edx
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	0f b6 c0             	movzbl %al,%eax
  80110d:	29 c2                	sub    %eax,%edx
  80110f:	89 d0                	mov    %edx,%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 0c          	sub    $0xc,%rsp
  80111b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111f:	89 f0                	mov    %esi,%eax
  801121:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801124:	eb 17                	jmp    80113d <strchr+0x2a>
		if (*s == c)
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801130:	75 06                	jne    801138 <strchr+0x25>
			return (char *) s;
  801132:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801136:	eb 15                	jmp    80114d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801138:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801141:	0f b6 00             	movzbl (%rax),%eax
  801144:	84 c0                	test   %al,%al
  801146:	75 de                	jne    801126 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114d:	c9                   	leaveq 
  80114e:	c3                   	retq   

000000000080114f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80114f:	55                   	push   %rbp
  801150:	48 89 e5             	mov    %rsp,%rbp
  801153:	48 83 ec 0c          	sub    $0xc,%rsp
  801157:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80115b:	89 f0                	mov    %esi,%eax
  80115d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801160:	eb 13                	jmp    801175 <strfind+0x26>
		if (*s == c)
  801162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801166:	0f b6 00             	movzbl (%rax),%eax
  801169:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80116c:	75 02                	jne    801170 <strfind+0x21>
			break;
  80116e:	eb 10                	jmp    801180 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801170:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	0f b6 00             	movzbl (%rax),%eax
  80117c:	84 c0                	test   %al,%al
  80117e:	75 e2                	jne    801162 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 18          	sub    $0x18,%rsp
  80118e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801192:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801195:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801199:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80119e:	75 06                	jne    8011a6 <memset+0x20>
		return v;
  8011a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a4:	eb 69                	jmp    80120f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011aa:	83 e0 03             	and    $0x3,%eax
  8011ad:	48 85 c0             	test   %rax,%rax
  8011b0:	75 48                	jne    8011fa <memset+0x74>
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	83 e0 03             	and    $0x3,%eax
  8011b9:	48 85 c0             	test   %rax,%rax
  8011bc:	75 3c                	jne    8011fa <memset+0x74>
		c &= 0xFF;
  8011be:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c8:	c1 e0 18             	shl    $0x18,%eax
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d0:	c1 e0 10             	shl    $0x10,%eax
  8011d3:	09 c2                	or     %eax,%edx
  8011d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d8:	c1 e0 08             	shl    $0x8,%eax
  8011db:	09 d0                	or     %edx,%eax
  8011dd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 c1 e8 02          	shr    $0x2,%rax
  8011e8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f2:	48 89 d7             	mov    %rdx,%rdi
  8011f5:	fc                   	cld    
  8011f6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011f8:	eb 11                	jmp    80120b <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801201:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801205:	48 89 d7             	mov    %rdx,%rdi
  801208:	fc                   	cld    
  801209:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 28          	sub    $0x28,%rsp
  801219:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801221:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801229:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80122d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801231:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80123d:	0f 83 88 00 00 00    	jae    8012cb <memmove+0xba>
  801243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801247:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124b:	48 01 d0             	add    %rdx,%rax
  80124e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801252:	76 77                	jbe    8012cb <memmove+0xba>
		s += n;
  801254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801258:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80125c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801260:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	83 e0 03             	and    $0x3,%eax
  80126b:	48 85 c0             	test   %rax,%rax
  80126e:	75 3b                	jne    8012ab <memmove+0x9a>
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	83 e0 03             	and    $0x3,%eax
  801277:	48 85 c0             	test   %rax,%rax
  80127a:	75 2f                	jne    8012ab <memmove+0x9a>
  80127c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801280:	83 e0 03             	and    $0x3,%eax
  801283:	48 85 c0             	test   %rax,%rax
  801286:	75 23                	jne    8012ab <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128c:	48 83 e8 04          	sub    $0x4,%rax
  801290:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801294:	48 83 ea 04          	sub    $0x4,%rdx
  801298:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80129c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 89 d6             	mov    %rdx,%rsi
  8012a6:	fd                   	std    
  8012a7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a9:	eb 1d                	jmp    8012c8 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012af:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bf:	48 89 d7             	mov    %rdx,%rdi
  8012c2:	48 89 c1             	mov    %rax,%rcx
  8012c5:	fd                   	std    
  8012c6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012c8:	fc                   	cld    
  8012c9:	eb 57                	jmp    801322 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	83 e0 03             	and    $0x3,%eax
  8012d2:	48 85 c0             	test   %rax,%rax
  8012d5:	75 36                	jne    80130d <memmove+0xfc>
  8012d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012db:	83 e0 03             	and    $0x3,%eax
  8012de:	48 85 c0             	test   %rax,%rax
  8012e1:	75 2a                	jne    80130d <memmove+0xfc>
  8012e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e7:	83 e0 03             	and    $0x3,%eax
  8012ea:	48 85 c0             	test   %rax,%rax
  8012ed:	75 1e                	jne    80130d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f3:	48 c1 e8 02          	shr    $0x2,%rax
  8012f7:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 89 d6             	mov    %rdx,%rsi
  801308:	fc                   	cld    
  801309:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80130b:	eb 15                	jmp    801322 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80130d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801311:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801315:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801319:	48 89 c7             	mov    %rax,%rdi
  80131c:	48 89 d6             	mov    %rdx,%rsi
  80131f:	fc                   	cld    
  801320:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801326:	c9                   	leaveq 
  801327:	c3                   	retq   

0000000000801328 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801328:	55                   	push   %rbp
  801329:	48 89 e5             	mov    %rsp,%rbp
  80132c:	48 83 ec 18          	sub    $0x18,%rsp
  801330:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801334:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80133c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801340:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801348:	48 89 ce             	mov    %rcx,%rsi
  80134b:	48 89 c7             	mov    %rax,%rdi
  80134e:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  801355:	00 00 00 
  801358:	ff d0                	callq  *%rax
}
  80135a:	c9                   	leaveq 
  80135b:	c3                   	retq   

000000000080135c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 28          	sub    $0x28,%rsp
  801364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80136c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801374:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801378:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801380:	eb 36                	jmp    8013b8 <memcmp+0x5c>
		if (*s1 != *s2)
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 10             	movzbl (%rax),%edx
  801389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	38 c2                	cmp    %al,%dl
  801392:	74 1a                	je     8013ae <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	0f b6 d0             	movzbl %al,%edx
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	0f b6 00             	movzbl (%rax),%eax
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	29 c2                	sub    %eax,%edx
  8013aa:	89 d0                	mov    %edx,%eax
  8013ac:	eb 20                	jmp    8013ce <memcmp+0x72>
		s1++, s2++;
  8013ae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013c4:	48 85 c0             	test   %rax,%rax
  8013c7:	75 b9                	jne    801382 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ce:	c9                   	leaveq 
  8013cf:	c3                   	retq   

00000000008013d0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013d0:	55                   	push   %rbp
  8013d1:	48 89 e5             	mov    %rsp,%rbp
  8013d4:	48 83 ec 28          	sub    $0x28,%rsp
  8013d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013eb:	48 01 d0             	add    %rdx,%rax
  8013ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013f2:	eb 15                	jmp    801409 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	0f b6 10             	movzbl (%rax),%edx
  8013fb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013fe:	38 c2                	cmp    %al,%dl
  801400:	75 02                	jne    801404 <memfind+0x34>
			break;
  801402:	eb 0f                	jmp    801413 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801404:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801411:	72 e1                	jb     8013f4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801417:	c9                   	leaveq 
  801418:	c3                   	retq   

0000000000801419 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801419:	55                   	push   %rbp
  80141a:	48 89 e5             	mov    %rsp,%rbp
  80141d:	48 83 ec 34          	sub    $0x34,%rsp
  801421:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801425:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801429:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80142c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801433:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80143a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80143b:	eb 05                	jmp    801442 <strtol+0x29>
		s++;
  80143d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	3c 20                	cmp    $0x20,%al
  80144b:	74 f0                	je     80143d <strtol+0x24>
  80144d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	3c 09                	cmp    $0x9,%al
  801456:	74 e5                	je     80143d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	0f b6 00             	movzbl (%rax),%eax
  80145f:	3c 2b                	cmp    $0x2b,%al
  801461:	75 07                	jne    80146a <strtol+0x51>
		s++;
  801463:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801468:	eb 17                	jmp    801481 <strtol+0x68>
	else if (*s == '-')
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	0f b6 00             	movzbl (%rax),%eax
  801471:	3c 2d                	cmp    $0x2d,%al
  801473:	75 0c                	jne    801481 <strtol+0x68>
		s++, neg = 1;
  801475:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801481:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801485:	74 06                	je     80148d <strtol+0x74>
  801487:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80148b:	75 28                	jne    8014b5 <strtol+0x9c>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	0f b6 00             	movzbl (%rax),%eax
  801494:	3c 30                	cmp    $0x30,%al
  801496:	75 1d                	jne    8014b5 <strtol+0x9c>
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	48 83 c0 01          	add    $0x1,%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3c 78                	cmp    $0x78,%al
  8014a5:	75 0e                	jne    8014b5 <strtol+0x9c>
		s += 2, base = 16;
  8014a7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014ac:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014b3:	eb 2c                	jmp    8014e1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b9:	75 19                	jne    8014d4 <strtol+0xbb>
  8014bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bf:	0f b6 00             	movzbl (%rax),%eax
  8014c2:	3c 30                	cmp    $0x30,%al
  8014c4:	75 0e                	jne    8014d4 <strtol+0xbb>
		s++, base = 8;
  8014c6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014cb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014d2:	eb 0d                	jmp    8014e1 <strtol+0xc8>
	else if (base == 0)
  8014d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d8:	75 07                	jne    8014e1 <strtol+0xc8>
		base = 10;
  8014da:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	3c 2f                	cmp    $0x2f,%al
  8014ea:	7e 1d                	jle    801509 <strtol+0xf0>
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 39                	cmp    $0x39,%al
  8014f5:	7f 12                	jg     801509 <strtol+0xf0>
			dig = *s - '0';
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	0f be c0             	movsbl %al,%eax
  801501:	83 e8 30             	sub    $0x30,%eax
  801504:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801507:	eb 4e                	jmp    801557 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 60                	cmp    $0x60,%al
  801512:	7e 1d                	jle    801531 <strtol+0x118>
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 7a                	cmp    $0x7a,%al
  80151d:	7f 12                	jg     801531 <strtol+0x118>
			dig = *s - 'a' + 10;
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	0f be c0             	movsbl %al,%eax
  801529:	83 e8 57             	sub    $0x57,%eax
  80152c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80152f:	eb 26                	jmp    801557 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3c 40                	cmp    $0x40,%al
  80153a:	7e 48                	jle    801584 <strtol+0x16b>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	3c 5a                	cmp    $0x5a,%al
  801545:	7f 3d                	jg     801584 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	0f be c0             	movsbl %al,%eax
  801551:	83 e8 37             	sub    $0x37,%eax
  801554:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801557:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80155d:	7c 02                	jl     801561 <strtol+0x148>
			break;
  80155f:	eb 23                	jmp    801584 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801561:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801566:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801569:	48 98                	cltq   
  80156b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801570:	48 89 c2             	mov    %rax,%rdx
  801573:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801576:	48 98                	cltq   
  801578:	48 01 d0             	add    %rdx,%rax
  80157b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80157f:	e9 5d ff ff ff       	jmpq   8014e1 <strtol+0xc8>

	if (endptr)
  801584:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801589:	74 0b                	je     801596 <strtol+0x17d>
		*endptr = (char *) s;
  80158b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80158f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801593:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801596:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80159a:	74 09                	je     8015a5 <strtol+0x18c>
  80159c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a0:	48 f7 d8             	neg    %rax
  8015a3:	eb 04                	jmp    8015a9 <strtol+0x190>
  8015a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <strstr>:

char * strstr(const char *in, const char *str)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 30          	sub    $0x30,%rsp
  8015b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8015bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8015cd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015d1:	75 06                	jne    8015d9 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	eb 6b                	jmp    801644 <strstr+0x99>

    len = strlen(str);
  8015d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015dd:	48 89 c7             	mov    %rax,%rdi
  8015e0:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	callq  *%rax
  8015ec:	48 98                	cltq   
  8015ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015fe:	0f b6 00             	movzbl (%rax),%eax
  801601:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801604:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801608:	75 07                	jne    801611 <strstr+0x66>
                return (char *) 0;
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
  80160f:	eb 33                	jmp    801644 <strstr+0x99>
        } while (sc != c);
  801611:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801615:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801618:	75 d8                	jne    8015f2 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80161a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	48 89 ce             	mov    %rcx,%rsi
  801629:	48 89 c7             	mov    %rax,%rdi
  80162c:	48 b8 a2 10 80 00 00 	movabs $0x8010a2,%rax
  801633:	00 00 00 
  801636:	ff d0                	callq  *%rax
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 b6                	jne    8015f2 <strstr+0x47>

    return (char *) (in - 1);
  80163c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801640:	48 83 e8 01          	sub    $0x1,%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	53                   	push   %rbx
  80164b:	48 83 ec 48          	sub    $0x48,%rsp
  80164f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801652:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801655:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801659:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80165d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801661:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801665:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801668:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80166c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801670:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801674:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801678:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80167c:	4c 89 c3             	mov    %r8,%rbx
  80167f:	cd 30                	int    $0x30
  801681:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801685:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801689:	74 3e                	je     8016c9 <syscall+0x83>
  80168b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801690:	7e 37                	jle    8016c9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801696:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801699:	49 89 d0             	mov    %rdx,%r8
  80169c:	89 c1                	mov    %eax,%ecx
  80169e:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  8016a5:	00 00 00 
  8016a8:	be 23 00 00 00       	mov    $0x23,%esi
  8016ad:	48 bf 9d 41 80 00 00 	movabs $0x80419d,%rdi
  8016b4:	00 00 00 
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	49 b9 c8 37 80 00 00 	movabs $0x8037c8,%r9
  8016c3:	00 00 00 
  8016c6:	41 ff d1             	callq  *%r9

	return ret;
  8016c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016cd:	48 83 c4 48          	add    $0x48,%rsp
  8016d1:	5b                   	pop    %rbx
  8016d2:	5d                   	pop    %rbp
  8016d3:	c3                   	retq   

00000000008016d4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016d4:	55                   	push   %rbp
  8016d5:	48 89 e5             	mov    %rsp,%rbp
  8016d8:	48 83 ec 20          	sub    $0x20,%rsp
  8016dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ec:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f3:	00 
  8016f4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801700:	48 89 d1             	mov    %rdx,%rcx
  801703:	48 89 c2             	mov    %rax,%rdx
  801706:	be 00 00 00 00       	mov    $0x0,%esi
  80170b:	bf 00 00 00 00       	mov    $0x0,%edi
  801710:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801717:	00 00 00 
  80171a:	ff d0                	callq  *%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <sys_cgetc>:

int
sys_cgetc(void)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801726:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172d:	00 
  80172e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173f:	ba 00 00 00 00       	mov    $0x0,%edx
  801744:	be 00 00 00 00       	mov    $0x0,%esi
  801749:	bf 01 00 00 00       	mov    $0x1,%edi
  80174e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 10          	sub    $0x10,%rsp
  801764:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176a:	48 98                	cltq   
  80176c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801773:	00 
  801774:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801780:	b9 00 00 00 00       	mov    $0x0,%ecx
  801785:	48 89 c2             	mov    %rax,%rdx
  801788:	be 01 00 00 00       	mov    $0x1,%esi
  80178d:	bf 03 00 00 00       	mov    $0x3,%edi
  801792:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801799:	00 00 00 
  80179c:	ff d0                	callq  *%rax
}
  80179e:	c9                   	leaveq 
  80179f:	c3                   	retq   

00000000008017a0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017a0:	55                   	push   %rbp
  8017a1:	48 89 e5             	mov    %rsp,%rbp
  8017a4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017af:	00 
  8017b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	be 00 00 00 00       	mov    $0x0,%esi
  8017cb:	bf 02 00 00 00       	mov    $0x2,%edi
  8017d0:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8017d7:	00 00 00 
  8017da:	ff d0                	callq  *%rax
}
  8017dc:	c9                   	leaveq 
  8017dd:	c3                   	retq   

00000000008017de <sys_yield>:

void
sys_yield(void)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017e6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ed:	00 
  8017ee:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	be 00 00 00 00       	mov    $0x0,%esi
  801809:	bf 0b 00 00 00       	mov    $0xb,%edi
  80180e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801815:	00 00 00 
  801818:	ff d0                	callq  *%rax
}
  80181a:	c9                   	leaveq 
  80181b:	c3                   	retq   

000000000080181c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	48 83 ec 20          	sub    $0x20,%rsp
  801824:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80182b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80182e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801831:	48 63 c8             	movslq %eax,%rcx
  801834:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80183b:	48 98                	cltq   
  80183d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801844:	00 
  801845:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80184b:	49 89 c8             	mov    %rcx,%r8
  80184e:	48 89 d1             	mov    %rdx,%rcx
  801851:	48 89 c2             	mov    %rax,%rdx
  801854:	be 01 00 00 00       	mov    $0x1,%esi
  801859:	bf 04 00 00 00       	mov    $0x4,%edi
  80185e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801865:	00 00 00 
  801868:	ff d0                	callq  *%rax
}
  80186a:	c9                   	leaveq 
  80186b:	c3                   	retq   

000000000080186c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80186c:	55                   	push   %rbp
  80186d:	48 89 e5             	mov    %rsp,%rbp
  801870:	48 83 ec 30          	sub    $0x30,%rsp
  801874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801877:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80187b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80187e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801882:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801886:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801889:	48 63 c8             	movslq %eax,%rcx
  80188c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801890:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801893:	48 63 f0             	movslq %eax,%rsi
  801896:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189d:	48 98                	cltq   
  80189f:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018a3:	49 89 f9             	mov    %rdi,%r9
  8018a6:	49 89 f0             	mov    %rsi,%r8
  8018a9:	48 89 d1             	mov    %rdx,%rcx
  8018ac:	48 89 c2             	mov    %rax,%rdx
  8018af:	be 01 00 00 00       	mov    $0x1,%esi
  8018b4:	bf 05 00 00 00       	mov    $0x5,%edi
  8018b9:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
}
  8018c5:	c9                   	leaveq 
  8018c6:	c3                   	retq   

00000000008018c7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	48 83 ec 20          	sub    $0x20,%rsp
  8018cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018dd:	48 98                	cltq   
  8018df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e6:	00 
  8018e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f3:	48 89 d1             	mov    %rdx,%rcx
  8018f6:	48 89 c2             	mov    %rax,%rdx
  8018f9:	be 01 00 00 00       	mov    $0x1,%esi
  8018fe:	bf 06 00 00 00       	mov    $0x6,%edi
  801903:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
}
  80190f:	c9                   	leaveq 
  801910:	c3                   	retq   

0000000000801911 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801911:	55                   	push   %rbp
  801912:	48 89 e5             	mov    %rsp,%rbp
  801915:	48 83 ec 10          	sub    $0x10,%rsp
  801919:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80191c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80191f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801922:	48 63 d0             	movslq %eax,%rdx
  801925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801928:	48 98                	cltq   
  80192a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801931:	00 
  801932:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801938:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193e:	48 89 d1             	mov    %rdx,%rcx
  801941:	48 89 c2             	mov    %rax,%rdx
  801944:	be 01 00 00 00       	mov    $0x1,%esi
  801949:	bf 08 00 00 00       	mov    $0x8,%edi
  80194e:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801955:	00 00 00 
  801958:	ff d0                	callq  *%rax
}
  80195a:	c9                   	leaveq 
  80195b:	c3                   	retq   

000000000080195c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	48 83 ec 20          	sub    $0x20,%rsp
  801964:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801967:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80196b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801972:	48 98                	cltq   
  801974:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197b:	00 
  80197c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801982:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801988:	48 89 d1             	mov    %rdx,%rcx
  80198b:	48 89 c2             	mov    %rax,%rdx
  80198e:	be 01 00 00 00       	mov    $0x1,%esi
  801993:	bf 09 00 00 00       	mov    $0x9,%edi
  801998:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 20          	sub    $0x20,%rsp
  8019ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bc:	48 98                	cltq   
  8019be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c5:	00 
  8019c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d2:	48 89 d1             	mov    %rdx,%rcx
  8019d5:	48 89 c2             	mov    %rax,%rdx
  8019d8:	be 01 00 00 00       	mov    $0x1,%esi
  8019dd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019e2:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 20          	sub    $0x20,%rsp
  8019f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a03:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a09:	48 63 f0             	movslq %eax,%rsi
  801a0c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a13:	48 98                	cltq   
  801a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a20:	00 
  801a21:	49 89 f1             	mov    %rsi,%r9
  801a24:	49 89 c8             	mov    %rcx,%r8
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 00 00 00 00       	mov    $0x0,%esi
  801a32:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a37:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 10          	sub    $0x10,%rsp
  801a4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a5c:	00 
  801a5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6e:	48 89 c2             	mov    %rax,%rdx
  801a71:	be 01 00 00 00       	mov    $0x1,%esi
  801a76:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a7b:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
}
  801a87:	c9                   	leaveq 
  801a88:	c3                   	retq   

0000000000801a89 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801a89:	55                   	push   %rbp
  801a8a:	48 89 e5             	mov    %rsp,%rbp
  801a8d:	48 83 ec 30          	sub    $0x30,%rsp
  801a91:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a99:	48 8b 00             	mov    (%rax),%rax
  801a9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801aa0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa4:	48 8b 40 08          	mov    0x8(%rax),%rax
  801aa8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801aab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801aae:	83 e0 02             	and    $0x2,%eax
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	75 4d                	jne    801b02 <pgfault+0x79>
  801ab5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab9:	48 c1 e8 0c          	shr    $0xc,%rax
  801abd:	48 89 c2             	mov    %rax,%rdx
  801ac0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ac7:	01 00 00 
  801aca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ace:	25 00 08 00 00       	and    $0x800,%eax
  801ad3:	48 85 c0             	test   %rax,%rax
  801ad6:	74 2a                	je     801b02 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ad8:	48 ba b0 41 80 00 00 	movabs $0x8041b0,%rdx
  801adf:	00 00 00 
  801ae2:	be 23 00 00 00       	mov    $0x23,%esi
  801ae7:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801aee:	00 00 00 
  801af1:	b8 00 00 00 00       	mov    $0x0,%eax
  801af6:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801afd:	00 00 00 
  801b00:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801b02:	ba 07 00 00 00       	mov    $0x7,%edx
  801b07:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801b11:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	callq  *%rax
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	0f 85 cd 00 00 00    	jne    801bf2 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b31:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b37:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801b3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b3f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b44:	48 89 c6             	mov    %rax,%rsi
  801b47:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b4c:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b5c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b62:	48 89 c1             	mov    %rax,%rcx
  801b65:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801b74:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801b7b:	00 00 00 
  801b7e:	ff d0                	callq  *%rax
  801b80:	85 c0                	test   %eax,%eax
  801b82:	79 2a                	jns    801bae <pgfault+0x125>
				panic("Page map at temp address failed");
  801b84:	48 ba f0 41 80 00 00 	movabs $0x8041f0,%rdx
  801b8b:	00 00 00 
  801b8e:	be 30 00 00 00       	mov    $0x30,%esi
  801b93:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801b9a:	00 00 00 
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba2:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801ba9:	00 00 00 
  801bac:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801bae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb8:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	79 54                	jns    801c1c <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801bc8:	48 ba 10 42 80 00 00 	movabs $0x804210,%rdx
  801bcf:	00 00 00 
  801bd2:	be 32 00 00 00       	mov    $0x32,%esi
  801bd7:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801bde:	00 00 00 
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
  801be6:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801bed:	00 00 00 
  801bf0:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801bf2:	48 ba 38 42 80 00 00 	movabs $0x804238,%rdx
  801bf9:	00 00 00 
  801bfc:	be 34 00 00 00       	mov    $0x34,%esi
  801c01:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801c08:	00 00 00 
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801c17:	00 00 00 
  801c1a:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801c1c:	c9                   	leaveq 
  801c1d:	c3                   	retq   

0000000000801c1e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c1e:	55                   	push   %rbp
  801c1f:	48 89 e5             	mov    %rsp,%rbp
  801c22:	48 83 ec 20          	sub    $0x20,%rsp
  801c26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c29:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801c2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c33:	01 00 00 
  801c36:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801c39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c3d:	25 07 0e 00 00       	and    $0xe07,%eax
  801c42:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801c45:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801c48:	48 c1 e0 0c          	shl    $0xc,%rax
  801c4c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801c50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c53:	25 00 04 00 00       	and    $0x400,%eax
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	74 57                	je     801cb3 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801c5c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c5f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801c63:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6a:	41 89 f0             	mov    %esi,%r8d
  801c6d:	48 89 c6             	mov    %rax,%rsi
  801c70:	bf 00 00 00 00       	mov    $0x0,%edi
  801c75:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
  801c81:	85 c0                	test   %eax,%eax
  801c83:	0f 8e 52 01 00 00    	jle    801ddb <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801c89:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  801c90:	00 00 00 
  801c93:	be 4e 00 00 00       	mov    $0x4e,%esi
  801c98:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801c9f:	00 00 00 
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca7:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801cae:	00 00 00 
  801cb1:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb6:	83 e0 02             	and    $0x2,%eax
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	75 10                	jne    801ccd <duppage+0xaf>
  801cbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc0:	25 00 08 00 00       	and    $0x800,%eax
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	0f 84 bb 00 00 00    	je     801d88 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801ccd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd0:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801cd5:	80 cc 08             	or     $0x8,%ah
  801cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cdb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cde:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ce2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ce5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce9:	41 89 f0             	mov    %esi,%r8d
  801cec:	48 89 c6             	mov    %rax,%rsi
  801cef:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf4:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
  801d00:	85 c0                	test   %eax,%eax
  801d02:	7e 2a                	jle    801d2e <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801d04:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  801d0b:	00 00 00 
  801d0e:	be 55 00 00 00       	mov    $0x55,%esi
  801d13:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801d1a:	00 00 00 
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801d29:	00 00 00 
  801d2c:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d2e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d39:	41 89 c8             	mov    %ecx,%r8d
  801d3c:	48 89 d1             	mov    %rdx,%rcx
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	48 89 c6             	mov    %rax,%rsi
  801d47:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4c:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	7e 2a                	jle    801d86 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801d5c:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  801d63:	00 00 00 
  801d66:	be 57 00 00 00       	mov    $0x57,%esi
  801d6b:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801d72:	00 00 00 
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801d81:	00 00 00 
  801d84:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801d86:	eb 53                	jmp    801ddb <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d88:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d8b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d8f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d96:	41 89 f0             	mov    %esi,%r8d
  801d99:	48 89 c6             	mov    %rax,%rsi
  801d9c:	bf 00 00 00 00       	mov    $0x0,%edi
  801da1:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
  801dad:	85 c0                	test   %eax,%eax
  801daf:	7e 2a                	jle    801ddb <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801db1:	48 ba 6a 42 80 00 00 	movabs $0x80426a,%rdx
  801db8:	00 00 00 
  801dbb:	be 5b 00 00 00       	mov    $0x5b,%esi
  801dc0:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801dc7:	00 00 00 
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  801dd6:	00 00 00 
  801dd9:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de0:	c9                   	leaveq 
  801de1:	c3                   	retq   

0000000000801de2 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801de2:	55                   	push   %rbp
  801de3:	48 89 e5             	mov    %rsp,%rbp
  801de6:	48 83 ec 18          	sub    $0x18,%rsp
  801dea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfa:	48 c1 e8 27          	shr    $0x27,%rax
  801dfe:	48 89 c2             	mov    %rax,%rdx
  801e01:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e08:	01 00 00 
  801e0b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e0f:	83 e0 01             	and    $0x1,%eax
  801e12:	48 85 c0             	test   %rax,%rax
  801e15:	74 51                	je     801e68 <pt_is_mapped+0x86>
  801e17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e1f:	48 c1 e8 1e          	shr    $0x1e,%rax
  801e23:	48 89 c2             	mov    %rax,%rdx
  801e26:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e2d:	01 00 00 
  801e30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e34:	83 e0 01             	and    $0x1,%eax
  801e37:	48 85 c0             	test   %rax,%rax
  801e3a:	74 2c                	je     801e68 <pt_is_mapped+0x86>
  801e3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e40:	48 c1 e0 0c          	shl    $0xc,%rax
  801e44:	48 c1 e8 15          	shr    $0x15,%rax
  801e48:	48 89 c2             	mov    %rax,%rdx
  801e4b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e52:	01 00 00 
  801e55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e59:	83 e0 01             	and    $0x1,%eax
  801e5c:	48 85 c0             	test   %rax,%rax
  801e5f:	74 07                	je     801e68 <pt_is_mapped+0x86>
  801e61:	b8 01 00 00 00       	mov    $0x1,%eax
  801e66:	eb 05                	jmp    801e6d <pt_is_mapped+0x8b>
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6d:	83 e0 01             	and    $0x1,%eax
}
  801e70:	c9                   	leaveq 
  801e71:	c3                   	retq   

0000000000801e72 <fork>:

envid_t
fork(void)
{
  801e72:	55                   	push   %rbp
  801e73:	48 89 e5             	mov    %rsp,%rbp
  801e76:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801e7a:	48 bf 89 1a 80 00 00 	movabs $0x801a89,%rdi
  801e81:	00 00 00 
  801e84:	48 b8 dc 38 80 00 00 	movabs $0x8038dc,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e90:	b8 07 00 00 00       	mov    $0x7,%eax
  801e95:	cd 30                	int    $0x30
  801e97:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801e9d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ea4:	79 30                	jns    801ed6 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801ea6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ea9:	89 c1                	mov    %eax,%ecx
  801eab:	48 ba 88 42 80 00 00 	movabs $0x804288,%rdx
  801eb2:	00 00 00 
  801eb5:	be 86 00 00 00       	mov    $0x86,%esi
  801eba:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  801ec1:	00 00 00 
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	49 b8 c8 37 80 00 00 	movabs $0x8037c8,%r8
  801ed0:	00 00 00 
  801ed3:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801eda:	75 46                	jne    801f22 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801edc:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  801ee3:	00 00 00 
  801ee6:	ff d0                	callq  *%rax
  801ee8:	25 ff 03 00 00       	and    $0x3ff,%eax
  801eed:	48 63 d0             	movslq %eax,%rdx
  801ef0:	48 89 d0             	mov    %rdx,%rax
  801ef3:	48 c1 e0 03          	shl    $0x3,%rax
  801ef7:	48 01 d0             	add    %rdx,%rax
  801efa:	48 c1 e0 05          	shl    $0x5,%rax
  801efe:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f05:	00 00 00 
  801f08:	48 01 c2             	add    %rax,%rdx
  801f0b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f12:	00 00 00 
  801f15:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1d:	e9 d1 01 00 00       	jmpq   8020f3 <fork+0x281>
	}
	uint64_t ad = 0;
  801f22:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f29:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801f2a:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801f2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801f33:	e9 df 00 00 00       	jmpq   802017 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3c:	48 c1 e8 27          	shr    $0x27,%rax
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f4a:	01 00 00 
  801f4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	48 85 c0             	test   %rax,%rax
  801f57:	0f 84 9e 00 00 00    	je     801ffb <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f61:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f65:	48 89 c2             	mov    %rax,%rdx
  801f68:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f6f:	01 00 00 
  801f72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f76:	83 e0 01             	and    $0x1,%eax
  801f79:	48 85 c0             	test   %rax,%rax
  801f7c:	74 73                	je     801ff1 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  801f7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f82:	48 c1 e8 15          	shr    $0x15,%rax
  801f86:	48 89 c2             	mov    %rax,%rdx
  801f89:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f90:	01 00 00 
  801f93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f97:	83 e0 01             	and    $0x1,%eax
  801f9a:	48 85 c0             	test   %rax,%rax
  801f9d:	74 48                	je     801fe7 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  801f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa3:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa7:	48 89 c2             	mov    %rax,%rdx
  801faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb1:	01 00 00 
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc0:	83 e0 01             	and    $0x1,%eax
  801fc3:	48 85 c0             	test   %rax,%rax
  801fc6:	74 47                	je     80200f <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  801fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fcc:	48 c1 e8 0c          	shr    $0xc,%rax
  801fd0:	89 c2                	mov    %eax,%edx
  801fd2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fd5:	89 d6                	mov    %edx,%esi
  801fd7:	89 c7                	mov    %eax,%edi
  801fd9:	48 b8 1e 1c 80 00 00 	movabs $0x801c1e,%rax
  801fe0:	00 00 00 
  801fe3:	ff d0                	callq  *%rax
  801fe5:	eb 28                	jmp    80200f <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  801fe7:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  801fee:	00 
  801fef:	eb 1e                	jmp    80200f <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  801ff1:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  801ff8:	40 
  801ff9:	eb 14                	jmp    80200f <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  801ffb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fff:	48 c1 e8 27          	shr    $0x27,%rax
  802003:	48 83 c0 01          	add    $0x1,%rax
  802007:	48 c1 e0 27          	shl    $0x27,%rax
  80200b:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80200f:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802016:	00 
  802017:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80201e:	00 
  80201f:	0f 87 13 ff ff ff    	ja     801f38 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802025:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802028:	ba 07 00 00 00       	mov    $0x7,%edx
  80202d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802032:	89 c7                	mov    %eax,%edi
  802034:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80203b:	00 00 00 
  80203e:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802040:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802043:	ba 07 00 00 00       	mov    $0x7,%edx
  802048:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80204d:	89 c7                	mov    %eax,%edi
  80204f:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802056:	00 00 00 
  802059:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80205b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802064:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802069:	ba 00 00 00 00       	mov    $0x0,%edx
  80206e:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802073:	89 c7                	mov    %eax,%edi
  802075:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802081:	ba 00 10 00 00       	mov    $0x1000,%edx
  802086:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80208b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802090:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802097:	00 00 00 
  80209a:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80209c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a6:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8020b2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020b9:	00 00 00 
  8020bc:	48 8b 00             	mov    (%rax),%rax
  8020bf:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8020c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c9:	48 89 d6             	mov    %rdx,%rsi
  8020cc:	89 c7                	mov    %eax,%edi
  8020ce:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  8020d5:	00 00 00 
  8020d8:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8020da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020dd:	be 02 00 00 00       	mov    $0x2,%esi
  8020e2:	89 c7                	mov    %eax,%edi
  8020e4:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8020eb:	00 00 00 
  8020ee:	ff d0                	callq  *%rax

	return envid;
  8020f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8020f3:	c9                   	leaveq 
  8020f4:	c3                   	retq   

00000000008020f5 <sfork>:

	
// Challenge!
int
sfork(void)
{
  8020f5:	55                   	push   %rbp
  8020f6:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8020f9:	48 ba a0 42 80 00 00 	movabs $0x8042a0,%rdx
  802100:	00 00 00 
  802103:	be bf 00 00 00       	mov    $0xbf,%esi
  802108:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  80210f:	00 00 00 
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  80211e:	00 00 00 
  802121:	ff d1                	callq  *%rcx

0000000000802123 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802123:	55                   	push   %rbp
  802124:	48 89 e5             	mov    %rsp,%rbp
  802127:	48 83 ec 08          	sub    $0x8,%rsp
  80212b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80212f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802133:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80213a:	ff ff ff 
  80213d:	48 01 d0             	add    %rdx,%rax
  802140:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802144:	c9                   	leaveq 
  802145:	c3                   	retq   

0000000000802146 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802146:	55                   	push   %rbp
  802147:	48 89 e5             	mov    %rsp,%rbp
  80214a:	48 83 ec 08          	sub    $0x8,%rsp
  80214e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802156:	48 89 c7             	mov    %rax,%rdi
  802159:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80216b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 18          	sub    $0x18,%rsp
  802179:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80217d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802184:	eb 6b                	jmp    8021f1 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802189:	48 98                	cltq   
  80218b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802191:	48 c1 e0 0c          	shl    $0xc,%rax
  802195:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219d:	48 c1 e8 15          	shr    $0x15,%rax
  8021a1:	48 89 c2             	mov    %rax,%rdx
  8021a4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ab:	01 00 00 
  8021ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b2:	83 e0 01             	and    $0x1,%eax
  8021b5:	48 85 c0             	test   %rax,%rax
  8021b8:	74 21                	je     8021db <fd_alloc+0x6a>
  8021ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021be:	48 c1 e8 0c          	shr    $0xc,%rax
  8021c2:	48 89 c2             	mov    %rax,%rdx
  8021c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021cc:	01 00 00 
  8021cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d3:	83 e0 01             	and    $0x1,%eax
  8021d6:	48 85 c0             	test   %rax,%rax
  8021d9:	75 12                	jne    8021ed <fd_alloc+0x7c>
			*fd_store = fd;
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021eb:	eb 1a                	jmp    802207 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021f1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021f5:	7e 8f                	jle    802186 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8021f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802202:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802207:	c9                   	leaveq 
  802208:	c3                   	retq   

0000000000802209 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802209:	55                   	push   %rbp
  80220a:	48 89 e5             	mov    %rsp,%rbp
  80220d:	48 83 ec 20          	sub    $0x20,%rsp
  802211:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802214:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802218:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80221c:	78 06                	js     802224 <fd_lookup+0x1b>
  80221e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802222:	7e 07                	jle    80222b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802224:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802229:	eb 6c                	jmp    802297 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80222b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80222e:	48 98                	cltq   
  802230:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802236:	48 c1 e0 0c          	shl    $0xc,%rax
  80223a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80223e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802242:	48 c1 e8 15          	shr    $0x15,%rax
  802246:	48 89 c2             	mov    %rax,%rdx
  802249:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802250:	01 00 00 
  802253:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802257:	83 e0 01             	and    $0x1,%eax
  80225a:	48 85 c0             	test   %rax,%rax
  80225d:	74 21                	je     802280 <fd_lookup+0x77>
  80225f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802263:	48 c1 e8 0c          	shr    $0xc,%rax
  802267:	48 89 c2             	mov    %rax,%rdx
  80226a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802271:	01 00 00 
  802274:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802278:	83 e0 01             	and    $0x1,%eax
  80227b:	48 85 c0             	test   %rax,%rax
  80227e:	75 07                	jne    802287 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802280:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802285:	eb 10                	jmp    802297 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80228b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80228f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802297:	c9                   	leaveq 
  802298:	c3                   	retq   

0000000000802299 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802299:	55                   	push   %rbp
  80229a:	48 89 e5             	mov    %rsp,%rbp
  80229d:	48 83 ec 30          	sub    $0x30,%rsp
  8022a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ae:	48 89 c7             	mov    %rax,%rdi
  8022b1:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  8022b8:	00 00 00 
  8022bb:	ff d0                	callq  *%rax
  8022bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c1:	48 89 d6             	mov    %rdx,%rsi
  8022c4:	89 c7                	mov    %eax,%edi
  8022c6:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
  8022d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d9:	78 0a                	js     8022e5 <fd_close+0x4c>
	    || fd != fd2)
  8022db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022df:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022e3:	74 12                	je     8022f7 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022e5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8022e9:	74 05                	je     8022f0 <fd_close+0x57>
  8022eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ee:	eb 05                	jmp    8022f5 <fd_close+0x5c>
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f5:	eb 69                	jmp    802360 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8022f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022fb:	8b 00                	mov    (%rax),%eax
  8022fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802301:	48 89 d6             	mov    %rdx,%rsi
  802304:	89 c7                	mov    %eax,%edi
  802306:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802319:	78 2a                	js     802345 <fd_close+0xac>
		if (dev->dev_close)
  80231b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802323:	48 85 c0             	test   %rax,%rax
  802326:	74 16                	je     80233e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802330:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802334:	48 89 d7             	mov    %rdx,%rdi
  802337:	ff d0                	callq  *%rax
  802339:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233c:	eb 07                	jmp    802345 <fd_close+0xac>
		else
			r = 0;
  80233e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802345:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802349:	48 89 c6             	mov    %rax,%rsi
  80234c:	bf 00 00 00 00       	mov    $0x0,%edi
  802351:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802358:	00 00 00 
  80235b:	ff d0                	callq  *%rax
	return r;
  80235d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   

0000000000802362 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	48 83 ec 20          	sub    $0x20,%rsp
  80236a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80236d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802378:	eb 41                	jmp    8023bb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80237a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802381:	00 00 00 
  802384:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802387:	48 63 d2             	movslq %edx,%rdx
  80238a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238e:	8b 00                	mov    (%rax),%eax
  802390:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802393:	75 22                	jne    8023b7 <dev_lookup+0x55>
			*dev = devtab[i];
  802395:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80239c:	00 00 00 
  80239f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023a2:	48 63 d2             	movslq %edx,%rdx
  8023a5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ad:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b5:	eb 60                	jmp    802417 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023bb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023c2:	00 00 00 
  8023c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023c8:	48 63 d2             	movslq %edx,%rdx
  8023cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cf:	48 85 c0             	test   %rax,%rax
  8023d2:	75 a6                	jne    80237a <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023d4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023db:	00 00 00 
  8023de:	48 8b 00             	mov    (%rax),%rax
  8023e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023ea:	89 c6                	mov    %eax,%esi
  8023ec:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  8023f3:	00 00 00 
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  802402:	00 00 00 
  802405:	ff d1                	callq  *%rcx
	*dev = 0;
  802407:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802412:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802417:	c9                   	leaveq 
  802418:	c3                   	retq   

0000000000802419 <close>:

int
close(int fdnum)
{
  802419:	55                   	push   %rbp
  80241a:	48 89 e5             	mov    %rsp,%rbp
  80241d:	48 83 ec 20          	sub    $0x20,%rsp
  802421:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802424:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802428:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80242b:	48 89 d6             	mov    %rdx,%rsi
  80242e:	89 c7                	mov    %eax,%edi
  802430:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  802437:	00 00 00 
  80243a:	ff d0                	callq  *%rax
  80243c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802443:	79 05                	jns    80244a <close+0x31>
		return r;
  802445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802448:	eb 18                	jmp    802462 <close+0x49>
	else
		return fd_close(fd, 1);
  80244a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244e:	be 01 00 00 00       	mov    $0x1,%esi
  802453:	48 89 c7             	mov    %rax,%rdi
  802456:	48 b8 99 22 80 00 00 	movabs $0x802299,%rax
  80245d:	00 00 00 
  802460:	ff d0                	callq  *%rax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <close_all>:

void
close_all(void)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80246c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802473:	eb 15                	jmp    80248a <close_all+0x26>
		close(i);
  802475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 19 24 80 00 00 	movabs $0x802419,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802486:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80248a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80248e:	7e e5                	jle    802475 <close_all+0x11>
		close(i);
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 40          	sub    $0x40,%rsp
  80249a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80249d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024a0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024a4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024a7:	48 89 d6             	mov    %rdx,%rsi
  8024aa:	89 c7                	mov    %eax,%edi
  8024ac:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax
  8024b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bf:	79 08                	jns    8024c9 <dup+0x37>
		return r;
  8024c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c4:	e9 70 01 00 00       	jmpq   802639 <dup+0x1a7>
	close(newfdnum);
  8024c9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024cc:	89 c7                	mov    %eax,%edi
  8024ce:	48 b8 19 24 80 00 00 	movabs $0x802419,%rax
  8024d5:	00 00 00 
  8024d8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024da:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024dd:	48 98                	cltq   
  8024df:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024e5:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8024ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024f1:	48 89 c7             	mov    %rax,%rdi
  8024f4:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802508:	48 89 c7             	mov    %rax,%rdi
  80250b:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  802512:	00 00 00 
  802515:	ff d0                	callq  *%rax
  802517:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80251b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251f:	48 c1 e8 15          	shr    $0x15,%rax
  802523:	48 89 c2             	mov    %rax,%rdx
  802526:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80252d:	01 00 00 
  802530:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802534:	83 e0 01             	and    $0x1,%eax
  802537:	48 85 c0             	test   %rax,%rax
  80253a:	74 73                	je     8025af <dup+0x11d>
  80253c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802540:	48 c1 e8 0c          	shr    $0xc,%rax
  802544:	48 89 c2             	mov    %rax,%rdx
  802547:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80254e:	01 00 00 
  802551:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802555:	83 e0 01             	and    $0x1,%eax
  802558:	48 85 c0             	test   %rax,%rax
  80255b:	74 52                	je     8025af <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80255d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802561:	48 c1 e8 0c          	shr    $0xc,%rax
  802565:	48 89 c2             	mov    %rax,%rdx
  802568:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80256f:	01 00 00 
  802572:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802576:	25 07 0e 00 00       	and    $0xe07,%eax
  80257b:	89 c1                	mov    %eax,%ecx
  80257d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802585:	41 89 c8             	mov    %ecx,%r8d
  802588:	48 89 d1             	mov    %rdx,%rcx
  80258b:	ba 00 00 00 00       	mov    $0x0,%edx
  802590:	48 89 c6             	mov    %rax,%rsi
  802593:	bf 00 00 00 00       	mov    $0x0,%edi
  802598:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ab:	79 02                	jns    8025af <dup+0x11d>
			goto err;
  8025ad:	eb 57                	jmp    802606 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b7:	48 89 c2             	mov    %rax,%rdx
  8025ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c1:	01 00 00 
  8025c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d7:	41 89 c8             	mov    %ecx,%r8d
  8025da:	48 89 d1             	mov    %rdx,%rcx
  8025dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e2:	48 89 c6             	mov    %rax,%rsi
  8025e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ea:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8025f1:	00 00 00 
  8025f4:	ff d0                	callq  *%rax
  8025f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fd:	79 02                	jns    802601 <dup+0x16f>
		goto err;
  8025ff:	eb 05                	jmp    802606 <dup+0x174>

	return newfdnum;
  802601:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802604:	eb 33                	jmp    802639 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260a:	48 89 c6             	mov    %rax,%rsi
  80260d:	bf 00 00 00 00       	mov    $0x0,%edi
  802612:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80261e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802622:	48 89 c6             	mov    %rax,%rsi
  802625:	bf 00 00 00 00       	mov    $0x0,%edi
  80262a:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802631:	00 00 00 
  802634:	ff d0                	callq  *%rax
	return r;
  802636:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802639:	c9                   	leaveq 
  80263a:	c3                   	retq   

000000000080263b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80263b:	55                   	push   %rbp
  80263c:	48 89 e5             	mov    %rsp,%rbp
  80263f:	48 83 ec 40          	sub    $0x40,%rsp
  802643:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802646:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80264a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80264e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802652:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802655:	48 89 d6             	mov    %rdx,%rsi
  802658:	89 c7                	mov    %eax,%edi
  80265a:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
  802666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266d:	78 24                	js     802693 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80266f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802673:	8b 00                	mov    (%rax),%eax
  802675:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802679:	48 89 d6             	mov    %rdx,%rsi
  80267c:	89 c7                	mov    %eax,%edi
  80267e:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802691:	79 05                	jns    802698 <read+0x5d>
		return r;
  802693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802696:	eb 76                	jmp    80270e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269c:	8b 40 08             	mov    0x8(%rax),%eax
  80269f:	83 e0 03             	and    $0x3,%eax
  8026a2:	83 f8 01             	cmp    $0x1,%eax
  8026a5:	75 3a                	jne    8026e1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026ae:	00 00 00 
  8026b1:	48 8b 00             	mov    (%rax),%rax
  8026b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026bd:	89 c6                	mov    %eax,%esi
  8026bf:	48 bf d7 42 80 00 00 	movabs $0x8042d7,%rdi
  8026c6:	00 00 00 
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8026d5:	00 00 00 
  8026d8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026df:	eb 2d                	jmp    80270e <read+0xd3>
	}
	if (!dev->dev_read)
  8026e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026e9:	48 85 c0             	test   %rax,%rax
  8026ec:	75 07                	jne    8026f5 <read+0xba>
		return -E_NOT_SUPP;
  8026ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f3:	eb 19                	jmp    80270e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8026f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802701:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802705:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802709:	48 89 cf             	mov    %rcx,%rdi
  80270c:	ff d0                	callq  *%rax
}
  80270e:	c9                   	leaveq 
  80270f:	c3                   	retq   

0000000000802710 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802710:	55                   	push   %rbp
  802711:	48 89 e5             	mov    %rsp,%rbp
  802714:	48 83 ec 30          	sub    $0x30,%rsp
  802718:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80271b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80271f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802723:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80272a:	eb 49                	jmp    802775 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80272c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272f:	48 98                	cltq   
  802731:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802735:	48 29 c2             	sub    %rax,%rdx
  802738:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273b:	48 63 c8             	movslq %eax,%rcx
  80273e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802742:	48 01 c1             	add    %rax,%rcx
  802745:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802748:	48 89 ce             	mov    %rcx,%rsi
  80274b:	89 c7                	mov    %eax,%edi
  80274d:	48 b8 3b 26 80 00 00 	movabs $0x80263b,%rax
  802754:	00 00 00 
  802757:	ff d0                	callq  *%rax
  802759:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80275c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802760:	79 05                	jns    802767 <readn+0x57>
			return m;
  802762:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802765:	eb 1c                	jmp    802783 <readn+0x73>
		if (m == 0)
  802767:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80276b:	75 02                	jne    80276f <readn+0x5f>
			break;
  80276d:	eb 11                	jmp    802780 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80276f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802772:	01 45 fc             	add    %eax,-0x4(%rbp)
  802775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802778:	48 98                	cltq   
  80277a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80277e:	72 ac                	jb     80272c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802780:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 40          	sub    $0x40,%rsp
  80278d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802790:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802794:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802798:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80279c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80279f:	48 89 d6             	mov    %rdx,%rsi
  8027a2:	89 c7                	mov    %eax,%edi
  8027a4:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax
  8027b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b7:	78 24                	js     8027dd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bd:	8b 00                	mov    (%rax),%eax
  8027bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027c3:	48 89 d6             	mov    %rdx,%rsi
  8027c6:	89 c7                	mov    %eax,%edi
  8027c8:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 05                	jns    8027e2 <write+0x5d>
		return r;
  8027dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e0:	eb 75                	jmp    802857 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e6:	8b 40 08             	mov    0x8(%rax),%eax
  8027e9:	83 e0 03             	and    $0x3,%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	75 3a                	jne    80282a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8027f0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027f7:	00 00 00 
  8027fa:	48 8b 00             	mov    (%rax),%rax
  8027fd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802803:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802806:	89 c6                	mov    %eax,%esi
  802808:	48 bf f3 42 80 00 00 	movabs $0x8042f3,%rdi
  80280f:	00 00 00 
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
  802817:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  80281e:	00 00 00 
  802821:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802828:	eb 2d                	jmp    802857 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80282a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802832:	48 85 c0             	test   %rax,%rax
  802835:	75 07                	jne    80283e <write+0xb9>
		return -E_NOT_SUPP;
  802837:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80283c:	eb 19                	jmp    802857 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80283e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802842:	48 8b 40 18          	mov    0x18(%rax),%rax
  802846:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80284a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80284e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802852:	48 89 cf             	mov    %rcx,%rdi
  802855:	ff d0                	callq  *%rax
}
  802857:	c9                   	leaveq 
  802858:	c3                   	retq   

0000000000802859 <seek>:

int
seek(int fdnum, off_t offset)
{
  802859:	55                   	push   %rbp
  80285a:	48 89 e5             	mov    %rsp,%rbp
  80285d:	48 83 ec 18          	sub    $0x18,%rsp
  802861:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802864:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802867:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80286b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80286e:	48 89 d6             	mov    %rdx,%rsi
  802871:	89 c7                	mov    %eax,%edi
  802873:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
  80287f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802886:	79 05                	jns    80288d <seek+0x34>
		return r;
  802888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288b:	eb 0f                	jmp    80289c <seek+0x43>
	fd->fd_offset = offset;
  80288d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802891:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802894:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802897:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289c:	c9                   	leaveq 
  80289d:	c3                   	retq   

000000000080289e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80289e:	55                   	push   %rbp
  80289f:	48 89 e5             	mov    %rsp,%rbp
  8028a2:	48 83 ec 30          	sub    $0x30,%rsp
  8028a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028b3:	48 89 d6             	mov    %rdx,%rsi
  8028b6:	89 c7                	mov    %eax,%edi
  8028b8:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
  8028c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cb:	78 24                	js     8028f1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d1:	8b 00                	mov    (%rax),%eax
  8028d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d7:	48 89 d6             	mov    %rdx,%rsi
  8028da:	89 c7                	mov    %eax,%edi
  8028dc:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  8028e3:	00 00 00 
  8028e6:	ff d0                	callq  *%rax
  8028e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ef:	79 05                	jns    8028f6 <ftruncate+0x58>
		return r;
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f4:	eb 72                	jmp    802968 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fa:	8b 40 08             	mov    0x8(%rax),%eax
  8028fd:	83 e0 03             	and    $0x3,%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	75 3a                	jne    80293e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802904:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80290b:	00 00 00 
  80290e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802911:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802917:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80291a:	89 c6                	mov    %eax,%esi
  80291c:	48 bf 10 43 80 00 00 	movabs $0x804310,%rdi
  802923:	00 00 00 
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
  80292b:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  802932:	00 00 00 
  802935:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802937:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80293c:	eb 2a                	jmp    802968 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80293e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802942:	48 8b 40 30          	mov    0x30(%rax),%rax
  802946:	48 85 c0             	test   %rax,%rax
  802949:	75 07                	jne    802952 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80294b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802950:	eb 16                	jmp    802968 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802952:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802956:	48 8b 40 30          	mov    0x30(%rax),%rax
  80295a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80295e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802961:	89 ce                	mov    %ecx,%esi
  802963:	48 89 d7             	mov    %rdx,%rdi
  802966:	ff d0                	callq  *%rax
}
  802968:	c9                   	leaveq 
  802969:	c3                   	retq   

000000000080296a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80296a:	55                   	push   %rbp
  80296b:	48 89 e5             	mov    %rsp,%rbp
  80296e:	48 83 ec 30          	sub    $0x30,%rsp
  802972:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802975:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802979:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802980:	48 89 d6             	mov    %rdx,%rsi
  802983:	89 c7                	mov    %eax,%edi
  802985:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	78 24                	js     8029be <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80299a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299e:	8b 00                	mov    (%rax),%eax
  8029a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a4:	48 89 d6             	mov    %rdx,%rsi
  8029a7:	89 c7                	mov    %eax,%edi
  8029a9:	48 b8 62 23 80 00 00 	movabs $0x802362,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
  8029b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bc:	79 05                	jns    8029c3 <fstat+0x59>
		return r;
  8029be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c1:	eb 5e                	jmp    802a21 <fstat+0xb7>
	if (!dev->dev_stat)
  8029c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029cb:	48 85 c0             	test   %rax,%rax
  8029ce:	75 07                	jne    8029d7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8029d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029d5:	eb 4a                	jmp    802a21 <fstat+0xb7>
	stat->st_name[0] = 0;
  8029d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029db:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029e2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8029e9:	00 00 00 
	stat->st_isdir = 0;
  8029ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8029f7:	00 00 00 
	stat->st_dev = dev;
  8029fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a02:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a15:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a19:	48 89 ce             	mov    %rcx,%rsi
  802a1c:	48 89 d7             	mov    %rdx,%rdi
  802a1f:	ff d0                	callq  *%rax
}
  802a21:	c9                   	leaveq 
  802a22:	c3                   	retq   

0000000000802a23 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a23:	55                   	push   %rbp
  802a24:	48 89 e5             	mov    %rsp,%rbp
  802a27:	48 83 ec 20          	sub    $0x20,%rsp
  802a2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a37:	be 00 00 00 00       	mov    $0x0,%esi
  802a3c:	48 89 c7             	mov    %rax,%rdi
  802a3f:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	79 05                	jns    802a59 <stat+0x36>
		return fd;
  802a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a57:	eb 2f                	jmp    802a88 <stat+0x65>
	r = fstat(fd, stat);
  802a59:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a60:	48 89 d6             	mov    %rdx,%rsi
  802a63:	89 c7                	mov    %eax,%edi
  802a65:	48 b8 6a 29 80 00 00 	movabs $0x80296a,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	callq  *%rax
  802a71:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a77:	89 c7                	mov    %eax,%edi
  802a79:	48 b8 19 24 80 00 00 	movabs $0x802419,%rax
  802a80:	00 00 00 
  802a83:	ff d0                	callq  *%rax
	return r;
  802a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 83 ec 10          	sub    $0x10,%rsp
  802a92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a99:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa0:	00 00 00 
  802aa3:	8b 00                	mov    (%rax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	75 1d                	jne    802ac6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802aa9:	bf 01 00 00 00       	mov    $0x1,%edi
  802aae:	48 b8 84 3b 80 00 00 	movabs $0x803b84,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
  802aba:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ac1:	00 00 00 
  802ac4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ac6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802acd:	00 00 00 
  802ad0:	8b 00                	mov    (%rax),%eax
  802ad2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ad5:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ada:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ae1:	00 00 00 
  802ae4:	89 c7                	mov    %eax,%edi
  802ae6:	48 b8 22 3b 80 00 00 	movabs $0x803b22,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802af2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af6:	ba 00 00 00 00       	mov    $0x0,%edx
  802afb:	48 89 c6             	mov    %rax,%rsi
  802afe:	bf 00 00 00 00       	mov    $0x0,%edi
  802b03:	48 b8 1c 3a 80 00 00 	movabs $0x803a1c,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 30          	sub    $0x30,%rsp
  802b19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b1d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802b20:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802b27:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802b2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802b35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802b3a:	75 08                	jne    802b44 <open+0x33>
	{
		return r;
  802b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3f:	e9 f2 00 00 00       	jmpq   802c36 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802b44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b48:	48 89 c7             	mov    %rax,%rdi
  802b4b:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802b52:	00 00 00 
  802b55:	ff d0                	callq  *%rax
  802b57:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b5a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802b61:	7e 0a                	jle    802b6d <open+0x5c>
	{
		return -E_BAD_PATH;
  802b63:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b68:	e9 c9 00 00 00       	jmpq   802c36 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802b6d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802b74:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802b75:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b79:	48 89 c7             	mov    %rax,%rdi
  802b7c:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802b83:	00 00 00 
  802b86:	ff d0                	callq  *%rax
  802b88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8f:	78 09                	js     802b9a <open+0x89>
  802b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b95:	48 85 c0             	test   %rax,%rax
  802b98:	75 08                	jne    802ba2 <open+0x91>
		{
			return r;
  802b9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9d:	e9 94 00 00 00       	jmpq   802c36 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802ba2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba6:	ba 00 04 00 00       	mov    $0x400,%edx
  802bab:	48 89 c6             	mov    %rax,%rsi
  802bae:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bb5:	00 00 00 
  802bb8:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802bc4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bcb:	00 00 00 
  802bce:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802bd1:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdb:	48 89 c6             	mov    %rax,%rsi
  802bde:	bf 01 00 00 00       	mov    $0x1,%edi
  802be3:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
  802bef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf6:	79 2b                	jns    802c23 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	be 00 00 00 00       	mov    $0x0,%esi
  802c01:	48 89 c7             	mov    %rax,%rdi
  802c04:	48 b8 99 22 80 00 00 	movabs $0x802299,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802c13:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c17:	79 05                	jns    802c1e <open+0x10d>
			{
				return d;
  802c19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c1c:	eb 18                	jmp    802c36 <open+0x125>
			}
			return r;
  802c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c21:	eb 13                	jmp    802c36 <open+0x125>
		}	
		return fd2num(fd_store);
  802c23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c27:	48 89 c7             	mov    %rax,%rdi
  802c2a:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802c36:	c9                   	leaveq 
  802c37:	c3                   	retq   

0000000000802c38 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 10          	sub    $0x10,%rsp
  802c40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c48:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c52:	00 00 00 
  802c55:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c57:	be 00 00 00 00       	mov    $0x0,%esi
  802c5c:	bf 06 00 00 00       	mov    $0x6,%edi
  802c61:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 30          	sub    $0x30,%rsp
  802c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c8a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c8f:	74 07                	je     802c98 <devfile_read+0x29>
  802c91:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c96:	75 07                	jne    802c9f <devfile_read+0x30>
		return -E_INVAL;
  802c98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c9d:	eb 77                	jmp    802d16 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ca6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cad:	00 00 00 
  802cb0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802cb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb9:	00 00 00 
  802cbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cc0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802cc4:	be 00 00 00 00       	mov    $0x0,%esi
  802cc9:	bf 03 00 00 00       	mov    $0x3,%edi
  802cce:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802cd5:	00 00 00 
  802cd8:	ff d0                	callq  *%rax
  802cda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce1:	7f 05                	jg     802ce8 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce6:	eb 2e                	jmp    802d16 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	48 63 d0             	movslq %eax,%rdx
  802cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cf9:	00 00 00 
  802cfc:	48 89 c7             	mov    %rax,%rdi
  802cff:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802d0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 30          	sub    $0x30,%rsp
  802d20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802d2c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802d33:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d38:	74 07                	je     802d41 <devfile_write+0x29>
  802d3a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d3f:	75 08                	jne    802d49 <devfile_write+0x31>
		return r;
  802d41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d44:	e9 9a 00 00 00       	jmpq   802de3 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d50:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d57:	00 00 00 
  802d5a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802d5c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d63:	00 
  802d64:	76 08                	jbe    802d6e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d66:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d6d:	00 
	}
	fsipcbuf.write.req_n = n;
  802d6e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d75:	00 00 00 
  802d78:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d7c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d80:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d88:	48 89 c6             	mov    %rax,%rsi
  802d8b:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d92:	00 00 00 
  802d95:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802da1:	be 00 00 00 00       	mov    $0x0,%esi
  802da6:	bf 04 00 00 00       	mov    $0x4,%edi
  802dab:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	callq  *%rax
  802db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbe:	7f 20                	jg     802de0 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802dc0:	48 bf 36 43 80 00 00 	movabs $0x804336,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  802dd6:	00 00 00 
  802dd9:	ff d2                	callq  *%rdx
		return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	eb 03                	jmp    802de3 <devfile_write+0xcb>
	}
	return r;
  802de0:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802de3:	c9                   	leaveq 
  802de4:	c3                   	retq   

0000000000802de5 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802de5:	55                   	push   %rbp
  802de6:	48 89 e5             	mov    %rsp,%rbp
  802de9:	48 83 ec 20          	sub    $0x20,%rsp
  802ded:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df9:	8b 50 0c             	mov    0xc(%rax),%edx
  802dfc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e03:	00 00 00 
  802e06:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e08:	be 00 00 00 00       	mov    $0x0,%esi
  802e0d:	bf 05 00 00 00       	mov    $0x5,%edi
  802e12:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
  802e1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e25:	79 05                	jns    802e2c <devfile_stat+0x47>
		return r;
  802e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2a:	eb 56                	jmp    802e82 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e30:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802e37:	00 00 00 
  802e3a:	48 89 c7             	mov    %rax,%rdi
  802e3d:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802e44:	00 00 00 
  802e47:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e50:	00 00 00 
  802e53:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e5d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6a:	00 00 00 
  802e6d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e77:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e82:	c9                   	leaveq 
  802e83:	c3                   	retq   

0000000000802e84 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e84:	55                   	push   %rbp
  802e85:	48 89 e5             	mov    %rsp,%rbp
  802e88:	48 83 ec 10          	sub    $0x10,%rsp
  802e8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e90:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e97:	8b 50 0c             	mov    0xc(%rax),%edx
  802e9a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea1:	00 00 00 
  802ea4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ea6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ead:	00 00 00 
  802eb0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802eb6:	be 00 00 00 00       	mov    $0x0,%esi
  802ebb:	bf 02 00 00 00       	mov    $0x2,%edi
  802ec0:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
}
  802ecc:	c9                   	leaveq 
  802ecd:	c3                   	retq   

0000000000802ece <remove>:

// Delete a file
int
remove(const char *path)
{
  802ece:	55                   	push   %rbp
  802ecf:	48 89 e5             	mov    %rsp,%rbp
  802ed2:	48 83 ec 10          	sub    $0x10,%rsp
  802ed6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ede:	48 89 c7             	mov    %rax,%rdi
  802ee1:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ef2:	7e 07                	jle    802efb <remove+0x2d>
		return -E_BAD_PATH;
  802ef4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ef9:	eb 33                	jmp    802f2e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eff:	48 89 c6             	mov    %rax,%rsi
  802f02:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f09:	00 00 00 
  802f0c:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f18:	be 00 00 00 00       	mov    $0x0,%esi
  802f1d:	bf 07 00 00 00       	mov    $0x7,%edi
  802f22:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
}
  802f2e:	c9                   	leaveq 
  802f2f:	c3                   	retq   

0000000000802f30 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f30:	55                   	push   %rbp
  802f31:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f34:	be 00 00 00 00       	mov    $0x0,%esi
  802f39:	bf 08 00 00 00       	mov    $0x8,%edi
  802f3e:	48 b8 8a 2a 80 00 00 	movabs $0x802a8a,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
}
  802f4a:	5d                   	pop    %rbp
  802f4b:	c3                   	retq   

0000000000802f4c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f4c:	55                   	push   %rbp
  802f4d:	48 89 e5             	mov    %rsp,%rbp
  802f50:	53                   	push   %rbx
  802f51:	48 83 ec 38          	sub    $0x38,%rsp
  802f55:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f59:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f5d:	48 89 c7             	mov    %rax,%rdi
  802f60:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
  802f6c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f73:	0f 88 bf 01 00 00    	js     803138 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f7d:	ba 07 04 00 00       	mov    $0x407,%edx
  802f82:	48 89 c6             	mov    %rax,%rsi
  802f85:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8a:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
  802f96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f9d:	0f 88 95 01 00 00    	js     803138 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802fa3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fa7:	48 89 c7             	mov    %rax,%rdi
  802faa:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
  802fb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fbd:	0f 88 5d 01 00 00    	js     803120 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fc7:	ba 07 04 00 00       	mov    $0x407,%edx
  802fcc:	48 89 c6             	mov    %rax,%rsi
  802fcf:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd4:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fe3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fe7:	0f 88 33 01 00 00    	js     803120 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff1:	48 89 c7             	mov    %rax,%rdi
  802ff4:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  802ffb:	00 00 00 
  802ffe:	ff d0                	callq  *%rax
  803000:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803004:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803008:	ba 07 04 00 00       	mov    $0x407,%edx
  80300d:	48 89 c6             	mov    %rax,%rsi
  803010:	bf 00 00 00 00       	mov    $0x0,%edi
  803015:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  80301c:	00 00 00 
  80301f:	ff d0                	callq  *%rax
  803021:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803024:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803028:	79 05                	jns    80302f <pipe+0xe3>
		goto err2;
  80302a:	e9 d9 00 00 00       	jmpq   803108 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80302f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803033:	48 89 c7             	mov    %rax,%rdi
  803036:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	48 89 c2             	mov    %rax,%rdx
  803045:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803049:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80304f:	48 89 d1             	mov    %rdx,%rcx
  803052:	ba 00 00 00 00       	mov    $0x0,%edx
  803057:	48 89 c6             	mov    %rax,%rsi
  80305a:	bf 00 00 00 00       	mov    $0x0,%edi
  80305f:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80306e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803072:	79 1b                	jns    80308f <pipe+0x143>
		goto err3;
  803074:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803075:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803079:	48 89 c6             	mov    %rax,%rsi
  80307c:	bf 00 00 00 00       	mov    $0x0,%edi
  803081:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803088:	00 00 00 
  80308b:	ff d0                	callq  *%rax
  80308d:	eb 79                	jmp    803108 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80308f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803093:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80309a:	00 00 00 
  80309d:	8b 12                	mov    (%rdx),%edx
  80309f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8030a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b0:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8030b7:	00 00 00 
  8030ba:	8b 12                	mov    (%rdx),%edx
  8030bc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8030be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cd:	48 89 c7             	mov    %rax,%rdi
  8030d0:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  8030d7:	00 00 00 
  8030da:	ff d0                	callq  *%rax
  8030dc:	89 c2                	mov    %eax,%edx
  8030de:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030e2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8030e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030e8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030f0:	48 89 c7             	mov    %rax,%rdi
  8030f3:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
  8030ff:	89 03                	mov    %eax,(%rbx)
	return 0;
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	eb 33                	jmp    80313b <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803108:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80310c:	48 89 c6             	mov    %rax,%rsi
  80310f:	bf 00 00 00 00       	mov    $0x0,%edi
  803114:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803120:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803124:	48 89 c6             	mov    %rax,%rsi
  803127:	bf 00 00 00 00       	mov    $0x0,%edi
  80312c:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
    err:
	return r;
  803138:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80313b:	48 83 c4 38          	add    $0x38,%rsp
  80313f:	5b                   	pop    %rbx
  803140:	5d                   	pop    %rbp
  803141:	c3                   	retq   

0000000000803142 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803142:	55                   	push   %rbp
  803143:	48 89 e5             	mov    %rsp,%rbp
  803146:	53                   	push   %rbx
  803147:	48 83 ec 28          	sub    $0x28,%rsp
  80314b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80314f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803153:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80315a:	00 00 00 
  80315d:	48 8b 00             	mov    (%rax),%rax
  803160:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803166:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803169:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316d:	48 89 c7             	mov    %rax,%rdi
  803170:	48 b8 06 3c 80 00 00 	movabs $0x803c06,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
  80317c:	89 c3                	mov    %eax,%ebx
  80317e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803182:	48 89 c7             	mov    %rax,%rdi
  803185:	48 b8 06 3c 80 00 00 	movabs $0x803c06,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	39 c3                	cmp    %eax,%ebx
  803193:	0f 94 c0             	sete   %al
  803196:	0f b6 c0             	movzbl %al,%eax
  803199:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80319c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031a3:	00 00 00 
  8031a6:	48 8b 00             	mov    (%rax),%rax
  8031a9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031af:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8031b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031b5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031b8:	75 05                	jne    8031bf <_pipeisclosed+0x7d>
			return ret;
  8031ba:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031bd:	eb 4f                	jmp    80320e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8031bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031c5:	74 42                	je     803209 <_pipeisclosed+0xc7>
  8031c7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031cb:	75 3c                	jne    803209 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031cd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031d4:	00 00 00 
  8031d7:	48 8b 00             	mov    (%rax),%rax
  8031da:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031e0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e6:	89 c6                	mov    %eax,%esi
  8031e8:	48 bf 57 43 80 00 00 	movabs $0x804357,%rdi
  8031ef:	00 00 00 
  8031f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f7:	49 b8 38 03 80 00 00 	movabs $0x800338,%r8
  8031fe:	00 00 00 
  803201:	41 ff d0             	callq  *%r8
	}
  803204:	e9 4a ff ff ff       	jmpq   803153 <_pipeisclosed+0x11>
  803209:	e9 45 ff ff ff       	jmpq   803153 <_pipeisclosed+0x11>
}
  80320e:	48 83 c4 28          	add    $0x28,%rsp
  803212:	5b                   	pop    %rbx
  803213:	5d                   	pop    %rbp
  803214:	c3                   	retq   

0000000000803215 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 30          	sub    $0x30,%rsp
  80321d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803220:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803224:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803227:	48 89 d6             	mov    %rdx,%rsi
  80322a:	89 c7                	mov    %eax,%edi
  80322c:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
  803238:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80323b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80323f:	79 05                	jns    803246 <pipeisclosed+0x31>
		return r;
  803241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803244:	eb 31                	jmp    803277 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803246:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324a:	48 89 c7             	mov    %rax,%rdi
  80324d:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  803254:	00 00 00 
  803257:	ff d0                	callq  *%rax
  803259:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80325d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803261:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803265:	48 89 d6             	mov    %rdx,%rsi
  803268:	48 89 c7             	mov    %rax,%rdi
  80326b:	48 b8 42 31 80 00 00 	movabs $0x803142,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
}
  803277:	c9                   	leaveq 
  803278:	c3                   	retq   

0000000000803279 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	48 83 ec 40          	sub    $0x40,%rsp
  803281:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803285:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803289:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80328d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803291:	48 89 c7             	mov    %rax,%rdi
  803294:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
  8032a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8032a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032b3:	00 
  8032b4:	e9 92 00 00 00       	jmpq   80334b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8032b9:	eb 41                	jmp    8032fc <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8032bb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032c0:	74 09                	je     8032cb <devpipe_read+0x52>
				return i;
  8032c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c6:	e9 92 00 00 00       	jmpq   80335d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8032cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d3:	48 89 d6             	mov    %rdx,%rsi
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 42 31 80 00 00 	movabs $0x803142,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	74 07                	je     8032f0 <devpipe_read+0x77>
				return 0;
  8032e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ee:	eb 6d                	jmp    80335d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032f0:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803300:	8b 10                	mov    (%rax),%edx
  803302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803306:	8b 40 04             	mov    0x4(%rax),%eax
  803309:	39 c2                	cmp    %eax,%edx
  80330b:	74 ae                	je     8032bb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80330d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803311:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803315:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331d:	8b 00                	mov    (%rax),%eax
  80331f:	99                   	cltd   
  803320:	c1 ea 1b             	shr    $0x1b,%edx
  803323:	01 d0                	add    %edx,%eax
  803325:	83 e0 1f             	and    $0x1f,%eax
  803328:	29 d0                	sub    %edx,%eax
  80332a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80332e:	48 98                	cltq   
  803330:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803335:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333b:	8b 00                	mov    (%rax),%eax
  80333d:	8d 50 01             	lea    0x1(%rax),%edx
  803340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803344:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803346:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80334b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803353:	0f 82 60 ff ff ff    	jb     8032b9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80335d:	c9                   	leaveq 
  80335e:	c3                   	retq   

000000000080335f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80335f:	55                   	push   %rbp
  803360:	48 89 e5             	mov    %rsp,%rbp
  803363:	48 83 ec 40          	sub    $0x40,%rsp
  803367:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80336b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80336f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803373:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803377:	48 89 c7             	mov    %rax,%rdi
  80337a:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  803381:	00 00 00 
  803384:	ff d0                	callq  *%rax
  803386:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80338a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80338e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803392:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803399:	00 
  80339a:	e9 8e 00 00 00       	jmpq   80342d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80339f:	eb 31                	jmp    8033d2 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8033a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a9:	48 89 d6             	mov    %rdx,%rsi
  8033ac:	48 89 c7             	mov    %rax,%rdi
  8033af:	48 b8 42 31 80 00 00 	movabs $0x803142,%rax
  8033b6:	00 00 00 
  8033b9:	ff d0                	callq  *%rax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 07                	je     8033c6 <devpipe_write+0x67>
				return 0;
  8033bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c4:	eb 79                	jmp    80343f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8033c6:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  8033cd:	00 00 00 
  8033d0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d6:	8b 40 04             	mov    0x4(%rax),%eax
  8033d9:	48 63 d0             	movslq %eax,%rdx
  8033dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e0:	8b 00                	mov    (%rax),%eax
  8033e2:	48 98                	cltq   
  8033e4:	48 83 c0 20          	add    $0x20,%rax
  8033e8:	48 39 c2             	cmp    %rax,%rdx
  8033eb:	73 b4                	jae    8033a1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	8b 40 04             	mov    0x4(%rax),%eax
  8033f4:	99                   	cltd   
  8033f5:	c1 ea 1b             	shr    $0x1b,%edx
  8033f8:	01 d0                	add    %edx,%eax
  8033fa:	83 e0 1f             	and    $0x1f,%eax
  8033fd:	29 d0                	sub    %edx,%eax
  8033ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803403:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803407:	48 01 ca             	add    %rcx,%rdx
  80340a:	0f b6 0a             	movzbl (%rdx),%ecx
  80340d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803411:	48 98                	cltq   
  803413:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341b:	8b 40 04             	mov    0x4(%rax),%eax
  80341e:	8d 50 01             	lea    0x1(%rax),%edx
  803421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803425:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803428:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80342d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803431:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803435:	0f 82 64 ff ff ff    	jb     80339f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80343b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80343f:	c9                   	leaveq 
  803440:	c3                   	retq   

0000000000803441 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803441:	55                   	push   %rbp
  803442:	48 89 e5             	mov    %rsp,%rbp
  803445:	48 83 ec 20          	sub    $0x20,%rsp
  803449:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80344d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803455:	48 89 c7             	mov    %rax,%rdi
  803458:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  80345f:	00 00 00 
  803462:	ff d0                	callq  *%rax
  803464:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803468:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346c:	48 be 6a 43 80 00 00 	movabs $0x80436a,%rsi
  803473:	00 00 00 
  803476:	48 89 c7             	mov    %rax,%rdi
  803479:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  803480:	00 00 00 
  803483:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803489:	8b 50 04             	mov    0x4(%rax),%edx
  80348c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803490:	8b 00                	mov    (%rax),%eax
  803492:	29 c2                	sub    %eax,%edx
  803494:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803498:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80349e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034a2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8034a9:	00 00 00 
	stat->st_dev = &devpipe;
  8034ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b0:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8034b7:	00 00 00 
  8034ba:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8034c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c6:	c9                   	leaveq 
  8034c7:	c3                   	retq   

00000000008034c8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8034c8:	55                   	push   %rbp
  8034c9:	48 89 e5             	mov    %rsp,%rbp
  8034cc:	48 83 ec 10          	sub    $0x10,%rsp
  8034d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d8:	48 89 c6             	mov    %rax,%rsi
  8034db:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e0:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8034e7:	00 00 00 
  8034ea:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f0:	48 89 c7             	mov    %rax,%rdi
  8034f3:	48 b8 46 21 80 00 00 	movabs $0x802146,%rax
  8034fa:	00 00 00 
  8034fd:	ff d0                	callq  *%rax
  8034ff:	48 89 c6             	mov    %rax,%rsi
  803502:	bf 00 00 00 00       	mov    $0x0,%edi
  803507:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 20          	sub    $0x20,%rsp
  80351d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803520:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803523:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803526:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80352a:	be 01 00 00 00       	mov    $0x1,%esi
  80352f:	48 89 c7             	mov    %rax,%rdi
  803532:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  803539:	00 00 00 
  80353c:	ff d0                	callq  *%rax
}
  80353e:	c9                   	leaveq 
  80353f:	c3                   	retq   

0000000000803540 <getchar>:

int
getchar(void)
{
  803540:	55                   	push   %rbp
  803541:	48 89 e5             	mov    %rsp,%rbp
  803544:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803548:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80354c:	ba 01 00 00 00       	mov    $0x1,%edx
  803551:	48 89 c6             	mov    %rax,%rsi
  803554:	bf 00 00 00 00       	mov    $0x0,%edi
  803559:	48 b8 3b 26 80 00 00 	movabs $0x80263b,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
  803565:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803568:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356c:	79 05                	jns    803573 <getchar+0x33>
		return r;
  80356e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803571:	eb 14                	jmp    803587 <getchar+0x47>
	if (r < 1)
  803573:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803577:	7f 07                	jg     803580 <getchar+0x40>
		return -E_EOF;
  803579:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80357e:	eb 07                	jmp    803587 <getchar+0x47>
	return c;
  803580:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803584:	0f b6 c0             	movzbl %al,%eax
}
  803587:	c9                   	leaveq 
  803588:	c3                   	retq   

0000000000803589 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 83 ec 20          	sub    $0x20,%rsp
  803591:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803594:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803598:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80359b:	48 89 d6             	mov    %rdx,%rsi
  80359e:	89 c7                	mov    %eax,%edi
  8035a0:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8035a7:	00 00 00 
  8035aa:	ff d0                	callq  *%rax
  8035ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b3:	79 05                	jns    8035ba <iscons+0x31>
		return r;
  8035b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b8:	eb 1a                	jmp    8035d4 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8035ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035be:	8b 10                	mov    (%rax),%edx
  8035c0:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8035c7:	00 00 00 
  8035ca:	8b 00                	mov    (%rax),%eax
  8035cc:	39 c2                	cmp    %eax,%edx
  8035ce:	0f 94 c0             	sete   %al
  8035d1:	0f b6 c0             	movzbl %al,%eax
}
  8035d4:	c9                   	leaveq 
  8035d5:	c3                   	retq   

00000000008035d6 <opencons>:

int
opencons(void)
{
  8035d6:	55                   	push   %rbp
  8035d7:	48 89 e5             	mov    %rsp,%rbp
  8035da:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035de:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f8:	79 05                	jns    8035ff <opencons+0x29>
		return r;
  8035fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fd:	eb 5b                	jmp    80365a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803603:	ba 07 04 00 00       	mov    $0x407,%edx
  803608:	48 89 c6             	mov    %rax,%rsi
  80360b:	bf 00 00 00 00       	mov    $0x0,%edi
  803610:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
  80361c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80361f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803623:	79 05                	jns    80362a <opencons+0x54>
		return r;
  803625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803628:	eb 30                	jmp    80365a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803635:	00 00 00 
  803638:	8b 12                	mov    (%rdx),%edx
  80363a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80363c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803640:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364b:	48 89 c7             	mov    %rax,%rdi
  80364e:	48 b8 23 21 80 00 00 	movabs $0x802123,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
}
  80365a:	c9                   	leaveq 
  80365b:	c3                   	retq   

000000000080365c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80365c:	55                   	push   %rbp
  80365d:	48 89 e5             	mov    %rsp,%rbp
  803660:	48 83 ec 30          	sub    $0x30,%rsp
  803664:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803668:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80366c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803670:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803675:	75 07                	jne    80367e <devcons_read+0x22>
		return 0;
  803677:	b8 00 00 00 00       	mov    $0x0,%eax
  80367c:	eb 4b                	jmp    8036c9 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80367e:	eb 0c                	jmp    80368c <devcons_read+0x30>
		sys_yield();
  803680:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803687:	00 00 00 
  80368a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80368c:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
  803698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369f:	74 df                	je     803680 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8036a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a5:	79 05                	jns    8036ac <devcons_read+0x50>
		return c;
  8036a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036aa:	eb 1d                	jmp    8036c9 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8036ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8036b0:	75 07                	jne    8036b9 <devcons_read+0x5d>
		return 0;
  8036b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b7:	eb 10                	jmp    8036c9 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8036b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bc:	89 c2                	mov    %eax,%edx
  8036be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c2:	88 10                	mov    %dl,(%rax)
	return 1;
  8036c4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8036c9:	c9                   	leaveq 
  8036ca:	c3                   	retq   

00000000008036cb <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036cb:	55                   	push   %rbp
  8036cc:	48 89 e5             	mov    %rsp,%rbp
  8036cf:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036d6:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036dd:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036e4:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036f2:	eb 76                	jmp    80376a <devcons_write+0x9f>
		m = n - tot;
  8036f4:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036fb:	89 c2                	mov    %eax,%edx
  8036fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803700:	29 c2                	sub    %eax,%edx
  803702:	89 d0                	mov    %edx,%eax
  803704:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803707:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80370a:	83 f8 7f             	cmp    $0x7f,%eax
  80370d:	76 07                	jbe    803716 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80370f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803716:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803719:	48 63 d0             	movslq %eax,%rdx
  80371c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371f:	48 63 c8             	movslq %eax,%rcx
  803722:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803729:	48 01 c1             	add    %rax,%rcx
  80372c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803733:	48 89 ce             	mov    %rcx,%rsi
  803736:	48 89 c7             	mov    %rax,%rdi
  803739:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  803740:	00 00 00 
  803743:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803745:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803748:	48 63 d0             	movslq %eax,%rdx
  80374b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803752:	48 89 d6             	mov    %rdx,%rsi
  803755:	48 89 c7             	mov    %rax,%rdi
  803758:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803764:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803767:	01 45 fc             	add    %eax,-0x4(%rbp)
  80376a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376d:	48 98                	cltq   
  80376f:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803776:	0f 82 78 ff ff ff    	jb     8036f4 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80377c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80377f:	c9                   	leaveq 
  803780:	c3                   	retq   

0000000000803781 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803781:	55                   	push   %rbp
  803782:	48 89 e5             	mov    %rsp,%rbp
  803785:	48 83 ec 08          	sub    $0x8,%rsp
  803789:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80378d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803792:	c9                   	leaveq 
  803793:	c3                   	retq   

0000000000803794 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803794:	55                   	push   %rbp
  803795:	48 89 e5             	mov    %rsp,%rbp
  803798:	48 83 ec 10          	sub    $0x10,%rsp
  80379c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	48 be 76 43 80 00 00 	movabs $0x804376,%rsi
  8037af:	00 00 00 
  8037b2:	48 89 c7             	mov    %rax,%rdi
  8037b5:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
	return 0;
  8037c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037c6:	c9                   	leaveq 
  8037c7:	c3                   	retq   

00000000008037c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8037c8:	55                   	push   %rbp
  8037c9:	48 89 e5             	mov    %rsp,%rbp
  8037cc:	53                   	push   %rbx
  8037cd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037d4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8037db:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8037e1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037e8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037ef:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037f6:	84 c0                	test   %al,%al
  8037f8:	74 23                	je     80381d <_panic+0x55>
  8037fa:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803801:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803805:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803809:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80380d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803811:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803815:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803819:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80381d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803824:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80382b:	00 00 00 
  80382e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803835:	00 00 00 
  803838:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80383c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803843:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80384a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803851:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803858:	00 00 00 
  80385b:	48 8b 18             	mov    (%rax),%rbx
  80385e:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  803865:	00 00 00 
  803868:	ff d0                	callq  *%rax
  80386a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803870:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803877:	41 89 c8             	mov    %ecx,%r8d
  80387a:	48 89 d1             	mov    %rdx,%rcx
  80387d:	48 89 da             	mov    %rbx,%rdx
  803880:	89 c6                	mov    %eax,%esi
  803882:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  803889:	00 00 00 
  80388c:	b8 00 00 00 00       	mov    $0x0,%eax
  803891:	49 b9 38 03 80 00 00 	movabs $0x800338,%r9
  803898:	00 00 00 
  80389b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80389e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8038a5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8038ac:	48 89 d6             	mov    %rdx,%rsi
  8038af:	48 89 c7             	mov    %rax,%rdi
  8038b2:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
	cprintf("\n");
  8038be:	48 bf a3 43 80 00 00 	movabs $0x8043a3,%rdi
  8038c5:	00 00 00 
  8038c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038cd:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  8038d4:	00 00 00 
  8038d7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8038d9:	cc                   	int3   
  8038da:	eb fd                	jmp    8038d9 <_panic+0x111>

00000000008038dc <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038dc:	55                   	push   %rbp
  8038dd:	48 89 e5             	mov    %rsp,%rbp
  8038e0:	48 83 ec 10          	sub    $0x10,%rsp
  8038e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8038e8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038ef:	00 00 00 
  8038f2:	48 8b 00             	mov    (%rax),%rax
  8038f5:	48 85 c0             	test   %rax,%rax
  8038f8:	0f 85 84 00 00 00    	jne    803982 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8038fe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803905:	00 00 00 
  803908:	48 8b 00             	mov    (%rax),%rax
  80390b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803911:	ba 07 00 00 00       	mov    $0x7,%edx
  803916:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80391b:	89 c7                	mov    %eax,%edi
  80391d:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	85 c0                	test   %eax,%eax
  80392b:	79 2a                	jns    803957 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80392d:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  803934:	00 00 00 
  803937:	be 23 00 00 00       	mov    $0x23,%esi
  80393c:	48 bf cf 43 80 00 00 	movabs $0x8043cf,%rdi
  803943:	00 00 00 
  803946:	b8 00 00 00 00       	mov    $0x0,%eax
  80394b:	48 b9 c8 37 80 00 00 	movabs $0x8037c8,%rcx
  803952:	00 00 00 
  803955:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803957:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80395e:	00 00 00 
  803961:	48 8b 00             	mov    (%rax),%rax
  803964:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80396a:	48 be 95 39 80 00 00 	movabs $0x803995,%rsi
  803971:	00 00 00 
  803974:	89 c7                	mov    %eax,%edi
  803976:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  80397d:	00 00 00 
  803980:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803982:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803989:	00 00 00 
  80398c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803990:	48 89 10             	mov    %rdx,(%rax)
}
  803993:	c9                   	leaveq 
  803994:	c3                   	retq   

0000000000803995 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803995:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803998:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  80399f:	00 00 00 
	call *%rax
  8039a2:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  8039a4:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8039ab:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8039ac:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8039b3:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8039b4:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8039b8:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8039bb:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8039c2:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8039c3:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8039c7:	4c 8b 3c 24          	mov    (%rsp),%r15
  8039cb:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8039d0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8039d5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8039da:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8039df:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8039e4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8039e9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8039ee:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8039f3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8039f8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8039fd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803a02:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803a07:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803a0c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803a11:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803a15:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803a19:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803a1a:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803a1b:	c3                   	retq   

0000000000803a1c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a1c:	55                   	push   %rbp
  803a1d:	48 89 e5             	mov    %rsp,%rbp
  803a20:	48 83 ec 30          	sub    $0x30,%rsp
  803a24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803a30:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a37:	00 00 00 
  803a3a:	48 8b 00             	mov    (%rax),%rax
  803a3d:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	75 3c                	jne    803a83 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803a47:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
  803a53:	25 ff 03 00 00       	and    $0x3ff,%eax
  803a58:	48 63 d0             	movslq %eax,%rdx
  803a5b:	48 89 d0             	mov    %rdx,%rax
  803a5e:	48 c1 e0 03          	shl    $0x3,%rax
  803a62:	48 01 d0             	add    %rdx,%rax
  803a65:	48 c1 e0 05          	shl    $0x5,%rax
  803a69:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a70:	00 00 00 
  803a73:	48 01 c2             	add    %rax,%rdx
  803a76:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a7d:	00 00 00 
  803a80:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803a83:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a88:	75 0e                	jne    803a98 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803a8a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803a91:	00 00 00 
  803a94:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803a98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9c:	48 89 c7             	mov    %rax,%rdi
  803a9f:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  803aa6:	00 00 00 
  803aa9:	ff d0                	callq  *%rax
  803aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab2:	79 19                	jns    803acd <ipc_recv+0xb1>
		*from_env_store = 0;
  803ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803acb:	eb 53                	jmp    803b20 <ipc_recv+0x104>
	}
	if(from_env_store)
  803acd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ad2:	74 19                	je     803aed <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803ad4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803adb:	00 00 00 
  803ade:	48 8b 00             	mov    (%rax),%rax
  803ae1:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aeb:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803aed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803af2:	74 19                	je     803b0d <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803af4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803afb:	00 00 00 
  803afe:	48 8b 00             	mov    (%rax),%rax
  803b01:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b0b:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803b0d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b14:	00 00 00 
  803b17:	48 8b 00             	mov    (%rax),%rax
  803b1a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803b20:	c9                   	leaveq 
  803b21:	c3                   	retq   

0000000000803b22 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b22:	55                   	push   %rbp
  803b23:	48 89 e5             	mov    %rsp,%rbp
  803b26:	48 83 ec 30          	sub    $0x30,%rsp
  803b2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b2d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b30:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b34:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803b37:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b3c:	75 0e                	jne    803b4c <ipc_send+0x2a>
		pg = (void*)UTOP;
  803b3e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b45:	00 00 00 
  803b48:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803b4c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b4f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b59:	89 c7                	mov    %eax,%edi
  803b5b:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
  803b67:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803b6a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b6e:	75 0c                	jne    803b7c <ipc_send+0x5a>
			sys_yield();
  803b70:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803b7c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b80:	74 ca                	je     803b4c <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803b82:	c9                   	leaveq 
  803b83:	c3                   	retq   

0000000000803b84 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b84:	55                   	push   %rbp
  803b85:	48 89 e5             	mov    %rsp,%rbp
  803b88:	48 83 ec 14          	sub    $0x14,%rsp
  803b8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b96:	eb 5e                	jmp    803bf6 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b98:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b9f:	00 00 00 
  803ba2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba5:	48 63 d0             	movslq %eax,%rdx
  803ba8:	48 89 d0             	mov    %rdx,%rax
  803bab:	48 c1 e0 03          	shl    $0x3,%rax
  803baf:	48 01 d0             	add    %rdx,%rax
  803bb2:	48 c1 e0 05          	shl    $0x5,%rax
  803bb6:	48 01 c8             	add    %rcx,%rax
  803bb9:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803bbf:	8b 00                	mov    (%rax),%eax
  803bc1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bc4:	75 2c                	jne    803bf2 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803bc6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803bcd:	00 00 00 
  803bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd3:	48 63 d0             	movslq %eax,%rdx
  803bd6:	48 89 d0             	mov    %rdx,%rax
  803bd9:	48 c1 e0 03          	shl    $0x3,%rax
  803bdd:	48 01 d0             	add    %rdx,%rax
  803be0:	48 c1 e0 05          	shl    $0x5,%rax
  803be4:	48 01 c8             	add    %rcx,%rax
  803be7:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bed:	8b 40 08             	mov    0x8(%rax),%eax
  803bf0:	eb 12                	jmp    803c04 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803bf2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bf6:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bfd:	7e 99                	jle    803b98 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c04:	c9                   	leaveq 
  803c05:	c3                   	retq   

0000000000803c06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c06:	55                   	push   %rbp
  803c07:	48 89 e5             	mov    %rsp,%rbp
  803c0a:	48 83 ec 18          	sub    $0x18,%rsp
  803c0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c16:	48 c1 e8 15          	shr    $0x15,%rax
  803c1a:	48 89 c2             	mov    %rax,%rdx
  803c1d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c24:	01 00 00 
  803c27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2b:	83 e0 01             	and    $0x1,%eax
  803c2e:	48 85 c0             	test   %rax,%rax
  803c31:	75 07                	jne    803c3a <pageref+0x34>
		return 0;
  803c33:	b8 00 00 00 00       	mov    $0x0,%eax
  803c38:	eb 53                	jmp    803c8d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c3e:	48 c1 e8 0c          	shr    $0xc,%rax
  803c42:	48 89 c2             	mov    %rax,%rdx
  803c45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c4c:	01 00 00 
  803c4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c5b:	83 e0 01             	and    $0x1,%eax
  803c5e:	48 85 c0             	test   %rax,%rax
  803c61:	75 07                	jne    803c6a <pageref+0x64>
		return 0;
  803c63:	b8 00 00 00 00       	mov    $0x0,%eax
  803c68:	eb 23                	jmp    803c8d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c6e:	48 c1 e8 0c          	shr    $0xc,%rax
  803c72:	48 89 c2             	mov    %rax,%rdx
  803c75:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c7c:	00 00 00 
  803c7f:	48 c1 e2 04          	shl    $0x4,%rdx
  803c83:	48 01 d0             	add    %rdx,%rax
  803c86:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c8a:	0f b7 c0             	movzwl %ax,%eax
}
  803c8d:	c9                   	leaveq 
  803c8e:	c3                   	retq   
