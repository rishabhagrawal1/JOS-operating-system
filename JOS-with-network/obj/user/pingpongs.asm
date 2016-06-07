
obj/user/pingpongs.debug:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf e0 47 80 00 00 	movabs $0x8047e0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf fa 47 80 00 00 	movabs $0x8047fa,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 7f 22 80 00 00 	movabs $0x80227f,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf 10 48 80 00 00 	movabs $0x804810,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba ca 03 80 00 00 	movabs $0x8003ca,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001d9:	00 00 00 
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	83 f8 0a             	cmp    $0xa,%eax
  8001e1:	75 02                	jne    8001e5 <umain+0x1a2>
			return;
  8001e3:	eb 05                	jmp    8001ea <umain+0x1a7>
	}
  8001e5:	e9 17 ff ff ff       	jmpq   800101 <umain+0xbe>

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800206:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	25 ff 03 00 00       	and    $0x3ff,%eax
  800217:	48 63 d0             	movslq %eax,%rdx
  80021a:	48 89 d0             	mov    %rdx,%rax
  80021d:	48 c1 e0 03          	shl    $0x3,%rax
  800221:	48 01 d0             	add    %rdx,%rax
  800224:	48 c1 e0 05          	shl    $0x5,%rax
  800228:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80022f:	00 00 00 
  800232:	48 01 c2             	add    %rax,%rdx
  800235:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80023c:	00 00 00 
  80023f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800246:	7e 14                	jle    80025c <libmain+0x65>
		binaryname = argv[0];
  800248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024c:	48 8b 10             	mov    (%rax),%rdx
  80024f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800256:	00 00 00 
  800259:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80025c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800263:	48 89 d6             	mov    %rdx,%rsi
  800266:	89 c7                	mov    %eax,%edi
  800268:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800274:	48 b8 82 02 80 00 00 	movabs $0x800282,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
}
  800280:	c9                   	leaveq 
  800281:	c3                   	retq   

0000000000800282 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800282:	55                   	push   %rbp
  800283:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800286:	48 b8 aa 27 80 00 00 	movabs $0x8027aa,%rax
  80028d:	00 00 00 
  800290:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800292:	bf 00 00 00 00       	mov    $0x0,%edi
  800297:	48 b8 ee 17 80 00 00 	movabs $0x8017ee,%rax
  80029e:	00 00 00 
  8002a1:	ff d0                	callq  *%rax

}
  8002a3:	5d                   	pop    %rbp
  8002a4:	c3                   	retq   

00000000008002a5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002a5:	55                   	push   %rbp
  8002a6:	48 89 e5             	mov    %rsp,%rbp
  8002a9:	48 83 ec 10          	sub    $0x10,%rsp
  8002ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b8:	8b 00                	mov    (%rax),%eax
  8002ba:	8d 48 01             	lea    0x1(%rax),%ecx
  8002bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c1:	89 0a                	mov    %ecx,(%rdx)
  8002c3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002c6:	89 d1                	mov    %edx,%ecx
  8002c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002cc:	48 98                	cltq   
  8002ce:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d6:	8b 00                	mov    (%rax),%eax
  8002d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dd:	75 2c                	jne    80030b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	8b 00                	mov    (%rax),%eax
  8002e5:	48 98                	cltq   
  8002e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002eb:	48 83 c2 08          	add    $0x8,%rdx
  8002ef:	48 89 c6             	mov    %rax,%rsi
  8002f2:	48 89 d7             	mov    %rdx,%rdi
  8002f5:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
        b->idx = 0;
  800301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800305:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80030b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030f:	8b 40 04             	mov    0x4(%rax),%eax
  800312:	8d 50 01             	lea    0x1(%rax),%edx
  800315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800319:	89 50 04             	mov    %edx,0x4(%rax)
}
  80031c:	c9                   	leaveq 
  80031d:	c3                   	retq   

000000000080031e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80031e:	55                   	push   %rbp
  80031f:	48 89 e5             	mov    %rsp,%rbp
  800322:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800329:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800330:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800337:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80033e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800345:	48 8b 0a             	mov    (%rdx),%rcx
  800348:	48 89 08             	mov    %rcx,(%rax)
  80034b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80034f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800353:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800357:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80035b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800362:	00 00 00 
    b.cnt = 0;
  800365:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80036c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80036f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800376:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80037d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800384:	48 89 c6             	mov    %rax,%rsi
  800387:	48 bf a5 02 80 00 00 	movabs $0x8002a5,%rdi
  80038e:	00 00 00 
  800391:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800398:	00 00 00 
  80039b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80039d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a3:	48 98                	cltq   
  8003a5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003ac:	48 83 c2 08          	add    $0x8,%rdx
  8003b0:	48 89 c6             	mov    %rax,%rsi
  8003b3:	48 89 d7             	mov    %rdx,%rdi
  8003b6:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003c8:	c9                   	leaveq 
  8003c9:	c3                   	retq   

00000000008003ca <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003ca:	55                   	push   %rbp
  8003cb:	48 89 e5             	mov    %rsp,%rbp
  8003ce:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003d5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003dc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ea:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003f8:	84 c0                	test   %al,%al
  8003fa:	74 20                	je     80041c <cprintf+0x52>
  8003fc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800400:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800404:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800408:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80040c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800410:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800414:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800418:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80041c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800423:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042a:	00 00 00 
  80042d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800434:	00 00 00 
  800437:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80043b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800442:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800449:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800450:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800457:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80045e:	48 8b 0a             	mov    (%rdx),%rcx
  800461:	48 89 08             	mov    %rcx,(%rax)
  800464:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800468:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80046c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800470:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800474:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80047b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800482:	48 89 d6             	mov    %rdx,%rsi
  800485:	48 89 c7             	mov    %rax,%rdi
  800488:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  80048f:	00 00 00 
  800492:	ff d0                	callq  *%rax
  800494:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80049a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a0:	c9                   	leaveq 
  8004a1:	c3                   	retq   

00000000008004a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a2:	55                   	push   %rbp
  8004a3:	48 89 e5             	mov    %rsp,%rbp
  8004a6:	53                   	push   %rbx
  8004a7:	48 83 ec 38          	sub    $0x38,%rsp
  8004ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004b7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004ba:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004be:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004c5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004c9:	77 3b                	ja     800506 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004cb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004ce:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004de:	48 f7 f3             	div    %rbx
  8004e1:	48 89 c2             	mov    %rax,%rdx
  8004e4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004e7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ea:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f2:	41 89 f9             	mov    %edi,%r9d
  8004f5:	48 89 c7             	mov    %rax,%rdi
  8004f8:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	callq  *%rax
  800504:	eb 1e                	jmp    800524 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800506:	eb 12                	jmp    80051a <printnum+0x78>
			putch(padc, putdat);
  800508:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80050c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 89 ce             	mov    %rcx,%rsi
  800516:	89 d7                	mov    %edx,%edi
  800518:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80051e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800522:	7f e4                	jg     800508 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800524:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80052b:	ba 00 00 00 00       	mov    $0x0,%edx
  800530:	48 f7 f1             	div    %rcx
  800533:	48 89 d0             	mov    %rdx,%rax
  800536:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  80053d:	00 00 00 
  800540:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800544:	0f be d0             	movsbl %al,%edx
  800547:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	48 89 ce             	mov    %rcx,%rsi
  800552:	89 d7                	mov    %edx,%edi
  800554:	ff d0                	callq  *%rax
}
  800556:	48 83 c4 38          	add    $0x38,%rsp
  80055a:	5b                   	pop    %rbx
  80055b:	5d                   	pop    %rbp
  80055c:	c3                   	retq   

000000000080055d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80055d:	55                   	push   %rbp
  80055e:	48 89 e5             	mov    %rsp,%rbp
  800561:	48 83 ec 1c          	sub    $0x1c,%rsp
  800565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800569:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80056c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800570:	7e 52                	jle    8005c4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800576:	8b 00                	mov    (%rax),%eax
  800578:	83 f8 30             	cmp    $0x30,%eax
  80057b:	73 24                	jae    8005a1 <getuint+0x44>
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	8b 00                	mov    (%rax),%eax
  80058b:	89 c0                	mov    %eax,%eax
  80058d:	48 01 d0             	add    %rdx,%rax
  800590:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800594:	8b 12                	mov    (%rdx),%edx
  800596:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800599:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059d:	89 0a                	mov    %ecx,(%rdx)
  80059f:	eb 17                	jmp    8005b8 <getuint+0x5b>
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a9:	48 89 d0             	mov    %rdx,%rax
  8005ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b8:	48 8b 00             	mov    (%rax),%rax
  8005bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005bf:	e9 a3 00 00 00       	jmpq   800667 <getuint+0x10a>
	else if (lflag)
  8005c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c8:	74 4f                	je     800619 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	8b 00                	mov    (%rax),%eax
  8005d0:	83 f8 30             	cmp    $0x30,%eax
  8005d3:	73 24                	jae    8005f9 <getuint+0x9c>
  8005d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	8b 00                	mov    (%rax),%eax
  8005e3:	89 c0                	mov    %eax,%eax
  8005e5:	48 01 d0             	add    %rdx,%rax
  8005e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ec:	8b 12                	mov    (%rdx),%edx
  8005ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	89 0a                	mov    %ecx,(%rdx)
  8005f7:	eb 17                	jmp    800610 <getuint+0xb3>
  8005f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800601:	48 89 d0             	mov    %rdx,%rax
  800604:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800610:	48 8b 00             	mov    (%rax),%rax
  800613:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800617:	eb 4e                	jmp    800667 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	83 f8 30             	cmp    $0x30,%eax
  800622:	73 24                	jae    800648 <getuint+0xeb>
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80062c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800630:	8b 00                	mov    (%rax),%eax
  800632:	89 c0                	mov    %eax,%eax
  800634:	48 01 d0             	add    %rdx,%rax
  800637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063b:	8b 12                	mov    (%rdx),%edx
  80063d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	89 0a                	mov    %ecx,(%rdx)
  800646:	eb 17                	jmp    80065f <getuint+0x102>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800650:	48 89 d0             	mov    %rdx,%rax
  800653:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065f:	8b 00                	mov    (%rax),%eax
  800661:	89 c0                	mov    %eax,%eax
  800663:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80066b:	c9                   	leaveq 
  80066c:	c3                   	retq   

000000000080066d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80066d:	55                   	push   %rbp
  80066e:	48 89 e5             	mov    %rsp,%rbp
  800671:	48 83 ec 1c          	sub    $0x1c,%rsp
  800675:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800679:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80067c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800680:	7e 52                	jle    8006d4 <getint+0x67>
		x=va_arg(*ap, long long);
  800682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800686:	8b 00                	mov    (%rax),%eax
  800688:	83 f8 30             	cmp    $0x30,%eax
  80068b:	73 24                	jae    8006b1 <getint+0x44>
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800699:	8b 00                	mov    (%rax),%eax
  80069b:	89 c0                	mov    %eax,%eax
  80069d:	48 01 d0             	add    %rdx,%rax
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	8b 12                	mov    (%rdx),%edx
  8006a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ad:	89 0a                	mov    %ecx,(%rdx)
  8006af:	eb 17                	jmp    8006c8 <getint+0x5b>
  8006b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b9:	48 89 d0             	mov    %rdx,%rax
  8006bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c8:	48 8b 00             	mov    (%rax),%rax
  8006cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cf:	e9 a3 00 00 00       	jmpq   800777 <getint+0x10a>
	else if (lflag)
  8006d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d8:	74 4f                	je     800729 <getint+0xbc>
		x=va_arg(*ap, long);
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	8b 00                	mov    (%rax),%eax
  8006e0:	83 f8 30             	cmp    $0x30,%eax
  8006e3:	73 24                	jae    800709 <getint+0x9c>
  8006e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	89 c0                	mov    %eax,%eax
  8006f5:	48 01 d0             	add    %rdx,%rax
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	8b 12                	mov    (%rdx),%edx
  8006fe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	89 0a                	mov    %ecx,(%rdx)
  800707:	eb 17                	jmp    800720 <getint+0xb3>
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800711:	48 89 d0             	mov    %rdx,%rax
  800714:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800720:	48 8b 00             	mov    (%rax),%rax
  800723:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800727:	eb 4e                	jmp    800777 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	83 f8 30             	cmp    $0x30,%eax
  800732:	73 24                	jae    800758 <getint+0xeb>
  800734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800738:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	89 c0                	mov    %eax,%eax
  800744:	48 01 d0             	add    %rdx,%rax
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	8b 12                	mov    (%rdx),%edx
  80074d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	89 0a                	mov    %ecx,(%rdx)
  800756:	eb 17                	jmp    80076f <getint+0x102>
  800758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800760:	48 89 d0             	mov    %rdx,%rax
  800763:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076f:	8b 00                	mov    (%rax),%eax
  800771:	48 98                	cltq   
  800773:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800777:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077b:	c9                   	leaveq 
  80077c:	c3                   	retq   

