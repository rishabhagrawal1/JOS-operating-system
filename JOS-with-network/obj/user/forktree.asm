
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
  80007e:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 a0 0d 80 00 00 	movabs $0x800da0,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 3c 1f 80 00 00 	movabs $0x801f3c,%rax
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
  8000f1:	48 bf 45 47 80 00 00 	movabs $0x804745,%rdi
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
  80014d:	48 bf 56 47 80 00 00 	movabs $0x804756,%rdi
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
  8001f4:	48 b8 2e 25 80 00 00 	movabs $0x80252e,%rax
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
  8004a4:	48 ba 70 49 80 00 00 	movabs $0x804970,%rdx
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
  80079c:	48 b8 98 49 80 00 00 	movabs $0x804998,%rax
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
  8008ea:	83 fb 15             	cmp    $0x15,%ebx
  8008ed:	7f 16                	jg     800905 <vprintfmt+0x21a>
  8008ef:	48 b8 c0 48 80 00 00 	movabs $0x8048c0,%rax
  8008f6:	00 00 00 
  8008f9:	48 63 d3             	movslq %ebx,%rdx
  8008fc:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800900:	4d 85 e4             	test   %r12,%r12
  800903:	75 2e                	jne    800933 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800905:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800909:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090d:	89 d9                	mov    %ebx,%ecx
  80090f:	48 ba 81 49 80 00 00 	movabs $0x804981,%rdx
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
  80093e:	48 ba 8a 49 80 00 00 	movabs $0x80498a,%rdx
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
  800998:	49 bc 8d 49 80 00 00 	movabs $0x80498d,%r12
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
  80169e:	48 ba 48 4c 80 00 00 	movabs $0x804c48,%rdx
  8016a5:	00 00 00 
  8016a8:	be 23 00 00 00       	mov    $0x23,%esi
  8016ad:	48 bf 65 4c 80 00 00 	movabs $0x804c65,%rdi
  8016b4:	00 00 00 
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bc:	49 b9 79 42 80 00 00 	movabs $0x804279,%r9
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

0000000000801a89 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801a89:	55                   	push   %rbp
  801a8a:	48 89 e5             	mov    %rsp,%rbp
  801a8d:	48 83 ec 20          	sub    $0x20,%rsp
  801a91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801a99:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa8:	00 
  801aa9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aaf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aba:	89 c6                	mov    %eax,%esi
  801abc:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ac1:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801ac8:	00 00 00 
  801acb:	ff d0                	callq  *%rax
}
  801acd:	c9                   	leaveq 
  801ace:	c3                   	retq   

0000000000801acf <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801acf:	55                   	push   %rbp
  801ad0:	48 89 e5             	mov    %rsp,%rbp
  801ad3:	48 83 ec 20          	sub    $0x20,%rsp
  801ad7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801adb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aee:	00 
  801aef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b00:	89 c6                	mov    %eax,%esi
  801b02:	bf 10 00 00 00       	mov    $0x10,%edi
  801b07:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801b0e:	00 00 00 
  801b11:	ff d0                	callq  *%rax
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b24:	00 
  801b25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b36:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3b:	be 00 00 00 00       	mov    $0x0,%esi
  801b40:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b45:	48 b8 46 16 80 00 00 	movabs $0x801646,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	callq  *%rax
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 30          	sub    $0x30,%rsp
  801b5b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b63:	48 8b 00             	mov    (%rax),%rax
  801b66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b72:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b75:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b78:	83 e0 02             	and    $0x2,%eax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	75 4d                	jne    801bcc <pgfault+0x79>
  801b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b83:	48 c1 e8 0c          	shr    $0xc,%rax
  801b87:	48 89 c2             	mov    %rax,%rdx
  801b8a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b91:	01 00 00 
  801b94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b98:	25 00 08 00 00       	and    $0x800,%eax
  801b9d:	48 85 c0             	test   %rax,%rax
  801ba0:	74 2a                	je     801bcc <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ba2:	48 ba 78 4c 80 00 00 	movabs $0x804c78,%rdx
  801ba9:	00 00 00 
  801bac:	be 23 00 00 00       	mov    $0x23,%esi
  801bb1:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801bb8:	00 00 00 
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc0:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801bc7:	00 00 00 
  801bca:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801bcc:	ba 07 00 00 00       	mov    $0x7,%edx
  801bd1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  801bdb:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  801be2:	00 00 00 
  801be5:	ff d0                	callq  *%rax
  801be7:	85 c0                	test   %eax,%eax
  801be9:	0f 85 cd 00 00 00    	jne    801cbc <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c01:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c09:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c0e:	48 89 c6             	mov    %rax,%rsi
  801c11:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c16:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  801c1d:	00 00 00 
  801c20:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801c22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c26:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c2c:	48 89 c1             	mov    %rax,%rcx
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c39:	bf 00 00 00 00       	mov    $0x0,%edi
  801c3e:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801c45:	00 00 00 
  801c48:	ff d0                	callq  *%rax
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	79 2a                	jns    801c78 <pgfault+0x125>
				panic("Page map at temp address failed");
  801c4e:	48 ba b8 4c 80 00 00 	movabs $0x804cb8,%rdx
  801c55:	00 00 00 
  801c58:	be 30 00 00 00       	mov    $0x30,%esi
  801c5d:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801c64:	00 00 00 
  801c67:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6c:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801c73:	00 00 00 
  801c76:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c78:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c82:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	79 54                	jns    801ce6 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c92:	48 ba d8 4c 80 00 00 	movabs $0x804cd8,%rdx
  801c99:	00 00 00 
  801c9c:	be 32 00 00 00       	mov    $0x32,%esi
  801ca1:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801ca8:	00 00 00 
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb0:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801cb7:	00 00 00 
  801cba:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801cbc:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  801cc3:	00 00 00 
  801cc6:	be 34 00 00 00       	mov    $0x34,%esi
  801ccb:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801cd2:	00 00 00 
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cda:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801ce1:	00 00 00 
  801ce4:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801ce6:	c9                   	leaveq 
  801ce7:	c3                   	retq   

0000000000801ce8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ce8:	55                   	push   %rbp
  801ce9:	48 89 e5             	mov    %rsp,%rbp
  801cec:	48 83 ec 20          	sub    $0x20,%rsp
  801cf0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cf3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cf6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cfd:	01 00 00 
  801d00:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d07:	25 07 0e 00 00       	and    $0xe07,%eax
  801d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801d0f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d12:	48 c1 e0 0c          	shl    $0xc,%rax
  801d16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1d:	25 00 04 00 00       	and    $0x400,%eax
  801d22:	85 c0                	test   %eax,%eax
  801d24:	74 57                	je     801d7d <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d26:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d29:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d34:	41 89 f0             	mov    %esi,%r8d
  801d37:	48 89 c6             	mov    %rax,%rsi
  801d3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3f:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	0f 8e 52 01 00 00    	jle    801ea5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d53:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801d5a:	00 00 00 
  801d5d:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d62:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801d69:	00 00 00 
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801d78:	00 00 00 
  801d7b:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d80:	83 e0 02             	and    $0x2,%eax
  801d83:	85 c0                	test   %eax,%eax
  801d85:	75 10                	jne    801d97 <duppage+0xaf>
  801d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8a:	25 00 08 00 00       	and    $0x800,%eax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	0f 84 bb 00 00 00    	je     801e52 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9a:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d9f:	80 cc 08             	or     $0x8,%ah
  801da2:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801da5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801da8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801daf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db3:	41 89 f0             	mov    %esi,%r8d
  801db6:	48 89 c6             	mov    %rax,%rsi
  801db9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbe:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801dc5:	00 00 00 
  801dc8:	ff d0                	callq  *%rax
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	7e 2a                	jle    801df8 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801dce:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801dd5:	00 00 00 
  801dd8:	be 55 00 00 00       	mov    $0x55,%esi
  801ddd:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801de4:	00 00 00 
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801df3:	00 00 00 
  801df6:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801df8:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801dfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e03:	41 89 c8             	mov    %ecx,%r8d
  801e06:	48 89 d1             	mov    %rdx,%rcx
  801e09:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0e:	48 89 c6             	mov    %rax,%rsi
  801e11:	bf 00 00 00 00       	mov    $0x0,%edi
  801e16:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	callq  *%rax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	7e 2a                	jle    801e50 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801e26:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801e2d:	00 00 00 
  801e30:	be 57 00 00 00       	mov    $0x57,%esi
  801e35:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801e3c:	00 00 00 
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801e4b:	00 00 00 
  801e4e:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e50:	eb 53                	jmp    801ea5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e52:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e55:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e59:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e60:	41 89 f0             	mov    %esi,%r8d
  801e63:	48 89 c6             	mov    %rax,%rsi
  801e66:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6b:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
  801e77:	85 c0                	test   %eax,%eax
  801e79:	7e 2a                	jle    801ea5 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e7b:	48 ba 32 4d 80 00 00 	movabs $0x804d32,%rdx
  801e82:	00 00 00 
  801e85:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e8a:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801e91:	00 00 00 
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  801ea0:	00 00 00 
  801ea3:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eaa:	c9                   	leaveq 
  801eab:	c3                   	retq   

0000000000801eac <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801eac:	55                   	push   %rbp
  801ead:	48 89 e5             	mov    %rsp,%rbp
  801eb0:	48 83 ec 18          	sub    $0x18,%rsp
  801eb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec4:	48 c1 e8 27          	shr    $0x27,%rax
  801ec8:	48 89 c2             	mov    %rax,%rdx
  801ecb:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ed2:	01 00 00 
  801ed5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed9:	83 e0 01             	and    $0x1,%eax
  801edc:	48 85 c0             	test   %rax,%rax
  801edf:	74 51                	je     801f32 <pt_is_mapped+0x86>
  801ee1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee9:	48 c1 e8 1e          	shr    $0x1e,%rax
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ef7:	01 00 00 
  801efa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801efe:	83 e0 01             	and    $0x1,%eax
  801f01:	48 85 c0             	test   %rax,%rax
  801f04:	74 2c                	je     801f32 <pt_is_mapped+0x86>
  801f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f0e:	48 c1 e8 15          	shr    $0x15,%rax
  801f12:	48 89 c2             	mov    %rax,%rdx
  801f15:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f1c:	01 00 00 
  801f1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f23:	83 e0 01             	and    $0x1,%eax
  801f26:	48 85 c0             	test   %rax,%rax
  801f29:	74 07                	je     801f32 <pt_is_mapped+0x86>
  801f2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f30:	eb 05                	jmp    801f37 <pt_is_mapped+0x8b>
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
  801f37:	83 e0 01             	and    $0x1,%eax
}
  801f3a:	c9                   	leaveq 
  801f3b:	c3                   	retq   

0000000000801f3c <fork>:

