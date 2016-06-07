
obj/user/icode.debug:     file format elf64-x86-64


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
  80003c:	e8 21 02 00 00       	callq  800262 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#define MOTD "/motd"

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800063:	00 00 00 
  800066:	48 bb c0 4b 80 00 00 	movabs $0x804bc0,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf c6 4b 80 00 00 	movabs $0x804bc6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf d5 4b 80 00 00 	movabs $0x804bd5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf e8 4b 80 00 00 	movabs $0x804be8,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba ee 4b 80 00 00 	movabs $0x804bee,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 04 4c 80 00 00 	movabs $0x804c04,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 11 4c 80 00 00 	movabs $0x804c11,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800118:	eb 3a                	jmp    800154 <umain+0x111>
		cprintf("Writing MOTD\n");
  80011a:	48 bf 24 4c 80 00 00 	movabs $0x804c24,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800135:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800138:	48 63 d0             	movslq %eax,%rdx
  80013b:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800142:	48 89 d6             	mov    %rdx,%rsi
  800145:	48 89 c7             	mov    %rax,%rdi
  800148:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open(MOTD, O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800154:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  80015b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80015e:	ba 00 02 00 00       	mov    $0x200,%edx
  800163:	48 89 ce             	mov    %rcx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800177:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80017b:	7f 9d                	jg     80011a <umain+0xd7>
		cprintf("Writing MOTD\n");
		sys_cputs(buf, n);
	}

	cprintf("icode: close /motd\n");
  80017d:	48 bf 32 4c 80 00 00 	movabs $0x804c32,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  800193:	00 00 00 
  800196:	ff d2                	callq  *%rdx
	close(fd);
  800198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80019b:	89 c7                	mov    %eax,%edi
  80019d:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8001a4:	00 00 00 
  8001a7:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a9:	48 bf 46 4c 80 00 00 	movabs $0x804c46,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ca:	48 b9 5f 4c 80 00 00 	movabs $0x804c5f,%rcx
  8001d1:	00 00 00 
  8001d4:	48 ba 68 4c 80 00 00 	movabs $0x804c68,%rdx
  8001db:	00 00 00 
  8001de:	48 be 71 4c 80 00 00 	movabs $0x804c71,%rsi
  8001e5:	00 00 00 
  8001e8:	48 bf 76 4c 80 00 00 	movabs $0x804c76,%rdi
  8001ef:	00 00 00 
  8001f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f7:	49 b9 c3 30 80 00 00 	movabs $0x8030c3,%r9
  8001fe:	00 00 00 
  800201:	41 ff d1             	callq  *%r9
  800204:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800207:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("icode: spawn /sbin/init: %e", r);
  80020d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 81 4c 80 00 00 	movabs $0x804c81,%rdx
  800219:	00 00 00 
  80021c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800221:	48 bf 04 4c 80 00 00 	movabs $0x804c04,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023d:	48 bf 9d 4c 80 00 00 	movabs $0x804c9d,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
}
  800258:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  80025f:	5b                   	pop    %rbx
  800260:	5d                   	pop    %rbp
  800261:	c3                   	retq   

0000000000800262 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800262:	55                   	push   %rbp
  800263:	48 89 e5             	mov    %rsp,%rbp
  800266:	48 83 ec 10          	sub    $0x10,%rsp
  80026a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80026d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800271:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
  80027d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800282:	48 63 d0             	movslq %eax,%rdx
  800285:	48 89 d0             	mov    %rdx,%rax
  800288:	48 c1 e0 03          	shl    $0x3,%rax
  80028c:	48 01 d0             	add    %rdx,%rax
  80028f:	48 c1 e0 05          	shl    $0x5,%rax
  800293:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80029a:	00 00 00 
  80029d:	48 01 c2             	add    %rax,%rdx
  8002a0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002a7:	00 00 00 
  8002aa:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002b1:	7e 14                	jle    8002c7 <libmain+0x65>
		binaryname = argv[0];
  8002b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b7:	48 8b 10             	mov    (%rax),%rdx
  8002ba:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002c1:	00 00 00 
  8002c4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ce:	48 89 d6             	mov    %rdx,%rsi
  8002d1:	89 c7                	mov    %eax,%edi
  8002d3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002da:	00 00 00 
  8002dd:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8002df:	48 b8 ed 02 80 00 00 	movabs $0x8002ed,%rax
  8002e6:	00 00 00 
  8002e9:	ff d0                	callq  *%rax
}
  8002eb:	c9                   	leaveq 
  8002ec:	c3                   	retq   

00000000008002ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002ed:	55                   	push   %rbp
  8002ee:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002f1:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800302:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax

}
  80030e:	5d                   	pop    %rbp
  80030f:	c3                   	retq   

0000000000800310 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800310:	55                   	push   %rbp
  800311:	48 89 e5             	mov    %rsp,%rbp
  800314:	53                   	push   %rbx
  800315:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80031c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800323:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800329:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800330:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800337:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80033e:	84 c0                	test   %al,%al
  800340:	74 23                	je     800365 <_panic+0x55>
  800342:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800349:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80034d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800351:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800355:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800359:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80035d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800361:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800365:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80036c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800373:	00 00 00 
  800376:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80037d:	00 00 00 
  800380:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800384:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80038b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800392:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800399:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003a0:	00 00 00 
  8003a3:	48 8b 18             	mov    (%rax),%rbx
  8003a6:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  8003ad:	00 00 00 
  8003b0:	ff d0                	callq  *%rax
  8003b2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003bf:	41 89 c8             	mov    %ecx,%r8d
  8003c2:	48 89 d1             	mov    %rdx,%rcx
  8003c5:	48 89 da             	mov    %rbx,%rdx
  8003c8:	89 c6                	mov    %eax,%esi
  8003ca:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  8003d1:	00 00 00 
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d9:	49 b9 49 05 80 00 00 	movabs $0x800549,%r9
  8003e0:	00 00 00 
  8003e3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003e6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f4:	48 89 d6             	mov    %rdx,%rsi
  8003f7:	48 89 c7             	mov    %rax,%rdi
  8003fa:	48 b8 9d 04 80 00 00 	movabs $0x80049d,%rax
  800401:	00 00 00 
  800404:	ff d0                	callq  *%rax
	cprintf("\n");
  800406:	48 bf db 4c 80 00 00 	movabs $0x804cdb,%rdi
  80040d:	00 00 00 
  800410:	b8 00 00 00 00       	mov    $0x0,%eax
  800415:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  80041c:	00 00 00 
  80041f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800421:	cc                   	int3   
  800422:	eb fd                	jmp    800421 <_panic+0x111>

0000000000800424 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 10          	sub    $0x10,%rsp
  80042c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80042f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800437:	8b 00                	mov    (%rax),%eax
  800439:	8d 48 01             	lea    0x1(%rax),%ecx
  80043c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800440:	89 0a                	mov    %ecx,(%rdx)
  800442:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800445:	89 d1                	mov    %edx,%ecx
  800447:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80044b:	48 98                	cltq   
  80044d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800455:	8b 00                	mov    (%rax),%eax
  800457:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045c:	75 2c                	jne    80048a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80045e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800462:	8b 00                	mov    (%rax),%eax
  800464:	48 98                	cltq   
  800466:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80046a:	48 83 c2 08          	add    $0x8,%rdx
  80046e:	48 89 c6             	mov    %rax,%rsi
  800471:	48 89 d7             	mov    %rdx,%rdi
  800474:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
        b->idx = 0;
  800480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800484:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80048a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80048e:	8b 40 04             	mov    0x4(%rax),%eax
  800491:	8d 50 01             	lea    0x1(%rax),%edx
  800494:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800498:	89 50 04             	mov    %edx,0x4(%rax)
}
  80049b:	c9                   	leaveq 
  80049c:	c3                   	retq   

000000000080049d <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80049d:	55                   	push   %rbp
  80049e:	48 89 e5             	mov    %rsp,%rbp
  8004a1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004a8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004af:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004b6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004bd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004c4:	48 8b 0a             	mov    (%rdx),%rcx
  8004c7:	48 89 08             	mov    %rcx,(%rax)
  8004ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004e1:	00 00 00 
    b.cnt = 0;
  8004e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004eb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004ee:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004f5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004fc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800503:	48 89 c6             	mov    %rax,%rsi
  800506:	48 bf 24 04 80 00 00 	movabs $0x800424,%rdi
  80050d:	00 00 00 
  800510:	48 b8 fc 08 80 00 00 	movabs $0x8008fc,%rax
  800517:	00 00 00 
  80051a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80051c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800522:	48 98                	cltq   
  800524:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80052b:	48 83 c2 08          	add    $0x8,%rdx
  80052f:	48 89 c6             	mov    %rax,%rsi
  800532:	48 89 d7             	mov    %rdx,%rdi
  800535:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  80053c:	00 00 00 
  80053f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800541:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800547:	c9                   	leaveq 
  800548:	c3                   	retq   

0000000000800549 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800549:	55                   	push   %rbp
  80054a:	48 89 e5             	mov    %rsp,%rbp
  80054d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800554:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80055b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800562:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800569:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800570:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800577:	84 c0                	test   %al,%al
  800579:	74 20                	je     80059b <cprintf+0x52>
  80057b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80057f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800583:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800587:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80058b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80058f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800593:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800597:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80059b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005a2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005a9:	00 00 00 
  8005ac:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005b3:	00 00 00 
  8005b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005c1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005cf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005d6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005dd:	48 8b 0a             	mov    (%rdx),%rcx
  8005e0:	48 89 08             	mov    %rcx,(%rax)
  8005e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005f3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800601:	48 89 d6             	mov    %rdx,%rsi
  800604:	48 89 c7             	mov    %rax,%rdi
  800607:	48 b8 9d 04 80 00 00 	movabs $0x80049d,%rax
  80060e:	00 00 00 
  800611:	ff d0                	callq  *%rax
  800613:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800619:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80061f:	c9                   	leaveq 
  800620:	c3                   	retq   

0000000000800621 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800621:	55                   	push   %rbp
  800622:	48 89 e5             	mov    %rsp,%rbp
  800625:	53                   	push   %rbx
  800626:	48 83 ec 38          	sub    $0x38,%rsp
  80062a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80062e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800632:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800636:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800639:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80063d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800644:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800648:	77 3b                	ja     800685 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80064a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80064d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800651:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800658:	ba 00 00 00 00       	mov    $0x0,%edx
  80065d:	48 f7 f3             	div    %rbx
  800660:	48 89 c2             	mov    %rax,%rdx
  800663:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800666:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800669:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	41 89 f9             	mov    %edi,%r9d
  800674:	48 89 c7             	mov    %rax,%rdi
  800677:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  80067e:	00 00 00 
  800681:	ff d0                	callq  *%rax
  800683:	eb 1e                	jmp    8006a3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800685:	eb 12                	jmp    800699 <printnum+0x78>
			putch(padc, putdat);
  800687:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80068b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80068e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800692:	48 89 ce             	mov    %rcx,%rsi
  800695:	89 d7                	mov    %edx,%edi
  800697:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800699:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80069d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006a1:	7f e4                	jg     800687 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8006af:	48 f7 f1             	div    %rcx
  8006b2:	48 89 d0             	mov    %rdx,%rax
  8006b5:	48 ba d0 4e 80 00 00 	movabs $0x804ed0,%rdx
  8006bc:	00 00 00 
  8006bf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006c3:	0f be d0             	movsbl %al,%edx
  8006c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ce:	48 89 ce             	mov    %rcx,%rsi
  8006d1:	89 d7                	mov    %edx,%edi
  8006d3:	ff d0                	callq  *%rax
}
  8006d5:	48 83 c4 38          	add    $0x38,%rsp
  8006d9:	5b                   	pop    %rbx
  8006da:	5d                   	pop    %rbp
  8006db:	c3                   	retq   

00000000008006dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dc:	55                   	push   %rbp
  8006dd:	48 89 e5             	mov    %rsp,%rbp
  8006e0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006ef:	7e 52                	jle    800743 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	83 f8 30             	cmp    $0x30,%eax
  8006fa:	73 24                	jae    800720 <getuint+0x44>
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	8b 00                	mov    (%rax),%eax
  80070a:	89 c0                	mov    %eax,%eax
  80070c:	48 01 d0             	add    %rdx,%rax
  80070f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800713:	8b 12                	mov    (%rdx),%edx
  800715:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	89 0a                	mov    %ecx,(%rdx)
  80071e:	eb 17                	jmp    800737 <getuint+0x5b>
  800720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800724:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800728:	48 89 d0             	mov    %rdx,%rax
  80072b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800737:	48 8b 00             	mov    (%rax),%rax
  80073a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80073e:	e9 a3 00 00 00       	jmpq   8007e6 <getuint+0x10a>
	else if (lflag)
  800743:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800747:	74 4f                	je     800798 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	83 f8 30             	cmp    $0x30,%eax
  800752:	73 24                	jae    800778 <getuint+0x9c>
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	8b 00                	mov    (%rax),%eax
  800762:	89 c0                	mov    %eax,%eax
  800764:	48 01 d0             	add    %rdx,%rax
  800767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076b:	8b 12                	mov    (%rdx),%edx
  80076d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	89 0a                	mov    %ecx,(%rdx)
  800776:	eb 17                	jmp    80078f <getuint+0xb3>
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800780:	48 89 d0             	mov    %rdx,%rax
  800783:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800787:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80078f:	48 8b 00             	mov    (%rax),%rax
  800792:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800796:	eb 4e                	jmp    8007e6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	8b 00                	mov    (%rax),%eax
  80079e:	83 f8 30             	cmp    $0x30,%eax
  8007a1:	73 24                	jae    8007c7 <getuint+0xeb>
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	8b 00                	mov    (%rax),%eax
  8007b1:	89 c0                	mov    %eax,%eax
  8007b3:	48 01 d0             	add    %rdx,%rax
  8007b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ba:	8b 12                	mov    (%rdx),%edx
  8007bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c3:	89 0a                	mov    %ecx,(%rdx)
  8007c5:	eb 17                	jmp    8007de <getuint+0x102>
  8007c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cf:	48 89 d0             	mov    %rdx,%rax
  8007d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007de:	8b 00                	mov    (%rax),%eax
  8007e0:	89 c0                	mov    %eax,%eax
  8007e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ea:	c9                   	leaveq 
  8007eb:	c3                   	retq   

00000000008007ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ec:	55                   	push   %rbp
  8007ed:	48 89 e5             	mov    %rsp,%rbp
  8007f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ff:	7e 52                	jle    800853 <getint+0x67>
		x=va_arg(*ap, long long);
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	8b 00                	mov    (%rax),%eax
  800807:	83 f8 30             	cmp    $0x30,%eax
  80080a:	73 24                	jae    800830 <getint+0x44>
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	89 c0                	mov    %eax,%eax
  80081c:	48 01 d0             	add    %rdx,%rax
  80081f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800823:	8b 12                	mov    (%rdx),%edx
  800825:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800828:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082c:	89 0a                	mov    %ecx,(%rdx)
  80082e:	eb 17                	jmp    800847 <getint+0x5b>
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800838:	48 89 d0             	mov    %rdx,%rax
  80083b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800847:	48 8b 00             	mov    (%rax),%rax
  80084a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084e:	e9 a3 00 00 00       	jmpq   8008f6 <getint+0x10a>
	else if (lflag)
  800853:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800857:	74 4f                	je     8008a8 <getint+0xbc>
		x=va_arg(*ap, long);
  800859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085d:	8b 00                	mov    (%rax),%eax
  80085f:	83 f8 30             	cmp    $0x30,%eax
  800862:	73 24                	jae    800888 <getint+0x9c>
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	8b 00                	mov    (%rax),%eax
  800872:	89 c0                	mov    %eax,%eax
  800874:	48 01 d0             	add    %rdx,%rax
  800877:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087b:	8b 12                	mov    (%rdx),%edx
  80087d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800880:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800884:	89 0a                	mov    %ecx,(%rdx)
  800886:	eb 17                	jmp    80089f <getint+0xb3>
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800890:	48 89 d0             	mov    %rdx,%rax
  800893:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800897:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80089f:	48 8b 00             	mov    (%rax),%rax
  8008a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008a6:	eb 4e                	jmp    8008f6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	83 f8 30             	cmp    $0x30,%eax
  8008b1:	73 24                	jae    8008d7 <getint+0xeb>
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	89 c0                	mov    %eax,%eax
  8008c3:	48 01 d0             	add    %rdx,%rax
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	8b 12                	mov    (%rdx),%edx
  8008cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d3:	89 0a                	mov    %ecx,(%rdx)
  8008d5:	eb 17                	jmp    8008ee <getint+0x102>
  8008d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008df:	48 89 d0             	mov    %rdx,%rax
  8008e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ee:	8b 00                	mov    (%rax),%eax
  8008f0:	48 98                	cltq   
  8008f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008fa:	c9                   	leaveq 
  8008fb:	c3                   	retq   

