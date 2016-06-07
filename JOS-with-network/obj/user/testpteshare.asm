
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
  80008d:	48 ba 9e 54 80 00 00 	movabs $0x80549e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 93 21 80 00 00 	movabs $0x802193,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba c5 54 80 00 00 	movabs $0x8054c5,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
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
  800135:	48 b8 71 4d 80 00 00 	movabs $0x804d71,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 d4 54 80 00 00 	movabs $0x8054d4,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf da 54 80 00 00 	movabs $0x8054da,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba f5 54 80 00 00 	movabs $0x8054f5,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be f9 54 80 00 00 	movabs $0x8054f9,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 06 55 80 00 00 	movabs $0x805506,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 a3 37 80 00 00 	movabs $0x8037a3,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 18 55 80 00 00 	movabs $0x805518,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf b1 54 80 00 00 	movabs $0x8054b1,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 71 4d 80 00 00 	movabs $0x804d71,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 a6 12 80 00 00 	movabs $0x8012a6,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 d4 54 80 00 00 	movabs $0x8054d4,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 22 55 80 00 00 	movabs $0x805522,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

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
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
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
  8002e6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
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
  800300:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
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
  800337:	48 b8 85 27 80 00 00 	movabs $0x802785,%rax
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
  8003df:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
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
  800410:	48 bf 48 55 80 00 00 	movabs $0x805548,%rdi
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
  80044c:	48 bf 6b 55 80 00 00 	movabs $0x80556b,%rdi
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
  8006fb:	48 ba 70 57 80 00 00 	movabs $0x805770,%rdx
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
  8009f3:	48 b8 98 57 80 00 00 	movabs $0x805798,%rax
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
  800b41:	83 fb 15             	cmp    $0x15,%ebx
  800b44:	7f 16                	jg     800b5c <vprintfmt+0x21a>
  800b46:	48 b8 c0 56 80 00 00 	movabs $0x8056c0,%rax
  800b4d:	00 00 00 
  800b50:	48 63 d3             	movslq %ebx,%rdx
  800b53:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b57:	4d 85 e4             	test   %r12,%r12
  800b5a:	75 2e                	jne    800b8a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b64:	89 d9                	mov    %ebx,%ecx
  800b66:	48 ba 81 57 80 00 00 	movabs $0x805781,%rdx
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
  800b95:	48 ba 8a 57 80 00 00 	movabs $0x80578a,%rdx
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
  800bef:	49 bc 8d 57 80 00 00 	movabs $0x80578d,%r12
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
  8018f5:	48 ba 48 5a 80 00 00 	movabs $0x805a48,%rdx
  8018fc:	00 00 00 
  8018ff:	be 23 00 00 00       	mov    $0x23,%esi
  801904:	48 bf 65 5a 80 00 00 	movabs $0x805a65,%rdi
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

0000000000801ce0 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 20          	sub    $0x20,%rsp
  801ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cff:	00 
  801d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d11:	89 c6                	mov    %eax,%esi
  801d13:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d18:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	callq  *%rax
}
  801d24:	c9                   	leaveq 
  801d25:	c3                   	retq   

0000000000801d26 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
  801d2a:	48 83 ec 20          	sub    $0x20,%rsp
  801d2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d45:	00 
  801d46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d57:	89 c6                	mov    %eax,%esi
  801d59:	bf 10 00 00 00       	mov    $0x10,%edi
  801d5e:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7b:	00 
  801d7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	be 00 00 00 00       	mov    $0x0,%esi
  801d97:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d9c:	48 b8 9d 18 80 00 00 	movabs $0x80189d,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
}
  801da8:	c9                   	leaveq 
  801da9:	c3                   	retq   

0000000000801daa <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801daa:	55                   	push   %rbp
  801dab:	48 89 e5             	mov    %rsp,%rbp
  801dae:	48 83 ec 30          	sub    $0x30,%rsp
  801db2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801db6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dba:	48 8b 00             	mov    (%rax),%rax
  801dbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc5:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dc9:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801dcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dcf:	83 e0 02             	and    $0x2,%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	75 4d                	jne    801e23 <pgfault+0x79>
  801dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dda:	48 c1 e8 0c          	shr    $0xc,%rax
  801dde:	48 89 c2             	mov    %rax,%rdx
  801de1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de8:	01 00 00 
  801deb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801def:	25 00 08 00 00       	and    $0x800,%eax
  801df4:	48 85 c0             	test   %rax,%rax
  801df7:	74 2a                	je     801e23 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801df9:	48 ba 78 5a 80 00 00 	movabs $0x805a78,%rdx
  801e00:	00 00 00 
  801e03:	be 23 00 00 00       	mov    $0x23,%esi
  801e08:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801e0f:	00 00 00 
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
  801e17:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801e1e:	00 00 00 
  801e21:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801e23:	ba 07 00 00 00       	mov    $0x7,%edx
  801e28:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e32:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	0f 85 cd 00 00 00    	jne    801f13 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e52:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801e5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e60:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e65:	48 89 c6             	mov    %rax,%rsi
  801e68:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801e6d:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e83:	48 89 c1             	mov    %rax,%rcx
  801e86:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e90:	bf 00 00 00 00       	mov    $0x0,%edi
  801e95:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	79 2a                	jns    801ecf <pgfault+0x125>
				panic("Page map at temp address failed");
  801ea5:	48 ba b8 5a 80 00 00 	movabs $0x805ab8,%rdx
  801eac:	00 00 00 
  801eaf:	be 30 00 00 00       	mov    $0x30,%esi
  801eb4:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801ebb:	00 00 00 
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801eca:	00 00 00 
  801ecd:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801ecf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ed4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed9:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	callq  *%rax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	79 54                	jns    801f3d <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801ee9:	48 ba d8 5a 80 00 00 	movabs $0x805ad8,%rdx
  801ef0:	00 00 00 
  801ef3:	be 32 00 00 00       	mov    $0x32,%esi
  801ef8:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801eff:	00 00 00 
  801f02:	b8 00 00 00 00       	mov    $0x0,%eax
  801f07:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f0e:	00 00 00 
  801f11:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801f13:	48 ba 00 5b 80 00 00 	movabs $0x805b00,%rdx
  801f1a:	00 00 00 
  801f1d:	be 34 00 00 00       	mov    $0x34,%esi
  801f22:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801f29:	00 00 00 
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f31:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801f38:	00 00 00 
  801f3b:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801f3d:	c9                   	leaveq 
  801f3e:	c3                   	retq   

0000000000801f3f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f3f:	55                   	push   %rbp
  801f40:	48 89 e5             	mov    %rsp,%rbp
  801f43:	48 83 ec 20          	sub    $0x20,%rsp
  801f47:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f4a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801f4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f54:	01 00 00 
  801f57:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5e:	25 07 0e 00 00       	and    $0xe07,%eax
  801f63:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801f66:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f69:	48 c1 e0 0c          	shl    $0xc,%rax
  801f6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801f71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f74:	25 00 04 00 00       	and    $0x400,%eax
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	74 57                	je     801fd4 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f7d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f80:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f84:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8b:	41 89 f0             	mov    %esi,%r8d
  801f8e:	48 89 c6             	mov    %rax,%rsi
  801f91:	bf 00 00 00 00       	mov    $0x0,%edi
  801f96:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	0f 8e 52 01 00 00    	jle    8020fc <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801faa:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  801fb1:	00 00 00 
  801fb4:	be 4e 00 00 00       	mov    $0x4e,%esi
  801fb9:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  801fc0:	00 00 00 
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  801fcf:	00 00 00 
  801fd2:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd7:	83 e0 02             	and    $0x2,%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	75 10                	jne    801fee <duppage+0xaf>
  801fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe1:	25 00 08 00 00       	and    $0x800,%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	0f 84 bb 00 00 00    	je     8020a9 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff1:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801ff6:	80 cc 08             	or     $0x8,%ah
  801ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ffc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801fff:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802003:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200a:	41 89 f0             	mov    %esi,%r8d
  80200d:	48 89 c6             	mov    %rax,%rsi
  802010:	bf 00 00 00 00       	mov    $0x0,%edi
  802015:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80201c:	00 00 00 
  80201f:	ff d0                	callq  *%rax
  802021:	85 c0                	test   %eax,%eax
  802023:	7e 2a                	jle    80204f <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802025:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  80202c:	00 00 00 
  80202f:	be 55 00 00 00       	mov    $0x55,%esi
  802034:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  80203b:	00 00 00 
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  80204a:	00 00 00 
  80204d:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  80204f:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802052:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205a:	41 89 c8             	mov    %ecx,%r8d
  80205d:	48 89 d1             	mov    %rdx,%rcx
  802060:	ba 00 00 00 00       	mov    $0x0,%edx
  802065:	48 89 c6             	mov    %rax,%rsi
  802068:	bf 00 00 00 00       	mov    $0x0,%edi
  80206d:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	85 c0                	test   %eax,%eax
  80207b:	7e 2a                	jle    8020a7 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80207d:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  802084:	00 00 00 
  802087:	be 57 00 00 00       	mov    $0x57,%esi
  80208c:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  802093:	00 00 00 
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  8020a2:	00 00 00 
  8020a5:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8020a7:	eb 53                	jmp    8020fc <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8020a9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8020ac:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8020b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020b7:	41 89 f0             	mov    %esi,%r8d
  8020ba:	48 89 c6             	mov    %rax,%rsi
  8020bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c2:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	7e 2a                	jle    8020fc <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8020d2:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  8020d9:	00 00 00 
  8020dc:	be 5b 00 00 00       	mov    $0x5b,%esi
  8020e1:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  8020e8:	00 00 00 
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  8020f7:	00 00 00 
  8020fa:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 18          	sub    $0x18,%rsp
  80210b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211b:	48 c1 e8 27          	shr    $0x27,%rax
  80211f:	48 89 c2             	mov    %rax,%rdx
  802122:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802129:	01 00 00 
  80212c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802130:	83 e0 01             	and    $0x1,%eax
  802133:	48 85 c0             	test   %rax,%rax
  802136:	74 51                	je     802189 <pt_is_mapped+0x86>
  802138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213c:	48 c1 e0 0c          	shl    $0xc,%rax
  802140:	48 c1 e8 1e          	shr    $0x1e,%rax
  802144:	48 89 c2             	mov    %rax,%rdx
  802147:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80214e:	01 00 00 
  802151:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802155:	83 e0 01             	and    $0x1,%eax
  802158:	48 85 c0             	test   %rax,%rax
  80215b:	74 2c                	je     802189 <pt_is_mapped+0x86>
  80215d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802161:	48 c1 e0 0c          	shl    $0xc,%rax
  802165:	48 c1 e8 15          	shr    $0x15,%rax
  802169:	48 89 c2             	mov    %rax,%rdx
  80216c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802173:	01 00 00 
  802176:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217a:	83 e0 01             	and    $0x1,%eax
  80217d:	48 85 c0             	test   %rax,%rax
  802180:	74 07                	je     802189 <pt_is_mapped+0x86>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	eb 05                	jmp    80218e <pt_is_mapped+0x8b>
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	83 e0 01             	and    $0x1,%eax
}
  802191:	c9                   	leaveq 
  802192:	c3                   	retq   

0000000000802193 <fork>:

envid_t
fork(void)
{
  802193:	55                   	push   %rbp
  802194:	48 89 e5             	mov    %rsp,%rbp
  802197:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80219b:	48 bf aa 1d 80 00 00 	movabs $0x801daa,%rdi
  8021a2:	00 00 00 
  8021a5:	48 b8 c1 50 80 00 00 	movabs $0x8050c1,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021b1:	b8 07 00 00 00       	mov    $0x7,%eax
  8021b6:	cd 30                	int    $0x30
  8021b8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8021be:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8021c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021c5:	79 30                	jns    8021f7 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8021c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021ca:	89 c1                	mov    %eax,%ecx
  8021cc:	48 ba 50 5b 80 00 00 	movabs $0x805b50,%rdx
  8021d3:	00 00 00 
  8021d6:	be 86 00 00 00       	mov    $0x86,%esi
  8021db:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  8021e2:	00 00 00 
  8021e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ea:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8021f1:	00 00 00 
  8021f4:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021fb:	75 46                	jne    802243 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8021fd:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802204:	00 00 00 
  802207:	ff d0                	callq  *%rax
  802209:	25 ff 03 00 00       	and    $0x3ff,%eax
  80220e:	48 63 d0             	movslq %eax,%rdx
  802211:	48 89 d0             	mov    %rdx,%rax
  802214:	48 c1 e0 03          	shl    $0x3,%rax
  802218:	48 01 d0             	add    %rdx,%rax
  80221b:	48 c1 e0 05          	shl    $0x5,%rax
  80221f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802226:	00 00 00 
  802229:	48 01 c2             	add    %rax,%rdx
  80222c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802233:	00 00 00 
  802236:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802239:	b8 00 00 00 00       	mov    $0x0,%eax
  80223e:	e9 d1 01 00 00       	jmpq   802414 <fork+0x281>
	}
	uint64_t ad = 0;
  802243:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80224a:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80224b:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802250:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802254:	e9 df 00 00 00       	jmpq   802338 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225d:	48 c1 e8 27          	shr    $0x27,%rax
  802261:	48 89 c2             	mov    %rax,%rdx
  802264:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80226b:	01 00 00 
  80226e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802272:	83 e0 01             	and    $0x1,%eax
  802275:	48 85 c0             	test   %rax,%rax
  802278:	0f 84 9e 00 00 00    	je     80231c <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80227e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802282:	48 c1 e8 1e          	shr    $0x1e,%rax
  802286:	48 89 c2             	mov    %rax,%rdx
  802289:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802290:	01 00 00 
  802293:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802297:	83 e0 01             	and    $0x1,%eax
  80229a:	48 85 c0             	test   %rax,%rax
  80229d:	74 73                	je     802312 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80229f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a3:	48 c1 e8 15          	shr    $0x15,%rax
  8022a7:	48 89 c2             	mov    %rax,%rdx
  8022aa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b1:	01 00 00 
  8022b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b8:	83 e0 01             	and    $0x1,%eax
  8022bb:	48 85 c0             	test   %rax,%rax
  8022be:	74 48                	je     802308 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8022c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8022c8:	48 89 c2             	mov    %rax,%rdx
  8022cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d2:	01 00 00 
  8022d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	83 e0 01             	and    $0x1,%eax
  8022e4:	48 85 c0             	test   %rax,%rax
  8022e7:	74 47                	je     802330 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8022e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f1:	89 c2                	mov    %eax,%edx
  8022f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022f6:	89 d6                	mov    %edx,%esi
  8022f8:	89 c7                	mov    %eax,%edi
  8022fa:	48 b8 3f 1f 80 00 00 	movabs $0x801f3f,%rax
  802301:	00 00 00 
  802304:	ff d0                	callq  *%rax
  802306:	eb 28                	jmp    802330 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802308:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  80230f:	00 
  802310:	eb 1e                	jmp    802330 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802312:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802319:	40 
  80231a:	eb 14                	jmp    802330 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80231c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802320:	48 c1 e8 27          	shr    $0x27,%rax
  802324:	48 83 c0 01          	add    $0x1,%rax
  802328:	48 c1 e0 27          	shl    $0x27,%rax
  80232c:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802330:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802337:	00 
  802338:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80233f:	00 
  802340:	0f 87 13 ff ff ff    	ja     802259 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802346:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802349:	ba 07 00 00 00       	mov    $0x7,%edx
  80234e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802353:	89 c7                	mov    %eax,%edi
  802355:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  80235c:	00 00 00 
  80235f:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802361:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802364:	ba 07 00 00 00       	mov    $0x7,%edx
  802369:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80236e:	89 c7                	mov    %eax,%edi
  802370:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  80237c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80237f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802385:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80238a:	ba 00 00 00 00       	mov    $0x0,%edx
  80238f:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8023a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023a7:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8023ac:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8023b1:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8023b8:	00 00 00 
  8023bb:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8023bd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c7:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8023d3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023da:	00 00 00 
  8023dd:	48 8b 00             	mov    (%rax),%rax
  8023e0:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8023e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023ea:	48 89 d6             	mov    %rdx,%rsi
  8023ed:	89 c7                	mov    %eax,%edi
  8023ef:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8023fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8023fe:	be 02 00 00 00       	mov    $0x2,%esi
  802403:	89 c7                	mov    %eax,%edi
  802405:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  80240c:	00 00 00 
  80240f:	ff d0                	callq  *%rax

	return envid;
  802411:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802414:	c9                   	leaveq 
  802415:	c3                   	retq   