envid_t
fork(void)
{
  801f3c:	55                   	push   %rbp
  801f3d:	48 89 e5             	mov    %rsp,%rbp
  801f40:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f44:	48 bf 53 1b 80 00 00 	movabs $0x801b53,%rdi
  801f4b:	00 00 00 
  801f4e:	48 b8 8d 43 80 00 00 	movabs $0x80438d,%rax
  801f55:	00 00 00 
  801f58:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f5a:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5f:	cd 30                	int    $0x30
  801f61:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f64:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f67:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f6e:	79 30                	jns    801fa0 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f73:	89 c1                	mov    %eax,%ecx
  801f75:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  801f7c:	00 00 00 
  801f7f:	be 86 00 00 00       	mov    $0x86,%esi
  801f84:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  801f8b:	00 00 00 
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	49 b8 79 42 80 00 00 	movabs $0x804279,%r8
  801f9a:	00 00 00 
  801f9d:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801fa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fa4:	75 46                	jne    801fec <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801fa6:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
  801fb2:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fb7:	48 63 d0             	movslq %eax,%rdx
  801fba:	48 89 d0             	mov    %rdx,%rax
  801fbd:	48 c1 e0 03          	shl    $0x3,%rax
  801fc1:	48 01 d0             	add    %rdx,%rax
  801fc4:	48 c1 e0 05          	shl    $0x5,%rax
  801fc8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fcf:	00 00 00 
  801fd2:	48 01 c2             	add    %rax,%rdx
  801fd5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fdc:	00 00 00 
  801fdf:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	e9 d1 01 00 00       	jmpq   8021bd <fork+0x281>
	}
	uint64_t ad = 0;
  801fec:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801ff3:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801ff4:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801ff9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801ffd:	e9 df 00 00 00       	jmpq   8020e1 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802006:	48 c1 e8 27          	shr    $0x27,%rax
  80200a:	48 89 c2             	mov    %rax,%rdx
  80200d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802014:	01 00 00 
  802017:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201b:	83 e0 01             	and    $0x1,%eax
  80201e:	48 85 c0             	test   %rax,%rax
  802021:	0f 84 9e 00 00 00    	je     8020c5 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80202f:	48 89 c2             	mov    %rax,%rdx
  802032:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802039:	01 00 00 
  80203c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802040:	83 e0 01             	and    $0x1,%eax
  802043:	48 85 c0             	test   %rax,%rax
  802046:	74 73                	je     8020bb <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204c:	48 c1 e8 15          	shr    $0x15,%rax
  802050:	48 89 c2             	mov    %rax,%rdx
  802053:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205a:	01 00 00 
  80205d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802061:	83 e0 01             	and    $0x1,%eax
  802064:	48 85 c0             	test   %rax,%rax
  802067:	74 48                	je     8020b1 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206d:	48 c1 e8 0c          	shr    $0xc,%rax
  802071:	48 89 c2             	mov    %rax,%rdx
  802074:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207b:	01 00 00 
  80207e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802082:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208a:	83 e0 01             	and    $0x1,%eax
  80208d:	48 85 c0             	test   %rax,%rax
  802090:	74 47                	je     8020d9 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802096:	48 c1 e8 0c          	shr    $0xc,%rax
  80209a:	89 c2                	mov    %eax,%edx
  80209c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80209f:	89 d6                	mov    %edx,%esi
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	48 b8 e8 1c 80 00 00 	movabs $0x801ce8,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
  8020af:	eb 28                	jmp    8020d9 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8020b1:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8020b8:	00 
  8020b9:	eb 1e                	jmp    8020d9 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8020bb:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  8020c2:	40 
  8020c3:	eb 14                	jmp    8020d9 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  8020c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c9:	48 c1 e8 27          	shr    $0x27,%rax
  8020cd:	48 83 c0 01          	add    $0x1,%rax
  8020d1:	48 c1 e0 27          	shl    $0x27,%rax
  8020d5:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020d9:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020e0:	00 
  8020e1:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020e8:	00 
  8020e9:	0f 87 13 ff ff ff    	ja     802002 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8020f7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020fc:	89 c7                	mov    %eax,%edi
  8020fe:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802105:	00 00 00 
  802108:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80210a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80210d:	ba 07 00 00 00       	mov    $0x7,%edx
  802112:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802125:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802128:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80212e:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80213d:	89 c7                	mov    %eax,%edi
  80213f:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80214b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802150:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802155:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80215a:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802166:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80216b:	bf 00 00 00 00       	mov    $0x0,%edi
  802170:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802177:	00 00 00 
  80217a:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80217c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802183:	00 00 00 
  802186:	48 8b 00             	mov    (%rax),%rax
  802189:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802190:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802193:	48 89 d6             	mov    %rdx,%rsi
  802196:	89 c7                	mov    %eax,%edi
  802198:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8021a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021a7:	be 02 00 00 00       	mov    $0x2,%esi
  8021ac:	89 c7                	mov    %eax,%edi
  8021ae:	48 b8 11 19 80 00 00 	movabs $0x801911,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax

	return envid;
  8021ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  8021bd:	c9                   	leaveq 
  8021be:	c3                   	retq   

00000000008021bf <sfork>:

	
// Challenge!
int
sfork(void)
{
  8021bf:	55                   	push   %rbp
  8021c0:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021c3:	48 ba 68 4d 80 00 00 	movabs $0x804d68,%rdx
  8021ca:	00 00 00 
  8021cd:	be bf 00 00 00       	mov    $0xbf,%esi
  8021d2:	48 bf ad 4c 80 00 00 	movabs $0x804cad,%rdi
  8021d9:	00 00 00 
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  8021e8:	00 00 00 
  8021eb:	ff d1                	callq  *%rcx

00000000008021ed <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021ed:	55                   	push   %rbp
  8021ee:	48 89 e5             	mov    %rsp,%rbp
  8021f1:	48 83 ec 08          	sub    $0x8,%rsp
  8021f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021fd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802204:	ff ff ff 
  802207:	48 01 d0             	add    %rdx,%rax
  80220a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 08          	sub    $0x8,%rsp
  802218:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80221c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802220:	48 89 c7             	mov    %rax,%rdi
  802223:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax
  80222f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802235:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802239:	c9                   	leaveq 
  80223a:	c3                   	retq   

000000000080223b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80223b:	55                   	push   %rbp
  80223c:	48 89 e5             	mov    %rsp,%rbp
  80223f:	48 83 ec 18          	sub    $0x18,%rsp
  802243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802247:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80224e:	eb 6b                	jmp    8022bb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802250:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802253:	48 98                	cltq   
  802255:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80225b:	48 c1 e0 0c          	shl    $0xc,%rax
  80225f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802267:	48 c1 e8 15          	shr    $0x15,%rax
  80226b:	48 89 c2             	mov    %rax,%rdx
  80226e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802275:	01 00 00 
  802278:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80227c:	83 e0 01             	and    $0x1,%eax
  80227f:	48 85 c0             	test   %rax,%rax
  802282:	74 21                	je     8022a5 <fd_alloc+0x6a>
  802284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802288:	48 c1 e8 0c          	shr    $0xc,%rax
  80228c:	48 89 c2             	mov    %rax,%rdx
  80228f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802296:	01 00 00 
  802299:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229d:	83 e0 01             	and    $0x1,%eax
  8022a0:	48 85 c0             	test   %rax,%rax
  8022a3:	75 12                	jne    8022b7 <fd_alloc+0x7c>
			*fd_store = fd;
  8022a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022ad:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b5:	eb 1a                	jmp    8022d1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022bb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022bf:	7e 8f                	jle    802250 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8022c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8022cc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8022d1:	c9                   	leaveq 
  8022d2:	c3                   	retq   

00000000008022d3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8022d3:	55                   	push   %rbp
  8022d4:	48 89 e5             	mov    %rsp,%rbp
  8022d7:	48 83 ec 20          	sub    $0x20,%rsp
  8022db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8022e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022e6:	78 06                	js     8022ee <fd_lookup+0x1b>
  8022e8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8022ec:	7e 07                	jle    8022f5 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022f3:	eb 6c                	jmp    802361 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022f8:	48 98                	cltq   
  8022fa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802300:	48 c1 e0 0c          	shl    $0xc,%rax
  802304:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230c:	48 c1 e8 15          	shr    $0x15,%rax
  802310:	48 89 c2             	mov    %rax,%rdx
  802313:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80231a:	01 00 00 
  80231d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802321:	83 e0 01             	and    $0x1,%eax
  802324:	48 85 c0             	test   %rax,%rax
  802327:	74 21                	je     80234a <fd_lookup+0x77>
  802329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80232d:	48 c1 e8 0c          	shr    $0xc,%rax
  802331:	48 89 c2             	mov    %rax,%rdx
  802334:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80233b:	01 00 00 
  80233e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802342:	83 e0 01             	and    $0x1,%eax
  802345:	48 85 c0             	test   %rax,%rax
  802348:	75 07                	jne    802351 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80234a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234f:	eb 10                	jmp    802361 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802355:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802359:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802361:	c9                   	leaveq 
  802362:	c3                   	retq   

0000000000802363 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802363:	55                   	push   %rbp
  802364:	48 89 e5             	mov    %rsp,%rbp
  802367:	48 83 ec 30          	sub    $0x30,%rsp
  80236b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80236f:	89 f0                	mov    %esi,%eax
  802371:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802378:	48 89 c7             	mov    %rax,%rdi
  80237b:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  802382:	00 00 00 
  802385:	ff d0                	callq  *%rax
  802387:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80238b:	48 89 d6             	mov    %rdx,%rsi
  80238e:	89 c7                	mov    %eax,%edi
  802390:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
  80239c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a3:	78 0a                	js     8023af <fd_close+0x4c>
	    || fd != fd2)
  8023a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023ad:	74 12                	je     8023c1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023af:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023b3:	74 05                	je     8023ba <fd_close+0x57>
  8023b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b8:	eb 05                	jmp    8023bf <fd_close+0x5c>
  8023ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bf:	eb 69                	jmp    80242a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c5:	8b 00                	mov    (%rax),%eax
  8023c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023cb:	48 89 d6             	mov    %rdx,%rsi
  8023ce:	89 c7                	mov    %eax,%edi
  8023d0:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  8023d7:	00 00 00 
  8023da:	ff d0                	callq  *%rax
  8023dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e3:	78 2a                	js     80240f <fd_close+0xac>
		if (dev->dev_close)
  8023e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023ed:	48 85 c0             	test   %rax,%rax
  8023f0:	74 16                	je     802408 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023fe:	48 89 d7             	mov    %rdx,%rdi
  802401:	ff d0                	callq  *%rax
  802403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802406:	eb 07                	jmp    80240f <fd_close+0xac>
		else
			r = 0;
  802408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80240f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802413:	48 89 c6             	mov    %rax,%rsi
  802416:	bf 00 00 00 00       	mov    $0x0,%edi
  80241b:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
	return r;
  802427:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80242a:	c9                   	leaveq 
  80242b:	c3                   	retq   

000000000080242c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80242c:	55                   	push   %rbp
  80242d:	48 89 e5             	mov    %rsp,%rbp
  802430:	48 83 ec 20          	sub    $0x20,%rsp
  802434:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802437:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80243b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802442:	eb 41                	jmp    802485 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802444:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80244b:	00 00 00 
  80244e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802451:	48 63 d2             	movslq %edx,%rdx
  802454:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802458:	8b 00                	mov    (%rax),%eax
  80245a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80245d:	75 22                	jne    802481 <dev_lookup+0x55>
			*dev = devtab[i];
  80245f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802466:	00 00 00 
  802469:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80246c:	48 63 d2             	movslq %edx,%rdx
  80246f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802477:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
  80247f:	eb 60                	jmp    8024e1 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802481:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802485:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80248c:	00 00 00 
  80248f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802492:	48 63 d2             	movslq %edx,%rdx
  802495:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802499:	48 85 c0             	test   %rax,%rax
  80249c:	75 a6                	jne    802444 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80249e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024a5:	00 00 00 
  8024a8:	48 8b 00             	mov    (%rax),%rax
  8024ab:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024b4:	89 c6                	mov    %eax,%esi
  8024b6:	48 bf 80 4d 80 00 00 	movabs $0x804d80,%rdi
  8024bd:	00 00 00 
  8024c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c5:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8024cc:	00 00 00 
  8024cf:	ff d1                	callq  *%rcx
	*dev = 0;
  8024d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8024dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8024e1:	c9                   	leaveq 
  8024e2:	c3                   	retq   

00000000008024e3 <close>:

int
close(int fdnum)
{
  8024e3:	55                   	push   %rbp
  8024e4:	48 89 e5             	mov    %rsp,%rbp
  8024e7:	48 83 ec 20          	sub    $0x20,%rsp
  8024eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024f5:	48 89 d6             	mov    %rdx,%rsi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	79 05                	jns    802514 <close+0x31>
		return r;
  80250f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802512:	eb 18                	jmp    80252c <close+0x49>
	else
		return fd_close(fd, 1);
  802514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802518:	be 01 00 00 00       	mov    $0x1,%esi
  80251d:	48 89 c7             	mov    %rax,%rdi
  802520:	48 b8 63 23 80 00 00 	movabs $0x802363,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <close_all>:

void
close_all(void)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80253d:	eb 15                	jmp    802554 <close_all+0x26>
		close(i);
  80253f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802542:	89 c7                	mov    %eax,%edi
  802544:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802550:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802554:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802558:	7e e5                	jle    80253f <close_all+0x11>
		close(i);
}
  80255a:	c9                   	leaveq 
  80255b:	c3                   	retq   

