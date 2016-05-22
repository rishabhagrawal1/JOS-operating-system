
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
  800060:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf 40 3d 80 00 00 	movabs $0x803d40,%rdi
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
  8000c6:	48 bf 5a 3d 80 00 00 	movabs $0x803d5a,%rdi
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
  8000f5:	48 b8 bb 22 80 00 00 	movabs $0x8022bb,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
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
  800168:	48 bf 70 3d 80 00 00 	movabs $0x803d70,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba ca 03 80 00 00 	movabs $0x8003ca,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 bb 22 80 00 00 	movabs $0x8022bb,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
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
  800235:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  800286:	48 b8 e0 26 80 00 00 	movabs $0x8026e0,%rax
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
  800536:	48 ba 68 3f 80 00 00 	movabs $0x803f68,%rdx
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
  80082e:	48 b8 90 3f 80 00 00 	movabs $0x803f90,%rax
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
  80097c:	83 fb 10             	cmp    $0x10,%ebx
  80097f:	7f 16                	jg     800997 <vprintfmt+0x21a>
  800981:	48 b8 e0 3e 80 00 00 	movabs $0x803ee0,%rax
  800988:	00 00 00 
  80098b:	48 63 d3             	movslq %ebx,%rdx
  80098e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800992:	4d 85 e4             	test   %r12,%r12
  800995:	75 2e                	jne    8009c5 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800997:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80099b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099f:	89 d9                	mov    %ebx,%ecx
  8009a1:	48 ba 79 3f 80 00 00 	movabs $0x803f79,%rdx
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
  8009d0:	48 ba 82 3f 80 00 00 	movabs $0x803f82,%rdx
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
  800a2a:	49 bc 85 3f 80 00 00 	movabs $0x803f85,%r12
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
  801730:	48 ba 40 42 80 00 00 	movabs $0x804240,%rdx
  801737:	00 00 00 
  80173a:	be 23 00 00 00       	mov    $0x23,%esi
  80173f:	48 bf 5d 42 80 00 00 	movabs $0x80425d,%rdi
  801746:	00 00 00 
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
  80174e:	49 b9 44 3a 80 00 00 	movabs $0x803a44,%r9
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

0000000000801b1b <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801b1b:	55                   	push   %rbp
  801b1c:	48 89 e5             	mov    %rsp,%rbp
  801b1f:	48 83 ec 30          	sub    $0x30,%rsp
  801b23:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2b:	48 8b 00             	mov    (%rax),%rax
  801b2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b36:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b3a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801b3d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b40:	83 e0 02             	and    $0x2,%eax
  801b43:	85 c0                	test   %eax,%eax
  801b45:	75 4d                	jne    801b94 <pgfault+0x79>
  801b47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4b:	48 c1 e8 0c          	shr    $0xc,%rax
  801b4f:	48 89 c2             	mov    %rax,%rdx
  801b52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b59:	01 00 00 
  801b5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b60:	25 00 08 00 00       	and    $0x800,%eax
  801b65:	48 85 c0             	test   %rax,%rax
  801b68:	74 2a                	je     801b94 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801b6a:	48 ba 70 42 80 00 00 	movabs $0x804270,%rdx
  801b71:	00 00 00 
  801b74:	be 23 00 00 00       	mov    $0x23,%esi
  801b79:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801b80:	00 00 00 
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
  801b88:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801b8f:	00 00 00 
  801b92:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801b94:	ba 07 00 00 00       	mov    $0x7,%edx
  801b99:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba3:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  801baa:	00 00 00 
  801bad:	ff d0                	callq  *%rax
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	0f 85 cd 00 00 00    	jne    801c84 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801bc9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801bcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bd1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bd6:	48 89 c6             	mov    %rax,%rsi
  801bd9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801bde:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801bea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bee:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801bf4:	48 89 c1             	mov    %rax,%rcx
  801bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c01:	bf 00 00 00 00       	mov    $0x0,%edi
  801c06:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
  801c12:	85 c0                	test   %eax,%eax
  801c14:	79 2a                	jns    801c40 <pgfault+0x125>
				panic("Page map at temp address failed");
  801c16:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801c1d:	00 00 00 
  801c20:	be 30 00 00 00       	mov    $0x30,%esi
  801c25:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801c2c:	00 00 00 
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c34:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801c3b:	00 00 00 
  801c3e:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801c40:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c45:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4a:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	callq  *%rax
  801c56:	85 c0                	test   %eax,%eax
  801c58:	79 54                	jns    801cae <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801c5a:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  801c61:	00 00 00 
  801c64:	be 32 00 00 00       	mov    $0x32,%esi
  801c69:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801c70:	00 00 00 
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
  801c78:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801c7f:	00 00 00 
  801c82:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801c84:	48 ba f8 42 80 00 00 	movabs $0x8042f8,%rdx
  801c8b:	00 00 00 
  801c8e:	be 34 00 00 00       	mov    $0x34,%esi
  801c93:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801c9a:	00 00 00 
  801c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca2:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801ca9:	00 00 00 
  801cac:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801cae:	c9                   	leaveq 
  801caf:	c3                   	retq   

0000000000801cb0 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	48 83 ec 20          	sub    $0x20,%rsp
  801cb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cbb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801cbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cc5:	01 00 00 
  801cc8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ccb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ccf:	25 07 0e 00 00       	and    $0xe07,%eax
  801cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801cd7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801cda:	48 c1 e0 0c          	shl    $0xc,%rax
  801cde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce5:	25 00 04 00 00       	and    $0x400,%eax
  801cea:	85 c0                	test   %eax,%eax
  801cec:	74 57                	je     801d45 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801cee:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cf1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cf5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cfc:	41 89 f0             	mov    %esi,%r8d
  801cff:	48 89 c6             	mov    %rax,%rsi
  801d02:	bf 00 00 00 00       	mov    $0x0,%edi
  801d07:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 8e 52 01 00 00    	jle    801e6d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801d1b:	48 ba 2a 43 80 00 00 	movabs $0x80432a,%rdx
  801d22:	00 00 00 
  801d25:	be 4e 00 00 00       	mov    $0x4e,%esi
  801d2a:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801d31:	00 00 00 
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801d40:	00 00 00 
  801d43:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d48:	83 e0 02             	and    $0x2,%eax
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	75 10                	jne    801d5f <duppage+0xaf>
  801d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d52:	25 00 08 00 00       	and    $0x800,%eax
  801d57:	85 c0                	test   %eax,%eax
  801d59:	0f 84 bb 00 00 00    	je     801e1a <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d62:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801d67:	80 cc 08             	or     $0x8,%ah
  801d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801d6d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d70:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d74:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7b:	41 89 f0             	mov    %esi,%r8d
  801d7e:	48 89 c6             	mov    %rax,%rsi
  801d81:	bf 00 00 00 00       	mov    $0x0,%edi
  801d86:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
  801d92:	85 c0                	test   %eax,%eax
  801d94:	7e 2a                	jle    801dc0 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801d96:	48 ba 2a 43 80 00 00 	movabs $0x80432a,%rdx
  801d9d:	00 00 00 
  801da0:	be 55 00 00 00       	mov    $0x55,%esi
  801da5:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801dac:	00 00 00 
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
  801db4:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801dbb:	00 00 00 
  801dbe:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801dc0:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801dc3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dcb:	41 89 c8             	mov    %ecx,%r8d
  801dce:	48 89 d1             	mov    %rdx,%rcx
  801dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd6:	48 89 c6             	mov    %rax,%rsi
  801dd9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dde:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801de5:	00 00 00 
  801de8:	ff d0                	callq  *%rax
  801dea:	85 c0                	test   %eax,%eax
  801dec:	7e 2a                	jle    801e18 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801dee:	48 ba 2a 43 80 00 00 	movabs $0x80432a,%rdx
  801df5:	00 00 00 
  801df8:	be 57 00 00 00       	mov    $0x57,%esi
  801dfd:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801e04:	00 00 00 
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801e13:	00 00 00 
  801e16:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801e18:	eb 53                	jmp    801e6d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e1a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e1d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e21:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e28:	41 89 f0             	mov    %esi,%r8d
  801e2b:	48 89 c6             	mov    %rax,%rsi
  801e2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e33:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  801e3a:	00 00 00 
  801e3d:	ff d0                	callq  *%rax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	7e 2a                	jle    801e6d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e43:	48 ba 2a 43 80 00 00 	movabs $0x80432a,%rdx
  801e4a:	00 00 00 
  801e4d:	be 5b 00 00 00       	mov    $0x5b,%esi
  801e52:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801e59:	00 00 00 
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  801e68:	00 00 00 
  801e6b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e72:	c9                   	leaveq 
  801e73:	c3                   	retq   

0000000000801e74 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 18          	sub    $0x18,%rsp
  801e7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e84:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  801e88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e8c:	48 c1 e8 27          	shr    $0x27,%rax
  801e90:	48 89 c2             	mov    %rax,%rdx
  801e93:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801e9a:	01 00 00 
  801e9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea1:	83 e0 01             	and    $0x1,%eax
  801ea4:	48 85 c0             	test   %rax,%rax
  801ea7:	74 51                	je     801efa <pt_is_mapped+0x86>
  801ea9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ead:	48 c1 e0 0c          	shl    $0xc,%rax
  801eb1:	48 c1 e8 1e          	shr    $0x1e,%rax
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ebf:	01 00 00 
  801ec2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ec6:	83 e0 01             	and    $0x1,%eax
  801ec9:	48 85 c0             	test   %rax,%rax
  801ecc:	74 2c                	je     801efa <pt_is_mapped+0x86>
  801ece:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed2:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed6:	48 c1 e8 15          	shr    $0x15,%rax
  801eda:	48 89 c2             	mov    %rax,%rdx
  801edd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee4:	01 00 00 
  801ee7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eeb:	83 e0 01             	and    $0x1,%eax
  801eee:	48 85 c0             	test   %rax,%rax
  801ef1:	74 07                	je     801efa <pt_is_mapped+0x86>
  801ef3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef8:	eb 05                	jmp    801eff <pt_is_mapped+0x8b>
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	83 e0 01             	and    $0x1,%eax
}
  801f02:	c9                   	leaveq 
  801f03:	c3                   	retq   

