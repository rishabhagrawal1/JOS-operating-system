
obj/user/testtime.debug:     file format elf64-x86-64


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
  80003c:	e8 6c 01 00 00       	callq  8001ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004e:	48 b8 71 1c 80 00 00 	movabs $0x801c71,%rax
  800055:	00 00 00 
  800058:	ff d0                	callq  *%rax
  80005a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800060:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  800070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	79 38                	jns    8000af <sleep+0x6c>
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007d:	7c 30                	jl     8000af <sleep+0x6c>
		panic("sys_time_msec: %e", (int)now);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba c0 3f 80 00 00 	movabs $0x803fc0,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf d2 3f 80 00 00 	movabs $0x803fd2,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if (end < now)
  8000af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b5:	73 2a                	jae    8000e1 <sleep+0x9e>
		panic("sleep: wrap");
  8000b7:	48 ba e2 3f 80 00 00 	movabs $0x803fe2,%rdx
  8000be:	00 00 00 
  8000c1:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c6:	48 bf d2 3f 80 00 00 	movabs $0x803fd2,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 5b 02 80 00 00 	movabs $0x80025b,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
  8000e1:	eb 0c                	jmp    8000ef <sleep+0xac>
		sys_yield();
  8000e3:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ef:	48 b8 71 1c 80 00 00 	movabs $0x801c71,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fe:	72 e3                	jb     8000e3 <sleep+0xa0>
		sys_yield();
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <umain>:

void
umain(int argc, char **argv)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
  800106:	48 83 ec 20          	sub    $0x20,%rsp
  80010a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800118:	eb 10                	jmp    80012a <umain+0x28>
		sys_yield();
  80011a:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80012a:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012e:	7e ea                	jle    80011a <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  800130:	48 bf ee 3f 80 00 00 	movabs $0x803fee,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  800146:	00 00 00 
  800149:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  80014b:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800152:	eb 35                	jmp    800189 <umain+0x87>
		cprintf("%d ", i);
  800154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800157:	89 c6                	mov    %eax,%esi
  800159:	48 bf 04 40 80 00 00 	movabs $0x804004,%rdi
  800160:	00 00 00 
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  80016f:	00 00 00 
  800172:	ff d2                	callq  *%rdx
		sleep(1);
  800174:	bf 01 00 00 00       	mov    $0x1,%edi
  800179:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800180:	00 00 00 
  800183:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800185:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018d:	79 c5                	jns    800154 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018f:	48 bf 08 40 80 00 00 	movabs $0x804008,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  8001a5:	00 00 00 
  8001a8:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001aa:	cc                   	int3   
	breakpoint();
}
  8001ab:	c9                   	leaveq 
  8001ac:	c3                   	retq   

00000000008001ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001bc:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cd:	48 63 d0             	movslq %eax,%rdx
  8001d0:	48 89 d0             	mov    %rdx,%rax
  8001d3:	48 c1 e0 03          	shl    $0x3,%rax
  8001d7:	48 01 d0             	add    %rdx,%rax
  8001da:	48 c1 e0 05          	shl    $0x5,%rax
  8001de:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e5:	00 00 00 
  8001e8:	48 01 c2             	add    %rax,%rdx
  8001eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001f2:	00 00 00 
  8001f5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001fc:	7e 14                	jle    800212 <libmain+0x65>
		binaryname = argv[0];
  8001fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800202:	48 8b 10             	mov    (%rax),%rdx
  800205:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80020c:	00 00 00 
  80020f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800219:	48 89 d6             	mov    %rdx,%rsi
  80021c:	89 c7                	mov    %eax,%edi
  80021e:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  80022a:	48 b8 38 02 80 00 00 	movabs $0x800238,%rax
  800231:	00 00 00 
  800234:	ff d0                	callq  *%rax
}
  800236:	c9                   	leaveq 
  800237:	c3                   	retq   

0000000000800238 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800238:	55                   	push   %rbp
  800239:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80023c:	48 b8 f0 1f 80 00 00 	movabs $0x801ff0,%rax
  800243:	00 00 00 
  800246:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800248:	bf 00 00 00 00       	mov    $0x0,%edi
  80024d:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  800254:	00 00 00 
  800257:	ff d0                	callq  *%rax

}
  800259:	5d                   	pop    %rbp
  80025a:	c3                   	retq   

000000000080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025b:	55                   	push   %rbp
  80025c:	48 89 e5             	mov    %rsp,%rbp
  80025f:	53                   	push   %rbx
  800260:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800267:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80026e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800274:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80027b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800282:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800289:	84 c0                	test   %al,%al
  80028b:	74 23                	je     8002b0 <_panic+0x55>
  80028d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800294:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800298:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80029c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002be:	00 00 00 
  8002c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002c8:	00 00 00 
  8002cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002e4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002eb:	00 00 00 
  8002ee:	48 8b 18             	mov    (%rax),%rbx
  8002f1:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
  8002fd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800303:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80030a:	41 89 c8             	mov    %ecx,%r8d
  80030d:	48 89 d1             	mov    %rdx,%rcx
  800310:	48 89 da             	mov    %rbx,%rdx
  800313:	89 c6                	mov    %eax,%esi
  800315:	48 bf 18 40 80 00 00 	movabs $0x804018,%rdi
  80031c:	00 00 00 
  80031f:	b8 00 00 00 00       	mov    $0x0,%eax
  800324:	49 b9 94 04 80 00 00 	movabs $0x800494,%r9
  80032b:	00 00 00 
  80032e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800331:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800338:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80033f:	48 89 d6             	mov    %rdx,%rsi
  800342:	48 89 c7             	mov    %rax,%rdi
  800345:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  80034c:	00 00 00 
  80034f:	ff d0                	callq  *%rax
	cprintf("\n");
  800351:	48 bf 3b 40 80 00 00 	movabs $0x80403b,%rdi
  800358:	00 00 00 
  80035b:	b8 00 00 00 00       	mov    $0x0,%eax
  800360:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  800367:	00 00 00 
  80036a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036c:	cc                   	int3   
  80036d:	eb fd                	jmp    80036c <_panic+0x111>

000000000080036f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80036f:	55                   	push   %rbp
  800370:	48 89 e5             	mov    %rsp,%rbp
  800373:	48 83 ec 10          	sub    $0x10,%rsp
  800377:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80037a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80037e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800382:	8b 00                	mov    (%rax),%eax
  800384:	8d 48 01             	lea    0x1(%rax),%ecx
  800387:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038b:	89 0a                	mov    %ecx,(%rdx)
  80038d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800390:	89 d1                	mov    %edx,%ecx
  800392:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800396:	48 98                	cltq   
  800398:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 00                	mov    (%rax),%eax
  8003a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a7:	75 2c                	jne    8003d5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ad:	8b 00                	mov    (%rax),%eax
  8003af:	48 98                	cltq   
  8003b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b5:	48 83 c2 08          	add    $0x8,%rdx
  8003b9:	48 89 c6             	mov    %rax,%rsi
  8003bc:	48 89 d7             	mov    %rdx,%rdi
  8003bf:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
        b->idx = 0;
  8003cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d9:	8b 40 04             	mov    0x4(%rax),%eax
  8003dc:	8d 50 01             	lea    0x1(%rax),%edx
  8003df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800401:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800408:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80040f:	48 8b 0a             	mov    (%rdx),%rcx
  800412:	48 89 08             	mov    %rcx,(%rax)
  800415:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800419:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80041d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800421:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800425:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80042c:	00 00 00 
    b.cnt = 0;
  80042f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800436:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800439:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800440:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800447:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80044e:	48 89 c6             	mov    %rax,%rsi
  800451:	48 bf 6f 03 80 00 00 	movabs $0x80036f,%rdi
  800458:	00 00 00 
  80045b:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800462:	00 00 00 
  800465:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800467:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80046d:	48 98                	cltq   
  80046f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800476:	48 83 c2 08          	add    $0x8,%rdx
  80047a:	48 89 c6             	mov    %rax,%rsi
  80047d:	48 89 d7             	mov    %rdx,%rdi
  800480:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  800487:	00 00 00 
  80048a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80048c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800492:	c9                   	leaveq 
  800493:	c3                   	retq   

0000000000800494 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800494:	55                   	push   %rbp
  800495:	48 89 e5             	mov    %rsp,%rbp
  800498:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80049f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004c2:	84 c0                	test   %al,%al
  8004c4:	74 20                	je     8004e6 <cprintf+0x52>
  8004c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004f4:	00 00 00 
  8004f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004fe:	00 00 00 
  800501:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800505:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80050c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800513:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80051a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800521:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800528:	48 8b 0a             	mov    (%rdx),%rcx
  80052b:	48 89 08             	mov    %rcx,(%rax)
  80052e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800532:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800536:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80053a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80053e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800545:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80054c:	48 89 d6             	mov    %rdx,%rsi
  80054f:	48 89 c7             	mov    %rax,%rdi
  800552:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  800559:	00 00 00 
  80055c:	ff d0                	callq  *%rax
  80055e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800564:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80056a:	c9                   	leaveq 
  80056b:	c3                   	retq   

000000000080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %rbp
  80056d:	48 89 e5             	mov    %rsp,%rbp
  800570:	53                   	push   %rbx
  800571:	48 83 ec 38          	sub    $0x38,%rsp
  800575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80057d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800581:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800584:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800588:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80058c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80058f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800593:	77 3b                	ja     8005d0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800595:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800598:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80059c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80059f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	48 f7 f3             	div    %rbx
  8005ab:	48 89 c2             	mov    %rax,%rdx
  8005ae:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005b4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bc:	41 89 f9             	mov    %edi,%r9d
  8005bf:	48 89 c7             	mov    %rax,%rdi
  8005c2:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  8005c9:	00 00 00 
  8005cc:	ff d0                	callq  *%rax
  8005ce:	eb 1e                	jmp    8005ee <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d0:	eb 12                	jmp    8005e4 <printnum+0x78>
			putch(padc, putdat);
  8005d2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005d6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dd:	48 89 ce             	mov    %rcx,%rsi
  8005e0:	89 d7                	mov    %edx,%edi
  8005e2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005ec:	7f e4                	jg     8005d2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	48 f7 f1             	div    %rcx
  8005fd:	48 89 d0             	mov    %rdx,%rax
  800600:	48 ba 30 42 80 00 00 	movabs $0x804230,%rdx
  800607:	00 00 00 
  80060a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80060e:	0f be d0             	movsbl %al,%edx
  800611:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800619:	48 89 ce             	mov    %rcx,%rsi
  80061c:	89 d7                	mov    %edx,%edi
  80061e:	ff d0                	callq  *%rax
}
  800620:	48 83 c4 38          	add    $0x38,%rsp
  800624:	5b                   	pop    %rbx
  800625:	5d                   	pop    %rbp
  800626:	c3                   	retq   

0000000000800627 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80062f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800633:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800636:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063a:	7e 52                	jle    80068e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	83 f8 30             	cmp    $0x30,%eax
  800645:	73 24                	jae    80066b <getuint+0x44>
  800647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800653:	8b 00                	mov    (%rax),%eax
  800655:	89 c0                	mov    %eax,%eax
  800657:	48 01 d0             	add    %rdx,%rax
  80065a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065e:	8b 12                	mov    (%rdx),%edx
  800660:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800667:	89 0a                	mov    %ecx,(%rdx)
  800669:	eb 17                	jmp    800682 <getuint+0x5b>
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800673:	48 89 d0             	mov    %rdx,%rax
  800676:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800682:	48 8b 00             	mov    (%rax),%rax
  800685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800689:	e9 a3 00 00 00       	jmpq   800731 <getuint+0x10a>
	else if (lflag)
  80068e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800692:	74 4f                	je     8006e3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	8b 00                	mov    (%rax),%eax
  80069a:	83 f8 30             	cmp    $0x30,%eax
  80069d:	73 24                	jae    8006c3 <getuint+0x9c>
  80069f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	8b 00                	mov    (%rax),%eax
  8006ad:	89 c0                	mov    %eax,%eax
  8006af:	48 01 d0             	add    %rdx,%rax
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	8b 12                	mov    (%rdx),%edx
  8006b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	89 0a                	mov    %ecx,(%rdx)
  8006c1:	eb 17                	jmp    8006da <getuint+0xb3>
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cb:	48 89 d0             	mov    %rdx,%rax
  8006ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006da:	48 8b 00             	mov    (%rax),%rax
  8006dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006e1:	eb 4e                	jmp    800731 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	83 f8 30             	cmp    $0x30,%eax
  8006ec:	73 24                	jae    800712 <getuint+0xeb>
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	89 c0                	mov    %eax,%eax
  8006fe:	48 01 d0             	add    %rdx,%rax
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	8b 12                	mov    (%rdx),%edx
  800707:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	89 0a                	mov    %ecx,(%rdx)
  800710:	eb 17                	jmp    800729 <getuint+0x102>
  800712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800716:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071a:	48 89 d0             	mov    %rdx,%rax
  80071d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800729:	8b 00                	mov    (%rax),%eax
  80072b:	89 c0                	mov    %eax,%eax
  80072d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800735:	c9                   	leaveq 
  800736:	c3                   	retq   

0000000000800737 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800737:	55                   	push   %rbp
  800738:	48 89 e5             	mov    %rsp,%rbp
  80073b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80073f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800743:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800746:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80074a:	7e 52                	jle    80079e <getint+0x67>
		x=va_arg(*ap, long long);
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	8b 00                	mov    (%rax),%eax
  800752:	83 f8 30             	cmp    $0x30,%eax
  800755:	73 24                	jae    80077b <getint+0x44>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	89 c0                	mov    %eax,%eax
  800767:	48 01 d0             	add    %rdx,%rax
  80076a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076e:	8b 12                	mov    (%rdx),%edx
  800770:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	89 0a                	mov    %ecx,(%rdx)
  800779:	eb 17                	jmp    800792 <getint+0x5b>
  80077b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800783:	48 89 d0             	mov    %rdx,%rax
  800786:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80078a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800792:	48 8b 00             	mov    (%rax),%rax
  800795:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800799:	e9 a3 00 00 00       	jmpq   800841 <getint+0x10a>
	else if (lflag)
  80079e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007a2:	74 4f                	je     8007f3 <getint+0xbc>
		x=va_arg(*ap, long);
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	8b 00                	mov    (%rax),%eax
  8007aa:	83 f8 30             	cmp    $0x30,%eax
  8007ad:	73 24                	jae    8007d3 <getint+0x9c>
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	89 c0                	mov    %eax,%eax
  8007bf:	48 01 d0             	add    %rdx,%rax
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	8b 12                	mov    (%rdx),%edx
  8007c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	89 0a                	mov    %ecx,(%rdx)
  8007d1:	eb 17                	jmp    8007ea <getint+0xb3>
  8007d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007db:	48 89 d0             	mov    %rdx,%rax
  8007de:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ea:	48 8b 00             	mov    (%rax),%rax
  8007ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f1:	eb 4e                	jmp    800841 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	83 f8 30             	cmp    $0x30,%eax
  8007fc:	73 24                	jae    800822 <getint+0xeb>
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080a:	8b 00                	mov    (%rax),%eax
  80080c:	89 c0                	mov    %eax,%eax
  80080e:	48 01 d0             	add    %rdx,%rax
  800811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800815:	8b 12                	mov    (%rdx),%edx
  800817:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	89 0a                	mov    %ecx,(%rdx)
  800820:	eb 17                	jmp    800839 <getint+0x102>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80082a:	48 89 d0             	mov    %rdx,%rax
  80082d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800835:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	48 98                	cltq   
  80083d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800845:	c9                   	leaveq 
  800846:	c3                   	retq   