0000000000802416 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802416:	55                   	push   %rbp
  802417:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80241a:	48 ba 68 5b 80 00 00 	movabs $0x805b68,%rdx
  802421:	00 00 00 
  802424:	be bf 00 00 00       	mov    $0xbf,%esi
  802429:	48 bf ad 5a 80 00 00 	movabs $0x805aad,%rdi
  802430:	00 00 00 
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  80243f:	00 00 00 
  802442:	ff d1                	callq  *%rcx

0000000000802444 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802444:	55                   	push   %rbp
  802445:	48 89 e5             	mov    %rsp,%rbp
  802448:	48 83 ec 08          	sub    $0x8,%rsp
  80244c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802450:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802454:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80245b:	ff ff ff 
  80245e:	48 01 d0             	add    %rdx,%rax
  802461:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	48 83 ec 08          	sub    $0x8,%rsp
  80246f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802477:	48 89 c7             	mov    %rax,%rdi
  80247a:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
  802486:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80248c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 18          	sub    $0x18,%rsp
  80249a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80249e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a5:	eb 6b                	jmp    802512 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024aa:	48 98                	cltq   
  8024ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 c1 e8 15          	shr    $0x15,%rax
  8024c2:	48 89 c2             	mov    %rax,%rdx
  8024c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024cc:	01 00 00 
  8024cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d3:	83 e0 01             	and    $0x1,%eax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	74 21                	je     8024fc <fd_alloc+0x6a>
  8024db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024df:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e3:	48 89 c2             	mov    %rax,%rdx
  8024e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ed:	01 00 00 
  8024f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f4:	83 e0 01             	and    $0x1,%eax
  8024f7:	48 85 c0             	test   %rax,%rax
  8024fa:	75 12                	jne    80250e <fd_alloc+0x7c>
			*fd_store = fd;
  8024fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802500:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802504:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802507:	b8 00 00 00 00       	mov    $0x0,%eax
  80250c:	eb 1a                	jmp    802528 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80250e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802512:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802516:	7e 8f                	jle    8024a7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802523:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802528:	c9                   	leaveq 
  802529:	c3                   	retq   

000000000080252a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 20          	sub    $0x20,%rsp
  802532:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802535:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802539:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80253d:	78 06                	js     802545 <fd_lookup+0x1b>
  80253f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802543:	7e 07                	jle    80254c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802545:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80254a:	eb 6c                	jmp    8025b8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80254c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254f:	48 98                	cltq   
  802551:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802557:	48 c1 e0 0c          	shl    $0xc,%rax
  80255b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80255f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802563:	48 c1 e8 15          	shr    $0x15,%rax
  802567:	48 89 c2             	mov    %rax,%rdx
  80256a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802571:	01 00 00 
  802574:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802578:	83 e0 01             	and    $0x1,%eax
  80257b:	48 85 c0             	test   %rax,%rax
  80257e:	74 21                	je     8025a1 <fd_lookup+0x77>
  802580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802584:	48 c1 e8 0c          	shr    $0xc,%rax
  802588:	48 89 c2             	mov    %rax,%rdx
  80258b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802592:	01 00 00 
  802595:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802599:	83 e0 01             	and    $0x1,%eax
  80259c:	48 85 c0             	test   %rax,%rax
  80259f:	75 07                	jne    8025a8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a6:	eb 10                	jmp    8025b8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025b0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b8:	c9                   	leaveq 
  8025b9:	c3                   	retq   

00000000008025ba <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025ba:	55                   	push   %rbp
  8025bb:	48 89 e5             	mov    %rsp,%rbp
  8025be:	48 83 ec 30          	sub    $0x30,%rsp
  8025c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025c6:	89 f0                	mov    %esi,%eax
  8025c8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025cf:	48 89 c7             	mov    %rax,%rdi
  8025d2:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e2:	48 89 d6             	mov    %rdx,%rsi
  8025e5:	89 c7                	mov    %eax,%edi
  8025e7:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  8025ee:	00 00 00 
  8025f1:	ff d0                	callq  *%rax
  8025f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fa:	78 0a                	js     802606 <fd_close+0x4c>
	    || fd != fd2)
  8025fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802600:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802604:	74 12                	je     802618 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802606:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80260a:	74 05                	je     802611 <fd_close+0x57>
  80260c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260f:	eb 05                	jmp    802616 <fd_close+0x5c>
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	eb 69                	jmp    802681 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261c:	8b 00                	mov    (%rax),%eax
  80261e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802622:	48 89 d6             	mov    %rdx,%rsi
  802625:	89 c7                	mov    %eax,%edi
  802627:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
  802633:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263a:	78 2a                	js     802666 <fd_close+0xac>
		if (dev->dev_close)
  80263c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802640:	48 8b 40 20          	mov    0x20(%rax),%rax
  802644:	48 85 c0             	test   %rax,%rax
  802647:	74 16                	je     80265f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802651:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802655:	48 89 d7             	mov    %rdx,%rdi
  802658:	ff d0                	callq  *%rax
  80265a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265d:	eb 07                	jmp    802666 <fd_close+0xac>
		else
			r = 0;
  80265f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266a:	48 89 c6             	mov    %rax,%rsi
  80266d:	bf 00 00 00 00       	mov    $0x0,%edi
  802672:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
	return r;
  80267e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802681:	c9                   	leaveq 
  802682:	c3                   	retq   

0000000000802683 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802683:	55                   	push   %rbp
  802684:	48 89 e5             	mov    %rsp,%rbp
  802687:	48 83 ec 20          	sub    $0x20,%rsp
  80268b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80268e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802692:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802699:	eb 41                	jmp    8026dc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80269b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026a2:	00 00 00 
  8026a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a8:	48 63 d2             	movslq %edx,%rdx
  8026ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026af:	8b 00                	mov    (%rax),%eax
  8026b1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026b4:	75 22                	jne    8026d8 <dev_lookup+0x55>
			*dev = devtab[i];
  8026b6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026bd:	00 00 00 
  8026c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026c3:	48 63 d2             	movslq %edx,%rdx
  8026c6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ce:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d6:	eb 60                	jmp    802738 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026dc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026e3:	00 00 00 
  8026e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026e9:	48 63 d2             	movslq %edx,%rdx
  8026ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f0:	48 85 c0             	test   %rax,%rax
  8026f3:	75 a6                	jne    80269b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026f5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026fc:	00 00 00 
  8026ff:	48 8b 00             	mov    (%rax),%rax
  802702:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802708:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80270b:	89 c6                	mov    %eax,%esi
  80270d:	48 bf 80 5b 80 00 00 	movabs $0x805b80,%rdi
  802714:	00 00 00 
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802723:	00 00 00 
  802726:	ff d1                	callq  *%rcx
	*dev = 0;
  802728:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802733:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802738:	c9                   	leaveq 
  802739:	c3                   	retq   

000000000080273a <close>:

int
close(int fdnum)
{
  80273a:	55                   	push   %rbp
  80273b:	48 89 e5             	mov    %rsp,%rbp
  80273e:	48 83 ec 20          	sub    $0x20,%rsp
  802742:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802745:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802749:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80274c:	48 89 d6             	mov    %rdx,%rsi
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	79 05                	jns    80276b <close+0x31>
		return r;
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	eb 18                	jmp    802783 <close+0x49>
	else
		return fd_close(fd, 1);
  80276b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276f:	be 01 00 00 00       	mov    $0x1,%esi
  802774:	48 89 c7             	mov    %rax,%rdi
  802777:	48 b8 ba 25 80 00 00 	movabs $0x8025ba,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <close_all>:

void
close_all(void)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80278d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802794:	eb 15                	jmp    8027ab <close_all+0x26>
		close(i);
  802796:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802799:	89 c7                	mov    %eax,%edi
  80279b:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  8027a2:	00 00 00 
  8027a5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027ab:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027af:	7e e5                	jle    802796 <close_all+0x11>
		close(i);
}
  8027b1:	c9                   	leaveq 
  8027b2:	c3                   	retq   

00000000008027b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027b3:	55                   	push   %rbp
  8027b4:	48 89 e5             	mov    %rsp,%rbp
  8027b7:	48 83 ec 40          	sub    $0x40,%rsp
  8027bb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027be:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027c1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027c5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027c8:	48 89 d6             	mov    %rdx,%rsi
  8027cb:	89 c7                	mov    %eax,%edi
  8027cd:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	callq  *%rax
  8027d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e0:	79 08                	jns    8027ea <dup+0x37>
		return r;
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e5:	e9 70 01 00 00       	jmpq   80295a <dup+0x1a7>
	close(newfdnum);
  8027ea:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ed:	89 c7                	mov    %eax,%edi
  8027ef:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027fb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027fe:	48 98                	cltq   
  802800:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802806:	48 c1 e0 0c          	shl    $0xc,%rax
  80280a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80280e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802812:	48 89 c7             	mov    %rax,%rdi
  802815:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  80281c:	00 00 00 
  80281f:	ff d0                	callq  *%rax
  802821:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802829:	48 89 c7             	mov    %rax,%rdi
  80282c:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802833:	00 00 00 
  802836:	ff d0                	callq  *%rax
  802838:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80283c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802840:	48 c1 e8 15          	shr    $0x15,%rax
  802844:	48 89 c2             	mov    %rax,%rdx
  802847:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80284e:	01 00 00 
  802851:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802855:	83 e0 01             	and    $0x1,%eax
  802858:	48 85 c0             	test   %rax,%rax
  80285b:	74 73                	je     8028d0 <dup+0x11d>
  80285d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802861:	48 c1 e8 0c          	shr    $0xc,%rax
  802865:	48 89 c2             	mov    %rax,%rdx
  802868:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80286f:	01 00 00 
  802872:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802876:	83 e0 01             	and    $0x1,%eax
  802879:	48 85 c0             	test   %rax,%rax
  80287c:	74 52                	je     8028d0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80287e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802882:	48 c1 e8 0c          	shr    $0xc,%rax
  802886:	48 89 c2             	mov    %rax,%rdx
  802889:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802890:	01 00 00 
  802893:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802897:	25 07 0e 00 00       	and    $0xe07,%eax
  80289c:	89 c1                	mov    %eax,%ecx
  80289e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a6:	41 89 c8             	mov    %ecx,%r8d
  8028a9:	48 89 d1             	mov    %rdx,%rcx
  8028ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b1:	48 89 c6             	mov    %rax,%rsi
  8028b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b9:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cc:	79 02                	jns    8028d0 <dup+0x11d>
			goto err;
  8028ce:	eb 57                	jmp    802927 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8028d8:	48 89 c2             	mov    %rax,%rdx
  8028db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028e2:	01 00 00 
  8028e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8028ee:	89 c1                	mov    %eax,%ecx
  8028f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028f8:	41 89 c8             	mov    %ecx,%r8d
  8028fb:	48 89 d1             	mov    %rdx,%rcx
  8028fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802903:	48 89 c6             	mov    %rax,%rsi
  802906:	bf 00 00 00 00       	mov    $0x0,%edi
  80290b:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  802912:	00 00 00 
  802915:	ff d0                	callq  *%rax
  802917:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80291e:	79 02                	jns    802922 <dup+0x16f>
		goto err;
  802920:	eb 05                	jmp    802927 <dup+0x174>

	return newfdnum;
  802922:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802925:	eb 33                	jmp    80295a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292b:	48 89 c6             	mov    %rax,%rsi
  80292e:	bf 00 00 00 00       	mov    $0x0,%edi
  802933:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80293f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802943:	48 89 c6             	mov    %rax,%rsi
  802946:	bf 00 00 00 00       	mov    $0x0,%edi
  80294b:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  802952:	00 00 00 
  802955:	ff d0                	callq  *%rax
	return r;
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80295a:	c9                   	leaveq 
  80295b:	c3                   	retq   

000000000080295c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
  802960:	48 83 ec 40          	sub    $0x40,%rsp
  802964:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802967:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80296b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80296f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802973:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802976:	48 89 d6             	mov    %rdx,%rsi
  802979:	89 c7                	mov    %eax,%edi
  80297b:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802982:	00 00 00 
  802985:	ff d0                	callq  *%rax
  802987:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298e:	78 24                	js     8029b4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802994:	8b 00                	mov    (%rax),%eax
  802996:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80299a:	48 89 d6             	mov    %rdx,%rsi
  80299d:	89 c7                	mov    %eax,%edi
  80299f:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
  8029ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b2:	79 05                	jns    8029b9 <read+0x5d>
		return r;
  8029b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b7:	eb 76                	jmp    802a2f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bd:	8b 40 08             	mov    0x8(%rax),%eax
  8029c0:	83 e0 03             	and    $0x3,%eax
  8029c3:	83 f8 01             	cmp    $0x1,%eax
  8029c6:	75 3a                	jne    802a02 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029c8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8029cf:	00 00 00 
  8029d2:	48 8b 00             	mov    (%rax),%rax
  8029d5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029db:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029de:	89 c6                	mov    %eax,%esi
  8029e0:	48 bf 9f 5b 80 00 00 	movabs $0x805b9f,%rdi
  8029e7:	00 00 00 
  8029ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ef:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  8029f6:	00 00 00 
  8029f9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a00:	eb 2d                	jmp    802a2f <read+0xd3>
	}
	if (!dev->dev_read)
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a0a:	48 85 c0             	test   %rax,%rax
  802a0d:	75 07                	jne    802a16 <read+0xba>
		return -E_NOT_SUPP;
  802a0f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a14:	eb 19                	jmp    802a2f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a1e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a22:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a26:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a2a:	48 89 cf             	mov    %rcx,%rdi
  802a2d:	ff d0                	callq  *%rax
}
  802a2f:	c9                   	leaveq 
  802a30:	c3                   	retq   

0000000000802a31 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a31:	55                   	push   %rbp
  802a32:	48 89 e5             	mov    %rsp,%rbp
  802a35:	48 83 ec 30          	sub    $0x30,%rsp
  802a39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a4b:	eb 49                	jmp    802a96 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a50:	48 98                	cltq   
  802a52:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a56:	48 29 c2             	sub    %rax,%rdx
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	48 63 c8             	movslq %eax,%rcx
  802a5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a63:	48 01 c1             	add    %rax,%rcx
  802a66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a69:	48 89 ce             	mov    %rcx,%rsi
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802a75:	00 00 00 
  802a78:	ff d0                	callq  *%rax
  802a7a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a7d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a81:	79 05                	jns    802a88 <readn+0x57>
			return m;
  802a83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a86:	eb 1c                	jmp    802aa4 <readn+0x73>
		if (m == 0)
  802a88:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a8c:	75 02                	jne    802a90 <readn+0x5f>
			break;
  802a8e:	eb 11                	jmp    802aa1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a93:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a99:	48 98                	cltq   
  802a9b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a9f:	72 ac                	jb     802a4d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aa4:	c9                   	leaveq 
  802aa5:	c3                   	retq   

0000000000802aa6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802aa6:	55                   	push   %rbp
  802aa7:	48 89 e5             	mov    %rsp,%rbp
  802aaa:	48 83 ec 40          	sub    $0x40,%rsp
  802aae:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ab1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ab5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ab9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802abd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ac0:	48 89 d6             	mov    %rdx,%rsi
  802ac3:	89 c7                	mov    %eax,%edi
  802ac5:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802acc:	00 00 00 
  802acf:	ff d0                	callq  *%rax
  802ad1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad8:	78 24                	js     802afe <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ade:	8b 00                	mov    (%rax),%eax
  802ae0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae4:	48 89 d6             	mov    %rdx,%rsi
  802ae7:	89 c7                	mov    %eax,%edi
  802ae9:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  802af0:	00 00 00 
  802af3:	ff d0                	callq  *%rax
  802af5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afc:	79 05                	jns    802b03 <write+0x5d>
		return r;
  802afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b01:	eb 75                	jmp    802b78 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b07:	8b 40 08             	mov    0x8(%rax),%eax
  802b0a:	83 e0 03             	and    $0x3,%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	75 3a                	jne    802b4b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b11:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b18:	00 00 00 
  802b1b:	48 8b 00             	mov    (%rax),%rax
  802b1e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b24:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b27:	89 c6                	mov    %eax,%esi
  802b29:	48 bf bb 5b 80 00 00 	movabs $0x805bbb,%rdi
  802b30:	00 00 00 
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802b3f:	00 00 00 
  802b42:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b49:	eb 2d                	jmp    802b78 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b53:	48 85 c0             	test   %rax,%rax
  802b56:	75 07                	jne    802b5f <write+0xb9>
		return -E_NOT_SUPP;
  802b58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b5d:	eb 19                	jmp    802b78 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b63:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b67:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b6f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b73:	48 89 cf             	mov    %rcx,%rdi
  802b76:	ff d0                	callq  *%rax
}
  802b78:	c9                   	leaveq 
  802b79:	c3                   	retq   