0000000000801f04 <fork>:

envid_t
fork(void)
{
  801f04:	55                   	push   %rbp
  801f05:	48 89 e5             	mov    %rsp,%rbp
  801f08:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  801f0c:	48 bf 1b 1b 80 00 00 	movabs $0x801b1b,%rdi
  801f13:	00 00 00 
  801f16:	48 b8 58 3b 80 00 00 	movabs $0x803b58,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f22:	b8 07 00 00 00       	mov    $0x7,%eax
  801f27:	cd 30                	int    $0x30
  801f29:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f2c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  801f2f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  801f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f36:	79 30                	jns    801f68 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  801f38:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f3b:	89 c1                	mov    %eax,%ecx
  801f3d:	48 ba 48 43 80 00 00 	movabs $0x804348,%rdx
  801f44:	00 00 00 
  801f47:	be 86 00 00 00       	mov    $0x86,%esi
  801f4c:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  801f53:	00 00 00 
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	49 b8 44 3a 80 00 00 	movabs $0x803a44,%r8
  801f62:	00 00 00 
  801f65:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  801f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f6c:	75 46                	jne    801fb4 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801f6e:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f7f:	48 63 d0             	movslq %eax,%rdx
  801f82:	48 89 d0             	mov    %rdx,%rax
  801f85:	48 c1 e0 03          	shl    $0x3,%rax
  801f89:	48 01 d0             	add    %rdx,%rax
  801f8c:	48 c1 e0 05          	shl    $0x5,%rax
  801f90:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f97:	00 00 00 
  801f9a:	48 01 c2             	add    %rax,%rdx
  801f9d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fa4:	00 00 00 
  801fa7:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	e9 d1 01 00 00       	jmpq   802185 <fork+0x281>
	}
	uint64_t ad = 0;
  801fb4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801fbb:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  801fbc:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  801fc1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fc5:	e9 df 00 00 00       	jmpq   8020a9 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  801fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fce:	48 c1 e8 27          	shr    $0x27,%rax
  801fd2:	48 89 c2             	mov    %rax,%rdx
  801fd5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fdc:	01 00 00 
  801fdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe3:	83 e0 01             	and    $0x1,%eax
  801fe6:	48 85 c0             	test   %rax,%rax
  801fe9:	0f 84 9e 00 00 00    	je     80208d <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  801fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff3:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ff7:	48 89 c2             	mov    %rax,%rdx
  801ffa:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802001:	01 00 00 
  802004:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802008:	83 e0 01             	and    $0x1,%eax
  80200b:	48 85 c0             	test   %rax,%rax
  80200e:	74 73                	je     802083 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802014:	48 c1 e8 15          	shr    $0x15,%rax
  802018:	48 89 c2             	mov    %rax,%rdx
  80201b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802022:	01 00 00 
  802025:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802029:	83 e0 01             	and    $0x1,%eax
  80202c:	48 85 c0             	test   %rax,%rax
  80202f:	74 48                	je     802079 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802035:	48 c1 e8 0c          	shr    $0xc,%rax
  802039:	48 89 c2             	mov    %rax,%rdx
  80203c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802043:	01 00 00 
  802046:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80204e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802052:	83 e0 01             	and    $0x1,%eax
  802055:	48 85 c0             	test   %rax,%rax
  802058:	74 47                	je     8020a1 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80205a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80205e:	48 c1 e8 0c          	shr    $0xc,%rax
  802062:	89 c2                	mov    %eax,%edx
  802064:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802067:	89 d6                	mov    %edx,%esi
  802069:	89 c7                	mov    %eax,%edi
  80206b:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  802072:	00 00 00 
  802075:	ff d0                	callq  *%rax
  802077:	eb 28                	jmp    8020a1 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802079:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802080:	00 
  802081:	eb 1e                	jmp    8020a1 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802083:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80208a:	40 
  80208b:	eb 14                	jmp    8020a1 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80208d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802091:	48 c1 e8 27          	shr    $0x27,%rax
  802095:	48 83 c0 01          	add    $0x1,%rax
  802099:	48 c1 e0 27          	shl    $0x27,%rax
  80209d:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8020a1:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8020a8:	00 
  8020a9:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8020b0:	00 
  8020b1:	0f 87 13 ff ff ff    	ja     801fca <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8020bf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020c4:	89 c7                	mov    %eax,%edi
  8020c6:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8020d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8020da:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8020df:	89 c7                	mov    %eax,%edi
  8020e1:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8020e8:	00 00 00 
  8020eb:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8020ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8020f6:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8020fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802100:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802105:	89 c7                	mov    %eax,%edi
  802107:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  80210e:	00 00 00 
  802111:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802113:	ba 00 10 00 00       	mov    $0x1000,%edx
  802118:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80211d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802122:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  802129:	00 00 00 
  80212c:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80212e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802133:	bf 00 00 00 00       	mov    $0x0,%edi
  802138:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802144:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80214b:	00 00 00 
  80214e:	48 8b 00             	mov    (%rax),%rax
  802151:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802158:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80215b:	48 89 d6             	mov    %rdx,%rsi
  80215e:	89 c7                	mov    %eax,%edi
  802160:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80216c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80216f:	be 02 00 00 00       	mov    $0x2,%esi
  802174:	89 c7                	mov    %eax,%edi
  802176:	48 b8 a3 19 80 00 00 	movabs $0x8019a3,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax

	return envid;
  802182:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802185:	c9                   	leaveq 
  802186:	c3                   	retq   

0000000000802187 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802187:	55                   	push   %rbp
  802188:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80218b:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  802192:	00 00 00 
  802195:	be bf 00 00 00       	mov    $0xbf,%esi
  80219a:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  8021a1:	00 00 00 
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  8021b0:	00 00 00 
  8021b3:	ff d1                	callq  *%rcx

00000000008021b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b5:	55                   	push   %rbp
  8021b6:	48 89 e5             	mov    %rsp,%rbp
  8021b9:	48 83 ec 30          	sub    $0x30,%rsp
  8021bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8021c9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021d0:	00 00 00 
  8021d3:	48 8b 00             	mov    (%rax),%rax
  8021d6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	75 3c                	jne    80221c <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8021e0:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	callq  *%rax
  8021ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021f1:	48 63 d0             	movslq %eax,%rdx
  8021f4:	48 89 d0             	mov    %rdx,%rax
  8021f7:	48 c1 e0 03          	shl    $0x3,%rax
  8021fb:	48 01 d0             	add    %rdx,%rax
  8021fe:	48 c1 e0 05          	shl    $0x5,%rax
  802202:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802209:	00 00 00 
  80220c:	48 01 c2             	add    %rax,%rdx
  80220f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802216:	00 00 00 
  802219:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80221c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802221:	75 0e                	jne    802231 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802223:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80222a:	00 00 00 
  80222d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802231:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802235:	48 89 c7             	mov    %rax,%rdi
  802238:	48 b8 d7 1a 80 00 00 	movabs $0x801ad7,%rax
  80223f:	00 00 00 
  802242:	ff d0                	callq  *%rax
  802244:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224b:	79 19                	jns    802266 <ipc_recv+0xb1>
		*from_env_store = 0;
  80224d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802251:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802264:	eb 53                	jmp    8022b9 <ipc_recv+0x104>
	}
	if(from_env_store)
  802266:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80226b:	74 19                	je     802286 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80226d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802274:	00 00 00 
  802277:	48 8b 00             	mov    (%rax),%rax
  80227a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802284:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802286:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80228b:	74 19                	je     8022a6 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80228d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802294:	00 00 00 
  802297:	48 8b 00             	mov    (%rax),%rax
  80229a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8022a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022ad:	00 00 00 
  8022b0:	48 8b 00             	mov    (%rax),%rax
  8022b3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8022b9:	c9                   	leaveq 
  8022ba:	c3                   	retq   

00000000008022bb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022bb:	55                   	push   %rbp
  8022bc:	48 89 e5             	mov    %rsp,%rbp
  8022bf:	48 83 ec 30          	sub    $0x30,%rsp
  8022c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022c6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022c9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022cd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8022d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022d5:	75 0e                	jne    8022e5 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8022d7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022de:	00 00 00 
  8022e1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8022e5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8022e8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8022eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022f2:	89 c7                	mov    %eax,%edi
  8022f4:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8022fb:	00 00 00 
  8022fe:	ff d0                	callq  *%rax
  802300:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802303:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802307:	75 0c                	jne    802315 <ipc_send+0x5a>
			sys_yield();
  802309:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802315:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802319:	74 ca                	je     8022e5 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80231b:	c9                   	leaveq 
  80231c:	c3                   	retq   