000000000080255c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80255c:	55                   	push   %rbp
  80255d:	48 89 e5             	mov    %rsp,%rbp
  802560:	48 83 ec 40          	sub    $0x40,%rsp
  802564:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802567:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80256a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80256e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802571:	48 89 d6             	mov    %rdx,%rsi
  802574:	89 c7                	mov    %eax,%edi
  802576:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  80257d:	00 00 00 
  802580:	ff d0                	callq  *%rax
  802582:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802589:	79 08                	jns    802593 <dup+0x37>
		return r;
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258e:	e9 70 01 00 00       	jmpq   802703 <dup+0x1a7>
	close(newfdnum);
  802593:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802596:	89 c7                	mov    %eax,%edi
  802598:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025a4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025a7:	48 98                	cltq   
  8025a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025af:	48 c1 e0 0c          	shl    $0xc,%rax
  8025b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bb:	48 89 c7             	mov    %rax,%rdi
  8025be:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	callq  *%rax
  8025ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8025ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d2:	48 89 c7             	mov    %rax,%rdi
  8025d5:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  8025dc:	00 00 00 
  8025df:	ff d0                	callq  *%rax
  8025e1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8025e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e9:	48 c1 e8 15          	shr    $0x15,%rax
  8025ed:	48 89 c2             	mov    %rax,%rdx
  8025f0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025f7:	01 00 00 
  8025fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fe:	83 e0 01             	and    $0x1,%eax
  802601:	48 85 c0             	test   %rax,%rax
  802604:	74 73                	je     802679 <dup+0x11d>
  802606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260a:	48 c1 e8 0c          	shr    $0xc,%rax
  80260e:	48 89 c2             	mov    %rax,%rdx
  802611:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802618:	01 00 00 
  80261b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261f:	83 e0 01             	and    $0x1,%eax
  802622:	48 85 c0             	test   %rax,%rax
  802625:	74 52                	je     802679 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262b:	48 c1 e8 0c          	shr    $0xc,%rax
  80262f:	48 89 c2             	mov    %rax,%rdx
  802632:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802639:	01 00 00 
  80263c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802640:	25 07 0e 00 00       	and    $0xe07,%eax
  802645:	89 c1                	mov    %eax,%ecx
  802647:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264f:	41 89 c8             	mov    %ecx,%r8d
  802652:	48 89 d1             	mov    %rdx,%rcx
  802655:	ba 00 00 00 00       	mov    $0x0,%edx
  80265a:	48 89 c6             	mov    %rax,%rsi
  80265d:	bf 00 00 00 00       	mov    $0x0,%edi
  802662:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
  80266e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802675:	79 02                	jns    802679 <dup+0x11d>
			goto err;
  802677:	eb 57                	jmp    8026d0 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80267d:	48 c1 e8 0c          	shr    $0xc,%rax
  802681:	48 89 c2             	mov    %rax,%rdx
  802684:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80268b:	01 00 00 
  80268e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802692:	25 07 0e 00 00       	and    $0xe07,%eax
  802697:	89 c1                	mov    %eax,%ecx
  802699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80269d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026a1:	41 89 c8             	mov    %ecx,%r8d
  8026a4:	48 89 d1             	mov    %rdx,%rcx
  8026a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ac:	48 89 c6             	mov    %rax,%rsi
  8026af:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b4:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c7:	79 02                	jns    8026cb <dup+0x16f>
		goto err;
  8026c9:	eb 05                	jmp    8026d0 <dup+0x174>

	return newfdnum;
  8026cb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ce:	eb 33                	jmp    802703 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8026d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d4:	48 89 c6             	mov    %rax,%rsi
  8026d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026dc:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8026e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ec:	48 89 c6             	mov    %rax,%rsi
  8026ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f4:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax
	return r;
  802700:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802703:	c9                   	leaveq 
  802704:	c3                   	retq   

0000000000802705 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802705:	55                   	push   %rbp
  802706:	48 89 e5             	mov    %rsp,%rbp
  802709:	48 83 ec 40          	sub    $0x40,%rsp
  80270d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802710:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802714:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802718:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80271c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80271f:	48 89 d6             	mov    %rdx,%rsi
  802722:	89 c7                	mov    %eax,%edi
  802724:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  80272b:	00 00 00 
  80272e:	ff d0                	callq  *%rax
  802730:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802733:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802737:	78 24                	js     80275d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273d:	8b 00                	mov    (%rax),%eax
  80273f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802743:	48 89 d6             	mov    %rdx,%rsi
  802746:	89 c7                	mov    %eax,%edi
  802748:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax
  802754:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802757:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275b:	79 05                	jns    802762 <read+0x5d>
		return r;
  80275d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802760:	eb 76                	jmp    8027d8 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	8b 40 08             	mov    0x8(%rax),%eax
  802769:	83 e0 03             	and    $0x3,%eax
  80276c:	83 f8 01             	cmp    $0x1,%eax
  80276f:	75 3a                	jne    8027ab <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802771:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802778:	00 00 00 
  80277b:	48 8b 00             	mov    (%rax),%rax
  80277e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802784:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802787:	89 c6                	mov    %eax,%esi
  802789:	48 bf 9f 4d 80 00 00 	movabs $0x804d9f,%rdi
  802790:	00 00 00 
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  80279f:	00 00 00 
  8027a2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027a9:	eb 2d                	jmp    8027d8 <read+0xd3>
	}
	if (!dev->dev_read)
  8027ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027af:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027b3:	48 85 c0             	test   %rax,%rax
  8027b6:	75 07                	jne    8027bf <read+0xba>
		return -E_NOT_SUPP;
  8027b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027bd:	eb 19                	jmp    8027d8 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8027bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027c7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027cb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027cf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027d3:	48 89 cf             	mov    %rcx,%rdi
  8027d6:	ff d0                	callq  *%rax
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 30          	sub    $0x30,%rsp
  8027e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f4:	eb 49                	jmp    80283f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f9:	48 98                	cltq   
  8027fb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ff:	48 29 c2             	sub    %rax,%rdx
  802802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802805:	48 63 c8             	movslq %eax,%rcx
  802808:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280c:	48 01 c1             	add    %rax,%rcx
  80280f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802812:	48 89 ce             	mov    %rcx,%rsi
  802815:	89 c7                	mov    %eax,%edi
  802817:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802826:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80282a:	79 05                	jns    802831 <readn+0x57>
			return m;
  80282c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80282f:	eb 1c                	jmp    80284d <readn+0x73>
		if (m == 0)
  802831:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802835:	75 02                	jne    802839 <readn+0x5f>
			break;
  802837:	eb 11                	jmp    80284a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802839:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80283c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80283f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802842:	48 98                	cltq   
  802844:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802848:	72 ac                	jb     8027f6 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80284a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80284d:	c9                   	leaveq 
  80284e:	c3                   	retq   

000000000080284f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80284f:	55                   	push   %rbp
  802850:	48 89 e5             	mov    %rsp,%rbp
  802853:	48 83 ec 40          	sub    $0x40,%rsp
  802857:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80285a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80285e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802862:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802866:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802869:	48 89 d6             	mov    %rdx,%rsi
  80286c:	89 c7                	mov    %eax,%edi
  80286e:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802875:	00 00 00 
  802878:	ff d0                	callq  *%rax
  80287a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802881:	78 24                	js     8028a7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802883:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802887:	8b 00                	mov    (%rax),%eax
  802889:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80288d:	48 89 d6             	mov    %rdx,%rsi
  802890:	89 c7                	mov    %eax,%edi
  802892:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
  80289e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a5:	79 05                	jns    8028ac <write+0x5d>
		return r;
  8028a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028aa:	eb 75                	jmp    802921 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028b0:	8b 40 08             	mov    0x8(%rax),%eax
  8028b3:	83 e0 03             	and    $0x3,%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	75 3a                	jne    8028f4 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028ba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028c1:	00 00 00 
  8028c4:	48 8b 00             	mov    (%rax),%rax
  8028c7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028cd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028d0:	89 c6                	mov    %eax,%esi
  8028d2:	48 bf bb 4d 80 00 00 	movabs $0x804dbb,%rdi
  8028d9:	00 00 00 
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e1:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8028e8:	00 00 00 
  8028eb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f2:	eb 2d                	jmp    802921 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8028f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028fc:	48 85 c0             	test   %rax,%rax
  8028ff:	75 07                	jne    802908 <write+0xb9>
		return -E_NOT_SUPP;
  802901:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802906:	eb 19                	jmp    802921 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802910:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802914:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802918:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80291c:	48 89 cf             	mov    %rcx,%rdi
  80291f:	ff d0                	callq  *%rax
}
  802921:	c9                   	leaveq 
  802922:	c3                   	retq   

0000000000802923 <seek>:

int
seek(int fdnum, off_t offset)
{
  802923:	55                   	push   %rbp
  802924:	48 89 e5             	mov    %rsp,%rbp
  802927:	48 83 ec 18          	sub    $0x18,%rsp
  80292b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80292e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802931:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802935:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802938:	48 89 d6             	mov    %rdx,%rsi
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802950:	79 05                	jns    802957 <seek+0x34>
		return r;
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	eb 0f                	jmp    802966 <seek+0x43>
	fd->fd_offset = offset;
  802957:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80295e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802966:	c9                   	leaveq 
  802967:	c3                   	retq   

0000000000802968 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802968:	55                   	push   %rbp
  802969:	48 89 e5             	mov    %rsp,%rbp
  80296c:	48 83 ec 30          	sub    $0x30,%rsp
  802970:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802973:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802976:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80297d:	48 89 d6             	mov    %rdx,%rsi
  802980:	89 c7                	mov    %eax,%edi
  802982:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax
  80298e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802991:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802995:	78 24                	js     8029bb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299b:	8b 00                	mov    (%rax),%eax
  80299d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a1:	48 89 d6             	mov    %rdx,%rsi
  8029a4:	89 c7                	mov    %eax,%edi
  8029a6:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
  8029b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b9:	79 05                	jns    8029c0 <ftruncate+0x58>
		return r;
  8029bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029be:	eb 72                	jmp    802a32 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c4:	8b 40 08             	mov    0x8(%rax),%eax
  8029c7:	83 e0 03             	and    $0x3,%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	75 3a                	jne    802a08 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8029ce:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029d5:	00 00 00 
  8029d8:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8029db:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e4:	89 c6                	mov    %eax,%esi
  8029e6:	48 bf d8 4d 80 00 00 	movabs $0x804dd8,%rdi
  8029ed:	00 00 00 
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	48 b9 38 03 80 00 00 	movabs $0x800338,%rcx
  8029fc:	00 00 00 
  8029ff:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a06:	eb 2a                	jmp    802a32 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a10:	48 85 c0             	test   %rax,%rax
  802a13:	75 07                	jne    802a1c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a15:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1a:	eb 16                	jmp    802a32 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a20:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a28:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a2b:	89 ce                	mov    %ecx,%esi
  802a2d:	48 89 d7             	mov    %rdx,%rdi
  802a30:	ff d0                	callq  *%rax
}
  802a32:	c9                   	leaveq 
  802a33:	c3                   	retq   

0000000000802a34 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a34:	55                   	push   %rbp
  802a35:	48 89 e5             	mov    %rsp,%rbp
  802a38:	48 83 ec 30          	sub    $0x30,%rsp
  802a3c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a43:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a47:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a4a:	48 89 d6             	mov    %rdx,%rsi
  802a4d:	89 c7                	mov    %eax,%edi
  802a4f:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	callq  *%rax
  802a5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a62:	78 24                	js     802a88 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a68:	8b 00                	mov    (%rax),%eax
  802a6a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a6e:	48 89 d6             	mov    %rdx,%rsi
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	48 b8 2c 24 80 00 00 	movabs $0x80242c,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
  802a7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a86:	79 05                	jns    802a8d <fstat+0x59>
		return r;
  802a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8b:	eb 5e                	jmp    802aeb <fstat+0xb7>
	if (!dev->dev_stat)
  802a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a91:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a95:	48 85 c0             	test   %rax,%rax
  802a98:	75 07                	jne    802aa1 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a9f:	eb 4a                	jmp    802aeb <fstat+0xb7>
	stat->st_name[0] = 0;
  802aa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802aa8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aac:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ab3:	00 00 00 
	stat->st_isdir = 0;
  802ab6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ac1:	00 00 00 
	stat->st_dev = dev;
  802ac4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ac8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802acc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802adf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ae3:	48 89 ce             	mov    %rcx,%rsi
  802ae6:	48 89 d7             	mov    %rdx,%rdi
  802ae9:	ff d0                	callq  *%rax
}
  802aeb:	c9                   	leaveq 
  802aec:	c3                   	retq   

0000000000802aed <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802aed:	55                   	push   %rbp
  802aee:	48 89 e5             	mov    %rsp,%rbp
  802af1:	48 83 ec 20          	sub    $0x20,%rsp
  802af5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	be 00 00 00 00       	mov    $0x0,%esi
  802b06:	48 89 c7             	mov    %rax,%rdi
  802b09:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  802b10:	00 00 00 
  802b13:	ff d0                	callq  *%rax
  802b15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1c:	79 05                	jns    802b23 <stat+0x36>
		return fd;
  802b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b21:	eb 2f                	jmp    802b52 <stat+0x65>
	r = fstat(fd, stat);
  802b23:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2a:	48 89 d6             	mov    %rdx,%rsi
  802b2d:	89 c7                	mov    %eax,%edi
  802b2f:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	callq  *%rax
  802b3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
	return r;
  802b4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b52:	c9                   	leaveq 
  802b53:	c3                   	retq   