0000000000802b7a <seek>:

int
seek(int fdnum, off_t offset)
{
  802b7a:	55                   	push   %rbp
  802b7b:	48 89 e5             	mov    %rsp,%rbp
  802b7e:	48 83 ec 18          	sub    $0x18,%rsp
  802b82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b85:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8f:	48 89 d6             	mov    %rdx,%rsi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba7:	79 05                	jns    802bae <seek+0x34>
		return r;
  802ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bac:	eb 0f                	jmp    802bbd <seek+0x43>
	fd->fd_offset = offset;
  802bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbd:	c9                   	leaveq 
  802bbe:	c3                   	retq   

0000000000802bbf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bbf:	55                   	push   %rbp
  802bc0:	48 89 e5             	mov    %rsp,%rbp
  802bc3:	48 83 ec 30          	sub    $0x30,%rsp
  802bc7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bca:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bcd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bd4:	48 89 d6             	mov    %rdx,%rsi
  802bd7:	89 c7                	mov    %eax,%edi
  802bd9:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bec:	78 24                	js     802c12 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf2:	8b 00                	mov    (%rax),%eax
  802bf4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf8:	48 89 d6             	mov    %rdx,%rsi
  802bfb:	89 c7                	mov    %eax,%edi
  802bfd:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax
  802c09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c10:	79 05                	jns    802c17 <ftruncate+0x58>
		return r;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	eb 72                	jmp    802c89 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1b:	8b 40 08             	mov    0x8(%rax),%eax
  802c1e:	83 e0 03             	and    $0x3,%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	75 3a                	jne    802c5f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c25:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c2c:	00 00 00 
  802c2f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c32:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c38:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c3b:	89 c6                	mov    %eax,%esi
  802c3d:	48 bf d8 5b 80 00 00 	movabs $0x805bd8,%rdi
  802c44:	00 00 00 
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  802c53:	00 00 00 
  802c56:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c5d:	eb 2a                	jmp    802c89 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c63:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c67:	48 85 c0             	test   %rax,%rax
  802c6a:	75 07                	jne    802c73 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c6c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c71:	eb 16                	jmp    802c89 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c77:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c7f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c82:	89 ce                	mov    %ecx,%esi
  802c84:	48 89 d7             	mov    %rdx,%rdi
  802c87:	ff d0                	callq  *%rax
}
  802c89:	c9                   	leaveq 
  802c8a:	c3                   	retq   

0000000000802c8b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c8b:	55                   	push   %rbp
  802c8c:	48 89 e5             	mov    %rsp,%rbp
  802c8f:	48 83 ec 30          	sub    $0x30,%rsp
  802c93:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c96:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca1:	48 89 d6             	mov    %rdx,%rsi
  802ca4:	89 c7                	mov    %eax,%edi
  802ca6:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb9:	78 24                	js     802cdf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbf:	8b 00                	mov    (%rax),%eax
  802cc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc5:	48 89 d6             	mov    %rdx,%rsi
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 83 26 80 00 00 	movabs $0x802683,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	79 05                	jns    802ce4 <fstat+0x59>
		return r;
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	eb 5e                	jmp    802d42 <fstat+0xb7>
	if (!dev->dev_stat)
  802ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cec:	48 85 c0             	test   %rax,%rax
  802cef:	75 07                	jne    802cf8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cf1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf6:	eb 4a                	jmp    802d42 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cf8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d03:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d0a:	00 00 00 
	stat->st_isdir = 0;
  802d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d11:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d18:	00 00 00 
	stat->st_dev = dev;
  802d1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d23:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d36:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d3a:	48 89 ce             	mov    %rcx,%rsi
  802d3d:	48 89 d7             	mov    %rdx,%rdi
  802d40:	ff d0                	callq  *%rax
}
  802d42:	c9                   	leaveq 
  802d43:	c3                   	retq   

0000000000802d44 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d44:	55                   	push   %rbp
  802d45:	48 89 e5             	mov    %rsp,%rbp
  802d48:	48 83 ec 20          	sub    $0x20,%rsp
  802d4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	be 00 00 00 00       	mov    $0x0,%esi
  802d5d:	48 89 c7             	mov    %rax,%rdi
  802d60:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  802d67:	00 00 00 
  802d6a:	ff d0                	callq  *%rax
  802d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d73:	79 05                	jns    802d7a <stat+0x36>
		return fd;
  802d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d78:	eb 2f                	jmp    802da9 <stat+0x65>
	r = fstat(fd, stat);
  802d7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d81:	48 89 d6             	mov    %rdx,%rsi
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 8b 2c 80 00 00 	movabs $0x802c8b,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
  802d92:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	89 c7                	mov    %eax,%edi
  802d9a:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
	return r;
  802da6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   

0000000000802dab <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 10          	sub    $0x10,%rsp
  802db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802db6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dc1:	00 00 00 
  802dc4:	8b 00                	mov    (%rax),%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	75 1d                	jne    802de7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802dca:	bf 01 00 00 00       	mov    $0x1,%edi
  802dcf:	48 b8 69 53 80 00 00 	movabs $0x805369,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
  802ddb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802de2:	00 00 00 
  802de5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802de7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dee:	00 00 00 
  802df1:	8b 00                	mov    (%rax),%eax
  802df3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802df6:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dfb:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e02:	00 00 00 
  802e05:	89 c7                	mov    %eax,%edi
  802e07:	48 b8 07 53 80 00 00 	movabs $0x805307,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e17:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1c:	48 89 c6             	mov    %rax,%rsi
  802e1f:	bf 00 00 00 00       	mov    $0x0,%edi
  802e24:	48 b8 01 52 80 00 00 	movabs $0x805201,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
}
  802e30:	c9                   	leaveq 
  802e31:	c3                   	retq   

0000000000802e32 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e32:	55                   	push   %rbp
  802e33:	48 89 e5             	mov    %rsp,%rbp
  802e36:	48 83 ec 30          	sub    $0x30,%rsp
  802e3a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e3e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802e41:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802e48:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802e4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802e56:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e5b:	75 08                	jne    802e65 <open+0x33>
	{
		return r;
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e60:	e9 f2 00 00 00       	jmpq   802f57 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e69:	48 89 c7             	mov    %rax,%rdi
  802e6c:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e7b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802e82:	7e 0a                	jle    802e8e <open+0x5c>
	{
		return -E_BAD_PATH;
  802e84:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e89:	e9 c9 00 00 00       	jmpq   802f57 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802e8e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802e95:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802e96:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802e9a:	48 89 c7             	mov    %rax,%rdi
  802e9d:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
  802ea9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb0:	78 09                	js     802ebb <open+0x89>
  802eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb6:	48 85 c0             	test   %rax,%rax
  802eb9:	75 08                	jne    802ec3 <open+0x91>
		{
			return r;
  802ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebe:	e9 94 00 00 00       	jmpq   802f57 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802ec3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec7:	ba 00 04 00 00       	mov    $0x400,%edx
  802ecc:	48 89 c6             	mov    %rax,%rsi
  802ecf:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ed6:	00 00 00 
  802ed9:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802ee5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802eec:	00 00 00 
  802eef:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802ef2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efc:	48 89 c6             	mov    %rax,%rsi
  802eff:	bf 01 00 00 00       	mov    $0x1,%edi
  802f04:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	79 2b                	jns    802f44 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1d:	be 00 00 00 00       	mov    $0x0,%esi
  802f22:	48 89 c7             	mov    %rax,%rdi
  802f25:	48 b8 ba 25 80 00 00 	movabs $0x8025ba,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f34:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f38:	79 05                	jns    802f3f <open+0x10d>
			{
				return d;
  802f3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f3d:	eb 18                	jmp    802f57 <open+0x125>
			}
			return r;
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	eb 13                	jmp    802f57 <open+0x125>
		}	
		return fd2num(fd_store);
  802f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 10          	sub    $0x10,%rsp
  802f61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f69:	8b 50 0c             	mov    0xc(%rax),%edx
  802f6c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f73:	00 00 00 
  802f76:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f78:	be 00 00 00 00       	mov    $0x0,%esi
  802f7d:	bf 06 00 00 00       	mov    $0x6,%edi
  802f82:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
}
  802f8e:	c9                   	leaveq 
  802f8f:	c3                   	retq   

0000000000802f90 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f90:	55                   	push   %rbp
  802f91:	48 89 e5             	mov    %rsp,%rbp
  802f94:	48 83 ec 30          	sub    $0x30,%rsp
  802f98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802fa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802fab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802fb0:	74 07                	je     802fb9 <devfile_read+0x29>
  802fb2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802fb7:	75 07                	jne    802fc0 <devfile_read+0x30>
		return -E_INVAL;
  802fb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fbe:	eb 77                	jmp    803037 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc4:	8b 50 0c             	mov    0xc(%rax),%edx
  802fc7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fce:	00 00 00 
  802fd1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fd3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fda:	00 00 00 
  802fdd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fe1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802fe5:	be 00 00 00 00       	mov    $0x0,%esi
  802fea:	bf 03 00 00 00       	mov    $0x3,%edi
  802fef:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
  802ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803002:	7f 05                	jg     803009 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	eb 2e                	jmp    803037 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803009:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300c:	48 63 d0             	movslq %eax,%rdx
  80300f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803013:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80301a:	00 00 00 
  80301d:	48 89 c7             	mov    %rax,%rdi
  803020:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80302c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803030:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803034:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803037:	c9                   	leaveq 
  803038:	c3                   	retq   

0000000000803039 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 83 ec 30          	sub    $0x30,%rsp
  803041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803049:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80304d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803054:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803059:	74 07                	je     803062 <devfile_write+0x29>
  80305b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803060:	75 08                	jne    80306a <devfile_write+0x31>
		return r;
  803062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803065:	e9 9a 00 00 00       	jmpq   803104 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80306a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306e:	8b 50 0c             	mov    0xc(%rax),%edx
  803071:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803078:	00 00 00 
  80307b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80307d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803084:	00 
  803085:	76 08                	jbe    80308f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803087:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80308e:	00 
	}
	fsipcbuf.write.req_n = n;
  80308f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803096:	00 00 00 
  803099:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80309d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8030a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a9:	48 89 c6             	mov    %rax,%rsi
  8030ac:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8030b3:	00 00 00 
  8030b6:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  8030bd:	00 00 00 
  8030c0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8030c2:	be 00 00 00 00       	mov    $0x0,%esi
  8030c7:	bf 04 00 00 00       	mov    $0x4,%edi
  8030cc:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  8030d3:	00 00 00 
  8030d6:	ff d0                	callq  *%rax
  8030d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030df:	7f 20                	jg     803101 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8030e1:	48 bf fe 5b 80 00 00 	movabs $0x805bfe,%rdi
  8030e8:	00 00 00 
  8030eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f0:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8030f7:	00 00 00 
  8030fa:	ff d2                	callq  *%rdx
		return r;
  8030fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ff:	eb 03                	jmp    803104 <devfile_write+0xcb>
	}
	return r;
  803101:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803104:	c9                   	leaveq 
  803105:	c3                   	retq   

0000000000803106 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803106:	55                   	push   %rbp
  803107:	48 89 e5             	mov    %rsp,%rbp
  80310a:	48 83 ec 20          	sub    $0x20,%rsp
  80310e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311a:	8b 50 0c             	mov    0xc(%rax),%edx
  80311d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803124:	00 00 00 
  803127:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803129:	be 00 00 00 00       	mov    $0x0,%esi
  80312e:	bf 05 00 00 00       	mov    $0x5,%edi
  803133:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803146:	79 05                	jns    80314d <devfile_stat+0x47>
		return r;
  803148:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314b:	eb 56                	jmp    8031a3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803158:	00 00 00 
  80315b:	48 89 c7             	mov    %rax,%rdi
  80315e:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80316a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803171:	00 00 00 
  803174:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80317a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803184:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80318b:	00 00 00 
  80318e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803198:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80319e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a3:	c9                   	leaveq 
  8031a4:	c3                   	retq   

00000000008031a5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8031a5:	55                   	push   %rbp
  8031a6:	48 89 e5             	mov    %rsp,%rbp
  8031a9:	48 83 ec 10          	sub    $0x10,%rsp
  8031ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8031bb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031c2:	00 00 00 
  8031c5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031c7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031ce:	00 00 00 
  8031d1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031d4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031d7:	be 00 00 00 00       	mov    $0x0,%esi
  8031dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e1:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
}
  8031ed:	c9                   	leaveq 
  8031ee:	c3                   	retq   

00000000008031ef <remove>:

// Delete a file
int
remove(const char *path)
{
  8031ef:	55                   	push   %rbp
  8031f0:	48 89 e5             	mov    %rsp,%rbp
  8031f3:	48 83 ec 10          	sub    $0x10,%rsp
  8031f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803213:	7e 07                	jle    80321c <remove+0x2d>
		return -E_BAD_PATH;
  803215:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80321a:	eb 33                	jmp    80324f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80321c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803220:	48 89 c6             	mov    %rax,%rsi
  803223:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80322a:	00 00 00 
  80322d:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803234:	00 00 00 
  803237:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803239:	be 00 00 00 00       	mov    $0x0,%esi
  80323e:	bf 07 00 00 00       	mov    $0x7,%edi
  803243:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
}
  80324f:	c9                   	leaveq 
  803250:	c3                   	retq   

0000000000803251 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803251:	55                   	push   %rbp
  803252:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803255:	be 00 00 00 00       	mov    $0x0,%esi
  80325a:	bf 08 00 00 00       	mov    $0x8,%edi
  80325f:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
}
  80326b:	5d                   	pop    %rbp
  80326c:	c3                   	retq   

000000000080326d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803278:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80327f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803286:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80328d:	be 00 00 00 00       	mov    $0x0,%esi
  803292:	48 89 c7             	mov    %rax,%rdi
  803295:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
  8032a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8032a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a8:	79 28                	jns    8032d2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8032aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ad:	89 c6                	mov    %eax,%esi
  8032af:	48 bf 1a 5c 80 00 00 	movabs $0x805c1a,%rdi
  8032b6:	00 00 00 
  8032b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032be:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8032c5:	00 00 00 
  8032c8:	ff d2                	callq  *%rdx
		return fd_src;
  8032ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cd:	e9 74 01 00 00       	jmpq   803446 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8032d2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8032d9:	be 01 01 00 00       	mov    $0x101,%esi
  8032de:	48 89 c7             	mov    %rax,%rdi
  8032e1:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8032f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032f4:	79 39                	jns    80332f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8032f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032f9:	89 c6                	mov    %eax,%esi
  8032fb:	48 bf 30 5c 80 00 00 	movabs $0x805c30,%rdi
  803302:	00 00 00 
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  803311:	00 00 00 
  803314:	ff d2                	callq  *%rdx
		close(fd_src);
  803316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803319:	89 c7                	mov    %eax,%edi
  80331b:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  803322:	00 00 00 
  803325:	ff d0                	callq  *%rax
		return fd_dest;
  803327:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80332a:	e9 17 01 00 00       	jmpq   803446 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80332f:	eb 74                	jmp    8033a5 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803334:	48 63 d0             	movslq %eax,%rdx
  803337:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80333e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803341:	48 89 ce             	mov    %rcx,%rsi
  803344:	89 c7                	mov    %eax,%edi
  803346:	48 b8 a6 2a 80 00 00 	movabs $0x802aa6,%rax
  80334d:	00 00 00 
  803350:	ff d0                	callq  *%rax
  803352:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803355:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803359:	79 4a                	jns    8033a5 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80335b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80335e:	89 c6                	mov    %eax,%esi
  803360:	48 bf 4a 5c 80 00 00 	movabs $0x805c4a,%rdi
  803367:	00 00 00 
  80336a:	b8 00 00 00 00       	mov    $0x0,%eax
  80336f:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  803376:	00 00 00 
  803379:	ff d2                	callq  *%rdx
			close(fd_src);
  80337b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337e:	89 c7                	mov    %eax,%edi
  803380:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  803387:	00 00 00 
  80338a:	ff d0                	callq  *%rax
			close(fd_dest);
  80338c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80338f:	89 c7                	mov    %eax,%edi
  803391:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
			return write_size;
  80339d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a0:	e9 a1 00 00 00       	jmpq   803446 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8033a5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033af:	ba 00 02 00 00       	mov    $0x200,%edx
  8033b4:	48 89 ce             	mov    %rcx,%rsi
  8033b7:	89 c7                	mov    %eax,%edi
  8033b9:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  8033c0:	00 00 00 
  8033c3:	ff d0                	callq  *%rax
  8033c5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033cc:	0f 8f 5f ff ff ff    	jg     803331 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8033d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033d6:	79 47                	jns    80341f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8033d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033db:	89 c6                	mov    %eax,%esi
  8033dd:	48 bf 5d 5c 80 00 00 	movabs $0x805c5d,%rdi
  8033e4:	00 00 00 
  8033e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ec:	48 ba 8f 05 80 00 00 	movabs $0x80058f,%rdx
  8033f3:	00 00 00 
  8033f6:	ff d2                	callq  *%rdx
		close(fd_src);
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	89 c7                	mov    %eax,%edi
  8033fd:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  803404:	00 00 00 
  803407:	ff d0                	callq  *%rax
		close(fd_dest);
  803409:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80340c:	89 c7                	mov    %eax,%edi
  80340e:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  803415:	00 00 00 
  803418:	ff d0                	callq  *%rax
		return read_size;
  80341a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80341d:	eb 27                	jmp    803446 <copy+0x1d9>
	}
	close(fd_src);
  80341f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803422:	89 c7                	mov    %eax,%edi
  803424:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  80342b:	00 00 00 
  80342e:	ff d0                	callq  *%rax
	close(fd_dest);
  803430:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803433:	89 c7                	mov    %eax,%edi
  803435:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  80343c:	00 00 00 
  80343f:	ff d0                	callq  *%rax
	return 0;
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803446:	c9                   	leaveq 
  803447:	c3                   	retq   