000000000080231d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80231d:	55                   	push   %rbp
  80231e:	48 89 e5             	mov    %rsp,%rbp
  802321:	48 83 ec 14          	sub    $0x14,%rsp
  802325:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80232f:	eb 5e                	jmp    80238f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802331:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802338:	00 00 00 
  80233b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233e:	48 63 d0             	movslq %eax,%rdx
  802341:	48 89 d0             	mov    %rdx,%rax
  802344:	48 c1 e0 03          	shl    $0x3,%rax
  802348:	48 01 d0             	add    %rdx,%rax
  80234b:	48 c1 e0 05          	shl    $0x5,%rax
  80234f:	48 01 c8             	add    %rcx,%rax
  802352:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802358:	8b 00                	mov    (%rax),%eax
  80235a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80235d:	75 2c                	jne    80238b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80235f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802366:	00 00 00 
  802369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236c:	48 63 d0             	movslq %eax,%rdx
  80236f:	48 89 d0             	mov    %rdx,%rax
  802372:	48 c1 e0 03          	shl    $0x3,%rax
  802376:	48 01 d0             	add    %rdx,%rax
  802379:	48 c1 e0 05          	shl    $0x5,%rax
  80237d:	48 01 c8             	add    %rcx,%rax
  802380:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802386:	8b 40 08             	mov    0x8(%rax),%eax
  802389:	eb 12                	jmp    80239d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80238b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80238f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802396:	7e 99                	jle    802331 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239d:	c9                   	leaveq 
  80239e:	c3                   	retq   

000000000080239f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80239f:	55                   	push   %rbp
  8023a0:	48 89 e5             	mov    %rsp,%rbp
  8023a3:	48 83 ec 08          	sub    $0x8,%rsp
  8023a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023af:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023b6:	ff ff ff 
  8023b9:	48 01 d0             	add    %rdx,%rax
  8023bc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023c0:	c9                   	leaveq 
  8023c1:	c3                   	retq   

00000000008023c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023c2:	55                   	push   %rbp
  8023c3:	48 89 e5             	mov    %rsp,%rbp
  8023c6:	48 83 ec 08          	sub    $0x8,%rsp
  8023ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 89 c7             	mov    %rax,%rdi
  8023d5:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
  8023e1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023e7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023eb:	c9                   	leaveq 
  8023ec:	c3                   	retq   

00000000008023ed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	48 83 ec 18          	sub    $0x18,%rsp
  8023f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802400:	eb 6b                	jmp    80246d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	48 98                	cltq   
  802407:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80240d:	48 c1 e0 0c          	shl    $0xc,%rax
  802411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802419:	48 c1 e8 15          	shr    $0x15,%rax
  80241d:	48 89 c2             	mov    %rax,%rdx
  802420:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802427:	01 00 00 
  80242a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242e:	83 e0 01             	and    $0x1,%eax
  802431:	48 85 c0             	test   %rax,%rax
  802434:	74 21                	je     802457 <fd_alloc+0x6a>
  802436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243a:	48 c1 e8 0c          	shr    $0xc,%rax
  80243e:	48 89 c2             	mov    %rax,%rdx
  802441:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802448:	01 00 00 
  80244b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244f:	83 e0 01             	and    $0x1,%eax
  802452:	48 85 c0             	test   %rax,%rax
  802455:	75 12                	jne    802469 <fd_alloc+0x7c>
			*fd_store = fd;
  802457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	eb 1a                	jmp    802483 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802469:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802471:	7e 8f                	jle    802402 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80247e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 20          	sub    $0x20,%rsp
  80248d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802490:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802494:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802498:	78 06                	js     8024a0 <fd_lookup+0x1b>
  80249a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80249e:	7e 07                	jle    8024a7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a5:	eb 6c                	jmp    802513 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024aa:	48 98                	cltq   
  8024ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024be:	48 c1 e8 15          	shr    $0x15,%rax
  8024c2:	48 89 c2             	mov    %rax,%rdx
  8024c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024cc:	01 00 00 
  8024cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d3:	83 e0 01             	and    $0x1,%eax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	74 21                	je     8024fc <fd_lookup+0x77>
  8024db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024df:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e3:	48 89 c2             	mov    %rax,%rdx
  8024e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ed:	01 00 00 
  8024f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f4:	83 e0 01             	and    $0x1,%eax
  8024f7:	48 85 c0             	test   %rax,%rax
  8024fa:	75 07                	jne    802503 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802501:	eb 10                	jmp    802513 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80250b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 30          	sub    $0x30,%rsp
  80251d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802521:	89 f0                	mov    %esi,%eax
  802523:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252a:	48 89 c7             	mov    %rax,%rdi
  80252d:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80253d:	48 89 d6             	mov    %rdx,%rsi
  802540:	89 c7                	mov    %eax,%edi
  802542:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax
  80254e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802551:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802555:	78 0a                	js     802561 <fd_close+0x4c>
	    || fd != fd2)
  802557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80255f:	74 12                	je     802573 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802561:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802565:	74 05                	je     80256c <fd_close+0x57>
  802567:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256a:	eb 05                	jmp    802571 <fd_close+0x5c>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	eb 69                	jmp    8025dc <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802577:	8b 00                	mov    (%rax),%eax
  802579:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80257d:	48 89 d6             	mov    %rdx,%rsi
  802580:	89 c7                	mov    %eax,%edi
  802582:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
  80258e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802591:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802595:	78 2a                	js     8025c1 <fd_close+0xac>
		if (dev->dev_close)
  802597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259b:	48 8b 40 20          	mov    0x20(%rax),%rax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	74 16                	je     8025ba <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b0:	48 89 d7             	mov    %rdx,%rdi
  8025b3:	ff d0                	callq  *%rax
  8025b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b8:	eb 07                	jmp    8025c1 <fd_close+0xac>
		else
			r = 0;
  8025ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c5:	48 89 c6             	mov    %rax,%rsi
  8025c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cd:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
	return r;
  8025d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 20          	sub    $0x20,%rsp
  8025e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f4:	eb 41                	jmp    802637 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025f6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025fd:	00 00 00 
  802600:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802603:	48 63 d2             	movslq %edx,%rdx
  802606:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260a:	8b 00                	mov    (%rax),%eax
  80260c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80260f:	75 22                	jne    802633 <dev_lookup+0x55>
			*dev = devtab[i];
  802611:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802618:	00 00 00 
  80261b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80261e:	48 63 d2             	movslq %edx,%rdx
  802621:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802629:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb 60                	jmp    802693 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802633:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802637:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80263e:	00 00 00 
  802641:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802644:	48 63 d2             	movslq %edx,%rdx
  802647:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264b:	48 85 c0             	test   %rax,%rax
  80264e:	75 a6                	jne    8025f6 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802650:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802657:	00 00 00 
  80265a:	48 8b 00             	mov    (%rax),%rax
  80265d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802663:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802666:	89 c6                	mov    %eax,%esi
  802668:	48 bf 78 43 80 00 00 	movabs $0x804378,%rdi
  80266f:	00 00 00 
  802672:	b8 00 00 00 00       	mov    $0x0,%eax
  802677:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  80267e:	00 00 00 
  802681:	ff d1                	callq  *%rcx
	*dev = 0;
  802683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802687:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80268e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802693:	c9                   	leaveq 
  802694:	c3                   	retq   

0000000000802695 <close>:

int
close(int fdnum)
{
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 20          	sub    $0x20,%rsp
  80269d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a7:	48 89 d6             	mov    %rdx,%rsi
  8026aa:	89 c7                	mov    %eax,%edi
  8026ac:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
  8026b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bf:	79 05                	jns    8026c6 <close+0x31>
		return r;
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	eb 18                	jmp    8026de <close+0x49>
	else
		return fd_close(fd, 1);
  8026c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ca:	be 01 00 00 00       	mov    $0x1,%esi
  8026cf:	48 89 c7             	mov    %rax,%rdi
  8026d2:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
}
  8026de:	c9                   	leaveq 
  8026df:	c3                   	retq   

00000000008026e0 <close_all>:

