
obj/user/testpteshare.debug:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba fe 49 80 00 00 	movabs $0x8049fe,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 25 4a 80 00 00 	movabs $0x804a25,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 c0 42 80 00 00 	movabs $0x8042c0,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 2e 4a 80 00 00 	movabs $0x804a2e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 34 4a 80 00 00 	movabs $0x804a34,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 3a 4a 80 00 00 	movabs $0x804a3a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 55 4a 80 00 00 	movabs $0x804a55,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 59 4a 80 00 00 	movabs $0x804a59,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 66 4a 80 00 00 	movabs $0x804a66,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 fe 34 80 00 00 	movabs $0x8034fe,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 78 4a 80 00 00 	movabs $0x804a78,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 c0 42 80 00 00 	movabs $0x8042c0,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 2e 4a 80 00 00 	movabs $0x804a2e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 34 4a 80 00 00 	movabs $0x804a34,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 82 4a 80 00 00 	movabs $0x804a82,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002b7:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c8:	48 63 d0             	movslq %eax,%rdx
  8002cb:	48 89 d0             	mov    %rdx,%rax
  8002ce:	48 c1 e0 03          	shl    $0x3,%rax
  8002d2:	48 01 d0             	add    %rdx,%rax
  8002d5:	48 c1 e0 05          	shl    $0x5,%rax
  8002d9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002e0:	00 00 00 
  8002e3:	48 01 c2             	add    %rax,%rdx
  8002e6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002ed:	00 00 00 
  8002f0:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f7:	7e 14                	jle    80030d <libmain+0x65>
		binaryname = argv[0];
  8002f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fd:	48 8b 10             	mov    (%rax),%rdx
  800300:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800307:	00 00 00 
  80030a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 89 d6             	mov    %rdx,%rsi
  800317:	89 c7                	mov    %eax,%edi
  800319:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800320:	00 00 00 
  800323:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800325:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  80032c:	00 00 00 
  80032f:	ff d0                	callq  *%rax
}
  800331:	c9                   	leaveq 
  800332:	c3                   	retq   

0000000000800333 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800333:	55                   	push   %rbp
  800334:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800337:	48 b8 bb 26 80 00 00 	movabs $0x8026bb,%rax
  80033e:	00 00 00 
  800341:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800343:	bf 00 00 00 00       	mov    $0x0,%edi
  800348:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax

}
  800354:	5d                   	pop    %rbp
  800355:	c3                   	retq   

0000000000800356 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	53                   	push   %rbx
  80035b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800362:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800369:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80036f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800376:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80037d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800384:	84 c0                	test   %al,%al
  800386:	74 23                	je     8003ab <_panic+0x55>
  800388:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80038f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800393:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800397:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80039b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80039f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003a7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003ab:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b9:	00 00 00 
  8003bc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c3:	00 00 00 
  8003c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ca:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003df:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8003e6:	00 00 00 
  8003e9:	48 8b 18             	mov    (%rax),%rbx
  8003ec:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
  8003f8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003fe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800405:	41 89 c8             	mov    %ecx,%r8d
  800408:	48 89 d1             	mov    %rdx,%rcx
  80040b:	48 89 da             	mov    %rbx,%rdx
  80040e:	89 c6                	mov    %eax,%esi
  800410:	48 bf a8 4a 80 00 00 	movabs $0x804aa8,%rdi
  800417:	00 00 00 
  80041a:	b8 00 00 00 00       	mov    $0x0,%eax
  80041f:	49 b9 8f 05 80 00 00 	movabs $0x80058f,%r9
  800426:	00 00 00 
  800429:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80042c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800433:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80043a:	48 89 d6             	mov    %rdx,%rsi
  80043d:	48 89 c7             	mov    %rax,%rdi
  800440:	48 b8 e3 04 80 00 00 	movabs $0x8004e3,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
	cprintf("\n");
  80044c:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  800453:	00 00 00 
  800456:	b8 00 00 00 00       	mov    $0x0,%eax
  80045b:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  800462:	00 00 00 
  800465:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800467:	cc                   	int3   
  800468:	eb fd                	jmp    800467 <_panic+0x111>

000000000080046a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 10          	sub    $0x10,%rsp
  800472:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800475:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047d:	8b 00                	mov    (%rax),%eax
  80047f:	8d 48 01             	lea    0x1(%rax),%ecx
  800482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800486:	89 0a                	mov    %ecx,(%rdx)
  800488:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80048b:	89 d1                	mov    %edx,%ecx
  80048d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800491:	48 98                	cltq   
  800493:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049b:	8b 00                	mov    (%rax),%eax
  80049d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a2:	75 2c                	jne    8004d0 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8004a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a8:	8b 00                	mov    (%rax),%eax
  8004aa:	48 98                	cltq   
  8004ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b0:	48 83 c2 08          	add    $0x8,%rdx
  8004b4:	48 89 c6             	mov    %rax,%rsi
  8004b7:	48 89 d7             	mov    %rdx,%rdi
  8004ba:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  8004c1:	00 00 00 
  8004c4:	ff d0                	callq  *%rax
		b->idx = 0;
  8004c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8004d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d4:	8b 40 04             	mov    0x4(%rax),%eax
  8004d7:	8d 50 01             	lea    0x1(%rax),%edx
  8004da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004de:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e1:	c9                   	leaveq 
  8004e2:	c3                   	retq   

00000000008004e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004e3:	55                   	push   %rbp
  8004e4:	48 89 e5             	mov    %rsp,%rbp
  8004e7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004ee:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004f5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8004fc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800503:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80050a:	48 8b 0a             	mov    (%rdx),%rcx
  80050d:	48 89 08             	mov    %rcx,(%rax)
  800510:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800514:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800518:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80051c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800531:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800534:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80053b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800542:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800549:	48 89 c6             	mov    %rax,%rsi
  80054c:	48 bf 6a 04 80 00 00 	movabs $0x80046a,%rdi
  800553:	00 00 00 
  800556:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800562:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800568:	48 98                	cltq   
  80056a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800571:	48 83 c2 08          	add    $0x8,%rdx
  800575:	48 89 c6             	mov    %rax,%rsi
  800578:	48 89 d7             	mov    %rdx,%rdi
  80057b:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  800582:	00 00 00 
  800585:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800587:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80058d:	c9                   	leaveq 
  80058e:	c3                   	retq   

000000000080058f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80058f:	55                   	push   %rbp
  800590:	48 89 e5             	mov    %rsp,%rbp
  800593:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80059a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005bd:	84 c0                	test   %al,%al
  8005bf:	74 20                	je     8005e1 <cprintf+0x52>
  8005c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8005e8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005ef:	00 00 00 
  8005f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f9:	00 00 00 
  8005fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800600:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800607:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80060e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800615:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80061c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800623:	48 8b 0a             	mov    (%rdx),%rcx
  800626:	48 89 08             	mov    %rcx,(%rax)
  800629:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800631:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800635:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800639:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800640:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800647:	48 89 d6             	mov    %rdx,%rsi
  80064a:	48 89 c7             	mov    %rax,%rdi
  80064d:	48 b8 e3 04 80 00 00 	movabs $0x8004e3,%rax
  800654:	00 00 00 
  800657:	ff d0                	callq  *%rax
  800659:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80065f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800665:	c9                   	leaveq 
  800666:	c3                   	retq   

0000000000800667 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800667:	55                   	push   %rbp
  800668:	48 89 e5             	mov    %rsp,%rbp
  80066b:	53                   	push   %rbx
  80066c:	48 83 ec 38          	sub    $0x38,%rsp
  800670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80067c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80067f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800683:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800687:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80068a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80068e:	77 3b                	ja     8006cb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800690:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800693:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800697:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80069a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a3:	48 f7 f3             	div    %rbx
  8006a6:	48 89 c2             	mov    %rax,%rdx
  8006a9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006ac:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006af:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	41 89 f9             	mov    %edi,%r9d
  8006ba:	48 89 c7             	mov    %rax,%rdi
  8006bd:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	callq  *%rax
  8006c9:	eb 1e                	jmp    8006e9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cb:	eb 12                	jmp    8006df <printnum+0x78>
			putch(padc, putdat);
  8006cd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 89 ce             	mov    %rcx,%rsi
  8006db:	89 d7                	mov    %edx,%edi
  8006dd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006df:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006e7:	7f e4                	jg     8006cd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006e9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	48 f7 f1             	div    %rcx
  8006f8:	48 89 d0             	mov    %rdx,%rax
  8006fb:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  800702:	00 00 00 
  800705:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800709:	0f be d0             	movsbl %al,%edx
  80070c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	48 89 ce             	mov    %rcx,%rsi
  800717:	89 d7                	mov    %edx,%edi
  800719:	ff d0                	callq  *%rax
}
  80071b:	48 83 c4 38          	add    $0x38,%rsp
  80071f:	5b                   	pop    %rbx
  800720:	5d                   	pop    %rbp
  800721:	c3                   	retq   

0000000000800722 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800731:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800735:	7e 52                	jle    800789 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	83 f8 30             	cmp    $0x30,%eax
  800740:	73 24                	jae    800766 <getuint+0x44>
  800742:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800746:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 01 d0             	add    %rdx,%rax
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	8b 12                	mov    (%rdx),%edx
  80075b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	89 0a                	mov    %ecx,(%rdx)
  800764:	eb 17                	jmp    80077d <getuint+0x5b>
  800766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076e:	48 89 d0             	mov    %rdx,%rax
  800771:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800775:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800779:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077d:	48 8b 00             	mov    (%rax),%rax
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800784:	e9 a3 00 00 00       	jmpq   80082c <getuint+0x10a>
	else if (lflag)
  800789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80078d:	74 4f                	je     8007de <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	83 f8 30             	cmp    $0x30,%eax
  800798:	73 24                	jae    8007be <getuint+0x9c>
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a6:	8b 00                	mov    (%rax),%eax
  8007a8:	89 c0                	mov    %eax,%eax
  8007aa:	48 01 d0             	add    %rdx,%rax
  8007ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b1:	8b 12                	mov    (%rdx),%edx
  8007b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	89 0a                	mov    %ecx,(%rdx)
  8007bc:	eb 17                	jmp    8007d5 <getuint+0xb3>
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c6:	48 89 d0             	mov    %rdx,%rax
  8007c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007dc:	eb 4e                	jmp    80082c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 24                	jae    80080d <getuint+0xeb>
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	89 c0                	mov    %eax,%eax
  8007f9:	48 01 d0             	add    %rdx,%rax
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	8b 12                	mov    (%rdx),%edx
  800802:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800805:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800809:	89 0a                	mov    %ecx,(%rdx)
  80080b:	eb 17                	jmp    800824 <getuint+0x102>
  80080d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800811:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800815:	48 89 d0             	mov    %rdx,%rax
  800818:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800820:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800824:	8b 00                	mov    (%rax),%eax
  800826:	89 c0                	mov    %eax,%eax
  800828:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80082c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800830:	c9                   	leaveq 
  800831:	c3                   	retq   

0000000000800832 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800832:	55                   	push   %rbp
  800833:	48 89 e5             	mov    %rsp,%rbp
  800836:	48 83 ec 1c          	sub    $0x1c,%rsp
  80083a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80083e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800841:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800845:	7e 52                	jle    800899 <getint+0x67>
		x=va_arg(*ap, long long);
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	8b 00                	mov    (%rax),%eax
  80084d:	83 f8 30             	cmp    $0x30,%eax
  800850:	73 24                	jae    800876 <getint+0x44>
  800852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800856:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085e:	8b 00                	mov    (%rax),%eax
  800860:	89 c0                	mov    %eax,%eax
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	8b 12                	mov    (%rdx),%edx
  80086b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800872:	89 0a                	mov    %ecx,(%rdx)
  800874:	eb 17                	jmp    80088d <getint+0x5b>
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087e:	48 89 d0             	mov    %rdx,%rax
  800881:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800889:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088d:	48 8b 00             	mov    (%rax),%rax
  800890:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800894:	e9 a3 00 00 00       	jmpq   80093c <getint+0x10a>
	else if (lflag)
  800899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80089d:	74 4f                	je     8008ee <getint+0xbc>
		x=va_arg(*ap, long);
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	83 f8 30             	cmp    $0x30,%eax
  8008a8:	73 24                	jae    8008ce <getint+0x9c>
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	89 c0                	mov    %eax,%eax
  8008ba:	48 01 d0             	add    %rdx,%rax
  8008bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c1:	8b 12                	mov    (%rdx),%edx
  8008c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	89 0a                	mov    %ecx,(%rdx)
  8008cc:	eb 17                	jmp    8008e5 <getint+0xb3>
  8008ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d6:	48 89 d0             	mov    %rdx,%rax
  8008d9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e5:	48 8b 00             	mov    (%rax),%rax
  8008e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ec:	eb 4e                	jmp    80093c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f2:	8b 00                	mov    (%rax),%eax
  8008f4:	83 f8 30             	cmp    $0x30,%eax
  8008f7:	73 24                	jae    80091d <getint+0xeb>
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	89 c0                	mov    %eax,%eax
  800909:	48 01 d0             	add    %rdx,%rax
  80090c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800910:	8b 12                	mov    (%rdx),%edx
  800912:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800915:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800919:	89 0a                	mov    %ecx,(%rdx)
  80091b:	eb 17                	jmp    800934 <getint+0x102>
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800925:	48 89 d0             	mov    %rdx,%rax
  800928:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800930:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800934:	8b 00                	mov    (%rax),%eax
  800936:	48 98                	cltq   
  800938:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80093c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800940:	c9                   	leaveq 
  800941:	c3                   	retq   