00000000008008fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008fc:	55                   	push   %rbp
  8008fd:	48 89 e5             	mov    %rsp,%rbp
  800900:	41 54                	push   %r12
  800902:	53                   	push   %rbx
  800903:	48 83 ec 60          	sub    $0x60,%rsp
  800907:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80090b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80090f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800913:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800917:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80091b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80091f:	48 8b 0a             	mov    (%rdx),%rcx
  800922:	48 89 08             	mov    %rcx,(%rax)
  800925:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800929:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80092d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800931:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800935:	eb 17                	jmp    80094e <vprintfmt+0x52>
			if (ch == '\0')
  800937:	85 db                	test   %ebx,%ebx
  800939:	0f 84 cc 04 00 00    	je     800e0b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80093f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800943:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800947:	48 89 d6             	mov    %rdx,%rsi
  80094a:	89 df                	mov    %ebx,%edi
  80094c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800952:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800956:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095a:	0f b6 00             	movzbl (%rax),%eax
  80095d:	0f b6 d8             	movzbl %al,%ebx
  800960:	83 fb 25             	cmp    $0x25,%ebx
  800963:	75 d2                	jne    800937 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800965:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800969:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800970:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800977:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80097e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800985:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800989:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80098d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800991:	0f b6 00             	movzbl (%rax),%eax
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 34 04 00 00    	ja     800dd7 <vprintfmt+0x4db>
  8009a3:	89 c0                	mov    %eax,%eax
  8009a5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009ac:	00 
  8009ad:	48 b8 f8 4e 80 00 00 	movabs $0x804ef8,%rax
  8009b4:	00 00 00 
  8009b7:	48 01 d0             	add    %rdx,%rax
  8009ba:	48 8b 00             	mov    (%rax),%rax
  8009bd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009bf:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009c3:	eb c0                	jmp    800985 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009c9:	eb ba                	jmp    800985 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009d2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009d5:	89 d0                	mov    %edx,%eax
  8009d7:	c1 e0 02             	shl    $0x2,%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	01 c0                	add    %eax,%eax
  8009de:	01 d8                	add    %ebx,%eax
  8009e0:	83 e8 30             	sub    $0x30,%eax
  8009e3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009e6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ea:	0f b6 00             	movzbl (%rax),%eax
  8009ed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f3:	7e 0c                	jle    800a01 <vprintfmt+0x105>
  8009f5:	83 fb 39             	cmp    $0x39,%ebx
  8009f8:	7f 07                	jg     800a01 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fa:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ff:	eb d1                	jmp    8009d2 <vprintfmt+0xd6>
			goto process_precision;
  800a01:	eb 58                	jmp    800a5b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a06:	83 f8 30             	cmp    $0x30,%eax
  800a09:	73 17                	jae    800a22 <vprintfmt+0x126>
  800a0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a12:	89 c0                	mov    %eax,%eax
  800a14:	48 01 d0             	add    %rdx,%rax
  800a17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1a:	83 c2 08             	add    $0x8,%edx
  800a1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a20:	eb 0f                	jmp    800a31 <vprintfmt+0x135>
  800a22:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a26:	48 89 d0             	mov    %rdx,%rax
  800a29:	48 83 c2 08          	add    $0x8,%rdx
  800a2d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a31:	8b 00                	mov    (%rax),%eax
  800a33:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a36:	eb 23                	jmp    800a5b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3c:	79 0c                	jns    800a4a <vprintfmt+0x14e>
				width = 0;
  800a3e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a45:	e9 3b ff ff ff       	jmpq   800985 <vprintfmt+0x89>
  800a4a:	e9 36 ff ff ff       	jmpq   800985 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a4f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a56:	e9 2a ff ff ff       	jmpq   800985 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5f:	79 12                	jns    800a73 <vprintfmt+0x177>
				width = precision, precision = -1;
  800a61:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a64:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a67:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a6e:	e9 12 ff ff ff       	jmpq   800985 <vprintfmt+0x89>
  800a73:	e9 0d ff ff ff       	jmpq   800985 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a78:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a7c:	e9 04 ff ff ff       	jmpq   800985 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a84:	83 f8 30             	cmp    $0x30,%eax
  800a87:	73 17                	jae    800aa0 <vprintfmt+0x1a4>
  800a89:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a90:	89 c0                	mov    %eax,%eax
  800a92:	48 01 d0             	add    %rdx,%rax
  800a95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a98:	83 c2 08             	add    $0x8,%edx
  800a9b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9e:	eb 0f                	jmp    800aaf <vprintfmt+0x1b3>
  800aa0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa4:	48 89 d0             	mov    %rdx,%rax
  800aa7:	48 83 c2 08          	add    $0x8,%rdx
  800aab:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aaf:	8b 10                	mov    (%rax),%edx
  800ab1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ab5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab9:	48 89 ce             	mov    %rcx,%rsi
  800abc:	89 d7                	mov    %edx,%edi
  800abe:	ff d0                	callq  *%rax
			break;
  800ac0:	e9 40 03 00 00       	jmpq   800e05 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ac5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac8:	83 f8 30             	cmp    $0x30,%eax
  800acb:	73 17                	jae    800ae4 <vprintfmt+0x1e8>
  800acd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad4:	89 c0                	mov    %eax,%eax
  800ad6:	48 01 d0             	add    %rdx,%rax
  800ad9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800adc:	83 c2 08             	add    $0x8,%edx
  800adf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae2:	eb 0f                	jmp    800af3 <vprintfmt+0x1f7>
  800ae4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae8:	48 89 d0             	mov    %rdx,%rax
  800aeb:	48 83 c2 08          	add    $0x8,%rdx
  800aef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800af5:	85 db                	test   %ebx,%ebx
  800af7:	79 02                	jns    800afb <vprintfmt+0x1ff>
				err = -err;
  800af9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800afb:	83 fb 15             	cmp    $0x15,%ebx
  800afe:	7f 16                	jg     800b16 <vprintfmt+0x21a>
  800b00:	48 b8 20 4e 80 00 00 	movabs $0x804e20,%rax
  800b07:	00 00 00 
  800b0a:	48 63 d3             	movslq %ebx,%rdx
  800b0d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b11:	4d 85 e4             	test   %r12,%r12
  800b14:	75 2e                	jne    800b44 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1e:	89 d9                	mov    %ebx,%ecx
  800b20:	48 ba e1 4e 80 00 00 	movabs $0x804ee1,%rdx
  800b27:	00 00 00 
  800b2a:	48 89 c7             	mov    %rax,%rdi
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b39:	00 00 00 
  800b3c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b3f:	e9 c1 02 00 00       	jmpq   800e05 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b44:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4c:	4c 89 e1             	mov    %r12,%rcx
  800b4f:	48 ba ea 4e 80 00 00 	movabs $0x804eea,%rdx
  800b56:	00 00 00 
  800b59:	48 89 c7             	mov    %rax,%rdi
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b61:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b68:	00 00 00 
  800b6b:	41 ff d0             	callq  *%r8
			break;
  800b6e:	e9 92 02 00 00       	jmpq   800e05 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b76:	83 f8 30             	cmp    $0x30,%eax
  800b79:	73 17                	jae    800b92 <vprintfmt+0x296>
  800b7b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b82:	89 c0                	mov    %eax,%eax
  800b84:	48 01 d0             	add    %rdx,%rax
  800b87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b8a:	83 c2 08             	add    $0x8,%edx
  800b8d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b90:	eb 0f                	jmp    800ba1 <vprintfmt+0x2a5>
  800b92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b96:	48 89 d0             	mov    %rdx,%rax
  800b99:	48 83 c2 08          	add    $0x8,%rdx
  800b9d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba1:	4c 8b 20             	mov    (%rax),%r12
  800ba4:	4d 85 e4             	test   %r12,%r12
  800ba7:	75 0a                	jne    800bb3 <vprintfmt+0x2b7>
				p = "(null)";
  800ba9:	49 bc ed 4e 80 00 00 	movabs $0x804eed,%r12
  800bb0:	00 00 00 
			if (width > 0 && padc != '-')
  800bb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb7:	7e 3f                	jle    800bf8 <vprintfmt+0x2fc>
  800bb9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bbd:	74 39                	je     800bf8 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bc2:	48 98                	cltq   
  800bc4:	48 89 c6             	mov    %rax,%rsi
  800bc7:	4c 89 e7             	mov    %r12,%rdi
  800bca:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  800bd1:	00 00 00 
  800bd4:	ff d0                	callq  *%rax
  800bd6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bd9:	eb 17                	jmp    800bf2 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bdb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bdf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	48 89 ce             	mov    %rcx,%rsi
  800bea:	89 d7                	mov    %edx,%edi
  800bec:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bee:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf6:	7f e3                	jg     800bdb <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf8:	eb 37                	jmp    800c31 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800bfa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bfe:	74 1e                	je     800c1e <vprintfmt+0x322>
  800c00:	83 fb 1f             	cmp    $0x1f,%ebx
  800c03:	7e 05                	jle    800c0a <vprintfmt+0x30e>
  800c05:	83 fb 7e             	cmp    $0x7e,%ebx
  800c08:	7e 14                	jle    800c1e <vprintfmt+0x322>
					putch('?', putdat);
  800c0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c12:	48 89 d6             	mov    %rdx,%rsi
  800c15:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c1a:	ff d0                	callq  *%rax
  800c1c:	eb 0f                	jmp    800c2d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	89 df                	mov    %ebx,%edi
  800c2b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c31:	4c 89 e0             	mov    %r12,%rax
  800c34:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c38:	0f b6 00             	movzbl (%rax),%eax
  800c3b:	0f be d8             	movsbl %al,%ebx
  800c3e:	85 db                	test   %ebx,%ebx
  800c40:	74 10                	je     800c52 <vprintfmt+0x356>
  800c42:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c46:	78 b2                	js     800bfa <vprintfmt+0x2fe>
  800c48:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c4c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c50:	79 a8                	jns    800bfa <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c52:	eb 16                	jmp    800c6a <vprintfmt+0x36e>
				putch(' ', putdat);
  800c54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5c:	48 89 d6             	mov    %rdx,%rsi
  800c5f:	bf 20 00 00 00       	mov    $0x20,%edi
  800c64:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c66:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c6e:	7f e4                	jg     800c54 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c70:	e9 90 01 00 00       	jmpq   800e05 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c79:	be 03 00 00 00       	mov    $0x3,%esi
  800c7e:	48 89 c7             	mov    %rax,%rdi
  800c81:	48 b8 ec 07 80 00 00 	movabs $0x8007ec,%rax
  800c88:	00 00 00 
  800c8b:	ff d0                	callq  *%rax
  800c8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c95:	48 85 c0             	test   %rax,%rax
  800c98:	79 1d                	jns    800cb7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c9a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca2:	48 89 d6             	mov    %rdx,%rsi
  800ca5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800caa:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb0:	48 f7 d8             	neg    %rax
  800cb3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cb7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cbe:	e9 d5 00 00 00       	jmpq   800d98 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cc3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc7:	be 03 00 00 00       	mov    $0x3,%esi
  800ccc:	48 89 c7             	mov    %rax,%rdi
  800ccf:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  800cd6:	00 00 00 
  800cd9:	ff d0                	callq  *%rax
  800cdb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cdf:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ce6:	e9 ad 00 00 00       	jmpq   800d98 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ceb:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800cee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf2:	89 d6                	mov    %edx,%esi
  800cf4:	48 89 c7             	mov    %rax,%rdi
  800cf7:	48 b8 ec 07 80 00 00 	movabs $0x8007ec,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800d07:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d0e:	e9 85 00 00 00       	jmpq   800d98 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800d13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1b:	48 89 d6             	mov    %rdx,%rsi
  800d1e:	bf 30 00 00 00       	mov    $0x30,%edi
  800d23:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2d:	48 89 d6             	mov    %rdx,%rsi
  800d30:	bf 78 00 00 00       	mov    $0x78,%edi
  800d35:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3a:	83 f8 30             	cmp    $0x30,%eax
  800d3d:	73 17                	jae    800d56 <vprintfmt+0x45a>
  800d3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d46:	89 c0                	mov    %eax,%eax
  800d48:	48 01 d0             	add    %rdx,%rax
  800d4b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d4e:	83 c2 08             	add    $0x8,%edx
  800d51:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d54:	eb 0f                	jmp    800d65 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d56:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5a:	48 89 d0             	mov    %rdx,%rax
  800d5d:	48 83 c2 08          	add    $0x8,%rdx
  800d61:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d65:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d6c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d73:	eb 23                	jmp    800d98 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d79:	be 03 00 00 00       	mov    $0x3,%esi
  800d7e:	48 89 c7             	mov    %rax,%rdi
  800d81:	48 b8 dc 06 80 00 00 	movabs $0x8006dc,%rax
  800d88:	00 00 00 
  800d8b:	ff d0                	callq  *%rax
  800d8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d91:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d98:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d9d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800daf:	45 89 c1             	mov    %r8d,%r9d
  800db2:	41 89 f8             	mov    %edi,%r8d
  800db5:	48 89 c7             	mov    %rax,%rdi
  800db8:	48 b8 21 06 80 00 00 	movabs $0x800621,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	callq  *%rax
			break;
  800dc4:	eb 3f                	jmp    800e05 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dce:	48 89 d6             	mov    %rdx,%rsi
  800dd1:	89 df                	mov    %ebx,%edi
  800dd3:	ff d0                	callq  *%rax
			break;
  800dd5:	eb 2e                	jmp    800e05 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddf:	48 89 d6             	mov    %rdx,%rsi
  800de2:	bf 25 00 00 00       	mov    $0x25,%edi
  800de7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dee:	eb 05                	jmp    800df5 <vprintfmt+0x4f9>
  800df0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800df9:	48 83 e8 01          	sub    $0x1,%rax
  800dfd:	0f b6 00             	movzbl (%rax),%eax
  800e00:	3c 25                	cmp    $0x25,%al
  800e02:	75 ec                	jne    800df0 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e04:	90                   	nop
		}
	}
  800e05:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e06:	e9 43 fb ff ff       	jmpq   80094e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e0b:	48 83 c4 60          	add    $0x60,%rsp
  800e0f:	5b                   	pop    %rbx
  800e10:	41 5c                	pop    %r12
  800e12:	5d                   	pop    %rbp
  800e13:	c3                   	retq   

0000000000800e14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e14:	55                   	push   %rbp
  800e15:	48 89 e5             	mov    %rsp,%rbp
  800e18:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e1f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e42:	84 c0                	test   %al,%al
  800e44:	74 20                	je     800e66 <printfmt+0x52>
  800e46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e6d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e74:	00 00 00 
  800e77:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e7e:	00 00 00 
  800e81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e85:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e93:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ea8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eaf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eb6:	48 89 c7             	mov    %rax,%rdi
  800eb9:	48 b8 fc 08 80 00 00 	movabs $0x8008fc,%rax
  800ec0:	00 00 00 
  800ec3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	48 83 ec 10          	sub    $0x10,%rsp
  800ecf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eda:	8b 40 10             	mov    0x10(%rax),%eax
  800edd:	8d 50 01             	lea    0x1(%rax),%edx
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eeb:	48 8b 10             	mov    (%rax),%rdx
  800eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ef6:	48 39 c2             	cmp    %rax,%rdx
  800ef9:	73 17                	jae    800f12 <sprintputch+0x4b>
		*b->buf++ = ch;
  800efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eff:	48 8b 00             	mov    (%rax),%rax
  800f02:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0a:	48 89 0a             	mov    %rcx,(%rdx)
  800f0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f10:	88 10                	mov    %dl,(%rax)
}
  800f12:	c9                   	leaveq 
  800f13:	c3                   	retq   

0000000000800f14 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f14:	55                   	push   %rbp
  800f15:	48 89 e5             	mov    %rsp,%rbp
  800f18:	48 83 ec 50          	sub    $0x50,%rsp
  800f1c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f20:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f23:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f27:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f2b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f2f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f33:	48 8b 0a             	mov    (%rdx),%rcx
  800f36:	48 89 08             	mov    %rcx,(%rax)
  800f39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f51:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f54:	48 98                	cltq   
  800f56:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f5e:	48 01 d0             	add    %rdx,%rax
  800f61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f6c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f71:	74 06                	je     800f79 <vsnprintf+0x65>
  800f73:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f77:	7f 07                	jg     800f80 <vsnprintf+0x6c>
		return -E_INVAL;
  800f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7e:	eb 2f                	jmp    800faf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f80:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f84:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f8c:	48 89 c6             	mov    %rax,%rsi
  800f8f:	48 bf c7 0e 80 00 00 	movabs $0x800ec7,%rdi
  800f96:	00 00 00 
  800f99:	48 b8 fc 08 80 00 00 	movabs $0x8008fc,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fa9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fbc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fc9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fd7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fde:	84 c0                	test   %al,%al
  800fe0:	74 20                	je     801002 <snprintf+0x51>
  800fe2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fe6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ff6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ffa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ffe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801002:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801009:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801010:	00 00 00 
  801013:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101a:	00 00 00 
  80101d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801021:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801028:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80102f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801036:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80103d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801044:	48 8b 0a             	mov    (%rdx),%rcx
  801047:	48 89 08             	mov    %rcx,(%rax)
  80104a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801052:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801056:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801061:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801068:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80106e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801075:	48 89 c7             	mov    %rax,%rdi
  801078:	48 b8 14 0f 80 00 00 	movabs $0x800f14,%rax
  80107f:	00 00 00 
  801082:	ff d0                	callq  *%rax
  801084:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a5:	eb 09                	jmp    8010b0 <strlen+0x1e>
		n++;
  8010a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 ec                	jne    8010a7 <strlen+0x15>
		n++;
	return n;
  8010bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 20          	sub    $0x20,%rsp
  8010c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010d7:	eb 0e                	jmp    8010e7 <strnlen+0x27>
		n++;
  8010d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ec:	74 0b                	je     8010f9 <strnlen+0x39>
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	75 e0                	jne    8010d9 <strnlen+0x19>
		n++;
	return n;
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801116:	90                   	nop
  801117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801127:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80112f:	0f b6 12             	movzbl (%rdx),%edx
  801132:	88 10                	mov    %dl,(%rax)
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	84 c0                	test   %al,%al
  801139:	75 dc                	jne    801117 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 20          	sub    $0x20,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 89 c7             	mov    %rax,%rdi
  801158:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
  801164:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116a:	48 63 d0             	movslq %eax,%rdx
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 01 c2             	add    %rax,%rdx
  801174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801178:	48 89 c6             	mov    %rax,%rsi
  80117b:	48 89 d7             	mov    %rdx,%rdi
  80117e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
	return dst;
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 28          	sub    $0x28,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b3:	00 
  8011b4:	eb 2a                	jmp    8011e0 <strncpy+0x50>
		*dst++ = *src;
  8011b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c6:	0f b6 12             	movzbl (%rdx),%edx
  8011c9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	74 05                	je     8011db <strncpy+0x4b>
			src++;
  8011d6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e8:	72 cc                	jb     8011b6 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 28          	sub    $0x28,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801200:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80120c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801211:	74 3d                	je     801250 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801213:	eb 1d                	jmp    801232 <strlcpy+0x42>
			*dst++ = *src++;
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801221:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801225:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801229:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122d:	0f b6 12             	movzbl (%rdx),%edx
  801230:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801232:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801237:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80123c:	74 0b                	je     801249 <strlcpy+0x59>
  80123e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	75 cc                	jne    801215 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801250:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 29 c2             	sub    %rax,%rdx
  80125b:	48 89 d0             	mov    %rdx,%rax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 10          	sub    $0x10,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801270:	eb 0a                	jmp    80127c <strcmp+0x1c>
		p++, q++;
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	74 12                	je     801299 <strcmp+0x39>
  801287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128b:	0f b6 10             	movzbl (%rax),%edx
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	38 c2                	cmp    %al,%dl
  801297:	74 d9                	je     801272 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	0f b6 d0             	movzbl %al,%edx
  8012a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	0f b6 c0             	movzbl %al,%eax
  8012ad:	29 c2                	sub    %eax,%edx
  8012af:	89 d0                	mov    %edx,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 18          	sub    $0x18,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012c7:	eb 0f                	jmp    8012d8 <strncmp+0x25>
		n--, p++, q++;
  8012c9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012dd:	74 1d                	je     8012fc <strncmp+0x49>
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	74 12                	je     8012fc <strncmp+0x49>
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 10             	movzbl (%rax),%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	38 c2                	cmp    %al,%dl
  8012fa:	74 cd                	je     8012c9 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801301:	75 07                	jne    80130a <strncmp+0x57>
		return 0;
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
  801308:	eb 18                	jmp    801322 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	0f b6 d0             	movzbl %al,%edx
  801314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 c0             	movzbl %al,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
}
  801322:	c9                   	leaveq 
  801323:	c3                   	retq   

0000000000801324 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	48 83 ec 0c          	sub    $0xc,%rsp
  80132c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801330:	89 f0                	mov    %esi,%eax
  801332:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801335:	eb 17                	jmp    80134e <strchr+0x2a>
		if (*s == c)
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801341:	75 06                	jne    801349 <strchr+0x25>
			return (char *) s;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801347:	eb 15                	jmp    80135e <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	84 c0                	test   %al,%al
  801357:	75 de                	jne    801337 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 0c          	sub    $0xc,%rsp
  801368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136c:	89 f0                	mov    %esi,%eax
  80136e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801371:	eb 13                	jmp    801386 <strfind+0x26>
		if (*s == c)
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137d:	75 02                	jne    801381 <strfind+0x21>
			break;
  80137f:	eb 10                	jmp    801391 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801381:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138a:	0f b6 00             	movzbl (%rax),%eax
  80138d:	84 c0                	test   %al,%al
  80138f:	75 e2                	jne    801373 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 18          	sub    $0x18,%rsp
  80139f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013af:	75 06                	jne    8013b7 <memset+0x20>
		return v;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 69                	jmp    801420 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 48                	jne    80140b <memset+0x74>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 3c                	jne    80140b <memset+0x74>
		c &= 0xFF;
  8013cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	c1 e0 18             	shl    $0x18,%eax
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 10             	shl    $0x10,%eax
  8013e4:	09 c2                	or     %eax,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 08             	shl    $0x8,%eax
  8013ec:	09 d0                	or     %edx,%eax
  8013ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 c1 e8 02          	shr    $0x2,%rax
  8013f9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	48 89 d7             	mov    %rdx,%rdi
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%rdi)
  801409:	eb 11                	jmp    80141c <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801416:	48 89 d7             	mov    %rdx,%rdi
  801419:	fc                   	cld    
  80141a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801420:	c9                   	leaveq 
  801421:	c3                   	retq   

0000000000801422 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	48 83 ec 28          	sub    $0x28,%rsp
  80142a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801432:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144e:	0f 83 88 00 00 00    	jae    8014dc <memmove+0xba>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801463:	76 77                	jbe    8014dc <memmove+0xba>
		s += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 3b                	jne    8014bc <memmove+0x9a>
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	75 2f                	jne    8014bc <memmove+0x9a>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 23                	jne    8014bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 83 e8 04          	sub    $0x4,%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 83 ea 04          	sub    $0x4,%rdx
  8014a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ad:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fd                   	std    
  8014b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ba:	eb 1d                	jmp    8014d9 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 89 d7             	mov    %rdx,%rdi
  8014d3:	48 89 c1             	mov    %rax,%rcx
  8014d6:	fd                   	std    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d9:	fc                   	cld    
  8014da:	eb 57                	jmp    801533 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 36                	jne    80151e <memmove+0xfc>
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	48 85 c0             	test   %rax,%rax
  8014f2:	75 2a                	jne    80151e <memmove+0xfc>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 1e                	jne    80151e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 c1 e8 02          	shr    $0x2,%rax
  801508:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 89 d6             	mov    %rdx,%rsi
  801519:	fc                   	cld    
  80151a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80151c:	eb 15                	jmp    801533 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fc                   	cld    
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 18          	sub    $0x18,%rsp
  801541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801549:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80154d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801551:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	48 89 ce             	mov    %rcx,%rsi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801591:	eb 36                	jmp    8015c9 <memcmp+0x5c>
		if (*s1 != *s2)
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 10             	movzbl (%rax),%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	74 1a                	je     8015bf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	29 c2                	sub    %eax,%edx
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	eb 20                	jmp    8015df <memcmp+0x72>
		s1++, s2++;
  8015bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015d5:	48 85 c0             	test   %rax,%rax
  8015d8:	75 b9                	jne    801593 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015df:	c9                   	leaveq 
  8015e0:	c3                   	retq   