void
close_all(void)
{
  8026e0:	55                   	push   %rbp
  8026e1:	48 89 e5             	mov    %rsp,%rbp
  8026e4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ef:	eb 15                	jmp    802706 <close_all+0x26>
		close(i);
  8026f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f4:	89 c7                	mov    %eax,%edi
  8026f6:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802702:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802706:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80270a:	7e e5                	jle    8026f1 <close_all+0x11>
		close(i);
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 40          	sub    $0x40,%rsp
  802716:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802719:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80271c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802720:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802723:	48 89 d6             	mov    %rdx,%rsi
  802726:	89 c7                	mov    %eax,%edi
  802728:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
  802734:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802737:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273b:	79 08                	jns    802745 <dup+0x37>
		return r;
  80273d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802740:	e9 70 01 00 00       	jmpq   8028b5 <dup+0x1a7>
	close(newfdnum);
  802745:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802748:	89 c7                	mov    %eax,%edi
  80274a:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802756:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802759:	48 98                	cltq   
  80275b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802761:	48 c1 e0 0c          	shl    $0xc,%rax
  802765:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276d:	48 89 c7             	mov    %rax,%rdi
  802770:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
  80277c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802784:	48 89 c7             	mov    %rax,%rdi
  802787:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  80278e:	00 00 00 
  802791:	ff d0                	callq  *%rax
  802793:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279b:	48 c1 e8 15          	shr    $0x15,%rax
  80279f:	48 89 c2             	mov    %rax,%rdx
  8027a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a9:	01 00 00 
  8027ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b0:	83 e0 01             	and    $0x1,%eax
  8027b3:	48 85 c0             	test   %rax,%rax
  8027b6:	74 73                	je     80282b <dup+0x11d>
  8027b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8027c0:	48 89 c2             	mov    %rax,%rdx
  8027c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ca:	01 00 00 
  8027cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d1:	83 e0 01             	and    $0x1,%eax
  8027d4:	48 85 c0             	test   %rax,%rax
  8027d7:	74 52                	je     80282b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e1:	48 89 c2             	mov    %rax,%rdx
  8027e4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027eb:	01 00 00 
  8027ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	41 89 c8             	mov    %ecx,%r8d
  802804:	48 89 d1             	mov    %rdx,%rcx
  802807:	ba 00 00 00 00       	mov    $0x0,%edx
  80280c:	48 89 c6             	mov    %rax,%rsi
  80280f:	bf 00 00 00 00       	mov    $0x0,%edi
  802814:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	callq  *%rax
  802820:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802823:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802827:	79 02                	jns    80282b <dup+0x11d>
			goto err;
  802829:	eb 57                	jmp    802882 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80282b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282f:	48 c1 e8 0c          	shr    $0xc,%rax
  802833:	48 89 c2             	mov    %rax,%rdx
  802836:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283d:	01 00 00 
  802840:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802844:	25 07 0e 00 00       	and    $0xe07,%eax
  802849:	89 c1                	mov    %eax,%ecx
  80284b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802853:	41 89 c8             	mov    %ecx,%r8d
  802856:	48 89 d1             	mov    %rdx,%rcx
  802859:	ba 00 00 00 00       	mov    $0x0,%edx
  80285e:	48 89 c6             	mov    %rax,%rsi
  802861:	bf 00 00 00 00       	mov    $0x0,%edi
  802866:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
  802872:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802875:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802879:	79 02                	jns    80287d <dup+0x16f>
		goto err;
  80287b:	eb 05                	jmp    802882 <dup+0x174>

	return newfdnum;
  80287d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802880:	eb 33                	jmp    8028b5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 89 c6             	mov    %rax,%rsi
  802889:	bf 00 00 00 00       	mov    $0x0,%edi
  80288e:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80289a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289e:	48 89 c6             	mov    %rax,%rsi
  8028a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a6:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
	return r;
  8028b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b5:	c9                   	leaveq 
  8028b6:	c3                   	retq   

00000000008028b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028b7:	55                   	push   %rbp
  8028b8:	48 89 e5             	mov    %rsp,%rbp
  8028bb:	48 83 ec 40          	sub    $0x40,%rsp
  8028bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ca:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028d1:	48 89 d6             	mov    %rdx,%rsi
  8028d4:	89 c7                	mov    %eax,%edi
  8028d6:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8028dd:	00 00 00 
  8028e0:	ff d0                	callq  *%rax
  8028e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e9:	78 24                	js     80290f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ef:	8b 00                	mov    (%rax),%eax
  8028f1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f5:	48 89 d6             	mov    %rdx,%rsi
  8028f8:	89 c7                	mov    %eax,%edi
  8028fa:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
  802906:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290d:	79 05                	jns    802914 <read+0x5d>
		return r;
  80290f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802912:	eb 76                	jmp    80298a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 40 08             	mov    0x8(%rax),%eax
  80291b:	83 e0 03             	and    $0x3,%eax
  80291e:	83 f8 01             	cmp    $0x1,%eax
  802921:	75 3a                	jne    80295d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802923:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80292a:	00 00 00 
  80292d:	48 8b 00             	mov    (%rax),%rax
  802930:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802936:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802939:	89 c6                	mov    %eax,%esi
  80293b:	48 bf 97 43 80 00 00 	movabs $0x804397,%rdi
  802942:	00 00 00 
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802951:	00 00 00 
  802954:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802956:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80295b:	eb 2d                	jmp    80298a <read+0xd3>
	}
	if (!dev->dev_read)
  80295d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802961:	48 8b 40 10          	mov    0x10(%rax),%rax
  802965:	48 85 c0             	test   %rax,%rax
  802968:	75 07                	jne    802971 <read+0xba>
		return -E_NOT_SUPP;
  80296a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296f:	eb 19                	jmp    80298a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802975:	48 8b 40 10          	mov    0x10(%rax),%rax
  802979:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80297d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802981:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802985:	48 89 cf             	mov    %rcx,%rdi
  802988:	ff d0                	callq  *%rax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 30          	sub    $0x30,%rsp
  802994:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80299f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029a6:	eb 49                	jmp    8029f1 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ab:	48 98                	cltq   
  8029ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029b1:	48 29 c2             	sub    %rax,%rdx
  8029b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b7:	48 63 c8             	movslq %eax,%rcx
  8029ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029be:	48 01 c1             	add    %rax,%rcx
  8029c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c4:	48 89 ce             	mov    %rcx,%rsi
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
  8029d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029dc:	79 05                	jns    8029e3 <readn+0x57>
			return m;
  8029de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e1:	eb 1c                	jmp    8029ff <readn+0x73>
		if (m == 0)
  8029e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029e7:	75 02                	jne    8029eb <readn+0x5f>
			break;
  8029e9:	eb 11                	jmp    8029fc <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ee:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f4:	48 98                	cltq   
  8029f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029fa:	72 ac                	jb     8029a8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029ff:	c9                   	leaveq 
  802a00:	c3                   	retq   

0000000000802a01 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a01:	55                   	push   %rbp
  802a02:	48 89 e5             	mov    %rsp,%rbp
  802a05:	48 83 ec 40          	sub    $0x40,%rsp
  802a09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1b:	48 89 d6             	mov    %rdx,%rsi
  802a1e:	89 c7                	mov    %eax,%edi
  802a20:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802a27:	00 00 00 
  802a2a:	ff d0                	callq  *%rax
  802a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a33:	78 24                	js     802a59 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a39:	8b 00                	mov    (%rax),%eax
  802a3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3f:	48 89 d6             	mov    %rdx,%rsi
  802a42:	89 c7                	mov    %eax,%edi
  802a44:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
  802a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a57:	79 05                	jns    802a5e <write+0x5d>
		return r;
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	eb 75                	jmp    802ad3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a62:	8b 40 08             	mov    0x8(%rax),%eax
  802a65:	83 e0 03             	and    $0x3,%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	75 3a                	jne    802aa6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a6c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a73:	00 00 00 
  802a76:	48 8b 00             	mov    (%rax),%rax
  802a79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a82:	89 c6                	mov    %eax,%esi
  802a84:	48 bf b3 43 80 00 00 	movabs $0x8043b3,%rdi
  802a8b:	00 00 00 
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a93:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802a9a:	00 00 00 
  802a9d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa4:	eb 2d                	jmp    802ad3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aae:	48 85 c0             	test   %rax,%rax
  802ab1:	75 07                	jne    802aba <write+0xb9>
		return -E_NOT_SUPP;
  802ab3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab8:	eb 19                	jmp    802ad3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ac2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ace:	48 89 cf             	mov    %rcx,%rdi
  802ad1:	ff d0                	callq  *%rax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 18          	sub    $0x18,%rsp
  802add:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aea:	48 89 d6             	mov    %rdx,%rsi
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	79 05                	jns    802b09 <seek+0x34>
		return r;
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	eb 0f                	jmp    802b18 <seek+0x43>
	fd->fd_offset = offset;
  802b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b18:	c9                   	leaveq 
  802b19:	c3                   	retq   

0000000000802b1a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b1a:	55                   	push   %rbp
  802b1b:	48 89 e5             	mov    %rsp,%rbp
  802b1e:	48 83 ec 30          	sub    $0x30,%rsp
  802b22:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b25:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b2f:	48 89 d6             	mov    %rdx,%rsi
  802b32:	89 c7                	mov    %eax,%edi
  802b34:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b47:	78 24                	js     802b6d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4d:	8b 00                	mov    (%rax),%eax
  802b4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b53:	48 89 d6             	mov    %rdx,%rsi
  802b56:	89 c7                	mov    %eax,%edi
  802b58:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	79 05                	jns    802b72 <ftruncate+0x58>
		return r;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	eb 72                	jmp    802be4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b76:	8b 40 08             	mov    0x8(%rax),%eax
  802b79:	83 e0 03             	and    $0x3,%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	75 3a                	jne    802bba <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b80:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b87:	00 00 00 
  802b8a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b8d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b93:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b96:	89 c6                	mov    %eax,%esi
  802b98:	48 bf d0 43 80 00 00 	movabs $0x8043d0,%rdi
  802b9f:	00 00 00 
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	48 b9 ca 03 80 00 00 	movabs $0x8003ca,%rcx
  802bae:	00 00 00 
  802bb1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb8:	eb 2a                	jmp    802be4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bc2:	48 85 c0             	test   %rax,%rax
  802bc5:	75 07                	jne    802bce <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bc7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bcc:	eb 16                	jmp    802be4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bda:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bdd:	89 ce                	mov    %ecx,%esi
  802bdf:	48 89 d7             	mov    %rdx,%rdi
  802be2:	ff d0                	callq  *%rax
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
  802bea:	48 83 ec 30          	sub    $0x30,%rsp
  802bee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bfc:	48 89 d6             	mov    %rdx,%rsi
  802bff:	89 c7                	mov    %eax,%edi
  802c01:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c14:	78 24                	js     802c3a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1a:	8b 00                	mov    (%rax),%eax
  802c1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c20:	48 89 d6             	mov    %rdx,%rsi
  802c23:	89 c7                	mov    %eax,%edi
  802c25:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c38:	79 05                	jns    802c3f <fstat+0x59>
		return r;
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	eb 5e                	jmp    802c9d <fstat+0xb7>
	if (!dev->dev_stat)
  802c3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c43:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c47:	48 85 c0             	test   %rax,%rax
  802c4a:	75 07                	jne    802c53 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c51:	eb 4a                	jmp    802c9d <fstat+0xb7>
	stat->st_name[0] = 0;
  802c53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c57:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c5e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c65:	00 00 00 
	stat->st_isdir = 0;
  802c68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c6c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c73:	00 00 00 
	stat->st_dev = dev;
  802c76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c91:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c95:	48 89 ce             	mov    %rcx,%rsi
  802c98:	48 89 d7             	mov    %rdx,%rdi
  802c9b:	ff d0                	callq  *%rax
}
  802c9d:	c9                   	leaveq 
  802c9e:	c3                   	retq   