0000000000803448 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803448:	55                   	push   %rbp
  803449:	48 89 e5             	mov    %rsp,%rbp
  80344c:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803453:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80345a:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803461:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803468:	be 00 00 00 00       	mov    $0x0,%esi
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 32 2e 80 00 00 	movabs $0x802e32,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80347f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803483:	79 08                	jns    80348d <spawn+0x45>
		return r;
  803485:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803488:	e9 14 03 00 00       	jmpq   8037a1 <spawn+0x359>
	fd = r;
  80348d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803490:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803493:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80349a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80349e:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8034a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034a8:	ba 00 02 00 00       	mov    $0x200,%edx
  8034ad:	48 89 ce             	mov    %rcx,%rsi
  8034b0:	89 c7                	mov    %eax,%edi
  8034b2:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
  8034be:	3d 00 02 00 00       	cmp    $0x200,%eax
  8034c3:	75 0d                	jne    8034d2 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8034c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c9:	8b 00                	mov    (%rax),%eax
  8034cb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8034d0:	74 43                	je     803515 <spawn+0xcd>
		close(fd);
  8034d2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8034d5:	89 c7                	mov    %eax,%edi
  8034d7:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8034e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e7:	8b 00                	mov    (%rax),%eax
  8034e9:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8034ee:	89 c6                	mov    %eax,%esi
  8034f0:	48 bf 78 5c 80 00 00 	movabs $0x805c78,%rdi
  8034f7:	00 00 00 
  8034fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ff:	48 b9 8f 05 80 00 00 	movabs $0x80058f,%rcx
  803506:	00 00 00 
  803509:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80350b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803510:	e9 8c 02 00 00       	jmpq   8037a1 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803515:	b8 07 00 00 00       	mov    $0x7,%eax
  80351a:	cd 30                	int    $0x30
  80351c:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80351f:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803522:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803529:	79 08                	jns    803533 <spawn+0xeb>
		return r;
  80352b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80352e:	e9 6e 02 00 00       	jmpq   8037a1 <spawn+0x359>
	child = r;
  803533:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803536:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803539:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80353c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803541:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803548:	00 00 00 
  80354b:	48 63 d0             	movslq %eax,%rdx
  80354e:	48 89 d0             	mov    %rdx,%rax
  803551:	48 c1 e0 03          	shl    $0x3,%rax
  803555:	48 01 d0             	add    %rdx,%rax
  803558:	48 c1 e0 05          	shl    $0x5,%rax
  80355c:	48 01 c8             	add    %rcx,%rax
  80355f:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803566:	48 89 c6             	mov    %rax,%rsi
  803569:	b8 18 00 00 00       	mov    $0x18,%eax
  80356e:	48 89 d7             	mov    %rdx,%rdi
  803571:	48 89 c1             	mov    %rax,%rcx
  803574:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80357b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80357f:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803586:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80358d:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803594:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80359b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80359e:	48 89 ce             	mov    %rcx,%rsi
  8035a1:	89 c7                	mov    %eax,%edi
  8035a3:	48 b8 0b 3a 80 00 00 	movabs $0x803a0b,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
  8035af:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8035b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8035b6:	79 08                	jns    8035c0 <spawn+0x178>
		return r;
  8035b8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8035bb:	e9 e1 01 00 00       	jmpq   8037a1 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8035c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8035c8:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8035cf:	48 01 d0             	add    %rdx,%rax
  8035d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8035d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035dd:	e9 a3 00 00 00       	jmpq   803685 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8035e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e6:	8b 00                	mov    (%rax),%eax
  8035e8:	83 f8 01             	cmp    $0x1,%eax
  8035eb:	74 05                	je     8035f2 <spawn+0x1aa>
			continue;
  8035ed:	e9 8a 00 00 00       	jmpq   80367c <spawn+0x234>
		perm = PTE_P | PTE_U;
  8035f2:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8035f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fd:	8b 40 04             	mov    0x4(%rax),%eax
  803600:	83 e0 02             	and    $0x2,%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 04                	je     80360b <spawn+0x1c3>
			perm |= PTE_W;
  803607:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80360b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803613:	41 89 c1             	mov    %eax,%r9d
  803616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80361e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803622:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80362e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803631:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803634:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803637:	89 3c 24             	mov    %edi,(%rsp)
  80363a:	89 c7                	mov    %eax,%edi
  80363c:	48 b8 b4 3c 80 00 00 	movabs $0x803cb4,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
  803648:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80364b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80364f:	79 2b                	jns    80367c <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803651:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803652:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803655:	89 c7                	mov    %eax,%edi
  803657:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
	close(fd);
  803663:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803666:	89 c7                	mov    %eax,%edi
  803668:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  80366f:	00 00 00 
  803672:	ff d0                	callq  *%rax
	return r;
  803674:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803677:	e9 25 01 00 00       	jmpq   8037a1 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80367c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803680:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803689:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80368d:	0f b7 c0             	movzwl %ax,%eax
  803690:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803693:	0f 8f 49 ff ff ff    	jg     8035e2 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  803699:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80369c:	89 c7                	mov    %eax,%edi
  80369e:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
	fd = -1;
  8036aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8036b1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8036b4:	89 c7                	mov    %eax,%edi
  8036b6:	48 b8 a0 3e 80 00 00 	movabs $0x803ea0,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8036c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8036c9:	79 30                	jns    8036fb <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8036cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	48 ba 92 5c 80 00 00 	movabs $0x805c92,%rdx
  8036d7:	00 00 00 
  8036da:	be 82 00 00 00       	mov    $0x82,%esi
  8036df:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  8036e6:	00 00 00 
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8036f5:	00 00 00 
  8036f8:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8036fb:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803702:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803705:	48 89 d6             	mov    %rdx,%rsi
  803708:	89 c7                	mov    %eax,%edi
  80370a:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
  803716:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803719:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80371d:	79 30                	jns    80374f <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  80371f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803722:	89 c1                	mov    %eax,%ecx
  803724:	48 ba b4 5c 80 00 00 	movabs $0x805cb4,%rdx
  80372b:	00 00 00 
  80372e:	be 85 00 00 00       	mov    $0x85,%esi
  803733:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  80373a:	00 00 00 
  80373d:	b8 00 00 00 00       	mov    $0x0,%eax
  803742:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803749:	00 00 00 
  80374c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80374f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803752:	be 02 00 00 00       	mov    $0x2,%esi
  803757:	89 c7                	mov    %eax,%edi
  803759:	48 b8 68 1b 80 00 00 	movabs $0x801b68,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803768:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80376c:	79 30                	jns    80379e <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  80376e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803771:	89 c1                	mov    %eax,%ecx
  803773:	48 ba ce 5c 80 00 00 	movabs $0x805cce,%rdx
  80377a:	00 00 00 
  80377d:	be 88 00 00 00       	mov    $0x88,%esi
  803782:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  803789:	00 00 00 
  80378c:	b8 00 00 00 00       	mov    $0x0,%eax
  803791:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803798:	00 00 00 
  80379b:	41 ff d0             	callq  *%r8

	return child;
  80379e:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8037a1:	c9                   	leaveq 
  8037a2:	c3                   	retq   

00000000008037a3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8037a3:	55                   	push   %rbp
  8037a4:	48 89 e5             	mov    %rsp,%rbp
  8037a7:	41 55                	push   %r13
  8037a9:	41 54                	push   %r12
  8037ab:	53                   	push   %rbx
  8037ac:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037b3:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8037ba:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8037c1:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8037c8:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8037cf:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8037d6:	84 c0                	test   %al,%al
  8037d8:	74 26                	je     803800 <spawnl+0x5d>
  8037da:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8037e1:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8037e8:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8037ec:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8037f0:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8037f4:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8037f8:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8037fc:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803800:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803807:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80380e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803811:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803818:	00 00 00 
  80381b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803822:	00 00 00 
  803825:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803829:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803830:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803837:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80383e:	eb 07                	jmp    803847 <spawnl+0xa4>
		argc++;
  803840:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803847:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80384d:	83 f8 30             	cmp    $0x30,%eax
  803850:	73 23                	jae    803875 <spawnl+0xd2>
  803852:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803859:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80385f:	89 c0                	mov    %eax,%eax
  803861:	48 01 d0             	add    %rdx,%rax
  803864:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80386a:	83 c2 08             	add    $0x8,%edx
  80386d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803873:	eb 15                	jmp    80388a <spawnl+0xe7>
  803875:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80387c:	48 89 d0             	mov    %rdx,%rax
  80387f:	48 83 c2 08          	add    $0x8,%rdx
  803883:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80388a:	48 8b 00             	mov    (%rax),%rax
  80388d:	48 85 c0             	test   %rax,%rax
  803890:	75 ae                	jne    803840 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803892:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803898:	83 c0 02             	add    $0x2,%eax
  80389b:	48 89 e2             	mov    %rsp,%rdx
  80389e:	48 89 d3             	mov    %rdx,%rbx
  8038a1:	48 63 d0             	movslq %eax,%rdx
  8038a4:	48 83 ea 01          	sub    $0x1,%rdx
  8038a8:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8038af:	48 63 d0             	movslq %eax,%rdx
  8038b2:	49 89 d4             	mov    %rdx,%r12
  8038b5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8038bb:	48 63 d0             	movslq %eax,%rdx
  8038be:	49 89 d2             	mov    %rdx,%r10
  8038c1:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8038c7:	48 98                	cltq   
  8038c9:	48 c1 e0 03          	shl    $0x3,%rax
  8038cd:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8038d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8038d6:	48 83 e8 01          	sub    $0x1,%rax
  8038da:	48 01 d0             	add    %rdx,%rax
  8038dd:	bf 10 00 00 00       	mov    $0x10,%edi
  8038e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8038e7:	48 f7 f7             	div    %rdi
  8038ea:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8038ee:	48 29 c4             	sub    %rax,%rsp
  8038f1:	48 89 e0             	mov    %rsp,%rax
  8038f4:	48 83 c0 07          	add    $0x7,%rax
  8038f8:	48 c1 e8 03          	shr    $0x3,%rax
  8038fc:	48 c1 e0 03          	shl    $0x3,%rax
  803900:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803907:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80390e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803915:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803918:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80391e:	8d 50 01             	lea    0x1(%rax),%edx
  803921:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803928:	48 63 d2             	movslq %edx,%rdx
  80392b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803932:	00 

	va_start(vl, arg0);
  803933:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80393a:	00 00 00 
  80393d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803944:	00 00 00 
  803947:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80394b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803952:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803959:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803960:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803967:	00 00 00 
  80396a:	eb 63                	jmp    8039cf <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80396c:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803972:	8d 70 01             	lea    0x1(%rax),%esi
  803975:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80397b:	83 f8 30             	cmp    $0x30,%eax
  80397e:	73 23                	jae    8039a3 <spawnl+0x200>
  803980:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803987:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80398d:	89 c0                	mov    %eax,%eax
  80398f:	48 01 d0             	add    %rdx,%rax
  803992:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803998:	83 c2 08             	add    $0x8,%edx
  80399b:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8039a1:	eb 15                	jmp    8039b8 <spawnl+0x215>
  8039a3:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8039aa:	48 89 d0             	mov    %rdx,%rax
  8039ad:	48 83 c2 08          	add    $0x8,%rdx
  8039b1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8039b8:	48 8b 08             	mov    (%rax),%rcx
  8039bb:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039c2:	89 f2                	mov    %esi,%edx
  8039c4:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8039c8:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8039cf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8039d5:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8039db:	77 8f                	ja     80396c <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8039dd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039e4:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8039eb:	48 89 d6             	mov    %rdx,%rsi
  8039ee:	48 89 c7             	mov    %rax,%rdi
  8039f1:	48 b8 48 34 80 00 00 	movabs $0x803448,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
  8039fd:	48 89 dc             	mov    %rbx,%rsp
}
  803a00:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803a04:	5b                   	pop    %rbx
  803a05:	41 5c                	pop    %r12
  803a07:	41 5d                	pop    %r13
  803a09:	5d                   	pop    %rbp
  803a0a:	c3                   	retq   