00000000008015e1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
  8015e5:	48 83 ec 28          	sub    $0x28,%rsp
  8015e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fc:	48 01 d0             	add    %rdx,%rax
  8015ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801603:	eb 15                	jmp    80161a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	0f b6 10             	movzbl (%rax),%edx
  80160c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80160f:	38 c2                	cmp    %al,%dl
  801611:	75 02                	jne    801615 <memfind+0x34>
			break;
  801613:	eb 0f                	jmp    801624 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801615:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801622:	72 e1                	jb     801605 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 34          	sub    $0x34,%rsp
  801632:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801636:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801644:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80164b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164c:	eb 05                	jmp    801653 <strtol+0x29>
		s++;
  80164e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 20                	cmp    $0x20,%al
  80165c:	74 f0                	je     80164e <strtol+0x24>
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 09                	cmp    $0x9,%al
  801667:	74 e5                	je     80164e <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 2b                	cmp    $0x2b,%al
  801672:	75 07                	jne    80167b <strtol+0x51>
		s++;
  801674:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801679:	eb 17                	jmp    801692 <strtol+0x68>
	else if (*s == '-')
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	3c 2d                	cmp    $0x2d,%al
  801684:	75 0c                	jne    801692 <strtol+0x68>
		s++, neg = 1;
  801686:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801692:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801696:	74 06                	je     80169e <strtol+0x74>
  801698:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80169c:	75 28                	jne    8016c6 <strtol+0x9c>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 30                	cmp    $0x30,%al
  8016a7:	75 1d                	jne    8016c6 <strtol+0x9c>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	48 83 c0 01          	add    $0x1,%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	3c 78                	cmp    $0x78,%al
  8016b6:	75 0e                	jne    8016c6 <strtol+0x9c>
		s += 2, base = 16;
  8016b8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016bd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c4:	eb 2c                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ca:	75 19                	jne    8016e5 <strtol+0xbb>
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 30                	cmp    $0x30,%al
  8016d5:	75 0e                	jne    8016e5 <strtol+0xbb>
		s++, base = 8;
  8016d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016dc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e3:	eb 0d                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0)
  8016e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e9:	75 07                	jne    8016f2 <strtol+0xc8>
		base = 10;
  8016eb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	3c 2f                	cmp    $0x2f,%al
  8016fb:	7e 1d                	jle    80171a <strtol+0xf0>
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 39                	cmp    $0x39,%al
  801706:	7f 12                	jg     80171a <strtol+0xf0>
			dig = *s - '0';
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	0f b6 00             	movzbl (%rax),%eax
  80170f:	0f be c0             	movsbl %al,%eax
  801712:	83 e8 30             	sub    $0x30,%eax
  801715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801718:	eb 4e                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	3c 60                	cmp    $0x60,%al
  801723:	7e 1d                	jle    801742 <strtol+0x118>
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 7a                	cmp    $0x7a,%al
  80172e:	7f 12                	jg     801742 <strtol+0x118>
			dig = *s - 'a' + 10;
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	0f be c0             	movsbl %al,%eax
  80173a:	83 e8 57             	sub    $0x57,%eax
  80173d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801740:	eb 26                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 40                	cmp    $0x40,%al
  80174b:	7e 48                	jle    801795 <strtol+0x16b>
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 5a                	cmp    $0x5a,%al
  801756:	7f 3d                	jg     801795 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	0f be c0             	movsbl %al,%eax
  801762:	83 e8 37             	sub    $0x37,%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80176e:	7c 02                	jl     801772 <strtol+0x148>
			break;
  801770:	eb 23                	jmp    801795 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801772:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801777:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177a:	48 98                	cltq   
  80177c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801781:	48 89 c2             	mov    %rax,%rdx
  801784:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801787:	48 98                	cltq   
  801789:	48 01 d0             	add    %rdx,%rax
  80178c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801790:	e9 5d ff ff ff       	jmpq   8016f2 <strtol+0xc8>

	if (endptr)
  801795:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179a:	74 0b                	je     8017a7 <strtol+0x17d>
		*endptr = (char *) s;
  80179c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ab:	74 09                	je     8017b6 <strtol+0x18c>
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	48 f7 d8             	neg    %rax
  8017b4:	eb 04                	jmp    8017ba <strtol+0x190>
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <strstr>:

char * strstr(const char *in, const char *str)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 30          	sub    $0x30,%rsp
  8017c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017de:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e2:	75 06                	jne    8017ea <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	eb 6b                	jmp    801855 <strstr+0x99>

	len = strlen(str);
  8017ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ee:	48 89 c7             	mov    %rax,%rdi
  8017f1:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
  8017fd:	48 98                	cltq   
  8017ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80180b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801815:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801819:	75 07                	jne    801822 <strstr+0x66>
				return (char *) 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb 33                	jmp    801855 <strstr+0x99>
		} while (sc != c);
  801822:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801826:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801829:	75 d8                	jne    801803 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80182b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	48 89 ce             	mov    %rcx,%rsi
  80183a:	48 89 c7             	mov    %rax,%rdi
  80183d:	48 b8 b3 12 80 00 00 	movabs $0x8012b3,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
  801849:	85 c0                	test   %eax,%eax
  80184b:	75 b6                	jne    801803 <strstr+0x47>

	return (char *) (in - 1);
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	48 83 e8 01          	sub    $0x1,%rax
}
  801855:	c9                   	leaveq 
  801856:	c3                   	retq   

0000000000801857 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	53                   	push   %rbx
  80185c:	48 83 ec 48          	sub    $0x48,%rsp
  801860:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801863:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801866:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80186e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801872:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801876:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801879:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80187d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801881:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801885:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801889:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80188d:	4c 89 c3             	mov    %r8,%rbx
  801890:	cd 30                	int    $0x30
  801892:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801896:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80189a:	74 3e                	je     8018da <syscall+0x83>
  80189c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a1:	7e 37                	jle    8018da <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018aa:	49 89 d0             	mov    %rdx,%r8
  8018ad:	89 c1                	mov    %eax,%ecx
  8018af:	48 ba a8 51 80 00 00 	movabs $0x8051a8,%rdx
  8018b6:	00 00 00 
  8018b9:	be 23 00 00 00       	mov    $0x23,%esi
  8018be:	48 bf c5 51 80 00 00 	movabs $0x8051c5,%rdi
  8018c5:	00 00 00 
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cd:	49 b9 10 03 80 00 00 	movabs $0x800310,%r9
  8018d4:	00 00 00 
  8018d7:	41 ff d1             	callq  *%r9

	return ret;
  8018da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018de:	48 83 c4 48          	add    $0x48,%rsp
  8018e2:	5b                   	pop    %rbx
  8018e3:	5d                   	pop    %rbp
  8018e4:	c3                   	retq   

00000000008018e5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
  8018e9:	48 83 ec 20          	sub    $0x20,%rsp
  8018ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801904:	00 
  801905:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801911:	48 89 d1             	mov    %rdx,%rcx
  801914:	48 89 c2             	mov    %rax,%rdx
  801917:	be 00 00 00 00       	mov    $0x0,%esi
  80191c:	bf 00 00 00 00       	mov    $0x0,%edi
  801921:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <sys_cgetc>:

int
sys_cgetc(void)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801937:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80193e:	00 
  80193f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801945:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	be 00 00 00 00       	mov    $0x0,%esi
  80195a:	bf 01 00 00 00       	mov    $0x1,%edi
  80195f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 10          	sub    $0x10,%rsp
  801975:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	48 98                	cltq   
  80197d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801984:	00 
  801985:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801991:	b9 00 00 00 00       	mov    $0x0,%ecx
  801996:	48 89 c2             	mov    %rax,%rdx
  801999:	be 01 00 00 00       	mov    $0x1,%esi
  80199e:	bf 03 00 00 00       	mov    $0x3,%edi
  8019a3:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
}
  8019af:	c9                   	leaveq 
  8019b0:	c3                   	retq   

00000000008019b1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019b1:	55                   	push   %rbp
  8019b2:	48 89 e5             	mov    %rsp,%rbp
  8019b5:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c0:	00 
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d7:	be 00 00 00 00       	mov    $0x0,%esi
  8019dc:	bf 02 00 00 00       	mov    $0x2,%edi
  8019e1:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019e8:	00 00 00 
  8019eb:	ff d0                	callq  *%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_yield>:

void
sys_yield(void)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fe:	00 
  8019ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a10:	ba 00 00 00 00       	mov    $0x0,%edx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a1f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 20          	sub    $0x20,%rsp
  801a35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a3c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a42:	48 63 c8             	movslq %eax,%rcx
  801a45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4c:	48 98                	cltq   
  801a4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a55:	00 
  801a56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5c:	49 89 c8             	mov    %rcx,%r8
  801a5f:	48 89 d1             	mov    %rdx,%rcx
  801a62:	48 89 c2             	mov    %rax,%rdx
  801a65:	be 01 00 00 00       	mov    $0x1,%esi
  801a6a:	bf 04 00 00 00       	mov    $0x4,%edi
  801a6f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a76:	00 00 00 
  801a79:	ff d0                	callq  *%rax
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 30          	sub    $0x30,%rsp
  801a85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a8f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a93:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a9a:	48 63 c8             	movslq %eax,%rcx
  801a9d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa4:	48 63 f0             	movslq %eax,%rsi
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aae:	48 98                	cltq   
  801ab0:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ab4:	49 89 f9             	mov    %rdi,%r9
  801ab7:	49 89 f0             	mov    %rsi,%r8
  801aba:	48 89 d1             	mov    %rdx,%rcx
  801abd:	48 89 c2             	mov    %rax,%rdx
  801ac0:	be 01 00 00 00       	mov    $0x1,%esi
  801ac5:	bf 05 00 00 00       	mov    $0x5,%edi
  801aca:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	callq  *%rax
}
  801ad6:	c9                   	leaveq 
  801ad7:	c3                   	retq   

0000000000801ad8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	48 83 ec 20          	sub    $0x20,%rsp
  801ae0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ae7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aee:	48 98                	cltq   
  801af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af7:	00 
  801af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b04:	48 89 d1             	mov    %rdx,%rcx
  801b07:	48 89 c2             	mov    %rax,%rdx
  801b0a:	be 01 00 00 00       	mov    $0x1,%esi
  801b0f:	bf 06 00 00 00       	mov    $0x6,%edi
  801b14:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
}
  801b20:	c9                   	leaveq 
  801b21:	c3                   	retq   

0000000000801b22 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b22:	55                   	push   %rbp
  801b23:	48 89 e5             	mov    %rsp,%rbp
  801b26:	48 83 ec 10          	sub    $0x10,%rsp
  801b2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b33:	48 63 d0             	movslq %eax,%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 01 00 00 00       	mov    $0x1,%esi
  801b5a:	bf 08 00 00 00       	mov    $0x8,%edi
  801b5f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 20          	sub    $0x20,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b78:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b83:	48 98                	cltq   
  801b85:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8c:	00 
  801b8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b99:	48 89 d1             	mov    %rdx,%rcx
  801b9c:	48 89 c2             	mov    %rax,%rdx
  801b9f:	be 01 00 00 00       	mov    $0x1,%esi
  801ba4:	bf 09 00 00 00       	mov    $0x9,%edi
  801ba9:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	callq  *%rax
}
  801bb5:	c9                   	leaveq 
  801bb6:	c3                   	retq   

0000000000801bb7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	48 83 ec 20          	sub    $0x20,%rsp
  801bbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcd:	48 98                	cltq   
  801bcf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd6:	00 
  801bd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be3:	48 89 d1             	mov    %rdx,%rcx
  801be6:	48 89 c2             	mov    %rax,%rdx
  801be9:	be 01 00 00 00       	mov    $0x1,%esi
  801bee:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bf3:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
}
  801bff:	c9                   	leaveq 
  801c00:	c3                   	retq   

0000000000801c01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c01:	55                   	push   %rbp
  801c02:	48 89 e5             	mov    %rsp,%rbp
  801c05:	48 83 ec 20          	sub    $0x20,%rsp
  801c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c10:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c14:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1a:	48 63 f0             	movslq %eax,%rsi
  801c1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c24:	48 98                	cltq   
  801c26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c31:	00 
  801c32:	49 89 f1             	mov    %rsi,%r9
  801c35:	49 89 c8             	mov    %rcx,%r8
  801c38:	48 89 d1             	mov    %rdx,%rcx
  801c3b:	48 89 c2             	mov    %rax,%rdx
  801c3e:	be 00 00 00 00       	mov    $0x0,%esi
  801c43:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c48:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c4f:	00 00 00 
  801c52:	ff d0                	callq  *%rax
}
  801c54:	c9                   	leaveq 
  801c55:	c3                   	retq   

0000000000801c56 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c56:	55                   	push   %rbp
  801c57:	48 89 e5             	mov    %rsp,%rbp
  801c5a:	48 83 ec 10          	sub    $0x10,%rsp
  801c5e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c66:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6d:	00 
  801c6e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c74:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7f:	48 89 c2             	mov    %rax,%rdx
  801c82:	be 01 00 00 00       	mov    $0x1,%esi
  801c87:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c8c:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	callq  *%rax
}
  801c98:	c9                   	leaveq 
  801c99:	c3                   	retq   

0000000000801c9a <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801c9a:	55                   	push   %rbp
  801c9b:	48 89 e5             	mov    %rsp,%rbp
  801c9e:	48 83 ec 20          	sub    $0x20,%rsp
  801ca2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ca6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, (uint64_t)buf, len, 0, 0, 0, 0);
  801caa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb9:	00 
  801cba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ccb:	89 c6                	mov    %eax,%esi
  801ccd:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cd2:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801cd9:	00 00 00 
  801cdc:	ff d0                	callq  *%rax
}
  801cde:	c9                   	leaveq 
  801cdf:	c3                   	retq   

0000000000801ce0 <sys_net_rx>:

int
sys_net_rx(void *buf, size_t len)
{
  801ce0:	55                   	push   %rbp
  801ce1:	48 89 e5             	mov    %rsp,%rbp
  801ce4:	48 83 ec 20          	sub    $0x20,%rsp
  801ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_rx, (uint64_t)buf, len, 0, 0, 0, 0);
  801cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cff:	00 
  801d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d11:	89 c6                	mov    %eax,%esi
  801d13:	bf 10 00 00 00       	mov    $0x10,%edi
  801d18:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	callq  *%rax
}
  801d24:	c9                   	leaveq 
  801d25:	c3                   	retq   

0000000000801d26 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801d26:	55                   	push   %rbp
  801d27:	48 89 e5             	mov    %rsp,%rbp
  801d2a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d35:	00 
  801d36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d42:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d47:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4c:	be 00 00 00 00       	mov    $0x0,%esi
  801d51:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d56:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
  801d68:	48 83 ec 08          	sub    $0x8,%rsp
  801d6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d74:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d7b:	ff ff ff 
  801d7e:	48 01 d0             	add    %rdx,%rax
  801d81:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d85:	c9                   	leaveq 
  801d86:	c3                   	retq   

0000000000801d87 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d87:	55                   	push   %rbp
  801d88:	48 89 e5             	mov    %rsp,%rbp
  801d8b:	48 83 ec 08          	sub    $0x8,%rsp
  801d8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d97:	48 89 c7             	mov    %rax,%rdi
  801d9a:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  801da1:	00 00 00 
  801da4:	ff d0                	callq  *%rax
  801da6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801db0:	c9                   	leaveq 
  801db1:	c3                   	retq   

0000000000801db2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801db2:	55                   	push   %rbp
  801db3:	48 89 e5             	mov    %rsp,%rbp
  801db6:	48 83 ec 18          	sub    $0x18,%rsp
  801dba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dc5:	eb 6b                	jmp    801e32 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dca:	48 98                	cltq   
  801dcc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dd2:	48 c1 e0 0c          	shl    $0xc,%rax
  801dd6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dde:	48 c1 e8 15          	shr    $0x15,%rax
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dec:	01 00 00 
  801def:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df3:	83 e0 01             	and    $0x1,%eax
  801df6:	48 85 c0             	test   %rax,%rax
  801df9:	74 21                	je     801e1c <fd_alloc+0x6a>
  801dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dff:	48 c1 e8 0c          	shr    $0xc,%rax
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e0d:	01 00 00 
  801e10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e14:	83 e0 01             	and    $0x1,%eax
  801e17:	48 85 c0             	test   %rax,%rax
  801e1a:	75 12                	jne    801e2e <fd_alloc+0x7c>
			*fd_store = fd;
  801e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e24:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2c:	eb 1a                	jmp    801e48 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e32:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e36:	7e 8f                	jle    801dc7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e3c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e43:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e48:	c9                   	leaveq 
  801e49:	c3                   	retq   

0000000000801e4a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e4a:	55                   	push   %rbp
  801e4b:	48 89 e5             	mov    %rsp,%rbp
  801e4e:	48 83 ec 20          	sub    $0x20,%rsp
  801e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e59:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e5d:	78 06                	js     801e65 <fd_lookup+0x1b>
  801e5f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e63:	7e 07                	jle    801e6c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6a:	eb 6c                	jmp    801ed8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e6f:	48 98                	cltq   
  801e71:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e77:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e83:	48 c1 e8 15          	shr    $0x15,%rax
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e91:	01 00 00 
  801e94:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e98:	83 e0 01             	and    $0x1,%eax
  801e9b:	48 85 c0             	test   %rax,%rax
  801e9e:	74 21                	je     801ec1 <fd_lookup+0x77>
  801ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ea8:	48 89 c2             	mov    %rax,%rdx
  801eab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb2:	01 00 00 
  801eb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb9:	83 e0 01             	and    $0x1,%eax
  801ebc:	48 85 c0             	test   %rax,%rax
  801ebf:	75 07                	jne    801ec8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec6:	eb 10                	jmp    801ed8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ecc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed8:	c9                   	leaveq 
  801ed9:	c3                   	retq   

0000000000801eda <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
  801ede:	48 83 ec 30          	sub    $0x30,%rsp
  801ee2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ee6:	89 f0                	mov    %esi,%eax
  801ee8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eef:	48 89 c7             	mov    %rax,%rdi
  801ef2:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	callq  *%rax
  801efe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f02:	48 89 d6             	mov    %rdx,%rsi
  801f05:	89 c7                	mov    %eax,%edi
  801f07:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  801f0e:	00 00 00 
  801f11:	ff d0                	callq  *%rax
  801f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1a:	78 0a                	js     801f26 <fd_close+0x4c>
	    || fd != fd2)
  801f1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f20:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f24:	74 12                	je     801f38 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f26:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f2a:	74 05                	je     801f31 <fd_close+0x57>
  801f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2f:	eb 05                	jmp    801f36 <fd_close+0x5c>
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	eb 69                	jmp    801fa1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3c:	8b 00                	mov    (%rax),%eax
  801f3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f42:	48 89 d6             	mov    %rdx,%rsi
  801f45:	89 c7                	mov    %eax,%edi
  801f47:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax
  801f53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5a:	78 2a                	js     801f86 <fd_close+0xac>
		if (dev->dev_close)
  801f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f60:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f64:	48 85 c0             	test   %rax,%rax
  801f67:	74 16                	je     801f7f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f71:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f75:	48 89 d7             	mov    %rdx,%rdi
  801f78:	ff d0                	callq  *%rax
  801f7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f7d:	eb 07                	jmp    801f86 <fd_close+0xac>
		else
			r = 0;
  801f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8a:	48 89 c6             	mov    %rax,%rsi
  801f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f92:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  801f99:	00 00 00 
  801f9c:	ff d0                	callq  *%rax
	return r;
  801f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fa1:	c9                   	leaveq 
  801fa2:	c3                   	retq   

0000000000801fa3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fa3:	55                   	push   %rbp
  801fa4:	48 89 e5             	mov    %rsp,%rbp
  801fa7:	48 83 ec 20          	sub    $0x20,%rsp
  801fab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fb9:	eb 41                	jmp    801ffc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fbb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fc2:	00 00 00 
  801fc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc8:	48 63 d2             	movslq %edx,%rdx
  801fcb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcf:	8b 00                	mov    (%rax),%eax
  801fd1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fd4:	75 22                	jne    801ff8 <dev_lookup+0x55>
			*dev = devtab[i];
  801fd6:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fdd:	00 00 00 
  801fe0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe3:	48 63 d2             	movslq %edx,%rdx
  801fe6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff6:	eb 60                	jmp    802058 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ff8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ffc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802003:	00 00 00 
  802006:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802009:	48 63 d2             	movslq %edx,%rdx
  80200c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802010:	48 85 c0             	test   %rax,%rax
  802013:	75 a6                	jne    801fbb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802015:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80201c:	00 00 00 
  80201f:	48 8b 00             	mov    (%rax),%rax
  802022:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802028:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80202b:	89 c6                	mov    %eax,%esi
  80202d:	48 bf d8 51 80 00 00 	movabs $0x8051d8,%rdi
  802034:	00 00 00 
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	48 b9 49 05 80 00 00 	movabs $0x800549,%rcx
  802043:	00 00 00 
  802046:	ff d1                	callq  *%rcx
	*dev = 0;
  802048:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802053:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802058:	c9                   	leaveq 
  802059:	c3                   	retq   