0000000000802c9f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
  802ca3:	48 83 ec 20          	sub    $0x20,%rsp
  802ca7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	be 00 00 00 00       	mov    $0x0,%esi
  802cb8:	48 89 c7             	mov    %rax,%rdi
  802cbb:	48 b8 8d 2d 80 00 00 	movabs $0x802d8d,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
  802cc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cce:	79 05                	jns    802cd5 <stat+0x36>
		return fd;
  802cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd3:	eb 2f                	jmp    802d04 <stat+0x65>
	r = fstat(fd, stat);
  802cd5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdc:	48 89 d6             	mov    %rdx,%rsi
  802cdf:	89 c7                	mov    %eax,%edi
  802ce1:	48 b8 e6 2b 80 00 00 	movabs $0x802be6,%rax
  802ce8:	00 00 00 
  802ceb:	ff d0                	callq  *%rax
  802ced:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802cf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf3:	89 c7                	mov    %eax,%edi
  802cf5:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
	return r;
  802d01:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d04:	c9                   	leaveq 
  802d05:	c3                   	retq   

0000000000802d06 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d06:	55                   	push   %rbp
  802d07:	48 89 e5             	mov    %rsp,%rbp
  802d0a:	48 83 ec 10          	sub    $0x10,%rsp
  802d0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d15:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d1c:	00 00 00 
  802d1f:	8b 00                	mov    (%rax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	75 1d                	jne    802d42 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d25:	bf 01 00 00 00       	mov    $0x1,%edi
  802d2a:	48 b8 1d 23 80 00 00 	movabs $0x80231d,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d3d:	00 00 00 
  802d40:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d42:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d49:	00 00 00 
  802d4c:	8b 00                	mov    (%rax),%eax
  802d4e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d51:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d56:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d5d:	00 00 00 
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 bb 22 80 00 00 	movabs $0x8022bb,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d72:	ba 00 00 00 00       	mov    $0x0,%edx
  802d77:	48 89 c6             	mov    %rax,%rsi
  802d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7f:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
}
  802d8b:	c9                   	leaveq 
  802d8c:	c3                   	retq   

0000000000802d8d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d8d:	55                   	push   %rbp
  802d8e:	48 89 e5             	mov    %rsp,%rbp
  802d91:	48 83 ec 30          	sub    $0x30,%rsp
  802d95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d99:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802d9c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802da3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802daa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802db1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802db6:	75 08                	jne    802dc0 <open+0x33>
	{
		return r;
  802db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbb:	e9 f2 00 00 00       	jmpq   802eb2 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802dc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dc4:	48 89 c7             	mov    %rax,%rdi
  802dc7:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax
  802dd3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802dd6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802ddd:	7e 0a                	jle    802de9 <open+0x5c>
	{
		return -E_BAD_PATH;
  802ddf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802de4:	e9 c9 00 00 00       	jmpq   802eb2 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802de9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802df0:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802df1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802df5:	48 89 c7             	mov    %rax,%rdi
  802df8:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax
  802e04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e0b:	78 09                	js     802e16 <open+0x89>
  802e0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e11:	48 85 c0             	test   %rax,%rax
  802e14:	75 08                	jne    802e1e <open+0x91>
		{
			return r;
  802e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e19:	e9 94 00 00 00       	jmpq   802eb2 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802e1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e22:	ba 00 04 00 00       	mov    $0x400,%edx
  802e27:	48 89 c6             	mov    %rax,%rsi
  802e2a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e31:	00 00 00 
  802e34:	48 b8 11 10 80 00 00 	movabs $0x801011,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802e40:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e47:	00 00 00 
  802e4a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802e4d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e57:	48 89 c6             	mov    %rax,%rsi
  802e5a:	bf 01 00 00 00       	mov    $0x1,%edi
  802e5f:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
  802e6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e72:	79 2b                	jns    802e9f <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802e74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e78:	be 00 00 00 00       	mov    $0x0,%esi
  802e7d:	48 89 c7             	mov    %rax,%rdi
  802e80:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	callq  *%rax
  802e8c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802e8f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e93:	79 05                	jns    802e9a <open+0x10d>
			{
				return d;
  802e95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e98:	eb 18                	jmp    802eb2 <open+0x125>
			}
			return r;
  802e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9d:	eb 13                	jmp    802eb2 <open+0x125>
		}	
		return fd2num(fd_store);
  802e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea3:	48 89 c7             	mov    %rax,%rdi
  802ea6:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802eb2:	c9                   	leaveq 
  802eb3:	c3                   	retq   

0000000000802eb4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802eb4:	55                   	push   %rbp
  802eb5:	48 89 e5             	mov    %rsp,%rbp
  802eb8:	48 83 ec 10          	sub    $0x10,%rsp
  802ebc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec4:	8b 50 0c             	mov    0xc(%rax),%edx
  802ec7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ece:	00 00 00 
  802ed1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ed3:	be 00 00 00 00       	mov    $0x0,%esi
  802ed8:	bf 06 00 00 00       	mov    $0x6,%edi
  802edd:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802ee4:	00 00 00 
  802ee7:	ff d0                	callq  *%rax
}
  802ee9:	c9                   	leaveq 
  802eea:	c3                   	retq   

0000000000802eeb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802eeb:	55                   	push   %rbp
  802eec:	48 89 e5             	mov    %rsp,%rbp
  802eef:	48 83 ec 30          	sub    $0x30,%rsp
  802ef3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802efb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802f06:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f0b:	74 07                	je     802f14 <devfile_read+0x29>
  802f0d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f12:	75 07                	jne    802f1b <devfile_read+0x30>
		return -E_INVAL;
  802f14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f19:	eb 77                	jmp    802f92 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1f:	8b 50 0c             	mov    0xc(%rax),%edx
  802f22:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f29:	00 00 00 
  802f2c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f2e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f35:	00 00 00 
  802f38:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f3c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802f40:	be 00 00 00 00       	mov    $0x0,%esi
  802f45:	bf 03 00 00 00       	mov    $0x3,%edi
  802f4a:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	7f 05                	jg     802f64 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f62:	eb 2e                	jmp    802f92 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f67:	48 63 d0             	movslq %eax,%rdx
  802f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f6e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f75:	00 00 00 
  802f78:	48 89 c7             	mov    %rax,%rdi
  802f7b:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802f87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f92:	c9                   	leaveq 
  802f93:	c3                   	retq   

0000000000802f94 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f94:	55                   	push   %rbp
  802f95:	48 89 e5             	mov    %rsp,%rbp
  802f98:	48 83 ec 30          	sub    $0x30,%rsp
  802f9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802fa8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802faf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fb4:	74 07                	je     802fbd <devfile_write+0x29>
  802fb6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fbb:	75 08                	jne    802fc5 <devfile_write+0x31>
		return r;
  802fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc0:	e9 9a 00 00 00       	jmpq   80305f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc9:	8b 50 0c             	mov    0xc(%rax),%edx
  802fcc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd3:	00 00 00 
  802fd6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802fd8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802fdf:	00 
  802fe0:	76 08                	jbe    802fea <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802fe2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802fe9:	00 
	}
	fsipcbuf.write.req_n = n;
  802fea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff1:	00 00 00 
  802ff4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ff8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802ffc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803000:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803004:	48 89 c6             	mov    %rax,%rsi
  803007:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80300e:	00 00 00 
  803011:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80301d:	be 00 00 00 00       	mov    $0x0,%esi
  803022:	bf 04 00 00 00       	mov    $0x4,%edi
  803027:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
  803033:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803036:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303a:	7f 20                	jg     80305c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80303c:	48 bf f6 43 80 00 00 	movabs $0x8043f6,%rdi
  803043:	00 00 00 
  803046:	b8 00 00 00 00       	mov    $0x0,%eax
  80304b:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  803052:	00 00 00 
  803055:	ff d2                	callq  *%rdx
		return r;
  803057:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305a:	eb 03                	jmp    80305f <devfile_write+0xcb>
	}
	return r;
  80305c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80305f:	c9                   	leaveq 
  803060:	c3                   	retq   

0000000000803061 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803061:	55                   	push   %rbp
  803062:	48 89 e5             	mov    %rsp,%rbp
  803065:	48 83 ec 20          	sub    $0x20,%rsp
  803069:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80306d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803075:	8b 50 0c             	mov    0xc(%rax),%edx
  803078:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80307f:	00 00 00 
  803082:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803084:	be 00 00 00 00       	mov    $0x0,%esi
  803089:	bf 05 00 00 00       	mov    $0x5,%edi
  80308e:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
  80309a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a1:	79 05                	jns    8030a8 <devfile_stat+0x47>
		return r;
  8030a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a6:	eb 56                	jmp    8030fe <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ac:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030b3:	00 00 00 
  8030b6:	48 89 c7             	mov    %rax,%rdi
  8030b9:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030c5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030cc:	00 00 00 
  8030cf:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030df:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e6:	00 00 00 
  8030e9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030fe:	c9                   	leaveq 
  8030ff:	c3                   	retq   