0000000000802b54 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b54:	55                   	push   %rbp
  802b55:	48 89 e5             	mov    %rsp,%rbp
  802b58:	48 83 ec 10          	sub    $0x10,%rsp
  802b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b63:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b6a:	00 00 00 
  802b6d:	8b 00                	mov    (%rax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	75 1d                	jne    802b90 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b73:	bf 01 00 00 00       	mov    $0x1,%edi
  802b78:	48 b8 35 46 80 00 00 	movabs $0x804635,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b8b:	00 00 00 
  802b8e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b90:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b97:	00 00 00 
  802b9a:	8b 00                	mov    (%rax),%eax
  802b9c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b9f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ba4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bab:	00 00 00 
  802bae:	89 c7                	mov    %eax,%edi
  802bb0:	48 b8 d3 45 80 00 00 	movabs $0x8045d3,%rax
  802bb7:	00 00 00 
  802bba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc5:	48 89 c6             	mov    %rax,%rsi
  802bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcd:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 30          	sub    $0x30,%rsp
  802be3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802be7:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802bea:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802bf1:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802bf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802bff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c04:	75 08                	jne    802c0e <open+0x33>
	{
		return r;
  802c06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c09:	e9 f2 00 00 00       	jmpq   802d00 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802c0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c24:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802c2b:	7e 0a                	jle    802c37 <open+0x5c>
	{
		return -E_BAD_PATH;
  802c2d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c32:	e9 c9 00 00 00       	jmpq   802d00 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802c37:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802c3e:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802c3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802c43:	48 89 c7             	mov    %rax,%rdi
  802c46:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
  802c52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c59:	78 09                	js     802c64 <open+0x89>
  802c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5f:	48 85 c0             	test   %rax,%rax
  802c62:	75 08                	jne    802c6c <open+0x91>
		{
			return r;
  802c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c67:	e9 94 00 00 00       	jmpq   802d00 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c70:	ba 00 04 00 00       	mov    $0x400,%edx
  802c75:	48 89 c6             	mov    %rax,%rsi
  802c78:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c7f:	00 00 00 
  802c82:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  802c89:	00 00 00 
  802c8c:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802c8e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c95:	00 00 00 
  802c98:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802c9b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca5:	48 89 c6             	mov    %rax,%rsi
  802ca8:	bf 01 00 00 00       	mov    $0x1,%edi
  802cad:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
  802cb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc0:	79 2b                	jns    802ced <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802cc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc6:	be 00 00 00 00       	mov    $0x0,%esi
  802ccb:	48 89 c7             	mov    %rax,%rdi
  802cce:	48 b8 63 23 80 00 00 	movabs $0x802363,%rax
  802cd5:	00 00 00 
  802cd8:	ff d0                	callq  *%rax
  802cda:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802cdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ce1:	79 05                	jns    802ce8 <open+0x10d>
			{
				return d;
  802ce3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce6:	eb 18                	jmp    802d00 <open+0x125>
			}
			return r;
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	eb 13                	jmp    802d00 <open+0x125>
		}	
		return fd2num(fd_store);
  802ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf1:	48 89 c7             	mov    %rax,%rdi
  802cf4:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802d00:	c9                   	leaveq 
  802d01:	c3                   	retq   

0000000000802d02 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d02:	55                   	push   %rbp
  802d03:	48 89 e5             	mov    %rsp,%rbp
  802d06:	48 83 ec 10          	sub    $0x10,%rsp
  802d0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d12:	8b 50 0c             	mov    0xc(%rax),%edx
  802d15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1c:	00 00 00 
  802d1f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d21:	be 00 00 00 00       	mov    $0x0,%esi
  802d26:	bf 06 00 00 00       	mov    $0x6,%edi
  802d2b:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax
}
  802d37:	c9                   	leaveq 
  802d38:	c3                   	retq   

0000000000802d39 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d39:	55                   	push   %rbp
  802d3a:	48 89 e5             	mov    %rsp,%rbp
  802d3d:	48 83 ec 30          	sub    $0x30,%rsp
  802d41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802d4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802d54:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d59:	74 07                	je     802d62 <devfile_read+0x29>
  802d5b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d60:	75 07                	jne    802d69 <devfile_read+0x30>
		return -E_INVAL;
  802d62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d67:	eb 77                	jmp    802de0 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6d:	8b 50 0c             	mov    0xc(%rax),%edx
  802d70:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d77:	00 00 00 
  802d7a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d7c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d83:	00 00 00 
  802d86:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d8a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802d8e:	be 00 00 00 00       	mov    $0x0,%esi
  802d93:	bf 03 00 00 00       	mov    $0x3,%edi
  802d98:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802d9f:	00 00 00 
  802da2:	ff d0                	callq  *%rax
  802da4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dab:	7f 05                	jg     802db2 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db0:	eb 2e                	jmp    802de0 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	48 63 d0             	movslq %eax,%rdx
  802db8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dbc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dc3:	00 00 00 
  802dc6:	48 89 c7             	mov    %rax,%rdi
  802dc9:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802dd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ddd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802de0:	c9                   	leaveq 
  802de1:	c3                   	retq   

0000000000802de2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802de2:	55                   	push   %rbp
  802de3:	48 89 e5             	mov    %rsp,%rbp
  802de6:	48 83 ec 30          	sub    $0x30,%rsp
  802dea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802df2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802df6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802dfd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e02:	74 07                	je     802e0b <devfile_write+0x29>
  802e04:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e09:	75 08                	jne    802e13 <devfile_write+0x31>
		return r;
  802e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0e:	e9 9a 00 00 00       	jmpq   802ead <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e17:	8b 50 0c             	mov    0xc(%rax),%edx
  802e1a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e21:	00 00 00 
  802e24:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802e26:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e2d:	00 
  802e2e:	76 08                	jbe    802e38 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802e30:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e37:	00 
	}
	fsipcbuf.write.req_n = n;
  802e38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e3f:	00 00 00 
  802e42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e46:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802e4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e52:	48 89 c6             	mov    %rax,%rsi
  802e55:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e5c:	00 00 00 
  802e5f:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802e6b:	be 00 00 00 00       	mov    $0x0,%esi
  802e70:	bf 04 00 00 00       	mov    $0x4,%edi
  802e75:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802e7c:	00 00 00 
  802e7f:	ff d0                	callq  *%rax
  802e81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e88:	7f 20                	jg     802eaa <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802e8a:	48 bf fe 4d 80 00 00 	movabs $0x804dfe,%rdi
  802e91:	00 00 00 
  802e94:	b8 00 00 00 00       	mov    $0x0,%eax
  802e99:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  802ea0:	00 00 00 
  802ea3:	ff d2                	callq  *%rdx
		return r;
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	eb 03                	jmp    802ead <devfile_write+0xcb>
	}
	return r;
  802eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ead:	c9                   	leaveq 
  802eae:	c3                   	retq   

0000000000802eaf <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802eaf:	55                   	push   %rbp
  802eb0:	48 89 e5             	mov    %rsp,%rbp
  802eb3:	48 83 ec 20          	sub    $0x20,%rsp
  802eb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ebb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ec6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ecd:	00 00 00 
  802ed0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ed2:	be 00 00 00 00       	mov    $0x0,%esi
  802ed7:	bf 05 00 00 00       	mov    $0x5,%edi
  802edc:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eef:	79 05                	jns    802ef6 <devfile_stat+0x47>
		return r;
  802ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef4:	eb 56                	jmp    802f4c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802efa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f01:	00 00 00 
  802f04:	48 89 c7             	mov    %rax,%rdi
  802f07:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f13:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f1a:	00 00 00 
  802f1d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f27:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f2d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f34:	00 00 00 
  802f37:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f41:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4c:	c9                   	leaveq 
  802f4d:	c3                   	retq   

0000000000802f4e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f4e:	55                   	push   %rbp
  802f4f:	48 89 e5             	mov    %rsp,%rbp
  802f52:	48 83 ec 10          	sub    $0x10,%rsp
  802f56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f5a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f61:	8b 50 0c             	mov    0xc(%rax),%edx
  802f64:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f6b:	00 00 00 
  802f6e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f70:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f77:	00 00 00 
  802f7a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f7d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f80:	be 00 00 00 00       	mov    $0x0,%esi
  802f85:	bf 02 00 00 00       	mov    $0x2,%edi
  802f8a:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
}
  802f96:	c9                   	leaveq 
  802f97:	c3                   	retq   

0000000000802f98 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f98:	55                   	push   %rbp
  802f99:	48 89 e5             	mov    %rsp,%rbp
  802f9c:	48 83 ec 10          	sub    $0x10,%rsp
  802fa0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fa4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa8:	48 89 c7             	mov    %rax,%rdi
  802fab:	48 b8 81 0e 80 00 00 	movabs $0x800e81,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
  802fb7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fbc:	7e 07                	jle    802fc5 <remove+0x2d>
		return -E_BAD_PATH;
  802fbe:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802fc3:	eb 33                	jmp    802ff8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc9:	48 89 c6             	mov    %rax,%rsi
  802fcc:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802fd3:	00 00 00 
  802fd6:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802fe2:	be 00 00 00 00       	mov    $0x0,%esi
  802fe7:	bf 07 00 00 00       	mov    $0x7,%edi
  802fec:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
}
  802ff8:	c9                   	leaveq 
  802ff9:	c3                   	retq   

0000000000802ffa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ffa:	55                   	push   %rbp
  802ffb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ffe:	be 00 00 00 00       	mov    $0x0,%esi
  803003:	bf 08 00 00 00       	mov    $0x8,%edi
  803008:	48 b8 54 2b 80 00 00 	movabs $0x802b54,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
}
  803014:	5d                   	pop    %rbp
  803015:	c3                   	retq   

0000000000803016 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803016:	55                   	push   %rbp
  803017:	48 89 e5             	mov    %rsp,%rbp
  80301a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803021:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803028:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80302f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803036:	be 00 00 00 00       	mov    $0x0,%esi
  80303b:	48 89 c7             	mov    %rax,%rdi
  80303e:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
  80304a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80304d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803051:	79 28                	jns    80307b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803053:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803056:	89 c6                	mov    %eax,%esi
  803058:	48 bf 1a 4e 80 00 00 	movabs $0x804e1a,%rdi
  80305f:	00 00 00 
  803062:	b8 00 00 00 00       	mov    $0x0,%eax
  803067:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  80306e:	00 00 00 
  803071:	ff d2                	callq  *%rdx
		return fd_src;
  803073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803076:	e9 74 01 00 00       	jmpq   8031ef <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80307b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803082:	be 01 01 00 00       	mov    $0x101,%esi
  803087:	48 89 c7             	mov    %rax,%rdi
  80308a:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803099:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80309d:	79 39                	jns    8030d8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80309f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030a2:	89 c6                	mov    %eax,%esi
  8030a4:	48 bf 30 4e 80 00 00 	movabs $0x804e30,%rdi
  8030ab:	00 00 00 
  8030ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b3:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  8030ba:	00 00 00 
  8030bd:	ff d2                	callq  *%rdx
		close(fd_src);
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	89 c7                	mov    %eax,%edi
  8030c4:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8030cb:	00 00 00 
  8030ce:	ff d0                	callq  *%rax
		return fd_dest;
  8030d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d3:	e9 17 01 00 00       	jmpq   8031ef <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030d8:	eb 74                	jmp    80314e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8030da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030dd:	48 63 d0             	movslq %eax,%rdx
  8030e0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ea:	48 89 ce             	mov    %rcx,%rsi
  8030ed:	89 c7                	mov    %eax,%edi
  8030ef:	48 b8 4f 28 80 00 00 	movabs $0x80284f,%rax
  8030f6:	00 00 00 
  8030f9:	ff d0                	callq  *%rax
  8030fb:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8030fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803102:	79 4a                	jns    80314e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803104:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803107:	89 c6                	mov    %eax,%esi
  803109:	48 bf 4a 4e 80 00 00 	movabs $0x804e4a,%rdi
  803110:	00 00 00 
  803113:	b8 00 00 00 00       	mov    $0x0,%eax
  803118:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  80311f:	00 00 00 
  803122:	ff d2                	callq  *%rdx
			close(fd_src);
  803124:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803127:	89 c7                	mov    %eax,%edi
  803129:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
			close(fd_dest);
  803135:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803138:	89 c7                	mov    %eax,%edi
  80313a:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
			return write_size;
  803146:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803149:	e9 a1 00 00 00       	jmpq   8031ef <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80314e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803158:	ba 00 02 00 00       	mov    $0x200,%edx
  80315d:	48 89 ce             	mov    %rcx,%rsi
  803160:	89 c7                	mov    %eax,%edi
  803162:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
  80316e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803171:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803175:	0f 8f 5f ff ff ff    	jg     8030da <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80317b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80317f:	79 47                	jns    8031c8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803181:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803184:	89 c6                	mov    %eax,%esi
  803186:	48 bf 5d 4e 80 00 00 	movabs $0x804e5d,%rdi
  80318d:	00 00 00 
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
  803195:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  80319c:	00 00 00 
  80319f:	ff d2                	callq  *%rdx
		close(fd_src);
  8031a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a4:	89 c7                	mov    %eax,%edi
  8031a6:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
		close(fd_dest);
  8031b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b5:	89 c7                	mov    %eax,%edi
  8031b7:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
		return read_size;
  8031c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031c6:	eb 27                	jmp    8031ef <copy+0x1d9>
	}
	close(fd_src);
  8031c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cb:	89 c7                	mov    %eax,%edi
  8031cd:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8031d4:	00 00 00 
  8031d7:	ff d0                	callq  *%rax
	close(fd_dest);
  8031d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031dc:	89 c7                	mov    %eax,%edi
  8031de:	48 b8 e3 24 80 00 00 	movabs $0x8024e3,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	callq  *%rax
	return 0;
  8031ea:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
  8031f5:	48 83 ec 20          	sub    $0x20,%rsp
  8031f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031fc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803200:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803203:	48 89 d6             	mov    %rdx,%rsi
  803206:	89 c7                	mov    %eax,%edi
  803208:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321b:	79 05                	jns    803222 <fd2sockid+0x31>
		return r;
  80321d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803220:	eb 24                	jmp    803246 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803226:	8b 10                	mov    (%rax),%edx
  803228:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80322f:	00 00 00 
  803232:	8b 00                	mov    (%rax),%eax
  803234:	39 c2                	cmp    %eax,%edx
  803236:	74 07                	je     80323f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803238:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80323d:	eb 07                	jmp    803246 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80323f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803243:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
  80324c:	48 83 ec 20          	sub    $0x20,%rsp
  803250:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803253:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803257:	48 89 c7             	mov    %rax,%rdi
  80325a:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  803261:	00 00 00 
  803264:	ff d0                	callq  *%rax
  803266:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803269:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326d:	78 26                	js     803295 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80326f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803273:	ba 07 04 00 00       	mov    $0x407,%edx
  803278:	48 89 c6             	mov    %rax,%rsi
  80327b:	bf 00 00 00 00       	mov    $0x0,%edi
  803280:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803293:	79 16                	jns    8032ab <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803295:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803298:	89 c7                	mov    %eax,%edi
  80329a:	48 b8 55 37 80 00 00 	movabs $0x803755,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
		return r;
  8032a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a9:	eb 3a                	jmp    8032e5 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032af:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032b6:	00 00 00 
  8032b9:	8b 12                	mov    (%rdx),%edx
  8032bb:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032cf:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
}
  8032e5:	c9                   	leaveq 
  8032e6:	c3                   	retq   