000000000080205a <close>:

int
close(int fdnum)
{
  80205a:	55                   	push   %rbp
  80205b:	48 89 e5             	mov    %rsp,%rbp
  80205e:	48 83 ec 20          	sub    $0x20,%rsp
  802062:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802065:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802069:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80206c:	48 89 d6             	mov    %rdx,%rsi
  80206f:	89 c7                	mov    %eax,%edi
  802071:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  802078:	00 00 00 
  80207b:	ff d0                	callq  *%rax
  80207d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802080:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802084:	79 05                	jns    80208b <close+0x31>
		return r;
  802086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802089:	eb 18                	jmp    8020a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80208b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80208f:	be 01 00 00 00       	mov    $0x1,%esi
  802094:	48 89 c7             	mov    %rax,%rdi
  802097:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
}
  8020a3:	c9                   	leaveq 
  8020a4:	c3                   	retq   

00000000008020a5 <close_all>:

void
close_all(void)
{
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b4:	eb 15                	jmp    8020cb <close_all+0x26>
		close(i);
  8020b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b9:	89 c7                	mov    %eax,%edi
  8020bb:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020cf:	7e e5                	jle    8020b6 <close_all+0x11>
		close(i);
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
  8020d7:	48 83 ec 40          	sub    $0x40,%rsp
  8020db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020e8:	48 89 d6             	mov    %rdx,%rsi
  8020eb:	89 c7                	mov    %eax,%edi
  8020ed:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
  8020f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802100:	79 08                	jns    80210a <dup+0x37>
		return r;
  802102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802105:	e9 70 01 00 00       	jmpq   80227a <dup+0x1a7>
	close(newfdnum);
  80210a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210d:	89 c7                	mov    %eax,%edi
  80210f:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80211b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80211e:	48 98                	cltq   
  802120:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802126:	48 c1 e0 0c          	shl    $0xc,%rax
  80212a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80212e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802132:	48 89 c7             	mov    %rax,%rdi
  802135:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	callq  *%rax
  802141:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802149:	48 89 c7             	mov    %rax,%rdi
  80214c:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
  802158:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802160:	48 c1 e8 15          	shr    $0x15,%rax
  802164:	48 89 c2             	mov    %rax,%rdx
  802167:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80216e:	01 00 00 
  802171:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802175:	83 e0 01             	and    $0x1,%eax
  802178:	48 85 c0             	test   %rax,%rax
  80217b:	74 73                	je     8021f0 <dup+0x11d>
  80217d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802181:	48 c1 e8 0c          	shr    $0xc,%rax
  802185:	48 89 c2             	mov    %rax,%rdx
  802188:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218f:	01 00 00 
  802192:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802196:	83 e0 01             	and    $0x1,%eax
  802199:	48 85 c0             	test   %rax,%rax
  80219c:	74 52                	je     8021f0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80219e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8021a6:	48 89 c2             	mov    %rax,%rdx
  8021a9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b0:	01 00 00 
  8021b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8021bc:	89 c1                	mov    %eax,%ecx
  8021be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c6:	41 89 c8             	mov    %ecx,%r8d
  8021c9:	48 89 d1             	mov    %rdx,%rcx
  8021cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d1:	48 89 c6             	mov    %rax,%rsi
  8021d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d9:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8021e0:	00 00 00 
  8021e3:	ff d0                	callq  *%rax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ec:	79 02                	jns    8021f0 <dup+0x11d>
			goto err;
  8021ee:	eb 57                	jmp    802247 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f8:	48 89 c2             	mov    %rax,%rdx
  8021fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802202:	01 00 00 
  802205:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802209:	25 07 0e 00 00       	and    $0xe07,%eax
  80220e:	89 c1                	mov    %eax,%ecx
  802210:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802218:	41 89 c8             	mov    %ecx,%r8d
  80221b:	48 89 d1             	mov    %rdx,%rcx
  80221e:	ba 00 00 00 00       	mov    $0x0,%edx
  802223:	48 89 c6             	mov    %rax,%rsi
  802226:	bf 00 00 00 00       	mov    $0x0,%edi
  80222b:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  802232:	00 00 00 
  802235:	ff d0                	callq  *%rax
  802237:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223e:	79 02                	jns    802242 <dup+0x16f>
		goto err;
  802240:	eb 05                	jmp    802247 <dup+0x174>

	return newfdnum;
  802242:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802245:	eb 33                	jmp    80227a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224b:	48 89 c6             	mov    %rax,%rsi
  80224e:	bf 00 00 00 00       	mov    $0x0,%edi
  802253:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80225f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802263:	48 89 c6             	mov    %rax,%rsi
  802266:	bf 00 00 00 00       	mov    $0x0,%edi
  80226b:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  802272:	00 00 00 
  802275:	ff d0                	callq  *%rax
	return r;
  802277:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80227a:	c9                   	leaveq 
  80227b:	c3                   	retq   

000000000080227c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80227c:	55                   	push   %rbp
  80227d:	48 89 e5             	mov    %rsp,%rbp
  802280:	48 83 ec 40          	sub    $0x40,%rsp
  802284:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802287:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80228b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80228f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802293:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802296:	48 89 d6             	mov    %rdx,%rsi
  802299:	89 c7                	mov    %eax,%edi
  80229b:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
  8022a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ae:	78 24                	js     8022d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b4:	8b 00                	mov    (%rax),%eax
  8022b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ba:	48 89 d6             	mov    %rdx,%rsi
  8022bd:	89 c7                	mov    %eax,%edi
  8022bf:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d2:	79 05                	jns    8022d9 <read+0x5d>
		return r;
  8022d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022d7:	eb 76                	jmp    80234f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dd:	8b 40 08             	mov    0x8(%rax),%eax
  8022e0:	83 e0 03             	and    $0x3,%eax
  8022e3:	83 f8 01             	cmp    $0x1,%eax
  8022e6:	75 3a                	jne    802322 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022e8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022ef:	00 00 00 
  8022f2:	48 8b 00             	mov    (%rax),%rax
  8022f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022fe:	89 c6                	mov    %eax,%esi
  802300:	48 bf f7 51 80 00 00 	movabs $0x8051f7,%rdi
  802307:	00 00 00 
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	48 b9 49 05 80 00 00 	movabs $0x800549,%rcx
  802316:	00 00 00 
  802319:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80231b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802320:	eb 2d                	jmp    80234f <read+0xd3>
	}
	if (!dev->dev_read)
  802322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802326:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232a:	48 85 c0             	test   %rax,%rax
  80232d:	75 07                	jne    802336 <read+0xba>
		return -E_NOT_SUPP;
  80232f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802334:	eb 19                	jmp    80234f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80233e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802342:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802346:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80234a:	48 89 cf             	mov    %rcx,%rdi
  80234d:	ff d0                	callq  *%rax
}
  80234f:	c9                   	leaveq 
  802350:	c3                   	retq   

0000000000802351 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802351:	55                   	push   %rbp
  802352:	48 89 e5             	mov    %rsp,%rbp
  802355:	48 83 ec 30          	sub    $0x30,%rsp
  802359:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80235c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802360:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80236b:	eb 49                	jmp    8023b6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80236d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802370:	48 98                	cltq   
  802372:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802376:	48 29 c2             	sub    %rax,%rdx
  802379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237c:	48 63 c8             	movslq %eax,%rcx
  80237f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802383:	48 01 c1             	add    %rax,%rcx
  802386:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802389:	48 89 ce             	mov    %rcx,%rsi
  80238c:	89 c7                	mov    %eax,%edi
  80238e:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  802395:	00 00 00 
  802398:	ff d0                	callq  *%rax
  80239a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80239d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023a1:	79 05                	jns    8023a8 <readn+0x57>
			return m;
  8023a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a6:	eb 1c                	jmp    8023c4 <readn+0x73>
		if (m == 0)
  8023a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023ac:	75 02                	jne    8023b0 <readn+0x5f>
			break;
  8023ae:	eb 11                	jmp    8023c1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b9:	48 98                	cltq   
  8023bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023bf:	72 ac                	jb     80236d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8023c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c4:	c9                   	leaveq 
  8023c5:	c3                   	retq   

00000000008023c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023c6:	55                   	push   %rbp
  8023c7:	48 89 e5             	mov    %rsp,%rbp
  8023ca:	48 83 ec 40          	sub    $0x40,%rsp
  8023ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	78 24                	js     80241e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fe:	8b 00                	mov    (%rax),%eax
  802400:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802404:	48 89 d6             	mov    %rdx,%rsi
  802407:	89 c7                	mov    %eax,%edi
  802409:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  802410:	00 00 00 
  802413:	ff d0                	callq  *%rax
  802415:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802418:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241c:	79 05                	jns    802423 <write+0x5d>
		return r;
  80241e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802421:	eb 75                	jmp    802498 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802427:	8b 40 08             	mov    0x8(%rax),%eax
  80242a:	83 e0 03             	and    $0x3,%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	75 3a                	jne    80246b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802431:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802438:	00 00 00 
  80243b:	48 8b 00             	mov    (%rax),%rax
  80243e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802444:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802447:	89 c6                	mov    %eax,%esi
  802449:	48 bf 13 52 80 00 00 	movabs $0x805213,%rdi
  802450:	00 00 00 
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	48 b9 49 05 80 00 00 	movabs $0x800549,%rcx
  80245f:	00 00 00 
  802462:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802464:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802469:	eb 2d                	jmp    802498 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802473:	48 85 c0             	test   %rax,%rax
  802476:	75 07                	jne    80247f <write+0xb9>
		return -E_NOT_SUPP;
  802478:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80247d:	eb 19                	jmp    802498 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80247f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802483:	48 8b 40 18          	mov    0x18(%rax),%rax
  802487:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80248b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80248f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802493:	48 89 cf             	mov    %rcx,%rdi
  802496:	ff d0                	callq  *%rax
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <seek>:

int
seek(int fdnum, off_t offset)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	48 83 ec 18          	sub    $0x18,%rsp
  8024a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024af:	48 89 d6             	mov    %rdx,%rsi
  8024b2:	89 c7                	mov    %eax,%edi
  8024b4:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8024bb:	00 00 00 
  8024be:	ff d0                	callq  *%rax
  8024c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c7:	79 05                	jns    8024ce <seek+0x34>
		return r;
  8024c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cc:	eb 0f                	jmp    8024dd <seek+0x43>
	fd->fd_offset = offset;
  8024ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dd:	c9                   	leaveq 
  8024de:	c3                   	retq   

00000000008024df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024df:	55                   	push   %rbp
  8024e0:	48 89 e5             	mov    %rsp,%rbp
  8024e3:	48 83 ec 30          	sub    $0x30,%rsp
  8024e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f4:	48 89 d6             	mov    %rdx,%rsi
  8024f7:	89 c7                	mov    %eax,%edi
  8024f9:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  802500:	00 00 00 
  802503:	ff d0                	callq  *%rax
  802505:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802508:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250c:	78 24                	js     802532 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802512:	8b 00                	mov    (%rax),%eax
  802514:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802518:	48 89 d6             	mov    %rdx,%rsi
  80251b:	89 c7                	mov    %eax,%edi
  80251d:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  802524:	00 00 00 
  802527:	ff d0                	callq  *%rax
  802529:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802530:	79 05                	jns    802537 <ftruncate+0x58>
		return r;
  802532:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802535:	eb 72                	jmp    8025a9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253b:	8b 40 08             	mov    0x8(%rax),%eax
  80253e:	83 e0 03             	and    $0x3,%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	75 3a                	jne    80257f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802545:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80254c:	00 00 00 
  80254f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802552:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802558:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255b:	89 c6                	mov    %eax,%esi
  80255d:	48 bf 30 52 80 00 00 	movabs $0x805230,%rdi
  802564:	00 00 00 
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	48 b9 49 05 80 00 00 	movabs $0x800549,%rcx
  802573:	00 00 00 
  802576:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257d:	eb 2a                	jmp    8025a9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80257f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802583:	48 8b 40 30          	mov    0x30(%rax),%rax
  802587:	48 85 c0             	test   %rax,%rax
  80258a:	75 07                	jne    802593 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80258c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802591:	eb 16                	jmp    8025a9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802597:	48 8b 40 30          	mov    0x30(%rax),%rax
  80259b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80259f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025a2:	89 ce                	mov    %ecx,%esi
  8025a4:	48 89 d7             	mov    %rdx,%rdi
  8025a7:	ff d0                	callq  *%rax
}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 30          	sub    $0x30,%rsp
  8025b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025c1:	48 89 d6             	mov    %rdx,%rsi
  8025c4:	89 c7                	mov    %eax,%edi
  8025c6:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
  8025d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d9:	78 24                	js     8025ff <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025df:	8b 00                	mov    (%rax),%eax
  8025e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025e5:	48 89 d6             	mov    %rdx,%rsi
  8025e8:	89 c7                	mov    %eax,%edi
  8025ea:	48 b8 a3 1f 80 00 00 	movabs $0x801fa3,%rax
  8025f1:	00 00 00 
  8025f4:	ff d0                	callq  *%rax
  8025f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025fd:	79 05                	jns    802604 <fstat+0x59>
		return r;
  8025ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802602:	eb 5e                	jmp    802662 <fstat+0xb7>
	if (!dev->dev_stat)
  802604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802608:	48 8b 40 28          	mov    0x28(%rax),%rax
  80260c:	48 85 c0             	test   %rax,%rax
  80260f:	75 07                	jne    802618 <fstat+0x6d>
		return -E_NOT_SUPP;
  802611:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802616:	eb 4a                	jmp    802662 <fstat+0xb7>
	stat->st_name[0] = 0;
  802618:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80261c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80261f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802623:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80262a:	00 00 00 
	stat->st_isdir = 0;
  80262d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802631:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802638:	00 00 00 
	stat->st_dev = dev;
  80263b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80263f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802643:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802656:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80265a:	48 89 ce             	mov    %rcx,%rsi
  80265d:	48 89 d7             	mov    %rdx,%rdi
  802660:	ff d0                	callq  *%rax
}
  802662:	c9                   	leaveq 
  802663:	c3                   	retq   

0000000000802664 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802664:	55                   	push   %rbp
  802665:	48 89 e5             	mov    %rsp,%rbp
  802668:	48 83 ec 20          	sub    $0x20,%rsp
  80266c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802670:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802678:	be 00 00 00 00       	mov    $0x0,%esi
  80267d:	48 89 c7             	mov    %rax,%rdi
  802680:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802687:	00 00 00 
  80268a:	ff d0                	callq  *%rax
  80268c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802693:	79 05                	jns    80269a <stat+0x36>
		return fd;
  802695:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802698:	eb 2f                	jmp    8026c9 <stat+0x65>
	r = fstat(fd, stat);
  80269a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80269e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a1:	48 89 d6             	mov    %rdx,%rsi
  8026a4:	89 c7                	mov    %eax,%edi
  8026a6:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
  8026b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b8:	89 c7                	mov    %eax,%edi
  8026ba:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax
	return r;
  8026c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026c9:	c9                   	leaveq 
  8026ca:	c3                   	retq   

00000000008026cb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026cb:	55                   	push   %rbp
  8026cc:	48 89 e5             	mov    %rsp,%rbp
  8026cf:	48 83 ec 10          	sub    $0x10,%rsp
  8026d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026e1:	00 00 00 
  8026e4:	8b 00                	mov    (%rax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	75 1d                	jne    802707 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ef:	48 b8 ac 4a 80 00 00 	movabs $0x804aac,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
  8026fb:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802702:	00 00 00 
  802705:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802707:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80270e:	00 00 00 
  802711:	8b 00                	mov    (%rax),%eax
  802713:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802716:	b9 07 00 00 00       	mov    $0x7,%ecx
  80271b:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802722:	00 00 00 
  802725:	89 c7                	mov    %eax,%edi
  802727:	48 b8 4a 4a 80 00 00 	movabs $0x804a4a,%rax
  80272e:	00 00 00 
  802731:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802737:	ba 00 00 00 00       	mov    $0x0,%edx
  80273c:	48 89 c6             	mov    %rax,%rsi
  80273f:	bf 00 00 00 00       	mov    $0x0,%edi
  802744:	48 b8 44 49 80 00 00 	movabs $0x804944,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
}
  802750:	c9                   	leaveq 
  802751:	c3                   	retq   

0000000000802752 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 30          	sub    $0x30,%rsp
  80275a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80275e:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802761:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802768:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80276f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802776:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80277b:	75 08                	jne    802785 <open+0x33>
	{
		return r;
  80277d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802780:	e9 f2 00 00 00       	jmpq   802877 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80279b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8027a2:	7e 0a                	jle    8027ae <open+0x5c>
	{
		return -E_BAD_PATH;
  8027a4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027a9:	e9 c9 00 00 00       	jmpq   802877 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8027ae:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027b5:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8027b6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8027ba:	48 89 c7             	mov    %rax,%rdi
  8027bd:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d0:	78 09                	js     8027db <open+0x89>
  8027d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d6:	48 85 c0             	test   %rax,%rax
  8027d9:	75 08                	jne    8027e3 <open+0x91>
		{
			return r;
  8027db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027de:	e9 94 00 00 00       	jmpq   802877 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8027e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e7:	ba 00 04 00 00       	mov    $0x400,%edx
  8027ec:	48 89 c6             	mov    %rax,%rsi
  8027ef:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8027f6:	00 00 00 
  8027f9:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802805:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80280c:	00 00 00 
  80280f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802812:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281c:	48 89 c6             	mov    %rax,%rsi
  80281f:	bf 01 00 00 00       	mov    $0x1,%edi
  802824:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802833:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802837:	79 2b                	jns    802864 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283d:	be 00 00 00 00       	mov    $0x0,%esi
  802842:	48 89 c7             	mov    %rax,%rdi
  802845:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802854:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802858:	79 05                	jns    80285f <open+0x10d>
			{
				return d;
  80285a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80285d:	eb 18                	jmp    802877 <open+0x125>
			}
			return r;
  80285f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802862:	eb 13                	jmp    802877 <open+0x125>
		}	
		return fd2num(fd_store);
  802864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802868:	48 89 c7             	mov    %rax,%rdi
  80286b:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802877:	c9                   	leaveq 
  802878:	c3                   	retq   

0000000000802879 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 10          	sub    $0x10,%rsp
  802881:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802889:	8b 50 0c             	mov    0xc(%rax),%edx
  80288c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802893:	00 00 00 
  802896:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802898:	be 00 00 00 00       	mov    $0x0,%esi
  80289d:	bf 06 00 00 00       	mov    $0x6,%edi
  8028a2:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax
}
  8028ae:	c9                   	leaveq 
  8028af:	c3                   	retq   

00000000008028b0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028b0:	55                   	push   %rbp
  8028b1:	48 89 e5             	mov    %rsp,%rbp
  8028b4:	48 83 ec 30          	sub    $0x30,%rsp
  8028b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8028c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8028cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028d0:	74 07                	je     8028d9 <devfile_read+0x29>
  8028d2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028d7:	75 07                	jne    8028e0 <devfile_read+0x30>
		return -E_INVAL;
  8028d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028de:	eb 77                	jmp    802957 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8028e7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028ee:	00 00 00 
  8028f1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028f3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028fa:	00 00 00 
  8028fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802901:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802905:	be 00 00 00 00       	mov    $0x0,%esi
  80290a:	bf 03 00 00 00       	mov    $0x3,%edi
  80290f:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802922:	7f 05                	jg     802929 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802927:	eb 2e                	jmp    802957 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292c:	48 63 d0             	movslq %eax,%rdx
  80292f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802933:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80293a:	00 00 00 
  80293d:	48 89 c7             	mov    %rax,%rdi
  802940:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802947:	00 00 00 
  80294a:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80294c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802950:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802954:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802957:	c9                   	leaveq 
  802958:	c3                   	retq   

0000000000802959 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802959:	55                   	push   %rbp
  80295a:	48 89 e5             	mov    %rsp,%rbp
  80295d:	48 83 ec 30          	sub    $0x30,%rsp
  802961:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802965:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802969:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80296d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802974:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802979:	74 07                	je     802982 <devfile_write+0x29>
  80297b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802980:	75 08                	jne    80298a <devfile_write+0x31>
		return r;
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802985:	e9 9a 00 00 00       	jmpq   802a24 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	8b 50 0c             	mov    0xc(%rax),%edx
  802991:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802998:	00 00 00 
  80299b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80299d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029a4:	00 
  8029a5:	76 08                	jbe    8029af <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8029a7:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029ae:	00 
	}
	fsipcbuf.write.req_n = n;
  8029af:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029b6:	00 00 00 
  8029b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029bd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8029c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c9:	48 89 c6             	mov    %rax,%rsi
  8029cc:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8029d3:	00 00 00 
  8029d6:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8029e2:	be 00 00 00 00       	mov    $0x0,%esi
  8029e7:	bf 04 00 00 00       	mov    $0x4,%edi
  8029ec:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax
  8029f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ff:	7f 20                	jg     802a21 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802a01:	48 bf 56 52 80 00 00 	movabs $0x805256,%rdi
  802a08:	00 00 00 
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  802a17:	00 00 00 
  802a1a:	ff d2                	callq  *%rdx
		return r;
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1f:	eb 03                	jmp    802a24 <devfile_write+0xcb>
	}
	return r;
  802a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a24:	c9                   	leaveq 
  802a25:	c3                   	retq   