0000000000803100 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 83 ec 10          	sub    $0x10,%rsp
  803108:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80310c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80310f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803113:	8b 50 0c             	mov    0xc(%rax),%edx
  803116:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80311d:	00 00 00 
  803120:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803122:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803129:	00 00 00 
  80312c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80312f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803132:	be 00 00 00 00       	mov    $0x0,%esi
  803137:	bf 02 00 00 00       	mov    $0x2,%edi
  80313c:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
}
  803148:	c9                   	leaveq 
  803149:	c3                   	retq   

000000000080314a <remove>:

// Delete a file
int
remove(const char *path)
{
  80314a:	55                   	push   %rbp
  80314b:	48 89 e5             	mov    %rsp,%rbp
  80314e:	48 83 ec 10          	sub    $0x10,%rsp
  803152:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80315a:	48 89 c7             	mov    %rax,%rdi
  80315d:	48 b8 13 0f 80 00 00 	movabs $0x800f13,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
  803169:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80316e:	7e 07                	jle    803177 <remove+0x2d>
		return -E_BAD_PATH;
  803170:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803175:	eb 33                	jmp    8031aa <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80317b:	48 89 c6             	mov    %rax,%rsi
  80317e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803185:	00 00 00 
  803188:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  80318f:	00 00 00 
  803192:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803194:	be 00 00 00 00       	mov    $0x0,%esi
  803199:	bf 07 00 00 00       	mov    $0x7,%edi
  80319e:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
}
  8031aa:	c9                   	leaveq 
  8031ab:	c3                   	retq   

00000000008031ac <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031ac:	55                   	push   %rbp
  8031ad:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031b0:	be 00 00 00 00       	mov    $0x0,%esi
  8031b5:	bf 08 00 00 00       	mov    $0x8,%edi
  8031ba:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
}
  8031c6:	5d                   	pop    %rbp
  8031c7:	c3                   	retq   

00000000008031c8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	53                   	push   %rbx
  8031cd:	48 83 ec 38          	sub    $0x38,%rsp
  8031d1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031d5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031d9:	48 89 c7             	mov    %rax,%rdi
  8031dc:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ef:	0f 88 bf 01 00 00    	js     8033b4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8031fe:	48 89 c6             	mov    %rax,%rsi
  803201:	bf 00 00 00 00       	mov    $0x0,%edi
  803206:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803215:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803219:	0f 88 95 01 00 00    	js     8033b4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80321f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803223:	48 89 c7             	mov    %rax,%rdi
  803226:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803235:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803239:	0f 88 5d 01 00 00    	js     80339c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80323f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803243:	ba 07 04 00 00       	mov    $0x407,%edx
  803248:	48 89 c6             	mov    %rax,%rsi
  80324b:	bf 00 00 00 00       	mov    $0x0,%edi
  803250:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803257:	00 00 00 
  80325a:	ff d0                	callq  *%rax
  80325c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80325f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803263:	0f 88 33 01 00 00    	js     80339c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326d:	48 89 c7             	mov    %rax,%rdi
  803270:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803280:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803284:	ba 07 04 00 00       	mov    $0x407,%edx
  803289:	48 89 c6             	mov    %rax,%rsi
  80328c:	bf 00 00 00 00       	mov    $0x0,%edi
  803291:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
  80329d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a4:	79 05                	jns    8032ab <pipe+0xe3>
		goto err2;
  8032a6:	e9 d9 00 00 00       	jmpq   803384 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032af:	48 89 c7             	mov    %rax,%rdi
  8032b2:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	48 89 c2             	mov    %rax,%rdx
  8032c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032cb:	48 89 d1             	mov    %rdx,%rcx
  8032ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8032d3:	48 89 c6             	mov    %rax,%rsi
  8032d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032db:	48 b8 fe 18 80 00 00 	movabs $0x8018fe,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ee:	79 1b                	jns    80330b <pipe+0x143>
		goto err3;
  8032f0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8032f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f5:	48 89 c6             	mov    %rax,%rsi
  8032f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032fd:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	eb 79                	jmp    803384 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80330b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80330f:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803316:	00 00 00 
  803319:	8b 12                	mov    (%rdx),%edx
  80331b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80331d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803321:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803328:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332c:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803333:	00 00 00 
  803336:	8b 12                	mov    (%rdx),%edx
  803338:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80333a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803345:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803349:	48 89 c7             	mov    %rax,%rdi
  80334c:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803353:	00 00 00 
  803356:	ff d0                	callq  *%rax
  803358:	89 c2                	mov    %eax,%edx
  80335a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80335e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803360:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803364:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803368:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336c:	48 89 c7             	mov    %rax,%rdi
  80336f:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
  80337b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80337d:	b8 00 00 00 00       	mov    $0x0,%eax
  803382:	eb 33                	jmp    8033b7 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803384:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803388:	48 89 c6             	mov    %rax,%rsi
  80338b:	bf 00 00 00 00       	mov    $0x0,%edi
  803390:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80339c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a0:	48 89 c6             	mov    %rax,%rsi
  8033a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a8:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8033af:	00 00 00 
  8033b2:	ff d0                	callq  *%rax
    err:
	return r;
  8033b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033b7:	48 83 c4 38          	add    $0x38,%rsp
  8033bb:	5b                   	pop    %rbx
  8033bc:	5d                   	pop    %rbp
  8033bd:	c3                   	retq   

00000000008033be <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033be:	55                   	push   %rbp
  8033bf:	48 89 e5             	mov    %rsp,%rbp
  8033c2:	53                   	push   %rbx
  8033c3:	48 83 ec 28          	sub    $0x28,%rsp
  8033c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033cf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033d6:	00 00 00 
  8033d9:	48 8b 00             	mov    (%rax),%rax
  8033dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e9:	48 89 c7             	mov    %rax,%rdi
  8033ec:	48 b8 98 3c 80 00 00 	movabs $0x803c98,%rax
  8033f3:	00 00 00 
  8033f6:	ff d0                	callq  *%rax
  8033f8:	89 c3                	mov    %eax,%ebx
  8033fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fe:	48 89 c7             	mov    %rax,%rdi
  803401:	48 b8 98 3c 80 00 00 	movabs $0x803c98,%rax
  803408:	00 00 00 
  80340b:	ff d0                	callq  *%rax
  80340d:	39 c3                	cmp    %eax,%ebx
  80340f:	0f 94 c0             	sete   %al
  803412:	0f b6 c0             	movzbl %al,%eax
  803415:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803418:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80341f:	00 00 00 
  803422:	48 8b 00             	mov    (%rax),%rax
  803425:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80342b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80342e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803431:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803434:	75 05                	jne    80343b <_pipeisclosed+0x7d>
			return ret;
  803436:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803439:	eb 4f                	jmp    80348a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80343b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80343e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803441:	74 42                	je     803485 <_pipeisclosed+0xc7>
  803443:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803447:	75 3c                	jne    803485 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803449:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803450:	00 00 00 
  803453:	48 8b 00             	mov    (%rax),%rax
  803456:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80345c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80345f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803462:	89 c6                	mov    %eax,%esi
  803464:	48 bf 17 44 80 00 00 	movabs $0x804417,%rdi
  80346b:	00 00 00 
  80346e:	b8 00 00 00 00       	mov    $0x0,%eax
  803473:	49 b8 ca 03 80 00 00 	movabs $0x8003ca,%r8
  80347a:	00 00 00 
  80347d:	41 ff d0             	callq  *%r8
	}
  803480:	e9 4a ff ff ff       	jmpq   8033cf <_pipeisclosed+0x11>
  803485:	e9 45 ff ff ff       	jmpq   8033cf <_pipeisclosed+0x11>
}
  80348a:	48 83 c4 28          	add    $0x28,%rsp
  80348e:	5b                   	pop    %rbx
  80348f:	5d                   	pop    %rbp
  803490:	c3                   	retq   

0000000000803491 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
  803495:	48 83 ec 30          	sub    $0x30,%rsp
  803499:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80349c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034a3:	48 89 d6             	mov    %rdx,%rsi
  8034a6:	89 c7                	mov    %eax,%edi
  8034a8:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8034af:	00 00 00 
  8034b2:	ff d0                	callq  *%rax
  8034b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bb:	79 05                	jns    8034c2 <pipeisclosed+0x31>
		return r;
  8034bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c0:	eb 31                	jmp    8034f3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c6:	48 89 c7             	mov    %rax,%rdi
  8034c9:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8034d0:	00 00 00 
  8034d3:	ff d0                	callq  *%rax
  8034d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034e1:	48 89 d6             	mov    %rdx,%rsi
  8034e4:	48 89 c7             	mov    %rax,%rdi
  8034e7:	48 b8 be 33 80 00 00 	movabs $0x8033be,%rax
  8034ee:	00 00 00 
  8034f1:	ff d0                	callq  *%rax
}
  8034f3:	c9                   	leaveq 
  8034f4:	c3                   	retq   