0000000000800847 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800847:	55                   	push   %rbp
  800848:	48 89 e5             	mov    %rsp,%rbp
  80084b:	41 54                	push   %r12
  80084d:	53                   	push   %rbx
  80084e:	48 83 ec 60          	sub    $0x60,%rsp
  800852:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800856:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80085a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800862:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800866:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80086a:	48 8b 0a             	mov    (%rdx),%rcx
  80086d:	48 89 08             	mov    %rcx,(%rax)
  800870:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800874:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800878:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80087c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800880:	eb 17                	jmp    800899 <vprintfmt+0x52>
			if (ch == '\0')
  800882:	85 db                	test   %ebx,%ebx
  800884:	0f 84 cc 04 00 00    	je     800d56 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80088a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80088e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800892:	48 89 d6             	mov    %rdx,%rsi
  800895:	89 df                	mov    %ebx,%edi
  800897:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80089d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a5:	0f b6 00             	movzbl (%rax),%eax
  8008a8:	0f b6 d8             	movzbl %al,%ebx
  8008ab:	83 fb 25             	cmp    $0x25,%ebx
  8008ae:	75 d2                	jne    800882 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008b4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dc:	0f b6 00             	movzbl (%rax),%eax
  8008df:	0f b6 d8             	movzbl %al,%ebx
  8008e2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008e5:	83 f8 55             	cmp    $0x55,%eax
  8008e8:	0f 87 34 04 00 00    	ja     800d22 <vprintfmt+0x4db>
  8008ee:	89 c0                	mov    %eax,%eax
  8008f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008f7:	00 
  8008f8:	48 b8 58 42 80 00 00 	movabs $0x804258,%rax
  8008ff:	00 00 00 
  800902:	48 01 d0             	add    %rdx,%rax
  800905:	48 8b 00             	mov    (%rax),%rax
  800908:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80090a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80090e:	eb c0                	jmp    8008d0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800910:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800914:	eb ba                	jmp    8008d0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800916:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80091d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800920:	89 d0                	mov    %edx,%eax
  800922:	c1 e0 02             	shl    $0x2,%eax
  800925:	01 d0                	add    %edx,%eax
  800927:	01 c0                	add    %eax,%eax
  800929:	01 d8                	add    %ebx,%eax
  80092b:	83 e8 30             	sub    $0x30,%eax
  80092e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800931:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093b:	83 fb 2f             	cmp    $0x2f,%ebx
  80093e:	7e 0c                	jle    80094c <vprintfmt+0x105>
  800940:	83 fb 39             	cmp    $0x39,%ebx
  800943:	7f 07                	jg     80094c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800945:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80094a:	eb d1                	jmp    80091d <vprintfmt+0xd6>
			goto process_precision;
  80094c:	eb 58                	jmp    8009a6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80094e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800951:	83 f8 30             	cmp    $0x30,%eax
  800954:	73 17                	jae    80096d <vprintfmt+0x126>
  800956:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095d:	89 c0                	mov    %eax,%eax
  80095f:	48 01 d0             	add    %rdx,%rax
  800962:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800965:	83 c2 08             	add    $0x8,%edx
  800968:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096b:	eb 0f                	jmp    80097c <vprintfmt+0x135>
  80096d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800971:	48 89 d0             	mov    %rdx,%rax
  800974:	48 83 c2 08          	add    $0x8,%rdx
  800978:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097c:	8b 00                	mov    (%rax),%eax
  80097e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800981:	eb 23                	jmp    8009a6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800983:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800987:	79 0c                	jns    800995 <vprintfmt+0x14e>
				width = 0;
  800989:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800990:	e9 3b ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>
  800995:	e9 36 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80099a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009a1:	e9 2a ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009aa:	79 12                	jns    8009be <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009af:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b9:	e9 12 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>
  8009be:	e9 0d ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009c7:	e9 04 ff ff ff       	jmpq   8008d0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cf:	83 f8 30             	cmp    $0x30,%eax
  8009d2:	73 17                	jae    8009eb <vprintfmt+0x1a4>
  8009d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 01 d0             	add    %rdx,%rax
  8009e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009e3:	83 c2 08             	add    $0x8,%edx
  8009e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e9:	eb 0f                	jmp    8009fa <vprintfmt+0x1b3>
  8009eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ef:	48 89 d0             	mov    %rdx,%rax
  8009f2:	48 83 c2 08          	add    $0x8,%rdx
  8009f6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009fa:	8b 10                	mov    (%rax),%edx
  8009fc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a04:	48 89 ce             	mov    %rcx,%rsi
  800a07:	89 d7                	mov    %edx,%edi
  800a09:	ff d0                	callq  *%rax
			break;
  800a0b:	e9 40 03 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a13:	83 f8 30             	cmp    $0x30,%eax
  800a16:	73 17                	jae    800a2f <vprintfmt+0x1e8>
  800a18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	89 c0                	mov    %eax,%eax
  800a21:	48 01 d0             	add    %rdx,%rax
  800a24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a27:	83 c2 08             	add    $0x8,%edx
  800a2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a2d:	eb 0f                	jmp    800a3e <vprintfmt+0x1f7>
  800a2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a33:	48 89 d0             	mov    %rdx,%rax
  800a36:	48 83 c2 08          	add    $0x8,%rdx
  800a3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a3e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a40:	85 db                	test   %ebx,%ebx
  800a42:	79 02                	jns    800a46 <vprintfmt+0x1ff>
				err = -err;
  800a44:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a46:	83 fb 15             	cmp    $0x15,%ebx
  800a49:	7f 16                	jg     800a61 <vprintfmt+0x21a>
  800a4b:	48 b8 80 41 80 00 00 	movabs $0x804180,%rax
  800a52:	00 00 00 
  800a55:	48 63 d3             	movslq %ebx,%rdx
  800a58:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a5c:	4d 85 e4             	test   %r12,%r12
  800a5f:	75 2e                	jne    800a8f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a69:	89 d9                	mov    %ebx,%ecx
  800a6b:	48 ba 41 42 80 00 00 	movabs $0x804241,%rdx
  800a72:	00 00 00 
  800a75:	48 89 c7             	mov    %rax,%rdi
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	49 b8 5f 0d 80 00 00 	movabs $0x800d5f,%r8
  800a84:	00 00 00 
  800a87:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a8a:	e9 c1 02 00 00       	jmpq   800d50 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a97:	4c 89 e1             	mov    %r12,%rcx
  800a9a:	48 ba 4a 42 80 00 00 	movabs $0x80424a,%rdx
  800aa1:	00 00 00 
  800aa4:	48 89 c7             	mov    %rax,%rdi
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aac:	49 b8 5f 0d 80 00 00 	movabs $0x800d5f,%r8
  800ab3:	00 00 00 
  800ab6:	41 ff d0             	callq  *%r8
			break;
  800ab9:	e9 92 02 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800abe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac1:	83 f8 30             	cmp    $0x30,%eax
  800ac4:	73 17                	jae    800add <vprintfmt+0x296>
  800ac6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acd:	89 c0                	mov    %eax,%eax
  800acf:	48 01 d0             	add    %rdx,%rax
  800ad2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad5:	83 c2 08             	add    $0x8,%edx
  800ad8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800adb:	eb 0f                	jmp    800aec <vprintfmt+0x2a5>
  800add:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae1:	48 89 d0             	mov    %rdx,%rax
  800ae4:	48 83 c2 08          	add    $0x8,%rdx
  800ae8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aec:	4c 8b 20             	mov    (%rax),%r12
  800aef:	4d 85 e4             	test   %r12,%r12
  800af2:	75 0a                	jne    800afe <vprintfmt+0x2b7>
				p = "(null)";
  800af4:	49 bc 4d 42 80 00 00 	movabs $0x80424d,%r12
  800afb:	00 00 00 
			if (width > 0 && padc != '-')
  800afe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b02:	7e 3f                	jle    800b43 <vprintfmt+0x2fc>
  800b04:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b08:	74 39                	je     800b43 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b0d:	48 98                	cltq   
  800b0f:	48 89 c6             	mov    %rax,%rsi
  800b12:	4c 89 e7             	mov    %r12,%rdi
  800b15:	48 b8 0b 10 80 00 00 	movabs $0x80100b,%rax
  800b1c:	00 00 00 
  800b1f:	ff d0                	callq  *%rax
  800b21:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b24:	eb 17                	jmp    800b3d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b26:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b2a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b32:	48 89 ce             	mov    %rcx,%rsi
  800b35:	89 d7                	mov    %edx,%edi
  800b37:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b39:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b41:	7f e3                	jg     800b26 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b43:	eb 37                	jmp    800b7c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b49:	74 1e                	je     800b69 <vprintfmt+0x322>
  800b4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b4e:	7e 05                	jle    800b55 <vprintfmt+0x30e>
  800b50:	83 fb 7e             	cmp    $0x7e,%ebx
  800b53:	7e 14                	jle    800b69 <vprintfmt+0x322>
					putch('?', putdat);
  800b55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5d:	48 89 d6             	mov    %rdx,%rsi
  800b60:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b65:	ff d0                	callq  *%rax
  800b67:	eb 0f                	jmp    800b78 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b71:	48 89 d6             	mov    %rdx,%rsi
  800b74:	89 df                	mov    %ebx,%edi
  800b76:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b78:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7c:	4c 89 e0             	mov    %r12,%rax
  800b7f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b83:	0f b6 00             	movzbl (%rax),%eax
  800b86:	0f be d8             	movsbl %al,%ebx
  800b89:	85 db                	test   %ebx,%ebx
  800b8b:	74 10                	je     800b9d <vprintfmt+0x356>
  800b8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b91:	78 b2                	js     800b45 <vprintfmt+0x2fe>
  800b93:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b97:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9b:	79 a8                	jns    800b45 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba7:	48 89 d6             	mov    %rdx,%rsi
  800baa:	bf 20 00 00 00       	mov    $0x20,%edi
  800baf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bbb:	e9 90 01 00 00       	jmpq   800d50 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc4:	be 03 00 00 00       	mov    $0x3,%esi
  800bc9:	48 89 c7             	mov    %rax,%rdi
  800bcc:	48 b8 37 07 80 00 00 	movabs $0x800737,%rax
  800bd3:	00 00 00 
  800bd6:	ff d0                	callq  *%rax
  800bd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be0:	48 85 c0             	test   %rax,%rax
  800be3:	79 1d                	jns    800c02 <vprintfmt+0x3bb>
				putch('-', putdat);
  800be5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bed:	48 89 d6             	mov    %rdx,%rsi
  800bf0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bfb:	48 f7 d8             	neg    %rax
  800bfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c09:	e9 d5 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c0e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c12:	be 03 00 00 00       	mov    $0x3,%esi
  800c17:	48 89 c7             	mov    %rax,%rdi
  800c1a:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
  800c26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c31:	e9 ad 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c36:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c39:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	48 b8 37 07 80 00 00 	movabs $0x800737,%rax
  800c49:	00 00 00 
  800c4c:	ff d0                	callq  *%rax
  800c4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c52:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c59:	e9 85 00 00 00       	jmpq   800ce3 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	48 89 d6             	mov    %rdx,%rsi
  800c69:	bf 30 00 00 00       	mov    $0x30,%edi
  800c6e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c78:	48 89 d6             	mov    %rdx,%rsi
  800c7b:	bf 78 00 00 00       	mov    $0x78,%edi
  800c80:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c85:	83 f8 30             	cmp    $0x30,%eax
  800c88:	73 17                	jae    800ca1 <vprintfmt+0x45a>
  800c8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c91:	89 c0                	mov    %eax,%eax
  800c93:	48 01 d0             	add    %rdx,%rax
  800c96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c99:	83 c2 08             	add    $0x8,%edx
  800c9c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9f:	eb 0f                	jmp    800cb0 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ca1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca5:	48 89 d0             	mov    %rdx,%rax
  800ca8:	48 83 c2 08          	add    $0x8,%rdx
  800cac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb0:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cb7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc4:	be 03 00 00 00       	mov    $0x3,%esi
  800cc9:	48 89 c7             	mov    %rax,%rdi
  800ccc:	48 b8 27 06 80 00 00 	movabs $0x800627,%rax
  800cd3:	00 00 00 
  800cd6:	ff d0                	callq  *%rax
  800cd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cdc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ce8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ceb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	45 89 c1             	mov    %r8d,%r9d
  800cfd:	41 89 f8             	mov    %edi,%r8d
  800d00:	48 89 c7             	mov    %rax,%rdi
  800d03:	48 b8 6c 05 80 00 00 	movabs $0x80056c,%rax
  800d0a:	00 00 00 
  800d0d:	ff d0                	callq  *%rax
			break;
  800d0f:	eb 3f                	jmp    800d50 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	48 89 d6             	mov    %rdx,%rsi
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	ff d0                	callq  *%rax
			break;
  800d20:	eb 2e                	jmp    800d50 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	48 89 d6             	mov    %rdx,%rsi
  800d2d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d32:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d34:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d39:	eb 05                	jmp    800d40 <vprintfmt+0x4f9>
  800d3b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d40:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d44:	48 83 e8 01          	sub    $0x1,%rax
  800d48:	0f b6 00             	movzbl (%rax),%eax
  800d4b:	3c 25                	cmp    $0x25,%al
  800d4d:	75 ec                	jne    800d3b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d4f:	90                   	nop
		}
	}
  800d50:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d51:	e9 43 fb ff ff       	jmpq   800899 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d56:	48 83 c4 60          	add    $0x60,%rsp
  800d5a:	5b                   	pop    %rbx
  800d5b:	41 5c                	pop    %r12
  800d5d:	5d                   	pop    %rbp
  800d5e:	c3                   	retq   

0000000000800d5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5f:	55                   	push   %rbp
  800d60:	48 89 e5             	mov    %rsp,%rbp
  800d63:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d6a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d71:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8d:	84 c0                	test   %al,%al
  800d8f:	74 20                	je     800db1 <printfmt+0x52>
  800d91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800db8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dbf:	00 00 00 
  800dc2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dc9:	00 00 00 
  800dcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dd7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dde:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800de5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800df3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dfa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e01:	48 89 c7             	mov    %rax,%rdi
  800e04:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e10:	c9                   	leaveq 
  800e11:	c3                   	retq   

0000000000800e12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e12:	55                   	push   %rbp
  800e13:	48 89 e5             	mov    %rsp,%rbp
  800e16:	48 83 ec 10          	sub    $0x10,%rsp
  800e1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e25:	8b 40 10             	mov    0x10(%rax),%eax
  800e28:	8d 50 01             	lea    0x1(%rax),%edx
  800e2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e36:	48 8b 10             	mov    (%rax),%rdx
  800e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e41:	48 39 c2             	cmp    %rax,%rdx
  800e44:	73 17                	jae    800e5d <sprintputch+0x4b>
		*b->buf++ = ch;
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	48 8b 00             	mov    (%rax),%rax
  800e4d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e55:	48 89 0a             	mov    %rcx,(%rdx)
  800e58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e5b:	88 10                	mov    %dl,(%rax)
}
  800e5d:	c9                   	leaveq 
  800e5e:	c3                   	retq   

0000000000800e5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e5f:	55                   	push   %rbp
  800e60:	48 89 e5             	mov    %rsp,%rbp
  800e63:	48 83 ec 50          	sub    $0x50,%rsp
  800e67:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e6b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e6e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e72:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e76:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e7a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e7e:	48 8b 0a             	mov    (%rdx),%rcx
  800e81:	48 89 08             	mov    %rcx,(%rax)
  800e84:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e88:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e8c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e90:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e98:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e9c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e9f:	48 98                	cltq   
  800ea1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ea5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea9:	48 01 d0             	add    %rdx,%rax
  800eac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eb0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eb7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ebc:	74 06                	je     800ec4 <vsnprintf+0x65>
  800ebe:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ec2:	7f 07                	jg     800ecb <vsnprintf+0x6c>
		return -E_INVAL;
  800ec4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec9:	eb 2f                	jmp    800efa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ecb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ecf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ed3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ed7:	48 89 c6             	mov    %rax,%rsi
  800eda:	48 bf 12 0e 80 00 00 	movabs $0x800e12,%rdi
  800ee1:	00 00 00 
  800ee4:	48 b8 47 08 80 00 00 	movabs $0x800847,%rax
  800eeb:	00 00 00 
  800eee:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ef0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ef4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ef7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800efa:	c9                   	leaveq 
  800efb:	c3                   	retq   

0000000000800efc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800efc:	55                   	push   %rbp
  800efd:	48 89 e5             	mov    %rsp,%rbp
  800f00:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f07:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f0e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f29:	84 c0                	test   %al,%al
  800f2b:	74 20                	je     800f4d <snprintf+0x51>
  800f2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f4d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f54:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f5b:	00 00 00 
  800f5e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f65:	00 00 00 
  800f68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f6c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f7a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f81:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f88:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f8f:	48 8b 0a             	mov    (%rdx),%rcx
  800f92:	48 89 08             	mov    %rcx,(%rax)
  800f95:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f99:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f9d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fa5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fac:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fb3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fb9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fc0:	48 89 c7             	mov    %rax,%rdi
  800fc3:	48 b8 5f 0e 80 00 00 	movabs $0x800e5f,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
  800fcf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fd5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 18          	sub    $0x18,%rsp
  800fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff0:	eb 09                	jmp    800ffb <strlen+0x1e>
		n++;
  800ff2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ffb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fff:	0f b6 00             	movzbl (%rax),%eax
  801002:	84 c0                	test   %al,%al
  801004:	75 ec                	jne    800ff2 <strlen+0x15>
		n++;
	return n;
  801006:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   

000000000080100b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80100b:	55                   	push   %rbp
  80100c:	48 89 e5             	mov    %rsp,%rbp
  80100f:	48 83 ec 20          	sub    $0x20,%rsp
  801013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801017:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801022:	eb 0e                	jmp    801032 <strnlen+0x27>
		n++;
  801024:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801028:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801032:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801037:	74 0b                	je     801044 <strnlen+0x39>
  801039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103d:	0f b6 00             	movzbl (%rax),%eax
  801040:	84 c0                	test   %al,%al
  801042:	75 e0                	jne    801024 <strnlen+0x19>
		n++;
	return n;
  801044:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801047:	c9                   	leaveq 
  801048:	c3                   	retq   

0000000000801049 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801049:	55                   	push   %rbp
  80104a:	48 89 e5             	mov    %rsp,%rbp
  80104d:	48 83 ec 20          	sub    $0x20,%rsp
  801051:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801055:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801061:	90                   	nop
  801062:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801066:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80106a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80106e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801072:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801076:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80107a:	0f b6 12             	movzbl (%rdx),%edx
  80107d:	88 10                	mov    %dl,(%rax)
  80107f:	0f b6 00             	movzbl (%rax),%eax
  801082:	84 c0                	test   %al,%al
  801084:	75 dc                	jne    801062 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80108a:	c9                   	leaveq 
  80108b:	c3                   	retq   