0000000000803a0b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803a0b:	55                   	push   %rbp
  803a0c:	48 89 e5             	mov    %rsp,%rbp
  803a0f:	48 83 ec 50          	sub    $0x50,%rsp
  803a13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803a16:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803a1a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803a1e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a25:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803a2d:	eb 33                	jmp    803a62 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803a2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a32:	48 98                	cltq   
  803a34:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a3b:	00 
  803a3c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a40:	48 01 d0             	add    %rdx,%rax
  803a43:	48 8b 00             	mov    (%rax),%rax
  803a46:	48 89 c7             	mov    %rax,%rdi
  803a49:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
  803a55:	83 c0 01             	add    $0x1,%eax
  803a58:	48 98                	cltq   
  803a5a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803a5e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803a62:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a65:	48 98                	cltq   
  803a67:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803a6e:	00 
  803a6f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a73:	48 01 d0             	add    %rdx,%rax
  803a76:	48 8b 00             	mov    (%rax),%rax
  803a79:	48 85 c0             	test   %rax,%rax
  803a7c:	75 b1                	jne    803a2f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803a7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a82:	48 f7 d8             	neg    %rax
  803a85:	48 05 00 10 40 00    	add    $0x401000,%rax
  803a8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a93:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803a97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9b:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803a9f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803aa2:	83 c2 01             	add    $0x1,%edx
  803aa5:	c1 e2 03             	shl    $0x3,%edx
  803aa8:	48 63 d2             	movslq %edx,%rdx
  803aab:	48 f7 da             	neg    %rdx
  803aae:	48 01 d0             	add    %rdx,%rax
  803ab1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803ab5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab9:	48 83 e8 10          	sub    $0x10,%rax
  803abd:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803ac3:	77 0a                	ja     803acf <init_stack+0xc4>
		return -E_NO_MEM;
  803ac5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803aca:	e9 e3 01 00 00       	jmpq   803cb2 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803acf:	ba 07 00 00 00       	mov    $0x7,%edx
  803ad4:	be 00 00 40 00       	mov    $0x400000,%esi
  803ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ade:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803ae5:	00 00 00 
  803ae8:	ff d0                	callq  *%rax
  803aea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803af1:	79 08                	jns    803afb <init_stack+0xf0>
		return r;
  803af3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af6:	e9 b7 01 00 00       	jmpq   803cb2 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803afb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803b02:	e9 8a 00 00 00       	jmpq   803b91 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803b07:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b0a:	48 98                	cltq   
  803b0c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b13:	00 
  803b14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b18:	48 01 c2             	add    %rax,%rdx
  803b1b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803b20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b24:	48 01 c8             	add    %rcx,%rax
  803b27:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803b2d:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803b30:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b33:	48 98                	cltq   
  803b35:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b3c:	00 
  803b3d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b41:	48 01 d0             	add    %rdx,%rax
  803b44:	48 8b 10             	mov    (%rax),%rdx
  803b47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4b:	48 89 d6             	mov    %rdx,%rsi
  803b4e:	48 89 c7             	mov    %rax,%rdi
  803b51:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803b5d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b60:	48 98                	cltq   
  803b62:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b69:	00 
  803b6a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b6e:	48 01 d0             	add    %rdx,%rax
  803b71:	48 8b 00             	mov    (%rax),%rax
  803b74:	48 89 c7             	mov    %rax,%rdi
  803b77:	48 b8 d8 10 80 00 00 	movabs $0x8010d8,%rax
  803b7e:	00 00 00 
  803b81:	ff d0                	callq  *%rax
  803b83:	48 98                	cltq   
  803b85:	48 83 c0 01          	add    $0x1,%rax
  803b89:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803b8d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803b91:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803b94:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803b97:	0f 8c 6a ff ff ff    	jl     803b07 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803b9d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ba0:	48 98                	cltq   
  803ba2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ba9:	00 
  803baa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bae:	48 01 d0             	add    %rdx,%rax
  803bb1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803bb8:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803bbf:	00 
  803bc0:	74 35                	je     803bf7 <init_stack+0x1ec>
  803bc2:	48 b9 e8 5c 80 00 00 	movabs $0x805ce8,%rcx
  803bc9:	00 00 00 
  803bcc:	48 ba 0e 5d 80 00 00 	movabs $0x805d0e,%rdx
  803bd3:	00 00 00 
  803bd6:	be f1 00 00 00       	mov    $0xf1,%esi
  803bdb:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  803be2:	00 00 00 
  803be5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bea:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803bf1:	00 00 00 
  803bf4:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803bf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bfb:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803bff:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c08:	48 01 c8             	add    %rcx,%rax
  803c0b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c11:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803c14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c18:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803c1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c1f:	48 98                	cltq   
  803c21:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803c24:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803c29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c2d:	48 01 d0             	add    %rdx,%rax
  803c30:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803c36:	48 89 c2             	mov    %rax,%rdx
  803c39:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c3d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803c40:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803c43:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803c49:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803c4e:	89 c2                	mov    %eax,%edx
  803c50:	be 00 00 40 00       	mov    $0x400000,%esi
  803c55:	bf 00 00 00 00       	mov    $0x0,%edi
  803c5a:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
  803c66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c6d:	79 02                	jns    803c71 <init_stack+0x266>
		goto error;
  803c6f:	eb 28                	jmp    803c99 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803c71:	be 00 00 40 00       	mov    $0x400000,%esi
  803c76:	bf 00 00 00 00       	mov    $0x0,%edi
  803c7b:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c8e:	79 02                	jns    803c92 <init_stack+0x287>
		goto error;
  803c90:	eb 07                	jmp    803c99 <init_stack+0x28e>

	return 0;
  803c92:	b8 00 00 00 00       	mov    $0x0,%eax
  803c97:	eb 19                	jmp    803cb2 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803c99:	be 00 00 40 00       	mov    $0x400000,%esi
  803c9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca3:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
	return r;
  803caf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803cb2:	c9                   	leaveq 
  803cb3:	c3                   	retq   

0000000000803cb4 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803cb4:	55                   	push   %rbp
  803cb5:	48 89 e5             	mov    %rsp,%rbp
  803cb8:	48 83 ec 50          	sub    $0x50,%rsp
  803cbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803cbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cc3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803cc7:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803cca:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803cce:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803cd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd6:	25 ff 0f 00 00       	and    $0xfff,%eax
  803cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ce2:	74 21                	je     803d05 <map_segment+0x51>
		va -= i;
  803ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce7:	48 98                	cltq   
  803ce9:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf0:	48 98                	cltq   
  803cf2:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf9:	48 98                	cltq   
  803cfb:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d02:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803d05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d0c:	e9 79 01 00 00       	jmpq   803e8a <map_segment+0x1d6>
		if (i >= filesz) {
  803d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d14:	48 98                	cltq   
  803d16:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803d1a:	72 3c                	jb     803d58 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1f:	48 63 d0             	movslq %eax,%rdx
  803d22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d26:	48 01 d0             	add    %rdx,%rax
  803d29:	48 89 c1             	mov    %rax,%rcx
  803d2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d2f:	8b 55 10             	mov    0x10(%rbp),%edx
  803d32:	48 89 ce             	mov    %rcx,%rsi
  803d35:	89 c7                	mov    %eax,%edi
  803d37:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
  803d43:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d46:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d4a:	0f 89 33 01 00 00    	jns    803e83 <map_segment+0x1cf>
				return r;
  803d50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d53:	e9 46 01 00 00       	jmpq   803e9e <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d58:	ba 07 00 00 00       	mov    $0x7,%edx
  803d5d:	be 00 00 40 00       	mov    $0x400000,%esi
  803d62:	bf 00 00 00 00       	mov    $0x0,%edi
  803d67:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  803d6e:	00 00 00 
  803d71:	ff d0                	callq  *%rax
  803d73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803d76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d7a:	79 08                	jns    803d84 <map_segment+0xd0>
				return r;
  803d7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d7f:	e9 1a 01 00 00       	jmpq   803e9e <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d87:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803d8a:	01 c2                	add    %eax,%edx
  803d8c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803d8f:	89 d6                	mov    %edx,%esi
  803d91:	89 c7                	mov    %eax,%edi
  803d93:	48 b8 7a 2b 80 00 00 	movabs $0x802b7a,%rax
  803d9a:	00 00 00 
  803d9d:	ff d0                	callq  *%rax
  803d9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803da2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803da6:	79 08                	jns    803db0 <map_segment+0xfc>
				return r;
  803da8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dab:	e9 ee 00 00 00       	jmpq   803e9e <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803db0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803db7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dba:	48 98                	cltq   
  803dbc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803dc0:	48 29 c2             	sub    %rax,%rdx
  803dc3:	48 89 d0             	mov    %rdx,%rax
  803dc6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803dca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803dcd:	48 63 d0             	movslq %eax,%rdx
  803dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd4:	48 39 c2             	cmp    %rax,%rdx
  803dd7:	48 0f 47 d0          	cmova  %rax,%rdx
  803ddb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dde:	be 00 00 40 00       	mov    $0x400000,%esi
  803de3:	89 c7                	mov    %eax,%edi
  803de5:	48 b8 31 2a 80 00 00 	movabs $0x802a31,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
  803df1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803df4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803df8:	79 08                	jns    803e02 <map_segment+0x14e>
				return r;
  803dfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dfd:	e9 9c 00 00 00       	jmpq   803e9e <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803e02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e05:	48 63 d0             	movslq %eax,%rdx
  803e08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e0c:	48 01 d0             	add    %rdx,%rax
  803e0f:	48 89 c2             	mov    %rax,%rdx
  803e12:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e15:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803e19:	48 89 d1             	mov    %rdx,%rcx
  803e1c:	89 c2                	mov    %eax,%edx
  803e1e:	be 00 00 40 00       	mov    $0x400000,%esi
  803e23:	bf 00 00 00 00       	mov    $0x0,%edi
  803e28:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803e2f:	00 00 00 
  803e32:	ff d0                	callq  *%rax
  803e34:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803e37:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e3b:	79 30                	jns    803e6d <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803e3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e40:	89 c1                	mov    %eax,%ecx
  803e42:	48 ba 23 5d 80 00 00 	movabs $0x805d23,%rdx
  803e49:	00 00 00 
  803e4c:	be 24 01 00 00       	mov    $0x124,%esi
  803e51:	48 bf a8 5c 80 00 00 	movabs $0x805ca8,%rdi
  803e58:	00 00 00 
  803e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e60:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  803e67:	00 00 00 
  803e6a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803e6d:	be 00 00 40 00       	mov    $0x400000,%esi
  803e72:	bf 00 00 00 00       	mov    $0x0,%edi
  803e77:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  803e7e:	00 00 00 
  803e81:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803e83:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803e8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8d:	48 98                	cltq   
  803e8f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e93:	0f 82 78 fe ff ff    	jb     803d11 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e9e:	c9                   	leaveq 
  803e9f:	c3                   	retq   

0000000000803ea0 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803ea0:	55                   	push   %rbp
  803ea1:	48 89 e5             	mov    %rsp,%rbp
  803ea4:	48 83 ec 20          	sub    $0x20,%rsp
  803ea8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803eab:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  803eb2:	00 
  803eb3:	e9 c9 00 00 00       	jmpq   803f81 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  803eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ebc:	48 c1 e8 27          	shr    $0x27,%rax
  803ec0:	48 89 c2             	mov    %rax,%rdx
  803ec3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803eca:	01 00 00 
  803ecd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ed1:	48 85 c0             	test   %rax,%rax
  803ed4:	74 3c                	je     803f12 <copy_shared_pages+0x72>
  803ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eda:	48 c1 e8 1e          	shr    $0x1e,%rax
  803ede:	48 89 c2             	mov    %rax,%rdx
  803ee1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803ee8:	01 00 00 
  803eeb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803eef:	48 85 c0             	test   %rax,%rax
  803ef2:	74 1e                	je     803f12 <copy_shared_pages+0x72>
  803ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef8:	48 c1 e8 15          	shr    $0x15,%rax
  803efc:	48 89 c2             	mov    %rax,%rdx
  803eff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f06:	01 00 00 
  803f09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f0d:	48 85 c0             	test   %rax,%rax
  803f10:	75 02                	jne    803f14 <copy_shared_pages+0x74>
                continue;
  803f12:	eb 65                	jmp    803f79 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803f14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f18:	48 c1 e8 0c          	shr    $0xc,%rax
  803f1c:	48 89 c2             	mov    %rax,%rdx
  803f1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f26:	01 00 00 
  803f29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f2d:	25 00 04 00 00       	and    $0x400,%eax
  803f32:	48 85 c0             	test   %rax,%rax
  803f35:	74 42                	je     803f79 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3b:	48 c1 e8 0c          	shr    $0xc,%rax
  803f3f:	48 89 c2             	mov    %rax,%rdx
  803f42:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f49:	01 00 00 
  803f4c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f50:	25 07 0e 00 00       	and    $0xe07,%eax
  803f55:	89 c6                	mov    %eax,%esi
  803f57:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803f5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f62:	41 89 f0             	mov    %esi,%r8d
  803f65:	48 89 c6             	mov    %rax,%rsi
  803f68:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6d:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  803f74:	00 00 00 
  803f77:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803f79:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  803f80:	00 
  803f81:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  803f88:	00 00 00 
  803f8b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803f8f:	0f 86 23 ff ff ff    	jbe    803eb8 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  803f95:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  803f9a:	c9                   	leaveq 
  803f9b:	c3                   	retq   

0000000000803f9c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803f9c:	55                   	push   %rbp
  803f9d:	48 89 e5             	mov    %rsp,%rbp
  803fa0:	48 83 ec 20          	sub    $0x20,%rsp
  803fa4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803fa7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fae:	48 89 d6             	mov    %rdx,%rsi
  803fb1:	89 c7                	mov    %eax,%edi
  803fb3:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
  803fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc6:	79 05                	jns    803fcd <fd2sockid+0x31>
		return r;
  803fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fcb:	eb 24                	jmp    803ff1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd1:	8b 10                	mov    (%rax),%edx
  803fd3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803fda:	00 00 00 
  803fdd:	8b 00                	mov    (%rax),%eax
  803fdf:	39 c2                	cmp    %eax,%edx
  803fe1:	74 07                	je     803fea <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803fe3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803fe8:	eb 07                	jmp    803ff1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fee:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 20          	sub    $0x20,%rsp
  803ffb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803ffe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804002:	48 89 c7             	mov    %rax,%rdi
  804005:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  80400c:	00 00 00 
  80400f:	ff d0                	callq  *%rax
  804011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804018:	78 26                	js     804040 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80401a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80401e:	ba 07 04 00 00       	mov    $0x407,%edx
  804023:	48 89 c6             	mov    %rax,%rsi
  804026:	bf 00 00 00 00       	mov    $0x0,%edi
  80402b:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804032:	00 00 00 
  804035:	ff d0                	callq  *%rax
  804037:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403e:	79 16                	jns    804056 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  804040:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804043:	89 c7                	mov    %eax,%edi
  804045:	48 b8 00 45 80 00 00 	movabs $0x804500,%rax
  80404c:	00 00 00 
  80404f:	ff d0                	callq  *%rax
		return r;
  804051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804054:	eb 3a                	jmp    804090 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80405a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  804061:	00 00 00 
  804064:	8b 12                	mov    (%rdx),%edx
  804066:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  804073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804077:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80407a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80407d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804081:	48 89 c7             	mov    %rax,%rdi
  804084:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  80408b:	00 00 00 
  80408e:	ff d0                	callq  *%rax
}
  804090:	c9                   	leaveq 
  804091:	c3                   	retq   

0000000000804092 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804092:	55                   	push   %rbp
  804093:	48 89 e5             	mov    %rsp,%rbp
  804096:	48 83 ec 30          	sub    $0x30,%rsp
  80409a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80409d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040a8:	89 c7                	mov    %eax,%edi
  8040aa:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  8040b1:	00 00 00 
  8040b4:	ff d0                	callq  *%rax
  8040b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040bd:	79 05                	jns    8040c4 <accept+0x32>
		return r;
  8040bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c2:	eb 3b                	jmp    8040ff <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8040c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8040c8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8040cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040cf:	48 89 ce             	mov    %rcx,%rsi
  8040d2:	89 c7                	mov    %eax,%edi
  8040d4:	48 b8 dd 43 80 00 00 	movabs $0x8043dd,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
  8040e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e7:	79 05                	jns    8040ee <accept+0x5c>
		return r;
  8040e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ec:	eb 11                	jmp    8040ff <accept+0x6d>
	return alloc_sockfd(r);
  8040ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f1:	89 c7                	mov    %eax,%edi
  8040f3:	48 b8 f3 3f 80 00 00 	movabs $0x803ff3,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
}
  8040ff:	c9                   	leaveq 
  804100:	c3                   	retq   

0000000000804101 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804101:	55                   	push   %rbp
  804102:	48 89 e5             	mov    %rsp,%rbp
  804105:	48 83 ec 20          	sub    $0x20,%rsp
  804109:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80410c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804110:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804116:	89 c7                	mov    %eax,%edi
  804118:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  80411f:	00 00 00 
  804122:	ff d0                	callq  *%rax
  804124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80412b:	79 05                	jns    804132 <bind+0x31>
		return r;
  80412d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804130:	eb 1b                	jmp    80414d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  804132:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804135:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413c:	48 89 ce             	mov    %rcx,%rsi
  80413f:	89 c7                	mov    %eax,%edi
  804141:	48 b8 5c 44 80 00 00 	movabs $0x80445c,%rax
  804148:	00 00 00 
  80414b:	ff d0                	callq  *%rax
}
  80414d:	c9                   	leaveq 
  80414e:	c3                   	retq   

000000000080414f <shutdown>:

int
shutdown(int s, int how)
{
  80414f:	55                   	push   %rbp
  804150:	48 89 e5             	mov    %rsp,%rbp
  804153:	48 83 ec 20          	sub    $0x20,%rsp
  804157:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80415a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80415d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804160:	89 c7                	mov    %eax,%edi
  804162:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  804169:	00 00 00 
  80416c:	ff d0                	callq  *%rax
  80416e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804171:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804175:	79 05                	jns    80417c <shutdown+0x2d>
		return r;
  804177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417a:	eb 16                	jmp    804192 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80417c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80417f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804182:	89 d6                	mov    %edx,%esi
  804184:	89 c7                	mov    %eax,%edi
  804186:	48 b8 c0 44 80 00 00 	movabs $0x8044c0,%rax
  80418d:	00 00 00 
  804190:	ff d0                	callq  *%rax
}
  804192:	c9                   	leaveq 
  804193:	c3                   	retq   