00000000008034f5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034f5:	55                   	push   %rbp
  8034f6:	48 89 e5             	mov    %rsp,%rbp
  8034f9:	48 83 ec 40          	sub    $0x40,%rsp
  8034fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803501:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803505:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350d:	48 89 c7             	mov    %rax,%rdi
  803510:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
  80351c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803520:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803524:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803528:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80352f:	00 
  803530:	e9 92 00 00 00       	jmpq   8035c7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803535:	eb 41                	jmp    803578 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803537:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80353c:	74 09                	je     803547 <devpipe_read+0x52>
				return i;
  80353e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803542:	e9 92 00 00 00       	jmpq   8035d9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803547:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354f:	48 89 d6             	mov    %rdx,%rsi
  803552:	48 89 c7             	mov    %rax,%rdi
  803555:	48 b8 be 33 80 00 00 	movabs $0x8033be,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
  803561:	85 c0                	test   %eax,%eax
  803563:	74 07                	je     80356c <devpipe_read+0x77>
				return 0;
  803565:	b8 00 00 00 00       	mov    $0x0,%eax
  80356a:	eb 6d                	jmp    8035d9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80356c:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  803573:	00 00 00 
  803576:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357c:	8b 10                	mov    (%rax),%edx
  80357e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803582:	8b 40 04             	mov    0x4(%rax),%eax
  803585:	39 c2                	cmp    %eax,%edx
  803587:	74 ae                	je     803537 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803591:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803599:	8b 00                	mov    (%rax),%eax
  80359b:	99                   	cltd   
  80359c:	c1 ea 1b             	shr    $0x1b,%edx
  80359f:	01 d0                	add    %edx,%eax
  8035a1:	83 e0 1f             	and    $0x1f,%eax
  8035a4:	29 d0                	sub    %edx,%eax
  8035a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035aa:	48 98                	cltq   
  8035ac:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035b1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b7:	8b 00                	mov    (%rax),%eax
  8035b9:	8d 50 01             	lea    0x1(%rax),%edx
  8035bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035cf:	0f 82 60 ff ff ff    	jb     803535 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035d9:	c9                   	leaveq 
  8035da:	c3                   	retq   

00000000008035db <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035db:	55                   	push   %rbp
  8035dc:	48 89 e5             	mov    %rsp,%rbp
  8035df:	48 83 ec 40          	sub    $0x40,%rsp
  8035e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f3:	48 89 c7             	mov    %rax,%rdi
  8035f6:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
  803602:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803606:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80360a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80360e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803615:	00 
  803616:	e9 8e 00 00 00       	jmpq   8036a9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80361b:	eb 31                	jmp    80364e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80361d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803625:	48 89 d6             	mov    %rdx,%rsi
  803628:	48 89 c7             	mov    %rax,%rdi
  80362b:	48 b8 be 33 80 00 00 	movabs $0x8033be,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	85 c0                	test   %eax,%eax
  803639:	74 07                	je     803642 <devpipe_write+0x67>
				return 0;
  80363b:	b8 00 00 00 00       	mov    $0x0,%eax
  803640:	eb 79                	jmp    8036bb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803642:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80364e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803652:	8b 40 04             	mov    0x4(%rax),%eax
  803655:	48 63 d0             	movslq %eax,%rdx
  803658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365c:	8b 00                	mov    (%rax),%eax
  80365e:	48 98                	cltq   
  803660:	48 83 c0 20          	add    $0x20,%rax
  803664:	48 39 c2             	cmp    %rax,%rdx
  803667:	73 b4                	jae    80361d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366d:	8b 40 04             	mov    0x4(%rax),%eax
  803670:	99                   	cltd   
  803671:	c1 ea 1b             	shr    $0x1b,%edx
  803674:	01 d0                	add    %edx,%eax
  803676:	83 e0 1f             	and    $0x1f,%eax
  803679:	29 d0                	sub    %edx,%eax
  80367b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80367f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803683:	48 01 ca             	add    %rcx,%rdx
  803686:	0f b6 0a             	movzbl (%rdx),%ecx
  803689:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80368d:	48 98                	cltq   
  80368f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803697:	8b 40 04             	mov    0x4(%rax),%eax
  80369a:	8d 50 01             	lea    0x1(%rax),%edx
  80369d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036b1:	0f 82 64 ff ff ff    	jb     80361b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036bb:	c9                   	leaveq 
  8036bc:	c3                   	retq   

00000000008036bd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036bd:	55                   	push   %rbp
  8036be:	48 89 e5             	mov    %rsp,%rbp
  8036c1:	48 83 ec 20          	sub    $0x20,%rsp
  8036c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d1:	48 89 c7             	mov    %rax,%rdi
  8036d4:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
  8036e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e8:	48 be 2a 44 80 00 00 	movabs $0x80442a,%rsi
  8036ef:	00 00 00 
  8036f2:	48 89 c7             	mov    %rax,%rdi
  8036f5:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  8036fc:	00 00 00 
  8036ff:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803705:	8b 50 04             	mov    0x4(%rax),%edx
  803708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370c:	8b 00                	mov    (%rax),%eax
  80370e:	29 c2                	sub    %eax,%edx
  803710:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803714:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80371a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803725:	00 00 00 
	stat->st_dev = &devpipe;
  803728:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372c:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803733:	00 00 00 
  803736:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80373d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803742:	c9                   	leaveq 
  803743:	c3                   	retq   

0000000000803744 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803744:	55                   	push   %rbp
  803745:	48 89 e5             	mov    %rsp,%rbp
  803748:	48 83 ec 10          	sub    $0x10,%rsp
  80374c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803754:	48 89 c6             	mov    %rax,%rsi
  803757:	bf 00 00 00 00       	mov    $0x0,%edi
  80375c:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376c:	48 89 c7             	mov    %rax,%rdi
  80376f:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803776:	00 00 00 
  803779:	ff d0                	callq  *%rax
  80377b:	48 89 c6             	mov    %rax,%rsi
  80377e:	bf 00 00 00 00       	mov    $0x0,%edi
  803783:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
}
  80378f:	c9                   	leaveq 
  803790:	c3                   	retq   

0000000000803791 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 20          	sub    $0x20,%rsp
  803799:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80379c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8037a2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8037a6:	be 01 00 00 00       	mov    $0x1,%esi
  8037ab:	48 89 c7             	mov    %rax,%rdi
  8037ae:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
}
  8037ba:	c9                   	leaveq 
  8037bb:	c3                   	retq   

00000000008037bc <getchar>:

int
getchar(void)
{
  8037bc:	55                   	push   %rbp
  8037bd:	48 89 e5             	mov    %rsp,%rbp
  8037c0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037c4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037c8:	ba 01 00 00 00       	mov    $0x1,%edx
  8037cd:	48 89 c6             	mov    %rax,%rsi
  8037d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d5:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
  8037e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e8:	79 05                	jns    8037ef <getchar+0x33>
		return r;
  8037ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ed:	eb 14                	jmp    803803 <getchar+0x47>
	if (r < 1)
  8037ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f3:	7f 07                	jg     8037fc <getchar+0x40>
		return -E_EOF;
  8037f5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037fa:	eb 07                	jmp    803803 <getchar+0x47>
	return c;
  8037fc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803800:	0f b6 c0             	movzbl %al,%eax
}
  803803:	c9                   	leaveq 
  803804:	c3                   	retq   

0000000000803805 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803805:	55                   	push   %rbp
  803806:	48 89 e5             	mov    %rsp,%rbp
  803809:	48 83 ec 20          	sub    $0x20,%rsp
  80380d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803810:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803814:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803817:	48 89 d6             	mov    %rdx,%rsi
  80381a:	89 c7                	mov    %eax,%edi
  80381c:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  803823:	00 00 00 
  803826:	ff d0                	callq  *%rax
  803828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80382b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382f:	79 05                	jns    803836 <iscons+0x31>
		return r;
  803831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803834:	eb 1a                	jmp    803850 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803836:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383a:	8b 10                	mov    (%rax),%edx
  80383c:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803843:	00 00 00 
  803846:	8b 00                	mov    (%rax),%eax
  803848:	39 c2                	cmp    %eax,%edx
  80384a:	0f 94 c0             	sete   %al
  80384d:	0f b6 c0             	movzbl %al,%eax
}
  803850:	c9                   	leaveq 
  803851:	c3                   	retq   

0000000000803852 <opencons>:

int
opencons(void)
{
  803852:	55                   	push   %rbp
  803853:	48 89 e5             	mov    %rsp,%rbp
  803856:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80385a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80385e:	48 89 c7             	mov    %rax,%rdi
  803861:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803868:	00 00 00 
  80386b:	ff d0                	callq  *%rax
  80386d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803874:	79 05                	jns    80387b <opencons+0x29>
		return r;
  803876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803879:	eb 5b                	jmp    8038d6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80387b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387f:	ba 07 04 00 00       	mov    $0x407,%edx
  803884:	48 89 c6             	mov    %rax,%rsi
  803887:	bf 00 00 00 00       	mov    $0x0,%edi
  80388c:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803893:	00 00 00 
  803896:	ff d0                	callq  *%rax
  803898:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389f:	79 05                	jns    8038a6 <opencons+0x54>
		return r;
  8038a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a4:	eb 30                	jmp    8038d6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8038a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038aa:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8038b1:	00 00 00 
  8038b4:	8b 12                	mov    (%rdx),%edx
  8038b6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c7:	48 89 c7             	mov    %rax,%rdi
  8038ca:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
}
  8038d6:	c9                   	leaveq 
  8038d7:	c3                   	retq   