000000000080108c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80108c:	55                   	push   %rbp
  80108d:	48 89 e5             	mov    %rsp,%rbp
  801090:	48 83 ec 20          	sub    $0x20,%rsp
  801094:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801098:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	48 89 c7             	mov    %rax,%rdi
  8010a3:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  8010aa:	00 00 00 
  8010ad:	ff d0                	callq  *%rax
  8010af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b5:	48 63 d0             	movslq %eax,%rdx
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	48 01 c2             	add    %rax,%rdx
  8010bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c3:	48 89 c6             	mov    %rax,%rsi
  8010c6:	48 89 d7             	mov    %rdx,%rdi
  8010c9:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
	return dst;
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010d9:	c9                   	leaveq 
  8010da:	c3                   	retq   

00000000008010db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010db:	55                   	push   %rbp
  8010dc:	48 89 e5             	mov    %rsp,%rbp
  8010df:	48 83 ec 28          	sub    $0x28,%rsp
  8010e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010fe:	00 
  8010ff:	eb 2a                	jmp    80112b <strncpy+0x50>
		*dst++ = *src;
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801109:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801111:	0f b6 12             	movzbl (%rdx),%edx
  801114:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801116:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	74 05                	je     801126 <strncpy+0x4b>
			src++;
  801121:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801126:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801133:	72 cc                	jb     801101 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 28          	sub    $0x28,%rsp
  801143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801147:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80114b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80114f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801153:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801157:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115c:	74 3d                	je     80119b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80115e:	eb 1d                	jmp    80117d <strlcpy+0x42>
			*dst++ = *src++;
  801160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801164:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801168:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801170:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801174:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801178:	0f b6 12             	movzbl (%rdx),%edx
  80117b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80117d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801182:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801187:	74 0b                	je     801194 <strlcpy+0x59>
  801189:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118d:	0f b6 00             	movzbl (%rax),%eax
  801190:	84 c0                	test   %al,%al
  801192:	75 cc                	jne    801160 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80119b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	48 29 c2             	sub    %rax,%rdx
  8011a6:	48 89 d0             	mov    %rdx,%rax
}
  8011a9:	c9                   	leaveq 
  8011aa:	c3                   	retq   

00000000008011ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011ab:	55                   	push   %rbp
  8011ac:	48 89 e5             	mov    %rsp,%rbp
  8011af:	48 83 ec 10          	sub    $0x10,%rsp
  8011b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011bb:	eb 0a                	jmp    8011c7 <strcmp+0x1c>
		p++, q++;
  8011bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	84 c0                	test   %al,%al
  8011d0:	74 12                	je     8011e4 <strcmp+0x39>
  8011d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d6:	0f b6 10             	movzbl (%rax),%edx
  8011d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	38 c2                	cmp    %al,%dl
  8011e2:	74 d9                	je     8011bd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	0f b6 d0             	movzbl %al,%edx
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	0f b6 00             	movzbl (%rax),%eax
  8011f5:	0f b6 c0             	movzbl %al,%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leaveq 
  8011fd:	c3                   	retq   

00000000008011fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011fe:	55                   	push   %rbp
  8011ff:	48 89 e5             	mov    %rsp,%rbp
  801202:	48 83 ec 18          	sub    $0x18,%rsp
  801206:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80120e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801212:	eb 0f                	jmp    801223 <strncmp+0x25>
		n--, p++, q++;
  801214:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801223:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801228:	74 1d                	je     801247 <strncmp+0x49>
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	74 12                	je     801247 <strncmp+0x49>
  801235:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801239:	0f b6 10             	movzbl (%rax),%edx
  80123c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	38 c2                	cmp    %al,%dl
  801245:	74 cd                	je     801214 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801247:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80124c:	75 07                	jne    801255 <strncmp+0x57>
		return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 18                	jmp    80126d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	0f b6 d0             	movzbl %al,%edx
  80125f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801263:	0f b6 00             	movzbl (%rax),%eax
  801266:	0f b6 c0             	movzbl %al,%eax
  801269:	29 c2                	sub    %eax,%edx
  80126b:	89 d0                	mov    %edx,%eax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 0c          	sub    $0xc,%rsp
  801277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80127b:	89 f0                	mov    %esi,%eax
  80127d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801280:	eb 17                	jmp    801299 <strchr+0x2a>
		if (*s == c)
  801282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801286:	0f b6 00             	movzbl (%rax),%eax
  801289:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80128c:	75 06                	jne    801294 <strchr+0x25>
			return (char *) s;
  80128e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801292:	eb 15                	jmp    8012a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801294:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	84 c0                	test   %al,%al
  8012a2:	75 de                	jne    801282 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b7:	89 f0                	mov    %esi,%eax
  8012b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012bc:	eb 13                	jmp    8012d1 <strfind+0x26>
		if (*s == c)
  8012be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c8:	75 02                	jne    8012cc <strfind+0x21>
			break;
  8012ca:	eb 10                	jmp    8012dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 e2                	jne    8012be <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 18          	sub    $0x18,%rsp
  8012ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fa:	75 06                	jne    801302 <memset+0x20>
		return v;
  8012fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801300:	eb 69                	jmp    80136b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	83 e0 03             	and    $0x3,%eax
  801309:	48 85 c0             	test   %rax,%rax
  80130c:	75 48                	jne    801356 <memset+0x74>
  80130e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	48 85 c0             	test   %rax,%rax
  801318:	75 3c                	jne    801356 <memset+0x74>
		c &= 0xFF;
  80131a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801321:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801324:	c1 e0 18             	shl    $0x18,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 10             	shl    $0x10,%eax
  80132f:	09 c2                	or     %eax,%edx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	c1 e0 08             	shl    $0x8,%eax
  801337:	09 d0                	or     %edx,%eax
  801339:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80133c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801340:	48 c1 e8 02          	shr    $0x2,%rax
  801344:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134e:	48 89 d7             	mov    %rdx,%rdi
  801351:	fc                   	cld    
  801352:	f3 ab                	rep stos %eax,%es:(%rdi)
  801354:	eb 11                	jmp    801367 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801356:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801361:	48 89 d7             	mov    %rdx,%rdi
  801364:	fc                   	cld    
  801365:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 28          	sub    $0x28,%rsp
  801375:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801379:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801385:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801395:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801399:	0f 83 88 00 00 00    	jae    801427 <memmove+0xba>
  80139f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a7:	48 01 d0             	add    %rdx,%rax
  8013aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ae:	76 77                	jbe    801427 <memmove+0xba>
		s += n;
  8013b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c4:	83 e0 03             	and    $0x3,%eax
  8013c7:	48 85 c0             	test   %rax,%rax
  8013ca:	75 3b                	jne    801407 <memmove+0x9a>
  8013cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d0:	83 e0 03             	and    $0x3,%eax
  8013d3:	48 85 c0             	test   %rax,%rax
  8013d6:	75 2f                	jne    801407 <memmove+0x9a>
  8013d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dc:	83 e0 03             	and    $0x3,%eax
  8013df:	48 85 c0             	test   %rax,%rax
  8013e2:	75 23                	jne    801407 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e8:	48 83 e8 04          	sub    $0x4,%rax
  8013ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f0:	48 83 ea 04          	sub    $0x4,%rdx
  8013f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013fc:	48 89 c7             	mov    %rax,%rdi
  8013ff:	48 89 d6             	mov    %rdx,%rsi
  801402:	fd                   	std    
  801403:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801405:	eb 1d                	jmp    801424 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80140f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801413:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	48 89 d7             	mov    %rdx,%rdi
  80141e:	48 89 c1             	mov    %rax,%rcx
  801421:	fd                   	std    
  801422:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801424:	fc                   	cld    
  801425:	eb 57                	jmp    80147e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142b:	83 e0 03             	and    $0x3,%eax
  80142e:	48 85 c0             	test   %rax,%rax
  801431:	75 36                	jne    801469 <memmove+0xfc>
  801433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801437:	83 e0 03             	and    $0x3,%eax
  80143a:	48 85 c0             	test   %rax,%rax
  80143d:	75 2a                	jne    801469 <memmove+0xfc>
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	83 e0 03             	and    $0x3,%eax
  801446:	48 85 c0             	test   %rax,%rax
  801449:	75 1e                	jne    801469 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	48 c1 e8 02          	shr    $0x2,%rax
  801453:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145e:	48 89 c7             	mov    %rax,%rdi
  801461:	48 89 d6             	mov    %rdx,%rsi
  801464:	fc                   	cld    
  801465:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801467:	eb 15                	jmp    80147e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801471:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801475:	48 89 c7             	mov    %rax,%rdi
  801478:	48 89 d6             	mov    %rdx,%rsi
  80147b:	fc                   	cld    
  80147c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80147e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801482:	c9                   	leaveq 
  801483:	c3                   	retq   

0000000000801484 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801484:	55                   	push   %rbp
  801485:	48 89 e5             	mov    %rsp,%rbp
  801488:	48 83 ec 18          	sub    $0x18,%rsp
  80148c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801490:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801494:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801498:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80149c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a4:	48 89 ce             	mov    %rcx,%rsi
  8014a7:	48 89 c7             	mov    %rax,%rdi
  8014aa:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8014b1:	00 00 00 
  8014b4:	ff d0                	callq  *%rax
}
  8014b6:	c9                   	leaveq 
  8014b7:	c3                   	retq   

00000000008014b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014b8:	55                   	push   %rbp
  8014b9:	48 89 e5             	mov    %rsp,%rbp
  8014bc:	48 83 ec 28          	sub    $0x28,%rsp
  8014c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014dc:	eb 36                	jmp    801514 <memcmp+0x5c>
		if (*s1 != *s2)
  8014de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e2:	0f b6 10             	movzbl (%rax),%edx
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e9:	0f b6 00             	movzbl (%rax),%eax
  8014ec:	38 c2                	cmp    %al,%dl
  8014ee:	74 1a                	je     80150a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	0f b6 d0             	movzbl %al,%edx
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	0f b6 c0             	movzbl %al,%eax
  801504:	29 c2                	sub    %eax,%edx
  801506:	89 d0                	mov    %edx,%eax
  801508:	eb 20                	jmp    80152a <memcmp+0x72>
		s1++, s2++;
  80150a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80151c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801520:	48 85 c0             	test   %rax,%rax
  801523:	75 b9                	jne    8014de <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 28          	sub    $0x28,%rsp
  801534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801538:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80153b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801547:	48 01 d0             	add    %rdx,%rax
  80154a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80154e:	eb 15                	jmp    801565 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	0f b6 10             	movzbl (%rax),%edx
  801557:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80155a:	38 c2                	cmp    %al,%dl
  80155c:	75 02                	jne    801560 <memfind+0x34>
			break;
  80155e:	eb 0f                	jmp    80156f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801560:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801569:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80156d:	72 e1                	jb     801550 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80156f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801573:	c9                   	leaveq 
  801574:	c3                   	retq   

0000000000801575 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801575:	55                   	push   %rbp
  801576:	48 89 e5             	mov    %rsp,%rbp
  801579:	48 83 ec 34          	sub    $0x34,%rsp
  80157d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801581:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801585:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801588:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80158f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801596:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801597:	eb 05                	jmp    80159e <strtol+0x29>
		s++;
  801599:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a2:	0f b6 00             	movzbl (%rax),%eax
  8015a5:	3c 20                	cmp    $0x20,%al
  8015a7:	74 f0                	je     801599 <strtol+0x24>
  8015a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ad:	0f b6 00             	movzbl (%rax),%eax
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 e5                	je     801599 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b8:	0f b6 00             	movzbl (%rax),%eax
  8015bb:	3c 2b                	cmp    $0x2b,%al
  8015bd:	75 07                	jne    8015c6 <strtol+0x51>
		s++;
  8015bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c4:	eb 17                	jmp    8015dd <strtol+0x68>
	else if (*s == '-')
  8015c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	3c 2d                	cmp    $0x2d,%al
  8015cf:	75 0c                	jne    8015dd <strtol+0x68>
		s++, neg = 1;
  8015d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e1:	74 06                	je     8015e9 <strtol+0x74>
  8015e3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e7:	75 28                	jne    801611 <strtol+0x9c>
  8015e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	3c 30                	cmp    $0x30,%al
  8015f2:	75 1d                	jne    801611 <strtol+0x9c>
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 83 c0 01          	add    $0x1,%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3c 78                	cmp    $0x78,%al
  801601:	75 0e                	jne    801611 <strtol+0x9c>
		s += 2, base = 16;
  801603:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801608:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80160f:	eb 2c                	jmp    80163d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801611:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801615:	75 19                	jne    801630 <strtol+0xbb>
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	3c 30                	cmp    $0x30,%al
  801620:	75 0e                	jne    801630 <strtol+0xbb>
		s++, base = 8;
  801622:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801627:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80162e:	eb 0d                	jmp    80163d <strtol+0xc8>
	else if (base == 0)
  801630:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801634:	75 07                	jne    80163d <strtol+0xc8>
		base = 10;
  801636:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 2f                	cmp    $0x2f,%al
  801646:	7e 1d                	jle    801665 <strtol+0xf0>
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 39                	cmp    $0x39,%al
  801651:	7f 12                	jg     801665 <strtol+0xf0>
			dig = *s - '0';
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 e8 30             	sub    $0x30,%eax
  801660:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801663:	eb 4e                	jmp    8016b3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	3c 60                	cmp    $0x60,%al
  80166e:	7e 1d                	jle    80168d <strtol+0x118>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 7a                	cmp    $0x7a,%al
  801679:	7f 12                	jg     80168d <strtol+0x118>
			dig = *s - 'a' + 10;
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	0f be c0             	movsbl %al,%eax
  801685:	83 e8 57             	sub    $0x57,%eax
  801688:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80168b:	eb 26                	jmp    8016b3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 40                	cmp    $0x40,%al
  801696:	7e 48                	jle    8016e0 <strtol+0x16b>
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 5a                	cmp    $0x5a,%al
  8016a1:	7f 3d                	jg     8016e0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f be c0             	movsbl %al,%eax
  8016ad:	83 e8 37             	sub    $0x37,%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b9:	7c 02                	jl     8016bd <strtol+0x148>
			break;
  8016bb:	eb 23                	jmp    8016e0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016c5:	48 98                	cltq   
  8016c7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016cc:	48 89 c2             	mov    %rax,%rdx
  8016cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016d2:	48 98                	cltq   
  8016d4:	48 01 d0             	add    %rdx,%rax
  8016d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016db:	e9 5d ff ff ff       	jmpq   80163d <strtol+0xc8>

	if (endptr)
  8016e0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016e5:	74 0b                	je     8016f2 <strtol+0x17d>
		*endptr = (char *) s;
  8016e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ef:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f6:	74 09                	je     801701 <strtol+0x18c>
  8016f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fc:	48 f7 d8             	neg    %rax
  8016ff:	eb 04                	jmp    801705 <strtol+0x190>
  801701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801705:	c9                   	leaveq 
  801706:	c3                   	retq   

0000000000801707 <strstr>:

char * strstr(const char *in, const char *str)
{
  801707:	55                   	push   %rbp
  801708:	48 89 e5             	mov    %rsp,%rbp
  80170b:	48 83 ec 30          	sub    $0x30,%rsp
  80170f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801713:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801717:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80171f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801723:	0f b6 00             	movzbl (%rax),%eax
  801726:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801729:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80172d:	75 06                	jne    801735 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80172f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801733:	eb 6b                	jmp    8017a0 <strstr+0x99>

	len = strlen(str);
  801735:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801739:	48 89 c7             	mov    %rax,%rdi
  80173c:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  801743:	00 00 00 
  801746:	ff d0                	callq  *%rax
  801748:	48 98                	cltq   
  80174a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801756:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80175a:	0f b6 00             	movzbl (%rax),%eax
  80175d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801760:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801764:	75 07                	jne    80176d <strstr+0x66>
				return (char *) 0;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 33                	jmp    8017a0 <strstr+0x99>
		} while (sc != c);
  80176d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801771:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801774:	75 d8                	jne    80174e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801776:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80177a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	48 89 ce             	mov    %rcx,%rsi
  801785:	48 89 c7             	mov    %rax,%rdi
  801788:	48 b8 fe 11 80 00 00 	movabs $0x8011fe,%rax
  80178f:	00 00 00 
  801792:	ff d0                	callq  *%rax
  801794:	85 c0                	test   %eax,%eax
  801796:	75 b6                	jne    80174e <strstr+0x47>

	return (char *) (in - 1);
  801798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179c:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a0:	c9                   	leaveq 
  8017a1:	c3                   	retq   

00000000008017a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017a2:	55                   	push   %rbp
  8017a3:	48 89 e5             	mov    %rsp,%rbp
  8017a6:	53                   	push   %rbx
  8017a7:	48 83 ec 48          	sub    $0x48,%rsp
  8017ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017b5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017b9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017bd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017c4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017cc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017d4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d8:	4c 89 c3             	mov    %r8,%rbx
  8017db:	cd 30                	int    $0x30
  8017dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017e5:	74 3e                	je     801825 <syscall+0x83>
  8017e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017ec:	7e 37                	jle    801825 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f5:	49 89 d0             	mov    %rdx,%r8
  8017f8:	89 c1                	mov    %eax,%ecx
  8017fa:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  801801:	00 00 00 
  801804:	be 23 00 00 00       	mov    $0x23,%esi
  801809:	48 bf 25 45 80 00 00 	movabs $0x804525,%rdi
  801810:	00 00 00 
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	49 b9 5b 02 80 00 00 	movabs $0x80025b,%r9
  80181f:	00 00 00 
  801822:	41 ff d1             	callq  *%r9

	return ret;
  801825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801829:	48 83 c4 48          	add    $0x48,%rsp
  80182d:	5b                   	pop    %rbx
  80182e:	5d                   	pop    %rbp
  80182f:	c3                   	retq   