0000000000802a26 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
  802a2a:	48 83 ec 20          	sub    $0x20,%rsp
  802a2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a32:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a3d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a44:	00 00 00 
  802a47:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a49:	be 00 00 00 00       	mov    $0x0,%esi
  802a4e:	bf 05 00 00 00       	mov    $0x5,%edi
  802a53:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	callq  *%rax
  802a5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a66:	79 05                	jns    802a6d <devfile_stat+0x47>
		return r;
  802a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6b:	eb 56                	jmp    802ac3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a71:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802a78:	00 00 00 
  802a7b:	48 89 c7             	mov    %rax,%rdi
  802a7e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a8a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a91:	00 00 00 
  802a94:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802aa4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802aab:	00 00 00 
  802aae:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ab4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ab8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac3:	c9                   	leaveq 
  802ac4:	c3                   	retq   

0000000000802ac5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ac5:	55                   	push   %rbp
  802ac6:	48 89 e5             	mov    %rsp,%rbp
  802ac9:	48 83 ec 10          	sub    $0x10,%rsp
  802acd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ad1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ad8:	8b 50 0c             	mov    0xc(%rax),%edx
  802adb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ae2:	00 00 00 
  802ae5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ae7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802aee:	00 00 00 
  802af1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802af7:	be 00 00 00 00       	mov    $0x0,%esi
  802afc:	bf 02 00 00 00       	mov    $0x2,%edi
  802b01:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
}
  802b0d:	c9                   	leaveq 
  802b0e:	c3                   	retq   

0000000000802b0f <remove>:

// Delete a file
int
remove(const char *path)
{
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
  802b13:	48 83 ec 10          	sub    $0x10,%rsp
  802b17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1f:	48 89 c7             	mov    %rax,%rdi
  802b22:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
  802b2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b33:	7e 07                	jle    802b3c <remove+0x2d>
		return -E_BAD_PATH;
  802b35:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b3a:	eb 33                	jmp    802b6f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b40:	48 89 c6             	mov    %rax,%rsi
  802b43:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802b4a:	00 00 00 
  802b4d:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  802b54:	00 00 00 
  802b57:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b59:	be 00 00 00 00       	mov    $0x0,%esi
  802b5e:	bf 07 00 00 00       	mov    $0x7,%edi
  802b63:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  802b6a:	00 00 00 
  802b6d:	ff d0                	callq  *%rax
}
  802b6f:	c9                   	leaveq 
  802b70:	c3                   	retq   

0000000000802b71 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b71:	55                   	push   %rbp
  802b72:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b75:	be 00 00 00 00       	mov    $0x0,%esi
  802b7a:	bf 08 00 00 00       	mov    $0x8,%edi
  802b7f:	48 b8 cb 26 80 00 00 	movabs $0x8026cb,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
}
  802b8b:	5d                   	pop    %rbp
  802b8c:	c3                   	retq   

0000000000802b8d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b8d:	55                   	push   %rbp
  802b8e:	48 89 e5             	mov    %rsp,%rbp
  802b91:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b98:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b9f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ba6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802bad:	be 00 00 00 00       	mov    $0x0,%esi
  802bb2:	48 89 c7             	mov    %rax,%rdi
  802bb5:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc8:	79 28                	jns    802bf2 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcd:	89 c6                	mov    %eax,%esi
  802bcf:	48 bf 72 52 80 00 00 	movabs $0x805272,%rdi
  802bd6:	00 00 00 
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  802be5:	00 00 00 
  802be8:	ff d2                	callq  *%rdx
		return fd_src;
  802bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bed:	e9 74 01 00 00       	jmpq   802d66 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bf2:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bf9:	be 01 01 00 00       	mov    $0x101,%esi
  802bfe:	48 89 c7             	mov    %rax,%rdi
  802c01:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c14:	79 39                	jns    802c4f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802c16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c19:	89 c6                	mov    %eax,%esi
  802c1b:	48 bf 88 52 80 00 00 	movabs $0x805288,%rdi
  802c22:	00 00 00 
  802c25:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2a:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  802c31:	00 00 00 
  802c34:	ff d2                	callq  *%rdx
		close(fd_src);
  802c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c39:	89 c7                	mov    %eax,%edi
  802c3b:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802c42:	00 00 00 
  802c45:	ff d0                	callq  *%rax
		return fd_dest;
  802c47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c4a:	e9 17 01 00 00       	jmpq   802d66 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c4f:	eb 74                	jmp    802cc5 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c54:	48 63 d0             	movslq %eax,%rdx
  802c57:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c61:	48 89 ce             	mov    %rcx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 c6 23 80 00 00 	movabs $0x8023c6,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c79:	79 4a                	jns    802cc5 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c7b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c7e:	89 c6                	mov    %eax,%esi
  802c80:	48 bf a2 52 80 00 00 	movabs $0x8052a2,%rdi
  802c87:	00 00 00 
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  802c96:	00 00 00 
  802c99:	ff d2                	callq  *%rdx
			close(fd_src);
  802c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9e:	89 c7                	mov    %eax,%edi
  802ca0:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802ca7:	00 00 00 
  802caa:	ff d0                	callq  *%rax
			close(fd_dest);
  802cac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802caf:	89 c7                	mov    %eax,%edi
  802cb1:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
			return write_size;
  802cbd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cc0:	e9 a1 00 00 00       	jmpq   802d66 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cc5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccf:	ba 00 02 00 00       	mov    $0x200,%edx
  802cd4:	48 89 ce             	mov    %rcx,%rsi
  802cd7:	89 c7                	mov    %eax,%edi
  802cd9:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
  802ce5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cec:	0f 8f 5f ff ff ff    	jg     802c51 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cf6:	79 47                	jns    802d3f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cf8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cfb:	89 c6                	mov    %eax,%esi
  802cfd:	48 bf b5 52 80 00 00 	movabs $0x8052b5,%rdi
  802d04:	00 00 00 
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0c:	48 ba 49 05 80 00 00 	movabs $0x800549,%rdx
  802d13:	00 00 00 
  802d16:	ff d2                	callq  *%rdx
		close(fd_src);
  802d18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d1b:	89 c7                	mov    %eax,%edi
  802d1d:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
		close(fd_dest);
  802d29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d2c:	89 c7                	mov    %eax,%edi
  802d2e:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
		return read_size;
  802d3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d3d:	eb 27                	jmp    802d66 <copy+0x1d9>
	}
	close(fd_src);
  802d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d42:	89 c7                	mov    %eax,%edi
  802d44:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
	close(fd_dest);
  802d50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d53:	89 c7                	mov    %eax,%edi
  802d55:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
	return 0;
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d66:	c9                   	leaveq 
  802d67:	c3                   	retq   

0000000000802d68 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802d68:	55                   	push   %rbp
  802d69:	48 89 e5             	mov    %rsp,%rbp
  802d6c:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802d73:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802d7a:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802d81:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802d88:	be 00 00 00 00       	mov    $0x0,%esi
  802d8d:	48 89 c7             	mov    %rax,%rdi
  802d90:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802da3:	79 08                	jns    802dad <spawn+0x45>
		return r;
  802da5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802da8:	e9 14 03 00 00       	jmpq   8030c1 <spawn+0x359>
	fd = r;
  802dad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802db0:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802db3:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802dba:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802dbe:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802dc5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802dc8:	ba 00 02 00 00       	mov    $0x200,%edx
  802dcd:	48 89 ce             	mov    %rcx,%rsi
  802dd0:	89 c7                	mov    %eax,%edi
  802dd2:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  802dd9:	00 00 00 
  802ddc:	ff d0                	callq  *%rax
  802dde:	3d 00 02 00 00       	cmp    $0x200,%eax
  802de3:	75 0d                	jne    802df2 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802de5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de9:	8b 00                	mov    (%rax),%eax
  802deb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802df0:	74 43                	je     802e35 <spawn+0xcd>
		close(fd);
  802df2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802df5:	89 c7                	mov    %eax,%edi
  802df7:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802e03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e07:	8b 00                	mov    (%rax),%eax
  802e09:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802e0e:	89 c6                	mov    %eax,%esi
  802e10:	48 bf d0 52 80 00 00 	movabs $0x8052d0,%rdi
  802e17:	00 00 00 
  802e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1f:	48 b9 49 05 80 00 00 	movabs $0x800549,%rcx
  802e26:	00 00 00 
  802e29:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802e2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e30:	e9 8c 02 00 00       	jmpq   8030c1 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802e35:	b8 07 00 00 00       	mov    $0x7,%eax
  802e3a:	cd 30                	int    $0x30
  802e3c:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802e3f:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802e42:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e45:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e49:	79 08                	jns    802e53 <spawn+0xeb>
		return r;
  802e4b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e4e:	e9 6e 02 00 00       	jmpq   8030c1 <spawn+0x359>
	child = r;
  802e53:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e56:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802e59:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e5c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802e61:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802e68:	00 00 00 
  802e6b:	48 63 d0             	movslq %eax,%rdx
  802e6e:	48 89 d0             	mov    %rdx,%rax
  802e71:	48 c1 e0 03          	shl    $0x3,%rax
  802e75:	48 01 d0             	add    %rdx,%rax
  802e78:	48 c1 e0 05          	shl    $0x5,%rax
  802e7c:	48 01 c8             	add    %rcx,%rax
  802e7f:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e86:	48 89 c6             	mov    %rax,%rsi
  802e89:	b8 18 00 00 00       	mov    $0x18,%eax
  802e8e:	48 89 d7             	mov    %rdx,%rdi
  802e91:	48 89 c1             	mov    %rax,%rcx
  802e94:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802e97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802e9f:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802ea6:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802ead:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802eb4:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802ebb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ebe:	48 89 ce             	mov    %rcx,%rsi
  802ec1:	89 c7                	mov    %eax,%edi
  802ec3:	48 b8 2b 33 80 00 00 	movabs $0x80332b,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
  802ecf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ed2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ed6:	79 08                	jns    802ee0 <spawn+0x178>
		return r;
  802ed8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802edb:	e9 e1 01 00 00       	jmpq   8030c1 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802ee0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee4:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ee8:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802eef:	48 01 d0             	add    %rdx,%rax
  802ef2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ef6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802efd:	e9 a3 00 00 00       	jmpq   802fa5 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f06:	8b 00                	mov    (%rax),%eax
  802f08:	83 f8 01             	cmp    $0x1,%eax
  802f0b:	74 05                	je     802f12 <spawn+0x1aa>
			continue;
  802f0d:	e9 8a 00 00 00       	jmpq   802f9c <spawn+0x234>
		perm = PTE_P | PTE_U;
  802f12:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1d:	8b 40 04             	mov    0x4(%rax),%eax
  802f20:	83 e0 02             	and    $0x2,%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 04                	je     802f2b <spawn+0x1c3>
			perm |= PTE_W;
  802f27:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2f:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802f33:	41 89 c1             	mov    %eax,%r9d
  802f36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3a:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f42:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4a:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802f4e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802f51:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f54:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802f57:	89 3c 24             	mov    %edi,(%rsp)
  802f5a:	89 c7                	mov    %eax,%edi
  802f5c:	48 b8 d4 35 80 00 00 	movabs $0x8035d4,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
  802f68:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f6f:	79 2b                	jns    802f9c <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802f71:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802f72:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
	close(fd);
  802f83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f86:	89 c7                	mov    %eax,%edi
  802f88:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
	return r;
  802f94:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f97:	e9 25 01 00 00       	jmpq   8030c1 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802f9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802fa0:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802fa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa9:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802fad:	0f b7 c0             	movzwl %ax,%eax
  802fb0:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802fb3:	0f 8f 49 ff ff ff    	jg     802f02 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802fb9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fbc:	89 c7                	mov    %eax,%edi
  802fbe:	48 b8 5a 20 80 00 00 	movabs $0x80205a,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
	fd = -1;
  802fca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802fd1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802fd4:	89 c7                	mov    %eax,%edi
  802fd6:	48 b8 c0 37 80 00 00 	movabs $0x8037c0,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
  802fe2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fe5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fe9:	79 30                	jns    80301b <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802feb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fee:	89 c1                	mov    %eax,%ecx
  802ff0:	48 ba ea 52 80 00 00 	movabs $0x8052ea,%rdx
  802ff7:	00 00 00 
  802ffa:	be 82 00 00 00       	mov    $0x82,%esi
  802fff:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  803006:	00 00 00 
  803009:	b8 00 00 00 00       	mov    $0x0,%eax
  80300e:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  803015:	00 00 00 
  803018:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80301b:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803022:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803025:	48 89 d6             	mov    %rdx,%rsi
  803028:	89 c7                	mov    %eax,%edi
  80302a:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
  803036:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803039:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80303d:	79 30                	jns    80306f <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  80303f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803042:	89 c1                	mov    %eax,%ecx
  803044:	48 ba 0c 53 80 00 00 	movabs $0x80530c,%rdx
  80304b:	00 00 00 
  80304e:	be 85 00 00 00       	mov    $0x85,%esi
  803053:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  80305a:	00 00 00 
  80305d:	b8 00 00 00 00       	mov    $0x0,%eax
  803062:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  803069:	00 00 00 
  80306c:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80306f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803072:	be 02 00 00 00       	mov    $0x2,%esi
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 22 1b 80 00 00 	movabs $0x801b22,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
  803085:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803088:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80308c:	79 30                	jns    8030be <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  80308e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803091:	89 c1                	mov    %eax,%ecx
  803093:	48 ba 26 53 80 00 00 	movabs $0x805326,%rdx
  80309a:	00 00 00 
  80309d:	be 88 00 00 00       	mov    $0x88,%esi
  8030a2:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  8030a9:	00 00 00 
  8030ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b1:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  8030b8:	00 00 00 
  8030bb:	41 ff d0             	callq  *%r8

	return child;
  8030be:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8030c1:	c9                   	leaveq 
  8030c2:	c3                   	retq   

00000000008030c3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8030c3:	55                   	push   %rbp
  8030c4:	48 89 e5             	mov    %rsp,%rbp
  8030c7:	41 55                	push   %r13
  8030c9:	41 54                	push   %r12
  8030cb:	53                   	push   %rbx
  8030cc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8030d3:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8030da:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8030e1:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8030e8:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8030ef:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8030f6:	84 c0                	test   %al,%al
  8030f8:	74 26                	je     803120 <spawnl+0x5d>
  8030fa:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803101:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803108:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  80310c:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803110:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803114:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803118:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80311c:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803120:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803127:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  80312e:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803131:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803138:	00 00 00 
  80313b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803142:	00 00 00 
  803145:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803149:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803150:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803157:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  80315e:	eb 07                	jmp    803167 <spawnl+0xa4>
		argc++;
  803160:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803167:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80316d:	83 f8 30             	cmp    $0x30,%eax
  803170:	73 23                	jae    803195 <spawnl+0xd2>
  803172:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803179:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80317f:	89 c0                	mov    %eax,%eax
  803181:	48 01 d0             	add    %rdx,%rax
  803184:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80318a:	83 c2 08             	add    $0x8,%edx
  80318d:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803193:	eb 15                	jmp    8031aa <spawnl+0xe7>
  803195:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80319c:	48 89 d0             	mov    %rdx,%rax
  80319f:	48 83 c2 08          	add    $0x8,%rdx
  8031a3:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8031aa:	48 8b 00             	mov    (%rax),%rax
  8031ad:	48 85 c0             	test   %rax,%rax
  8031b0:	75 ae                	jne    803160 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8031b2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8031b8:	83 c0 02             	add    $0x2,%eax
  8031bb:	48 89 e2             	mov    %rsp,%rdx
  8031be:	48 89 d3             	mov    %rdx,%rbx
  8031c1:	48 63 d0             	movslq %eax,%rdx
  8031c4:	48 83 ea 01          	sub    $0x1,%rdx
  8031c8:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8031cf:	48 63 d0             	movslq %eax,%rdx
  8031d2:	49 89 d4             	mov    %rdx,%r12
  8031d5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8031db:	48 63 d0             	movslq %eax,%rdx
  8031de:	49 89 d2             	mov    %rdx,%r10
  8031e1:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8031e7:	48 98                	cltq   
  8031e9:	48 c1 e0 03          	shl    $0x3,%rax
  8031ed:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8031f1:	b8 10 00 00 00       	mov    $0x10,%eax
  8031f6:	48 83 e8 01          	sub    $0x1,%rax
  8031fa:	48 01 d0             	add    %rdx,%rax
  8031fd:	bf 10 00 00 00       	mov    $0x10,%edi
  803202:	ba 00 00 00 00       	mov    $0x0,%edx
  803207:	48 f7 f7             	div    %rdi
  80320a:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80320e:	48 29 c4             	sub    %rax,%rsp
  803211:	48 89 e0             	mov    %rsp,%rax
  803214:	48 83 c0 07          	add    $0x7,%rax
  803218:	48 c1 e8 03          	shr    $0x3,%rax
  80321c:	48 c1 e0 03          	shl    $0x3,%rax
  803220:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803227:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80322e:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803235:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803238:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80323e:	8d 50 01             	lea    0x1(%rax),%edx
  803241:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803248:	48 63 d2             	movslq %edx,%rdx
  80324b:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803252:	00 

	va_start(vl, arg0);
  803253:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80325a:	00 00 00 
  80325d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803264:	00 00 00 
  803267:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80326b:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803272:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803279:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803280:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803287:	00 00 00 
  80328a:	eb 63                	jmp    8032ef <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80328c:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803292:	8d 70 01             	lea    0x1(%rax),%esi
  803295:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80329b:	83 f8 30             	cmp    $0x30,%eax
  80329e:	73 23                	jae    8032c3 <spawnl+0x200>
  8032a0:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8032a7:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8032ad:	89 c0                	mov    %eax,%eax
  8032af:	48 01 d0             	add    %rdx,%rax
  8032b2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8032b8:	83 c2 08             	add    $0x8,%edx
  8032bb:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8032c1:	eb 15                	jmp    8032d8 <spawnl+0x215>
  8032c3:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8032ca:	48 89 d0             	mov    %rdx,%rax
  8032cd:	48 83 c2 08          	add    $0x8,%rdx
  8032d1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8032d8:	48 8b 08             	mov    (%rax),%rcx
  8032db:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8032e2:	89 f2                	mov    %esi,%edx
  8032e4:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8032e8:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8032ef:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032f5:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8032fb:	77 8f                	ja     80328c <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8032fd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803304:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80330b:	48 89 d6             	mov    %rdx,%rsi
  80330e:	48 89 c7             	mov    %rax,%rdi
  803311:	48 b8 68 2d 80 00 00 	movabs $0x802d68,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
  80331d:	48 89 dc             	mov    %rbx,%rsp
}
  803320:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803324:	5b                   	pop    %rbx
  803325:	41 5c                	pop    %r12
  803327:	41 5d                	pop    %r13
  803329:	5d                   	pop    %rbp
  80332a:	c3                   	retq   