0000000000800942 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800942:	55                   	push   %rbp
  800943:	48 89 e5             	mov    %rsp,%rbp
  800946:	41 54                	push   %r12
  800948:	53                   	push   %rbx
  800949:	48 83 ec 60          	sub    $0x60,%rsp
  80094d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800951:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800955:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800959:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80095d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800961:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800965:	48 8b 0a             	mov    (%rdx),%rcx
  800968:	48 89 08             	mov    %rcx,(%rax)
  80096b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80096f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800973:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800977:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097b:	eb 17                	jmp    800994 <vprintfmt+0x52>
			if (ch == '\0')
  80097d:	85 db                	test   %ebx,%ebx
  80097f:	0f 84 cc 04 00 00    	je     800e51 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	89 df                	mov    %ebx,%edi
  800992:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800994:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800998:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80099c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009a0:	0f b6 00             	movzbl (%rax),%eax
  8009a3:	0f b6 d8             	movzbl %al,%ebx
  8009a6:	83 fb 25             	cmp    $0x25,%ebx
  8009a9:	75 d2                	jne    80097d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009af:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009d7:	0f b6 00             	movzbl (%rax),%eax
  8009da:	0f b6 d8             	movzbl %al,%ebx
  8009dd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009e0:	83 f8 55             	cmp    $0x55,%eax
  8009e3:	0f 87 34 04 00 00    	ja     800e1d <vprintfmt+0x4db>
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009f2:	00 
  8009f3:	48 b8 d0 4c 80 00 00 	movabs $0x804cd0,%rax
  8009fa:	00 00 00 
  8009fd:	48 01 d0             	add    %rdx,%rax
  800a00:	48 8b 00             	mov    (%rax),%rax
  800a03:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a05:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a09:	eb c0                	jmp    8009cb <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a0b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a0f:	eb ba                	jmp    8009cb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a11:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a18:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	c1 e0 02             	shl    $0x2,%eax
  800a20:	01 d0                	add    %edx,%eax
  800a22:	01 c0                	add    %eax,%eax
  800a24:	01 d8                	add    %ebx,%eax
  800a26:	83 e8 30             	sub    $0x30,%eax
  800a29:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a2c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a30:	0f b6 00             	movzbl (%rax),%eax
  800a33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a36:	83 fb 2f             	cmp    $0x2f,%ebx
  800a39:	7e 0c                	jle    800a47 <vprintfmt+0x105>
  800a3b:	83 fb 39             	cmp    $0x39,%ebx
  800a3e:	7f 07                	jg     800a47 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a40:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a45:	eb d1                	jmp    800a18 <vprintfmt+0xd6>
			goto process_precision;
  800a47:	eb 58                	jmp    800aa1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4c:	83 f8 30             	cmp    $0x30,%eax
  800a4f:	73 17                	jae    800a68 <vprintfmt+0x126>
  800a51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a58:	89 c0                	mov    %eax,%eax
  800a5a:	48 01 d0             	add    %rdx,%rax
  800a5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a60:	83 c2 08             	add    $0x8,%edx
  800a63:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a66:	eb 0f                	jmp    800a77 <vprintfmt+0x135>
  800a68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6c:	48 89 d0             	mov    %rdx,%rax
  800a6f:	48 83 c2 08          	add    $0x8,%rdx
  800a73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a77:	8b 00                	mov    (%rax),%eax
  800a79:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a7c:	eb 23                	jmp    800aa1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a82:	79 0c                	jns    800a90 <vprintfmt+0x14e>
				width = 0;
  800a84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a8b:	e9 3b ff ff ff       	jmpq   8009cb <vprintfmt+0x89>
  800a90:	e9 36 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a95:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a9c:	e9 2a ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800aa1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aa5:	79 12                	jns    800ab9 <vprintfmt+0x177>
				width = precision, precision = -1;
  800aa7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aaa:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800aad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ab4:	e9 12 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>
  800ab9:	e9 0d ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800abe:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ac2:	e9 04 ff ff ff       	jmpq   8009cb <vprintfmt+0x89>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ac7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aca:	83 f8 30             	cmp    $0x30,%eax
  800acd:	73 17                	jae    800ae6 <vprintfmt+0x1a4>
  800acf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad6:	89 c0                	mov    %eax,%eax
  800ad8:	48 01 d0             	add    %rdx,%rax
  800adb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ade:	83 c2 08             	add    $0x8,%edx
  800ae1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae4:	eb 0f                	jmp    800af5 <vprintfmt+0x1b3>
  800ae6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aea:	48 89 d0             	mov    %rdx,%rax
  800aed:	48 83 c2 08          	add    $0x8,%rdx
  800af1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af5:	8b 10                	mov    (%rax),%edx
  800af7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800afb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aff:	48 89 ce             	mov    %rcx,%rsi
  800b02:	89 d7                	mov    %edx,%edi
  800b04:	ff d0                	callq  *%rax
			break;
  800b06:	e9 40 03 00 00       	jmpq   800e4b <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0e:	83 f8 30             	cmp    $0x30,%eax
  800b11:	73 17                	jae    800b2a <vprintfmt+0x1e8>
  800b13:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b22:	83 c2 08             	add    $0x8,%edx
  800b25:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b28:	eb 0f                	jmp    800b39 <vprintfmt+0x1f7>
  800b2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2e:	48 89 d0             	mov    %rdx,%rax
  800b31:	48 83 c2 08          	add    $0x8,%rdx
  800b35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b39:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b3b:	85 db                	test   %ebx,%ebx
  800b3d:	79 02                	jns    800b41 <vprintfmt+0x1ff>
				err = -err;
  800b3f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b41:	83 fb 10             	cmp    $0x10,%ebx
  800b44:	7f 16                	jg     800b5c <vprintfmt+0x21a>
  800b46:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  800b4d:	00 00 00 
  800b50:	48 63 d3             	movslq %ebx,%rdx
  800b53:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b57:	4d 85 e4             	test   %r12,%r12
  800b5a:	75 2e                	jne    800b8a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	89 d9                	mov    %ebx,%ecx
  800b66:	48 ba b9 4c 80 00 00 	movabs $0x804cb9,%rdx
  800b6d:	00 00 00 
  800b70:	48 89 c7             	mov    %rax,%rdi
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800b7f:	00 00 00 
  800b82:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b85:	e9 c1 02 00 00       	jmpq   800e4b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b92:	4c 89 e1             	mov    %r12,%rcx
  800b95:	48 ba c2 4c 80 00 00 	movabs $0x804cc2,%rdx
  800b9c:	00 00 00 
  800b9f:	48 89 c7             	mov    %rax,%rdi
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba7:	49 b8 5a 0e 80 00 00 	movabs $0x800e5a,%r8
  800bae:	00 00 00 
  800bb1:	41 ff d0             	callq  *%r8
			break;
  800bb4:	e9 92 02 00 00       	jmpq   800e4b <vprintfmt+0x509>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bb9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbc:	83 f8 30             	cmp    $0x30,%eax
  800bbf:	73 17                	jae    800bd8 <vprintfmt+0x296>
  800bc1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc8:	89 c0                	mov    %eax,%eax
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd0:	83 c2 08             	add    $0x8,%edx
  800bd3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd6:	eb 0f                	jmp    800be7 <vprintfmt+0x2a5>
  800bd8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bdc:	48 89 d0             	mov    %rdx,%rax
  800bdf:	48 83 c2 08          	add    $0x8,%rdx
  800be3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be7:	4c 8b 20             	mov    (%rax),%r12
  800bea:	4d 85 e4             	test   %r12,%r12
  800bed:	75 0a                	jne    800bf9 <vprintfmt+0x2b7>
				p = "(null)";
  800bef:	49 bc c5 4c 80 00 00 	movabs $0x804cc5,%r12
  800bf6:	00 00 00 
			if (width > 0 && padc != '-')
  800bf9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfd:	7e 3f                	jle    800c3e <vprintfmt+0x2fc>
  800bff:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c03:	74 39                	je     800c3e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c05:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c08:	48 98                	cltq   
  800c0a:	48 89 c6             	mov    %rax,%rsi
  800c0d:	4c 89 e7             	mov    %r12,%rdi
  800c10:	48 b8 06 11 80 00 00 	movabs $0x801106,%rax
  800c17:	00 00 00 
  800c1a:	ff d0                	callq  *%rax
  800c1c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c1f:	eb 17                	jmp    800c38 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c21:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c25:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2d:	48 89 ce             	mov    %rcx,%rsi
  800c30:	89 d7                	mov    %edx,%edi
  800c32:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3c:	7f e3                	jg     800c21 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3e:	eb 37                	jmp    800c77 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c44:	74 1e                	je     800c64 <vprintfmt+0x322>
  800c46:	83 fb 1f             	cmp    $0x1f,%ebx
  800c49:	7e 05                	jle    800c50 <vprintfmt+0x30e>
  800c4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c4e:	7e 14                	jle    800c64 <vprintfmt+0x322>
					putch('?', putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c60:	ff d0                	callq  *%rax
  800c62:	eb 0f                	jmp    800c73 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6c:	48 89 d6             	mov    %rdx,%rsi
  800c6f:	89 df                	mov    %ebx,%edi
  800c71:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c73:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c77:	4c 89 e0             	mov    %r12,%rax
  800c7a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c7e:	0f b6 00             	movzbl (%rax),%eax
  800c81:	0f be d8             	movsbl %al,%ebx
  800c84:	85 db                	test   %ebx,%ebx
  800c86:	74 10                	je     800c98 <vprintfmt+0x356>
  800c88:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c8c:	78 b2                	js     800c40 <vprintfmt+0x2fe>
  800c8e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c92:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c96:	79 a8                	jns    800c40 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c98:	eb 16                	jmp    800cb0 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca2:	48 89 d6             	mov    %rdx,%rsi
  800ca5:	bf 20 00 00 00       	mov    $0x20,%edi
  800caa:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb4:	7f e4                	jg     800c9a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cb6:	e9 90 01 00 00       	jmpq   800e4b <vprintfmt+0x509>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cbf:	be 03 00 00 00       	mov    $0x3,%esi
  800cc4:	48 89 c7             	mov    %rax,%rdi
  800cc7:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800cce:	00 00 00 
  800cd1:	ff d0                	callq  *%rax
  800cd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cdb:	48 85 c0             	test   %rax,%rax
  800cde:	79 1d                	jns    800cfd <vprintfmt+0x3bb>
				putch('-', putdat);
  800ce0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce8:	48 89 d6             	mov    %rdx,%rsi
  800ceb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf6:	48 f7 d8             	neg    %rax
  800cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cfd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d04:	e9 d5 00 00 00       	jmpq   800dde <vprintfmt+0x49c>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d0d:	be 03 00 00 00       	mov    $0x3,%esi
  800d12:	48 89 c7             	mov    %rax,%rdi
  800d15:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800d1c:	00 00 00 
  800d1f:	ff d0                	callq  *%rax
  800d21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d25:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2c:	e9 ad 00 00 00       	jmpq   800dde <vprintfmt+0x49c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800d31:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800d34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d38:	89 d6                	mov    %edx,%esi
  800d3a:	48 89 c7             	mov    %rax,%rdi
  800d3d:	48 b8 32 08 80 00 00 	movabs $0x800832,%rax
  800d44:	00 00 00 
  800d47:	ff d0                	callq  *%rax
  800d49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d4d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d54:	e9 85 00 00 00       	jmpq   800dde <vprintfmt+0x49c>


		// pointer
		case 'p':
			putch('0', putdat);
  800d59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d61:	48 89 d6             	mov    %rdx,%rsi
  800d64:	bf 30 00 00 00       	mov    $0x30,%edi
  800d69:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d73:	48 89 d6             	mov    %rdx,%rsi
  800d76:	bf 78 00 00 00       	mov    $0x78,%edi
  800d7b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	83 f8 30             	cmp    $0x30,%eax
  800d83:	73 17                	jae    800d9c <vprintfmt+0x45a>
  800d85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8c:	89 c0                	mov    %eax,%eax
  800d8e:	48 01 d0             	add    %rdx,%rax
  800d91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d94:	83 c2 08             	add    $0x8,%edx
  800d97:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d9a:	eb 0f                	jmp    800dab <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da0:	48 89 d0             	mov    %rdx,%rax
  800da3:	48 83 c2 08          	add    $0x8,%rdx
  800da7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dab:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800db2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db9:	eb 23                	jmp    800dde <vprintfmt+0x49c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dbb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbf:	be 03 00 00 00       	mov    $0x3,%esi
  800dc4:	48 89 c7             	mov    %rax,%rdi
  800dc7:	48 b8 22 07 80 00 00 	movabs $0x800722,%rax
  800dce:	00 00 00 
  800dd1:	ff d0                	callq  *%rax
  800dd3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dd7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dde:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800de3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800de6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ded:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df5:	45 89 c1             	mov    %r8d,%r9d
  800df8:	41 89 f8             	mov    %edi,%r8d
  800dfb:	48 89 c7             	mov    %rax,%rdi
  800dfe:	48 b8 67 06 80 00 00 	movabs $0x800667,%rax
  800e05:	00 00 00 
  800e08:	ff d0                	callq  *%rax
			break;
  800e0a:	eb 3f                	jmp    800e4b <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	48 89 d6             	mov    %rdx,%rsi
  800e17:	89 df                	mov    %ebx,%edi
  800e19:	ff d0                	callq  *%rax
			break;
  800e1b:	eb 2e                	jmp    800e4b <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	48 89 d6             	mov    %rdx,%rsi
  800e28:	bf 25 00 00 00       	mov    $0x25,%edi
  800e2d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e2f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e34:	eb 05                	jmp    800e3b <vprintfmt+0x4f9>
  800e36:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e3b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e3f:	48 83 e8 01          	sub    $0x1,%rax
  800e43:	0f b6 00             	movzbl (%rax),%eax
  800e46:	3c 25                	cmp    $0x25,%al
  800e48:	75 ec                	jne    800e36 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e4a:	90                   	nop
		}
	}
  800e4b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4c:	e9 43 fb ff ff       	jmpq   800994 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800e51:	48 83 c4 60          	add    $0x60,%rsp
  800e55:	5b                   	pop    %rbx
  800e56:	41 5c                	pop    %r12
  800e58:	5d                   	pop    %rbp
  800e59:	c3                   	retq   

0000000000800e5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e5a:	55                   	push   %rbp
  800e5b:	48 89 e5             	mov    %rsp,%rbp
  800e5e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e65:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e6c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e73:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e7a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e81:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e88:	84 c0                	test   %al,%al
  800e8a:	74 20                	je     800eac <printfmt+0x52>
  800e8c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e90:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e94:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e98:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e9c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ea0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ea4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eac:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eb3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eba:	00 00 00 
  800ebd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ec4:	00 00 00 
  800ec7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ecb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ed2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ee0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ee7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eee:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ef5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800efc:	48 89 c7             	mov    %rax,%rdi
  800eff:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  800f06:	00 00 00 
  800f09:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f0b:	c9                   	leaveq 
  800f0c:	c3                   	retq   

0000000000800f0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f0d:	55                   	push   %rbp
  800f0e:	48 89 e5             	mov    %rsp,%rbp
  800f11:	48 83 ec 10          	sub    $0x10,%rsp
  800f15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f20:	8b 40 10             	mov    0x10(%rax),%eax
  800f23:	8d 50 01             	lea    0x1(%rax),%edx
  800f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f31:	48 8b 10             	mov    (%rax),%rdx
  800f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f38:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f3c:	48 39 c2             	cmp    %rax,%rdx
  800f3f:	73 17                	jae    800f58 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f45:	48 8b 00             	mov    (%rax),%rax
  800f48:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f50:	48 89 0a             	mov    %rcx,(%rdx)
  800f53:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f56:	88 10                	mov    %dl,(%rax)
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 50          	sub    $0x50,%rsp
  800f62:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f66:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f69:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f6d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f71:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f75:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f79:	48 8b 0a             	mov    (%rdx),%rcx
  800f7c:	48 89 08             	mov    %rcx,(%rax)
  800f7f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f83:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f87:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f8b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f93:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f97:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f9a:	48 98                	cltq   
  800f9c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa4:	48 01 d0             	add    %rdx,%rax
  800fa7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fb2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fb7:	74 06                	je     800fbf <vsnprintf+0x65>
  800fb9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fbd:	7f 07                	jg     800fc6 <vsnprintf+0x6c>
		return -E_INVAL;
  800fbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc4:	eb 2f                	jmp    800ff5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fc6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fca:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fce:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fd2:	48 89 c6             	mov    %rax,%rsi
  800fd5:	48 bf 0d 0f 80 00 00 	movabs $0x800f0d,%rdi
  800fdc:	00 00 00 
  800fdf:	48 b8 42 09 80 00 00 	movabs $0x800942,%rax
  800fe6:	00 00 00 
  800fe9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800feb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fef:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ff2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ff5:	c9                   	leaveq 
  800ff6:	c3                   	retq   

0000000000800ff7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801002:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801009:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80100f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801016:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801024:	84 c0                	test   %al,%al
  801026:	74 20                	je     801048 <snprintf+0x51>
  801028:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80102c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801030:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801034:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801038:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80103c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801040:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801044:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801048:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80104f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801056:	00 00 00 
  801059:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801060:	00 00 00 
  801063:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801067:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80106e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801075:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80107c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801083:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80108a:	48 8b 0a             	mov    (%rdx),%rcx
  80108d:	48 89 08             	mov    %rcx,(%rax)
  801090:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801094:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801098:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80109c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010a0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010a7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010ae:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010b4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010bb:	48 89 c7             	mov    %rax,%rdi
  8010be:	48 b8 5a 0f 80 00 00 	movabs $0x800f5a,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	callq  *%rax
  8010ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010d6:	c9                   	leaveq 
  8010d7:	c3                   	retq   

00000000008010d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d8:	55                   	push   %rbp
  8010d9:	48 89 e5             	mov    %rsp,%rbp
  8010dc:	48 83 ec 18          	sub    $0x18,%rsp
  8010e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010eb:	eb 09                	jmp    8010f6 <strlen+0x1e>
		n++;
  8010ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fa:	0f b6 00             	movzbl (%rax),%eax
  8010fd:	84 c0                	test   %al,%al
  8010ff:	75 ec                	jne    8010ed <strlen+0x15>
		n++;
	return n;
  801101:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801104:	c9                   	leaveq 
  801105:	c3                   	retq   

0000000000801106 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 83 ec 20          	sub    $0x20,%rsp
  80110e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111d:	eb 0e                	jmp    80112d <strnlen+0x27>
		n++;
  80111f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801123:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801128:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80112d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801132:	74 0b                	je     80113f <strnlen+0x39>
  801134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801138:	0f b6 00             	movzbl (%rax),%eax
  80113b:	84 c0                	test   %al,%al
  80113d:	75 e0                	jne    80111f <strnlen+0x19>
		n++;
	return n;
  80113f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801142:	c9                   	leaveq 
  801143:	c3                   	retq   

0000000000801144 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	48 83 ec 20          	sub    $0x20,%rsp
  80114c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801150:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80115c:	90                   	nop
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801165:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801169:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80116d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801171:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801175:	0f b6 12             	movzbl (%rdx),%edx
  801178:	88 10                	mov    %dl,(%rax)
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	84 c0                	test   %al,%al
  80117f:	75 dc                	jne    80115d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801185:	c9                   	leaveq 
  801186:	c3                   	retq   

0000000000801187 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801187:	55                   	push   %rbp
  801188:	48 89 e5             	mov    %rsp,%rbp
  80118b:	48 83 ec 20          	sub    $0x20,%rsp
  80118f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801193:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119b:	48 89 c7             	mov    %rax,%rdi
  80119e:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  8011a5:	00 00 00 
  8011a8:	ff d0                	callq  *%rax
  8011aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b0:	48 63 d0             	movslq %eax,%rdx
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 01 c2             	add    %rax,%rdx
  8011ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011be:	48 89 c6             	mov    %rax,%rsi
  8011c1:	48 89 d7             	mov    %rdx,%rdi
  8011c4:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  8011cb:	00 00 00 
  8011ce:	ff d0                	callq  *%rax
	return dst;
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 28          	sub    $0x28,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011f9:	00 
  8011fa:	eb 2a                	jmp    801226 <strncpy+0x50>
		*dst++ = *src;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120c:	0f b6 12             	movzbl (%rdx),%edx
  80120f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801211:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801215:	0f b6 00             	movzbl (%rax),%eax
  801218:	84 c0                	test   %al,%al
  80121a:	74 05                	je     801221 <strncpy+0x4b>
			src++;
  80121c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801221:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801226:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80122e:	72 cc                	jb     8011fc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801234:	c9                   	leaveq 
  801235:	c3                   	retq   

0000000000801236 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801236:	55                   	push   %rbp
  801237:	48 89 e5             	mov    %rsp,%rbp
  80123a:	48 83 ec 28          	sub    $0x28,%rsp
  80123e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801242:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801246:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801252:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801257:	74 3d                	je     801296 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801259:	eb 1d                	jmp    801278 <strlcpy+0x42>
			*dst++ = *src++;
  80125b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801267:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80126f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801273:	0f b6 12             	movzbl (%rdx),%edx
  801276:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801278:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80127d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801282:	74 0b                	je     80128f <strlcpy+0x59>
  801284:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	84 c0                	test   %al,%al
  80128d:	75 cc                	jne    80125b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801296:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	48 29 c2             	sub    %rax,%rdx
  8012a1:	48 89 d0             	mov    %rdx,%rax
}
  8012a4:	c9                   	leaveq 
  8012a5:	c3                   	retq   

00000000008012a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012a6:	55                   	push   %rbp
  8012a7:	48 89 e5             	mov    %rsp,%rbp
  8012aa:	48 83 ec 10          	sub    $0x10,%rsp
  8012ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012b6:	eb 0a                	jmp    8012c2 <strcmp+0x1c>
		p++, q++;
  8012b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	0f b6 00             	movzbl (%rax),%eax
  8012c9:	84 c0                	test   %al,%al
  8012cb:	74 12                	je     8012df <strcmp+0x39>
  8012cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d1:	0f b6 10             	movzbl (%rax),%edx
  8012d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d8:	0f b6 00             	movzbl (%rax),%eax
  8012db:	38 c2                	cmp    %al,%dl
  8012dd:	74 d9                	je     8012b8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	0f b6 c0             	movzbl %al,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
}
  8012f7:	c9                   	leaveq 
  8012f8:	c3                   	retq   

00000000008012f9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012f9:	55                   	push   %rbp
  8012fa:	48 89 e5             	mov    %rsp,%rbp
  8012fd:	48 83 ec 18          	sub    $0x18,%rsp
  801301:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801305:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80130d:	eb 0f                	jmp    80131e <strncmp+0x25>
		n--, p++, q++;
  80130f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801314:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801319:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80131e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801323:	74 1d                	je     801342 <strncmp+0x49>
  801325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801329:	0f b6 00             	movzbl (%rax),%eax
  80132c:	84 c0                	test   %al,%al
  80132e:	74 12                	je     801342 <strncmp+0x49>
  801330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801334:	0f b6 10             	movzbl (%rax),%edx
  801337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	38 c2                	cmp    %al,%dl
  801340:	74 cd                	je     80130f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801342:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801347:	75 07                	jne    801350 <strncmp+0x57>
		return 0;
  801349:	b8 00 00 00 00       	mov    $0x0,%eax
  80134e:	eb 18                	jmp    801368 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	0f b6 c0             	movzbl %al,%eax
  801364:	29 c2                	sub    %eax,%edx
  801366:	89 d0                	mov    %edx,%eax
}
  801368:	c9                   	leaveq 
  801369:	c3                   	retq   

000000000080136a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136a:	55                   	push   %rbp
  80136b:	48 89 e5             	mov    %rsp,%rbp
  80136e:	48 83 ec 0c          	sub    $0xc,%rsp
  801372:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801376:	89 f0                	mov    %esi,%eax
  801378:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80137b:	eb 17                	jmp    801394 <strchr+0x2a>
		if (*s == c)
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801387:	75 06                	jne    80138f <strchr+0x25>
			return (char *) s;
  801389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138d:	eb 15                	jmp    8013a4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80138f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	84 c0                	test   %al,%al
  80139d:	75 de                	jne    80137d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 0c          	sub    $0xc,%rsp
  8013ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b2:	89 f0                	mov    %esi,%eax
  8013b4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b7:	eb 13                	jmp    8013cc <strfind+0x26>
		if (*s == c)
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c3:	75 02                	jne    8013c7 <strfind+0x21>
			break;
  8013c5:	eb 10                	jmp    8013d7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d0:	0f b6 00             	movzbl (%rax),%eax
  8013d3:	84 c0                	test   %al,%al
  8013d5:	75 e2                	jne    8013b9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 18          	sub    $0x18,%rsp
  8013e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f5:	75 06                	jne    8013fd <memset+0x20>
		return v;
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	eb 69                	jmp    801466 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	83 e0 03             	and    $0x3,%eax
  801404:	48 85 c0             	test   %rax,%rax
  801407:	75 48                	jne    801451 <memset+0x74>
  801409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140d:	83 e0 03             	and    $0x3,%eax
  801410:	48 85 c0             	test   %rax,%rax
  801413:	75 3c                	jne    801451 <memset+0x74>
		c &= 0xFF;
  801415:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80141c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80141f:	c1 e0 18             	shl    $0x18,%eax
  801422:	89 c2                	mov    %eax,%edx
  801424:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801427:	c1 e0 10             	shl    $0x10,%eax
  80142a:	09 c2                	or     %eax,%edx
  80142c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142f:	c1 e0 08             	shl    $0x8,%eax
  801432:	09 d0                	or     %edx,%eax
  801434:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143b:	48 c1 e8 02          	shr    $0x2,%rax
  80143f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801442:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801446:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801449:	48 89 d7             	mov    %rdx,%rdi
  80144c:	fc                   	cld    
  80144d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80144f:	eb 11                	jmp    801462 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801451:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801455:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801458:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80145c:	48 89 d7             	mov    %rdx,%rdi
  80145f:	fc                   	cld    
  801460:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801462:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 28          	sub    $0x28,%rsp
  801470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801478:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80147c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801480:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801488:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801494:	0f 83 88 00 00 00    	jae    801522 <memmove+0xba>
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a2:	48 01 d0             	add    %rdx,%rax
  8014a5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014a9:	76 77                	jbe    801522 <memmove+0xba>
		s += n;
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bf:	83 e0 03             	and    $0x3,%eax
  8014c2:	48 85 c0             	test   %rax,%rax
  8014c5:	75 3b                	jne    801502 <memmove+0x9a>
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	83 e0 03             	and    $0x3,%eax
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 2f                	jne    801502 <memmove+0x9a>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	83 e0 03             	and    $0x3,%eax
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 23                	jne    801502 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e3:	48 83 e8 04          	sub    $0x4,%rax
  8014e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014eb:	48 83 ea 04          	sub    $0x4,%rdx
  8014ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014f7:	48 89 c7             	mov    %rax,%rdi
  8014fa:	48 89 d6             	mov    %rdx,%rsi
  8014fd:	fd                   	std    
  8014fe:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801500:	eb 1d                	jmp    80151f <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801516:	48 89 d7             	mov    %rdx,%rdi
  801519:	48 89 c1             	mov    %rax,%rcx
  80151c:	fd                   	std    
  80151d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80151f:	fc                   	cld    
  801520:	eb 57                	jmp    801579 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	83 e0 03             	and    $0x3,%eax
  801529:	48 85 c0             	test   %rax,%rax
  80152c:	75 36                	jne    801564 <memmove+0xfc>
  80152e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801532:	83 e0 03             	and    $0x3,%eax
  801535:	48 85 c0             	test   %rax,%rax
  801538:	75 2a                	jne    801564 <memmove+0xfc>
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	83 e0 03             	and    $0x3,%eax
  801541:	48 85 c0             	test   %rax,%rax
  801544:	75 1e                	jne    801564 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	48 c1 e8 02          	shr    $0x2,%rax
  80154e:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801555:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801559:	48 89 c7             	mov    %rax,%rdi
  80155c:	48 89 d6             	mov    %rdx,%rsi
  80155f:	fc                   	cld    
  801560:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801562:	eb 15                	jmp    801579 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801568:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801570:	48 89 c7             	mov    %rax,%rdi
  801573:	48 89 d6             	mov    %rdx,%rsi
  801576:	fc                   	cld    
  801577:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157d:	c9                   	leaveq 
  80157e:	c3                   	retq   