00000000008032e7 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032e7:	55                   	push   %rbp
  8032e8:	48 89 e5             	mov    %rsp,%rbp
  8032eb:	48 83 ec 30          	sub    $0x30,%rsp
  8032ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032fd:	89 c7                	mov    %eax,%edi
  8032ff:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  803306:	00 00 00 
  803309:	ff d0                	callq  *%rax
  80330b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803312:	79 05                	jns    803319 <accept+0x32>
		return r;
  803314:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803317:	eb 3b                	jmp    803354 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803319:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80331d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	48 89 ce             	mov    %rcx,%rsi
  803327:	89 c7                	mov    %eax,%edi
  803329:	48 b8 32 36 80 00 00 	movabs $0x803632,%rax
  803330:	00 00 00 
  803333:	ff d0                	callq  *%rax
  803335:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803338:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333c:	79 05                	jns    803343 <accept+0x5c>
		return r;
  80333e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803341:	eb 11                	jmp    803354 <accept+0x6d>
	return alloc_sockfd(r);
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803346:	89 c7                	mov    %eax,%edi
  803348:	48 b8 48 32 80 00 00 	movabs $0x803248,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
}
  803354:	c9                   	leaveq 
  803355:	c3                   	retq   

0000000000803356 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803356:	55                   	push   %rbp
  803357:	48 89 e5             	mov    %rsp,%rbp
  80335a:	48 83 ec 20          	sub    $0x20,%rsp
  80335e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803361:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803365:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336b:	89 c7                	mov    %eax,%edi
  80336d:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803380:	79 05                	jns    803387 <bind+0x31>
		return r;
  803382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803385:	eb 1b                	jmp    8033a2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803387:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80338a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80338e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803391:	48 89 ce             	mov    %rcx,%rsi
  803394:	89 c7                	mov    %eax,%edi
  803396:	48 b8 b1 36 80 00 00 	movabs $0x8036b1,%rax
  80339d:	00 00 00 
  8033a0:	ff d0                	callq  *%rax
}
  8033a2:	c9                   	leaveq 
  8033a3:	c3                   	retq   

00000000008033a4 <shutdown>:

int
shutdown(int s, int how)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 83 ec 20          	sub    $0x20,%rsp
  8033ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033af:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b5:	89 c7                	mov    %eax,%edi
  8033b7:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  8033be:	00 00 00 
  8033c1:	ff d0                	callq  *%rax
  8033c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ca:	79 05                	jns    8033d1 <shutdown+0x2d>
		return r;
  8033cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cf:	eb 16                	jmp    8033e7 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033d1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d7:	89 d6                	mov    %edx,%esi
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
}
  8033e7:	c9                   	leaveq 
  8033e8:	c3                   	retq   

00000000008033e9 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033e9:	55                   	push   %rbp
  8033ea:	48 89 e5             	mov    %rsp,%rbp
  8033ed:	48 83 ec 10          	sub    $0x10,%rsp
  8033f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f9:	48 89 c7             	mov    %rax,%rdi
  8033fc:	48 b8 b7 46 80 00 00 	movabs $0x8046b7,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
  803408:	83 f8 01             	cmp    $0x1,%eax
  80340b:	75 17                	jne    803424 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80340d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803411:	8b 40 0c             	mov    0xc(%rax),%eax
  803414:	89 c7                	mov    %eax,%edi
  803416:	48 b8 55 37 80 00 00 	movabs $0x803755,%rax
  80341d:	00 00 00 
  803420:	ff d0                	callq  *%rax
  803422:	eb 05                	jmp    803429 <devsock_close+0x40>
	else
		return 0;
  803424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 20          	sub    $0x20,%rsp
  803433:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80343a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80343d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803440:	89 c7                	mov    %eax,%edi
  803442:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  803449:	00 00 00 
  80344c:	ff d0                	callq  *%rax
  80344e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803451:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803455:	79 05                	jns    80345c <connect+0x31>
		return r;
  803457:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345a:	eb 1b                	jmp    803477 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80345c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80345f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803466:	48 89 ce             	mov    %rcx,%rsi
  803469:	89 c7                	mov    %eax,%edi
  80346b:	48 b8 82 37 80 00 00 	movabs $0x803782,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
}
  803477:	c9                   	leaveq 
  803478:	c3                   	retq   

0000000000803479 <listen>:

int
listen(int s, int backlog)
{
  803479:	55                   	push   %rbp
  80347a:	48 89 e5             	mov    %rsp,%rbp
  80347d:	48 83 ec 20          	sub    $0x20,%rsp
  803481:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803484:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803487:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348a:	89 c7                	mov    %eax,%edi
  80348c:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  803493:	00 00 00 
  803496:	ff d0                	callq  *%rax
  803498:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349f:	79 05                	jns    8034a6 <listen+0x2d>
		return r;
  8034a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a4:	eb 16                	jmp    8034bc <listen+0x43>
	return nsipc_listen(r, backlog);
  8034a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ac:	89 d6                	mov    %edx,%esi
  8034ae:	89 c7                	mov    %eax,%edi
  8034b0:	48 b8 e6 37 80 00 00 	movabs $0x8037e6,%rax
  8034b7:	00 00 00 
  8034ba:	ff d0                	callq  *%rax
}
  8034bc:	c9                   	leaveq 
  8034bd:	c3                   	retq   

00000000008034be <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034be:	55                   	push   %rbp
  8034bf:	48 89 e5             	mov    %rsp,%rbp
  8034c2:	48 83 ec 20          	sub    $0x20,%rsp
  8034c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d6:	89 c2                	mov    %eax,%edx
  8034d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034dc:	8b 40 0c             	mov    0xc(%rax),%eax
  8034df:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034e8:	89 c7                	mov    %eax,%edi
  8034ea:	48 b8 26 38 80 00 00 	movabs $0x803826,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
}
  8034f6:	c9                   	leaveq 
  8034f7:	c3                   	retq   

00000000008034f8 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034f8:	55                   	push   %rbp
  8034f9:	48 89 e5             	mov    %rsp,%rbp
  8034fc:	48 83 ec 20          	sub    $0x20,%rsp
  803500:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803504:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803508:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80350c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803510:	89 c2                	mov    %eax,%edx
  803512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803516:	8b 40 0c             	mov    0xc(%rax),%eax
  803519:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80351d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803522:	89 c7                	mov    %eax,%edi
  803524:	48 b8 f2 38 80 00 00 	movabs $0x8038f2,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
}
  803530:	c9                   	leaveq 
  803531:	c3                   	retq   

0000000000803532 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803532:	55                   	push   %rbp
  803533:	48 89 e5             	mov    %rsp,%rbp
  803536:	48 83 ec 10          	sub    $0x10,%rsp
  80353a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80353e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803546:	48 be 78 4e 80 00 00 	movabs $0x804e78,%rsi
  80354d:	00 00 00 
  803550:	48 89 c7             	mov    %rax,%rdi
  803553:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80355a:	00 00 00 
  80355d:	ff d0                	callq  *%rax
	return 0;
  80355f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803564:	c9                   	leaveq 
  803565:	c3                   	retq   

0000000000803566 <socket>:

int
socket(int domain, int type, int protocol)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 20          	sub    $0x20,%rsp
  80356e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803571:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803574:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803577:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80357a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80357d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803580:	89 ce                	mov    %ecx,%esi
  803582:	89 c7                	mov    %eax,%edi
  803584:	48 b8 aa 39 80 00 00 	movabs $0x8039aa,%rax
  80358b:	00 00 00 
  80358e:	ff d0                	callq  *%rax
  803590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803597:	79 05                	jns    80359e <socket+0x38>
		return r;
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	eb 11                	jmp    8035af <socket+0x49>
	return alloc_sockfd(r);
  80359e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a1:	89 c7                	mov    %eax,%edi
  8035a3:	48 b8 48 32 80 00 00 	movabs $0x803248,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
}
  8035af:	c9                   	leaveq 
  8035b0:	c3                   	retq   

00000000008035b1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035b1:	55                   	push   %rbp
  8035b2:	48 89 e5             	mov    %rsp,%rbp
  8035b5:	48 83 ec 10          	sub    $0x10,%rsp
  8035b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035bc:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035c3:	00 00 00 
  8035c6:	8b 00                	mov    (%rax),%eax
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	75 1d                	jne    8035e9 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035cc:	bf 02 00 00 00       	mov    $0x2,%edi
  8035d1:	48 b8 35 46 80 00 00 	movabs $0x804635,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8035e4:	00 00 00 
  8035e7:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035e9:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8035f0:	00 00 00 
  8035f3:	8b 00                	mov    (%rax),%eax
  8035f5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035f8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8035fd:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803604:	00 00 00 
  803607:	89 c7                	mov    %eax,%edi
  803609:	48 b8 d3 45 80 00 00 	movabs $0x8045d3,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803615:	ba 00 00 00 00       	mov    $0x0,%edx
  80361a:	be 00 00 00 00       	mov    $0x0,%esi
  80361f:	bf 00 00 00 00       	mov    $0x0,%edi
  803624:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  80362b:	00 00 00 
  80362e:	ff d0                	callq  *%rax
}
  803630:	c9                   	leaveq 
  803631:	c3                   	retq   

0000000000803632 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803632:	55                   	push   %rbp
  803633:	48 89 e5             	mov    %rsp,%rbp
  803636:	48 83 ec 30          	sub    $0x30,%rsp
  80363a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80363d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803641:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803645:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364c:	00 00 00 
  80364f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803652:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803654:	bf 01 00 00 00       	mov    $0x1,%edi
  803659:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  803660:	00 00 00 
  803663:	ff d0                	callq  *%rax
  803665:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803668:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366c:	78 3e                	js     8036ac <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80366e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803675:	00 00 00 
  803678:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80367c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803680:	8b 40 10             	mov    0x10(%rax),%eax
  803683:	89 c2                	mov    %eax,%edx
  803685:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80368d:	48 89 ce             	mov    %rcx,%rsi
  803690:	48 89 c7             	mov    %rax,%rdi
  803693:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80369f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a3:	8b 50 10             	mov    0x10(%rax),%edx
  8036a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036aa:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036af:	c9                   	leaveq 
  8036b0:	c3                   	retq   