0000000000801830 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 20          	sub    $0x20,%rsp
  801838:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80183c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801848:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184f:	00 
  801850:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801856:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185c:	48 89 d1             	mov    %rdx,%rcx
  80185f:	48 89 c2             	mov    %rax,%rdx
  801862:	be 00 00 00 00       	mov    $0x0,%esi
  801867:	bf 00 00 00 00       	mov    $0x0,%edi
  80186c:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
}
  801878:	c9                   	leaveq 
  801879:	c3                   	retq   

000000000080187a <sys_cgetc>:

int
sys_cgetc(void)
{
  80187a:	55                   	push   %rbp
  80187b:	48 89 e5             	mov    %rsp,%rbp
  80187e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801882:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801889:	00 
  80188a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801890:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801896:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	be 00 00 00 00       	mov    $0x0,%esi
  8018a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8018aa:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
}
  8018b6:	c9                   	leaveq 
  8018b7:	c3                   	retq   

00000000008018b8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	48 83 ec 10          	sub    $0x10,%rsp
  8018c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c6:	48 98                	cltq   
  8018c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cf:	00 
  8018d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e1:	48 89 c2             	mov    %rax,%rdx
  8018e4:	be 01 00 00 00       	mov    $0x1,%esi
  8018e9:	bf 03 00 00 00       	mov    $0x3,%edi
  8018ee:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8018f5:	00 00 00 
  8018f8:	ff d0                	callq  *%rax
}
  8018fa:	c9                   	leaveq 
  8018fb:	c3                   	retq   

00000000008018fc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018fc:	55                   	push   %rbp
  8018fd:	48 89 e5             	mov    %rsp,%rbp
  801900:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801904:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190b:	00 
  80190c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801912:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	be 00 00 00 00       	mov    $0x0,%esi
  801927:	bf 02 00 00 00       	mov    $0x2,%edi
  80192c:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
}
  801938:	c9                   	leaveq 
  801939:	c3                   	retq   

000000000080193a <sys_yield>:

void
sys_yield(void)
{
  80193a:	55                   	push   %rbp
  80193b:	48 89 e5             	mov    %rsp,%rbp
  80193e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801956:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	be 00 00 00 00       	mov    $0x0,%esi
  801965:	bf 0b 00 00 00       	mov    $0xb,%edi
  80196a:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801983:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801987:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80198a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80198d:	48 63 c8             	movslq %eax,%rcx
  801990:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801997:	48 98                	cltq   
  801999:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a0:	00 
  8019a1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a7:	49 89 c8             	mov    %rcx,%r8
  8019aa:	48 89 d1             	mov    %rdx,%rcx
  8019ad:	48 89 c2             	mov    %rax,%rdx
  8019b0:	be 01 00 00 00       	mov    $0x1,%esi
  8019b5:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ba:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  8019c1:	00 00 00 
  8019c4:	ff d0                	callq  *%rax
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 30          	sub    $0x30,%rsp
  8019d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019da:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019de:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019e2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e5:	48 63 c8             	movslq %eax,%rcx
  8019e8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ef:	48 63 f0             	movslq %eax,%rsi
  8019f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f9:	48 98                	cltq   
  8019fb:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019ff:	49 89 f9             	mov    %rdi,%r9
  801a02:	49 89 f0             	mov    %rsi,%r8
  801a05:	48 89 d1             	mov    %rdx,%rcx
  801a08:	48 89 c2             	mov    %rax,%rdx
  801a0b:	be 01 00 00 00       	mov    $0x1,%esi
  801a10:	bf 05 00 00 00       	mov    $0x5,%edi
  801a15:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
}
  801a21:	c9                   	leaveq 
  801a22:	c3                   	retq   

0000000000801a23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a23:	55                   	push   %rbp
  801a24:	48 89 e5             	mov    %rsp,%rbp
  801a27:	48 83 ec 20          	sub    $0x20,%rsp
  801a2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a39:	48 98                	cltq   
  801a3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a42:	00 
  801a43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4f:	48 89 d1             	mov    %rdx,%rcx
  801a52:	48 89 c2             	mov    %rax,%rdx
  801a55:	be 01 00 00 00       	mov    $0x1,%esi
  801a5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801a5f:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801a66:	00 00 00 
  801a69:	ff d0                	callq  *%rax
}
  801a6b:	c9                   	leaveq 
  801a6c:	c3                   	retq   

0000000000801a6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a6d:	55                   	push   %rbp
  801a6e:	48 89 e5             	mov    %rsp,%rbp
  801a71:	48 83 ec 10          	sub    $0x10,%rsp
  801a75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a7e:	48 63 d0             	movslq %eax,%rdx
  801a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	48 89 d1             	mov    %rdx,%rcx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 01 00 00 00       	mov    $0x1,%esi
  801aa5:	bf 08 00 00 00       	mov    $0x8,%edi
  801aaa:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ac7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ace:	48 98                	cltq   
  801ad0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad7:	00 
  801ad8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ade:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae4:	48 89 d1             	mov    %rdx,%rcx
  801ae7:	48 89 c2             	mov    %rax,%rdx
  801aea:	be 01 00 00 00       	mov    $0x1,%esi
  801aef:	bf 09 00 00 00       	mov    $0x9,%edi
  801af4:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801afb:	00 00 00 
  801afe:	ff d0                	callq  *%rax
}
  801b00:	c9                   	leaveq 
  801b01:	c3                   	retq   

0000000000801b02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b02:	55                   	push   %rbp
  801b03:	48 89 e5             	mov    %rsp,%rbp
  801b06:	48 83 ec 20          	sub    $0x20,%rsp
  801b0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	48 98                	cltq   
  801b1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b21:	00 
  801b22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2e:	48 89 d1             	mov    %rdx,%rcx
  801b31:	48 89 c2             	mov    %rax,%rdx
  801b34:	be 01 00 00 00       	mov    $0x1,%esi
  801b39:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b3e:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b5f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b65:	48 63 f0             	movslq %eax,%rsi
  801b68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6f:	48 98                	cltq   
  801b71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7c:	00 
  801b7d:	49 89 f1             	mov    %rsi,%r9
  801b80:	49 89 c8             	mov    %rcx,%r8
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 00 00 00 00       	mov    $0x0,%esi
  801b8e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b93:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 10          	sub    $0x10,%rsp
  801ba9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bca:	48 89 c2             	mov    %rax,%rdx
  801bcd:	be 01 00 00 00       	mov    $0x1,%esi
  801bd2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bd7:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801bde:	00 00 00 
  801be1:	ff d0                	callq  *%rax
}
  801be3:	c9                   	leaveq 
  801be4:	c3                   	retq   

0000000000801be5 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801be5:	55                   	push   %rbp
  801be6:	48 89 e5             	mov    %rsp,%rbp
  801be9:	48 83 ec 20          	sub    $0x20,%rsp
  801bed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c04:	00 
  801c05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c16:	89 c6                	mov    %eax,%esi
  801c18:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c1d:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801c24:	00 00 00 
  801c27:	ff d0                	callq  *%rax
}
  801c29:	c9                   	leaveq 
  801c2a:	c3                   	retq   

0000000000801c2b <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801c2b:	55                   	push   %rbp
  801c2c:	48 89 e5             	mov    %rsp,%rbp
  801c2f:	48 83 ec 20          	sub    $0x20,%rsp
  801c33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4a:	00 
  801c4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5c:	89 c6                	mov    %eax,%esi
  801c5e:	bf 10 00 00 00       	mov    $0x10,%edi
  801c63:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	callq  *%rax
}
  801c6f:	c9                   	leaveq 
  801c70:	c3                   	retq   

0000000000801c71 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c71:	55                   	push   %rbp
  801c72:	48 89 e5             	mov    %rsp,%rbp
  801c75:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c80:	00 
  801c81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	be 00 00 00 00       	mov    $0x0,%esi
  801c9c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ca1:	48 b8 a2 17 80 00 00 	movabs $0x8017a2,%rax
  801ca8:	00 00 00 
  801cab:	ff d0                	callq  *%rax
}
  801cad:	c9                   	leaveq 
  801cae:	c3                   	retq   

0000000000801caf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801caf:	55                   	push   %rbp
  801cb0:	48 89 e5             	mov    %rsp,%rbp
  801cb3:	48 83 ec 08          	sub    $0x8,%rsp
  801cb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cbb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cbf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cc6:	ff ff ff 
  801cc9:	48 01 d0             	add    %rdx,%rax
  801ccc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cd0:	c9                   	leaveq 
  801cd1:	c3                   	retq   

0000000000801cd2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd2:	55                   	push   %rbp
  801cd3:	48 89 e5             	mov    %rsp,%rbp
  801cd6:	48 83 ec 08          	sub    $0x8,%rsp
  801cda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce2:	48 89 c7             	mov    %rax,%rdi
  801ce5:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  801cec:	00 00 00 
  801cef:	ff d0                	callq  *%rax
  801cf1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cf7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cfb:	c9                   	leaveq 
  801cfc:	c3                   	retq   

0000000000801cfd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cfd:	55                   	push   %rbp
  801cfe:	48 89 e5             	mov    %rsp,%rbp
  801d01:	48 83 ec 18          	sub    $0x18,%rsp
  801d05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d10:	eb 6b                	jmp    801d7d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d15:	48 98                	cltq   
  801d17:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d1d:	48 c1 e0 0c          	shl    $0xc,%rax
  801d21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d29:	48 c1 e8 15          	shr    $0x15,%rax
  801d2d:	48 89 c2             	mov    %rax,%rdx
  801d30:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d37:	01 00 00 
  801d3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d3e:	83 e0 01             	and    $0x1,%eax
  801d41:	48 85 c0             	test   %rax,%rax
  801d44:	74 21                	je     801d67 <fd_alloc+0x6a>
  801d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4a:	48 c1 e8 0c          	shr    $0xc,%rax
  801d4e:	48 89 c2             	mov    %rax,%rdx
  801d51:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d58:	01 00 00 
  801d5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d5f:	83 e0 01             	and    $0x1,%eax
  801d62:	48 85 c0             	test   %rax,%rax
  801d65:	75 12                	jne    801d79 <fd_alloc+0x7c>
			*fd_store = fd;
  801d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	eb 1a                	jmp    801d93 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d7d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d81:	7e 8f                	jle    801d12 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d87:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d8e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 20          	sub    $0x20,%rsp
  801d9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801da4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801da8:	78 06                	js     801db0 <fd_lookup+0x1b>
  801daa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801dae:	7e 07                	jle    801db7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801db0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db5:	eb 6c                	jmp    801e23 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dba:	48 98                	cltq   
  801dbc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dc2:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dce:	48 c1 e8 15          	shr    $0x15,%rax
  801dd2:	48 89 c2             	mov    %rax,%rdx
  801dd5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ddc:	01 00 00 
  801ddf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de3:	83 e0 01             	and    $0x1,%eax
  801de6:	48 85 c0             	test   %rax,%rax
  801de9:	74 21                	je     801e0c <fd_lookup+0x77>
  801deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801def:	48 c1 e8 0c          	shr    $0xc,%rax
  801df3:	48 89 c2             	mov    %rax,%rdx
  801df6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dfd:	01 00 00 
  801e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e04:	83 e0 01             	and    $0x1,%eax
  801e07:	48 85 c0             	test   %rax,%rax
  801e0a:	75 07                	jne    801e13 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e11:	eb 10                	jmp    801e23 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e17:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e23:	c9                   	leaveq 
  801e24:	c3                   	retq   

0000000000801e25 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	48 83 ec 30          	sub    $0x30,%rsp
  801e2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e31:	89 f0                	mov    %esi,%eax
  801e33:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3a:	48 89 c7             	mov    %rax,%rdi
  801e3d:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e4d:	48 89 d6             	mov    %rdx,%rsi
  801e50:	89 c7                	mov    %eax,%edi
  801e52:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  801e59:	00 00 00 
  801e5c:	ff d0                	callq  *%rax
  801e5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e65:	78 0a                	js     801e71 <fd_close+0x4c>
	    || fd != fd2)
  801e67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e6f:	74 12                	je     801e83 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e71:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e75:	74 05                	je     801e7c <fd_close+0x57>
  801e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7a:	eb 05                	jmp    801e81 <fd_close+0x5c>
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e81:	eb 69                	jmp    801eec <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e87:	8b 00                	mov    (%rax),%eax
  801e89:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e8d:	48 89 d6             	mov    %rdx,%rsi
  801e90:	89 c7                	mov    %eax,%edi
  801e92:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	callq  *%rax
  801e9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea5:	78 2a                	js     801ed1 <fd_close+0xac>
		if (dev->dev_close)
  801ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eab:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eaf:	48 85 c0             	test   %rax,%rax
  801eb2:	74 16                	je     801eca <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ebc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ec0:	48 89 d7             	mov    %rdx,%rdi
  801ec3:	ff d0                	callq  *%rax
  801ec5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec8:	eb 07                	jmp    801ed1 <fd_close+0xac>
		else
			r = 0;
  801eca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed5:	48 89 c6             	mov    %rax,%rsi
  801ed8:	bf 00 00 00 00       	mov    $0x0,%edi
  801edd:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	callq  *%rax
	return r;
  801ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801eec:	c9                   	leaveq 
  801eed:	c3                   	retq   

0000000000801eee <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801eee:	55                   	push   %rbp
  801eef:	48 89 e5             	mov    %rsp,%rbp
  801ef2:	48 83 ec 20          	sub    $0x20,%rsp
  801ef6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ef9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801efd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f04:	eb 41                	jmp    801f47 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f06:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f0d:	00 00 00 
  801f10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f13:	48 63 d2             	movslq %edx,%rdx
  801f16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1a:	8b 00                	mov    (%rax),%eax
  801f1c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f1f:	75 22                	jne    801f43 <dev_lookup+0x55>
			*dev = devtab[i];
  801f21:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f28:	00 00 00 
  801f2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f2e:	48 63 d2             	movslq %edx,%rdx
  801f31:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f39:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	eb 60                	jmp    801fa3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f43:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f47:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f4e:	00 00 00 
  801f51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f54:	48 63 d2             	movslq %edx,%rdx
  801f57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5b:	48 85 c0             	test   %rax,%rax
  801f5e:	75 a6                	jne    801f06 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f60:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f67:	00 00 00 
  801f6a:	48 8b 00             	mov    (%rax),%rax
  801f6d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f73:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f76:	89 c6                	mov    %eax,%esi
  801f78:	48 bf 38 45 80 00 00 	movabs $0x804538,%rdi
  801f7f:	00 00 00 
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  801f8e:	00 00 00 
  801f91:	ff d1                	callq  *%rcx
	*dev = 0;
  801f93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f97:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fa3:	c9                   	leaveq 
  801fa4:	c3                   	retq   

0000000000801fa5 <close>:

int
close(int fdnum)
{
  801fa5:	55                   	push   %rbp
  801fa6:	48 89 e5             	mov    %rsp,%rbp
  801fa9:	48 83 ec 20          	sub    $0x20,%rsp
  801fad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb7:	48 89 d6             	mov    %rdx,%rsi
  801fba:	89 c7                	mov    %eax,%edi
  801fbc:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fcf:	79 05                	jns    801fd6 <close+0x31>
		return r;
  801fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd4:	eb 18                	jmp    801fee <close+0x49>
	else
		return fd_close(fd, 1);
  801fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fda:	be 01 00 00 00       	mov    $0x1,%esi
  801fdf:	48 89 c7             	mov    %rax,%rdi
  801fe2:	48 b8 25 1e 80 00 00 	movabs $0x801e25,%rax
  801fe9:	00 00 00 
  801fec:	ff d0                	callq  *%rax
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <close_all>:

void
close_all(void)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ff8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fff:	eb 15                	jmp    802016 <close_all+0x26>
		close(i);
  802001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802004:	89 c7                	mov    %eax,%edi
  802006:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  80200d:	00 00 00 
  802010:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802012:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802016:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80201a:	7e e5                	jle    802001 <close_all+0x11>
		close(i);
}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
  802022:	48 83 ec 40          	sub    $0x40,%rsp
  802026:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802029:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80202c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802030:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802033:	48 89 d6             	mov    %rdx,%rsi
  802036:	89 c7                	mov    %eax,%edi
  802038:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  80203f:	00 00 00 
  802042:	ff d0                	callq  *%rax
  802044:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802047:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204b:	79 08                	jns    802055 <dup+0x37>
		return r;
  80204d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802050:	e9 70 01 00 00       	jmpq   8021c5 <dup+0x1a7>
	close(newfdnum);
  802055:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802058:	89 c7                	mov    %eax,%edi
  80205a:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802066:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802069:	48 98                	cltq   
  80206b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802071:	48 c1 e0 0c          	shl    $0xc,%rax
  802075:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207d:	48 89 c7             	mov    %rax,%rdi
  802080:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax
  80208c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802094:	48 89 c7             	mov    %rax,%rdi
  802097:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
  8020a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ab:	48 c1 e8 15          	shr    $0x15,%rax
  8020af:	48 89 c2             	mov    %rax,%rdx
  8020b2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020b9:	01 00 00 
  8020bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c0:	83 e0 01             	and    $0x1,%eax
  8020c3:	48 85 c0             	test   %rax,%rax
  8020c6:	74 73                	je     80213b <dup+0x11d>
  8020c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d0:	48 89 c2             	mov    %rax,%rdx
  8020d3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020da:	01 00 00 
  8020dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e1:	83 e0 01             	and    $0x1,%eax
  8020e4:	48 85 c0             	test   %rax,%rax
  8020e7:	74 52                	je     80213b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ed:	48 c1 e8 0c          	shr    $0xc,%rax
  8020f1:	48 89 c2             	mov    %rax,%rdx
  8020f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020fb:	01 00 00 
  8020fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802102:	25 07 0e 00 00       	and    $0xe07,%eax
  802107:	89 c1                	mov    %eax,%ecx
  802109:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	41 89 c8             	mov    %ecx,%r8d
  802114:	48 89 d1             	mov    %rdx,%rcx
  802117:	ba 00 00 00 00       	mov    $0x0,%edx
  80211c:	48 89 c6             	mov    %rax,%rsi
  80211f:	bf 00 00 00 00       	mov    $0x0,%edi
  802124:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802137:	79 02                	jns    80213b <dup+0x11d>
			goto err;
  802139:	eb 57                	jmp    802192 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80213b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213f:	48 c1 e8 0c          	shr    $0xc,%rax
  802143:	48 89 c2             	mov    %rax,%rdx
  802146:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80214d:	01 00 00 
  802150:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802154:	25 07 0e 00 00       	and    $0xe07,%eax
  802159:	89 c1                	mov    %eax,%ecx
  80215b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802163:	41 89 c8             	mov    %ecx,%r8d
  802166:	48 89 d1             	mov    %rdx,%rcx
  802169:	ba 00 00 00 00       	mov    $0x0,%edx
  80216e:	48 89 c6             	mov    %rax,%rsi
  802171:	bf 00 00 00 00       	mov    $0x0,%edi
  802176:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax
  802182:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802189:	79 02                	jns    80218d <dup+0x16f>
		goto err;
  80218b:	eb 05                	jmp    802192 <dup+0x174>

	return newfdnum;
  80218d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802190:	eb 33                	jmp    8021c5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802196:	48 89 c6             	mov    %rax,%rsi
  802199:	bf 00 00 00 00       	mov    $0x0,%edi
  80219e:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ae:	48 89 c6             	mov    %rax,%rsi
  8021b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b6:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8021bd:	00 00 00 
  8021c0:	ff d0                	callq  *%rax
	return r;
  8021c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c5:	c9                   	leaveq 
  8021c6:	c3                   	retq   