000000000080077d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80077d:	55                   	push   %rbp
  80077e:	48 89 e5             	mov    %rsp,%rbp
  800781:	41 54                	push   %r12
  800783:	53                   	push   %rbx
  800784:	48 83 ec 60          	sub    $0x60,%rsp
  800788:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80078c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800790:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800794:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800798:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80079c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a0:	48 8b 0a             	mov    (%rdx),%rcx
  8007a3:	48 89 08             	mov    %rcx,(%rax)
  8007a6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007aa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ae:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b6:	eb 17                	jmp    8007cf <vprintfmt+0x52>
			if (ch == '\0')
  8007b8:	85 db                	test   %ebx,%ebx
  8007ba:	0f 84 cc 04 00 00    	je     800c8c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c8:	48 89 d6             	mov    %rdx,%rsi
  8007cb:	89 df                	mov    %ebx,%edi
  8007cd:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007db:	0f b6 00             	movzbl (%rax),%eax
  8007de:	0f b6 d8             	movzbl %al,%ebx
  8007e1:	83 fb 25             	cmp    $0x25,%ebx
  8007e4:	75 d2                	jne    8007b8 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e6:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007ea:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800806:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80080a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80080e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800812:	0f b6 00             	movzbl (%rax),%eax
  800815:	0f b6 d8             	movzbl %al,%ebx
  800818:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80081b:	83 f8 55             	cmp    $0x55,%eax
  80081e:	0f 87 34 04 00 00    	ja     800c58 <vprintfmt+0x4db>
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80082d:	00 
  80082e:	48 b8 58 4a 80 00 00 	movabs $0x804a58,%rax
  800835:	00 00 00 
  800838:	48 01 d0             	add    %rdx,%rax
  80083b:	48 8b 00             	mov    (%rax),%rax
  80083e:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800840:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800844:	eb c0                	jmp    800806 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800846:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80084a:	eb ba                	jmp    800806 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800853:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800856:	89 d0                	mov    %edx,%eax
  800858:	c1 e0 02             	shl    $0x2,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	01 c0                	add    %eax,%eax
  80085f:	01 d8                	add    %ebx,%eax
  800861:	83 e8 30             	sub    $0x30,%eax
  800864:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800867:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80086b:	0f b6 00             	movzbl (%rax),%eax
  80086e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800871:	83 fb 2f             	cmp    $0x2f,%ebx
  800874:	7e 0c                	jle    800882 <vprintfmt+0x105>
  800876:	83 fb 39             	cmp    $0x39,%ebx
  800879:	7f 07                	jg     800882 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800880:	eb d1                	jmp    800853 <vprintfmt+0xd6>
			goto process_precision;
  800882:	eb 58                	jmp    8008dc <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800884:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800887:	83 f8 30             	cmp    $0x30,%eax
  80088a:	73 17                	jae    8008a3 <vprintfmt+0x126>
  80088c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800890:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800893:	89 c0                	mov    %eax,%eax
  800895:	48 01 d0             	add    %rdx,%rax
  800898:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089b:	83 c2 08             	add    $0x8,%edx
  80089e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a1:	eb 0f                	jmp    8008b2 <vprintfmt+0x135>
  8008a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a7:	48 89 d0             	mov    %rdx,%rax
  8008aa:	48 83 c2 08          	add    $0x8,%rdx
  8008ae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b2:	8b 00                	mov    (%rax),%eax
  8008b4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008b7:	eb 23                	jmp    8008dc <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008bd:	79 0c                	jns    8008cb <vprintfmt+0x14e>
				width = 0;
  8008bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008c6:	e9 3b ff ff ff       	jmpq   800806 <vprintfmt+0x89>
  8008cb:	e9 36 ff ff ff       	jmpq   800806 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008d7:	e9 2a ff ff ff       	jmpq   800806 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e0:	79 12                	jns    8008f4 <vprintfmt+0x177>
				width = precision, precision = -1;
  8008e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008e5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008ef:	e9 12 ff ff ff       	jmpq   800806 <vprintfmt+0x89>
  8008f4:	e9 0d ff ff ff       	jmpq   800806 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008fd:	e9 04 ff ff ff       	jmpq   800806 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800902:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800905:	83 f8 30             	cmp    $0x30,%eax
  800908:	73 17                	jae    800921 <vprintfmt+0x1a4>
  80090a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800911:	89 c0                	mov    %eax,%eax
  800913:	48 01 d0             	add    %rdx,%rax
  800916:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800919:	83 c2 08             	add    $0x8,%edx
  80091c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091f:	eb 0f                	jmp    800930 <vprintfmt+0x1b3>
  800921:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800925:	48 89 d0             	mov    %rdx,%rax
  800928:	48 83 c2 08          	add    $0x8,%rdx
  80092c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800930:	8b 10                	mov    (%rax),%edx
  800932:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800936:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093a:	48 89 ce             	mov    %rcx,%rsi
  80093d:	89 d7                	mov    %edx,%edi
  80093f:	ff d0                	callq  *%rax
			break;
  800941:	e9 40 03 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800946:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 17                	jae    800965 <vprintfmt+0x1e8>
  80094e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800952:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800955:	89 c0                	mov    %eax,%eax
  800957:	48 01 d0             	add    %rdx,%rax
  80095a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095d:	83 c2 08             	add    $0x8,%edx
  800960:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800963:	eb 0f                	jmp    800974 <vprintfmt+0x1f7>
  800965:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800969:	48 89 d0             	mov    %rdx,%rax
  80096c:	48 83 c2 08          	add    $0x8,%rdx
  800970:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800974:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800976:	85 db                	test   %ebx,%ebx
  800978:	79 02                	jns    80097c <vprintfmt+0x1ff>
				err = -err;
  80097a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80097c:	83 fb 15             	cmp    $0x15,%ebx
  80097f:	7f 16                	jg     800997 <vprintfmt+0x21a>
  800981:	48 b8 80 49 80 00 00 	movabs $0x804980,%rax
  800988:	00 00 00 
  80098b:	48 63 d3             	movslq %ebx,%rdx
  80098e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800992:	4d 85 e4             	test   %r12,%r12
  800995:	75 2e                	jne    8009c5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800997:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099f:	89 d9                	mov    %ebx,%ecx
  8009a1:	48 ba 41 4a 80 00 00 	movabs $0x804a41,%rdx
  8009a8:	00 00 00 
  8009ab:	48 89 c7             	mov    %rax,%rdi
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b3:	49 b8 95 0c 80 00 00 	movabs $0x800c95,%r8
  8009ba:	00 00 00 
  8009bd:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c0:	e9 c1 02 00 00       	jmpq   800c86 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009c5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009cd:	4c 89 e1             	mov    %r12,%rcx
  8009d0:	48 ba 4a 4a 80 00 00 	movabs $0x804a4a,%rdx
  8009d7:	00 00 00 
  8009da:	48 89 c7             	mov    %rax,%rdi
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e2:	49 b8 95 0c 80 00 00 	movabs $0x800c95,%r8
  8009e9:	00 00 00 
  8009ec:	41 ff d0             	callq  *%r8
			break;
  8009ef:	e9 92 02 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	83 f8 30             	cmp    $0x30,%eax
  8009fa:	73 17                	jae    800a13 <vprintfmt+0x296>
  8009fc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	89 c0                	mov    %eax,%eax
  800a05:	48 01 d0             	add    %rdx,%rax
  800a08:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0b:	83 c2 08             	add    $0x8,%edx
  800a0e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x2a5>
  800a13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a17:	48 89 d0             	mov    %rdx,%rax
  800a1a:	48 83 c2 08          	add    $0x8,%rdx
  800a1e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a22:	4c 8b 20             	mov    (%rax),%r12
  800a25:	4d 85 e4             	test   %r12,%r12
  800a28:	75 0a                	jne    800a34 <vprintfmt+0x2b7>
				p = "(null)";
  800a2a:	49 bc 4d 4a 80 00 00 	movabs $0x804a4d,%r12
  800a31:	00 00 00 
			if (width > 0 && padc != '-')
  800a34:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a38:	7e 3f                	jle    800a79 <vprintfmt+0x2fc>
  800a3a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a3e:	74 39                	je     800a79 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a43:	48 98                	cltq   
  800a45:	48 89 c6             	mov    %rax,%rsi
  800a48:	4c 89 e7             	mov    %r12,%rdi
  800a4b:	48 b8 41 0f 80 00 00 	movabs $0x800f41,%rax
  800a52:	00 00 00 
  800a55:	ff d0                	callq  *%rax
  800a57:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a5a:	eb 17                	jmp    800a73 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a5c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a60:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a68:	48 89 ce             	mov    %rcx,%rsi
  800a6b:	89 d7                	mov    %edx,%edi
  800a6d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a77:	7f e3                	jg     800a5c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	eb 37                	jmp    800ab2 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a7f:	74 1e                	je     800a9f <vprintfmt+0x322>
  800a81:	83 fb 1f             	cmp    $0x1f,%ebx
  800a84:	7e 05                	jle    800a8b <vprintfmt+0x30e>
  800a86:	83 fb 7e             	cmp    $0x7e,%ebx
  800a89:	7e 14                	jle    800a9f <vprintfmt+0x322>
					putch('?', putdat);
  800a8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a93:	48 89 d6             	mov    %rdx,%rsi
  800a96:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a9b:	ff d0                	callq  *%rax
  800a9d:	eb 0f                	jmp    800aae <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa7:	48 89 d6             	mov    %rdx,%rsi
  800aaa:	89 df                	mov    %ebx,%edi
  800aac:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aae:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ab2:	4c 89 e0             	mov    %r12,%rax
  800ab5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ab9:	0f b6 00             	movzbl (%rax),%eax
  800abc:	0f be d8             	movsbl %al,%ebx
  800abf:	85 db                	test   %ebx,%ebx
  800ac1:	74 10                	je     800ad3 <vprintfmt+0x356>
  800ac3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ac7:	78 b2                	js     800a7b <vprintfmt+0x2fe>
  800ac9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800acd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad1:	79 a8                	jns    800a7b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad3:	eb 16                	jmp    800aeb <vprintfmt+0x36e>
				putch(' ', putdat);
  800ad5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  800ae5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ae7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aeb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aef:	7f e4                	jg     800ad5 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800af1:	e9 90 01 00 00       	jmpq   800c86 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800af6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800afa:	be 03 00 00 00       	mov    $0x3,%esi
  800aff:	48 89 c7             	mov    %rax,%rdi
  800b02:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800b09:	00 00 00 
  800b0c:	ff d0                	callq  *%rax
  800b0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	48 85 c0             	test   %rax,%rax
  800b19:	79 1d                	jns    800b38 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	48 89 d6             	mov    %rdx,%rsi
  800b26:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b2b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b31:	48 f7 d8             	neg    %rax
  800b34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b38:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b3f:	e9 d5 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b48:	be 03 00 00 00       	mov    $0x3,%esi
  800b4d:	48 89 c7             	mov    %rax,%rdi
  800b50:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800b57:	00 00 00 
  800b5a:	ff d0                	callq  *%rax
  800b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b60:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b67:	e9 ad 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800b6c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800b6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b73:	89 d6                	mov    %edx,%esi
  800b75:	48 89 c7             	mov    %rax,%rdi
  800b78:	48 b8 6d 06 80 00 00 	movabs $0x80066d,%rax
  800b7f:	00 00 00 
  800b82:	ff d0                	callq  *%rax
  800b84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b88:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b8f:	e9 85 00 00 00       	jmpq   800c19 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800b94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9c:	48 89 d6             	mov    %rdx,%rsi
  800b9f:	bf 30 00 00 00       	mov    $0x30,%edi
  800ba4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ba6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800baa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bae:	48 89 d6             	mov    %rdx,%rsi
  800bb1:	bf 78 00 00 00       	mov    $0x78,%edi
  800bb6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bb8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbb:	83 f8 30             	cmp    $0x30,%eax
  800bbe:	73 17                	jae    800bd7 <vprintfmt+0x45a>
  800bc0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc7:	89 c0                	mov    %eax,%eax
  800bc9:	48 01 d0             	add    %rdx,%rax
  800bcc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcf:	83 c2 08             	add    $0x8,%edx
  800bd2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd5:	eb 0f                	jmp    800be6 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800bd7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdb:	48 89 d0             	mov    %rdx,%rax
  800bde:	48 83 c2 08          	add    $0x8,%rdx
  800be2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be6:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800be9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bed:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bf6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bfa:	be 03 00 00 00       	mov    $0x3,%esi
  800bff:	48 89 c7             	mov    %rax,%rdi
  800c02:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800c09:	00 00 00 
  800c0c:	ff d0                	callq  *%rax
  800c0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c12:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c19:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c1e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c21:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c30:	45 89 c1             	mov    %r8d,%r9d
  800c33:	41 89 f8             	mov    %edi,%r8d
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 a2 04 80 00 00 	movabs $0x8004a2,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
			break;
  800c45:	eb 3f                	jmp    800c86 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4f:	48 89 d6             	mov    %rdx,%rsi
  800c52:	89 df                	mov    %ebx,%edi
  800c54:	ff d0                	callq  *%rax
			break;
  800c56:	eb 2e                	jmp    800c86 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c60:	48 89 d6             	mov    %rdx,%rsi
  800c63:	bf 25 00 00 00       	mov    $0x25,%edi
  800c68:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c6f:	eb 05                	jmp    800c76 <vprintfmt+0x4f9>
  800c71:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c7a:	48 83 e8 01          	sub    $0x1,%rax
  800c7e:	0f b6 00             	movzbl (%rax),%eax
  800c81:	3c 25                	cmp    $0x25,%al
  800c83:	75 ec                	jne    800c71 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c85:	90                   	nop
		}
	}
  800c86:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c87:	e9 43 fb ff ff       	jmpq   8007cf <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c8c:	48 83 c4 60          	add    $0x60,%rsp
  800c90:	5b                   	pop    %rbx
  800c91:	41 5c                	pop    %r12
  800c93:	5d                   	pop    %rbp
  800c94:	c3                   	retq   

0000000000800c95 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c95:	55                   	push   %rbp
  800c96:	48 89 e5             	mov    %rsp,%rbp
  800c99:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ca7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cbc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 20                	je     800ce7 <printfmt+0x52>
  800cc7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ccb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cdb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cee:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cf5:	00 00 00 
  800cf8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cff:	00 00 00 
  800d02:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d0d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d14:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d1b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d22:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d29:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d30:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d37:	48 89 c7             	mov    %rax,%rdi
  800d3a:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800d41:	00 00 00 
  800d44:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d46:	c9                   	leaveq 
  800d47:	c3                   	retq   

0000000000800d48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d48:	55                   	push   %rbp
  800d49:	48 89 e5             	mov    %rsp,%rbp
  800d4c:	48 83 ec 10          	sub    $0x10,%rsp
  800d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d5b:	8b 40 10             	mov    0x10(%rax),%eax
  800d5e:	8d 50 01             	lea    0x1(%rax),%edx
  800d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d65:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6c:	48 8b 10             	mov    (%rax),%rdx
  800d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d73:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d77:	48 39 c2             	cmp    %rax,%rdx
  800d7a:	73 17                	jae    800d93 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d80:	48 8b 00             	mov    (%rax),%rax
  800d83:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d8b:	48 89 0a             	mov    %rcx,(%rdx)
  800d8e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d91:	88 10                	mov    %dl,(%rax)
}
  800d93:	c9                   	leaveq 
  800d94:	c3                   	retq   

0000000000800d95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d95:	55                   	push   %rbp
  800d96:	48 89 e5             	mov    %rsp,%rbp
  800d99:	48 83 ec 50          	sub    $0x50,%rsp
  800d9d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800da1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800da4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800da8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dac:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800db4:	48 8b 0a             	mov    (%rdx),%rcx
  800db7:	48 89 08             	mov    %rcx,(%rax)
  800dba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dbe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dc2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dce:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dd2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dd5:	48 98                	cltq   
  800dd7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ddb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ddf:	48 01 d0             	add    %rdx,%rax
  800de2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800de6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ded:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800df2:	74 06                	je     800dfa <vsnprintf+0x65>
  800df4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800df8:	7f 07                	jg     800e01 <vsnprintf+0x6c>
		return -E_INVAL;
  800dfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dff:	eb 2f                	jmp    800e30 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e01:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e05:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e09:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e0d:	48 89 c6             	mov    %rax,%rsi
  800e10:	48 bf 48 0d 80 00 00 	movabs $0x800d48,%rdi
  800e17:	00 00 00 
  800e1a:	48 b8 7d 07 80 00 00 	movabs $0x80077d,%rax
  800e21:	00 00 00 
  800e24:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e2d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e30:	c9                   	leaveq 
  800e31:	c3                   	retq   

0000000000800e32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e32:	55                   	push   %rbp
  800e33:	48 89 e5             	mov    %rsp,%rbp
  800e36:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e3d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e44:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e4a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e51:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e58:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e5f:	84 c0                	test   %al,%al
  800e61:	74 20                	je     800e83 <snprintf+0x51>
  800e63:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e67:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e6f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e73:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e77:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e7f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e83:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e8a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e91:	00 00 00 
  800e94:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e9b:	00 00 00 
  800e9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ea2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ea9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800eb7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ebe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec5:	48 8b 0a             	mov    (%rdx),%rcx
  800ec8:	48 89 08             	mov    %rcx,(%rax)
  800ecb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ecf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ed3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800edb:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ee2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ee9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800eef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ef6:	48 89 c7             	mov    %rax,%rdi
  800ef9:	48 b8 95 0d 80 00 00 	movabs $0x800d95,%rax
  800f00:	00 00 00 
  800f03:	ff d0                	callq  *%rax
  800f05:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f0b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f11:	c9                   	leaveq 
  800f12:	c3                   	retq   

0000000000800f13 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f13:	55                   	push   %rbp
  800f14:	48 89 e5             	mov    %rsp,%rbp
  800f17:	48 83 ec 18          	sub    $0x18,%rsp
  800f1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f26:	eb 09                	jmp    800f31 <strlen+0x1e>
		n++;
  800f28:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f2c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f35:	0f b6 00             	movzbl (%rax),%eax
  800f38:	84 c0                	test   %al,%al
  800f3a:	75 ec                	jne    800f28 <strlen+0x15>
		n++;
	return n;
  800f3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3f:	c9                   	leaveq 
  800f40:	c3                   	retq   

0000000000800f41 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f41:	55                   	push   %rbp
  800f42:	48 89 e5             	mov    %rsp,%rbp
  800f45:	48 83 ec 20          	sub    $0x20,%rsp
  800f49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f58:	eb 0e                	jmp    800f68 <strnlen+0x27>
		n++;
  800f5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f63:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f68:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f6d:	74 0b                	je     800f7a <strnlen+0x39>
  800f6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f73:	0f b6 00             	movzbl (%rax),%eax
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e0                	jne    800f5a <strnlen+0x19>
		n++;
	return n;
  800f7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f7d:	c9                   	leaveq 
  800f7e:	c3                   	retq   

0000000000800f7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f7f:	55                   	push   %rbp
  800f80:	48 89 e5             	mov    %rsp,%rbp
  800f83:	48 83 ec 20          	sub    $0x20,%rsp
  800f87:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f97:	90                   	nop
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fac:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb0:	0f b6 12             	movzbl (%rdx),%edx
  800fb3:	88 10                	mov    %dl,(%rax)
  800fb5:	0f b6 00             	movzbl (%rax),%eax
  800fb8:	84 c0                	test   %al,%al
  800fba:	75 dc                	jne    800f98 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 20          	sub    $0x20,%rsp
  800fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd6:	48 89 c7             	mov    %rax,%rdi
  800fd9:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  800fe0:	00 00 00 
  800fe3:	ff d0                	callq  *%rax
  800fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800feb:	48 63 d0             	movslq %eax,%rdx
  800fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff2:	48 01 c2             	add    %rax,%rdx
  800ff5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff9:	48 89 c6             	mov    %rax,%rsi
  800ffc:	48 89 d7             	mov    %rdx,%rdi
  800fff:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  801006:	00 00 00 
  801009:	ff d0                	callq  *%rax
	return dst;
  80100b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80100f:	c9                   	leaveq 
  801010:	c3                   	retq   

0000000000801011 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801011:	55                   	push   %rbp
  801012:	48 89 e5             	mov    %rsp,%rbp
  801015:	48 83 ec 28          	sub    $0x28,%rsp
  801019:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801021:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801029:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80102d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801034:	00 
  801035:	eb 2a                	jmp    801061 <strncpy+0x50>
		*dst++ = *src;
  801037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80103f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801043:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801047:	0f b6 12             	movzbl (%rdx),%edx
  80104a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80104c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801050:	0f b6 00             	movzbl (%rax),%eax
  801053:	84 c0                	test   %al,%al
  801055:	74 05                	je     80105c <strncpy+0x4b>
			src++;
  801057:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80105c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801061:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801065:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801069:	72 cc                	jb     801037 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80106b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 28          	sub    $0x28,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801081:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801089:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80108d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801092:	74 3d                	je     8010d1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801094:	eb 1d                	jmp    8010b3 <strlcpy+0x42>
			*dst++ = *src++;
  801096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80109e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010a2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010a6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010aa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ae:	0f b6 12             	movzbl (%rdx),%edx
  8010b1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010bd:	74 0b                	je     8010ca <strlcpy+0x59>
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	0f b6 00             	movzbl (%rax),%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 cc                	jne    801096 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ce:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d9:	48 29 c2             	sub    %rax,%rdx
  8010dc:	48 89 d0             	mov    %rdx,%rax
}
  8010df:	c9                   	leaveq 
  8010e0:	c3                   	retq   

00000000008010e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e1:	55                   	push   %rbp
  8010e2:	48 89 e5             	mov    %rsp,%rbp
  8010e5:	48 83 ec 10          	sub    $0x10,%rsp
  8010e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010f1:	eb 0a                	jmp    8010fd <strcmp+0x1c>
		p++, q++;
  8010f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801101:	0f b6 00             	movzbl (%rax),%eax
  801104:	84 c0                	test   %al,%al
  801106:	74 12                	je     80111a <strcmp+0x39>
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110c:	0f b6 10             	movzbl (%rax),%edx
  80110f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	38 c2                	cmp    %al,%dl
  801118:	74 d9                	je     8010f3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111e:	0f b6 00             	movzbl (%rax),%eax
  801121:	0f b6 d0             	movzbl %al,%edx
  801124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801128:	0f b6 00             	movzbl (%rax),%eax
  80112b:	0f b6 c0             	movzbl %al,%eax
  80112e:	29 c2                	sub    %eax,%edx
  801130:	89 d0                	mov    %edx,%eax
}
  801132:	c9                   	leaveq 
  801133:	c3                   	retq   

0000000000801134 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801134:	55                   	push   %rbp
  801135:	48 89 e5             	mov    %rsp,%rbp
  801138:	48 83 ec 18          	sub    $0x18,%rsp
  80113c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801144:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801148:	eb 0f                	jmp    801159 <strncmp+0x25>
		n--, p++, q++;
  80114a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80114f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801154:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801159:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115e:	74 1d                	je     80117d <strncmp+0x49>
  801160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801164:	0f b6 00             	movzbl (%rax),%eax
  801167:	84 c0                	test   %al,%al
  801169:	74 12                	je     80117d <strncmp+0x49>
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	0f b6 10             	movzbl (%rax),%edx
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801176:	0f b6 00             	movzbl (%rax),%eax
  801179:	38 c2                	cmp    %al,%dl
  80117b:	74 cd                	je     80114a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80117d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801182:	75 07                	jne    80118b <strncmp+0x57>
		return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
  801189:	eb 18                	jmp    8011a3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80118b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118f:	0f b6 00             	movzbl (%rax),%eax
  801192:	0f b6 d0             	movzbl %al,%edx
  801195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
}
  8011a3:	c9                   	leaveq 
  8011a4:	c3                   	retq   

00000000008011a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a5:	55                   	push   %rbp
  8011a6:	48 89 e5             	mov    %rsp,%rbp
  8011a9:	48 83 ec 0c          	sub    $0xc,%rsp
  8011ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b6:	eb 17                	jmp    8011cf <strchr+0x2a>
		if (*s == c)
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 00             	movzbl (%rax),%eax
  8011bf:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011c2:	75 06                	jne    8011ca <strchr+0x25>
			return (char *) s;
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c8:	eb 15                	jmp    8011df <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	75 de                	jne    8011b8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011df:	c9                   	leaveq 
  8011e0:	c3                   	retq   

00000000008011e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011e1:	55                   	push   %rbp
  8011e2:	48 89 e5             	mov    %rsp,%rbp
  8011e5:	48 83 ec 0c          	sub    $0xc,%rsp
  8011e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ed:	89 f0                	mov    %esi,%eax
  8011ef:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011f2:	eb 13                	jmp    801207 <strfind+0x26>
		if (*s == c)
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	0f b6 00             	movzbl (%rax),%eax
  8011fb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011fe:	75 02                	jne    801202 <strfind+0x21>
			break;
  801200:	eb 10                	jmp    801212 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801202:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	84 c0                	test   %al,%al
  801210:	75 e2                	jne    8011f4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801216:	c9                   	leaveq 
  801217:	c3                   	retq   