000000000080157f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80157f:	55                   	push   %rbp
  801580:	48 89 e5             	mov    %rsp,%rbp
  801583:	48 83 ec 18          	sub    $0x18,%rsp
  801587:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80158f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801597:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	48 89 ce             	mov    %rcx,%rsi
  8015a2:	48 89 c7             	mov    %rax,%rdi
  8015a5:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8015ac:	00 00 00 
  8015af:	ff d0                	callq  *%rax
}
  8015b1:	c9                   	leaveq 
  8015b2:	c3                   	retq   

00000000008015b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015b3:	55                   	push   %rbp
  8015b4:	48 89 e5             	mov    %rsp,%rbp
  8015b7:	48 83 ec 28          	sub    $0x28,%rsp
  8015bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015d7:	eb 36                	jmp    80160f <memcmp+0x5c>
		if (*s1 != *s2)
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	0f b6 10             	movzbl (%rax),%edx
  8015e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e4:	0f b6 00             	movzbl (%rax),%eax
  8015e7:	38 c2                	cmp    %al,%dl
  8015e9:	74 1a                	je     801605 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	0f b6 d0             	movzbl %al,%edx
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	0f b6 c0             	movzbl %al,%eax
  8015ff:	29 c2                	sub    %eax,%edx
  801601:	89 d0                	mov    %edx,%eax
  801603:	eb 20                	jmp    801625 <memcmp+0x72>
		s1++, s2++;
  801605:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801617:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80161b:	48 85 c0             	test   %rax,%rax
  80161e:	75 b9                	jne    8015d9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	c9                   	leaveq 
  801626:	c3                   	retq   

0000000000801627 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	48 83 ec 28          	sub    $0x28,%rsp
  80162f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801633:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801636:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801642:	48 01 d0             	add    %rdx,%rax
  801645:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801649:	eb 15                	jmp    801660 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80164b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80164f:	0f b6 10             	movzbl (%rax),%edx
  801652:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801655:	38 c2                	cmp    %al,%dl
  801657:	75 02                	jne    80165b <memfind+0x34>
			break;
  801659:	eb 0f                	jmp    80166a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80165b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801664:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801668:	72 e1                	jb     80164b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80166e:	c9                   	leaveq 
  80166f:	c3                   	retq   

0000000000801670 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801670:	55                   	push   %rbp
  801671:	48 89 e5             	mov    %rsp,%rbp
  801674:	48 83 ec 34          	sub    $0x34,%rsp
  801678:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80167c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801680:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801683:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80168a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801691:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801692:	eb 05                	jmp    801699 <strtol+0x29>
		s++;
  801694:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801699:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	3c 20                	cmp    $0x20,%al
  8016a2:	74 f0                	je     801694 <strtol+0x24>
  8016a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a8:	0f b6 00             	movzbl (%rax),%eax
  8016ab:	3c 09                	cmp    $0x9,%al
  8016ad:	74 e5                	je     801694 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b3:	0f b6 00             	movzbl (%rax),%eax
  8016b6:	3c 2b                	cmp    $0x2b,%al
  8016b8:	75 07                	jne    8016c1 <strtol+0x51>
		s++;
  8016ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bf:	eb 17                	jmp    8016d8 <strtol+0x68>
	else if (*s == '-')
  8016c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	3c 2d                	cmp    $0x2d,%al
  8016ca:	75 0c                	jne    8016d8 <strtol+0x68>
		s++, neg = 1;
  8016cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016dc:	74 06                	je     8016e4 <strtol+0x74>
  8016de:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016e2:	75 28                	jne    80170c <strtol+0x9c>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 30                	cmp    $0x30,%al
  8016ed:	75 1d                	jne    80170c <strtol+0x9c>
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	48 83 c0 01          	add    $0x1,%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 78                	cmp    $0x78,%al
  8016fc:	75 0e                	jne    80170c <strtol+0x9c>
		s += 2, base = 16;
  8016fe:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801703:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80170a:	eb 2c                	jmp    801738 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80170c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801710:	75 19                	jne    80172b <strtol+0xbb>
  801712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	3c 30                	cmp    $0x30,%al
  80171b:	75 0e                	jne    80172b <strtol+0xbb>
		s++, base = 8;
  80171d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801722:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801729:	eb 0d                	jmp    801738 <strtol+0xc8>
	else if (base == 0)
  80172b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80172f:	75 07                	jne    801738 <strtol+0xc8>
		base = 10;
  801731:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	3c 2f                	cmp    $0x2f,%al
  801741:	7e 1d                	jle    801760 <strtol+0xf0>
  801743:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801747:	0f b6 00             	movzbl (%rax),%eax
  80174a:	3c 39                	cmp    $0x39,%al
  80174c:	7f 12                	jg     801760 <strtol+0xf0>
			dig = *s - '0';
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	0f be c0             	movsbl %al,%eax
  801758:	83 e8 30             	sub    $0x30,%eax
  80175b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80175e:	eb 4e                	jmp    8017ae <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 60                	cmp    $0x60,%al
  801769:	7e 1d                	jle    801788 <strtol+0x118>
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 7a                	cmp    $0x7a,%al
  801774:	7f 12                	jg     801788 <strtol+0x118>
			dig = *s - 'a' + 10;
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	0f be c0             	movsbl %al,%eax
  801780:	83 e8 57             	sub    $0x57,%eax
  801783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801786:	eb 26                	jmp    8017ae <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	0f b6 00             	movzbl (%rax),%eax
  80178f:	3c 40                	cmp    $0x40,%al
  801791:	7e 48                	jle    8017db <strtol+0x16b>
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	3c 5a                	cmp    $0x5a,%al
  80179c:	7f 3d                	jg     8017db <strtol+0x16b>
			dig = *s - 'A' + 10;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	0f be c0             	movsbl %al,%eax
  8017a8:	83 e8 37             	sub    $0x37,%eax
  8017ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017b4:	7c 02                	jl     8017b8 <strtol+0x148>
			break;
  8017b6:	eb 23                	jmp    8017db <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017b8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017c0:	48 98                	cltq   
  8017c2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017c7:	48 89 c2             	mov    %rax,%rdx
  8017ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017cd:	48 98                	cltq   
  8017cf:	48 01 d0             	add    %rdx,%rax
  8017d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017d6:	e9 5d ff ff ff       	jmpq   801738 <strtol+0xc8>

	if (endptr)
  8017db:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017e0:	74 0b                	je     8017ed <strtol+0x17d>
		*endptr = (char *) s;
  8017e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ea:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017f1:	74 09                	je     8017fc <strtol+0x18c>
  8017f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f7:	48 f7 d8             	neg    %rax
  8017fa:	eb 04                	jmp    801800 <strtol+0x190>
  8017fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801800:	c9                   	leaveq 
  801801:	c3                   	retq   

0000000000801802 <strstr>:

char * strstr(const char *in, const char *str)
{
  801802:	55                   	push   %rbp
  801803:	48 89 e5             	mov    %rsp,%rbp
  801806:	48 83 ec 30          	sub    $0x30,%rsp
  80180a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80180e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801816:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80181a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801824:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801828:	75 06                	jne    801830 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	eb 6b                	jmp    80189b <strstr+0x99>

    len = strlen(str);
  801830:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801834:	48 89 c7             	mov    %rax,%rdi
  801837:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  80183e:	00 00 00 
  801841:	ff d0                	callq  *%rax
  801843:	48 98                	cltq   
  801845:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801851:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801855:	0f b6 00             	movzbl (%rax),%eax
  801858:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80185b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80185f:	75 07                	jne    801868 <strstr+0x66>
                return (char *) 0;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
  801866:	eb 33                	jmp    80189b <strstr+0x99>
        } while (sc != c);
  801868:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80186c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80186f:	75 d8                	jne    801849 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801871:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801875:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	48 89 ce             	mov    %rcx,%rsi
  801880:	48 89 c7             	mov    %rax,%rdi
  801883:	48 b8 f9 12 80 00 00 	movabs $0x8012f9,%rax
  80188a:	00 00 00 
  80188d:	ff d0                	callq  *%rax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 b6                	jne    801849 <strstr+0x47>

    return (char *) (in - 1);
  801893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801897:	48 83 e8 01          	sub    $0x1,%rax
}
  80189b:	c9                   	leaveq 
  80189c:	c3                   	retq   

000000000080189d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	53                   	push   %rbx
  8018a2:	48 83 ec 48          	sub    $0x48,%rsp
  8018a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018ac:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018b4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018b8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018bf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018c3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018c7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018cb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018cf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018d3:	4c 89 c3             	mov    %r8,%rbx
  8018d6:	cd 30                	int    $0x30
  8018d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018e0:	74 3e                	je     801920 <syscall+0x83>
  8018e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018e7:	7e 37                	jle    801920 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f0:	49 89 d0             	mov    %rdx,%r8
  8018f3:	89 c1                	mov    %eax,%ecx
  8018f5:	48 ba 80 4f 80 00 00 	movabs $0x804f80,%rdx
  8018fc:	00 00 00 
  8018ff:	be 23 00 00 00       	mov    $0x23,%esi
  801904:	48 bf 9d 4f 80 00 00 	movabs $0x804f9d,%rdi
  80190b:	00 00 00 
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	49 b9 56 03 80 00 00 	movabs $0x800356,%r9
  80191a:	00 00 00 
  80191d:	41 ff d1             	callq  *%r9

	return ret;
  801920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801924:	48 83 c4 48          	add    $0x48,%rsp
  801928:	5b                   	pop    %rbx
  801929:	5d                   	pop    %rbp
  80192a:	c3                   	retq   

000000000080192b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80192b:	55                   	push   %rbp
  80192c:	48 89 e5             	mov    %rsp,%rbp
  80192f:	48 83 ec 20          	sub    $0x20,%rsp
  801933:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801937:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80193b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801943:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194a:	00 
  80194b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801951:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801957:	48 89 d1             	mov    %rdx,%rcx
  80195a:	48 89 c2             	mov    %rax,%rdx
  80195d:	be 00 00 00 00       	mov    $0x0,%esi
  801962:	bf 00 00 00 00       	mov    $0x0,%edi
  801967:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  80196e:	00 00 00 
  801971:	ff d0                	callq  *%rax
}
  801973:	c9                   	leaveq 
  801974:	c3                   	retq   

0000000000801975 <sys_cgetc>:

int
sys_cgetc(void)
{
  801975:	55                   	push   %rbp
  801976:	48 89 e5             	mov    %rsp,%rbp
  801979:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80197d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801984:	00 
  801985:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801991:	b9 00 00 00 00       	mov    $0x0,%ecx
  801996:	ba 00 00 00 00       	mov    $0x0,%edx
  80199b:	be 00 00 00 00       	mov    $0x0,%esi
  8019a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8019a5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  8019ac:	00 00 00 
  8019af:	ff d0                	callq  *%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 10          	sub    $0x10,%rsp
  8019bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c1:	48 98                	cltq   
  8019c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ca:	00 
  8019cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dc:	48 89 c2             	mov    %rax,%rdx
  8019df:	be 01 00 00 00       	mov    $0x1,%esi
  8019e4:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e9:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	callq  *%rax
}
  8019f5:	c9                   	leaveq 
  8019f6:	c3                   	retq   

00000000008019f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a06:	00 
  801a07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a18:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1d:	be 00 00 00 00       	mov    $0x0,%esi
  801a22:	bf 02 00 00 00       	mov    $0x2,%edi
  801a27:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801a2e:	00 00 00 
  801a31:	ff d0                	callq  *%rax
}
  801a33:	c9                   	leaveq 
  801a34:	c3                   	retq   

0000000000801a35 <sys_yield>:

void
sys_yield(void)
{
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a44:	00 
  801a45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a51:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	be 00 00 00 00       	mov    $0x0,%esi
  801a60:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a65:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	callq  *%rax
}
  801a71:	c9                   	leaveq 
  801a72:	c3                   	retq   

0000000000801a73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a73:	55                   	push   %rbp
  801a74:	48 89 e5             	mov    %rsp,%rbp
  801a77:	48 83 ec 20          	sub    $0x20,%rsp
  801a7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a82:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a88:	48 63 c8             	movslq %eax,%rcx
  801a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a92:	48 98                	cltq   
  801a94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9b:	00 
  801a9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa2:	49 89 c8             	mov    %rcx,%r8
  801aa5:	48 89 d1             	mov    %rdx,%rcx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 01 00 00 00       	mov    $0x1,%esi
  801ab0:	bf 04 00 00 00       	mov    $0x4,%edi
  801ab5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 30          	sub    $0x30,%rsp
  801acb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ace:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ad2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ad5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801add:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ae0:	48 63 c8             	movslq %eax,%rcx
  801ae3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ae7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aea:	48 63 f0             	movslq %eax,%rsi
  801aed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af4:	48 98                	cltq   
  801af6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801afa:	49 89 f9             	mov    %rdi,%r9
  801afd:	49 89 f0             	mov    %rsi,%r8
  801b00:	48 89 d1             	mov    %rdx,%rcx
  801b03:	48 89 c2             	mov    %rax,%rdx
  801b06:	be 01 00 00 00       	mov    $0x1,%esi
  801b0b:	bf 05 00 00 00       	mov    $0x5,%edi
  801b10:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801b17:	00 00 00 
  801b1a:	ff d0                	callq  *%rax
}
  801b1c:	c9                   	leaveq 
  801b1d:	c3                   	retq   

0000000000801b1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b1e:	55                   	push   %rbp
  801b1f:	48 89 e5             	mov    %rsp,%rbp
  801b22:	48 83 ec 20          	sub    $0x20,%rsp
  801b26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b34:	48 98                	cltq   
  801b36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3d:	00 
  801b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4a:	48 89 d1             	mov    %rdx,%rcx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 06 00 00 00       	mov    $0x6,%edi
  801b5a:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 10          	sub    $0x10,%rsp
  801b70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b73:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b79:	48 63 d0             	movslq %eax,%rdx
  801b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7f:	48 98                	cltq   
  801b81:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b88:	00 
  801b89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b95:	48 89 d1             	mov    %rdx,%rcx
  801b98:	48 89 c2             	mov    %rax,%rdx
  801b9b:	be 01 00 00 00       	mov    $0x1,%esi
  801ba0:	bf 08 00 00 00       	mov    $0x8,%edi
  801ba5:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801bac:	00 00 00 
  801baf:	ff d0                	callq  *%rax
}
  801bb1:	c9                   	leaveq 
  801bb2:	c3                   	retq   

0000000000801bb3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bb3:	55                   	push   %rbp
  801bb4:	48 89 e5             	mov    %rsp,%rbp
  801bb7:	48 83 ec 20          	sub    $0x20,%rsp
  801bbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc9:	48 98                	cltq   
  801bcb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd2:	00 
  801bd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdf:	48 89 d1             	mov    %rdx,%rcx
  801be2:	48 89 c2             	mov    %rax,%rdx
  801be5:	be 01 00 00 00       	mov    $0x1,%esi
  801bea:	bf 09 00 00 00       	mov    $0x9,%edi
  801bef:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801bf6:	00 00 00 
  801bf9:	ff d0                	callq  *%rax
}
  801bfb:	c9                   	leaveq 
  801bfc:	c3                   	retq   

0000000000801bfd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bfd:	55                   	push   %rbp
  801bfe:	48 89 e5             	mov    %rsp,%rbp
  801c01:	48 83 ec 20          	sub    $0x20,%rsp
  801c05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c13:	48 98                	cltq   
  801c15:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1c:	00 
  801c1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c29:	48 89 d1             	mov    %rdx,%rcx
  801c2c:	48 89 c2             	mov    %rax,%rdx
  801c2f:	be 01 00 00 00       	mov    $0x1,%esi
  801c34:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c39:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	callq  *%rax
}
  801c45:	c9                   	leaveq 
  801c46:	c3                   	retq   

0000000000801c47 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c47:	55                   	push   %rbp
  801c48:	48 89 e5             	mov    %rsp,%rbp
  801c4b:	48 83 ec 20          	sub    $0x20,%rsp
  801c4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c56:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c5a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c60:	48 63 f0             	movslq %eax,%rsi
  801c63:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6a:	48 98                	cltq   
  801c6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c77:	00 
  801c78:	49 89 f1             	mov    %rsi,%r9
  801c7b:	49 89 c8             	mov    %rcx,%r8
  801c7e:	48 89 d1             	mov    %rdx,%rcx
  801c81:	48 89 c2             	mov    %rax,%rdx
  801c84:	be 00 00 00 00       	mov    $0x0,%esi
  801c89:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c8e:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
}
  801c9a:	c9                   	leaveq 
  801c9b:	c3                   	retq   