00000000008021c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021c7:	55                   	push   %rbp
  8021c8:	48 89 e5             	mov    %rsp,%rbp
  8021cb:	48 83 ec 40          	sub    $0x40,%rsp
  8021cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021e1:	48 89 d6             	mov    %rdx,%rsi
  8021e4:	89 c7                	mov    %eax,%edi
  8021e6:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8021ed:	00 00 00 
  8021f0:	ff d0                	callq  *%rax
  8021f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f9:	78 24                	js     80221f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ff:	8b 00                	mov    (%rax),%eax
  802201:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802205:	48 89 d6             	mov    %rdx,%rsi
  802208:	89 c7                	mov    %eax,%edi
  80220a:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax
  802216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221d:	79 05                	jns    802224 <read+0x5d>
		return r;
  80221f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802222:	eb 76                	jmp    80229a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	8b 40 08             	mov    0x8(%rax),%eax
  80222b:	83 e0 03             	and    $0x3,%eax
  80222e:	83 f8 01             	cmp    $0x1,%eax
  802231:	75 3a                	jne    80226d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802233:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80223a:	00 00 00 
  80223d:	48 8b 00             	mov    (%rax),%rax
  802240:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802246:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802249:	89 c6                	mov    %eax,%esi
  80224b:	48 bf 57 45 80 00 00 	movabs $0x804557,%rdi
  802252:	00 00 00 
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
  80225a:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  802261:	00 00 00 
  802264:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802266:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226b:	eb 2d                	jmp    80229a <read+0xd3>
	}
	if (!dev->dev_read)
  80226d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802271:	48 8b 40 10          	mov    0x10(%rax),%rax
  802275:	48 85 c0             	test   %rax,%rax
  802278:	75 07                	jne    802281 <read+0xba>
		return -E_NOT_SUPP;
  80227a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80227f:	eb 19                	jmp    80229a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802285:	48 8b 40 10          	mov    0x10(%rax),%rax
  802289:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80228d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802291:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802295:	48 89 cf             	mov    %rcx,%rdi
  802298:	ff d0                	callq  *%rax
}
  80229a:	c9                   	leaveq 
  80229b:	c3                   	retq   

000000000080229c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80229c:	55                   	push   %rbp
  80229d:	48 89 e5             	mov    %rsp,%rbp
  8022a0:	48 83 ec 30          	sub    $0x30,%rsp
  8022a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b6:	eb 49                	jmp    802301 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bb:	48 98                	cltq   
  8022bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c1:	48 29 c2             	sub    %rax,%rdx
  8022c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c7:	48 63 c8             	movslq %eax,%rcx
  8022ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ce:	48 01 c1             	add    %rax,%rcx
  8022d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d4:	48 89 ce             	mov    %rcx,%rsi
  8022d7:	89 c7                	mov    %eax,%edi
  8022d9:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022ec:	79 05                	jns    8022f3 <readn+0x57>
			return m;
  8022ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022f1:	eb 1c                	jmp    80230f <readn+0x73>
		if (m == 0)
  8022f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022f7:	75 02                	jne    8022fb <readn+0x5f>
			break;
  8022f9:	eb 11                	jmp    80230c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022fe:	01 45 fc             	add    %eax,-0x4(%rbp)
  802301:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802304:	48 98                	cltq   
  802306:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80230a:	72 ac                	jb     8022b8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80230c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80230f:	c9                   	leaveq 
  802310:	c3                   	retq   

0000000000802311 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802311:	55                   	push   %rbp
  802312:	48 89 e5             	mov    %rsp,%rbp
  802315:	48 83 ec 40          	sub    $0x40,%rsp
  802319:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80231c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802320:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802324:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802328:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80232b:	48 89 d6             	mov    %rdx,%rsi
  80232e:	89 c7                	mov    %eax,%edi
  802330:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802337:	00 00 00 
  80233a:	ff d0                	callq  *%rax
  80233c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802343:	78 24                	js     802369 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802349:	8b 00                	mov    (%rax),%eax
  80234b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80234f:	48 89 d6             	mov    %rdx,%rsi
  802352:	89 c7                	mov    %eax,%edi
  802354:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  80235b:	00 00 00 
  80235e:	ff d0                	callq  *%rax
  802360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802367:	79 05                	jns    80236e <write+0x5d>
		return r;
  802369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236c:	eb 75                	jmp    8023e3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80236e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802372:	8b 40 08             	mov    0x8(%rax),%eax
  802375:	83 e0 03             	and    $0x3,%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	75 3a                	jne    8023b6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80237c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802383:	00 00 00 
  802386:	48 8b 00             	mov    (%rax),%rax
  802389:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80238f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802392:	89 c6                	mov    %eax,%esi
  802394:	48 bf 73 45 80 00 00 	movabs $0x804573,%rdi
  80239b:	00 00 00 
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a3:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  8023aa:	00 00 00 
  8023ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b4:	eb 2d                	jmp    8023e3 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8023b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023be:	48 85 c0             	test   %rax,%rax
  8023c1:	75 07                	jne    8023ca <write+0xb9>
		return -E_NOT_SUPP;
  8023c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023c8:	eb 19                	jmp    8023e3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023de:	48 89 cf             	mov    %rcx,%rdi
  8023e1:	ff d0                	callq  *%rax
}
  8023e3:	c9                   	leaveq 
  8023e4:	c3                   	retq   

00000000008023e5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023e5:	55                   	push   %rbp
  8023e6:	48 89 e5             	mov    %rsp,%rbp
  8023e9:	48 83 ec 18          	sub    $0x18,%rsp
  8023ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023fa:	48 89 d6             	mov    %rdx,%rsi
  8023fd:	89 c7                	mov    %eax,%edi
  8023ff:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
  80240b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802412:	79 05                	jns    802419 <seek+0x34>
		return r;
  802414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802417:	eb 0f                	jmp    802428 <seek+0x43>
	fd->fd_offset = offset;
  802419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802420:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 30          	sub    $0x30,%rsp
  802432:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802435:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802438:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80243c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243f:	48 89 d6             	mov    %rdx,%rsi
  802442:	89 c7                	mov    %eax,%edi
  802444:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  80244b:	00 00 00 
  80244e:	ff d0                	callq  *%rax
  802450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802457:	78 24                	js     80247d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	8b 00                	mov    (%rax),%eax
  80245f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802463:	48 89 d6             	mov    %rdx,%rsi
  802466:	89 c7                	mov    %eax,%edi
  802468:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  80246f:	00 00 00 
  802472:	ff d0                	callq  *%rax
  802474:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802477:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247b:	79 05                	jns    802482 <ftruncate+0x58>
		return r;
  80247d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802480:	eb 72                	jmp    8024f4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802486:	8b 40 08             	mov    0x8(%rax),%eax
  802489:	83 e0 03             	and    $0x3,%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	75 3a                	jne    8024ca <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802490:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802497:	00 00 00 
  80249a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80249d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a6:	89 c6                	mov    %eax,%esi
  8024a8:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  8024af:	00 00 00 
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	48 b9 94 04 80 00 00 	movabs $0x800494,%rcx
  8024be:	00 00 00 
  8024c1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c8:	eb 2a                	jmp    8024f4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ce:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d2:	48 85 c0             	test   %rax,%rax
  8024d5:	75 07                	jne    8024de <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024dc:	eb 16                	jmp    8024f4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ea:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024ed:	89 ce                	mov    %ecx,%esi
  8024ef:	48 89 d7             	mov    %rdx,%rdi
  8024f2:	ff d0                	callq  *%rax
}
  8024f4:	c9                   	leaveq 
  8024f5:	c3                   	retq   

00000000008024f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024f6:	55                   	push   %rbp
  8024f7:	48 89 e5             	mov    %rsp,%rbp
  8024fa:	48 83 ec 30          	sub    $0x30,%rsp
  8024fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802501:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802505:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802509:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250c:	48 89 d6             	mov    %rdx,%rsi
  80250f:	89 c7                	mov    %eax,%edi
  802511:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802518:	00 00 00 
  80251b:	ff d0                	callq  *%rax
  80251d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802520:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802524:	78 24                	js     80254a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252a:	8b 00                	mov    (%rax),%eax
  80252c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802530:	48 89 d6             	mov    %rdx,%rsi
  802533:	89 c7                	mov    %eax,%edi
  802535:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802548:	79 05                	jns    80254f <fstat+0x59>
		return r;
  80254a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254d:	eb 5e                	jmp    8025ad <fstat+0xb7>
	if (!dev->dev_stat)
  80254f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802553:	48 8b 40 28          	mov    0x28(%rax),%rax
  802557:	48 85 c0             	test   %rax,%rax
  80255a:	75 07                	jne    802563 <fstat+0x6d>
		return -E_NOT_SUPP;
  80255c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802561:	eb 4a                	jmp    8025ad <fstat+0xb7>
	stat->st_name[0] = 0;
  802563:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802567:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80256a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802575:	00 00 00 
	stat->st_isdir = 0;
  802578:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802583:	00 00 00 
	stat->st_dev = dev;
  802586:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80258e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802599:	48 8b 40 28          	mov    0x28(%rax),%rax
  80259d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025a1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025a5:	48 89 ce             	mov    %rcx,%rsi
  8025a8:	48 89 d7             	mov    %rdx,%rdi
  8025ab:	ff d0                	callq  *%rax
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 20          	sub    $0x20,%rsp
  8025b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c3:	be 00 00 00 00       	mov    $0x0,%esi
  8025c8:	48 89 c7             	mov    %rax,%rdi
  8025cb:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <stat+0x36>
		return fd;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 2f                	jmp    802614 <stat+0x65>
	r = fstat(fd, stat);
  8025e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ec:	48 89 d6             	mov    %rdx,%rsi
  8025ef:	89 c7                	mov    %eax,%edi
  8025f1:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
  8025fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802600:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802603:	89 c7                	mov    %eax,%edi
  802605:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	callq  *%rax
	return r;
  802611:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802614:	c9                   	leaveq 
  802615:	c3                   	retq   

0000000000802616 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802616:	55                   	push   %rbp
  802617:	48 89 e5             	mov    %rsp,%rbp
  80261a:	48 83 ec 10          	sub    $0x10,%rsp
  80261e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802621:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802625:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80262c:	00 00 00 
  80262f:	8b 00                	mov    (%rax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 1d                	jne    802652 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802635:	bf 01 00 00 00       	mov    $0x1,%edi
  80263a:	48 b8 a3 3e 80 00 00 	movabs $0x803ea3,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80264d:	00 00 00 
  802650:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802652:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802659:	00 00 00 
  80265c:	8b 00                	mov    (%rax),%eax
  80265e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802661:	b9 07 00 00 00       	mov    $0x7,%ecx
  802666:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80266d:	00 00 00 
  802670:	89 c7                	mov    %eax,%edi
  802672:	48 b8 41 3e 80 00 00 	movabs $0x803e41,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80267e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802682:	ba 00 00 00 00       	mov    $0x0,%edx
  802687:	48 89 c6             	mov    %rax,%rsi
  80268a:	bf 00 00 00 00       	mov    $0x0,%edi
  80268f:	48 b8 3b 3d 80 00 00 	movabs $0x803d3b,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
}
  80269b:	c9                   	leaveq 
  80269c:	c3                   	retq   

000000000080269d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
  8026a1:	48 83 ec 30          	sub    $0x30,%rsp
  8026a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026a9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8026ac:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8026b3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8026ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8026c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8026c6:	75 08                	jne    8026d0 <open+0x33>
	{
		return r;
  8026c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026cb:	e9 f2 00 00 00       	jmpq   8027c2 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8026d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d4:	48 89 c7             	mov    %rax,%rdi
  8026d7:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026e6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8026ed:	7e 0a                	jle    8026f9 <open+0x5c>
	{
		return -E_BAD_PATH;
  8026ef:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026f4:	e9 c9 00 00 00       	jmpq   8027c2 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8026f9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802700:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802701:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802705:	48 89 c7             	mov    %rax,%rdi
  802708:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
  802714:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802717:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271b:	78 09                	js     802726 <open+0x89>
  80271d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802721:	48 85 c0             	test   %rax,%rax
  802724:	75 08                	jne    80272e <open+0x91>
		{
			return r;
  802726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802729:	e9 94 00 00 00       	jmpq   8027c2 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80272e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802732:	ba 00 04 00 00       	mov    $0x400,%edx
  802737:	48 89 c6             	mov    %rax,%rsi
  80273a:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802741:	00 00 00 
  802744:	48 b8 db 10 80 00 00 	movabs $0x8010db,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802750:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802757:	00 00 00 
  80275a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80275d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802767:	48 89 c6             	mov    %rax,%rsi
  80276a:	bf 01 00 00 00       	mov    $0x1,%edi
  80276f:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	79 2b                	jns    8027af <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802788:	be 00 00 00 00       	mov    $0x0,%esi
  80278d:	48 89 c7             	mov    %rax,%rdi
  802790:	48 b8 25 1e 80 00 00 	movabs $0x801e25,%rax
  802797:	00 00 00 
  80279a:	ff d0                	callq  *%rax
  80279c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80279f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027a3:	79 05                	jns    8027aa <open+0x10d>
			{
				return d;
  8027a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027a8:	eb 18                	jmp    8027c2 <open+0x125>
			}
			return r;
  8027aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ad:	eb 13                	jmp    8027c2 <open+0x125>
		}	
		return fd2num(fd_store);
  8027af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b3:	48 89 c7             	mov    %rax,%rdi
  8027b6:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  8027bd:	00 00 00 
  8027c0:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8027c2:	c9                   	leaveq 
  8027c3:	c3                   	retq   

00000000008027c4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027c4:	55                   	push   %rbp
  8027c5:	48 89 e5             	mov    %rsp,%rbp
  8027c8:	48 83 ec 10          	sub    $0x10,%rsp
  8027cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d4:	8b 50 0c             	mov    0xc(%rax),%edx
  8027d7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027de:	00 00 00 
  8027e1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027e3:	be 00 00 00 00       	mov    $0x0,%esi
  8027e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8027ed:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
}
  8027f9:	c9                   	leaveq 
  8027fa:	c3                   	retq   

00000000008027fb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027fb:	55                   	push   %rbp
  8027fc:	48 89 e5             	mov    %rsp,%rbp
  8027ff:	48 83 ec 30          	sub    $0x30,%rsp
  802803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802807:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80280b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80280f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802816:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80281b:	74 07                	je     802824 <devfile_read+0x29>
  80281d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802822:	75 07                	jne    80282b <devfile_read+0x30>
		return -E_INVAL;
  802824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802829:	eb 77                	jmp    8028a2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80282b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282f:	8b 50 0c             	mov    0xc(%rax),%edx
  802832:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802839:	00 00 00 
  80283c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80283e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802845:	00 00 00 
  802848:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802850:	be 00 00 00 00       	mov    $0x0,%esi
  802855:	bf 03 00 00 00       	mov    $0x3,%edi
  80285a:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286d:	7f 05                	jg     802874 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80286f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802872:	eb 2e                	jmp    8028a2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802877:	48 63 d0             	movslq %eax,%rdx
  80287a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802885:	00 00 00 
  802888:	48 89 c7             	mov    %rax,%rdi
  80288b:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802897:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80289f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8028a2:	c9                   	leaveq 
  8028a3:	c3                   	retq   

00000000008028a4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	48 83 ec 30          	sub    $0x30,%rsp
  8028ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8028b8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8028bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028c4:	74 07                	je     8028cd <devfile_write+0x29>
  8028c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028cb:	75 08                	jne    8028d5 <devfile_write+0x31>
		return r;
  8028cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d0:	e9 9a 00 00 00       	jmpq   80296f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e3:	00 00 00 
  8028e6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8028e8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028ef:	00 
  8028f0:	76 08                	jbe    8028fa <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8028f2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028f9:	00 
	}
	fsipcbuf.write.req_n = n;
  8028fa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802901:	00 00 00 
  802904:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802908:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80290c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802910:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802914:	48 89 c6             	mov    %rax,%rsi
  802917:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80291e:	00 00 00 
  802921:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80292d:	be 00 00 00 00       	mov    $0x0,%esi
  802932:	bf 04 00 00 00       	mov    $0x4,%edi
  802937:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
  802943:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294a:	7f 20                	jg     80296c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80294c:	48 bf b6 45 80 00 00 	movabs $0x8045b6,%rdi
  802953:	00 00 00 
  802956:	b8 00 00 00 00       	mov    $0x0,%eax
  80295b:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802962:	00 00 00 
  802965:	ff d2                	callq  *%rdx
		return r;
  802967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296a:	eb 03                	jmp    80296f <devfile_write+0xcb>
	}
	return r;
  80296c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80296f:	c9                   	leaveq 
  802970:	c3                   	retq   