0000000000801218 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801218:	55                   	push   %rbp
  801219:	48 89 e5             	mov    %rsp,%rbp
  80121c:	48 83 ec 18          	sub    $0x18,%rsp
  801220:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801224:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801227:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80122b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801230:	75 06                	jne    801238 <memset+0x20>
		return v;
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	eb 69                	jmp    8012a1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	83 e0 03             	and    $0x3,%eax
  80123f:	48 85 c0             	test   %rax,%rax
  801242:	75 48                	jne    80128c <memset+0x74>
  801244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801248:	83 e0 03             	and    $0x3,%eax
  80124b:	48 85 c0             	test   %rax,%rax
  80124e:	75 3c                	jne    80128c <memset+0x74>
		c &= 0xFF;
  801250:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801257:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80125a:	c1 e0 18             	shl    $0x18,%eax
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801262:	c1 e0 10             	shl    $0x10,%eax
  801265:	09 c2                	or     %eax,%edx
  801267:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126a:	c1 e0 08             	shl    $0x8,%eax
  80126d:	09 d0                	or     %edx,%eax
  80126f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 c1 e8 02          	shr    $0x2,%rax
  80127a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80127d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801281:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801284:	48 89 d7             	mov    %rdx,%rdi
  801287:	fc                   	cld    
  801288:	f3 ab                	rep stos %eax,%es:(%rdi)
  80128a:	eb 11                	jmp    80129d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80128c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801290:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801293:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801297:	48 89 d7             	mov    %rdx,%rdi
  80129a:	fc                   	cld    
  80129b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80129d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 28          	sub    $0x28,%rsp
  8012ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012cf:	0f 83 88 00 00 00    	jae    80135d <memmove+0xba>
  8012d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012dd:	48 01 d0             	add    %rdx,%rax
  8012e0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012e4:	76 77                	jbe    80135d <memmove+0xba>
		s += n;
  8012e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ea:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fa:	83 e0 03             	and    $0x3,%eax
  8012fd:	48 85 c0             	test   %rax,%rax
  801300:	75 3b                	jne    80133d <memmove+0x9a>
  801302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801306:	83 e0 03             	and    $0x3,%eax
  801309:	48 85 c0             	test   %rax,%rax
  80130c:	75 2f                	jne    80133d <memmove+0x9a>
  80130e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	48 85 c0             	test   %rax,%rax
  801318:	75 23                	jne    80133d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80131a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131e:	48 83 e8 04          	sub    $0x4,%rax
  801322:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801326:	48 83 ea 04          	sub    $0x4,%rdx
  80132a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80132e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 89 d6             	mov    %rdx,%rsi
  801338:	fd                   	std    
  801339:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80133b:	eb 1d                	jmp    80135a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80133d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801341:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801349:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80134d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801351:	48 89 d7             	mov    %rdx,%rdi
  801354:	48 89 c1             	mov    %rax,%rcx
  801357:	fd                   	std    
  801358:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80135a:	fc                   	cld    
  80135b:	eb 57                	jmp    8013b4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80135d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801361:	83 e0 03             	and    $0x3,%eax
  801364:	48 85 c0             	test   %rax,%rax
  801367:	75 36                	jne    80139f <memmove+0xfc>
  801369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	48 85 c0             	test   %rax,%rax
  801373:	75 2a                	jne    80139f <memmove+0xfc>
  801375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801379:	83 e0 03             	and    $0x3,%eax
  80137c:	48 85 c0             	test   %rax,%rax
  80137f:	75 1e                	jne    80139f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	48 c1 e8 02          	shr    $0x2,%rax
  801389:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80138c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801390:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801394:	48 89 c7             	mov    %rax,%rdi
  801397:	48 89 d6             	mov    %rdx,%rsi
  80139a:	fc                   	cld    
  80139b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80139d:	eb 15                	jmp    8013b4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80139f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ab:	48 89 c7             	mov    %rax,%rdi
  8013ae:	48 89 d6             	mov    %rdx,%rsi
  8013b1:	fc                   	cld    
  8013b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 18          	sub    $0x18,%rsp
  8013c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	48 89 ce             	mov    %rcx,%rsi
  8013dd:	48 89 c7             	mov    %rax,%rdi
  8013e0:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8013e7:	00 00 00 
  8013ea:	ff d0                	callq  *%rax
}
  8013ec:	c9                   	leaveq 
  8013ed:	c3                   	retq   

00000000008013ee <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
  8013f2:	48 83 ec 28          	sub    $0x28,%rsp
  8013f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80140a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801412:	eb 36                	jmp    80144a <memcmp+0x5c>
		if (*s1 != *s2)
  801414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801418:	0f b6 10             	movzbl (%rax),%edx
  80141b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	38 c2                	cmp    %al,%dl
  801424:	74 1a                	je     801440 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	0f b6 d0             	movzbl %al,%edx
  801430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	0f b6 c0             	movzbl %al,%eax
  80143a:	29 c2                	sub    %eax,%edx
  80143c:	89 d0                	mov    %edx,%eax
  80143e:	eb 20                	jmp    801460 <memcmp+0x72>
		s1++, s2++;
  801440:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801445:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801452:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801456:	48 85 c0             	test   %rax,%rax
  801459:	75 b9                	jne    801414 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801460:	c9                   	leaveq 
  801461:	c3                   	retq   

0000000000801462 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801462:	55                   	push   %rbp
  801463:	48 89 e5             	mov    %rsp,%rbp
  801466:	48 83 ec 28          	sub    $0x28,%rsp
  80146a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80147d:	48 01 d0             	add    %rdx,%rax
  801480:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801484:	eb 15                	jmp    80149b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	0f b6 10             	movzbl (%rax),%edx
  80148d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801490:	38 c2                	cmp    %al,%dl
  801492:	75 02                	jne    801496 <memfind+0x34>
			break;
  801494:	eb 0f                	jmp    8014a5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801496:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80149b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014a3:	72 e1                	jb     801486 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 34          	sub    $0x34,%rsp
  8014b3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014b7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014bb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014c5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014cc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014cd:	eb 05                	jmp    8014d4 <strtol+0x29>
		s++;
  8014cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	3c 20                	cmp    $0x20,%al
  8014dd:	74 f0                	je     8014cf <strtol+0x24>
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	3c 09                	cmp    $0x9,%al
  8014e8:	74 e5                	je     8014cf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	3c 2b                	cmp    $0x2b,%al
  8014f3:	75 07                	jne    8014fc <strtol+0x51>
		s++;
  8014f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014fa:	eb 17                	jmp    801513 <strtol+0x68>
	else if (*s == '-')
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	3c 2d                	cmp    $0x2d,%al
  801505:	75 0c                	jne    801513 <strtol+0x68>
		s++, neg = 1;
  801507:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80150c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801513:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801517:	74 06                	je     80151f <strtol+0x74>
  801519:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80151d:	75 28                	jne    801547 <strtol+0x9c>
  80151f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801523:	0f b6 00             	movzbl (%rax),%eax
  801526:	3c 30                	cmp    $0x30,%al
  801528:	75 1d                	jne    801547 <strtol+0x9c>
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	48 83 c0 01          	add    $0x1,%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	3c 78                	cmp    $0x78,%al
  801537:	75 0e                	jne    801547 <strtol+0x9c>
		s += 2, base = 16;
  801539:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80153e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801545:	eb 2c                	jmp    801573 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801547:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80154b:	75 19                	jne    801566 <strtol+0xbb>
  80154d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	3c 30                	cmp    $0x30,%al
  801556:	75 0e                	jne    801566 <strtol+0xbb>
		s++, base = 8;
  801558:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80155d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801564:	eb 0d                	jmp    801573 <strtol+0xc8>
	else if (base == 0)
  801566:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80156a:	75 07                	jne    801573 <strtol+0xc8>
		base = 10;
  80156c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801577:	0f b6 00             	movzbl (%rax),%eax
  80157a:	3c 2f                	cmp    $0x2f,%al
  80157c:	7e 1d                	jle    80159b <strtol+0xf0>
  80157e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801582:	0f b6 00             	movzbl (%rax),%eax
  801585:	3c 39                	cmp    $0x39,%al
  801587:	7f 12                	jg     80159b <strtol+0xf0>
			dig = *s - '0';
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	0f be c0             	movsbl %al,%eax
  801593:	83 e8 30             	sub    $0x30,%eax
  801596:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801599:	eb 4e                	jmp    8015e9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	3c 60                	cmp    $0x60,%al
  8015a4:	7e 1d                	jle    8015c3 <strtol+0x118>
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 7a                	cmp    $0x7a,%al
  8015af:	7f 12                	jg     8015c3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	0f be c0             	movsbl %al,%eax
  8015bb:	83 e8 57             	sub    $0x57,%eax
  8015be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c1:	eb 26                	jmp    8015e9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	3c 40                	cmp    $0x40,%al
  8015cc:	7e 48                	jle    801616 <strtol+0x16b>
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 5a                	cmp    $0x5a,%al
  8015d7:	7f 3d                	jg     801616 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	0f be c0             	movsbl %al,%eax
  8015e3:	83 e8 37             	sub    $0x37,%eax
  8015e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015ec:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ef:	7c 02                	jl     8015f3 <strtol+0x148>
			break;
  8015f1:	eb 23                	jmp    801616 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015fb:	48 98                	cltq   
  8015fd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801602:	48 89 c2             	mov    %rax,%rdx
  801605:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801608:	48 98                	cltq   
  80160a:	48 01 d0             	add    %rdx,%rax
  80160d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801611:	e9 5d ff ff ff       	jmpq   801573 <strtol+0xc8>

	if (endptr)
  801616:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80161b:	74 0b                	je     801628 <strtol+0x17d>
		*endptr = (char *) s;
  80161d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801621:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801625:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801628:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80162c:	74 09                	je     801637 <strtol+0x18c>
  80162e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801632:	48 f7 d8             	neg    %rax
  801635:	eb 04                	jmp    80163b <strtol+0x190>
  801637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80163b:	c9                   	leaveq 
  80163c:	c3                   	retq   

000000000080163d <strstr>:

char * strstr(const char *in, const char *str)
{
  80163d:	55                   	push   %rbp
  80163e:	48 89 e5             	mov    %rsp,%rbp
  801641:	48 83 ec 30          	sub    $0x30,%rsp
  801645:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801649:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80164d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801651:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801655:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80165f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801663:	75 06                	jne    80166b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	eb 6b                	jmp    8016d6 <strstr+0x99>

	len = strlen(str);
  80166b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80166f:	48 89 c7             	mov    %rax,%rdi
  801672:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  801679:	00 00 00 
  80167c:	ff d0                	callq  *%rax
  80167e:	48 98                	cltq   
  801680:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80168c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801690:	0f b6 00             	movzbl (%rax),%eax
  801693:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801696:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80169a:	75 07                	jne    8016a3 <strstr+0x66>
				return (char *) 0;
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a1:	eb 33                	jmp    8016d6 <strstr+0x99>
		} while (sc != c);
  8016a3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016a7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016aa:	75 d8                	jne    801684 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	48 89 ce             	mov    %rcx,%rsi
  8016bb:	48 89 c7             	mov    %rax,%rdi
  8016be:	48 b8 34 11 80 00 00 	movabs $0x801134,%rax
  8016c5:	00 00 00 
  8016c8:	ff d0                	callq  *%rax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	75 b6                	jne    801684 <strstr+0x47>

	return (char *) (in - 1);
  8016ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d2:	48 83 e8 01          	sub    $0x1,%rax
}
  8016d6:	c9                   	leaveq 
  8016d7:	c3                   	retq   

00000000008016d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016d8:	55                   	push   %rbp
  8016d9:	48 89 e5             	mov    %rsp,%rbp
  8016dc:	53                   	push   %rbx
  8016dd:	48 83 ec 48          	sub    $0x48,%rsp
  8016e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016e4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ef:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016f3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016fa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016fe:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801702:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801706:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80170a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80170e:	4c 89 c3             	mov    %r8,%rbx
  801711:	cd 30                	int    $0x30
  801713:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801717:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80171b:	74 3e                	je     80175b <syscall+0x83>
  80171d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801722:	7e 37                	jle    80175b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801724:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801728:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80172b:	49 89 d0             	mov    %rdx,%r8
  80172e:	89 c1                	mov    %eax,%ecx
  801730:	48 ba 08 4d 80 00 00 	movabs $0x804d08,%rdx
  801737:	00 00 00 
  80173a:	be 23 00 00 00       	mov    $0x23,%esi
  80173f:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  801746:	00 00 00 
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
  80174e:	49 b9 f5 44 80 00 00 	movabs $0x8044f5,%r9
  801755:	00 00 00 
  801758:	41 ff d1             	callq  *%r9

	return ret;
  80175b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80175f:	48 83 c4 48          	add    $0x48,%rsp
  801763:	5b                   	pop    %rbx
  801764:	5d                   	pop    %rbp
  801765:	c3                   	retq   

0000000000801766 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801766:	55                   	push   %rbp
  801767:	48 89 e5             	mov    %rsp,%rbp
  80176a:	48 83 ec 20          	sub    $0x20,%rsp
  80176e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801772:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801785:	00 
  801786:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801792:	48 89 d1             	mov    %rdx,%rcx
  801795:	48 89 c2             	mov    %rax,%rdx
  801798:	be 00 00 00 00       	mov    $0x0,%esi
  80179d:	bf 00 00 00 00       	mov    $0x0,%edi
  8017a2:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
}
  8017ae:	c9                   	leaveq 
  8017af:	c3                   	retq   

00000000008017b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b0:	55                   	push   %rbp
  8017b1:	48 89 e5             	mov    %rsp,%rbp
  8017b4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017b8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bf:	00 
  8017c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d6:	be 00 00 00 00       	mov    $0x0,%esi
  8017db:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
}
  8017ec:	c9                   	leaveq 
  8017ed:	c3                   	retq   

00000000008017ee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ee:	55                   	push   %rbp
  8017ef:	48 89 e5             	mov    %rsp,%rbp
  8017f2:	48 83 ec 10          	sub    $0x10,%rsp
  8017f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fc:	48 98                	cltq   
  8017fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801805:	00 
  801806:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801812:	b9 00 00 00 00       	mov    $0x0,%ecx
  801817:	48 89 c2             	mov    %rax,%rdx
  80181a:	be 01 00 00 00       	mov    $0x1,%esi
  80181f:	bf 03 00 00 00       	mov    $0x3,%edi
  801824:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
}
  801830:	c9                   	leaveq 
  801831:	c3                   	retq   

0000000000801832 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80183a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801841:	00 
  801842:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801848:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	be 00 00 00 00       	mov    $0x0,%esi
  80185d:	bf 02 00 00 00       	mov    $0x2,%edi
  801862:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
}
  80186e:	c9                   	leaveq 
  80186f:	c3                   	retq   

0000000000801870 <sys_yield>:

void
sys_yield(void)
{
  801870:	55                   	push   %rbp
  801871:	48 89 e5             	mov    %rsp,%rbp
  801874:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801878:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187f:	00 
  801880:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801886:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	be 00 00 00 00       	mov    $0x0,%esi
  80189b:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c3:	48 63 c8             	movslq %eax,%rcx
  8018c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cd:	48 98                	cltq   
  8018cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d6:	00 
  8018d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dd:	49 89 c8             	mov    %rcx,%r8
  8018e0:	48 89 d1             	mov    %rdx,%rcx
  8018e3:	48 89 c2             	mov    %rax,%rdx
  8018e6:	be 01 00 00 00       	mov    $0x1,%esi
  8018eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8018f7:	00 00 00 
  8018fa:	ff d0                	callq  *%rax
}
  8018fc:	c9                   	leaveq 
  8018fd:	c3                   	retq   

00000000008018fe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018fe:	55                   	push   %rbp
  8018ff:	48 89 e5             	mov    %rsp,%rbp
  801902:	48 83 ec 30          	sub    $0x30,%rsp
  801906:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801909:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801910:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801914:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801918:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191b:	48 63 c8             	movslq %eax,%rcx
  80191e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801922:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801925:	48 63 f0             	movslq %eax,%rsi
  801928:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192f:	48 98                	cltq   
  801931:	48 89 0c 24          	mov    %rcx,(%rsp)
  801935:	49 89 f9             	mov    %rdi,%r9
  801938:	49 89 f0             	mov    %rsi,%r8
  80193b:	48 89 d1             	mov    %rdx,%rcx
  80193e:	48 89 c2             	mov    %rax,%rdx
  801941:	be 01 00 00 00       	mov    $0x1,%esi
  801946:	bf 05 00 00 00       	mov    $0x5,%edi
  80194b:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
}
  801957:	c9                   	leaveq 
  801958:	c3                   	retq   

0000000000801959 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801959:	55                   	push   %rbp
  80195a:	48 89 e5             	mov    %rsp,%rbp
  80195d:	48 83 ec 20          	sub    $0x20,%rsp
  801961:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801964:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196f:	48 98                	cltq   
  801971:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801978:	00 
  801979:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801985:	48 89 d1             	mov    %rdx,%rcx
  801988:	48 89 c2             	mov    %rax,%rdx
  80198b:	be 01 00 00 00       	mov    $0x1,%esi
  801990:	bf 06 00 00 00       	mov    $0x6,%edi
  801995:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  80199c:	00 00 00 
  80199f:	ff d0                	callq  *%rax
}
  8019a1:	c9                   	leaveq 
  8019a2:	c3                   	retq   

00000000008019a3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	48 83 ec 10          	sub    $0x10,%rsp
  8019ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b4:	48 63 d0             	movslq %eax,%rdx
  8019b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ba:	48 98                	cltq   
  8019bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c3:	00 
  8019c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d0:	48 89 d1             	mov    %rdx,%rcx
  8019d3:	48 89 c2             	mov    %rax,%rdx
  8019d6:	be 01 00 00 00       	mov    $0x1,%esi
  8019db:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e0:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  8019e7:	00 00 00 
  8019ea:	ff d0                	callq  *%rax
}
  8019ec:	c9                   	leaveq 
  8019ed:	c3                   	retq   

00000000008019ee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019ee:	55                   	push   %rbp
  8019ef:	48 89 e5             	mov    %rsp,%rbp
  8019f2:	48 83 ec 20          	sub    $0x20,%rsp
  8019f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a04:	48 98                	cltq   
  801a06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0d:	00 
  801a0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1a:	48 89 d1             	mov    %rdx,%rcx
  801a1d:	48 89 c2             	mov    %rax,%rdx
  801a20:	be 01 00 00 00       	mov    $0x1,%esi
  801a25:	bf 09 00 00 00       	mov    $0x9,%edi
  801a2a:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4e:	48 98                	cltq   
  801a50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a57:	00 
  801a58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a64:	48 89 d1             	mov    %rdx,%rcx
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	be 01 00 00 00       	mov    $0x1,%esi
  801a6f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a74:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801a7b:	00 00 00 
  801a7e:	ff d0                	callq  *%rax
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
  801a86:	48 83 ec 20          	sub    $0x20,%rsp
  801a8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a91:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a95:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9b:	48 63 f0             	movslq %eax,%rsi
  801a9e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa5:	48 98                	cltq   
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab2:	00 
  801ab3:	49 89 f1             	mov    %rsi,%r9
  801ab6:	49 89 c8             	mov    %rcx,%r8
  801ab9:	48 89 d1             	mov    %rdx,%rcx
  801abc:	48 89 c2             	mov    %rax,%rdx
  801abf:	be 00 00 00 00       	mov    $0x0,%esi
  801ac4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ac9:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	callq  *%rax
}
  801ad5:	c9                   	leaveq 
  801ad6:	c3                   	retq   

0000000000801ad7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	48 83 ec 10          	sub    $0x10,%rsp
  801adf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aee:	00 
  801aef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801afb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b00:	48 89 c2             	mov    %rax,%rdx
  801b03:	be 01 00 00 00       	mov    $0x1,%esi
  801b08:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b0d:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	callq  *%rax
}
  801b19:	c9                   	leaveq 
  801b1a:	c3                   	retq   