00000000008036b1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036b1:	55                   	push   %rbp
  8036b2:	48 89 e5             	mov    %rsp,%rbp
  8036b5:	48 83 ec 10          	sub    $0x10,%rsp
  8036b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036c0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036c3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ca:	00 00 00 
  8036cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d9:	48 89 c6             	mov    %rax,%rsi
  8036dc:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036e3:	00 00 00 
  8036e6:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8036ed:	00 00 00 
  8036f0:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f9:	00 00 00 
  8036fc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036ff:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803702:	bf 02 00 00 00       	mov    $0x2,%edi
  803707:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
  803719:	48 83 ec 10          	sub    $0x10,%rsp
  80371d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803720:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803723:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372a:	00 00 00 
  80372d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803730:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803732:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803739:	00 00 00 
  80373c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80373f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803742:	bf 03 00 00 00       	mov    $0x3,%edi
  803747:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  80374e:	00 00 00 
  803751:	ff d0                	callq  *%rax
}
  803753:	c9                   	leaveq 
  803754:	c3                   	retq   

0000000000803755 <nsipc_close>:

int
nsipc_close(int s)
{
  803755:	55                   	push   %rbp
  803756:	48 89 e5             	mov    %rsp,%rbp
  803759:	48 83 ec 10          	sub    $0x10,%rsp
  80375d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803760:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803767:	00 00 00 
  80376a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80376d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80376f:	bf 04 00 00 00       	mov    $0x4,%edi
  803774:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
}
  803780:	c9                   	leaveq 
  803781:	c3                   	retq   

0000000000803782 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803782:	55                   	push   %rbp
  803783:	48 89 e5             	mov    %rsp,%rbp
  803786:	48 83 ec 10          	sub    $0x10,%rsp
  80378a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80378d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803791:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803794:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379b:	00 00 00 
  80379e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037a3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037aa:	48 89 c6             	mov    %rax,%rsi
  8037ad:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037b4:	00 00 00 
  8037b7:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8037be:	00 00 00 
  8037c1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037c3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ca:	00 00 00 
  8037cd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037d0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8037d8:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  8037df:	00 00 00 
  8037e2:	ff d0                	callq  *%rax
}
  8037e4:	c9                   	leaveq 
  8037e5:	c3                   	retq   

00000000008037e6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037e6:	55                   	push   %rbp
  8037e7:	48 89 e5             	mov    %rsp,%rbp
  8037ea:	48 83 ec 10          	sub    $0x10,%rsp
  8037ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037f1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fb:	00 00 00 
  8037fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803801:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803803:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380a:	00 00 00 
  80380d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803810:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803813:	bf 06 00 00 00       	mov    $0x6,%edi
  803818:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
}
  803824:	c9                   	leaveq 
  803825:	c3                   	retq   

0000000000803826 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803826:	55                   	push   %rbp
  803827:	48 89 e5             	mov    %rsp,%rbp
  80382a:	48 83 ec 30          	sub    $0x30,%rsp
  80382e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803831:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803835:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803838:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80383b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803842:	00 00 00 
  803845:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803848:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80384a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803851:	00 00 00 
  803854:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803857:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80385a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803861:	00 00 00 
  803864:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803867:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80386a:	bf 07 00 00 00       	mov    $0x7,%edi
  80386f:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803882:	78 69                	js     8038ed <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803884:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80388b:	7f 08                	jg     803895 <nsipc_recv+0x6f>
  80388d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803890:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803893:	7e 35                	jle    8038ca <nsipc_recv+0xa4>
  803895:	48 b9 7f 4e 80 00 00 	movabs $0x804e7f,%rcx
  80389c:	00 00 00 
  80389f:	48 ba 94 4e 80 00 00 	movabs $0x804e94,%rdx
  8038a6:	00 00 00 
  8038a9:	be 61 00 00 00       	mov    $0x61,%esi
  8038ae:	48 bf a9 4e 80 00 00 	movabs $0x804ea9,%rdi
  8038b5:	00 00 00 
  8038b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bd:	49 b8 79 42 80 00 00 	movabs $0x804279,%r8
  8038c4:	00 00 00 
  8038c7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cd:	48 63 d0             	movslq %eax,%rdx
  8038d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d4:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038db:	00 00 00 
  8038de:	48 89 c7             	mov    %rax,%rdi
  8038e1:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8038e8:	00 00 00 
  8038eb:	ff d0                	callq  *%rax
	}

	return r;
  8038ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038f0:	c9                   	leaveq 
  8038f1:	c3                   	retq   

00000000008038f2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038f2:	55                   	push   %rbp
  8038f3:	48 89 e5             	mov    %rsp,%rbp
  8038f6:	48 83 ec 20          	sub    $0x20,%rsp
  8038fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803901:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803904:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803907:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80390e:	00 00 00 
  803911:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803914:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803916:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80391d:	7e 35                	jle    803954 <nsipc_send+0x62>
  80391f:	48 b9 b5 4e 80 00 00 	movabs $0x804eb5,%rcx
  803926:	00 00 00 
  803929:	48 ba 94 4e 80 00 00 	movabs $0x804e94,%rdx
  803930:	00 00 00 
  803933:	be 6c 00 00 00       	mov    $0x6c,%esi
  803938:	48 bf a9 4e 80 00 00 	movabs $0x804ea9,%rdi
  80393f:	00 00 00 
  803942:	b8 00 00 00 00       	mov    $0x0,%eax
  803947:	49 b8 79 42 80 00 00 	movabs $0x804279,%r8
  80394e:	00 00 00 
  803951:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803957:	48 63 d0             	movslq %eax,%rdx
  80395a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395e:	48 89 c6             	mov    %rax,%rsi
  803961:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803968:	00 00 00 
  80396b:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803977:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80397e:	00 00 00 
  803981:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803984:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803987:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80398e:	00 00 00 
  803991:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803994:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803997:	bf 08 00 00 00       	mov    $0x8,%edi
  80399c:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  8039a3:	00 00 00 
  8039a6:	ff d0                	callq  *%rax
}
  8039a8:	c9                   	leaveq 
  8039a9:	c3                   	retq   

00000000008039aa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039aa:	55                   	push   %rbp
  8039ab:	48 89 e5             	mov    %rsp,%rbp
  8039ae:	48 83 ec 10          	sub    $0x10,%rsp
  8039b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039b5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039b8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c2:	00 00 00 
  8039c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039c8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d1:	00 00 00 
  8039d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e1:	00 00 00 
  8039e4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039e7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039ea:	bf 09 00 00 00       	mov    $0x9,%edi
  8039ef:	48 b8 b1 35 80 00 00 	movabs $0x8035b1,%rax
  8039f6:	00 00 00 
  8039f9:	ff d0                	callq  *%rax
}
  8039fb:	c9                   	leaveq 
  8039fc:	c3                   	retq   

00000000008039fd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039fd:	55                   	push   %rbp
  8039fe:	48 89 e5             	mov    %rsp,%rbp
  803a01:	53                   	push   %rbx
  803a02:	48 83 ec 38          	sub    $0x38,%rsp
  803a06:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a0a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a24:	0f 88 bf 01 00 00    	js     803be9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2e:	ba 07 04 00 00       	mov    $0x407,%edx
  803a33:	48 89 c6             	mov    %rax,%rsi
  803a36:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3b:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803a42:	00 00 00 
  803a45:	ff d0                	callq  *%rax
  803a47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a4e:	0f 88 95 01 00 00    	js     803be9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a54:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a58:	48 89 c7             	mov    %rax,%rdi
  803a5b:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  803a62:	00 00 00 
  803a65:	ff d0                	callq  *%rax
  803a67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a6e:	0f 88 5d 01 00 00    	js     803bd1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a78:	ba 07 04 00 00       	mov    $0x407,%edx
  803a7d:	48 89 c6             	mov    %rax,%rsi
  803a80:	bf 00 00 00 00       	mov    $0x0,%edi
  803a85:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a98:	0f 88 33 01 00 00    	js     803bd1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa2:	48 89 c7             	mov    %rax,%rdi
  803aa5:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
  803ab1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ab5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab9:	ba 07 04 00 00       	mov    $0x407,%edx
  803abe:	48 89 c6             	mov    %rax,%rsi
  803ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac6:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  803acd:	00 00 00 
  803ad0:	ff d0                	callq  *%rax
  803ad2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ad9:	79 05                	jns    803ae0 <pipe+0xe3>
		goto err2;
  803adb:	e9 d9 00 00 00       	jmpq   803bb9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae4:	48 89 c7             	mov    %rax,%rdi
  803ae7:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803aee:	00 00 00 
  803af1:	ff d0                	callq  *%rax
  803af3:	48 89 c2             	mov    %rax,%rdx
  803af6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afa:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b00:	48 89 d1             	mov    %rdx,%rcx
  803b03:	ba 00 00 00 00       	mov    $0x0,%edx
  803b08:	48 89 c6             	mov    %rax,%rsi
  803b0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b10:	48 b8 6c 18 80 00 00 	movabs $0x80186c,%rax
  803b17:	00 00 00 
  803b1a:	ff d0                	callq  *%rax
  803b1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b23:	79 1b                	jns    803b40 <pipe+0x143>
		goto err3;
  803b25:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b2a:	48 89 c6             	mov    %rax,%rsi
  803b2d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b32:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	eb 79                	jmp    803bb9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b44:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4b:	00 00 00 
  803b4e:	8b 12                	mov    (%rdx),%edx
  803b50:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b61:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b68:	00 00 00 
  803b6b:	8b 12                	mov    (%rdx),%edx
  803b6d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b7e:	48 89 c7             	mov    %rax,%rdi
  803b81:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
  803b8d:	89 c2                	mov    %eax,%edx
  803b8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b93:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b99:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba1:	48 89 c7             	mov    %rax,%rdi
  803ba4:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
  803bb0:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb7:	eb 33                	jmp    803bec <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803bb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbd:	48 89 c6             	mov    %rax,%rsi
  803bc0:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc5:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd5:	48 89 c6             	mov    %rax,%rsi
  803bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdd:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
err:
	return r;
  803be9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bec:	48 83 c4 38          	add    $0x38,%rsp
  803bf0:	5b                   	pop    %rbx
  803bf1:	5d                   	pop    %rbp
  803bf2:	c3                   	retq   

0000000000803bf3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bf3:	55                   	push   %rbp
  803bf4:	48 89 e5             	mov    %rsp,%rbp
  803bf7:	53                   	push   %rbx
  803bf8:	48 83 ec 28          	sub    $0x28,%rsp
  803bfc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c00:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c04:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c0b:	00 00 00 
  803c0e:	48 8b 00             	mov    (%rax),%rax
  803c11:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c17:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1e:	48 89 c7             	mov    %rax,%rdi
  803c21:	48 b8 b7 46 80 00 00 	movabs $0x8046b7,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax
  803c2d:	89 c3                	mov    %eax,%ebx
  803c2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c33:	48 89 c7             	mov    %rax,%rdi
  803c36:	48 b8 b7 46 80 00 00 	movabs $0x8046b7,%rax
  803c3d:	00 00 00 
  803c40:	ff d0                	callq  *%rax
  803c42:	39 c3                	cmp    %eax,%ebx
  803c44:	0f 94 c0             	sete   %al
  803c47:	0f b6 c0             	movzbl %al,%eax
  803c4a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c54:	00 00 00 
  803c57:	48 8b 00             	mov    (%rax),%rax
  803c5a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c60:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c66:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c69:	75 05                	jne    803c70 <_pipeisclosed+0x7d>
			return ret;
  803c6b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c6e:	eb 4f                	jmp    803cbf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c73:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c76:	74 42                	je     803cba <_pipeisclosed+0xc7>
  803c78:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c7c:	75 3c                	jne    803cba <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c7e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c85:	00 00 00 
  803c88:	48 8b 00             	mov    (%rax),%rax
  803c8b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c91:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c97:	89 c6                	mov    %eax,%esi
  803c99:	48 bf c6 4e 80 00 00 	movabs $0x804ec6,%rdi
  803ca0:	00 00 00 
  803ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca8:	49 b8 38 03 80 00 00 	movabs $0x800338,%r8
  803caf:	00 00 00 
  803cb2:	41 ff d0             	callq  *%r8
	}
  803cb5:	e9 4a ff ff ff       	jmpq   803c04 <_pipeisclosed+0x11>
  803cba:	e9 45 ff ff ff       	jmpq   803c04 <_pipeisclosed+0x11>
}
  803cbf:	48 83 c4 28          	add    $0x28,%rsp
  803cc3:	5b                   	pop    %rbx
  803cc4:	5d                   	pop    %rbp
  803cc5:	c3                   	retq   