0000000000802971 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802971:	55                   	push   %rbp
  802972:	48 89 e5             	mov    %rsp,%rbp
  802975:	48 83 ec 20          	sub    $0x20,%rsp
  802979:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80297d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802985:	8b 50 0c             	mov    0xc(%rax),%edx
  802988:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80298f:	00 00 00 
  802992:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802994:	be 00 00 00 00       	mov    $0x0,%esi
  802999:	bf 05 00 00 00       	mov    $0x5,%edi
  80299e:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8029a5:	00 00 00 
  8029a8:	ff d0                	callq  *%rax
  8029aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b1:	79 05                	jns    8029b8 <devfile_stat+0x47>
		return r;
  8029b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b6:	eb 56                	jmp    802a0e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029bc:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029c3:	00 00 00 
  8029c6:	48 89 c7             	mov    %rax,%rdi
  8029c9:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029d5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029dc:	00 00 00 
  8029df:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f6:	00 00 00 
  8029f9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a03:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0e:	c9                   	leaveq 
  802a0f:	c3                   	retq   

0000000000802a10 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a10:	55                   	push   %rbp
  802a11:	48 89 e5             	mov    %rsp,%rbp
  802a14:	48 83 ec 10          	sub    $0x10,%rsp
  802a18:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a1c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a23:	8b 50 0c             	mov    0xc(%rax),%edx
  802a26:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2d:	00 00 00 
  802a30:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a32:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a39:	00 00 00 
  802a3c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a3f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a42:	be 00 00 00 00       	mov    $0x0,%esi
  802a47:	bf 02 00 00 00       	mov    $0x2,%edi
  802a4c:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	callq  *%rax
}
  802a58:	c9                   	leaveq 
  802a59:	c3                   	retq   

0000000000802a5a <remove>:

// Delete a file
int
remove(const char *path)
{
  802a5a:	55                   	push   %rbp
  802a5b:	48 89 e5             	mov    %rsp,%rbp
  802a5e:	48 83 ec 10          	sub    $0x10,%rsp
  802a62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6a:	48 89 c7             	mov    %rax,%rdi
  802a6d:	48 b8 dd 0f 80 00 00 	movabs $0x800fdd,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
  802a79:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a7e:	7e 07                	jle    802a87 <remove+0x2d>
		return -E_BAD_PATH;
  802a80:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a85:	eb 33                	jmp    802aba <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a8b:	48 89 c6             	mov    %rax,%rsi
  802a8e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a95:	00 00 00 
  802a98:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802aa4:	be 00 00 00 00       	mov    $0x0,%esi
  802aa9:	bf 07 00 00 00       	mov    $0x7,%edi
  802aae:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
}
  802aba:	c9                   	leaveq 
  802abb:	c3                   	retq   

0000000000802abc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802abc:	55                   	push   %rbp
  802abd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ac0:	be 00 00 00 00       	mov    $0x0,%esi
  802ac5:	bf 08 00 00 00       	mov    $0x8,%edi
  802aca:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
}
  802ad6:	5d                   	pop    %rbp
  802ad7:	c3                   	retq   

0000000000802ad8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ae3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802aea:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802af1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802af8:	be 00 00 00 00       	mov    $0x0,%esi
  802afd:	48 89 c7             	mov    %rax,%rdi
  802b00:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
  802b0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b13:	79 28                	jns    802b3d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b18:	89 c6                	mov    %eax,%esi
  802b1a:	48 bf d2 45 80 00 00 	movabs $0x8045d2,%rdi
  802b21:	00 00 00 
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802b30:	00 00 00 
  802b33:	ff d2                	callq  *%rdx
		return fd_src;
  802b35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b38:	e9 74 01 00 00       	jmpq   802cb1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b3d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b44:	be 01 01 00 00       	mov    $0x101,%esi
  802b49:	48 89 c7             	mov    %rax,%rdi
  802b4c:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
  802b58:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b5b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b5f:	79 39                	jns    802b9a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b64:	89 c6                	mov    %eax,%esi
  802b66:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  802b6d:	00 00 00 
  802b70:	b8 00 00 00 00       	mov    $0x0,%eax
  802b75:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802b7c:	00 00 00 
  802b7f:	ff d2                	callq  *%rdx
		close(fd_src);
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	89 c7                	mov    %eax,%edi
  802b86:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
		return fd_dest;
  802b92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b95:	e9 17 01 00 00       	jmpq   802cb1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b9a:	eb 74                	jmp    802c10 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b9c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b9f:	48 63 d0             	movslq %eax,%rdx
  802ba2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bac:	48 89 ce             	mov    %rcx,%rsi
  802baf:	89 c7                	mov    %eax,%edi
  802bb1:	48 b8 11 23 80 00 00 	movabs $0x802311,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802bc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bc4:	79 4a                	jns    802c10 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bc6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bc9:	89 c6                	mov    %eax,%esi
  802bcb:	48 bf 02 46 80 00 00 	movabs $0x804602,%rdi
  802bd2:	00 00 00 
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802be1:	00 00 00 
  802be4:	ff d2                	callq  *%rdx
			close(fd_src);
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	89 c7                	mov    %eax,%edi
  802beb:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
			close(fd_dest);
  802bf7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bfa:	89 c7                	mov    %eax,%edi
  802bfc:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
			return write_size;
  802c08:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c0b:	e9 a1 00 00 00       	jmpq   802cb1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c10:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1a:	ba 00 02 00 00       	mov    $0x200,%edx
  802c1f:	48 89 ce             	mov    %rcx,%rsi
  802c22:	89 c7                	mov    %eax,%edi
  802c24:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
  802c30:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c37:	0f 8f 5f ff ff ff    	jg     802b9c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c41:	79 47                	jns    802c8a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c46:	89 c6                	mov    %eax,%esi
  802c48:	48 bf 15 46 80 00 00 	movabs $0x804615,%rdi
  802c4f:	00 00 00 
  802c52:	b8 00 00 00 00       	mov    $0x0,%eax
  802c57:	48 ba 94 04 80 00 00 	movabs $0x800494,%rdx
  802c5e:	00 00 00 
  802c61:	ff d2                	callq  *%rdx
		close(fd_src);
  802c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c66:	89 c7                	mov    %eax,%edi
  802c68:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	callq  *%rax
		close(fd_dest);
  802c74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
		return read_size;
  802c85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c88:	eb 27                	jmp    802cb1 <copy+0x1d9>
	}
	close(fd_src);
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	89 c7                	mov    %eax,%edi
  802c8f:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
	close(fd_dest);
  802c9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c9e:	89 c7                	mov    %eax,%edi
  802ca0:	48 b8 a5 1f 80 00 00 	movabs $0x801fa5,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
	return 0;
  802cac:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 20          	sub    $0x20,%rsp
  802cbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802cbe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc5:	48 89 d6             	mov    %rdx,%rsi
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	79 05                	jns    802ce4 <fd2sockid+0x31>
		return r;
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	eb 24                	jmp    802d08 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce8:	8b 10                	mov    (%rax),%edx
  802cea:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802cf1:	00 00 00 
  802cf4:	8b 00                	mov    (%rax),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	74 07                	je     802d01 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802cfa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cff:	eb 07                	jmp    802d08 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d05:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d08:	c9                   	leaveq 
  802d09:	c3                   	retq   

0000000000802d0a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d0a:	55                   	push   %rbp
  802d0b:	48 89 e5             	mov    %rsp,%rbp
  802d0e:	48 83 ec 20          	sub    $0x20,%rsp
  802d12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d15:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d19:	48 89 c7             	mov    %rax,%rdi
  802d1c:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  802d23:	00 00 00 
  802d26:	ff d0                	callq  *%rax
  802d28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2f:	78 26                	js     802d57 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d35:	ba 07 04 00 00       	mov    $0x407,%edx
  802d3a:	48 89 c6             	mov    %rax,%rsi
  802d3d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d42:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
  802d4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d55:	79 16                	jns    802d6d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d5a:	89 c7                	mov    %eax,%edi
  802d5c:	48 b8 17 32 80 00 00 	movabs $0x803217,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
		return r;
  802d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6b:	eb 3a                	jmp    802da7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d71:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802d78:	00 00 00 
  802d7b:	8b 12                	mov    (%rdx),%edx
  802d7d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802d7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802d8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d91:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802d94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d98:	48 89 c7             	mov    %rax,%rdi
  802d9b:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	callq  *%rax
}
  802da7:	c9                   	leaveq 
  802da8:	c3                   	retq   

0000000000802da9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802da9:	55                   	push   %rbp
  802daa:	48 89 e5             	mov    %rsp,%rbp
  802dad:	48 83 ec 30          	sub    $0x30,%rsp
  802db1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802db8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802dbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dbf:	89 c7                	mov    %eax,%edi
  802dc1:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd4:	79 05                	jns    802ddb <accept+0x32>
		return r;
  802dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd9:	eb 3b                	jmp    802e16 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ddb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ddf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de6:	48 89 ce             	mov    %rcx,%rsi
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 f4 30 80 00 00 	movabs $0x8030f4,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
  802df7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dfe:	79 05                	jns    802e05 <accept+0x5c>
		return r;
  802e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e03:	eb 11                	jmp    802e16 <accept+0x6d>
	return alloc_sockfd(r);
  802e05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e08:	89 c7                	mov    %eax,%edi
  802e0a:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
}
  802e16:	c9                   	leaveq 
  802e17:	c3                   	retq   

0000000000802e18 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 20          	sub    $0x20,%rsp
  802e20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e27:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e2d:	89 c7                	mov    %eax,%edi
  802e2f:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802e36:	00 00 00 
  802e39:	ff d0                	callq  *%rax
  802e3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e42:	79 05                	jns    802e49 <bind+0x31>
		return r;
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	eb 1b                	jmp    802e64 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e49:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e4c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e53:	48 89 ce             	mov    %rcx,%rsi
  802e56:	89 c7                	mov    %eax,%edi
  802e58:	48 b8 73 31 80 00 00 	movabs $0x803173,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
}
  802e64:	c9                   	leaveq 
  802e65:	c3                   	retq   

0000000000802e66 <shutdown>:

int
shutdown(int s, int how)
{
  802e66:	55                   	push   %rbp
  802e67:	48 89 e5             	mov    %rsp,%rbp
  802e6a:	48 83 ec 20          	sub    $0x20,%rsp
  802e6e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e71:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e77:	89 c7                	mov    %eax,%edi
  802e79:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802e80:	00 00 00 
  802e83:	ff d0                	callq  *%rax
  802e85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8c:	79 05                	jns    802e93 <shutdown+0x2d>
		return r;
  802e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e91:	eb 16                	jmp    802ea9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802e93:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e99:	89 d6                	mov    %edx,%esi
  802e9b:	89 c7                	mov    %eax,%edi
  802e9d:	48 b8 d7 31 80 00 00 	movabs $0x8031d7,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 10          	sub    $0x10,%rsp
  802eb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802eb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebb:	48 89 c7             	mov    %rax,%rdi
  802ebe:	48 b8 25 3f 80 00 00 	movabs $0x803f25,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	callq  *%rax
  802eca:	83 f8 01             	cmp    $0x1,%eax
  802ecd:	75 17                	jne    802ee6 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed3:	8b 40 0c             	mov    0xc(%rax),%eax
  802ed6:	89 c7                	mov    %eax,%edi
  802ed8:	48 b8 17 32 80 00 00 	movabs $0x803217,%rax
  802edf:	00 00 00 
  802ee2:	ff d0                	callq  *%rax
  802ee4:	eb 05                	jmp    802eeb <devsock_close+0x40>
	else
		return 0;
  802ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eeb:	c9                   	leaveq 
  802eec:	c3                   	retq   

0000000000802eed <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802eed:	55                   	push   %rbp
  802eee:	48 89 e5             	mov    %rsp,%rbp
  802ef1:	48 83 ec 20          	sub    $0x20,%rsp
  802ef5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802efc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802eff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	79 05                	jns    802f1e <connect+0x31>
		return r;
  802f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1c:	eb 1b                	jmp    802f39 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f1e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f21:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f28:	48 89 ce             	mov    %rcx,%rsi
  802f2b:	89 c7                	mov    %eax,%edi
  802f2d:	48 b8 44 32 80 00 00 	movabs $0x803244,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax
}
  802f39:	c9                   	leaveq 
  802f3a:	c3                   	retq   

0000000000802f3b <listen>:

int
listen(int s, int backlog)
{
  802f3b:	55                   	push   %rbp
  802f3c:	48 89 e5             	mov    %rsp,%rbp
  802f3f:	48 83 ec 20          	sub    $0x20,%rsp
  802f43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f46:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f4c:	89 c7                	mov    %eax,%edi
  802f4e:	48 b8 b3 2c 80 00 00 	movabs $0x802cb3,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax
  802f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f61:	79 05                	jns    802f68 <listen+0x2d>
		return r;
  802f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f66:	eb 16                	jmp    802f7e <listen+0x43>
	return nsipc_listen(r, backlog);
  802f68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6e:	89 d6                	mov    %edx,%esi
  802f70:	89 c7                	mov    %eax,%edi
  802f72:	48 b8 a8 32 80 00 00 	movabs $0x8032a8,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
}
  802f7e:	c9                   	leaveq 
  802f7f:	c3                   	retq   

0000000000802f80 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802f80:	55                   	push   %rbp
  802f81:	48 89 e5             	mov    %rsp,%rbp
  802f84:	48 83 ec 20          	sub    $0x20,%rsp
  802f88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f98:	89 c2                	mov    %eax,%edx
  802f9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9e:	8b 40 0c             	mov    0xc(%rax),%eax
  802fa1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  802faa:	89 c7                	mov    %eax,%edi
  802fac:	48 b8 e8 32 80 00 00 	movabs $0x8032e8,%rax
  802fb3:	00 00 00 
  802fb6:	ff d0                	callq  *%rax
}
  802fb8:	c9                   	leaveq 
  802fb9:	c3                   	retq   

0000000000802fba <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802fba:	55                   	push   %rbp
  802fbb:	48 89 e5             	mov    %rsp,%rbp
  802fbe:	48 83 ec 20          	sub    $0x20,%rsp
  802fc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd2:	89 c2                	mov    %eax,%edx
  802fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd8:	8b 40 0c             	mov    0xc(%rax),%eax
  802fdb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fe4:	89 c7                	mov    %eax,%edi
  802fe6:	48 b8 b4 33 80 00 00 	movabs $0x8033b4,%rax
  802fed:	00 00 00 
  802ff0:	ff d0                	callq  *%rax
}
  802ff2:	c9                   	leaveq 
  802ff3:	c3                   	retq   

0000000000802ff4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802ff4:	55                   	push   %rbp
  802ff5:	48 89 e5             	mov    %rsp,%rbp
  802ff8:	48 83 ec 10          	sub    $0x10,%rsp
  802ffc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803000:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803008:	48 be 30 46 80 00 00 	movabs $0x804630,%rsi
  80300f:	00 00 00 
  803012:	48 89 c7             	mov    %rax,%rdi
  803015:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  80301c:	00 00 00 
  80301f:	ff d0                	callq  *%rax
	return 0;
  803021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803026:	c9                   	leaveq 
  803027:	c3                   	retq   

0000000000803028 <socket>:

int
socket(int domain, int type, int protocol)
{
  803028:	55                   	push   %rbp
  803029:	48 89 e5             	mov    %rsp,%rbp
  80302c:	48 83 ec 20          	sub    $0x20,%rsp
  803030:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803033:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803036:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803039:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80303c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80303f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803042:	89 ce                	mov    %ecx,%esi
  803044:	89 c7                	mov    %eax,%edi
  803046:	48 b8 6c 34 80 00 00 	movabs $0x80346c,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803059:	79 05                	jns    803060 <socket+0x38>
		return r;
  80305b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305e:	eb 11                	jmp    803071 <socket+0x49>
	return alloc_sockfd(r);
  803060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803063:	89 c7                	mov    %eax,%edi
  803065:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  80306c:	00 00 00 
  80306f:	ff d0                	callq  *%rax
}
  803071:	c9                   	leaveq 
  803072:	c3                   	retq   