0000000000801b1b <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 20          	sub    $0x20,%rsp
  801b23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3a:	00 
  801b3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b47:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4c:	89 c6                	mov    %eax,%esi
  801b4e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b53:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 20          	sub    $0x20,%rsp
  801b69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b92:	89 c6                	mov    %eax,%esi
  801b94:	bf 10 00 00 00       	mov    $0x10,%edi
  801b99:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801ba0:	00 00 00 
  801ba3:	ff d0                	callq  *%rax
}
  801ba5:	c9                   	leaveq 
  801ba6:	c3                   	retq   

0000000000801ba7 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ba7:	55                   	push   %rbp
  801ba8:	48 89 e5             	mov    %rsp,%rbp
  801bab:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801baf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb6:	00 
  801bb7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcd:	be 00 00 00 00       	mov    $0x0,%esi
  801bd2:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bd7:	48 b8 d8 16 80 00 00 	movabs $0x8016d8,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 30          	sub    $0x30,%rsp
  801bed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf5:	48 8b 00             	mov    (%rax),%rax
  801bf8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801bfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c00:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c04:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801c07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c0a:	83 e0 02             	and    $0x2,%eax
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	75 4d                	jne    801c5e <pgfault+0x79>
  801c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c15:	48 c1 e8 0c          	shr    $0xc,%rax
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c23:	01 00 00 
  801c26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2a:	25 00 08 00 00       	and    $0x800,%eax
  801c2f:	48 85 c0             	test   %rax,%rax
  801c32:	74 2a                	je     801c5e <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801c34:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  801c3b:	00 00 00 
  801c3e:	be 23 00 00 00       	mov    $0x23,%esi
  801c43:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801c4a:	00 00 00 
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801c59:	00 00 00 
  801c5c:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801c5e:	ba 07 00 00 00       	mov    $0x7,%edx
  801c63:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c68:	bf 00 00 00 00       	mov    $0x0,%edi
  801c6d:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  801c74:	00 00 00 
  801c77:	ff d0                	callq  *%rax
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	0f 85 cd 00 00 00    	jne    801d4e <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c93:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801c97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c9b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ca0:	48 89 c6             	mov    %rax,%rsi
  801ca3:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ca8:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801cb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cbe:	48 89 c1             	mov    %rax,%rcx
  801cc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc6:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ccb:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd0:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	79 2a                	jns    801d0a <pgfault+0x125>
				panic("Page map at temp address failed");
  801ce0:	48 ba 78 4d 80 00 00 	movabs $0x804d78,%rdx
  801ce7:	00 00 00 
  801cea:	be 30 00 00 00       	mov    $0x30,%esi
  801cef:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801cf6:	00 00 00 
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfe:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801d05:	00 00 00 
  801d08:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801d0a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d14:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  801d1b:	00 00 00 
  801d1e:	ff d0                	callq  *%rax
  801d20:	85 c0                	test   %eax,%eax
  801d22:	79 54                	jns    801d78 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801d24:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  801d2b:	00 00 00 
  801d2e:	be 32 00 00 00       	mov    $0x32,%esi
  801d33:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d3a:	00 00 00 
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d42:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801d49:	00 00 00 
  801d4c:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801d4e:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  801d55:	00 00 00 
  801d58:	be 34 00 00 00       	mov    $0x34,%esi
  801d5d:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801d64:	00 00 00 
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6c:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801d73:	00 00 00 
  801d76:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801d78:	c9                   	leaveq 
  801d79:	c3                   	retq   

0000000000801d7a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d7a:	55                   	push   %rbp
  801d7b:	48 89 e5             	mov    %rsp,%rbp
  801d7e:	48 83 ec 20          	sub    $0x20,%rsp
  801d82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d85:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801d88:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8f:	01 00 00 
  801d92:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d99:	25 07 0e 00 00       	and    $0xe07,%eax
  801d9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801da1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801da4:	48 c1 e0 0c          	shl    $0xc,%rax
  801da8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daf:	25 00 04 00 00       	and    $0x400,%eax
  801db4:	85 c0                	test   %eax,%eax
  801db6:	74 57                	je     801e0f <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801db8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801dbb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801dbf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc6:	41 89 f0             	mov    %esi,%r8d
  801dc9:	48 89 c6             	mov    %rax,%rsi
  801dcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd1:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	0f 8e 52 01 00 00    	jle    801f37 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801de5:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801dec:	00 00 00 
  801def:	be 4e 00 00 00       	mov    $0x4e,%esi
  801df4:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801dfb:	00 00 00 
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801e0a:	00 00 00 
  801e0d:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e12:	83 e0 02             	and    $0x2,%eax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 10                	jne    801e29 <duppage+0xaf>
  801e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1c:	25 00 08 00 00       	and    $0x800,%eax
  801e21:	85 c0                	test   %eax,%eax
  801e23:	0f 84 bb 00 00 00    	je     801ee4 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2c:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801e31:	80 cc 08             	or     $0x8,%ah
  801e34:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e37:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e3a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e45:	41 89 f0             	mov    %esi,%r8d
  801e48:	48 89 c6             	mov    %rax,%rsi
  801e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e50:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801e57:	00 00 00 
  801e5a:	ff d0                	callq  *%rax
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	7e 2a                	jle    801e8a <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801e60:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801e67:	00 00 00 
  801e6a:	be 55 00 00 00       	mov    $0x55,%esi
  801e6f:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801e76:	00 00 00 
  801e79:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7e:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801e85:	00 00 00 
  801e88:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e8a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801e8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e95:	41 89 c8             	mov    %ecx,%r8d
  801e98:	48 89 d1             	mov    %rdx,%rcx
  801e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea0:	48 89 c6             	mov    %rax,%rsi
  801ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea8:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801eaf:	00 00 00 
  801eb2:	ff d0                	callq  *%rax
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	7e 2a                	jle    801ee2 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801eb8:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801ebf:	00 00 00 
  801ec2:	be 57 00 00 00       	mov    $0x57,%esi
  801ec7:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801ece:	00 00 00 
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801edd:	00 00 00 
  801ee0:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801ee2:	eb 53                	jmp    801f37 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ee4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801ee7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eeb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef2:	41 89 f0             	mov    %esi,%r8d
  801ef5:	48 89 c6             	mov    %rax,%rsi
  801ef8:	bf 00 00 00 00       	mov    $0x0,%edi
  801efd:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801f04:	00 00 00 
  801f07:	ff d0                	callq  *%rax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	7e 2a                	jle    801f37 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801f0d:	48 ba f2 4d 80 00 00 	movabs $0x804df2,%rdx
  801f14:	00 00 00 
  801f17:	be 5b 00 00 00       	mov    $0x5b,%esi
  801f1c:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  801f23:	00 00 00 
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2b:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  801f32:	00 00 00 
  801f35:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leaveq 
  801f3d:	c3                   	retq   

0000000000801f3e <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801f3e:	55                   	push   %rbp
  801f3f:	48 89 e5             	mov    %rsp,%rbp
  801f42:	48 83 ec 18          	sub    $0x18,%rsp
  801f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801f52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f56:	48 c1 e8 27          	shr    $0x27,%rax
  801f5a:	48 89 c2             	mov    %rax,%rdx
  801f5d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f64:	01 00 00 
  801f67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f6b:	83 e0 01             	and    $0x1,%eax
  801f6e:	48 85 c0             	test   %rax,%rax
  801f71:	74 51                	je     801fc4 <pt_is_mapped+0x86>
  801f73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f77:	48 c1 e0 0c          	shl    $0xc,%rax
  801f7b:	48 c1 e8 1e          	shr    $0x1e,%rax
  801f7f:	48 89 c2             	mov    %rax,%rdx
  801f82:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801f89:	01 00 00 
  801f8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f90:	83 e0 01             	and    $0x1,%eax
  801f93:	48 85 c0             	test   %rax,%rax
  801f96:	74 2c                	je     801fc4 <pt_is_mapped+0x86>
  801f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9c:	48 c1 e0 0c          	shl    $0xc,%rax
  801fa0:	48 c1 e8 15          	shr    $0x15,%rax
  801fa4:	48 89 c2             	mov    %rax,%rdx
  801fa7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fae:	01 00 00 
  801fb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb5:	83 e0 01             	and    $0x1,%eax
  801fb8:	48 85 c0             	test   %rax,%rax
  801fbb:	74 07                	je     801fc4 <pt_is_mapped+0x86>
  801fbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc2:	eb 05                	jmp    801fc9 <pt_is_mapped+0x8b>
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	83 e0 01             	and    $0x1,%eax
}
  801fcc:	c9                   	leaveq 
  801fcd:	c3                   	retq   

0000000000801fce <fork>:

envid_t
fork(void)
{
  801fce:	55                   	push   %rbp
  801fcf:	48 89 e5             	mov    %rsp,%rbp
  801fd2:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801fd6:	48 bf e5 1b 80 00 00 	movabs $0x801be5,%rdi
  801fdd:	00 00 00 
  801fe0:	48 b8 09 46 80 00 00 	movabs $0x804609,%rax
  801fe7:	00 00 00 
  801fea:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fec:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff1:	cd 30                	int    $0x30
  801ff3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ff6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801ff9:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802000:	79 30                	jns    802032 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802002:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802005:	89 c1                	mov    %eax,%ecx
  802007:	48 ba 10 4e 80 00 00 	movabs $0x804e10,%rdx
  80200e:	00 00 00 
  802011:	be 86 00 00 00       	mov    $0x86,%esi
  802016:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80201d:	00 00 00 
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	49 b8 f5 44 80 00 00 	movabs $0x8044f5,%r8
  80202c:	00 00 00 
  80202f:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802032:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802036:	75 46                	jne    80207e <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802038:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80203f:	00 00 00 
  802042:	ff d0                	callq  *%rax
  802044:	25 ff 03 00 00       	and    $0x3ff,%eax
  802049:	48 63 d0             	movslq %eax,%rdx
  80204c:	48 89 d0             	mov    %rdx,%rax
  80204f:	48 c1 e0 03          	shl    $0x3,%rax
  802053:	48 01 d0             	add    %rdx,%rax
  802056:	48 c1 e0 05          	shl    $0x5,%rax
  80205a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802061:	00 00 00 
  802064:	48 01 c2             	add    %rax,%rdx
  802067:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80206e:	00 00 00 
  802071:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	e9 d1 01 00 00       	jmpq   80224f <fork+0x281>
	}
	uint64_t ad = 0;
  80207e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802085:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802086:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80208b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80208f:	e9 df 00 00 00       	jmpq   802173 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802098:	48 c1 e8 27          	shr    $0x27,%rax
  80209c:	48 89 c2             	mov    %rax,%rdx
  80209f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020a6:	01 00 00 
  8020a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ad:	83 e0 01             	and    $0x1,%eax
  8020b0:	48 85 c0             	test   %rax,%rax
  8020b3:	0f 84 9e 00 00 00    	je     802157 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8020b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020bd:	48 c1 e8 1e          	shr    $0x1e,%rax
  8020c1:	48 89 c2             	mov    %rax,%rdx
  8020c4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020cb:	01 00 00 
  8020ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d2:	83 e0 01             	and    $0x1,%eax
  8020d5:	48 85 c0             	test   %rax,%rax
  8020d8:	74 73                	je     80214d <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8020da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020de:	48 c1 e8 15          	shr    $0x15,%rax
  8020e2:	48 89 c2             	mov    %rax,%rdx
  8020e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020ec:	01 00 00 
  8020ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f3:	83 e0 01             	and    $0x1,%eax
  8020f6:	48 85 c0             	test   %rax,%rax
  8020f9:	74 48                	je     802143 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8020fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ff:	48 c1 e8 0c          	shr    $0xc,%rax
  802103:	48 89 c2             	mov    %rax,%rdx
  802106:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210d:	01 00 00 
  802110:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802114:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211c:	83 e0 01             	and    $0x1,%eax
  80211f:	48 85 c0             	test   %rax,%rax
  802122:	74 47                	je     80216b <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802128:	48 c1 e8 0c          	shr    $0xc,%rax
  80212c:	89 c2                	mov    %eax,%edx
  80212e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802131:	89 d6                	mov    %edx,%esi
  802133:	89 c7                	mov    %eax,%edi
  802135:	48 b8 7a 1d 80 00 00 	movabs $0x801d7a,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	callq  *%rax
  802141:	eb 28                	jmp    80216b <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802143:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80214a:	00 
  80214b:	eb 1e                	jmp    80216b <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80214d:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802154:	40 
  802155:	eb 14                	jmp    80216b <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80215b:	48 c1 e8 27          	shr    $0x27,%rax
  80215f:	48 83 c0 01          	add    $0x1,%rax
  802163:	48 c1 e0 27          	shl    $0x27,%rax
  802167:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80216b:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802172:	00 
  802173:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80217a:	00 
  80217b:	0f 87 13 ff ff ff    	ja     802094 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802181:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802184:	ba 07 00 00 00       	mov    $0x7,%edx
  802189:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80218e:	89 c7                	mov    %eax,%edi
  802190:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80219c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80219f:	ba 07 00 00 00       	mov    $0x7,%edx
  8021a4:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021a9:	89 c7                	mov    %eax,%edi
  8021ab:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8021b2:	00 00 00 
  8021b5:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8021b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021ba:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8021c0:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8021c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ca:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8021dd:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021e2:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8021e7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021ec:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8021f8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802202:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802209:	00 00 00 
  80220c:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  80220e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802215:	00 00 00 
  802218:	48 8b 00             	mov    (%rax),%rax
  80221b:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802222:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802225:	48 89 d6             	mov    %rdx,%rsi
  802228:	89 c7                	mov    %eax,%edi
  80222a:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802236:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802239:	be 02 00 00 00       	mov    $0x2,%esi
  80223e:	89 c7                	mov    %eax,%edi
  802240:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  802247:	00 00 00 
  80224a:	ff d0                	callq  *%rax

	return envid;
  80224c:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80224f:	c9                   	leaveq 
  802250:	c3                   	retq   

0000000000802251 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802255:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  80225c:	00 00 00 
  80225f:	be bf 00 00 00       	mov    $0xbf,%esi
  802264:	48 bf 6d 4d 80 00 00 	movabs $0x804d6d,%rdi
  80226b:	00 00 00 
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  80227a:	00 00 00 
  80227d:	ff d1                	callq  *%rcx

000000000080227f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80227f:	55                   	push   %rbp
  802280:	48 89 e5             	mov    %rsp,%rbp
  802283:	48 83 ec 30          	sub    $0x30,%rsp
  802287:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80228b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80228f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802293:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80229a:	00 00 00 
  80229d:	48 8b 00             	mov    (%rax),%rax
  8022a0:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	75 3c                	jne    8022e6 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8022aa:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  8022b1:	00 00 00 
  8022b4:	ff d0                	callq  *%rax
  8022b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8022bb:	48 63 d0             	movslq %eax,%rdx
  8022be:	48 89 d0             	mov    %rdx,%rax
  8022c1:	48 c1 e0 03          	shl    $0x3,%rax
  8022c5:	48 01 d0             	add    %rdx,%rax
  8022c8:	48 c1 e0 05          	shl    $0x5,%rax
  8022cc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8022d3:	00 00 00 
  8022d6:	48 01 c2             	add    %rax,%rdx
  8022d9:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8022e0:	00 00 00 
  8022e3:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8022e6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022eb:	75 0e                	jne    8022fb <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8022ed:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022f4:	00 00 00 
  8022f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8022fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ff:	48 89 c7             	mov    %rax,%rdi
  802302:	48 b8 d7 1a 80 00 00 	movabs $0x801ad7,%rax
  802309:	00 00 00 
  80230c:	ff d0                	callq  *%rax
  80230e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802315:	79 19                	jns    802330 <ipc_recv+0xb1>
		*from_env_store = 0;
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802325:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232e:	eb 53                	jmp    802383 <ipc_recv+0x104>
	}
	if(from_env_store)
  802330:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802335:	74 19                	je     802350 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802337:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80233e:	00 00 00 
  802341:	48 8b 00             	mov    (%rax),%rax
  802344:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80234a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234e:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802350:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802355:	74 19                	je     802370 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802357:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80235e:	00 00 00 
  802361:	48 8b 00             	mov    (%rax),%rax
  802364:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80236a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236e:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802370:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802377:	00 00 00 
  80237a:	48 8b 00             	mov    (%rax),%rax
  80237d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802383:	c9                   	leaveq 
  802384:	c3                   	retq   

0000000000802385 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802385:	55                   	push   %rbp
  802386:	48 89 e5             	mov    %rsp,%rbp
  802389:	48 83 ec 30          	sub    $0x30,%rsp
  80238d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802390:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802393:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802397:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80239a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80239f:	75 0e                	jne    8023af <ipc_send+0x2a>
		pg = (void*)UTOP;
  8023a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023a8:	00 00 00 
  8023ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8023af:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023b2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8023b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023bc:	89 c7                	mov    %eax,%edi
  8023be:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8023cd:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023d1:	75 0c                	jne    8023df <ipc_send+0x5a>
			sys_yield();
  8023d3:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8023da:	00 00 00 
  8023dd:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8023df:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8023e3:	74 ca                	je     8023af <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8023e5:	c9                   	leaveq 
  8023e6:	c3                   	retq   

00000000008023e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023e7:	55                   	push   %rbp
  8023e8:	48 89 e5             	mov    %rsp,%rbp
  8023eb:	48 83 ec 14          	sub    $0x14,%rsp
  8023ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8023f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023f9:	eb 5e                	jmp    802459 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8023fb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802402:	00 00 00 
  802405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802408:	48 63 d0             	movslq %eax,%rdx
  80240b:	48 89 d0             	mov    %rdx,%rax
  80240e:	48 c1 e0 03          	shl    $0x3,%rax
  802412:	48 01 d0             	add    %rdx,%rax
  802415:	48 c1 e0 05          	shl    $0x5,%rax
  802419:	48 01 c8             	add    %rcx,%rax
  80241c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802422:	8b 00                	mov    (%rax),%eax
  802424:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802427:	75 2c                	jne    802455 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802429:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802430:	00 00 00 
  802433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802436:	48 63 d0             	movslq %eax,%rdx
  802439:	48 89 d0             	mov    %rdx,%rax
  80243c:	48 c1 e0 03          	shl    $0x3,%rax
  802440:	48 01 d0             	add    %rdx,%rax
  802443:	48 c1 e0 05          	shl    $0x5,%rax
  802447:	48 01 c8             	add    %rcx,%rax
  80244a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802450:	8b 40 08             	mov    0x8(%rax),%eax
  802453:	eb 12                	jmp    802467 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802455:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802459:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802460:	7e 99                	jle    8023fb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 08          	sub    $0x8,%rsp
  802471:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802479:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802480:	ff ff ff 
  802483:	48 01 d0             	add    %rdx,%rax
  802486:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80248a:	c9                   	leaveq 
  80248b:	c3                   	retq   

000000000080248c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80248c:	55                   	push   %rbp
  80248d:	48 89 e5             	mov    %rsp,%rbp
  802490:	48 83 ec 08          	sub    $0x8,%rsp
  802494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249c:	48 89 c7             	mov    %rax,%rdi
  80249f:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	callq  *%rax
  8024ab:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024b1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024b5:	c9                   	leaveq 
  8024b6:	c3                   	retq   