0000000000804194 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804194:	55                   	push   %rbp
  804195:	48 89 e5             	mov    %rsp,%rbp
  804198:	48 83 ec 10          	sub    $0x10,%rsp
  80419c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8041a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a4:	48 89 c7             	mov    %rax,%rdi
  8041a7:	48 b8 eb 53 80 00 00 	movabs $0x8053eb,%rax
  8041ae:	00 00 00 
  8041b1:	ff d0                	callq  *%rax
  8041b3:	83 f8 01             	cmp    $0x1,%eax
  8041b6:	75 17                	jne    8041cf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8041b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8041bf:	89 c7                	mov    %eax,%edi
  8041c1:	48 b8 00 45 80 00 00 	movabs $0x804500,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
  8041cd:	eb 05                	jmp    8041d4 <devsock_close+0x40>
	else
		return 0;
  8041cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041d4:	c9                   	leaveq 
  8041d5:	c3                   	retq   

00000000008041d6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8041d6:	55                   	push   %rbp
  8041d7:	48 89 e5             	mov    %rsp,%rbp
  8041da:	48 83 ec 20          	sub    $0x20,%rsp
  8041de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041e5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041eb:	89 c7                	mov    %eax,%edi
  8041ed:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  8041f4:	00 00 00 
  8041f7:	ff d0                	callq  *%rax
  8041f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804200:	79 05                	jns    804207 <connect+0x31>
		return r;
  804202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804205:	eb 1b                	jmp    804222 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804207:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80420a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80420e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804211:	48 89 ce             	mov    %rcx,%rsi
  804214:	89 c7                	mov    %eax,%edi
  804216:	48 b8 2d 45 80 00 00 	movabs $0x80452d,%rax
  80421d:	00 00 00 
  804220:	ff d0                	callq  *%rax
}
  804222:	c9                   	leaveq 
  804223:	c3                   	retq   

0000000000804224 <listen>:

int
listen(int s, int backlog)
{
  804224:	55                   	push   %rbp
  804225:	48 89 e5             	mov    %rsp,%rbp
  804228:	48 83 ec 20          	sub    $0x20,%rsp
  80422c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80422f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804232:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804235:	89 c7                	mov    %eax,%edi
  804237:	48 b8 9c 3f 80 00 00 	movabs $0x803f9c,%rax
  80423e:	00 00 00 
  804241:	ff d0                	callq  *%rax
  804243:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804246:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80424a:	79 05                	jns    804251 <listen+0x2d>
		return r;
  80424c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424f:	eb 16                	jmp    804267 <listen+0x43>
	return nsipc_listen(r, backlog);
  804251:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804257:	89 d6                	mov    %edx,%esi
  804259:	89 c7                	mov    %eax,%edi
  80425b:	48 b8 91 45 80 00 00 	movabs $0x804591,%rax
  804262:	00 00 00 
  804265:	ff d0                	callq  *%rax
}
  804267:	c9                   	leaveq 
  804268:	c3                   	retq   

0000000000804269 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804269:	55                   	push   %rbp
  80426a:	48 89 e5             	mov    %rsp,%rbp
  80426d:	48 83 ec 20          	sub    $0x20,%rsp
  804271:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804275:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804279:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80427d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804281:	89 c2                	mov    %eax,%edx
  804283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804287:	8b 40 0c             	mov    0xc(%rax),%eax
  80428a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80428e:	b9 00 00 00 00       	mov    $0x0,%ecx
  804293:	89 c7                	mov    %eax,%edi
  804295:	48 b8 d1 45 80 00 00 	movabs $0x8045d1,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
}
  8042a1:	c9                   	leaveq 
  8042a2:	c3                   	retq   

00000000008042a3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8042a3:	55                   	push   %rbp
  8042a4:	48 89 e5             	mov    %rsp,%rbp
  8042a7:	48 83 ec 20          	sub    $0x20,%rsp
  8042ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8042b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8042b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042bb:	89 c2                	mov    %eax,%edx
  8042bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8042c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8042c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8042cd:	89 c7                	mov    %eax,%edi
  8042cf:	48 b8 9d 46 80 00 00 	movabs $0x80469d,%rax
  8042d6:	00 00 00 
  8042d9:	ff d0                	callq  *%rax
}
  8042db:	c9                   	leaveq 
  8042dc:	c3                   	retq   

00000000008042dd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8042dd:	55                   	push   %rbp
  8042de:	48 89 e5             	mov    %rsp,%rbp
  8042e1:	48 83 ec 10          	sub    $0x10,%rsp
  8042e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8042ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f1:	48 be 45 5d 80 00 00 	movabs $0x805d45,%rsi
  8042f8:	00 00 00 
  8042fb:	48 89 c7             	mov    %rax,%rdi
  8042fe:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  804305:	00 00 00 
  804308:	ff d0                	callq  *%rax
	return 0;
  80430a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80430f:	c9                   	leaveq 
  804310:	c3                   	retq   

0000000000804311 <socket>:

int
socket(int domain, int type, int protocol)
{
  804311:	55                   	push   %rbp
  804312:	48 89 e5             	mov    %rsp,%rbp
  804315:	48 83 ec 20          	sub    $0x20,%rsp
  804319:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80431c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80431f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804322:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804325:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80432b:	89 ce                	mov    %ecx,%esi
  80432d:	89 c7                	mov    %eax,%edi
  80432f:	48 b8 55 47 80 00 00 	movabs $0x804755,%rax
  804336:	00 00 00 
  804339:	ff d0                	callq  *%rax
  80433b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80433e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804342:	79 05                	jns    804349 <socket+0x38>
		return r;
  804344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804347:	eb 11                	jmp    80435a <socket+0x49>
	return alloc_sockfd(r);
  804349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434c:	89 c7                	mov    %eax,%edi
  80434e:	48 b8 f3 3f 80 00 00 	movabs $0x803ff3,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
}
  80435a:	c9                   	leaveq 
  80435b:	c3                   	retq   

000000000080435c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80435c:	55                   	push   %rbp
  80435d:	48 89 e5             	mov    %rsp,%rbp
  804360:	48 83 ec 10          	sub    $0x10,%rsp
  804364:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804367:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80436e:	00 00 00 
  804371:	8b 00                	mov    (%rax),%eax
  804373:	85 c0                	test   %eax,%eax
  804375:	75 1d                	jne    804394 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804377:	bf 02 00 00 00       	mov    $0x2,%edi
  80437c:	48 b8 69 53 80 00 00 	movabs $0x805369,%rax
  804383:	00 00 00 
  804386:	ff d0                	callq  *%rax
  804388:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80438f:	00 00 00 
  804392:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804394:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80439b:	00 00 00 
  80439e:	8b 00                	mov    (%rax),%eax
  8043a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8043a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8043a8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8043af:	00 00 00 
  8043b2:	89 c7                	mov    %eax,%edi
  8043b4:	48 b8 07 53 80 00 00 	movabs $0x805307,%rax
  8043bb:	00 00 00 
  8043be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8043c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8043c5:	be 00 00 00 00       	mov    $0x0,%esi
  8043ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8043cf:	48 b8 01 52 80 00 00 	movabs $0x805201,%rax
  8043d6:	00 00 00 
  8043d9:	ff d0                	callq  *%rax
}
  8043db:	c9                   	leaveq 
  8043dc:	c3                   	retq   

00000000008043dd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8043dd:	55                   	push   %rbp
  8043de:	48 89 e5             	mov    %rsp,%rbp
  8043e1:	48 83 ec 30          	sub    $0x30,%rsp
  8043e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8043f0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043f7:	00 00 00 
  8043fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043fd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8043ff:	bf 01 00 00 00       	mov    $0x1,%edi
  804404:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  80440b:	00 00 00 
  80440e:	ff d0                	callq  *%rax
  804410:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804413:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804417:	78 3e                	js     804457 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804419:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804420:	00 00 00 
  804423:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804427:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442b:	8b 40 10             	mov    0x10(%rax),%eax
  80442e:	89 c2                	mov    %eax,%edx
  804430:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804434:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804438:	48 89 ce             	mov    %rcx,%rsi
  80443b:	48 89 c7             	mov    %rax,%rdi
  80443e:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804445:	00 00 00 
  804448:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80444a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80444e:	8b 50 10             	mov    0x10(%rax),%edx
  804451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804455:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804457:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80445a:	c9                   	leaveq 
  80445b:	c3                   	retq   

000000000080445c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80445c:	55                   	push   %rbp
  80445d:	48 89 e5             	mov    %rsp,%rbp
  804460:	48 83 ec 10          	sub    $0x10,%rsp
  804464:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804467:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80446b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80446e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804475:	00 00 00 
  804478:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80447b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80447d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804484:	48 89 c6             	mov    %rax,%rsi
  804487:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80448e:	00 00 00 
  804491:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804498:	00 00 00 
  80449b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80449d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044a4:	00 00 00 
  8044a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044aa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8044ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8044b2:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  8044b9:	00 00 00 
  8044bc:	ff d0                	callq  *%rax
}
  8044be:	c9                   	leaveq 
  8044bf:	c3                   	retq   

00000000008044c0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8044c0:	55                   	push   %rbp
  8044c1:	48 89 e5             	mov    %rsp,%rbp
  8044c4:	48 83 ec 10          	sub    $0x10,%rsp
  8044c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044cb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8044ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044d5:	00 00 00 
  8044d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044db:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8044dd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044e4:	00 00 00 
  8044e7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044ea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8044ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8044f2:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  8044f9:	00 00 00 
  8044fc:	ff d0                	callq  *%rax
}
  8044fe:	c9                   	leaveq 
  8044ff:	c3                   	retq   

0000000000804500 <nsipc_close>:

int
nsipc_close(int s)
{
  804500:	55                   	push   %rbp
  804501:	48 89 e5             	mov    %rsp,%rbp
  804504:	48 83 ec 10          	sub    $0x10,%rsp
  804508:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80450b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804512:	00 00 00 
  804515:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804518:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80451a:	bf 04 00 00 00       	mov    $0x4,%edi
  80451f:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  804526:	00 00 00 
  804529:	ff d0                	callq  *%rax
}
  80452b:	c9                   	leaveq 
  80452c:	c3                   	retq   

000000000080452d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80452d:	55                   	push   %rbp
  80452e:	48 89 e5             	mov    %rsp,%rbp
  804531:	48 83 ec 10          	sub    $0x10,%rsp
  804535:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804538:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80453c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80453f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804546:	00 00 00 
  804549:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80454c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80454e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804555:	48 89 c6             	mov    %rax,%rsi
  804558:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80455f:	00 00 00 
  804562:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804569:	00 00 00 
  80456c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80456e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804575:	00 00 00 
  804578:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80457b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80457e:	bf 05 00 00 00       	mov    $0x5,%edi
  804583:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  80458a:	00 00 00 
  80458d:	ff d0                	callq  *%rax
}
  80458f:	c9                   	leaveq 
  804590:	c3                   	retq   

0000000000804591 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804591:	55                   	push   %rbp
  804592:	48 89 e5             	mov    %rsp,%rbp
  804595:	48 83 ec 10          	sub    $0x10,%rsp
  804599:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80459c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80459f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045a6:	00 00 00 
  8045a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8045ac:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8045ae:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045b5:	00 00 00 
  8045b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045bb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8045be:	bf 06 00 00 00       	mov    $0x6,%edi
  8045c3:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  8045ca:	00 00 00 
  8045cd:	ff d0                	callq  *%rax
}
  8045cf:	c9                   	leaveq 
  8045d0:	c3                   	retq   

00000000008045d1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8045d1:	55                   	push   %rbp
  8045d2:	48 89 e5             	mov    %rsp,%rbp
  8045d5:	48 83 ec 30          	sub    $0x30,%rsp
  8045d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045e0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8045e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8045e6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045ed:	00 00 00 
  8045f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8045f5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045fc:	00 00 00 
  8045ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804602:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804605:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80460c:	00 00 00 
  80460f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804612:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804615:	bf 07 00 00 00       	mov    $0x7,%edi
  80461a:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  804621:	00 00 00 
  804624:	ff d0                	callq  *%rax
  804626:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804629:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80462d:	78 69                	js     804698 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80462f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804636:	7f 08                	jg     804640 <nsipc_recv+0x6f>
  804638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80463e:	7e 35                	jle    804675 <nsipc_recv+0xa4>
  804640:	48 b9 4c 5d 80 00 00 	movabs $0x805d4c,%rcx
  804647:	00 00 00 
  80464a:	48 ba 61 5d 80 00 00 	movabs $0x805d61,%rdx
  804651:	00 00 00 
  804654:	be 61 00 00 00       	mov    $0x61,%esi
  804659:	48 bf 76 5d 80 00 00 	movabs $0x805d76,%rdi
  804660:	00 00 00 
  804663:	b8 00 00 00 00       	mov    $0x0,%eax
  804668:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  80466f:	00 00 00 
  804672:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804675:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804678:	48 63 d0             	movslq %eax,%rdx
  80467b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80467f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804686:	00 00 00 
  804689:	48 89 c7             	mov    %rax,%rdi
  80468c:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  804693:	00 00 00 
  804696:	ff d0                	callq  *%rax
	}

	return r;
  804698:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80469b:	c9                   	leaveq 
  80469c:	c3                   	retq   

000000000080469d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80469d:	55                   	push   %rbp
  80469e:	48 89 e5             	mov    %rsp,%rbp
  8046a1:	48 83 ec 20          	sub    $0x20,%rsp
  8046a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8046a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8046ac:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8046af:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8046b2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046b9:	00 00 00 
  8046bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046bf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8046c1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8046c8:	7e 35                	jle    8046ff <nsipc_send+0x62>
  8046ca:	48 b9 82 5d 80 00 00 	movabs $0x805d82,%rcx
  8046d1:	00 00 00 
  8046d4:	48 ba 61 5d 80 00 00 	movabs $0x805d61,%rdx
  8046db:	00 00 00 
  8046de:	be 6c 00 00 00       	mov    $0x6c,%esi
  8046e3:	48 bf 76 5d 80 00 00 	movabs $0x805d76,%rdi
  8046ea:	00 00 00 
  8046ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f2:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  8046f9:	00 00 00 
  8046fc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8046ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804702:	48 63 d0             	movslq %eax,%rdx
  804705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804709:	48 89 c6             	mov    %rax,%rsi
  80470c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804713:	00 00 00 
  804716:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  80471d:	00 00 00 
  804720:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804722:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804729:	00 00 00 
  80472c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80472f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804732:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804739:	00 00 00 
  80473c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80473f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804742:	bf 08 00 00 00       	mov    $0x8,%edi
  804747:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  80474e:	00 00 00 
  804751:	ff d0                	callq  *%rax
}
  804753:	c9                   	leaveq 
  804754:	c3                   	retq   

0000000000804755 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804755:	55                   	push   %rbp
  804756:	48 89 e5             	mov    %rsp,%rbp
  804759:	48 83 ec 10          	sub    $0x10,%rsp
  80475d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804760:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804763:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804766:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80476d:	00 00 00 
  804770:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804773:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804775:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80477c:	00 00 00 
  80477f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804782:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804785:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80478c:	00 00 00 
  80478f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804792:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804795:	bf 09 00 00 00       	mov    $0x9,%edi
  80479a:	48 b8 5c 43 80 00 00 	movabs $0x80435c,%rax
  8047a1:	00 00 00 
  8047a4:	ff d0                	callq  *%rax
}
  8047a6:	c9                   	leaveq 
  8047a7:	c3                   	retq   