0000000000803cc6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803cc6:	55                   	push   %rbp
  803cc7:	48 89 e5             	mov    %rsp,%rbp
  803cca:	48 83 ec 30          	sub    $0x30,%rsp
  803cce:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cd5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cd8:	48 89 d6             	mov    %rdx,%rsi
  803cdb:	89 c7                	mov    %eax,%edi
  803cdd:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cf0:	79 05                	jns    803cf7 <pipeisclosed+0x31>
		return r;
  803cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf5:	eb 31                	jmp    803d28 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cfb:	48 89 c7             	mov    %rax,%rdi
  803cfe:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803d05:	00 00 00 
  803d08:	ff d0                	callq  *%rax
  803d0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d16:	48 89 d6             	mov    %rdx,%rsi
  803d19:	48 89 c7             	mov    %rax,%rdi
  803d1c:	48 b8 f3 3b 80 00 00 	movabs $0x803bf3,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 40          	sub    $0x40,%rsp
  803d32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d42:	48 89 c7             	mov    %rax,%rdi
  803d45:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803d4c:	00 00 00 
  803d4f:	ff d0                	callq  *%rax
  803d51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d59:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d5d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d64:	00 
  803d65:	e9 92 00 00 00       	jmpq   803dfc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d6a:	eb 41                	jmp    803dad <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d6c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d71:	74 09                	je     803d7c <devpipe_read+0x52>
				return i;
  803d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d77:	e9 92 00 00 00       	jmpq   803e0e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d84:	48 89 d6             	mov    %rdx,%rsi
  803d87:	48 89 c7             	mov    %rax,%rdi
  803d8a:	48 b8 f3 3b 80 00 00 	movabs $0x803bf3,%rax
  803d91:	00 00 00 
  803d94:	ff d0                	callq  *%rax
  803d96:	85 c0                	test   %eax,%eax
  803d98:	74 07                	je     803da1 <devpipe_read+0x77>
				return 0;
  803d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9f:	eb 6d                	jmp    803e0e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803da1:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db1:	8b 10                	mov    (%rax),%edx
  803db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db7:	8b 40 04             	mov    0x4(%rax),%eax
  803dba:	39 c2                	cmp    %eax,%edx
  803dbc:	74 ae                	je     803d6c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803dbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dc6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dce:	8b 00                	mov    (%rax),%eax
  803dd0:	99                   	cltd   
  803dd1:	c1 ea 1b             	shr    $0x1b,%edx
  803dd4:	01 d0                	add    %edx,%eax
  803dd6:	83 e0 1f             	and    $0x1f,%eax
  803dd9:	29 d0                	sub    %edx,%eax
  803ddb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ddf:	48 98                	cltq   
  803de1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803de6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dec:	8b 00                	mov    (%rax),%eax
  803dee:	8d 50 01             	lea    0x1(%rax),%edx
  803df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803df7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e00:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e04:	0f 82 60 ff ff ff    	jb     803d6a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e0e:	c9                   	leaveq 
  803e0f:	c3                   	retq   

0000000000803e10 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e10:	55                   	push   %rbp
  803e11:	48 89 e5             	mov    %rsp,%rbp
  803e14:	48 83 ec 40          	sub    $0x40,%rsp
  803e18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e20:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e28:	48 89 c7             	mov    %rax,%rdi
  803e2b:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803e32:	00 00 00 
  803e35:	ff d0                	callq  *%rax
  803e37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e43:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e4a:	00 
  803e4b:	e9 8e 00 00 00       	jmpq   803ede <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e50:	eb 31                	jmp    803e83 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e5a:	48 89 d6             	mov    %rdx,%rsi
  803e5d:	48 89 c7             	mov    %rax,%rdi
  803e60:	48 b8 f3 3b 80 00 00 	movabs $0x803bf3,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
  803e6c:	85 c0                	test   %eax,%eax
  803e6e:	74 07                	je     803e77 <devpipe_write+0x67>
				return 0;
  803e70:	b8 00 00 00 00       	mov    $0x0,%eax
  803e75:	eb 79                	jmp    803ef0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e77:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803e7e:	00 00 00 
  803e81:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e87:	8b 40 04             	mov    0x4(%rax),%eax
  803e8a:	48 63 d0             	movslq %eax,%rdx
  803e8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e91:	8b 00                	mov    (%rax),%eax
  803e93:	48 98                	cltq   
  803e95:	48 83 c0 20          	add    $0x20,%rax
  803e99:	48 39 c2             	cmp    %rax,%rdx
  803e9c:	73 b4                	jae    803e52 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea2:	8b 40 04             	mov    0x4(%rax),%eax
  803ea5:	99                   	cltd   
  803ea6:	c1 ea 1b             	shr    $0x1b,%edx
  803ea9:	01 d0                	add    %edx,%eax
  803eab:	83 e0 1f             	and    $0x1f,%eax
  803eae:	29 d0                	sub    %edx,%eax
  803eb0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803eb4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803eb8:	48 01 ca             	add    %rcx,%rdx
  803ebb:	0f b6 0a             	movzbl (%rdx),%ecx
  803ebe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ec2:	48 98                	cltq   
  803ec4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecc:	8b 40 04             	mov    0x4(%rax),%eax
  803ecf:	8d 50 01             	lea    0x1(%rax),%edx
  803ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ed9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ede:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ee6:	0f 82 64 ff ff ff    	jb     803e50 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803eec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ef0:	c9                   	leaveq 
  803ef1:	c3                   	retq   

0000000000803ef2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ef2:	55                   	push   %rbp
  803ef3:	48 89 e5             	mov    %rsp,%rbp
  803ef6:	48 83 ec 20          	sub    $0x20,%rsp
  803efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f06:	48 89 c7             	mov    %rax,%rdi
  803f09:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803f10:	00 00 00 
  803f13:	ff d0                	callq  *%rax
  803f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f1d:	48 be d9 4e 80 00 00 	movabs $0x804ed9,%rsi
  803f24:	00 00 00 
  803f27:	48 89 c7             	mov    %rax,%rdi
  803f2a:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  803f31:	00 00 00 
  803f34:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3a:	8b 50 04             	mov    0x4(%rax),%edx
  803f3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f41:	8b 00                	mov    (%rax),%eax
  803f43:	29 c2                	sub    %eax,%edx
  803f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f49:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f5a:	00 00 00 
	stat->st_dev = &devpipe;
  803f5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f61:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f68:	00 00 00 
  803f6b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f77:	c9                   	leaveq 
  803f78:	c3                   	retq   

0000000000803f79 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f79:	55                   	push   %rbp
  803f7a:	48 89 e5             	mov    %rsp,%rbp
  803f7d:	48 83 ec 10          	sub    $0x10,%rsp
  803f81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f89:	48 89 c6             	mov    %rax,%rsi
  803f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f91:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803f98:	00 00 00 
  803f9b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa1:	48 89 c7             	mov    %rax,%rdi
  803fa4:	48 b8 10 22 80 00 00 	movabs $0x802210,%rax
  803fab:	00 00 00 
  803fae:	ff d0                	callq  *%rax
  803fb0:	48 89 c6             	mov    %rax,%rsi
  803fb3:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb8:	48 b8 c7 18 80 00 00 	movabs $0x8018c7,%rax
  803fbf:	00 00 00 
  803fc2:	ff d0                	callq  *%rax
}
  803fc4:	c9                   	leaveq 
  803fc5:	c3                   	retq   

0000000000803fc6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fc6:	55                   	push   %rbp
  803fc7:	48 89 e5             	mov    %rsp,%rbp
  803fca:	48 83 ec 20          	sub    $0x20,%rsp
  803fce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fd4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fd7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803fdb:	be 01 00 00 00       	mov    $0x1,%esi
  803fe0:	48 89 c7             	mov    %rax,%rdi
  803fe3:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  803fea:	00 00 00 
  803fed:	ff d0                	callq  *%rax
}
  803fef:	c9                   	leaveq 
  803ff0:	c3                   	retq   

0000000000803ff1 <getchar>:

int
getchar(void)
{
  803ff1:	55                   	push   %rbp
  803ff2:	48 89 e5             	mov    %rsp,%rbp
  803ff5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ff9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ffd:	ba 01 00 00 00       	mov    $0x1,%edx
  804002:	48 89 c6             	mov    %rax,%rsi
  804005:	bf 00 00 00 00       	mov    $0x0,%edi
  80400a:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  804011:	00 00 00 
  804014:	ff d0                	callq  *%rax
  804016:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401d:	79 05                	jns    804024 <getchar+0x33>
		return r;
  80401f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804022:	eb 14                	jmp    804038 <getchar+0x47>
	if (r < 1)
  804024:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804028:	7f 07                	jg     804031 <getchar+0x40>
		return -E_EOF;
  80402a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80402f:	eb 07                	jmp    804038 <getchar+0x47>
	return c;
  804031:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804035:	0f b6 c0             	movzbl %al,%eax
}
  804038:	c9                   	leaveq 
  804039:	c3                   	retq   

000000000080403a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80403a:	55                   	push   %rbp
  80403b:	48 89 e5             	mov    %rsp,%rbp
  80403e:	48 83 ec 20          	sub    $0x20,%rsp
  804042:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804045:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804049:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80404c:	48 89 d6             	mov    %rdx,%rsi
  80404f:	89 c7                	mov    %eax,%edi
  804051:	48 b8 d3 22 80 00 00 	movabs $0x8022d3,%rax
  804058:	00 00 00 
  80405b:	ff d0                	callq  *%rax
  80405d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804064:	79 05                	jns    80406b <iscons+0x31>
		return r;
  804066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804069:	eb 1a                	jmp    804085 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80406b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406f:	8b 10                	mov    (%rax),%edx
  804071:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804078:	00 00 00 
  80407b:	8b 00                	mov    (%rax),%eax
  80407d:	39 c2                	cmp    %eax,%edx
  80407f:	0f 94 c0             	sete   %al
  804082:	0f b6 c0             	movzbl %al,%eax
}
  804085:	c9                   	leaveq 
  804086:	c3                   	retq   

0000000000804087 <opencons>:

int
opencons(void)
{
  804087:	55                   	push   %rbp
  804088:	48 89 e5             	mov    %rsp,%rbp
  80408b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80408f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804093:	48 89 c7             	mov    %rax,%rdi
  804096:	48 b8 3b 22 80 00 00 	movabs $0x80223b,%rax
  80409d:	00 00 00 
  8040a0:	ff d0                	callq  *%rax
  8040a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a9:	79 05                	jns    8040b0 <opencons+0x29>
		return r;
  8040ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ae:	eb 5b                	jmp    80410b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8040b9:	48 89 c6             	mov    %rax,%rsi
  8040bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c1:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8040c8:	00 00 00 
  8040cb:	ff d0                	callq  *%rax
  8040cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d4:	79 05                	jns    8040db <opencons+0x54>
		return r;
  8040d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d9:	eb 30                	jmp    80410b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040df:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040e6:	00 00 00 
  8040e9:	8b 12                	mov    (%rdx),%edx
  8040eb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fc:	48 89 c7             	mov    %rax,%rdi
  8040ff:	48 b8 ed 21 80 00 00 	movabs $0x8021ed,%rax
  804106:	00 00 00 
  804109:	ff d0                	callq  *%rax
}
  80410b:	c9                   	leaveq 
  80410c:	c3                   	retq   

000000000080410d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80410d:	55                   	push   %rbp
  80410e:	48 89 e5             	mov    %rsp,%rbp
  804111:	48 83 ec 30          	sub    $0x30,%rsp
  804115:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804119:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804121:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804126:	75 07                	jne    80412f <devcons_read+0x22>
		return 0;
  804128:	b8 00 00 00 00       	mov    $0x0,%eax
  80412d:	eb 4b                	jmp    80417a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80412f:	eb 0c                	jmp    80413d <devcons_read+0x30>
		sys_yield();
  804131:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80413d:	48 b8 1e 17 80 00 00 	movabs $0x80171e,%rax
  804144:	00 00 00 
  804147:	ff d0                	callq  *%rax
  804149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804150:	74 df                	je     804131 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804156:	79 05                	jns    80415d <devcons_read+0x50>
		return c;
  804158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415b:	eb 1d                	jmp    80417a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80415d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804161:	75 07                	jne    80416a <devcons_read+0x5d>
		return 0;
  804163:	b8 00 00 00 00       	mov    $0x0,%eax
  804168:	eb 10                	jmp    80417a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80416a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416d:	89 c2                	mov    %eax,%edx
  80416f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804173:	88 10                	mov    %dl,(%rax)
	return 1;
  804175:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80417a:	c9                   	leaveq 
  80417b:	c3                   	retq   