00000000008024b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024b7:	55                   	push   %rbp
  8024b8:	48 89 e5             	mov    %rsp,%rbp
  8024bb:	48 83 ec 18          	sub    $0x18,%rsp
  8024bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ca:	eb 6b                	jmp    802537 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cf:	48 98                	cltq   
  8024d1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8024db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e3:	48 c1 e8 15          	shr    $0x15,%rax
  8024e7:	48 89 c2             	mov    %rax,%rdx
  8024ea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f1:	01 00 00 
  8024f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f8:	83 e0 01             	and    $0x1,%eax
  8024fb:	48 85 c0             	test   %rax,%rax
  8024fe:	74 21                	je     802521 <fd_alloc+0x6a>
  802500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802504:	48 c1 e8 0c          	shr    $0xc,%rax
  802508:	48 89 c2             	mov    %rax,%rdx
  80250b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802512:	01 00 00 
  802515:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802519:	83 e0 01             	and    $0x1,%eax
  80251c:	48 85 c0             	test   %rax,%rax
  80251f:	75 12                	jne    802533 <fd_alloc+0x7c>
			*fd_store = fd;
  802521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802525:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802529:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
  802531:	eb 1a                	jmp    80254d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802533:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802537:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80253b:	7e 8f                	jle    8024cc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80253d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802541:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802548:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80254d:	c9                   	leaveq 
  80254e:	c3                   	retq   

000000000080254f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80254f:	55                   	push   %rbp
  802550:	48 89 e5             	mov    %rsp,%rbp
  802553:	48 83 ec 20          	sub    $0x20,%rsp
  802557:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80255e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802562:	78 06                	js     80256a <fd_lookup+0x1b>
  802564:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802568:	7e 07                	jle    802571 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80256a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80256f:	eb 6c                	jmp    8025dd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802571:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802574:	48 98                	cltq   
  802576:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80257c:	48 c1 e0 0c          	shl    $0xc,%rax
  802580:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802588:	48 c1 e8 15          	shr    $0x15,%rax
  80258c:	48 89 c2             	mov    %rax,%rdx
  80258f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802596:	01 00 00 
  802599:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259d:	83 e0 01             	and    $0x1,%eax
  8025a0:	48 85 c0             	test   %rax,%rax
  8025a3:	74 21                	je     8025c6 <fd_lookup+0x77>
  8025a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a9:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ad:	48 89 c2             	mov    %rax,%rdx
  8025b0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b7:	01 00 00 
  8025ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025be:	83 e0 01             	and    $0x1,%eax
  8025c1:	48 85 c0             	test   %rax,%rax
  8025c4:	75 07                	jne    8025cd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025cb:	eb 10                	jmp    8025dd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dd:	c9                   	leaveq 
  8025de:	c3                   	retq   

00000000008025df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025df:	55                   	push   %rbp
  8025e0:	48 89 e5             	mov    %rsp,%rbp
  8025e3:	48 83 ec 30          	sub    $0x30,%rsp
  8025e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025eb:	89 f0                	mov    %esi,%eax
  8025ed:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f4:	48 89 c7             	mov    %rax,%rdi
  8025f7:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	callq  *%rax
  802603:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802607:	48 89 d6             	mov    %rdx,%rsi
  80260a:	89 c7                	mov    %eax,%edi
  80260c:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261f:	78 0a                	js     80262b <fd_close+0x4c>
	    || fd != fd2)
  802621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802625:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802629:	74 12                	je     80263d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80262b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80262f:	74 05                	je     802636 <fd_close+0x57>
  802631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802634:	eb 05                	jmp    80263b <fd_close+0x5c>
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
  80263b:	eb 69                	jmp    8026a6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80263d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802641:	8b 00                	mov    (%rax),%eax
  802643:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	78 2a                	js     80268b <fd_close+0xac>
		if (dev->dev_close)
  802661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802665:	48 8b 40 20          	mov    0x20(%rax),%rax
  802669:	48 85 c0             	test   %rax,%rax
  80266c:	74 16                	je     802684 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80266e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802672:	48 8b 40 20          	mov    0x20(%rax),%rax
  802676:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80267a:	48 89 d7             	mov    %rdx,%rdi
  80267d:	ff d0                	callq  *%rax
  80267f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802682:	eb 07                	jmp    80268b <fd_close+0xac>
		else
			r = 0;
  802684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80268b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80268f:	48 89 c6             	mov    %rax,%rsi
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
	return r;
  8026a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026a6:	c9                   	leaveq 
  8026a7:	c3                   	retq   

00000000008026a8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	48 83 ec 20          	sub    $0x20,%rsp
  8026b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026be:	eb 41                	jmp    802701 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026c0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026c7:	00 00 00 
  8026ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026cd:	48 63 d2             	movslq %edx,%rdx
  8026d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d4:	8b 00                	mov    (%rax),%eax
  8026d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026d9:	75 22                	jne    8026fd <dev_lookup+0x55>
			*dev = devtab[i];
  8026db:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026e2:	00 00 00 
  8026e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026e8:	48 63 d2             	movslq %edx,%rdx
  8026eb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fb:	eb 60                	jmp    80275d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802701:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802708:	00 00 00 
  80270b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80270e:	48 63 d2             	movslq %edx,%rdx
  802711:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802715:	48 85 c0             	test   %rax,%rax
  802718:	75 a6                	jne    8026c0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80271a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802721:	00 00 00 
  802724:	48 8b 00             	mov    (%rax),%rax
  802727:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80272d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802730:	89 c6                	mov    %eax,%esi
  802732:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  802739:	00 00 00 
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802748:	00 00 00 
  80274b:	ff d1                	callq  *%rcx
	*dev = 0;
  80274d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802751:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802758:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80275d:	c9                   	leaveq 
  80275e:	c3                   	retq   

000000000080275f <close>:

int
close(int fdnum)
{
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
  802763:	48 83 ec 20          	sub    $0x20,%rsp
  802767:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80276e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802771:	48 89 d6             	mov    %rdx,%rsi
  802774:	89 c7                	mov    %eax,%edi
  802776:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  80277d:	00 00 00 
  802780:	ff d0                	callq  *%rax
  802782:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802785:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802789:	79 05                	jns    802790 <close+0x31>
		return r;
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	eb 18                	jmp    8027a8 <close+0x49>
	else
		return fd_close(fd, 1);
  802790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802794:	be 01 00 00 00       	mov    $0x1,%esi
  802799:	48 89 c7             	mov    %rax,%rdi
  80279c:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
}
  8027a8:	c9                   	leaveq 
  8027a9:	c3                   	retq   

00000000008027aa <close_all>:

void
close_all(void)
{
  8027aa:	55                   	push   %rbp
  8027ab:	48 89 e5             	mov    %rsp,%rbp
  8027ae:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027b9:	eb 15                	jmp    8027d0 <close_all+0x26>
		close(i);
  8027bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027be:	89 c7                	mov    %eax,%edi
  8027c0:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027d4:	7e e5                	jle    8027bb <close_all+0x11>
		close(i);
}
  8027d6:	c9                   	leaveq 
  8027d7:	c3                   	retq   

00000000008027d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027d8:	55                   	push   %rbp
  8027d9:	48 89 e5             	mov    %rsp,%rbp
  8027dc:	48 83 ec 40          	sub    $0x40,%rsp
  8027e0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027e3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027e6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027ed:	48 89 d6             	mov    %rdx,%rsi
  8027f0:	89 c7                	mov    %eax,%edi
  8027f2:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802805:	79 08                	jns    80280f <dup+0x37>
		return r;
  802807:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280a:	e9 70 01 00 00       	jmpq   80297f <dup+0x1a7>
	close(newfdnum);
  80280f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802812:	89 c7                	mov    %eax,%edi
  802814:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802820:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802823:	48 98                	cltq   
  802825:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80282b:	48 c1 e0 0c          	shl    $0xc,%rax
  80282f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802837:	48 89 c7             	mov    %rax,%rdi
  80283a:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
  802846:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	48 89 c7             	mov    %rax,%rdi
  802851:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
  80285d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802865:	48 c1 e8 15          	shr    $0x15,%rax
  802869:	48 89 c2             	mov    %rax,%rdx
  80286c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802873:	01 00 00 
  802876:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287a:	83 e0 01             	and    $0x1,%eax
  80287d:	48 85 c0             	test   %rax,%rax
  802880:	74 73                	je     8028f5 <dup+0x11d>
  802882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802886:	48 c1 e8 0c          	shr    $0xc,%rax
  80288a:	48 89 c2             	mov    %rax,%rdx
  80288d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802894:	01 00 00 
  802897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	74 52                	je     8028f5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8028ab:	48 89 c2             	mov    %rax,%rdx
  8028ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028b5:	01 00 00 
  8028b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8028c1:	89 c1                	mov    %eax,%ecx
  8028c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cb:	41 89 c8             	mov    %ecx,%r8d
  8028ce:	48 89 d1             	mov    %rdx,%rcx
  8028d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d6:	48 89 c6             	mov    %rax,%rsi
  8028d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028de:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  8028e5:	00 00 00 
  8028e8:	ff d0                	callq  *%rax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f1:	79 02                	jns    8028f5 <dup+0x11d>
			goto err;
  8028f3:	eb 57                	jmp    80294c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8028fd:	48 89 c2             	mov    %rax,%rdx
  802900:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802907:	01 00 00 
  80290a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290e:	25 07 0e 00 00       	and    $0xe07,%eax
  802913:	89 c1                	mov    %eax,%ecx
  802915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802919:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80291d:	41 89 c8             	mov    %ecx,%r8d
  802920:	48 89 d1             	mov    %rdx,%rcx
  802923:	ba 00 00 00 00       	mov    $0x0,%edx
  802928:	48 89 c6             	mov    %rax,%rsi
  80292b:	bf 00 00 00 00       	mov    $0x0,%edi
  802930:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  802937:	00 00 00 
  80293a:	ff d0                	callq  *%rax
  80293c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802943:	79 02                	jns    802947 <dup+0x16f>
		goto err;
  802945:	eb 05                	jmp    80294c <dup+0x174>

	return newfdnum;
  802947:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80294a:	eb 33                	jmp    80297f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 89 c6             	mov    %rax,%rsi
  802953:	bf 00 00 00 00       	mov    $0x0,%edi
  802958:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80295f:	00 00 00 
  802962:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802968:	48 89 c6             	mov    %rax,%rsi
  80296b:	bf 00 00 00 00       	mov    $0x0,%edi
  802970:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
	return r;
  80297c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80297f:	c9                   	leaveq 
  802980:	c3                   	retq   

0000000000802981 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802981:	55                   	push   %rbp
  802982:	48 89 e5             	mov    %rsp,%rbp
  802985:	48 83 ec 40          	sub    $0x40,%rsp
  802989:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802990:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802994:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802998:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299b:	48 89 d6             	mov    %rdx,%rsi
  80299e:	89 c7                	mov    %eax,%edi
  8029a0:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  8029a7:	00 00 00 
  8029aa:	ff d0                	callq  *%rax
  8029ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b3:	78 24                	js     8029d9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b9:	8b 00                	mov    (%rax),%eax
  8029bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029bf:	48 89 d6             	mov    %rdx,%rsi
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d7:	79 05                	jns    8029de <read+0x5d>
		return r;
  8029d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dc:	eb 76                	jmp    802a54 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e2:	8b 40 08             	mov    0x8(%rax),%eax
  8029e5:	83 e0 03             	and    $0x3,%eax
  8029e8:	83 f8 01             	cmp    $0x1,%eax
  8029eb:	75 3a                	jne    802a27 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029ed:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8029f4:	00 00 00 
  8029f7:	48 8b 00             	mov    (%rax),%rax
  8029fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a03:	89 c6                	mov    %eax,%esi
  802a05:	48 bf 5f 4e 80 00 00 	movabs $0x804e5f,%rdi
  802a0c:	00 00 00 
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a14:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802a1b:	00 00 00 
  802a1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a25:	eb 2d                	jmp    802a54 <read+0xd3>
	}
	if (!dev->dev_read)
  802a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a2f:	48 85 c0             	test   %rax,%rax
  802a32:	75 07                	jne    802a3b <read+0xba>
		return -E_NOT_SUPP;
  802a34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a39:	eb 19                	jmp    802a54 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a4b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a4f:	48 89 cf             	mov    %rcx,%rdi
  802a52:	ff d0                	callq  *%rax
}
  802a54:	c9                   	leaveq 
  802a55:	c3                   	retq   

0000000000802a56 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a56:	55                   	push   %rbp
  802a57:	48 89 e5             	mov    %rsp,%rbp
  802a5a:	48 83 ec 30          	sub    $0x30,%rsp
  802a5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a70:	eb 49                	jmp    802abb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	48 98                	cltq   
  802a77:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a7b:	48 29 c2             	sub    %rax,%rdx
  802a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a81:	48 63 c8             	movslq %eax,%rcx
  802a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a88:	48 01 c1             	add    %rax,%rcx
  802a8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a8e:	48 89 ce             	mov    %rcx,%rsi
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802aa2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aa6:	79 05                	jns    802aad <readn+0x57>
			return m;
  802aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aab:	eb 1c                	jmp    802ac9 <readn+0x73>
		if (m == 0)
  802aad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ab1:	75 02                	jne    802ab5 <readn+0x5f>
			break;
  802ab3:	eb 11                	jmp    802ac6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abe:	48 98                	cltq   
  802ac0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ac4:	72 ac                	jb     802a72 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ac9:	c9                   	leaveq 
  802aca:	c3                   	retq   

0000000000802acb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802acb:	55                   	push   %rbp
  802acc:	48 89 e5             	mov    %rsp,%rbp
  802acf:	48 83 ec 40          	sub    $0x40,%rsp
  802ad3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ad6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ada:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ade:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ae5:	48 89 d6             	mov    %rdx,%rsi
  802ae8:	89 c7                	mov    %eax,%edi
  802aea:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
  802af6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afd:	78 24                	js     802b23 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b03:	8b 00                	mov    (%rax),%eax
  802b05:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b09:	48 89 d6             	mov    %rdx,%rsi
  802b0c:	89 c7                	mov    %eax,%edi
  802b0e:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  802b15:	00 00 00 
  802b18:	ff d0                	callq  *%rax
  802b1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b21:	79 05                	jns    802b28 <write+0x5d>
		return r;
  802b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b26:	eb 75                	jmp    802b9d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2c:	8b 40 08             	mov    0x8(%rax),%eax
  802b2f:	83 e0 03             	and    $0x3,%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 3a                	jne    802b70 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b36:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802b3d:	00 00 00 
  802b40:	48 8b 00             	mov    (%rax),%rax
  802b43:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b49:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b4c:	89 c6                	mov    %eax,%esi
  802b4e:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
  802b55:	00 00 00 
  802b58:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5d:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802b64:	00 00 00 
  802b67:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b6e:	eb 2d                	jmp    802b9d <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b74:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b78:	48 85 c0             	test   %rax,%rax
  802b7b:	75 07                	jne    802b84 <write+0xb9>
		return -E_NOT_SUPP;
  802b7d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b82:	eb 19                	jmp    802b9d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b8c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b90:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b94:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b98:	48 89 cf             	mov    %rcx,%rdi
  802b9b:	ff d0                	callq  *%rax
}
  802b9d:	c9                   	leaveq 
  802b9e:	c3                   	retq   

0000000000802b9f <seek>:

int
seek(int fdnum, off_t offset)
{
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	48 83 ec 18          	sub    $0x18,%rsp
  802ba7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802baa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb4:	48 89 d6             	mov    %rdx,%rsi
  802bb7:	89 c7                	mov    %eax,%edi
  802bb9:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	callq  *%rax
  802bc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcc:	79 05                	jns    802bd3 <seek+0x34>
		return r;
  802bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd1:	eb 0f                	jmp    802be2 <seek+0x43>
	fd->fd_offset = offset;
  802bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	48 83 ec 30          	sub    $0x30,%rsp
  802bec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bef:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf9:	48 89 d6             	mov    %rdx,%rsi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c11:	78 24                	js     802c37 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c17:	8b 00                	mov    (%rax),%eax
  802c19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c1d:	48 89 d6             	mov    %rdx,%rsi
  802c20:	89 c7                	mov    %eax,%edi
  802c22:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c35:	79 05                	jns    802c3c <ftruncate+0x58>
		return r;
  802c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3a:	eb 72                	jmp    802cae <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c40:	8b 40 08             	mov    0x8(%rax),%eax
  802c43:	83 e0 03             	and    $0x3,%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	75 3a                	jne    802c84 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c4a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802c51:	00 00 00 
  802c54:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c57:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c5d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c60:	89 c6                	mov    %eax,%esi
  802c62:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  802c69:	00 00 00 
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802c78:	00 00 00 
  802c7b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c82:	eb 2a                	jmp    802cae <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c88:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c8c:	48 85 c0             	test   %rax,%rax
  802c8f:	75 07                	jne    802c98 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c96:	eb 16                	jmp    802cae <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ca0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ca7:	89 ce                	mov    %ecx,%esi
  802ca9:	48 89 d7             	mov    %rdx,%rdi
  802cac:	ff d0                	callq  *%rax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 30          	sub    $0x30,%rsp
  802cb8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cbf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc6:	48 89 d6             	mov    %rdx,%rsi
  802cc9:	89 c7                	mov    %eax,%edi
  802ccb:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
  802cd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cde:	78 24                	js     802d04 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce4:	8b 00                	mov    (%rax),%eax
  802ce6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cea:	48 89 d6             	mov    %rdx,%rsi
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 05                	jns    802d09 <fstat+0x59>
		return r;
  802d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d07:	eb 5e                	jmp    802d67 <fstat+0xb7>
	if (!dev->dev_stat)
  802d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d11:	48 85 c0             	test   %rax,%rax
  802d14:	75 07                	jne    802d1d <fstat+0x6d>
		return -E_NOT_SUPP;
  802d16:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d1b:	eb 4a                	jmp    802d67 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d21:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d28:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d2f:	00 00 00 
	stat->st_isdir = 0;
  802d32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d36:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d3d:	00 00 00 
	stat->st_dev = dev;
  802d40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d48:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d53:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d5b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d5f:	48 89 ce             	mov    %rcx,%rsi
  802d62:	48 89 d7             	mov    %rdx,%rdi
  802d65:	ff d0                	callq  *%rax
}
  802d67:	c9                   	leaveq 
  802d68:	c3                   	retq   

0000000000802d69 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d69:	55                   	push   %rbp
  802d6a:	48 89 e5             	mov    %rsp,%rbp
  802d6d:	48 83 ec 20          	sub    $0x20,%rsp
  802d71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7d:	be 00 00 00 00       	mov    $0x0,%esi
  802d82:	48 89 c7             	mov    %rax,%rdi
  802d85:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d98:	79 05                	jns    802d9f <stat+0x36>
		return fd;
  802d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9d:	eb 2f                	jmp    802dce <stat+0x65>
	r = fstat(fd, stat);
  802d9f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da6:	48 89 d6             	mov    %rdx,%rsi
  802da9:	89 c7                	mov    %eax,%edi
  802dab:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	callq  *%rax
  802db7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbd:	89 c7                	mov    %eax,%edi
  802dbf:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
	return r;
  802dcb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dce:	c9                   	leaveq 
  802dcf:	c3                   	retq   