0000000000801c9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c9c:	55                   	push   %rbp
  801c9d:	48 89 e5             	mov    %rsp,%rbp
  801ca0:	48 83 ec 10          	sub    $0x10,%rsp
  801ca4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb3:	00 
  801cb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc5:	48 89 c2             	mov    %rax,%rdx
  801cc8:	be 01 00 00 00       	mov    $0x1,%esi
  801ccd:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cd2:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 30          	sub    $0x30,%rsp
  801ce8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf0:	48 8b 00             	mov    (%rax),%rax
  801cf3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cff:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801d02:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d05:	83 e0 02             	and    $0x2,%eax
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	75 4d                	jne    801d59 <pgfault+0x79>
  801d0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d10:	48 c1 e8 0c          	shr    $0xc,%rax
  801d14:	48 89 c2             	mov    %rax,%rdx
  801d17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d1e:	01 00 00 
  801d21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d25:	25 00 08 00 00       	and    $0x800,%eax
  801d2a:	48 85 c0             	test   %rax,%rax
  801d2d:	74 2a                	je     801d59 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801d2f:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  801d36:	00 00 00 
  801d39:	be 23 00 00 00       	mov    $0x23,%esi
  801d3e:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801d45:	00 00 00 
  801d48:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4d:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801d54:	00 00 00 
  801d57:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d59:	ba 07 00 00 00       	mov    $0x7,%edx
  801d5e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d63:	bf 00 00 00 00       	mov    $0x0,%edi
  801d68:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	callq  *%rax
  801d74:	85 c0                	test   %eax,%eax
  801d76:	0f 85 cd 00 00 00    	jne    801e49 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d88:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d8e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d96:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d9b:	48 89 c6             	mov    %rax,%rsi
  801d9e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801da3:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  801daa:	00 00 00 
  801dad:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801daf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801db9:	48 89 c1             	mov    %rax,%rcx
  801dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcb:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	79 2a                	jns    801e05 <pgfault+0x125>
				panic("Page map at temp address failed");
  801ddb:	48 ba f0 4f 80 00 00 	movabs $0x804ff0,%rdx
  801de2:	00 00 00 
  801de5:	be 30 00 00 00       	mov    $0x30,%esi
  801dea:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801df1:	00 00 00 
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801e00:	00 00 00 
  801e03:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801e05:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0f:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
  801e1b:	85 c0                	test   %eax,%eax
  801e1d:	79 54                	jns    801e73 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801e1f:	48 ba 10 50 80 00 00 	movabs $0x805010,%rdx
  801e26:	00 00 00 
  801e29:	be 32 00 00 00       	mov    $0x32,%esi
  801e2e:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801e35:	00 00 00 
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801e44:	00 00 00 
  801e47:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801e49:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  801e50:	00 00 00 
  801e53:	be 34 00 00 00       	mov    $0x34,%esi
  801e58:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801e5f:	00 00 00 
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
  801e67:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801e6e:	00 00 00 
  801e71:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e73:	c9                   	leaveq 
  801e74:	c3                   	retq   

0000000000801e75 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e75:	55                   	push   %rbp
  801e76:	48 89 e5             	mov    %rsp,%rbp
  801e79:	48 83 ec 20          	sub    $0x20,%rsp
  801e7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e80:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e8a:	01 00 00 
  801e8d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e94:	25 07 0e 00 00       	and    $0xe07,%eax
  801e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e9c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e9f:	48 c1 e0 0c          	shl    $0xc,%rax
  801ea3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eaa:	25 00 04 00 00       	and    $0x400,%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	74 57                	je     801f0a <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801eb3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eb6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801eba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec1:	41 89 f0             	mov    %esi,%r8d
  801ec4:	48 89 c6             	mov    %rax,%rsi
  801ec7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecc:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 8e 52 01 00 00    	jle    802032 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801ee0:	48 ba 6a 50 80 00 00 	movabs $0x80506a,%rdx
  801ee7:	00 00 00 
  801eea:	be 4e 00 00 00       	mov    $0x4e,%esi
  801eef:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801ef6:	00 00 00 
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f05:	00 00 00 
  801f08:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0d:	83 e0 02             	and    $0x2,%eax
  801f10:	85 c0                	test   %eax,%eax
  801f12:	75 10                	jne    801f24 <duppage+0xaf>
  801f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f17:	25 00 08 00 00       	and    $0x800,%eax
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	0f 84 bb 00 00 00    	je     801fdf <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801f24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f27:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801f2c:	80 cc 08             	or     $0x8,%ah
  801f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f32:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f35:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f39:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f40:	41 89 f0             	mov    %esi,%r8d
  801f43:	48 89 c6             	mov    %rax,%rsi
  801f46:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4b:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
  801f57:	85 c0                	test   %eax,%eax
  801f59:	7e 2a                	jle    801f85 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f5b:	48 ba 6a 50 80 00 00 	movabs $0x80506a,%rdx
  801f62:	00 00 00 
  801f65:	be 55 00 00 00       	mov    $0x55,%esi
  801f6a:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801f71:	00 00 00 
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
  801f79:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f80:	00 00 00 
  801f83:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f85:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f90:	41 89 c8             	mov    %ecx,%r8d
  801f93:	48 89 d1             	mov    %rdx,%rcx
  801f96:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9b:	48 89 c6             	mov    %rax,%rsi
  801f9e:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa3:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	7e 2a                	jle    801fdd <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801fb3:	48 ba 6a 50 80 00 00 	movabs $0x80506a,%rdx
  801fba:	00 00 00 
  801fbd:	be 57 00 00 00       	mov    $0x57,%esi
  801fc2:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  801fc9:	00 00 00 
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801fd8:	00 00 00 
  801fdb:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801fdd:	eb 53                	jmp    802032 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801fdf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fe2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fe6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fed:	41 89 f0             	mov    %esi,%r8d
  801ff0:	48 89 c6             	mov    %rax,%rsi
  801ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff8:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
  802004:	85 c0                	test   %eax,%eax
  802006:	7e 2a                	jle    802032 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802008:	48 ba 6a 50 80 00 00 	movabs $0x80506a,%rdx
  80200f:	00 00 00 
  802012:	be 5b 00 00 00       	mov    $0x5b,%esi
  802017:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  80201e:	00 00 00 
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  80202d:	00 00 00 
  802030:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 18          	sub    $0x18,%rsp
  802041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802049:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  80204d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802051:	48 c1 e8 27          	shr    $0x27,%rax
  802055:	48 89 c2             	mov    %rax,%rdx
  802058:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80205f:	01 00 00 
  802062:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802066:	83 e0 01             	and    $0x1,%eax
  802069:	48 85 c0             	test   %rax,%rax
  80206c:	74 51                	je     8020bf <pt_is_mapped+0x86>
  80206e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802072:	48 c1 e0 0c          	shl    $0xc,%rax
  802076:	48 c1 e8 1e          	shr    $0x1e,%rax
  80207a:	48 89 c2             	mov    %rax,%rdx
  80207d:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802084:	01 00 00 
  802087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208b:	83 e0 01             	and    $0x1,%eax
  80208e:	48 85 c0             	test   %rax,%rax
  802091:	74 2c                	je     8020bf <pt_is_mapped+0x86>
  802093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802097:	48 c1 e0 0c          	shl    $0xc,%rax
  80209b:	48 c1 e8 15          	shr    $0x15,%rax
  80209f:	48 89 c2             	mov    %rax,%rdx
  8020a2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a9:	01 00 00 
  8020ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b0:	83 e0 01             	and    $0x1,%eax
  8020b3:	48 85 c0             	test   %rax,%rax
  8020b6:	74 07                	je     8020bf <pt_is_mapped+0x86>
  8020b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bd:	eb 05                	jmp    8020c4 <pt_is_mapped+0x8b>
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c4:	83 e0 01             	and    $0x1,%eax
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <fork>:

envid_t
fork(void)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8020d1:	48 bf e0 1c 80 00 00 	movabs $0x801ce0,%rdi
  8020d8:	00 00 00 
  8020db:	48 b8 10 46 80 00 00 	movabs $0x804610,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020e7:	b8 07 00 00 00       	mov    $0x7,%eax
  8020ec:	cd 30                	int    $0x30
  8020ee:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020f1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020fb:	79 30                	jns    80212d <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802100:	89 c1                	mov    %eax,%ecx
  802102:	48 ba 88 50 80 00 00 	movabs $0x805088,%rdx
  802109:	00 00 00 
  80210c:	be 86 00 00 00       	mov    $0x86,%esi
  802111:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  802118:	00 00 00 
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  802127:	00 00 00 
  80212a:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  80212d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802131:	75 46                	jne    802179 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802133:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
  80213f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802144:	48 63 d0             	movslq %eax,%rdx
  802147:	48 89 d0             	mov    %rdx,%rax
  80214a:	48 c1 e0 03          	shl    $0x3,%rax
  80214e:	48 01 d0             	add    %rdx,%rax
  802151:	48 c1 e0 05          	shl    $0x5,%rax
  802155:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80215c:	00 00 00 
  80215f:	48 01 c2             	add    %rax,%rdx
  802162:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802169:	00 00 00 
  80216c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	e9 d1 01 00 00       	jmpq   80234a <fork+0x281>
	}
	uint64_t ad = 0;
  802179:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802180:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802181:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802186:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80218a:	e9 df 00 00 00       	jmpq   80226e <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  80218f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802193:	48 c1 e8 27          	shr    $0x27,%rax
  802197:	48 89 c2             	mov    %rax,%rdx
  80219a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021a1:	01 00 00 
  8021a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a8:	83 e0 01             	and    $0x1,%eax
  8021ab:	48 85 c0             	test   %rax,%rax
  8021ae:	0f 84 9e 00 00 00    	je     802252 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8021b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8021bc:	48 89 c2             	mov    %rax,%rdx
  8021bf:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021c6:	01 00 00 
  8021c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cd:	83 e0 01             	and    $0x1,%eax
  8021d0:	48 85 c0             	test   %rax,%rax
  8021d3:	74 73                	je     802248 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8021d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d9:	48 c1 e8 15          	shr    $0x15,%rax
  8021dd:	48 89 c2             	mov    %rax,%rdx
  8021e0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021e7:	01 00 00 
  8021ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ee:	83 e0 01             	and    $0x1,%eax
  8021f1:	48 85 c0             	test   %rax,%rax
  8021f4:	74 48                	je     80223e <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8021fe:	48 89 c2             	mov    %rax,%rdx
  802201:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802208:	01 00 00 
  80220b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802217:	83 e0 01             	and    $0x1,%eax
  80221a:	48 85 c0             	test   %rax,%rax
  80221d:	74 47                	je     802266 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80221f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802223:	48 c1 e8 0c          	shr    $0xc,%rax
  802227:	89 c2                	mov    %eax,%edx
  802229:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80222c:	89 d6                	mov    %edx,%esi
  80222e:	89 c7                	mov    %eax,%edi
  802230:	48 b8 75 1e 80 00 00 	movabs $0x801e75,%rax
  802237:	00 00 00 
  80223a:	ff d0                	callq  *%rax
  80223c:	eb 28                	jmp    802266 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  80223e:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802245:	00 
  802246:	eb 1e                	jmp    802266 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802248:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80224f:	40 
  802250:	eb 14                	jmp    802266 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802252:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802256:	48 c1 e8 27          	shr    $0x27,%rax
  80225a:	48 83 c0 01          	add    $0x1,%rax
  80225e:	48 c1 e0 27          	shl    $0x27,%rax
  802262:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802266:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80226d:	00 
  80226e:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802275:	00 
  802276:	0f 87 13 ff ff ff    	ja     80218f <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80227c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80227f:	ba 07 00 00 00       	mov    $0x7,%edx
  802284:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802289:	89 c7                	mov    %eax,%edi
  80228b:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80229a:	ba 07 00 00 00       	mov    $0x7,%edx
  80229f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022a4:	89 c7                	mov    %eax,%edi
  8022a6:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  8022ad:	00 00 00 
  8022b0:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8022b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022b5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022bb:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8022c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c5:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022ca:	89 c7                	mov    %eax,%edi
  8022cc:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8022d3:	00 00 00 
  8022d6:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8022d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022dd:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8022e2:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022e7:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022f3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fd:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802304:	00 00 00 
  802307:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802309:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802310:	00 00 00 
  802313:	48 8b 00             	mov    (%rax),%rax
  802316:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80231d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802320:	48 89 d6             	mov    %rdx,%rsi
  802323:	89 c7                	mov    %eax,%edi
  802325:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  80232c:	00 00 00 
  80232f:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802334:	be 02 00 00 00       	mov    $0x2,%esi
  802339:	89 c7                	mov    %eax,%edi
  80233b:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  802342:	00 00 00 
  802345:	ff d0                	callq  *%rax

	return envid;
  802347:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80234a:	c9                   	leaveq 
  80234b:	c3                   	retq   

000000000080234c <sfork>:

	
// Challenge!
int
sfork(void)
{
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802350:	48 ba a0 50 80 00 00 	movabs $0x8050a0,%rdx
  802357:	00 00 00 
  80235a:	be bf 00 00 00       	mov    $0xbf,%esi
  80235f:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  802366:	00 00 00 
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
  80236e:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  802375:	00 00 00 
  802378:	ff d1                	callq  *%rcx

000000000080237a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80237a:	55                   	push   %rbp
  80237b:	48 89 e5             	mov    %rsp,%rbp
  80237e:	48 83 ec 08          	sub    $0x8,%rsp
  802382:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802386:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80238a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802391:	ff ff ff 
  802394:	48 01 d0             	add    %rdx,%rax
  802397:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80239b:	c9                   	leaveq 
  80239c:	c3                   	retq   

000000000080239d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80239d:	55                   	push   %rbp
  80239e:	48 89 e5             	mov    %rsp,%rbp
  8023a1:	48 83 ec 08          	sub    $0x8,%rsp
  8023a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ad:	48 89 c7             	mov    %rax,%rdi
  8023b0:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
  8023bc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023c2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023c6:	c9                   	leaveq 
  8023c7:	c3                   	retq   

00000000008023c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023c8:	55                   	push   %rbp
  8023c9:	48 89 e5             	mov    %rsp,%rbp
  8023cc:	48 83 ec 18          	sub    $0x18,%rsp
  8023d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023db:	eb 6b                	jmp    802448 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e0:	48 98                	cltq   
  8023e2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023e8:	48 c1 e0 0c          	shl    $0xc,%rax
  8023ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f4:	48 c1 e8 15          	shr    $0x15,%rax
  8023f8:	48 89 c2             	mov    %rax,%rdx
  8023fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802402:	01 00 00 
  802405:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802409:	83 e0 01             	and    $0x1,%eax
  80240c:	48 85 c0             	test   %rax,%rax
  80240f:	74 21                	je     802432 <fd_alloc+0x6a>
  802411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802415:	48 c1 e8 0c          	shr    $0xc,%rax
  802419:	48 89 c2             	mov    %rax,%rdx
  80241c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802423:	01 00 00 
  802426:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242a:	83 e0 01             	and    $0x1,%eax
  80242d:	48 85 c0             	test   %rax,%rax
  802430:	75 12                	jne    802444 <fd_alloc+0x7c>
			*fd_store = fd;
  802432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802436:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80243a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
  802442:	eb 1a                	jmp    80245e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802444:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802448:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80244c:	7e 8f                	jle    8023dd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80244e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802452:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802459:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80245e:	c9                   	leaveq 
  80245f:	c3                   	retq   

0000000000802460 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802460:	55                   	push   %rbp
  802461:	48 89 e5             	mov    %rsp,%rbp
  802464:	48 83 ec 20          	sub    $0x20,%rsp
  802468:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80246f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802473:	78 06                	js     80247b <fd_lookup+0x1b>
  802475:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802479:	7e 07                	jle    802482 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80247b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802480:	eb 6c                	jmp    8024ee <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802482:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802485:	48 98                	cltq   
  802487:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80248d:	48 c1 e0 0c          	shl    $0xc,%rax
  802491:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802499:	48 c1 e8 15          	shr    $0x15,%rax
  80249d:	48 89 c2             	mov    %rax,%rdx
  8024a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024a7:	01 00 00 
  8024aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ae:	83 e0 01             	and    $0x1,%eax
  8024b1:	48 85 c0             	test   %rax,%rax
  8024b4:	74 21                	je     8024d7 <fd_lookup+0x77>
  8024b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ba:	48 c1 e8 0c          	shr    $0xc,%rax
  8024be:	48 89 c2             	mov    %rax,%rdx
  8024c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024c8:	01 00 00 
  8024cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024cf:	83 e0 01             	and    $0x1,%eax
  8024d2:	48 85 c0             	test   %rax,%rax
  8024d5:	75 07                	jne    8024de <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024dc:	eb 10                	jmp    8024ee <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024e6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ee:	c9                   	leaveq 
  8024ef:	c3                   	retq   

00000000008024f0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024f0:	55                   	push   %rbp
  8024f1:	48 89 e5             	mov    %rsp,%rbp
  8024f4:	48 83 ec 30          	sub    $0x30,%rsp
  8024f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024fc:	89 f0                	mov    %esi,%eax
  8024fe:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802501:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802505:	48 89 c7             	mov    %rax,%rdi
  802508:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  80250f:	00 00 00 
  802512:	ff d0                	callq  *%rax
  802514:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802518:	48 89 d6             	mov    %rdx,%rsi
  80251b:	89 c7                	mov    %eax,%edi
  80251d:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802530:	78 0a                	js     80253c <fd_close+0x4c>
	    || fd != fd2)
  802532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802536:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80253a:	74 12                	je     80254e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80253c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802540:	74 05                	je     802547 <fd_close+0x57>
  802542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802545:	eb 05                	jmp    80254c <fd_close+0x5c>
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	eb 69                	jmp    8025b7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80254e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802552:	8b 00                	mov    (%rax),%eax
  802554:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802558:	48 89 d6             	mov    %rdx,%rsi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	78 2a                	js     80259c <fd_close+0xac>
		if (dev->dev_close)
  802572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802576:	48 8b 40 20          	mov    0x20(%rax),%rax
  80257a:	48 85 c0             	test   %rax,%rax
  80257d:	74 16                	je     802595 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80257f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802583:	48 8b 40 20          	mov    0x20(%rax),%rax
  802587:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80258b:	48 89 d7             	mov    %rdx,%rdi
  80258e:	ff d0                	callq  *%rax
  802590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802593:	eb 07                	jmp    80259c <fd_close+0xac>
		else
			r = 0;
  802595:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80259c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a0:	48 89 c6             	mov    %rax,%rsi
  8025a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a8:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax
	return r;
  8025b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025b7:	c9                   	leaveq 
  8025b8:	c3                   	retq   

00000000008025b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025b9:	55                   	push   %rbp
  8025ba:	48 89 e5             	mov    %rsp,%rbp
  8025bd:	48 83 ec 20          	sub    $0x20,%rsp
  8025c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025cf:	eb 41                	jmp    802612 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025d1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025d8:	00 00 00 
  8025db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025de:	48 63 d2             	movslq %edx,%rdx
  8025e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e5:	8b 00                	mov    (%rax),%eax
  8025e7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025ea:	75 22                	jne    80260e <dev_lookup+0x55>
			*dev = devtab[i];
  8025ec:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8025f3:	00 00 00 
  8025f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f9:	48 63 d2             	movslq %edx,%rdx
  8025fc:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802604:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
  80260c:	eb 60                	jmp    80266e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80260e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802612:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802619:	00 00 00 
  80261c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80261f:	48 63 d2             	movslq %edx,%rdx
  802622:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802626:	48 85 c0             	test   %rax,%rax
  802629:	75 a6                	jne    8025d1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80262b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802632:	00 00 00 
  802635:	48 8b 00             	mov    (%rax),%rax
  802638:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80263e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802641:	89 c6                	mov    %eax,%esi
  802643:	48 bf b8 50 80 00 00 	movabs $0x8050b8,%rdi
  80264a:	00 00 00 
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
  802652:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802659:	00 00 00 
  80265c:	ff d1                	callq  *%rcx
	*dev = 0;
  80265e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802662:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802669:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80266e:	c9                   	leaveq 
  80266f:	c3                   	retq   

0000000000802670 <close>:

int
close(int fdnum)
{
  802670:	55                   	push   %rbp
  802671:	48 89 e5             	mov    %rsp,%rbp
  802674:	48 83 ec 20          	sub    $0x20,%rsp
  802678:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80267f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802682:	48 89 d6             	mov    %rdx,%rsi
  802685:	89 c7                	mov    %eax,%edi
  802687:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  80268e:	00 00 00 
  802691:	ff d0                	callq  *%rax
  802693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269a:	79 05                	jns    8026a1 <close+0x31>
		return r;
  80269c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269f:	eb 18                	jmp    8026b9 <close+0x49>
	else
		return fd_close(fd, 1);
  8026a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a5:	be 01 00 00 00       	mov    $0x1,%esi
  8026aa:	48 89 c7             	mov    %rax,%rdi
  8026ad:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
}
  8026b9:	c9                   	leaveq 
  8026ba:	c3                   	retq   

00000000008026bb <close_all>:

void
close_all(void)
{
  8026bb:	55                   	push   %rbp
  8026bc:	48 89 e5             	mov    %rsp,%rbp
  8026bf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ca:	eb 15                	jmp    8026e1 <close_all+0x26>
		close(i);
  8026cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cf:	89 c7                	mov    %eax,%edi
  8026d1:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026e5:	7e e5                	jle    8026cc <close_all+0x11>
		close(i);
}
  8026e7:	c9                   	leaveq 
  8026e8:	c3                   	retq   

00000000008026e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026e9:	55                   	push   %rbp
  8026ea:	48 89 e5             	mov    %rsp,%rbp
  8026ed:	48 83 ec 40          	sub    $0x40,%rsp
  8026f1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026f4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026f7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026fb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026fe:	48 89 d6             	mov    %rdx,%rsi
  802701:	89 c7                	mov    %eax,%edi
  802703:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  80270a:	00 00 00 
  80270d:	ff d0                	callq  *%rax
  80270f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802712:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802716:	79 08                	jns    802720 <dup+0x37>
		return r;
  802718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271b:	e9 70 01 00 00       	jmpq   802890 <dup+0x1a7>
	close(newfdnum);
  802720:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802723:	89 c7                	mov    %eax,%edi
  802725:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802731:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802734:	48 98                	cltq   
  802736:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80273c:	48 c1 e0 0c          	shl    $0xc,%rax
  802740:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802748:	48 89 c7             	mov    %rax,%rdi
  80274b:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  802752:	00 00 00 
  802755:	ff d0                	callq  *%rax
  802757:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80275b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275f:	48 89 c7             	mov    %rax,%rdi
  802762:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
  80276e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802776:	48 c1 e8 15          	shr    $0x15,%rax
  80277a:	48 89 c2             	mov    %rax,%rdx
  80277d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802784:	01 00 00 
  802787:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278b:	83 e0 01             	and    $0x1,%eax
  80278e:	48 85 c0             	test   %rax,%rax
  802791:	74 73                	je     802806 <dup+0x11d>
  802793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802797:	48 c1 e8 0c          	shr    $0xc,%rax
  80279b:	48 89 c2             	mov    %rax,%rdx
  80279e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027a5:	01 00 00 
  8027a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ac:	83 e0 01             	and    $0x1,%eax
  8027af:	48 85 c0             	test   %rax,%rax
  8027b2:	74 52                	je     802806 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8027bc:	48 89 c2             	mov    %rax,%rdx
  8027bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c6:	01 00 00 
  8027c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8027d2:	89 c1                	mov    %eax,%ecx
  8027d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027dc:	41 89 c8             	mov    %ecx,%r8d
  8027df:	48 89 d1             	mov    %rdx,%rcx
  8027e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e7:	48 89 c6             	mov    %rax,%rsi
  8027ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ef:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802802:	79 02                	jns    802806 <dup+0x11d>
			goto err;
  802804:	eb 57                	jmp    80285d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280a:	48 c1 e8 0c          	shr    $0xc,%rax
  80280e:	48 89 c2             	mov    %rax,%rdx
  802811:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802818:	01 00 00 
  80281b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281f:	25 07 0e 00 00       	and    $0xe07,%eax
  802824:	89 c1                	mov    %eax,%ecx
  802826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80282e:	41 89 c8             	mov    %ecx,%r8d
  802831:	48 89 d1             	mov    %rdx,%rcx
  802834:	ba 00 00 00 00       	mov    $0x0,%edx
  802839:	48 89 c6             	mov    %rax,%rsi
  80283c:	bf 00 00 00 00       	mov    $0x0,%edi
  802841:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax
  80284d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802850:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802854:	79 02                	jns    802858 <dup+0x16f>
		goto err;
  802856:	eb 05                	jmp    80285d <dup+0x174>

	return newfdnum;
  802858:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80285b:	eb 33                	jmp    802890 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80285d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802861:	48 89 c6             	mov    %rax,%rsi
  802864:	bf 00 00 00 00       	mov    $0x0,%edi
  802869:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802870:	00 00 00 
  802873:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802875:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802879:	48 89 c6             	mov    %rax,%rsi
  80287c:	bf 00 00 00 00       	mov    $0x0,%edi
  802881:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802888:	00 00 00 
  80288b:	ff d0                	callq  *%rax
	return r;
  80288d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802890:	c9                   	leaveq 
  802891:	c3                   	retq   

0000000000802892 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802892:	55                   	push   %rbp
  802893:	48 89 e5             	mov    %rsp,%rbp
  802896:	48 83 ec 40          	sub    $0x40,%rsp
  80289a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80289d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ac:	48 89 d6             	mov    %rdx,%rsi
  8028af:	89 c7                	mov    %eax,%edi
  8028b1:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c4:	78 24                	js     8028ea <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ca:	8b 00                	mov    (%rax),%eax
  8028cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d0:	48 89 d6             	mov    %rdx,%rsi
  8028d3:	89 c7                	mov    %eax,%edi
  8028d5:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
  8028e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e8:	79 05                	jns    8028ef <read+0x5d>
		return r;
  8028ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ed:	eb 76                	jmp    802965 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f3:	8b 40 08             	mov    0x8(%rax),%eax
  8028f6:	83 e0 03             	and    $0x3,%eax
  8028f9:	83 f8 01             	cmp    $0x1,%eax
  8028fc:	75 3a                	jne    802938 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028fe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802905:	00 00 00 
  802908:	48 8b 00             	mov    (%rax),%rax
  80290b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802911:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802914:	89 c6                	mov    %eax,%esi
  802916:	48 bf d7 50 80 00 00 	movabs $0x8050d7,%rdi
  80291d:	00 00 00 
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
  802925:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  80292c:	00 00 00 
  80292f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802931:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802936:	eb 2d                	jmp    802965 <read+0xd3>
	}
	if (!dev->dev_read)
  802938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802940:	48 85 c0             	test   %rax,%rax
  802943:	75 07                	jne    80294c <read+0xba>
		return -E_NOT_SUPP;
  802945:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80294a:	eb 19                	jmp    802965 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 8b 40 10          	mov    0x10(%rax),%rax
  802954:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802958:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80295c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802960:	48 89 cf             	mov    %rcx,%rdi
  802963:	ff d0                	callq  *%rax
}
  802965:	c9                   	leaveq 
  802966:	c3                   	retq   

0000000000802967 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802967:	55                   	push   %rbp
  802968:	48 89 e5             	mov    %rsp,%rbp
  80296b:	48 83 ec 30          	sub    $0x30,%rsp
  80296f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802972:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802976:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80297a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802981:	eb 49                	jmp    8029cc <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802986:	48 98                	cltq   
  802988:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80298c:	48 29 c2             	sub    %rax,%rdx
  80298f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802992:	48 63 c8             	movslq %eax,%rcx
  802995:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802999:	48 01 c1             	add    %rax,%rcx
  80299c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299f:	48 89 ce             	mov    %rcx,%rsi
  8029a2:	89 c7                	mov    %eax,%edi
  8029a4:	48 b8 92 28 80 00 00 	movabs $0x802892,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	callq  *%rax
  8029b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029b7:	79 05                	jns    8029be <readn+0x57>
			return m;
  8029b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029bc:	eb 1c                	jmp    8029da <readn+0x73>
		if (m == 0)
  8029be:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029c2:	75 02                	jne    8029c6 <readn+0x5f>
			break;
  8029c4:	eb 11                	jmp    8029d7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029c9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	48 98                	cltq   
  8029d1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029d5:	72 ac                	jb     802983 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029da:	c9                   	leaveq 
  8029db:	c3                   	retq   

00000000008029dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029dc:	55                   	push   %rbp
  8029dd:	48 89 e5             	mov    %rsp,%rbp
  8029e0:	48 83 ec 40          	sub    $0x40,%rsp
  8029e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f6:	48 89 d6             	mov    %rdx,%rsi
  8029f9:	89 c7                	mov    %eax,%edi
  8029fb:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
  802a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0e:	78 24                	js     802a34 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	8b 00                	mov    (%rax),%eax
  802a16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a1a:	48 89 d6             	mov    %rdx,%rsi
  802a1d:	89 c7                	mov    %eax,%edi
  802a1f:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
  802a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a32:	79 05                	jns    802a39 <write+0x5d>
		return r;
  802a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a37:	eb 75                	jmp    802aae <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3d:	8b 40 08             	mov    0x8(%rax),%eax
  802a40:	83 e0 03             	and    $0x3,%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	75 3a                	jne    802a81 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a4e:	00 00 00 
  802a51:	48 8b 00             	mov    (%rax),%rax
  802a54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a5d:	89 c6                	mov    %eax,%esi
  802a5f:	48 bf f3 50 80 00 00 	movabs $0x8050f3,%rdi
  802a66:	00 00 00 
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802a75:	00 00 00 
  802a78:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a7f:	eb 2d                	jmp    802aae <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a85:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a89:	48 85 c0             	test   %rax,%rax
  802a8c:	75 07                	jne    802a95 <write+0xb9>
		return -E_NOT_SUPP;
  802a8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a93:	eb 19                	jmp    802aae <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a9d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aa1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802aa5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aa9:	48 89 cf             	mov    %rcx,%rdi
  802aac:	ff d0                	callq  *%rax
}
  802aae:	c9                   	leaveq 
  802aaf:	c3                   	retq   

0000000000802ab0 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 18          	sub    $0x18,%rsp
  802ab8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802abb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802abe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac5:	48 89 d6             	mov    %rdx,%rsi
  802ac8:	89 c7                	mov    %eax,%edi
  802aca:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
  802ad6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802add:	79 05                	jns    802ae4 <seek+0x34>
		return r;
  802adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae2:	eb 0f                	jmp    802af3 <seek+0x43>
	fd->fd_offset = offset;
  802ae4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802aeb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af3:	c9                   	leaveq 
  802af4:	c3                   	retq   

0000000000802af5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802af5:	55                   	push   %rbp
  802af6:	48 89 e5             	mov    %rsp,%rbp
  802af9:	48 83 ec 30          	sub    $0x30,%rsp
  802afd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b00:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b0a:	48 89 d6             	mov    %rdx,%rsi
  802b0d:	89 c7                	mov    %eax,%edi
  802b0f:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b22:	78 24                	js     802b48 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b28:	8b 00                	mov    (%rax),%eax
  802b2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b2e:	48 89 d6             	mov    %rdx,%rsi
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802b3a:	00 00 00 
  802b3d:	ff d0                	callq  *%rax
  802b3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b46:	79 05                	jns    802b4d <ftruncate+0x58>
		return r;
  802b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4b:	eb 72                	jmp    802bbf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	8b 40 08             	mov    0x8(%rax),%eax
  802b54:	83 e0 03             	and    $0x3,%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	75 3a                	jne    802b95 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b5b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b62:	00 00 00 
  802b65:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b68:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b6e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b71:	89 c6                	mov    %eax,%esi
  802b73:	48 bf 10 51 80 00 00 	movabs $0x805110,%rdi
  802b7a:	00 00 00 
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b82:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802b89:	00 00 00 
  802b8c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b93:	eb 2a                	jmp    802bbf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b99:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b9d:	48 85 c0             	test   %rax,%rax
  802ba0:	75 07                	jne    802ba9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ba2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ba7:	eb 16                	jmp    802bbf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bad:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bb5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802bb8:	89 ce                	mov    %ecx,%esi
  802bba:	48 89 d7             	mov    %rdx,%rdi
  802bbd:	ff d0                	callq  *%rax
}
  802bbf:	c9                   	leaveq 
  802bc0:	c3                   	retq   

0000000000802bc1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802bc1:	55                   	push   %rbp
  802bc2:	48 89 e5             	mov    %rsp,%rbp
  802bc5:	48 83 ec 30          	sub    $0x30,%rsp
  802bc9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bcc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bd7:	48 89 d6             	mov    %rdx,%rsi
  802bda:	89 c7                	mov    %eax,%edi
  802bdc:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
  802be8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bef:	78 24                	js     802c15 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bf1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf5:	8b 00                	mov    (%rax),%eax
  802bf7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bfb:	48 89 d6             	mov    %rdx,%rsi
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 b9 25 80 00 00 	movabs $0x8025b9,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
  802c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c13:	79 05                	jns    802c1a <fstat+0x59>
		return r;
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	eb 5e                	jmp    802c78 <fstat+0xb7>
	if (!dev->dev_stat)
  802c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c22:	48 85 c0             	test   %rax,%rax
  802c25:	75 07                	jne    802c2e <fstat+0x6d>
		return -E_NOT_SUPP;
  802c27:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c2c:	eb 4a                	jmp    802c78 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c32:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c39:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c40:	00 00 00 
	stat->st_isdir = 0;
  802c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c47:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c4e:	00 00 00 
	stat->st_dev = dev;
  802c51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c59:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c64:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c6c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c70:	48 89 ce             	mov    %rcx,%rsi
  802c73:	48 89 d7             	mov    %rdx,%rdi
  802c76:	ff d0                	callq  *%rax
}
  802c78:	c9                   	leaveq 
  802c79:	c3                   	retq   

0000000000802c7a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c7a:	55                   	push   %rbp
  802c7b:	48 89 e5             	mov    %rsp,%rbp
  802c7e:	48 83 ec 20          	sub    $0x20,%rsp
  802c82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8e:	be 00 00 00 00       	mov    $0x0,%esi
  802c93:	48 89 c7             	mov    %rax,%rdi
  802c96:	48 b8 68 2d 80 00 00 	movabs $0x802d68,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
  802ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca9:	79 05                	jns    802cb0 <stat+0x36>
		return fd;
  802cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cae:	eb 2f                	jmp    802cdf <stat+0x65>
	r = fstat(fd, stat);
  802cb0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb7:	48 89 d6             	mov    %rdx,%rsi
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 c1 2b 80 00 00 	movabs $0x802bc1,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	89 c7                	mov    %eax,%edi
  802cd0:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
	return r;
  802cdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cdf:	c9                   	leaveq 
  802ce0:	c3                   	retq   

0000000000802ce1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ce1:	55                   	push   %rbp
  802ce2:	48 89 e5             	mov    %rsp,%rbp
  802ce5:	48 83 ec 10          	sub    $0x10,%rsp
  802ce9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cf0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cf7:	00 00 00 
  802cfa:	8b 00                	mov    (%rax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	75 1d                	jne    802d1d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d00:	bf 01 00 00 00       	mov    $0x1,%edi
  802d05:	48 b8 b8 48 80 00 00 	movabs $0x8048b8,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d18:	00 00 00 
  802d1b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d1d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d24:	00 00 00 
  802d27:	8b 00                	mov    (%rax),%eax
  802d29:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d2c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d31:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d38:	00 00 00 
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 56 48 80 00 00 	movabs $0x804856,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d52:	48 89 c6             	mov    %rax,%rsi
  802d55:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5a:	48 b8 50 47 80 00 00 	movabs $0x804750,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
}
  802d66:	c9                   	leaveq 
  802d67:	c3                   	retq   

0000000000802d68 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d68:	55                   	push   %rbp
  802d69:	48 89 e5             	mov    %rsp,%rbp
  802d6c:	48 83 ec 30          	sub    $0x30,%rsp
  802d70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d74:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802d77:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802d7e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802d85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d8c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d91:	75 08                	jne    802d9b <open+0x33>
	{
		return r;
  802d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d96:	e9 f2 00 00 00       	jmpq   802e8d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d9f:	48 89 c7             	mov    %rax,%rdi
  802da2:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802db1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802db8:	7e 0a                	jle    802dc4 <open+0x5c>
	{
		return -E_BAD_PATH;
  802dba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802dbf:	e9 c9 00 00 00       	jmpq   802e8d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802dc4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802dcb:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802dcc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802dd0:	48 89 c7             	mov    %rax,%rdi
  802dd3:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
  802ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de6:	78 09                	js     802df1 <open+0x89>
  802de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dec:	48 85 c0             	test   %rax,%rax
  802def:	75 08                	jne    802df9 <open+0x91>
		{
			return r;
  802df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df4:	e9 94 00 00 00       	jmpq   802e8d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802df9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dfd:	ba 00 04 00 00       	mov    $0x400,%edx
  802e02:	48 89 c6             	mov    %rax,%rsi
  802e05:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e0c:	00 00 00 
  802e0f:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802e1b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e22:	00 00 00 
  802e25:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802e28:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	48 89 c6             	mov    %rax,%rsi
  802e35:	bf 01 00 00 00       	mov    $0x1,%edi
  802e3a:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
  802e46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4d:	79 2b                	jns    802e7a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e53:	be 00 00 00 00       	mov    $0x0,%esi
  802e58:	48 89 c7             	mov    %rax,%rdi
  802e5b:	48 b8 f0 24 80 00 00 	movabs $0x8024f0,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
  802e67:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802e6a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e6e:	79 05                	jns    802e75 <open+0x10d>
			{
				return d;
  802e70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e73:	eb 18                	jmp    802e8d <open+0x125>
			}
			return r;
  802e75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e78:	eb 13                	jmp    802e8d <open+0x125>
		}	
		return fd2num(fd_store);
  802e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7e:	48 89 c7             	mov    %rax,%rdi
  802e81:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e8d:	c9                   	leaveq 
  802e8e:	c3                   	retq   

0000000000802e8f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e8f:	55                   	push   %rbp
  802e90:	48 89 e5             	mov    %rsp,%rbp
  802e93:	48 83 ec 10          	sub    $0x10,%rsp
  802e97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9f:	8b 50 0c             	mov    0xc(%rax),%edx
  802ea2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ea9:	00 00 00 
  802eac:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802eae:	be 00 00 00 00       	mov    $0x0,%esi
  802eb3:	bf 06 00 00 00       	mov    $0x6,%edi
  802eb8:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
}
  802ec4:	c9                   	leaveq 
  802ec5:	c3                   	retq   

0000000000802ec6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ec6:	55                   	push   %rbp
  802ec7:	48 89 e5             	mov    %rsp,%rbp
  802eca:	48 83 ec 30          	sub    $0x30,%rsp
  802ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ed2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ed6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802eda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802ee1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802ee6:	74 07                	je     802eef <devfile_read+0x29>
  802ee8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802eed:	75 07                	jne    802ef6 <devfile_read+0x30>
		return -E_INVAL;
  802eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef4:	eb 77                	jmp    802f6d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efa:	8b 50 0c             	mov    0xc(%rax),%edx
  802efd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f04:	00 00 00 
  802f07:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f09:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f10:	00 00 00 
  802f13:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f17:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802f1b:	be 00 00 00 00       	mov    $0x0,%esi
  802f20:	bf 03 00 00 00       	mov    $0x3,%edi
  802f25:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f38:	7f 05                	jg     802f3f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3d:	eb 2e                	jmp    802f6d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	48 63 d0             	movslq %eax,%rdx
  802f45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f49:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f50:	00 00 00 
  802f53:	48 89 c7             	mov    %rax,%rdi
  802f56:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802f62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f6d:	c9                   	leaveq 
  802f6e:	c3                   	retq   

0000000000802f6f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f6f:	55                   	push   %rbp
  802f70:	48 89 e5             	mov    %rsp,%rbp
  802f73:	48 83 ec 30          	sub    $0x30,%rsp
  802f77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802f83:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802f8a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f8f:	74 07                	je     802f98 <devfile_write+0x29>
  802f91:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f96:	75 08                	jne    802fa0 <devfile_write+0x31>
		return r;
  802f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9b:	e9 9a 00 00 00       	jmpq   80303a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa4:	8b 50 0c             	mov    0xc(%rax),%edx
  802fa7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fae:	00 00 00 
  802fb1:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802fb3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802fba:	00 
  802fbb:	76 08                	jbe    802fc5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802fbd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802fc4:	00 
	}
	fsipcbuf.write.req_n = n;
  802fc5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fcc:	00 00 00 
  802fcf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fd3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802fd7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fdf:	48 89 c6             	mov    %rax,%rsi
  802fe2:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fe9:	00 00 00 
  802fec:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802ff8:	be 00 00 00 00       	mov    $0x0,%esi
  802ffd:	bf 04 00 00 00       	mov    $0x4,%edi
  803002:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
  80300e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803011:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803015:	7f 20                	jg     803037 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803017:	48 bf 36 51 80 00 00 	movabs $0x805136,%rdi
  80301e:	00 00 00 
  803021:	b8 00 00 00 00       	mov    $0x0,%eax
  803026:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  80302d:	00 00 00 
  803030:	ff d2                	callq  *%rdx
		return r;
  803032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803035:	eb 03                	jmp    80303a <devfile_write+0xcb>
	}
	return r;
  803037:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80303a:	c9                   	leaveq 
  80303b:	c3                   	retq   