00000000008038d8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038d8:	55                   	push   %rbp
  8038d9:	48 89 e5             	mov    %rsp,%rbp
  8038dc:	48 83 ec 30          	sub    $0x30,%rsp
  8038e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8038ec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038f1:	75 07                	jne    8038fa <devcons_read+0x22>
		return 0;
  8038f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f8:	eb 4b                	jmp    803945 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038fa:	eb 0c                	jmp    803908 <devcons_read+0x30>
		sys_yield();
  8038fc:	48 b8 70 18 80 00 00 	movabs $0x801870,%rax
  803903:	00 00 00 
  803906:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803908:	48 b8 b0 17 80 00 00 	movabs $0x8017b0,%rax
  80390f:	00 00 00 
  803912:	ff d0                	callq  *%rax
  803914:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803917:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391b:	74 df                	je     8038fc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80391d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803921:	79 05                	jns    803928 <devcons_read+0x50>
		return c;
  803923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803926:	eb 1d                	jmp    803945 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803928:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80392c:	75 07                	jne    803935 <devcons_read+0x5d>
		return 0;
  80392e:	b8 00 00 00 00       	mov    $0x0,%eax
  803933:	eb 10                	jmp    803945 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803938:	89 c2                	mov    %eax,%edx
  80393a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80393e:	88 10                	mov    %dl,(%rax)
	return 1;
  803940:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803945:	c9                   	leaveq 
  803946:	c3                   	retq   

0000000000803947 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803947:	55                   	push   %rbp
  803948:	48 89 e5             	mov    %rsp,%rbp
  80394b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803952:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803959:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803960:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803967:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80396e:	eb 76                	jmp    8039e6 <devcons_write+0x9f>
		m = n - tot;
  803970:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803977:	89 c2                	mov    %eax,%edx
  803979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397c:	29 c2                	sub    %eax,%edx
  80397e:	89 d0                	mov    %edx,%eax
  803980:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803983:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803986:	83 f8 7f             	cmp    $0x7f,%eax
  803989:	76 07                	jbe    803992 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80398b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803992:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803995:	48 63 d0             	movslq %eax,%rdx
  803998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399b:	48 63 c8             	movslq %eax,%rcx
  80399e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8039a5:	48 01 c1             	add    %rax,%rcx
  8039a8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039af:	48 89 ce             	mov    %rcx,%rsi
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 a3 12 80 00 00 	movabs $0x8012a3,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c4:	48 63 d0             	movslq %eax,%rdx
  8039c7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039ce:	48 89 d6             	mov    %rdx,%rsi
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 66 17 80 00 00 	movabs $0x801766,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039e3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e9:	48 98                	cltq   
  8039eb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039f2:	0f 82 78 ff ff ff    	jb     803970 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039fb:	c9                   	leaveq 
  8039fc:	c3                   	retq   

00000000008039fd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039fd:	55                   	push   %rbp
  8039fe:	48 89 e5             	mov    %rsp,%rbp
  803a01:	48 83 ec 08          	sub    $0x8,%rsp
  803a05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0e:	c9                   	leaveq 
  803a0f:	c3                   	retq   

0000000000803a10 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a10:	55                   	push   %rbp
  803a11:	48 89 e5             	mov    %rsp,%rbp
  803a14:	48 83 ec 10          	sub    $0x10,%rsp
  803a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a24:	48 be 36 44 80 00 00 	movabs $0x804436,%rsi
  803a2b:	00 00 00 
  803a2e:	48 89 c7             	mov    %rax,%rdi
  803a31:	48 b8 7f 0f 80 00 00 	movabs $0x800f7f,%rax
  803a38:	00 00 00 
  803a3b:	ff d0                	callq  *%rax
	return 0;
  803a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a42:	c9                   	leaveq 
  803a43:	c3                   	retq   

0000000000803a44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	53                   	push   %rbx
  803a49:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a50:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a57:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a5d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a64:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a6b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a72:	84 c0                	test   %al,%al
  803a74:	74 23                	je     803a99 <_panic+0x55>
  803a76:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a7d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a81:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a85:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a89:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a8d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a91:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a95:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a99:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803aa0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803aa7:	00 00 00 
  803aaa:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803ab1:	00 00 00 
  803ab4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ab8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803abf:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803ac6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803acd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803ad4:	00 00 00 
  803ad7:	48 8b 18             	mov    (%rax),%rbx
  803ada:	48 b8 32 18 80 00 00 	movabs $0x801832,%rax
  803ae1:	00 00 00 
  803ae4:	ff d0                	callq  *%rax
  803ae6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803aec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803af3:	41 89 c8             	mov    %ecx,%r8d
  803af6:	48 89 d1             	mov    %rdx,%rcx
  803af9:	48 89 da             	mov    %rbx,%rdx
  803afc:	89 c6                	mov    %eax,%esi
  803afe:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
  803b05:	00 00 00 
  803b08:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0d:	49 b9 ca 03 80 00 00 	movabs $0x8003ca,%r9
  803b14:	00 00 00 
  803b17:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b1a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803b21:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803b28:	48 89 d6             	mov    %rdx,%rsi
  803b2b:	48 89 c7             	mov    %rax,%rdi
  803b2e:	48 b8 1e 03 80 00 00 	movabs $0x80031e,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
	cprintf("\n");
  803b3a:	48 bf 63 44 80 00 00 	movabs $0x804463,%rdi
  803b41:	00 00 00 
  803b44:	b8 00 00 00 00       	mov    $0x0,%eax
  803b49:	48 ba ca 03 80 00 00 	movabs $0x8003ca,%rdx
  803b50:	00 00 00 
  803b53:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b55:	cc                   	int3   
  803b56:	eb fd                	jmp    803b55 <_panic+0x111>

0000000000803b58 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b58:	55                   	push   %rbp
  803b59:	48 89 e5             	mov    %rsp,%rbp
  803b5c:	48 83 ec 10          	sub    $0x10,%rsp
  803b60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  803b64:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b6b:	00 00 00 
  803b6e:	48 8b 00             	mov    (%rax),%rax
  803b71:	48 85 c0             	test   %rax,%rax
  803b74:	0f 85 84 00 00 00    	jne    803bfe <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  803b7a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b81:	00 00 00 
  803b84:	48 8b 00             	mov    (%rax),%rax
  803b87:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b8d:	ba 07 00 00 00       	mov    $0x7,%edx
  803b92:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b97:	89 c7                	mov    %eax,%edi
  803b99:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  803ba0:	00 00 00 
  803ba3:	ff d0                	callq  *%rax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	79 2a                	jns    803bd3 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  803ba9:	48 ba 68 44 80 00 00 	movabs $0x804468,%rdx
  803bb0:	00 00 00 
  803bb3:	be 23 00 00 00       	mov    $0x23,%esi
  803bb8:	48 bf 8f 44 80 00 00 	movabs $0x80448f,%rdi
  803bbf:	00 00 00 
  803bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bc7:	48 b9 44 3a 80 00 00 	movabs $0x803a44,%rcx
  803bce:	00 00 00 
  803bd1:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  803bd3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bda:	00 00 00 
  803bdd:	48 8b 00             	mov    (%rax),%rax
  803be0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803be6:	48 be 11 3c 80 00 00 	movabs $0x803c11,%rsi
  803bed:	00 00 00 
  803bf0:	89 c7                	mov    %eax,%edi
  803bf2:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  803bfe:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803c05:	00 00 00 
  803c08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c0c:	48 89 10             	mov    %rdx,(%rax)
}
  803c0f:	c9                   	leaveq 
  803c10:	c3                   	retq   

0000000000803c11 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803c11:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803c14:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803c1b:	00 00 00 
	call *%rax
  803c1e:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  803c20:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803c27:	00 
	movq 152(%rsp), %rcx  //Load RSP
  803c28:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  803c2f:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  803c30:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  803c34:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  803c37:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  803c3e:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  803c3f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  803c43:	4c 8b 3c 24          	mov    (%rsp),%r15
  803c47:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803c4c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803c51:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803c56:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803c5b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803c60:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803c65:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803c6a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803c6f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803c74:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803c79:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803c7e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803c83:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803c88:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803c8d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  803c91:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  803c95:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  803c96:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803c97:	c3                   	retq   

0000000000803c98 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c98:	55                   	push   %rbp
  803c99:	48 89 e5             	mov    %rsp,%rbp
  803c9c:	48 83 ec 18          	sub    $0x18,%rsp
  803ca0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca8:	48 c1 e8 15          	shr    $0x15,%rax
  803cac:	48 89 c2             	mov    %rax,%rdx
  803caf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803cb6:	01 00 00 
  803cb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbd:	83 e0 01             	and    $0x1,%eax
  803cc0:	48 85 c0             	test   %rax,%rax
  803cc3:	75 07                	jne    803ccc <pageref+0x34>
		return 0;
  803cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cca:	eb 53                	jmp    803d1f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd0:	48 c1 e8 0c          	shr    $0xc,%rax
  803cd4:	48 89 c2             	mov    %rax,%rdx
  803cd7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cde:	01 00 00 
  803ce1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ce5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ce9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ced:	83 e0 01             	and    $0x1,%eax
  803cf0:	48 85 c0             	test   %rax,%rax
  803cf3:	75 07                	jne    803cfc <pageref+0x64>
		return 0;
  803cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfa:	eb 23                	jmp    803d1f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d00:	48 c1 e8 0c          	shr    $0xc,%rax
  803d04:	48 89 c2             	mov    %rax,%rdx
  803d07:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d0e:	00 00 00 
  803d11:	48 c1 e2 04          	shl    $0x4,%rdx
  803d15:	48 01 d0             	add    %rdx,%rax
  803d18:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d1c:	0f b7 c0             	movzwl %ax,%eax
}
  803d1f:	c9                   	leaveq 
  803d20:	c3                   	retq   