00000000008047a8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8047a8:	55                   	push   %rbp
  8047a9:	48 89 e5             	mov    %rsp,%rbp
  8047ac:	53                   	push   %rbx
  8047ad:	48 83 ec 38          	sub    $0x38,%rsp
  8047b1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8047b5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8047b9:	48 89 c7             	mov    %rax,%rdi
  8047bc:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  8047c3:	00 00 00 
  8047c6:	ff d0                	callq  *%rax
  8047c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047cf:	0f 88 bf 01 00 00    	js     804994 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8047de:	48 89 c6             	mov    %rax,%rsi
  8047e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e6:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  8047ed:	00 00 00 
  8047f0:	ff d0                	callq  *%rax
  8047f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047f9:	0f 88 95 01 00 00    	js     804994 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8047ff:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804803:	48 89 c7             	mov    %rax,%rdi
  804806:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  80480d:	00 00 00 
  804810:	ff d0                	callq  *%rax
  804812:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804815:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804819:	0f 88 5d 01 00 00    	js     80497c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80481f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804823:	ba 07 04 00 00       	mov    $0x407,%edx
  804828:	48 89 c6             	mov    %rax,%rsi
  80482b:	bf 00 00 00 00       	mov    $0x0,%edi
  804830:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804837:	00 00 00 
  80483a:	ff d0                	callq  *%rax
  80483c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80483f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804843:	0f 88 33 01 00 00    	js     80497c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80484d:	48 89 c7             	mov    %rax,%rdi
  804850:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804857:	00 00 00 
  80485a:	ff d0                	callq  *%rax
  80485c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804860:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804864:	ba 07 04 00 00       	mov    $0x407,%edx
  804869:	48 89 c6             	mov    %rax,%rsi
  80486c:	bf 00 00 00 00       	mov    $0x0,%edi
  804871:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
  80487d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804880:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804884:	79 05                	jns    80488b <pipe+0xe3>
		goto err2;
  804886:	e9 d9 00 00 00       	jmpq   804964 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80488b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80488f:	48 89 c7             	mov    %rax,%rdi
  804892:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804899:	00 00 00 
  80489c:	ff d0                	callq  *%rax
  80489e:	48 89 c2             	mov    %rax,%rdx
  8048a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048a5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8048ab:	48 89 d1             	mov    %rdx,%rcx
  8048ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8048b3:	48 89 c6             	mov    %rax,%rsi
  8048b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8048bb:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8048c2:	00 00 00 
  8048c5:	ff d0                	callq  *%rax
  8048c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048ce:	79 1b                	jns    8048eb <pipe+0x143>
		goto err3;
  8048d0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8048d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d5:	48 89 c6             	mov    %rax,%rsi
  8048d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8048dd:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  8048e4:	00 00 00 
  8048e7:	ff d0                	callq  *%rax
  8048e9:	eb 79                	jmp    804964 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8048eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ef:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8048f6:	00 00 00 
  8048f9:	8b 12                	mov    (%rdx),%edx
  8048fb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8048fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804901:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804908:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80490c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804913:	00 00 00 
  804916:	8b 12                	mov    (%rdx),%edx
  804918:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80491a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80491e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804929:	48 89 c7             	mov    %rax,%rdi
  80492c:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  804933:	00 00 00 
  804936:	ff d0                	callq  *%rax
  804938:	89 c2                	mov    %eax,%edx
  80493a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80493e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804940:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804944:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804948:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80494c:	48 89 c7             	mov    %rax,%rdi
  80494f:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  804956:	00 00 00 
  804959:	ff d0                	callq  *%rax
  80495b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80495d:	b8 00 00 00 00       	mov    $0x0,%eax
  804962:	eb 33                	jmp    804997 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804964:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804968:	48 89 c6             	mov    %rax,%rsi
  80496b:	bf 00 00 00 00       	mov    $0x0,%edi
  804970:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804977:	00 00 00 
  80497a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80497c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804980:	48 89 c6             	mov    %rax,%rsi
  804983:	bf 00 00 00 00       	mov    $0x0,%edi
  804988:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  80498f:	00 00 00 
  804992:	ff d0                	callq  *%rax
err:
	return r;
  804994:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804997:	48 83 c4 38          	add    $0x38,%rsp
  80499b:	5b                   	pop    %rbx
  80499c:	5d                   	pop    %rbp
  80499d:	c3                   	retq   

000000000080499e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80499e:	55                   	push   %rbp
  80499f:	48 89 e5             	mov    %rsp,%rbp
  8049a2:	53                   	push   %rbx
  8049a3:	48 83 ec 28          	sub    $0x28,%rsp
  8049a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8049af:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049b6:	00 00 00 
  8049b9:	48 8b 00             	mov    (%rax),%rax
  8049bc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8049c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8049c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049c9:	48 89 c7             	mov    %rax,%rdi
  8049cc:	48 b8 eb 53 80 00 00 	movabs $0x8053eb,%rax
  8049d3:	00 00 00 
  8049d6:	ff d0                	callq  *%rax
  8049d8:	89 c3                	mov    %eax,%ebx
  8049da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049de:	48 89 c7             	mov    %rax,%rdi
  8049e1:	48 b8 eb 53 80 00 00 	movabs $0x8053eb,%rax
  8049e8:	00 00 00 
  8049eb:	ff d0                	callq  *%rax
  8049ed:	39 c3                	cmp    %eax,%ebx
  8049ef:	0f 94 c0             	sete   %al
  8049f2:	0f b6 c0             	movzbl %al,%eax
  8049f5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8049f8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049ff:	00 00 00 
  804a02:	48 8b 00             	mov    (%rax),%rax
  804a05:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804a0b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804a0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a11:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a14:	75 05                	jne    804a1b <_pipeisclosed+0x7d>
			return ret;
  804a16:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a19:	eb 4f                	jmp    804a6a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804a1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a1e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a21:	74 42                	je     804a65 <_pipeisclosed+0xc7>
  804a23:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804a27:	75 3c                	jne    804a65 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804a29:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a30:	00 00 00 
  804a33:	48 8b 00             	mov    (%rax),%rax
  804a36:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804a3c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a42:	89 c6                	mov    %eax,%esi
  804a44:	48 bf 93 5d 80 00 00 	movabs $0x805d93,%rdi
  804a4b:	00 00 00 
  804a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a53:	49 b8 8f 05 80 00 00 	movabs $0x80058f,%r8
  804a5a:	00 00 00 
  804a5d:	41 ff d0             	callq  *%r8
	}
  804a60:	e9 4a ff ff ff       	jmpq   8049af <_pipeisclosed+0x11>
  804a65:	e9 45 ff ff ff       	jmpq   8049af <_pipeisclosed+0x11>
}
  804a6a:	48 83 c4 28          	add    $0x28,%rsp
  804a6e:	5b                   	pop    %rbx
  804a6f:	5d                   	pop    %rbp
  804a70:	c3                   	retq   

0000000000804a71 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804a71:	55                   	push   %rbp
  804a72:	48 89 e5             	mov    %rsp,%rbp
  804a75:	48 83 ec 30          	sub    $0x30,%rsp
  804a79:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a7c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804a80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804a83:	48 89 d6             	mov    %rdx,%rsi
  804a86:	89 c7                	mov    %eax,%edi
  804a88:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  804a8f:	00 00 00 
  804a92:	ff d0                	callq  *%rax
  804a94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a9b:	79 05                	jns    804aa2 <pipeisclosed+0x31>
		return r;
  804a9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aa0:	eb 31                	jmp    804ad3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa6:	48 89 c7             	mov    %rax,%rdi
  804aa9:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804ab0:	00 00 00 
  804ab3:	ff d0                	callq  *%rax
  804ab5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804abd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ac1:	48 89 d6             	mov    %rdx,%rsi
  804ac4:	48 89 c7             	mov    %rax,%rdi
  804ac7:	48 b8 9e 49 80 00 00 	movabs $0x80499e,%rax
  804ace:	00 00 00 
  804ad1:	ff d0                	callq  *%rax
}
  804ad3:	c9                   	leaveq 
  804ad4:	c3                   	retq   

0000000000804ad5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804ad5:	55                   	push   %rbp
  804ad6:	48 89 e5             	mov    %rsp,%rbp
  804ad9:	48 83 ec 40          	sub    $0x40,%rsp
  804add:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804ae1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804ae5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804aed:	48 89 c7             	mov    %rax,%rdi
  804af0:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804af7:	00 00 00 
  804afa:	ff d0                	callq  *%rax
  804afc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b08:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b0f:	00 
  804b10:	e9 92 00 00 00       	jmpq   804ba7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804b15:	eb 41                	jmp    804b58 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804b17:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b1c:	74 09                	je     804b27 <devpipe_read+0x52>
				return i;
  804b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b22:	e9 92 00 00 00       	jmpq   804bb9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b2f:	48 89 d6             	mov    %rdx,%rsi
  804b32:	48 89 c7             	mov    %rax,%rdi
  804b35:	48 b8 9e 49 80 00 00 	movabs $0x80499e,%rax
  804b3c:	00 00 00 
  804b3f:	ff d0                	callq  *%rax
  804b41:	85 c0                	test   %eax,%eax
  804b43:	74 07                	je     804b4c <devpipe_read+0x77>
				return 0;
  804b45:	b8 00 00 00 00       	mov    $0x0,%eax
  804b4a:	eb 6d                	jmp    804bb9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804b4c:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804b53:	00 00 00 
  804b56:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b5c:	8b 10                	mov    (%rax),%edx
  804b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b62:	8b 40 04             	mov    0x4(%rax),%eax
  804b65:	39 c2                	cmp    %eax,%edx
  804b67:	74 ae                	je     804b17 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b71:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b79:	8b 00                	mov    (%rax),%eax
  804b7b:	99                   	cltd   
  804b7c:	c1 ea 1b             	shr    $0x1b,%edx
  804b7f:	01 d0                	add    %edx,%eax
  804b81:	83 e0 1f             	and    $0x1f,%eax
  804b84:	29 d0                	sub    %edx,%eax
  804b86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b8a:	48 98                	cltq   
  804b8c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804b91:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b97:	8b 00                	mov    (%rax),%eax
  804b99:	8d 50 01             	lea    0x1(%rax),%edx
  804b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ba0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804ba2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bab:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804baf:	0f 82 60 ff ff ff    	jb     804b15 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804bb9:	c9                   	leaveq 
  804bba:	c3                   	retq   

0000000000804bbb <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804bbb:	55                   	push   %rbp
  804bbc:	48 89 e5             	mov    %rsp,%rbp
  804bbf:	48 83 ec 40          	sub    $0x40,%rsp
  804bc3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804bc7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804bcb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804bcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bd3:	48 89 c7             	mov    %rax,%rdi
  804bd6:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804bdd:	00 00 00 
  804be0:	ff d0                	callq  *%rax
  804be2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804be6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804bee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804bf5:	00 
  804bf6:	e9 8e 00 00 00       	jmpq   804c89 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804bfb:	eb 31                	jmp    804c2e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804bfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c05:	48 89 d6             	mov    %rdx,%rsi
  804c08:	48 89 c7             	mov    %rax,%rdi
  804c0b:	48 b8 9e 49 80 00 00 	movabs $0x80499e,%rax
  804c12:	00 00 00 
  804c15:	ff d0                	callq  *%rax
  804c17:	85 c0                	test   %eax,%eax
  804c19:	74 07                	je     804c22 <devpipe_write+0x67>
				return 0;
  804c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  804c20:	eb 79                	jmp    804c9b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804c22:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804c29:	00 00 00 
  804c2c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c32:	8b 40 04             	mov    0x4(%rax),%eax
  804c35:	48 63 d0             	movslq %eax,%rdx
  804c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c3c:	8b 00                	mov    (%rax),%eax
  804c3e:	48 98                	cltq   
  804c40:	48 83 c0 20          	add    $0x20,%rax
  804c44:	48 39 c2             	cmp    %rax,%rdx
  804c47:	73 b4                	jae    804bfd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804c49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c4d:	8b 40 04             	mov    0x4(%rax),%eax
  804c50:	99                   	cltd   
  804c51:	c1 ea 1b             	shr    $0x1b,%edx
  804c54:	01 d0                	add    %edx,%eax
  804c56:	83 e0 1f             	and    $0x1f,%eax
  804c59:	29 d0                	sub    %edx,%eax
  804c5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804c5f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804c63:	48 01 ca             	add    %rcx,%rdx
  804c66:	0f b6 0a             	movzbl (%rdx),%ecx
  804c69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c6d:	48 98                	cltq   
  804c6f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c77:	8b 40 04             	mov    0x4(%rax),%eax
  804c7a:	8d 50 01             	lea    0x1(%rax),%edx
  804c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c81:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c84:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c8d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c91:	0f 82 64 ff ff ff    	jb     804bfb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804c9b:	c9                   	leaveq 
  804c9c:	c3                   	retq   

0000000000804c9d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804c9d:	55                   	push   %rbp
  804c9e:	48 89 e5             	mov    %rsp,%rbp
  804ca1:	48 83 ec 20          	sub    $0x20,%rsp
  804ca5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ca9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804cb1:	48 89 c7             	mov    %rax,%rdi
  804cb4:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804cbb:	00 00 00 
  804cbe:	ff d0                	callq  *%rax
  804cc0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cc8:	48 be a6 5d 80 00 00 	movabs $0x805da6,%rsi
  804ccf:	00 00 00 
  804cd2:	48 89 c7             	mov    %rax,%rdi
  804cd5:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  804cdc:	00 00 00 
  804cdf:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ce5:	8b 50 04             	mov    0x4(%rax),%edx
  804ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cec:	8b 00                	mov    (%rax),%eax
  804cee:	29 c2                	sub    %eax,%edx
  804cf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cf4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804cfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cfe:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804d05:	00 00 00 
	stat->st_dev = &devpipe;
  804d08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d0c:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804d13:	00 00 00 
  804d16:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d22:	c9                   	leaveq 
  804d23:	c3                   	retq   

0000000000804d24 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804d24:	55                   	push   %rbp
  804d25:	48 89 e5             	mov    %rsp,%rbp
  804d28:	48 83 ec 10          	sub    $0x10,%rsp
  804d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d34:	48 89 c6             	mov    %rax,%rsi
  804d37:	bf 00 00 00 00       	mov    $0x0,%edi
  804d3c:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804d43:	00 00 00 
  804d46:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d4c:	48 89 c7             	mov    %rax,%rdi
  804d4f:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  804d56:	00 00 00 
  804d59:	ff d0                	callq  *%rax
  804d5b:	48 89 c6             	mov    %rax,%rsi
  804d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  804d63:	48 b8 1e 1b 80 00 00 	movabs $0x801b1e,%rax
  804d6a:	00 00 00 
  804d6d:	ff d0                	callq  *%rax
}
  804d6f:	c9                   	leaveq 
  804d70:	c3                   	retq   

0000000000804d71 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804d71:	55                   	push   %rbp
  804d72:	48 89 e5             	mov    %rsp,%rbp
  804d75:	48 83 ec 20          	sub    $0x20,%rsp
  804d79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804d7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804d80:	75 35                	jne    804db7 <wait+0x46>
  804d82:	48 b9 ad 5d 80 00 00 	movabs $0x805dad,%rcx
  804d89:	00 00 00 
  804d8c:	48 ba b8 5d 80 00 00 	movabs $0x805db8,%rdx
  804d93:	00 00 00 
  804d96:	be 09 00 00 00       	mov    $0x9,%esi
  804d9b:	48 bf cd 5d 80 00 00 	movabs $0x805dcd,%rdi
  804da2:	00 00 00 
  804da5:	b8 00 00 00 00       	mov    $0x0,%eax
  804daa:	49 b8 56 03 80 00 00 	movabs $0x800356,%r8
  804db1:	00 00 00 
  804db4:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dba:	25 ff 03 00 00       	and    $0x3ff,%eax
  804dbf:	48 63 d0             	movslq %eax,%rdx
  804dc2:	48 89 d0             	mov    %rdx,%rax
  804dc5:	48 c1 e0 03          	shl    $0x3,%rax
  804dc9:	48 01 d0             	add    %rdx,%rax
  804dcc:	48 c1 e0 05          	shl    $0x5,%rax
  804dd0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804dd7:	00 00 00 
  804dda:	48 01 d0             	add    %rdx,%rax
  804ddd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804de1:	eb 0c                	jmp    804def <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  804de3:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804dea:	00 00 00 
  804ded:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  804def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804df3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804df9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804dfc:	75 0e                	jne    804e0c <wait+0x9b>
  804dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804e02:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804e08:	85 c0                	test   %eax,%eax
  804e0a:	75 d7                	jne    804de3 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  804e0c:	c9                   	leaveq 
  804e0d:	c3                   	retq   

0000000000804e0e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804e0e:	55                   	push   %rbp
  804e0f:	48 89 e5             	mov    %rsp,%rbp
  804e12:	48 83 ec 20          	sub    $0x20,%rsp
  804e16:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e1c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804e1f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804e23:	be 01 00 00 00       	mov    $0x1,%esi
  804e28:	48 89 c7             	mov    %rax,%rdi
  804e2b:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  804e32:	00 00 00 
  804e35:	ff d0                	callq  *%rax
}
  804e37:	c9                   	leaveq 
  804e38:	c3                   	retq   

0000000000804e39 <getchar>:

int
getchar(void)
{
  804e39:	55                   	push   %rbp
  804e3a:	48 89 e5             	mov    %rsp,%rbp
  804e3d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804e41:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804e45:	ba 01 00 00 00       	mov    $0x1,%edx
  804e4a:	48 89 c6             	mov    %rax,%rsi
  804e4d:	bf 00 00 00 00       	mov    $0x0,%edi
  804e52:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  804e59:	00 00 00 
  804e5c:	ff d0                	callq  *%rax
  804e5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804e61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e65:	79 05                	jns    804e6c <getchar+0x33>
		return r;
  804e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e6a:	eb 14                	jmp    804e80 <getchar+0x47>
	if (r < 1)
  804e6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e70:	7f 07                	jg     804e79 <getchar+0x40>
		return -E_EOF;
  804e72:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804e77:	eb 07                	jmp    804e80 <getchar+0x47>
	return c;
  804e79:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804e7d:	0f b6 c0             	movzbl %al,%eax
}
  804e80:	c9                   	leaveq 
  804e81:	c3                   	retq   