000000000080332b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80332b:	55                   	push   %rbp
  80332c:	48 89 e5             	mov    %rsp,%rbp
  80332f:	48 83 ec 50          	sub    $0x50,%rsp
  803333:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803336:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80333a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80333e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803345:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80334d:	eb 33                	jmp    803382 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80334f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803352:	48 98                	cltq   
  803354:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80335b:	00 
  80335c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803360:	48 01 d0             	add    %rdx,%rax
  803363:	48 8b 00             	mov    (%rax),%rax
  803366:	48 89 c7             	mov    %rax,%rdi
  803369:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	83 c0 01             	add    $0x1,%eax
  803378:	48 98                	cltq   
  80337a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80337e:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803382:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803385:	48 98                	cltq   
  803387:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80338e:	00 
  80338f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803393:	48 01 d0             	add    %rdx,%rax
  803396:	48 8b 00             	mov    (%rax),%rax
  803399:	48 85 c0             	test   %rax,%rax
  80339c:	75 b1                	jne    80334f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80339e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a2:	48 f7 d8             	neg    %rax
  8033a5:	48 05 00 10 40 00    	add    $0x401000,%rax
  8033ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8033af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8033b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033bb:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8033bf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033c2:	83 c2 01             	add    $0x1,%edx
  8033c5:	c1 e2 03             	shl    $0x3,%edx
  8033c8:	48 63 d2             	movslq %edx,%rdx
  8033cb:	48 f7 da             	neg    %rdx
  8033ce:	48 01 d0             	add    %rdx,%rax
  8033d1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8033d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033d9:	48 83 e8 10          	sub    $0x10,%rax
  8033dd:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8033e3:	77 0a                	ja     8033ef <init_stack+0xc4>
		return -E_NO_MEM;
  8033e5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8033ea:	e9 e3 01 00 00       	jmpq   8035d2 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8033ef:	ba 07 00 00 00       	mov    $0x7,%edx
  8033f4:	be 00 00 40 00       	mov    $0x400000,%esi
  8033f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fe:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80340d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803411:	79 08                	jns    80341b <init_stack+0xf0>
		return r;
  803413:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803416:	e9 b7 01 00 00       	jmpq   8035d2 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80341b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803422:	e9 8a 00 00 00       	jmpq   8034b1 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803427:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80342a:	48 98                	cltq   
  80342c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803433:	00 
  803434:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803438:	48 01 c2             	add    %rax,%rdx
  80343b:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803440:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803444:	48 01 c8             	add    %rcx,%rax
  803447:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80344d:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803450:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803453:	48 98                	cltq   
  803455:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80345c:	00 
  80345d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803461:	48 01 d0             	add    %rdx,%rax
  803464:	48 8b 10             	mov    (%rax),%rdx
  803467:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80346b:	48 89 d6             	mov    %rdx,%rsi
  80346e:	48 89 c7             	mov    %rax,%rdi
  803471:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  803478:	00 00 00 
  80347b:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80347d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803480:	48 98                	cltq   
  803482:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803489:	00 
  80348a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80348e:	48 01 d0             	add    %rdx,%rax
  803491:	48 8b 00             	mov    (%rax),%rax
  803494:	48 89 c7             	mov    %rax,%rdi
  803497:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  80349e:	00 00 00 
  8034a1:	ff d0                	callq  *%rax
  8034a3:	48 98                	cltq   
  8034a5:	48 83 c0 01          	add    $0x1,%rax
  8034a9:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8034ad:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8034b1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034b4:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8034b7:	0f 8c 6a ff ff ff    	jl     803427 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8034bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034c0:	48 98                	cltq   
  8034c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8034c9:	00 
  8034ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034ce:	48 01 d0             	add    %rdx,%rax
  8034d1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8034d8:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8034df:	00 
  8034e0:	74 35                	je     803517 <init_stack+0x1ec>
  8034e2:	48 b9 40 53 80 00 00 	movabs $0x805340,%rcx
  8034e9:	00 00 00 
  8034ec:	48 ba 66 53 80 00 00 	movabs $0x805366,%rdx
  8034f3:	00 00 00 
  8034f6:	be f1 00 00 00       	mov    $0xf1,%esi
  8034fb:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  803502:	00 00 00 
  803505:	b8 00 00 00 00       	mov    $0x0,%eax
  80350a:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  803511:	00 00 00 
  803514:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803517:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351b:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80351f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803524:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803528:	48 01 c8             	add    %rcx,%rax
  80352b:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803531:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803534:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803538:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80353c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80353f:	48 98                	cltq   
  803541:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803544:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803549:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354d:	48 01 d0             	add    %rdx,%rax
  803550:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803556:	48 89 c2             	mov    %rax,%rdx
  803559:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80355d:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803560:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803563:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803569:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80356e:	89 c2                	mov    %eax,%edx
  803570:	be 00 00 40 00       	mov    $0x400000,%esi
  803575:	bf 00 00 00 00       	mov    $0x0,%edi
  80357a:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803589:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80358d:	79 02                	jns    803591 <init_stack+0x266>
		goto error;
  80358f:	eb 28                	jmp    8035b9 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803591:	be 00 00 40 00       	mov    $0x400000,%esi
  803596:	bf 00 00 00 00       	mov    $0x0,%edi
  80359b:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
  8035a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ae:	79 02                	jns    8035b2 <init_stack+0x287>
		goto error;
  8035b0:	eb 07                	jmp    8035b9 <init_stack+0x28e>

	return 0;
  8035b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b7:	eb 19                	jmp    8035d2 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8035b9:	be 00 00 40 00       	mov    $0x400000,%esi
  8035be:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c3:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
	return r;
  8035cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035d2:	c9                   	leaveq 
  8035d3:	c3                   	retq   

00000000008035d4 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8035d4:	55                   	push   %rbp
  8035d5:	48 89 e5             	mov    %rsp,%rbp
  8035d8:	48 83 ec 50          	sub    $0x50,%rsp
  8035dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8035e7:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8035ea:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8035ee:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8035f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8035fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803602:	74 21                	je     803625 <map_segment+0x51>
		va -= i;
  803604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803607:	48 98                	cltq   
  803609:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80360d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803610:	48 98                	cltq   
  803612:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803619:	48 98                	cltq   
  80361b:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80361f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803622:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803625:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80362c:	e9 79 01 00 00       	jmpq   8037aa <map_segment+0x1d6>
		if (i >= filesz) {
  803631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803634:	48 98                	cltq   
  803636:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80363a:	72 3c                	jb     803678 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80363c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363f:	48 63 d0             	movslq %eax,%rdx
  803642:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803646:	48 01 d0             	add    %rdx,%rax
  803649:	48 89 c1             	mov    %rax,%rcx
  80364c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80364f:	8b 55 10             	mov    0x10(%rbp),%edx
  803652:	48 89 ce             	mov    %rcx,%rsi
  803655:	89 c7                	mov    %eax,%edi
  803657:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803666:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80366a:	0f 89 33 01 00 00    	jns    8037a3 <map_segment+0x1cf>
				return r;
  803670:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803673:	e9 46 01 00 00       	jmpq   8037be <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803678:	ba 07 00 00 00       	mov    $0x7,%edx
  80367d:	be 00 00 40 00       	mov    $0x400000,%esi
  803682:	bf 00 00 00 00       	mov    $0x0,%edi
  803687:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
  803693:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803696:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80369a:	79 08                	jns    8036a4 <map_segment+0xd0>
				return r;
  80369c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80369f:	e9 1a 01 00 00       	jmpq   8037be <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8036a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a7:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8036aa:	01 c2                	add    %eax,%edx
  8036ac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036af:	89 d6                	mov    %edx,%esi
  8036b1:	89 c7                	mov    %eax,%edi
  8036b3:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  8036ba:	00 00 00 
  8036bd:	ff d0                	callq  *%rax
  8036bf:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8036c2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036c6:	79 08                	jns    8036d0 <map_segment+0xfc>
				return r;
  8036c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036cb:	e9 ee 00 00 00       	jmpq   8037be <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8036d0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8036d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036da:	48 98                	cltq   
  8036dc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036e0:	48 29 c2             	sub    %rax,%rdx
  8036e3:	48 89 d0             	mov    %rdx,%rax
  8036e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8036ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036ed:	48 63 d0             	movslq %eax,%rdx
  8036f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f4:	48 39 c2             	cmp    %rax,%rdx
  8036f7:	48 0f 47 d0          	cmova  %rax,%rdx
  8036fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036fe:	be 00 00 40 00       	mov    $0x400000,%esi
  803703:	89 c7                	mov    %eax,%edi
  803705:	48 b8 51 23 80 00 00 	movabs $0x802351,%rax
  80370c:	00 00 00 
  80370f:	ff d0                	callq  *%rax
  803711:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803714:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803718:	79 08                	jns    803722 <map_segment+0x14e>
				return r;
  80371a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80371d:	e9 9c 00 00 00       	jmpq   8037be <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803725:	48 63 d0             	movslq %eax,%rdx
  803728:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80372c:	48 01 d0             	add    %rdx,%rax
  80372f:	48 89 c2             	mov    %rax,%rdx
  803732:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803735:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803739:	48 89 d1             	mov    %rdx,%rcx
  80373c:	89 c2                	mov    %eax,%edx
  80373e:	be 00 00 40 00       	mov    $0x400000,%esi
  803743:	bf 00 00 00 00       	mov    $0x0,%edi
  803748:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803757:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80375b:	79 30                	jns    80378d <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80375d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803760:	89 c1                	mov    %eax,%ecx
  803762:	48 ba 7b 53 80 00 00 	movabs $0x80537b,%rdx
  803769:	00 00 00 
  80376c:	be 24 01 00 00       	mov    $0x124,%esi
  803771:	48 bf 00 53 80 00 00 	movabs $0x805300,%rdi
  803778:	00 00 00 
  80377b:	b8 00 00 00 00       	mov    $0x0,%eax
  803780:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  803787:	00 00 00 
  80378a:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80378d:	be 00 00 40 00       	mov    $0x400000,%esi
  803792:	bf 00 00 00 00       	mov    $0x0,%edi
  803797:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  80379e:	00 00 00 
  8037a1:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8037a3:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	48 98                	cltq   
  8037af:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037b3:	0f 82 78 fe ff ff    	jb     803631 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8037b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037be:	c9                   	leaveq 
  8037bf:	c3                   	retq   

00000000008037c0 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 20          	sub    $0x20,%rsp
  8037c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8037cb:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8037d2:	00 
  8037d3:	e9 c9 00 00 00       	jmpq   8038a1 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8037d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037dc:	48 c1 e8 27          	shr    $0x27,%rax
  8037e0:	48 89 c2             	mov    %rax,%rdx
  8037e3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8037ea:	01 00 00 
  8037ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037f1:	48 85 c0             	test   %rax,%rax
  8037f4:	74 3c                	je     803832 <copy_shared_pages+0x72>
  8037f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fa:	48 c1 e8 1e          	shr    $0x1e,%rax
  8037fe:	48 89 c2             	mov    %rax,%rdx
  803801:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803808:	01 00 00 
  80380b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80380f:	48 85 c0             	test   %rax,%rax
  803812:	74 1e                	je     803832 <copy_shared_pages+0x72>
  803814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803818:	48 c1 e8 15          	shr    $0x15,%rax
  80381c:	48 89 c2             	mov    %rax,%rdx
  80381f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803826:	01 00 00 
  803829:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80382d:	48 85 c0             	test   %rax,%rax
  803830:	75 02                	jne    803834 <copy_shared_pages+0x74>
                continue;
  803832:	eb 65                	jmp    803899 <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  803834:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803838:	48 c1 e8 0c          	shr    $0xc,%rax
  80383c:	48 89 c2             	mov    %rax,%rdx
  80383f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803846:	01 00 00 
  803849:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80384d:	25 00 04 00 00       	and    $0x400,%eax
  803852:	48 85 c0             	test   %rax,%rax
  803855:	74 42                	je     803899 <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  803857:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385b:	48 c1 e8 0c          	shr    $0xc,%rax
  80385f:	48 89 c2             	mov    %rax,%rdx
  803862:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803869:	01 00 00 
  80386c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803870:	25 07 0e 00 00       	and    $0xe07,%eax
  803875:	89 c6                	mov    %eax,%esi
  803877:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80387b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803882:	41 89 f0             	mov    %esi,%r8d
  803885:	48 89 c6             	mov    %rax,%rsi
  803888:	bf 00 00 00 00       	mov    $0x0,%edi
  80388d:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  803894:	00 00 00 
  803897:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  803899:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8038a0:	00 
  8038a1:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  8038a8:	00 00 00 
  8038ab:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8038af:	0f 86 23 ff ff ff    	jbe    8037d8 <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8038b5:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8038ba:	c9                   	leaveq 
  8038bb:	c3                   	retq   

00000000008038bc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8038bc:	55                   	push   %rbp
  8038bd:	48 89 e5             	mov    %rsp,%rbp
  8038c0:	48 83 ec 20          	sub    $0x20,%rsp
  8038c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8038c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ce:	48 89 d6             	mov    %rdx,%rsi
  8038d1:	89 c7                	mov    %eax,%edi
  8038d3:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
  8038df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e6:	79 05                	jns    8038ed <fd2sockid+0x31>
		return r;
  8038e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038eb:	eb 24                	jmp    803911 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8038ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f1:	8b 10                	mov    (%rax),%edx
  8038f3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8038fa:	00 00 00 
  8038fd:	8b 00                	mov    (%rax),%eax
  8038ff:	39 c2                	cmp    %eax,%edx
  803901:	74 07                	je     80390a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803903:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803908:	eb 07                	jmp    803911 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80390a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803911:	c9                   	leaveq 
  803912:	c3                   	retq   

0000000000803913 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803913:	55                   	push   %rbp
  803914:	48 89 e5             	mov    %rsp,%rbp
  803917:	48 83 ec 20          	sub    $0x20,%rsp
  80391b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80391e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
  803931:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803934:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803938:	78 26                	js     803960 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80393a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393e:	ba 07 04 00 00       	mov    $0x407,%edx
  803943:	48 89 c6             	mov    %rax,%rsi
  803946:	bf 00 00 00 00       	mov    $0x0,%edi
  80394b:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
  803957:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395e:	79 16                	jns    803976 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803960:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803963:	89 c7                	mov    %eax,%edi
  803965:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  80396c:	00 00 00 
  80396f:	ff d0                	callq  *%rax
		return r;
  803971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803974:	eb 3a                	jmp    8039b0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803981:	00 00 00 
  803984:	8b 12                	mov    (%rdx),%edx
  803986:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803997:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80399a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80399d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
}
  8039b0:	c9                   	leaveq 
  8039b1:	c3                   	retq   

00000000008039b2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039b2:	55                   	push   %rbp
  8039b3:	48 89 e5             	mov    %rsp,%rbp
  8039b6:	48 83 ec 30          	sub    $0x30,%rsp
  8039ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c8:	89 c7                	mov    %eax,%edi
  8039ca:	48 b8 bc 38 80 00 00 	movabs $0x8038bc,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039dd:	79 05                	jns    8039e4 <accept+0x32>
		return r;
  8039df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e2:	eb 3b                	jmp    803a1f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8039e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8039e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ef:	48 89 ce             	mov    %rcx,%rsi
  8039f2:	89 c7                	mov    %eax,%edi
  8039f4:	48 b8 fd 3c 80 00 00 	movabs $0x803cfd,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a07:	79 05                	jns    803a0e <accept+0x5c>
		return r;
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0c:	eb 11                	jmp    803a1f <accept+0x6d>
	return alloc_sockfd(r);
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a11:	89 c7                	mov    %eax,%edi
  803a13:	48 b8 13 39 80 00 00 	movabs $0x803913,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax
}
  803a1f:	c9                   	leaveq 
  803a20:	c3                   	retq   

0000000000803a21 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a21:	55                   	push   %rbp
  803a22:	48 89 e5             	mov    %rsp,%rbp
  803a25:	48 83 ec 20          	sub    $0x20,%rsp
  803a29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a30:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a36:	89 c7                	mov    %eax,%edi
  803a38:	48 b8 bc 38 80 00 00 	movabs $0x8038bc,%rax
  803a3f:	00 00 00 
  803a42:	ff d0                	callq  *%rax
  803a44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a4b:	79 05                	jns    803a52 <bind+0x31>
		return r;
  803a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a50:	eb 1b                	jmp    803a6d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803a52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a55:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5c:	48 89 ce             	mov    %rcx,%rsi
  803a5f:	89 c7                	mov    %eax,%edi
  803a61:	48 b8 7c 3d 80 00 00 	movabs $0x803d7c,%rax
  803a68:	00 00 00 
  803a6b:	ff d0                	callq  *%rax
}
  803a6d:	c9                   	leaveq 
  803a6e:	c3                   	retq   

0000000000803a6f <shutdown>:

int
shutdown(int s, int how)
{
  803a6f:	55                   	push   %rbp
  803a70:	48 89 e5             	mov    %rsp,%rbp
  803a73:	48 83 ec 20          	sub    $0x20,%rsp
  803a77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a7a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a80:	89 c7                	mov    %eax,%edi
  803a82:	48 b8 bc 38 80 00 00 	movabs $0x8038bc,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
  803a8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a95:	79 05                	jns    803a9c <shutdown+0x2d>
		return r;
  803a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9a:	eb 16                	jmp    803ab2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803a9c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa2:	89 d6                	mov    %edx,%esi
  803aa4:	89 c7                	mov    %eax,%edi
  803aa6:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
}
  803ab2:	c9                   	leaveq 
  803ab3:	c3                   	retq   

0000000000803ab4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803ab4:	55                   	push   %rbp
  803ab5:	48 89 e5             	mov    %rsp,%rbp
  803ab8:	48 83 ec 10          	sub    $0x10,%rsp
  803abc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803ac0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac4:	48 89 c7             	mov    %rax,%rdi
  803ac7:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
  803ad3:	83 f8 01             	cmp    $0x1,%eax
  803ad6:	75 17                	jne    803aef <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803ad8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803adc:	8b 40 0c             	mov    0xc(%rax),%eax
  803adf:	89 c7                	mov    %eax,%edi
  803ae1:	48 b8 20 3e 80 00 00 	movabs $0x803e20,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
  803aed:	eb 05                	jmp    803af4 <devsock_close+0x40>
	else
		return 0;
  803aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af4:	c9                   	leaveq 
  803af5:	c3                   	retq   

0000000000803af6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803af6:	55                   	push   %rbp
  803af7:	48 89 e5             	mov    %rsp,%rbp
  803afa:	48 83 ec 20          	sub    $0x20,%rsp
  803afe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b05:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b0b:	89 c7                	mov    %eax,%edi
  803b0d:	48 b8 bc 38 80 00 00 	movabs $0x8038bc,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
  803b19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b20:	79 05                	jns    803b27 <connect+0x31>
		return r;
  803b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b25:	eb 1b                	jmp    803b42 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803b27:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b2a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b31:	48 89 ce             	mov    %rcx,%rsi
  803b34:	89 c7                	mov    %eax,%edi
  803b36:	48 b8 4d 3e 80 00 00 	movabs $0x803e4d,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
}
  803b42:	c9                   	leaveq 
  803b43:	c3                   	retq   

0000000000803b44 <listen>:

int
listen(int s, int backlog)
{
  803b44:	55                   	push   %rbp
  803b45:	48 89 e5             	mov    %rsp,%rbp
  803b48:	48 83 ec 20          	sub    $0x20,%rsp
  803b4c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b4f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b55:	89 c7                	mov    %eax,%edi
  803b57:	48 b8 bc 38 80 00 00 	movabs $0x8038bc,%rax
  803b5e:	00 00 00 
  803b61:	ff d0                	callq  *%rax
  803b63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6a:	79 05                	jns    803b71 <listen+0x2d>
		return r;
  803b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6f:	eb 16                	jmp    803b87 <listen+0x43>
	return nsipc_listen(r, backlog);
  803b71:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b77:	89 d6                	mov    %edx,%esi
  803b79:	89 c7                	mov    %eax,%edi
  803b7b:	48 b8 b1 3e 80 00 00 	movabs $0x803eb1,%rax
  803b82:	00 00 00 
  803b85:	ff d0                	callq  *%rax
}
  803b87:	c9                   	leaveq 
  803b88:	c3                   	retq   

0000000000803b89 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803b89:	55                   	push   %rbp
  803b8a:	48 89 e5             	mov    %rsp,%rbp
  803b8d:	48 83 ec 20          	sub    $0x20,%rsp
  803b91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b99:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba1:	89 c2                	mov    %eax,%edx
  803ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba7:	8b 40 0c             	mov    0xc(%rax),%eax
  803baa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803bae:	b9 00 00 00 00       	mov    $0x0,%ecx
  803bb3:	89 c7                	mov    %eax,%edi
  803bb5:	48 b8 f1 3e 80 00 00 	movabs $0x803ef1,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
}
  803bc1:	c9                   	leaveq 
  803bc2:	c3                   	retq   