000000000080303c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80303c:	55                   	push   %rbp
  80303d:	48 89 e5             	mov    %rsp,%rbp
  803040:	48 83 ec 20          	sub    $0x20,%rsp
  803044:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80304c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803050:	8b 50 0c             	mov    0xc(%rax),%edx
  803053:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305a:	00 00 00 
  80305d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80305f:	be 00 00 00 00       	mov    $0x0,%esi
  803064:	bf 05 00 00 00       	mov    $0x5,%edi
  803069:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  803070:	00 00 00 
  803073:	ff d0                	callq  *%rax
  803075:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803078:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307c:	79 05                	jns    803083 <devfile_stat+0x47>
		return r;
  80307e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803081:	eb 56                	jmp    8030d9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803083:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803087:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80308e:	00 00 00 
  803091:	48 89 c7             	mov    %rax,%rdi
  803094:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a7:	00 00 00 
  8030aa:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c1:	00 00 00 
  8030c4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ce:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d9:	c9                   	leaveq 
  8030da:	c3                   	retq   

00000000008030db <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030db:	55                   	push   %rbp
  8030dc:	48 89 e5             	mov    %rsp,%rbp
  8030df:	48 83 ec 10          	sub    $0x10,%rsp
  8030e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f8:	00 00 00 
  8030fb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803104:	00 00 00 
  803107:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80310d:	be 00 00 00 00       	mov    $0x0,%esi
  803112:	bf 02 00 00 00       	mov    $0x2,%edi
  803117:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  80311e:	00 00 00 
  803121:	ff d0                	callq  *%rax
}
  803123:	c9                   	leaveq 
  803124:	c3                   	retq   

0000000000803125 <remove>:

// Delete a file
int
remove(const char *path)
{
  803125:	55                   	push   %rbp
  803126:	48 89 e5             	mov    %rsp,%rbp
  803129:	48 83 ec 10          	sub    $0x10,%rsp
  80312d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803135:	48 89 c7             	mov    %rax,%rdi
  803138:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803149:	7e 07                	jle    803152 <remove+0x2d>
		return -E_BAD_PATH;
  80314b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803150:	eb 33                	jmp    803185 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803156:	48 89 c6             	mov    %rax,%rsi
  803159:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803160:	00 00 00 
  803163:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80316f:	be 00 00 00 00       	mov    $0x0,%esi
  803174:	bf 07 00 00 00       	mov    $0x7,%edi
  803179:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
}
  803185:	c9                   	leaveq 
  803186:	c3                   	retq   

0000000000803187 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803187:	55                   	push   %rbp
  803188:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80318b:	be 00 00 00 00       	mov    $0x0,%esi
  803190:	bf 08 00 00 00       	mov    $0x8,%edi
  803195:	48 b8 e1 2c 80 00 00 	movabs $0x802ce1,%rax
  80319c:	00 00 00 
  80319f:	ff d0                	callq  *%rax
}
  8031a1:	5d                   	pop    %rbp
  8031a2:	c3                   	retq   

00000000008031a3 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8031a3:	55                   	push   %rbp
  8031a4:	48 89 e5             	mov    %rsp,%rbp
  8031a7:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8031ae:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8031b5:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8031bc:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8031c3:	be 00 00 00 00       	mov    $0x0,%esi
  8031c8:	48 89 c7             	mov    %rax,%rdi
  8031cb:	48 b8 68 2d 80 00 00 	movabs $0x802d68,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
  8031d7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031da:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031de:	79 08                	jns    8031e8 <spawn+0x45>
		return r;
  8031e0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031e3:	e9 14 03 00 00       	jmpq   8034fc <spawn+0x359>
	fd = r;
  8031e8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031eb:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031ee:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8031f5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8031f9:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803200:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803203:	ba 00 02 00 00       	mov    $0x200,%edx
  803208:	48 89 ce             	mov    %rcx,%rsi
  80320b:	89 c7                	mov    %eax,%edi
  80320d:	48 b8 67 29 80 00 00 	movabs $0x802967,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
  803219:	3d 00 02 00 00       	cmp    $0x200,%eax
  80321e:	75 0d                	jne    80322d <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  803220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803224:	8b 00                	mov    (%rax),%eax
  803226:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  80322b:	74 43                	je     803270 <spawn+0xcd>
		close(fd);
  80322d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803230:	89 c7                	mov    %eax,%edi
  803232:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80323e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803242:	8b 00                	mov    (%rax),%eax
  803244:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803249:	89 c6                	mov    %eax,%esi
  80324b:	48 bf 58 51 80 00 00 	movabs $0x805158,%rdi
  803252:	00 00 00 
  803255:	b8 00 00 00 00       	mov    $0x0,%eax
  80325a:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  803261:	00 00 00 
  803264:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803266:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80326b:	e9 8c 02 00 00       	jmpq   8034fc <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803270:	b8 07 00 00 00       	mov    $0x7,%eax
  803275:	cd 30                	int    $0x30
  803277:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80327a:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80327d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803280:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803284:	79 08                	jns    80328e <spawn+0xeb>
		return r;
  803286:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803289:	e9 6e 02 00 00       	jmpq   8034fc <spawn+0x359>
	child = r;
  80328e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803291:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803294:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803297:	25 ff 03 00 00       	and    $0x3ff,%eax
  80329c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032a3:	00 00 00 
  8032a6:	48 63 d0             	movslq %eax,%rdx
  8032a9:	48 89 d0             	mov    %rdx,%rax
  8032ac:	48 c1 e0 03          	shl    $0x3,%rax
  8032b0:	48 01 d0             	add    %rdx,%rax
  8032b3:	48 c1 e0 05          	shl    $0x5,%rax
  8032b7:	48 01 c8             	add    %rcx,%rax
  8032ba:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8032c1:	48 89 c6             	mov    %rax,%rsi
  8032c4:	b8 18 00 00 00       	mov    $0x18,%eax
  8032c9:	48 89 d7             	mov    %rdx,%rdi
  8032cc:	48 89 c1             	mov    %rax,%rcx
  8032cf:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032da:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032e1:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8032e8:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032ef:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8032f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032f9:	48 89 ce             	mov    %rcx,%rsi
  8032fc:	89 c7                	mov    %eax,%edi
  8032fe:	48 b8 66 37 80 00 00 	movabs $0x803766,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
  80330a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80330d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803311:	79 08                	jns    80331b <spawn+0x178>
		return r;
  803313:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803316:	e9 e1 01 00 00       	jmpq   8034fc <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80331b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331f:	48 8b 40 20          	mov    0x20(%rax),%rax
  803323:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  80332a:	48 01 d0             	add    %rdx,%rax
  80332d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803331:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803338:	e9 a3 00 00 00       	jmpq   8033e0 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  80333d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803341:	8b 00                	mov    (%rax),%eax
  803343:	83 f8 01             	cmp    $0x1,%eax
  803346:	74 05                	je     80334d <spawn+0x1aa>
			continue;
  803348:	e9 8a 00 00 00       	jmpq   8033d7 <spawn+0x234>
		perm = PTE_P | PTE_U;
  80334d:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803358:	8b 40 04             	mov    0x4(%rax),%eax
  80335b:	83 e0 02             	and    $0x2,%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	74 04                	je     803366 <spawn+0x1c3>
			perm |= PTE_W;
  803362:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336a:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80336e:	41 89 c1             	mov    %eax,%r9d
  803371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803375:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337d:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803385:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803389:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80338c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80338f:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803392:	89 3c 24             	mov    %edi,(%rsp)
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 0f 3a 80 00 00 	movabs $0x803a0f,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
  8033a3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033aa:	79 2b                	jns    8033d7 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8033ac:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8033ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033b0:	89 c7                	mov    %eax,%edi
  8033b2:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
	close(fd);
  8033be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033c1:	89 c7                	mov    %eax,%edi
  8033c3:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  8033ca:	00 00 00 
  8033cd:	ff d0                	callq  *%rax
	return r;
  8033cf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033d2:	e9 25 01 00 00       	jmpq   8034fc <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033db:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8033e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e4:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033e8:	0f b7 c0             	movzwl %ax,%eax
  8033eb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8033ee:	0f 8f 49 ff ff ff    	jg     80333d <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033f4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033f7:	89 c7                	mov    %eax,%edi
  8033f9:	48 b8 70 26 80 00 00 	movabs $0x802670,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
	fd = -1;
  803405:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80340c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80340f:	89 c7                	mov    %eax,%edi
  803411:	48 b8 fb 3b 80 00 00 	movabs $0x803bfb,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
  80341d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803420:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803424:	79 30                	jns    803456 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803426:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803429:	89 c1                	mov    %eax,%ecx
  80342b:	48 ba 72 51 80 00 00 	movabs $0x805172,%rdx
  803432:	00 00 00 
  803435:	be 82 00 00 00       	mov    $0x82,%esi
  80343a:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  803441:	00 00 00 
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
  803449:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803450:	00 00 00 
  803453:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803456:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80345d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803460:	48 89 d6             	mov    %rdx,%rsi
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803474:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803478:	79 30                	jns    8034aa <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  80347a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80347d:	89 c1                	mov    %eax,%ecx
  80347f:	48 ba 94 51 80 00 00 	movabs $0x805194,%rdx
  803486:	00 00 00 
  803489:	be 85 00 00 00       	mov    $0x85,%esi
  80348e:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  803495:	00 00 00 
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
  80349d:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8034a4:	00 00 00 
  8034a7:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8034aa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034ad:	be 02 00 00 00       	mov    $0x2,%esi
  8034b2:	89 c7                	mov    %eax,%edi
  8034b4:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
  8034c0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034c7:	79 30                	jns    8034f9 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  8034c9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034cc:	89 c1                	mov    %eax,%ecx
  8034ce:	48 ba ae 51 80 00 00 	movabs $0x8051ae,%rdx
  8034d5:	00 00 00 
  8034d8:	be 88 00 00 00       	mov    $0x88,%esi
  8034dd:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  8034e4:	00 00 00 
  8034e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ec:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8034f3:	00 00 00 
  8034f6:	41 ff d0             	callq  *%r8

	return child;
  8034f9:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8034fc:	c9                   	leaveq 
  8034fd:	c3                   	retq   

00000000008034fe <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8034fe:	55                   	push   %rbp
  8034ff:	48 89 e5             	mov    %rsp,%rbp
  803502:	41 55                	push   %r13
  803504:	41 54                	push   %r12
  803506:	53                   	push   %rbx
  803507:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80350e:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803515:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80351c:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803523:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  80352a:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803531:	84 c0                	test   %al,%al
  803533:	74 26                	je     80355b <spawnl+0x5d>
  803535:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80353c:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803543:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803547:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  80354b:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80354f:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803553:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803557:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  80355b:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803562:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803569:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80356c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803573:	00 00 00 
  803576:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80357d:	00 00 00 
  803580:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803584:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80358b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803592:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803599:	eb 07                	jmp    8035a2 <spawnl+0xa4>
		argc++;
  80359b:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8035a2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8035a8:	83 f8 30             	cmp    $0x30,%eax
  8035ab:	73 23                	jae    8035d0 <spawnl+0xd2>
  8035ad:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8035b4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8035ba:	89 c0                	mov    %eax,%eax
  8035bc:	48 01 d0             	add    %rdx,%rax
  8035bf:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8035c5:	83 c2 08             	add    $0x8,%edx
  8035c8:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8035ce:	eb 15                	jmp    8035e5 <spawnl+0xe7>
  8035d0:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8035d7:	48 89 d0             	mov    %rdx,%rax
  8035da:	48 83 c2 08          	add    $0x8,%rdx
  8035de:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035e5:	48 8b 00             	mov    (%rax),%rax
  8035e8:	48 85 c0             	test   %rax,%rax
  8035eb:	75 ae                	jne    80359b <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035ed:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035f3:	83 c0 02             	add    $0x2,%eax
  8035f6:	48 89 e2             	mov    %rsp,%rdx
  8035f9:	48 89 d3             	mov    %rdx,%rbx
  8035fc:	48 63 d0             	movslq %eax,%rdx
  8035ff:	48 83 ea 01          	sub    $0x1,%rdx
  803603:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80360a:	48 63 d0             	movslq %eax,%rdx
  80360d:	49 89 d4             	mov    %rdx,%r12
  803610:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803616:	48 63 d0             	movslq %eax,%rdx
  803619:	49 89 d2             	mov    %rdx,%r10
  80361c:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803622:	48 98                	cltq   
  803624:	48 c1 e0 03          	shl    $0x3,%rax
  803628:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80362c:	b8 10 00 00 00       	mov    $0x10,%eax
  803631:	48 83 e8 01          	sub    $0x1,%rax
  803635:	48 01 d0             	add    %rdx,%rax
  803638:	bf 10 00 00 00       	mov    $0x10,%edi
  80363d:	ba 00 00 00 00       	mov    $0x0,%edx
  803642:	48 f7 f7             	div    %rdi
  803645:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803649:	48 29 c4             	sub    %rax,%rsp
  80364c:	48 89 e0             	mov    %rsp,%rax
  80364f:	48 83 c0 07          	add    $0x7,%rax
  803653:	48 c1 e8 03          	shr    $0x3,%rax
  803657:	48 c1 e0 03          	shl    $0x3,%rax
  80365b:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803662:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803669:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803670:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803673:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803679:	8d 50 01             	lea    0x1(%rax),%edx
  80367c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803683:	48 63 d2             	movslq %edx,%rdx
  803686:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80368d:	00 

	va_start(vl, arg0);
  80368e:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803695:	00 00 00 
  803698:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80369f:	00 00 00 
  8036a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8036a6:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8036ad:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8036b4:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8036bb:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8036c2:	00 00 00 
  8036c5:	eb 63                	jmp    80372a <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8036c7:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8036cd:	8d 70 01             	lea    0x1(%rax),%esi
  8036d0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036d6:	83 f8 30             	cmp    $0x30,%eax
  8036d9:	73 23                	jae    8036fe <spawnl+0x200>
  8036db:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8036e2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036e8:	89 c0                	mov    %eax,%eax
  8036ea:	48 01 d0             	add    %rdx,%rax
  8036ed:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036f3:	83 c2 08             	add    $0x8,%edx
  8036f6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036fc:	eb 15                	jmp    803713 <spawnl+0x215>
  8036fe:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803705:	48 89 d0             	mov    %rdx,%rax
  803708:	48 83 c2 08          	add    $0x8,%rdx
  80370c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803713:	48 8b 08             	mov    (%rax),%rcx
  803716:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80371d:	89 f2                	mov    %esi,%edx
  80371f:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803723:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80372a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803730:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803736:	77 8f                	ja     8036c7 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803738:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80373f:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803746:	48 89 d6             	mov    %rdx,%rsi
  803749:	48 89 c7             	mov    %rax,%rdi
  80374c:	48 b8 a3 31 80 00 00 	movabs $0x8031a3,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
  803758:	48 89 dc             	mov    %rbx,%rsp
}
  80375b:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80375f:	5b                   	pop    %rbx
  803760:	41 5c                	pop    %r12
  803762:	41 5d                	pop    %r13
  803764:	5d                   	pop    %rbp
  803765:	c3                   	retq   

0000000000803766 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803766:	55                   	push   %rbp
  803767:	48 89 e5             	mov    %rsp,%rbp
  80376a:	48 83 ec 50          	sub    $0x50,%rsp
  80376e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803771:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803775:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803779:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803780:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803781:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803788:	eb 33                	jmp    8037bd <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80378a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80378d:	48 98                	cltq   
  80378f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803796:	00 
  803797:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80379b:	48 01 d0             	add    %rdx,%rax
  80379e:	48 8b 00             	mov    (%rax),%rax
  8037a1:	48 89 c7             	mov    %rax,%rdi
  8037a4:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
  8037b0:	83 c0 01             	add    $0x1,%eax
  8037b3:	48 98                	cltq   
  8037b5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8037b9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8037bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c0:	48 98                	cltq   
  8037c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037c9:	00 
  8037ca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037ce:	48 01 d0             	add    %rdx,%rax
  8037d1:	48 8b 00             	mov    (%rax),%rax
  8037d4:	48 85 c0             	test   %rax,%rax
  8037d7:	75 b1                	jne    80378a <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037dd:	48 f7 d8             	neg    %rax
  8037e0:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ee:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f6:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037fa:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037fd:	83 c2 01             	add    $0x1,%edx
  803800:	c1 e2 03             	shl    $0x3,%edx
  803803:	48 63 d2             	movslq %edx,%rdx
  803806:	48 f7 da             	neg    %rdx
  803809:	48 01 d0             	add    %rdx,%rax
  80380c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803810:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803814:	48 83 e8 10          	sub    $0x10,%rax
  803818:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  80381e:	77 0a                	ja     80382a <init_stack+0xc4>
		return -E_NO_MEM;
  803820:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803825:	e9 e3 01 00 00       	jmpq   803a0d <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80382a:	ba 07 00 00 00       	mov    $0x7,%edx
  80382f:	be 00 00 40 00       	mov    $0x400000,%esi
  803834:	bf 00 00 00 00       	mov    $0x0,%edi
  803839:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
  803845:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803848:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80384c:	79 08                	jns    803856 <init_stack+0xf0>
		return r;
  80384e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803851:	e9 b7 01 00 00       	jmpq   803a0d <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803856:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80385d:	e9 8a 00 00 00       	jmpq   8038ec <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803862:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803865:	48 98                	cltq   
  803867:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80386e:	00 
  80386f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803873:	48 01 c2             	add    %rax,%rdx
  803876:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80387b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80387f:	48 01 c8             	add    %rcx,%rax
  803882:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803888:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80388b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80388e:	48 98                	cltq   
  803890:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803897:	00 
  803898:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80389c:	48 01 d0             	add    %rdx,%rax
  80389f:	48 8b 10             	mov    (%rax),%rdx
  8038a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a6:	48 89 d6             	mov    %rdx,%rsi
  8038a9:	48 89 c7             	mov    %rax,%rdi
  8038ac:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8038b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038bb:	48 98                	cltq   
  8038bd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038c4:	00 
  8038c5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038c9:	48 01 d0             	add    %rdx,%rax
  8038cc:	48 8b 00             	mov    (%rax),%rax
  8038cf:	48 89 c7             	mov    %rax,%rdi
  8038d2:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  8038d9:	00 00 00 
  8038dc:	ff d0                	callq  *%rax
  8038de:	48 98                	cltq   
  8038e0:	48 83 c0 01          	add    $0x1,%rax
  8038e4:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038e8:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038ef:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038f2:	0f 8c 6a ff ff ff    	jl     803862 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038fb:	48 98                	cltq   
  8038fd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803904:	00 
  803905:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803909:	48 01 d0             	add    %rdx,%rax
  80390c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803913:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80391a:	00 
  80391b:	74 35                	je     803952 <init_stack+0x1ec>
  80391d:	48 b9 c8 51 80 00 00 	movabs $0x8051c8,%rcx
  803924:	00 00 00 
  803927:	48 ba ee 51 80 00 00 	movabs $0x8051ee,%rdx
  80392e:	00 00 00 
  803931:	be f1 00 00 00       	mov    $0xf1,%esi
  803936:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  80393d:	00 00 00 
  803940:	b8 00 00 00 00       	mov    $0x0,%eax
  803945:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  80394c:	00 00 00 
  80394f:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803952:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803956:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80395a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80395f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803963:	48 01 c8             	add    %rcx,%rax
  803966:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80396c:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80396f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803973:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803977:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80397a:	48 98                	cltq   
  80397c:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80397f:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803984:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803988:	48 01 d0             	add    %rdx,%rax
  80398b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803991:	48 89 c2             	mov    %rax,%rdx
  803994:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803998:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80399b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80399e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8039a4:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8039a9:	89 c2                	mov    %eax,%edx
  8039ab:	be 00 00 40 00       	mov    $0x400000,%esi
  8039b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b5:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c8:	79 02                	jns    8039cc <init_stack+0x266>
		goto error;
  8039ca:	eb 28                	jmp    8039f4 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8039cc:	be 00 00 40 00       	mov    $0x400000,%esi
  8039d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d6:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
  8039e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039e9:	79 02                	jns    8039ed <init_stack+0x287>
		goto error;
  8039eb:	eb 07                	jmp    8039f4 <init_stack+0x28e>

	return 0;
  8039ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f2:	eb 19                	jmp    803a0d <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8039f4:	be 00 00 40 00       	mov    $0x400000,%esi
  8039f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039fe:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
	return r;
  803a0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a0d:	c9                   	leaveq 
  803a0e:	c3                   	retq   