0000000000804e82 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804e82:	55                   	push   %rbp
  804e83:	48 89 e5             	mov    %rsp,%rbp
  804e86:	48 83 ec 20          	sub    $0x20,%rsp
  804e8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804e8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804e91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804e94:	48 89 d6             	mov    %rdx,%rsi
  804e97:	89 c7                	mov    %eax,%edi
  804e99:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  804ea0:	00 00 00 
  804ea3:	ff d0                	callq  *%rax
  804ea5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804eac:	79 05                	jns    804eb3 <iscons+0x31>
		return r;
  804eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804eb1:	eb 1a                	jmp    804ecd <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804eb7:	8b 10                	mov    (%rax),%edx
  804eb9:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804ec0:	00 00 00 
  804ec3:	8b 00                	mov    (%rax),%eax
  804ec5:	39 c2                	cmp    %eax,%edx
  804ec7:	0f 94 c0             	sete   %al
  804eca:	0f b6 c0             	movzbl %al,%eax
}
  804ecd:	c9                   	leaveq 
  804ece:	c3                   	retq   

0000000000804ecf <opencons>:

int
opencons(void)
{
  804ecf:	55                   	push   %rbp
  804ed0:	48 89 e5             	mov    %rsp,%rbp
  804ed3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804ed7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804edb:	48 89 c7             	mov    %rax,%rdi
  804ede:	48 b8 92 24 80 00 00 	movabs $0x802492,%rax
  804ee5:	00 00 00 
  804ee8:	ff d0                	callq  *%rax
  804eea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804eed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ef1:	79 05                	jns    804ef8 <opencons+0x29>
		return r;
  804ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ef6:	eb 5b                	jmp    804f53 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804efc:	ba 07 04 00 00       	mov    $0x407,%edx
  804f01:	48 89 c6             	mov    %rax,%rsi
  804f04:	bf 00 00 00 00       	mov    $0x0,%edi
  804f09:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  804f10:	00 00 00 
  804f13:	ff d0                	callq  *%rax
  804f15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f1c:	79 05                	jns    804f23 <opencons+0x54>
		return r;
  804f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f21:	eb 30                	jmp    804f53 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f27:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804f2e:	00 00 00 
  804f31:	8b 12                	mov    (%rdx),%edx
  804f33:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f39:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f44:	48 89 c7             	mov    %rax,%rdi
  804f47:	48 b8 44 24 80 00 00 	movabs $0x802444,%rax
  804f4e:	00 00 00 
  804f51:	ff d0                	callq  *%rax
}
  804f53:	c9                   	leaveq 
  804f54:	c3                   	retq   

0000000000804f55 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804f55:	55                   	push   %rbp
  804f56:	48 89 e5             	mov    %rsp,%rbp
  804f59:	48 83 ec 30          	sub    $0x30,%rsp
  804f5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804f61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804f65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804f69:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804f6e:	75 07                	jne    804f77 <devcons_read+0x22>
		return 0;
  804f70:	b8 00 00 00 00       	mov    $0x0,%eax
  804f75:	eb 4b                	jmp    804fc2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804f77:	eb 0c                	jmp    804f85 <devcons_read+0x30>
		sys_yield();
  804f79:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  804f80:	00 00 00 
  804f83:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804f85:	48 b8 75 19 80 00 00 	movabs $0x801975,%rax
  804f8c:	00 00 00 
  804f8f:	ff d0                	callq  *%rax
  804f91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f98:	74 df                	je     804f79 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f9e:	79 05                	jns    804fa5 <devcons_read+0x50>
		return c;
  804fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fa3:	eb 1d                	jmp    804fc2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804fa5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804fa9:	75 07                	jne    804fb2 <devcons_read+0x5d>
		return 0;
  804fab:	b8 00 00 00 00       	mov    $0x0,%eax
  804fb0:	eb 10                	jmp    804fc2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb5:	89 c2                	mov    %eax,%edx
  804fb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804fbb:	88 10                	mov    %dl,(%rax)
	return 1;
  804fbd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804fc2:	c9                   	leaveq 
  804fc3:	c3                   	retq   

0000000000804fc4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804fc4:	55                   	push   %rbp
  804fc5:	48 89 e5             	mov    %rsp,%rbp
  804fc8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804fcf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804fd6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804fdd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804fe4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804feb:	eb 76                	jmp    805063 <devcons_write+0x9f>
		m = n - tot;
  804fed:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804ff4:	89 c2                	mov    %eax,%edx
  804ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ff9:	29 c2                	sub    %eax,%edx
  804ffb:	89 d0                	mov    %edx,%eax
  804ffd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  805000:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805003:	83 f8 7f             	cmp    $0x7f,%eax
  805006:	76 07                	jbe    80500f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  805008:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80500f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805012:	48 63 d0             	movslq %eax,%rdx
  805015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805018:	48 63 c8             	movslq %eax,%rcx
  80501b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  805022:	48 01 c1             	add    %rax,%rcx
  805025:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80502c:	48 89 ce             	mov    %rcx,%rsi
  80502f:	48 89 c7             	mov    %rax,%rdi
  805032:	48 b8 68 14 80 00 00 	movabs $0x801468,%rax
  805039:	00 00 00 
  80503c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80503e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805041:	48 63 d0             	movslq %eax,%rdx
  805044:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80504b:	48 89 d6             	mov    %rdx,%rsi
  80504e:	48 89 c7             	mov    %rax,%rdi
  805051:	48 b8 2b 19 80 00 00 	movabs $0x80192b,%rax
  805058:	00 00 00 
  80505b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80505d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805060:	01 45 fc             	add    %eax,-0x4(%rbp)
  805063:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805066:	48 98                	cltq   
  805068:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80506f:	0f 82 78 ff ff ff    	jb     804fed <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  805075:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805078:	c9                   	leaveq 
  805079:	c3                   	retq   

000000000080507a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80507a:	55                   	push   %rbp
  80507b:	48 89 e5             	mov    %rsp,%rbp
  80507e:	48 83 ec 08          	sub    $0x8,%rsp
  805082:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  805086:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80508b:	c9                   	leaveq 
  80508c:	c3                   	retq   

000000000080508d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80508d:	55                   	push   %rbp
  80508e:	48 89 e5             	mov    %rsp,%rbp
  805091:	48 83 ec 10          	sub    $0x10,%rsp
  805095:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805099:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80509d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050a1:	48 be dd 5d 80 00 00 	movabs $0x805ddd,%rsi
  8050a8:	00 00 00 
  8050ab:	48 89 c7             	mov    %rax,%rdi
  8050ae:	48 b8 44 11 80 00 00 	movabs $0x801144,%rax
  8050b5:	00 00 00 
  8050b8:	ff d0                	callq  *%rax
	return 0;
  8050ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050bf:	c9                   	leaveq 
  8050c0:	c3                   	retq   

00000000008050c1 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8050c1:	55                   	push   %rbp
  8050c2:	48 89 e5             	mov    %rsp,%rbp
  8050c5:	48 83 ec 10          	sub    $0x10,%rsp
  8050c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8050cd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8050d4:	00 00 00 
  8050d7:	48 8b 00             	mov    (%rax),%rax
  8050da:	48 85 c0             	test   %rax,%rax
  8050dd:	0f 85 84 00 00 00    	jne    805167 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8050e3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8050ea:	00 00 00 
  8050ed:	48 8b 00             	mov    (%rax),%rax
  8050f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8050f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8050fb:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805100:	89 c7                	mov    %eax,%edi
  805102:	48 b8 73 1a 80 00 00 	movabs $0x801a73,%rax
  805109:	00 00 00 
  80510c:	ff d0                	callq  *%rax
  80510e:	85 c0                	test   %eax,%eax
  805110:	79 2a                	jns    80513c <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  805112:	48 ba e8 5d 80 00 00 	movabs $0x805de8,%rdx
  805119:	00 00 00 
  80511c:	be 23 00 00 00       	mov    $0x23,%esi
  805121:	48 bf 0f 5e 80 00 00 	movabs $0x805e0f,%rdi
  805128:	00 00 00 
  80512b:	b8 00 00 00 00       	mov    $0x0,%eax
  805130:	48 b9 56 03 80 00 00 	movabs $0x800356,%rcx
  805137:	00 00 00 
  80513a:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80513c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805143:	00 00 00 
  805146:	48 8b 00             	mov    (%rax),%rax
  805149:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80514f:	48 be 7a 51 80 00 00 	movabs $0x80517a,%rsi
  805156:	00 00 00 
  805159:	89 c7                	mov    %eax,%edi
  80515b:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  805162:	00 00 00 
  805165:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  805167:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80516e:	00 00 00 
  805171:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805175:	48 89 10             	mov    %rdx,(%rax)
}
  805178:	c9                   	leaveq 
  805179:	c3                   	retq   

000000000080517a <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80517a:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80517d:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  805184:	00 00 00 
call *%rax
  805187:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  805189:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805190:	00 
	movq 152(%rsp), %rcx  //Load RSP
  805191:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  805198:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  805199:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  80519d:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  8051a0:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8051a7:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8051a8:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8051ac:	4c 8b 3c 24          	mov    (%rsp),%r15
  8051b0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8051b5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8051ba:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8051bf:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8051c4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8051c9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8051ce:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8051d3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8051d8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8051dd:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8051e2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8051e7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8051ec:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8051f1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8051f6:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8051fa:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8051fe:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8051ff:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  805200:	c3                   	retq   

0000000000805201 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805201:	55                   	push   %rbp
  805202:	48 89 e5             	mov    %rsp,%rbp
  805205:	48 83 ec 30          	sub    $0x30,%rsp
  805209:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80520d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805211:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  805215:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80521c:	00 00 00 
  80521f:	48 8b 00             	mov    (%rax),%rax
  805222:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  805228:	85 c0                	test   %eax,%eax
  80522a:	75 3c                	jne    805268 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80522c:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  805233:	00 00 00 
  805236:	ff d0                	callq  *%rax
  805238:	25 ff 03 00 00       	and    $0x3ff,%eax
  80523d:	48 63 d0             	movslq %eax,%rdx
  805240:	48 89 d0             	mov    %rdx,%rax
  805243:	48 c1 e0 03          	shl    $0x3,%rax
  805247:	48 01 d0             	add    %rdx,%rax
  80524a:	48 c1 e0 05          	shl    $0x5,%rax
  80524e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805255:	00 00 00 
  805258:	48 01 c2             	add    %rax,%rdx
  80525b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  805262:	00 00 00 
  805265:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  805268:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80526d:	75 0e                	jne    80527d <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80526f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805276:	00 00 00 
  805279:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  80527d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805281:	48 89 c7             	mov    %rax,%rdi
  805284:	48 b8 9c 1c 80 00 00 	movabs $0x801c9c,%rax
  80528b:	00 00 00 
  80528e:	ff d0                	callq  *%rax
  805290:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  805293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805297:	79 19                	jns    8052b2 <ipc_recv+0xb1>
		*from_env_store = 0;
  805299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80529d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8052a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052a7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8052ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052b0:	eb 53                	jmp    805305 <ipc_recv+0x104>
	}
	if(from_env_store)
  8052b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8052b7:	74 19                	je     8052d2 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8052b9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052c0:	00 00 00 
  8052c3:	48 8b 00             	mov    (%rax),%rax
  8052c6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8052cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052d0:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8052d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8052d7:	74 19                	je     8052f2 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8052d9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052e0:	00 00 00 
  8052e3:	48 8b 00             	mov    (%rax),%rax
  8052e6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8052ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052f0:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8052f2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8052f9:	00 00 00 
  8052fc:	48 8b 00             	mov    (%rax),%rax
  8052ff:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  805305:	c9                   	leaveq 
  805306:	c3                   	retq   

0000000000805307 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805307:	55                   	push   %rbp
  805308:	48 89 e5             	mov    %rsp,%rbp
  80530b:	48 83 ec 30          	sub    $0x30,%rsp
  80530f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805312:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805315:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805319:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80531c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805321:	75 0e                	jne    805331 <ipc_send+0x2a>
		pg = (void*)UTOP;
  805323:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80532a:	00 00 00 
  80532d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  805331:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805334:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805337:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80533b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80533e:	89 c7                	mov    %eax,%edi
  805340:	48 b8 47 1c 80 00 00 	movabs $0x801c47,%rax
  805347:	00 00 00 
  80534a:	ff d0                	callq  *%rax
  80534c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80534f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805353:	75 0c                	jne    805361 <ipc_send+0x5a>
			sys_yield();
  805355:	48 b8 35 1a 80 00 00 	movabs $0x801a35,%rax
  80535c:	00 00 00 
  80535f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  805361:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805365:	74 ca                	je     805331 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  805367:	c9                   	leaveq 
  805368:	c3                   	retq   

0000000000805369 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805369:	55                   	push   %rbp
  80536a:	48 89 e5             	mov    %rsp,%rbp
  80536d:	48 83 ec 14          	sub    $0x14,%rsp
  805371:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80537b:	eb 5e                	jmp    8053db <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80537d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805384:	00 00 00 
  805387:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80538a:	48 63 d0             	movslq %eax,%rdx
  80538d:	48 89 d0             	mov    %rdx,%rax
  805390:	48 c1 e0 03          	shl    $0x3,%rax
  805394:	48 01 d0             	add    %rdx,%rax
  805397:	48 c1 e0 05          	shl    $0x5,%rax
  80539b:	48 01 c8             	add    %rcx,%rax
  80539e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8053a4:	8b 00                	mov    (%rax),%eax
  8053a6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8053a9:	75 2c                	jne    8053d7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8053ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8053b2:	00 00 00 
  8053b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053b8:	48 63 d0             	movslq %eax,%rdx
  8053bb:	48 89 d0             	mov    %rdx,%rax
  8053be:	48 c1 e0 03          	shl    $0x3,%rax
  8053c2:	48 01 d0             	add    %rdx,%rax
  8053c5:	48 c1 e0 05          	shl    $0x5,%rax
  8053c9:	48 01 c8             	add    %rcx,%rax
  8053cc:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8053d2:	8b 40 08             	mov    0x8(%rax),%eax
  8053d5:	eb 12                	jmp    8053e9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8053d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8053db:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8053e2:	7e 99                	jle    80537d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8053e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8053e9:	c9                   	leaveq 
  8053ea:	c3                   	retq   

00000000008053eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8053eb:	55                   	push   %rbp
  8053ec:	48 89 e5             	mov    %rsp,%rbp
  8053ef:	48 83 ec 18          	sub    $0x18,%rsp
  8053f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8053f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053fb:	48 c1 e8 15          	shr    $0x15,%rax
  8053ff:	48 89 c2             	mov    %rax,%rdx
  805402:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805409:	01 00 00 
  80540c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805410:	83 e0 01             	and    $0x1,%eax
  805413:	48 85 c0             	test   %rax,%rax
  805416:	75 07                	jne    80541f <pageref+0x34>
		return 0;
  805418:	b8 00 00 00 00       	mov    $0x0,%eax
  80541d:	eb 53                	jmp    805472 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80541f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805423:	48 c1 e8 0c          	shr    $0xc,%rax
  805427:	48 89 c2             	mov    %rax,%rdx
  80542a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805431:	01 00 00 
  805434:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805438:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80543c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805440:	83 e0 01             	and    $0x1,%eax
  805443:	48 85 c0             	test   %rax,%rax
  805446:	75 07                	jne    80544f <pageref+0x64>
		return 0;
  805448:	b8 00 00 00 00       	mov    $0x0,%eax
  80544d:	eb 23                	jmp    805472 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80544f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805453:	48 c1 e8 0c          	shr    $0xc,%rax
  805457:	48 89 c2             	mov    %rax,%rdx
  80545a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805461:	00 00 00 
  805464:	48 c1 e2 04          	shl    $0x4,%rdx
  805468:	48 01 d0             	add    %rdx,%rax
  80546b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80546f:	0f b7 c0             	movzwl %ax,%eax
}
  805472:	c9                   	leaveq 
  805473:	c3                   	retq   