0000000000803073 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803073:	55                   	push   %rbp
  803074:	48 89 e5             	mov    %rsp,%rbp
  803077:	48 83 ec 10          	sub    $0x10,%rsp
  80307b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80307e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803085:	00 00 00 
  803088:	8b 00                	mov    (%rax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	75 1d                	jne    8030ab <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80308e:	bf 02 00 00 00       	mov    $0x2,%edi
  803093:	48 b8 a3 3e 80 00 00 	movabs $0x803ea3,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
  80309f:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8030a6:	00 00 00 
  8030a9:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8030ab:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030b2:	00 00 00 
  8030b5:	8b 00                	mov    (%rax),%eax
  8030b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030ba:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030bf:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8030c6:	00 00 00 
  8030c9:	89 c7                	mov    %eax,%edi
  8030cb:	48 b8 41 3e 80 00 00 	movabs $0x803e41,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8030d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8030dc:	be 00 00 00 00       	mov    $0x0,%esi
  8030e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e6:	48 b8 3b 3d 80 00 00 	movabs $0x803d3b,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
}
  8030f2:	c9                   	leaveq 
  8030f3:	c3                   	retq   

00000000008030f4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8030f4:	55                   	push   %rbp
  8030f5:	48 89 e5             	mov    %rsp,%rbp
  8030f8:	48 83 ec 30          	sub    $0x30,%rsp
  8030fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803103:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803107:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80310e:	00 00 00 
  803111:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803114:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803116:	bf 01 00 00 00       	mov    $0x1,%edi
  80311b:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
  803127:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312e:	78 3e                	js     80316e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803130:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803137:	00 00 00 
  80313a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80313e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803142:	8b 40 10             	mov    0x10(%rax),%eax
  803145:	89 c2                	mov    %eax,%edx
  803147:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80314b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314f:	48 89 ce             	mov    %rcx,%rsi
  803152:	48 89 c7             	mov    %rax,%rdi
  803155:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803165:	8b 50 10             	mov    0x10(%rax),%edx
  803168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80316e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803171:	c9                   	leaveq 
  803172:	c3                   	retq   

0000000000803173 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803173:	55                   	push   %rbp
  803174:	48 89 e5             	mov    %rsp,%rbp
  803177:	48 83 ec 10          	sub    $0x10,%rsp
  80317b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80317e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803182:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803185:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80318c:	00 00 00 
  80318f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803192:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803194:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319b:	48 89 c6             	mov    %rax,%rsi
  80319e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8031a5:	00 00 00 
  8031a8:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8031b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bb:	00 00 00 
  8031be:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031c1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8031c4:	bf 02 00 00 00       	mov    $0x2,%edi
  8031c9:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  8031d0:	00 00 00 
  8031d3:	ff d0                	callq  *%rax
}
  8031d5:	c9                   	leaveq 
  8031d6:	c3                   	retq   

00000000008031d7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8031d7:	55                   	push   %rbp
  8031d8:	48 89 e5             	mov    %rsp,%rbp
  8031db:	48 83 ec 10          	sub    $0x10,%rsp
  8031df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8031e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ec:	00 00 00 
  8031ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031f2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8031f4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031fb:	00 00 00 
  8031fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803201:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803204:	bf 03 00 00 00       	mov    $0x3,%edi
  803209:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  803210:	00 00 00 
  803213:	ff d0                	callq  *%rax
}
  803215:	c9                   	leaveq 
  803216:	c3                   	retq   

0000000000803217 <nsipc_close>:

int
nsipc_close(int s)
{
  803217:	55                   	push   %rbp
  803218:	48 89 e5             	mov    %rsp,%rbp
  80321b:	48 83 ec 10          	sub    $0x10,%rsp
  80321f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803222:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803229:	00 00 00 
  80322c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80322f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803231:	bf 04 00 00 00       	mov    $0x4,%edi
  803236:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
}
  803242:	c9                   	leaveq 
  803243:	c3                   	retq   

0000000000803244 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803244:	55                   	push   %rbp
  803245:	48 89 e5             	mov    %rsp,%rbp
  803248:	48 83 ec 10          	sub    $0x10,%rsp
  80324c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80324f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803253:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803256:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325d:	00 00 00 
  803260:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803263:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803265:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326c:	48 89 c6             	mov    %rax,%rsi
  80326f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803276:	00 00 00 
  803279:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803285:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328c:	00 00 00 
  80328f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803292:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803295:	bf 05 00 00 00       	mov    $0x5,%edi
  80329a:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
}
  8032a6:	c9                   	leaveq 
  8032a7:	c3                   	retq   

00000000008032a8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8032a8:	55                   	push   %rbp
  8032a9:	48 89 e5             	mov    %rsp,%rbp
  8032ac:	48 83 ec 10          	sub    $0x10,%rsp
  8032b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032b3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8032b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032bd:	00 00 00 
  8032c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032c3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8032c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032cc:	00 00 00 
  8032cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032d2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8032d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8032da:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
}
  8032e6:	c9                   	leaveq 
  8032e7:	c3                   	retq   

00000000008032e8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8032e8:	55                   	push   %rbp
  8032e9:	48 89 e5             	mov    %rsp,%rbp
  8032ec:	48 83 ec 30          	sub    $0x30,%rsp
  8032f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032f7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8032fa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8032fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803304:	00 00 00 
  803307:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80330a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80330c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803313:	00 00 00 
  803316:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803319:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80331c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803323:	00 00 00 
  803326:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803329:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80332c:	bf 07 00 00 00       	mov    $0x7,%edi
  803331:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  803338:	00 00 00 
  80333b:	ff d0                	callq  *%rax
  80333d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803344:	78 69                	js     8033af <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803346:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80334d:	7f 08                	jg     803357 <nsipc_recv+0x6f>
  80334f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803352:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803355:	7e 35                	jle    80338c <nsipc_recv+0xa4>
  803357:	48 b9 37 46 80 00 00 	movabs $0x804637,%rcx
  80335e:	00 00 00 
  803361:	48 ba 4c 46 80 00 00 	movabs $0x80464c,%rdx
  803368:	00 00 00 
  80336b:	be 61 00 00 00       	mov    $0x61,%esi
  803370:	48 bf 61 46 80 00 00 	movabs $0x804661,%rdi
  803377:	00 00 00 
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  803386:	00 00 00 
  803389:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80338c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338f:	48 63 d0             	movslq %eax,%rdx
  803392:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803396:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80339d:	00 00 00 
  8033a0:	48 89 c7             	mov    %rax,%rdi
  8033a3:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
	}

	return r;
  8033af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b2:	c9                   	leaveq 
  8033b3:	c3                   	retq   

00000000008033b4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8033b4:	55                   	push   %rbp
  8033b5:	48 89 e5             	mov    %rsp,%rbp
  8033b8:	48 83 ec 20          	sub    $0x20,%rsp
  8033bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033c3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8033c6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8033c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033d0:	00 00 00 
  8033d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d6:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8033d8:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8033df:	7e 35                	jle    803416 <nsipc_send+0x62>
  8033e1:	48 b9 6d 46 80 00 00 	movabs $0x80466d,%rcx
  8033e8:	00 00 00 
  8033eb:	48 ba 4c 46 80 00 00 	movabs $0x80464c,%rdx
  8033f2:	00 00 00 
  8033f5:	be 6c 00 00 00       	mov    $0x6c,%esi
  8033fa:	48 bf 61 46 80 00 00 	movabs $0x804661,%rdi
  803401:	00 00 00 
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
  803409:	49 b8 5b 02 80 00 00 	movabs $0x80025b,%r8
  803410:	00 00 00 
  803413:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803416:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803419:	48 63 d0             	movslq %eax,%rdx
  80341c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803420:	48 89 c6             	mov    %rax,%rsi
  803423:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80342a:	00 00 00 
  80342d:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803439:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803440:	00 00 00 
  803443:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803446:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803449:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803450:	00 00 00 
  803453:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803456:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803459:	bf 08 00 00 00       	mov    $0x8,%edi
  80345e:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  803465:	00 00 00 
  803468:	ff d0                	callq  *%rax
}
  80346a:	c9                   	leaveq 
  80346b:	c3                   	retq   

000000000080346c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80346c:	55                   	push   %rbp
  80346d:	48 89 e5             	mov    %rsp,%rbp
  803470:	48 83 ec 10          	sub    $0x10,%rsp
  803474:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803477:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80347a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80347d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803484:	00 00 00 
  803487:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80348a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80348c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803493:	00 00 00 
  803496:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803499:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80349c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a3:	00 00 00 
  8034a6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8034a9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8034ac:	bf 09 00 00 00       	mov    $0x9,%edi
  8034b1:	48 b8 73 30 80 00 00 	movabs $0x803073,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
}
  8034bd:	c9                   	leaveq 
  8034be:	c3                   	retq   

00000000008034bf <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034bf:	55                   	push   %rbp
  8034c0:	48 89 e5             	mov    %rsp,%rbp
  8034c3:	53                   	push   %rbx
  8034c4:	48 83 ec 38          	sub    $0x38,%rsp
  8034c8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034cc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034d0:	48 89 c7             	mov    %rax,%rdi
  8034d3:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e6:	0f 88 bf 01 00 00    	js     8036ab <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f0:	ba 07 04 00 00       	mov    $0x407,%edx
  8034f5:	48 89 c6             	mov    %rax,%rsi
  8034f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8034fd:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
  803509:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80350c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803510:	0f 88 95 01 00 00    	js     8036ab <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803516:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80351a:	48 89 c7             	mov    %rax,%rdi
  80351d:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
  803529:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80352c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803530:	0f 88 5d 01 00 00    	js     803693 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80353a:	ba 07 04 00 00       	mov    $0x407,%edx
  80353f:	48 89 c6             	mov    %rax,%rsi
  803542:	bf 00 00 00 00       	mov    $0x0,%edi
  803547:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
  803553:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803556:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80355a:	0f 88 33 01 00 00    	js     803693 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803564:	48 89 c7             	mov    %rax,%rdi
  803567:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803577:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357b:	ba 07 04 00 00       	mov    $0x407,%edx
  803580:	48 89 c6             	mov    %rax,%rsi
  803583:	bf 00 00 00 00       	mov    $0x0,%edi
  803588:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
  803594:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803597:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80359b:	79 05                	jns    8035a2 <pipe+0xe3>
		goto err2;
  80359d:	e9 d9 00 00 00       	jmpq   80367b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a6:	48 89 c7             	mov    %rax,%rdi
  8035a9:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8035b0:	00 00 00 
  8035b3:	ff d0                	callq  *%rax
  8035b5:	48 89 c2             	mov    %rax,%rdx
  8035b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035bc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035c2:	48 89 d1             	mov    %rdx,%rcx
  8035c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ca:	48 89 c6             	mov    %rax,%rsi
  8035cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d2:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
  8035de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035e5:	79 1b                	jns    803602 <pipe+0x143>
		goto err3;
  8035e7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ec:	48 89 c6             	mov    %rax,%rsi
  8035ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f4:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
  803600:	eb 79                	jmp    80367b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803606:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80360d:	00 00 00 
  803610:	8b 12                	mov    (%rdx),%edx
  803612:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803618:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80361f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803623:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80362a:	00 00 00 
  80362d:	8b 12                	mov    (%rdx),%edx
  80362f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803631:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803635:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80363c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803640:	48 89 c7             	mov    %rax,%rdi
  803643:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  80364a:	00 00 00 
  80364d:	ff d0                	callq  *%rax
  80364f:	89 c2                	mov    %eax,%edx
  803651:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803655:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803657:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80365b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80365f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803663:	48 89 c7             	mov    %rax,%rdi
  803666:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  80366d:	00 00 00 
  803670:	ff d0                	callq  *%rax
  803672:	89 03                	mov    %eax,(%rbx)
	return 0;
  803674:	b8 00 00 00 00       	mov    $0x0,%eax
  803679:	eb 33                	jmp    8036ae <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80367b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367f:	48 89 c6             	mov    %rax,%rsi
  803682:	bf 00 00 00 00       	mov    $0x0,%edi
  803687:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803697:	48 89 c6             	mov    %rax,%rsi
  80369a:	bf 00 00 00 00       	mov    $0x0,%edi
  80369f:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  8036a6:	00 00 00 
  8036a9:	ff d0                	callq  *%rax
err:
	return r;
  8036ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8036ae:	48 83 c4 38          	add    $0x38,%rsp
  8036b2:	5b                   	pop    %rbx
  8036b3:	5d                   	pop    %rbp
  8036b4:	c3                   	retq   

00000000008036b5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036b5:	55                   	push   %rbp
  8036b6:	48 89 e5             	mov    %rsp,%rbp
  8036b9:	53                   	push   %rbx
  8036ba:	48 83 ec 28          	sub    $0x28,%rsp
  8036be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036c6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036cd:	00 00 00 
  8036d0:	48 8b 00             	mov    (%rax),%rax
  8036d3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e0:	48 89 c7             	mov    %rax,%rdi
  8036e3:	48 b8 25 3f 80 00 00 	movabs $0x803f25,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
  8036ef:	89 c3                	mov    %eax,%ebx
  8036f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f5:	48 89 c7             	mov    %rax,%rdi
  8036f8:	48 b8 25 3f 80 00 00 	movabs $0x803f25,%rax
  8036ff:	00 00 00 
  803702:	ff d0                	callq  *%rax
  803704:	39 c3                	cmp    %eax,%ebx
  803706:	0f 94 c0             	sete   %al
  803709:	0f b6 c0             	movzbl %al,%eax
  80370c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80370f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803716:	00 00 00 
  803719:	48 8b 00             	mov    (%rax),%rax
  80371c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803722:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803725:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803728:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80372b:	75 05                	jne    803732 <_pipeisclosed+0x7d>
			return ret;
  80372d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803730:	eb 4f                	jmp    803781 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803732:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803735:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803738:	74 42                	je     80377c <_pipeisclosed+0xc7>
  80373a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80373e:	75 3c                	jne    80377c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803740:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803747:	00 00 00 
  80374a:	48 8b 00             	mov    (%rax),%rax
  80374d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803753:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803756:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803759:	89 c6                	mov    %eax,%esi
  80375b:	48 bf 7e 46 80 00 00 	movabs $0x80467e,%rdi
  803762:	00 00 00 
  803765:	b8 00 00 00 00       	mov    $0x0,%eax
  80376a:	49 b8 94 04 80 00 00 	movabs $0x800494,%r8
  803771:	00 00 00 
  803774:	41 ff d0             	callq  *%r8
	}
  803777:	e9 4a ff ff ff       	jmpq   8036c6 <_pipeisclosed+0x11>
  80377c:	e9 45 ff ff ff       	jmpq   8036c6 <_pipeisclosed+0x11>
}
  803781:	48 83 c4 28          	add    $0x28,%rsp
  803785:	5b                   	pop    %rbx
  803786:	5d                   	pop    %rbp
  803787:	c3                   	retq   

0000000000803788 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803788:	55                   	push   %rbp
  803789:	48 89 e5             	mov    %rsp,%rbp
  80378c:	48 83 ec 30          	sub    $0x30,%rsp
  803790:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803793:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803797:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80379a:	48 89 d6             	mov    %rdx,%rsi
  80379d:	89 c7                	mov    %eax,%edi
  80379f:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037b2:	79 05                	jns    8037b9 <pipeisclosed+0x31>
		return r;
  8037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b7:	eb 31                	jmp    8037ea <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bd:	48 89 c7             	mov    %rax,%rdi
  8037c0:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
  8037cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037d8:	48 89 d6             	mov    %rdx,%rsi
  8037db:	48 89 c7             	mov    %rax,%rdi
  8037de:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
}
  8037ea:	c9                   	leaveq 
  8037eb:	c3                   	retq   

00000000008037ec <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037ec:	55                   	push   %rbp
  8037ed:	48 89 e5             	mov    %rsp,%rbp
  8037f0:	48 83 ec 40          	sub    $0x40,%rsp
  8037f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803817:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80381b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80381f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803826:	00 
  803827:	e9 92 00 00 00       	jmpq   8038be <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80382c:	eb 41                	jmp    80386f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80382e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803833:	74 09                	je     80383e <devpipe_read+0x52>
				return i;
  803835:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803839:	e9 92 00 00 00       	jmpq   8038d0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80383e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803846:	48 89 d6             	mov    %rdx,%rsi
  803849:	48 89 c7             	mov    %rax,%rdi
  80384c:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 07                	je     803863 <devpipe_read+0x77>
				return 0;
  80385c:	b8 00 00 00 00       	mov    $0x0,%eax
  803861:	eb 6d                	jmp    8038d0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803863:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80386f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803873:	8b 10                	mov    (%rax),%edx
  803875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803879:	8b 40 04             	mov    0x4(%rax),%eax
  80387c:	39 c2                	cmp    %eax,%edx
  80387e:	74 ae                	je     80382e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803888:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80388c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803890:	8b 00                	mov    (%rax),%eax
  803892:	99                   	cltd   
  803893:	c1 ea 1b             	shr    $0x1b,%edx
  803896:	01 d0                	add    %edx,%eax
  803898:	83 e0 1f             	and    $0x1f,%eax
  80389b:	29 d0                	sub    %edx,%eax
  80389d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038a1:	48 98                	cltq   
  8038a3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8038a8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8038aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ae:	8b 00                	mov    (%rax),%eax
  8038b0:	8d 50 01             	lea    0x1(%rax),%edx
  8038b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038c6:	0f 82 60 ff ff ff    	jb     80382c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038d0:	c9                   	leaveq 
  8038d1:	c3                   	retq   