0000000000803a0f <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803a0f:	55                   	push   %rbp
  803a10:	48 89 e5             	mov    %rsp,%rbp
  803a13:	48 83 ec 50          	sub    $0x50,%rsp
  803a17:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803a1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a1e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803a22:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803a25:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803a29:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803a2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a31:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a3d:	74 21                	je     803a60 <map_segment+0x51>
		va -= i;
  803a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a42:	48 98                	cltq   
  803a44:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4b:	48 98                	cltq   
  803a4d:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a54:	48 98                	cltq   
  803a56:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5d:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a67:	e9 79 01 00 00       	jmpq   803be5 <map_segment+0x1d6>
		if (i >= filesz) {
  803a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6f:	48 98                	cltq   
  803a71:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a75:	72 3c                	jb     803ab3 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7a:	48 63 d0             	movslq %eax,%rdx
  803a7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a81:	48 01 d0             	add    %rdx,%rax
  803a84:	48 89 c1             	mov    %rax,%rcx
  803a87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a8a:	8b 55 10             	mov    0x10(%rbp),%edx
  803a8d:	48 89 ce             	mov    %rcx,%rsi
  803a90:	89 c7                	mov    %eax,%edi
  803a92:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
  803a9e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803aa1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803aa5:	0f 89 33 01 00 00    	jns    803bde <map_segment+0x1cf>
				return r;
  803aab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aae:	e9 46 01 00 00       	jmpq   803bf9 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ab3:	ba 07 00 00 00       	mov    $0x7,%edx
  803ab8:	be 00 00 40 00       	mov    $0x400000,%esi
  803abd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac2:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803ac9:	00 00 00 
  803acc:	ff d0                	callq  *%rax
  803ace:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ad1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ad5:	79 08                	jns    803adf <map_segment+0xd0>
				return r;
  803ad7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ada:	e9 1a 01 00 00       	jmpq   803bf9 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae2:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803ae5:	01 c2                	add    %eax,%edx
  803ae7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803aea:	89 d6                	mov    %edx,%esi
  803aec:	89 c7                	mov    %eax,%edi
  803aee:	48 b8 b0 2a 80 00 00 	movabs $0x802ab0,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	callq  *%rax
  803afa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803afd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b01:	79 08                	jns    803b0b <map_segment+0xfc>
				return r;
  803b03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b06:	e9 ee 00 00 00       	jmpq   803bf9 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803b0b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803b12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b15:	48 98                	cltq   
  803b17:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b1b:	48 29 c2             	sub    %rax,%rdx
  803b1e:	48 89 d0             	mov    %rdx,%rax
  803b21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b28:	48 63 d0             	movslq %eax,%rdx
  803b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b2f:	48 39 c2             	cmp    %rax,%rdx
  803b32:	48 0f 47 d0          	cmova  %rax,%rdx
  803b36:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b39:	be 00 00 40 00       	mov    $0x400000,%esi
  803b3e:	89 c7                	mov    %eax,%edi
  803b40:	48 b8 67 29 80 00 00 	movabs $0x802967,%rax
  803b47:	00 00 00 
  803b4a:	ff d0                	callq  *%rax
  803b4c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b4f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b53:	79 08                	jns    803b5d <map_segment+0x14e>
				return r;
  803b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b58:	e9 9c 00 00 00       	jmpq   803bf9 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b60:	48 63 d0             	movslq %eax,%rdx
  803b63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b67:	48 01 d0             	add    %rdx,%rax
  803b6a:	48 89 c2             	mov    %rax,%rdx
  803b6d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b70:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b74:	48 89 d1             	mov    %rdx,%rcx
  803b77:	89 c2                	mov    %eax,%edx
  803b79:	be 00 00 40 00       	mov    $0x400000,%esi
  803b7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b83:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
  803b8f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b92:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b96:	79 30                	jns    803bc8 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803b98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b9b:	89 c1                	mov    %eax,%ecx
  803b9d:	48 ba 03 52 80 00 00 	movabs $0x805203,%rdx
  803ba4:	00 00 00 
  803ba7:	be 24 01 00 00       	mov    $0x124,%esi
  803bac:	48 bf 88 51 80 00 00 	movabs $0x805188,%rdi
  803bb3:	00 00 00 
  803bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbb:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803bc2:	00 00 00 
  803bc5:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803bc8:	be 00 00 40 00       	mov    $0x400000,%esi
  803bcd:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd2:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803bd9:	00 00 00 
  803bdc:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803bde:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be8:	48 98                	cltq   
  803bea:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bee:	0f 82 78 fe ff ff    	jb     803a6c <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bf9:	c9                   	leaveq 
  803bfa:	c3                   	retq   

0000000000803bfb <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bfb:	55                   	push   %rbp
  803bfc:	48 89 e5             	mov    %rsp,%rbp
  803bff:	48 83 ec 20          	sub    $0x20,%rsp
  803c03:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803c06:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803c0d:	00 
  803c0e:	e9 c9 00 00 00       	jmpq   803cdc <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c17:	48 c1 e8 27          	shr    $0x27,%rax
  803c1b:	48 89 c2             	mov    %rax,%rdx
  803c1e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803c25:	01 00 00 
  803c28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c2c:	48 85 c0             	test   %rax,%rax
  803c2f:	74 3c                	je     803c6d <copy_shared_pages+0x72>
  803c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c35:	48 c1 e8 1e          	shr    $0x1e,%rax
  803c39:	48 89 c2             	mov    %rax,%rdx
  803c3c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c43:	01 00 00 
  803c46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4a:	48 85 c0             	test   %rax,%rax
  803c4d:	74 1e                	je     803c6d <copy_shared_pages+0x72>
  803c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c53:	48 c1 e8 15          	shr    $0x15,%rax
  803c57:	48 89 c2             	mov    %rax,%rdx
  803c5a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c61:	01 00 00 
  803c64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c68:	48 85 c0             	test   %rax,%rax
  803c6b:	75 02                	jne    803c6f <copy_shared_pages+0x74>
                continue;
  803c6d:	eb 65                	jmp    803cd4 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803c6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c73:	48 c1 e8 0c          	shr    $0xc,%rax
  803c77:	48 89 c2             	mov    %rax,%rdx
  803c7a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c81:	01 00 00 
  803c84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c88:	25 00 04 00 00       	and    $0x400,%eax
  803c8d:	48 85 c0             	test   %rax,%rax
  803c90:	74 42                	je     803cd4 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803c92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c96:	48 c1 e8 0c          	shr    $0xc,%rax
  803c9a:	48 89 c2             	mov    %rax,%rdx
  803c9d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ca4:	01 00 00 
  803ca7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cab:	25 07 0e 00 00       	and    $0xe07,%eax
  803cb0:	89 c6                	mov    %eax,%esi
  803cb2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803cb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cbd:	41 89 f0             	mov    %esi,%r8d
  803cc0:	48 89 c6             	mov    %rax,%rsi
  803cc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc8:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803cd4:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803cdb:	00 
  803cdc:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803ce3:	00 00 00 
  803ce6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803cea:	0f 86 23 ff ff ff    	jbe    803c13 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803cf0:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803cf5:	c9                   	leaveq 
  803cf6:	c3                   	retq   

0000000000803cf7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803cf7:	55                   	push   %rbp
  803cf8:	48 89 e5             	mov    %rsp,%rbp
  803cfb:	53                   	push   %rbx
  803cfc:	48 83 ec 38          	sub    $0x38,%rsp
  803d00:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d04:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d08:	48 89 c7             	mov    %rax,%rdi
  803d0b:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  803d12:	00 00 00 
  803d15:	ff d0                	callq  *%rax
  803d17:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d1e:	0f 88 bf 01 00 00    	js     803ee3 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d28:	ba 07 04 00 00       	mov    $0x407,%edx
  803d2d:	48 89 c6             	mov    %rax,%rsi
  803d30:	bf 00 00 00 00       	mov    $0x0,%edi
  803d35:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d48:	0f 88 95 01 00 00    	js     803ee3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d4e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d52:	48 89 c7             	mov    %rax,%rdi
  803d55:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  803d5c:	00 00 00 
  803d5f:	ff d0                	callq  *%rax
  803d61:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d64:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d68:	0f 88 5d 01 00 00    	js     803ecb <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d72:	ba 07 04 00 00       	mov    $0x407,%edx
  803d77:	48 89 c6             	mov    %rax,%rsi
  803d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7f:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d92:	0f 88 33 01 00 00    	js     803ecb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d9c:	48 89 c7             	mov    %rax,%rdi
  803d9f:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  803da6:	00 00 00 
  803da9:	ff d0                	callq  *%rax
  803dab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803daf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803db3:	ba 07 04 00 00       	mov    $0x407,%edx
  803db8:	48 89 c6             	mov    %rax,%rsi
  803dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc0:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803dc7:	00 00 00 
  803dca:	ff d0                	callq  *%rax
  803dcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd3:	79 05                	jns    803dda <pipe+0xe3>
		goto err2;
  803dd5:	e9 d9 00 00 00       	jmpq   803eb3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dda:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dde:	48 89 c7             	mov    %rax,%rdi
  803de1:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  803de8:	00 00 00 
  803deb:	ff d0                	callq  *%rax
  803ded:	48 89 c2             	mov    %rax,%rdx
  803df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803dfa:	48 89 d1             	mov    %rdx,%rcx
  803dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  803e02:	48 89 c6             	mov    %rax,%rsi
  803e05:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0a:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
  803e16:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e1d:	79 1b                	jns    803e3a <pipe+0x143>
		goto err3;
  803e1f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e24:	48 89 c6             	mov    %rax,%rsi
  803e27:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2c:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803e33:	00 00 00 
  803e36:	ff d0                	callq  *%rax
  803e38:	eb 79                	jmp    803eb3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803e45:	00 00 00 
  803e48:	8b 12                	mov    (%rdx),%edx
  803e4a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e5b:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803e62:	00 00 00 
  803e65:	8b 12                	mov    (%rdx),%edx
  803e67:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e6d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
  803e87:	89 c2                	mov    %eax,%edx
  803e89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e8d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803e8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e93:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9b:	48 89 c7             	mov    %rax,%rdi
  803e9e:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
  803eaa:	89 03                	mov    %eax,(%rbx)
	return 0;
  803eac:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb1:	eb 33                	jmp    803ee6 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803eb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb7:	48 89 c6             	mov    %rax,%rsi
  803eba:	bf 00 00 00 00       	mov    $0x0,%edi
  803ebf:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803ec6:	00 00 00 
  803ec9:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803ecb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ecf:	48 89 c6             	mov    %rax,%rsi
  803ed2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed7:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803ede:	00 00 00 
  803ee1:	ff d0                	callq  *%rax
    err:
	return r;
  803ee3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ee6:	48 83 c4 38          	add    $0x38,%rsp
  803eea:	5b                   	pop    %rbx
  803eeb:	5d                   	pop    %rbp
  803eec:	c3                   	retq   

0000000000803eed <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803eed:	55                   	push   %rbp
  803eee:	48 89 e5             	mov    %rsp,%rbp
  803ef1:	53                   	push   %rbx
  803ef2:	48 83 ec 28          	sub    $0x28,%rsp
  803ef6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803efa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803efe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f05:	00 00 00 
  803f08:	48 8b 00             	mov    (%rax),%rax
  803f0b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f11:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f18:	48 89 c7             	mov    %rax,%rdi
  803f1b:	48 b8 3a 49 80 00 00 	movabs $0x80493a,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
  803f27:	89 c3                	mov    %eax,%ebx
  803f29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f2d:	48 89 c7             	mov    %rax,%rdi
  803f30:	48 b8 3a 49 80 00 00 	movabs $0x80493a,%rax
  803f37:	00 00 00 
  803f3a:	ff d0                	callq  *%rax
  803f3c:	39 c3                	cmp    %eax,%ebx
  803f3e:	0f 94 c0             	sete   %al
  803f41:	0f b6 c0             	movzbl %al,%eax
  803f44:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f4e:	00 00 00 
  803f51:	48 8b 00             	mov    (%rax),%rax
  803f54:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f5a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f60:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f63:	75 05                	jne    803f6a <_pipeisclosed+0x7d>
			return ret;
  803f65:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f68:	eb 4f                	jmp    803fb9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f6d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f70:	74 42                	je     803fb4 <_pipeisclosed+0xc7>
  803f72:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803f76:	75 3c                	jne    803fb4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803f78:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f7f:	00 00 00 
  803f82:	48 8b 00             	mov    (%rax),%rax
  803f85:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803f8b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803f8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f91:	89 c6                	mov    %eax,%esi
  803f93:	48 bf 25 52 80 00 00 	movabs $0x805225,%rdi
  803f9a:	00 00 00 
  803f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa2:	49 b8 8f 05 80 00 00 	movabs $0x80058f,%r8
  803fa9:	00 00 00 
  803fac:	41 ff d0             	callq  *%r8
	}
  803faf:	e9 4a ff ff ff       	jmpq   803efe <_pipeisclosed+0x11>
  803fb4:	e9 45 ff ff ff       	jmpq   803efe <_pipeisclosed+0x11>
}
  803fb9:	48 83 c4 28          	add    $0x28,%rsp
  803fbd:	5b                   	pop    %rbx
  803fbe:	5d                   	pop    %rbp
  803fbf:	c3                   	retq   

0000000000803fc0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803fc0:	55                   	push   %rbp
  803fc1:	48 89 e5             	mov    %rsp,%rbp
  803fc4:	48 83 ec 30          	sub    $0x30,%rsp
  803fc8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fcb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fcf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fd2:	48 89 d6             	mov    %rdx,%rsi
  803fd5:	89 c7                	mov    %eax,%edi
  803fd7:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
  803fe3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fea:	79 05                	jns    803ff1 <pipeisclosed+0x31>
		return r;
  803fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fef:	eb 31                	jmp    804022 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ff5:	48 89 c7             	mov    %rax,%rdi
  803ff8:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
  804004:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80400c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804010:	48 89 d6             	mov    %rdx,%rsi
  804013:	48 89 c7             	mov    %rax,%rdi
  804016:	48 b8 ed 3e 80 00 00 	movabs $0x803eed,%rax
  80401d:	00 00 00 
  804020:	ff d0                	callq  *%rax
}
  804022:	c9                   	leaveq 
  804023:	c3                   	retq   

0000000000804024 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804024:	55                   	push   %rbp
  804025:	48 89 e5             	mov    %rsp,%rbp
  804028:	48 83 ec 40          	sub    $0x40,%rsp
  80402c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804030:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804034:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804038:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403c:	48 89 c7             	mov    %rax,%rdi
  80403f:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
  80404b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80404f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804053:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804057:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80405e:	00 
  80405f:	e9 92 00 00 00       	jmpq   8040f6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804064:	eb 41                	jmp    8040a7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804066:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80406b:	74 09                	je     804076 <devpipe_read+0x52>
				return i;
  80406d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804071:	e9 92 00 00 00       	jmpq   804108 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804076:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80407a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80407e:	48 89 d6             	mov    %rdx,%rsi
  804081:	48 89 c7             	mov    %rax,%rdi
  804084:	48 b8 ed 3e 80 00 00 	movabs $0x803eed,%rax
  80408b:	00 00 00 
  80408e:	ff d0                	callq  *%rax
  804090:	85 c0                	test   %eax,%eax
  804092:	74 07                	je     80409b <devpipe_read+0x77>
				return 0;
  804094:	b8 00 00 00 00       	mov    $0x0,%eax
  804099:	eb 6d                	jmp    804108 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80409b:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  8040a2:	00 00 00 
  8040a5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ab:	8b 10                	mov    (%rax),%edx
  8040ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b1:	8b 40 04             	mov    0x4(%rax),%eax
  8040b4:	39 c2                	cmp    %eax,%edx
  8040b6:	74 ae                	je     804066 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040c0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040c8:	8b 00                	mov    (%rax),%eax
  8040ca:	99                   	cltd   
  8040cb:	c1 ea 1b             	shr    $0x1b,%edx
  8040ce:	01 d0                	add    %edx,%eax
  8040d0:	83 e0 1f             	and    $0x1f,%eax
  8040d3:	29 d0                	sub    %edx,%eax
  8040d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040d9:	48 98                	cltq   
  8040db:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8040e0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8040e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e6:	8b 00                	mov    (%rax),%eax
  8040e8:	8d 50 01             	lea    0x1(%rax),%edx
  8040eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ef:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fa:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040fe:	0f 82 60 ff ff ff    	jb     804064 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804108:	c9                   	leaveq 
  804109:	c3                   	retq   

000000000080410a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80410a:	55                   	push   %rbp
  80410b:	48 89 e5             	mov    %rsp,%rbp
  80410e:	48 83 ec 40          	sub    $0x40,%rsp
  804112:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804116:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80411a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80411e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804122:	48 89 c7             	mov    %rax,%rdi
  804125:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  80412c:	00 00 00 
  80412f:	ff d0                	callq  *%rax
  804131:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804135:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804139:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80413d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804144:	00 
  804145:	e9 8e 00 00 00       	jmpq   8041d8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80414a:	eb 31                	jmp    80417d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80414c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804154:	48 89 d6             	mov    %rdx,%rsi
  804157:	48 89 c7             	mov    %rax,%rdi
  80415a:	48 b8 ed 3e 80 00 00 	movabs $0x803eed,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
  804166:	85 c0                	test   %eax,%eax
  804168:	74 07                	je     804171 <devpipe_write+0x67>
				return 0;
  80416a:	b8 00 00 00 00       	mov    $0x0,%eax
  80416f:	eb 79                	jmp    8041ea <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804171:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804178:	00 00 00 
  80417b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80417d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804181:	8b 40 04             	mov    0x4(%rax),%eax
  804184:	48 63 d0             	movslq %eax,%rdx
  804187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80418b:	8b 00                	mov    (%rax),%eax
  80418d:	48 98                	cltq   
  80418f:	48 83 c0 20          	add    $0x20,%rax
  804193:	48 39 c2             	cmp    %rax,%rdx
  804196:	73 b4                	jae    80414c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80419c:	8b 40 04             	mov    0x4(%rax),%eax
  80419f:	99                   	cltd   
  8041a0:	c1 ea 1b             	shr    $0x1b,%edx
  8041a3:	01 d0                	add    %edx,%eax
  8041a5:	83 e0 1f             	and    $0x1f,%eax
  8041a8:	29 d0                	sub    %edx,%eax
  8041aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041b2:	48 01 ca             	add    %rcx,%rdx
  8041b5:	0f b6 0a             	movzbl (%rdx),%ecx
  8041b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041bc:	48 98                	cltq   
  8041be:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c6:	8b 40 04             	mov    0x4(%rax),%eax
  8041c9:	8d 50 01             	lea    0x1(%rax),%edx
  8041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041dc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041e0:	0f 82 64 ff ff ff    	jb     80414a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8041e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041ea:	c9                   	leaveq 
  8041eb:	c3                   	retq   