0000000000803bc3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803bc3:	55                   	push   %rbp
  803bc4:	48 89 e5             	mov    %rsp,%rbp
  803bc7:	48 83 ec 20          	sub    $0x20,%rsp
  803bcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803bcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bd3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bdb:	89 c2                	mov    %eax,%edx
  803bdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be1:	8b 40 0c             	mov    0xc(%rax),%eax
  803be4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803be8:	b9 00 00 00 00       	mov    $0x0,%ecx
  803bed:	89 c7                	mov    %eax,%edi
  803bef:	48 b8 bd 3f 80 00 00 	movabs $0x803fbd,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
}
  803bfb:	c9                   	leaveq 
  803bfc:	c3                   	retq   

0000000000803bfd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803bfd:	55                   	push   %rbp
  803bfe:	48 89 e5             	mov    %rsp,%rbp
  803c01:	48 83 ec 10          	sub    $0x10,%rsp
  803c05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c11:	48 be 9d 53 80 00 00 	movabs $0x80539d,%rsi
  803c18:	00 00 00 
  803c1b:	48 89 c7             	mov    %rax,%rdi
  803c1e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
	return 0;
  803c2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2f:	c9                   	leaveq 
  803c30:	c3                   	retq   

0000000000803c31 <socket>:

int
socket(int domain, int type, int protocol)
{
  803c31:	55                   	push   %rbp
  803c32:	48 89 e5             	mov    %rsp,%rbp
  803c35:	48 83 ec 20          	sub    $0x20,%rsp
  803c39:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c3c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c3f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803c42:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803c45:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c48:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4b:	89 ce                	mov    %ecx,%esi
  803c4d:	89 c7                	mov    %eax,%edi
  803c4f:	48 b8 75 40 80 00 00 	movabs $0x804075,%rax
  803c56:	00 00 00 
  803c59:	ff d0                	callq  *%rax
  803c5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c62:	79 05                	jns    803c69 <socket+0x38>
		return r;
  803c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c67:	eb 11                	jmp    803c7a <socket+0x49>
	return alloc_sockfd(r);
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	89 c7                	mov    %eax,%edi
  803c6e:	48 b8 13 39 80 00 00 	movabs $0x803913,%rax
  803c75:	00 00 00 
  803c78:	ff d0                	callq  *%rax
}
  803c7a:	c9                   	leaveq 
  803c7b:	c3                   	retq   

0000000000803c7c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803c7c:	55                   	push   %rbp
  803c7d:	48 89 e5             	mov    %rsp,%rbp
  803c80:	48 83 ec 10          	sub    $0x10,%rsp
  803c84:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803c87:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803c8e:	00 00 00 
  803c91:	8b 00                	mov    (%rax),%eax
  803c93:	85 c0                	test   %eax,%eax
  803c95:	75 1d                	jne    803cb4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803c97:	bf 02 00 00 00       	mov    $0x2,%edi
  803c9c:	48 b8 ac 4a 80 00 00 	movabs $0x804aac,%rax
  803ca3:	00 00 00 
  803ca6:	ff d0                	callq  *%rax
  803ca8:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803caf:	00 00 00 
  803cb2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803cb4:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803cbb:	00 00 00 
  803cbe:	8b 00                	mov    (%rax),%eax
  803cc0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803cc3:	b9 07 00 00 00       	mov    $0x7,%ecx
  803cc8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803ccf:	00 00 00 
  803cd2:	89 c7                	mov    %eax,%edi
  803cd4:	48 b8 4a 4a 80 00 00 	movabs $0x804a4a,%rax
  803cdb:	00 00 00 
  803cde:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce5:	be 00 00 00 00       	mov    $0x0,%esi
  803cea:	bf 00 00 00 00       	mov    $0x0,%edi
  803cef:	48 b8 44 49 80 00 00 	movabs $0x804944,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
}
  803cfb:	c9                   	leaveq 
  803cfc:	c3                   	retq   

0000000000803cfd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803cfd:	55                   	push   %rbp
  803cfe:	48 89 e5             	mov    %rsp,%rbp
  803d01:	48 83 ec 30          	sub    $0x30,%rsp
  803d05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803d10:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d17:	00 00 00 
  803d1a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d1d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803d1f:	bf 01 00 00 00       	mov    $0x1,%edi
  803d24:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803d2b:	00 00 00 
  803d2e:	ff d0                	callq  *%rax
  803d30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d37:	78 3e                	js     803d77 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803d39:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d40:	00 00 00 
  803d43:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803d47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d4b:	8b 40 10             	mov    0x10(%rax),%eax
  803d4e:	89 c2                	mov    %eax,%edx
  803d50:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803d54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d58:	48 89 ce             	mov    %rcx,%rsi
  803d5b:	48 89 c7             	mov    %rax,%rdi
  803d5e:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803d65:	00 00 00 
  803d68:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6e:	8b 50 10             	mov    0x10(%rax),%edx
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803d77:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d7a:	c9                   	leaveq 
  803d7b:	c3                   	retq   

0000000000803d7c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d7c:	55                   	push   %rbp
  803d7d:	48 89 e5             	mov    %rsp,%rbp
  803d80:	48 83 ec 10          	sub    $0x10,%rsp
  803d84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d8b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803d8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d95:	00 00 00 
  803d98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d9b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803d9d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da4:	48 89 c6             	mov    %rax,%rsi
  803da7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803dae:	00 00 00 
  803db1:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803dbd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dc4:	00 00 00 
  803dc7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dca:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803dcd:	bf 02 00 00 00       	mov    $0x2,%edi
  803dd2:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
}
  803dde:	c9                   	leaveq 
  803ddf:	c3                   	retq   

0000000000803de0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803de0:	55                   	push   %rbp
  803de1:	48 89 e5             	mov    %rsp,%rbp
  803de4:	48 83 ec 10          	sub    $0x10,%rsp
  803de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803deb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803dee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df5:	00 00 00 
  803df8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803dfb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803dfd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e04:	00 00 00 
  803e07:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e0a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803e0d:	bf 03 00 00 00       	mov    $0x3,%edi
  803e12:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803e19:	00 00 00 
  803e1c:	ff d0                	callq  *%rax
}
  803e1e:	c9                   	leaveq 
  803e1f:	c3                   	retq   

0000000000803e20 <nsipc_close>:

int
nsipc_close(int s)
{
  803e20:	55                   	push   %rbp
  803e21:	48 89 e5             	mov    %rsp,%rbp
  803e24:	48 83 ec 10          	sub    $0x10,%rsp
  803e28:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803e2b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e32:	00 00 00 
  803e35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e38:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803e3a:	bf 04 00 00 00       	mov    $0x4,%edi
  803e3f:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803e46:	00 00 00 
  803e49:	ff d0                	callq  *%rax
}
  803e4b:	c9                   	leaveq 
  803e4c:	c3                   	retq   

0000000000803e4d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e4d:	55                   	push   %rbp
  803e4e:	48 89 e5             	mov    %rsp,%rbp
  803e51:	48 83 ec 10          	sub    $0x10,%rsp
  803e55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e5c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803e5f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e66:	00 00 00 
  803e69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e6c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803e6e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e75:	48 89 c6             	mov    %rax,%rsi
  803e78:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803e7f:	00 00 00 
  803e82:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803e8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e95:	00 00 00 
  803e98:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e9b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803e9e:	bf 05 00 00 00       	mov    $0x5,%edi
  803ea3:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803eaa:	00 00 00 
  803ead:	ff d0                	callq  *%rax
}
  803eaf:	c9                   	leaveq 
  803eb0:	c3                   	retq   

0000000000803eb1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803eb1:	55                   	push   %rbp
  803eb2:	48 89 e5             	mov    %rsp,%rbp
  803eb5:	48 83 ec 10          	sub    $0x10,%rsp
  803eb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ebc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803ebf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ec6:	00 00 00 
  803ec9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ecc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803ece:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed5:	00 00 00 
  803ed8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803edb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ede:	bf 06 00 00 00       	mov    $0x6,%edi
  803ee3:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803eea:	00 00 00 
  803eed:	ff d0                	callq  *%rax
}
  803eef:	c9                   	leaveq 
  803ef0:	c3                   	retq   

0000000000803ef1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803ef1:	55                   	push   %rbp
  803ef2:	48 89 e5             	mov    %rsp,%rbp
  803ef5:	48 83 ec 30          	sub    $0x30,%rsp
  803ef9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803efc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f00:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803f03:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803f06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f0d:	00 00 00 
  803f10:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f13:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803f15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f1c:	00 00 00 
  803f1f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f22:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803f25:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f2c:	00 00 00 
  803f2f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f32:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803f35:	bf 07 00 00 00       	mov    $0x7,%edi
  803f3a:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803f41:	00 00 00 
  803f44:	ff d0                	callq  *%rax
  803f46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f4d:	78 69                	js     803fb8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803f4f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803f56:	7f 08                	jg     803f60 <nsipc_recv+0x6f>
  803f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803f5e:	7e 35                	jle    803f95 <nsipc_recv+0xa4>
  803f60:	48 b9 a4 53 80 00 00 	movabs $0x8053a4,%rcx
  803f67:	00 00 00 
  803f6a:	48 ba b9 53 80 00 00 	movabs $0x8053b9,%rdx
  803f71:	00 00 00 
  803f74:	be 61 00 00 00       	mov    $0x61,%esi
  803f79:	48 bf ce 53 80 00 00 	movabs $0x8053ce,%rdi
  803f80:	00 00 00 
  803f83:	b8 00 00 00 00       	mov    $0x0,%eax
  803f88:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  803f8f:	00 00 00 
  803f92:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803f95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f98:	48 63 d0             	movslq %eax,%rdx
  803f9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f9f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803fa6:	00 00 00 
  803fa9:	48 89 c7             	mov    %rax,%rdi
  803fac:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803fb3:	00 00 00 
  803fb6:	ff d0                	callq  *%rax
	}

	return r;
  803fb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fbb:	c9                   	leaveq 
  803fbc:	c3                   	retq   

0000000000803fbd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803fbd:	55                   	push   %rbp
  803fbe:	48 89 e5             	mov    %rsp,%rbp
  803fc1:	48 83 ec 20          	sub    $0x20,%rsp
  803fc5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803fcc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803fcf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803fd2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fd9:	00 00 00 
  803fdc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fdf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803fe1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803fe8:	7e 35                	jle    80401f <nsipc_send+0x62>
  803fea:	48 b9 da 53 80 00 00 	movabs $0x8053da,%rcx
  803ff1:	00 00 00 
  803ff4:	48 ba b9 53 80 00 00 	movabs $0x8053b9,%rdx
  803ffb:	00 00 00 
  803ffe:	be 6c 00 00 00       	mov    $0x6c,%esi
  804003:	48 bf ce 53 80 00 00 	movabs $0x8053ce,%rdi
  80400a:	00 00 00 
  80400d:	b8 00 00 00 00       	mov    $0x0,%eax
  804012:	49 b8 10 03 80 00 00 	movabs $0x800310,%r8
  804019:	00 00 00 
  80401c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80401f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804022:	48 63 d0             	movslq %eax,%rdx
  804025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804029:	48 89 c6             	mov    %rax,%rsi
  80402c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804033:	00 00 00 
  804036:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  80403d:	00 00 00 
  804040:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804042:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804049:	00 00 00 
  80404c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80404f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804052:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804059:	00 00 00 
  80405c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80405f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804062:	bf 08 00 00 00       	mov    $0x8,%edi
  804067:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
}
  804073:	c9                   	leaveq 
  804074:	c3                   	retq   

0000000000804075 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804075:	55                   	push   %rbp
  804076:	48 89 e5             	mov    %rsp,%rbp
  804079:	48 83 ec 10          	sub    $0x10,%rsp
  80407d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804080:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804083:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804086:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80408d:	00 00 00 
  804090:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804093:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804095:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80409c:	00 00 00 
  80409f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040a2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8040a5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040ac:	00 00 00 
  8040af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8040b2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8040b5:	bf 09 00 00 00       	mov    $0x9,%edi
  8040ba:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  8040c1:	00 00 00 
  8040c4:	ff d0                	callq  *%rax
}
  8040c6:	c9                   	leaveq 
  8040c7:	c3                   	retq   

00000000008040c8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8040c8:	55                   	push   %rbp
  8040c9:	48 89 e5             	mov    %rsp,%rbp
  8040cc:	53                   	push   %rbx
  8040cd:	48 83 ec 38          	sub    $0x38,%rsp
  8040d1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8040d5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8040d9:	48 89 c7             	mov    %rax,%rdi
  8040dc:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040ef:	0f 88 bf 01 00 00    	js     8042b4 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8040fe:	48 89 c6             	mov    %rax,%rsi
  804101:	bf 00 00 00 00       	mov    $0x0,%edi
  804106:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  80410d:	00 00 00 
  804110:	ff d0                	callq  *%rax
  804112:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804115:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804119:	0f 88 95 01 00 00    	js     8042b4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80411f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804123:	48 89 c7             	mov    %rax,%rdi
  804126:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  80412d:	00 00 00 
  804130:	ff d0                	callq  *%rax
  804132:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804135:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804139:	0f 88 5d 01 00 00    	js     80429c <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80413f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804143:	ba 07 04 00 00       	mov    $0x407,%edx
  804148:	48 89 c6             	mov    %rax,%rsi
  80414b:	bf 00 00 00 00       	mov    $0x0,%edi
  804150:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804157:	00 00 00 
  80415a:	ff d0                	callq  *%rax
  80415c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80415f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804163:	0f 88 33 01 00 00    	js     80429c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804169:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80416d:	48 89 c7             	mov    %rax,%rdi
  804170:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  804177:	00 00 00 
  80417a:	ff d0                	callq  *%rax
  80417c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804180:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804184:	ba 07 04 00 00       	mov    $0x407,%edx
  804189:	48 89 c6             	mov    %rax,%rsi
  80418c:	bf 00 00 00 00       	mov    $0x0,%edi
  804191:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804198:	00 00 00 
  80419b:	ff d0                	callq  *%rax
  80419d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041a4:	79 05                	jns    8041ab <pipe+0xe3>
		goto err2;
  8041a6:	e9 d9 00 00 00       	jmpq   804284 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041af:	48 89 c7             	mov    %rax,%rdi
  8041b2:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  8041b9:	00 00 00 
  8041bc:	ff d0                	callq  *%rax
  8041be:	48 89 c2             	mov    %rax,%rdx
  8041c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c5:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8041cb:	48 89 d1             	mov    %rdx,%rcx
  8041ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8041d3:	48 89 c6             	mov    %rax,%rsi
  8041d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8041db:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8041e2:	00 00 00 
  8041e5:	ff d0                	callq  *%rax
  8041e7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041ee:	79 1b                	jns    80420b <pipe+0x143>
		goto err3;
  8041f0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8041f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041f5:	48 89 c6             	mov    %rax,%rsi
  8041f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8041fd:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  804204:	00 00 00 
  804207:	ff d0                	callq  *%rax
  804209:	eb 79                	jmp    804284 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80420b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80420f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804216:	00 00 00 
  804219:	8b 12                	mov    (%rdx),%edx
  80421b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80421d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804221:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804228:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80422c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804233:	00 00 00 
  804236:	8b 12                	mov    (%rdx),%edx
  804238:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80423a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80423e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804249:	48 89 c7             	mov    %rax,%rdi
  80424c:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  804253:	00 00 00 
  804256:	ff d0                	callq  *%rax
  804258:	89 c2                	mov    %eax,%edx
  80425a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80425e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804260:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804264:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804268:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80426c:	48 89 c7             	mov    %rax,%rdi
  80426f:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  804276:	00 00 00 
  804279:	ff d0                	callq  *%rax
  80427b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80427d:	b8 00 00 00 00       	mov    $0x0,%eax
  804282:	eb 33                	jmp    8042b7 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804284:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804288:	48 89 c6             	mov    %rax,%rsi
  80428b:	bf 00 00 00 00       	mov    $0x0,%edi
  804290:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  804297:	00 00 00 
  80429a:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80429c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a0:	48 89 c6             	mov    %rax,%rsi
  8042a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042a8:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  8042af:	00 00 00 
  8042b2:	ff d0                	callq  *%rax
err:
	return r;
  8042b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8042b7:	48 83 c4 38          	add    $0x38,%rsp
  8042bb:	5b                   	pop    %rbx
  8042bc:	5d                   	pop    %rbp
  8042bd:	c3                   	retq   

00000000008042be <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8042be:	55                   	push   %rbp
  8042bf:	48 89 e5             	mov    %rsp,%rbp
  8042c2:	53                   	push   %rbx
  8042c3:	48 83 ec 28          	sub    $0x28,%rsp
  8042c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8042cf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8042d6:	00 00 00 
  8042d9:	48 8b 00             	mov    (%rax),%rax
  8042dc:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8042e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8042e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042e9:	48 89 c7             	mov    %rax,%rdi
  8042ec:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  8042f3:	00 00 00 
  8042f6:	ff d0                	callq  *%rax
  8042f8:	89 c3                	mov    %eax,%ebx
  8042fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042fe:	48 89 c7             	mov    %rax,%rdi
  804301:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  804308:	00 00 00 
  80430b:	ff d0                	callq  *%rax
  80430d:	39 c3                	cmp    %eax,%ebx
  80430f:	0f 94 c0             	sete   %al
  804312:	0f b6 c0             	movzbl %al,%eax
  804315:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804318:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80431f:	00 00 00 
  804322:	48 8b 00             	mov    (%rax),%rax
  804325:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80432b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80432e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804331:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804334:	75 05                	jne    80433b <_pipeisclosed+0x7d>
			return ret;
  804336:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804339:	eb 4f                	jmp    80438a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80433b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804341:	74 42                	je     804385 <_pipeisclosed+0xc7>
  804343:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804347:	75 3c                	jne    804385 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804349:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804350:	00 00 00 
  804353:	48 8b 00             	mov    (%rax),%rax
  804356:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80435c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80435f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804362:	89 c6                	mov    %eax,%esi
  804364:	48 bf eb 53 80 00 00 	movabs $0x8053eb,%rdi
  80436b:	00 00 00 
  80436e:	b8 00 00 00 00       	mov    $0x0,%eax
  804373:	49 b8 49 05 80 00 00 	movabs $0x800549,%r8
  80437a:	00 00 00 
  80437d:	41 ff d0             	callq  *%r8
	}
  804380:	e9 4a ff ff ff       	jmpq   8042cf <_pipeisclosed+0x11>
  804385:	e9 45 ff ff ff       	jmpq   8042cf <_pipeisclosed+0x11>
}
  80438a:	48 83 c4 28          	add    $0x28,%rsp
  80438e:	5b                   	pop    %rbx
  80438f:	5d                   	pop    %rbp
  804390:	c3                   	retq   

0000000000804391 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804391:	55                   	push   %rbp
  804392:	48 89 e5             	mov    %rsp,%rbp
  804395:	48 83 ec 30          	sub    $0x30,%rsp
  804399:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80439c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8043a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8043a3:	48 89 d6             	mov    %rdx,%rsi
  8043a6:	89 c7                	mov    %eax,%edi
  8043a8:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  8043af:	00 00 00 
  8043b2:	ff d0                	callq  *%rax
  8043b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043bb:	79 05                	jns    8043c2 <pipeisclosed+0x31>
		return r;
  8043bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c0:	eb 31                	jmp    8043f3 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8043c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043c6:	48 89 c7             	mov    %rax,%rdi
  8043c9:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  8043d0:	00 00 00 
  8043d3:	ff d0                	callq  *%rax
  8043d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8043d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043dd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043e1:	48 89 d6             	mov    %rdx,%rsi
  8043e4:	48 89 c7             	mov    %rax,%rdi
  8043e7:	48 b8 be 42 80 00 00 	movabs $0x8042be,%rax
  8043ee:	00 00 00 
  8043f1:	ff d0                	callq  *%rax
}
  8043f3:	c9                   	leaveq 
  8043f4:	c3                   	retq   