0000000000802dd0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dd0:	55                   	push   %rbp
  802dd1:	48 89 e5             	mov    %rsp,%rbp
  802dd4:	48 83 ec 10          	sub    $0x10,%rsp
  802dd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ddb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ddf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802de6:	00 00 00 
  802de9:	8b 00                	mov    (%rax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	75 1d                	jne    802e0c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802def:	bf 01 00 00 00       	mov    $0x1,%edi
  802df4:	48 b8 e7 23 80 00 00 	movabs $0x8023e7,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	callq  *%rax
  802e00:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802e07:	00 00 00 
  802e0a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e0c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e13:	00 00 00 
  802e16:	8b 00                	mov    (%rax),%eax
  802e18:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e1b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e20:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e27:	00 00 00 
  802e2a:	89 c7                	mov    %eax,%edi
  802e2c:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802e41:	48 89 c6             	mov    %rax,%rsi
  802e44:	bf 00 00 00 00       	mov    $0x0,%edi
  802e49:	48 b8 7f 22 80 00 00 	movabs $0x80227f,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
}
  802e55:	c9                   	leaveq 
  802e56:	c3                   	retq   

0000000000802e57 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e57:	55                   	push   %rbp
  802e58:	48 89 e5             	mov    %rsp,%rbp
  802e5b:	48 83 ec 30          	sub    $0x30,%rsp
  802e5f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e63:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e66:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e6d:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e7b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e80:	75 08                	jne    802e8a <open+0x33>
	{
		return r;
  802e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e85:	e9 f2 00 00 00       	jmpq   802f7c <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e8e:	48 89 c7             	mov    %rax,%rdi
  802e91:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
  802e9d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ea0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ea7:	7e 0a                	jle    802eb3 <open+0x5c>
	{
		return -E_BAD_PATH;
  802ea9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802eae:	e9 c9 00 00 00       	jmpq   802f7c <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802eb3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802eba:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802ebb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ebf:	48 89 c7             	mov    %rax,%rdi
  802ec2:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
  802ece:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed5:	78 09                	js     802ee0 <open+0x89>
  802ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edb:	48 85 c0             	test   %rax,%rax
  802ede:	75 08                	jne    802ee8 <open+0x91>
		{
			return r;
  802ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee3:	e9 94 00 00 00       	jmpq   802f7c <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802ee8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eec:	ba 00 04 00 00       	mov    $0x400,%edx
  802ef1:	48 89 c6             	mov    %rax,%rsi
  802ef4:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802efb:	00 00 00 
  802efe:	48 b8 11 10 80 00 00 	movabs $0x801011,%rax
  802f05:	00 00 00 
  802f08:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802f0a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f11:	00 00 00 
  802f14:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802f17:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f21:	48 89 c6             	mov    %rax,%rsi
  802f24:	bf 01 00 00 00       	mov    $0x1,%edi
  802f29:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3c:	79 2b                	jns    802f69 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f42:	be 00 00 00 00       	mov    $0x0,%esi
  802f47:	48 89 c7             	mov    %rax,%rdi
  802f4a:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f5d:	79 05                	jns    802f64 <open+0x10d>
			{
				return d;
  802f5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f62:	eb 18                	jmp    802f7c <open+0x125>
			}
			return r;
  802f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f67:	eb 13                	jmp    802f7c <open+0x125>
		}	
		return fd2num(fd_store);
  802f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6d:	48 89 c7             	mov    %rax,%rdi
  802f70:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  802f77:	00 00 00 
  802f7a:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f7c:	c9                   	leaveq 
  802f7d:	c3                   	retq   

0000000000802f7e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f7e:	55                   	push   %rbp
  802f7f:	48 89 e5             	mov    %rsp,%rbp
  802f82:	48 83 ec 10          	sub    $0x10,%rsp
  802f86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f8e:	8b 50 0c             	mov    0xc(%rax),%edx
  802f91:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f98:	00 00 00 
  802f9b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f9d:	be 00 00 00 00       	mov    $0x0,%esi
  802fa2:	bf 06 00 00 00       	mov    $0x6,%edi
  802fa7:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 83 ec 30          	sub    $0x30,%rsp
  802fbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fc1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802fd0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fd5:	74 07                	je     802fde <devfile_read+0x29>
  802fd7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fdc:	75 07                	jne    802fe5 <devfile_read+0x30>
		return -E_INVAL;
  802fde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fe3:	eb 77                	jmp    80305c <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe9:	8b 50 0c             	mov    0xc(%rax),%edx
  802fec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff3:	00 00 00 
  802ff6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ff8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fff:	00 00 00 
  803002:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803006:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80300a:	be 00 00 00 00       	mov    $0x0,%esi
  80300f:	bf 03 00 00 00       	mov    $0x3,%edi
  803014:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
  803020:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803023:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803027:	7f 05                	jg     80302e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302c:	eb 2e                	jmp    80305c <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80302e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803031:	48 63 d0             	movslq %eax,%rdx
  803034:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803038:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80303f:	00 00 00 
  803042:	48 89 c7             	mov    %rax,%rdi
  803045:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803051:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803055:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80305c:	c9                   	leaveq 
  80305d:	c3                   	retq   

000000000080305e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80305e:	55                   	push   %rbp
  80305f:	48 89 e5             	mov    %rsp,%rbp
  803062:	48 83 ec 30          	sub    $0x30,%rsp
  803066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80306a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80306e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803072:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803079:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80307e:	74 07                	je     803087 <devfile_write+0x29>
  803080:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803085:	75 08                	jne    80308f <devfile_write+0x31>
		return r;
  803087:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308a:	e9 9a 00 00 00       	jmpq   803129 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80308f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803093:	8b 50 0c             	mov    0xc(%rax),%edx
  803096:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80309d:	00 00 00 
  8030a0:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8030a2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030a9:	00 
  8030aa:	76 08                	jbe    8030b4 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8030ac:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030b3:	00 
	}
	fsipcbuf.write.req_n = n;
  8030b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bb:	00 00 00 
  8030be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030c2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ce:	48 89 c6             	mov    %rax,%rsi
  8030d1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030d8:	00 00 00 
  8030db:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8030e2:	00 00 00 
  8030e5:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030e7:	be 00 00 00 00       	mov    $0x0,%esi
  8030ec:	bf 04 00 00 00       	mov    $0x4,%edi
  8030f1:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  8030f8:	00 00 00 
  8030fb:	ff d0                	callq  *%rax
  8030fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803104:	7f 20                	jg     803126 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803106:	48 bf be 4e 80 00 00 	movabs $0x804ebe,%rdi
  80310d:	00 00 00 
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
  803115:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80311c:	00 00 00 
  80311f:	ff d2                	callq  *%rdx
		return r;
  803121:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803124:	eb 03                	jmp    803129 <devfile_write+0xcb>
	}
	return r;
  803126:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803129:	c9                   	leaveq 
  80312a:	c3                   	retq   

000000000080312b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80312b:	55                   	push   %rbp
  80312c:	48 89 e5             	mov    %rsp,%rbp
  80312f:	48 83 ec 20          	sub    $0x20,%rsp
  803133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80313b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313f:	8b 50 0c             	mov    0xc(%rax),%edx
  803142:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803149:	00 00 00 
  80314c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80314e:	be 00 00 00 00       	mov    $0x0,%esi
  803153:	bf 05 00 00 00       	mov    $0x5,%edi
  803158:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
  803164:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316b:	79 05                	jns    803172 <devfile_stat+0x47>
		return r;
  80316d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803170:	eb 56                	jmp    8031c8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803172:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803176:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80317d:	00 00 00 
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80318f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803196:	00 00 00 
  803199:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80319f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b0:	00 00 00 
  8031b3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031bd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c8:	c9                   	leaveq 
  8031c9:	c3                   	retq   

00000000008031ca <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031ca:	55                   	push   %rbp
  8031cb:	48 89 e5             	mov    %rsp,%rbp
  8031ce:	48 83 ec 10          	sub    $0x10,%rsp
  8031d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031d6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031dd:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031e7:	00 00 00 
  8031ea:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031ec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031f3:	00 00 00 
  8031f6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031f9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031fc:	be 00 00 00 00       	mov    $0x0,%esi
  803201:	bf 02 00 00 00       	mov    $0x2,%edi
  803206:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
}
  803212:	c9                   	leaveq 
  803213:	c3                   	retq   

0000000000803214 <remove>:

// Delete a file
int
remove(const char *path)
{
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	48 83 ec 10          	sub    $0x10,%rsp
  80321c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803224:	48 89 c7             	mov    %rax,%rdi
  803227:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803238:	7e 07                	jle    803241 <remove+0x2d>
		return -E_BAD_PATH;
  80323a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80323f:	eb 33                	jmp    803274 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803245:	48 89 c6             	mov    %rax,%rsi
  803248:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80324f:	00 00 00 
  803252:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80325e:	be 00 00 00 00       	mov    $0x0,%esi
  803263:	bf 07 00 00 00       	mov    $0x7,%edi
  803268:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
}
  803274:	c9                   	leaveq 
  803275:	c3                   	retq   

0000000000803276 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803276:	55                   	push   %rbp
  803277:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80327a:	be 00 00 00 00       	mov    $0x0,%esi
  80327f:	bf 08 00 00 00       	mov    $0x8,%edi
  803284:	48 b8 d0 2d 80 00 00 	movabs $0x802dd0,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
}
  803290:	5d                   	pop    %rbp
  803291:	c3                   	retq   

0000000000803292 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803292:	55                   	push   %rbp
  803293:	48 89 e5             	mov    %rsp,%rbp
  803296:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80329d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8032a4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8032ab:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8032b2:	be 00 00 00 00       	mov    $0x0,%esi
  8032b7:	48 89 c7             	mov    %rax,%rdi
  8032ba:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
  8032c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cd:	79 28                	jns    8032f7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d2:	89 c6                	mov    %eax,%esi
  8032d4:	48 bf da 4e 80 00 00 	movabs $0x804eda,%rdi
  8032db:	00 00 00 
  8032de:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e3:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  8032ea:	00 00 00 
  8032ed:	ff d2                	callq  *%rdx
		return fd_src;
  8032ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f2:	e9 74 01 00 00       	jmpq   80346b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032f7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032fe:	be 01 01 00 00       	mov    $0x101,%esi
  803303:	48 89 c7             	mov    %rax,%rdi
  803306:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  80330d:	00 00 00 
  803310:	ff d0                	callq  *%rax
  803312:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803315:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803319:	79 39                	jns    803354 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80331b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80331e:	89 c6                	mov    %eax,%esi
  803320:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  803327:	00 00 00 
  80332a:	b8 00 00 00 00       	mov    $0x0,%eax
  80332f:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  803336:	00 00 00 
  803339:	ff d2                	callq  *%rdx
		close(fd_src);
  80333b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333e:	89 c7                	mov    %eax,%edi
  803340:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  803347:	00 00 00 
  80334a:	ff d0                	callq  *%rax
		return fd_dest;
  80334c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80334f:	e9 17 01 00 00       	jmpq   80346b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803354:	eb 74                	jmp    8033ca <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803356:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803359:	48 63 d0             	movslq %eax,%rdx
  80335c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803363:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803366:	48 89 ce             	mov    %rcx,%rsi
  803369:	89 c7                	mov    %eax,%edi
  80336b:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  803372:	00 00 00 
  803375:	ff d0                	callq  *%rax
  803377:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80337a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80337e:	79 4a                	jns    8033ca <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803380:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803383:	89 c6                	mov    %eax,%esi
  803385:	48 bf 0a 4f 80 00 00 	movabs $0x804f0a,%rdi
  80338c:	00 00 00 
  80338f:	b8 00 00 00 00       	mov    $0x0,%eax
  803394:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  80339b:	00 00 00 
  80339e:	ff d2                	callq  *%rdx
			close(fd_src);
  8033a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a3:	89 c7                	mov    %eax,%edi
  8033a5:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
			close(fd_dest);
  8033b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
			return write_size;
  8033c2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033c5:	e9 a1 00 00 00       	jmpq   80346b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033ca:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d4:	ba 00 02 00 00       	mov    $0x200,%edx
  8033d9:	48 89 ce             	mov    %rcx,%rsi
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033f1:	0f 8f 5f ff ff ff    	jg     803356 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033fb:	79 47                	jns    803444 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803400:	89 c6                	mov    %eax,%esi
  803402:	48 bf 1d 4f 80 00 00 	movabs $0x804f1d,%rdi
  803409:	00 00 00 
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
  803411:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  803418:	00 00 00 
  80341b:	ff d2                	callq  *%rdx
		close(fd_src);
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803420:	89 c7                	mov    %eax,%edi
  803422:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
		close(fd_dest);
  80342e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803431:	89 c7                	mov    %eax,%edi
  803433:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  80343a:	00 00 00 
  80343d:	ff d0                	callq  *%rax
		return read_size;
  80343f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803442:	eb 27                	jmp    80346b <copy+0x1d9>
	}
	close(fd_src);
  803444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803447:	89 c7                	mov    %eax,%edi
  803449:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  803450:	00 00 00 
  803453:	ff d0                	callq  *%rax
	close(fd_dest);
  803455:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
	return 0;
  803466:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80346b:	c9                   	leaveq 
  80346c:	c3                   	retq   

000000000080346d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80346d:	55                   	push   %rbp
  80346e:	48 89 e5             	mov    %rsp,%rbp
  803471:	48 83 ec 20          	sub    $0x20,%rsp
  803475:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803478:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80347c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80347f:	48 89 d6             	mov    %rdx,%rsi
  803482:	89 c7                	mov    %eax,%edi
  803484:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  80348b:	00 00 00 
  80348e:	ff d0                	callq  *%rax
  803490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803497:	79 05                	jns    80349e <fd2sockid+0x31>
		return r;
  803499:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349c:	eb 24                	jmp    8034c2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80349e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a2:	8b 10                	mov    (%rax),%edx
  8034a4:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8034ab:	00 00 00 
  8034ae:	8b 00                	mov    (%rax),%eax
  8034b0:	39 c2                	cmp    %eax,%edx
  8034b2:	74 07                	je     8034bb <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8034b4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034b9:	eb 07                	jmp    8034c2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034bf:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034c2:	c9                   	leaveq 
  8034c3:	c3                   	retq   

00000000008034c4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034c4:	55                   	push   %rbp
  8034c5:	48 89 e5             	mov    %rsp,%rbp
  8034c8:	48 83 ec 20          	sub    $0x20,%rsp
  8034cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034cf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
  8034e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e9:	78 26                	js     803511 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8034f4:	48 89 c6             	mov    %rax,%rsi
  8034f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8034fc:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
  803508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80350b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350f:	79 16                	jns    803527 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803511:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803514:	89 c7                	mov    %eax,%edi
  803516:	48 b8 d1 39 80 00 00 	movabs $0x8039d1,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
		return r;
  803522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803525:	eb 3a                	jmp    803561 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352b:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803532:	00 00 00 
  803535:	8b 12                	mov    (%rdx),%edx
  803537:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803548:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80354b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80354e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803552:	48 89 c7             	mov    %rax,%rdi
  803555:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
}
  803561:	c9                   	leaveq 
  803562:	c3                   	retq   

0000000000803563 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803563:	55                   	push   %rbp
  803564:	48 89 e5             	mov    %rsp,%rbp
  803567:	48 83 ec 30          	sub    $0x30,%rsp
  80356b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80356e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803572:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803576:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803579:	89 c7                	mov    %eax,%edi
  80357b:	48 b8 6d 34 80 00 00 	movabs $0x80346d,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
  803587:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80358e:	79 05                	jns    803595 <accept+0x32>
		return r;
  803590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803593:	eb 3b                	jmp    8035d0 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803595:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803599:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80359d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a0:	48 89 ce             	mov    %rcx,%rsi
  8035a3:	89 c7                	mov    %eax,%edi
  8035a5:	48 b8 ae 38 80 00 00 	movabs $0x8038ae,%rax
  8035ac:	00 00 00 
  8035af:	ff d0                	callq  *%rax
  8035b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b8:	79 05                	jns    8035bf <accept+0x5c>
		return r;
  8035ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bd:	eb 11                	jmp    8035d0 <accept+0x6d>
	return alloc_sockfd(r);
  8035bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c2:	89 c7                	mov    %eax,%edi
  8035c4:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  8035cb:	00 00 00 
  8035ce:	ff d0                	callq  *%rax
}
  8035d0:	c9                   	leaveq 
  8035d1:	c3                   	retq   

00000000008035d2 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035d2:	55                   	push   %rbp
  8035d3:	48 89 e5             	mov    %rsp,%rbp
  8035d6:	48 83 ec 20          	sub    $0x20,%rsp
  8035da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e7:	89 c7                	mov    %eax,%edi
  8035e9:	48 b8 6d 34 80 00 00 	movabs $0x80346d,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fc:	79 05                	jns    803603 <bind+0x31>
		return r;
  8035fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803601:	eb 1b                	jmp    80361e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803603:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803606:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80360a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80360d:	48 89 ce             	mov    %rcx,%rsi
  803610:	89 c7                	mov    %eax,%edi
  803612:	48 b8 2d 39 80 00 00 	movabs $0x80392d,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
}
  80361e:	c9                   	leaveq 
  80361f:	c3                   	retq   

0000000000803620 <shutdown>:

int
shutdown(int s, int how)
{
  803620:	55                   	push   %rbp
  803621:	48 89 e5             	mov    %rsp,%rbp
  803624:	48 83 ec 20          	sub    $0x20,%rsp
  803628:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80362b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80362e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803631:	89 c7                	mov    %eax,%edi
  803633:	48 b8 6d 34 80 00 00 	movabs $0x80346d,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
  80363f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803646:	79 05                	jns    80364d <shutdown+0x2d>
		return r;
  803648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364b:	eb 16                	jmp    803663 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80364d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803650:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803653:	89 d6                	mov    %edx,%esi
  803655:	89 c7                	mov    %eax,%edi
  803657:	48 b8 91 39 80 00 00 	movabs $0x803991,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
}
  803663:	c9                   	leaveq 
  803664:	c3                   	retq   

0000000000803665 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803665:	55                   	push   %rbp
  803666:	48 89 e5             	mov    %rsp,%rbp
  803669:	48 83 ec 10          	sub    $0x10,%rsp
  80366d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 49 47 80 00 00 	movabs $0x804749,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	83 f8 01             	cmp    $0x1,%eax
  803687:	75 17                	jne    8036a0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368d:	8b 40 0c             	mov    0xc(%rax),%eax
  803690:	89 c7                	mov    %eax,%edi
  803692:	48 b8 d1 39 80 00 00 	movabs $0x8039d1,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	eb 05                	jmp    8036a5 <devsock_close+0x40>
	else
		return 0;
  8036a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036a5:	c9                   	leaveq 
  8036a6:	c3                   	retq   

00000000008036a7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036a7:	55                   	push   %rbp
  8036a8:	48 89 e5             	mov    %rsp,%rbp
  8036ab:	48 83 ec 20          	sub    $0x20,%rsp
  8036af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036b6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036bc:	89 c7                	mov    %eax,%edi
  8036be:	48 b8 6d 34 80 00 00 	movabs $0x80346d,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036d1:	79 05                	jns    8036d8 <connect+0x31>
		return r;
  8036d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d6:	eb 1b                	jmp    8036f3 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e2:	48 89 ce             	mov    %rcx,%rsi
  8036e5:	89 c7                	mov    %eax,%edi
  8036e7:	48 b8 fe 39 80 00 00 	movabs $0x8039fe,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <listen>:

int
listen(int s, int backlog)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 20          	sub    $0x20,%rsp
  8036fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803700:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803706:	89 c7                	mov    %eax,%edi
  803708:	48 b8 6d 34 80 00 00 	movabs $0x80346d,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371b:	79 05                	jns    803722 <listen+0x2d>
		return r;
  80371d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803720:	eb 16                	jmp    803738 <listen+0x43>
	return nsipc_listen(r, backlog);
  803722:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803728:	89 d6                	mov    %edx,%esi
  80372a:	89 c7                	mov    %eax,%edi
  80372c:	48 b8 62 3a 80 00 00 	movabs $0x803a62,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   

000000000080373a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80373a:	55                   	push   %rbp
  80373b:	48 89 e5             	mov    %rsp,%rbp
  80373e:	48 83 ec 20          	sub    $0x20,%rsp
  803742:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803746:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80374a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80374e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803752:	89 c2                	mov    %eax,%edx
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	8b 40 0c             	mov    0xc(%rax),%eax
  80375b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80375f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803764:	89 c7                	mov    %eax,%edi
  803766:	48 b8 a2 3a 80 00 00 	movabs $0x803aa2,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 20          	sub    $0x20,%rsp
  80377c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803780:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803784:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803792:	8b 40 0c             	mov    0xc(%rax),%eax
  803795:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803799:	b9 00 00 00 00       	mov    $0x0,%ecx
  80379e:	89 c7                	mov    %eax,%edi
  8037a0:	48 b8 6e 3b 80 00 00 	movabs $0x803b6e,%rax
  8037a7:	00 00 00 
  8037aa:	ff d0                	callq  *%rax
}
  8037ac:	c9                   	leaveq 
  8037ad:	c3                   	retq   

00000000008037ae <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037ae:	55                   	push   %rbp
  8037af:	48 89 e5             	mov    %rsp,%rbp
  8037b2:	48 83 ec 10          	sub    $0x10,%rsp
  8037b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c2:	48 be 38 4f 80 00 00 	movabs $0x804f38,%rsi
  8037c9:	00 00 00 
  8037cc:	48 89 c7             	mov    %rax,%rdi
  8037cf:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
	return 0;
  8037db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e0:	c9                   	leaveq 
  8037e1:	c3                   	retq   

00000000008037e2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8037e2:	55                   	push   %rbp
  8037e3:	48 89 e5             	mov    %rsp,%rbp
  8037e6:	48 83 ec 20          	sub    $0x20,%rsp
  8037ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ed:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037f0:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037f3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037fc:	89 ce                	mov    %ecx,%esi
  8037fe:	89 c7                	mov    %eax,%edi
  803800:	48 b8 26 3c 80 00 00 	movabs $0x803c26,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80380f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803813:	79 05                	jns    80381a <socket+0x38>
		return r;
  803815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803818:	eb 11                	jmp    80382b <socket+0x49>
	return alloc_sockfd(r);
  80381a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381d:	89 c7                	mov    %eax,%edi
  80381f:	48 b8 c4 34 80 00 00 	movabs $0x8034c4,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
}
  80382b:	c9                   	leaveq 
  80382c:	c3                   	retq   

000000000080382d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80382d:	55                   	push   %rbp
  80382e:	48 89 e5             	mov    %rsp,%rbp
  803831:	48 83 ec 10          	sub    $0x10,%rsp
  803835:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803838:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80383f:	00 00 00 
  803842:	8b 00                	mov    (%rax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	75 1d                	jne    803865 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803848:	bf 02 00 00 00       	mov    $0x2,%edi
  80384d:	48 b8 e7 23 80 00 00 	movabs $0x8023e7,%rax
  803854:	00 00 00 
  803857:	ff d0                	callq  *%rax
  803859:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803860:	00 00 00 
  803863:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803865:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80386c:	00 00 00 
  80386f:	8b 00                	mov    (%rax),%eax
  803871:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803874:	b9 07 00 00 00       	mov    $0x7,%ecx
  803879:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803880:	00 00 00 
  803883:	89 c7                	mov    %eax,%edi
  803885:	48 b8 85 23 80 00 00 	movabs $0x802385,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803891:	ba 00 00 00 00       	mov    $0x0,%edx
  803896:	be 00 00 00 00       	mov    $0x0,%esi
  80389b:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a0:	48 b8 7f 22 80 00 00 	movabs $0x80227f,%rax
  8038a7:	00 00 00 
  8038aa:	ff d0                	callq  *%rax
}
  8038ac:	c9                   	leaveq 
  8038ad:	c3                   	retq   

00000000008038ae <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038ae:	55                   	push   %rbp
  8038af:	48 89 e5             	mov    %rsp,%rbp
  8038b2:	48 83 ec 30          	sub    $0x30,%rsp
  8038b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038c8:	00 00 00 
  8038cb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038ce:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8038d5:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
  8038e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e8:	78 3e                	js     803928 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8038ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038f1:	00 00 00 
  8038f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8038f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fc:	8b 40 10             	mov    0x10(%rax),%eax
  8038ff:	89 c2                	mov    %eax,%edx
  803901:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803909:	48 89 ce             	mov    %rcx,%rsi
  80390c:	48 89 c7             	mov    %rax,%rdi
  80390f:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80391b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391f:	8b 50 10             	mov    0x10(%rax),%edx
  803922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803926:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803928:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 10          	sub    $0x10,%rsp
  803935:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803938:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80393c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80393f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803946:	00 00 00 
  803949:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80394e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803955:	48 89 c6             	mov    %rax,%rsi
  803958:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80395f:	00 00 00 
  803962:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80396e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803975:	00 00 00 
  803978:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80397b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80397e:	bf 02 00 00 00       	mov    $0x2,%edi
  803983:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  80398a:	00 00 00 
  80398d:	ff d0                	callq  *%rax
}
  80398f:	c9                   	leaveq 
  803990:	c3                   	retq   

0000000000803991 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803991:	55                   	push   %rbp
  803992:	48 89 e5             	mov    %rsp,%rbp
  803995:	48 83 ec 10          	sub    $0x10,%rsp
  803999:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80399c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80399f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039a6:	00 00 00 
  8039a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8039ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b5:	00 00 00 
  8039b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039bb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039be:	bf 03 00 00 00       	mov    $0x3,%edi
  8039c3:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
}
  8039cf:	c9                   	leaveq 
  8039d0:	c3                   	retq   

00000000008039d1 <nsipc_close>:

int
nsipc_close(int s)
{
  8039d1:	55                   	push   %rbp
  8039d2:	48 89 e5             	mov    %rsp,%rbp
  8039d5:	48 83 ec 10          	sub    $0x10,%rsp
  8039d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8039dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e3:	00 00 00 
  8039e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039e9:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8039eb:	bf 04 00 00 00       	mov    $0x4,%edi
  8039f0:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  8039f7:	00 00 00 
  8039fa:	ff d0                	callq  *%rax
}
  8039fc:	c9                   	leaveq 
  8039fd:	c3                   	retq   

00000000008039fe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039fe:	55                   	push   %rbp
  8039ff:	48 89 e5             	mov    %rsp,%rbp
  803a02:	48 83 ec 10          	sub    $0x10,%rsp
  803a06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a0d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803a10:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a17:	00 00 00 
  803a1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a1d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a26:	48 89 c6             	mov    %rax,%rsi
  803a29:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a30:	00 00 00 
  803a33:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a3f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a46:	00 00 00 
  803a49:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a4c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a4f:	bf 05 00 00 00       	mov    $0x5,%edi
  803a54:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  803a5b:	00 00 00 
  803a5e:	ff d0                	callq  *%rax
}
  803a60:	c9                   	leaveq 
  803a61:	c3                   	retq   

0000000000803a62 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a62:	55                   	push   %rbp
  803a63:	48 89 e5             	mov    %rsp,%rbp
  803a66:	48 83 ec 10          	sub    $0x10,%rsp
  803a6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a6d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a70:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a77:	00 00 00 
  803a7a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a7d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a7f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a86:	00 00 00 
  803a89:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a8c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a8f:	bf 06 00 00 00       	mov    $0x6,%edi
  803a94:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  803a9b:	00 00 00 
  803a9e:	ff d0                	callq  *%rax
}
  803aa0:	c9                   	leaveq 
  803aa1:	c3                   	retq   

0000000000803aa2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803aa2:	55                   	push   %rbp
  803aa3:	48 89 e5             	mov    %rsp,%rbp
  803aa6:	48 83 ec 30          	sub    $0x30,%rsp
  803aaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ab1:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803ab4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ab7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803abe:	00 00 00 
  803ac1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ac4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ac6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803acd:	00 00 00 
  803ad0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ad3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ad6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803add:	00 00 00 
  803ae0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ae3:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ae6:	bf 07 00 00 00       	mov    $0x7,%edi
  803aeb:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afe:	78 69                	js     803b69 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803b00:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803b07:	7f 08                	jg     803b11 <nsipc_recv+0x6f>
  803b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803b0f:	7e 35                	jle    803b46 <nsipc_recv+0xa4>
  803b11:	48 b9 3f 4f 80 00 00 	movabs $0x804f3f,%rcx
  803b18:	00 00 00 
  803b1b:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803b22:	00 00 00 
  803b25:	be 61 00 00 00       	mov    $0x61,%esi
  803b2a:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803b31:	00 00 00 
  803b34:	b8 00 00 00 00       	mov    $0x0,%eax
  803b39:	49 b8 f5 44 80 00 00 	movabs $0x8044f5,%r8
  803b40:	00 00 00 
  803b43:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b49:	48 63 d0             	movslq %eax,%rdx
  803b4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b50:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b57:	00 00 00 
  803b5a:	48 89 c7             	mov    %rax,%rdi
  803b5d:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
	}

	return r;
  803b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b6c:	c9                   	leaveq 
  803b6d:	c3                   	retq   

0000000000803b6e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b6e:	55                   	push   %rbp
  803b6f:	48 89 e5             	mov    %rsp,%rbp
  803b72:	48 83 ec 20          	sub    $0x20,%rsp
  803b76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b7d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b80:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b83:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b8a:	00 00 00 
  803b8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b90:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b92:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b99:	7e 35                	jle    803bd0 <nsipc_send+0x62>
  803b9b:	48 b9 75 4f 80 00 00 	movabs $0x804f75,%rcx
  803ba2:	00 00 00 
  803ba5:	48 ba 54 4f 80 00 00 	movabs $0x804f54,%rdx
  803bac:	00 00 00 
  803baf:	be 6c 00 00 00       	mov    $0x6c,%esi
  803bb4:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803bbb:	00 00 00 
  803bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc3:	49 b8 f5 44 80 00 00 	movabs $0x8044f5,%r8
  803bca:	00 00 00 
  803bcd:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd3:	48 63 d0             	movslq %eax,%rdx
  803bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bda:	48 89 c6             	mov    %rax,%rsi
  803bdd:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803be4:	00 00 00 
  803be7:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803bee:	00 00 00 
  803bf1:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803bf3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bfa:	00 00 00 
  803bfd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c00:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803c03:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c0a:	00 00 00 
  803c0d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c10:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803c13:	bf 08 00 00 00       	mov    $0x8,%edi
  803c18:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
}
  803c24:	c9                   	leaveq 
  803c25:	c3                   	retq   

0000000000803c26 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c26:	55                   	push   %rbp
  803c27:	48 89 e5             	mov    %rsp,%rbp
  803c2a:	48 83 ec 10          	sub    $0x10,%rsp
  803c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c31:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c34:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c3e:	00 00 00 
  803c41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c44:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c4d:	00 00 00 
  803c50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c53:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c56:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c5d:	00 00 00 
  803c60:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c63:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c66:	bf 09 00 00 00       	mov    $0x9,%edi
  803c6b:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
}
  803c77:	c9                   	leaveq 
  803c78:	c3                   	retq   

0000000000803c79 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c79:	55                   	push   %rbp
  803c7a:	48 89 e5             	mov    %rsp,%rbp
  803c7d:	53                   	push   %rbx
  803c7e:	48 83 ec 38          	sub    $0x38,%rsp
  803c82:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c86:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c8a:	48 89 c7             	mov    %rax,%rdi
  803c8d:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  803c94:	00 00 00 
  803c97:	ff d0                	callq  *%rax
  803c99:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ca0:	0f 88 bf 01 00 00    	js     803e65 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ca6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803caa:	ba 07 04 00 00       	mov    $0x407,%edx
  803caf:	48 89 c6             	mov    %rax,%rsi
  803cb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb7:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
  803cc3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cca:	0f 88 95 01 00 00    	js     803e65 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cd0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cd4:	48 89 c7             	mov    %rax,%rdi
  803cd7:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
  803ce3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ce6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cea:	0f 88 5d 01 00 00    	js     803e4d <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cf0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cf4:	ba 07 04 00 00       	mov    $0x407,%edx
  803cf9:	48 89 c6             	mov    %rax,%rsi
  803cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  803d01:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
  803d0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d14:	0f 88 33 01 00 00    	js     803e4d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d1e:	48 89 c7             	mov    %rax,%rdi
  803d21:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
  803d2d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d35:	ba 07 04 00 00       	mov    $0x407,%edx
  803d3a:	48 89 c6             	mov    %rax,%rsi
  803d3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d42:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803d49:	00 00 00 
  803d4c:	ff d0                	callq  *%rax
  803d4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d55:	79 05                	jns    803d5c <pipe+0xe3>
		goto err2;
  803d57:	e9 d9 00 00 00       	jmpq   803e35 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d60:	48 89 c7             	mov    %rax,%rdi
  803d63:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
  803d6f:	48 89 c2             	mov    %rax,%rdx
  803d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d76:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d7c:	48 89 d1             	mov    %rdx,%rcx
  803d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  803d84:	48 89 c6             	mov    %rax,%rsi
  803d87:	bf 00 00 00 00       	mov    $0x0,%edi
  803d8c:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
  803d98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d9f:	79 1b                	jns    803dbc <pipe+0x143>
		goto err3;
  803da1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803da2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803da6:	48 89 c6             	mov    %rax,%rsi
  803da9:	bf 00 00 00 00       	mov    $0x0,%edi
  803dae:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
  803dba:	eb 79                	jmp    803e35 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803dbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803dc7:	00 00 00 
  803dca:	8b 12                	mov    (%rdx),%edx
  803dcc:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803dce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803dd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ddd:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803de4:	00 00 00 
  803de7:	8b 12                	mov    (%rdx),%edx
  803de9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803deb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803def:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfa:	48 89 c7             	mov    %rax,%rdi
  803dfd:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  803e04:	00 00 00 
  803e07:	ff d0                	callq  *%rax
  803e09:	89 c2                	mov    %eax,%edx
  803e0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e0f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e15:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e1d:	48 89 c7             	mov    %rax,%rdi
  803e20:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  803e27:	00 00 00 
  803e2a:	ff d0                	callq  *%rax
  803e2c:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e33:	eb 33                	jmp    803e68 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803e35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e39:	48 89 c6             	mov    %rax,%rsi
  803e3c:	bf 00 00 00 00       	mov    $0x0,%edi
  803e41:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e51:	48 89 c6             	mov    %rax,%rsi
  803e54:	bf 00 00 00 00       	mov    $0x0,%edi
  803e59:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803e60:	00 00 00 
  803e63:	ff d0                	callq  *%rax
err:
	return r;
  803e65:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e68:	48 83 c4 38          	add    $0x38,%rsp
  803e6c:	5b                   	pop    %rbx
  803e6d:	5d                   	pop    %rbp
  803e6e:	c3                   	retq   

0000000000803e6f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e6f:	55                   	push   %rbp
  803e70:	48 89 e5             	mov    %rsp,%rbp
  803e73:	53                   	push   %rbx
  803e74:	48 83 ec 28          	sub    $0x28,%rsp
  803e78:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e7c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e80:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803e87:	00 00 00 
  803e8a:	48 8b 00             	mov    (%rax),%rax
  803e8d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e93:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9a:	48 89 c7             	mov    %rax,%rdi
  803e9d:	48 b8 49 47 80 00 00 	movabs $0x804749,%rax
  803ea4:	00 00 00 
  803ea7:	ff d0                	callq  *%rax
  803ea9:	89 c3                	mov    %eax,%ebx
  803eab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 49 47 80 00 00 	movabs $0x804749,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
  803ebe:	39 c3                	cmp    %eax,%ebx
  803ec0:	0f 94 c0             	sete   %al
  803ec3:	0f b6 c0             	movzbl %al,%eax
  803ec6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ec9:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803ed0:	00 00 00 
  803ed3:	48 8b 00             	mov    (%rax),%rax
  803ed6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803edc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803edf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ee2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ee5:	75 05                	jne    803eec <_pipeisclosed+0x7d>
			return ret;
  803ee7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803eea:	eb 4f                	jmp    803f3b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803eec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eef:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ef2:	74 42                	je     803f36 <_pipeisclosed+0xc7>
  803ef4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ef8:	75 3c                	jne    803f36 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803efa:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803f01:	00 00 00 
  803f04:	48 8b 00             	mov    (%rax),%rax
  803f07:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f0d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f13:	89 c6                	mov    %eax,%esi
  803f15:	48 bf 86 4f 80 00 00 	movabs $0x804f86,%rdi
  803f1c:	00 00 00 
  803f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f24:	49 b8 ca 03 80 00 00 	movabs $0x8003ca,%r8
  803f2b:	00 00 00 
  803f2e:	41 ff d0             	callq  *%r8
	}
  803f31:	e9 4a ff ff ff       	jmpq   803e80 <_pipeisclosed+0x11>
  803f36:	e9 45 ff ff ff       	jmpq   803e80 <_pipeisclosed+0x11>
}
  803f3b:	48 83 c4 28          	add    $0x28,%rsp
  803f3f:	5b                   	pop    %rbx
  803f40:	5d                   	pop    %rbp
  803f41:	c3                   	retq   

0000000000803f42 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f42:	55                   	push   %rbp
  803f43:	48 89 e5             	mov    %rsp,%rbp
  803f46:	48 83 ec 30          	sub    $0x30,%rsp
  803f4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f54:	48 89 d6             	mov    %rdx,%rsi
  803f57:	89 c7                	mov    %eax,%edi
  803f59:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  803f60:	00 00 00 
  803f63:	ff d0                	callq  *%rax
  803f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6c:	79 05                	jns    803f73 <pipeisclosed+0x31>
		return r;
  803f6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f71:	eb 31                	jmp    803fa4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f77:	48 89 c7             	mov    %rax,%rdi
  803f7a:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  803f81:	00 00 00 
  803f84:	ff d0                	callq  *%rax
  803f86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f92:	48 89 d6             	mov    %rdx,%rsi
  803f95:	48 89 c7             	mov    %rax,%rdi
  803f98:	48 b8 6f 3e 80 00 00 	movabs $0x803e6f,%rax
  803f9f:	00 00 00 
  803fa2:	ff d0                	callq  *%rax
}
  803fa4:	c9                   	leaveq 
  803fa5:	c3                   	retq   