00000000008041ec <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8041ec:	55                   	push   %rbp
  8041ed:	48 89 e5             	mov    %rsp,%rbp
  8041f0:	48 83 ec 20          	sub    $0x20,%rsp
  8041f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8041fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804200:	48 89 c7             	mov    %rax,%rdi
  804203:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  80420a:	00 00 00 
  80420d:	ff d0                	callq  *%rax
  80420f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804217:	48 be 38 52 80 00 00 	movabs $0x805238,%rsi
  80421e:	00 00 00 
  804221:	48 89 c7             	mov    %rax,%rdi
  804224:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  80422b:	00 00 00 
  80422e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804234:	8b 50 04             	mov    0x4(%rax),%edx
  804237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423b:	8b 00                	mov    (%rax),%eax
  80423d:	29 c2                	sub    %eax,%edx
  80423f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804243:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804249:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80424d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804254:	00 00 00 
	stat->st_dev = &devpipe;
  804257:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425b:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  804262:	00 00 00 
  804265:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80426c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804271:	c9                   	leaveq 
  804272:	c3                   	retq   

0000000000804273 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804273:	55                   	push   %rbp
  804274:	48 89 e5             	mov    %rsp,%rbp
  804277:	48 83 ec 10          	sub    $0x10,%rsp
  80427b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80427f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804283:	48 89 c6             	mov    %rax,%rsi
  804286:	bf 00 00 00 00       	mov    $0x0,%edi
  80428b:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804292:	00 00 00 
  804295:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429b:	48 89 c7             	mov    %rax,%rdi
  80429e:	48 b8 9d 23 80 00 00 	movabs $0x80239d,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
  8042aa:	48 89 c6             	mov    %rax,%rsi
  8042ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8042b2:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8042b9:	00 00 00 
  8042bc:	ff d0                	callq  *%rax
}
  8042be:	c9                   	leaveq 
  8042bf:	c3                   	retq   

00000000008042c0 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8042c0:	55                   	push   %rbp
  8042c1:	48 89 e5             	mov    %rsp,%rbp
  8042c4:	48 83 ec 20          	sub    $0x20,%rsp
  8042c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8042cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042cf:	75 35                	jne    804306 <wait+0x46>
  8042d1:	48 b9 3f 52 80 00 00 	movabs $0x80523f,%rcx
  8042d8:	00 00 00 
  8042db:	48 ba 4a 52 80 00 00 	movabs $0x80524a,%rdx
  8042e2:	00 00 00 
  8042e5:	be 09 00 00 00       	mov    $0x9,%esi
  8042ea:	48 bf 5f 52 80 00 00 	movabs $0x80525f,%rdi
  8042f1:	00 00 00 
  8042f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f9:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  804300:	00 00 00 
  804303:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804306:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804309:	25 ff 03 00 00       	and    $0x3ff,%eax
  80430e:	48 63 d0             	movslq %eax,%rdx
  804311:	48 89 d0             	mov    %rdx,%rax
  804314:	48 c1 e0 03          	shl    $0x3,%rax
  804318:	48 01 d0             	add    %rdx,%rax
  80431b:	48 c1 e0 05          	shl    $0x5,%rax
  80431f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804326:	00 00 00 
  804329:	48 01 d0             	add    %rdx,%rax
  80432c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804330:	eb 0c                	jmp    80433e <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804332:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804339:	00 00 00 
  80433c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80433e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804342:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804348:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80434b:	75 0e                	jne    80435b <wait+0x9b>
  80434d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804351:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804357:	85 c0                	test   %eax,%eax
  804359:	75 d7                	jne    804332 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80435b:	c9                   	leaveq 
  80435c:	c3                   	retq   

000000000080435d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80435d:	55                   	push   %rbp
  80435e:	48 89 e5             	mov    %rsp,%rbp
  804361:	48 83 ec 20          	sub    $0x20,%rsp
  804365:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80436b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80436e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804372:	be 01 00 00 00       	mov    $0x1,%esi
  804377:	48 89 c7             	mov    %rax,%rdi
  80437a:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  804381:	00 00 00 
  804384:	ff d0                	callq  *%rax
}
  804386:	c9                   	leaveq 
  804387:	c3                   	retq   

0000000000804388 <getchar>:

int
getchar(void)
{
  804388:	55                   	push   %rbp
  804389:	48 89 e5             	mov    %rsp,%rbp
  80438c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804390:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804394:	ba 01 00 00 00       	mov    $0x1,%edx
  804399:	48 89 c6             	mov    %rax,%rsi
  80439c:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a1:	48 b8 92 28 80 00 00 	movabs $0x802892,%rax
  8043a8:	00 00 00 
  8043ab:	ff d0                	callq  *%rax
  8043ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b4:	79 05                	jns    8043bb <getchar+0x33>
		return r;
  8043b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043b9:	eb 14                	jmp    8043cf <getchar+0x47>
	if (r < 1)
  8043bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043bf:	7f 07                	jg     8043c8 <getchar+0x40>
		return -E_EOF;
  8043c1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8043c6:	eb 07                	jmp    8043cf <getchar+0x47>
	return c;
  8043c8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8043cc:	0f b6 c0             	movzbl %al,%eax
}
  8043cf:	c9                   	leaveq 
  8043d0:	c3                   	retq   

00000000008043d1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8043d1:	55                   	push   %rbp
  8043d2:	48 89 e5             	mov    %rsp,%rbp
  8043d5:	48 83 ec 20          	sub    $0x20,%rsp
  8043d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8043dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8043e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043e3:	48 89 d6             	mov    %rdx,%rsi
  8043e6:	89 c7                	mov    %eax,%edi
  8043e8:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8043ef:	00 00 00 
  8043f2:	ff d0                	callq  *%rax
  8043f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043fb:	79 05                	jns    804402 <iscons+0x31>
		return r;
  8043fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804400:	eb 1a                	jmp    80441c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804406:	8b 10                	mov    (%rax),%edx
  804408:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80440f:	00 00 00 
  804412:	8b 00                	mov    (%rax),%eax
  804414:	39 c2                	cmp    %eax,%edx
  804416:	0f 94 c0             	sete   %al
  804419:	0f b6 c0             	movzbl %al,%eax
}
  80441c:	c9                   	leaveq 
  80441d:	c3                   	retq   

000000000080441e <opencons>:

int
opencons(void)
{
  80441e:	55                   	push   %rbp
  80441f:	48 89 e5             	mov    %rsp,%rbp
  804422:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804426:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80442a:	48 89 c7             	mov    %rax,%rdi
  80442d:	48 b8 c8 23 80 00 00 	movabs $0x8023c8,%rax
  804434:	00 00 00 
  804437:	ff d0                	callq  *%rax
  804439:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80443c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804440:	79 05                	jns    804447 <opencons+0x29>
		return r;
  804442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804445:	eb 5b                	jmp    8044a2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80444b:	ba 07 04 00 00       	mov    $0x407,%edx
  804450:	48 89 c6             	mov    %rax,%rsi
  804453:	bf 00 00 00 00       	mov    $0x0,%edi
  804458:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80445f:	00 00 00 
  804462:	ff d0                	callq  *%rax
  804464:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804467:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446b:	79 05                	jns    804472 <opencons+0x54>
		return r;
  80446d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804470:	eb 30                	jmp    8044a2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804476:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80447d:	00 00 00 
  804480:	8b 12                	mov    (%rdx),%edx
  804482:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804488:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80448f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804493:	48 89 c7             	mov    %rax,%rdi
  804496:	48 b8 7a 23 80 00 00 	movabs $0x80237a,%rax
  80449d:	00 00 00 
  8044a0:	ff d0                	callq  *%rax
}
  8044a2:	c9                   	leaveq 
  8044a3:	c3                   	retq   

00000000008044a4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044a4:	55                   	push   %rbp
  8044a5:	48 89 e5             	mov    %rsp,%rbp
  8044a8:	48 83 ec 30          	sub    $0x30,%rsp
  8044ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044b8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044bd:	75 07                	jne    8044c6 <devcons_read+0x22>
		return 0;
  8044bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8044c4:	eb 4b                	jmp    804511 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8044c6:	eb 0c                	jmp    8044d4 <devcons_read+0x30>
		sys_yield();
  8044c8:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  8044cf:	00 00 00 
  8044d2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8044d4:	48 b8 75 19 80 00 00 	movabs $0x801975,%rax
  8044db:	00 00 00 
  8044de:	ff d0                	callq  *%rax
  8044e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e7:	74 df                	je     8044c8 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8044e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ed:	79 05                	jns    8044f4 <devcons_read+0x50>
		return c;
  8044ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f2:	eb 1d                	jmp    804511 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8044f4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8044f8:	75 07                	jne    804501 <devcons_read+0x5d>
		return 0;
  8044fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ff:	eb 10                	jmp    804511 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804504:	89 c2                	mov    %eax,%edx
  804506:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80450a:	88 10                	mov    %dl,(%rax)
	return 1;
  80450c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804511:	c9                   	leaveq 
  804512:	c3                   	retq   

0000000000804513 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804513:	55                   	push   %rbp
  804514:	48 89 e5             	mov    %rsp,%rbp
  804517:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80451e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804525:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80452c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804533:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80453a:	eb 76                	jmp    8045b2 <devcons_write+0x9f>
		m = n - tot;
  80453c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804543:	89 c2                	mov    %eax,%edx
  804545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804548:	29 c2                	sub    %eax,%edx
  80454a:	89 d0                	mov    %edx,%eax
  80454c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80454f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804552:	83 f8 7f             	cmp    $0x7f,%eax
  804555:	76 07                	jbe    80455e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804557:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80455e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804561:	48 63 d0             	movslq %eax,%rdx
  804564:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804567:	48 63 c8             	movslq %eax,%rcx
  80456a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804571:	48 01 c1             	add    %rax,%rcx
  804574:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80457b:	48 89 ce             	mov    %rcx,%rsi
  80457e:	48 89 c7             	mov    %rax,%rdi
  804581:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804588:	00 00 00 
  80458b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80458d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804590:	48 63 d0             	movslq %eax,%rdx
  804593:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80459a:	48 89 d6             	mov    %rdx,%rsi
  80459d:	48 89 c7             	mov    %rax,%rdi
  8045a0:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  8045a7:	00 00 00 
  8045aa:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045af:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b5:	48 98                	cltq   
  8045b7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045be:	0f 82 78 ff ff ff    	jb     80453c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8045c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8045c7:	c9                   	leaveq 
  8045c8:	c3                   	retq   

00000000008045c9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8045c9:	55                   	push   %rbp
  8045ca:	48 89 e5             	mov    %rsp,%rbp
  8045cd:	48 83 ec 08          	sub    $0x8,%rsp
  8045d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8045d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045da:	c9                   	leaveq 
  8045db:	c3                   	retq   

00000000008045dc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8045dc:	55                   	push   %rbp
  8045dd:	48 89 e5             	mov    %rsp,%rbp
  8045e0:	48 83 ec 10          	sub    $0x10,%rsp
  8045e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8045ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f0:	48 be 6f 52 80 00 00 	movabs $0x80526f,%rsi
  8045f7:	00 00 00 
  8045fa:	48 89 c7             	mov    %rax,%rdi
  8045fd:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  804604:	00 00 00 
  804607:	ff d0                	callq  *%rax
	return 0;
  804609:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80460e:	c9                   	leaveq 
  80460f:	c3                   	retq   

0000000000804610 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804610:	55                   	push   %rbp
  804611:	48 89 e5             	mov    %rsp,%rbp
  804614:	48 83 ec 10          	sub    $0x10,%rsp
  804618:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80461c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804623:	00 00 00 
  804626:	48 8b 00             	mov    (%rax),%rax
  804629:	48 85 c0             	test   %rax,%rax
  80462c:	0f 85 84 00 00 00    	jne    8046b6 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804632:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804639:	00 00 00 
  80463c:	48 8b 00             	mov    (%rax),%rax
  80463f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804645:	ba 07 00 00 00       	mov    $0x7,%edx
  80464a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80464f:	89 c7                	mov    %eax,%edi
  804651:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804658:	00 00 00 
  80465b:	ff d0                	callq  *%rax
  80465d:	85 c0                	test   %eax,%eax
  80465f:	79 2a                	jns    80468b <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804661:	48 ba 78 52 80 00 00 	movabs $0x805278,%rdx
  804668:	00 00 00 
  80466b:	be 23 00 00 00       	mov    $0x23,%esi
  804670:	48 bf 9f 52 80 00 00 	movabs $0x80529f,%rdi
  804677:	00 00 00 
  80467a:	b8 00 00 00 00       	mov    $0x0,%eax
  80467f:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  804686:	00 00 00 
  804689:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80468b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804692:	00 00 00 
  804695:	48 8b 00             	mov    (%rax),%rax
  804698:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80469e:	48 be c9 46 80 00 00 	movabs $0x8046c9,%rsi
  8046a5:	00 00 00 
  8046a8:	89 c7                	mov    %eax,%edi
  8046aa:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  8046b1:	00 00 00 
  8046b4:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8046b6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8046bd:	00 00 00 
  8046c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046c4:	48 89 10             	mov    %rdx,(%rax)
}
  8046c7:	c9                   	leaveq 
  8046c8:	c3                   	retq   

00000000008046c9 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8046c9:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8046cc:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8046d3:	00 00 00 
	call *%rax
  8046d6:	ff d0                	callq  *%rax


	/*This code is to be removed*/

	// LAB 4: Your code here.
	movq 136(%rsp), %rbx  //Load RIP 
  8046d8:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8046df:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8046e0:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8046e7:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8046e8:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8046ec:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8046ef:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8046f6:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8046f7:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8046fb:	4c 8b 3c 24          	mov    (%rsp),%r15
  8046ff:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804704:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804709:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80470e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804713:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804718:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80471d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804722:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804727:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80472c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804731:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804736:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80473b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804740:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804745:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804749:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80474d:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80474e:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80474f:	c3                   	retq   

0000000000804750 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804750:	55                   	push   %rbp
  804751:	48 89 e5             	mov    %rsp,%rbp
  804754:	48 83 ec 30          	sub    $0x30,%rsp
  804758:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80475c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804760:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804764:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80476b:	00 00 00 
  80476e:	48 8b 00             	mov    (%rax),%rax
  804771:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804777:	85 c0                	test   %eax,%eax
  804779:	75 3c                	jne    8047b7 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80477b:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
  804787:	25 ff 03 00 00       	and    $0x3ff,%eax
  80478c:	48 63 d0             	movslq %eax,%rdx
  80478f:	48 89 d0             	mov    %rdx,%rax
  804792:	48 c1 e0 03          	shl    $0x3,%rax
  804796:	48 01 d0             	add    %rdx,%rax
  804799:	48 c1 e0 05          	shl    $0x5,%rax
  80479d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8047a4:	00 00 00 
  8047a7:	48 01 c2             	add    %rax,%rdx
  8047aa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8047b1:	00 00 00 
  8047b4:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8047b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047bc:	75 0e                	jne    8047cc <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8047be:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047c5:	00 00 00 
  8047c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8047cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047d0:	48 89 c7             	mov    %rax,%rdi
  8047d3:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  8047da:	00 00 00 
  8047dd:	ff d0                	callq  *%rax
  8047df:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8047e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047e6:	79 19                	jns    804801 <ipc_recv+0xb1>
		*from_env_store = 0;
  8047e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ec:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8047f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8047fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ff:	eb 53                	jmp    804854 <ipc_recv+0x104>
	}
	if(from_env_store)
  804801:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804806:	74 19                	je     804821 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  804808:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80480f:	00 00 00 
  804812:	48 8b 00             	mov    (%rax),%rax
  804815:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80481b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80481f:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804821:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804826:	74 19                	je     804841 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804828:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80482f:	00 00 00 
  804832:	48 8b 00             	mov    (%rax),%rax
  804835:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80483b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80483f:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804841:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804848:	00 00 00 
  80484b:	48 8b 00             	mov    (%rax),%rax
  80484e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804854:	c9                   	leaveq 
  804855:	c3                   	retq   

0000000000804856 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804856:	55                   	push   %rbp
  804857:	48 89 e5             	mov    %rsp,%rbp
  80485a:	48 83 ec 30          	sub    $0x30,%rsp
  80485e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804861:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804864:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804868:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80486b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804870:	75 0e                	jne    804880 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804872:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804879:	00 00 00 
  80487c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804880:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804883:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804886:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80488a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80488d:	89 c7                	mov    %eax,%edi
  80488f:	48 b8 47 1c 80 00 00 	movabs $0x801c47,%rax
  804896:	00 00 00 
  804899:	ff d0                	callq  *%rax
  80489b:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80489e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048a2:	75 0c                	jne    8048b0 <ipc_send+0x5a>
			sys_yield();
  8048a4:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  8048ab:	00 00 00 
  8048ae:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8048b0:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048b4:	74 ca                	je     804880 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8048b6:	c9                   	leaveq 
  8048b7:	c3                   	retq   

00000000008048b8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8048b8:	55                   	push   %rbp
  8048b9:	48 89 e5             	mov    %rsp,%rbp
  8048bc:	48 83 ec 14          	sub    $0x14,%rsp
  8048c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8048c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048ca:	eb 5e                	jmp    80492a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048cc:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048d3:	00 00 00 
  8048d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d9:	48 63 d0             	movslq %eax,%rdx
  8048dc:	48 89 d0             	mov    %rdx,%rax
  8048df:	48 c1 e0 03          	shl    $0x3,%rax
  8048e3:	48 01 d0             	add    %rdx,%rax
  8048e6:	48 c1 e0 05          	shl    $0x5,%rax
  8048ea:	48 01 c8             	add    %rcx,%rax
  8048ed:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048f3:	8b 00                	mov    (%rax),%eax
  8048f5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048f8:	75 2c                	jne    804926 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048fa:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804901:	00 00 00 
  804904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804907:	48 63 d0             	movslq %eax,%rdx
  80490a:	48 89 d0             	mov    %rdx,%rax
  80490d:	48 c1 e0 03          	shl    $0x3,%rax
  804911:	48 01 d0             	add    %rdx,%rax
  804914:	48 c1 e0 05          	shl    $0x5,%rax
  804918:	48 01 c8             	add    %rcx,%rax
  80491b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804921:	8b 40 08             	mov    0x8(%rax),%eax
  804924:	eb 12                	jmp    804938 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804926:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80492a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804931:	7e 99                	jle    8048cc <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804938:	c9                   	leaveq 
  804939:	c3                   	retq   

000000000080493a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80493a:	55                   	push   %rbp
  80493b:	48 89 e5             	mov    %rsp,%rbp
  80493e:	48 83 ec 18          	sub    $0x18,%rsp
  804942:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80494a:	48 c1 e8 15          	shr    $0x15,%rax
  80494e:	48 89 c2             	mov    %rax,%rdx
  804951:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804958:	01 00 00 
  80495b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80495f:	83 e0 01             	and    $0x1,%eax
  804962:	48 85 c0             	test   %rax,%rax
  804965:	75 07                	jne    80496e <pageref+0x34>
		return 0;
  804967:	b8 00 00 00 00       	mov    $0x0,%eax
  80496c:	eb 53                	jmp    8049c1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80496e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804972:	48 c1 e8 0c          	shr    $0xc,%rax
  804976:	48 89 c2             	mov    %rax,%rdx
  804979:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804980:	01 00 00 
  804983:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804987:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80498b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80498f:	83 e0 01             	and    $0x1,%eax
  804992:	48 85 c0             	test   %rax,%rax
  804995:	75 07                	jne    80499e <pageref+0x64>
		return 0;
  804997:	b8 00 00 00 00       	mov    $0x0,%eax
  80499c:	eb 23                	jmp    8049c1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80499e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8049a6:	48 89 c2             	mov    %rax,%rdx
  8049a9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049b0:	00 00 00 
  8049b3:	48 c1 e2 04          	shl    $0x4,%rdx
  8049b7:	48 01 d0             	add    %rdx,%rax
  8049ba:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049be:	0f b7 c0             	movzwl %ax,%eax
}
  8049c1:	c9                   	leaveq 
  8049c2:	c3                   	retq   