00000000008038d2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038d2:	55                   	push   %rbp
  8038d3:	48 89 e5             	mov    %rsp,%rbp
  8038d6:	48 83 ec 40          	sub    $0x40,%rsp
  8038da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ea:	48 89 c7             	mov    %rax,%rdi
  8038ed:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
  8038f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803901:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803905:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80390c:	00 
  80390d:	e9 8e 00 00 00       	jmpq   8039a0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803912:	eb 31                	jmp    803945 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803914:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80391c:	48 89 d6             	mov    %rdx,%rsi
  80391f:	48 89 c7             	mov    %rax,%rdi
  803922:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	85 c0                	test   %eax,%eax
  803930:	74 07                	je     803939 <devpipe_write+0x67>
				return 0;
  803932:	b8 00 00 00 00       	mov    $0x0,%eax
  803937:	eb 79                	jmp    8039b2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803939:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803949:	8b 40 04             	mov    0x4(%rax),%eax
  80394c:	48 63 d0             	movslq %eax,%rdx
  80394f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803953:	8b 00                	mov    (%rax),%eax
  803955:	48 98                	cltq   
  803957:	48 83 c0 20          	add    $0x20,%rax
  80395b:	48 39 c2             	cmp    %rax,%rdx
  80395e:	73 b4                	jae    803914 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803964:	8b 40 04             	mov    0x4(%rax),%eax
  803967:	99                   	cltd   
  803968:	c1 ea 1b             	shr    $0x1b,%edx
  80396b:	01 d0                	add    %edx,%eax
  80396d:	83 e0 1f             	and    $0x1f,%eax
  803970:	29 d0                	sub    %edx,%eax
  803972:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803976:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80397a:	48 01 ca             	add    %rcx,%rdx
  80397d:	0f b6 0a             	movzbl (%rdx),%ecx
  803980:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803984:	48 98                	cltq   
  803986:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80398a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398e:	8b 40 04             	mov    0x4(%rax),%eax
  803991:	8d 50 01             	lea    0x1(%rax),%edx
  803994:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803998:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80399b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8039a8:	0f 82 64 ff ff ff    	jb     803912 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039b2:	c9                   	leaveq 
  8039b3:	c3                   	retq   

00000000008039b4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039b4:	55                   	push   %rbp
  8039b5:	48 89 e5             	mov    %rsp,%rbp
  8039b8:	48 83 ec 20          	sub    $0x20,%rsp
  8039bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c8:	48 89 c7             	mov    %rax,%rdi
  8039cb:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039df:	48 be 91 46 80 00 00 	movabs $0x804691,%rsi
  8039e6:	00 00 00 
  8039e9:	48 89 c7             	mov    %rax,%rdi
  8039ec:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fc:	8b 50 04             	mov    0x4(%rax),%edx
  8039ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a03:	8b 00                	mov    (%rax),%eax
  803a05:	29 c2                	sub    %eax,%edx
  803a07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a0b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a15:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a1c:	00 00 00 
	stat->st_dev = &devpipe;
  803a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a23:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a2a:	00 00 00 
  803a2d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a39:	c9                   	leaveq 
  803a3a:	c3                   	retq   

0000000000803a3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a3b:	55                   	push   %rbp
  803a3c:	48 89 e5             	mov    %rsp,%rbp
  803a3f:	48 83 ec 10          	sub    $0x10,%rsp
  803a43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a4b:	48 89 c6             	mov    %rax,%rsi
  803a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a53:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a63:	48 89 c7             	mov    %rax,%rdi
  803a66:	48 b8 d2 1c 80 00 00 	movabs $0x801cd2,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	48 89 c6             	mov    %rax,%rsi
  803a75:	bf 00 00 00 00       	mov    $0x0,%edi
  803a7a:	48 b8 23 1a 80 00 00 	movabs $0x801a23,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
}
  803a86:	c9                   	leaveq 
  803a87:	c3                   	retq   

0000000000803a88 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a88:	55                   	push   %rbp
  803a89:	48 89 e5             	mov    %rsp,%rbp
  803a8c:	48 83 ec 20          	sub    $0x20,%rsp
  803a90:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a96:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a99:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a9d:	be 01 00 00 00       	mov    $0x1,%esi
  803aa2:	48 89 c7             	mov    %rax,%rdi
  803aa5:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
}
  803ab1:	c9                   	leaveq 
  803ab2:	c3                   	retq   

0000000000803ab3 <getchar>:

int
getchar(void)
{
  803ab3:	55                   	push   %rbp
  803ab4:	48 89 e5             	mov    %rsp,%rbp
  803ab7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803abb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803abf:	ba 01 00 00 00       	mov    $0x1,%edx
  803ac4:	48 89 c6             	mov    %rax,%rsi
  803ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  803acc:	48 b8 c7 21 80 00 00 	movabs $0x8021c7,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
  803ad8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803adb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803adf:	79 05                	jns    803ae6 <getchar+0x33>
		return r;
  803ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae4:	eb 14                	jmp    803afa <getchar+0x47>
	if (r < 1)
  803ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aea:	7f 07                	jg     803af3 <getchar+0x40>
		return -E_EOF;
  803aec:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803af1:	eb 07                	jmp    803afa <getchar+0x47>
	return c;
  803af3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803af7:	0f b6 c0             	movzbl %al,%eax
}
  803afa:	c9                   	leaveq 
  803afb:	c3                   	retq   

0000000000803afc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803afc:	55                   	push   %rbp
  803afd:	48 89 e5             	mov    %rsp,%rbp
  803b00:	48 83 ec 20          	sub    $0x20,%rsp
  803b04:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b07:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b0b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b0e:	48 89 d6             	mov    %rdx,%rsi
  803b11:	89 c7                	mov    %eax,%edi
  803b13:	48 b8 95 1d 80 00 00 	movabs $0x801d95,%rax
  803b1a:	00 00 00 
  803b1d:	ff d0                	callq  *%rax
  803b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b26:	79 05                	jns    803b2d <iscons+0x31>
		return r;
  803b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2b:	eb 1a                	jmp    803b47 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b31:	8b 10                	mov    (%rax),%edx
  803b33:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b3a:	00 00 00 
  803b3d:	8b 00                	mov    (%rax),%eax
  803b3f:	39 c2                	cmp    %eax,%edx
  803b41:	0f 94 c0             	sete   %al
  803b44:	0f b6 c0             	movzbl %al,%eax
}
  803b47:	c9                   	leaveq 
  803b48:	c3                   	retq   

0000000000803b49 <opencons>:

int
opencons(void)
{
  803b49:	55                   	push   %rbp
  803b4a:	48 89 e5             	mov    %rsp,%rbp
  803b4d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b51:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b55:	48 89 c7             	mov    %rax,%rdi
  803b58:	48 b8 fd 1c 80 00 00 	movabs $0x801cfd,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
  803b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6b:	79 05                	jns    803b72 <opencons+0x29>
		return r;
  803b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b70:	eb 5b                	jmp    803bcd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	ba 07 04 00 00       	mov    $0x407,%edx
  803b7b:	48 89 c6             	mov    %rax,%rsi
  803b7e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b83:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803b8a:	00 00 00 
  803b8d:	ff d0                	callq  *%rax
  803b8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b96:	79 05                	jns    803b9d <opencons+0x54>
		return r;
  803b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9b:	eb 30                	jmp    803bcd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803ba8:	00 00 00 
  803bab:	8b 12                	mov    (%rdx),%edx
  803bad:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbe:	48 89 c7             	mov    %rax,%rdi
  803bc1:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  803bc8:	00 00 00 
  803bcb:	ff d0                	callq  *%rax
}
  803bcd:	c9                   	leaveq 
  803bce:	c3                   	retq   

0000000000803bcf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bcf:	55                   	push   %rbp
  803bd0:	48 89 e5             	mov    %rsp,%rbp
  803bd3:	48 83 ec 30          	sub    $0x30,%rsp
  803bd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803be3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803be8:	75 07                	jne    803bf1 <devcons_read+0x22>
		return 0;
  803bea:	b8 00 00 00 00       	mov    $0x0,%eax
  803bef:	eb 4b                	jmp    803c3c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bf1:	eb 0c                	jmp    803bff <devcons_read+0x30>
		sys_yield();
  803bf3:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803bfa:	00 00 00 
  803bfd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bff:	48 b8 7a 18 80 00 00 	movabs $0x80187a,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
  803c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c12:	74 df                	je     803bf3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c18:	79 05                	jns    803c1f <devcons_read+0x50>
		return c;
  803c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1d:	eb 1d                	jmp    803c3c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c23:	75 07                	jne    803c2c <devcons_read+0x5d>
		return 0;
  803c25:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2a:	eb 10                	jmp    803c3c <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c2f:	89 c2                	mov    %eax,%edx
  803c31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c35:	88 10                	mov    %dl,(%rax)
	return 1;
  803c37:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c3c:	c9                   	leaveq 
  803c3d:	c3                   	retq   

0000000000803c3e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c3e:	55                   	push   %rbp
  803c3f:	48 89 e5             	mov    %rsp,%rbp
  803c42:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c49:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c50:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c57:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c65:	eb 76                	jmp    803cdd <devcons_write+0x9f>
		m = n - tot;
  803c67:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c6e:	89 c2                	mov    %eax,%edx
  803c70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c73:	29 c2                	sub    %eax,%edx
  803c75:	89 d0                	mov    %edx,%eax
  803c77:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c7d:	83 f8 7f             	cmp    $0x7f,%eax
  803c80:	76 07                	jbe    803c89 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c82:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c8c:	48 63 d0             	movslq %eax,%rdx
  803c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c92:	48 63 c8             	movslq %eax,%rcx
  803c95:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c9c:	48 01 c1             	add    %rax,%rcx
  803c9f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ca6:	48 89 ce             	mov    %rcx,%rsi
  803ca9:	48 89 c7             	mov    %rax,%rdi
  803cac:	48 b8 6d 13 80 00 00 	movabs $0x80136d,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803cb8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cbb:	48 63 d0             	movslq %eax,%rdx
  803cbe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cc5:	48 89 d6             	mov    %rdx,%rsi
  803cc8:	48 89 c7             	mov    %rax,%rdi
  803ccb:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cda:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce0:	48 98                	cltq   
  803ce2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ce9:	0f 82 78 ff ff ff    	jb     803c67 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cf2:	c9                   	leaveq 
  803cf3:	c3                   	retq   

0000000000803cf4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cf4:	55                   	push   %rbp
  803cf5:	48 89 e5             	mov    %rsp,%rbp
  803cf8:	48 83 ec 08          	sub    $0x8,%rsp
  803cfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d05:	c9                   	leaveq 
  803d06:	c3                   	retq   

0000000000803d07 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 10          	sub    $0x10,%rsp
  803d0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1b:	48 be 9d 46 80 00 00 	movabs $0x80469d,%rsi
  803d22:	00 00 00 
  803d25:	48 89 c7             	mov    %rax,%rdi
  803d28:	48 b8 49 10 80 00 00 	movabs $0x801049,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
	return 0;
  803d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d39:	c9                   	leaveq 
  803d3a:	c3                   	retq   

0000000000803d3b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d3b:	55                   	push   %rbp
  803d3c:	48 89 e5             	mov    %rsp,%rbp
  803d3f:	48 83 ec 30          	sub    $0x30,%rsp
  803d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803d4f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d56:	00 00 00 
  803d59:	48 8b 00             	mov    (%rax),%rax
  803d5c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d62:	85 c0                	test   %eax,%eax
  803d64:	75 3c                	jne    803da2 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d66:	48 b8 fc 18 80 00 00 	movabs $0x8018fc,%rax
  803d6d:	00 00 00 
  803d70:	ff d0                	callq  *%rax
  803d72:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d77:	48 63 d0             	movslq %eax,%rdx
  803d7a:	48 89 d0             	mov    %rdx,%rax
  803d7d:	48 c1 e0 03          	shl    $0x3,%rax
  803d81:	48 01 d0             	add    %rdx,%rax
  803d84:	48 c1 e0 05          	shl    $0x5,%rax
  803d88:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d8f:	00 00 00 
  803d92:	48 01 c2             	add    %rax,%rdx
  803d95:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d9c:	00 00 00 
  803d9f:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803da2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803da7:	75 0e                	jne    803db7 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803da9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803db0:	00 00 00 
  803db3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803db7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbb:	48 89 c7             	mov    %rax,%rdi
  803dbe:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  803dc5:	00 00 00 
  803dc8:	ff d0                	callq  *%rax
  803dca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803dcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd1:	79 19                	jns    803dec <ipc_recv+0xb1>
		*from_env_store = 0;
  803dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803ddd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dea:	eb 53                	jmp    803e3f <ipc_recv+0x104>
	}
	if(from_env_store)
  803dec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803df1:	74 19                	je     803e0c <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803df3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dfa:	00 00 00 
  803dfd:	48 8b 00             	mov    (%rax),%rax
  803e00:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e0a:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803e0c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e11:	74 19                	je     803e2c <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803e13:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e1a:	00 00 00 
  803e1d:	48 8b 00             	mov    (%rax),%rax
  803e20:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e2a:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803e2c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e33:	00 00 00 
  803e36:	48 8b 00             	mov    (%rax),%rax
  803e39:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803e3f:	c9                   	leaveq 
  803e40:	c3                   	retq   

0000000000803e41 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e41:	55                   	push   %rbp
  803e42:	48 89 e5             	mov    %rsp,%rbp
  803e45:	48 83 ec 30          	sub    $0x30,%rsp
  803e49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e4c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e4f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e53:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803e56:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e5b:	75 0e                	jne    803e6b <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e5d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e64:	00 00 00 
  803e67:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e6b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e6e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e71:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e78:	89 c7                	mov    %eax,%edi
  803e7a:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  803e81:	00 00 00 
  803e84:	ff d0                	callq  *%rax
  803e86:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e89:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e8d:	75 0c                	jne    803e9b <ipc_send+0x5a>
			sys_yield();
  803e8f:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  803e96:	00 00 00 
  803e99:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e9b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e9f:	74 ca                	je     803e6b <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803ea1:	c9                   	leaveq 
  803ea2:	c3                   	retq   

0000000000803ea3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ea3:	55                   	push   %rbp
  803ea4:	48 89 e5             	mov    %rsp,%rbp
  803ea7:	48 83 ec 14          	sub    $0x14,%rsp
  803eab:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803eae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803eb5:	eb 5e                	jmp    803f15 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803eb7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ebe:	00 00 00 
  803ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec4:	48 63 d0             	movslq %eax,%rdx
  803ec7:	48 89 d0             	mov    %rdx,%rax
  803eca:	48 c1 e0 03          	shl    $0x3,%rax
  803ece:	48 01 d0             	add    %rdx,%rax
  803ed1:	48 c1 e0 05          	shl    $0x5,%rax
  803ed5:	48 01 c8             	add    %rcx,%rax
  803ed8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ede:	8b 00                	mov    (%rax),%eax
  803ee0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ee3:	75 2c                	jne    803f11 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803ee5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803eec:	00 00 00 
  803eef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef2:	48 63 d0             	movslq %eax,%rdx
  803ef5:	48 89 d0             	mov    %rdx,%rax
  803ef8:	48 c1 e0 03          	shl    $0x3,%rax
  803efc:	48 01 d0             	add    %rdx,%rax
  803eff:	48 c1 e0 05          	shl    $0x5,%rax
  803f03:	48 01 c8             	add    %rcx,%rax
  803f06:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f0c:	8b 40 08             	mov    0x8(%rax),%eax
  803f0f:	eb 12                	jmp    803f23 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f11:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f15:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f1c:	7e 99                	jle    803eb7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f23:	c9                   	leaveq 
  803f24:	c3                   	retq   

0000000000803f25 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f25:	55                   	push   %rbp
  803f26:	48 89 e5             	mov    %rsp,%rbp
  803f29:	48 83 ec 18          	sub    $0x18,%rsp
  803f2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f35:	48 c1 e8 15          	shr    $0x15,%rax
  803f39:	48 89 c2             	mov    %rax,%rdx
  803f3c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f43:	01 00 00 
  803f46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f4a:	83 e0 01             	and    $0x1,%eax
  803f4d:	48 85 c0             	test   %rax,%rax
  803f50:	75 07                	jne    803f59 <pageref+0x34>
		return 0;
  803f52:	b8 00 00 00 00       	mov    $0x0,%eax
  803f57:	eb 53                	jmp    803fac <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f5d:	48 c1 e8 0c          	shr    $0xc,%rax
  803f61:	48 89 c2             	mov    %rax,%rdx
  803f64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f6b:	01 00 00 
  803f6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f7a:	83 e0 01             	and    $0x1,%eax
  803f7d:	48 85 c0             	test   %rax,%rax
  803f80:	75 07                	jne    803f89 <pageref+0x64>
		return 0;
  803f82:	b8 00 00 00 00       	mov    $0x0,%eax
  803f87:	eb 23                	jmp    803fac <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8d:	48 c1 e8 0c          	shr    $0xc,%rax
  803f91:	48 89 c2             	mov    %rax,%rdx
  803f94:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f9b:	00 00 00 
  803f9e:	48 c1 e2 04          	shl    $0x4,%rdx
  803fa2:	48 01 d0             	add    %rdx,%rax
  803fa5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fa9:	0f b7 c0             	movzwl %ax,%eax
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   