0000000000803fa6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fa6:	55                   	push   %rbp
  803fa7:	48 89 e5             	mov    %rsp,%rbp
  803faa:	48 83 ec 40          	sub    $0x40,%rsp
  803fae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fb2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803fb6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fbe:	48 89 c7             	mov    %rax,%rdi
  803fc1:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
  803fcd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fd9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fe0:	00 
  803fe1:	e9 92 00 00 00       	jmpq   804078 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803fe6:	eb 41                	jmp    804029 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803fe8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fed:	74 09                	je     803ff8 <devpipe_read+0x52>
				return i;
  803fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff3:	e9 92 00 00 00       	jmpq   80408a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ff8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ffc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804000:	48 89 d6             	mov    %rdx,%rsi
  804003:	48 89 c7             	mov    %rax,%rdi
  804006:	48 b8 6f 3e 80 00 00 	movabs $0x803e6f,%rax
  80400d:	00 00 00 
  804010:	ff d0                	callq  *%rax
  804012:	85 c0                	test   %eax,%eax
  804014:	74 07                	je     80401d <devpipe_read+0x77>
				return 0;
  804016:	b8 00 00 00 00       	mov    $0x0,%eax
  80401b:	eb 6d                	jmp    80408a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80401d:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80402d:	8b 10                	mov    (%rax),%edx
  80402f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804033:	8b 40 04             	mov    0x4(%rax),%eax
  804036:	39 c2                	cmp    %eax,%edx
  804038:	74 ae                	je     803fe8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80403a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80403e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804042:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404a:	8b 00                	mov    (%rax),%eax
  80404c:	99                   	cltd   
  80404d:	c1 ea 1b             	shr    $0x1b,%edx
  804050:	01 d0                	add    %edx,%eax
  804052:	83 e0 1f             	and    $0x1f,%eax
  804055:	29 d0                	sub    %edx,%eax
  804057:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80405b:	48 98                	cltq   
  80405d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804062:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804068:	8b 00                	mov    (%rax),%eax
  80406a:	8d 50 01             	lea    0x1(%rax),%edx
  80406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804071:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804073:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80407c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804080:	0f 82 60 ff ff ff    	jb     803fe6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80408a:	c9                   	leaveq 
  80408b:	c3                   	retq   

000000000080408c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80408c:	55                   	push   %rbp
  80408d:	48 89 e5             	mov    %rsp,%rbp
  804090:	48 83 ec 40          	sub    $0x40,%rsp
  804094:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804098:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80409c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8040a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a4:	48 89 c7             	mov    %rax,%rdi
  8040a7:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  8040ae:	00 00 00 
  8040b1:	ff d0                	callq  *%rax
  8040b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040c6:	00 
  8040c7:	e9 8e 00 00 00       	jmpq   80415a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040cc:	eb 31                	jmp    8040ff <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d6:	48 89 d6             	mov    %rdx,%rsi
  8040d9:	48 89 c7             	mov    %rax,%rdi
  8040dc:	48 b8 6f 3e 80 00 00 	movabs $0x803e6f,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	85 c0                	test   %eax,%eax
  8040ea:	74 07                	je     8040f3 <devpipe_write+0x67>
				return 0;
  8040ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f1:	eb 79                	jmp    80416c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040f3:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804103:	8b 40 04             	mov    0x4(%rax),%eax
  804106:	48 63 d0             	movslq %eax,%rdx
  804109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410d:	8b 00                	mov    (%rax),%eax
  80410f:	48 98                	cltq   
  804111:	48 83 c0 20          	add    $0x20,%rax
  804115:	48 39 c2             	cmp    %rax,%rdx
  804118:	73 b4                	jae    8040ce <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80411a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411e:	8b 40 04             	mov    0x4(%rax),%eax
  804121:	99                   	cltd   
  804122:	c1 ea 1b             	shr    $0x1b,%edx
  804125:	01 d0                	add    %edx,%eax
  804127:	83 e0 1f             	and    $0x1f,%eax
  80412a:	29 d0                	sub    %edx,%eax
  80412c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804130:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804134:	48 01 ca             	add    %rcx,%rdx
  804137:	0f b6 0a             	movzbl (%rdx),%ecx
  80413a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80413e:	48 98                	cltq   
  804140:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804148:	8b 40 04             	mov    0x4(%rax),%eax
  80414b:	8d 50 01             	lea    0x1(%rax),%edx
  80414e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804152:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804155:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80415a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80415e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804162:	0f 82 64 ff ff ff    	jb     8040cc <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80416c:	c9                   	leaveq 
  80416d:	c3                   	retq   

000000000080416e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80416e:	55                   	push   %rbp
  80416f:	48 89 e5             	mov    %rsp,%rbp
  804172:	48 83 ec 20          	sub    $0x20,%rsp
  804176:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80417a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80417e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804182:	48 89 c7             	mov    %rax,%rdi
  804185:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  80418c:	00 00 00 
  80418f:	ff d0                	callq  *%rax
  804191:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804199:	48 be 99 4f 80 00 00 	movabs $0x804f99,%rsi
  8041a0:	00 00 00 
  8041a3:	48 89 c7             	mov    %rax,%rdi
  8041a6:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8041ad:	00 00 00 
  8041b0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8041b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b6:	8b 50 04             	mov    0x4(%rax),%edx
  8041b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bd:	8b 00                	mov    (%rax),%eax
  8041bf:	29 c2                	sub    %eax,%edx
  8041c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041cf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041d6:	00 00 00 
	stat->st_dev = &devpipe;
  8041d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041dd:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8041e4:	00 00 00 
  8041e7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8041ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041f3:	c9                   	leaveq 
  8041f4:	c3                   	retq   

00000000008041f5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041f5:	55                   	push   %rbp
  8041f6:	48 89 e5             	mov    %rsp,%rbp
  8041f9:	48 83 ec 10          	sub    $0x10,%rsp
  8041fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804205:	48 89 c6             	mov    %rax,%rsi
  804208:	bf 00 00 00 00       	mov    $0x0,%edi
  80420d:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  804214:	00 00 00 
  804217:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804219:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421d:	48 89 c7             	mov    %rax,%rdi
  804220:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  804227:	00 00 00 
  80422a:	ff d0                	callq  *%rax
  80422c:	48 89 c6             	mov    %rax,%rsi
  80422f:	bf 00 00 00 00       	mov    $0x0,%edi
  804234:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80423b:	00 00 00 
  80423e:	ff d0                	callq  *%rax
}
  804240:	c9                   	leaveq 
  804241:	c3                   	retq   

0000000000804242 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804242:	55                   	push   %rbp
  804243:	48 89 e5             	mov    %rsp,%rbp
  804246:	48 83 ec 20          	sub    $0x20,%rsp
  80424a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80424d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804250:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804253:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804257:	be 01 00 00 00       	mov    $0x1,%esi
  80425c:	48 89 c7             	mov    %rax,%rdi
  80425f:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  804266:	00 00 00 
  804269:	ff d0                	callq  *%rax
}
  80426b:	c9                   	leaveq 
  80426c:	c3                   	retq   

000000000080426d <getchar>:

int
getchar(void)
{
  80426d:	55                   	push   %rbp
  80426e:	48 89 e5             	mov    %rsp,%rbp
  804271:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804275:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804279:	ba 01 00 00 00       	mov    $0x1,%edx
  80427e:	48 89 c6             	mov    %rax,%rsi
  804281:	bf 00 00 00 00       	mov    $0x0,%edi
  804286:	48 b8 81 29 80 00 00 	movabs $0x802981,%rax
  80428d:	00 00 00 
  804290:	ff d0                	callq  *%rax
  804292:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804299:	79 05                	jns    8042a0 <getchar+0x33>
		return r;
  80429b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80429e:	eb 14                	jmp    8042b4 <getchar+0x47>
	if (r < 1)
  8042a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042a4:	7f 07                	jg     8042ad <getchar+0x40>
		return -E_EOF;
  8042a6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8042ab:	eb 07                	jmp    8042b4 <getchar+0x47>
	return c;
  8042ad:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8042b1:	0f b6 c0             	movzbl %al,%eax
}
  8042b4:	c9                   	leaveq 
  8042b5:	c3                   	retq   

00000000008042b6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042b6:	55                   	push   %rbp
  8042b7:	48 89 e5             	mov    %rsp,%rbp
  8042ba:	48 83 ec 20          	sub    $0x20,%rsp
  8042be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042c8:	48 89 d6             	mov    %rdx,%rsi
  8042cb:	89 c7                	mov    %eax,%edi
  8042cd:	48 b8 4f 25 80 00 00 	movabs $0x80254f,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
  8042d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e0:	79 05                	jns    8042e7 <iscons+0x31>
		return r;
  8042e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042e5:	eb 1a                	jmp    804301 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8042e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042eb:	8b 10                	mov    (%rax),%edx
  8042ed:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8042f4:	00 00 00 
  8042f7:	8b 00                	mov    (%rax),%eax
  8042f9:	39 c2                	cmp    %eax,%edx
  8042fb:	0f 94 c0             	sete   %al
  8042fe:	0f b6 c0             	movzbl %al,%eax
}
  804301:	c9                   	leaveq 
  804302:	c3                   	retq   

0000000000804303 <opencons>:

int
opencons(void)
{
  804303:	55                   	push   %rbp
  804304:	48 89 e5             	mov    %rsp,%rbp
  804307:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80430b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80430f:	48 89 c7             	mov    %rax,%rdi
  804312:	48 b8 b7 24 80 00 00 	movabs $0x8024b7,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
  80431e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804321:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804325:	79 05                	jns    80432c <opencons+0x29>
		return r;
  804327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432a:	eb 5b                	jmp    804387 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80432c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804330:	ba 07 04 00 00       	mov    $0x407,%edx
  804335:	48 89 c6             	mov    %rax,%rsi
  804338:	bf 00 00 00 00       	mov    $0x0,%edi
  80433d:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  804344:	00 00 00 
  804347:	ff d0                	callq  *%rax
  804349:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80434c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804350:	79 05                	jns    804357 <opencons+0x54>
		return r;
  804352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804355:	eb 30                	jmp    804387 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80435b:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804362:	00 00 00 
  804365:	8b 12                	mov    (%rdx),%edx
  804367:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804378:	48 89 c7             	mov    %rax,%rdi
  80437b:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	48 83 ec 30          	sub    $0x30,%rsp
  804391:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804395:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804399:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80439d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8043a2:	75 07                	jne    8043ab <devcons_read+0x22>
		return 0;
  8043a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a9:	eb 4b                	jmp    8043f6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8043ab:	eb 0c                	jmp    8043b9 <devcons_read+0x30>
		sys_yield();
  8043ad:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  8043b4:	00 00 00 
  8043b7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8043b9:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  8043c0:	00 00 00 
  8043c3:	ff d0                	callq  *%rax
  8043c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043cc:	74 df                	je     8043ad <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8043ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d2:	79 05                	jns    8043d9 <devcons_read+0x50>
		return c;
  8043d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d7:	eb 1d                	jmp    8043f6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8043d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8043dd:	75 07                	jne    8043e6 <devcons_read+0x5d>
		return 0;
  8043df:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e4:	eb 10                	jmp    8043f6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8043e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043e9:	89 c2                	mov    %eax,%edx
  8043eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ef:	88 10                	mov    %dl,(%rax)
	return 1;
  8043f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043f6:	c9                   	leaveq 
  8043f7:	c3                   	retq   

00000000008043f8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043f8:	55                   	push   %rbp
  8043f9:	48 89 e5             	mov    %rsp,%rbp
  8043fc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804403:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80440a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804411:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80441f:	eb 76                	jmp    804497 <devcons_write+0x9f>
		m = n - tot;
  804421:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804428:	89 c2                	mov    %eax,%edx
  80442a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442d:	29 c2                	sub    %eax,%edx
  80442f:	89 d0                	mov    %edx,%eax
  804431:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804434:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804437:	83 f8 7f             	cmp    $0x7f,%eax
  80443a:	76 07                	jbe    804443 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80443c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804443:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804446:	48 63 d0             	movslq %eax,%rdx
  804449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444c:	48 63 c8             	movslq %eax,%rcx
  80444f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804456:	48 01 c1             	add    %rax,%rcx
  804459:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804460:	48 89 ce             	mov    %rcx,%rsi
  804463:	48 89 c7             	mov    %rax,%rdi
  804466:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  80446d:	00 00 00 
  804470:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804472:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804475:	48 63 d0             	movslq %eax,%rdx
  804478:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80447f:	48 89 d6             	mov    %rdx,%rsi
  804482:	48 89 c7             	mov    %rax,%rdi
  804485:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  80448c:	00 00 00 
  80448f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804491:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804494:	01 45 fc             	add    %eax,-0x4(%rbp)
  804497:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449a:	48 98                	cltq   
  80449c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8044a3:	0f 82 78 ff ff ff    	jb     804421 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8044a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044ac:	c9                   	leaveq 
  8044ad:	c3                   	retq   

00000000008044ae <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8044ae:	55                   	push   %rbp
  8044af:	48 89 e5             	mov    %rsp,%rbp
  8044b2:	48 83 ec 08          	sub    $0x8,%rsp
  8044b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044bf:	c9                   	leaveq 
  8044c0:	c3                   	retq   

00000000008044c1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044c1:	55                   	push   %rbp
  8044c2:	48 89 e5             	mov    %rsp,%rbp
  8044c5:	48 83 ec 10          	sub    $0x10,%rsp
  8044c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d5:	48 be a5 4f 80 00 00 	movabs $0x804fa5,%rsi
  8044dc:	00 00 00 
  8044df:	48 89 c7             	mov    %rax,%rdi
  8044e2:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8044e9:	00 00 00 
  8044ec:	ff d0                	callq  *%rax
	return 0;
  8044ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044f3:	c9                   	leaveq 
  8044f4:	c3                   	retq   

00000000008044f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8044f5:	55                   	push   %rbp
  8044f6:	48 89 e5             	mov    %rsp,%rbp
  8044f9:	53                   	push   %rbx
  8044fa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804501:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  804508:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80450e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804515:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80451c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804523:	84 c0                	test   %al,%al
  804525:	74 23                	je     80454a <_panic+0x55>
  804527:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80452e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804532:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804536:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80453a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80453e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804542:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804546:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80454a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804551:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804558:	00 00 00 
  80455b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804562:	00 00 00 
  804565:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804569:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804570:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804577:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80457e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804585:	00 00 00 
  804588:	48 8b 18             	mov    (%rax),%rbx
  80458b:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
  804597:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80459d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8045a4:	41 89 c8             	mov    %ecx,%r8d
  8045a7:	48 89 d1             	mov    %rdx,%rcx
  8045aa:	48 89 da             	mov    %rbx,%rdx
  8045ad:	89 c6                	mov    %eax,%esi
  8045af:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  8045b6:	00 00 00 
  8045b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045be:	49 b9 ca 03 80 00 00 	movabs $0x8003ca,%r9
  8045c5:	00 00 00 
  8045c8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8045cb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8045d2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8045d9:	48 89 d6             	mov    %rdx,%rsi
  8045dc:	48 89 c7             	mov    %rax,%rdi
  8045df:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  8045e6:	00 00 00 
  8045e9:	ff d0                	callq  *%rax
	cprintf("\n");
  8045eb:	48 bf d3 4f 80 00 00 	movabs $0x804fd3,%rdi
  8045f2:	00 00 00 
  8045f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8045fa:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  804601:	00 00 00 
  804604:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804606:	cc                   	int3   
  804607:	eb fd                	jmp    804606 <_panic+0x111>

0000000000804609 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804609:	55                   	push   %rbp
  80460a:	48 89 e5             	mov    %rsp,%rbp
  80460d:	48 83 ec 10          	sub    $0x10,%rsp
  804611:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804615:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80461c:	00 00 00 
  80461f:	48 8b 00             	mov    (%rax),%rax
  804622:	48 85 c0             	test   %rax,%rax
  804625:	0f 85 84 00 00 00    	jne    8046af <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80462b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804632:	00 00 00 
  804635:	48 8b 00             	mov    (%rax),%rax
  804638:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80463e:	ba 07 00 00 00       	mov    $0x7,%edx
  804643:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804648:	89 c7                	mov    %eax,%edi
  80464a:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  804651:	00 00 00 
  804654:	ff d0                	callq  *%rax
  804656:	85 c0                	test   %eax,%eax
  804658:	79 2a                	jns    804684 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80465a:	48 ba d8 4f 80 00 00 	movabs $0x804fd8,%rdx
  804661:	00 00 00 
  804664:	be 23 00 00 00       	mov    $0x23,%esi
  804669:	48 bf ff 4f 80 00 00 	movabs $0x804fff,%rdi
  804670:	00 00 00 
  804673:	b8 00 00 00 00       	mov    $0x0,%eax
  804678:	48 b9 f5 44 80 00 00 	movabs $0x8044f5,%rcx
  80467f:	00 00 00 
  804682:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804684:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80468b:	00 00 00 
  80468e:	48 8b 00             	mov    (%rax),%rax
  804691:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804697:	48 be c2 46 80 00 00 	movabs $0x8046c2,%rsi
  80469e:	00 00 00 
  8046a1:	89 c7                	mov    %eax,%edi
  8046a3:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  8046aa:	00 00 00 
  8046ad:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046b6:	00 00 00 
  8046b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046bd:	48 89 10             	mov    %rdx,(%rax)
}
  8046c0:	c9                   	leaveq 
  8046c1:	c3                   	retq   

00000000008046c2 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8046c2:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8046c5:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8046cc:	00 00 00 
call *%rax
  8046cf:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8046d1:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8046d8:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8046d9:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8046e0:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8046e1:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8046e5:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8046e8:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8046ef:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8046f0:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8046f4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8046f8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8046fd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804702:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804707:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80470c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804711:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804716:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80471b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804720:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804725:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80472a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80472f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804734:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804739:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80473e:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804742:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804746:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804747:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804748:	c3                   	retq   

0000000000804749 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804749:	55                   	push   %rbp
  80474a:	48 89 e5             	mov    %rsp,%rbp
  80474d:	48 83 ec 18          	sub    $0x18,%rsp
  804751:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804759:	48 c1 e8 15          	shr    $0x15,%rax
  80475d:	48 89 c2             	mov    %rax,%rdx
  804760:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804767:	01 00 00 
  80476a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80476e:	83 e0 01             	and    $0x1,%eax
  804771:	48 85 c0             	test   %rax,%rax
  804774:	75 07                	jne    80477d <pageref+0x34>
		return 0;
  804776:	b8 00 00 00 00       	mov    $0x0,%eax
  80477b:	eb 53                	jmp    8047d0 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80477d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804781:	48 c1 e8 0c          	shr    $0xc,%rax
  804785:	48 89 c2             	mov    %rax,%rdx
  804788:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80478f:	01 00 00 
  804792:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80479a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80479e:	83 e0 01             	and    $0x1,%eax
  8047a1:	48 85 c0             	test   %rax,%rax
  8047a4:	75 07                	jne    8047ad <pageref+0x64>
		return 0;
  8047a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ab:	eb 23                	jmp    8047d0 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8047ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8047b5:	48 89 c2             	mov    %rax,%rdx
  8047b8:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8047bf:	00 00 00 
  8047c2:	48 c1 e2 04          	shl    $0x4,%rdx
  8047c6:	48 01 d0             	add    %rdx,%rax
  8047c9:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8047cd:	0f b7 c0             	movzwl %ax,%eax
}
  8047d0:	c9                   	leaveq 
  8047d1:	c3                   	retq   