000000000080417c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80417c:	55                   	push   %rbp
  80417d:	48 89 e5             	mov    %rsp,%rbp
  804180:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804187:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80418e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804195:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80419c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041a3:	eb 76                	jmp    80421b <devcons_write+0x9f>
		m = n - tot;
  8041a5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041ac:	89 c2                	mov    %eax,%edx
  8041ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b1:	29 c2                	sub    %eax,%edx
  8041b3:	89 d0                	mov    %edx,%eax
  8041b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041bb:	83 f8 7f             	cmp    $0x7f,%eax
  8041be:	76 07                	jbe    8041c7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041c0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ca:	48 63 d0             	movslq %eax,%rdx
  8041cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d0:	48 63 c8             	movslq %eax,%rcx
  8041d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041da:	48 01 c1             	add    %rax,%rcx
  8041dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041e4:	48 89 ce             	mov    %rcx,%rsi
  8041e7:	48 89 c7             	mov    %rax,%rdi
  8041ea:	48 b8 11 12 80 00 00 	movabs $0x801211,%rax
  8041f1:	00 00 00 
  8041f4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041f9:	48 63 d0             	movslq %eax,%rdx
  8041fc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804203:	48 89 d6             	mov    %rdx,%rsi
  804206:	48 89 c7             	mov    %rax,%rdi
  804209:	48 b8 d4 16 80 00 00 	movabs $0x8016d4,%rax
  804210:	00 00 00 
  804213:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804215:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804218:	01 45 fc             	add    %eax,-0x4(%rbp)
  80421b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421e:	48 98                	cltq   
  804220:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804227:	0f 82 78 ff ff ff    	jb     8041a5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80422d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804230:	c9                   	leaveq 
  804231:	c3                   	retq   

0000000000804232 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804232:	55                   	push   %rbp
  804233:	48 89 e5             	mov    %rsp,%rbp
  804236:	48 83 ec 08          	sub    $0x8,%rsp
  80423a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80423e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804243:	c9                   	leaveq 
  804244:	c3                   	retq   

0000000000804245 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804245:	55                   	push   %rbp
  804246:	48 89 e5             	mov    %rsp,%rbp
  804249:	48 83 ec 10          	sub    $0x10,%rsp
  80424d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804251:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804259:	48 be e5 4e 80 00 00 	movabs $0x804ee5,%rsi
  804260:	00 00 00 
  804263:	48 89 c7             	mov    %rax,%rdi
  804266:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80426d:	00 00 00 
  804270:	ff d0                	callq  *%rax
	return 0;
  804272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804277:	c9                   	leaveq 
  804278:	c3                   	retq   

0000000000804279 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804279:	55                   	push   %rbp
  80427a:	48 89 e5             	mov    %rsp,%rbp
  80427d:	53                   	push   %rbx
  80427e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804285:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80428c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804292:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804299:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8042a0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8042a7:	84 c0                	test   %al,%al
  8042a9:	74 23                	je     8042ce <_panic+0x55>
  8042ab:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8042b2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8042b6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8042ba:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8042be:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8042c2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8042c6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8042ca:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8042ce:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8042d5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8042dc:	00 00 00 
  8042df:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8042e6:	00 00 00 
  8042e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8042ed:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8042f4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042fb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804302:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804309:	00 00 00 
  80430c:	48 8b 18             	mov    (%rax),%rbx
  80430f:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  804316:	00 00 00 
  804319:	ff d0                	callq  *%rax
  80431b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804321:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804328:	41 89 c8             	mov    %ecx,%r8d
  80432b:	48 89 d1             	mov    %rdx,%rcx
  80432e:	48 89 da             	mov    %rbx,%rdx
  804331:	89 c6                	mov    %eax,%esi
  804333:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  80433a:	00 00 00 
  80433d:	b8 00 00 00 00       	mov    $0x0,%eax
  804342:	49 b9 38 03 80 00 00 	movabs $0x800338,%r9
  804349:	00 00 00 
  80434c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80434f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804356:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80435d:	48 89 d6             	mov    %rdx,%rsi
  804360:	48 89 c7             	mov    %rax,%rdi
  804363:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  80436a:	00 00 00 
  80436d:	ff d0                	callq  *%rax
	cprintf("\n");
  80436f:	48 bf 13 4f 80 00 00 	movabs $0x804f13,%rdi
  804376:	00 00 00 
  804379:	b8 00 00 00 00       	mov    $0x0,%eax
  80437e:	48 ba 38 03 80 00 00 	movabs $0x800338,%rdx
  804385:	00 00 00 
  804388:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80438a:	cc                   	int3   
  80438b:	eb fd                	jmp    80438a <_panic+0x111>

000000000080438d <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80438d:	55                   	push   %rbp
  80438e:	48 89 e5             	mov    %rsp,%rbp
  804391:	48 83 ec 10          	sub    $0x10,%rsp
  804395:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804399:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a0:	00 00 00 
  8043a3:	48 8b 00             	mov    (%rax),%rax
  8043a6:	48 85 c0             	test   %rax,%rax
  8043a9:	0f 85 84 00 00 00    	jne    804433 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8043af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043b6:	00 00 00 
  8043b9:	48 8b 00             	mov    (%rax),%rax
  8043bc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043c2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043c7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8043cc:	89 c7                	mov    %eax,%edi
  8043ce:	48 b8 1c 18 80 00 00 	movabs $0x80181c,%rax
  8043d5:	00 00 00 
  8043d8:	ff d0                	callq  *%rax
  8043da:	85 c0                	test   %eax,%eax
  8043dc:	79 2a                	jns    804408 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  8043de:	48 ba 18 4f 80 00 00 	movabs $0x804f18,%rdx
  8043e5:	00 00 00 
  8043e8:	be 23 00 00 00       	mov    $0x23,%esi
  8043ed:	48 bf 3f 4f 80 00 00 	movabs $0x804f3f,%rdi
  8043f4:	00 00 00 
  8043f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fc:	48 b9 79 42 80 00 00 	movabs $0x804279,%rcx
  804403:	00 00 00 
  804406:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804408:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80440f:	00 00 00 
  804412:	48 8b 00             	mov    (%rax),%rax
  804415:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80441b:	48 be 46 44 80 00 00 	movabs $0x804446,%rsi
  804422:	00 00 00 
  804425:	89 c7                	mov    %eax,%edi
  804427:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  80442e:	00 00 00 
  804431:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804433:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80443a:	00 00 00 
  80443d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804441:	48 89 10             	mov    %rdx,(%rax)
}
  804444:	c9                   	leaveq 
  804445:	c3                   	retq   

0000000000804446 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804446:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804449:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804450:	00 00 00 
call *%rax
  804453:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804455:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80445c:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80445d:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804464:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804465:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804469:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80446c:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804473:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804474:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804478:	4c 8b 3c 24          	mov    (%rsp),%r15
  80447c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804481:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804486:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80448b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804490:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804495:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80449a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80449f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044a4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044a9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8044ae:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8044b3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8044b8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044bd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044c2:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8044c6:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8044ca:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8044cb:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8044cc:	c3                   	retq   

00000000008044cd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044cd:	55                   	push   %rbp
  8044ce:	48 89 e5             	mov    %rsp,%rbp
  8044d1:	48 83 ec 30          	sub    $0x30,%rsp
  8044d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8044e1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8044e8:	00 00 00 
  8044eb:	48 8b 00             	mov    (%rax),%rax
  8044ee:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8044f4:	85 c0                	test   %eax,%eax
  8044f6:	75 3c                	jne    804534 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8044f8:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  8044ff:	00 00 00 
  804502:	ff d0                	callq  *%rax
  804504:	25 ff 03 00 00       	and    $0x3ff,%eax
  804509:	48 63 d0             	movslq %eax,%rdx
  80450c:	48 89 d0             	mov    %rdx,%rax
  80450f:	48 c1 e0 03          	shl    $0x3,%rax
  804513:	48 01 d0             	add    %rdx,%rax
  804516:	48 c1 e0 05          	shl    $0x5,%rax
  80451a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804521:	00 00 00 
  804524:	48 01 c2             	add    %rax,%rdx
  804527:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80452e:	00 00 00 
  804531:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  804534:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804539:	75 0e                	jne    804549 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80453b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804542:	00 00 00 
  804545:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804549:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80454d:	48 89 c7             	mov    %rax,%rdi
  804550:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  804557:	00 00 00 
  80455a:	ff d0                	callq  *%rax
  80455c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  80455f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804563:	79 19                	jns    80457e <ipc_recv+0xb1>
		*from_env_store = 0;
  804565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804569:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  80456f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804573:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457c:	eb 53                	jmp    8045d1 <ipc_recv+0x104>
	}
	if(from_env_store)
  80457e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804583:	74 19                	je     80459e <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804585:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80458c:	00 00 00 
  80458f:	48 8b 00             	mov    (%rax),%rax
  804592:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80459c:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  80459e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045a3:	74 19                	je     8045be <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8045a5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045ac:	00 00 00 
  8045af:	48 8b 00             	mov    (%rax),%rax
  8045b2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8045b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045bc:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8045be:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045c5:	00 00 00 
  8045c8:	48 8b 00             	mov    (%rax),%rax
  8045cb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8045d1:	c9                   	leaveq 
  8045d2:	c3                   	retq   

00000000008045d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045d3:	55                   	push   %rbp
  8045d4:	48 89 e5             	mov    %rsp,%rbp
  8045d7:	48 83 ec 30          	sub    $0x30,%rsp
  8045db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045de:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045e1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8045e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045ed:	75 0e                	jne    8045fd <ipc_send+0x2a>
		pg = (void*)UTOP;
  8045ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8045f6:	00 00 00 
  8045f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8045fd:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804600:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804603:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804607:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80460a:	89 c7                	mov    %eax,%edi
  80460c:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  804613:	00 00 00 
  804616:	ff d0                	callq  *%rax
  804618:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80461b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80461f:	75 0c                	jne    80462d <ipc_send+0x5a>
			sys_yield();
  804621:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  804628:	00 00 00 
  80462b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80462d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804631:	74 ca                	je     8045fd <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804633:	c9                   	leaveq 
  804634:	c3                   	retq   

0000000000804635 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804635:	55                   	push   %rbp
  804636:	48 89 e5             	mov    %rsp,%rbp
  804639:	48 83 ec 14          	sub    $0x14,%rsp
  80463d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804647:	eb 5e                	jmp    8046a7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804649:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804650:	00 00 00 
  804653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804656:	48 63 d0             	movslq %eax,%rdx
  804659:	48 89 d0             	mov    %rdx,%rax
  80465c:	48 c1 e0 03          	shl    $0x3,%rax
  804660:	48 01 d0             	add    %rdx,%rax
  804663:	48 c1 e0 05          	shl    $0x5,%rax
  804667:	48 01 c8             	add    %rcx,%rax
  80466a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804670:	8b 00                	mov    (%rax),%eax
  804672:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804675:	75 2c                	jne    8046a3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804677:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80467e:	00 00 00 
  804681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804684:	48 63 d0             	movslq %eax,%rdx
  804687:	48 89 d0             	mov    %rdx,%rax
  80468a:	48 c1 e0 03          	shl    $0x3,%rax
  80468e:	48 01 d0             	add    %rdx,%rax
  804691:	48 c1 e0 05          	shl    $0x5,%rax
  804695:	48 01 c8             	add    %rcx,%rax
  804698:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80469e:	8b 40 08             	mov    0x8(%rax),%eax
  8046a1:	eb 12                	jmp    8046b5 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046a7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046ae:	7e 99                	jle    804649 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8046b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046b5:	c9                   	leaveq 
  8046b6:	c3                   	retq   

00000000008046b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046b7:	55                   	push   %rbp
  8046b8:	48 89 e5             	mov    %rsp,%rbp
  8046bb:	48 83 ec 18          	sub    $0x18,%rsp
  8046bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046c7:	48 c1 e8 15          	shr    $0x15,%rax
  8046cb:	48 89 c2             	mov    %rax,%rdx
  8046ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046d5:	01 00 00 
  8046d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046dc:	83 e0 01             	and    $0x1,%eax
  8046df:	48 85 c0             	test   %rax,%rax
  8046e2:	75 07                	jne    8046eb <pageref+0x34>
		return 0;
  8046e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e9:	eb 53                	jmp    80473e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046ef:	48 c1 e8 0c          	shr    $0xc,%rax
  8046f3:	48 89 c2             	mov    %rax,%rdx
  8046f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8046fd:	01 00 00 
  804700:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804704:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80470c:	83 e0 01             	and    $0x1,%eax
  80470f:	48 85 c0             	test   %rax,%rax
  804712:	75 07                	jne    80471b <pageref+0x64>
		return 0;
  804714:	b8 00 00 00 00       	mov    $0x0,%eax
  804719:	eb 23                	jmp    80473e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80471b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80471f:	48 c1 e8 0c          	shr    $0xc,%rax
  804723:	48 89 c2             	mov    %rax,%rdx
  804726:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80472d:	00 00 00 
  804730:	48 c1 e2 04          	shl    $0x4,%rdx
  804734:	48 01 d0             	add    %rdx,%rax
  804737:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80473b:	0f b7 c0             	movzwl %ax,%eax
}
  80473e:	c9                   	leaveq 
  80473f:	c3                   	retq   