00000000008043f5 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8043f5:	55                   	push   %rbp
  8043f6:	48 89 e5             	mov    %rsp,%rbp
  8043f9:	48 83 ec 40          	sub    $0x40,%rsp
  8043fd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804401:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804405:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80440d:	48 89 c7             	mov    %rax,%rdi
  804410:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  804417:	00 00 00 
  80441a:	ff d0                	callq  *%rax
  80441c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804420:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804424:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804428:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80442f:	00 
  804430:	e9 92 00 00 00       	jmpq   8044c7 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804435:	eb 41                	jmp    804478 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804437:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80443c:	74 09                	je     804447 <devpipe_read+0x52>
				return i;
  80443e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804442:	e9 92 00 00 00       	jmpq   8044d9 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804447:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80444b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80444f:	48 89 d6             	mov    %rdx,%rsi
  804452:	48 89 c7             	mov    %rax,%rdi
  804455:	48 b8 be 42 80 00 00 	movabs $0x8042be,%rax
  80445c:	00 00 00 
  80445f:	ff d0                	callq  *%rax
  804461:	85 c0                	test   %eax,%eax
  804463:	74 07                	je     80446c <devpipe_read+0x77>
				return 0;
  804465:	b8 00 00 00 00       	mov    $0x0,%eax
  80446a:	eb 6d                	jmp    8044d9 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80446c:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804473:	00 00 00 
  804476:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447c:	8b 10                	mov    (%rax),%edx
  80447e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804482:	8b 40 04             	mov    0x4(%rax),%eax
  804485:	39 c2                	cmp    %eax,%edx
  804487:	74 ae                	je     804437 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804491:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804499:	8b 00                	mov    (%rax),%eax
  80449b:	99                   	cltd   
  80449c:	c1 ea 1b             	shr    $0x1b,%edx
  80449f:	01 d0                	add    %edx,%eax
  8044a1:	83 e0 1f             	and    $0x1f,%eax
  8044a4:	29 d0                	sub    %edx,%eax
  8044a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044aa:	48 98                	cltq   
  8044ac:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8044b1:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8044b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b7:	8b 00                	mov    (%rax),%eax
  8044b9:	8d 50 01             	lea    0x1(%rax),%edx
  8044bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c0:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8044c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044cb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044cf:	0f 82 60 ff ff ff    	jb     804435 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8044d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8044d9:	c9                   	leaveq 
  8044da:	c3                   	retq   

00000000008044db <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044db:	55                   	push   %rbp
  8044dc:	48 89 e5             	mov    %rsp,%rbp
  8044df:	48 83 ec 40          	sub    $0x40,%rsp
  8044e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8044ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044f3:	48 89 c7             	mov    %rax,%rdi
  8044f6:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  8044fd:	00 00 00 
  804500:	ff d0                	callq  *%rax
  804502:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804506:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80450a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80450e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804515:	00 
  804516:	e9 8e 00 00 00       	jmpq   8045a9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80451b:	eb 31                	jmp    80454e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80451d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804525:	48 89 d6             	mov    %rdx,%rsi
  804528:	48 89 c7             	mov    %rax,%rdi
  80452b:	48 b8 be 42 80 00 00 	movabs $0x8042be,%rax
  804532:	00 00 00 
  804535:	ff d0                	callq  *%rax
  804537:	85 c0                	test   %eax,%eax
  804539:	74 07                	je     804542 <devpipe_write+0x67>
				return 0;
  80453b:	b8 00 00 00 00       	mov    $0x0,%eax
  804540:	eb 79                	jmp    8045bb <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804542:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804549:	00 00 00 
  80454c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80454e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804552:	8b 40 04             	mov    0x4(%rax),%eax
  804555:	48 63 d0             	movslq %eax,%rdx
  804558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80455c:	8b 00                	mov    (%rax),%eax
  80455e:	48 98                	cltq   
  804560:	48 83 c0 20          	add    $0x20,%rax
  804564:	48 39 c2             	cmp    %rax,%rdx
  804567:	73 b4                	jae    80451d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456d:	8b 40 04             	mov    0x4(%rax),%eax
  804570:	99                   	cltd   
  804571:	c1 ea 1b             	shr    $0x1b,%edx
  804574:	01 d0                	add    %edx,%eax
  804576:	83 e0 1f             	and    $0x1f,%eax
  804579:	29 d0                	sub    %edx,%eax
  80457b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80457f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804583:	48 01 ca             	add    %rcx,%rdx
  804586:	0f b6 0a             	movzbl (%rdx),%ecx
  804589:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80458d:	48 98                	cltq   
  80458f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804597:	8b 40 04             	mov    0x4(%rax),%eax
  80459a:	8d 50 01             	lea    0x1(%rax),%edx
  80459d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045a1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8045a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ad:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045b1:	0f 82 64 ff ff ff    	jb     80451b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8045b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045bb:	c9                   	leaveq 
  8045bc:	c3                   	retq   

00000000008045bd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8045bd:	55                   	push   %rbp
  8045be:	48 89 e5             	mov    %rsp,%rbp
  8045c1:	48 83 ec 20          	sub    $0x20,%rsp
  8045c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8045cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045d1:	48 89 c7             	mov    %rax,%rdi
  8045d4:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  8045db:	00 00 00 
  8045de:	ff d0                	callq  *%rax
  8045e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8045e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045e8:	48 be fe 53 80 00 00 	movabs $0x8053fe,%rsi
  8045ef:	00 00 00 
  8045f2:	48 89 c7             	mov    %rax,%rdi
  8045f5:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  8045fc:	00 00 00 
  8045ff:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804605:	8b 50 04             	mov    0x4(%rax),%edx
  804608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80460c:	8b 00                	mov    (%rax),%eax
  80460e:	29 c2                	sub    %eax,%edx
  804610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804614:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80461a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80461e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804625:	00 00 00 
	stat->st_dev = &devpipe;
  804628:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80462c:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804633:	00 00 00 
  804636:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80463d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804642:	c9                   	leaveq 
  804643:	c3                   	retq   

0000000000804644 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804644:	55                   	push   %rbp
  804645:	48 89 e5             	mov    %rsp,%rbp
  804648:	48 83 ec 10          	sub    $0x10,%rsp
  80464c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804654:	48 89 c6             	mov    %rax,%rsi
  804657:	bf 00 00 00 00       	mov    $0x0,%edi
  80465c:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  804663:	00 00 00 
  804666:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466c:	48 89 c7             	mov    %rax,%rdi
  80466f:	48 b8 87 1d 80 00 00 	movabs $0x801d87,%rax
  804676:	00 00 00 
  804679:	ff d0                	callq  *%rax
  80467b:	48 89 c6             	mov    %rax,%rsi
  80467e:	bf 00 00 00 00       	mov    $0x0,%edi
  804683:	48 b8 d8 1a 80 00 00 	movabs $0x801ad8,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
}
  80468f:	c9                   	leaveq 
  804690:	c3                   	retq   

0000000000804691 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804691:	55                   	push   %rbp
  804692:	48 89 e5             	mov    %rsp,%rbp
  804695:	48 83 ec 20          	sub    $0x20,%rsp
  804699:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80469c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80469f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8046a2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8046a6:	be 01 00 00 00       	mov    $0x1,%esi
  8046ab:	48 89 c7             	mov    %rax,%rdi
  8046ae:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  8046b5:	00 00 00 
  8046b8:	ff d0                	callq  *%rax
}
  8046ba:	c9                   	leaveq 
  8046bb:	c3                   	retq   

00000000008046bc <getchar>:

int
getchar(void)
{
  8046bc:	55                   	push   %rbp
  8046bd:	48 89 e5             	mov    %rsp,%rbp
  8046c0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8046c4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8046c8:	ba 01 00 00 00       	mov    $0x1,%edx
  8046cd:	48 89 c6             	mov    %rax,%rsi
  8046d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8046d5:	48 b8 7c 22 80 00 00 	movabs $0x80227c,%rax
  8046dc:	00 00 00 
  8046df:	ff d0                	callq  *%rax
  8046e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8046e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046e8:	79 05                	jns    8046ef <getchar+0x33>
		return r;
  8046ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ed:	eb 14                	jmp    804703 <getchar+0x47>
	if (r < 1)
  8046ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046f3:	7f 07                	jg     8046fc <getchar+0x40>
		return -E_EOF;
  8046f5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8046fa:	eb 07                	jmp    804703 <getchar+0x47>
	return c;
  8046fc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804700:	0f b6 c0             	movzbl %al,%eax
}
  804703:	c9                   	leaveq 
  804704:	c3                   	retq   

0000000000804705 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804705:	55                   	push   %rbp
  804706:	48 89 e5             	mov    %rsp,%rbp
  804709:	48 83 ec 20          	sub    $0x20,%rsp
  80470d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804710:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804714:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804717:	48 89 d6             	mov    %rdx,%rsi
  80471a:	89 c7                	mov    %eax,%edi
  80471c:	48 b8 4a 1e 80 00 00 	movabs $0x801e4a,%rax
  804723:	00 00 00 
  804726:	ff d0                	callq  *%rax
  804728:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80472b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472f:	79 05                	jns    804736 <iscons+0x31>
		return r;
  804731:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804734:	eb 1a                	jmp    804750 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80473a:	8b 10                	mov    (%rax),%edx
  80473c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804743:	00 00 00 
  804746:	8b 00                	mov    (%rax),%eax
  804748:	39 c2                	cmp    %eax,%edx
  80474a:	0f 94 c0             	sete   %al
  80474d:	0f b6 c0             	movzbl %al,%eax
}
  804750:	c9                   	leaveq 
  804751:	c3                   	retq   

0000000000804752 <opencons>:

int
opencons(void)
{
  804752:	55                   	push   %rbp
  804753:	48 89 e5             	mov    %rsp,%rbp
  804756:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80475a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80475e:	48 89 c7             	mov    %rax,%rdi
  804761:	48 b8 b2 1d 80 00 00 	movabs $0x801db2,%rax
  804768:	00 00 00 
  80476b:	ff d0                	callq  *%rax
  80476d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804770:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804774:	79 05                	jns    80477b <opencons+0x29>
		return r;
  804776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804779:	eb 5b                	jmp    8047d6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80477b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80477f:	ba 07 04 00 00       	mov    $0x407,%edx
  804784:	48 89 c6             	mov    %rax,%rsi
  804787:	bf 00 00 00 00       	mov    $0x0,%edi
  80478c:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  804793:	00 00 00 
  804796:	ff d0                	callq  *%rax
  804798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80479b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479f:	79 05                	jns    8047a6 <opencons+0x54>
		return r;
  8047a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a4:	eb 30                	jmp    8047d6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8047a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047aa:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8047b1:	00 00 00 
  8047b4:	8b 12                	mov    (%rdx),%edx
  8047b6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8047b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8047c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047c7:	48 89 c7             	mov    %rax,%rdi
  8047ca:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8047d1:	00 00 00 
  8047d4:	ff d0                	callq  *%rax
}
  8047d6:	c9                   	leaveq 
  8047d7:	c3                   	retq   

00000000008047d8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8047d8:	55                   	push   %rbp
  8047d9:	48 89 e5             	mov    %rsp,%rbp
  8047dc:	48 83 ec 30          	sub    $0x30,%rsp
  8047e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8047ec:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047f1:	75 07                	jne    8047fa <devcons_read+0x22>
		return 0;
  8047f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8047f8:	eb 4b                	jmp    804845 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8047fa:	eb 0c                	jmp    804808 <devcons_read+0x30>
		sys_yield();
  8047fc:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804803:	00 00 00 
  804806:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804808:	48 b8 2f 19 80 00 00 	movabs $0x80192f,%rax
  80480f:	00 00 00 
  804812:	ff d0                	callq  *%rax
  804814:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804817:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80481b:	74 df                	je     8047fc <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80481d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804821:	79 05                	jns    804828 <devcons_read+0x50>
		return c;
  804823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804826:	eb 1d                	jmp    804845 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804828:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80482c:	75 07                	jne    804835 <devcons_read+0x5d>
		return 0;
  80482e:	b8 00 00 00 00       	mov    $0x0,%eax
  804833:	eb 10                	jmp    804845 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804835:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804838:	89 c2                	mov    %eax,%edx
  80483a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80483e:	88 10                	mov    %dl,(%rax)
	return 1;
  804840:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804845:	c9                   	leaveq 
  804846:	c3                   	retq   

0000000000804847 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804847:	55                   	push   %rbp
  804848:	48 89 e5             	mov    %rsp,%rbp
  80484b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804852:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804859:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804860:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804867:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80486e:	eb 76                	jmp    8048e6 <devcons_write+0x9f>
		m = n - tot;
  804870:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804877:	89 c2                	mov    %eax,%edx
  804879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80487c:	29 c2                	sub    %eax,%edx
  80487e:	89 d0                	mov    %edx,%eax
  804880:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804883:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804886:	83 f8 7f             	cmp    $0x7f,%eax
  804889:	76 07                	jbe    804892 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80488b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804892:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804895:	48 63 d0             	movslq %eax,%rdx
  804898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489b:	48 63 c8             	movslq %eax,%rcx
  80489e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8048a5:	48 01 c1             	add    %rax,%rcx
  8048a8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048af:	48 89 ce             	mov    %rcx,%rsi
  8048b2:	48 89 c7             	mov    %rax,%rdi
  8048b5:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  8048bc:	00 00 00 
  8048bf:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8048c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048c4:	48 63 d0             	movslq %eax,%rdx
  8048c7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8048ce:	48 89 d6             	mov    %rdx,%rsi
  8048d1:	48 89 c7             	mov    %rax,%rdi
  8048d4:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  8048db:	00 00 00 
  8048de:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8048e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048e3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8048e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048e9:	48 98                	cltq   
  8048eb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8048f2:	0f 82 78 ff ff ff    	jb     804870 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8048f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8048fb:	c9                   	leaveq 
  8048fc:	c3                   	retq   

00000000008048fd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8048fd:	55                   	push   %rbp
  8048fe:	48 89 e5             	mov    %rsp,%rbp
  804901:	48 83 ec 08          	sub    $0x8,%rsp
  804905:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804909:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80490e:	c9                   	leaveq 
  80490f:	c3                   	retq   

0000000000804910 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804910:	55                   	push   %rbp
  804911:	48 89 e5             	mov    %rsp,%rbp
  804914:	48 83 ec 10          	sub    $0x10,%rsp
  804918:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80491c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804924:	48 be 0a 54 80 00 00 	movabs $0x80540a,%rsi
  80492b:	00 00 00 
  80492e:	48 89 c7             	mov    %rax,%rdi
  804931:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  804938:	00 00 00 
  80493b:	ff d0                	callq  *%rax
	return 0;
  80493d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804942:	c9                   	leaveq 
  804943:	c3                   	retq   

0000000000804944 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804944:	55                   	push   %rbp
  804945:	48 89 e5             	mov    %rsp,%rbp
  804948:	48 83 ec 30          	sub    $0x30,%rsp
  80494c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804950:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804954:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  804958:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80495f:	00 00 00 
  804962:	48 8b 00             	mov    (%rax),%rax
  804965:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80496b:	85 c0                	test   %eax,%eax
  80496d:	75 3c                	jne    8049ab <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80496f:	48 b8 b1 19 80 00 00 	movabs $0x8019b1,%rax
  804976:	00 00 00 
  804979:	ff d0                	callq  *%rax
  80497b:	25 ff 03 00 00       	and    $0x3ff,%eax
  804980:	48 63 d0             	movslq %eax,%rdx
  804983:	48 89 d0             	mov    %rdx,%rax
  804986:	48 c1 e0 03          	shl    $0x3,%rax
  80498a:	48 01 d0             	add    %rdx,%rax
  80498d:	48 c1 e0 05          	shl    $0x5,%rax
  804991:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804998:	00 00 00 
  80499b:	48 01 c2             	add    %rax,%rdx
  80499e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049a5:	00 00 00 
  8049a8:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8049ab:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8049b0:	75 0e                	jne    8049c0 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8049b2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8049b9:	00 00 00 
  8049bc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8049c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049c4:	48 89 c7             	mov    %rax,%rdi
  8049c7:	48 b8 56 1c 80 00 00 	movabs $0x801c56,%rax
  8049ce:	00 00 00 
  8049d1:	ff d0                	callq  *%rax
  8049d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8049d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049da:	79 19                	jns    8049f5 <ipc_recv+0xb1>
		*from_env_store = 0;
  8049dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8049e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8049f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049f3:	eb 53                	jmp    804a48 <ipc_recv+0x104>
	}
	if(from_env_store)
  8049f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8049fa:	74 19                	je     804a15 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8049fc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a03:	00 00 00 
  804a06:	48 8b 00             	mov    (%rax),%rax
  804a09:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a13:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804a15:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a1a:	74 19                	je     804a35 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  804a1c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a23:	00 00 00 
  804a26:	48 8b 00             	mov    (%rax),%rax
  804a29:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a33:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804a35:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804a3c:	00 00 00 
  804a3f:	48 8b 00             	mov    (%rax),%rax
  804a42:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804a48:	c9                   	leaveq 
  804a49:	c3                   	retq   

0000000000804a4a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a4a:	55                   	push   %rbp
  804a4b:	48 89 e5             	mov    %rsp,%rbp
  804a4e:	48 83 ec 30          	sub    $0x30,%rsp
  804a52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a55:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804a58:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804a5c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804a5f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a64:	75 0e                	jne    804a74 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804a66:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a6d:	00 00 00 
  804a70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804a74:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a77:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804a7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a81:	89 c7                	mov    %eax,%edi
  804a83:	48 b8 01 1c 80 00 00 	movabs $0x801c01,%rax
  804a8a:	00 00 00 
  804a8d:	ff d0                	callq  *%rax
  804a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804a92:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a96:	75 0c                	jne    804aa4 <ipc_send+0x5a>
			sys_yield();
  804a98:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804a9f:	00 00 00 
  804aa2:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804aa4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804aa8:	74 ca                	je     804a74 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804aaa:	c9                   	leaveq 
  804aab:	c3                   	retq   

0000000000804aac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804aac:	55                   	push   %rbp
  804aad:	48 89 e5             	mov    %rsp,%rbp
  804ab0:	48 83 ec 14          	sub    $0x14,%rsp
  804ab4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804ab7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804abe:	eb 5e                	jmp    804b1e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804ac0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804ac7:	00 00 00 
  804aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804acd:	48 63 d0             	movslq %eax,%rdx
  804ad0:	48 89 d0             	mov    %rdx,%rax
  804ad3:	48 c1 e0 03          	shl    $0x3,%rax
  804ad7:	48 01 d0             	add    %rdx,%rax
  804ada:	48 c1 e0 05          	shl    $0x5,%rax
  804ade:	48 01 c8             	add    %rcx,%rax
  804ae1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ae7:	8b 00                	mov    (%rax),%eax
  804ae9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804aec:	75 2c                	jne    804b1a <ipc_find_env+0x6e>
			return envs[i].env_id;
  804aee:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804af5:	00 00 00 
  804af8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804afb:	48 63 d0             	movslq %eax,%rdx
  804afe:	48 89 d0             	mov    %rdx,%rax
  804b01:	48 c1 e0 03          	shl    $0x3,%rax
  804b05:	48 01 d0             	add    %rdx,%rax
  804b08:	48 c1 e0 05          	shl    $0x5,%rax
  804b0c:	48 01 c8             	add    %rcx,%rax
  804b0f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804b15:	8b 40 08             	mov    0x8(%rax),%eax
  804b18:	eb 12                	jmp    804b2c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804b1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804b1e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804b25:	7e 99                	jle    804ac0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804b27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b2c:	c9                   	leaveq 
  804b2d:	c3                   	retq   

0000000000804b2e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804b2e:	55                   	push   %rbp
  804b2f:	48 89 e5             	mov    %rsp,%rbp
  804b32:	48 83 ec 18          	sub    $0x18,%rsp
  804b36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b3e:	48 c1 e8 15          	shr    $0x15,%rax
  804b42:	48 89 c2             	mov    %rax,%rdx
  804b45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b4c:	01 00 00 
  804b4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b53:	83 e0 01             	and    $0x1,%eax
  804b56:	48 85 c0             	test   %rax,%rax
  804b59:	75 07                	jne    804b62 <pageref+0x34>
		return 0;
  804b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b60:	eb 53                	jmp    804bb5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b66:	48 c1 e8 0c          	shr    $0xc,%rax
  804b6a:	48 89 c2             	mov    %rax,%rdx
  804b6d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b74:	01 00 00 
  804b77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b83:	83 e0 01             	and    $0x1,%eax
  804b86:	48 85 c0             	test   %rax,%rax
  804b89:	75 07                	jne    804b92 <pageref+0x64>
		return 0;
  804b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  804b90:	eb 23                	jmp    804bb5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804b92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b96:	48 c1 e8 0c          	shr    $0xc,%rax
  804b9a:	48 89 c2             	mov    %rax,%rdx
  804b9d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ba4:	00 00 00 
  804ba7:	48 c1 e2 04          	shl    $0x4,%rdx
  804bab:	48 01 d0             	add    %rdx,%rax
  804bae:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804bb2:	0f b7 c0             	movzwl %ax,%eax
}
  804bb5:	c9                   	leaveq 
  804bb6:	c3                   	retq   
